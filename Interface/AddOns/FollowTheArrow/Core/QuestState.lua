-- QuestState.lua

local _, FTA = ...

FTA.Quest = FTA.Quest or {}


local function GetQuestCreditTable()
  if type(FTACharDB) ~= "table" then return nil end
  if type(FTACharDB.completion) ~= "table" then FTACharDB.completion = {} end
  if type(FTACharDB.completion.questCredits) ~= "table" then FTACharDB.completion.questCredits = {} end
  return FTACharDB.completion.questCredits
end

function FTA.Quest:IsQuestCreditCached(questID)
  if type(questID) ~= "number" then return false end
  local t = GetQuestCreditTable()
  return (t and t[questID] == true) or false
end

function FTA.Quest:MarkQuestCredit(questID)
  if type(questID) ~= "number" then return false end
  local t = GetQuestCreditTable()
  if not t then return false end
  if t[questID] == true then return false end
  t[questID] = true
  return true
end

function FTA.Quest:AnyQuestCreditCached(questIDs)
  for qid in IterateQuestIDs(questIDs) do
    if type(qid) == "number" and self:IsQuestCreditCached(qid) then
      return true, qid
    end
  end
  return false, nil
end

function FTA.Quest:RefreshQuestCredit(questID)
  if type(questID) ~= "number" then return false end
  if self:IsQuestCreditCached(questID) then return true end
  if not (C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then return false end
  if C_QuestLog.IsQuestFlaggedCompleted(questID) then
    self:MarkQuestCredit(questID)
    return true
  end
  return false
end

function FTA.Quest:RefreshQuestCredits(questIDs)
  local any = false
  for qid in IterateQuestIDs(questIDs) do
    if type(qid) == "number" then
      if self:RefreshQuestCredit(qid) then
        any = true
      end
    end
  end
  return any
end

function IterateQuestIDs(questIDs)
  if questIDs == nil then
    return function() return nil end
  end

  if type(questIDs) == "number" then
    local done = false
    return function()
      if done then return nil end
      done = true
      return questIDs
    end
  end

  if type(questIDs) == "table" then
    local maxIndex = 0
    for k, _ in pairs(questIDs) do
      if type(k) == "number" and k > maxIndex then
        maxIndex = k
      end
    end

    local i = 0
    return function()
      while true do
        i = i + 1
        if i > maxIndex then
          return nil
        end
        local v = questIDs[i]
        if v ~= nil then
          return v
        end
      end
    end
  end

  return function() return nil end
end

local function FirstQuestID(questIDs)
  for qid in IterateQuestIDs(questIDs) do
    if type(qid) == "number" then
      return qid
    end
  end
  return nil
end

local function FindActiveQuestIDInLog(self, questIDs)
  local inLog, activeQID = self:IsInLog(questIDs)
  if inLog and activeQID then
    return activeQID
  end
  return nil
end

function FTA.Quest:ResolveActiveQuestID(questIDs, opts)
  if questIDs == nil then return nil end
  opts = (type(opts) == "table") and opts or {}

  local qid = FindActiveQuestIDInLog(self, questIDs)
  if qid then return qid end

  if opts.allowReady and self.IsReadyForTurnIn then
    local ready, rqid = self:IsReadyForTurnIn(questIDs)
    if ready and rqid then return rqid end
  end

  if opts.allowCompleted and self.IsFlaggedCompleted then
    local done, dqid = self:IsFlaggedCompleted(questIDs)
    if done and dqid then return dqid end
  end

  return nil
end

function FTA.Quest:IsInLog(questIDs)
  if not (C_QuestLog and C_QuestLog.GetLogIndexForQuestID) then
    return false, nil
  end
  for qid in IterateQuestIDs(questIDs) do
    if qid then
      local idx = C_QuestLog.GetLogIndexForQuestID(qid)
      if idx then return true, qid end
    end
  end
  return false, nil
end

function FTA.Quest:IsFlaggedCompleted(questIDs)
  local cached, cachedQID = self:AnyQuestCreditCached(questIDs)
  if cached and cachedQID then
    return true, cachedQID
  end

  if not (C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then
    return false, nil
  end

  for qid in IterateQuestIDs(questIDs) do
    if qid and C_QuestLog.IsQuestFlaggedCompleted(qid) then
      self:MarkQuestCredit(qid)
      return true, qid
    end
  end
  return false, nil
end

function FTA.Quest:IsReadyForTurnIn(questIDs)
  if not (C_QuestLog and C_QuestLog.ReadyForTurnIn) then
    return false, nil
  end
  for qid in IterateQuestIDs(questIDs) do
    if qid and C_QuestLog.ReadyForTurnIn(qid) then
      return true, qid
    end
  end
  return false, nil
end

function FTA.Quest:GetObjectiveProgress(questIDs)
  local inLog, activeQID = self:IsInLog(questIDs)
  if not inLog or not activeQID then return nil, nil end
  if not (C_QuestLog and C_QuestLog.GetQuestObjectives) then return nil, nil end

  local objs = C_QuestLog.GetQuestObjectives(activeQID)
  if type(objs) ~= "table" then return nil, nil end

  local cur, tot = 0, 0
  local found = false

  for _, o in ipairs(objs) do
    if o and o.numRequired and o.numFulfilled then
      tot = tot + o.numRequired
      cur = cur + math.min(o.numFulfilled, o.numRequired)
      found = true
    end
  end

  if not found then return nil, nil end
  return cur, tot
end

function FTA.Quest:GetObjectiveDisplay(questIDs)
  local cur, tot = self:GetObjectiveProgress(questIDs)
  if cur and tot and tot > 0 then
    return ("%d/%d"):format(cur, tot)
  end
  return nil
end

function FTA.Quest:GetQuestObjectives(questID)
  if not (C_QuestLog and C_QuestLog.GetQuestObjectives) then return nil end
  return C_QuestLog.GetQuestObjectives(questID)
end

local function FindObjectiveBySelector(objs, seg)
  if type(objs) ~= "table" or type(seg) ~= "table" then return nil end

  if type(seg.objectiveIndex) == "number" then
    return objs[seg.objectiveIndex]
  end

  if type(seg.objectiveText) == "string" and seg.objectiveText ~= "" then
    for _, o in ipairs(objs) do
      if o and type(o.text) == "string" and o.text == seg.objectiveText then
        return o
      end
    end
    return nil
  end

  if type(seg.objectiveTextContains) == "string" and seg.objectiveTextContains ~= "" then
    for _, o in ipairs(objs) do
      if o and type(o.text) == "string" and string.find(o.text, seg.objectiveTextContains, 1, true) then
        return o
      end
    end
    return nil
  end

  return objs[1]
end

local function Clamp(n, lo, hi)
  if n < lo then return lo end
  if n > hi then return hi end
  return n
end

local function TryParsePercentFromText(text)
  if type(text) ~= "string" then return nil end
  local p = text:match("(%d+)%%")
  if not p then return nil end
  local n = tonumber(p)
  if not n then return nil end
  return Clamp(n, 0, 100)
end

function FTA.Quest:IsObjectiveSatisfied(questIDs, seg)
  if type(seg) ~= "table" then return nil end

  local questID = FindActiveQuestIDInLog(self, questIDs)
  if not questID then return nil end

  local objs = self:GetQuestObjectives(questID)
  if type(objs) ~= "table" or #objs == 0 then
    return nil
  end

  local o = FindObjectiveBySelector(objs, seg)
  if not o then
    return nil
  end

  if o.finished ~= nil then
    return o.finished == true
  end

  return nil
end

function FTA.Quest:GetObjectiveCountForSegment(questIDs, seg)
  if type(seg) ~= "table" then return nil, nil end

  local questID = FindActiveQuestIDInLog(self, questIDs)
  if not questID then return nil, nil end

  local objs = self:GetQuestObjectives(questID)
  if type(objs) ~= "table" or #objs == 0 then
    return nil, nil
  end

  local o = FindObjectiveBySelector(objs, seg)
  if not o then
    return nil, nil
  end

  if o.numFulfilled == nil or o.numRequired == nil then
    return nil, nil
  end

  return o.numFulfilled, o.numRequired
end

function FTA.Quest:GetProgressBarPercent(questIDs)
  local questID = FirstQuestID(questIDs)
  if not questID then return nil end

  if C_QuestLog and C_QuestLog.GetQuestProgressBarPercent then
    local pct = C_QuestLog.GetQuestProgressBarPercent(questID)
    if type(pct) == "number" then
      return Clamp(math.floor(pct + 0.5), 0, 100)
    end
  end

  if type(GetQuestProgressBarPercent) == "function" then
    local pct = GetQuestProgressBarPercent(questID)
    if type(pct) == "number" then
      return Clamp(math.floor(pct + 0.5), 0, 100)
    end
  end

  return nil
end

function FTA.Quest:GetObjectiveDisplayForSegment(questIDs, seg)
  if type(seg) ~= "table" then return nil end

  local questID = FindActiveQuestIDInLog(self, questIDs)
  if not questID then return nil end

  local objs = self:GetQuestObjectives(questID)
  if type(objs) ~= "table" or #objs == 0 then
    return nil
  end

  local o = FindObjectiveBySelector(objs, seg)
  if not o then
    return nil
  end

  local textPct = TryParsePercentFromText(o.text)
  if textPct ~= nil then
    return ("%d%%"):format(textPct)
  end

  if type(o.numFulfilled) == "number" and type(o.numRequired) == "number" and o.numRequired > 0 then
    local cur = Clamp(o.numFulfilled, 0, o.numRequired)
    return ("%d/%d"):format(cur, o.numRequired)
  end

  return nil
end

function FTA.Quest:NormalizeCoord(v)
  if type(v) ~= "number" then return v end
  if v > 1.0 then
    return v / 100.0
  end
  return v
end

function FTA.Quest:DebugQuest(questID)
  if not questID then
    FTA:Print("DebugQuest: missing questID")
    return
  end

  local objs = (C_QuestLog and C_QuestLog.GetQuestObjectives) and C_QuestLog.GetQuestObjectives(questID) or nil
  if type(objs) ~= "table" then
    FTA:Print(("Quest %d: no objectives table"):format(questID))
    return
  end

  FTA:Print(("Quest %d objectives: %d"):format(questID, #objs))
  for i, o in ipairs(objs) do
    local txt = (o and o.text) or ""
    local nf = (o and o.numFulfilled)
    local nr = (o and o.numRequired)
    local fin = (o and o.finished)
    FTA:Print(("[%d] %s | %s/%s | finished=%s"):format(i, txt, tostring(nf), tostring(nr), tostring(fin)))
  end
end

FTA.Quest._recentTurnIns = FTA.Quest._recentTurnIns or {}

local TURNIN_CACHE_SECONDS = 120

local function MarkTurnedIn(questID)
  if type(questID) ~= "number" then return end
  FTA.Quest._recentTurnIns[questID] = GetTime()

  FTA.Quest:MarkQuestCredit(questID)
end

local function IsRecentlyTurnedIn(questID)
  local t = FTA.Quest._recentTurnIns[questID]
  if type(t) ~= "number" then return false end
  if (GetTime() - t) > TURNIN_CACHE_SECONDS then
    FTA.Quest._recentTurnIns[questID] = nil
    return false
  end
  return true
end

function FTA.Quest:WasRecentlyTurnedIn(questIDs)
  for qid in IterateQuestIDs(questIDs) do
    if type(qid) == "number" and IsRecentlyTurnedIn(qid) then
      self:MarkQuestCredit(qid)
      return true, qid
    end
  end
  return false, nil
end

do
  local f = CreateFrame("Frame")
  f:RegisterEvent("QUEST_TURNED_IN")
  f:SetScript("OnEvent", function(_, event, questID)
    if event == "QUEST_TURNED_IN" then
      MarkTurnedIn(questID)
    end
  end)
end