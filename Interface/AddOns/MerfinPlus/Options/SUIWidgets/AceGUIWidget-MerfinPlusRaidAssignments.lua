-- Guild-Manager-style TBC Raid Assignments view for the MerfinPlus AceConfig shell.

local AceGUI = LibStub("AceGUI-3.0")
local MerfinPlus = LibStub("AceAddon-3.0"):GetAddon("MerfinPlus")

local WIDGET_TYPE = "MerfinPlusRaidAssignments"
local WIDGET_VERSION = 1
local FONT = "Interface\\AddOns\\MerfinPlus\\Media\\font\\SFUIDisplayCondensed-Semibold.otf"
local DEFAULT_FONT_HEIGHT = 14
local SECTION_ROW_HEIGHT = 32
local TASK_ROW_HEIGHT = 42
local ROW_GAP = 6
local template = BackdropTemplateMixin and "BackdropTemplate" or nil

local backdrop = {
  bgFile = "Interface\\Buttons\\WHITE8X8",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  edgeSize = 14,
  insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

local colors = {
  field = { 0.035, 0.039, 0.043, 0.99 },
  panel = { 0.025, 0.028, 0.030, 0.96 },
  row = { 0.045, 0.047, 0.047, 0.96 },
  heading = { 0.075, 0.065, 0.035, 0.98 },
  hover = { 0.075, 0.079, 0.075, 1 },
  selected = { 0.12, 0.10, 0.055, 1 },
  pressed = { 0.16, 0.12, 0.035, 1 },
  menu = { 0.018, 0.021, 0.023, 1 },
  border = { 0.86, 0.58, 0.08, 0.95 },
  borderSoft = { 0.34, 0.34, 0.30, 0.9 },
  text = { 0.96, 0.96, 0.93, 1 },
  muted = { 0.56, 0.56, 0.53, 1 },
  cyan = { 0.24, 0.78, 1.00, 1 },
  good = { 0.42, 0.90, 0.46, 1 },
  red = { 0.95, 0.22, 0.18, 1 },
}

local function NormalizeKey(value)
  return tostring(value or ""):lower():gsub("[%s%p%c]+", "")
end

local CLASS_TOKENS = {
  druid = "DRUID",
  hunter = "HUNTER",
  mage = "MAGE",
  paladin = "PALADIN",
  priest = "PRIEST",
  rogue = "ROGUE",
  shaman = "SHAMAN",
  warlock = "WARLOCK",
  warrior = "WARRIOR",
}

local function GetClassToken(className)
  return CLASS_TOKENS[NormalizeKey(className)]
end

local function GetClassIcon(classToken)
  return classToken and "Interface\\AddOns\\MerfinPlus\\Media\\assignments\\icons\\Classes\\" .. classToken .. ".tga" or nil
end

local function GetSpecIcon(classToken, spec)
  return MerfinPlus:GetRaidAssignmentSpecIconPath(classToken, spec)
end

local function GetRoleIcon(spec)
  local key = NormalizeKey(spec)
  if key:find("tank", 1, true) or key == "protection" or key == "guardian" then
    return "Interface\\AddOns\\MerfinPlus\\Media\\assignments\\icons\\Roles\\tank.tga"
  end
  if key:find("heal", 1, true) or key == "holy" or key == "discipline" or key == "restoration" then
    return "Interface\\AddOns\\MerfinPlus\\Media\\assignments\\icons\\Roles\\heal.tga"
  end
  return "Interface\\AddOns\\MerfinPlus\\Media\\assignments\\icons\\Roles\\dps.tga"
end

local function GetClassColor(classToken)
  local classColor = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[classToken])
    or (RAID_CLASS_COLORS and RAID_CLASS_COLORS[classToken])
    or { r = colors.text[1], g = colors.text[2], b = colors.text[3] }
  return classColor.r or classColor[1], classColor.g or classColor[2], classColor.b or classColor[3]
end

local function SetBackdrop(frame, background, border)
  if frame.SetBackdrop then
    frame:SetBackdrop(backdrop)
    frame:SetBackdropColor(background[1], background[2], background[3], background[4])
    frame:SetBackdropBorderColor(border[1], border[2], border[3], border[4])
  end
end

local function ApplyNativeFont(fontObject, fontFile, height, flags)
  return MerfinPlus:SafeSetFontPath(fontObject, fontFile, height, flags)
end

do
  local nativeCallCount = 0
  local forwardedArgumentCount = 0
  local probe = {
    SetFont = function(_, ...)
      nativeCallCount = nativeCallCount + 1
      forwardedArgumentCount = select("#", ...)
    end,
  }
  local rejected = ApplyNativeFont(probe, "LeftButton", false, nil)
  assert(rejected == false and nativeCallCount == 0, "Raid Assignments font guard must reject invalid font values")
  local latinApplied = ApplyNativeFont(probe, "Fonts\\FRIZQT__.TTF", DEFAULT_FONT_HEIGHT, false)
  assert(latinApplied == true and nativeCallCount == 1 and forwardedArgumentCount == 2, "Raid Assignments font guard must accept the Latin fallback")
  local cyrillicApplied = ApplyNativeFont(probe, "Fonts\\FRIZQT___CYR.TTF", DEFAULT_FONT_HEIGHT, nil)
  assert(cyrillicApplied == true and nativeCallCount == 2 and forwardedArgumentCount == 2, "Raid Assignments font guard must accept the Cyrillic fallback")
end

local function ApplyWidgetFont(fontObject, size, flags)
  local height = tonumber(size)
  if not height or height <= 0 then
    height = DEFAULT_FONT_HEIGHT
  end
  local fontPath = MerfinPlus:ResolveLocalizedFontPath(FONT)
  if ApplyNativeFont(fontObject, fontPath, height, flags) then
    return true
  end
  return MerfinPlus:ApplyLocalizedFont(fontObject, FONT, height, flags) ~= nil
end

local function SetIconTexture(texture, value, fullTexture)
  local fallback
  if type(value) == "table" then
    fallback = value.fallback
    value = value.path
  end
  if not value and not fallback then
    texture:SetTexture(nil)
    texture:Hide()
    return false
  end
  local applied
  if value then
    applied = texture:SetTexture(value)
  end
  if (not value or applied == false) and fallback then
    applied = texture:SetTexture(fallback)
  end
  if applied == false then
    texture:SetTexture(nil)
    texture:Hide()
    return false
  end
  if fullTexture then
    texture:SetTexCoord(0, 1, 0, 1)
  else
    texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  end
  texture:Show()
  return true
end

local function SetButtonStyle(button, hovered, pressed, active)
  if button.disabled then
    SetBackdrop(button, colors.field, colors.borderSoft)
    button.label:SetTextColor(0.45, 0.45, 0.43, 1)
    return
  end
  local idleBackground = button.opaqueMenuRow and colors.menu or colors.field
  local background = active and colors.selected or (pressed and colors.pressed or (hovered and colors.hover or idleBackground))
  local border = (active or hovered) and colors.border or colors.borderSoft
  SetBackdrop(button, background, border)
  button.label:SetTextColor(colors.text[1], colors.text[2], colors.text[3], 1)
end

local function SetButtonEnabled(button, enabled)
  button.disabled = not enabled
  if enabled or button.keepMouseWhenDisabled then
    button:Enable()
  else
    button:Disable()
  end
  SetButtonStyle(button, false, false, button.active)
end

local function CreateButton(parent, label, width)
  local button = CreateFrame("Button", nil, parent, template)
  button:SetSize(width, 30)
  button:RegisterForClicks("AnyUp")
  button.label = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  ApplyWidgetFont(button.label, 14)
  button.label:SetPoint("CENTER")
  button.label:SetText(label)
  SetButtonStyle(button, false, false, false)
  button:SetScript("OnEnter", function(self)
    SetButtonStyle(self, true, false, self.active)
    if self.tooltipText and self.tooltipText ~= "" and GameTooltip then
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:SetText(self.tooltipTitle or self.label:GetText() or "", 1, 0.82, 0.25)
      GameTooltip:AddLine(self.tooltipText, 0.88, 0.9, 0.94, true)
      GameTooltip:Show()
    end
  end)
  button:SetScript("OnLeave", function(self)
    SetButtonStyle(self, false, false, self.active)
    if GameTooltip then GameTooltip:Hide() end
  end)
  button:SetScript("OnMouseDown", function(self)
    SetButtonStyle(self, true, true, self.active)
  end)
  button:SetScript("OnMouseUp", function(self)
    SetButtonStyle(self, self:IsMouseOver(), false, self.active)
  end)
  return button
