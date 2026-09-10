-- TBC Anniversary Ready Check window and durability exchange.

local MerfinPlus = LibStub("AceAddon-3.0"):GetAddon("MerfinPlus")
if not (MerfinPlus.IsTBC and MerfinPlus:IsTBC()) then
  return
end

local LSM = LibStub("LibSharedMedia-3.0", true)
local ADDON_PREFIX = "MFP_RC1"
local EXPIRING_SECONDS = 5 * 60
local DURABILITY_BASIS_POINTS_PER_PERCENT = 100
local DURABILITY_MAX_BASIS_POINTS = 100 * DURABILITY_BASIS_POINTS_PER_PERCENT
local BASE_WIDTH = 940
local BASE_HEIGHT = 820
local MIN_WIDTH = 820
local MIN_HEIGHT = 120
local MAX_WIDTH = 1600
local MAX_HEIGHT = 1000

local READY_CHECK_DEFAULTS = {
  enabled = false,
  leaderOnly = false,
  assistantOnly = false,
  displayDuration = 15,
  fontSize = 14,
  sortByClass = false,
  sortByName = false,
  reportFood = false,
  reportFlask = false,
  reportScrolls = false,
  reportMotw = false,
  reportIntellect = false,
  reportAttackPower = false,
  reportStamina = false,
  reportSpirit = false,
  reportArmor = false,
  reportShadow = false,
  reportMight = false,
  reportWisdom = false,
  reportKings = false,
  reportSalvation = false,
  showExpiring = true,
  showFoodColumn = true,
  showFlaskColumn = true,
  showScrollsColumn = true,
  showMotwColumn = true,
  showIntellectColumn = true,
  showAttackPowerColumn = true,
  showStaminaColumn = true,
  showSpiritColumn = true,
  showArmorColumn = true,
  showShadowColumn = true,
  showMightColumn = true,
  showWisdomColumn = true,
  showKingsColumn = true,
  showSalvationColumn = true,
  showDurabilityColumn = true,
  showMerfinPlusColumn = true,
  windowWidth = BASE_WIDTH,
  windowHeight = BASE_HEIGHT,
  windowX = 0,
  windowY = 0,
}

-- Spell IDs are matched against auras directly visible on each group unit.
-- Food includes the Classic and TBC Well Fed variants that can be active at
-- level 70. Flask includes Classic, TBC, Shattrath and unstable raid flasks.
local CATEGORY_SPELLS = {
  food = {
    18125, 18141, 18191, 18192, 18194, 18222, 19705, 19706, 19708, 19709,
    19710, 19711, 22730, 22789, 22790, 24799, 24870, 25661, 25694, 25804,
    25941, 29335, 33254, 33256, 33257, 33259, 33261, 33263, 33265, 33268,
    33272, 35272, 40323, 42293, 43722, 43730, 43764, 43771, 44097, 44098,
    44099, 44100, 44101, 44102, 44104, 44105, 44106, 45245, 45619, 46682,
    46687, 46899,
  },
  flask = {
    17626, 17627, 17628, 17629,
    28518, 28519, 28520, 28521, 28540,
    40567, 40568, 40572, 40573, 40575, 40576,
    41608, 41609, 41610, 41611, 42735, 46837, 46839,
  },
  battleElixir = {
    -- Classic battle elixirs still usable at level 70
    11334, 11405, 11406, 11474, 16322, 16323, 16329, 17038, 17537,
    17538, 17539, 21920, 26276,
    -- TBC battle elixirs
    28490, 28491, 28493, 28497, 28501, 28503, 33720, 33721, 33726, 38954,
  },
  guardianElixir = {
    -- Classic guardian elixirs still usable at level 70
    3593, 10668, 10693, 11348, 11371, 16325, 16326, 17535, 24361,
    24363, 24382, 24383, 24417,
    -- TBC guardian elixirs
    28502, 28509, 28514, 39625, 39626, 39627, 39628,
  },
  scrolls = {
    8091, 8094, 8095, 8096, 8097, 8098, 8099, 8100, 8101,
    8112, 8113, 8114, 8115, 8116, 8117, 8118, 8119, 8120,
    12174, 12175, 12176, 12177, 12178, 12179,
    33077, 33078, 33079, 33080, 33081, 33082,
  },
  motw = {
    1126, 5232, 5234, 6756, 8907, 9884, 9885, 21849, 21850, 26990, 26991,
  },
  intellect = {
    -- Arcane Intellect and Arcane Brilliance
    1459, 1460, 1461, 10156, 10157, 23028, 27126, 27127,
  },
  attackPower = {
    -- Battle Shout
    6673, 5242, 6192, 11549, 11550, 11551, 25289, 2048,
    -- Trueshot Aura and Unleashed Rage
    19506, 20905, 20906, 27066, 30802, 30808, 30809,
  },
  stamina = {
    -- Power Word: Fortitude and Prayer of Fortitude
    1243, 1244, 1245, 2791, 10937, 10938, 25389,
    21562, 21564, 25392,
  },
  spirit = {
    14752, 14818, 14819, 25312, 27841, 27681, 32999,
  },
  armor = {
    -- Inner Fire
    588, 602, 1006, 7128, 10951, 10952, 25431,
    -- Devotion Aura
    465, 643, 1032, 10290, 10291, 10292, 10293, 27149,
    -- Frost/Ice Armor, Demon Armor and Stoneskin Totem
    168, 7300, 7301, 7302, 7320, 10219, 10220, 27124,
    706, 1086, 11733, 11734, 11735, 27260,
    8071, 8154, 8155, 10406, 10407, 10408, 25508,
  },
  shadow = {
    -- Shadow Protection and Prayer of Shadow Protection
    976, 10957, 10958, 25433, 27683, 39374,
    -- Shadow Resistance Aura
    19876, 19895, 19896, 27151,
  },
  might = {
    -- Blessing and Greater Blessing of Might
    19740, 19834, 19835, 19836, 19837, 19838, 25291, 27140,
    25782, 25916, 27141,
  },
  wisdom = {
    -- Blessing and Greater Blessing of Wisdom
    19742, 19850, 19852, 19853, 19854, 25290, 27142,
    25894, 25918, 27143,
  },
  kings = {
    20217, 25898,
  },
  salvation = {
    1038, 25895,
  },
}

local COLUMNS = {
  { key = "food", label = "Food", shortLabel = "Food", width = 64, visibleSetting = "showFoodColumn" },
  { key = "flask", label = "Flask / Elixir", shortLabel = "F/E", width = 58, visibleSetting = "showFlaskColumn", flaskElixirs = true },
  { key = "scrolls", label = "Scroll", shortLabel = "Scroll", width = 48, visibleSetting = "showScrollsColumn" },
  { key = "motw", label = "Mark of the Wild (MOTW)", shortLabel = "MOTW", width = 48, visibleSetting = "showMotwColumn" },
  { key = "intellect", label = "Intellect", shortLabel = "Int", width = 46, visibleSetting = "showIntellectColumn" },
  { key = "attackPower", label = "Attack Power", shortLabel = "AP", width = 42, visibleSetting = "showAttackPowerColumn" },
  { key = "stamina", label = "Stamina", shortLabel = "Stam", width = 48, visibleSetting = "showStaminaColumn" },
  { key = "spirit", label = "Spirit", shortLabel = "Spirit", width = 46, visibleSetting = "showSpiritColumn" },
  { key = "armor", label = "Armor", shortLabel = "Armor", width = 48, visibleSetting = "showArmorColumn" },
  { key = "shadow", label = "Shadow Protection", shortLabel = "Shadow", width = 54, visibleSetting = "showShadowColumn" },
  { key = "might", label = "Blessing of Might", shortLabel = "Might", width = 46, visibleSetting = "showMightColumn" },
  { key = "wisdom", label = "Blessing of Wisdom", shortLabel = "Wis", width = 48, visibleSetting = "showWisdomColumn" },
  { key = "kings", label = "Blessing of Kings", shortLabel = "Kings", width = 46, visibleSetting = "showKingsColumn" },
  { key = "salvation", label = "Blessing of Salvation", shortLabel = "Salv", width = 46, visibleSetting = "showSalvationColumn" },
  { key = "durability", label = "Durability", shortLabel = "Dur", width = 48, visibleSetting = "showDurabilityColumn", durability = true },
  { key = "merfinPlus", label = "Merfin Plus", shortLabel = "MP", width = 66, visibleSetting = "showMerfinPlusColumn", version = true },
}

local AURA_CATEGORY_KEYS = {
  "food",
  "flask",
  "battleElixir",
  "guardianElixir",
  "scrolls",
  "motw",
  "intellect",
  "attackPower",
  "stamina",
  "spirit",
  "armor",
  "shadow",
  "might",
  "wisdom",
  "kings",
  "salvation",
}

local REPORT_CATEGORIES = {
  { reportSetting = "reportFood", label = "Food", auraKey = "food" },
  { reportSetting = "reportFlask", label = "Flask / Elixir", flaskElixirs = true },
  { reportSetting = "reportScrolls", label = "Scroll", auraKey = "scrolls" },
  { reportSetting = "reportMotw", label = "MOTW", auraKey = "motw" },
  { reportSetting = "reportIntellect", label = "Intellect", auraKey = "intellect" },
  { reportSetting = "reportAttackPower", label = "Attack Power", auraKey = "attackPower" },
  { reportSetting = "reportStamina", label = "Stamina", auraKey = "stamina" },
  { reportSetting = "reportSpirit", label = "Spirit", auraKey = "spirit" },
  { reportSetting = "reportArmor", label = "Armor", auraKey = "armor" },
  { reportSetting = "reportShadow", label = "Shadow Protection", auraKey = "shadow" },
  { reportSetting = "reportMight", label = "Blessing of Might", auraKey = "might" },
  { reportSetting = "reportWisdom", label = "Blessing of Wisdom", auraKey = "wisdom" },
  { reportSetting = "reportKings", label = "Blessing of Kings", auraKey = "kings" },
  { reportSetting = "reportSalvation", label = "Blessing of Salvation", auraKey = "salvation" },
}

local STATUS_TEXTURES = {
  waiting = READY_CHECK_WAITING_TEXTURE or "Interface\\RaidFrame\\ReadyCheck-Waiting",
  ready = READY_CHECK_READY_TEXTURE or "Interface\\RaidFrame\\ReadyCheck-Ready",
  notready = READY_CHECK_NOT_READY_TEXTURE or "Interface\\RaidFrame\\ReadyCheck-NotReady",
}

local SPELL_CATEGORY_BY_ID = {}
local SPELL_CATEGORY_BY_NAME = {}

local function Clamp(value, minimum, maximum)
  value = tonumber(value) or minimum
  if value < minimum then
    return minimum
  elseif value > maximum then
    return maximum
  end
  return value
end

local function Round(value)
  return math.floor((tonumber(value) or 0) + 0.5)
end

