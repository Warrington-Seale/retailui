local _, FTA = ...

FTA.Settings = FTA.Settings or {}

local function EnsureDefaults()
  FTADB = FTADB or {}
  FTADB.profile = FTADB.profile or {}

  FTADB.profile.ui = FTADB.profile.ui or {}
  FTADB.profile.qol = FTADB.profile.qol or {}
  FTADB.profile.arrow = FTADB.profile.arrow or {}
  FTADB.profile.automation = FTADB.profile.automation or {}
  FTADB.profile.general = FTADB.profile.general or {}
  FTADB.profile.minimap = FTADB.profile.minimap or {}

  local gen = FTADB.profile.general
  if gen.voldemortMode == nil then gen.voldemortMode = false end
  if gen.hideOnLogin == nil then gen.hideOnLogin = false end
  if gen.hideArrow == nil then gen.hideArrow = false end
  if gen.hideMainWindow == nil then gen.hideMainWindow = false end
  if gen.textOnlyMainWindow == nil then gen.textOnlyMainWindow = false end

  local ui = FTADB.profile.ui
  if ui.mainScale == nil then ui.mainScale = 1.0 end
  if ui.textScale == nil then ui.textScale = 1.0 end
  if ui.mainBgAlpha == nil then ui.mainBgAlpha = 0.85 end

  local qol = FTADB.profile.qol
  if qol.hideCompleted == nil then qol.hideCompleted = false end
  if qol.hideUpcoming == nil then qol.hideUpcoming = false end
  if qol.lockMainWindow == nil then qol.lockMainWindow = false end

  local arrow = FTADB.profile.arrow
  arrow.colors = arrow.colors or {}
  if arrow.colors.facing == nil then arrow.colors.facing = { r = 0, g = 1, b = 0, a = 1 } end
  if arrow.colors.mid == nil then arrow.colors.mid = { r = 1, g = 1, b = 0, a = 1 } end
  if arrow.colors.away == nil then arrow.colors.away = { r = 1, g = 0, b = 0, a = 1 } end

  if arrow.scale == nil then arrow.scale = 1.0 end
  if arrow.textScale == nil then arrow.textScale = 1.0 end
  if arrow.locked == nil then arrow.locked = false end

  arrow.helper = arrow.helper or {}
  if arrow.helper.mode == nil then arrow.helper.mode = "WINDOW" end

  local a = FTADB.profile.automation
  if a.enableQuestAutomation == nil then a.enableQuestAutomation = false end

  local minimap = FTADB.profile.minimap
  if minimap.hide == nil then minimap.hide = false end
  if minimap.angle == nil then minimap.angle = 225 end
end

local function ResetAllToDefaults()
  FTADB = FTADB or {}
  FTADB.profile = FTADB.profile or {}

  FTADB.profile.ui = {}
  FTADB.profile.qol = {}
  FTADB.profile.arrow = {}
  FTADB.profile.automation = {}
  FTADB.profile.general = {}
  FTADB.profile.minimap = {}

  EnsureDefaults()
end

local function ResetLiveWindowPositions()
  if FTA and FTA.UI and FTA.UI.ResetMain then
    FTA.UI:ResetMain()
  end

  local ui = FTADB and FTADB.profile and FTADB.profile.ui
  if ui then
    ui.arrow = ui.arrow or {}
    ui.arrow.point = "CENTER"
    ui.arrow.relPoint = "CENTER"
    ui.arrow.x = 0
    ui.arrow.y = 120
  end

  if FTA and FTA.GuideArrow and FTA.GuideArrow.frame then
    local f = FTA.GuideArrow.frame
    f:StopMovingOrSizing()
    f:ClearAllPoints()
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
    if FTA.GuideArrow._distAnchorMode ~= nil then
      FTA.GuideArrow._distAnchorMode = nil
    end
    if FTA.GuideArrow._distAnchorPad ~= nil then
      FTA.GuideArrow._distAnchorPad = nil
    end
    if FTA.GuideArrow.RequestRefresh then
      FTA.GuideArrow:RequestRefresh()
    end
  end
end

