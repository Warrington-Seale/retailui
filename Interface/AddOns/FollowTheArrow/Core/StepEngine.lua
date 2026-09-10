local _, FTA = ...

FTA.StepEngine = {}

local function NormalizeManualSegKey(seg, segIndex)
  if type(seg) == "table" and type(seg.key) == "string" and seg.key ~= "" then
    return seg.key
  end
  if type(segIndex) == "number" and segIndex >= 1 then
    return "SEG:" .. tostring(math.floor(segIndex))
  end
  return nil
end

function FTA.StepEngine:EnsureDB()
  FTACharDB = FTACharDB or {}
  FTACharDB.progress = FTACharDB.progress or {}
  FTACharDB.progress.stepIndexByModule = FTACharDB.progress.stepIndexByModule or {}

  FTACharDB.progress.autoAdvanceModules = (FTACharDB.progress.autoAdvanceModules == true)

  FTACharDB.progress.isBrowsingByModule = FTACharDB.progress.isBrowsingByModule or {}
  FTACharDB.progress.manualSegmentState = FTACharDB.progress.manualSegmentState or {}
end

function FTA.StepEngine:EnsureRuntimeState()
  self._observedStepStateByModule = self._observedStepStateByModule or {}
  return self._observedStepStateByModule
end

function FTA.StepEngine:GetActiveModuleId()
  self:EnsureDB()
  return FTACharDB.progress.activeModuleId
end

function FTA.StepEngine:GetModule(moduleId)
  return FTA.Modules and FTA.Modules[moduleId]
end

function FTA.StepEngine:GetActiveRouteId()
  self:EnsureDB()
  return FTACharDB.progress.activeRouteId
end

function FTA.StepEngine:EnsureManualStateDB()
  self:EnsureDB()
  FTACharDB.progress.manualSegmentState = FTACharDB.progress.manualSegmentState or {}
  return FTACharDB.progress.manualSegmentState
end

function FTA.StepEngine:GetManualSegmentStorageKey(moduleId, stepIndex, seg, segIndex)
  if type(moduleId) ~= "string" or moduleId == "" then return nil end
  stepIndex = tonumber(stepIndex)
  if not stepIndex or stepIndex < 1 then return nil end

  local segKey = NormalizeManualSegKey(seg, segIndex)
  if not segKey then return nil end

  return moduleId .. ":" .. tostring(math.floor(stepIndex)) .. ":" .. segKey
end

function FTA.StepEngine:IsManualSegmentComplete(moduleId, stepIndex, seg, segIndex)
  local key = self:GetManualSegmentStorageKey(moduleId, stepIndex, seg, segIndex)
  if not key then return false end
  local db = self:EnsureManualStateDB()
  return db[key] == true
end

function FTA.StepEngine:SetManualSegmentComplete(moduleId, stepIndex, seg, value, segIndex)
  local key = self:GetManualSegmentStorageKey(moduleId, stepIndex, seg, segIndex)
  if not key then return false end

  local db = self:EnsureManualStateDB()
  if value == true then
    db[key] = true
  else
    db[key] = nil
  end

  return true
end

function FTA.StepEngine:ToggleManualSegmentComplete(moduleId, stepIndex, seg, segIndex)
  local newValue = not self:IsManualSegmentComplete(moduleId, stepIndex, seg, segIndex)
  self:SetManualSegmentComplete(moduleId, stepIndex, seg, newValue, segIndex)
  return newValue
end

function FTA.StepEngine:ResetAllManualSegments()
  self:EnsureDB()
  FTACharDB.progress.manualSegmentState = {}
end

function FTA:SetAllManualSegmentsIncomplete()
  if self.StepEngine and self.StepEngine.ResetAllManualSegments then
    self.StepEngine:ResetAllManualSegments()
  end

  if self.FullRefresh then
    self:FullRefresh("RESET_ALL_MANUAL_SEGMENTS")
  elseif self.UI and self.UI.Refresh then
    self.UI:Refresh()
  end
