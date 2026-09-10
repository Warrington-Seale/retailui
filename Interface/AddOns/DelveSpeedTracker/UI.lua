local ADDON_NAME, namespace = ...
local DST = namespace.DST
local AF = namespace.AF
local InCombat = namespace.InCombat
local Locale = namespace.Locale
local GetLocaleFont = namespace.GetLocaleFont
local ApplyTextStyle = namespace.ApplyTextStyle
local GetContentInsets = namespace.GetContentInsets
local GetContentWidthFromLongestEntry = namespace.GetContentWidthFromLongestEntry
local CopyTableSafe = namespace.CopyTableSafe
local ClearTomTomWaypointsFromAddon = namespace.ClearTomTomWaypointsFromAddon
local BuildActiveDelvesList = namespace.BuildActiveDelvesList
local ShowAddonTooltip = namespace.ShowAddonTooltip
local HideAddonTooltip = namespace.HideAddonTooltip

local LAYOUT = DST.LAYOUT

-- Bottom line of delve row tooltip (grey; 0–1 RGB). Prefer Blizzard gray if present.
local function GetTooltipClickGreyRGB()
    local g = _G.GRAY_FONT_COLOR
    if g and g.GetRGB then
        return g:GetRGB()
    end
    return 170 / 255, 170 / 255, 170 / 255
end

local function RepositionTooltipIfOffScreen(tooltip, headerFrame, screenEdgeInset)
    screenEdgeInset = screenEdgeInset or 8
    if tooltip:GetLeft() and tooltip:GetLeft() < screenEdgeInset then
        AF.ClearPoints(tooltip)
        AF.SetPoint(tooltip, "TOPLEFT", headerFrame, "TOPRIGHT", 0, 0)
        if tooltip.ClampToScreen then
            tooltip:ClampToScreen()
        end
    end
end

