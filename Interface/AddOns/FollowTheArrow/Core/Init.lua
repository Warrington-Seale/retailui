local ADDON_NAME, FTA = ...

FTA.ADDON_NAME = ADDON_NAME
FTA.VERSION = "0.1"

function FTA:Print(msg)
  DEFAULT_CHAT_FRAME:AddMessage(("|cff7fd3ffFollow the Arrow|r: %s"):format(tostring(msg)))
end

local function GetPlayerMapChain()
  local out = {}
  if not (C_Map and C_Map.GetBestMapForUnit) then return out end

  local cur = C_Map.GetBestMapForUnit("player")
  local safety = 0

  while cur and safety < 25 do
    safety = safety + 1
    out[#out + 1] = cur

    if not (C_Map.GetMapInfo) then break end
    local info = C_Map.GetMapInfo(cur)
    local parent = info and info.parentMapID
    if not parent or parent == 0 then break end
    cur = parent
  end

  return out
end

local function CandidateSetFrom(value)
  local set = {}

  if type(value) == "number" then
    set[value] = true
    return set
  end

  if type(value) == "table" then
    local n = #value
    if n > 0 then
      for i = 1, n do
        local id = tonumber(value[i])
        if id then set[id] = true end
      end
      return set
    end

    for k, _ in pairs(value) do
      local id = tonumber(k)
      if id then set[id] = true end
    end
  end

  return set
end

local function PlayerIsInCandidates(candidates)
  local set = CandidateSetFrom(candidates)
  if not set then return false end

  local chain = GetPlayerMapChain()

  if #chain == 0 then
    return true
  end

  for _, mapID in ipairs(chain) do
    if set[mapID] then
      return true, mapID
    end
  end
  return false
end

local refreshPending = false

local function CurrentStepIsCompleted()
  if not (FTA.StepEngine and FTA.StepEngine.GetCurrentStep) then return false end
  local _, _, step = FTA.StepEngine:GetCurrentStep()
  if not step then return false end
  if not (FTA.Resolve and FTA.Resolve.IsStepSatisfied) then return false end
  return FTA.Resolve:IsStepSatisfied(step) == true
end

local function NudgeArrowNow()
  if CurrentStepIsCompleted() then
    return
  end
  if FTA.Waypoint then
    if type(FTA.Waypoint.UpdateToCurrentStep) == "function" then
      FTA.Waypoint:UpdateToCurrentStep()
    elseif type(FTA.Waypoint.Refresh) == "function" then
      FTA.Waypoint:Refresh()
    end
  end

  if FTA.GuideArrow then
    if type(FTA.GuideArrow.UpdateToCurrentStep) == "function" then
      FTA.GuideArrow:UpdateToCurrentStep()
    elseif type(FTA.GuideArrow.Recalc) == "function" then
      FTA.GuideArrow:Recalc()
    elseif type(FTA.GuideArrow.ForceUpdate) == "function" then
      FTA.GuideArrow:ForceUpdate()
    elseif type(FTA.GuideArrow.Update) == "function" then
      FTA.GuideArrow:Update()
    elseif type(FTA.GuideArrow.Refresh) == "function" then
      FTA.GuideArrow:Refresh()
    elseif type(FTA.GuideArrow.RequestRefresh) == "function" then
      FTA.GuideArrow:RequestRefresh()
    elseif type(FTA.GuideArrow.SetDirty) == "function" then
      FTA.GuideArrow:SetDirty(true)
    end
  end
end

local function VoldemortEmote(newLevel)
  if not (FTADB and FTADB.profile and FTADB.profile.general and FTADB.profile.general.voldemortMode) then
    return
  end

  local lvl = tonumber(newLevel)

  if not lvl or lvl <= 0 then
    C_Timer.After(0, function()
      if not (FTADB and FTADB.profile and FTADB.profile.general and FTADB.profile.general.voldemortMode) then
        return
      end

      local l2 = UnitLevel("player") or 0
      if l2 > 0 then
        SendChatMessage(("has reached level %d without needing to use a paid addon!"):format(l2), "EMOTE")
      end
    end)
    return
  end

  SendChatMessage(("has reached level %d without needing to use a paid addon!"):format(lvl), "EMOTE")
end

function FTA:FullRefresh(reason)
  if refreshPending then return end
  refreshPending = true

  C_Timer.After(0, function()
    refreshPending = false

    if FTA.StepEngine and FTA.StepEngine.SyncForward then
      FTA.StepEngine:SyncForward()
    end

    local done = CurrentStepIsCompleted()

    if done then
      if FTA.GuideArrow and FTA.GuideArrow.SetEnabled then
        FTA.GuideArrow:SetEnabled(false)
      end

      if FTA.UI and FTA.UI.Refresh then
        FTA.UI:Refresh()
      end

      return
    end

    if FTA.Waypoint and FTA.Waypoint.UpdateToCurrentStep then
      FTA.Waypoint:UpdateToCurrentStep()
    end

    if FTA.UI and FTA.UI.Refresh then
      FTA.UI:Refresh()
    end

    C_Timer.After(0, function()
      NudgeArrowNow()
    end)
  end)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function(_, event, arg1)
  if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
    if FTA.SavedVars_Init then
      FTA:SavedVars_Init()
    end

    if FTA.Settings_Init then
      FTA:Settings_Init()
    end

    if FTA.MinimapButton_Init then
      FTA:MinimapButton_Init()
    end

    if FTA.StepEngine_Init then
      FTA:StepEngine_Init()
    end
    return
  end

  if event == "PLAYER_LOGIN" then
    if FTA.UI_Init then
      FTA:UI_Init()
    end
    if FTA.Events and FTA.Events.Init then
      FTA.Events:Init()
    end
    if FTA.Slash_Init then
      FTA:Slash_Init()
    end

    if FTA.GuideArrow and FTA.GuideArrow.Init then
      FTA.GuideArrow:Init()
    end

    if FTADB and FTADB.profile and FTADB.profile.general and FTADB.profile.general.hideArrow == true then
      if FTA.GuideArrow and FTA.GuideArrow.SetEnabled then
        FTA.GuideArrow:SetEnabled(false)
      end
    end

    local showOnLogin = true
    if FTADB and FTADB.profile and FTADB.profile.general then
      if FTADB.profile.general.hideOnLogin == true then
        showOnLogin = false
      end
      if FTADB.profile.general.hideMainWindow == true then
        showOnLogin = false
      end
    end

    if FTA.UI and FTA.UI.ToggleMain then
      FTA.UI:ToggleMain(showOnLogin)
    end

    eventFrame:RegisterEvent("QUEST_LOG_UPDATE")
    eventFrame:RegisterEvent("QUEST_ACCEPTED")
    eventFrame:RegisterEvent("QUEST_TURNED_IN")
    eventFrame:RegisterEvent("QUEST_WATCH_UPDATE")
    eventFrame:RegisterEvent("SUPER_TRACKING_CHANGED")
    eventFrame:RegisterEvent("QUEST_REMOVED")

    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:RegisterEvent("LOADING_SCREEN_DISABLED")

    eventFrame:RegisterEvent("ZONE_CHANGED")
    eventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
    eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

    eventFrame:RegisterEvent("NEW_WMO_CHUNK")
    eventFrame:RegisterEvent("AREA_POIS_UPDATED")

    eventFrame:RegisterEvent("PLAYER_CONTROL_GAINED")

    eventFrame:RegisterEvent("PLAYER_LEVEL_UP")

    FTA:FullRefresh("PLAYER_LOGIN")
    return
  end

  if event == "PLAYER_LEVEL_UP" then
    VoldemortEmote(arg1)
    return
  end

  if event == "QUEST_LOG_UPDATE"
    or event == "QUEST_ACCEPTED"
    or event == "QUEST_TURNED_IN"
    or event == "QUEST_WATCH_UPDATE"
    or event == "SUPER_TRACKING_CHANGED"
    or event == "QUEST_REMOVED"

    or event == "PLAYER_ENTERING_WORLD"
    or event == "LOADING_SCREEN_DISABLED"
    or event == "ZONE_CHANGED"
    or event == "ZONE_CHANGED_INDOORS"
    or event == "ZONE_CHANGED_NEW_AREA"
    or event == "NEW_WMO_CHUNK"
    or event == "AREA_POIS_UPDATED"
    or event == "PLAYER_CONTROL_GAINED"
  then
    FTA:FullRefresh(event)
  end
end)