end

function FTA.StepEngine:SetActiveRoute(routeId)
  self:EnsureDB()
  if type(routeId) ~= "string" or routeId == "" then return false end

  local exists = false
  local routes = self:GetRouteList()
  for _, r in ipairs(routes) do
    if r.id == routeId then
      exists = true
      break
    end
  end
  if not exists then return false end

  FTACharDB.progress.activeRouteId = routeId

  local mods = self:GetModulesForRoute(routeId)
  if type(mods) ~= "table" or #mods < 1 then
    return true
  end

  local chosenId = nil
  for _, item in ipairs(mods) do
    if item and item.id and not self:IsModuleComplete(item.id) then
      chosenId = item.id
      break
    end
  end
  if not chosenId then
    chosenId = mods[1].id
  end

  FTACharDB.progress.activeModuleId = chosenId
  FTACharDB.progress.stepIndexByModule[chosenId] = FTACharDB.progress.stepIndexByModule[chosenId] or 1
  FTACharDB.progress.isBrowsingByModule[chosenId] = false

  self:OnStepChanged()
  self:CaptureObservedStepState(chosenId)
  return true
end

local function GetRouteMetaFromModule(moduleId, mod)
  local rid = (mod and mod.routeId) or "UNGROUPED"
  local title = (mod and mod.routeTitle) or (rid == "UNGROUPED" and "Other" or rid)
  local order = (mod and mod.routeOrder) or 9999
  return rid, title, order
end

