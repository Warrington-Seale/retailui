-- =============================================================
-- [[ 玩家护盾量显示 ]]
-- { Key = "ExTools.PlayerShield", Name = "玩家护盾量", Desc = "在屏幕上显示玩家当前总护盾量。", Category = 4 },
-- =============================================================

local ondev = false
if ondev then
    return
end

local ExwindTools = _G.ExwindTools
if not ExwindTools then return end

local L = (ExwindTools and ExwindTools.L) or setmetatable({}, { __index = function(_, key) return key end })
local EXStaticDB = ExwindTools.DB_Static or _G.EXDB
local UIParent = _G.UIParent
local CreateFrame = _G.CreateFrame
local GetSpellTexture = _G.GetSpellTexture
local GetTime = _G.GetTime
local UnitGetTotalAbsorbs = _G.UnitGetTotalAbsorbs
local BreakUpLargeNumbers = _G.BreakUpLargeNumbers
local AbbreviateLargeNumbers = _G.AbbreviateLargeNumbers
local AbbreviateNumbers = _G.AbbreviateNumbers
local C_StringUtil = _G.C_StringUtil
local C_Timer = _G.C_Timer
local math_abs = math.abs
local math_floor = math.floor
local math_max = math.max

local EXWIND_MODULE_KEY = "ExTools.PlayerShield"
local DEFAULT_ICON_SPELL_ID = 17

local function EX_RegisterLayout()
    local layout = {
        { key = "header", type = "header", x = 1, y = 1, w = 53, h = 2, label = L["玩家护盾量"], labelSize = 25 },
        { key = "enabled", type = "checkbox", x = 1, y = 4, w = 10, h = 2, label = L["启用"] },
        { key = "icon_display", type = "icongroup", x = 1, y = 7, w = 53, h = 27, label = L["护盾图标样式"], labelSize = 20 },
        { key = "font_text", type = "fontgroup", x = 1, y = 37, w = 53, h = 17, label = L["护盾文字样式"], labelSize = 20 },
    }


    ExwindTools:RegisterModuleLayout(EXWIND_MODULE_KEY, layout)
end
EX_RegisterLayout()

if not ExwindTools:IsModuleEnabled(EXWIND_MODULE_KEY) then return end

local EX_DEFAULTS = {
    abbreviateNumber = true,
    enabled = false,
    frameScale = 1.0,
    hideWhenZero = true,
    icon_display = {
        height = 36,
        iconID = (_G.C_Spell and _G.C_Spell.GetSpellTexture and _G.C_Spell.GetSpellTexture(DEFAULT_ICON_SPELL_ID)) or
            (GetSpellTexture and GetSpellTexture(DEFAULT_ICON_SPELL_ID)),
        reverse = false,
        showIcon = true,
        width = 36,
        x = 0,
        y = 0,
    },
    point = "CENTER",
    relativePoint = "CENTER",
    xOffset = 0,
    yOffset = -120,
    font_text = {
        a = 1,
        b = 1,
        font = "默认",
        g = 0.91372555494308,
        outline = "THICKOUTLINE",
        r = 0.24705883860588,
        shadow = true,
        shadowX = 1,
        shadowY = -1,
        size = 24,
        x = 0,
        y = 0,
    },
}

local EX_DB = ExwindTools:GetModuleDB(EXWIND_MODULE_KEY, EX_DEFAULTS)
local displayFrame = nil
local displayText = nil
local isEditModeActive = false
local isEditModeVisible = true
local refreshTimer = nil
local iconHideTimer = nil
local REFRESH_THROTTLE = 0.2
local ICON_HIDE_DELAY = 10
local PREVIEW_VALUE = 1250000
local FRAME_MIN_WIDTH = 96
local FRAME_HORIZONTAL_PADDING = 10
local FRAME_VERTICAL_PADDING = 18
local TEXT_BLOCK_MIN_HEIGHT = 28
local TEXT_ICON_GAP = 6
local FRAME_SIDE_OFFSET_PADDING = 8
local lastAbsorbEventTime = nil
local RefreshDisplay

local function IsSecretValue(value)
    return type(_G.issecretvalue) == "function" and _G.issecretvalue(value)
end

local function RefreshEditOverlay()
    if not displayFrame then return end

    if isEditModeActive and isEditModeVisible then
        ExwindTools:ShowExwindToolsEditOverlay(EXWIND_MODULE_KEY, displayFrame)
    else
        ExwindTools:HideExwindToolsEditOverlay(displayFrame)
    end
end

