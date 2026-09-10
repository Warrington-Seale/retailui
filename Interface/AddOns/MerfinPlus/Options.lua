local MerfinPlus = LibStub("AceAddon-3.0"):GetAddon("MerfinPlus")

local aceDbOptions = LibStub("AceDBOptions-3.0")
local aceConfigDialog = LibStub("AceConfigDialog-3.0")
local aceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local aceConsole = LibStub("AceConsole-3.0")
local aceGui = LibStub("AceGUI-3.0")
local locale = MerfinPlus.L

local getAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local backdropTemplate = BackdropTemplateMixin and "BackdropTemplate" or nil
local standaloneOptionsName = "MerfinPlus_Standalone"
local defaultFrameWidth = 1040
local defaultFrameHeight = 700
local minimumFrameWidth = 760
local minimumFrameHeight = 520
local logoBadgeSize = 58
local frameInset = 1
local navDividerX = 220
local navFlareOverflow = 8
local contentLeft = 244
local contentTop = 76
local navItemHeight = 48
local panelR, panelG, panelB, panelA = 0.014, 0.022, 0.028, 0.98
local headerR, headerG, headerB, headerA = 0.012, 0.017, 0.021, 0.96
local lineR, lineG, lineB = 0.86, 0.58, 0.08
local languageFlagPaths = {
  enUS = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\flags\\flag_enUS.tga",
  deDE = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\flags\\flag_deDE.tga",
  frFR = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\flags\\flag_frFR.tga",
  esES = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\flags\\flag_esES.tga",
  esMX = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\flags\\flag_esMX.tga",
  ptBR = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\flags\\flag_ptBR.tga",
  itIT = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\flags\\flag_itIT.tga",
  ruRU = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\flags\\flag_ruRU.tga",
  zhCN = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\flags\\flag_zhCN.tga",
  zhTW = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\flags\\flag_zhTW.tga",
  koKR = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\flags\\flag_koKR.tga",
  jaJP = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\flags\\flag_jaJP.tga",
}
local optionPanelBackdrop = {
  bgFile = "Interface\\Buttons\\WHITE8X8",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  edgeSize = 16,
  insets = { left = 6, right = 6, top = 6, bottom = 6 },
}

local optionPanelBackdrop2 = {
  bgFile = "Interface\\Buttons\\WHITE8X8",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  edgeSize = 16,
  insets = { left = 3.5, right = 3.5, top = 3.5, bottom = 3.5 },
}

local function SetColor(texture, r, g, b, a)
  if texture.SetColorTexture then
    texture:SetColorTexture(r, g, b, a)
  else
    texture:SetTexture(r, g, b, a)
  end
end

local function CreateSolidTexture(parent, layer, r, g, b, a)
  local texture = parent:CreateTexture(nil, layer or "BACKGROUND")
  SetColor(texture, r, g, b, a)
  return texture
end

local function ApplyOptionsBackdrop(frame, bgAlpha, borderAlpha, a)
  if not frame.SetBackdrop then
    return
  end

  frame:SetBackdrop(not a and optionPanelBackdrop or optionPanelBackdrop2)
  frame:SetBackdropColor(panelR, panelG, panelB, bgAlpha or panelA)
  frame:SetBackdropBorderColor(0.45, 0.47, 0.49, borderAlpha or 0.75)
end

