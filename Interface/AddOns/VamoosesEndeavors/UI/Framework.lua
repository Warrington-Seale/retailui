-- ============================================================================
-- Vamoose's Endeavors - UI Framework
-- Reusable UI components with Solarized theme
-- Uses Theme Registry pattern for live theme switching
-- ============================================================================

VE = VE or {}
VE.UI = {}

-- DR step colors for repeatable initiative tasks (curve 87592).
-- Step 0 = first completion (100%), step 5+ = floor (50%).
-- Plasma-reversed sequential palette, sampled from the high-luminance band
-- (L* >= ~52) so every step reads clearly on dark backdrops. Yellow -> orange
-- -> coral -> pink -> magenta. Sidesteps the dark-red readability problem by
-- ending in vivid magenta rather than deep red. Colorblind-safe across
-- deuteranopia/protanopia/tritanopia (luminance progression carries the
-- signal even when reds and greens collapse).
VE.UI.DR_STEP_COLORS = {
    [0] = { r = 1.00, g = 0.93, b = 0.63 }, -- 100% -- pale yellow (best)
    [1] = { r = 1.00, g = 0.80, b = 0.34 }, -- 90%  -- yellow-orange
    [2] = { r = 1.00, g = 0.62, b = 0.29 }, -- 80%  -- orange
    [3] = { r = 0.97, g = 0.46, b = 0.42 }, -- 70%  -- coral
    [4] = { r = 0.89, g = 0.36, b = 0.58 }, -- 60%  -- pink
    [5] = { r = 0.77, g = 0.28, b = 0.72 }, -- 50%  -- magenta (floor)
}

-- ============================================================================
-- CENTRALIZED BACKDROP CONSTANTS
-- ============================================================================

local BACKDROP_FLAT = {
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
}