local function GetCanonicalAddonVersion()
  local getter = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
  if not getter then
    return "unknown"
  end

  local ok, version = pcall(getter, "MerfinPlus", "Version")
  version = ok and tostring(version or "") or ""
  version = version:match("^%s*(.-)%s*$") or ""
  return version ~= "" and version or "unknown"
end

local function EncodeAddonVersion(version)
  version = tostring(version or "unknown")
  version = version:gsub("[^%w%._%+%-@]", ""):sub(1, 32)
  return version ~= "" and version or "unknown"
end

local function NormalizeReportedVersion(version)
  version = tostring(version or ""):match("^%s*(.-)%s*$") or ""
  if version == "" or version == "unknown" or #version > 32 or version:find("[^%w%._%+%-@]") then
    return nil
  end
  return version
end

local function FormatAddonVersion(version)
  version = tostring(version or "")
  if version == "" then
    return "?"
  end
  if version:match("^[vV]") or not version:match("^%d") then
    return version
  end
  return "v" .. version
end

local function ResolveReadyCheckFont()
  if LSM then
    local ok, font = pcall(LSM.Fetch, LSM, "font", "Merfin Font 1", true)
    if ok and type(font) == "string" and font ~= "" then
      return font
    end
  end
  if GameFontNormal and GameFontNormal.GetFont then
    local font = GameFontNormal:GetFont()
    if type(font) == "string" and font ~= "" then
      return font
    end
  end
  if type(STANDARD_TEXT_FONT) == "string" and STANDARD_TEXT_FONT ~= "" then
    return STANDARD_TEXT_FONT
  end
  return "Fonts\\FRIZQT__.TTF"
end

local function ApplyReadyCheckFont(fontString, size, flags)
  if not fontString then
    return false
  end

  local candidates = {
    ResolveReadyCheckFont(),
    type(STANDARD_TEXT_FONT) == "string" and STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF",
    "Fonts\\FRIZQT__.TTF",
  }
  local attempted = {}
  for _, font in ipairs(candidates) do
    if font and not attempted[font] then
      attempted[font] = true
      local ok = pcall(fontString.SetFont, fontString, font, size or 12, flags or "OUTLINE")
      local currentFont = fontString:GetFont()
      if ok and currentFont then
        return true
      end
    end
  end
  return false
end

local function NormalizeName(name)
  name = tostring(name or "")
  if Ambiguate and name ~= "" then
    local ok, shortName = pcall(Ambiguate, name, "short")
    if ok and shortName and shortName ~= "" then
      name = shortName
    end
  end
  name = name:match("^[^-]+") or name
  return string.lower(name)
end

local function DisplayName(name)
  name = tostring(name or UNKNOWN or "Unknown")
  if Ambiguate then
    local ok, shortName = pcall(Ambiguate, name, "short")
    if ok and shortName and shortName ~= "" then
      return shortName
    end
  end
  return name:match("^[^-]+") or name
end

local function GetUnitFullName(unit)
  local name, realm = UnitName(unit)
  if not name then
    return nil
  end
  if realm and realm ~= "" then
    return name .. "-" .. realm
  end
  return name
end

local function ResolveReadyCheckName(nameOrUnit)
  if type(nameOrUnit) ~= "string" or nameOrUnit == "" then
    return nil
  end
  if UnitExists and UnitExists(nameOrUnit) then
    return GetUnitFullName(nameOrUnit)
  end
  return nameOrUnit
end

local function GetGroupChannel()
  if LE_PARTY_CATEGORY_INSTANCE and IsInGroup and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
    return "INSTANCE_CHAT"
  end
  if IsInRaid and IsInRaid() then
    return "RAID"
  end
  if IsInGroup and IsInGroup() then
    return "PARTY"
  end
  return nil
end

local function IsPlayerGroupLeader()
  if UnitIsGroupLeader then
    return UnitIsGroupLeader("player") and true or false
  end
  if IsRaidLeader and IsRaidLeader() then
    return true
  end
  return UnitIsPartyLeader and UnitIsPartyLeader("player") and true or false
end

local function IsPlayerGroupAssistant()
  if UnitIsGroupAssistant then
    return UnitIsGroupAssistant("player") and true or false
  end
  return IsRaidOfficer and IsRaidOfficer() and not IsPlayerGroupLeader() or false
end