function FTA:OnArrowArrive(p)
  if type(p) ~= "table" or p.mode ~= "WAYPOINT_CHAIN" then return end
  if not p.key then return end

  if FTA.Quest and p.questIDs then
    if (FTA.Quest.IsFlaggedCompleted and FTA.Quest:IsFlaggedCompleted(p.questIDs))
      or (FTA.Quest.IsReadyForTurnIn and FTA.Quest:IsReadyForTurnIn(p.questIDs))
    then
      FTACharDB = FTACharDB or {}
      FTACharDB.progress = FTACharDB.progress or {}
      FTACharDB.progress.chainIndex = FTACharDB.progress.chainIndex or {}
      FTACharDB.progress.chainIndex[p.key] = nil

      if FTA.StepEngine and FTA.StepEngine.SyncNow then
        FTA.StepEngine:SyncNow(10)
      elseif FTA.StepEngine and FTA.StepEngine.SyncForward then
        FTA.StepEngine:SyncForward()
      end

      FTA:FullRefresh("OnArrowArrive:questDone")
      return
    end
  end

  FTACharDB = FTACharDB or {}
  FTACharDB.progress = FTACharDB.progress or {}
  FTACharDB.progress.chainIndex = FTACharDB.progress.chainIndex or {}
  local idx = tonumber(p.idx) or 1
  FTACharDB.progress.chainIndex[p.key] = math.floor(idx) + 1

  FTA:FullRefresh("OnArrowArrive:advance")
end