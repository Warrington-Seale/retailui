local _, FTA = ...

FTA.Resolve = FTA.Resolve or {}

local DEFAULT_RADIUS = 5

local PlayerProjectsDirectlyToMap

local function asMapIDList(v)
  if type(v) == "number" then
    return (v > 0) and { v } or {}
  elseif type(v) == "table" then
    local out = {}
    for _, id in ipairs(v) do
      if type(id) == "number" and id > 0 then
        out[#out + 1] = id
      end
    end
    return out
  end
  return {}
end

local function segMapIDs(step, seg)
  local v = (seg and seg.mapID ~= nil) and seg.mapID or (step and step.mapID)
  return asMapIDList(v)
end

local function segRadius(mod, step, seg)
  return seg.radius or step.radius or (mod and mod.defaultRadius) or DEFAULT_RADIUS
end

local function coordXY(seg)
  if not (FTA.Quest and FTA.Quest.NormalizeCoord) then
    return seg.x, seg.y
  end
  local x = FTA.Quest:NormalizeCoord(seg.x)
  local y = FTA.Quest:NormalizeCoord(seg.y)
  return x, y
end

local function GetBestPlayerMapID()
  return (C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")) or nil
end

local function SharesAncestor(a, b)
  if type(a) ~= "number" or a <= 0 then return false end
  if type(b) ~= "number" or b <= 0 then return false end
  if a == b then return true end
  if not (C_Map and C_Map.GetMapInfo) then return false end

  local ancestorsA = {}
  local cur = a
  local safety = 0
  while cur and safety < 50 do
    safety = safety + 1
    ancestorsA[cur] = true
    local info = C_Map.GetMapInfo(cur)
    local parent = info and info.parentMapID
    if not parent or parent <= 0 then break end
    cur = parent
  end

  cur = b
  safety = 0
  while cur and safety < 50 do
    safety = safety + 1
    if ancestorsA[cur] then
      return true
    end
    local info = C_Map.GetMapInfo(cur)
    local parent = info and info.parentMapID
    if not parent or parent <= 0 then break end
    cur = parent
  end

  return false
end

local function IsMapRelated(a, b)
  if type(a) ~= "number" or a <= 0 then return false end
  if type(b) ~= "number" or b <= 0 then return false end
  if a == b then return true end
  if not C_Map then return false end

  if C_Map.IsChildMap then
    if C_Map.IsChildMap(a, b) then return true end
    if C_Map.IsChildMap(b, a) then return true end
  end

  if C_Map.GetMapInfo then
    local cur = b
    local safety = 0
    while cur and safety < 50 do
      safety = safety + 1
      local info = C_Map.GetMapInfo(cur)
      local parent = info and info.parentMapID
      if not parent or parent <= 0 then break end
      if parent == a then return true end
      cur = parent
    end

    cur = a
    safety = 0
    while cur and safety < 50 do
      safety = safety + 1
      local info = C_Map.GetMapInfo(cur)
      local parent = info and info.parentMapID
      if not parent or parent <= 0 then break end
      if parent == b then return true end
      cur = parent
    end
  end

  return false
end

local function PlayerHasPositionOnMap(mapID)
  if type(mapID) ~= "number" or mapID <= 0 then return false end
  if not C_Map then return false end

  if C_Map.GetPlayerMapPosition then
    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if pos ~= nil then
      return true
    end
  end

  local best = GetBestPlayerMapID()
  if best and IsMapRelated(mapID, best) then
    return true
  end

  return false
end

local function PickBestMapID(mapIDs)
  if type(mapIDs) ~= "table" or #mapIDs < 1 then return nil end
  if not (C_Map and C_Map.GetBestMapForUnit and C_Map.GetMapInfo) then
    return mapIDs[1]
  end

  local isCandidate = {}
  for _, id in ipairs(mapIDs) do
    if type(id) == "number" and id > 0 then
      isCandidate[id] = true
    end
  end

  local cur = C_Map.GetBestMapForUnit("player")
  local safety = 0
  while type(cur) == "number" and cur > 0 and safety < 50 do
    safety = safety + 1

    if isCandidate[cur] then
      return cur
    end

    local info = C_Map.GetMapInfo(cur)
    local parent = info and info.parentMapID
    if type(parent) ~= "number" or parent <= 0 then
      break
    end
    cur = parent
  end

  for _, id in ipairs(mapIDs) do
    if PlayerProjectsDirectlyToMap(id) then
      return id
    end
  end

  return mapIDs[1]
end

local function pickPointForCurrentMap(points)
  if type(points) ~= "table" then return nil end
  if not (C_Map and C_Map.GetBestMapForUnit and C_Map.GetMapInfo) then return nil end

  local cur = C_Map.GetBestMapForUnit("player")
  local safety = 0
  while type(cur) == "number" and cur > 0 and safety < 50 do
    safety = safety + 1

    local pt = points[cur]
    if type(pt) == "table" then
      return pt, cur
    end

    local info = C_Map.GetMapInfo(cur)
    local parent = info and info.parentMapID
    if type(parent) ~= "number" or parent <= 0 then
      break
    end
    cur = parent
  end

  return nil
end

local function CollectCandidateMapIDs(step, seg)
  local out = {}
  local seen = {}

  local function add(id)
    if type(id) == "number" and id > 0 and not seen[id] then
      seen[id] = true
      out[#out + 1] = id
    end
  end

  local explicit = segMapIDs(step, seg)
  for _, id in ipairs(explicit) do
    add(id)
  end

  if seg and type(seg.points) == "table" then
    for mapID, _ in pairs(seg.points) do
      add(mapID)
    end
  end

  return out
end

local function AnyQuestFlaggedCompletedRaw(qids)
  if not (C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then
    return false
  end
  for qid in IterateQuestIDs(qids) do
    if type(qid) == "number" and qid > 0 and C_QuestLog.IsQuestFlaggedCompleted(qid) then
      return true
    end
  end
  return false
end

local function AnyReadyForTurnInRaw(qids)
  if not (C_QuestLog and C_QuestLog.ReadyForTurnIn) then
    return false
  end
  for qid in IterateQuestIDs(qids) do
    if type(qid) == "number" and qid > 0 and C_QuestLog.ReadyForTurnIn(qid) then
      return true
    end
  end
  return false
end

local function AnyInLogRaw(qids)
  if not (C_QuestLog and C_QuestLog.IsOnQuest) then
    return false
  end
  for qid in IterateQuestIDs(qids) do
    if type(qid) == "number" and qid > 0 and C_QuestLog.IsOnQuest(qid) then
      return true
    end
  end
  return false
end

local function IsAnyQuestInLog(qids)
  if not qids then return false end

  if FTA.Quest and FTA.Quest.IsInLog and FTA.Quest:IsInLog(qids) == true then
    return true
  end

  return AnyInLogRaw(qids)
end

local function IsQuestDrivenSegmentApplicable(seg)
  if type(seg) ~= "table" then return true end
  if not seg.questIDs then return true end
  if not (FTA.Quest and FTA.Quest.IsInLog and FTA.Quest.IsReadyForTurnIn and FTA.Quest.IsFlaggedCompleted) then
    return true
  end

  local kind = seg.kind
  if kind ~= "OBJECTIVE" and kind ~= "TURNIN" then
    return true
  end

  if kind == "TURNIN" then
    return true
  end

  if FTA.Quest.WasRecentlyTurnedIn then
    local recent = FTA.Quest:WasRecentlyTurnedIn(seg.questIDs)
    if recent then return true end
  end

  local inLog = FTA.Quest:IsInLog(seg.questIDs)
  if inLog then return true end

  local ready = FTA.Quest:IsReadyForTurnIn(seg.questIDs)
  if ready then return true end

  local done = FTA.Quest:IsFlaggedCompleted(seg.questIDs)
  if done then return true end

  return false
end

local function IsPickupAlreadyDone(qids)
  if not qids then return false end

  local inLog = false
  if FTA.Quest and FTA.Quest.IsInLog then
    inLog = (FTA.Quest:IsInLog(qids) == true)
  end
  if (not inLog) and AnyInLogRaw(qids) then
    inLog = true
  end
  if inLog then return false end

  if FTA.Quest and FTA.Quest.WasRecentlyTurnedIn and FTA.Quest:WasRecentlyTurnedIn(qids) then
    return true
  end

  if (FTA.Quest and FTA.Quest.IsReadyForTurnIn and FTA.Quest:IsReadyForTurnIn(qids) == true)
    or AnyReadyForTurnInRaw(qids)
  then
    return true
  end

  if AnyQuestFlaggedCompletedRaw(qids) then
    return true
  end

  if (FTA.Quest and FTA.Quest.IsFlaggedCompleted and FTA.Quest:IsFlaggedCompleted(qids) == true) then
    return true
  end

  return false
end

local function BuildQuestIDSet(questIDs)
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

local function QuestIDsOverlap(a, b)
  local A = BuildQuestIDSet(a)
  if not A then return false end
  if type(b) == "number" then
    return A[b] == true
  elseif type(b) == "table" then
    for _, qid in ipairs(b) do
      if A[qid] then return true end
    end
  end
  return false
end

local function ResetChainsForQuestInStep(step, questIDs)
  if not (FTA.StepEngine and FTA.StepEngine.ResetChainIndex) then return end
  if type(step) ~= "table" or type(step.segments) ~= "table" then return end

  for idx, s in ipairs(step.segments) do
    if type(s) == "table"
      and s.kind == "OBJECTIVE"
      and type(s.arrow) == "table"
      and (s.arrow.mode == "WAYPOINT_CHAIN" or s.arrow.mode == "SEQUENCE_CHAIN")
      and s.questIDs
      and QuestIDsOverlap(questIDs, s.questIDs)
    then
      local key = s.arrow.key or ("Q:" .. tostring((type(s.questIDs) == "table" and s.questIDs[1]) or s.questIDs) .. ":SEG:" .. tostring(idx))
      FTA.StepEngine:ResetChainIndex(key)
    end
  end
end

local function ResetStepChainIfAny(step)
  if not (FTA.StepEngine and FTA.StepEngine.ResetChainIndex) then return end
  if type(step) ~= "table" then return end
  if type(step.arrow) ~= "table" then return end
  if step.arrow.mode ~= "SEQUENCE_CHAIN" then return end
  local key = step.arrow.key or "STEPSEQ:DEFAULT"
  FTA.StepEngine:ResetChainIndex(key)
end

local function ResetStepWaypointChainIfAny(step)
  if not (FTA.StepEngine and FTA.StepEngine.ResetChainIndex) then return end
  if type(step) ~= "table" then return end
  if type(step.arrow) ~= "table" then return end
  if step.arrow.mode ~= "WAYPOINT_CHAIN" then return end
  local key = step.arrow.key or "STEPWP:DEFAULT"
  FTA.StepEngine:ResetChainIndex(key)
end

local function ShouldShowTurnin(seg)
  if not seg or seg.kind ~= "TURNIN" or not seg.questIDs then return false end
  if not (FTA.Quest and FTA.Quest.IsInLog and FTA.Quest.IsReadyForTurnIn) then return false end

  local inLog = FTA.Quest:IsInLog(seg.questIDs)
  if not inLog then return false end

  local ready = FTA.Quest:IsReadyForTurnIn(seg.questIDs)
  return ready == true
end

local function ResolveSegmentContext(moduleId, stepIndex)
  if type(moduleId) == "string" and moduleId ~= "" and type(stepIndex) == "number" and stepIndex >= 1 then
    return moduleId, math.floor(stepIndex)
  end

  if FTA.StepEngine and FTA.StepEngine.GetActiveModuleId and FTA.StepEngine.GetStepIndex then
    local activeModuleId = FTA.StepEngine:GetActiveModuleId()
    if type(activeModuleId) == "string" and activeModuleId ~= "" then
      return activeModuleId, FTA.StepEngine:GetStepIndex(activeModuleId)
    end
  end

  return nil, nil
end

local function IsSegmentVisible(step, segIndex, seg, moduleId, stepIndex)
  if type(seg) ~= "table" then return true end

  local prereqIdx = seg.showAfter
  if type(prereqIdx) == "number" then
    prereqIdx = math.floor(prereqIdx)
    if prereqIdx >= 1 and type(step) == "table" and type(step.segments) == "table" then
      local prereq = step.segments[prereqIdx]
      if type(prereq) == "table" and FTA.Resolve and FTA.Resolve.IsSegmentSatisfied then
        if FTA.Resolve:IsSegmentSatisfied(prereq, moduleId, stepIndex, prereqIdx) ~= true then
          return false
        end
      end
    end
  end

  if seg.showWhenQuestInLog ~= nil then
    local qids = seg.showWhenQuestInLog
    if qids == true then
      qids = seg.questIDs
    end

    if qids and not IsAnyQuestInLog(qids) then
      return false
    end
  end

  return true
end

local function FindChainStartIndex(step)
  if type(step) ~= "table" or type(step.segments) ~= "table" then return nil end
  for idx, seg in ipairs(step.segments) do
    if type(seg) == "table" and seg.kind == "CHAIN_START" then
      return idx
    end
  end
  return nil
end

local function HasUnsatisfiedObjectives(step, fromIndex, moduleId, stepIndex)
  if type(step) ~= "table" or type(step.segments) ~= "table" then return false end
  fromIndex = tonumber(fromIndex) or 1
  if fromIndex < 1 then fromIndex = 1 end

  for idx = fromIndex, #step.segments do
    local seg = step.segments[idx]
    if type(seg) == "table" and (seg.kind == "OBJECTIVE" or seg.kind == "MANUAL") then
      if FTA.Resolve and FTA.Resolve.IsSegmentSatisfied then
        if not FTA.Resolve:IsSegmentSatisfied(seg, moduleId, stepIndex, idx) then
          return true
        end
      end
    end
  end
  return false
end

function FTA.Resolve:IsSegmentSatisfied(seg, moduleId, stepIndex, segIndex)
  if not seg or not seg.kind then return true end
  local kind = seg.kind

  if kind == "NOTE" then
    return true
  end

  if kind == "CHAIN_START" then
    return true
  end

  if kind == "IMAGE_POPUP" then
    return true
  end

  if kind == "VIDEO_EMBED" then
    return true
  end

  if kind == "MANUAL" then
    local resolvedModuleId, resolvedStepIndex = ResolveSegmentContext(moduleId, stepIndex)
    if not (resolvedModuleId and resolvedStepIndex) then
      return false
    end
    if not (FTA.StepEngine and FTA.StepEngine.IsManualSegmentComplete) then
      return false
    end
    return FTA.StepEngine:IsManualSegmentComplete(resolvedModuleId, resolvedStepIndex, seg, segIndex) == true
  end

  if (kind == "OBJECTIVE" or kind == "TURNIN") and not IsQuestDrivenSegmentApplicable(seg) then
    return true
  end

  local qids = seg.questIDs
  if not qids then
    return false
  end

  if kind == "PICKUP" then
    if AnyQuestFlaggedCompletedRaw(qids) then
      return true
    end

    if IsPickupAlreadyDone(qids) then
      return true
    end

    local inLog = (FTA.Quest and FTA.Quest.IsInLog and FTA.Quest:IsInLog(qids) == true) or AnyInLogRaw(qids)
    if inLog then
      return true
    end

    local done = (FTA.Quest and FTA.Quest.IsFlaggedCompleted and FTA.Quest:IsFlaggedCompleted(qids) == true)
    if done then
      return true
    end

    return false
  end

  if kind == "OBJECTIVE" then
    if FTA.Quest and FTA.Quest.WasRecentlyTurnedIn then
      local recent = FTA.Quest:WasRecentlyTurnedIn(qids)
      if recent then return true end
    end

    local done = FTA.Quest:IsFlaggedCompleted(qids)
    if done then
      return true
    end

    local inLog = FTA.Quest:IsInLog(qids)
    if not inLog then
      return false
    end

    local rft = FTA.Quest:IsReadyForTurnIn(qids)
    if rft then
      return true
    end

    if FTA.Quest and FTA.Quest.IsObjectiveSatisfied then
      local ok = FTA.Quest:IsObjectiveSatisfied(qids, seg)
      if ok ~= nil then
        return ok
      end
    end

    return false
  end

  if kind == "TURNIN" then
    if FTA.Quest and FTA.Quest.WasRecentlyTurnedIn then
      local recent = FTA.Quest:WasRecentlyTurnedIn(qids)
      if recent then return true end
    end

    local done = FTA.Quest:IsFlaggedCompleted(qids)
    if done then return true end

    local inLog = FTA.Quest:IsInLog(qids)
    if inLog then
      return false
    end

    return false
  end

  return false
end

function FTA.Resolve:IsStepSatisfied(step, moduleId, stepIndex)
  if not step then return true end
  if type(step.segments) ~= "table" then return true end

  for segIndex, seg in ipairs(step.segments) do
    if seg.kind ~= "NOTE"
      and seg.kind ~= "CHAIN_START"
      and seg.kind ~= "IMAGE_POPUP"
      and seg.kind ~= "VIDEO_EMBED"
      and IsSegmentVisible(step, segIndex, seg, moduleId, stepIndex)
      and not self:IsSegmentSatisfied(seg, moduleId, stepIndex, segIndex)
    then
      return false
    end
  end
  return true
end

function FTA.Resolve:GetActiveSegment(mod, step, moduleId, stepIndex)
  if not step or type(step.segments) ~= "table" then return nil, nil end

  local resolvedModuleId, resolvedStepIndex = ResolveSegmentContext(moduleId, stepIndex)

  for i, seg in ipairs(step.segments) do
    if seg.kind ~= "NOTE"
      and seg.kind ~= "CHAIN_START"
      and seg.kind ~= "IMAGE_POPUP"
      and seg.kind ~= "VIDEO_EMBED"
      and seg.kind ~= "MODULE_BUTTON"
      and seg.kind ~= "MODULE_CHOICE_ROW"
      and seg.kind ~= "CAMPAIGN_PROGRESS_CHOICE"
      and IsSegmentVisible(step, i, seg, resolvedModuleId, resolvedStepIndex)
      and not self:IsSegmentSatisfied(seg, resolvedModuleId, resolvedStepIndex, i)
    then
      if seg.kind == "TURNIN" then
        if not ShouldShowTurnin(seg) then
        else
          return i, seg
        end
      else
        return i, seg
      end
    end
  end

  return nil, nil
end

local function applyRouteIfAny(seg, x, y)
  if type(seg) ~= "table" then return x, y end
  if seg.routeMode ~= "objectiveCount" then return x, y end
  if type(seg.route) ~= "table" or #seg.route < 1 then return x, y end
  if not (FTA.Quest and FTA.Quest.GetObjectiveCountForSegment) then return x, y end
  if not seg.questIDs then return x, y end

  local cur, tot = FTA.Quest:GetObjectiveCountForSegment(seg.questIDs, seg)
  if type(cur) ~= "number" then return x, y end

  local idx = math.floor(cur) + 1
  if idx < 1 then idx = 1 end
  if idx > #seg.route then idx = #seg.route end

  local wp = seg.route[idx]
  if type(wp) == "table" and wp.x and wp.y then
    return wp.x, wp.y
  end

  return x, y
end

local function NormalizeCoord01(v)
  if type(v) ~= "number" then return nil end
  if v > 1 then return v / 100 end
  return v
end

local function NormalizeXY(x, y)
  x = NormalizeCoord01(x)
  y = NormalizeCoord01(y)
  return x, y
end

local function GetWaypointMapIDs(step, seg, wp)
  if type(wp) == "table" and wp.mapID ~= nil then
    local ids = asMapIDList(wp.mapID)
    if #ids > 0 then return ids end
  end
  return CollectCandidateMapIDs(step, seg)
end

local function pickWaypointPoint(step, seg, wp)
  if type(wp) ~= "table" then return nil, nil, nil end

  if type(wp.points) == "table" then
    local mapIDs = {}
    local seen = {}

    for mapID, _ in pairs(wp.points) do
      if type(mapID) == "number" and mapID > 0 and not seen[mapID] then
        seen[mapID] = true
        mapIDs[#mapIDs + 1] = mapID
      end
    end

    if #mapIDs < 1 then
      mapIDs = CollectCandidateMapIDs(step, seg)
    end

    local best = PickBestMapID(mapIDs)
    if best and type(wp.points[best]) == "table" then
      local pt = wp.points[best]
      return pt.x, pt.y, mapIDs
    end

    local pt, ptMap = pickPointForCurrentMap(wp.points)
    if pt then
      mapIDs = (#mapIDs > 0) and mapIDs or { ptMap }
      return pt.x, pt.y, mapIDs
    end
  end

  local mapIDs = GetWaypointMapIDs(step, seg, wp)
  return wp.x, wp.y, mapIDs
end

local function ReorderMapIDsByBest(mapIDs)
  if type(mapIDs) ~= "table" or #mapIDs < 1 then return mapIDs end
  local best = PickBestMapID(mapIDs)
  if not best then return mapIDs end
  local reordered = { best }
  for _, id in ipairs(mapIDs) do
    if id ~= best then
      reordered[#reordered + 1] = id
    end
  end
  return reordered
end

local function IsObjectiveNodeSatisfied(node)
  if type(node) ~= "table" then return false end
  if node.advance ~= "OBJECTIVE" then return false end
  if not node.questIDs then return false end
  if not FTA.Quest then return false end

  if FTA.Quest.IsFlaggedCompleted and FTA.Quest:IsFlaggedCompleted(node.questIDs) then
    return true
  end

  if FTA.Quest.IsReadyForTurnIn and FTA.Quest:IsReadyForTurnIn(node.questIDs) then
    return true
  end

  if FTA.Quest.IsObjectiveSatisfied then
    local ok = FTA.Quest:IsObjectiveSatisfied(node.questIDs, node)
    return ok == true
  end

  return false
end

local function IsPickupNodeSatisfied(node)
  if type(node) ~= "table" then return false end
  if node.advance ~= "PICKUP" then return false end
  if not node.questIDs then return false end

  if AnyQuestFlaggedCompletedRaw(node.questIDs) then
    return true
  end

  if IsPickupAlreadyDone(node.questIDs) then
    return true
  end

  if IsAnyQuestInLog(node.questIDs) then
    return true
  end

  if FTA.Quest and FTA.Quest.IsFlaggedCompleted and FTA.Quest:IsFlaggedCompleted(node.questIDs) then
    return true
  end

  return false
end

local function IsTurninNodeSatisfied(node)
  if type(node) ~= "table" then return false end
  if node.advance ~= "TURNIN" then return false end
  if not node.questIDs then return false end

  if FTA.Quest and FTA.Quest.WasRecentlyTurnedIn and FTA.Quest:WasRecentlyTurnedIn(node.questIDs) then
    return true
  end

  if AnyQuestFlaggedCompletedRaw(node.questIDs) then
    return true
  end

  if FTA.Quest and FTA.Quest.IsFlaggedCompleted and FTA.Quest:IsFlaggedCompleted(node.questIDs) then
    return true
  end

  return false
end

local function IsSequenceNodeSatisfied(node)
  if type(node) ~= "table" then return false end

  if node.advance == "OBJECTIVE" then
    return IsObjectiveNodeSatisfied(node)
  end

  if node.advance == "PICKUP" then
    return IsPickupNodeSatisfied(node)
  end

  if node.advance == "TURNIN" then
    return IsTurninNodeSatisfied(node)
  end

  return false
end

local function IsGateSatisfied(gate)
  if gate == nil then
    return true
  end
  if type(gate) ~= "table" then
    return true
  end

  local qids = gate.questIDs or gate.questID
  if not qids then
    return false
  end

  if gate.progressAtLeast ~= nil or gate.progressAtMost ~= nil then
    if not (FTA.Quest and FTA.Quest.GetProgressBarPercent) then
      return false
    end

    local pct = FTA.Quest:GetProgressBarPercent(qids)
    if type(pct) ~= "number" then
      return false
    end

    local ok = true

    if gate.progressAtLeast ~= nil then
      local n = tonumber(gate.progressAtLeast)
      if n ~= nil and pct < n then ok = false end
    end

    if gate.progressAtMost ~= nil then
      local n = tonumber(gate.progressAtMost)
      if n ~= nil and pct > n then ok = false end
    end

    if gate.invert == true then
      ok = not ok
    end

    return ok
  end

  if not (FTA.Quest and FTA.Quest.GetObjectiveCountForSegment) then
    return false
  end

  local selector = {
    objectiveIndex = gate.objectiveIndex,
    objectiveText = gate.objectiveText,
    objectiveTextContains = gate.objectiveTextContains,
  }

  local cur, req = FTA.Quest:GetObjectiveCountForSegment(qids, selector)

  if type(cur) ~= "number" then
    return false
  end

  if cur < 0 then cur = 0 end
  if type(req) == "number" and req > 0 and cur > req then
    cur = req
  end

  local ok = true

  if gate.atLeast ~= nil then
    local n = tonumber(gate.atLeast)
    if n ~= nil and cur < n then ok = false end
  end

  if gate.atMost ~= nil then
    local n = tonumber(gate.atMost)
    if n ~= nil and cur > n then ok = false end
  end

  if gate.invert == true then
    ok = not ok
  end

  return ok
end

local function Seq_NormalizeCoord01(v)
  if type(v) ~= "number" then return nil end
  if v <= 0 then return nil end

  local safety = 0
  while v > 1 and safety < 4 do
    v = v / 100
    safety = safety + 1
  end

  if v <= 0 or v > 1 then return nil end
  return v
end

local function Seq_NormalizeAndValidateXY(x, y)
  x = Seq_NormalizeCoord01(x)
  y = Seq_NormalizeCoord01(y)
  if not x or not y then return nil, nil end
  return x, y
end

local function Seq_PickValidNodePoint(step, seg, node)
  local x, y, mapIDs = pickWaypointPoint(step, seg, node)
  x, y = Seq_NormalizeAndValidateXY(x, y)
  if x and y and type(mapIDs) == "table" and #mapIDs > 0 then
    return x, y, mapIDs
  end

  if type(node) ~= "table" or type(node.points) ~= "table" then
    return nil, nil, nil
  end

  local pt, ptMap = pickPointForCurrentMap(node.points)
  if pt then
    local nx, ny = Seq_NormalizeAndValidateXY(pt.x, pt.y)
    if nx and ny then
      return nx, ny, { ptMap }
    end
  end

  for mapID, p in pairs(node.points) do
    if type(mapID) == "number" and mapID > 0 and type(p) == "table" then
      local nx, ny = Seq_NormalizeAndValidateXY(p.x, p.y)
      if nx and ny then
        return nx, ny, { mapID }
      end
    end
  end

  return nil, nil, nil
end

local function ResolveSequenceChainTarget(step, seg, seq, keyPrefix, segIndexForKey)
  if type(seq) ~= "table" then return nil end
  if seq.mode ~= "SEQUENCE_CHAIN" then return nil end
  if type(seq.nodes) ~= "table" or #seq.nodes < 1 then return nil end
  if not (FTA.StepEngine and FTA.StepEngine.GetChainIndex and FTA.StepEngine.AdvanceChainIndex and FTA.StepEngine.ResetChainIndex) then
    return nil
  end

  local key = seq.key or (keyPrefix .. tostring(segIndexForKey or 0))

  local idx = FTA.StepEngine:GetChainIndex(key)
  if type(idx) ~= "number" or idx < 1 then idx = 1 end

  local safety = 0
  while idx <= #seq.nodes and safety < 50 do
    safety = safety + 1
    local node = seq.nodes[idx]

    if type(node) ~= "table" then
      FTA.StepEngine:AdvanceChainIndex(key, 1)
      idx = idx + 1
    elseif IsSequenceNodeSatisfied(node) then
      FTA.StepEngine:AdvanceChainIndex(key, 1)
      idx = idx + 1
    else
      break
    end
  end

  if idx > #seq.nodes then
    return nil
  end

  local node = seq.nodes[idx]
  if type(node) ~= "table" then return nil end

  local x, y, mapIDs = pickWaypointPoint(step, seg, node)
  x, y = NormalizeXY(x, y)

  if type(node.points) == "table" then
    local chosenMapID = nil
    local best = (C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")) or nil

    if best and type(node.points[best]) == "table" then
      chosenMapID = best
      local p = node.points[best]
      x, y = NormalizeXY(p.x, p.y)
    else
      local pt, ptMap = pickPointForCurrentMap(node.points)
      if pt and ptMap then
        chosenMapID = ptMap
        x, y = NormalizeXY(pt.x, pt.y)
      end
    end

    if not chosenMapID then
      if type(mapIDs) == "table" and #mapIDs > 0 then
        chosenMapID = mapIDs[1]
      elseif type(node.mapID) == "number" and node.mapID > 0 then
        chosenMapID = node.mapID
      end
    end

    if not chosenMapID then return nil end
    mapIDs = { chosenMapID }
  end

  if not (type(mapIDs) == "table" and #mapIDs > 0) then return nil end
  if type(x) ~= "number" or type(y) ~= "number" or x <= 0 or y <= 0 then return nil end

  mapIDs = ReorderMapIDsByBest(mapIDs)

  local radius = tonumber(node.radius) or tonumber(seq.radius) or 7
  local advanceType = node.advance or "PROXIMITY"

  local onArrive = nil
  local arriveBehavior = nil

  if advanceType == "PROXIMITY" then
    local gateOK = IsGateSatisfied(node.gate)

    if gateOK then
      arriveBehavior = "ADVANCE"
      onArrive = {
        mode = "SEQUENCE_CHAIN",
        key = key,
        idx = idx,
        count = #seq.nodes,
        debounce = tonumber(node.debounce) or tonumber(seq.debounce) or 0.75,
      }
    end
  end

  return {
    mapIDs = mapIDs,
    mapID  = mapIDs[1],
    x = x,
    y = y,
    radius = radius,
    arriveBehavior = arriveBehavior,
    arriveShowDown = false,
    onArrive = onArrive,
    _segIndex = segIndexForKey,
  }
end

local function ResolveWaypointChainTarget(step, segContext, chain, keyPrefix, segIndexForKey)
  if type(chain) ~= "table" then return nil end
  if chain.mode ~= "WAYPOINT_CHAIN" then return nil end
  if type(chain.points) ~= "table" or #chain.points < 1 then return nil end
  if not (FTA.StepEngine and FTA.StepEngine.GetChainIndex and FTA.StepEngine.AdvanceChainIndex and FTA.StepEngine.ResetChainIndex) then
    return nil
  end

  local key = chain.key or (keyPrefix .. tostring(segIndexForKey or 0))

  local pts = chain.points
  local idx = FTA.StepEngine:GetChainIndex(key)
  if type(idx) ~= "number" or idx < 1 then idx = 1 end

  if idx <= #pts then
    local wp = pts[idx]
    local x, y, mapIDs = pickWaypointPoint(step, segContext, wp)
    x, y = NormalizeXY(x, y)

    if type(mapIDs) == "table" and #mapIDs > 0 and type(x) == "number" and type(y) == "number" and x > 0 and y > 0 then
      mapIDs = ReorderMapIDsByBest(mapIDs)

      return {
        mapIDs = mapIDs,
        mapID  = mapIDs[1],
        x = x,
        y = y,
        radius = tonumber(wp.radius) or tonumber(chain.radius) or 7,
        arriveBehavior = "ADVANCE",
        arriveShowDown = false,
        onArrive = {
          mode = "WAYPOINT_CHAIN",
          key = key,
          idx = idx,
          count = #pts,
          debounce = tonumber(chain.debounce) or 0.75,
        },
        _segIndex = segIndexForKey,
      }
    end
  end

  if type(chain.fallback) == "table" then
    local fb = chain.fallback
    local x, y, mapIDs = pickWaypointPoint(step, segContext, fb)
    x, y = NormalizeXY(x, y)

    if type(mapIDs) == "table" and #mapIDs > 0 and type(x) == "number" and type(y) == "number" and x > 0 and y > 0 then
      mapIDs = ReorderMapIDsByBest(mapIDs)

      return {
        mapIDs = mapIDs,
        mapID  = mapIDs[1],
        x = x,
        y = y,
        radius = tonumber(fb.radius) or tonumber(chain.radius) or DEFAULT_RADIUS,
        _segIndex = segIndexForKey,
      }
    end
  end

  return nil
end

local function ResolveAnyActiveSequenceChainTarget(step, seg, requireStarted)
  if type(step) ~= "table" then return nil end
  if not (FTA.StepEngine and FTA.StepEngine.GetChainIndex) then return nil end

  if type(step.segments) == "table" then
    for segIndex, s in ipairs(step.segments) do
      if type(s) == "table"
        and s.kind == "OBJECTIVE"
        and type(s.arrow) == "table"
        and s.arrow.mode == "SEQUENCE_CHAIN"
      then
        local key = s.arrow.key or ("SEGSEQ:" .. tostring(segIndex))
        local idx = FTA.StepEngine:GetChainIndex(key)

        if (not requireStarted) or (type(idx) == "number" and idx > 1) then
          local tgt = ResolveSequenceChainTarget(step, s, s.arrow, "SEGSEQ:", segIndex)
          if tgt then
            return tgt
          end
        end
      end
    end
  end

  if type(step.arrow) == "table" and step.arrow.mode == "SEQUENCE_CHAIN" then
    local key = step.arrow.key or "STEPSEQ:DEFAULT"
    local idx = FTA.StepEngine:GetChainIndex(key)
    if (not requireStarted) or (type(idx) == "number" and idx > 1) then
      local tgt = ResolveSequenceChainTarget(step, seg, step.arrow, "STEPSEQ:", 0)
      if tgt then return tgt end
    end
  end

  return nil
end

PlayerProjectsDirectlyToMap = function(mapID)
  if type(mapID) ~= "number" or mapID <= 0 then return false end
  if not (C_Map and C_Map.GetPlayerMapPosition) then return false end

  local pos = C_Map.GetPlayerMapPosition(mapID, "player")
  if not pos then
    return false
  end

  local x, y = pos:GetXY()
  return type(x) == "number" and type(y) == "number"
end

function FTA.Resolve:GetCurrentTarget(mod, step)
  local activeModuleId, activeStepIndex = ResolveSegmentContext(nil, nil)
  local i, seg = self:GetActiveSegment(mod, step, activeModuleId, activeStepIndex)
  if not seg then return nil end

  local pickupActive = (seg.kind == "PICKUP")

  local chainStartIndex = FindChainStartIndex(step)

  local function ChainAllowedNow(activeSegIndex)
    if not chainStartIndex then
      return true
    end
    if type(activeSegIndex) ~= "number" then
      return false
    end
    return activeSegIndex >= chainStartIndex
  end

  local function ChainTargetAllowedByActiveSegment(chain, defaultKey)
    if not pickupActive then
      return true
    end
    if not (FTA.StepEngine and FTA.StepEngine.GetChainIndex) then
      return false
    end
    local key = (type(chain) == "table" and chain.key) or defaultKey
    local idx = FTA.StepEngine:GetChainIndex(key)
    return type(idx) == "number" and idx > 1
  end

  if (not pickupActive)
    and seg.kind == "OBJECTIVE"
    and type(seg.arrow) == "table"
    and seg.arrow.mode == "SEQUENCE_CHAIN"
  then
    local tgt = ResolveSequenceChainTarget(step, seg, seg.arrow, "SEGSEQ:", i)
    if tgt then return tgt end
  end

  if (not pickupActive)
    or (type(step) == "table"
      and type(step.arrow) == "table"
      and step.arrow.mode == "SEQUENCE_CHAIN"
      and ChainTargetAllowedByActiveSegment(step.arrow, "STEPSEQ:DEFAULT"))
  then
    local fromIdx = chainStartIndex or 1
    if HasUnsatisfiedObjectives(step, fromIdx, activeModuleId, activeStepIndex) then
      local chainTgt = ResolveAnyActiveSequenceChainTarget(step, seg, true)
      if chainTgt then
        return chainTgt
      end
    end
  end

  if type(step) == "table"
    and type(step.arrow) == "table"
    and step.arrow.mode == "WAYPOINT_CHAIN"
    and ChainAllowedNow(i)
    and ChainTargetAllowedByActiveSegment(step.arrow, "STEPWP:DEFAULT")
  then
    local fromIdx = chainStartIndex or 1
    if HasUnsatisfiedObjectives(step, fromIdx, activeModuleId, activeStepIndex) then
      local tgt = ResolveWaypointChainTarget(step, seg, step.arrow, "STEPWP:", 0)
      if tgt then return tgt end
    end
  end

  if seg.kind == "OBJECTIVE"
    and type(seg.arrow) == "table"
    and seg.arrow.mode == "WAYPOINT_CHAIN"
    and seg.questIDs
    and FTA.StepEngine
    and FTA.StepEngine.GetChainIndex
    and FTA.StepEngine.ResetChainIndex
  then
    if FTA.Quest then
      local done = FTA.Quest:IsFlaggedCompleted(seg.questIDs)
      local rft  = FTA.Quest:IsReadyForTurnIn(seg.questIDs)
      local inLog = FTA.Quest:IsInLog(seg.questIDs)

      local key = seg.arrow.key or ("Q:" .. tostring((type(seg.questIDs) == "table" and seg.questIDs[1]) or seg.questIDs) .. ":SEG:" .. tostring(i))

      if (not inLog) or done or rft then
        FTA.StepEngine:ResetChainIndex(key)
      else
        local pts = seg.arrow.points
        if type(pts) == "table" and #pts > 0 then
          local idx = FTA.StepEngine:GetChainIndex(key)

          if idx <= #pts then
            local wp = pts[idx]
            local x, y, mapIDs = pickWaypointPoint(step, seg, wp)
            x, y = NormalizeXY(x, y)

            if type(mapIDs) == "table" and #mapIDs > 0 and type(x) == "number" and type(y) == "number" and x > 0 and y > 0 then
              mapIDs = ReorderMapIDsByBest(mapIDs)

              return {
                mapIDs = mapIDs,
                mapID  = mapIDs[1],
                x = x,
                y = y,
                radius = tonumber(seg.arrow.radius) or 7,
                arriveBehavior = "ADVANCE",
                arriveShowDown = false,
                onArrive = {
                  mode = "WAYPOINT_CHAIN",
                  key = key,
                  idx = idx,
                  count = #pts,
                  questIDs = seg.questIDs,
                  debounce = tonumber(seg.arrow.debounce) or 0.75,
                },
                _segIndex = i,
              }
            end
          end
        end

        if type(seg.arrow.fallback) == "table" then
          local fb = seg.arrow.fallback
          local x, y, mapIDs = pickWaypointPoint(step, seg, fb)
          x, y = NormalizeXY(x, y)

          if type(mapIDs) == "table" and #mapIDs > 0 and type(x) == "number" and type(y) == "number" and x > 0 and y > 0 then
            mapIDs = ReorderMapIDsByBest(mapIDs)

            return {
              mapIDs = mapIDs,
              mapID  = mapIDs[1],
              x = x,
              y = y,
              radius = tonumber(fb.radius) or segRadius(mod, step, seg),
              _segIndex = i,
            }
          end
        end
      end
    end
  end

  if type(step) == "table"
    and type(step.arrow) == "table"
    and step.arrow.mode == "SEQUENCE_CHAIN"
    and ChainAllowedNow(i)
    and ChainTargetAllowedByActiveSegment(step.arrow, "STEPSEQ:DEFAULT")
  then
    local fromIdx = chainStartIndex or 1
    if HasUnsatisfiedObjectives(step, fromIdx, activeModuleId, activeStepIndex) then
      local tgt = ResolveSequenceChainTarget(step, seg, step.arrow, "STEPSEQ:", i)
      if tgt then return tgt end
    end
  end

  local mapIDs = CollectCandidateMapIDs(step, seg)

  local x, y

  if type(seg.points) == "table" then
    local bestForPoints = PickBestMapID(mapIDs)
    if bestForPoints and type(seg.points[bestForPoints]) == "table" then
      x = seg.points[bestForPoints].x
      y = seg.points[bestForPoints].y
      mapIDs = { bestForPoints }
    else
      local pt, ptMap = pickPointForCurrentMap(seg.points)
      if pt and ptMap then
        mapIDs = { ptMap }
        x = pt.x
        y = pt.y
      end
    end
  end

  if x == nil or y == nil then
    x, y = coordXY(seg)
  end

  x, y = applyRouteIfAny(seg, x, y)

  if #mapIDs < 1 then return nil end
  if type(x) ~= "number" or type(y) ~= "number" then return nil end
  if x <= 0 or y <= 0 then return nil end

  mapIDs = ReorderMapIDsByBest(mapIDs)

  return {
    mapIDs = mapIDs,
    mapID  = mapIDs[1],
    x = x,
    y = y,
    radius = segRadius(mod, step, seg),
    _segIndex = i,
  }
end

function FTA.Resolve:GetSegmentProgressText(seg)
  if not seg or seg.kind ~= "OBJECTIVE" then return nil end
  if not seg.questIDs then return nil end

  if FTA.Quest and FTA.Quest.GetObjectiveDisplayForSegment then
    local t = FTA.Quest:GetObjectiveDisplayForSegment(seg.questIDs, seg)
    if t then return t end
  end

  if not (FTA.Quest and FTA.Quest.GetObjectiveDisplay) then return nil end
  return FTA.Quest:GetObjectiveDisplay(seg.questIDs)
end

function FTA.Resolve:GetDisplaySegmentsForStep(step, moduleId, stepIndex)
  if not step or type(step.segments) ~= "table" then return {} end

  local resolvedModuleId, resolvedStepIndex = ResolveSegmentContext(moduleId, stepIndex)

  local groups = {}
  local groupOrder = {}

  local passthrough = {}

  local function IsPassthroughKind(kind)
    return kind == "MODULE_BUTTON"
      or kind == "CAMPAIGN_PROGRESS_CHOICE"
      or kind == "IMAGE_POPUP"
      or kind == "VIDEO_EMBED"
      or kind == "MODULE_CHOICE_ROW"
  end

  local function questGroupKey(seg, segIndex)
    if seg.trackKey then
      return seg.trackKey, true
    end

    if seg.kind == "MANUAL" then
      if type(seg.key) == "string" and seg.key ~= "" then
        return "MANUAL:" .. seg.key, false
      end
      return "MANUALIDX:" .. tostring(segIndex or 0), false
    end

    local qid = nil
    if type(seg.questIDs) == "table" then qid = seg.questIDs[1]
    elseif type(seg.questIDs) == "number" then qid = seg.questIDs end

    if qid then
      return "Q:" .. tostring(qid), false
    end

    return "MISC:" .. tostring(seg), false
  end

  for segIndex, seg in ipairs(step.segments) do
    if seg and seg.kind ~= "NOTE" and seg.kind ~= "CHAIN_START" then
      if IsPassthroughKind(seg.kind) then
        if IsSegmentVisible(step, segIndex, seg, resolvedModuleId, resolvedStepIndex) then
          passthrough[#passthrough + 1] = seg
        end
      else
        local key, isTrackKey = questGroupKey(seg, segIndex)
        if not groups[key] then
          groups[key] = { segs = {}, isTrackKey = isTrackKey }
          table.insert(groupOrder, key)
        end
        table.insert(groups[key].segs, { seg = seg, idx = segIndex })
      end
    end
  end

  local out = {}

  local function hasObjectiveSelector(seg)
    return type(seg.objectiveIndex) == "number"
      or (type(seg.objectiveText) == "string" and seg.objectiveText ~= "")
      or (type(seg.objectiveTextContains) == "string" and seg.objectiveTextContains ~= "")
  end

  for _, key in ipairs(groupOrder) do
    local g = groups[key]
    local wrapped = g.segs

    local pick
    local turn
    local turnIdx
    local objectives = {}

    for _, w in ipairs(wrapped) do
      local seg = w.seg
      if seg.kind == "PICKUP" then
        if not pick then
          pick = seg
        end
      elseif seg.kind == "TURNIN" then
        if not turn then
          turn = seg
          turnIdx = w.idx
        end
      elseif seg.kind == "OBJECTIVE" or seg.kind == "MANUAL" then
        table.insert(objectives, w)
      end
    end

    local pickVisible = false
    if pick then
      for _, w in ipairs(wrapped) do
        if w.seg == pick then
          pickVisible = IsSegmentVisible(step, w.idx, pick, resolvedModuleId, resolvedStepIndex)
          break
        end
      end
    end

    local turnVisible = false
    if turn and turnIdx then
      turnVisible = IsSegmentVisible(step, turnIdx, turn, resolvedModuleId, resolvedStepIndex)
    end

    if pick and pickVisible and not self:IsSegmentSatisfied(pick, resolvedModuleId, resolvedStepIndex) then
      table.insert(out, pick)
    else
      if g.isTrackKey then
        local chosen = nil
        for _, w in ipairs(wrapped) do
          local seg = w.seg
          local idx = w.idx
          if seg.kind ~= "NOTE"
            and seg.kind ~= "CHAIN_START"
            and IsSegmentVisible(step, idx, seg, resolvedModuleId, resolvedStepIndex)
            and not self:IsSegmentSatisfied(seg, resolvedModuleId, resolvedStepIndex, idx)
          then
            if seg.kind == "TURNIN" then
              if ShouldShowTurnin(seg) then
                chosen = seg
                break
              end
            else
              chosen = seg
              break
            end
          end
        end
        if chosen then
          table.insert(out, chosen)
        end
      else
        local anyShown = false

        for _, w in ipairs(objectives) do
          local obj = w.seg
          local idx = w.idx
          if obj.kind == "OBJECTIVE"
            and hasObjectiveSelector(obj)
            and IsSegmentVisible(step, idx, obj, resolvedModuleId, resolvedStepIndex)
            and not self:IsSegmentSatisfied(obj, resolvedModuleId, resolvedStepIndex, idx)
          then
            table.insert(out, obj)
            anyShown = true
          end
        end

        if not anyShown then
          for _, w in ipairs(objectives) do
            local obj = w.seg
            local idx = w.idx
            if IsSegmentVisible(step, idx, obj, resolvedModuleId, resolvedStepIndex)
              and not self:IsSegmentSatisfied(obj, resolvedModuleId, resolvedStepIndex, idx)
            then
              table.insert(out, obj)
              anyShown = true
              break
            end
          end
        end

        if turn and turnVisible and ShouldShowTurnin(turn) then
          table.insert(out, turn)
        end
      end
    end
  end

  for _, seg in ipairs(passthrough) do
    table.insert(out, seg)
  end

  for _, seg in ipairs(step.segments) do
    if seg.kind == "NOTE" then
      table.insert(out, seg)
    end
  end

  return out
end