local BACKDROP_BORDERLESS = {
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = nil,
    tile = false,
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

local WHITE = "Interface\\Buttons\\WHITE8x8"

local function GetScheme()
    if VE.Theme and VE.Theme.currentScheme then
        return VE.Theme.currentScheme
    end
    return VE.Constants.Colors
end

local function RegisterWidget(widget, widgetType)
    if VE.Theme and VE.Theme.Register then
        VE.Theme:Register(widget, widgetType)
    end
end

-- Natural (unclamped) text width, measurable at build time.
--
-- GetStringWidth is wrong for sizing widgets for two reasons: it returns the
-- CLAMPED width (so a truncated label under-reports), and it returns 0 until the
-- FontString has actually drawn once. The 0 is the nastier half -- `w or 50`
-- reads as a fallback but never fires, because 0 is truthy in Lua, so callers
-- silently got `0 + padding`-wide widgets at build time.
--
-- GetUnboundedStringWidthForText measures arbitrary text against the FontString's
-- own font with no SetText and no render required (verified 12.0.5,
-- SimpleFontStringAPIDocumentation). It's a pure read, so it never mutates
-- geometry the way the old SetWidth(0)+GetStringWidth probe did. This is the
-- pattern HDG's layout engine uses throughout.
function VE.UI.NaturalTextWidth(fs, text, fallback)
    fallback = fallback or 0
    if not fs then return fallback end
    text = text or (fs.GetText and fs:GetText()) or ""
    -- exception(boundary): GetUnboundedStringWidthForText is 12.0+; the older
    -- unbounded read needs a prior draw, and GetStringWidth is the last resort.
    local w
    if fs.GetUnboundedStringWidthForText then
        w = fs:GetUnboundedStringWidthForText(text)
    elseif fs.GetUnboundedStringWidth then
        w = fs:GetUnboundedStringWidth()
    elseif fs.GetStringWidth then
        w = fs:GetStringWidth()
    end
    if not w or w <= 0 then return fallback end
    return w
end

-- ============================================================================
-- THEME APPLICATION (Legacy support + Registration)
-- ============================================================================

local function ApplyTheme(frame, themeType)
    if not frame then return end

    local Colors = GetScheme()

    if themeType == "Window" then
        frame:SetBackdrop(BACKDROP_BORDERLESS)
        frame:SetBackdropColor(Colors.bg.r, Colors.bg.g, Colors.bg.b, Colors.bg.a)
        RegisterWidget(frame, "Frame")

    elseif themeType == "Panel" then
        frame:SetBackdrop(BACKDROP_FLAT)
        frame:SetBackdropColor(Colors.panel.r, Colors.panel.g, Colors.panel.b, Colors.panel.a)
        frame:SetBackdropBorderColor(Colors.border.r, Colors.border.g, Colors.border.b, Colors.border.a)
        RegisterWidget(frame, "Panel")

    elseif themeType == "Button" then
        frame:SetBackdrop(BACKDROP_FLAT)
        frame:SetBackdropColor(Colors.button_normal.r, Colors.button_normal.g, Colors.button_normal.b, Colors.button_normal.a)
        frame:SetBackdropBorderColor(Colors.border.r, Colors.border.g, Colors.border.b, Colors.border.a)

        -- Store scheme reference for hover scripts
        frame._scheme = Colors

        frame:SetScript("OnEnter", function(self)
            local c = self._scheme or GetScheme()
            self:SetBackdropColor(c.button_hover.r, c.button_hover.g, c.button_hover.b, c.button_hover.a)
        end)
        frame:SetScript("OnLeave", function(self)
            local c = self._scheme or GetScheme()
            self:SetBackdropColor(c.button_normal.r, c.button_normal.g, c.button_normal.b, c.button_normal.a)
        end)

        RegisterWidget(frame, "Button")
    end
end

-- ============================================================================
-- MAIN FRAME
-- ============================================================================

function VE.UI:CreateMainFrame(name, title)
    local UI = VE.Constants.UI

    local frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    frame:SetSize(UI.mainWidth, UI.mainHeight)
    frame:SetPoint("CENTER")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetFrameStrata("MEDIUM")
    frame:SetToplevel(true)
    frame:SetClampedToScreen(true)

    -- Atlas wood frame border (Housing Theme)
    local borderFrame = CreateFrame("Frame", nil, frame)
    borderFrame:SetAllPoints()  -- Align with window edges
    borderFrame:SetFrameLevel(frame:GetFrameLevel() + 10)  -- Render on top
    local borderTex = borderFrame:CreateTexture(nil, "OVERLAY")
    borderTex:SetAllPoints()
    borderTex:SetAtlas("housing-wood-frame")
    borderTex:SetAlpha(1)
    borderFrame.tex = borderTex
    frame.borderFrame = borderFrame
    -- Initial visibility based on theme
    local Colors = GetScheme()
    if Colors.atlas and Colors.atlas.windowBorder then
        borderFrame:Show()
    else
        borderFrame:Hide()
    end

    ApplyTheme(frame, "Window")

    -- Title Bar
    local Colors = GetScheme()
    local titleBar = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    titleBar:SetHeight(27)  -- 18 * 1.5 = 27 (50% taller)
    titleBar:SetPoint("TOPLEFT", 0, 0)
    titleBar:SetPoint("TOPRIGHT", 0, 0)
    titleBar:SetBackdrop(BACKDROP_BORDERLESS)
    titleBar:SetBackdropColor(0, 0, 0, 0) -- Transparent, atlas provides background

    -- Watercolor paper background for title bar
    local titleBg = titleBar:CreateTexture(nil, "BACKGROUND")
    titleBg:SetAllPoints()
    titleBg:SetTexture("Interface\\AddOns\\VamoosesEndeavors\\Textures\\ve_paper_bg")
    titleBg:SetVertexColor(Colors.accent.r, Colors.accent.g, Colors.accent.b, 0.4)
    titleBar.atlasBg = titleBg

    local titleText = titleBar:CreateFontString(nil, "OVERLAY")
    titleText:SetPoint("CENTER", 0, 0)
    VE.Theme.ApplyFont(titleText, Colors, "small")
    titleText:SetText(title)
    titleText:SetTextColor(Colors.accent.r, Colors.accent.g, Colors.accent.b, Colors.accent.a)
    frame.titleText = titleText
    titleBar.titleText = titleText

    -- Logo texture for Housing Theme (replaces title text)
    local titleLogo = titleBar:CreateTexture(nil, "OVERLAY")
    titleLogo:SetTexture("Interface\\AddOns\\VamoosesEndeavors\\Textures\\title_logo.tga")
    titleLogo:SetSize(180, 60)  -- Aspect ratio ~3:1, logo overlaps but transparent areas invisible
    titleLogo:SetPoint("CENTER", 0, 0)
    titleBar.titleLogo = titleLogo
    -- Set initial visibility based on current theme
    if Colors.atlas and Colors.atlas.titleBarBg then
        titleLogo:Show()
        titleText:Hide()
    else
        titleLogo:Hide()
        titleText:Show()
    end

    -- Register title bar for theming
    RegisterWidget(titleBar, "TitleBar")

    -- Refresh Button (top left, icon only)
    local refreshBtn = CreateFrame("Button", nil, titleBar)
    refreshBtn:SetSize(20, 20)
    refreshBtn:SetPoint("LEFT", 4, 0)
    refreshBtn._scheme = Colors

    local refreshIcon = refreshBtn:CreateTexture(nil, "ARTWORK")
    refreshIcon:SetSize(18, 18)
    refreshIcon:SetPoint("CENTER")
    refreshIcon:SetAtlas("housefinder_neighborhood-party-sync-icon")
    refreshBtn.icon = refreshIcon
    titleBar.refreshBtn = refreshBtn    -- Store for TitleBar skinner to update _scheme

    refreshBtn:SetScript("OnClick", function()
        if VE.EndeavorTracker then
            -- Refresh all endeavor data (handles correct API call order)
            VE.EndeavorTracker:RefreshAll()
        end
        if VE.EndeavorTracker then
            -- Refresh housing data (coupons, house level)
            VE.EndeavorTracker:RequestHouseInfo()
            VE.EndeavorTracker:UpdateCoupons()
        end
        -- Refresh whichever tab is currently shown (after data loads)
        C_Timer.After(0.5, function()
            if InCombatLockdown() then return end
            if VE.MainFrame then
                if VE.MainFrame.endeavorsTab and VE.MainFrame.endeavorsTab:IsShown() then
                    VE.MainFrame.endeavorsTab:Update()
                elseif VE.MainFrame.leaderboardTab and VE.MainFrame.leaderboardTab:IsShown() then
                    VE.MainFrame.leaderboardTab:Update()
                elseif VE.MainFrame.activityTab and VE.MainFrame.activityTab:IsShown() then
                    VE.MainFrame.activityTab:Update()
                end
            end
        end)
    end)

    refreshBtn:SetScript("OnEnter", function(self)
        if self.icon then
            self.icon:SetVertexColor(1, 1, 1, 1)  -- Bright on hover
        end
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("Refresh", 1, 1, 1)
        GameTooltip:AddLine("Fetches latest endeavor data and rebuilds all UI elements", 0.7, 0.7, 0.7, true)
        GameTooltip:Show()
    end)

    refreshBtn:SetScript("OnLeave", function(self)
        if self.icon then
            self.icon:SetVertexColor(0.7, 0.7, 0.7, 1)  -- Dim when not hovered
        end
        GameTooltip:Hide()
    end)

    -- Set initial dimmed state
    refreshIcon:SetVertexColor(0.7, 0.7, 0.7, 1)

    -- Minimize Button (collapses task list)
    local minimizeBtn = CreateFrame("Button", nil, titleBar)
    minimizeBtn:SetSize(18, 18)
    minimizeBtn:SetPoint("RIGHT", -25, 0)

    local minimizeIcon = minimizeBtn:CreateTexture(nil, "ARTWORK")
    minimizeIcon:SetAllPoints()
    minimizeIcon:SetAtlas("Map-Filter-Button")
    minimizeIcon:SetVertexColor(0.85, 0.85, 0.85, 1)  -- Dimmed when not hovered
    minimizeBtn.icon = minimizeIcon

    frame.isMinimized = false
    frame.expandedHeight = UI.mainHeight

    minimizeBtn:SetScript("OnClick", function()
        frame.isMinimized = not frame.isMinimized
        if frame.isMinimized then
            -- Collapse to compact view (title bar + progress bar only)
            -- Hide tab bar
            if frame.tabBar then frame.tabBar:Hide() end
            -- Hide content area
            if frame.content then frame.content:Hide() end
        else
            -- Expand to full height
            frame:SetHeight(frame.expandedHeight)
            -- Show tab bar
            if frame.tabBar then frame.tabBar:Show() end
            -- Show content area
            if frame.content then frame.content:Show() end
        end
    end)

    minimizeBtn:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(1, 1, 1, 1)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        if frame.isMinimized then
            GameTooltip:AddLine("Expand", 1, 1, 1)
            GameTooltip:AddLine("Show full tracker", 0.7, 0.7, 0.7, true)
        else
            GameTooltip:AddLine("Swap to Mini-Tracker", 1, 1, 1)
            GameTooltip:AddLine("Collapse to compact view", 0.7, 0.7, 0.7, true)
        end
        GameTooltip:Show()
    end)

    minimizeBtn:SetScript("OnLeave", function(self)
        self.icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        GameTooltip:Hide()
    end)

    frame.minimizeBtn = minimizeBtn

    -- Pin Button (to left of minimize)
    local pinBtn = CreateFrame("Button", nil, titleBar)
    pinBtn:SetSize(16, 16)
    pinBtn:SetPoint("RIGHT", minimizeBtn, "LEFT", -4, 0)

    local pinIcon = pinBtn:CreateTexture(nil, "ARTWORK")
    pinIcon:SetAllPoints()
    pinIcon:SetAtlas("friendslist-recentallies-Pin-yellow")
    pinBtn.icon = pinIcon

    local isPinned = VE.Store:GetState().config.pinWindow
    pinIcon:SetDesaturated(not isPinned)
    if not isPinned then pinIcon:SetVertexColor(0.6, 0.6, 0.6, 1) end

    pinBtn:SetScript("OnClick", function()
        local state = VE.Store:GetState()
        local newPinned = not state.config.pinWindow
        VE.Store:Dispatch("SET_CONFIG", { key = "pinWindow", value = newPinned })

        pinIcon:SetDesaturated(not newPinned)
        pinIcon:SetVertexColor(newPinned and 1 or 0.6, newPinned and 1 or 0.6, newPinned and 0.6 or 0.6, 1)

        -- Toggle UISpecialFrames registration
        local frameName = frame:GetName()
        if newPinned then
            for i = #UISpecialFrames, 1, -1 do
                if UISpecialFrames[i] == frameName then
                    table.remove(UISpecialFrames, i)
                    break
                end
            end
        else
            -- Re-register so Escape closes again
            local found = false
            for _, v in ipairs(UISpecialFrames) do
                if v == frameName then found = true; break end
            end
            if not found then table.insert(UISpecialFrames, frameName) end
        end
    end)

    pinBtn:SetScript("OnEnter", function(self)
        if VE.Store:GetState().config.pinWindow then
            self.icon:SetVertexColor(1, 1, 0.7, 1)
        else
            self.icon:SetVertexColor(0.85, 0.85, 0.85, 1)
        end
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("Pin Window", 1, 1, 1)
        if VE.Store:GetState().config.pinWindow then
            GameTooltip:AddLine("Pinned: stays open on Escape and reload", 0.7, 0.7, 0.7, true)
        else
            GameTooltip:AddLine("Click to keep window open on Escape and reload", 0.7, 0.7, 0.7, true)
        end
        GameTooltip:Show()
    end)

    pinBtn:SetScript("OnLeave", function(self)
        local pinned = VE.Store:GetState().config.pinWindow
        self.icon:SetDesaturated(not pinned)
        self.icon:SetVertexColor(pinned and 1 or 0.6, pinned and 1 or 0.6, pinned and 0.6 or 0.6, 1)
        GameTooltip:Hide()
    end)

    frame.pinBtn = pinBtn

    -- Theme Toggle Button (left side, after refresh)
    local themeBtn = CreateFrame("Button", nil, titleBar)
    themeBtn:SetSize(22, 22)
    themeBtn:SetPoint("LEFT", refreshBtn, "RIGHT", 4, 0)
    themeBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    local themeIcon = themeBtn:CreateTexture(nil, "ARTWORK")
    themeIcon:SetAllPoints()
    themeIcon:SetAtlas("housing-dyable-palette-icon")
    themeIcon:SetVertexColor(0.7, 0.7, 0.7, 1)
    themeBtn.icon = themeIcon
    titleBar.themeIcon = themeIcon  -- Store reference

    themeBtn:SetScript("OnMouseDown", function()
        themeIcon:SetVertexColor(0.5, 0.5, 0.5, 1)
    end)
    themeBtn:SetScript("OnMouseUp", function()
        themeIcon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end)

    -- Helper to get adjacent theme display name
    local function GetAdjacentThemeName(direction)
        local currentTheme = VE.Constants:GetCurrentTheme()
        local currentIndex = 1
        for i, theme in ipairs(VE.Constants.ThemeOrder) do
            if theme == currentTheme then currentIndex = i; break end
        end
        local count = #VE.Constants.ThemeOrder
        local adjIndex
        if direction == "next" then
            adjIndex = (currentIndex % count) + 1
        else
            adjIndex = ((currentIndex - 2) % count) + 1
        end
        local adjTheme = VE.Constants.ThemeOrder[adjIndex]
        return VE.Constants.ThemeDisplayNames[adjTheme] or VE.Constants.ThemeNames[adjTheme] or "Dark"
    end

    -- Helper to show theme tooltip
    local function ShowThemeTooltip(btn)
        local currentTheme = VE.Constants:GetCurrentTheme()
        local currentDisplayName = VE.Constants.ThemeDisplayNames[currentTheme] or currentTheme
        GameTooltip:SetOwner(btn, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("Change Theme", 1, 1, 1)
        GameTooltip:AddLine("Current: " .. currentDisplayName, 0.7, 0.7, 0.7, true)
        GameTooltip:AddLine("Left-click: " .. GetAdjacentThemeName("next"), 0.5, 0.8, 0.5, true)
        GameTooltip:AddLine("Right-click: " .. GetAdjacentThemeName("prev"), 0.8, 0.5, 0.5, true)
        GameTooltip:Show()
    end

    local function ApplyNewTheme(newTheme, btn)
        local themeName = VE.Constants.ThemeNames[newTheme] or "Dark"
        local displayName = VE.Constants.ThemeDisplayNames[newTheme] or themeName
        if VE.EventBus then
            VE.EventBus:Trigger("VE_THEME_UPDATE", { themeName = themeName })
        end
        print("|cFF2aa198[VE]|r Theme switched to " .. displayName)
        if GameTooltip:IsShown() and GameTooltip:GetOwner() == btn then
            ShowThemeTooltip(btn)
        end
    end

    themeBtn:SetScript("OnClick", function(self, button)
        if button == "RightButton" then
            ApplyNewTheme(VE.Constants:ToggleThemeReverse(), self)
        else
            ApplyNewTheme(VE.Constants:ToggleTheme(), self)
        end
    end)

    themeBtn:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(1, 1, 1, 1)
        ShowThemeTooltip(self)
    end)

    themeBtn:SetScript("OnLeave", function(self)
        self.icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        GameTooltip:Hide()
    end)

    frame.themeBtn = themeBtn

    -- Vamoose's Neighbors promo button (left side, after theme toggle)
    local vnBtn = CreateFrame("Button", nil, titleBar)
    vnBtn:SetSize(20, 20)
    vnBtn:SetPoint("LEFT", themeBtn, "RIGHT", 4, 0)

    local vnIcon = vnBtn:CreateTexture(nil, "ARTWORK")
    vnIcon:SetSize(18, 18)
    vnIcon:SetPoint("CENTER")
    vnIcon:SetVertexColor(0.7, 0.7, 0.7, 1)
    vnBtn.icon = vnIcon

    -- Helper: check VN availability (deferred since load order varies)
    local function IsVNAvailable()
        return _G.VamoosesNeighbors and _G.VamoosesNeighbors.MainPanel
    end

    vnIcon:SetTexture("Interface\\AddOns\\VamoosesEndeavors\\textures\\vn_icon")

    vnBtn:SetScript("OnClick", function()
        if IsVNAvailable() then
            _G.VamoosesNeighbors.MainPanel:Toggle()
        end
    end)

    vnBtn:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(1, 1, 1, 1)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        if IsVNAvailable() then
            GameTooltip:AddLine("Vamoose's Neighbors", 1, 1, 1)
            GameTooltip:AddLine("Click to open the neighborhood browser", 0.7, 0.7, 0.7, true)
        else
            GameTooltip:AddLine("Vamoose's Neighbors", 1, 1, 1)
            GameTooltip:AddLine("Browse neighborhoods, visit friends' houses, and discover your community!", 0.7, 0.7, 0.7, true)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Get it on CurseForge:", 0.5, 0.8, 0.5)
            GameTooltip:AddLine("curseforge.com/wow/addons/vamooses-neighbors", 0.4, 0.7, 1.0)
        end
        GameTooltip:Show()
    end)

    vnBtn:SetScript("OnLeave", function(self)
        self.icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        GameTooltip:Hide()
    end)

    frame.vnBtn = vnBtn

    -- Close Button (top right)
    local closeBtn = CreateFrame("Button", nil, titleBar)
    closeBtn:SetSize(22, 22)
    closeBtn:SetPoint("RIGHT", -1, -1)

    local closeIcon = closeBtn:CreateTexture(nil, "ARTWORK")
    closeIcon:SetSize(18, 18)
    closeIcon:SetPoint("CENTER")
    closeIcon:SetAtlas("XMarksTheSpot")
    closeIcon:SetVertexColor(0.7, 0.7, 0.7, 1)
    closeBtn.icon = closeIcon
    titleBar.closeIcon = closeIcon  -- Store for TitleBar skinner

    closeBtn:SetScript("OnClick", function() frame:Hide() end)

    closeBtn:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(1, 1, 1, 1)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("Close", 1, 1, 1)
        GameTooltip:Show()
    end)

    closeBtn:SetScript("OnLeave", function(self)
        self.icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        GameTooltip:Hide()
    end)

    frame.titleBar = titleBar
    frame.refreshBtn = refreshBtn
    frame.themeBtn = themeBtn
    frame.closeBtn = closeBtn

    return frame