local function SavePosition()
    if not displayFrame then return end

    local point, _, relativePoint, xOffset, yOffset = displayFrame:GetPoint()
    if point and relativePoint then
        EX_DB.point = point
        EX_DB.relativePoint = relativePoint
        EX_DB.xOffset = xOffset or 0
        EX_DB.yOffset = yOffset or 0
    end

    if ExwindTools.UI and ExwindTools.UI.MainFrame and ExwindTools.UI.MainFrame:IsShown() then
        ExwindTools.UI:RefreshContent()
    end
end

local function StartFrameMove(frame)
    if not frame or not isEditModeActive or not isEditModeVisible then
        return
    end

    frame.isMoving = true
    frame:StartMoving()
end

local function StopFrameMove(frame)
    if not frame or not frame.isMoving then
        return
    end

    frame.isMoving = false
    frame:StopMovingOrSizing()
    SavePosition()
end

local function RestorePosition()
    if not displayFrame then return end

    displayFrame:SetScale(EX_DB.frameScale or 1)
    displayFrame:ClearAllPoints()
    displayFrame:SetPoint(
        EX_DB.point or "CENTER",
        UIParent,
        EX_DB.relativePoint or "CENTER",
        EX_DB.xOffset or 0,
        EX_DB.yOffset or -120
    )
end

local function GetIconTexture()
    local iconCfg = EX_DB.icon_display or {}
    if iconCfg.iconID then
        return iconCfg.iconID
    end

    if _G.C_Spell and type(_G.C_Spell.GetSpellTexture) == "function" then
        return _G.C_Spell.GetSpellTexture(DEFAULT_ICON_SPELL_ID)
    end

    if GetSpellTexture then
        return GetSpellTexture(DEFAULT_ICON_SPELL_ID)
    end

    return nil
end

local function IsIconEventActive()
    if isEditModeActive then
        return isEditModeVisible
    end

    if lastAbsorbEventTime == nil then
        return false
    end

    return (GetTime() - lastAbsorbEventTime) < ICON_HIDE_DELAY
end

local function ScheduleIconHideRefresh()
    if iconHideTimer and type(iconHideTimer.Cancel) == "function" then
        iconHideTimer:Cancel()
        iconHideTimer = nil
    end

    if not C_Timer or type(C_Timer.NewTimer) ~= "function" then
        return
    end

    iconHideTimer = C_Timer.NewTimer(ICON_HIDE_DELAY, function()
        iconHideTimer = nil
        RefreshDisplay()
    end)
end

local function MarkAbsorbEventActive()
    if not GetTime then
        return
    end

    lastAbsorbEventTime = GetTime()
    ScheduleIconHideRefresh()
end

local function ApplyDisplayStyle()
    if not displayFrame or not displayText or not displayFrame.Icon then
        return
    end

    local iconCfg = EX_DB.icon_display or {}
    local showIcon = iconCfg.showIcon ~= false
    local iconWidth = iconCfg.width or 36
    local iconHeight = iconCfg.height or 36
    local iconTexture = GetIconTexture()
    local fontCfg = EX_DB.font_text or {}
    local fontSize = tonumber(fontCfg.size) or 24
    local textHeight = math_max(TEXT_BLOCK_MIN_HEIGHT, fontSize + 8)
    local iconOffsetX = iconCfg.x or 0
    local iconOffsetY = iconCfg.y or 0
    local fontX = fontCfg.x or 0
    local fontY = fontCfg.y or 0
    local contentHeight = showIcon and (iconHeight + TEXT_ICON_GAP + textHeight) or textHeight
    local rawIconTop = 0
    local rawIconBottom = 0
    local rawTextTop = 0
    local rawTextBottom = 0

    if showIcon then
        rawIconTop = math_floor(contentHeight * 0.5) + iconOffsetY
        rawIconBottom = rawIconTop - iconHeight
        rawTextTop = rawIconBottom + fontY - TEXT_ICON_GAP
        rawTextBottom = rawTextTop - textHeight
    else
        rawTextTop = (textHeight * 0.5) + fontY
        rawTextBottom = (-textHeight * 0.5) + fontY
    end

    local topExtent = math_max(rawIconTop, rawTextTop)
    local bottomExtent = math.min(rawIconBottom, rawTextBottom)
    local contentCenterShift = -((topExtent + bottomExtent) * 0.5)
    local frameHeight = (topExtent - bottomExtent) + FRAME_VERTICAL_PADDING
    local frameWidth = math_max(
        FRAME_MIN_WIDTH,
        (showIcon and iconWidth or 0) + FRAME_HORIZONTAL_PADDING,
        (showIcon and math_abs(iconOffsetX) * 2 or 0) + iconWidth + FRAME_SIDE_OFFSET_PADDING,
        math_abs(fontX) * 2 + FRAME_MIN_WIDTH
    )

    displayFrame:SetSize(frameWidth, frameHeight)

    displayFrame.Icon:ClearAllPoints()
    displayFrame.Icon:SetSize(iconWidth, iconHeight)
    displayFrame.Icon:SetPoint("TOP", displayFrame, "CENTER", iconOffsetX, rawIconTop + contentCenterShift)
    displayFrame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    displayFrame.Icon:SetTexture(iconTexture)
    displayFrame.Icon:SetShown(showIcon and iconTexture ~= nil and IsIconEventActive())

    if not EXStaticDB or not EXStaticDB.ApplyFont then
        return
    end

    EXStaticDB:ApplyFont(displayText, EX_DB.font_text)
    displayText:ClearAllPoints()
    displayText:SetWidth(frameWidth - 12)
    displayText:SetJustifyH("CENTER")
    displayText:SetWordWrap(false)
    if displayFrame.Icon:IsShown() then
        displayText:SetPoint("TOP", displayFrame.Icon, "BOTTOM", fontX, fontY - TEXT_ICON_GAP)
    else
        displayText:SetPoint("CENTER", displayFrame, "CENTER", fontX, fontY + contentCenterShift)
    end
