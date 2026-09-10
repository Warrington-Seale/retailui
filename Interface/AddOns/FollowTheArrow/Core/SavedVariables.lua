local _, FTA = ...

local function DeepCopyDefaults(dst, src)
  for k, v in pairs(src) do
    if type(v) == "table" then
      if type(dst[k]) ~= "table" then dst[k] = {} end
      DeepCopyDefaults(dst[k], v)
    elseif dst[k] == nil then
      dst[k] = v
    end
  end
end

local DEFAULT_DB = {
  profile = {
    ui = {
      scale = 1.0,
      showDistance = true,
      showNotesInCurrent = true,
      showNotesInUpcoming = false,

      point = "CENTER",
      relPoint = "CENTER",
      x = 0,
      y = 0,
      width = 360,
      height = 420,

      arrow = {
        point = "CENTER",
        relPoint = "CENTER",
        x = 0,
        y = 120,
      },
    },
  },
}

local DEFAULT_CHAR_DB = {
  firstLogin = true,

  progress = {
    activeModuleId = "MIDNIGHT_SUNWELL_INTRO",
    stepIndexByModule = {},
    manualSegmentState = {},
  },

  completion = {
    questCredits = {},
    moduleCredits = {},
  },
}

function FTA:SavedVars_Init()
  FTADB = FTADB or {}
  FTACharDB = FTACharDB or {}

  DeepCopyDefaults(FTADB, DEFAULT_DB)
  DeepCopyDefaults(FTACharDB, DEFAULT_CHAR_DB)

  FTACharDB.progress = FTACharDB.progress or {}
  FTACharDB.progress.stepIndexByModule = FTACharDB.progress.stepIndexByModule or {}
  FTACharDB.progress.manualSegmentState = FTACharDB.progress.manualSegmentState or {}

  FTACharDB.completion = FTACharDB.completion or {}
  FTACharDB.completion.questCredits = FTACharDB.completion.questCredits or {}
  FTACharDB.completion.moduleCredits = FTACharDB.completion.moduleCredits or {}

  local moduleId = FTACharDB.progress.activeModuleId
  if moduleId and FTACharDB.progress.stepIndexByModule[moduleId] == nil then
    FTACharDB.progress.stepIndexByModule[moduleId] = 1
  end
end