end

-- ============================================================================
-- BUTTON
-- ============================================================================

function VE.UI:CreateButton(parent, text, width, height)
    local Colors = GetScheme()

    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(width or 100, height or 24)
    btn:SetText(text)
    ApplyTheme(btn, "Button")

    local fs = btn:GetFontString()
    if fs then
        VE.Theme.ApplyFont(fs, Colors)
        fs:SetTextColor(Colors.button_text_norm.r, Colors.button_text_norm.g, Colors.button_text_norm.b)
    end

    return btn
end

-- ============================================================================
-- TAB BUTTON
-- ============================================================================

function VE.UI:CreateTabButton(parent, text, options)
    options = options or {}
    local Colors = GetScheme()
    local UI = VE.Constants.UI or {}
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(UI.tabWidth or 90, UI.tabHeight or 24)

    -- Support icon-only tabs (atlas icons)
    if options.icon then
        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetSize(14, 14)
        icon:SetPoint("CENTER")
        icon:SetAtlas(options.icon)
        btn.icon = icon
        btn.iconDefault = options.icon
        btn.iconActive = options.iconActive or options.icon
    else
        local label = btn:CreateFontString(nil, "OVERLAY")
        label:SetPoint("CENTER", 0, 1)
        VE.Theme.ApplyFont(label, Colors, "small")
        label:SetText(text)
        label:SetTextColor(Colors.text_dim.r, Colors.text_dim.g, Colors.text_dim.b)
        btn.label = label
    end

    -- 2px bottom accent bar (shown when active)
    local accent = btn:CreateTexture(nil, "ARTWORK")
    accent:SetPoint("BOTTOMLEFT", 2, 0)
    accent:SetPoint("BOTTOMRIGHT", -2, 0)
    accent:SetHeight(2)
    accent:SetTexture(WHITE)
    accent:SetVertexColor(Colors.accent.r, Colors.accent.g, Colors.accent.b, 1)
    accent:Hide()
    btn._accent = accent

    btn.isActive = false

    function btn:SetActive(active)
        self.isActive = active
        local c = GetScheme()
        -- Update icon atlas if using icon mode
        if self.icon then
            if active then
                self.icon:SetAtlas(self.iconActive)
            else
                self.icon:SetAtlas(self.iconDefault)
            end
        end
        if active then
            self._accent:Show()
            if self.label then
                self.label:SetTextColor(c.text_header.r, c.text_header.g, c.text_header.b)
            end
        else
            self._accent:Hide()
            if self.label then
                self.label:SetTextColor(c.text_dim.r, c.text_dim.g, c.text_dim.b)
            end
        end
    end

    btn:SetScript("OnEnter", function(self)
        local c = GetScheme()
        if self.label then
            self.label:SetTextColor(c.text_header.r, c.text_header.g, c.text_header.b)
        end
    end)

    btn:SetScript("OnLeave", function(self)
        if not self.isActive then
            local c = GetScheme()
            if self.label then
                self.label:SetTextColor(c.text_dim.r, c.text_dim.g, c.text_dim.b)
            end
        end
    end)

    -- Register with theme engine
    RegisterWidget(btn, "TabButton")

    return btn
end

-- ============================================================================
-- PROGRESS BAR
-- ============================================================================

function VE.UI:CreateProgressBar(parent, options)
    options = options or {}
    local width = options.width or 200
    local height = options.height or VE.Constants.UI.progressBarHeight
    local Colors = GetScheme()

    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(width, height)

    -- Mouse-enabled for the chest tooltip + right-click claim below. Enabling
    -- mouse on a child otherwise swallows the window's own left-drag, so the
    -- drag is forwarded to the first movable ancestor -- dragging the window by
    -- the progress bar keeps working.
    container:EnableMouse(true)
    container:RegisterForDrag("LeftButton")
    local function movableAncestor(self)
        local p = self:GetParent()
        while p do
            if p.IsMovable and p:IsMovable() then return p end
            p = p:GetParent()
        end
        return nil
    end
    container:SetScript("OnDragStart", function(self)
        local win = movableAncestor(self)   -- exception(nullable): no movable ancestor in embedded use
        if win then win:StartMoving() end
    end)
    container:SetScript("OnDragStop", function(self)
        local win = movableAncestor(self)   -- exception(nullable): see OnDragStart
        if win then win:StopMovingOrSizing() end
    end)

    -- Background texture (Blizzard atlas)
    local bg = container:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetAtlas(Colors.atlas.fillBarBg)
    container.bg = bg

    -- Fill bar (Blizzard atlas) - centered within bg (25px fill in 34px bg = 2px inset)
    local fill = container:CreateTexture(nil, "ARTWORK")
    fill:SetAtlas(Colors.atlas.fillBarFill)
    fill:SetPoint("TOPLEFT", 2, -2)
    fill:SetPoint("BOTTOMLEFT", 2, 3)
    fill:SetWidth(1)
    container.fill = fill

    -- Progress text
    local text = container:CreateFontString(nil, "OVERLAY")
    text:SetPoint("CENTER")
    VE.Theme.ApplyFont(text, Colors, "small")
    text:SetTextColor(Colors.text.r, Colors.text.g, Colors.text.b)
    container.text = text

    -- Reward icon (shown when progress is maxed)
    -- The icon lives inside a host FRAME rather than being a bare texture on the
    -- bar, because the pulse scales it: SetScale is a SimpleFrame method and does
    -- NOT exist on textures/regions (checked against Blizzard's generated API
    -- docs), so a Scale animation has nothing to act on and the reset path would
    -- error. Show/Hide and the animation target the host; texture-only calls
    -- (SetTexture, SetDesaturated) stay on the icon.
    local rewardHost = CreateFrame("Frame", nil, container)
    rewardHost:SetSize(height - 4, height - 4)
    rewardHost:SetPoint("CENTER")
    rewardHost:Hide()
    container.rewardHost = rewardHost

    local rewardIcon = rewardHost:CreateTexture(nil, "OVERLAY")
    rewardIcon:SetAllPoints()
    container.rewardIcon = rewardIcon
    container.finalRewardTexture = nil

    -- Pulse animation for "chest ready to claim" state. Looped, so OnFinished
    -- only fires when Stop() is called explicitly -- that's where we restore
    -- alpha. SetChestState also resets alpha when stopping, belt-and-braces.
    -- The icon breathes: grows + brightens, then shrinks + dims, on repeat.
    -- Alpha alone was too easy to miss on a 16px bar, so a Scale pair carries
    -- most of the signal now.
    --
    -- Scale animations COMPOUND -- each one multiplies the current scale rather
    -- than setting an absolute one. Under SetLooping("REPEAT") the up and down
    -- factors must therefore multiply back to exactly 1.0 or the icon drifts
    -- bigger (or vanishes) over successive cycles. 1.25 * 0.8 == 1.0.
    local PULSE_GROW, PULSE_SHRINK = 1.25, 0.8
    local PULSE_HALF = 0.6

    local pulse = rewardHost:CreateAnimationGroup()
    pulse:SetLooping("REPEAT")

    local grow = pulse:CreateAnimation("Scale")
    grow:SetScaleTo(PULSE_GROW, PULSE_GROW)
    grow:SetOrigin("CENTER", 0, 0)
    grow:SetDuration(PULSE_HALF)
    grow:SetOrder(1)
    grow:SetSmoothing("IN_OUT")

    local fadeOut = pulse:CreateAnimation("Alpha")
    fadeOut:SetFromAlpha(1.0)
    fadeOut:SetToAlpha(0.55)
    fadeOut:SetDuration(PULSE_HALF)
    fadeOut:SetOrder(1)
    fadeOut:SetSmoothing("IN_OUT")

    local shrink = pulse:CreateAnimation("Scale")
    shrink:SetScaleTo(PULSE_SHRINK, PULSE_SHRINK)
    shrink:SetOrigin("CENTER", 0, 0)
    shrink:SetDuration(PULSE_HALF)
    shrink:SetOrder(2)
    shrink:SetSmoothing("IN_OUT")

    local fadeIn = pulse:CreateAnimation("Alpha")
    fadeIn:SetFromAlpha(0.55)
    fadeIn:SetToAlpha(1.0)
    fadeIn:SetDuration(PULSE_HALF)
    fadeIn:SetOrder(2)
    fadeIn:SetSmoothing("IN_OUT")

    -- Restore BOTH properties on stop. A Stop() mid-cycle leaves the icon at
    -- whatever scale/alpha the animation had reached, and the compounding above
    -- means a stray residual scale would persist into the next Play().
    local function resetPulse()
        rewardHost:SetAlpha(1.0)
        rewardHost:SetScale(1.0)
    end
    pulse:SetScript("OnFinished", resetPulse)
    pulse:SetScript("OnStop", resetPulse)
    container.rewardPulse = pulse
    container.chestAvailable = false
    container.chestClaimed = false

    -- Tooltip. Explains the pulsing icon (which is otherwise unlabelled) and is
    -- where the right-click action is advertised -- the only affordance it has,
    -- so it's only offered while the action would actually do something.
    container:SetScript("OnEnter", function(self)
        -- Once the chest is claimed -- however it got there, manual or the
        -- favor-delta detector -- there's nothing left to explain and no action
        -- left to offer, so the bar goes quiet. A tooltip that fires on every
        -- hover for the rest of the cycle is pure noise.
        if self.chestClaimed then return end

        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("Endeavor Progress", 1, 1, 1)
        GameTooltip:AddLine("Your neighborhood's progress toward this cycle's milestones.", 0.7, 0.7, 0.7, true)

        if self.chestAvailable then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Completion chest ready to claim", 0.2, 0.8, 0.2)
            GameTooltip:AddLine("Collect it from the neighborhood notice board.", 0.7, 0.7, 0.7, true)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Right-click: mark as already claimed", 1, 0.82, 0)
            GameTooltip:AddLine("Use this if you claimed it and the icon is still pulsing.", 0.7, 0.7, 0.7, true)
        end
        GameTooltip:Show()
    end)
    container:SetScript("OnLeave", GameTooltip_Hide)

    -- Right-click marks the chest claimed -- same action as /ve claimed. Only
    -- meaningful while a chest is ready, so it's a no-op otherwise rather than
    -- printing noise at players who right-clicked the bar by accident.
    container:SetScript("OnMouseUp", function(self, button)
        if button ~= "RightButton" then return end
        if not (self.chestAvailable and not self.chestClaimed) then return end
        if not VE.EndeavorTracker then return end

        local ok, info = VE.EndeavorTracker:MarkActiveChestClaimed()
        if ok then
            print(("|cFF859900[VE]|r Marked chest as claimed for the active house, cycle %s. |cFF93a1a1(/ve unclaimed to undo)|r")
                :format(tostring(info)))
            -- The open tooltip is dismissed by _ApplyChestVisuals, which the
            -- claim's UI refresh runs -- so the manual and automatic paths
            -- retire it the same way.
        elseif info == "already-claimed" then
            print("|cFFb58900[VE]|r That chest is already marked claimed.")
        else
            print("|cFFdc322f[VE]|r No active house initiative loaded; can't mark claimed.")
        end
    end)

    -- Milestone diamonds (if provided)
    container.milestones = {}

    function container:SetFinalReward(rewardQuestID)
        if not rewardQuestID or rewardQuestID == 0 then
            self.finalRewardTexture = nil
            return
        end
        local currencyInfo = C_QuestLog.GetQuestRewardCurrencyInfo(rewardQuestID, 1, false)
        if currencyInfo and currencyInfo.texture then
            self.finalRewardTexture = currencyInfo.texture
        end
    end

    -- Flash the chest icon when ready-to-claim, freeze it when claimed.
    -- The rewardIcon is an addon-owned texture so Play/Stop/SetDesaturated/
    -- SetAlpha shouldn't taint Blizzard widgets, but if we're called during
    -- combat we still defer to PLAYER_REGEN_ENABLED -- paranoid-safe and
    -- avoids any future-Blizzard surprises.
    function container:SetChestState(available, claimed)
        self.chestAvailable = available and true or false
        self.chestClaimed = claimed and true or false
        if InCombatLockdown() then
            if not self._pendingChestApply then
                self._pendingChestApply = true
                local frame = CreateFrame("Frame")
                frame:RegisterEvent("PLAYER_REGEN_ENABLED")
                frame:SetScript("OnEvent", function(f)
                    f:UnregisterAllEvents()
                    container._pendingChestApply = nil
                    container:_ApplyChestVisuals()
                end)
            end
            return
        end
        self:_ApplyChestVisuals()
    end

    -- Internal: reconcile pulse + alpha + desaturation against the current
    -- (chestAvailable, chestClaimed, rewardIcon visibility) state. Called
    -- from both SetChestState and SetProgress so the two never disagree.
    function container:_ApplyChestVisuals()
        local shouldPulse = self.chestAvailable and not self.chestClaimed and self.rewardHost:IsShown()
        if shouldPulse then
            if not self.rewardPulse:IsPlaying() then self.rewardPulse:Play() end
            self.rewardIcon:SetDesaturated(false)
        else
            if self.rewardPulse:IsPlaying() then self.rewardPulse:Stop() end
            self.rewardHost:SetAlpha(1.0)
            self.rewardHost:SetScale(1.0)
            self.rewardIcon:SetDesaturated(self.chestClaimed)
        end

        -- Retire an open tooltip the moment the chest becomes claimed. This runs
        -- for BOTH claim paths (right-click and the favor-delta auto-detector),
        -- so a tooltip left hanging under the cursor can't keep advertising an
        -- action that no longer exists.
        if self.chestClaimed and GameTooltip:IsOwned(self) then
            GameTooltip:Hide()
        end
    end

    function container:SetProgress(current, max)
        local pct = max > 0 and (current / max) or 0
        pct = math.min(1, math.max(0, pct))

        local fillWidth = math.max(1, (self:GetWidth() - 4) * pct)
        self.fill:SetWidth(fillWidth)

        -- When maxed and we have a reward texture, show icon instead of text
        if current >= max and self.finalRewardTexture then
            self.text:Hide()
            self.rewardIcon:SetTexture(self.finalRewardTexture)
            self.rewardHost:Show()
            self:_ApplyChestVisuals()
        else
            self.rewardHost:Hide()
            self:_ApplyChestVisuals()
            self.text:SetText(string.format("%d / %d", current, max))
            self.text:Show()
        end
    end

    function container:SetMilestones(milestones, max)
        -- Clear existing
        for _, m in ipairs(self.milestones) do
            m:Hide()
        end
        self.milestones = {}

        if not milestones then return end

        local C = GetScheme()
        local barWidth = self:GetWidth() - 4
        if barWidth <= 0 then barWidth = VE.Constants.UI.mainWidth - 60 end
        for i, milestone in ipairs(milestones) do
            local pip = self:CreateTexture(nil, "OVERLAY")
            pip:SetSize(VE.Constants.UI.milestoneSize, VE.Constants.UI.milestoneSize)

            local xPos = (milestone.threshold / max) * barWidth
            pip:SetPoint("CENTER", self, "LEFT", xPos + 2, 0)

            -- All themes use Blizzard pip atlases
            if milestone.reached then
                pip:SetAtlas(C.atlas.pipComplete)
            else
                pip:SetAtlas(C.atlas.pipIncomplete)
            end
            pip:SetVertexColor(1, 1, 1, 1)

            table.insert(self.milestones, pip)
        end
    end

    -- Register with theme engine
    RegisterWidget(container, "ProgressBar")

    return container