local function CreateStandaloneFrameLayout(frame)
  local headerContainer = CreateFrame("Frame", nil, frame, backdropTemplate)
  headerContainer:SetPoint("TOPLEFT", frame, "TOPLEFT", frameInset, -frameInset)
  headerContainer:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -frameInset, -frameInset)
  headerContainer:SetHeight(contentTop - (frameInset * 2))
  headerContainer:SetFrameLevel(frame:GetFrameLevel() + 20)
  ApplyOptionsBackdrop(headerContainer, headerA, 0.78)
  frame.HeaderContainer = headerContainer

  local function StartHeaderMove(_, button)
    if button == "LeftButton" then
      frame:StartMoving()
    end
  end

  local function StopHeaderMove(_, button)
    if button == "LeftButton" then
      frame:StopMovingOrSizing()
    end
  end

  frame.StartHeaderMove = StartHeaderMove
  frame.StopHeaderMove = StopHeaderMove
  headerContainer:EnableMouse(true)
  headerContainer:SetScript("OnMouseDown", StartHeaderMove)
  headerContainer:SetScript("OnMouseUp", StopHeaderMove)

  local contentContainer = CreateFrame("Frame", nil, frame, backdropTemplate)
  contentContainer:SetPoint("TOPLEFT", frame, "TOPLEFT", frameInset, -(contentTop + 2))
  contentContainer:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -frameInset, frameInset)
  ApplyOptionsBackdrop(contentContainer, panelA, 0.7, true)
  frame.ContentContainer = contentContainer

  local headerBackground = CreateSolidTexture(frame, "BORDER", headerR, headerG, headerB, headerA)
  headerBackground:SetPoint("TOPLEFT", headerContainer, "TOPLEFT", 3, -3)
  headerBackground:SetPoint("BOTTOMRIGHT", headerContainer, "BOTTOMRIGHT", -3, 3)
  frame.HeaderBackground = headerBackground

  local borderFrame = CreateFrame("Frame", nil, frame)
  borderFrame:SetAllPoints(frame)
  borderFrame:SetFrameLevel(frame:GetFrameLevel() + 50)
  borderFrame:EnableMouse(false)

  local borderTop = CreateSolidTexture(borderFrame, "OVERLAY", lineR, lineG, lineB, 1)
  borderTop:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
  borderTop:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
  borderTop:SetHeight(2)

  local borderBottom = CreateSolidTexture(borderFrame, "OVERLAY", lineR, lineG, lineB, 1)
  borderBottom:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
  borderBottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
  borderBottom:SetHeight(2)

  local borderLeft = CreateSolidTexture(borderFrame, "OVERLAY", lineR, lineG, lineB, 1)
  borderLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
  borderLeft:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 2)
  borderLeft:SetWidth(2)

  local borderRight = CreateSolidTexture(borderFrame, "OVERLAY", lineR, lineG, lineB, 1)
  borderRight:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
  borderRight:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 2)
  borderRight:SetWidth(2)

  local headerDivider = CreateSolidTexture(borderFrame, "OVERLAY", lineR, lineG, lineB, 1)
  headerDivider:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -contentTop)
  headerDivider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -contentTop)
  headerDivider:SetHeight(2)

  frame.GoldBorder = borderFrame
  frame.HeaderDivider = headerDivider

  local contentBottomLine = CreateSolidTexture(frame, "ARTWORK", lineR, lineG, lineB, 0.95)
  contentBottomLine:SetPoint("BOTTOMLEFT", contentContainer, "BOTTOMLEFT", 0, 1)
  contentBottomLine:SetPoint("BOTTOMRIGHT", contentContainer, "BOTTOMRIGHT", 0, 1)
  contentBottomLine:SetHeight(1)
  frame.ContentBottomLine = contentBottomLine

  local watermark = frame:CreateTexture(nil, "BORDER", nil, 1)
  watermark:SetTexture("Interface\\AddOns\\MerfinPlus\\Media\\options\\merfin_watermark.png")
  watermark:SetSize(360, 360)
  watermark:SetPoint("RIGHT", contentContainer, "RIGHT", 0, -18)
  watermark:SetVertexColor(0.62, 0.52, 0.26, 0.11)
  frame.ContentWatermark = watermark

  local navDivider = CreateSolidTexture(frame, "BORDER", 0.18, 0.2, 0.22, 0.9)
  navDivider:SetPoint("TOPLEFT", frame, "TOPLEFT", navDividerX, -contentTop)
  navDivider:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", navDividerX, 18)
  navDivider:SetWidth(1)
  frame.NavDivider = navDivider

  frame.TitleContainer = CreateFrame("Frame", nil, frame)
  frame.TitleContainer:SetPoint("LEFT", headerContainer, "LEFT", 88, 0)
  frame.TitleContainer:SetPoint("RIGHT", headerContainer, "RIGHT", -330, 0)
  frame.TitleContainer:SetHeight(28)
  frame.TitleContainer:SetFrameLevel(headerContainer:GetFrameLevel() + 2)
  frame.TitleContainer:EnableMouse(true)
  frame.TitleContainer:SetScript("OnMouseDown", StartHeaderMove)
  frame.TitleContainer:SetScript("OnMouseUp", StopHeaderMove)

  local titleText = frame.TitleContainer:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  MerfinPlus:ApplyLocalizedFont(
    titleText,
    "Interface\\AddOns\\MerfinPlus\\Media\\font\\SFUIDisplayCondensed-Bold.otf",
    21,
    "OUTLINE"
  )
  titleText:SetPoint("LEFT", frame.TitleContainer, "LEFT", 0, 0)
  titleText:SetJustifyH("LEFT")
  titleText:SetText("Merfin |cffffc20aPlus|r")
  titleText:SetTextColor(1, 1, 1, 1)
  titleText:SetShadowColor(0, 0, 0, 0.85)
  titleText:SetShadowOffset(0, 0)
  frame.TitleText = titleText

  local versionText = frame.TitleContainer:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  MerfinPlus:ApplyLocalizedFont(
    versionText,
    "Interface\\AddOns\\MerfinPlus\\Media\\font\\SFUIDisplayCondensed-Semibold.otf",
    14,
    "OUTLINE"
  )
  versionText:SetPoint("LEFT", titleText, "RIGHT", 10, 0)
  versionText:SetText("v" .. (getAddOnMetadata("MerfinPlus", "Version") or "???"))
  versionText:SetTextColor(0.78, 0.78, 0.75, 1)
  frame.VersionText = versionText

  frame.NavContainer = CreateFrame("Frame", nil, frame)
  frame.NavContainer:SetFrameLevel(frame:GetFrameLevel() + 5)
  frame.NavContainer:SetPoint("TOPLEFT", contentContainer, "TOPLEFT", 0, -10)
  frame.NavContainer:SetPoint("BOTTOMLEFT", contentContainer, "BOTTOMLEFT", 0, 10)
  frame.NavContainer:SetWidth(navDividerX - frameInset)

  frame.ContentContentContainer = CreateFrame("Frame", nil, frame)
  frame.ContentContentContainer:SetPoint("TOPLEFT", frame, "TOPLEFT", contentLeft, -(contentTop + 16))
  frame.ContentContentContainer:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -24, 24)

  frame.NavGroup = aceGui:Create("SimpleGroup")
  frame.NavGroup.frame:SetParent(frame.NavContainer)
  frame.NavGroup.frame:SetPoint("TOPLEFT", frame.NavContainer, "TOPLEFT", 0, 0)
  frame.NavGroup.frame:SetPoint(
    "BOTTOMRIGHT",
    frame.NavContainer,
    "BOTTOMRIGHT",
    -navFlareOverflow,
    0
  )
  frame.NavGroup:SetLayout("MerfinPlusNavList")
  frame.NavGroup:SetFullWidth(true)
  frame.NavGroup:SetFullHeight(true)

  frame.AceContainer = aceGui:Create("MerfinPlusOptionsContent")
  frame.AceContainer.frame:SetParent(frame.ContentContentContainer)
  frame.AceContainer.frame:SetAllPoints(frame.ContentContentContainer)
  frame.AceContainer:SetLayout("Fill")
  frame.AceContainer:SetFullWidth(true)
  frame.AceContainer:SetFullHeight(true)

  frame.ContentContentContainer:SetScript("OnSizeChanged", function(self, width, height)
    frame.AceContainer.frame:SetSize(width, height)
    frame.AceContainer:SetWidth(width)
    frame.AceContainer:SetHeight(height)
  end)

  frame.NavContainer:SetScript("OnSizeChanged", function(self, width, height)
    frame.NavGroup.frame:SetSize(width - navFlareOverflow, height)
    frame.NavGroup:SetWidth(width - navFlareOverflow)
    frame.NavGroup:SetHeight(height)
  end)

  return frame
end

local function PlayLogoSpin(frame)
  if frame.SpinOnce:IsPlaying() then
    frame.SpinOnce:Stop()
  end

  if frame.HoverSpin:IsPlaying() then
    frame.HoverSpin:Stop()
  end

  frame.SpinOnce:Play()
end