end

local function ShouldHideDisplayByIconState()
    if isEditModeActive then
        return false
    end

    local iconCfg = EX_DB.icon_display or {}
    if iconCfg.showIcon == false then
        return false
    end

    return not IsIconEventActive()
end

local function GetPlayerShieldAmount()
    local amount = nil
    if UnitGetTotalAbsorbs then
        amount = UnitGetTotalAbsorbs("player")
    end
    if IsSecretValue(amount) then
        return amount, true
    end
    if amount == nil then
        return 0, false
    end
    amount = tonumber(amount) or 0
    if amount < 0 then
        return 0, false
    end
    return amount, false
end

local function FormatSecretLargeNumberCN(value)
    if not AbbreviateNumbers then
        if AbbreviateLargeNumbers then
            return AbbreviateLargeNumbers(value)
        end
        return string.format("%s", value)
    end

    return AbbreviateNumbers(value, {
        breakpointData = {
            {
                breakpoint = 100000000,
                abbreviation = "亿",
                significandDivisor = 100000000,
                fractionDivisor = 1,
                abbreviationIsGlobal = false,
            },
            {
                breakpoint = 10000,
                abbreviation = "万",
                significandDivisor = 10000,
                fractionDivisor = 1,
                abbreviationIsGlobal = false,
            },
        },
    })
end

local function FormatLargeNumber(value)
    if IsSecretValue(value) then
        return FormatSecretLargeNumberCN(value)
    end
    if value >= 100000000 then
        return string.format(L["%.2f亿"], value / 100000000)
    end
    if value >= 10000 then
        return string.format(L["%d万"], math_floor(value / 10000))
    end
    if BreakUpLargeNumbers then
        return BreakUpLargeNumbers(math_floor(value + 0.5))
    end
    return tostring(math_floor(value + 0.5))
end

local function FormatShieldValue(amount)
    if IsSecretValue(amount) then
        if EX_DB.abbreviateNumber then
            return FormatLargeNumber(amount)
        end
        return string.format("%.0f", amount)
    end
    if EX_DB.abbreviateNumber then
        return FormatLargeNumber(amount)
    end
    if BreakUpLargeNumbers then
        return BreakUpLargeNumbers(math_floor(amount + 0.5))
    end
    return tostring(math_floor(amount + 0.5))
end

local function BuildSecretZeroSafeValueText(amount)
    if not C_StringUtil or type(C_StringUtil.TruncateWhenZero) ~= "function" then
        return nil
    end
    return C_StringUtil.TruncateWhenZero(amount)
end

local function BuildPreviewText()
    return FormatShieldValue(PREVIEW_VALUE)
end

local function BuildLiveText()
    local shieldAmount, shieldAmountIsSecret = GetPlayerShieldAmount()
    if shieldAmountIsSecret and EX_DB.hideWhenZero and not EX_DB.abbreviateNumber then
        local zeroSafeText = BuildSecretZeroSafeValueText(shieldAmount)
        if zeroSafeText ~= nil then
            return shieldAmount, shieldAmountIsSecret, zeroSafeText, false
        end
    end
    return shieldAmount, shieldAmountIsSecret, FormatShieldValue(shieldAmount), false
end

local function SetFrameVisible(visible)
    if not displayFrame then return end
    if visible then
        displayFrame:Show()
    else
        if displayFrame.Icon then
            displayFrame.Icon:Hide()
        end
        displayFrame:Hide()
    end
end