local function AddGroupUnits(target)
  if IsInRaid and IsInRaid() then
    local count = GetNumGroupMembers and GetNumGroupMembers() or (GetNumRaidMembers and GetNumRaidMembers()) or 0
    for index = 1, count do
      target[#target + 1] = "raid" .. index
    end
    return
  end

  if IsInGroup and IsInGroup() then
    target[#target + 1] = "player"
    local count = GetNumSubgroupMembers and GetNumSubgroupMembers()
      or (GetNumPartyMembers and GetNumPartyMembers())
      or 0
    for index = 1, count do
      target[#target + 1] = "party" .. index
    end
  end
end

local function IsSenderInGroup(sender)
  local senderKey = NormalizeName(sender)
  if senderKey == "" then
    return false
  end

  local units = {}
  AddGroupUnits(units)
  for _, unit in ipairs(units) do
    if UnitExists(unit) and NormalizeName(GetUnitFullName(unit)) == senderKey then
      return true
    end
  end
  return false
end

local function SendAddonPayload(message, distribution, target)
  if not message or not distribution then
    return false
  end

  local sender = C_ChatInfo and C_ChatInfo.SendAddonMessage or SendAddonMessage
  if not sender then
    return false
  end

  local ok = pcall(sender, ADDON_PREFIX, message, distribution, target)
  return ok
end

local function SendGroupChat(message)
  local channel = GetGroupChannel()
  if not channel or not message or message == "" then
    return false
  end

  local sender = C_ChatInfo and C_ChatInfo.SendChatMessage or SendChatMessage
  if not sender then
    return false
  end

  local ok = pcall(sender, message, channel)
  return ok
end

local function CalculateLocalDurability()
  if not GetInventoryItemDurability then
    return nil
  end

  local minimumBasisPoints
  for slot = 1, 18 do
    local current, maximum = GetInventoryItemDurability(slot)
    if current and maximum and maximum > 0 then
      local basisPoints = math.floor((current / maximum) * DURABILITY_MAX_BASIS_POINTS)
      minimumBasisPoints = minimumBasisPoints and math.min(minimumBasisPoints, basisPoints) or basisPoints
    end
  end

  return minimumBasisPoints and Clamp(minimumBasisPoints, 0, DURABILITY_MAX_BASIS_POINTS) or nil
end

local function GetAuraData(unit, index)
  if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
    local aura = C_UnitAuras.GetAuraDataByIndex(unit, index, "HELPFUL")
    if aura then
      return {
        name = aura.name,
        icon = aura.icon,
        applications = aura.applications or 0,
        duration = aura.duration or 0,
        expirationTime = aura.expirationTime or 0,
        spellId = aura.spellId,
      }
    end
    return nil
  end

  if not UnitBuff then
    return nil
  end
  local name, icon, applications, _, duration, expirationTime, _, _, _, spellId = UnitBuff(unit, index)
  if not name then
    return nil
  end
  return {
    name = name,
    icon = icon,
    applications = applications or 0,
    duration = duration or 0,
    expirationTime = expirationTime or 0,
    spellId = spellId,
  }
end

local function AuraRemaining(aura, now)
  if not aura or not aura.expirationTime or aura.expirationTime <= 0 then
    return math.huge
  end
  return math.max(0, aura.expirationTime - now)
end

local function ScanUnitAuras(unit)
  local found = {}
  local matchesByCategory = {}
  local now = GetTime()

  for index = 1, 80 do
    local aura = GetAuraData(unit, index)
    if not aura then
      break
    end

    local category = aura.spellId and SPELL_CATEGORY_BY_ID[aura.spellId]
      or (aura.name and SPELL_CATEGORY_BY_NAME[aura.name])
    if category then
      matchesByCategory[category] = matchesByCategory[category] or {}
      matchesByCategory[category][#matchesByCategory[category] + 1] = aura
      local previous = found[category]
      if not previous or AuraRemaining(aura, now) < AuraRemaining(previous, now) then
        found[category] = aura
      end
    end
  end

  for category, matches in pairs(matchesByCategory) do
    table.sort(matches, function(left, right)
      local leftName = string.lower(tostring(left.name or ""))
      local rightName = string.lower(tostring(right.name or ""))
      if leftName ~= rightName then
        return leftName < rightName
      end
      local leftID = tonumber(left.spellId) or 0
      local rightID = tonumber(right.spellId) or 0
      if leftID ~= rightID then
        return leftID < rightID
      end
      return AuraRemaining(left, now) < AuraRemaining(right, now)
    end)
    found[category].matchedCount = #matches
  end
  found.matchesByCategory = matchesByCategory
  return found
end

local function ReadyCheckAuraSignature(auras)
  local parts = {}
  local now = GetTime()
  for _, category in ipairs(AURA_CATEGORY_KEYS) do
    local aura = auras and auras[category]
    if aura then
      local matches = auras.matchesByCategory and auras.matchesByCategory[category]
        or { aura }
      for _, matchedAura in ipairs(matches) do
        parts[#parts + 1] = table.concat({
          category,
          tostring(matchedAura.spellId or matchedAura.name or ""),
          tostring(matchedAura.name or ""),
          tostring(matchedAura.icon or ""),
          tostring(matchedAura.applications or 0),
          tostring(matchedAura.expirationTime or 0),
          AuraRemaining(matchedAura, now) <= EXPIRING_SECONDS and "expiring" or "lasting",
        }, ":")
      end
    end
  end
  return table.concat(parts, "|")
end

local function GetFlaskElixirState(auras)
  if not auras then
    return nil
  end

  if auras.flask then
    return {
      kind = "flask",
      remaining = AuraRemaining(auras.flask, GetTime()),
      entries = {
        { label = "Flask", aura = auras.flask },
      },
    }
  end

  local entries = {}
  if auras.battleElixir then
    entries[#entries + 1] = { label = "Battle Elixir", aura = auras.battleElixir }
  end
  if auras.guardianElixir then
    entries[#entries + 1] = { label = "Guardian Elixir", aura = auras.guardianElixir }
  end
  if #entries == 0 then
    return nil
  end

  local remaining = math.huge
  for _, entry in ipairs(entries) do
    remaining = math.min(remaining, AuraRemaining(entry.aura, GetTime()))
  end
  return {
    kind = #entries == 2 and "bothElixirs"
      or (auras.battleElixir and "battleElixir" or "guardianElixir"),
    remaining = remaining,
    entries = entries,
  }
end

local function SetBorderColor(widget, red, green, blue, alpha)
  for _, texture in ipairs(widget.borderTextures or {}) do
    texture:SetColorTexture(red, green, blue, alpha or 1)
  end
end

local function AddBorderTextures(widget, thickness)
  thickness = thickness or 1
  widget.borderTextures = {}

  local top = widget:CreateTexture(nil, "BORDER")
  top:SetPoint("TOPLEFT")
  top:SetPoint("TOPRIGHT")
  top:SetHeight(thickness)
  widget.borderTextures[#widget.borderTextures + 1] = top

  local bottom = widget:CreateTexture(nil, "BORDER")
  bottom:SetPoint("BOTTOMLEFT")
  bottom:SetPoint("BOTTOMRIGHT")
  bottom:SetHeight(thickness)
  widget.borderTextures[#widget.borderTextures + 1] = bottom

  local left = widget:CreateTexture(nil, "BORDER")
  left:SetPoint("TOPLEFT")
  left:SetPoint("BOTTOMLEFT")
  left:SetWidth(thickness)
  widget.borderTextures[#widget.borderTextures + 1] = left

  local right = widget:CreateTexture(nil, "BORDER")
  right:SetPoint("TOPRIGHT")
  right:SetPoint("BOTTOMRIGHT")
  right:SetWidth(thickness)
  widget.borderTextures[#widget.borderTextures + 1] = right
end

local function ShowReadyCheckTooltip(owner, title, description)
  if not GameTooltip then
    return
  end
  GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
  GameTooltip:SetText(title or "", 0.88, 0.74, 0.35)
  if description and description ~= "" then
    GameTooltip:AddLine(description, 0.9, 0.9, 0.9, true)
  end
  GameTooltip:Show()
end

local function ShowReadyCheckAuraTooltip(owner, aura, categoryLabel)
  if not GameTooltip or not aura then
    return
  end
  GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
  GameTooltip:SetText(aura.name or MerfinPlus:T("Buff active"), 0.88, 0.74, 0.35)
  if categoryLabel and categoryLabel ~= "" then
    GameTooltip:AddLine(categoryLabel, 0.72, 0.72, 0.72)
  end
  local applications = tonumber(aura.applications) or 0
  if applications > 1 then
    GameTooltip:AddLine(MerfinPlus:T("Stacks: %d", applications), 0.9, 0.9, 0.9)
  end
  local remaining = AuraRemaining(aura, GetTime())
  if remaining ~= math.huge then
    GameTooltip:AddLine(
      MerfinPlus:T("Remaining: %d:%02d", math.floor(remaining / 60), math.floor(remaining % 60)),
      0.9,
      0.9,
      0.9
    )
  end
  GameTooltip:Show()
end

local function CreateHeaderCell(parent)
  local cell = CreateFrame("Frame", nil, parent)
  cell.text = cell:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  ApplyReadyCheckFont(cell.text, 12, "OUTLINE")
  cell.text:SetPoint("CENTER")
  cell.text:SetJustifyH("CENTER")
  cell.text:SetTextColor(0.94, 0.80, 0.42, 1)
  cell:EnableMouse(true)
  cell:SetScript("OnEnter", function(current)
    ShowReadyCheckTooltip(current, current.tooltipTitle, current.tooltipDescription)
  end)
  cell:SetScript("OnLeave", function()
    if GameTooltip then
      GameTooltip:Hide()
    end
  end)
  return cell
end

local function CreateAuraCell(parent)
  local cell = CreateFrame("Frame", nil, parent)
  cell.background = cell:CreateTexture(nil, "BACKGROUND")
  cell.background:SetAllPoints()
  cell.background:SetColorTexture(0.04, 0.04, 0.04, 0.75)

  cell.icon = cell:CreateTexture(nil, "ARTWORK")
  cell.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

  cell.icon2 = cell:CreateTexture(nil, "ARTWORK")
  cell.icon2:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  cell.icon2:Hide()

  cell.expiringIcon = cell:CreateTexture(nil, "OVERLAY")
  cell.expiringIcon:SetTexture("Interface\\Icons\\INV_Misc_PocketWatch_01")
  cell.expiringIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  cell.expiringIcon:SetVertexColor(1, 0.68, 0.12, 1)
  cell.expiringIcon:Hide()

  cell.text = cell:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  ApplyReadyCheckFont(cell.text, 10, "OUTLINE")
  cell.text:SetPoint("CENTER")
  cell.text:SetJustifyH("CENTER")

  AddBorderTextures(cell, 1)
  SetBorderColor(cell, 0.25, 0.25, 0.25, 0.8)

  cell:EnableMouse(true)
  cell:SetScript("OnEnter", function(current)
    if not GameTooltip then
      return
    end
    GameTooltip:SetOwner(current, "ANCHOR_RIGHT")
    GameTooltip:SetText(current.categoryLabel or "", 0.88, 0.74, 0.35)
    if current.auraGroup then
      for _, entry in ipairs(current.auraGroup) do
        local entryLabel = MerfinPlus:T(entry.label)
        if entry.aura then
          GameTooltip:AddLine(string.format("%s: %s", entryLabel, entry.aura.name or MerfinPlus:T("Buff active")), 1, 1, 1)
          local remaining = AuraRemaining(entry.aura, GetTime())
          if remaining ~= math.huge then
            GameTooltip:AddLine("  " .. MerfinPlus:T("Remaining: %d:%02d", math.floor(remaining / 60), math.floor(remaining % 60)), 0.9, 0.9, 0.9)
          end
        else
          GameTooltip:AddLine(MerfinPlus:T("%s: Missing", entryLabel), 1, 0.25, 0.25)
        end
      end
    elseif current.auraData then
      GameTooltip:AddLine(current.auraData.name or MerfinPlus:T("Buff active"), 1, 1, 1)
      local remaining = AuraRemaining(current.auraData, GetTime())
      if remaining ~= math.huge then
        GameTooltip:AddLine(MerfinPlus:T("Remaining: %d:%02d", math.floor(remaining / 60), math.floor(remaining % 60)), 0.9, 0.9, 0.9)
      end
    elseif current.usesAuraIconButtons then
      return
    elseif current.durabilityBasisPoints ~= nil then
      GameTooltip:AddLine(string.format("%.2f%%", current.durabilityBasisPoints / DURABILITY_BASIS_POINTS_PER_PERCENT), 1, 1, 1)
    elseif current.isVersion then
      if current.versionValue then
        GameTooltip:AddLine(MerfinPlus:T("Reported: %s", current.versionValue), 1, 1, 1)
        GameTooltip:AddLine(MerfinPlus:T("Local: %s", current.localVersion or MerfinPlus:T("Unknown")), 0.75, 0.75, 0.75)
      else
        GameTooltip:AddLine(MerfinPlus:T("Unknown until the player responds with MerfinPlus."), 0.65, 0.65, 0.65)
      end
    else
      GameTooltip:AddLine(MerfinPlus:T(current.isDurability and "Unknown until the player responds." or "Missing"), 1, 0.25, 0.25)
    end
    if current.isExpiring then
      GameTooltip:AddLine(MerfinPlus:T("Expiring in 5 minutes or less."), 1, 0.55, 0.10)
    end
    GameTooltip:Show()
  end)
  cell:SetScript("OnLeave", function()
    if GameTooltip then
      GameTooltip:Hide()
    end
  end)
  return cell
end

local function CreateReadyCheckAuraIconButton(cell)
  local button = CreateFrame("Button", nil, cell)
  button.texture = button:CreateTexture(nil, "ARTWORK")
  button.texture:SetAllPoints()
  button.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  button:SetScript("OnEnter", function(current)
    ShowReadyCheckAuraTooltip(current, current.auraData, current.categoryLabel)
  end)
  button:SetScript("OnLeave", function()
    if GameTooltip then
      GameTooltip:Hide()
    end
  end)
  button:SetScript("OnHide", function()
    if GameTooltip and GameTooltip.IsOwned and GameTooltip:IsOwned(button) then
      GameTooltip:Hide()
    end
  end)
  button:Hide()
  return button
end

local function SetReadyCheckAuraIconButtons(cell, auras, categoryLabel)
  cell.auraIconButtons = cell.auraIconButtons or {}
  local count = type(auras) == "table" and #auras or 0
  for index = 1, count do
    local button = cell.auraIconButtons[index]
    if not button then
      button = CreateReadyCheckAuraIconButton(cell)
      cell.auraIconButtons[index] = button
    end
    local aura = auras[index]
    button.auraData = aura
    button.categoryLabel = categoryLabel
    button.texture:SetTexture(aura.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
    button.texture:SetVertexColor(1, 1, 1, 1)
    button:Show()
  end
  for index = count + 1, #cell.auraIconButtons do
    local button = cell.auraIconButtons[index]
    button.auraData = nil
    button.categoryLabel = nil
    button:Hide()
  end
  cell.usesAuraIconButtons = count > 0
end

local function LayoutReadyCheckCellIcons(cell, rowHeight, scale)
  if not cell then
    return
  end
  rowHeight = tonumber(rowHeight) or 19
  scale = tonumber(scale) or 1
  local cellWidth = cell:GetWidth()
  local iconSize = math.max(9, math.min(rowHeight - 6, 14 * scale, cellWidth - 4))

  if cell.usesAuraIconButtons then
    local visibleButtons = {}
    for _, button in ipairs(cell.auraIconButtons or {}) do
      if button:IsShown() then
        visibleButtons[#visibleButtons + 1] = button
      end
    end
    local showExpiringIcon = cell.expiringIcon:IsShown()
    local visualCount = #visibleButtons + (showExpiringIcon and 1 or 0)
    local availableWidth = math.max(1, cellWidth - (4 * scale))
    if visualCount > 0 then
      local gap = visualCount > 1
        and math.min(math.max(1, 2 * scale), availableWidth / (visualCount * 3))
        or 0
      iconSize = math.max(
        0.5,
        math.min(iconSize, (availableWidth - ((visualCount - 1) * gap)) / visualCount)
      )
      local totalWidth = (visualCount * iconSize) + ((visualCount - 1) * gap)
      local x = -totalWidth / 2
      for _, button in ipairs(visibleButtons) do
        button:ClearAllPoints()
        button:SetPoint("LEFT", cell, "CENTER", x, 0)
        button:SetSize(iconSize, iconSize)
        x = x + iconSize + gap
      end
      cell.expiringIcon:ClearAllPoints()
      if showExpiringIcon then
        local expiringIconSize = math.max(5, math.min(iconSize * 0.7, 10 * scale))
        cell.expiringIcon:SetPoint("LEFT", cell, "CENTER", x + ((iconSize - expiringIconSize) / 2), 0)
        cell.expiringIcon:SetSize(expiringIconSize, expiringIconSize)
      else
        cell.expiringIcon:SetPoint("CENTER")
      end
    end
    cell.icon:Hide()
    cell.icon2:Hide()
    return
  end

  cell.icon:ClearAllPoints()
  cell.icon2:ClearAllPoints()
  cell.expiringIcon:ClearAllPoints()
  local showSecondIcon = cell.icon2:IsShown()
  local showExpiringIcon = cell.expiringIcon:IsShown()
  if showSecondIcon and showExpiringIcon then
    iconSize = math.max(7, math.min(iconSize, (cellWidth - 8) / 3))
    cell.icon:SetPoint("RIGHT", cell, "CENTER", -((iconSize / 2) + 1), 0)
    cell.icon2:SetPoint("CENTER", cell, "CENTER", 0, 0)
    cell.expiringIcon:SetPoint("LEFT", cell, "CENTER", (iconSize / 2) + 2, 0)
  elseif showSecondIcon then
    iconSize = math.max(8, math.min(iconSize, (cellWidth - 5) / 2))
    cell.icon:SetPoint("RIGHT", cell, "CENTER", -1, 0)
    cell.icon2:SetPoint("LEFT", cell, "CENTER", 1, 0)
    cell.expiringIcon:SetPoint("CENTER")
  elseif showExpiringIcon then
    iconSize = math.max(8, math.min(iconSize, (cellWidth - 5) / 2))
    cell.icon:SetPoint("RIGHT", cell, "CENTER", -1, 0)
    cell.icon2:SetPoint("CENTER")
    cell.expiringIcon:SetPoint("LEFT", cell, "CENTER", 2, 0)
  else
    cell.icon:SetPoint("CENTER")
    cell.icon2:SetPoint("CENTER")
    cell.expiringIcon:SetPoint("CENTER")
  end
  cell.icon:SetSize(iconSize, iconSize)
  cell.icon2:SetSize(iconSize, iconSize)
  local expiringIconSize = math.max(7, math.min(iconSize * 0.7, 10 * scale))
  cell.expiringIcon:SetSize(expiringIconSize, expiringIconSize)
end

local function CreateReadyCheckRow(parent)
  local row = CreateFrame("Frame", nil, parent)
  row.background = row:CreateTexture(nil, "BACKGROUND")
  row.background:SetAllPoints()

  row.nameText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  ApplyReadyCheckFont(row.nameText, 12, "OUTLINE")
  row.nameText:SetJustifyH("LEFT")
  row.nameText:SetTextColor(1, 1, 1, 1)

  row.statusIcon = row:CreateTexture(nil, "ARTWORK")
  row.statusIcon:SetTexCoord(0, 1, 0, 1)

  row.cells = {}
  for index, column in ipairs(COLUMNS) do
    local cell = CreateAuraCell(row)
    cell.categoryLabel = column.label
    cell.isDurability = column.durability and true or false
    cell.isVersion = column.version and true or false
    row.cells[index] = cell
  end
  return row
end

local function MigrateReadyCheckSettings(settings)
  local legacyReportFoodFlask = rawget(settings, "reportFoodFlask")
  if legacyReportFoodFlask ~= nil then
    if rawget(settings, "reportFood") == nil then
      settings.reportFood = legacyReportFoodFlask and true or false
    end
    if rawget(settings, "reportFlask") == nil then
      settings.reportFlask = legacyReportFoodFlask and true or false
    end
    settings.reportFoodFlask = nil
  end
end

local function GetVisibleReadyCheckColumns(settings)
  local visibleColumns = {}
  for index, column in ipairs(COLUMNS) do
    if settings[column.visibleSetting] then
      visibleColumns[#visibleColumns + 1] = {
        index = index,
        column = column,
      }
    end
  end
  return visibleColumns
end

function MerfinPlus:GetReadyCheckSettings()
  local profile = self.db and self.db.profile
  if not profile then
    return READY_CHECK_DEFAULTS
  end

  if type(profile.readyCheck) ~= "table" then
    profile.readyCheck = {}
  end
  local settings = profile.readyCheck
  MigrateReadyCheckSettings(settings)
  for key, defaultValue in pairs(READY_CHECK_DEFAULTS) do
    if settings[key] == nil then
      settings[key] = defaultValue
    end
  end

  settings.displayDuration = Clamp(Round(settings.displayDuration), 5, 60)
  settings.fontSize = Clamp(Round(settings.fontSize), 8, 24)
  settings.windowWidth = Clamp(Round(settings.windowWidth), MIN_WIDTH, MAX_WIDTH)
  settings.windowHeight = Clamp(Round(settings.windowHeight), MIN_HEIGHT, MAX_HEIGHT)
  settings.windowX = tonumber(settings.windowX) or 0
  settings.windowY = tonumber(settings.windowY) or 0
  return settings
end

function MerfinPlus:IsReadyCheckDisplayAllowed()
  local settings = self:GetReadyCheckSettings()
  if not settings.enabled then
    return false
  end

  local leaderGate = settings.leaderOnly and true or false
  local assistantGate = settings.assistantOnly and true or false
  if not leaderGate and not assistantGate then
    return true
  end

  return (leaderGate and IsPlayerGroupLeader())
    or (assistantGate and IsPlayerGroupAssistant())
    or false
end

function MerfinPlus:SetReadyCheckSetting(key, value)
  local settings = self:GetReadyCheckSettings()
  if key == "displayDuration" then
    value = Clamp(Round(value), 5, 60)
  elseif key == "fontSize" then
    value = Clamp(Round(value), 8, 24)
  else
    value = value and true or false
  end
  settings[key] = value

  if key == "enabled" and not value then
    self.readyCheckActive = false
    if self.readyCheckFrame then
      self.readyCheckFrame:Hide()
    end
  elseif self.readyCheckFrame and self.readyCheckFrame:IsShown() then
    self:RefreshReadyCheckWindow()
  end
end

function MerfinPlus:BuildReadyCheckOptions()
  return {
    type = "group",
    name = self:T("Ready Check"),
    get = function(info)
      return MerfinPlus:GetReadyCheckSettings()[info[#info]]
    end,
    set = function(info, value)
      MerfinPlus:SetReadyCheckSetting(info[#info], value)
    end,
    args = {
      header = {
        type = "header",
        name = self:T("Ready Check"),
        order = 0,
      },
      description = {
        type = "description",
        name = self:T("Shows a movable and resizable raid status window when a Blizzard ready check begins."),
        order = 1,
        width = "full",
      },
      enabled = {
        type = "toggle",
        name = self:T("Enable"),
        order = 2,
        width = "full",
      },
      leaderOnly = {
        type = "toggle",
        name = self:T("Enable only while group leader"),
        desc = self:T("When both role restrictions are selected, either group leader or assistant is allowed."),
        order = 3,
        width = 1.5,
      },
      assistantOnly = {
        type = "toggle",
        name = self:T("Enable only while assistant"),
        desc = self:T("When both role restrictions are selected, either group leader or assistant is allowed."),
        order = 4,
        width = 1.5,
      },
      displayDuration = {
        type = "range",
        name = self:T("Display Duration"),
        desc = self:T("Seconds to keep the window visible from the moment the ready check starts."),
        order = 5,
        min = 5,
        max = 60,
        step = 1,
        width = "full",
      },
      fontSize = {
        type = "range",
        name = self:T("Font Size"),
        desc = self:T("Controls Ready Check text size independently of window resizing."),
        order = 6,
        min = 8,
        max = 24,
        step = 1,
        width = "full",
      },
      sortByName = {
        type = "toggle",
        name = self:T("Sort by Name"),
        order = 7,
        width = 1.5,
      },
      sortByClass = {
        type = "toggle",
        name = self:T("Sort by Class"),
        order = 8,
        width = 1.5,
      },
      showExpiring = {
        type = "toggle",
        name = self:T("Show Expiring Buffs, Food and Flask"),
        desc = self:T("Highlights every tracked aura with 5 minutes or less remaining using an orange cell and hourglass."),
        order = 9,
        width = "full",
      },
      reportHeader = {
        type = "header",
        name = self:T("Report in Chat:"),
        order = 10,
      },
      reportFood = {
        type = "toggle",
        name = self:T("Food"),
        order = 11,
        width = 1.0,
      },
      reportFlask = {
        type = "toggle",
        name = self:T("Flask / Elixir"),
        order = 12,
        width = 1.0,
      },
      reportScrolls = {
        type = "toggle",
        name = self:T("Scroll"),
        order = 13,
        width = 1.0,
      },
      reportMotw = {
        type = "toggle",
        name = self:T("MOTW"),
        order = 14,
        width = 1.0,
      },
      reportIntellect = {
        type = "toggle",
        name = self:T("Intellect"),
        order = 15,
        width = 1.0,
      },
      reportAttackPower = {
        type = "toggle",
        name = self:T("Attack Power"),
        order = 16,
        width = 1.0,
      },
      reportStamina = {
        type = "toggle",
        name = self:T("Stamina"),
        order = 17,
        width = 1.0,
      },
      reportSpirit = {
        type = "toggle",
        name = self:T("Spirit"),
        order = 18,
        width = 1.0,
      },
      reportArmor = {
        type = "toggle",
        name = self:T("Armor"),
        order = 19,
        width = 1.0,
      },
      reportShadow = {
        type = "toggle",
        name = self:T("Shadow Protection"),
        order = 20,
        width = 1.0,
      },
      reportMight = {
        type = "toggle",
        name = self:T("Blessing of Might"),
        order = 21,
        width = 1.0,
      },
      reportWisdom = {
        type = "toggle",
        name = self:T("Blessing of Wisdom"),
        order = 22,
        width = 1.0,
      },
      reportKings = {
        type = "toggle",
        name = self:T("Blessing of Kings"),
        order = 23,
        width = 1.0,
      },
      reportSalvation = {
        type = "toggle",
        name = self:T("Blessing of Salvation"),
        order = 24,
        width = 1.0,
      },
      frameHeader = {
        type = "header",
        name = self:T("Ready Check Frame Settings"),
        order = 25,
      },
      showFoodColumn = {
        type = "toggle",
        name = self:T("Food"),
        order = 26,
        width = 1.0,
      },
      showFlaskColumn = {
        type = "toggle",
        name = self:T("Flask / Elixir"),
        order = 27,
        width = 1.0,
      },
      showScrollsColumn = {
        type = "toggle",
        name = self:T("Scroll"),
        order = 28,
        width = 1.0,
      },
      showMotwColumn = {
        type = "toggle",
        name = self:T("MOTW"),
        order = 29,
        width = 1.0,
      },
      showIntellectColumn = {
        type = "toggle",
        name = self:T("Intellect"),
        order = 30,
        width = 1.0,
      },
      showAttackPowerColumn = {
        type = "toggle",
        name = self:T("Attack Power"),
        order = 31,
        width = 1.0,
      },
      showStaminaColumn = {
        type = "toggle",
        name = self:T("Stamina"),
        order = 32,
        width = 1.0,
      },
      showSpiritColumn = {
        type = "toggle",
        name = self:T("Spirit"),
        order = 33,
        width = 1.0,
      },
      showArmorColumn = {
        type = "toggle",
        name = self:T("Armor"),
        order = 34,
        width = 1.0,
      },
      showShadowColumn = {
        type = "toggle",
        name = self:T("Shadow Protection"),
        order = 35,
        width = 1.0,
      },
      showMightColumn = {
        type = "toggle",
        name = self:T("Blessing of Might"),
        order = 36,
        width = 1.0,
      },
      showWisdomColumn = {
        type = "toggle",
        name = self:T("Blessing of Wisdom"),
        order = 37,
        width = 1.0,
      },
      showKingsColumn = {
        type = "toggle",
        name = self:T("Blessing of Kings"),
        order = 38,
        width = 1.0,
      },
      showSalvationColumn = {
        type = "toggle",
        name = self:T("Blessing of Salvation"),
        order = 39,
        width = 1.0,
      },
      showDurabilityColumn = {
        type = "toggle",
        name = self:T("Durability"),
        order = 40,
        width = 1.0,
      },
      showMerfinPlusColumn = {
        type = "toggle",
        name = self:T("Merfin Plus"),
        order = 41,
        width = 1.0,
      },
    },
  }
end

function MerfinPlus:SaveReadyCheckWindowGeometry()
  local frame = self.readyCheckFrame
  if not frame then
    return
  end

  local settings = self:GetReadyCheckSettings()
  settings.windowWidth = Round(frame:GetWidth())
  settings.windowHeight = Round(frame:GetHeight())
  local centerX, centerY = frame:GetCenter()
  local parentX, parentY = UIParent:GetCenter()
  if centerX and centerY and parentX and parentY then
    settings.windowX = Round(centerX - parentX)
    settings.windowY = Round(centerY - parentY)
  end
end

function MerfinPlus:CreateReadyCheckWindow()
  if self.readyCheckFrame then
    return self.readyCheckFrame
  end

  local settings = self:GetReadyCheckSettings()
  local frame = CreateFrame("Frame", "MerfinPlusReadyCheckFrame", UIParent)
  frame:SetFrameStrata("DIALOG")
  frame:SetToplevel(true)
  frame:SetClampedToScreen(true)
  frame:SetMovable(true)
  frame:SetResizable(true)
  frame:EnableMouse(true)
  frame:SetSize(settings.windowWidth, settings.windowHeight)
  frame:SetPoint("CENTER", UIParent, "CENTER", settings.windowX, settings.windowY)

  if frame.SetResizeBounds then
    frame:SetResizeBounds(MIN_WIDTH, MIN_HEIGHT, MAX_WIDTH, MAX_HEIGHT)
  else
    if frame.SetMinResize then
      frame:SetMinResize(MIN_WIDTH, MIN_HEIGHT)
    end
    if frame.SetMaxResize then
      frame:SetMaxResize(MAX_WIDTH, MAX_HEIGHT)
    end
  end

  frame.background = frame:CreateTexture(nil, "BACKGROUND")
  frame.background:SetAllPoints()
  frame.background:SetColorTexture(0.025, 0.025, 0.025, 0.96)
  AddBorderTextures(frame, 2)
  SetBorderColor(frame, 0.88, 0.74, 0.35, 1)

  frame.titleBar = CreateFrame("StatusBar", nil, frame)
  frame.titleBar:SetPoint("TOPLEFT", 2, -2)
  frame.titleBar:SetPoint("TOPRIGHT", -2, -2)
  frame.titleBar:EnableMouse(true)
  frame.titleBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
  frame.titleBar:SetStatusBarColor(0.88, 0.64, 0.16, 0.52)
  frame.titleBar:SetMinMaxValues(0, 1)
  frame.titleBar:SetValue(1)
  frame.titleBar.background = frame.titleBar:CreateTexture(nil, "BACKGROUND")
  frame.titleBar.background:SetAllPoints()
  frame.titleBar.background:SetColorTexture(0.055, 0.045, 0.025, 0.98)

  frame.countText = frame.titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  ApplyReadyCheckFont(frame.countText, 12, "OUTLINE")
  frame.countText:SetJustifyH("LEFT")
  frame.countText:SetTextColor(1, 1, 1, 1)

  frame.titleText = frame.titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  ApplyReadyCheckFont(frame.titleText, 12, "OUTLINE")
  frame.titleText:SetPoint("CENTER")
  frame.titleText:SetTextColor(0.94, 0.80, 0.42, 1)

  frame.closeButton = CreateFrame("Button", nil, frame.titleBar)
  frame.closeButton:SetPoint("RIGHT", -6, 0)
  frame.closeButton.text = frame.closeButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  ApplyReadyCheckFont(frame.closeButton.text, 16, "OUTLINE")
  frame.closeButton.text:SetPoint("CENTER", 0, 1)
  frame.closeButton.text:SetText("×")
  frame.closeButton.text:SetTextColor(0.9, 0.9, 0.9, 1)
  frame.closeButton:SetScript("OnEnter", function(button)
    button.text:SetTextColor(1, 0.25, 0.25, 1)
  end)
  frame.closeButton:SetScript("OnLeave", function(button)
    button.text:SetTextColor(0.9, 0.9, 0.9, 1)
  end)
  frame.closeButton:SetScript("OnClick", function()
    frame:Hide()
  end)

  frame.header = CreateFrame("Frame", nil, frame)
  frame.header.background = frame.header:CreateTexture(nil, "BACKGROUND")
  frame.header.background:SetAllPoints()
  frame.header.background:SetColorTexture(0.075, 0.075, 0.075, 0.98)
  frame.headerCells = {}
  frame.headerTexts = {}
  for index = 1, #COLUMNS + 2 do
    local cell = CreateHeaderCell(frame.header)
    cell.text:SetJustifyH(index == 1 and "LEFT" or "CENTER")
    frame.headerCells[index] = cell
    frame.headerTexts[index] = cell.text
  end

  frame.rows = {}
  frame.members = {}

  frame.resizeHandle = CreateFrame("Button", nil, frame)
  frame.resizeHandle:SetPoint("BOTTOMRIGHT", -2, 2)
  frame.resizeHandle:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
  frame.resizeHandle:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
  frame.resizeHandle:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
  frame.resizeHandle:SetScript("OnMouseDown", function(_, button)
    if button == "LeftButton" then
      frame:StartSizing("BOTTOMRIGHT")
    end
  end)
  frame.resizeHandle:SetScript("OnMouseUp", function()
    frame:StopMovingOrSizing()
    MerfinPlus:UpdateReadyCheckWindowLayout(true)
    MerfinPlus:SaveReadyCheckWindowGeometry()
  end)

  frame.titleBar:SetScript("OnMouseDown", function(_, button)
    if button == "LeftButton" then
      frame:StartMoving()
    end
  end)
  frame.titleBar:SetScript("OnMouseUp", function()
    frame:StopMovingOrSizing()
    MerfinPlus:SaveReadyCheckWindowGeometry()
  end)
  frame:SetScript("OnSizeChanged", function()
    MerfinPlus:UpdateReadyCheckWindowLayout(false)
  end)
  frame:SetScript("OnHide", function()
    MerfinPlus:CancelReadyCheckCountdownTimer()
    MerfinPlus.readyCheckAuraRefreshGeneration = (MerfinPlus.readyCheckAuraRefreshGeneration or 0) + 1
    MerfinPlus.readyCheckAuraRefreshPending = nil
    MerfinPlus.readyCheckDirtyAuraUnits = {}
    MerfinPlus:SaveReadyCheckWindowGeometry()
  end)

  frame:Hide()
  self.readyCheckFrame = frame
  return frame
end

function MerfinPlus:GetReadyCheckFont()
  return ResolveReadyCheckFont()
end

function MerfinPlus:CancelReadyCheckCountdownTimer()
  if self.readyCheckCountdownTimer then
    self.readyCheckCountdownTimer:Cancel()
    self.readyCheckCountdownTimer = nil
  end
end

function MerfinPlus:ScheduleReadyCheckCountdownTick()
  self:CancelReadyCheckCountdownTimer()
  local frame = self.readyCheckFrame
  if not frame or not frame:IsShown() or not frame.countdownEndsAt then
    return
  end

  local remaining = math.max(0, frame.countdownEndsAt - GetTime())
  if remaining <= 0 or not (C_Timer and C_Timer.NewTimer) then
    return
  end
  local nextDisplayedSecond = math.max(0, math.ceil(remaining) - 1)
  local delay = math.max(0.05, remaining - nextDisplayedSecond + 0.02)
  self.readyCheckCountdownTimer = C_Timer.NewTimer(delay, function()
    MerfinPlus.readyCheckCountdownTimer = nil
    MerfinPlus:UpdateReadyCheckCountdown(0, true)
    MerfinPlus:ScheduleReadyCheckCountdownTick()
  end)
end

function MerfinPlus:StartReadyCheckCountdown(seconds)
  local frame = self.readyCheckFrame
  if not frame then
    return
  end

  local duration = math.max(1, tonumber(seconds) or 1)
  frame.countdownDuration = duration
  frame.countdownEndsAt = GetTime() + duration
  self:UpdateReadyCheckCountdown(0, true)
  self:ScheduleReadyCheckCountdownTick()
end

function MerfinPlus:UpdateReadyCheckCountdown(_elapsed, _force)
  local frame = self.readyCheckFrame
  if not frame or not frame:IsShown() or not frame.countdownEndsAt then
    return
  end

  local duration = math.max(1, tonumber(frame.countdownDuration) or 1)
  local remaining = math.max(0, frame.countdownEndsAt - GetTime())
  frame.titleBar:SetMinMaxValues(0, duration)
  frame.titleBar:SetValue(math.min(duration, remaining))
  frame.titleText:SetText(self:T("MP: Ready Check (%d sec.)", math.ceil(remaining)))
end

function MerfinPlus:UpdateReadyCheckWindowLayout(fitHeight)
  local frame = self.readyCheckFrame
  if not frame then
    return
  end

  local width = frame:GetWidth() or BASE_WIDTH
  local scale = Clamp(width / BASE_WIDTH, 0.78, 1.35)
  local settings = self:GetReadyCheckSettings()
  local fontSize = Clamp(Round(settings.fontSize), 8, 24)
  local titleFontSize = Clamp(fontSize + 1, 9, 25)
  local headerFontSize = Clamp(fontSize - 2, 7, 22)
  local rowFontSize = fontSize
  local margin = 6 * scale
  local titleHeight = math.max(fontSize + 10, 24 * scale)
  local headerHeight = math.max(fontSize + 8, 21 * scale)
  local rowHeight = math.max(fontSize + 5, 19 * scale)
  frame.readyCheckScale = scale
  frame.readyCheckRowHeight = rowHeight
  local memberCount = math.max(1, #(frame.members or {}))
  local desiredHeight = Clamp(
    4 + titleHeight + (4 * scale) + headerHeight + (memberCount * rowHeight) + margin,
    MIN_HEIGHT,
    MAX_HEIGHT
  )

  if fitHeight and math.abs((frame:GetHeight() or 0) - desiredHeight) > 0.5 then
    frame.readyCheckFittingHeight = true
    frame:SetHeight(desiredHeight)
    frame.readyCheckFittingHeight = nil
  end

  frame.titleBar:SetHeight(titleHeight)
  frame.countText:ClearAllPoints()
  frame.countText:SetPoint("LEFT", 8 * scale, 0)
  ApplyReadyCheckFont(frame.countText, titleFontSize, "OUTLINE")
  ApplyReadyCheckFont(frame.titleText, titleFontSize, "OUTLINE")
  frame.closeButton:SetSize(titleHeight - 4, titleHeight - 4)
  ApplyReadyCheckFont(frame.closeButton.text, Clamp(fontSize + 5, 13, 29), "OUTLINE")

  local nameWidth = 130 * scale
  local statusWidth = 24 * scale
  local visibleColumns = GetVisibleReadyCheckColumns(settings)
  frame.visibleColumns = visibleColumns
  local columnWidths = {}
  local gridWidth = nameWidth + statusWidth
  for _, visible in ipairs(visibleColumns) do
    columnWidths[visible.index] = (visible.column.width or 48) * scale
    gridWidth = gridWidth + columnWidths[visible.index]
  end

  frame.header:ClearAllPoints()
  frame.header:SetPoint("TOP", frame, "TOP", 0, -(titleHeight + 4 * scale))
  frame.header:SetSize(gridWidth, headerHeight)
  frame.header:SetHeight(headerHeight)
  frame.resizeHandle:SetSize(18 * scale, 18 * scale)

  for _, headerCell in ipairs(frame.headerCells) do
    headerCell:Hide()
  end

  local x = 0
  local function PositionHeaderCell(headerCell, cellWidth, title, description, text, justifyLeft)
    headerCell.tooltipTitle = self:T(title)
    headerCell.tooltipDescription = self:T(description)
    headerCell.text:SetText(self:T(text))
    headerCell:ClearAllPoints()
    headerCell:SetPoint("LEFT", frame.header, "LEFT", x, 0)
    headerCell:SetSize(cellWidth, headerHeight)
    headerCell.text:ClearAllPoints()
    headerCell.text:SetPoint(justifyLeft and "LEFT" or "CENTER", headerCell, justifyLeft and "LEFT" or "CENTER", justifyLeft and 4 * scale or 0, 0)
    headerCell.text:SetWidth(cellWidth - (justifyLeft and 4 * scale or 0))
    ApplyReadyCheckFont(headerCell.text, headerFontSize, "OUTLINE")
    headerCell:Show()
    x = x + cellWidth
  end

  PositionHeaderCell(frame.headerCells[1], nameWidth, "Player", "Grouped player name", "Player", true)
  PositionHeaderCell(frame.headerCells[2], statusWidth, "Ready Status", "Waiting, ready, or not ready", "RC", false)
  for _, visible in ipairs(visibleColumns) do
    local column = visible.column
    local description
    if column.flaskElixirs then
      description = "Satisfied by a Flask, a Battle Elixir, a Guardian Elixir, or both elixirs."
    elseif column.durability then
      description = "Lowest equipped-item durability reported by MerfinPlus."
    elseif column.version then
      description = "MerfinPlus version reported by the player."
    else
      description = "Directly read from visible group auras."
    end
    PositionHeaderCell(
      frame.headerCells[visible.index + 2],
      columnWidths[visible.index],
      column.label,
      description,
      column.shortLabel or column.label,
      false
    )
  end

  for index, row in ipairs(frame.rows) do
    local member = frame.members[index]
    if member then
      row:ClearAllPoints()
      row:SetPoint("TOPLEFT", frame.header, "BOTTOMLEFT", 0, -((index - 1) * rowHeight))
      row:SetSize(gridWidth, math.max(8, rowHeight - 1))
      row.nameText:ClearAllPoints()
      row.nameText:SetPoint("LEFT", row, "LEFT", 5 * scale, 0)
      row.nameText:SetSize(nameWidth - (8 * scale), rowHeight)
      ApplyReadyCheckFont(row.nameText, rowFontSize, "OUTLINE")
      row.statusIcon:ClearAllPoints()
      row.statusIcon:SetPoint("CENTER", row, "LEFT", nameWidth + (statusWidth / 2), 0)
      local statusIconSize = math.max(10, math.min(rowHeight - 4, 15 * scale))
      row.statusIcon:SetSize(statusIconSize, statusIconSize)

      local cellX = nameWidth + statusWidth
      for _, cell in ipairs(row.cells) do
        cell:Hide()
      end
      for _, visible in ipairs(visibleColumns) do
        local cell = row.cells[visible.index]
        local columnWidth = columnWidths[visible.index]
        cell:ClearAllPoints()
        cell:SetPoint("LEFT", row, "LEFT", cellX + scale, 0)
        cell:SetSize(math.max(8, columnWidth - (2 * scale)), math.max(8, rowHeight - 2))
        LayoutReadyCheckCellIcons(cell, rowHeight, scale)
        cell.text:ClearAllPoints()
        cell.text:SetAllPoints(cell)
        ApplyReadyCheckFont(cell.text, Clamp(rowFontSize - 2, 7, 22), "OUTLINE")
        cell:Show()
        cellX = cellX + columnWidth
      end
      row:Show()
    else
      row:Hide()
    end
  end
end

function MerfinPlus:BuildReadyCheckRoster()
  local units = {}
  AddGroupUnits(units)
  local members = {}

  for rosterIndex, unit in ipairs(units) do
    if UnitExists(unit) and UnitIsPlayer(unit) then
      local fullName = GetUnitFullName(unit)
      local _, classFile = UnitClass(unit)
      local guid = UnitGUID(unit)
      if fullName then
        members[#members + 1] = {
          unit = unit,
          guid = guid,
          key = guid or NormalizeName(fullName),
          nameKey = NormalizeName(fullName),
          name = DisplayName(fullName),
          classFile = classFile,
          rosterIndex = rosterIndex,
        }
      end
    end
  end

  local settings = self:GetReadyCheckSettings()
  if settings.sortByClass or settings.sortByName then
    table.sort(members, function(left, right)
      if settings.sortByClass then
        local leftClass = left.classFile or "ZZZ"
        local rightClass = right.classFile or "ZZZ"
        if leftClass ~= rightClass then
          return leftClass < rightClass
        end
      end
      if settings.sortByName then
        local leftName = string.lower(left.name or "")
        local rightName = string.lower(right.name or "")
        if leftName ~= rightName then
          return leftName < rightName
        end
      end
      return left.rosterIndex < right.rosterIndex
    end)
  end

  return members
end

function MerfinPlus:GetStoredReadyStatus(member)
  local status = self.readyCheckStatuses and self.readyCheckStatuses[member.key]
  if not status and self.readyCheckStatusesByName then
    status = self.readyCheckStatusesByName[member.nameKey]
  end
  if not status and GetReadyCheckStatus then
    status = GetReadyCheckStatus(member.unit)
  end
  if status ~= "ready" and status ~= "notready" then
    status = "waiting"
  end
  return status
end

function MerfinPlus:SetReadyCheckAuraCell(cell, column, aura, auraMatches)
  local useIndividualIcons = column.key == "food"
  cell.categoryLabel = self:T(column.label)
  cell.auraData = useIndividualIcons and nil or aura
  cell.auraGroup = nil
  cell.durabilityValue = nil
  cell.durabilityBasisPoints = nil
  cell.versionValue = nil
  cell.localVersion = nil
  cell.isDurability = false
  cell.isVersion = false
  cell.isExpiring = false
  cell.icon2:Hide()
  cell.expiringIcon:Hide()
  if useIndividualIcons then
    local displayAuras = auraMatches
    if type(displayAuras) ~= "table" and aura then
      displayAuras = { aura }
    end
    SetReadyCheckAuraIconButtons(cell, displayAuras, cell.categoryLabel)
    cell.icon:Hide()
  elseif cell.auraIconButtons then
    SetReadyCheckAuraIconButtons(cell, nil, nil)
  end

  if not aura then
    cell.icon:Hide()
    cell.text:SetText("—")
    cell.text:SetTextColor(0.95, 0.28, 0.28, 1)
    cell.background:SetColorTexture(0.12, 0.025, 0.025, 0.82)
    SetBorderColor(cell, 0.45, 0.10, 0.10, 0.95)
    return
  end

  if not useIndividualIcons then
    cell.icon:SetTexture(aura.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
    cell.icon:SetVertexColor(1, 1, 1, 1)
    cell.icon:Show()
  end
  cell.background:SetColorTexture(0.025, 0.09, 0.035, 0.82)

  local settings = self:GetReadyCheckSettings()
  local remaining = AuraRemaining(aura, GetTime())
  local expiring = settings.showExpiring
    and remaining ~= math.huge
    and remaining <= EXPIRING_SECONDS

  if expiring then
    cell.isExpiring = true
    cell.expiringIcon:Show()
    cell.text:SetText("")
    cell.text:SetTextColor(1, 0.72, 0.10, 1)
    cell.background:SetColorTexture(0.25, 0.10, 0.01, 0.88)
    SetBorderColor(cell, 1, 0.42, 0.05, 1)
  else
    cell.text:SetText(not useIndividualIcons and (aura.matchedCount or 0) > 1
      and tostring(aura.matchedCount)
      or "")
    cell.text:SetTextColor(1, 1, 1, 1)
    SetBorderColor(cell, 0.18, 0.62, 0.25, 0.95)
  end
end

function MerfinPlus:SetReadyCheckFlaskCell(cell, auras)
  local state = GetFlaskElixirState(auras)
  cell.categoryLabel = self:T("Flask / Elixir")
  cell.auraData = nil
  cell.auraGroup = state and state.entries or nil
  cell.durabilityValue = nil
  cell.durabilityBasisPoints = nil
  cell.versionValue = nil
  cell.localVersion = nil
  cell.isDurability = false
  cell.isVersion = false
  cell.isExpiring = false
  cell.icon:Hide()
  cell.icon2:Hide()
  cell.expiringIcon:Hide()

  if not state then
    cell.text:SetText("—")
    cell.text:SetTextColor(0.95, 0.28, 0.28, 1)
    cell.background:SetColorTexture(0.12, 0.025, 0.025, 0.82)
    SetBorderColor(cell, 0.45, 0.10, 0.10, 0.95)
    return
  end

  for index, entry in ipairs(state.entries) do
    local icon = index == 1 and cell.icon or cell.icon2
    icon:SetTexture(entry.aura.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
    icon:SetVertexColor(1, 1, 1, 1)
    icon:Show()
  end

  local expiring = self:GetReadyCheckSettings().showExpiring
    and state.remaining ~= math.huge
    and state.remaining <= EXPIRING_SECONDS
  if expiring then
    cell.isExpiring = true
    cell.expiringIcon:Show()
    cell.text:SetText("")
    cell.text:SetTextColor(1, 0.72, 0.10, 1)
    cell.background:SetColorTexture(0.25, 0.10, 0.01, 0.88)
    SetBorderColor(cell, 1, 0.42, 0.05, 1)
    return
  end

  cell.text:SetText("")
  cell.icon:SetVertexColor(1, 1, 1, 1)
  cell.icon2:SetVertexColor(1, 1, 1, 1)
  cell.text:SetTextColor(1, 1, 1, 1)
  cell.background:SetColorTexture(0.025, 0.09, 0.035, 0.82)
  SetBorderColor(cell, 0.18, 0.62, 0.25, 0.95)
end

function MerfinPlus:SetReadyCheckDurabilityCell(cell, value)
  cell.categoryLabel = self:T("Durability")
  cell.auraData = nil
  cell.auraGroup = nil
  cell.durabilityValue = nil
  cell.durabilityBasisPoints = value
  cell.versionValue = nil
  cell.localVersion = nil
  cell.isDurability = true
  cell.isVersion = false
  cell.isExpiring = false
  cell.icon:Hide()
  cell.icon2:Hide()
  cell.expiringIcon:Hide()

  if value == nil then
    cell.text:SetText("?")
    cell.text:SetTextColor(0.65, 0.65, 0.65, 1)
    cell.background:SetColorTexture(0.055, 0.055, 0.055, 0.82)
    SetBorderColor(cell, 0.28, 0.28, 0.28, 0.95)
    return
  end

  local basisPoints = Clamp(Round(value), 0, DURABILITY_MAX_BASIS_POINTS)
  local wholePercent = math.floor(basisPoints / DURABILITY_BASIS_POINTS_PER_PERCENT)
  cell.durabilityBasisPoints = basisPoints
  cell.durabilityValue = wholePercent
  cell.text:SetText(string.format("%d%%", wholePercent))
  if wholePercent >= 75 then
    cell.text:SetTextColor(0.25, 1, 0.35, 1)
    SetBorderColor(cell, 0.18, 0.62, 0.25, 0.95)
  elseif wholePercent >= 50 then
    cell.text:SetTextColor(1, 0.88, 0.20, 1)
    SetBorderColor(cell, 0.75, 0.60, 0.10, 0.95)
  elseif wholePercent >= 25 then
    cell.text:SetTextColor(1, 0.55, 0.10, 1)
    SetBorderColor(cell, 0.85, 0.35, 0.05, 0.95)
  else
    cell.text:SetTextColor(1, 0.20, 0.20, 1)
    SetBorderColor(cell, 0.65, 0.08, 0.08, 0.95)
  end
  cell.background:SetColorTexture(0.035, 0.035, 0.035, 0.82)
end

function MerfinPlus:SetReadyCheckVersionCell(cell, version, responded)
  local localVersion = GetCanonicalAddonVersion()
  version = responded and NormalizeReportedVersion(version) or nil

  cell.categoryLabel = self:T("Merfin Plus")
  cell.auraData = nil
  cell.auraGroup = nil
  cell.durabilityValue = nil
  cell.durabilityBasisPoints = nil
  cell.versionValue = version
  cell.localVersion = localVersion
  cell.isDurability = false
  cell.isVersion = true
  cell.isExpiring = false
  cell.icon:Hide()
  cell.icon2:Hide()
  cell.expiringIcon:Hide()

  if not version or localVersion == "unknown" then
    cell.text:SetText("?")
    cell.text:SetTextColor(0.65, 0.65, 0.65, 1)
    cell.background:SetColorTexture(0.055, 0.055, 0.055, 0.82)
    SetBorderColor(cell, 0.28, 0.28, 0.28, 0.95)
    return
  end

  cell.text:SetText(FormatAddonVersion(version))
  if version == localVersion then
    cell.text:SetTextColor(0.25, 1, 0.35, 1)
    cell.background:SetColorTexture(0.025, 0.09, 0.035, 0.82)
    SetBorderColor(cell, 0.18, 0.62, 0.25, 0.95)
  else
    cell.text:SetTextColor(1, 0.28, 0.28, 1)
    cell.background:SetColorTexture(0.12, 0.025, 0.025, 0.82)
    SetBorderColor(cell, 0.65, 0.08, 0.08, 0.95)
  end
end

function MerfinPlus:UpdateReadyCheckResponseCount()
  local frame = self.readyCheckFrame
  if not frame or not frame:IsShown() then
    return
  end
  local responded = 0
  for _, member in ipairs(frame.members or {}) do
    if member.status == "ready" or member.status == "notready" then
      responded = responded + 1
    end
  end
  frame.countText:SetText(string.format("%s: %d/%d", self:T("Responses"), responded, #(frame.members or {})))
end

function MerfinPlus:RenderReadyCheckMember(member, options)
  local frame = self.readyCheckFrame
  local row = member and member.row
  if not frame or not row then
    return false
  end
  options = options or {}

  local auraChanged = false
  if options.auras then
    local auras = ScanUnitAuras(member.unit)
    local signature = ReadyCheckAuraSignature(auras)
    auraChanged = options.forceAuras or signature ~= member.auraSignature
    member.auras = auras
    member.auraSignature = signature
  end

  if options.static then
    local classColors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
    local color = classColors and member.classFile and classColors[member.classFile]
    if color then
      row.background:SetColorTexture(color.r, color.g, color.b, 0.42)
    else
      row.background:SetColorTexture(0.20, 0.20, 0.20, 0.42)
    end
    row.nameText:SetText(member.name)
  end

  if options.status then
    member.status = self:GetStoredReadyStatus(member)
    row.statusIcon:SetTexture(STATUS_TEXTURES[member.status] or STATUS_TEXTURES.waiting)
    row.statusIcon:Show()
  end

  for cellIndex, column in ipairs(COLUMNS) do
    local cell = row.cells[cellIndex]
    local cellChanged = false
    if column.version and options.version then
      self:SetReadyCheckVersionCell(
        cell,
        self.readyCheckVersions and self.readyCheckVersions[member.nameKey],
        self.readyCheckVersionResponded and self.readyCheckVersionResponded[member.nameKey]
      )
      cellChanged = true
    elseif column.durability and options.durability then
      self:SetReadyCheckDurabilityCell(cell, self.readyCheckDurability and self.readyCheckDurability[member.nameKey])
      cellChanged = true
    elseif not column.version and not column.durability and auraChanged then
      if column.flaskElixirs then
        self:SetReadyCheckFlaskCell(cell, member.auras)
      else
        self:SetReadyCheckAuraCell(
          cell,
          column,
          member.auras[column.key],
          member.auras.matchesByCategory and member.auras.matchesByCategory[column.key]
        )
      end
      cellChanged = true
    end

    if cellChanged and options.layoutCells and frame.readyCheckRowHeight then
      LayoutReadyCheckCellIcons(cell, frame.readyCheckRowHeight, frame.readyCheckScale)
    end
  end
  return auraChanged
end

function MerfinPlus:GetDisplayedReadyCheckMember(unitOrName)
  local frame = self.readyCheckFrame
  if not frame or not frame:IsShown() or type(unitOrName) ~= "string" then
    return nil
  end
  return (frame.membersByUnit and frame.membersByUnit[unitOrName])
    or (frame.membersByName and frame.membersByName[NormalizeName(unitOrName)])
end

function MerfinPlus:RefreshReadyCheckMember(unitOrName, options)
  local member = self:GetDisplayedReadyCheckMember(unitOrName)
  if not member then
    return false
  end
  self:RenderReadyCheckMember(member, options)
  if options and options.status then
    self:UpdateReadyCheckResponseCount()
  end
  return true
end

function MerfinPlus:IsReadyCheckSenderInGroup(sender)
  if self.readyCheckActive and self:GetDisplayedReadyCheckMember(sender) then
    return true
  end
  return IsSenderInGroup(sender)
end

function MerfinPlus:QueueReadyCheckAuraRefresh(unit)
  if not self.readyCheckActive or not self:GetDisplayedReadyCheckMember(unit) then
    return
  end
  self.readyCheckDirtyAuraUnits = self.readyCheckDirtyAuraUnits or {}
  self.readyCheckDirtyAuraUnits[unit] = true
  if self.readyCheckAuraRefreshPending then
    return
  end

  self.readyCheckAuraRefreshPending = true
  self.readyCheckAuraRefreshGeneration = (self.readyCheckAuraRefreshGeneration or 0) + 1
  local generation = self.readyCheckAuraRefreshGeneration
  local function refreshDirtyRows()
    if MerfinPlus.readyCheckAuraRefreshGeneration ~= generation then
      return
    end
    MerfinPlus.readyCheckAuraRefreshPending = nil
    local dirtyUnits = MerfinPlus.readyCheckDirtyAuraUnits or {}
    MerfinPlus.readyCheckDirtyAuraUnits = {}
    for dirtyUnit in pairs(dirtyUnits) do
      MerfinPlus:RefreshReadyCheckMember(dirtyUnit, {
        auras = true,
        layoutCells = true,
      })
    end
  end

  if C_Timer and C_Timer.After then
    C_Timer.After(0.05, refreshDirtyRows)
  else
    refreshDirtyRows()
  end
end

function MerfinPlus:RefreshReadyCheckWindow()
  local frame = self.readyCheckFrame
  if not frame or not frame:IsShown() then
    return
  end

  self.readyCheckAuraRefreshGeneration = (self.readyCheckAuraRefreshGeneration or 0) + 1
  self.readyCheckAuraRefreshPending = nil
  self.readyCheckDirtyAuraUnits = {}

  frame.members = self:BuildReadyCheckRoster()
  frame.membersByUnit = {}
  frame.membersByName = {}

  for index, member in ipairs(frame.members) do
    local row = frame.rows[index]
    if not row then
      row = CreateReadyCheckRow(frame)
      frame.rows[index] = row
    end
    member.row = row
    frame.membersByUnit[member.unit] = member
    frame.membersByName[member.nameKey] = member
    self:RenderReadyCheckMember(member, {
      auras = true,
      forceAuras = true,
      status = true,
      durability = true,
      version = true,
      static = true,
    })
  end

  for index = #frame.members + 1, #frame.rows do
    frame.rows[index]:Hide()
  end

  self:UpdateReadyCheckResponseCount()
  self:UpdateReadyCheckWindowLayout(true)
  self:UpdateReadyCheckCountdown(0, true)
end

function MerfinPlus:CancelReadyCheckHideTimer()
  if self.readyCheckHideTimer then
    self.readyCheckHideTimer:Cancel()
    self.readyCheckHideTimer = nil
  end
end

function MerfinPlus:ScheduleReadyCheckHide(seconds, updateCountdown)
  self:CancelReadyCheckHideTimer()
  if updateCountdown ~= false then
    self:StartReadyCheckCountdown(seconds)
  end
  if not (C_Timer and C_Timer.NewTimer) then
    return
  end
  self.readyCheckHideTimer = C_Timer.NewTimer(math.max(1, tonumber(seconds) or 1), function()
    MerfinPlus.readyCheckHideTimer = nil
    if MerfinPlus.readyCheckActive and not MerfinPlus.readyCheckFinished then
      MerfinPlus:HandleReadyCheckFinished()
    end
    MerfinPlus.readyCheckActive = false
    if MerfinPlus.readyCheckFrame then
      MerfinPlus.readyCheckFrame:Hide()
    end
  end)
end

function MerfinPlus:RequestReadyCheckDurability()
  local channel = GetGroupChannel()
  if not channel then
    return
  end

  local tick = math.floor((GetTime() or 0) * 1000) % 1679616
  self.readyCheckNonceCounter = ((self.readyCheckNonceCounter or 0) + 1) % 36
  self.readyCheckNonce = string.format("%05x%x", tick, self.readyCheckNonceCounter)
  self.readyCheckDurability = {}
  self.readyCheckVersions = {}
  self.readyCheckVersionResponded = {}

  local playerName = GetUnitFullName("player")
  local localDurability = CalculateLocalDurability()
  if playerName then
    local playerKey = NormalizeName(playerName)
    if localDurability ~= nil then
      self.readyCheckDurability[playerKey] = localDurability
    end
    self.readyCheckVersions[playerKey] = NormalizeReportedVersion(GetCanonicalAddonVersion())
    self.readyCheckVersionResponded[playerKey] = true
  end

  SendAddonPayload("Q:" .. self.readyCheckNonce, channel)
end

function MerfinPlus:HandleReadyCheckAddonMessage(_, prefix, message, _, sender)
  if prefix ~= ADDON_PREFIX
    or type(message) ~= "string"
    or not self:IsReadyCheckSenderInGroup(sender)
  then
    return
  end

  local requestNonce = message:match("^Q:([%w]+)$")
  if requestNonce then
    local playerName = GetUnitFullName("player")
    if NormalizeName(sender) == NormalizeName(playerName) then
      return
    end

    self.readyCheckRespondedRequests = self.readyCheckRespondedRequests or {}
    local requestKey = NormalizeName(sender) .. ":" .. requestNonce
    if self.readyCheckRespondedRequests[requestKey] then
      return
    end
    self.readyCheckRespondedRequests[requestKey] = GetTime()

    local durability = CalculateLocalDurability()
    local durabilityToken = durability ~= nil and tostring(durability) or "x"
    local version = EncodeAddonVersion(GetCanonicalAddonVersion())
    SendAddonPayload(string.format("D:%s:b%s:v%s", requestNonce, durabilityToken, version), "WHISPER", sender)
    return
  end

  local responseNonce, durabilityToken, remoteVersion = message:match("^D:([%w]+):b([%w]+):v([^:]+)$")
  if responseNonce then
    if responseNonce ~= self.readyCheckNonce then
      return
    end

    local durability
    if durabilityToken ~= "x" then
      durability = tonumber(durabilityToken)
      if not durability or durability < 0 or durability > DURABILITY_MAX_BASIS_POINTS then
        return
      end
      durability = Round(durability)
    end

    local senderKey = NormalizeName(sender)
    self.readyCheckDurability = self.readyCheckDurability or {}
    self.readyCheckVersions = self.readyCheckVersions or {}
    self.readyCheckVersionResponded = self.readyCheckVersionResponded or {}
    self.readyCheckDurability[senderKey] = durability
    self.readyCheckVersions[senderKey] = NormalizeReportedVersion(remoteVersion)
    self.readyCheckVersionResponded[senderKey] = true
    self:RefreshReadyCheckMember(sender, {
      durability = true,
      version = true,
      layoutCells = true,
    })
    return
  end

  local durabilityText
  responseNonce, durabilityText = message:match("^D:([%w]+):b(%d+)$")
  local legacyWholePercent = false
  if not responseNonce then
    responseNonce, durabilityText = message:match("^D:([%w]+):(%d%d?%d?)$")
    legacyWholePercent = responseNonce and true or false
  end
  if not responseNonce or responseNonce ~= self.readyCheckNonce then
    return
  end

  local durability = tonumber(durabilityText)
  local maximum = legacyWholePercent and 100 or DURABILITY_MAX_BASIS_POINTS
  if not durability or durability < 0 or durability > maximum then
    return
  end
  if legacyWholePercent then
    durability = durability * DURABILITY_BASIS_POINTS_PER_PERCENT
  end
  self.readyCheckDurability = self.readyCheckDurability or {}
  self.readyCheckDurability[NormalizeName(sender)] = Round(durability)
  self:RefreshReadyCheckMember(sender, {
    durability = true,
    layoutCells = true,
  })
end

function MerfinPlus:HandleReadyCheckStart(_, initiator)
  self:CancelReadyCheckHideTimer()
  self.readyCheckStatuses = {}
  self.readyCheckStatusesByName = {}
  self.readyCheckReportSent = false
  self.readyCheckFinished = false

  local initiatorName = ResolveReadyCheckName(initiator)
  local playerName = GetUnitFullName("player")
  if initiatorName and playerName and NormalizeName(initiatorName) == NormalizeName(playerName) then
    local playerGUID = UnitGUID("player")
    if playerGUID then
      self.readyCheckStatuses[playerGUID] = "ready"
    end
    self.readyCheckStatusesByName[NormalizeName(playerName)] = "ready"
  end

  if not self:IsReadyCheckDisplayAllowed() then
    self.readyCheckActive = false
    if self.readyCheckFrame then
      self.readyCheckFrame:Hide()
    end
    return
  end

  self.readyCheckActive = true
  local frame = self:CreateReadyCheckWindow()
  frame:Show()
  self:RequestReadyCheckDurability()
  self:RefreshReadyCheckWindow()

  -- Display Duration is one lifetime for the window. Only a genuinely new
  -- READY_CHECK event may establish a new deadline; confirmations and the
  -- finished event update state without extending it.
  self:ScheduleReadyCheckHide(self:GetReadyCheckSettings().displayDuration)
end

function MerfinPlus:HandleReadyCheckConfirm(_, unit, ready)
  if not self.readyCheckActive then
    return
  end

  local status = ready and "ready" or "notready"
  local guid = unit and UnitGUID(unit)
  local fullName = unit and GetUnitFullName(unit)
  if guid then
    self.readyCheckStatuses[guid] = status
  end
  if fullName then
    self.readyCheckStatusesByName[NormalizeName(fullName)] = status
  elseif type(unit) == "string" then
    self.readyCheckStatusesByName[NormalizeName(unit)] = status
  end
  self:RefreshReadyCheckMember(unit or fullName or "", {
    status = true,
  })
end

local function SendMissingList(label, names)
  if #names == 0 then
    return
  end

  local prefix = string.format(MerfinPlus:T("Ready Check - Missing %s: "), MerfinPlus:T(label))
  local message = prefix
  for index, name in ipairs(names) do
    local addition = (message == prefix and "" or ", ") .. name
    if #message + #addition > 235 and message ~= prefix then
      SendGroupChat(message)
      message = prefix .. name
    else
      message = message .. addition
    end
  end
  if message ~= prefix then
    SendGroupChat(message)
  end
end

function MerfinPlus:ReportReadyCheckCategories()
  if self.readyCheckReportSent then
    return
  end

  local settings = self:GetReadyCheckSettings()
  local selectedCategories = {}
  for _, category in ipairs(REPORT_CATEGORIES) do
    if settings[category.reportSetting] then
      selectedCategories[#selectedCategories + 1] = {
        category = category,
        missing = {},
      }
    end
  end
  if #selectedCategories == 0 then
    return
  end
  self.readyCheckReportSent = true

  local members = self:BuildReadyCheckRoster()
  for _, member in ipairs(members) do
    local auras = ScanUnitAuras(member.unit)
    for _, selected in ipairs(selectedCategories) do
      local category = selected.category
      local present = category.flaskElixirs and GetFlaskElixirState(auras)
        or (category.auraKey and auras[category.auraKey])
      if not present then
        selected.missing[#selected.missing + 1] = member.name
      end
    end
  end

  for _, selected in ipairs(selectedCategories) do
    SendMissingList(selected.category.label, selected.missing)
  end
end

function MerfinPlus:HandleReadyCheckFinished()
  if not self.readyCheckActive or self.readyCheckFinished then
    return
  end
  self.readyCheckFinished = true

  -- Blizzard's native ready-check display converts unanswered players to the
  -- not-ready state when the check times out. Mirror that final state even if
  -- GetReadyCheckStatus has already been cleared by the client.
  local frame = self.readyCheckFrame
  local members = frame and frame.members or self:BuildReadyCheckRoster()
  for _, member in ipairs(members) do
    if self:GetStoredReadyStatus(member) == "waiting" then
      self.readyCheckStatuses[member.key] = "notready"
      self.readyCheckStatusesByName[member.nameKey] = "notready"
    end
    if member.row then
      self:RenderReadyCheckMember(member, { status = true })
    end
  end
  self:UpdateReadyCheckResponseCount()
  self:ReportReadyCheckCategories()
end

function MerfinPlus:HandleReadyCheckUnitAura(_, unit)
  if not self.readyCheckActive or not self.readyCheckFrame or not self.readyCheckFrame:IsShown() then
    return
  end
  if unit == "player" or tostring(unit):match("^party%d+$") or tostring(unit):match("^raid%d+$") then
    self:QueueReadyCheckAuraRefresh(unit)
  end
end

function MerfinPlus:HandleReadyCheckRosterUpdate()
  if not self.readyCheckActive then
    return
  end
  if not GetGroupChannel() then
    self.readyCheckActive = false
    self:CancelReadyCheckHideTimer()
    if self.readyCheckFrame then
      self.readyCheckFrame:Hide()
    end
    return
  end
  self:RefreshReadyCheckWindow()
end

function MerfinPlus:InitializeReadyCheck()
  if self.readyCheckInitialized then
    return
  end
  self.readyCheckInitialized = true
  self:GetReadyCheckSettings()

  for category, spellIDs in pairs(CATEGORY_SPELLS) do
    for _, spellID in ipairs(spellIDs) do
      SPELL_CATEGORY_BY_ID[spellID] = category
      local spellName = GetSpellInfo and GetSpellInfo(spellID)
      if spellName then
        SPELL_CATEGORY_BY_NAME[spellName] = category
      end
    end
  end

  local registerPrefix = C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix or RegisterAddonMessagePrefix
  if registerPrefix then
    pcall(registerPrefix, ADDON_PREFIX)
  end

  -- A dedicated frame prevents this module from replacing AceEvent handlers
  -- already registered on the shared MerfinPlus addon object (Pull Timer uses
  -- CHAT_MSG_ADDON and GROUP_ROSTER_UPDATE as well).
  local eventFrame = CreateFrame("Frame")
  eventFrame:RegisterEvent("READY_CHECK")
  eventFrame:RegisterEvent("READY_CHECK_CONFIRM")
  eventFrame:RegisterEvent("READY_CHECK_FINISHED")
  eventFrame:RegisterEvent("CHAT_MSG_ADDON")
  eventFrame:RegisterEvent("UNIT_AURA")
  eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
  eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "READY_CHECK" then
      MerfinPlus:HandleReadyCheckStart(event, ...)
    elseif event == "READY_CHECK_CONFIRM" then
      MerfinPlus:HandleReadyCheckConfirm(event, ...)
    elseif event == "READY_CHECK_FINISHED" then
      MerfinPlus:HandleReadyCheckFinished(event, ...)
    elseif event == "CHAT_MSG_ADDON" then
      MerfinPlus:HandleReadyCheckAddonMessage(event, ...)
    elseif event == "UNIT_AURA" then
      MerfinPlus:HandleReadyCheckUnitAura(event, ...)
    elseif event == "GROUP_ROSTER_UPDATE" then
      MerfinPlus:HandleReadyCheckRosterUpdate(event, ...)
    end
  end)
  self.readyCheckEventFrame = eventFrame
end