function FTA.StepEngine:GetRouteList()
  if not FTA.Modules then return {} end

  local byId = {}
  for id, m in pairs(FTA.Modules) do
    local rid, title, order = GetRouteMetaFromModule(id, m)
    if not byId[rid] then
      byId[rid] = { id = rid, title = title, order = order }
    else
      if byId[rid].title == rid and title ~= rid then
        byId[rid].title = title
      end
      if type(order) == "number" and order < (byId[rid].order or 9999) then
        byId[rid].order = order
      end
    end
  end

  local list = {}
  for _, r in pairs(byId) do
    list[#list + 1] = r
  end

  table.sort(list, function(a, b)
    if (a.order or 9999) ~= (b.order or 9999) then
      return (a.order or 9999) < (b.order or 9999)
    end
    if a.title ~= b.title then return a.title < b.title end
    return a.id < b.id
  end)

  return list
end

function FTA.StepEngine:GetModulesForRoute(routeId)
  if not FTA.Modules then return {} end
  if type(routeId) ~= "string" or routeId == "" then routeId = "UNGROUPED" end

  local list = {}
  for id, m in pairs(FTA.Modules) do
    local rid = (m and m.routeId) or "UNGROUPED"
    if rid == routeId then
      list[#list + 1] = {
        id = id,
        title = (m and m.title) or id,
        order = (m and m.moduleOrder) or (m and m.order) or 9999,
      }
    end
  end

  table.sort(list, function(a, b)
    if a.order ~= b.order then return a.order < b.order end
    if a.title ~= b.title then return a.title < b.title end
    return a.id < b.id
  end)

  return list
end

function FTA.StepEngine:GetModuleList()
  if not FTA.Modules then return {} end

  local list = {}
  for id, m in pairs(FTA.Modules) do
    list[#list + 1] = {
      id = id,
      title = (m and m.title) or id,
      order = (m and m.order) or 9999,
    }
  end

  table.sort(list, function(a, b)
    if a.order ~= b.order then
      return a.order < b.order
    end
    if a.title ~= b.title then
      return a.title < b.title
    end
    return a.id < b.id
  end)

  return list
end

function FTA.StepEngine:GetStepIndex(moduleId)
  self:EnsureDB()
  local idx = FTACharDB.progress.stepIndexByModule[moduleId]
  if not idx or idx < 1 then idx = 1 end
  return idx
end

function FTA.StepEngine:SetStepIndex(moduleId, idx)
  self:EnsureDB()
  if idx < 1 then idx = 1 end
  FTACharDB.progress.stepIndexByModule[moduleId] = idx
end

function FTA.StepEngine:GetCurrentStep()
  self:EnsureDB()

  local moduleId = self:GetActiveModuleId()
  local mod = self:GetModule(moduleId)

  if not mod then
    return nil
  end

  local idx = self:GetStepIndex(moduleId)
  return mod, idx, (mod.steps or {})[idx]
end

function FTA.StepEngine:ClampIndex(moduleId, idx)
  local mod = self:GetModule(moduleId)
  if not mod then return 1 end
  local n = #(mod.steps or {})
  if n < 1 then return 1 end
  if idx < 1 then return 1 end
  if idx > n then return n end
  return idx
end

local function FindFirstActionableStepIndex(moduleId, mod)
  if not (FTA.Resolve and FTA.Resolve.GetActiveSegment) then return 1 end
  if type(moduleId) ~= "string" or moduleId == "" then return 1 end
  if type(mod) ~= "table" or type(mod.steps) ~= "table" then return 1 end

  for i, step in ipairs(mod.steps) do
    local _, seg = FTA.Resolve:GetActiveSegment(mod, step, moduleId, i)
    if seg then
      return i
    end
  end

  return 1
end

local function FindFirstUnsatisfiedStepIndex(moduleId, mod)
  if not (FTA.Resolve and FTA.Resolve.IsStepSatisfied) then return 1 end
  if type(moduleId) ~= "string" or moduleId == "" then return 1 end
  if type(mod) ~= "table" or type(mod.steps) ~= "table" then return 1 end

  for i, step in ipairs(mod.steps) do
    if not FTA.Resolve:IsStepSatisfied(step, moduleId, i) then
      return i
    end
  end

  local n = #mod.steps
  if n < 1 then return 1 end
  return n
end

function FTA.StepEngine:IsBrowsing(moduleId)
  self:EnsureDB()
  return FTACharDB.progress.isBrowsingByModule[moduleId] == true
end

function FTA.StepEngine:SetBrowsing(moduleId, v)
  self:EnsureDB()
  if type(moduleId) ~= "string" or moduleId == "" then return end
  FTACharDB.progress.isBrowsingByModule[moduleId] = (v == true)
end

function FTA.StepEngine:IsStepSatisfiedAt(moduleId, idx)
  local mod = self:GetModule(moduleId)
  if not mod or type(mod.steps) ~= "table" then return false end
  local step = mod.steps[idx]
  if not step then return false end
  if not (FTA.Resolve and FTA.Resolve.IsStepSatisfied) then return false end
  return FTA.Resolve:IsStepSatisfied(step, moduleId, idx) == true
end

function FTA.StepEngine:CaptureObservedStepState(moduleId)
  if type(moduleId) ~= "string" or moduleId == "" then return end
  local state = self:EnsureRuntimeState()
  local idx = self:GetStepIndex(moduleId)
  state[moduleId] = {
    idx = idx,
    complete = self:IsStepSatisfiedAt(moduleId, idx),
  }
end

function FTA.StepEngine:CurrentStepJustCompleted(moduleId)
  if type(moduleId) ~= "string" or moduleId == "" then return false end
  local state = self:EnsureRuntimeState()
  local prev = state[moduleId]
  local idx = self:GetStepIndex(moduleId)
  local complete = self:IsStepSatisfiedAt(moduleId, idx)

  if not prev then
    return false
  end

  return prev.idx == idx and prev.complete == false and complete == true
end

function FTA.StepEngine:UpdateBrowsingState(moduleId)
  self:EnsureDB()
  if type(moduleId) ~= "string" or moduleId == "" then return end
  local mod = self:GetModule(moduleId)
  if not mod then return end

  local idx = self:GetStepIndex(moduleId)
  local cur = FindFirstUnsatisfiedStepIndex(moduleId, mod)

  if idx == cur then
    self:SetBrowsing(moduleId, false)
  else
    self:SetBrowsing(moduleId, true)
  end
end

function FTA.StepEngine:SetActiveModule(moduleId)
  self:EnsureDB()

  if not (FTA.Modules and FTA.Modules[moduleId]) then
    return false
  end

  local mod = FTA.Modules[moduleId]

  FTACharDB.progress.activeModuleId = moduleId

  if FTACharDB.progress.stepIndexByModule[moduleId] == nil then
    FTACharDB.progress.stepIndexByModule[moduleId] = FindFirstActionableStepIndex(moduleId, mod)
  end

  FTACharDB.progress.isBrowsingByModule[moduleId] = false

  local routeId = (mod and mod.routeId) or "UNGROUPED"
  FTACharDB.progress.activeRouteId = routeId

  self:OnStepChanged()
  self:CaptureObservedStepState(moduleId)
  return true
end

function FTA.StepEngine:NextStep()
  self:EnsureDB()

  local moduleId = self:GetActiveModuleId()
  if not moduleId then
    return
  end

  local idx = self:GetStepIndex(moduleId)
  idx = self:ClampIndex(moduleId, idx + 1)
  self:SetStepIndex(moduleId, idx)
  self:UpdateBrowsingState(moduleId)
  self:CaptureObservedStepState(moduleId)

  if FTA.UI and FTA.UI.Refresh then
    FTA.UI:Refresh()
  end
end

function FTA.StepEngine:PrevStep()
  self:EnsureDB()

  local moduleId = self:GetActiveModuleId()
  if not moduleId then
    return
  end

  local idx = self:GetStepIndex(moduleId)
  idx = self:ClampIndex(moduleId, idx - 1)
  self:SetStepIndex(moduleId, idx)
  self:UpdateBrowsingState(moduleId)
  self:CaptureObservedStepState(moduleId)

  if FTA.UI and FTA.UI.Refresh then
    FTA.UI:Refresh()
  end
end

function FTA.StepEngine:IsModuleComplete(moduleId)
  local mod = self:GetModule(moduleId)
  if not mod or type(mod.steps) ~= "table" then return false end
  if not (FTA.Resolve and FTA.Resolve.IsStepSatisfied) then return false end

  for stepIndex, step in ipairs(mod.steps) do
    if not FTA.Resolve:IsStepSatisfied(step, moduleId, stepIndex) then
      return false
    end
  end
  return true
end

function FTA.StepEngine:GetNextModuleId(moduleId)
  local mod = self:GetModule(moduleId)
  if not mod then return nil end

  if type(mod.nextModuleId) == "string" and mod.nextModuleId ~= "" then
    if FTA.Modules and FTA.Modules[mod.nextModuleId] then
      return mod.nextModuleId
    end
  end

  local routeId = (mod and mod.routeId) or "UNGROUPED"
  local list = self:GetModulesForRoute(routeId)

  local found = false
  for _, item in ipairs(list) do
    if found then
      return item.id
    end
    if item.id == moduleId then
      found = true
    end
  end

  return nil
end

function FTA.StepEngine:AutoAdvanceModuleIfComplete(moduleId)
  if type(moduleId) ~= "string" or moduleId == "" then return false end
  if not self:IsModuleComplete(moduleId) then return false end

  local nextId = self:GetNextModuleId(moduleId)
  if not nextId then return false end

  local safety = 0
  while nextId and safety < 25 do
    safety = safety + 1
    if not self:IsModuleComplete(nextId) then
      break
    end
    nextId = self:GetNextModuleId(nextId)
  end

  if not nextId then return false end
  if self:IsModuleComplete(nextId) then return false end

  self:SetActiveModule(nextId)
  if self.SyncForward then
    self:SyncForward(true)
  end
  return true
end

function FTA.StepEngine:OnStepChanged()
  if self.SyncForward then
    self:SyncForward(false)
  end

  if FTA.UI and FTA.UI.Refresh then
    FTA.UI:Refresh()
  end
end

function FTA.StepEngine:SyncForward(force)
  self:EnsureDB()

  local moduleId = self:GetActiveModuleId()
  if not moduleId then return end

  if force ~= true and self:IsBrowsing(moduleId) and not self:CurrentStepJustCompleted(moduleId) then
    self:CaptureObservedStepState(moduleId)
    return
  end

  local mod = self:GetModule(moduleId)
  if not mod or type(mod.steps) ~= "table" then return end

  local idx = self:GetStepIndex(moduleId)
  local n = #mod.steps
  if n < 1 then return end

  local advancedPastEnd = false
  while idx <= n do
    local step = mod.steps[idx]
    if not (FTA.Resolve and FTA.Resolve.IsStepSatisfied) then break end
    if not FTA.Resolve:IsStepSatisfied(step, moduleId, idx) then break end
    idx = idx + 1
  end

  if idx > n then
    advancedPastEnd = true
    idx = n
  end

  idx = self:ClampIndex(moduleId, idx)
  self:SetStepIndex(moduleId, idx)
  self:UpdateBrowsingState(moduleId)
  self:CaptureObservedStepState(moduleId)

  if advancedPastEnd and FTACharDB
      and FTACharDB.progress
      and FTACharDB.progress.autoAdvanceModules == true
  then
    self:AutoAdvanceModuleIfComplete(moduleId)
  end
end

function FTA.StepEngine:EnsureChainDB()
  self:EnsureDB()
  FTACharDB.progress.chainIndex = FTACharDB.progress.chainIndex or {}
  return FTACharDB.progress.chainIndex
end

function FTA.StepEngine:GetChainIndex(key)
  if type(key) ~= "string" or key == "" then return 1 end
  local db = self:EnsureChainDB()
  local v = db[key]
  if type(v) ~= "number" or v < 1 then return 1 end
  return math.floor(v)
end

function FTA.StepEngine:SetChainIndex(key, idx)
  if type(key) ~= "string" or key == "" then return end
  local db = self:EnsureChainDB()
  idx = tonumber(idx) or 1
  if idx < 1 then idx = 1 end
  db[key] = math.floor(idx)
end

function FTA.StepEngine:AdvanceChainIndex(key, delta)
  if type(key) ~= "string" or key == "" then return end
  delta = tonumber(delta) or 1
  if delta == 0 then return end

  local cur = self:GetChainIndex(key)
  local nxt = cur + math.floor(delta)

  if nxt < 1 then nxt = 1 end
  self:SetChainIndex(key, nxt)
end

function FTA.StepEngine:ResetChainIndex(key)
  if type(key) ~= "string" or key == "" then return end
  local db = self:EnsureChainDB()
  db[key] = nil
end

local function ChainQuestIDSet(questIDs)
  local set = {}
  if type(questIDs) == "number" then
    if questIDs > 0 then set[questIDs] = true end
  elseif type(questIDs) == "table" then
    for _, qid in ipairs(questIDs) do
      if type(qid) == "number" and qid > 0 then
        set[qid] = true
      end
    end
  end
  return set
end

local function ChainQuestIDsOverlap(a, b)
  local A = ChainQuestIDSet(a)
  if type(b) == "number" then
    return A[b] == true
  elseif type(b) == "table" then
    for _, qid in ipairs(b) do
      if A[qid] then return true end
    end
  end
  return false
end

local function SequenceChainReferencesQuest(seq, questIDs)
  if type(seq) ~= "table" or seq.mode ~= "SEQUENCE_CHAIN" then return false end
  if type(seq.nodes) ~= "table" then return false end

  for _, node in ipairs(seq.nodes) do
    if type(node) == "table" then
      local qids = node.questIDs or node.questID
      if qids and ChainQuestIDsOverlap(questIDs, qids) then
        return true
      end

      if type(node.gate) == "table" then
        qids = node.gate.questIDs or node.gate.questID
        if qids and ChainQuestIDsOverlap(questIDs, qids) then
          return true
        end
      end
    end
  end

  return false
end

function FTA.StepEngine:ResetActiveSequenceChainsForQuest(questIDs)
  if not questIDs then return 0 end

  local _, _, step = self:GetCurrentStep()
  if type(step) ~= "table" then return 0 end

  local resetCount = 0

  if type(step.arrow) == "table"
    and step.arrow.mode == "SEQUENCE_CHAIN"
    and SequenceChainReferencesQuest(step.arrow, questIDs)
  then
    local key = step.arrow.key or "STEPSEQ:DEFAULT"
    self:ResetChainIndex(key)
    resetCount = resetCount + 1
  end

  if type(step.segments) == "table" then
    for segIndex, seg in ipairs(step.segments) do
      if type(seg) == "table"
        and type(seg.arrow) == "table"
        and seg.arrow.mode == "SEQUENCE_CHAIN"
        and SequenceChainReferencesQuest(seg.arrow, questIDs)
      then
        local key = seg.arrow.key or ("SEGSEQ:" .. tostring(segIndex))
        self:ResetChainIndex(key)
        resetCount = resetCount + 1
      end
    end
  end

  return resetCount
end

function FTA.StepEngine:SyncNow(maxPasses)
  self:EnsureDB()

  local moduleId = self:GetActiveModuleId()
  if not moduleId then
    return
  end

  maxPasses = tonumber(maxPasses) or 25
  if maxPasses < 1 then maxPasses = 1 end
  if maxPasses > 50 then maxPasses = 50 end

  local lastIdx = self:GetStepIndex(moduleId)

  for _ = 1, maxPasses do
    self:SyncForward(true)
    local newIdx = self:GetStepIndex(moduleId)
    if newIdx == lastIdx then
      break
    end
    lastIdx = newIdx
  end

  self:SetBrowsing(moduleId, false)
  self:CaptureObservedStepState(moduleId)

  if FTA.UI and FTA.UI.Refresh then
    FTA.UI:Refresh()
  end
end

function FTA.StepEngine:ForceResync(maxPasses)
  self:SyncNow(maxPasses)
end

function FTA:StepEngine_Init()
  if FTA.StepEngine and FTA.StepEngine.EnsureDB then
    FTA.StepEngine:EnsureDB()
    FTA.StepEngine:EnsureRuntimeState()
  end
end

function FTA:CanSelectModule(moduleId)
  if type(moduleId) ~= "string" or moduleId == "" then
    return false, "Invalid module id."
  end
  if not (FTA.Modules and FTA.Modules[moduleId]) then
    return false, ("Unknown module id: %s"):format(tostring(moduleId))
  end
  return true
end

function FTA:SelectModule(moduleId, opts)
  local ok, err = self:CanSelectModule(moduleId)
  if not ok then
    if self.Print then self:Print(err) end
    return false
  end

  opts = (type(opts) == "table") and opts or nil

  if self.StepEngine and self.StepEngine.EnsureDB then
    self.StepEngine:EnsureDB()
  end

  if opts and opts.resetStep == true then
    if FTACharDB and FTACharDB.progress and FTACharDB.progress.stepIndexByModule then
      FTACharDB.progress.stepIndexByModule[moduleId] = nil
    end
    if FTACharDB and FTACharDB.progress and FTACharDB.progress.isBrowsingByModule then
      FTACharDB.progress.isBrowsingByModule[moduleId] = false
    end
  end

  if self.StepEngine and self.StepEngine.SetActiveModule then
    return self.StepEngine:SetActiveModule(moduleId) == true
  end

  return false
end

function FTA:SelectRoute(routeId)
  if self.StepEngine and self.StepEngine.SetActiveRoute then
    return self.StepEngine:SetActiveRoute(routeId) == true
  end
  return false
end