end

-- ============================================================================
-- TASK ROW
-- ============================================================================

-- Floor for the task row's progress column, so short values ("0/5") line up in a
-- consistent gutter instead of jittering per row. No ceiling -- see the progress
-- FontString below.
local PROGRESS_MIN_W = 50

function VE.UI:CreateTaskRow(parent, options)
    options = options or {}
    local height = options.height or VE.Constants.UI.taskRowHeight
    local Colors = GetScheme()

    local row = CreateFrame("Button", nil, parent, "BackdropTemplate")
    row:SetHeight(height)
    row:SetBackdrop(BACKDROP_BORDERLESS)
    row:SetBackdropColor(Colors.panel.r, Colors.panel.g, Colors.panel.b, Colors.panel.a * 0.5)
    row:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    -- Store scheme for hover scripts
    row._scheme = Colors

    -- Checkbox/status indicator
    local status = row:CreateTexture(nil, "ARTWORK")
    status:SetSize(14, 14)
    status:SetPoint("LEFT", 4, 0)  -- 4px left padding
    status:SetTexture("Interface\\COMMON\\Indicator-Gray")
    row.status = status

    -- Repeatable indicator (circular arrow icon - replaces status for repeatable tasks)
    local repeatIcon = row:CreateTexture(nil, "ARTWORK")
    repeatIcon:SetSize(20, 20)
    repeatIcon:SetPoint("LEFT", 1, 0)  -- 4px left padding (-3 + 4 = 1)
    repeatIcon:SetAtlas("UI-RefreshButton")
    repeatIcon:Hide()
    row.repeatIcon = repeatIcon

    -- Counter text inside repeat icon (shows times completed)
    local repeatCount = row:CreateFontString(nil, "OVERLAY")
    repeatCount:SetPoint("CENTER", repeatIcon, "CENTER", 1, 0)
    repeatCount:SetFont(VE.Constants:GetFontFile(), 10, "OUTLINE")
    repeatCount:SetTextColor(Colors.success.r, Colors.success.g, Colors.success.b)
    repeatCount:Hide()
    row.repeatCount = repeatCount

    -- Tracking checkmark (overlays on status/repeat icon when task is pinned)
    local trackMark = row:CreateTexture(nil, "OVERLAY", nil, 7)  -- High sublevel to draw on top
    trackMark:SetSize(14, 14)
    trackMark:SetPoint("LEFT", 4, 0)  -- 4px left padding
    trackMark:SetAtlas("common-icon-checkmark")
    trackMark:SetVertexColor(Colors.success.r, Colors.success.g, Colors.success.b)
    trackMark:Hide()
    row.trackMark = trackMark

    -- Task name (use theme-aware text color). Anchored LEFT only here; its RIGHT
    -- edge is set against the progress column further down, once that exists.
    local name = row:CreateFontString(nil, "OVERLAY")
    name:SetPoint("LEFT", status, "RIGHT", 6, 0)
    name:SetJustifyH("LEFT")
    VE.Theme.ApplyFont(name, Colors)
    name:SetTextColor(Colors.text.r, Colors.text.g, Colors.text.b)
    row.name = name

    -- Favourite star icon (above coupon badge)
    local favStar = row:CreateTexture(nil, "OVERLAY", nil, 7)
    favStar:SetSize(16, 16)
    favStar:SetPoint("RIGHT", 1, 8)  -- Above coupon display, 3px right
    favStar:SetAtlas("ParagonReputation_Glow")
    favStar:SetVertexColor(1, 0.82, 0, 0.9)  -- Gold star
    favStar:Hide()
    row.favStar = favStar

    -- Favourite toggle function
    function row:SetFavourite(isFav)
        self.isFavourite = isFav
        self.favStar:SetShown(isFav)
    end

    -- Helper: get per-endeavor favourites table (migrates old flat format)
    local function GetFavTable()
        VE_DB = VE_DB or {}
        VE_DB.ui = VE_DB.ui or {}
        VE_DB.ui.favouriteTasks = VE_DB.ui.favouriteTasks or {}
        -- Migrate old flat format: {[taskName]=true} -> wipe
        for _, v in pairs(VE_DB.ui.favouriteTasks) do
            if v == true then VE_DB.ui.favouriteTasks = {} end
            break
        end
        local initID = VE.Store:GetState().endeavor.initiativeID
        if not initID or initID == 0 then return nil, 0 end
        VE_DB.ui.favouriteTasks[initID] = VE_DB.ui.favouriteTasks[initID] or {}
        return VE_DB.ui.favouriteTasks[initID], initID
    end

    function row:ToggleFavourite()
        if not self.task then return end
        local taskName = self.task.name
        if not taskName then return end
        local favTable = GetFavTable()
        if not favTable then return end
        if favTable[taskName] then
            favTable[taskName] = nil
            self:SetFavourite(false)
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        else
            local count = 0
            for _ in pairs(favTable) do count = count + 1 end
            if count >= 7 then
                print("|cFFFFCC00[VE]|r Maximum 7 favourites per endeavor")
                return
            end
            favTable[taskName] = true
            self:SetFavourite(true)
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        end
        VE.EventBus:Trigger("VE_FAVOURITES_CHANGED")
    end

    -- Check if task is already favourited
    function row:CheckFavourite()
        if not self.task or not self.task.name then return end
        local favTable = GetFavTable()
        local isFav = favTable and favTable[self.task.name] and true or false
        self:SetFavourite(isFav)
    end

    -- Coupon reward badge (shows +3 coupons)
    local couponBg = CreateFrame("Frame", nil, row, "BackdropTemplate")
    couponBg:SetSize(26, 18)
    couponBg:SetPoint("RIGHT", -4, 0)
    couponBg:SetBackdrop(BACKDROP_FLAT)
    couponBg:SetBackdropColor(Colors.accent.r, Colors.accent.g, Colors.accent.b, Colors.accent.a * 0.3)
    couponBg:SetBackdropBorderColor(Colors.accent.r, Colors.accent.g, Colors.accent.b, Colors.accent.a * 0.6)

    local couponText = couponBg:CreateFontString(nil, "OVERLAY")
    couponText:SetPoint("CENTER")
    VE.Theme.ApplyFont(couponText, Colors)
    couponText:SetTextColor(Colors.accent.r, Colors.accent.g, Colors.accent.b, Colors.accent.a)
    couponText:SetText("+3")
    row.couponText = couponText
    row.couponBg = couponBg

    -- Points badge
    local pointsBg = CreateFrame("Frame", nil, row, "BackdropTemplate")
    pointsBg:SetSize(32, 24)
    pointsBg:SetPoint("RIGHT", couponBg, "LEFT", -4, 0)
    pointsBg:SetBackdrop(BACKDROP_FLAT)
    pointsBg:SetBackdropColor(Colors.endeavor.r, Colors.endeavor.g, Colors.endeavor.b, Colors.endeavor.a * 0.3)
    pointsBg:SetBackdropBorderColor(Colors.endeavor.r, Colors.endeavor.g, Colors.endeavor.b, Colors.endeavor.a * 0.6)

    local points = pointsBg:CreateFontString(nil, "OVERLAY")
    points:SetPoint("CENTER")
    VE.Theme.ApplyFont(points, Colors)
    points:SetTextColor(Colors.endeavor.r, Colors.endeavor.g, Colors.endeavor.b, Colors.endeavor.a)
    row.points = points
    row.pointsBg = pointsBg

    -- Progress text (for partial completion).
    --
    -- Width is content-driven, set per update in SetTask. It used to be a hard
    -- SetWidth(50) with word-wrap off, which silently TRUNCATED any value wider
    -- than that -- a task counting to a big number rendered as "0/250..." with
    -- the real total cut off. PROGRESS_MIN_W keeps short values in a consistent
    -- column; there's deliberately no maximum, because clipping the number is
    -- worse than borrowing space from the task name.
    local progress = row:CreateFontString(nil, "OVERLAY")
    progress:SetPoint("RIGHT", pointsBg, "LEFT", -6, 0)
    progress:SetWidth(PROGRESS_MIN_W)
    progress:SetJustifyH("RIGHT")
    progress:SetWordWrap(false)
    VE.Theme.ApplyFont(progress, Colors)
    progress:SetTextColor(Colors.text_dim.r, Colors.text_dim.g, Colors.text_dim.b)
    row.progress = progress

    -- Name's right edge now tracks the progress column instead of a fixed -70
    -- inset. That inset never matched the actual right-hand cluster (coupon +
    -- points + progress is ~124px), so a long name ran underneath it; and now
    -- that progress can grow, the name has to yield rather than be overlapped.
    name:ClearAllPoints()
    name:SetPoint("LEFT", status, "RIGHT", 6, 0)
    name:SetPoint("RIGHT", progress, "LEFT", -6, 0)

    -- Rank medal indicator (top-left of XP badge)
    local rankMedal = pointsBg:CreateTexture(nil, "OVERLAY", nil, 2)
    rankMedal:SetSize(14, 14)
    rankMedal:SetPoint("TOPLEFT", pointsBg, "TOPLEFT", -4, 4)
    rankMedal:Hide()
    row.rankMedal = rankMedal

    -- Medal atlases by rank
    row.rankMedals = {
        [1] = "challenges-medal-gold",
        [2] = "challenges-medal-silver",
        [3] = "challenges-medal-bronze",
    }

    -- Store rank colors (gold, silver, bronze)
    row.rankColors = {
        [1] = { r = 1.0, g = 0.84, b = 0.0 },   -- Gold
        [2] = { r = 0.75, g = 0.75, b = 0.75 }, -- Silver
        [3] = { r = 0.80, g = 0.50, b = 0.20 }, -- Bronze
    }
    row.rankTints = {
        [1] = { r = 1.0, g = 0.84, b = 0.0, a = 0.15 },   -- Gold tint
        [2] = { r = 0.75, g = 0.75, b = 0.75, a = 0.12 }, -- Silver tint
        [3] = { r = 0.80, g = 0.50, b = 0.20, a = 0.12 }, -- Bronze tint
    }

    -- Update function
    function row:SetTask(task, ranking)
        local C = GetScheme()  -- Re-fetch for current theme
        self.task = task
        self.ranking = ranking  -- Store for tooltip
        self.name:SetText(task.name or "Unknown Task")
        self.points:SetText(tostring(task.points or 0))

        -- Update coupon reward display. couponReward already carries Blizzard's
        -- own dampening for the next completion (GetInitiativeTaskRewardScaling),
        -- so there is nothing left for us to multiply.
        local couponDisplay = task.couponReward or 0
        if couponDisplay > 0 then
            self.couponText:SetText("+" .. couponDisplay)
            self.couponBg:Show()
        else
            self.couponBg:Hide()
        end

        -- Show/hide repeatable icon and adjust name position
        self.name:ClearAllPoints()
        if task.isRepeatable then
            self.status:Hide()
            self.repeatIcon:Show()
            -- Show completion count inside icon
            local count = task.timesCompleted or 0
            if count > 0 then
                self.repeatCount:SetText(tostring(count))
                self.repeatCount:Show()
            else
                self.repeatCount:Hide()
            end
            self.name:SetPoint("LEFT", self.repeatIcon, "RIGHT", 2, 0)
            self.name:SetPoint("RIGHT", -100, 0)
        else
            self.repeatIcon:Hide()
            self.repeatCount:Hide()
            self.status:Show()
            self.name:SetPoint("LEFT", self.status, "RIGHT", 6, 0)
            self.name:SetPoint("RIGHT", -100, 0)

            if task.completed then
                self.status:SetTexture("Interface\\COMMON\\Indicator-Green")
            else
                self.status:SetTexture("Interface\\COMMON\\Indicator-Gray")
            end
        end

        local progressStr = ""
        if task.completed then
            self.name:SetTextColor(C.success.r, C.success.g, C.success.b)
        else
            if task.max and task.max > 1 then
                progressStr = string.format("%d/%d", task.current or 0, task.max)
            end
            self.name:SetTextColor(C.text.r, C.text.g, C.text.b)
        end
        -- Size the column to the text BEFORE setting it, so a wide value gets the
        -- room it needs instead of being truncated to "0/250...". Measured off the
        -- font rather than the rendered string, so it's right on the first paint.
        self.progress:SetWidth(math.max(PROGRESS_MIN_W,
            VE.UI.NaturalTextWidth(self.progress, progressStr, 0) + 2))
        self.progress:SetText(progressStr)

        -- Update tracking checkmark
        if task.tracked and not task.completed then
            self.trackMark:Show()
        else
            self.trackMark:Hide()
        end

        -- DR step lookup (drives both XP and coupon coloring for repeatable tasks)
        local dr = nil
        if VE.EndeavorTracker and VE.EndeavorTracker.GetDRStepInfo then
            dr = VE.EndeavorTracker:GetDRStepInfo({
                taskType = self.task.taskType,
                timesCompleted = self.task.timesCompleted,
            })
        end
        local drColor = dr and VE.UI.DR_STEP_COLORS[dr.step] or nil
        local pointsColor = drColor or C.success

        -- Tint coupon (both border and text) when DR applies; reset to accent otherwise
        if self.couponBg and self.couponText then
            if drColor then
                self.couponBg:SetBackdropColor(drColor.r, drColor.g, drColor.b, 0.30)
                self.couponBg:SetBackdropBorderColor(drColor.r, drColor.g, drColor.b, 0.85)
                self.couponText:SetTextColor(drColor.r, drColor.g, drColor.b, 1)
            else
                self.couponBg:SetBackdropColor(C.accent.r, C.accent.g, C.accent.b, C.accent.a * 0.3)
                self.couponBg:SetBackdropBorderColor(C.accent.r, C.accent.g, C.accent.b, C.accent.a * 0.6)
                self.couponText:SetTextColor(C.accent.r, C.accent.g, C.accent.b, C.accent.a)
            end
        end

        -- Apply ranking tint and medal for top 3 "next XP" tasks
        if ranking and ranking.rank and ranking.rank >= 1 and ranking.rank <= 3 then
            local rank = ranking.rank
            local tint = self.rankTints[rank]
            -- Store tint for OnLeave to restore
            self._rankTint = tint
            -- Apply background tint
            self:SetBackdropColor(tint.r, tint.g, tint.b, tint.a)
            -- Reset XP text to themed color (in case it was warning before)
            self.points:SetTextColor(pointsColor.r, pointsColor.g, pointsColor.b)
            -- Show medal
            self.rankMedal:SetAtlas(self.rankMedals[rank])
            self.rankMedal:Show()
        else
            -- Hide medal
            self.rankMedal:Hide()
            -- Check if task gives 0 XP (warning highlight)
            local showNoXPWarning = false
            local endeavor = VE.Store and VE.Store:GetState().endeavor
            local isCapped = endeavor and endeavor.maxProgress and endeavor.maxProgress > 0
                and endeavor.currentProgress and endeavor.currentProgress >= endeavor.maxProgress
            if not task.completed and VE.EndeavorTracker and not isCapped then
                if task.isRepeatable then
                    -- Repeatable: check if next completion gives 0 XP
                    local nextXP = VE.EndeavorTracker:CalculateNextContribution(task.name)
                    showNoXPWarning = (nextXP == 0)
                elseif not task.isRepeatable then
                    -- Non-repeatable: no warning if not completed (will give XP on first/only completion)
                    showNoXPWarning = false
                end
            end
            if showNoXPWarning then
                -- Apply warning tint for 0 XP tasks (use theme's error color)
                self._isNoXPWarning = true
                self._rankTint = { r = C.error.r, g = C.error.g, b = C.error.b, a = 0.18 }
                self:SetBackdropColor(C.error.r, C.error.g, C.error.b, 0.18)
                -- Also color the XP text to match warning
                self.points:SetTextColor(C.error.r, C.error.g, C.error.b)
            else
                -- Clear warning flag and rank tint, reset to default
                self._isNoXPWarning = false
                self._rankTint = nil
                self:SetBackdropColor(C.panel.r, C.panel.g, C.panel.b, C.panel.a * 0.5)
                -- Reset XP text to themed color
                self.points:SetTextColor(pointsColor.r, pointsColor.g, pointsColor.b)
            end
        end

        -- Check favourite status
        self:CheckFavourite()
    end

    -- Toggle tracking state
    function row:ToggleTracking()
        if not self.task or not self.task.id then return end
        if self.task.completed then return end
        if InCombatLockdown() then return end

        if C_NeighborhoodInitiative then
            if self.task.tracked then
                C_NeighborhoodInitiative.RemoveTrackedInitiativeTask(self.task.id)
                self.task.tracked = false
            else
                C_NeighborhoodInitiative.AddTrackedInitiativeTask(self.task.id)
                self.task.tracked = true
            end
            self.trackMark:SetShown(self.task.tracked)
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        end
    end

    -- Click handler (shift-click to favourite, right-click to track)
    row:SetScript("OnClick", function(self, button)
        if button == "RightButton" then
            self:ToggleTracking()
        elseif IsModifiedClick("QUESTWATCHTOGGLE") then
            self:ToggleFavourite()
        end
    end)

    -- Hover effect
    row:EnableMouse(true)
    row:SetScript("OnEnter", function(self)
        local c = self._scheme or GetScheme()
        self:SetBackdropColor(c.button_hover.r, c.button_hover.g, c.button_hover.b, c.button_hover.a * 0.3)
        if self.task then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(self.task.name, 1, 1, 1)
            if self.task.description and self.task.description ~= "" then
                GameTooltip:AddLine(self.task.description, nil, nil, nil, true)
            end

            -- DR breakdown for repeatable tasks (curve 87592, 6 steps)
            if self.task.isRepeatable then
                local times = self.task.timesCompleted or 0
                local currentMult = (times >= 5) and 0.5 or math.max(0.5, 1.0 - times * 0.1)
                local pointsForecast = self.task.points or 0
                local xpBase = (currentMult > 0) and math.floor(pointsForecast / currentMult + 0.5) or pointsForecast
                local couponBase = self.task.couponBase or 0

                if xpBase > 0 or couponBase > 0 then
                    GameTooltip:AddLine(" ")
                    local baseLine = "Base reward: " .. xpBase .. " XP"
                    if couponBase > 0 then baseLine = baseLine .. "  /  " .. couponBase .. " coupons" end
                    GameTooltip:AddLine(baseLine, 1.00, 0.82, 0.00)

                    -- Where this task actually stands. The ">" marker names the
                    -- rung but not the count behind it, and the count is what
                    -- tells you whether the next one is still worth doing.
                    local currentStep = math.min(times, 5)
                    local standing
                    if times == 0 then
                        standing = "Not completed yet -- next is #1"
                    elseif times >= 5 then
                        standing = ("Completed %d times -- at the 50%% floor"):format(times)
                    else
                        standing = ("Completed %d time%s -- next is #%d"):format(
                            times, times == 1 and "" or "s", currentStep + 1)
                    end
                    local standingColor = VE.UI.DR_STEP_COLORS[currentStep]
                    GameTooltip:AddLine(standing, standingColor.r, standingColor.g, standingColor.b)

                    GameTooltip:AddLine("Diminishing returns for each completion:", 0.7, 0.7, 0.7)
                    for step = 0, 5 do
                        local mult = (step >= 5) and 0.5 or (1.0 - step * 0.1)
                        local xp = math.floor(xpBase * mult + 0.5)
                        local cp = math.floor(couponBase * mult + 0.5)
                        local sc = (VE.UI and VE.UI.DR_STEP_COLORS and VE.UI.DR_STEP_COLORS[step])
                            or { r = 1, g = 1, b = 1 }
                        local marker = (step == currentStep) and ">  " or "    "
                        local nLabel = (step >= 5) and (tostring(step + 1) .. "+") or tostring(step + 1)
                        local pctLabel = (step >= 5) and "50%+" or string.format("%d%%", math.floor(mult * 100 + 0.5))
                        local line = string.format("%s#%s (%s): %d XP", marker, nLabel, pctLabel, xp)
                        if couponBase > 0 then line = line .. " / " .. cp .. " coupons" end
                        GameTooltip:AddLine(line, sc.r, sc.g, sc.b)
                    end
                end
            end

            if not self.task.completed then
                GameTooltip:AddLine(" ")
                if self.isFavourite then
                    GameTooltip:AddLine("Shift-click to unfavourite", 1, 0.82, 0)
                else
                    GameTooltip:AddLine("Shift-click to favourite", 0.5, 0.5, 0.5)
                end
                if self.task.tracked then
                    GameTooltip:AddLine("Right-click to untrack", 0.5, 0.5, 0.5)
                else
                    GameTooltip:AddLine("Right-click to track", 0.5, 0.5, 0.5)
                end
            end
            GameTooltip:Show()
        end
    end)
    row:SetScript("OnLeave", function(self)
        local c = self._scheme or GetScheme()
        -- Restore rank tint if present, otherwise default panel color
        if self._rankTint then
            self:SetBackdropColor(self._rankTint.r, self._rankTint.g, self._rankTint.b, self._rankTint.a)
        else
            self:SetBackdropColor(c.panel.r, c.panel.g, c.panel.b, c.panel.a * 0.5)
        end
        GameTooltip:Hide()
    end)

    -- Register with theme engine
    RegisterWidget(row, "TaskRow")

    return row
end

-- ============================================================================
-- DROPDOWN / CHARACTER SELECTOR
-- ============================================================================

function VE.UI:CreateDropdown(parent, options)
    options = options or {}
    local width = options.width or 150
    local height = options.height or VE.Constants.UI.charSelectorHeight
    local Colors = GetScheme()

    local container = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    container:SetSize(width, height)
    container:SetBackdrop(BACKDROP_FLAT)
    container:SetBackdropColor(Colors.panel.r, Colors.panel.g, Colors.panel.b, Colors.panel.a)
    container:SetBackdropBorderColor(Colors.border.r, Colors.border.g, Colors.border.b, Colors.border.a)

    -- Selected text
    local text = container:CreateFontString(nil, "OVERLAY")
    text:SetPoint("LEFT", 8, 0)
    text:SetPoint("RIGHT", -20, 0)
    text:SetJustifyH("LEFT")
    text:SetWordWrap(false)
    VE.Theme.ApplyFont(text, Colors, "small")
    text:SetTextColor(Colors.text.r, Colors.text.g, Colors.text.b)
    container.text = text

    -- Arrow icon
    local arrow = container:CreateTexture(nil, "OVERLAY")
    arrow:SetSize(12, 12)
    arrow:SetPoint("RIGHT", -4, 0)
    arrow:SetAtlas("housing-floor-arrow-down-pressed")

    -- Dropdown menu (hidden by default)
    local menu = CreateFrame("Frame", nil, container, "BackdropTemplate")
    menu:SetPoint("TOPLEFT", container, "BOTTOMLEFT", 0, -1)
    menu:SetPoint("TOPRIGHT", container, "BOTTOMRIGHT", 0, -1)
    menu:SetBackdrop(BACKDROP_FLAT)
    menu:SetBackdropColor(Colors.bg.r, Colors.bg.g, Colors.bg.b, Colors.bg.a)
    menu:SetBackdropBorderColor(Colors.border.r, Colors.border.g, Colors.border.b, Colors.border.a)
    menu:SetFrameStrata("TOOLTIP")
    menu:Hide()
    container.menu = menu

    local menuItems = {}
    container.menuItems = menuItems
    container.selectedKey = nil
    container.onSelect = options.onSelect

    -- Items are POOLED -- created once, reused on every call. The previous version
    -- did item:SetParent(nil) and built fresh Buttons each time, but WoW never
    -- reclaims frames, so each repopulation permanently orphaned a set of Buttons
    -- and FontStrings. The house dropdown repopulates on every window open, so
    -- that accumulated for the whole session.
    function container:SetItems(items)
        local pool = self.menuItems
        local itemHeight = 20
        local yOffset = -2
        -- Read fresh: the factory-captured `Colors` upvalue is the scheme from
        -- build time, so items painted from it kept stale colours after a theme
        -- switch (the OnEnter/OnLeave handlers already read fresh).
        local C = VE.Constants:GetThemeColors()

        for i, itemData in ipairs(items) do
            local item = pool[i]
            if not item then
                item = CreateFrame("Button", nil, self.menu)
                item:SetHeight(itemHeight)

                local itemText = item:CreateFontString(nil, "OVERLAY")
                itemText:SetPoint("LEFT", 6, 0)
                item.text = itemText

                -- Wired once. The handlers read self.key / self.data, which the
                -- loop restamps on every reuse, so a recycled row never fires
                -- with the previous item's payload.
                item:SetScript("OnClick", function(self)
                    container:SetSelected(self.key, self.data)
                    container.menu:Hide()
                    if container.onSelect then
                        container.onSelect(self.key, self.data)
                    end
                end)
                item:SetScript("OnEnter", function(self)
                    local c = VE.Constants:GetThemeColors()
                    self.text:SetTextColor(c.accent.r, c.accent.g, c.accent.b)
                end)
                item:SetScript("OnLeave", function(self)
                    local c = VE.Constants:GetThemeColors()
                    self.text:SetTextColor(c.text.r, c.text.g, c.text.b)
                end)

                pool[i] = item
            end

            item:ClearAllPoints()
            item:SetPoint("TOPLEFT", 2, yOffset)
            item:SetPoint("TOPRIGHT", -2, yOffset)

            item.key = itemData.key
            item.data = itemData
            -- ApplyFont MUST precede SetText. A freshly-pooled FontString has no
            -- font object yet, and SetText on one errors "Font not set" -- the
            -- old non-pooled code got away with the reverse order only because it
            -- fonted each FontString at creation.
            VE.Theme.ApplyFont(item.text, C, "small")
            item.text:SetText(itemData.label or itemData.key)
            item.text:SetTextColor(C.text.r, C.text.g, C.text.b)
            item:Show()

            yOffset = yOffset - itemHeight
        end

        -- Surplus is hidden, not destroyed -- the next call reuses it.
        for i = #items + 1, #pool do
            pool[i]:Hide()
        end

        -- Menu width fits the longest label. NaturalTextWidth, not
        -- GetStringWidth: the latter reads 0 until the FontString has drawn, so
        -- the menu collapsed to the container minimum on its first population.
        local maxTextWidth = width - 4 -- minimum = container width minus borders
        for i = 1, #items do
            local textWidth = VE.UI.NaturalTextWidth(pool[i].text, nil, 0) + 16
            if textWidth > maxTextWidth then
                maxTextWidth = textWidth
            end
        end

        -- Clear right anchor and set explicit width for menu
        self.menu:ClearAllPoints()
        self.menu:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
        self.menu:SetWidth(maxTextWidth)
        self.menu:SetHeight(math.abs(yOffset) + 4)
    end

    function container:SetSelected(key, data)
        self.selectedKey = key
        if data and data.label then
            self.text:SetText(data.label)
        else
            self.text:SetText(key or "")
        end
    end

    function container:GetSelected()
        return self.selectedKey
    end

    -- Toggle menu on click
    container:EnableMouse(true)
    container:SetScript("OnMouseDown", function(self)
        if self.menu:IsShown() then
            self.menu:Hide()
        else
            self.menu:Show()
        end
    end)

    -- Close menu when clicking elsewhere
    menu:SetScript("OnShow", function(self)
        self:SetPropagateKeyboardInput(true)
    end)

    -- Register with theme engine
    RegisterWidget(container, "Dropdown")

    return container
end

-- ============================================================================
-- SECTION HEADER
-- ============================================================================

function VE.UI:CreateSectionHeader(parent, text)
    local Colors = GetScheme()

    local header = CreateFrame("Frame", nil, parent)
    header:SetHeight(18)

    -- Background texture (atlas for Housing Theme)
    local bg = header:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    if Colors.atlas and Colors.atlas.sectionHeaderBg then
        bg:SetAtlas(Colors.atlas.sectionHeaderBg)
    else
        bg:SetTexture("Interface\\Buttons\\WHITE8x8")
        bg:SetVertexColor(Colors.panel.r, Colors.panel.g, Colors.panel.b, 0.3)
    end
    header.bg = bg

    -- Border for non-atlas themes (1px edge)
    local border = header:CreateTexture(nil, "BORDER")
    border:SetAllPoints()
    border:SetTexture("Interface\\Buttons\\WHITE8x8")
    border:SetVertexColor(Colors.border.r, Colors.border.g, Colors.border.b, 0.5)
    header.border = border

    -- Inner background (slightly inset for border effect)
    local innerBg = header:CreateTexture(nil, "ARTWORK", nil, -1)
    innerBg:SetPoint("TOPLEFT", 1, -1)
    innerBg:SetPoint("BOTTOMRIGHT", -1, 1)
    innerBg:SetTexture("Interface\\Buttons\\WHITE8x8")
    innerBg:SetVertexColor(Colors.panel.r, Colors.panel.g, Colors.panel.b, 0.3)
    header.innerBg = innerBg

    -- Hide border elements for atlas themes
    if Colors.atlas and Colors.atlas.sectionHeaderBg then
        border:Hide()
        innerBg:Hide()
    end

    -- Drop shadow (rendered behind main label)
    local shadow = header:CreateFontString(nil, "ARTWORK")
    shadow:SetPoint("CENTER", 1, 1)  -- Offset down-right for shadow effect
    shadow:SetJustifyH("CENTER")
    VE.Theme.ApplyFont(shadow, Colors, "small")
    shadow:SetText(text)
    shadow:SetTextColor(0, 0, 0, 0.6)  -- Black with transparency
    header.shadow = shadow

    local label = header:CreateFontString(nil, "OVERLAY")
    label:SetPoint("CENTER", 0, 2)  -- 2px higher
    label:SetJustifyH("CENTER")
    VE.Theme.ApplyFont(label, Colors, "small")
    label:SetText(text)
    label:SetTextColor(Colors.accent.r, Colors.accent.g, Colors.accent.b)
    header.label = label

    local line = header:CreateTexture(nil, "ARTWORK")
    line:SetHeight(8)
    line:SetPoint("LEFT", label, "RIGHT", 8, 0)
    line:SetPoint("RIGHT", -4, 0)
    line:SetAtlas("housing-bulletinboard-list-header-decorative-line")
    line:Hide()  -- Hidden by default (centered text doesn't use line)
    header.line = line

    -- Decorative foliage (Housing Theme only) - spills below header
    -- Layer order: BACKGROUND (bg) -> BORDER (foliage) -> OVERLAY (text/icons)
    local foliageLeft = header:CreateTexture(nil, "BORDER")
    foliageLeft:SetAtlas("housing-decorative-foliage-left")
    foliageLeft:SetPoint("BOTTOMLEFT", 0, -8)  -- Anchor at bottom, spills down
    foliageLeft:SetSize(32, 32)
    header.foliageLeft = foliageLeft

    local foliageRight = header:CreateTexture(nil, "BORDER")
    foliageRight:SetAtlas("housing-decorative-foliage-right")
    foliageRight:SetPoint("BOTTOMRIGHT", 0, -8)  -- Anchor at bottom, spills down
    foliageRight:SetSize(32, 32)
    header.foliageRight = foliageRight

    -- Only show foliage for Housing Theme
    if not (Colors.atlas and Colors.atlas.sectionHeaderBg) then
        foliageLeft:Hide()
        foliageRight:Hide()
    end

    -- Register with theme engine
    RegisterWidget(header, "SectionHeader")

    return header
end

-- ============================================================================
-- ATLAS BACKGROUND HELPER
-- ============================================================================

-- Adds atlas background support to a BackdropTemplate frame
-- Returns a function to apply colors based on current theme
function VE.UI:AddAtlasBackground(frame)
    local atlasBg = frame:CreateTexture(nil, "BACKGROUND")
    atlasBg:SetAllPoints()
    frame.atlasBg = atlasBg

    -- Return the apply function
    return function(opacityMultiplier)
        local C = GetScheme()
        opacityMultiplier = opacityMultiplier or 0.3
        if C.atlas and C.atlas.taskListBg then
            frame:SetBackdrop(nil)
            atlasBg:SetAtlas(C.atlas.taskListBg)
            atlasBg:SetAlpha(1)
            atlasBg:Show()
        else
            frame:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
            frame:SetBackdropColor(C.panel.r, C.panel.g, C.panel.b, C.panel.a * opacityMultiplier)
            atlasBg:Hide()
        end
    end
end

-- ============================================================================
-- STYLED SCROLLBAR (ported from VDS)
-- ============================================================================

function VE.UI.StyleScrollBar(scrollFrame)
    if not scrollFrame or scrollFrame._veStyled then return end
    scrollFrame._veStyled = true

    local scrollBar = scrollFrame.ScrollBar
    if not scrollBar then return end

    local scheme = GetScheme()

    -- Hide all default Blizzard gold scroll textures
    for _, region in pairs({ scrollBar:GetRegions() }) do
        if region and region.SetAlpha and region:IsObjectType("Texture") then
            region:SetAlpha(0)
        end
    end

    -- Collapse up/down arrow buttons (invisible but still functional)
    if scrollBar.ScrollUpButton then
        scrollBar.ScrollUpButton:SetSize(1, 1)
        scrollBar.ScrollUpButton:SetAlpha(0)
    end
    if scrollBar.ScrollDownButton then
        scrollBar.ScrollDownButton:SetSize(1, 1)
        scrollBar.ScrollDownButton:SetAlpha(0)
    end

    -- Slim dark track (6px wide)
    scrollBar:SetWidth(6)
    local track = scrollBar:CreateTexture(nil, "BACKGROUND")
    track:SetAllPoints()
    track:SetTexture(WHITE)
    track:SetVertexColor(0, 0, 0, 0.10)
    scrollBar._track = track

    -- Thumb: use atlas if Housing Theme provides one, otherwise flat accent
    local thumb = scrollBar:GetThumbTexture()
    local useAtlas = scheme.atlas and scheme.atlas.scrollThumb
    if thumb then
        if useAtlas then
            thumb:SetAtlas(scheme.atlas.scrollThumb)
            thumb:SetVertexColor(1, 1, 1, 1)
            thumb:SetSize(6, 40)
        else
            thumb:SetTexture(WHITE)
            thumb:SetSize(4, 40)
            thumb:SetVertexColor(scheme.accent.r, scheme.accent.g, scheme.accent.b, 0.7)
        end
    end
    scrollBar._thumb = thumb
    scrollBar._useAtlas = useAtlas

    -- Hover brightens thumb (only for non-atlas thumbs)
    scrollBar:HookScript("OnEnter", function(self)
        if self._thumb and not self._useAtlas then
            local s = GetScheme()
            self._thumb:SetVertexColor(
                math.min(s.accent.r + 0.1, 1),
                math.min(s.accent.g + 0.1, 1),
                math.min(s.accent.b + 0.1, 1), 0.9)
        end
    end)
    scrollBar:HookScript("OnLeave", function(self)
        if self._thumb and not self._useAtlas then
            local s = GetScheme()
            self._thumb:SetVertexColor(s.accent.r, s.accent.g, s.accent.b, 0.7)
        end
    end)
end

-- ============================================================================
-- SCROLL FRAME
-- ============================================================================

function VE.UI:CreateScrollFrame(parent)
    local scrollFrame = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 0, -2)
    scrollFrame:SetPoint("BOTTOMRIGHT", -6, 2)

    VE.UI.StyleScrollBar(scrollFrame)

    -- Content container
    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetWidth(scrollFrame:GetWidth())
    content:SetHeight(1) -- Will be updated
    scrollFrame:SetScrollChild(content)
    scrollFrame.content = content

    -- Register with theme engine
    RegisterWidget(scrollFrame, "ScrollFrame")

    return scrollFrame, content
end

-- ============================================================================
-- VIRTUALIZED SCROLL LIST (WowScrollBoxList + pooled rows)
-- ============================================================================
-- Use this for any list whose length is driven by server data (activity log,
-- leaderboard). CreateScrollFrame above lays out every row as its own real
-- frame, so frame count and per-refresh repaint cost both scale with the data:
-- a busy neighborhood's activity log became hundreds of live frames plus a full
-- repaint of all of them every 5s. ScrollBox keeps roughly viewport-many frames
-- alive and recycles them, making both costs O(visible) instead of O(data).
--
-- Contract for opts.initializer -- it runs on a RECYCLED frame:
--   * rows are bare CreateFrame("Frame") instances with NO template mixins, so
--     SetBackdrop/SetBackdropColor are nil on them. Use a plain
--     CreateTexture("BACKGROUND") + SetColorTexture for a row background --
--     cheaper than a backdrop for a flat fill, and it actually exists.
--   * build children exactly once, guarded on a SINGLE row._built key
--   * paint every field on every call, including clearing the ones that don't
--     apply to this row's kind (a recycled row still holds the last kind's text)
--   * one initializer per list. Two initializers sharing this "Frame" pool with
--     different lazy-init keys leak each other's FontStrings -- see
--     Lattice/cookbook/03-scrollboxes.md "Cross-kind frame-pool contamination".
--
-- Fonts are the expensive part of a repaint (SetFont re-measures), and they only
-- change when the theme/font config does, so initializers gate them on
-- VE.Theme.fontGeneration rather than re-applying per data refresh.