local function CreateLogoBadge(frame)
  local badge = CreateFrame("Frame", nil, frame.HeaderContainer)
  badge:SetPoint("LEFT", frame.HeaderContainer, "LEFT", 16, 0)
  badge:SetSize(logoBadgeSize, logoBadgeSize)
  badge:EnableMouse(true)
  badge:SetScript("OnMouseDown", frame.StartHeaderMove)
  badge:SetScript("OnMouseUp", frame.StopHeaderMove)

  local backplate = badge:CreateTexture(nil, "ARTWORK", nil, 4)
  backplate:SetTexture("Interface\\AddOns\\MerfinPlus\\Media\\options\\portrait_backplate_dark.png")
  backplate:SetTexCoord(0, 1, 0, 1)
  backplate:SetPoint("CENTER", badge, "CENTER", 0, 0)
  backplate:SetSize(logoBadgeSize, logoBadgeSize)

  local logo = badge:CreateTexture(nil, "OVERLAY", nil, 7)
  logo:SetTexture("Interface\\AddOns\\MerfinPlus\\Media\\icons\\merfinplus_logo_inner.png")
  logo:SetVertexColor(1, 1, 1, 1)
  logo:SetAlpha(1)
  logo:SetTexCoord(0, 1, 0, 1)
  logo:SetPoint("CENTER", badge, "CENTER", 0, -1)
  logo:SetSize(logoBadgeSize * 0.92, logoBadgeSize * 0.92)

  local portraitFrame = badge:CreateTexture(nil, "ARTWORK", nil, 5)
  portraitFrame:SetTexture("Interface\\AddOns\\MerfinPlus\\Media\\icons\\header_logo_border.tga")
  portraitFrame:SetTexCoord(0, 1, 0, 1)
  portraitFrame:SetPoint("CENTER", badge, "CENTER", 0, 0)
  portraitFrame:SetSize(logoBadgeSize, logoBadgeSize)
  portraitFrame:SetAlpha(1)

  frame.Badge = badge
  badge.Backplate = backplate
  badge.Logo = logo
  badge.PortraitFrame = portraitFrame

  return badge, logo
end

local function CreateCloseButton(frame)
  local button = CreateFrame("Button", nil, frame.HeaderContainer, backdropTemplate)
  button:SetPoint("RIGHT", frame.HeaderContainer, "RIGHT", -15, 0)
  button:SetSize(30, 30)
  ApplyOptionsBackdrop(button, 0.98, 0.72)

  button.Hover = CreateSolidTexture(button, "ARTWORK", 0.5, 0.03, 0.03, 0.9)
  button.Hover:SetAllPoints(button)
  button.Hover:Hide()

  button.Text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  button.Text:SetPoint("CENTER", button, "CENTER", 0, 0)
  button.Text:SetText("X")
  button.Text:SetTextColor(1, 1, 1, 1)

  button:SetScript("OnEnter", function(self)
    self.Hover:Show()
  end)
  button:SetScript("OnLeave", function(self)
    self.Hover:Hide()
  end)
  button:SetScript("OnClick", function()
    frame:Hide()
  end)

  frame.CloseButton = button
  return button
end

local function UpdateLanguageFlag(frame, localeCode)
  if not frame or not frame.LanguageFlag then
    return
  end
  frame.LanguageFlag:SetTexture(languageFlagPaths[localeCode] or languageFlagPaths.enUS)
  frame.LanguageFlag:SetTexCoord(0, 1, 0, 1)
end

local function RefreshLanguageDropdown(frame)
  local dropdown = frame and frame.LanguageDropdown
  if not dropdown then return end
  local localeCode = MerfinPlus:ApplyUILocaleSelectionToDropdown(dropdown)
  UpdateLanguageFlag(frame, localeCode)
end

local function CreateLanguageDropdown(frame)
  if not aceGui:GetWidgetVersion("MerfinPlusDropdown") then
    return
  end

  local dropdown = aceGui:Create("MerfinPlusDropdown")
  dropdown.frame:SetParent(frame.HeaderContainer)
  dropdown.frame:ClearAllPoints()
  dropdown.frame:SetPoint("RIGHT", frame.CloseButton, "LEFT", -10, 0)
  dropdown:SetWidth(215)
  dropdown:SetLabel("")
  dropdown:SetCallback("OnValueChanged", function(_, _, value)
    MerfinPlus:SetUILocale(value)
    RefreshLanguageDropdown(frame)
  end)

  local flag = frame.HeaderContainer:CreateTexture(nil, "OVERLAY", nil, 7)
  flag:SetSize(30, 22)
  flag:SetPoint("RIGHT", dropdown.frame, "LEFT", -8, 0)
  frame.LanguageFlag = flag
  frame.LanguageDropdown = dropdown
  RefreshLanguageDropdown(frame)
  frame:HookScript("OnShow", function()
    RefreshLanguageDropdown(frame)
  end)
end

local function CreateLogoAnimations(frame, texture)
  local spinOnce = texture:CreateAnimationGroup()
  local spin = spinOnce:CreateAnimation("Rotation")
  spin:SetDegrees(-360)
  spin:SetDuration(0.6)
  spin:SetStartDelay(0.6)
  spin:SetSmoothing("OUT")
  frame.SpinOnce = spinOnce

  local hoverSpin = texture:CreateAnimationGroup()
  hoverSpin:SetLooping("REPEAT")
  local hover = hoverSpin:CreateAnimation("Rotation")
  hover:SetOrder(1)
  hover:SetDegrees(-360)
  hover:SetDuration(0.6)
  hover:SetSmoothing("NONE")
  local hoverDelay = hoverSpin:CreateAnimation("Alpha")
  hoverDelay:SetOrder(2)
  hoverDelay:SetFromAlpha(1)
  hoverDelay:SetToAlpha(1)
  hoverDelay:SetDuration(0.6)
  frame.HoverSpin = hoverSpin
  hoverSpin:SetScript("OnLoop", function(self)
    if frame.StopHoverSpin then
      frame.StopHoverSpin = nil
      self:Stop()
    end
  end)

  frame:SetScript("OnEnter", function(self)
    self.StopHoverSpin = nil

    if self.SpinOnce:IsPlaying() then
      self.SpinOnce:Stop()
    end

    if not self.HoverSpin:IsPlaying() then
      self.HoverSpin:Play()
    end
  end)

  frame:SetScript("OnLeave", function(self)
    if self.HoverSpin:IsPlaying() then
      self.StopHoverSpin = true
    end
  end)

  frame:SetScript("OnHide", function(self)
    if self.SpinOnce:IsPlaying() then
      self.SpinOnce:Stop()
    end

    if self.HoverSpin:IsPlaying() then
      self.StopHoverSpin = nil
      self.HoverSpin:Stop()
    end

    if texture.SetRotation then
      texture:SetRotation(0)
    end
  end)
