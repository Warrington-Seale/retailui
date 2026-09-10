-- Raid auto-marker options ported from the post-2.76 main branch.

local MerfinPlus = LibStub("AceAddon-3.0"):GetAddon("MerfinPlus")
-- Auto-Marker options are rebuilt after a runtime locale change; resolve every
-- standard label from the active UI locale instead of the startup locale.
local L = setmetatable({}, {
  __index = function(_, key)
    return MerfinPlus:T(key)
  end,
})
local AceSerializer = LibStub("AceSerializer-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

MerfinPlus.AutoMarkerDefaults = MerfinPlus.AutoMarkerDefaults or {}
MerfinPlus.AutoMarkerDefaults.mouseover = MerfinPlus.AutoMarkerDefaults.mouseover or 4
MerfinPlus.AutoMarkerDefaults.instances = MerfinPlus.AutoMarkerDefaults.instances or {}
MerfinPlus.AutoMarkerDefaults.mechanics = MerfinPlus.AutoMarkerDefaults.mechanics or {
  icebolt = { enable = true, marks = { 8 } },
  sleep = { enable = true, marks = { 1, 2, 3 } },
  azgalorDoom = { enable = true, marks = { 8 } },
  archimondeAirBurst = { enable = true, marks = { 8 } },
  najentusImpalingSpine = { enable = true, marks = { 8 } },
  supremusChase = { enable = true, marks = { 8 } },
  teronCrushingShadows = { enable = true, marks = { 1, 2, 3, 4, 5 } },
  gurtoggFelRage = { enable = true, marks = { 8 } },
  teronShadowOfDeath = { enable = true, marks = { 8 } },
  friendlyMarkerTest = { enable = true, marks = { 8 } },
  reliquarySpite = { enable = true, marks = { 1, 2, 3 } },
  reliquarySoulDrain = { enable = true, marks = { 1, 2, 3, 4, 5 } },
  fattalAttraction = { enable = true, marks = { 1, 2, 3 } },
  deadlyPoison = { enable = true, marks = { 8 } },
  parasite = { enable = true, marks = { 8 } },
}

MerfinPlus.FriendlyMarkerCatalog = MerfinPlus.FriendlyMarkerCatalog or {
  {
    key = "icebolt", name = "Icebolt", spellID = 31249,
    raid = "IID534", raidName = "Hyjal Summit", boss = "618", bossName = "Rage Winterchill",
    maxMarks = 1,
  },
  {
    key = "sleep", name = "Sleep", spellID = 31298,
    raid = "IID534", raidName = "Hyjal Summit", boss = "619", bossName = "Anetheron",
    maxMarks = 3,
  },
  {
    key = "azgalorDoom", name = "Doom", spellID = 31347,
    raid = "IID534", raidName = "Hyjal Summit", boss = "621", bossName = "Azgalor",
    maxMarks = 1,
  },
  {
    key = "archimondeAirBurst", name = "Air Burst", spellID = 32014,
    raid = "IID534", raidName = "Hyjal Summit", boss = "622", bossName = "Archimonde",
    maxMarks = 1,
  },
  {
    key = "najentusImpalingSpine", name = "Impaling Spine", icon = 135855,
    raid = "IID564", raidName = "Black Temple", boss = "601", bossName = "High Warlord Naj'entus",
    spellID = 39837, maxMarks = 1,
  },
  {
    key = "supremusChase", name = "Chase Target", icon = 132284,
    raid = "IID564", raidName = "Black Temple", boss = "602", bossName = "Supremus",
    applyEvent = "CHAGE_TARGET", clearEvent = "PHASE_TANK", maxMarks = 1,
  },
  {
    key = "teronCrushingShadows", name = "Crushing Shadows", spellID = 40243,
    raid = "IID564", raidName = "Black Temple", boss = "604", bossName = "Teron Gorefiend",
    maxMarks = 5,
  },
  {
    key = "teronShadowOfDeath", name = "Shadow of Death", icon = 135752,
    raid = "IID564", raidName = "Black Temple", boss = "604", bossName = "Teron Gorefiend",
    spellID = 40251, maxMarks = 1,
  },
  {
    key = "gurtoggFelRage", name = "Fel Rage", icon = 135791,
    raid = "IID564", raidName = "Black Temple", boss = "605", bossName = "Gurtogg Bloodboil",
    spellID = 40604, maxMarks = 1,
  },
  {
    key = "friendlyMarkerTest", name = "Test: 13165", spellID = 13165,
    raid = "IID564", raidName = "Black Temple", boss = "test", bossName = "Test",
    maxMarks = 1,
  },
  {
    key = "reliquarySpite", name = "Spite", spellID = 41376,
    raid = "IID564", raidName = "Black Temple", boss = "606", bossName = "Reliquary of Souls",
    maxMarks = 3,
  },
  {
    key = "reliquarySoulDrain", name = "Soul Drain", spellID = 41303,
    raid = "IID564", raidName = "Black Temple", boss = "606", bossName = "Reliquary of Souls",
    maxMarks = 5,
  },
  {
    key = "fattalAttraction", name = "Fatal Attraction", spellID = 41001,
    raid = "IID564", raidName = "Black Temple", boss = "607", bossName = "Mother Shahraz",
    maxMarks = 3,
  },
  {
    key = "deadlyPoison", name = "Deadly Poison", spellID = 41485,
    raid = "IID564", raidName = "Black Temple", boss = "608", bossName = "Illidari Council",
    maxMarks = 1,
  },
  {
    key = "parasite", name = "Parasitic Shadowfiend", spellID = 41917,
    raid = "IID564", raidName = "Black Temple", boss = "609", bossName = "Illidan Stormrage",
    maxMarks = 1,
  },
}

local markerValues = {
  [0] = NONE or "None",
  [1] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:16|t",
  [2] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:16|t",
  [3] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:16|t",
  [4] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:16|t",
  [5] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:16|t",
  [6] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:16|t",
  [7] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:16|t",
  [8] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:16|t",
}

local selectedInstance = "IID564"
local selectedSection = {}
local selectedFriendlyRaid = "IID564"
local selectedFriendlyBoss = {}
local transferState = { text = "", status = "" }

local function EnsureDB()
  local profile = MerfinPlus.db.profile
  profile.raidAutoMarker = profile.raidAutoMarker or {
    mouseover = MerfinPlus.AutoMarkerDefaults.mouseover or 4,
    instances = {},
    mechanics = {},
  }
  profile.raidAutoMarker.instances = profile.raidAutoMarker.instances or {}
  profile.raidAutoMarker.mechanics = profile.raidAutoMarker.mechanics or {}
  return profile.raidAutoMarker
end

local function NotifyChanged()
  if Merfin and Merfin.NotifyRaidAutoMarkerConfigChanged then
    Merfin.NotifyRaidAutoMarkerConfigChanged()
  end
end

local function EnemySettings(instanceKey, npcID)
  local db = EnsureDB()
  db.instances[instanceKey] = db.instances[instanceKey] or {}
  if not db.instances[instanceKey][npcID] then
    local defaults = MerfinPlus.AutoMarkerDefaults.instances
      and MerfinPlus.AutoMarkerDefaults.instances[instanceKey]
      and MerfinPlus.AutoMarkerDefaults.instances[instanceKey][npcID] or {}
    local marks = {}
    for index = 1, 8 do marks[index] = defaults.marks and defaults.marks[index] or nil end
    db.instances[instanceKey][npcID] = {
      enable = defaults.enable ~= false,
      priority = tonumber(defaults.priority) or 1,
      marks = marks,
    }
  end
  local settings = db.instances[instanceKey][npcID]
  settings.marks = settings.marks or {}
  return settings
end

local function FriendlySettings(key)
  local db = EnsureDB()
  local defaults = MerfinPlus.AutoMarkerDefaults.mechanics[key] or {}
  if not db.mechanics[key] then
    local marks = {}
    for index = 1, 8 do marks[index] = defaults.marks and defaults.marks[index] or nil end
    db.mechanics[key] = { enable = defaults.enable ~= false, marks = marks }
  end
  db.mechanics[key].marks = db.mechanics[key].marks or {}
  return db.mechanics[key], defaults
end

local function CurrentCatalog()
  return MerfinPlus.AutoMarkerCatalog and MerfinPlus.AutoMarkerCatalog[selectedInstance]
end

local function CurrentSection()
  local catalog = CurrentCatalog()
  if not catalog or not catalog.sections or not catalog.sections[1] then return end
  selectedSection[selectedInstance] = selectedSection[selectedInstance] or catalog.sections[1].key
  return selectedSection[selectedInstance]
end

local function SpellTexture(spellID)
  if C_Spell and C_Spell.GetSpellTexture then return C_Spell.GetSpellTexture(spellID) end
  if GetSpellTexture then return GetSpellTexture(spellID) end
end

local function BuildEnemyOptions()
  local args = {
    mouseoverDescription = {
      type = "description", order = 1, width = "full",
      name = L["Select how mouseover marking is activated."],
    },
    mouseover = {
      type = "select", name = L["Mouseover Marking"], order = 2, width = 1.5,
      values = { [1] = L["Always"], [2] = "Alt", [3] = "Ctrl", [4] = "Shift", [5] = L["Disabled"] },
      get = function() return EnsureDB().mouseover or 4 end,
      set = function(_, value) EnsureDB().mouseover = value; NotifyChanged() end,
    },
    raid = {
      type = "select", name = L["Raid"], order = 3, width = 1.5,
      values = function()
        local values = {}
        for key, data in pairs(MerfinPlus.AutoMarkerCatalog or {}) do
          values[key] = MerfinPlus:GetLocalizedRaidName(key, data.name)
        end
        return values
      end,
      get = function() return selectedInstance end,
      set = function(_, value)
        selectedInstance = value
        CurrentSection()
        AceConfigRegistry:NotifyChange("MerfinPlus_RaidPack")
      end,
    },
    subzone = {
      type = "select", name = L["Subzone"], order = 4, width = 1.5,
      values = function()
        local values = {}
        for _, section in ipairs(CurrentCatalog() and CurrentCatalog().sections or {}) do
          values[section.key] = MerfinPlus:LocalizeKnownValue(section.name)
        end
        return values
      end,
      sorting = function()
        local order = {}
        for _, section in ipairs(CurrentCatalog() and CurrentCatalog().sections or {}) do
          order[#order + 1] = section.key
        end
        return order
      end,
      get = CurrentSection,
      set = function(_, value)
        selectedSection[selectedInstance] = value
        AceConfigRegistry:NotifyChange("MerfinPlus_RaidPack")
      end,
    },
    sectionHeader = {
      type = "header", order = 5,
      name = function()
        for _, section in ipairs(CurrentCatalog() and CurrentCatalog().sections or {}) do
          if section.key == CurrentSection() then
            return MerfinPlus:LocalizeKnownValue(section.name)
          end
        end
        return L["Enemy"]
      end,
    },
  }

  local rowOrder = 10
  for instanceKey, catalog in pairs(MerfinPlus.AutoMarkerCatalog or {}) do
    local mobs = {}
    for _, mob in ipairs(catalog.mobs or {}) do mobs[mob.npc] = mob end
    for _, section in ipairs(catalog.sections or {}) do
      for _, npcID in ipairs(section.npcs or {}) do
        local rowInstance, rowSection, rowNpc = instanceKey, section.key, npcID
        local mob = mobs[npcID]
        local defaults = MerfinPlus.AutoMarkerDefaults.instances
          and MerfinPlus.AutoMarkerDefaults.instances[rowInstance]
          and MerfinPlus.AutoMarkerDefaults.instances[rowInstance][rowNpc] or {}
        local markerCount = math.max(1, defaults.marks and #defaults.marks or 0)
        local rowArgs = {
          enable = {
            type = "toggle",
            name = function()
              return MerfinPlus:GetLocalizedEnemyName(rowNpc, mob and mob.name or tostring(rowNpc))
            end,
            order = 1, width = 1.25,
            get = function() return EnemySettings(rowInstance, rowNpc).enable ~= false end,
            set = function(_, value) EnemySettings(rowInstance, rowNpc).enable = value; NotifyChanged() end,
          },
          priority = {
            type = "range", name = L["Priority"], order = 2, width = 0.65,
            min = 1, max = 20, step = 1,
            get = function() return tonumber(EnemySettings(rowInstance, rowNpc).priority) or 1 end,
            set = function(_, value) EnemySettings(rowInstance, rowNpc).priority = value; NotifyChanged() end,
          },
        }
        for markerIndex = 1, markerCount do
          local index = markerIndex
          rowArgs["mark" .. index] = {
            type = "select", name = "", order = 2 + index, width = 0.4,
            values = markerValues,
            get = function()
              local mark = tonumber(EnemySettings(rowInstance, rowNpc).marks[index])
              return mark and mark >= 1 and mark <= 8 and mark or 0
            end,
            set = function(_, value)
              EnemySettings(rowInstance, rowNpc).marks[index] = value ~= 0 and value or nil
              NotifyChanged()
            end,
          }
        end
        rowOrder = rowOrder + 1
        args["enemy_" .. rowInstance .. "_" .. rowNpc] = {
          type = "group", name = "", inline = true, order = rowOrder,
          hidden = function() return selectedInstance ~= rowInstance or CurrentSection() ~= rowSection end,
          args = rowArgs,
        }
      end
    end
  end
  return args
end

-- AceConfig otherwise snapshots string names while the option tree is built.
-- Keep every label reactive to a later MerfinPlus UI-language change.
local function MakeOptionNamesDynamic(option)
  if type(option) ~= "table" then
    return option
  end
  if type(option.name) == "string" then
    local staticName = option.name
    option.name = function()
      return MerfinPlus:LocalizeKnownValue(staticName)
    end
  end
  for _, child in pairs(option.args or {}) do
    MakeOptionNamesDynamic(child)
  end
  return option
end

local function FriendlyBosses()
  local bosses, seen = {}, {}
  for _, mechanic in ipairs(MerfinPlus.FriendlyMarkerCatalog or {}) do
    if mechanic.raid == selectedFriendlyRaid and not seen[mechanic.boss] then
      seen[mechanic.boss] = true
      bosses[#bosses + 1] = { key = mechanic.boss, name = mechanic.bossName }
    end
  end
  table.sort(bosses, function(a, b) return (tonumber(a.key) or math.huge) < (tonumber(b.key) or math.huge) end)
  return bosses
end

local function CurrentFriendlyBoss()
  local current = selectedFriendlyBoss[selectedFriendlyRaid]
  for _, boss in ipairs(FriendlyBosses()) do
    if boss.key == current then return current end
  end
  current = FriendlyBosses()[1] and FriendlyBosses()[1].key
  selectedFriendlyBoss[selectedFriendlyRaid] = current
  return current
end

local function BuildFriendlyOptions()
  local args = {
    description = {
      type = "description", order = 1, width = "full",
      name = L["Configure raid markers assigned to players targeted by boss mechanics."],
    },
    raid = {
      type = "select", name = L["Raid"], order = 2, width = 1.5,
      values = function()
        local values = {}
        for _, mechanic in ipairs(MerfinPlus.FriendlyMarkerCatalog or {}) do
          values[mechanic.raid] = MerfinPlus:GetLocalizedRaidName(mechanic.raid, mechanic.raidName)
        end
        return values
      end,
      get = function() return selectedFriendlyRaid end,
      set = function(_, value)
        selectedFriendlyRaid = value
        CurrentFriendlyBoss()
        AceConfigRegistry:NotifyChange("MerfinPlus_RaidPack")
      end,
    },
    boss = {
      type = "select", name = L["Boss"], order = 3, width = 1.5,
      values = function()
        local values = {}
        for _, boss in ipairs(FriendlyBosses()) do
          values[boss.key] = MerfinPlus:GetLocalizedBossName(
            boss.localeID or "encounter:" .. tostring(boss.key),
            boss.name
          )
        end
        return values
      end,
      get = CurrentFriendlyBoss,
      set = function(_, value)
        selectedFriendlyBoss[selectedFriendlyRaid] = value
        AceConfigRegistry:NotifyChange("MerfinPlus_RaidPack")
      end,
    },
  }

  for mechanicIndex, mechanic in ipairs(MerfinPlus.FriendlyMarkerCatalog or {}) do
    local row = mechanic
    local rowArgs = {
      enable = {
        type = "toggle", order = 1, width = 1.3,
        name = function()
          local icon = row.icon or row.spellID and SpellTexture(row.spellID) or 134400
          return ("|T%s:16:16|t %s"):format(
            icon,
            MerfinPlus:GetLocalizedMechanicName(row.key, row.name)
          )
        end,
        get = function()
          local settings, defaults = FriendlySettings(row.key)
          return settings.enable == nil and defaults.enable ~= false or settings.enable
        end,
        set = function(_, value) FriendlySettings(row.key).enable = value; NotifyChanged() end,
      },
    }
    for markerIndex = 1, row.maxMarks do
      local index = markerIndex
      rowArgs["mark" .. index] = {
        type = "select", name = "", order = 1 + index, width = 0.4,
        values = markerValues,
        get = function()
          local settings, defaults = FriendlySettings(row.key)
          local mark = tonumber(settings.marks[index]) or tonumber(defaults.marks and defaults.marks[index])
          return mark and mark >= 1 and mark <= 8 and mark or 0
        end,
        set = function(_, value)
          FriendlySettings(row.key).marks[index] = tonumber(value) or 0
          NotifyChanged()
        end,
      }
    end
    args["mechanic_" .. row.key] = {
      type = "group", name = "", inline = true, order = 10 + mechanicIndex,
      hidden = function() return selectedFriendlyRaid ~= row.raid or CurrentFriendlyBoss() ~= row.boss end,
      args = rowArgs,
    }
  end
  return args
end

local function CopyMarks(source)
  local marks = {}
  for index = 1, 8 do
    local mark = source and tonumber(source[index])
    if mark and mark >= 1 and mark <= 8 then marks[index] = mark end
  end
  return marks
end

local function BuildExport()
  local db = EnsureDB()
  local payload = {
    kind = "autoMarker", version = 1, mouseover = tonumber(db.mouseover) or 4,
    instances = {}, mechanics = {},
  }
  for instanceKey, catalog in pairs(MerfinPlus.AutoMarkerCatalog or {}) do
    payload.instances[instanceKey] = {}
    for _, mob in ipairs(catalog.mobs or {}) do
      local settings = EnemySettings(instanceKey, mob.npc)
      payload.instances[instanceKey][mob.npc] = {
        enable = settings.enable ~= false,
        priority = math.max(1, math.min(20, tonumber(settings.priority) or 1)),
        marks = CopyMarks(settings.marks),
      }
    end
  end
  for _, mechanic in ipairs(MerfinPlus.FriendlyMarkerCatalog or {}) do
    local settings, defaults = FriendlySettings(mechanic.key)
    local marks = {}
    for index = 1, mechanic.maxMarks or 1 do
      marks[index] = tonumber(settings.marks[index])
        or tonumber(defaults.marks and defaults.marks[index]) or 0
    end
    payload.mechanics[mechanic.key] = {
      enable = settings.enable == nil and defaults.enable ~= false or settings.enable,
      marks = marks,
    }
  end
  return "!MPAM:1!" .. AceSerializer:Serialize(payload)
end

local function Import(text)
  text = type(text) == "string" and text:match("^%s*(.-)%s*$") or ""
  local prefix = "!MPAM:1!"
  if text:sub(1, #prefix) ~= prefix then return false, L["Invalid Auto-Marker export string."] end
  local ok, payload = AceSerializer:Deserialize(text:sub(#prefix + 1))
  if not ok or type(payload) ~= "table" or payload.kind ~= "autoMarker" or payload.version ~= 1 then
    return false, L["Invalid Auto-Marker export string."]
  end

  local imported = {
    mouseover = math.max(1, math.min(5, tonumber(payload.mouseover) or 4)),
    instances = {}, mechanics = {},
  }
  for instanceKey, catalog in pairs(MerfinPlus.AutoMarkerCatalog or {}) do
    imported.instances[instanceKey] = {}
    local sourceInstance = type(payload.instances) == "table" and payload.instances[instanceKey] or {}
    sourceInstance = type(sourceInstance) == "table" and sourceInstance or {}
    local defaultInstance = MerfinPlus.AutoMarkerDefaults.instances
      and MerfinPlus.AutoMarkerDefaults.instances[instanceKey] or {}
    for _, mob in ipairs(catalog.mobs or {}) do
      local fallback = defaultInstance[mob.npc] or {}
      local source = type(sourceInstance[mob.npc]) == "table" and sourceInstance[mob.npc] or fallback
      imported.instances[instanceKey][mob.npc] = {
        enable = type(source.enable) == "boolean" and source.enable or fallback.enable ~= false,
        priority = math.max(1, math.min(20, tonumber(source.priority) or tonumber(fallback.priority) or 1)),
        marks = CopyMarks(type(source.marks) == "table" and source.marks or fallback.marks),
      }
    end
  end
  for _, mechanic in ipairs(MerfinPlus.FriendlyMarkerCatalog or {}) do
    local fallback = MerfinPlus.AutoMarkerDefaults.mechanics[mechanic.key] or {}
    local source = type(payload.mechanics) == "table" and payload.mechanics[mechanic.key] or fallback
    source = type(source) == "table" and source or fallback
    local marks = {}
    for index = 1, mechanic.maxMarks or 1 do
      local mark = tonumber(source.marks and source.marks[index])
        or tonumber(fallback.marks and fallback.marks[index]) or 0
      marks[index] = mark >= 1 and mark <= 8 and mark or 0
    end
    imported.mechanics[mechanic.key] = {
      enable = type(source.enable) == "boolean" and source.enable or fallback.enable ~= false,
      marks = marks,
    }
  end
  MerfinPlus.db.profile.raidAutoMarker = imported
  NotifyChanged()
  return true, L["Auto-Marker settings imported successfully."]
end

local function BuildTransferOptions()
  return {
    exportString = {
      type = "input", name = L["Export String"], order = 1, width = "full", multiline = 10,
      get = BuildExport, set = function() end,
    },
    importString = {
      type = "input", name = L["Import String"], order = 2, width = "full", multiline = 10,
      get = function() return transferState.text end,
      set = function(_, value) transferState.text = value or ""; transferState.status = "" end,
    },
    importButton = {
      type = "execute", name = L["Import"], order = 3, width = 1,
      disabled = function() return transferState.text == "" end,
      func = function()
        local ok, message = Import(transferState.text)
        transferState.status = (ok and "|cff33ff99" or "|cffff5555") .. tostring(message) .. "|r"
        AceConfigRegistry:NotifyChange("MerfinPlus_RaidPack")
      end,
    },
    status = {
      type = "description", order = 4, width = "full",
      name = function() return transferState.status end,
    },
  }
end

function MerfinPlus:BuildRaidAutoMarkerOptions()
  EnsureDB()
  local options = {
    type = "group",
    name = function()
      return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:16:16:0:0|t " .. L["Auto-Marker"]
    end,
    childGroups = "tab",
    args = {
      enemy = {
        type = "group", name = L["Enemy"], order = 1,
        args = BuildEnemyOptions(),
      },
      friendly = {
        type = "group", name = L["Friendly"], order = 2,
        args = BuildFriendlyOptions(),
      },
      transfer = {
        type = "group", name = L["Export / Import"], order = 3,
        args = BuildTransferOptions(),
      },
    },
  }
  return MakeOptionNamesDynamic(options)
end