-- MinimalScrollBar is a different template from the legacy scroll frame's slider
-- (Track/Thumb frames, no GetThumbTexture), so StyleScrollBar above can't skin
-- it. Same visual result: no arrows, slim accent thumb.
function VE.UI.StyleMinimalScrollBar(scrollBar)
    local scheme = GetScheme()

    -- exception(boundary): Back/Forward/Track are MinimalScrollBar template
    -- sub-widgets; Blizzard has renamed them across template revisions.
    if scrollBar.Back then scrollBar.Back:Hide() end
    if scrollBar.Forward then scrollBar.Forward:Hide() end

    local track = scrollBar.Track
    if not track then return end

    -- Arrows are hidden, so the track inherits their dead space at each end.
    track:ClearAllPoints()
    track:SetPoint("TOPLEFT", scrollBar, "TOPLEFT", 0, 0)
    track:SetPoint("BOTTOMRIGHT", scrollBar, "BOTTOMRIGHT", 0, 0)

    local thumb = track.Thumb
    if not thumb then return end
    if scheme.atlas and scheme.atlas.scrollThumb and thumb.SetAtlas then
        thumb:SetAtlas(scheme.atlas.scrollThumb)
    elseif thumb.SetColorTexture then
        thumb:SetColorTexture(scheme.accent.r, scheme.accent.g, scheme.accent.b, 0.7)
    end
