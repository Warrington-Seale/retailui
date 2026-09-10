local _, FTA = ...

FTA.Quest = FTA.Quest or {}

local function ShowHelp()
  FTA:Print("Commands:")
  FTA:Print("/fta - toggle window")
  FTA:Print("/fta sync - re-scan quests and advance the guide until stable")
  FTA:Print("/fta show - show window")
  FTA:Print("/fta hide - hide window")
  FTA:Print("/fta reset - reset window position/size")
  FTA:Print("/fta status - show current module/step")
  FTA:Print("/fta next - next step")
  FTA:Print("/fta prev - previous step")
  FTA:Print("/fta modules - list loaded modules")
  FTA:Print("/fta module <id> - set active module (case-insensitive)")
  FTA:Print("/fta qdbg <questID> - debug quest objectives (prints objective text/values)")
  FTA:Print("/fta prog <questID> - debug quest progress bar percent")
  FTA:Print("/followthearrow - same as /fta")
end

local function FindModuleIdCaseInsensitive(inputId)
  if not (inputId and FTA.Modules) then return nil end
  local needle = inputId:lower()
  for id, _ in pairs(FTA.Modules) do
    if type(id) == "string" and id:lower() == needle then
      return id
    end
  end
  return nil
end

local function ListModules()
  if not FTA.Modules then
    FTA:Print("No modules loaded.")
    return
  end
  FTA:Print("Loaded modules:")
  local any = false
  for id, mod in pairs(FTA.Modules) do
    any = true
    local title = (type(mod) == "table" and (mod.title or mod.name)) or ""
    if title ~= "" then
      FTA:Print((" - %s (%s)"):format(id, title))
    else
      FTA:Print((" - %s"):format(id))
    end
  end
  if not any then
    FTA:Print(" (none)")
  end
end

local function ShowStatus()
  local moduleId = FTACharDB and FTACharDB.progress and FTACharDB.progress.activeModuleId or nil
  if not moduleId then
    FTA:Print("No active module set.")
    return
  end

  local mod = FTA.StepEngine and FTA.StepEngine.GetModule and FTA.StepEngine:GetModule(moduleId) or nil
  local idx = FTA.StepEngine and FTA.StepEngine.GetStepIndex and FTA.StepEngine:GetStepIndex(moduleId) or nil
  local total = (mod and mod.steps and #mod.steps) or 0
  local title = (mod and (mod.title or mod.name)) or ""

  if title ~= "" then
    FTA:Print(("Module: %s (%s)"):format(moduleId, title))
  else
    FTA:Print(("Module: %s"):format(moduleId))
  end
  if idx then
    FTA:Print(("Step: %d / %d"):format(idx, total))
  end
end

local function DebugQuestProgress(rawQuestID)
  local questID = tonumber(rawQuestID)
  if not questID then
    FTA:Print("Usage: /fta prog <questID>")
    return
  end

  FTA:Print(("Quest progress debug: %d"):format(questID))

  if type(GetQuestProgressBarPercent) == "function" then
    local percent = GetQuestProgressBarPercent(questID)
    FTA:Print(("GetQuestProgressBarPercent: %s (%s)"):format(tostring(percent), type(percent)))
  else
    FTA:Print("GetQuestProgressBarPercent: unavailable")
  end

  if type(C_QuestLog) == "table" and type(C_QuestLog.GetQuestObjectives) == "function" then
    local objectives = C_QuestLog.GetQuestObjectives(questID)
    FTA:Print(("C_QuestLog.GetQuestObjectives: %s"):format(objectives and #objectives or "nil"))

    if type(objectives) == "table" then
      for i, obj in ipairs(objectives) do
        FTA:Print(("Objective %d: text=%s finished=%s fulfilled=%s required=%s type=%s"):format(
          i,
          tostring(obj.text),
          tostring(obj.finished),
          tostring(obj.numFulfilled),
          tostring(obj.numRequired),
          tostring(obj.type)
        ))
      end
    end
  else
    FTA:Print("C_QuestLog.GetQuestObjectives: unavailable")
  end
end

local function Handle(raw)
  raw = raw or ""
  raw = raw:gsub("^%s+", ""):gsub("%s+$", "")

  if raw == "" then
    if FTA.UI and FTA.UI.ToggleMain then
      FTA.UI:ToggleMain()
    else
      FTA:Print("UI not ready yet.")
    end
    return
  end

  local cmd, rest = raw:match("^(%S+)%s*(.-)$")
  cmd = (cmd or ""):lower()
  rest = (rest or ""):gsub("^%s+", ""):gsub("%s+$", "")

  if cmd == "help" or cmd == "options" then ShowHelp(); return end
  if cmd == "show" then if FTA.UI then FTA.UI:ToggleMain(true) end; return end
  if cmd == "hide" then if FTA.UI then FTA.UI:ToggleMain(false) end; return end
  if cmd == "reset" then if FTA.UI and FTA.UI.ResetMain then FTA.UI:ResetMain(); FTA:Print("Window reset.") end; return end
  if cmd == "status" then ShowStatus(); return end
  if cmd == "next" then if FTA.StepEngine then FTA.StepEngine:NextStep() end; return end
  if cmd == "prev" then if FTA.StepEngine then FTA.StepEngine:PrevStep() end; return end
  if cmd == "modules" then ListModules(); return end

  if cmd == "qdbg" then
    if rest == "" then
      FTA:Print("Usage: /fta qdbg <questID>")
      return
    end
    if FTA.Quest and FTA.Quest.DebugQuest then
      FTA.Quest:DebugQuest(rest)
    else
      FTA:Print("Quest debug not available (DebugQuest not loaded).")
      FTA:Print("Make sure DebugQuest() is defined in QuestState.lua and that file is in the .toc before SlashCommands.lua.")
    end
    return
  end

  if cmd == "prog" then
    DebugQuestProgress(rest)
    return
  end

  if cmd == "sync" then
    if FTA.StepEngine and FTA.StepEngine.SyncNow then
      FTA.StepEngine:SyncNow(25)
      FTA:Print("Synced.")
    end
    return
  end

  if cmd == "module" then
    if rest == "" then
      FTA:Print("Usage: /fta module <id>  (try /fta modules)")
      return
    end

    local realId = FindModuleIdCaseInsensitive(rest)
    if not realId then
      FTA:Print("Unknown module: " .. rest)
      FTA:Print("Try: /fta modules")
      return
    end

    local ok = FTA.StepEngine and FTA.StepEngine.SetActiveModule and FTA.StepEngine:SetActiveModule(realId)
    if ok then
      FTA:Print("Active module set to: " .. realId)
    end
    return
  end

  ShowHelp()
end

function FTA:Slash_Init()
  SLASH_FTA1 = "/fta"
  SlashCmdList["FTA"] = Handle

  SLASH_FOLLOWTHEARROW1 = "/followthearrow"
  SlashCmdList["FOLLOWTHEARROW"] = Handle
end