local function Apply(reason)
  if FTA and FTA.FullRefresh then
    FTA:FullRefresh(reason or "settings")
    return
  end
  if FTA and FTA.UI and FTA.UI.Refresh then
    FTA.UI:Refresh()
  end
end

local function SetClickThrough(frame, clickThrough)
  if not frame then return end
  if frame.EnableMouse then
    frame:EnableMouse(not clickThrough)
  end
  if frame.SetPropagateMouseClicks then
    frame:SetPropagateMouseClicks(clickThrough)
  end
  if frame.SetPropagateMouseMotion then
    frame:SetPropagateMouseMotion(clickThrough)
  end
end

function FTA.Settings:Open()
  if not Settings or not Settings.OpenToCategory then return end
  if self._categoryID then
    Settings.OpenToCategory(self._categoryID)
  else
    Settings.OpenToCategory("Follow The Arrow")
  end
end

local function OpenColorPicker(initial, onCommit)
  if not ColorPickerFrame or type(onCommit) ~= "function" then return end
  initial = initial or {}

  local prev = {
    r = tonumber(initial.r) or 1,
    g = tonumber(initial.g) or 1,
    b = tonumber(initial.b) or 1,
    a = tonumber(initial.a) or 1,
  }

  if ColorPickerFrame.SetupColorPickerAndShow then
    local info = {
      r = prev.r,
      g = prev.g,
      b = prev.b,
      opacity = 1 - prev.a,
      hasOpacity = true,
      swatchFunc = function()
        local r, g, b = ColorPickerFrame:GetColorRGB()
        local a = 1 - (ColorPickerFrame:GetColorAlpha() or (1 - prev.a))
        onCommit(r, g, b, a)
      end,
      opacityFunc = function()
        local r, g, b = ColorPickerFrame:GetColorRGB()
        local a = 1 - (ColorPickerFrame:GetColorAlpha() or (1 - prev.a))
        onCommit(r, g, b, a)
      end,
      cancelFunc = function()
        onCommit(prev.r, prev.g, prev.b, prev.a)
      end,
    }
    ColorPickerFrame:SetupColorPickerAndShow(info)
    return
  end

  ColorPickerFrame.previousValues = prev
  ColorPickerFrame.hasOpacity = true
  ColorPickerFrame.opacity = 1 - prev.a

  ColorPickerFrame.func = function()
    local r, g, b = ColorPickerFrame:GetColorRGB()
    local a = 1 - (ColorPickerFrame.opacity or 0)
    onCommit(r, g, b, a)
  end

  ColorPickerFrame.opacityFunc = function()
    local r, g, b = ColorPickerFrame:GetColorRGB()
    local a = 1 - (ColorPickerFrame.opacity or 0)
    onCommit(r, g, b, a)
  end

  ColorPickerFrame.cancelFunc = function()
    onCommit(prev.r, prev.g, prev.b, prev.a)
  end

  local picker = ColorPickerFrame
  if picker and picker.Content and picker.Content.ColorPicker then
    picker = picker.Content.ColorPicker
  end
  if picker and picker.SetColorRGB then
    picker:SetColorRGB(prev.r, prev.g, prev.b)
  end

  ColorPickerFrame:Show()
end

local function MakeCheckbox(parent, label, tooltip, onGet, onSet)
  local b = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
  b.text:SetText(label)

  if tooltip then
    b:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:SetText(tooltip)
      GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
  end

  b:SetScript("OnClick", function(self)
    onSet(self:GetChecked() and true or false)
  end)

  b.Refresh = function()
    b:SetChecked(onGet() and true or false)
  end
  b:Refresh()

  return b
end

local function MakeSlider(parent, label, minV, maxV, step, onGet, onSet)
  local s = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
  s:SetMinMaxValues(minV, maxV)
  s:SetValueStep(step)
  s:SetObeyStepOnDrag(true)

  local name = s:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  name:SetPoint("BOTTOM", s, "TOP", 0, 2)
  name:SetText(label)

  local val = s:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  val:SetPoint("TOP", s, "BOTTOM", 0, -2)

  s:SetScript("OnValueChanged", function(self, v)
    v = tonumber(v) or minV
    v = math.floor(v / step + 0.5) * step
    val:SetText(("%.2f"):format(v))
    if self._suppress then return end
    onSet(v)
  end)

  s.Refresh = function()
    s._suppress = true
    local v = tonumber(onGet()) or minV
    s:SetValue(v)
    val:SetText(("%.2f"):format(v))
    s._suppress = false
  end
  s:Refresh()

  return s