end

-- opts:
--   rowHeight   (number, required) uniform row extent in px
--   spacing     (number) gap between rows, default 0
--   initializer (function(row, elementData)) paints a pooled row
function VE.UI:CreateScrollBoxList(parent, opts)
    local host = CreateFrame("Frame", nil, parent)
    host:SetPoint("TOPLEFT", 0, -2)
    host:SetPoint("BOTTOMRIGHT", -2, 2)

    local scrollBox = CreateFrame("Frame", nil, host, "WowScrollBoxList")
    scrollBox:SetPoint("TOPLEFT", 0, 0)
    scrollBox:SetPoint("BOTTOMRIGHT", -8, 0)   -- gutter for the bar

    local scrollBar = CreateFrame("EventFrame", nil, host, "MinimalScrollBar")
    scrollBar:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 2, 0)
    scrollBar:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 2, 0)
    scrollBar:SetWidth(6)
    VE.UI.StyleMinimalScrollBar(scrollBar)

    local view = CreateScrollBoxListLinearView(0, 0, 0, 0, opts.spacing or 0)
    view:SetElementExtent(opts.rowHeight)
    -- No row:SetWidth here on purpose. For a vertical list Blizzard's layout
    -- anchors every element TOPLEFT *and* TOPRIGHT to the scroll target
    -- (ScrollBoxViewUtil.SetPoint, stretch enabled by default), so rows already
    -- span the full width -- and two horizontal anchors override any SetWidth
    -- anyway. Setting it here reads as load-bearing while doing nothing.
    view:SetElementInitializer("Frame", opts.initializer)

    ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBar, view)

    local provider = CreateDataProvider()
    scrollBox:SetDataProvider(provider)

    host.scrollBox = scrollBox
    host.scrollBar = scrollBar
    host.view = view
    host.provider = provider

    -- Swap the whole dataset. A fresh provider object forces a full release +
    -- re-acquire of the visible range, so every visible row re-runs the
    -- initializer -- no stale rows, and frames recycle instead of accumulating.
    function host:SetItems(items)
        local p = CreateDataProvider()
        for i = 1, #items do
            p:Insert(items[i])
        end
        self.provider = p
        self.scrollBox:SetDataProvider(p)
    end

    -- Repaint visible rows in place (theme change) without rebuilding the data.
    function host:Repaint()
        VE.UI.StyleMinimalScrollBar(self.scrollBar)
        self.scrollBox:ReinitializeFrames()
    end

    return host