end

local function CloseRaidMenu(self)
  self.raidMenu:Hide()
  self.raidMenuOpen = nil
end

local function RefreshRaidMenu(self)
  local groups = MerfinPlus:GetRaidAssignmentGroups()
  local selectedGroup = MerfinPlus:GetRaidAssignmentUIState().selectedGroup
  for index, option in ipairs(self.raidOptions) do
    local group = groups[index]
    option.groupID = group and group.id or nil
    if group then
      option.label:SetText(MerfinPlus:GetLocalizedRaidName(group.id, group.name))
      option.active = group.id == selectedGroup
      SetButtonStyle(option, false, false, option.active)
      option:Show()
    else
      option:Hide()
    end
  end
  self.raidMenu:SetHeight(8 + (#groups * 32))
end

local function OpenRaidMenu(self)
  if self.raidMenuOpen then
    CloseRaidMenu(self)
    return
  end
  self.raidMenuOpen = true
  self.raidMenu:ClearAllPoints()
  self.raidMenu:SetPoint("TOPLEFT", self.raidDropdown, "BOTTOMLEFT", 0, -2)
  RefreshRaidMenu(self)
  self.raidMenu:Show()
end

local function CloseSavedImportMenu(self)
  self.savedImportMenu:Hide()
  self.savedImportMenuOpen = nil
end

local function RefreshSavedImportMenu(self)
  local imports = MerfinPlus:GetSavedRaidAssignmentImports()
  for index, entry in ipairs(imports) do
    local option = self.savedImportOptions[index]
    if not option then
      option = CreateButton(self.savedImportMenu, "", 294)
      option:SetHeight(29)
      option.opaqueMenuRow = true
      option.label:SetJustifyH("LEFT")
      option.label:ClearAllPoints()
      option.label:SetPoint("LEFT", option, "LEFT", 9, 0)
      option.label:SetPoint("RIGHT", option, "RIGHT", -9, 0)
      option:SetScript("OnClick", function(row)
        CloseSavedImportMenu(self)
        local selected, selectError = MerfinPlus:SelectSavedRaidAssignmentImport(row.importID)
        if not selected then
          local state = MerfinPlus:GetRaidAssignmentUIState()
          state.status = MerfinPlus:T(selectError or "Saved Raid Assignments import is unavailable.")
          state.statusTone = "red"
          MerfinPlus:NotifyRaidAssignmentStatusChanged()
        end
      end)
      self.savedImportOptions[index] = option
    end
    option.importID = entry.id
    option:SetFrameLevel(self.savedImportMenu:GetFrameLevel() + 2)
    option:SetAlpha(1)
    option:EnableMouse(true)
    SetButtonEnabled(option, true)
    option.label:SetText(entry.savedLabel or MerfinPlus:T("Saved Raid Assignments"))
    option.active = entry.id == MerfinPlus:GetRaidAssignmentUIState().selectedSavedRaidImportID
    SetButtonStyle(option, false, false, option.active)
    option:ClearAllPoints()
    option:SetPoint("TOPLEFT", self.savedImportMenu, "TOPLEFT", 4, -4 - ((index - 1) * 32))
    option:SetPoint("TOPRIGHT", self.savedImportMenu, "TOPRIGHT", -4, -4 - ((index - 1) * 32))
    option:Show()
  end
  for index = #imports + 1, #self.savedImportOptions do
    local option = self.savedImportOptions[index]
    option.importID = nil
    option.active = false
    SetButtonEnabled(option, false)
    option:Hide()
  end
  self.savedImportMenu:SetHeight(math.max(37, 8 + (#imports * 32)))
end

local function OpenSavedImportMenu(self)
  if self.savedImportMenuOpen then
    CloseSavedImportMenu(self)
    return
  end
  self.savedImportMenuOpen = true
  self.savedImportMenu:ClearAllPoints()
  self.savedImportMenu:SetPoint("TOPLEFT", self.savedImportDropdown, "BOTTOMLEFT", 0, -2)
  self.savedImportMenu:SetFrameStrata("TOOLTIP")
  self.savedImportMenu:SetFrameLevel(math.max(100, (self.frame:GetFrameLevel() or 0) + 50))
  self.savedImportMenu:SetAlpha(1)
  SetBackdrop(self.savedImportMenu, colors.menu, colors.border)
  RefreshSavedImportMenu(self)
  self.savedImportMenu:Show()
  if self.savedImportMenu.Raise then self.savedImportMenu:Raise() end
end

local function ResetDetailRow(row)
  row:ClearAllPoints()
  row:EnableMouse(false)
  row:SetScript("OnEnter", nil)
  row:SetScript("OnLeave", nil)
  row:SetScript("OnMouseUp", nil)
  row.section:Hide()
  row.classIcon:Hide()
  row.specIcon:Hide()
  row.roleIcon:Hide()
  row.spellIcon:Hide()
  row.secondarySpellIcon:Hide()
  row.assignmentMarkerIcon:Hide()
  row.targetIcon:Hide()
  row.targetSpecIcon:Hide()
  row.name:Hide()
  row.detail:Hide()
  row.target:Hide()
end

local function ApplyTaskRowGeometry(row)
  local parentWidth = row:GetParent() and row:GetParent():GetWidth()
  local rowWidth = math.max(460, parentWidth or row:GetWidth() or 460)
  local assignmentLeft = math.max(174, math.floor(rowWidth * 0.37))
  row.classIcon:ClearAllPoints()
  row.classIcon:SetPoint("TOPLEFT", row, "TOPLEFT", 10, -8)
  row.specIcon:ClearAllPoints()
  row.specIcon:SetPoint("TOPLEFT", row.classIcon, "TOPRIGHT", 5, 0)
  row.roleIcon:ClearAllPoints()
  row.roleIcon:SetPoint("TOPLEFT", row.specIcon, "TOPRIGHT", 5, 0)
  row.name:ClearAllPoints()
  row.name:SetPoint("TOPLEFT", row.roleIcon, "TOPRIGHT", 7, 0)
  row.name:SetPoint("TOPRIGHT", row, "TOPLEFT", assignmentLeft - 8, -8)
  row.spellIcon:ClearAllPoints()
  row.spellIcon:SetPoint("TOPLEFT", row, "TOPLEFT", assignmentLeft, -8)
  row.secondarySpellIcon:ClearAllPoints()
  row.secondarySpellIcon:SetPoint("TOPLEFT", row.spellIcon, "TOPRIGHT", 4, 0)
  row.assignmentMarkerIcon:ClearAllPoints()
  row.assignmentMarkerIcon:SetPoint("TOPLEFT", row.secondarySpellIcon, "TOPRIGHT", 4, 0)
  row.detail:ClearAllPoints()
  row.detail:SetPoint("TOPLEFT", row.assignmentMarkerIcon, "TOPRIGHT", 7, 0)
  row.detail:SetPoint("TOPRIGHT", row, "TOPRIGHT", -9, -8)
  row.targetIcon:ClearAllPoints()
  row.targetIcon:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", assignmentLeft, 8)
  row.targetSpecIcon:ClearAllPoints()
  row.targetSpecIcon:SetPoint("BOTTOMLEFT", row.targetIcon, "BOTTOMRIGHT", 4, 0)
  row.target:ClearAllPoints()
  row.target:SetPoint("BOTTOMLEFT", row.targetSpecIcon, "BOTTOMRIGHT", 7, 0)
  row.target:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", -9, 8)
end

local function ApplyTaskAssignmentIconGeometry(row, hasSpellIcon, hasSecondarySpellIcon, hasAssignmentMarkerIcon)
  local parentWidth = row:GetParent() and row:GetParent():GetWidth()
  local rowWidth = math.max(460, parentWidth or row:GetWidth() or 460)
  local assignmentLeft = math.max(174, math.floor(rowWidth * 0.37))
  local previous
  for _, entry in ipairs({
    { row.spellIcon, hasSpellIcon },
    { row.secondarySpellIcon, hasSecondarySpellIcon },
    { row.assignmentMarkerIcon, hasAssignmentMarkerIcon },
  }) do
    local texture, shown = entry[1], entry[2]
    texture:ClearAllPoints()
    if shown then
      if previous then texture:SetPoint("TOPLEFT", previous, "TOPRIGHT", 4, 0)
      else texture:SetPoint("TOPLEFT", row, "TOPLEFT", assignmentLeft, -8) end
      previous = texture
    end
  end
  row.detail:ClearAllPoints()
  if previous then row.detail:SetPoint("TOPLEFT", previous, "TOPRIGHT", 7, 0)
  else row.detail:SetPoint("TOPLEFT", row, "TOPLEFT", assignmentLeft, -8) end
  row.detail:SetPoint("TOPRIGHT", row, "TOPRIGHT", -9, -8)
end

local function ApplyAdditionalTaskRowGeometry(row)
  ApplyTaskRowGeometry(row)
  row.specIcon:ClearAllPoints()
  row.specIcon:SetPoint("TOPLEFT", row, "TOPLEFT", 10, -8)
  row.name:ClearAllPoints()
  row.name:SetPoint("TOPLEFT", row.specIcon, "TOPRIGHT", 7, 0)
  local parentWidth = row:GetParent() and row:GetParent():GetWidth()
  local rowWidth = math.max(460, parentWidth or row:GetWidth() or 460)
  local assignmentLeft = math.max(174, math.floor(rowWidth * 0.37))
  row.name:SetPoint("TOPRIGHT", row, "TOPLEFT", assignmentLeft - 8, -8)
end

local function AcquireDetailRow(self, index)
  local row = self.detailRows[index]
  if row then
    return row
  end
  row = CreateFrame("Button", nil, self.detailChild, template)
  if row.SetClipsChildren then
    row:SetClipsChildren(true)
  end
  SetBackdrop(row, colors.row, colors.borderSoft)

  row.section = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  ApplyWidgetFont(row.section, 15)
  row.section:SetHeight(18)
  row.section:SetJustifyH("LEFT")
  if row.section.SetWordWrap then
    row.section:SetWordWrap(false)
  end

  row.classIcon = row:CreateTexture(nil, "ARTWORK")
  row.classIcon:SetSize(22, 22)
  row.classIcon:SetPoint("LEFT", row, "LEFT", 10, 0)
  row.specIcon = row:CreateTexture(nil, "ARTWORK")
  row.specIcon:SetSize(22, 22)
  row.specIcon:SetPoint("LEFT", row.classIcon, "RIGHT", 5, 0)
  row.roleIcon = row:CreateTexture(nil, "ARTWORK")
  row.roleIcon:SetSize(22, 22)
  row.roleIcon:SetPoint("LEFT", row.specIcon, "RIGHT", 5, 0)

  row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  ApplyWidgetFont(row.name, 13)
  row.name:SetPoint("LEFT", row.roleIcon, "RIGHT", 7, 0)
  row.name:SetJustifyH("LEFT")
  if row.name.SetWordWrap then
    row.name:SetWordWrap(true)
  end

  row.spellIcon = row:CreateTexture(nil, "ARTWORK")
  row.spellIcon:SetSize(22, 22)
  row.spellIcon:SetPoint("LEFT", row, "LEFT", 194, 0)
  row.secondarySpellIcon = row:CreateTexture(nil, "ARTWORK")
  row.secondarySpellIcon:SetSize(22, 22)
  row.assignmentMarkerIcon = row:CreateTexture(nil, "ARTWORK")
  row.assignmentMarkerIcon:SetSize(18, 18)
  row.detail = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  ApplyWidgetFont(row.detail, 12)
  row.detail:SetPoint("LEFT", row.spellIcon, "RIGHT", 7, 0)
  row.detail:SetJustifyH("LEFT")
  if row.detail.SetWordWrap then
    row.detail:SetWordWrap(true)
  end

  row.targetIcon = row:CreateTexture(nil, "ARTWORK")
  row.targetIcon:SetSize(22, 22)
  row.targetIcon:SetPoint("LEFT", row, "LEFT", 368, 0)
  row.targetSpecIcon = row:CreateTexture(nil, "ARTWORK")
  row.targetSpecIcon:SetSize(22, 22)
  row.target = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  ApplyWidgetFont(row.target, 12)
  row.target:SetPoint("LEFT", row.targetIcon, "RIGHT", 7, 0)
  row.target:SetPoint("RIGHT", row, "RIGHT", -9, 0)
  row.target:SetJustifyH("LEFT")
  if row.target.SetWordWrap then
    row.target:SetWordWrap(true)
  end
  ApplyTaskRowGeometry(row)
  self.detailRows[index] = row
  return row
end

local RefreshDetail

local function ConfigureSectionRow(self, row, entry, boss, section, collapseKey, indent)
  ResetDetailRow(row)
  collapseKey = collapseKey or section.name
  indent = indent or 0
  local collapsed = MerfinPlus:IsRaidAssignmentSectionCollapsed(entry, boss, collapseKey)
  local label, icon = MerfinPlus:GetRaidAssignmentSectionDisplay(section.displayName or section.name, section.kind)
  SetBackdrop(row, colors.heading, collapsed and colors.borderSoft or colors.border)
  row.section:ClearAllPoints()
  if icon then
    row.spellIcon:ClearAllPoints()
    row.spellIcon:SetPoint("LEFT", row, "LEFT", 10 + indent, 0)
    SetIconTexture(row.spellIcon, icon)
    row.section:SetPoint("LEFT", row.spellIcon, "RIGHT", 8, 0)
  else
    row.section:SetPoint("LEFT", row, "LEFT", 12 + indent, 0)
  end
  row.section:SetPoint("RIGHT", row, "RIGHT", -12, 0)
  row.section:SetText((collapsed and "+ " or "- ") .. tostring(label or section.name) .. "  (" .. tostring(#(section.rows or {})) .. ")")
  row.section:SetTextColor(1, 0.76, 0.12, 1)
  row.section:Show()
  row:EnableMouse(true)
  row:SetScript("OnEnter", function(selfRow)
    SetBackdrop(selfRow, colors.hover, colors.border)
  end)
  row:SetScript("OnLeave", function(selfRow)
    SetBackdrop(selfRow, colors.heading, collapsed and colors.borderSoft or colors.border)
  end)
  row:SetScript("OnMouseUp", function(_, button)
    if button == "LeftButton" then
      MerfinPlus:ToggleRaidAssignmentSection(entry, boss, collapseKey, true)
      RefreshDetail(self, self.navigation)
    end
  end)
  return collapsed
end

local function ConfigureTaskRow(row, task, playerMap, sectionName, sectionKind)
  ResetDetailRow(row)
  local display = MerfinPlus:BuildRaidAssignmentRowDisplay(task, sectionName, playerMap)
  if display.isAdditional then ApplyAdditionalTaskRowGeometry(row) else ApplyTaskRowGeometry(row) end
  SetBackdrop(row, colors.row, colors.borderSoft)
  -- The imported row is authoritative for class/spec.  A single placeholder
  -- name can legitimately represent many class/spec rows and must never make
  -- the UI reuse one arbitrary player's icons for every row.
  local classToken = GetClassToken(task.class)
  local spec = task.spec
  local spellLabel, spellIcon, secondarySpellIcon = display.label, display.icon, display.secondaryIcon
  local assignmentMarkerIcon = display.assignmentMarkerIcon
  local targetLabel, targetClassToken, targetIcon = display.target, display.targetClass, display.targetIcon
  local targetIsMarker, targetSpec = display.targetIsMarker, display.targetSpec
  local _, sectionIcon = MerfinPlus:GetRaidAssignmentSectionDisplay(sectionName, sectionKind)
  if not display.isAdditional then spellIcon = sectionIcon or spellIcon end
  if assignmentMarkerIcon == sectionIcon then assignmentMarkerIcon = nil end
  if targetIsMarker and targetIcon == spellIcon then
    targetIcon = nil
  end

  local hasClassIcon = SetIconTexture(row.classIcon, GetClassIcon(classToken))
  local hasSpecIcon = SetIconTexture(row.specIcon, GetSpecIcon(classToken, spec))
  local hasRoleIcon = SetIconTexture(row.roleIcon, GetRoleIcon(spec))
  local hasSpellIcon = SetIconTexture(row.spellIcon, spellIcon)
  local hasSecondarySpellIcon = SetIconTexture(row.secondarySpellIcon, secondarySpellIcon)
  local hasAssignmentMarkerIcon = SetIconTexture(row.assignmentMarkerIcon, assignmentMarkerIcon)
  ApplyTaskAssignmentIconGeometry(row, hasSpellIcon, hasSecondarySpellIcon, hasAssignmentMarkerIcon)
  SetIconTexture(row.targetIcon, targetIcon)
  SetIconTexture(row.targetSpecIcon, GetSpecIcon(targetClassToken, targetSpec))

  local r, g, b = GetClassColor(classToken)
  row.name:SetText(task.player or "")
  row.name:SetTextColor(r, g, b, 1)
  local detailLabel = (spellLabel or task.assignment or "")
  row.detail:SetText(detailLabel .. (display.note and display.note ~= "" and (" — " .. display.note) or ""))
  row.detail:SetTextColor(colors.muted[1], colors.muted[2], colors.muted[3], 1)
  row.target:SetText(targetLabel or "")
  if targetClassToken then
    local tr, tg, tb = GetClassColor(targetClassToken)
    row.target:SetTextColor(tr, tg, tb, 1)
  else
    row.target:SetTextColor(colors.text[1], colors.text[2], colors.text[3], 1)
  end

  if not display.isAdditional and hasClassIcon then row.classIcon:Show() end
  if hasSpecIcon then row.specIcon:Show() end
  if not display.isAdditional and hasRoleIcon then row.roleIcon:Show() end
  row.name:Show()
  if hasSpellIcon then
    row.spellIcon:Show()
  end
  if hasSecondarySpellIcon then
    row.secondarySpellIcon:Show()
  end
  if hasAssignmentMarkerIcon then row.assignmentMarkerIcon:Show() end
  row.detail:Show()
  if targetIcon then
    row.targetIcon:Show()
  end
  if targetClassToken and targetSpec then
    row.targetSpecIcon:Show()
  end
  local hasTarget = not targetIsMarker and targetLabel and targetLabel ~= ""
  if hasTarget then
    row.target:Show()
  end
  local topHeight = math.max(
    row.name:GetStringHeight() or 0,
    row.detail:GetStringHeight() or 0,
    22
  )
  local targetHeight = hasTarget and math.max(row.target:GetStringHeight() or 0, 22) or 0
  return math.max(TASK_ROW_HEIGHT, math.ceil(topHeight + targetHeight + 16))
end

local function UpdateDetailScrollGeometry(self, contentHeight)
  local childWidth = math.max(1, self.detailScroll:GetWidth() or self.detailChild:GetWidth() or 1)
  self.detailChild:SetWidth(childWidth)
  self.detailChild:SetHeight(math.max(1, contentHeight or 1))
  if self.detailScroll.UpdateScrollChildRect then
    self.detailScroll:UpdateScrollChildRect()
  end

  self.detailLayoutGeneration = (self.detailLayoutGeneration or 0) + 1
  local generation = self.detailLayoutGeneration
  local function ClampScroll()
    if self.detailLayoutGeneration ~= generation then
      return
    end
    if self.detailScroll.UpdateScrollChildRect then
      self.detailScroll:UpdateScrollChildRect()
    end
    local maximum = math.max(0, self.detailScroll:GetVerticalScrollRange() or 0)
    if self.detailScroll:GetVerticalScroll() > maximum then
      self.detailScroll:SetVerticalScroll(maximum)
    end
  end
  ClampScroll()
end

local function GetCatalogBoss(self, navigation)
  local state = MerfinPlus:GetRaidAssignmentUIState()
  if not state.selectedGroup or not state.selectedBossKey then return nil end
  local item
  for _, candidate in ipairs(navigation or {}) do
    if candidate.kind ~= "heading" and candidate.key == state.selectedBossKey then
      item = candidate
      break
    end
  end
  if navigation == nil then
    item = MerfinPlus:GetRaidAssignmentNavigationEntry(state.selectedGroup, state.selectedBossKey)
  end
  if item then return item.boss, item.raid, item.importedBoss, item end
end

RefreshDetail = function(self, navigation)
  local state = MerfinPlus:GetRaidAssignmentUIState()
  local catalogBoss, catalogRaid, navigationBoss, navigationItem = GetCatalogBoss(self, navigation)
  local entry = state.selectedGroup and MerfinPlus:GetRaidAssignmentImportForGroup(state.selectedGroup)
  local importedBoss = navigationBoss
    or (catalogBoss and entry and entry.parsed and MerfinPlus:GetRaidAssignmentBoss(entry.parsed, catalogBoss))

  if not catalogBoss then
    self.detailHeaderIcon:Hide()
    self.detailTitle:SetText(MerfinPlus:T("Select a boss"))
    self.detailSubtitle:SetText("")
    self.detailEmpty:SetText(MerfinPlus:T("Choose a boss from the list."))
    self.detailEmpty:Show()
    self.broadcastButton:Hide()
  else
    local hasHeaderIcon = SetIconTexture(self.detailHeaderIcon, catalogBoss.icon, true)
    self.detailTitle:SetText(catalogBoss.localeID
      and MerfinPlus:GetLocalizedBossName(catalogBoss.localeID, catalogBoss.name)
      or MerfinPlus:T(catalogBoss.name or "Trash"))
    self.detailSubtitle:SetText(
      catalogRaid and MerfinPlus:GetLocalizedRaidName(catalogRaid.localeID, catalogRaid.name) or ""
    )
    self.detailHeaderIcon:SetShown(hasHeaderIcon == true)
    if importedBoss then
      self.detailEmpty:Hide()
      if navigationItem and navigationItem.kind == "additional" then
        self.broadcastButton:Hide()
      else
        self.broadcastButton:Show()
        SetButtonEnabled(self.broadcastButton, true)
      end
    else
      self.detailEmpty:SetText(MerfinPlus:T("No imported assignments exist for this boss."))
      self.detailEmpty:Show()
      self.broadcastButton:Hide()
    end
  end

  local rowIndex, contentHeight = 0, 0
  local previousRow
  local function PlaceRow(row, height)
    row:ClearAllPoints()
    if previousRow then
      row:SetPoint("TOPLEFT", previousRow, "BOTTOMLEFT", 0, -ROW_GAP)
      row:SetPoint("TOPRIGHT", previousRow, "BOTTOMRIGHT", 0, -ROW_GAP)
      contentHeight = contentHeight + ROW_GAP
    else
      row:SetPoint("TOPLEFT", self.detailChild, "TOPLEFT", 0, 0)
      row:SetPoint("TOPRIGHT", self.detailChild, "TOPRIGHT", 0, 0)
    end
    row:SetHeight(height)
    row:Show()
    previousRow = row
    contentHeight = contentHeight + height
  end

  if importedBoss then
    local playerMap = MerfinPlus:BuildRaidAssignmentPlayerMap(importedBoss)
    for _, section in ipairs(MerfinPlus:GetRaidAssignmentDetailSections(importedBoss)) do
      if #(section.rows or {}) > 0 then
        rowIndex = rowIndex + 1
        local header = AcquireDetailRow(self, rowIndex)
        local collapsed = ConfigureSectionRow(self, header, entry, importedBoss, section)
        PlaceRow(header, SECTION_ROW_HEIGHT)
        if not collapsed then
          local nestedSections = section.isBuffGroup and section.rows or { section }
          for _, nestedSection in ipairs(nestedSections) do
            local nestedCollapsed = false
            if section.isBuffGroup then
              rowIndex = rowIndex + 1
              local classHeader = AcquireDetailRow(self, rowIndex)
              nestedCollapsed = ConfigureSectionRow(
                self,
                classHeader,
                entry,
                importedBoss,
                nestedSection,
                section.name .. "::" .. nestedSection.name,
                16
              )
              PlaceRow(classHeader, SECTION_ROW_HEIGHT)
            end
            if not nestedCollapsed then
              for _, rowData in ipairs(nestedSection.rows or {}) do
                rowIndex = rowIndex + 1
                local row = AcquireDetailRow(self, rowIndex)
                local task = rowData.task or rowData
                local rowHeight = ConfigureTaskRow(
                  row,
                  task,
                  playerMap,
                  rowData.sectionName or nestedSection.name,
                  nestedSection.kind
                )
                PlaceRow(row, rowHeight)
              end
            end
          end
        end
      end
    end
  end
  for index = rowIndex + 1, #self.detailRows do
    self.detailRows[index]:ClearAllPoints()
    self.detailRows[index]:Hide()
  end
  UpdateDetailScrollGeometry(self, contentHeight)
end

local function AcquireRaidHeading(self, index)
  local heading = self.raidHeadings[index]
  if heading then
    return heading
  end
  heading = CreateFrame("Frame", nil, self.bossChild, template)
  heading:SetHeight(24)
  SetBackdrop(heading, colors.heading, colors.borderSoft)
  heading.label = heading:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  ApplyWidgetFont(heading.label, 13)
  heading.label:SetPoint("LEFT", heading, "LEFT", 9, 0)
  heading.label:SetPoint("RIGHT", heading, "RIGHT", -9, 0)
  heading.label:SetJustifyH("LEFT")
  heading.label:SetTextColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 1)
  self.raidHeadings[index] = heading
  return heading
end

local function AcquireBossButton(self, index)
  local button = self.bossButtons[index]
  if button then
    return button
  end
  button = CreateButton(self.bossChild, "", 220)
  button:SetHeight(34)
  button.icon = button:CreateTexture(nil, "ARTWORK")
  button.icon:SetSize(44, 22)
  button.icon:SetPoint("LEFT", button, "LEFT", 7, 0)
  button.label:ClearAllPoints()
  button.label:SetPoint("LEFT", button.icon, "RIGHT", 7, 0)
  button.label:SetPoint("RIGHT", button, "RIGHT", -7, 0)
  button.label:SetJustifyH("LEFT")
  self.bossButtons[index] = button
  return button
end

local function RefreshBossList(self, navigation)
  local state = MerfinPlus:GetRaidAssignmentUIState()
  local group = MerfinPlus:GetRaidAssignmentGroup(state.selectedGroup)
  local entry = group and MerfinPlus:GetRaidAssignmentImportForGroup(group.id)
  local parsed = entry and entry.parsed
  local y, bossIndex, headingIndex = 0, 0, 0
  local selectedBossIsValid = state.selectedBossKey == nil
  navigation = navigation or MerfinPlus:BuildRaidAssignmentNavigation(parsed, group)
  local function AddBossButton(item)
    bossIndex = bossIndex + 1
    local button = AcquireBossButton(self, bossIndex)
    button:ClearAllPoints()
    button:SetPoint("TOPLEFT", self.bossChild, "TOPLEFT", 0, -y)
    button:SetPoint("TOPRIGHT", self.bossChild, "TOPRIGHT", 0, -y)
    button.label:SetText(MerfinPlus:T(item.title or "Raid Assignments"))
    SetIconTexture(button.icon, item.boss and item.boss.icon, true)
    if state.selectedBossKey == item.key then selectedBossIsValid = true end
    button.active = state.selectedBossKey == item.key
    SetButtonStyle(button, false, false, button.active)
    button.navigationGroupID = state.selectedGroup
    button.navigationKey = item.key
    button.navigationItem = item
    button:SetScript("OnClick", function(row)
      local selected, selectError = MerfinPlus:SelectRaidAssignmentNavigationEntry(row.navigationGroupID, row.navigationKey, row.navigationItem, true)
      if not selected then
        local currentState = MerfinPlus:GetRaidAssignmentUIState()
        currentState.status = MerfinPlus:T(selectError or "Raid Assignments entry is unavailable.")
        currentState.statusTone = "red"
        self:UpdateStatus(currentState)
        return
      end
      local currentState = MerfinPlus:GetRaidAssignmentUIState()
      for _, bossButton in ipairs(self.bossButtons) do
        if bossButton:IsShown() and bossButton.navigationKey then
          bossButton.active = bossButton.navigationKey == currentState.selectedBossKey
          SetButtonStyle(bossButton, false, false, bossButton.active)
        end
      end
      self.showBossPlanButton.hasPlan = MerfinPlus:HasRaidAssignmentBossPlan(currentState.selectedGroup, currentState.selectedBossKey)
      self.showBossPlanButton.tooltipText = self.showBossPlanButton.hasPlan
        and MerfinPlus:T("Open the complete imported MFPRA1 Boss Plan for the selected boss.")
        or MerfinPlus:T("No imported MFPRA1 Boss Plan is available for the selected raid and boss.")
      SetButtonEnabled(self.showBossPlanButton, not self.disabled and self.showBossPlanButton.hasPlan)
      RefreshDetail(self, self.navigation)
    end)
    button:Show()
    y = y + 39
  end
  for _, item in ipairs(navigation) do
    if item.kind == "heading" then
      headingIndex = headingIndex + 1
      local heading = AcquireRaidHeading(self, headingIndex)
      heading:ClearAllPoints()
      heading:SetPoint("TOPLEFT", self.bossChild, "TOPLEFT", 0, -y)
      heading:SetPoint("TOPRIGHT", self.bossChild, "TOPRIGHT", 0, -y)
      heading.label:SetText(MerfinPlus:T(item.title))
      heading:Show()
      y = y + 29
    else
      AddBossButton(item)
    end
  end
  if not selectedBossIsValid then
    state.selectedBossKey = nil
  end
  for index = bossIndex + 1, #self.bossButtons do
    self.bossButtons[index]:Hide()
  end
  for index = headingIndex + 1, #self.raidHeadings do
    self.raidHeadings[index]:Hide()
  end
  self.bossChild:SetHeight(math.max(1, y))
end

local function SetSecondaryVisible(self, visible)
  local frames = {
    self.bossPanel,
    self.detailPanel,
  }
  for _, frame in ipairs(frames) do
    if visible then
      frame:Show()
    else
      frame:Hide()
    end
  end
end

local function ImportInput(self, raw)
  local state = MerfinPlus:GetRaidAssignmentUIState()
  local entry, errorText, duplicate = MerfinPlus:ImportCanonicalRaidAssignmentSnapshot(raw, state.selectedGroup)
  if not entry then
    state.status = errorText or "Invalid MFPRA1 Raid Assignments string."
    state.statusTone = "red"
    return false, state.status
  else
    state.input = ""
    state.status = duplicate
      and "Identical MFPRA1 snapshot selected locally. Nothing was sent."
      or "MFPRA1 Raid Assignments imported locally. Nothing was sent."
    state.statusTone = "good"
    return true
  end
end

local methods = {
  OnAcquire = function(self)
    self:SetWidth(900)
    self:SetHeight(580)
    MerfinPlus:RegisterRaidAssignmentsWidget(self)
    self:Refresh()
  end,
  OnRelease = function(self)
    MerfinPlus:UnregisterRaidAssignmentsWidget(self)
    CloseRaidMenu(self)
    CloseSavedImportMenu(self)
  end,
  SetText = function() end,
  SetDisabled = function(self, disabled)
    self.disabled = disabled == true
    SetButtonEnabled(self.importButton, not self.disabled)
    SetButtonEnabled(self.savedImportDropdown, not self.disabled)
    SetButtonEnabled(self.removeSavedImportButton, not self.disabled)
    SetButtonEnabled(self.broadcastButton, not self.disabled)
    SetButtonEnabled(self.syncFullButton, not self.disabled)
    SetButtonEnabled(self.showBossPlanButton, not self.disabled and self.showBossPlanButton.hasPlan)
  end,
  UpdateStatus = function(self, state)
    state = state or MerfinPlus:GetRaidAssignmentUIState()
    self.status:SetText(MerfinPlus:LocalizeRaidAssignmentStatus(state.status))
    local tone = colors[state.statusTone or "muted"] or colors.muted
    self.status:SetTextColor(tone[1], tone[2], tone[3], tone[4])
  end,
  UpdateTransportProgress = function(self, progress)
    if not self.transportProgress then return end
    if not progress or progress.phase == "idle" then
      self.transportProgress:Hide()
      return
    end
    local confirmed = math.max(0, tonumber(progress.confirmed) or 0)
    local target = math.max(0, tonumber(progress.target) or 0)
    local phase = tostring(progress.phase or "pending")
    local suffix = phase == "preparing" and MerfinPlus:T(" (preparing)")
      or phase == "discovering" and MerfinPlus:T(" (discovering)")
      or phase == "complete" and MerfinPlus:T(" (complete)")
      or phase == "partial" and MerfinPlus:T(" (partial)")
      or phase == "local" and MerfinPlus:T(" (local)")
      or phase == "failed" and MerfinPlus:T(" (failed)")
      or ""
    local texture = phase == "failed" and "Interface\\RaidFrame\\ReadyCheck-NotReady"
      or (phase == "complete" or phase == "local") and "Interface\\RaidFrame\\ReadyCheck-Ready"
      or "Interface\\Icons\\INV_Misc_PocketWatch_01"
    local tone = phase == "failed" and colors.red
      or (phase == "complete" or phase == "local") and colors.good
      or phase == "partial" and colors.border
      or colors.cyan
    self.transportProgressIcon:SetTexture(texture)
    self.transportProgressText:SetText(MerfinPlus:T("Players %d/%d%s", confirmed, target, suffix))
    self.transportProgressText:SetTextColor(tone[1], tone[2], tone[3], 1)
    self.transportProgress.tooltipText = MerfinPlus:LocalizeRaidAssignmentStatus(progress.detail)
    self.transportProgress:Show()
  end,
  Refresh = function(self)
    local state = MerfinPlus:GetRaidAssignmentUIState()
    local group = MerfinPlus:GetRaidAssignmentGroup(state.selectedGroup)
    local entry = group and MerfinPlus:GetRaidAssignmentImportForGroup(group.id)
    local navigation = MerfinPlus:BuildRaidAssignmentNavigation(entry and entry.parsed, group)
    self.navigation = navigation
    local canTransfer, transferReason = MerfinPlus:CanCanonicalRaidAssignmentAction()
    self:UpdateTransportProgress(MerfinPlus:GetRaidAssignmentTransportProgress())
    self.importButton.label:SetText(MerfinPlus:T("Import"))
    self.savedImportText:SetText(MerfinPlus:T("Saved Imports"))
    self.removeSavedImportButton.label:SetText(MerfinPlus:T("Remove"))
    self.syncFullButton.label:SetText(MerfinPlus:T("Sync Full Assignments"))
    self.showBossPlanButton.label:SetText(MerfinPlus:T("Show Boss Plan"))
    self.broadcastButton.label:SetText(MerfinPlus:T("Send Boss Assignments"))
    self.importButton.tooltipTitle = MerfinPlus:T("Import Raid Assignments")
    self.importButton.tooltipText = MerfinPlus:T("Import one canonical MFPRA1 snapshot locally. This never sends addon data and does not require a group.")
    self.syncFullButton.tooltipTitle = MerfinPlus:T("Sync Full Assignments")
    self.syncFullButton.tooltipText = canTransfer
      and MerfinPlus:T("Explicitly broadcast the complete MFPRA1 assignment and Boss Plan snapshot.")
      or MerfinPlus:T(transferReason or "Only the raid leader or an assistant can sync.")
    self.broadcastButton.tooltipTitle = MerfinPlus:T("Send Boss Assignments")
    self.broadcastButton.tooltipText = canTransfer
      and MerfinPlus:T("Broadcast the selected boss assignment/widget delta and any matching Quick Overview Boss Plans.")
      or MerfinPlus:T(transferReason or "Only the raid leader or an assistant can send.")
    SetButtonEnabled(self.importButton, not self.disabled)
    SetButtonEnabled(self.syncFullButton, not self.disabled and canTransfer and group ~= nil)
    self.raidDropdownText:SetText(group
      and MerfinPlus:GetLocalizedRaidName(group.id, group.name)
      or MerfinPlus:T("Select Raid"))
    local selectedSaved
    for _, entry in ipairs(MerfinPlus:GetSavedRaidAssignmentImports()) do
      if entry.id == state.selectedSavedRaidImportID then
        selectedSaved = entry
        break
      end
    end
    if state.selectedSavedRaidImportID and not selectedSaved then
      state.selectedSavedRaidImportID = nil
    end
    self.savedImportText:SetText(selectedSaved and selectedSaved.savedLabel or MerfinPlus:T("Saved Imports"))
    SetButtonEnabled(self.removeSavedImportButton, not self.disabled and selectedSaved ~= nil)
    SetSecondaryVisible(self, group ~= nil)
    self:UpdateStatus(state)
    if not group then
      self.showBossPlanButton.hasPlan = false
      self.showBossPlanButton.tooltipText = MerfinPlus:T("Select a raid and import an MFPRA1 snapshot with a Boss Plan to enable this button.")
      self.showBossPlanButton:Show()
      SetButtonEnabled(self.showBossPlanButton, false)
      return
    end
    RefreshBossList(self, navigation)
    self.showBossPlanButton.hasPlan = MerfinPlus:HasRaidAssignmentBossPlan(group.id, state.selectedBossKey)
    self.showBossPlanButton.tooltipText = self.showBossPlanButton.hasPlan
      and MerfinPlus:T("Open the complete imported MFPRA1 Boss Plan for the selected boss.")
      or MerfinPlus:T("No imported MFPRA1 Boss Plan is available for the selected raid and boss.")
    self.showBossPlanButton:Show()
    SetButtonEnabled(self.showBossPlanButton, not self.disabled and self.showBossPlanButton.hasPlan)
    RefreshDetail(self, navigation)
    if self.broadcastButton:IsShown() then SetButtonEnabled(self.broadcastButton, not self.disabled and canTransfer) end
    if self.raidMenu:IsShown() then
      RefreshRaidMenu(self)
    end
    if self.savedImportMenu:IsShown() then
      RefreshSavedImportMenu(self)
    end
  end,
}

local function Constructor()
  local frame = CreateFrame("Frame", nil, UIParent)
  frame:SetHeight(580)

  local raidDropdown = CreateFrame("Button", nil, frame, template)
  raidDropdown:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
  raidDropdown:SetSize(260, 30)
  raidDropdown:RegisterForClicks("AnyUp")
  SetBackdrop(raidDropdown, colors.field, colors.border)
  local raidDropdownText = raidDropdown:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  ApplyWidgetFont(raidDropdownText, 14)
  raidDropdownText:SetPoint("LEFT", raidDropdown, "LEFT", 10, 0)
  raidDropdownText:SetPoint("RIGHT", raidDropdown, "RIGHT", -26, 0)
  raidDropdownText:SetJustifyH("LEFT")
  local arrow = raidDropdown:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  ApplyWidgetFont(arrow, 14)
  arrow:SetPoint("RIGHT", raidDropdown, "RIGHT", -10, 0)
  arrow:SetText("v")
  arrow:SetTextColor(1, 0.76, 0.08, 1)

  local raidMenu = CreateFrame("Frame", nil, UIParent, template)
  raidMenu:SetFrameStrata("TOOLTIP")
  raidMenu:SetClampedToScreen(true)
  raidMenu:SetWidth(260)
  SetBackdrop(raidMenu, colors.menu, colors.border)
  raidMenu:Hide()

  local inputWrap = CreateFrame("Frame", nil, frame, template)
  inputWrap:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -40)
  inputWrap:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -98, -40)
  inputWrap:SetHeight(30)
  SetBackdrop(inputWrap, colors.field, colors.borderSoft)
  local inputScroll = CreateFrame("ScrollFrame", nil, inputWrap)
  inputScroll:SetPoint("TOPLEFT", inputWrap, "TOPLEFT", 9, -5)
  inputScroll:SetPoint("BOTTOMRIGHT", inputWrap, "BOTTOMRIGHT", -9, 5)
  local editBox = CreateFrame("EditBox", nil, inputScroll)
  editBox:SetPoint("TOPLEFT", inputScroll, "TOPLEFT", 0, 0)
  editBox:SetWidth(1)
  editBox:SetHeight(20)
  editBox:SetAutoFocus(false)
  editBox:SetMultiLine(true)
  if editBox.SetMaxLetters then
    editBox:SetMaxLetters(0)
  end
  if editBox.SetMaxBytes then
    editBox:SetMaxBytes(0)
  end
  editBox:SetTextColor(colors.text[1], colors.text[2], colors.text[3], 1)
  ApplyWidgetFont(editBox, DEFAULT_FONT_HEIGHT)
  MerfinPlus:ConfigureAssignmentImportEditBox(editBox)
  inputScroll:SetScrollChild(editBox)
  inputScroll:EnableMouse(true)
  inputScroll:SetScript("OnMouseDown", function()
    editBox:SetFocus()
  end)
  editBox:SetScript("OnEscapePressed", function(self)
    self:ClearFocus()
  end)

  local importButton = CreateButton(frame, MerfinPlus:T("Import"), 80)
  importButton:SetPoint("LEFT", raidDropdown, "RIGHT", 8, 0)
  local savedImportDropdown = CreateButton(frame, MerfinPlus:T("Saved Imports"), 300)
  savedImportDropdown:SetPoint("LEFT", importButton, "RIGHT", 8, 0)
  savedImportDropdown.label:ClearAllPoints()
  savedImportDropdown.label:SetPoint("LEFT", savedImportDropdown, "LEFT", 9, 0)
  savedImportDropdown.label:SetPoint("RIGHT", savedImportDropdown, "RIGHT", -9, 0)
  savedImportDropdown.label:SetJustifyH("LEFT")
  local savedImportMenu = CreateFrame("Frame", nil, UIParent, template)
  savedImportMenu:SetFrameStrata("TOOLTIP")
  savedImportMenu:SetFrameLevel(100)
  savedImportMenu:SetClampedToScreen(true)
  savedImportMenu:SetWidth(302)
  savedImportMenu:EnableMouse(true)
  savedImportMenu:SetAlpha(1)
  SetBackdrop(savedImportMenu, colors.menu, colors.border)
  savedImportMenu:Hide()
  local removeSavedImportButton = CreateButton(frame, MerfinPlus:T("Remove"), 76)
  removeSavedImportButton:SetPoint("LEFT", savedImportDropdown, "RIGHT", 8, 0)
  local syncFullButton = CreateButton(frame, MerfinPlus:T("Sync Full Assignments"), 260)
  syncFullButton:SetPoint("TOPLEFT", raidDropdown, "BOTTOMLEFT", 0, -8)
  local showBossPlanButton = CreateButton(frame, MerfinPlus:T("Show Boss Plan"), 180)
  showBossPlanButton:SetPoint("LEFT", syncFullButton, "RIGHT", 8, 0)
  showBossPlanButton.keepMouseWhenDisabled = true
  showBossPlanButton.tooltipTitle = MerfinPlus:T("Show Boss Plan")
  showBossPlanButton.tooltipText = MerfinPlus:T("Select a raid and import an MFPRA1 snapshot with a Boss Plan to enable this button.")
  showBossPlanButton:Show()
  local transportProgress = CreateFrame("Frame", nil, frame)
  transportProgress:SetPoint("LEFT", showBossPlanButton, "RIGHT", 8, 0)
  transportProgress:SetSize(280, 30)
  transportProgress:EnableMouse(true)
  transportProgress:Hide()
  local transportProgressIcon = transportProgress:CreateTexture(nil, "ARTWORK")
  transportProgressIcon:SetSize(18, 18)
  transportProgressIcon:SetPoint("LEFT", transportProgress, "LEFT", 0, 0)
  transportProgressIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  local transportProgressText = transportProgress:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  ApplyWidgetFont(transportProgressText, 12)
  transportProgressText:SetPoint("LEFT", transportProgressIcon, "RIGHT", 5, 0)
  transportProgressText:SetPoint("RIGHT", transportProgress, "RIGHT", 0, 0)
  transportProgressText:SetJustifyH("LEFT")
  transportProgress:SetScript("OnEnter", function(progressFrame)
    if progressFrame.tooltipText and progressFrame.tooltipText ~= "" and GameTooltip then
      GameTooltip:SetOwner(progressFrame, "ANCHOR_TOP")
      GameTooltip:SetText(MerfinPlus:T("Assignment Transport"), 1, 0.82, 0.25)
      GameTooltip:AddLine(progressFrame.tooltipText, 0.88, 0.9, 0.94, true)
      GameTooltip:Show()
    end
  end)
  transportProgress:SetScript("OnLeave", function()
    if GameTooltip then GameTooltip:Hide() end
  end)
  local status = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  ApplyWidgetFont(status, 12)
  status:SetPoint("TOPLEFT", syncFullButton, "BOTTOMLEFT", 2, -4)
  status:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -74)
  status:SetJustifyH("LEFT")

  local bossPanel = CreateFrame("Frame", nil, frame, template)
  bossPanel:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -94)
  bossPanel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
  bossPanel:SetWidth(246)
  SetBackdrop(bossPanel, colors.panel, colors.borderSoft)
  local bossScroll = CreateFrame("ScrollFrame", nil, bossPanel)
  bossScroll:SetPoint("TOPLEFT", bossPanel, "TOPLEFT", 9, -9)
  bossScroll:SetPoint("BOTTOMRIGHT", bossPanel, "BOTTOMRIGHT", -9, 9)
  bossScroll:EnableMouseWheel(true)
  local bossChild = CreateFrame("Frame", nil, bossScroll)
  bossChild:SetSize(228, 1)
  bossScroll:SetScrollChild(bossChild)

  local detailPanel = CreateFrame("Frame", nil, frame, template)
  detailPanel:SetPoint("TOPLEFT", bossPanel, "TOPRIGHT", 10, 0)
  detailPanel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
  SetBackdrop(detailPanel, colors.panel, colors.borderSoft)
  local detailHeaderIcon = detailPanel:CreateTexture(nil, "ARTWORK")
  detailHeaderIcon:SetSize(80, 40)
  detailHeaderIcon:SetPoint("TOPLEFT", detailPanel, "TOPLEFT", 14, -14)
  local detailTitle = detailPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  ApplyWidgetFont(detailTitle, 18)
  detailTitle:SetPoint("TOPLEFT", detailHeaderIcon, "TOPRIGHT", 11, -1)
  detailTitle:SetPoint("RIGHT", detailPanel, "RIGHT", -130, -1)
  detailTitle:SetJustifyH("LEFT")
  detailTitle:SetTextColor(colors.text[1], colors.text[2], colors.text[3], 1)
  local detailSubtitle = detailPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  ApplyWidgetFont(detailSubtitle, 13)
  detailSubtitle:SetPoint("TOPLEFT", detailTitle, "BOTTOMLEFT", 0, -5)
  detailSubtitle:SetPoint("RIGHT", detailPanel, "RIGHT", -130, -5)
  detailSubtitle:SetJustifyH("LEFT")
  detailSubtitle:SetTextColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 1)
  local broadcastButton = CreateButton(detailPanel, MerfinPlus:T("Send Boss Assignments"), 150)
  broadcastButton:SetPoint("TOPRIGHT", detailPanel, "TOPRIGHT", -12, -14)

  local detailScroll = CreateFrame("ScrollFrame", nil, detailPanel)
  detailScroll:SetPoint("TOPLEFT", detailPanel, "TOPLEFT", 10, -66)
  detailScroll:SetPoint("BOTTOMRIGHT", detailPanel, "BOTTOMRIGHT", -10, 10)
  detailScroll:EnableMouseWheel(true)
  local detailChild = CreateFrame("Frame", nil, detailScroll)
  detailChild:SetSize(520, 1)
  detailChild:SetPoint("TOPLEFT", detailScroll, "TOPLEFT", 0, 0)
  detailScroll:SetScrollChild(detailChild)
  local detailEmpty = detailPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  ApplyWidgetFont(detailEmpty, 14)
  detailEmpty:SetPoint("CENTER", detailScroll, "CENTER", 0, 0)
  detailEmpty:SetWidth(360)
  detailEmpty:SetJustifyH("CENTER")
  detailEmpty:SetTextColor(colors.muted[1], colors.muted[2], colors.muted[3], 1)

  local self = {
    type = WIDGET_TYPE,
    frame = frame,
    raidDropdown = raidDropdown,
    raidDropdownText = raidDropdownText,
    raidMenu = raidMenu,
    raidOptions = {},
    inputWrap = inputWrap,
    inputScroll = inputScroll,
    editBox = editBox,
    importButton = importButton,
    savedImportDropdown = savedImportDropdown,
    savedImportText = savedImportDropdown.label,
    savedImportMenu = savedImportMenu,
    savedImportOptions = {},
    removeSavedImportButton = removeSavedImportButton,
    syncFullButton = syncFullButton,
    showBossPlanButton = showBossPlanButton,
    transportProgress = transportProgress,
    transportProgressIcon = transportProgressIcon,
    transportProgressText = transportProgressText,
    status = status,
    bossPanel = bossPanel,
    bossScroll = bossScroll,
    bossChild = bossChild,
    bossButtons = {},
    raidHeadings = {},
    detailPanel = detailPanel,
    detailHeaderIcon = detailHeaderIcon,
    detailTitle = detailTitle,
    detailSubtitle = detailSubtitle,
    broadcastButton = broadcastButton,
    detailScroll = detailScroll,
    detailChild = detailChild,
    detailEmpty = detailEmpty,
    detailRows = {},
  }
  frame.obj = self
  raidDropdown.obj = self
  importButton.obj = self
  savedImportDropdown.obj = self
  removeSavedImportButton.obj = self
  syncFullButton.obj = self
  showBossPlanButton.obj = self
  broadcastButton.obj = self

  for name, method in pairs(methods) do
    self[name] = method
  end

  for index, group in ipairs(MerfinPlus:GetRaidAssignmentGroups()) do
    local option = CreateButton(raidMenu, group.name, 252)
    option:SetHeight(29)
    option:SetPoint("TOPLEFT", raidMenu, "TOPLEFT", 4, -4 - ((index - 1) * 32))
    option:SetPoint("TOPRIGHT", raidMenu, "TOPRIGHT", -4, -4 - ((index - 1) * 32))
    option.label:SetJustifyH("LEFT")
    option.label:ClearAllPoints()
    option.label:SetPoint("LEFT", option, "LEFT", 9, 0)
    option.label:SetPoint("RIGHT", option, "RIGHT", -9, 0)
    option.groupID = group.id
    option:SetScript("OnClick", function(row)
      local state = MerfinPlus:GetRaidAssignmentUIState()
      state.selectedGroup = row.groupID
      state.selectedBossKey = nil
      state.input = ""
      state.status = ""
      state.statusTone = "muted"
      editBox:SetText("")
      CloseRaidMenu(self)
      MerfinPlus:NotifyRaidAssignmentsChanged()
    end)
    self.raidOptions[index] = option
  end

  raidDropdown:SetScript("OnClick", function()
    OpenRaidMenu(self)
  end)
  raidDropdown:SetScript("OnEnter", function(button)
    SetBackdrop(button, colors.hover, colors.border)
  end)
  raidDropdown:SetScript("OnLeave", function(button)
    SetBackdrop(button, colors.field, colors.border)
  end)
  importButton:SetScript("OnClick", function()
    if not self.disabled then
      MerfinPlus:ShowAssignmentImportDialog(MerfinPlus:T("Import Raid Assignments"), function(raw)
        return ImportInput(self, raw)
      end, MerfinPlus:T("Import"))
    end
  end)
  savedImportDropdown:SetScript("OnClick", function()
    if not self.disabled then
      OpenSavedImportMenu(self)
    end
  end)
  removeSavedImportButton:SetScript("OnClick", function()
    local importID = MerfinPlus:GetRaidAssignmentUIState().selectedSavedRaidImportID
    if importID then
      local removed, removeError = MerfinPlus:RemoveSavedRaidAssignmentImport(importID)
      if not removed then
        local state = MerfinPlus:GetRaidAssignmentUIState()
        state.status = MerfinPlus:T(removeError or "Saved Raid Assignments import is unavailable.")
        state.statusTone = "red"
        MerfinPlus:NotifyRaidAssignmentStatusChanged()
      end
    end
  end)
  syncFullButton:SetScript("OnClick", function()
    if not self.disabled then
      local state = MerfinPlus:GetRaidAssignmentUIState()
      local sent, reason = MerfinPlus:BroadcastFullRaidAssignments(state.selectedGroup, true)
      if not sent then
        state.status = MerfinPlus:T(reason or "Full Raid Assignments sync is unavailable.")
        state.statusTone = "red"
        self:UpdateStatus(state)
      end
    end
  end)
  showBossPlanButton:SetScript("OnClick", function()
    local state = MerfinPlus:GetRaidAssignmentUIState()
    if self.disabled or showBossPlanButton.disabled then
      state.status = showBossPlanButton.tooltipText or MerfinPlus:T("Import an MFPRA1 Boss Plan first.")
      state.statusTone = "muted"
      MerfinPlus:NotifyRaidAssignmentStatusChanged()
      return
    end
    local shown, reason = MerfinPlus:ShowCurrentRaidAssignmentBossPlan(state.selectedGroup, state.selectedBossKey)
    if not shown then
      state.status = MerfinPlus:T(reason or "Boss Plan is unavailable.")
      state.statusTone = "red"
      MerfinPlus:NotifyRaidAssignmentStatusChanged()
    end
  end)
  broadcastButton:SetScript("OnClick", function()
    if not self.disabled then
      local boss = GetCatalogBoss(self, self.navigation)
      if boss then
        MerfinPlus:BroadcastPersonalRaidAssignments(boss, true)
      end
    end
  end)
  editBox:SetScript("OnTextChanged", function(box)
    local text = box:GetText() or ""
    MerfinPlus:GetRaidAssignmentUIState().input = text
    local _, newlineCount = text:gsub("\n", "\n")
    box:SetHeight(math.max(inputScroll:GetHeight(), ((newlineCount + 1) * DEFAULT_FONT_HEIGHT) + 6))
  end)
  inputScroll:SetScript("OnSizeChanged", function(scrollFrame, width, height)
    editBox:SetWidth(math.max(1, width))
    local text = editBox:GetText() or ""
    local _, newlineCount = text:gsub("\n", "\n")
    editBox:SetHeight(math.max(height, ((newlineCount + 1) * DEFAULT_FONT_HEIGHT) + 6))
  end)
  bossScroll:SetScript("OnMouseWheel", function(scrollFrame, delta)
    local nextValue = scrollFrame:GetVerticalScroll() - (delta * 40)
    scrollFrame:SetVerticalScroll(math.max(0, math.min(scrollFrame:GetVerticalScrollRange(), nextValue)))
  end)
  detailScroll:SetScript("OnMouseWheel", function(scrollFrame, delta)
    local nextValue = scrollFrame:GetVerticalScroll() - (delta * 40)
    scrollFrame:SetVerticalScroll(math.max(0, math.min(scrollFrame:GetVerticalScrollRange(), nextValue)))
  end)
  detailScroll:SetScript("OnSizeChanged", function(_, width)
    local layoutWidth = math.floor(math.max(1, width or 1) + 0.5)
    detailChild:SetWidth(layoutWidth)
    if self.detailLayoutWidth == layoutWidth then return end
    self.detailLayoutWidth = layoutWidth
    RefreshDetail(self, self.navigation)
  end)
  frame:SetScript("OnSizeChanged", function(_, width)
    bossChild:SetWidth(math.max(1, bossPanel:GetWidth() - 18))
    if detailScroll:GetWidth() and detailScroll:GetWidth() > 0 then
      detailChild:SetWidth(detailScroll:GetWidth())
    else
      detailChild:SetWidth(math.max(1, width - bossPanel:GetWidth() - 40))
    end
  end)
  frame:SetScript("OnHide", function()
    CloseRaidMenu(self)
    CloseSavedImportMenu(self)
  end)
  inputWrap:Hide()

  return AceGUI:RegisterAsWidget(self)
end

AceGUI:RegisterWidgetType(WIDGET_TYPE, Constructor, WIDGET_VERSION)