--- Delve entry hover: addon-owned tooltip (not GameTooltip) to avoid tainting POI/widget tooltips in delves.
local function ShowRowTooltip(row)
    if InCombat() then return end
    if not ShowAddonTooltip then return end
    local tooltipLines = row._tooltipLines
    if not tooltipLines or #tooltipLines == 0 then return end
    if not DST.Frame or not DST.Frame.header then return end

    local accentR, accentG, accentB = AF.GetColorRGB(row.accentColor or "accent")
    local rowFontSize = LAYOUT.EMBLEM_ROW_SIZE or 13
    local clickFontSize = LAYOUT.TOOLTIP_CLICK_FONT_SIZE or 12
    local tr, tg, tb = GetTooltipClickGreyRGB()

    local specs = {}
    specs[#specs + 1] = {
        text = tooltipLines[1],
        r = accentR,
        g = accentG,
        b = accentB,
        size = rowFontSize,
    }
    for i = 2, #tooltipLines do
        if type(tooltipLines[i]) == "string" then
            specs[#specs + 1] = { text = tooltipLines[i], r = 1, g = 1, b = 1, size = rowFontSize }
        end
    end
    if row._tooltipClickLine then
        specs[#specs + 1] = { text = row._tooltipClickLine, r = tr, g = tg, b = tb, size = clickFontSize }
    end

    local tip = ShowAddonTooltip(DST.Frame.header, "TOPRIGHT", "TOPLEFT", 0, 0, specs, accentR, accentG, accentB)
    if tip then
        RepositionTooltipIfOffScreen(tip, DST.Frame.header, 8)
    end
end

-- Single shared OnClick for delve rows (frame is first arg from SetScript; uses . not :).
function DST.RowOpenMapOnClick(row, _buttonName)
    if InCombat() then return end
    local mapId = row and row._openMapMapId
    local poiID = row and row._openMapPoiID
    local title = row and row._openMapTitle
    local poiX = row and row._openMapX
    local poiY = row and row._openMapY
    if mapId then DST:OpenMapToDelveAndShowRipple(mapId, poiID, title, poiX, poiY) end
end

function DST:GetCategoryDisplayName(difficulty)
    local config = DST.difficultyConfig[difficulty]
    if config then
        return config.color .. (Locale(config.nameKey):upper()) .. "|r"
    end
    return (Locale("UNKNOWN"):upper())
end

local function DifficultyColorToRGB(colorStr)
    if not colorStr or type(colorStr) ~= "string" then return 0.2, 0.2, 0.2 end
    local rr, gg, bb = colorStr:match("|cff(%x%x)(%x%x)(%x%x)")
    if not rr then return 0.2, 0.2, 0.2 end
    return tonumber(rr, 16) / 255, tonumber(gg, 16) / 255, tonumber(bb, 16) / 255
end

local function ApplyRowIconWithData(row, mapId, zoneIconData)
    if not row or not row.icon then return end
    local coords = zoneIconData.texCoords and mapId and zoneIconData.texCoords[mapId]
    if coords and zoneIconData.file then
        row.icon:SetIcon(zoneIconData.file, false)
        row.icon:SetIconTexCoord(coords[1], coords[2], coords[3], coords[4])
        row.icon:Show()
    elseif zoneIconData.icons and zoneIconData.icons[mapId] and AF.IsAtlas(zoneIconData.icons[mapId]) then
        row.icon:SetIcon(zoneIconData.icons[mapId], true)
        row.icon:SetIconTexCoord(0, 1, 0, 1)
        row.icon:Show()
    else
        row.icon:Hide()
    end
end

local function ApplySectionHeaderRow(headerRow, difficulty, contentWidth, yOffset)
    headerRow:Show()
    headerRow.icon:Hide()
    headerRow:SetBackdrop(nil)
    headerRow._color = nil
    headerRow._hoverColor = nil
    AF.ClearPoints(headerRow.text)
    local headerTextX = (LAYOUT.ICON_COLUMN_LEFT or 0) + (LAYOUT.SECTION_HEADER_TEXT_OFFSET_X or 0)
    AF.SetPoint(headerRow.text, "LEFT", headerRow, "LEFT", headerTextX, 0)
    headerRow:SetText(DST:GetCategoryDisplayName(difficulty))
    local headerConfig = DST.difficultyConfig[difficulty]
    if headerConfig and headerRow.timeText then
        headerRow.timeText:SetText(headerConfig.color .. Locale(headerConfig.timeKey) .. "|r")
        headerRow.timeText:Show()
    elseif headerRow.timeText then
        headerRow.timeText:Hide()
    end
    headerRow:SetEnabled(false)
    headerRow:SetScript("OnClick", nil)
    headerRow._tooltipLines = nil
    headerRow._tooltipClickLine = nil
    AF.SetSize(headerRow, contentWidth, LAYOUT.ROW_HEIGHT)
    local headerRowX = LAYOUT.SECTION_HEADER_OFFSET_X or 0
    local headerRowYExtra = LAYOUT.SECTION_HEADER_OFFSET_Y or 0
    AF.SetPoint(headerRow, "TOPLEFT", DST.Content, "TOPLEFT", headerRowX, -(yOffset + headerRowYExtra))
    return yOffset + LAYOUT.ROW_HEIGHT
end

local function ApplyDelveRow(row, delve, contentWidth, yOffset, zoneIconData)
    if row.timeText then row.timeText:Hide() end
    ApplyRowIconWithData(row, delve.mapId, zoneIconData)
    AF.ClearPoints(row.text)
    AF.SetPoint(row.text, "LEFT", row.icon, "RIGHT", LAYOUT.ROW_ICON_TEXT_GAP, 0)
    row:SetText(delve.displayName)
    row:SetEnabled(true)
    AF.SetSize(row, contentWidth - LAYOUT.ROW_INDENT, LAYOUT.ROW_HEIGHT)
    AF.SetPoint(row, "TOPLEFT", DST.Content, "TOPLEFT", LAYOUT.ROW_INDENT, -yOffset)

    local config = DST.difficultyConfig[delve.difficulty]
    local r, g, b = DifficultyColorToRGB(config and config.color)
    row._hoverColor = namespace.HOVER_HIGHLIGHT
    row._color = { r, g, b, LAYOUT.BACKDROP_ALPHA }
    AF.ApplyDefaultBackdrop(row, 0.5)
    row:SetBackdropColor(r, g, b, LAYOUT.BACKDROP_ALPHA)
    if row.SetBackdropBorderColor then row:SetBackdropBorderColor(0, 0, 0, 1) end

    row._tooltipLines = delve.tooltipLines
    row._tooltipClickLine = Locale("TOOLTIP_CLICK_OPEN_MAP")
    row._openMapMapId = delve.mapId
    row._openMapPoiID = delve.areaPoiID
    row._openMapTitle = delve.displayName
    row._openMapX = delve.poiX
    row._openMapY = delve.poiY
    row:SetScript("OnClick", DST.RowOpenMapOnClick)
end

function DST:CreateUI()
    local mainFrame = AF.CreateHeaderedFrame(AF.UIParent, "DST_MainFrame",
        "|cff7DD3FC" .. Locale("WINDOW_TITLE") .. "|r", LAYOUT.MIN_WIDTH + LAYOUT.TITLE_CLOSE_PAD, 100)
    AF.ClearPoints(mainFrame)
    local pos = DelveSpeedTrackerDB.framePosition
    if pos
        and type(pos) == "table"
        and type(pos[1]) == "string"
        and (
            (type(pos[2]) == "number" and type(pos[3]) == "number")
            or (type(pos[2]) == "string" and type(pos[3]) == "number" and type(pos[4]) == "number")
        )
    then
        AF.LoadPosition(mainFrame, pos, AF.UIParent)
    else
        AF.SetPoint(mainFrame, "TOPRIGHT", AF.UIParent, "TOPRIGHT", -(LAYOUT.DEFAULT_FRAME_X or 80), LAYOUT.DEFAULT_FRAME_Y or -100)
    end
    mainFrame:SetFrameStrata("LOW")
    mainFrame:SetFrameLevel(500)
    mainFrame:SetTitleJustify("LEFT")

    mainFrame.header.settingsBtn = AF.CreateIconButton(
        mainFrame.header, AF.GetIcon("Settings"), 20, 20, 0, "gray", "white", "NEAREST", true
    )
    AF.SetPoint(mainFrame.header.settingsBtn, "TOPRIGHT", mainFrame.header.closeBtn, "TOPLEFT", 0, 0)

    local settingsFrame = AF.CreateBorderedFrame(AF.UIParent, "DST_SettingsFrame", 120, 55, "background", "black")
    settingsFrame:SetFrameStrata("LOW")
    settingsFrame:SetFrameLevel(450)
    settingsFrame:SetIgnoreParentAlpha(true)
    settingsFrame:SetBackdropColor(AF.GetColorRGB("background", 0.92))
    settingsFrame:Hide()
    AF.SetPoint(settingsFrame, "TOPLEFT", mainFrame.header, "TOPRIGHT", 0, 0)
    DST.SettingsFrame = settingsFrame

    local settingsTomTomCheck = AF.CreateCheckButton(settingsFrame, "TomTom", function(checked)
        if not DelveSpeedTrackerDB then return end
        DelveSpeedTrackerDB.tomtomArrowsEnabled = checked and true or false
        if not checked then
            ClearTomTomWaypointsFromAddon()
        end
    end)
    DST.SettingsTomTomCheck = settingsTomTomCheck
    AF.SetPoint(settingsTomTomCheck, "TOPLEFT", settingsFrame, "TOPLEFT", 10, -6)
    settingsTomTomCheck:SetChecked(DelveSpeedTrackerDB and DelveSpeedTrackerDB.tomtomArrowsEnabled ~= false)

    local settingsDebugBtn = AF.CreateButton(settingsFrame, "Debug", "accent", 64, 18, nil, "black", "")
    DST.SettingsDebugBtn = settingsDebugBtn
    AF.SetPoint(settingsDebugBtn, "TOPLEFT", settingsFrame, "TOPLEFT", 10, -26)
    settingsDebugBtn:SetScript("OnClick", function()
        if DST.DebugCheckPOIAndAchievements then
            DST:DebugCheckPOIAndAchievements(false)
        end
    end)

    mainFrame.header.settingsBtn:SetScript("OnClick", function()
        if InCombat() then return end
        if not DST.SettingsFrame then return end
        if DST.SettingsFrame:IsShown() then
            DST.SettingsFrame:Hide()
        else
            DST.SettingsFrame:Show()
            if DST.SettingsTomTomCheck then
                DST.SettingsTomTomCheck:SetChecked(DelveSpeedTrackerDB and DelveSpeedTrackerDB.tomtomArrowsEnabled ~= false)
            end
        end
    end)

    DST:ApplyTitlePosition()
    mainFrame:SetMovable(true)
    mainFrame.header:HookScript("OnDragStop", function()
        local point, relativeTo, relativePoint, x, y = mainFrame:GetPoint(1)
        if not point then return end
        if relativeTo ~= AF.UIParent then
            relativeTo = AF.UIParent
            relativePoint = relativePoint or point
            AF.ClearPoints(mainFrame)
            AF.SetPoint(mainFrame, point, relativeTo, relativePoint, x or 0, y or 0)
            point, relativeTo, relativePoint, x, y = mainFrame:GetPoint(1)
        end
        DelveSpeedTrackerDB.framePosition = { point, relativePoint or point, x or 0, y or 0 }
    end)

    mainFrame.body = AF.CreateFrame(mainFrame, nil, nil, nil)
    AF.SetPoint(mainFrame.body, "TOPLEFT", mainFrame.header, "BOTTOMLEFT", 0, 0)
    AF.SetPoint(mainFrame.body, "BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", 0, 0)

    DST.Frame = mainFrame
    mainFrame:SetBackdropColor(AF.GetColorRGB("background", 0.92))
    mainFrame.header.text:SetFont(GetLocaleFont(), LAYOUT.EMBLEM_TITLE_SIZE or 12, DST:GetTextFontFlagString())
    ApplyTextStyle(mainFrame.header.text)

    mainFrame:HookScript("OnShow", function()
        if DelveSpeedTrackerDB then DelveSpeedTrackerDB.windowShown = true end
        -- CreateUI's UpdateUI runs while the frame is still hidden; body/content layout and
        -- width-from-POI math are unreliable until shown. PEW also defers UpdateUI by 1s, so if the
        -- window stayed closed on login, the first open could show wrong margins until /reload.
        -- Refresh after the first layout pass when visible (next frame).
        if C_Timer and C_Timer.After then
            C_Timer.After(0, function()
                if DST and DST.Frame and DST.Frame:IsShown() and DST.UpdateUI then
                    DST:UpdateUI()
                end
            end)
        end
        -- Do not use AF.ShowHelpTip (GameTooltip); it taints shared tooltip state and breaks map/quest UI.
        if DelveSpeedTrackerDB and not DelveSpeedTrackerDB.helpTipShown and DST.Frame then
            C_Timer.After(0.15, function()
                if DST.Frame and DST.Frame:IsShown() then
                    DelveSpeedTrackerDB.helpTipShown = true
                    if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
                        DEFAULT_CHAT_FRAME:AddMessage("|cff7DD3FC[DST]|r " .. Locale("HELPTIP_CLICK_MAP"))
                    end
                end
            end)
        end
    end)
    mainFrame:HookScript("OnHide", function()
        if DelveSpeedTrackerDB then DelveSpeedTrackerDB.windowShown = false end
        if DST.SettingsFrame then DST.SettingsFrame:Hide() end
        HideAddonTooltip()
    end)

    namespace.SetHoverHighlight(AF.GetColorTable("cyan", 0.38))
    DST.Content = AF.CreateFrame(mainFrame.body, nil, nil, nil)
    local insetL, insetT, insetR, insetB = GetContentInsets()
    AF.SetPoint(DST.Content, "TOPLEFT", mainFrame.body, "TOPLEFT", insetL, -insetT)
    AF.SetPoint(DST.Content, "BOTTOMRIGHT", mainFrame.body, "BOTTOMRIGHT", -insetR, insetB)

    DST:UpdateUI()
end

function DST:GetRow(index)
    if not DST.rows[index] then
        local rowButton = AF.CreateButton(DST.Content, "", "none", nil, LAYOUT.ROW_HEIGHT, nil, "none", "")
        rowButton:SetTextJustifyH("LEFT")
        rowButton:EnablePushEffect(false)
        rowButton._hoverColor = namespace.HOVER_HIGHLIGHT
        local rowFont = LAYOUT.EMBLEM_ROW_SIZE or 13
        local fontFlag = DST:GetTextFontFlagString()
        rowButton.text:SetFont(GetLocaleFont(), rowFont, fontFlag)
        ApplyTextStyle(rowButton.text)
        local iconFrame = AF.CreateIcon(rowButton, nil, LAYOUT.ROW_ICON_SIZE, "none")
        AF.SetPoint(iconFrame, "LEFT", rowButton, "LEFT", LAYOUT.ROW_BOX_LEFT_PAD, 0)
        rowButton.icon = iconFrame
        local timeText = rowButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        timeText:SetFont(GetLocaleFont(), rowFont, fontFlag)
        ApplyTextStyle(timeText)
        timeText:SetJustifyH("RIGHT")
        AF.SetPoint(timeText, "RIGHT", rowButton, "RIGHT", -(LAYOUT.ROW_TIME_RIGHT_INSET or 4), 0)
        timeText:Hide()
        rowButton.timeText = timeText
        rowButton:SetScript("OnEnter", function(self)
            if self._hoverColor then self:SetBackdropColor(AF.UnpackColor(self._hoverColor)) end
            if self.SetBackdropBorderColor then self:SetBackdropBorderColor(0, 0, 0, 1) end
            if self._tooltipLines and #self._tooltipLines > 0 then
                ShowRowTooltip(self)
            end
        end)
        rowButton:SetScript("OnLeave", function(self)
            if self._color then self:SetBackdropColor(AF.UnpackColor(self._color)) end
            if self.SetBackdropBorderColor then self:SetBackdropBorderColor(0, 0, 0, 1) end
            HideAddonTooltip()
        end)
        DST.rows[index] = rowButton
    end
    local row = DST.rows[index]
    local rowFontSize = LAYOUT.EMBLEM_ROW_SIZE or 13
    local fontFlag = DST:GetTextFontFlagString()
    row.text:SetFont(GetLocaleFont(), rowFontSize, fontFlag)
    ApplyTextStyle(row.text)
    if row.timeText then
        row.timeText:SetFont(GetLocaleFont(), rowFontSize, fontFlag)
        ApplyTextStyle(row.timeText)
    end
    return row
end

function DST:UpdateUI()
    if not DST.Frame then return end
    if InCombat() then return end

    local insetL, insetT, insetR, insetB = GetContentInsets()
    AF.ClearPoints(DST.Content)
    AF.SetPoint(DST.Content, "TOPLEFT", DST.Frame.body, "TOPLEFT", insetL, -insetT)
    AF.SetPoint(DST.Content, "BOTTOMRIGHT", DST.Frame.body, "BOTTOMRIGHT", -insetR, insetB)

    DST.Frame:SetTitle("|cff7DD3FC" .. Locale("WINDOW_TITLE") .. "|r")
    DST.Frame.header.text:SetFont(GetLocaleFont(), LAYOUT.EMBLEM_TITLE_SIZE or 12, DST:GetTextFontFlagString())
    ApplyTextStyle(DST.Frame.header.text)
    DST:ApplyTitlePosition()

    for _, row in pairs(DST.rows) do row:Hide() end

    local activeVariants = DST:GetCurrentDelveVariants()
    local activeDelves = BuildActiveDelvesList(activeVariants, DST.delves)

    local widthCache = {}
    local contentWidth = GetContentWidthFromLongestEntry(activeDelves, widthCache)
    local frameWidth = contentWidth + LAYOUT.TITLE_CLOSE_PAD

    local zoneIconData = {
        file = DST.ZONE_ICON_FILE,
        texCoords = DST.zoneIconTexCoords,
        icons = DST.zoneIcons,
    }

    local rowIndex = 1
    local currentDifficulty = nil
    local yOffset = 0

    for _, delve in ipairs(activeDelves) do
        if currentDifficulty ~= delve.difficulty then
            currentDifficulty = delve.difficulty
            if yOffset > 0 then
                yOffset = yOffset + LAYOUT.SECTION_GAP
            end
            yOffset = yOffset + (LAYOUT.HEADER_TOP_PAD or 0)
            local headerRow = DST:GetRow(rowIndex)
            yOffset = ApplySectionHeaderRow(headerRow, delve.difficulty, contentWidth, yOffset)
            rowIndex = rowIndex + 1
        end

        local row = DST:GetRow(rowIndex)
        row:Show()
        ApplyDelveRow(row, delve, contentWidth, yOffset, zoneIconData)
        yOffset = yOffset + LAYOUT.ROW_HEIGHT
        rowIndex = rowIndex + 1
    end

    local contentHeight = yOffset
    local frameHeight = LAYOUT.HEADER_HEIGHT + contentHeight
    local mainFrame = DST.Frame
    local uiParent = AF.UIParent
    AF.SetSize(mainFrame, frameWidth, math.max(60, frameHeight))
    -- Only re-anchor after resize while the frame is visible and UIParent has valid layout.
    -- During CreateUI, UpdateUI runs before core.lua calls Show(); GetRight/GetTop on a hidden
    -- frame (and/or early UIParent) produce bogus offsets and corrupt the saved position.
    local parentRight = uiParent and uiParent:GetRight()
    local parentTop = uiParent and uiParent:GetTop()
    if mainFrame:IsShown() and parentRight and parentTop and parentRight > 0 then
        local saveRight = mainFrame:GetRight()
        local saveTop = mainFrame:GetTop()
        if saveRight and saveTop then
            local offsetX = saveRight - parentRight
            local offsetY = saveTop - parentTop
            AF.LoadPosition(mainFrame, { "TOPRIGHT", "TOPRIGHT", offsetX, offsetY }, uiParent)
        end
    end

    DST:UpdateLayoutDebugOverlay()
end

--- Visualize body insets vs content: margin tints + content fill. Toggle with /dstdebuglayout or DB.layoutDebugOverlay.
function DST:UpdateLayoutDebugOverlay()
    local root = DST._layoutDebugRoot
    if not DelveSpeedTrackerDB or not DelveSpeedTrackerDB.layoutDebugOverlay then
        if root then root:Hide() end
        return
    end
    if not DST.Frame or not DST.Frame.body or not DST.Content then
        if root then root:Hide() end
        return
    end
    local body = DST.Frame.body
    local insetL, insetT, insetR, insetB = GetContentInsets()

    if not root then
        root = CreateFrame("Frame", "DST_LayoutDebugOverlay", body)
        root:SetFrameStrata(DST.Frame:GetFrameStrata() or "LOW")
        root:SetFrameLevel((DST.Frame:GetFrameLevel() or 0) + 80)
        root:EnableMouse(false)
        DST._layoutDebugRoot = root
    end
    root:SetAllPoints(body)
    root:Show()

    local function ensureChild(name)
        local f = root[name]
        if not f then
            f = CreateFrame("Frame", nil, root)
            f:EnableMouse(false)
            local t = f:CreateTexture(nil, "ARTWORK", nil, 1)
            t:SetAllPoints(f)
            f._tex = t
            root[name] = f
        end
        return f
    end

    local left = ensureChild("_dbgMarginLeft")
    left._tex:SetColorTexture(1, 0.25, 0.25, 0.35)
    left:SetPoint("TOPLEFT", body, "TOPLEFT", 0, 0)
    left:SetPoint("BOTTOMLEFT", body, "BOTTOMLEFT", 0, 0)
    left:SetWidth(math.max(1, insetL))

    local right = ensureChild("_dbgMarginRight")
    right._tex:SetColorTexture(0.25, 0.35, 1, 0.35)
    right:SetPoint("TOPRIGHT", body, "TOPRIGHT", 0, 0)
    right:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT", 0, 0)
    right:SetWidth(math.max(1, insetR))

    local top = ensureChild("_dbgMarginTop")
    top._tex:SetColorTexture(0.25, 1, 0.35, 0.35)
    top:SetPoint("TOPLEFT", body, "TOPLEFT", 0, 0)
    top:SetPoint("TOPRIGHT", body, "TOPRIGHT", 0, 0)
    top:SetHeight(math.max(1, insetT))

    local bottom = ensureChild("_dbgMarginBottom")
    bottom._tex:SetColorTexture(1, 1, 0.25, 0.35)
    bottom:SetPoint("BOTTOMLEFT", body, "BOTTOMLEFT", 0, 0)
    bottom:SetPoint("BOTTOMRIGHT", body, "BOTTOMRIGHT", 0, 0)
    bottom:SetHeight(math.max(1, insetB))

    local contentFill = ensureChild("_dbgContentFill")
    contentFill._tex:SetColorTexture(0.2, 0.85, 0.95, 0.18)
    contentFill:SetFrameLevel(root:GetFrameLevel() + 2)
    contentFill:SetAllPoints(DST.Content)
end

function DST:ToggleLayoutDebugOverlay()
    if not DelveSpeedTrackerDB then return end
    DelveSpeedTrackerDB.layoutDebugOverlay = not DelveSpeedTrackerDB.layoutDebugOverlay
    local on = DelveSpeedTrackerDB.layoutDebugOverlay
    if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
        DEFAULT_CHAT_FRAME:AddMessage("|cff7DD3FC[DST]|r Layout debug: " .. (on and "ON" or "OFF")
            .. " — red=left, blue=right, green=top, yellow=bottom, teal=content region")
    end
    self:UpdateLayoutDebugOverlay()
end

function DST:CreateMinimapButton()
    local db = DelveSpeedTrackerDB
    if not db.minimap then
        db.minimap = CopyTableSafe(DST.DB_DEFAULTS and DST.DB_DEFAULTS.minimap or {})
    end
    db.minimap.hide = false
    local proxyDb = setmetatable({}, {
        __index = function(_, k)
            local m = db.minimap
            if not m then return nil end
            if k == "minimapPos" then return m.minimapPos end
            if k == "hide" then return m.hide end
            return m[k]
        end,
        __newindex = function(_, k, v)
            if not db.minimap then db.minimap = {} end
            local m = db.minimap
            if k == "minimapPos" then m.minimapPos = v; return end
            if k == "hide" then m.hide = v; return end
            m[k] = v
        end,
    })

    local icon = "Interface\\AddOns\\DelveSpeedTracker\\DSTlogo"
    local onClick = function(_, buttonName)
        if buttonName == "LeftButton" then
            if DST.Frame:IsShown() then DST.Frame:Hide() else DST.Frame:Show() end
        end
    end
    local rowFontSize = LAYOUT.EMBLEM_ROW_SIZE or 13
    local onEnter = function(button)
        local r, g, b = AF.GetColorRGB(button.accentColor or "accent")
        ShowAddonTooltip(button, "BOTTOM", "TOP", 0, 4, {
            { text = Locale("MINIMAP_TOOLTIP_TITLE"), r = r, g = g, b = b, size = rowFontSize },
            { text = Locale("MINIMAP_TOOLTIP_TOGGLE"), r = 1, g = 1, b = 1, size = rowFontSize },
        }, r, g, b)
    end
    local onLeave = function()
        HideAddonTooltip()
    end

    AF.NewMinimapButton("DelveSpeedTracker", icon, proxyDb, onClick, nil, onEnter, onLeave)
    local btn = AF.Libs.LibDBIcon:GetMinimapButton("DelveSpeedTracker")
    DST.MinimapButton = btn
    if btn and btn.icon then
        AF.ClearPoints(btn.icon)
        AF.SetPoint(btn.icon, "CENTER", btn, "CENTER", 0.5, 0)
    end
    if AF.Libs.LibDBIcon.Show then
        AF.Libs.LibDBIcon:Show("DelveSpeedTracker")
    end
end