end

-- ============================================================================
-- SET AS ACTIVE BUTTON (for non-active house state)
-- ============================================================================

function VE.UI:CreateSetAsActiveButton(parent, anchorTo, options)
    options = options or {}
    local Colors = GetScheme()
    local UI = VE.Constants.UI

    local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    btn:SetSize(UI.setActiveButtonWidth, UI.setActiveButtonHeight)
    btn:SetPoint("TOP", anchorTo, "BOTTOM", 0, UI.setActiveButtonOffset)
    btn:SetText("Set as Active")

    btn:SetScript("OnClick", function()
        if options.onBeforeClick then
            options.onBeforeClick()
        end
        local tracker = VE.EndeavorTracker
        if tracker then
            tracker:SetAsActiveEndeavor()
        end
    end)

    -- Apply font styling
    local fs = btn:GetFontString()
    if fs and VE.Theme and VE.Theme.ApplyFont then
        VE.Theme.ApplyFont(fs, Colors)
    end

    RegisterWidget(btn, "Button")
    return btn
end

-- ============================================================================
-- EMPTY STATE VIEW (for tabs with no data)
-- ============================================================================

function VE.UI:CreateEmptyStateView(parent, options)
    options = options or {}
    local Colors = GetScheme()

    local container = CreateFrame("Frame", nil, parent)
    container:SetAllPoints()

    -- Empty text
    local text = container:CreateFontString(nil, "OVERLAY")
    text:SetPoint("CENTER", 0, 20)
    if VE.Theme and VE.Theme.ApplyFont then
        VE.Theme.ApplyFont(text, Colors)
    end
    text:SetText(options.message or "No data available.")
    container.text = text
    RegisterWidget(text, "Text")

    -- Optional Set as Active button
    if options.showSetActiveButton then
        local btn = self:CreateSetAsActiveButton(container, text, {
            onBeforeClick = options.onSetActiveClick
        })
        container.button = btn
    end

    function container:SetMessage(msg)
        self.text:SetText(msg)
    end

    function container:ShowButton()
        if self.button then self.button:Show() end
    end

    function container:HideButton()
        if self.button then self.button:Hide() end
    end

    return container
