local _, FTA = ...

FTA.Events = FTA.Events or {}

local recentlyTurnedIn = {}

local function AutomationEnabled()
  return FTADB
    and FTADB.profile
    and FTADB.profile.automation
    and (FTADB.profile.automation.enableQuestAutomation == true)
end

local function SuppressedByModifier()
  return IsShiftKeyDown and IsShiftKeyDown()
end

local function CanAutomate()
  if not AutomationEnabled() then return false end
  if SuppressedByModifier() then return false end
  if InCombatLockdown and InCombatLockdown() then return false end
  return true
end

local function NudgeStepEngine()
  if FTA.StepEngine and FTA.StepEngine.OnStepChanged then
    FTA.StepEngine:OnStepChanged()
  end
end

local function NormalizeQuestID(questID)
  questID = tonumber(questID)
  if not questID or questID <= 0 then return nil end
  return math.floor(questID)
end

local function MarkRecentlyTurnedIn(questID)
  questID = NormalizeQuestID(questID)
  if not questID then return end

  local now = (GetTime and GetTime()) or 0
  recentlyTurnedIn[questID] = now

  if C_Timer and C_Timer.After then
    C_Timer.After(20, function()
      if recentlyTurnedIn[questID] == now then
        recentlyTurnedIn[questID] = nil
      end
    end)
  end
end

local function WasRecentlyTurnedIn(questID)
  questID = NormalizeQuestID(questID)
  if not questID then return false end

  local t = recentlyTurnedIn[questID]
  if type(t) == "number" then
    local now = (GetTime and GetTime()) or t
    if now - t <= 20 then
      return true
    end
    recentlyTurnedIn[questID] = nil
  end

  if FTA.Quest and FTA.Quest.WasRecentlyTurnedIn then
    if FTA.Quest:WasRecentlyTurnedIn(questID) then
      return true
    end
    if FTA.Quest:WasRecentlyTurnedIn({ questID }) then
      return true
    end
  end

  return false
end

local function IsFlaggedCompleted(questID)
  questID = NormalizeQuestID(questID)
  if not questID then return false end

  if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted and C_QuestLog.IsQuestFlaggedCompleted(questID) then
    return true
  end

  if FTA.Quest and FTA.Quest.IsFlaggedCompleted then
    if FTA.Quest:IsFlaggedCompleted(questID) then
      return true
    end
    if FTA.Quest:IsFlaggedCompleted({ questID }) then
      return true
    end
  end

  return false
end

local function ResetSequenceChainsForRemovedQuest(questID)
  questID = NormalizeQuestID(questID)
  if not questID then return end
  if WasRecentlyTurnedIn(questID) then return end
  if IsFlaggedCompleted(questID) then return end

  if FTA.StepEngine and FTA.StepEngine.ResetActiveSequenceChainsForQuest then
    FTA.StepEngine:ResetActiveSequenceChainsForQuest(questID)
  end
end

local function HandleQuestRemoved(questID)
  questID = NormalizeQuestID(questID)
  if not questID then return end

  if C_Timer and C_Timer.After then
    C_Timer.After(0.1, function()
      ResetSequenceChainsForRemovedQuest(questID)
      NudgeStepEngine()
    end)
  else
    ResetSequenceChainsForRemovedQuest(questID)
    NudgeStepEngine()
  end
end

local function TryAcceptQuest()
  if not CanAutomate() then return end
  if AcceptQuest then
    AcceptQuest()
  end
end

local function TryCompleteQuest()
  if not CanAutomate() then return end
  if IsQuestCompletable and IsQuestCompletable() and CompleteQuest then
    CompleteQuest()
  end
end

local function TryGetQuestReward()
  if not CanAutomate() then return end
  if not (GetNumQuestChoices and GetQuestReward) then return end

  local n = GetNumQuestChoices()
  if n == 0 then
    GetQuestReward(0)
    return
  end

  if n == 1 then
    GetQuestReward(1)
    return
  end
end

local function TryAutoSelectGossip()
  if not CanAutomate() then return end
  if not C_GossipInfo then return end

  local avail = C_GossipInfo.GetAvailableQuests and C_GossipInfo.GetAvailableQuests() or nil
  local active = C_GossipInfo.GetActiveQuests and C_GossipInfo.GetActiveQuests() or nil

  local availCount = (type(avail) == "table") and #avail or 0
  local activeCount = (type(active) == "table") and #active or 0

  if activeCount > 0 and C_GossipInfo.SelectActiveQuest then
    local completableIdx = nil
    local completableN = 0

    for i = 1, activeCount do
      local q = active[i]
      if q and (q.isComplete == true or q.isComplete == 1) then
        completableN = completableN + 1
        completableIdx = i
      end
    end

    if completableN == 1 and completableIdx then
      C_GossipInfo.SelectActiveQuest(completableIdx)
      return
    end
  end

  if availCount == 1 and C_GossipInfo.SelectAvailableQuest then
    C_GossipInfo.SelectAvailableQuest(1)
    return
  end
end

function FTA.Events:Init()
  local f = CreateFrame("Frame")
  self.frame = f

  f:RegisterEvent("QUEST_ACCEPTED")
  f:RegisterEvent("QUEST_TURNED_IN")
  f:RegisterEvent("QUEST_REMOVED")
  f:RegisterEvent("QUEST_LOG_UPDATE")

  f:RegisterEvent("QUEST_DETAIL")
  f:RegisterEvent("QUEST_PROGRESS")
  f:RegisterEvent("QUEST_COMPLETE")
  f:RegisterEvent("GOSSIP_SHOW")
  f:RegisterEvent("QUEST_GREETING")

  f:SetScript("OnEvent", function(_, event, ...)
    if event == "QUEST_TURNED_IN" then
      MarkRecentlyTurnedIn(...)
      NudgeStepEngine()
      return
    end

    if event == "QUEST_REMOVED" then
      HandleQuestRemoved(...)
      return
    end

    if event == "QUEST_ACCEPTED"
      or event == "QUEST_LOG_UPDATE"
    then
      NudgeStepEngine()
      return
    end

    if not AutomationEnabled() then return end

    if event == "GOSSIP_SHOW" then
      TryAutoSelectGossip()
      return
    end

    if event == "QUEST_GREETING" then
      return
    end

    if event == "QUEST_DETAIL" then
      TryAcceptQuest()
      return
    end

    if event == "QUEST_PROGRESS" then
      TryCompleteQuest()
      return
    end

    if event == "QUEST_COMPLETE" then
      TryGetQuestReward()
      return
    end
  end)
end