end

local function CreateStandaloneFrame()
  local frame = CreateFrame("Frame", "MerfinPlusOptionsFrame", UIParent, backdropTemplate)
  frame:SetSize(defaultFrameWidth, defaultFrameHeight)
  frame:SetPoint("CENTER")
  frame:SetFrameStrata("FULLSCREEN_DIALOG")
  frame:SetMovable(true)
  if frame.SetResizable then
    frame:SetResizable(true)
  end
  if frame.SetResizeBounds then
    frame:SetResizeBounds(minimumFrameWidth, minimumFrameHeight)
  elseif frame.SetMinResize then
    frame:SetMinResize(minimumFrameWidth, minimumFrameHeight)
  end
  frame:EnableMouse(true)
  frame:SetClampedToScreen(true)
  frame:Hide()

  CreateStandaloneFrameLayout(frame)

  frame.Logo, frame.LogoTexture = CreateLogoBadge(frame)
  if frame.Logo and frame.LogoTexture then
    CreateLogoAnimations(frame.Logo, frame.LogoTexture)
  end

  CreateCloseButton(frame)
  CreateLanguageDropdown(frame)

  local resizeGrip = CreateFrame("Button", nil, frame, backdropTemplate)
  resizeGrip:SetSize(30, 30)
  resizeGrip:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
  resizeGrip:SetFrameLevel(frame:GetFrameLevel() + 80)
  resizeGrip:EnableMouse(true)
  resizeGrip:RegisterForDrag("LeftButton")

  local gripLines = {}
  for index = 0, 2 do
    local startX, startY = -4, 4 + index * 6
    local endX, endY = -22 + index * 6, 22
    local lineCreated
    if resizeGrip.CreateLine then
      local line = resizeGrip:CreateLine(nil, "OVERLAY")
      local ok = pcall(function()
        line:SetColorTexture(lineR, lineG, lineB, 0.78)
        line:SetThickness(1.5)
        line:SetStartPoint("BOTTOMRIGHT", resizeGrip, "BOTTOMRIGHT", startX, startY)
        line:SetEndPoint("BOTTOMRIGHT", resizeGrip, "BOTTOMRIGHT", endX, endY)
      end)
      if ok then
        gripLines[#gripLines + 1] = line
        lineCreated = true
      else
        line:Hide()
      end
    end
    if not lineCreated then
      local delta = endY - startY
      local diagonal = CreateSolidTexture(resizeGrip, "OVERLAY", lineR, lineG, lineB, 0.78)
      diagonal:SetSize(math.sqrt(2) * delta, 1.5)
      diagonal:SetPoint(
        "CENTER", resizeGrip, "BOTTOMRIGHT",
        (startX + endX) * 0.5, (startY + endY) * 0.5
      )
      if diagonal.SetRotation then
        diagonal:SetRotation(-math.pi * 0.25)
      end
      gripLines[#gripLines + 1] = diagonal
    end
  end

  local sizing
  local function SetGripHighlight(highlighted)
    local alpha = highlighted and 1 or 0.72
    for _, texture in ipairs(gripLines) do
      texture:SetAlpha(alpha)
    end
  end
  local function StartResize(_, button)
    if button and button ~= "LeftButton" then
      return
    end
    sizing = true
    frame:StartSizing("BOTTOMRIGHT")
    SetGripHighlight(true)
  end
  local function StopResize()
    if sizing then
      frame:StopMovingOrSizing()
      sizing = nil
    end
    SetGripHighlight(false)
  end

  resizeGrip:SetScript("OnMouseDown", StartResize)
  resizeGrip:SetScript("OnMouseUp", StopResize)
  resizeGrip:SetScript("OnEnter", function()
    SetGripHighlight(true)
  end)
  resizeGrip:SetScript("OnLeave", function()
    if not sizing then
      SetGripHighlight(false)
    end
  end)
  frame.ResizeGrip = resizeGrip

  frame:SetScript("OnHide", function(self)
    self:StopMovingOrSizing()
    sizing = nil
    SetGripHighlight(false)
  end)

  tinsert(UISpecialFrames, frame:GetName())
  return frame
end

local function GetStandaloneFrame()
  if not MerfinPlus.optionsStandaloneFrame then
    MerfinPlus.optionsStandaloneFrame = CreateStandaloneFrame()
  end

  return MerfinPlus.optionsStandaloneFrame
end

-- The content frame is already fully anchored when the standalone window is
-- first shown, but AceGUI still holds its 300px OnAcquire width until the
-- outer frame is manually resized. Propagate the resolved host size once
-- before AceConfig builds child tab groups; never trigger a layout from a
-- width callback.
local function SyncStandaloneContentSize(frame)
  local host = frame and frame.ContentContentContainer
  local container = frame and frame.AceContainer
  if not host or not container or container.merfinPlusSyncingSize then
    return
  end

  local width = tonumber(host:GetWidth())
  local height = tonumber(host:GetHeight())
  if not width or width <= 0 or not height or height <= 0 then
    return
  end

  width = math.floor(width + 0.5)
  height = math.floor(height + 0.5)
  if
    container.merfinPlusSyncedWidth == width
    and container.merfinPlusSyncedHeight == height
  then
    return
  end

  container.merfinPlusSyncingSize = true
  if container.frame and container.frame.SetSize then
    container.frame:SetSize(width, height)
  end
  container:SetWidth(width)
  container:SetHeight(height)
  container.merfinPlusSyncedWidth = width
  container.merfinPlusSyncedHeight = height
  container.merfinPlusSyncingSize = nil
end

local function SetStandaloneNavigation(frame, optionSections, selectedKey, onSelect)
  if not frame.NavGroup then
    return
  end

  frame.NavGroup:ReleaseChildren()

  frame.NavWidgets = {}

  for _, section in ipairs(optionSections) do
    if section.options then
      local sectionKey = section.key
      local widget = aceGui:Create("MerfinPlusNavButton")
      widget:SetText(section.label)
      widget:SetFullWidth(true)
      widget:SetHeight(navItemHeight)
      widget:SetIcon(section.icon)

      widget:SetCallback("OnClick", function()
        onSelect(sectionKey)
      end)

      frame.NavGroup:AddChild(widget)
      frame.NavWidgets[sectionKey] = widget
      widget:SetSelected(sectionKey == selectedKey)
    end
  end
end

local function ApplyMerfinPlusDropdowns(option)
  if type(option) ~= "table" then
    return
  end
  if option.type == "select" and not option.dialogControl and not option.control then
    option.dialogControl = "MerfinPlusDropdown"
  end
  if type(option.args) == "table" then
    for _, child in pairs(option.args) do
      ApplyMerfinPlusDropdowns(child)
    end
  end
end

-- Build and register all options (Blizzard panels + standalone window + slash commands)
function MerfinPlus:SetupOptions()
  local version = getAddOnMetadata("MerfinPlus", "Version") or "???"
  local capabilities = self:GetCapabilities()
  local mediaOptions = capabilities.mediaOptions and self:BuildMediaOptions() or nil
  local raidPack = capabilities.raidPackOptions and self:BuildRaidPackOptions() or nil
  local wowSimOptions = capabilities.wowSimOptions and self:BuildWoWSimOptions() or nil
  local exportOptions = capabilities.export and self:BuildExportOptions() or nil
  local assignmentsOptions = capabilities.assignmentsOptions and self:BuildAssignmentsOptions() or nil
  local raidCooldownOptions = capabilities.raidCooldowns
    and self:BuildRaidCooldownTrackerOptions()
    or nil

  local mainSettingsOptions
  if capabilities.mainSettings then
    mainSettingsOptions = {
      type = "group",
      name = function() return self:T("Settings") end,
      args = {
        showMinimapIcon = {
          type = "toggle",
          name = function() return self:T("Show Minimap Icon") end,
          order = 10,
          width = "full",
          get = function()
            return self:GetMinimapButtonVisibleSetting()
          end,
          set = function(_, value)
            self:SetMinimapButtonVisibleSetting(value)
          end,
        },
      },
    }
  end

  local mainOptions = {
    type = "group",
    name = "MerfinPlus v" .. version,
    args = {
      version = {
        type = "description",
        name = "|cff00ccff" .. locale["Version:"] .. "|r" .. version,
        fontSize = "medium",
        order = 1,
      },
      author = {
        type = "description",
        name = locale["Author: "] .. "Merfin",
        fontSize = "medium",
        order = 2,
      },
      spacer = { type = "description", name = " ", order = 3 },
      description = {
        type = "description",
        name = locale["MerfinPlus provides custom fonts, textures, and utilities that enhance or support WeakAuras and other Merfin UI components."],
        fontSize = "large",
        order = 4,
      },
      spacer2 = { type = "description", name = " ", order = 5 },
    },
  }

  -- ==== Profiles (AceDB) ====
  local profilesOptions = aceDbOptions:GetOptionsTable(self.db)
  if capabilities.localizedProfiles then
    profilesOptions = self:CreateLocalizedProfilesOptions(profilesOptions)
  end
  profilesOptions.name = locale["Profiles"] or "Profiles" -- ensure the node has a name

  if capabilities.uiLocalization then
    self:LocalizeOptionTree(mainOptions)
    self:LocalizeOptionTree(mediaOptions)
    self:LocalizeOptionTree(wowSimOptions)
    self:LocalizeOptionTree(raidPack)
    self:LocalizeOptionTree(profilesOptions)
    self:LocalizeOptionTree(exportOptions)
    self:LocalizeOptionTree(assignmentsOptions)
    self:LocalizeOptionTree(raidCooldownOptions)
    self:LocalizeOptionTree(mainSettingsOptions)
  end

  local registeredLocalizationRoots = {
    MerfinPlus = mainOptions,
    MerfinPlus_Media = mediaOptions,
    MerfinPlus_WoWSim = wowSimOptions,
    MerfinPlus_RaidPack = raidPack,
    MerfinPlus_Profiles = profilesOptions,
    MerfinPlus_Export = exportOptions,
    MerfinPlus_Assignments = assignmentsOptions,
    MerfinPlus_RaidCooldowns = raidCooldownOptions,
    MerfinPlus_MainSettings = mainSettingsOptions,
  }
  local localizationSchemaValid, localizationSchemaError = true
  if capabilities.localizationValidation then
    localizationSchemaValid, localizationSchemaError =
      self:ValidateLocalizedOptionsTrees(registeredLocalizationRoots)
    if not localizationSchemaValid then
      error(localizationSchemaError)
    end
  end

  if aceGui:GetWidgetVersion("MerfinPlusDropdown") then
    ApplyMerfinPlusDropdowns(mainOptions)
    ApplyMerfinPlusDropdowns(mediaOptions)
    ApplyMerfinPlusDropdowns(wowSimOptions)
    ApplyMerfinPlusDropdowns(raidPack)
    ApplyMerfinPlusDropdowns(profilesOptions)
    ApplyMerfinPlusDropdowns(exportOptions)
    ApplyMerfinPlusDropdowns(assignmentsOptions)
    ApplyMerfinPlusDropdowns(raidCooldownOptions)
    ApplyMerfinPlusDropdowns(mainSettingsOptions)
  end

  -- ==== Register Blizzard panels (left AddOns pane) ====
  aceConfigRegistry:RegisterOptionsTable("MerfinPlus", mainOptions)
  self.optionsFrame = aceConfigDialog:AddToBlizOptions("MerfinPlus", "MerfinPlus v" .. version)

  if mediaOptions then
    aceConfigRegistry:RegisterOptionsTable("MerfinPlus_Media", mediaOptions)
    aceConfigDialog:AddToBlizOptions("MerfinPlus_Media", "Media", "MerfinPlus v" .. version)
  end

  if wowSimOptions then
    aceConfigRegistry:RegisterOptionsTable("MerfinPlus_WoWSim", wowSimOptions)
    aceConfigDialog:AddToBlizOptions("MerfinPlus_WoWSim", "WoW Sim", "MerfinPlus v" .. version)
  end

  if raidPack then
    aceConfigRegistry:RegisterOptionsTable("MerfinPlus_RaidPack", raidPack)
    aceConfigDialog:AddToBlizOptions("MerfinPlus_RaidPack", "Raid Settings", "MerfinPlus v" .. version)
  end

  aceConfigRegistry:RegisterOptionsTable("MerfinPlus_Profiles", profilesOptions)
  aceConfigDialog:AddToBlizOptions("MerfinPlus_Profiles", "Profiles", "MerfinPlus v" .. version)

  if exportOptions then
    aceConfigRegistry:RegisterOptionsTable("MerfinPlus_Export", exportOptions)
    aceConfigDialog:AddToBlizOptions("MerfinPlus_Export", "Export", "MerfinPlus v" .. version)
  end

  if assignmentsOptions then
    aceConfigRegistry:RegisterOptionsTable("MerfinPlus_Assignments", assignmentsOptions)
    aceConfigDialog:AddToBlizOptions("MerfinPlus_Assignments", "Assignments", "MerfinPlus v" .. version)
  end

  -- ==== Standalone window (own AceConfigDialog frame) ====
  -- IMPORTANT: include whole profilesOptions object, not just .args, to keep its handler intact.
  local standaloneOptions = {
    type = "group",
    name = "MerfinPlus v" .. version,
    args = {},
  }

  mediaOptions.childGroups = nil

  local optionSections = {}
  registeredLocalizationRoots[standaloneOptionsName] = standaloneOptions

  if raidPack then
    table.insert(optionSections, {
      key = "raidPack",
      labelKey = "Raid Settings",
      label = self:T("Raid Settings"),
      icon = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\nav_raid_settings.tga",
      aliases = { "raidpack", "raid", "rp" },
      options = raidPack,
      order = 20,
    })
  end

  if assignmentsOptions then
    table.insert(optionSections, {
      key = "assignments",
      labelKey = "Assignments",
      label = self:T("Assignments"),
      icon = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\nav_assignments.tga",
      aliases = { "assignments", "assignment", "assigns" },
      options = assignmentsOptions,
      order = 30,
    })
  end

  if raidCooldownOptions then
    table.insert(optionSections, {
      key = "raidCooldowns",
      labelKey = "Raid Cooldowns",
      label = self:T("Raid Cooldowns"),
      icon = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\nav_raid_cooldowns.tga",
      aliases = { "raidcooldowns", "cooldowns", "cooldown", "cds" },
      options = raidCooldownOptions,
      order = 35,
    })
  end

  table.insert(optionSections, {
    key = "wowSim",
    labelKey = "WoW Sim",
    label = self:T("WoW Sim"),
    icon = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\nav_wowsims.tga",
    aliases = { "wowsim", "wow", "sim", "bis" },
    options = wowSimOptions,
    order = 40,
  })

  table.insert(optionSections, {
    key = "media",
    labelKey = "Media",
    label = self:T("Media"),
    icon = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\nav_media.tga",
    aliases = { "media" },
    options = mediaOptions,
    order = 50,
  })

  table.insert(optionSections, {
    key = "profiles",
    labelKey = "Profiles",
    label = self:T("Profiles"),
    icon = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\nav_profiles.tga",
    aliases = { "profiles", "profile" },
    options = profilesOptions,
    order = 60,
  })

  if exportOptions then
    table.insert(optionSections, {
      key = "export",
      labelKey = "Export",
      label = self:T("Export"),
      icon = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\nav_export.tga",
      aliases = { "export" },
      options = exportOptions,
      order = 65,
    })
  end

  if mainSettingsOptions then
    table.insert(optionSections, {
      key = "settings",
      labelKey = "Settings",
      label = self:T("Settings"),
      icon = "Interface\\AddOns\\MerfinPlus\\Media\\icons\\nav_settings.tga",
      aliases = { "settings", "setting", "config", "options" },
      options = mainSettingsOptions,
      order = 70,
    })
  end

  local sectionsByKey = {}
  local sectionByAlias = {}

  for _, section in ipairs(optionSections) do
    if section.options then
      section.options.order = section.order
      standaloneOptions.args[section.key] = section.options
      sectionsByKey[section.key] = section

      for _, alias in ipairs(section.aliases) do
        sectionByAlias[alias] = section
      end
    end
  end

  if capabilities.localizationValidation then
    self:StripOptionLocalizationMetadata(standaloneOptions)
    localizationSchemaValid, localizationSchemaError =
      self:ValidateLocalizedOptionsTrees(registeredLocalizationRoots)
    if not localizationSchemaValid then
      error(localizationSchemaError)
    end
  end

  aceConfigRegistry:RegisterOptionsTable(standaloneOptionsName, standaloneOptions)
  aceConfigDialog:SetDefaultSize(standaloneOptionsName, 1000, 680)

  local defaultSectionKey
  for _, section in ipairs(optionSections) do
    if section.options then
      defaultSectionKey = section.key
      break
    end
  end

  local validAssignmentTabs = {
    raid = true,
    preboss = true,
    settings = true,
  }
  local validRaidCooldownTabs = {
    general = true,
    activation = true,
  }

  local function GetStoredViewState()
    local storage
    if capabilities.assignmentsOptions and type(MerfinPlus.GetRaidAssignmentStorage) == "function" then
      storage = MerfinPlus:GetRaidAssignmentStorage()
    else
      local db = MerfinPlus.db
      storage = db and db.global and db.global.assignments
      if type(storage) ~= "table" then
        return {}
      end
    end
    storage.viewState = storage.viewState or {}
    return storage.viewState
  end

  local assignmentTabWidths = { 160, 135, 90 }
  local assignmentTabsRequiredWidth = 405

  local function CompactAssignmentTabGroup(tabGroup)
    if
      not tabGroup
      or tabGroup.merfinPlusSingleRowDisabled
      or tabGroup.type ~= "TabGroup"
      or #(tabGroup.tabs or {}) < 3
    then
      return false
    end
    local expected = { "raid", "preboss", "settings" }
    for index = 1, 3 do
      if tabGroup.tabs[index].value ~= expected[index] then
        return false
      end
    end

    -- Never compact from BuildTabs/OnWidthSet itself. AceGUI's OnWidthSet calls
    -- BuildTabs, so changing layout dimensions in that callback chain can
    -- recursively re-enter the container layout. At genuinely narrow widths,
    -- leave the native (multi-row) layout untouched as the safe fallback.
    local frameWidth = tabGroup.frame and tabGroup.frame:GetWidth() or 0
    if frameWidth < assignmentTabsRequiredWidth then
      return false
    end
    if tabGroup.merfinPlusApplyingTabLayout then
      return false
    end
    if not tabGroup.frame or not tabGroup.border or not tabGroup.border.SetPoint then
      tabGroup.merfinPlusSingleRowDisabled = true
      return false
    end
    for index = 1, 3 do
      local tab = tabGroup.tabs[index]
      if not tab or not tab.ClearAllPoints or not tab.SetPoint or not tab.SetWidth then
        tabGroup.merfinPlusSingleRowDisabled = true
        return false
      end
    end
    tabGroup.merfinPlusApplyingTabLayout = true

    local compacted = pcall(function()
      local previous
      for index = 1, 3 do
        local tab = tabGroup.tabs[index]
        local width = assignmentTabWidths[index]
        tab:ClearAllPoints()
        if previous then
          tab:SetPoint("LEFT", previous, "RIGHT", -10, 0)
        else
          local hasTitle = tabGroup.titletext
            and tabGroup.titletext:GetText()
            and tabGroup.titletext:GetText() ~= ""
          tab:SetPoint("TOPLEFT", tabGroup.frame, "TOPLEFT", 0, hasTitle and -14 or -7)
        end
        tab:SetWidth(width)
        if tab.Middle then
          tab.Middle:SetWidth(math.max(1, width - 40))
        end
        if tab.MiddleDisabled then
          tab.MiddleDisabled:SetWidth(math.max(1, width - 40))
        end
        if tab.HighlightTexture then
          tab.HighlightTexture:SetWidth(width)
        end
        previous = tab
      end

      local hasTitle = tabGroup.titletext
        and tabGroup.titletext:GetText()
        and tabGroup.titletext:GetText() ~= ""
      tabGroup.borderoffset = (hasTitle and 17 or 10) + 20
      tabGroup.border:SetPoint("TOPLEFT", 1, -tabGroup.borderoffset)
    end)
    tabGroup.merfinPlusApplyingTabLayout = false
    if not compacted then
      -- Disable only this optional compaction. AceGUI's already-rendered native
      -- tabs remain the fallback and no retry loop can be entered.
      tabGroup.merfinPlusSingleRowDisabled = true
    end
    return compacted
  end

  local function KeepAssignmentTabsOnOneRow(container)
    local function FindTabGroup(widget)
      for _, child in ipairs(widget and widget.children or {}) do
        if child.type == "TabGroup" then
          local values = {}
          for _, tab in ipairs(child.tabs or {}) do
            values[tab.value] = true
          end
          if values.raid and values.settings and values.preboss then
            return child
          end
        end
        local nested = FindTabGroup(child)
        if nested then
          return nested
        end
      end
    end

    local tabGroup = FindTabGroup(container)
    if not tabGroup then
      return
    end

    local function ScheduleCompact()
      tabGroup.merfinPlusTabLayoutGeneration = (tabGroup.merfinPlusTabLayoutGeneration or 0) + 1
      local generation = tabGroup.merfinPlusTabLayoutGeneration
      local apply = function()
        if generation ~= tabGroup.merfinPlusTabLayoutGeneration then
          return
        end
        CompactAssignmentTabGroup(tabGroup)
      end
      if C_Timer and C_Timer.After then
        -- Run after AceGUI's own one-frame BuildTabsOnUpdate pass.
        C_Timer.After(0.01, apply)
      end
    end

    if not tabGroup.merfinPlusSingleRowSizeHooked then
      tabGroup.frame:HookScript("OnSizeChanged", function()
        if not tabGroup.merfinPlusApplyingTabLayout then
          ScheduleCompact()
        end
      end)
      tabGroup.merfinPlusSingleRowSizeHooked = true
    end
    ScheduleCompact()
  end

  function MerfinPlus:SaveAssignmentOptionsViewState()
    local viewState = GetStoredViewState()
    -- AceConfig's status table is rebuilt during a locale refresh and can
    -- briefly report its first group. The selected navigation widget is the
    -- visible source of truth and preserves the page the user is viewing.
    local selectedMain
    local frame = self.optionsStandaloneFrame
    for sectionKey, widget in pairs((frame and frame.NavWidgets) or {}) do
      if widget and widget.selected and sectionsByKey[sectionKey] then
        selectedMain = sectionKey
        break
      end
    end
    if not selectedMain then
      local rootStatus = aceConfigDialog:GetStatusTable(standaloneOptionsName)
      selectedMain = rootStatus and rootStatus.groups and rootStatus.groups.selected
    end
    if selectedMain and sectionsByKey[selectedMain] then
      viewState.activeMainNav = selectedMain
    end
    if assignmentsOptions then
      local assignmentStatus = aceConfigDialog:GetStatusTable(standaloneOptionsName, { "assignments" })
      local selectedTab = assignmentStatus and assignmentStatus.groups and assignmentStatus.groups.selected
      if validAssignmentTabs[selectedTab] then
        viewState.activeAssignmentsTab = selectedTab
      end
    end
    if raidCooldownOptions then
      local raidCooldownStatus = aceConfigDialog:GetStatusTable(
        standaloneOptionsName,
        { "raidCooldowns" }
      )
      local selectedRaidCooldownTab = raidCooldownStatus
        and raidCooldownStatus.groups
        and raidCooldownStatus.groups.selected
      if validRaidCooldownTabs[selectedRaidCooldownTab] then
        viewState.activeRaidCooldownsTab = selectedRaidCooldownTab
      end
    end
  end

  local standaloneFrame = GetStandaloneFrame()
  if not standaloneFrame.merfinPlusViewStateHooked then
    standaloneFrame:HookScript("OnHide", function()
      MerfinPlus:SaveAssignmentOptionsViewState()
    end)
    standaloneFrame.merfinPlusViewStateHooked = true
  end
  self:RegisterEvent("PLAYER_LOGOUT", "SaveAssignmentOptionsViewState")

  -- Toggle standalone and optionally preselect section/subtab
  function MerfinPlus:ToggleStandalone(which, sub)
    local frame = GetStandaloneFrame()
    local viewState = GetStoredViewState()

    if frame:IsShown() and not which then
      self:SaveAssignmentOptionsViewState()
      frame:Hide()
      return
    end

    frame:Show()
    SyncStandaloneContentSize(frame)
    if frame.Logo then
      if not frame.Logo.SpinOnce:IsPlaying() then
        PlayLogoSpin(frame.Logo)
      end
    end

    local selectedKey = which and sectionsByKey[which] and which
      or (sectionsByKey[viewState.activeMainNav] and viewState.activeMainNav)
      or defaultSectionKey
    viewState.activeMainNav = selectedKey
    if selectedKey == "assignments" then
      if not validAssignmentTabs[sub] then
        sub = validAssignmentTabs[viewState.activeAssignmentsTab] and viewState.activeAssignmentsTab or "raid"
      end
      viewState.activeAssignmentsTab = sub
    elseif selectedKey == "raidCooldowns" then
      if not validRaidCooldownTabs[sub] then
        sub = validRaidCooldownTabs[viewState.activeRaidCooldownsTab]
          and viewState.activeRaidCooldownsTab
          or "general"
      end
      viewState.activeRaidCooldownsTab = sub
    end
    SetStandaloneNavigation(frame, optionSections, selectedKey, function(key)
      MerfinPlus:SaveAssignmentOptionsViewState()
      GetStoredViewState().activeMainNav = key
      MerfinPlus:ToggleStandalone(key)
    end)

    if selectedKey and sectionsByKey[selectedKey] then
      if sub then
        -- Store the child selection, but render from the parent group. Opening
        -- the full leaf path bypasses AceConfig's TabGroup and hides its tabs.
        aceConfigDialog:SelectGroup(standaloneOptionsName, selectedKey, sub)
      end
      aceConfigDialog:Open(standaloneOptionsName, frame.AceContainer, selectedKey)
      if selectedKey == "assignments" then
        KeepAssignmentTabsOnOneRow(frame.AceContainer)
      end
      self:ApplyLocalizedFontsToFrame(frame)
    else
      aceConfigDialog:Open(standaloneOptionsName, frame.AceContainer)
      self:ApplyLocalizedFontsToFrame(frame)
    end
    -- The first login builds the standalone frame before AceConfig has laid
    -- out its content. Rebind after that initial layout so both the stored
    -- value and its visible top-right label are present on the first open.
    RefreshLanguageDropdown(frame)
    if C_Timer and C_Timer.After then
      -- The host size becomes final one frame after AceConfig creates nested
      -- TabGroups. Run the same one-shot size propagation as a real resize.
      C_Timer.After(0, function()
        if frame:IsShown() then
          SyncStandaloneContentSize(frame)
        end
      end)
    end
  end

  self.merfinPlusLocalizationRoots = registeredLocalizationRoots
  self.merfinPlusLocalizationSections = optionSections

  function MerfinPlus:RefreshUILocale()
    local frame = self.optionsStandaloneFrame
    local wasShown = frame and frame:IsShown()
    if wasShown then
      self:SaveAssignmentOptionsViewState()
    end

    for _, root in pairs(self.merfinPlusLocalizationRoots or {}) do
      self:StripOptionLocalizationMetadata(root)
      self:LocalizeOptionTree(root)
      self:StripOptionLocalizationMetadata(root)
    end
    for _, section in ipairs(self.merfinPlusLocalizationSections or {}) do
      section.label = self:T(section.labelKey or section.label)
    end

    if frame and frame.LanguageDropdown then
      RefreshLanguageDropdown(frame)
    end
    if self.RefreshAssignmentWidgetLocale then
      self:RefreshAssignmentWidgetLocale()
    end
    if self.RefreshVersionCheckLocale then
      self:RefreshVersionCheckLocale()
    end
    if self.RefreshReadyCheckWindow then
      self:RefreshReadyCheckWindow()
    end
    if StaticPopupDialogs.MERFINPLUS_DELETE_RECORDED_RAID then
      StaticPopupDialogs.MERFINPLUS_DELETE_RECORDED_RAID.text =
        self:T("Delete the selected recorded raid?\n\n%s")
      StaticPopupDialogs.MERFINPLUS_DELETE_RECORDED_RAID.button1 = self:T("Delete")
      StaticPopupDialogs.MERFINPLUS_DELETE_RECORDED_RAID.button2 = self:T("Cancel")
    end

    local schemaValid, schemaError =
      self:ValidateLocalizedOptionsTrees(self.merfinPlusLocalizationRoots)
    if not schemaValid then
      self:PrettyPrint("Localization refresh stopped: " .. tostring(schemaError))
      return
    end

    aceConfigRegistry:NotifyChange(standaloneOptionsName)
    if assignmentsOptions then
      aceConfigRegistry:NotifyChange("MerfinPlus_Assignments")
    end
    if wasShown then
      local viewState = GetStoredViewState()
      local selectedKey = sectionsByKey[viewState.activeMainNav] and viewState.activeMainNav or defaultSectionKey
      SetStandaloneNavigation(frame, optionSections, selectedKey, function(key)
        GetStoredViewState().activeMainNav = key
        MerfinPlus:ToggleStandalone(key)
      end)
      local selectedChild
      if selectedKey == "assignments" then
        selectedChild = viewState.activeAssignmentsTab
      elseif selectedKey == "raidCooldowns" then
        selectedChild = viewState.activeRaidCooldownsTab
      end
      self:ToggleStandalone(selectedKey, selectedChild)
    end
  end

  local function PrintSlashHelp()
    local lines = {
      MerfinPlus:T("Commands:"),
      "/mp",
      "/mp help",
    }

    for _, section in ipairs(optionSections) do
      if sectionsByKey[section.key] then
        table.insert(lines, "/mp " .. section.aliases[1] .. " - " .. section.label)
      end
    end

    MerfinPlus.PrettyPrint(table.concat(lines, "\n"))
  end

  local function RunSlashCommand(msg)
    msg = strlower(strtrim(msg or ""))

    if msg == "" then
      MerfinPlus:ToggleStandalone()
      return
    end

    if msg == "help" or msg == "?" then
      PrintSlashHelp()
      return
    end

    local which, sub = strmatch(msg, "^(%S+)%s+(%S+)$")
    local section = sectionByAlias[which or msg]

    if section then
      MerfinPlus:ToggleStandalone(section.key, sub)
    else
      PrintSlashHelp()
    end
  end

  function MerfinPlus:OpenOptions(which, sub)
    if which then
      local section = sectionByAlias[strlower(which)]
      which = section and section.key or which
    end

    if which == "help" or which == "?" then
      PrintSlashHelp()
    else
      self:ToggleStandalone(which, sub)
    end
  end

  -- ==== Slash commands ====
  aceConsole:RegisterChatCommand("merfinplus", RunSlashCommand)
  aceConsole:RegisterChatCommand("mp", RunSlashCommand)
end