end

-- ============================================================================
-- UTILITY: Color code for text
-- ============================================================================

function VE.UI:ColorCode(colorName)
    local Colors = GetScheme()
    local color = Colors[colorName]
    if color then
        if color.hex then
            return "|cFF" .. color.hex
        else
            -- Generate hex from RGB
            local hex = string.format("%02x%02x%02x", math.floor(color.r * 255), math.floor(color.g * 255), math.floor(color.b * 255))
            return "|cFF" .. hex
        end
    end
    return "|cFFffffff"
end

-- ============================================================================
-- CSV EXPORT WINDOW
-- ============================================================================

function VE.UI:ShowCSVExportWindow(csvText, rowCount, titleOverride)
    local Colors = GetScheme()

    -- Reuse existing window or create new
    if not VE.csvExportWindow then
        local window = CreateFrame("Frame", "VE_CSVExportWindow", UIParent, "BackdropTemplate")
        window:SetSize(500, 400)
        window:SetPoint("CENTER")
        window:SetFrameStrata("DIALOG")
        window:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        window:SetMovable(true)
        window:EnableMouse(true)
        window:RegisterForDrag("LeftButton")
        window:SetScript("OnDragStart", window.StartMoving)
        window:SetScript("OnDragStop", window.StopMovingOrSizing)
        window:SetClampedToScreen(true)

        -- Title bar
        local titleBar = CreateFrame("Frame", nil, window)
        titleBar:SetHeight(24)
        titleBar:SetPoint("TOPLEFT", 0, 0)
        titleBar:SetPoint("TOPRIGHT", 0, 0)
        titleBar:EnableMouse(true)
        titleBar:RegisterForDrag("LeftButton")
        titleBar:SetScript("OnDragStart", function() window:StartMoving() end)
        titleBar:SetScript("OnDragStop", function() window:StopMovingOrSizing() end)

        local titleText = titleBar:CreateFontString(nil, "OVERLAY")
        titleText:SetPoint("LEFT", 10, 0)
        titleText:SetFont(STANDARD_TEXT_FONT, 12, "")
        window.titleText = titleText

        -- Close button
        local closeBtn = CreateFrame("Button", nil, titleBar)
        closeBtn:SetSize(16, 16)
        closeBtn:SetPoint("RIGHT", -4, 0)
        closeBtn:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
        closeBtn:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
        closeBtn:SetScript("OnClick", function() window:Hide() end)

        -- Instructions
        local instructions = window:CreateFontString(nil, "OVERLAY")
        instructions:SetPoint("TOPLEFT", 10, -30)
        instructions:SetFont(STANDARD_TEXT_FONT, 10, "")
        instructions:SetText("Select all (Ctrl+A) and copy (Ctrl+C) to paste into Excel or a text file:")
        window.instructions = instructions

        -- Scroll frame for edit box
        local scrollFrame = CreateFrame("ScrollFrame", nil, window, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", 10, -50)
        scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

        -- Edit box (copyable text)
        local editBox = CreateFrame("EditBox", nil, scrollFrame)
        editBox:SetMultiLine(true)
        editBox:SetAutoFocus(false)
        editBox:SetFontObject(ChatFontNormal)
        editBox:SetWidth(440)
        editBox:EnableMouse(true)
        editBox:SetScript("OnEscapePressed", function() window:Hide() end)
        scrollFrame:SetScrollChild(editBox)
        window.editBox = editBox

        VE.csvExportWindow = window
    end

    local window = VE.csvExportWindow

    -- Apply current theme colors
    window:SetBackdropColor(Colors.bg.r, Colors.bg.g, Colors.bg.b, 0.98)
    window:SetBackdropBorderColor(Colors.border.r, Colors.border.g, Colors.border.b, 1)
    window.titleText:SetText(titleOverride or ("Activity Export (" .. rowCount .. " entries)"))
    window.titleText:SetTextColor(Colors.text.r, Colors.text.g, Colors.text.b)
    window.instructions:SetTextColor(Colors.text_dim.r, Colors.text_dim.g, Colors.text_dim.b)

    -- Set the CSV content
    window.editBox:SetText(csvText)
    window.editBox:HighlightText()
    window.editBox:SetFocus()

    window:Show()
end