RefreshDisplay = function()
    refreshTimer = nil
    if not displayFrame or not displayText then return end

    RestorePosition()
    ApplyDisplayStyle()

    if isEditModeActive then
        if not isEditModeVisible then
            SetFrameVisible(false)
            RefreshEditOverlay()
            return
        end

        displayText:SetText(BuildPreviewText())
        SetFrameVisible(true)
        displayFrame:EnableMouse(true)
        RefreshEditOverlay()
        return
    end

    displayFrame:EnableMouse(false)
    RefreshEditOverlay()

    if not EX_DB.enabled then
        SetFrameVisible(false)
        return
    end

    if ShouldHideDisplayByIconState() then
        SetFrameVisible(false)
        return
    end

    local shieldAmount, shieldAmountIsSecret, text, shouldHide = BuildLiveText()
    if shouldHide then
        SetFrameVisible(false)
        return
    end
    if EX_DB.hideWhenZero and not shieldAmountIsSecret and math_abs(tonumber(shieldAmount) or 0) <= 0.0001 then
        SetFrameVisible(false)
        return
    end

    if text == nil then
        text = ""
    end
    displayText:SetText(text)
    SetFrameVisible(true)
end

local function ScheduleRefresh()
    if refreshTimer then
        return
    end

    if C_Timer and type(C_Timer.NewTimer) == "function" then
        refreshTimer = C_Timer.NewTimer(REFRESH_THROTTLE, RefreshDisplay)
        return
    end

    if C_Timer and type(C_Timer.After) == "function" then
        refreshTimer = true
        C_Timer.After(REFRESH_THROTTLE, RefreshDisplay)
        return
    end

    RefreshDisplay()
end

local function ResetPosition()
    EX_DB.point = EX_DEFAULTS.point
    EX_DB.relativePoint = EX_DEFAULTS.relativePoint
    EX_DB.xOffset = EX_DEFAULTS.xOffset
    EX_DB.yOffset = EX_DEFAULTS.yOffset
    RestorePosition()
    SavePosition()
end

local function CreateDisplayFrame()
    if displayFrame then return end

    local frame = CreateFrame("Frame", "ExwindPlayerShieldFrame", UIParent)
    frame:SetSize(FRAME_MIN_WIDTH, 88)
    frame:SetPoint("CENTER", UIParent, "CENTER", EX_DB.xOffset or 0, EX_DB.yOffset or -120)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetClampedToScreen(false)

    frame.Icon = frame:CreateTexture(nil, "ARTWORK")
    frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    frame.Text = frame:CreateFontString(nil, "OVERLAY")
    frame.Text:SetPoint("CENTER")
    frame.Text:SetJustifyH("CENTER")

    frame:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            StartFrameMove(self)
        elseif button == "RightButton" and ExwindTools.GlobalEditMode then
            ExwindTools:OpenConfig(EXWIND_MODULE_KEY)
        end
    end)

    frame:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            StopFrameMove(self)
        end
    end)

    frame:SetScript("OnDragStart", function(self)
        StartFrameMove(self)
    end)

    frame:SetScript("OnDragStop", function(self)
        StopFrameMove(self)
    end)

    displayFrame = frame
    displayText = frame.Text

    ExwindTools:RegisterHUD(EXWIND_MODULE_KEY, frame)
    frame:EnableMouse(false)
end

CreateDisplayFrame()

ExwindTools:RegisterEditModeHandler(EXWIND_MODULE_KEY, {
    EnterEditMode = function()
        isEditModeActive = true
        isEditModeVisible = true
        RefreshDisplay()
    end,
    ExitEditMode = function()
        isEditModeActive = false
        isEditModeVisible = true
        RefreshDisplay()
    end,
    SetEditVisible = function(_, visible)
        isEditModeVisible = (visible ~= false)
        RefreshDisplay()
    end,
})

ExwindTools:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", EXWIND_MODULE_KEY, function(_, unit)
    if unit == "player" then
        MarkAbsorbEventActive()
        ScheduleRefresh()
    end
end)

ExwindTools:RegisterEvent("PLAYER_ENTERING_WORLD", EXWIND_MODULE_KEY, function()
    ScheduleRefresh()
end)

ExwindTools:WatchState(EXWIND_MODULE_KEY .. ".DatabaseChanged", EXWIND_MODULE_KEY, function()
    ScheduleRefresh()
end)

ExwindTools:WatchState(EXWIND_MODULE_KEY .. ".ButtonClicked", EXWIND_MODULE_KEY, function(info)
    if not info or info.key ~= "btn_resetPos" then
        return
    end
    ResetPosition()
    ScheduleRefresh()
end)

ScheduleRefresh()
ExwindTools:ReportReady(EXWIND_MODULE_KEY)