end

local function BeginLayout(tabFrame)
  local PAD_X = 16
  local y = -16

  local function Heading(text)
    local h = tabFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    h:SetPoint("TOPLEFT", PAD_X, y)
    h:SetText(text)
    y = y - 22
    return h
  end

  local function Place(widget, indent, yStepOverride)
    if not widget then return end
    indent = indent or 0
    widget:SetPoint("TOPLEFT", PAD_X + indent, y)

    local step = yStepOverride
    if not step then
      local h = widget.GetHeight and widget:GetHeight() or 20
      step = (h > 0 and h or 20) + 8
    end

    y = y - step
  end

  local function PlaceSlider(slider)
    if not slider then return end
    Place(slider, 0, 48)
  end

  local function Line()
    y = y - 10
  end

  return Heading, Place, PlaceSlider, Line, PAD_X
end

local function MakeWrappedText(parent, text, width)
  local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  fs:SetJustifyH("LEFT")
  fs:SetJustifyV("TOP")
  fs:SetWordWrap(true)
  if width and fs.SetWidth then
    fs:SetWidth(width)
  end
  fs:SetText(text or "")
  return fs
end

function FTA:Settings_Init()
  EnsureDefaults()
  if not Settings or not Settings.RegisterCanvasLayoutCategory then return end

  local panel = CreateFrame("Frame", nil, UIParent)
  panel.name = "Follow The Arrow"

  local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 16, -16)
  title:SetText("Follow The Arrow")

  local nav = CreateFrame("Frame", nil, panel, "BackdropTemplate")
  nav:SetPoint("TOPLEFT", 16, -48)
  nav:SetPoint("BOTTOMLEFT", 16, 16)
  nav:SetWidth(190)
  nav:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 14,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  })
  nav:SetBackdropColor(0, 0, 0, 0.35)

  local content = CreateFrame("Frame", nil, panel, "BackdropTemplate")
  content:SetPoint("TOPLEFT", nav, "TOPRIGHT", 14, 0)
  content:SetPoint("BOTTOMRIGHT", -20, 18)
  content:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 14,
    insets = { left = 6, right = 10, top = 6, bottom = 6 },
  })
  content:SetBackdropColor(0, 0, 0, 0.25)

  local tabs = {}
  local tabOrder = {
    { key = "GENERAL", text = "General" },
    { key = "VISUAL",  text = "Visual Customization" },
    { key = "AUTO",    text = "Automation" },
  }

  local function SelectTab(key)
    for _, t in pairs(tabs) do
      t.frame:Hide()
      t.btn:UnlockHighlight()
    end
    local t = tabs[key]
    if not t then return end
    t.frame:Show()
    t.btn:LockHighlight()
  end

  local btnY = -8
  for i = 1, #tabOrder do
    local info = tabOrder[i]

    local b = CreateFrame("Button", nil, nav, "UIPanelButtonTemplate")
    b:SetSize(170, 22)
    b:SetPoint("TOPLEFT", 10, btnY)
    b:SetText(info.text)

    btnY = btnY - 26

    local tf = CreateFrame("Frame", nil, content)
    tf:SetAllPoints(content)
    tf:Hide()

    b:SetScript("OnClick", function() SelectTab(info.key) end)

    tabs[info.key] = { btn = b, frame = tf }
  end

  local vold, hideLogin, hideCompleted, hideUpcoming, hideArrow, hideMain, hideMinimapButton, lockMain, lockArrow, textOnly, questAutomation
  local s1, s2, s3, s4, s5

  do
    local tf = tabs.GENERAL.frame
    local Heading, Place, _, Line = BeginLayout(tf)

    local RIGHT_X = 205
    local rightY = -16

    local function RightHeading(text)
      local h = tf:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      h:SetPoint("TOPLEFT", RIGHT_X, rightY)
      h:SetText(text)
      rightY = rightY - 22
      return h
    end

    local function RightPlace(widget, yStepOverride)
      if not widget then return end
      widget:SetPoint("TOPLEFT", RIGHT_X, rightY)

      local step = yStepOverride
      if not step then
        local h = widget.GetHeight and widget:GetHeight() or 20
        step = (h > 0 and h or 20) + 8
      end

      rightY = rightY - step
    end

    Heading("General")

    vold = MakeCheckbox(
      tf,
      "Enable Voldemort Mode",
      nil,
      function() return FTADB.profile.general.voldemortMode end,
      function(v) FTADB.profile.general.voldemortMode = v; Apply("settings:voldemort") end
    )
    Place(vold)

    hideLogin = MakeCheckbox(
      tf,
      "Hide On Login",
      "If enabled, Follow The Arrow will not automatically open when you log in.",
      function() return FTADB.profile.general.hideOnLogin end,
      function(v) FTADB.profile.general.hideOnLogin = v; Apply("settings:hideOnLogin") end
    )
    Place(hideLogin)

    Line()
    Heading("Step List")

    hideCompleted = MakeCheckbox(
      tf,
      "Hide Completed Steps",
      "If enabled, completed steps are hidden/collapsed in the step list.",
      function() return FTADB.profile.qol.hideCompleted end,
      function(v) FTADB.profile.qol.hideCompleted = v; Apply("settings:hideCompleted") end
    )
    Place(hideCompleted)

    hideUpcoming = MakeCheckbox(
      tf,
      "Hide Upcoming Steps",
      "If enabled, upcoming steps are hidden/collapsed in the step list.",
      function() return FTADB.profile.qol.hideUpcoming end,
      function(v) FTADB.profile.qol.hideUpcoming = v; Apply("settings:hideUpcoming") end
    )
    Place(hideUpcoming)

    Line()
    Heading("Hide Features")

    hideArrow = MakeCheckbox(
      tf,
      "Hide Arrow",
      "If enabled, the arrow is hidden.",
      function() return FTADB.profile.general.hideArrow end,
      function(v)
        FTADB.profile.general.hideArrow = v
        if FTA.GuideArrow and FTA.GuideArrow.SetEnabled then
          FTA.GuideArrow:SetEnabled(not v)
        end
        Apply("settings:hideArrow")
      end
    )
    Place(hideArrow)

    hideMain = MakeCheckbox(
      tf,
      "Hide Main Window",
      "If enabled, the main window is hidden.",
      function() return FTADB.profile.general.hideMainWindow end,
      function(v)
        FTADB.profile.general.hideMainWindow = v and true or false

        if FTA and FTA.UI and FTA.UI.main then
          if FTADB.profile.general.hideMainWindow == true then
            FTA.UI.main:Hide()
          else
            FTA.UI.main:Show()
          end
        end

        Apply("settings:hideMainWindow")
      end
    )
    Place(hideMain)

    hideMinimapButton = MakeCheckbox(
      tf,
      "Hide Minimap Button",
      "If enabled, the minimap button is hidden.",
      function() return FTADB.profile.minimap.hide end,
      function(v)
        FTADB.profile.minimap.hide = v and true or false

        if FTADB.profile.minimap.hide then
          if FTA.MinimapButton_Hide then
            FTA:MinimapButton_Hide()
          end
        else
          if FTA.MinimapButton_Show then
            FTA:MinimapButton_Show()
          end
        end

        Apply("settings:hideMinimapButton")
      end
    )
    Place(hideMinimapButton)

    RightHeading("Arrow & Window")

    textOnly = MakeCheckbox(
      tf,
      "Text Only Mode",
      "Hides borders/background and other UI so you only see the step list text.",
      function() return FTADB.profile.general.textOnlyMainWindow end,
      function(v)
        FTADB.profile.general.textOnlyMainWindow = v and true or false
        Apply("settings:textOnlyMainWindow")
      end
    )
    RightPlace(textOnly)

    lockMain = MakeCheckbox(
      tf,
      "Lock Main Window",
      "Locks the main window position and disables dragging/resizing handles.",
      function() return FTADB.profile.qol.lockMainWindow end,
      function(v) FTADB.profile.qol.lockMainWindow = v; Apply("settings:lockMain") end
    )
    RightPlace(lockMain)

    lockArrow = MakeCheckbox(
      tf,
      "Lock Arrow",
      "Locks the arrow position and makes it ignore mouse clicks.",
      function() return FTADB.profile.arrow.locked end,
      function(v)
        FTADB.profile.arrow.locked = v
        if FTA.UI and FTA.UI.arrowFrame then
          SetClickThrough(FTA.UI.arrowFrame, v)
        end
        Apply("settings:arrowLocked")
      end
    )
    RightPlace(lockArrow)

    Line()

    local buttonRow = CreateFrame("Frame", nil, tf)
    buttonRow:SetSize(340, 22)

    local defaultsBtn = CreateFrame("Button", nil, buttonRow, "UIPanelButtonTemplate")
    defaultsBtn:SetSize(160, 22)
    defaultsBtn:SetPoint("LEFT", buttonRow, "LEFT", 0, 0)
    defaultsBtn:SetText("Default Settings")
    defaultsBtn:SetScript("OnClick", function()
      ResetAllToDefaults()
      ResetLiveWindowPositions()
      Apply("settings:defaults")

      if vold and vold.Refresh then vold:Refresh() end
      if hideLogin and hideLogin.Refresh then hideLogin:Refresh() end
      if hideCompleted and hideCompleted.Refresh then hideCompleted:Refresh() end
      if hideUpcoming and hideUpcoming.Refresh then hideUpcoming:Refresh() end
      if hideArrow and hideArrow.Refresh then hideArrow:Refresh() end
      if hideMain and hideMain.Refresh then hideMain:Refresh() end
      if hideMinimapButton and hideMinimapButton.Refresh then hideMinimapButton:Refresh() end
      if textOnly and textOnly.Refresh then textOnly:Refresh() end
      if lockMain and lockMain.Refresh then lockMain:Refresh() end
      if lockArrow and lockArrow.Refresh then lockArrow:Refresh() end
      if questAutomation and questAutomation.Refresh then questAutomation:Refresh() end
      if s1 and s1.Refresh then s1:Refresh() end
      if s2 and s2.Refresh then s2:Refresh() end
      if s3 and s3.Refresh then s3:Refresh() end
      if s4 and s4.Refresh then s4:Refresh() end
      if s5 and s5.Refresh then s5:Refresh() end
    end)

    local resetOptionalBtn = CreateFrame("Button", nil, buttonRow, "UIPanelButtonTemplate")
    resetOptionalBtn:SetSize(160, 22)
    resetOptionalBtn:SetPoint("LEFT", defaultsBtn, "RIGHT", 12, 0)
    resetOptionalBtn:SetText("Reset Optional Steps")
    resetOptionalBtn:SetScript("OnClick", function()
      if FTA and FTA.SetAllManualSegmentsIncomplete then
        FTA:SetAllManualSegmentsIncomplete()
      elseif FTA and FTA.StepEngine and FTA.StepEngine.ResetAllManualSegments then
        FTA.StepEngine:ResetAllManualSegments()
        Apply("settings:resetOptionalSteps")
      end
    end)

    Place(buttonRow, 0, 30)
  end

  do
    local tf = tabs.VISUAL.frame
    local Heading, Place, PlaceSlider, Line = BeginLayout(tf)

    Heading("Arrow Colors")

    local facingBtn = CreateFrame("Button", nil, tf, "UIPanelButtonTemplate")
    facingBtn:SetSize(160, 22)
    facingBtn:SetText("Facing Color")
    facingBtn:SetScript("OnClick", function()
      local c = FTADB.profile.arrow.colors.facing
      OpenColorPicker(c, function(r, g, b, a)
        c.r, c.g, c.b, c.a = r, g, b, a
        Apply("settings:arrowFacingColor")
      end)
    end)
    Place(facingBtn)

    local midBtn = CreateFrame("Button", nil, tf, "UIPanelButtonTemplate")
    midBtn:SetSize(160, 22)
    midBtn:SetText("Midpoint Color")
    midBtn:SetScript("OnClick", function()
      local c = FTADB.profile.arrow.colors.mid
      OpenColorPicker(c, function(r, g, b, a)
        c.r, c.g, c.b, c.a = r, g, b, a
        Apply("settings:arrowMidColor")
      end)
    end)
    Place(midBtn)

    local awayBtn = CreateFrame("Button", nil, tf, "UIPanelButtonTemplate")
    awayBtn:SetSize(160, 22)
    awayBtn:SetText("Away Color")
    awayBtn:SetScript("OnClick", function()
      local c = FTADB.profile.arrow.colors.away
      OpenColorPicker(c, function(r, g, b, a)
        c.r, c.g, c.b, c.a = r, g, b, a
        Apply("settings:arrowAwayColor")
      end)
    end)
    Place(awayBtn)

    Line()
    Heading("Arrow Sizing")
    Line()

    s1 = MakeSlider(
      tf,
      "Arrow Scale",
      0.60, 1.80, 0.05,
      function() return FTADB.profile.arrow.scale end,
      function(v) FTADB.profile.arrow.scale = v; Apply("settings:arrowScale") end
    )
    s1:SetSize(260, 16)
    PlaceSlider(s1)

    s2 = MakeSlider(
      tf,
      "Arrow Text Scale",
      0.60, 1.60, 0.05,
      function() return FTADB.profile.arrow.textScale end,
      function(v) FTADB.profile.arrow.textScale = v; Apply("settings:arrowTextScale") end
    )
    s2:SetSize(260, 16)
    PlaceSlider(s2)

    Line()
    Heading("Main Window Sizing")
    Line()

    s3 = MakeSlider(
      tf,
      "Main Window Scale",
      0.70, 1.60, 0.05,
      function() return FTADB.profile.ui.mainScale end,
      function(v) FTADB.profile.ui.mainScale = v; Apply("settings:mainScale") end
    )
    s3:SetSize(260, 16)
    PlaceSlider(s3)

    s4 = MakeSlider(
      tf,
      "Main Text Scale",
      0.70, 1.60, 0.05,
      function() return FTADB.profile.ui.textScale end,
      function(v) FTADB.profile.ui.textScale = v; Apply("settings:mainTextScale") end
    )
    s4:SetSize(260, 16)
    PlaceSlider(s4)

    Line()
    Heading("Main Window Opacity")
    Line()

    s5 = MakeSlider(
      tf,
      "Background Opacity",
      0.00, 1.00, 0.05,
      function() return FTADB.profile.ui.mainBgAlpha end,
      function(v) FTADB.profile.ui.mainBgAlpha = v; Apply("settings:mainBgAlpha") end
    )
    s5:SetSize(260, 16)
    PlaceSlider(s5)
  end

  do
    local tf = tabs.AUTO.frame
    local Heading, Place, _, Line = BeginLayout(tf)

    Heading("Quest Handling")

    questAutomation = MakeCheckbox(
      tf,
      "Enable Auto Quest Pickup & Turn-In",
      "Allows Follow The Arrow to help pick up and hand in quests (user-initiated clicks only).",
      function() return FTADB.profile.automation.enableQuestAutomation end,
      function(v) FTADB.profile.automation.enableQuestAutomation = v; Apply("settings:questAutomation") end
    )
    Place(questAutomation)

    Line()

    local noteText = MakeWrappedText(tf,
      "Currently the automation settings are fairly limited, as I want to focus my time on improving the quality of the guides. \n\nHowever, my addon is fully compatible with other automation addons. I would personally recommend QuickQuest and ExtraQuestButton by p3lim. \n\nQuickQuest handles fancy automation magic, like auto skipping gossip options, and ExtraQuestButton causes quest items to appear as an Extra Action Button for easy interaction. \n\nLeatrix Plus is another helpful addon with a lot of general QoL and automation settings.",
      375
    )
    Place(noteText, 0, 64)
  end

  SelectTab("GENERAL")

  local category = Settings.RegisterCanvasLayoutCategory(panel, "Follow The Arrow")
  Settings.RegisterAddOnCategory(category)

  if category and category.GetID then
    FTA.Settings._categoryID = category:GetID()
  end
end