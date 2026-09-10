-- =============================================================
-- [[ 团队标记面板 ]]
-- { Key = "ExTools.RaidMarkerPanel", Name = "团队标记面板", Desc = "提供目标标记与地面光柱的一体化操作面板。", Category = 1 },
-- =============================================================

local ExwindTools = _G.ExwindTools
if not ExwindTools then return end

local L = (ExwindTools and ExwindTools.L) or setmetatable({}, { __index = function(_, key) return key end })

local CreateFrame = _G.CreateFrame
local C_Timer = _G.C_Timer
local GameTooltip = _G.GameTooltip
local UIParent = _G.UIParent

local EXWIND_MODULE_KEY = "ExTools.RaidMarkerPanel"

-- =============================================================
-- 1. Grid 布局定义
-- =============================================================

local BINDING_ORDER = {
    "left",
    "right",
    "shift-left",
    "shift-right",
    "ctrl-left",
    "ctrl-right",
}

local BINDING_DEFS = {
    ["left"] = {
        label = L["左键"],
        typeAttr = "type1",
        actionAttr = "action1",
        markerAttr = "marker1",
        unitAttr = "unit1",
    },
    ["right"] = {
        label = L["右键"],
        typeAttr = "type2",
        actionAttr = "action2",
        markerAttr = "marker2",
        unitAttr = "unit2",
    },
    ["shift-left"] = {
        label = L["SHIFT+左键"],
        typeAttr = "shift-type1",
        actionAttr = "shift-action1",
        markerAttr = "shift-marker1",
        unitAttr = "shift-unit1",
    },
    ["shift-right"] = {
        label = L["SHIFT+右键"],
        typeAttr = "shift-type2",
        actionAttr = "shift-action2",
        markerAttr = "shift-marker2",
        unitAttr = "shift-unit2",
    },
    ["ctrl-left"] = {
        label = L["CTRL+左键"],
        typeAttr = "ctrl-type1",
        actionAttr = "ctrl-action1",
        markerAttr = "ctrl-marker1",
        unitAttr = "ctrl-unit1",
    },
    ["ctrl-right"] = {
        label = L["CTRL+右键"],
        typeAttr = "ctrl-type2",
        actionAttr = "ctrl-action2",
        markerAttr = "ctrl-marker2",
        unitAttr = "ctrl-unit2",
    },
}

local function EX_RegisterLayout()
    local layout = {
        { key = "header", type = "header", x = 2, y = 1, w = 50, h = 2, label = L["团队标记面板"], labelSize = 24 },
        { key = "showPanel", type = "checkbox", x = 2, y = 5, w = 14, h = 2, label = L["显示面板"] },
        { key = "lockPanel", type = "checkbox", x = 18, y = 5, w = 14, h = 2, label = L["锁定位置"] },
        { key = "scale", type = "slider", x = 2, y = 10, w = 14, h = 2, label = L["面板缩放"], min = 0.1, max = 3, step = 0.1 },
        { key = "raidMarkerBinding", type = "dropdown", x = 18, y = 10, w = 14, h = 2, label = L["标记按键"], items = "left:左键,right:右键,shift-left:SHIFT+左键,shift-right:SHIFT+右键,ctrl-left:CTRL+左键,ctrl-right:CTRL+右键" },
        { key = "worldMarkerBinding", type = "dropdown", x = 34, y = 10, w = 14, h = 2, label = L["光柱按键"], items = "left:左键,right:右键,shift-left:SHIFT+左键,shift-right:SHIFT+右键,ctrl-left:CTRL+左键,ctrl-right:CTRL+右键" },
        { key = "enableCountdownButton", type = "checkbox", x = 2, y = 15, w = 14, h = 2, label = L["启用倒数"] },
        { key = "countdownSeconds", type = "input", x = 18, y = 15, w = 10, h = 2, label = L["倒数秒数"] },
        { key = "swapCountdownAndReadyCheck", type = "checkbox", x = 34, y = 15, w = 14, h = 2, label = L["交换确认与倒数按钮位置"] },
        { key = "enableReadyCheckButton", type = "checkbox", x = 2, y = 20, w = 14, h = 2, label = L["启用就位确认"] },
        { key = "bundleLayout", type = "checkbox", x = 18, y = 20, w = 14, h = 2, label = L["束状排列"] },
        { key = "buttonSpacing", type = "slider", x = 34, y = 20, w = 14, h = 2, label = L["按钮间距"], min = 0, max = 20, step = 1 },
        { key = "hoverShow", type = "checkbox", x = 2, y = 25, w = 14, h = 2, label = L["启用悬停显示"] },
        { key = "idleAlpha", type = "slider", x = 18, y = 25, w = 14, h = 2, label = L["离开透明度"], min = 0, max = 1, step = 0.05 },
        { key = "btn_reset_pos", type = "button", x = 34, y = 5, w = 14, h = 2, label = L["重置位置"] },
    }

    ExwindTools:RegisterModuleLayout(EXWIND_MODULE_KEY, layout)
end

EX_RegisterLayout()

-- =============================================================
-- 2. 载入检查
-- =============================================================

if not ExwindTools:IsModuleEnabled(EXWIND_MODULE_KEY) then return end

-- =============================================================
-- 3. 依赖与数据初始化
-- =============================================================

local EX_DEFAULTS = {
    showPanel = false,
    scale = 1,
    posPoint = "CENTER",
    posRelativePoint = "CENTER",
    posX = 0,
    posY = 0,
    raidMarkerBinding = "left",
    worldMarkerBinding = "right",
    enableCountdownButton = true,
    countdownSeconds = "10",
    swapCountdownAndReadyCheck = false,
    enableReadyCheckButton = true,
    bundleLayout = false,
    buttonSpacing = 4,
    hoverShow = false,
    idleAlpha = 0.15,
}

local EX_DB = ExwindTools:GetModuleDB(EXWIND_MODULE_KEY, EX_DEFAULTS)

local DB_KEYS = {
    showPanel = true,
    scale = true,
    posPoint = true,
    posRelativePoint = true,
    posX = true,
    posY = true,
    raidMarkerBinding = true,
    worldMarkerBinding = true,
    enableCountdownButton = true,
    countdownSeconds = true,
    swapCountdownAndReadyCheck = true,
    enableReadyCheckButton = true,
    bundleLayout = true,
    buttonSpacing = true,
    hoverShow = true,
    idleAlpha = true,
}

local MARKER_NAMES = {
    [1] = L["星星"],
    [2] = L["圆圈"],
    [3] = L["菱形"],
    [4] = L["三角"],
    [5] = L["月亮"],
    [6] = L["方块"],
    [7] = L["叉叉"],
    [8] = L["骷髅"],
}

local WORLD_RAID_MARKER_ORDER = {
    [1] = 8,
    [2] = 4,
    [3] = 1,
    [4] = 7,
    [5] = 2,
    [6] = 3,
    [7] = 6,
    [8] = 5,
}

local PANEL_PADDING = 8
local BTN_SIZE = 28
local BTN_HOVER_SCALE = 1.12
local PANEL_FADE_OUT_DELAY = 2
local PANEL_FADE_DURATION = 0.35

local ATLAS_CONTENT_SCALE = {
    ["GM-raidMarker-remove"] = 1.31,
    ["GM-icon-countdown-hover"] = 1.87,
    ["GM-icon-readyCheck-hover"] = 2.00,
}

local Panel
local ButtonArea
local MarkerButtons = {}
local RemoveButton
local CountdownButton
local ReadyCheckButton
local PendingShowState
local PendingBindingRefresh = false
local isEditModeActive = false
local isEditModeVisible = true
local RuntimeLockPanel = true
local HoverFadeToken = 0

local function NormalizeModuleDB()
    local cleaned = {}

    for key, defaultValue in pairs(EX_DEFAULTS) do
        local currentValue = EX_DB[key]
        if type(currentValue) == type(defaultValue) then
            cleaned[key] = currentValue
        else
            cleaned[key] = defaultValue
        end
    end

    for key in pairs(EX_DB) do
        if not DB_KEYS[key] then
            EX_DB[key] = nil
        end
    end

    for key, value in pairs(cleaned) do
        EX_DB[key] = value
    end

    EX_DB.lockPanel = nil
end

local function GetBindingChoice(dbValue, defaultKey)
    if type(dbValue) == "string" and BINDING_DEFS[dbValue] then
        return dbValue
    end
    return defaultKey
end

local function FindFirstAvailableBinding(excludedKey)
    for _, bindingKey in ipairs(BINDING_ORDER) do
        if bindingKey ~= excludedKey then
            return bindingKey
        end
    end
    return "right"
end

local function NormalizeBindingChoices(changedKey)
    local raidBinding = GetBindingChoice(EX_DB.raidMarkerBinding, "left")
    local worldBinding = GetBindingChoice(EX_DB.worldMarkerBinding, "right")

    if raidBinding == worldBinding then
        if changedKey == "worldMarkerBinding" then
            raidBinding = FindFirstAvailableBinding(worldBinding)
        else
            worldBinding = FindFirstAvailableBinding(raidBinding)
        end
    end

    EX_DB.raidMarkerBinding = raidBinding
    EX_DB.worldMarkerBinding = worldBinding
end

local function NormalizeCountdownSeconds()
    local seconds = tonumber(EX_DB.countdownSeconds)
    if not seconds then
        seconds = 10
    end

    seconds = math.floor(seconds + 0.5)
    if seconds < 1 then
        seconds = 1
    elseif seconds > 30 then
        seconds = 30
    end

    EX_DB.countdownSeconds = tostring(seconds)
    return seconds
end

local function NormalizePanelScale()
    local scale = tonumber(EX_DB.scale) or EX_DEFAULTS.scale
    scale = math.floor(scale * 10 + 0.5) / 10
    if scale < 0.1 then
        scale = 0.1
    elseif scale > 3 then
        scale = 3
    end
    EX_DB.scale = scale
    return scale
end

local function NormalizeButtonSpacing()
    local spacing = tonumber(EX_DB.buttonSpacing)
    if not spacing then
        spacing = EX_DEFAULTS.buttonSpacing
    end

    spacing = math.floor(spacing + 0.5)
    if spacing < 0 then
        spacing = 0
    elseif spacing > 20 then
        spacing = 20
    end

    EX_DB.buttonSpacing = spacing
    return spacing
end

local function NormalizeIdleAlpha()
    local alpha = tonumber(EX_DB.idleAlpha)
    if not alpha then
        alpha = EX_DEFAULTS.idleAlpha
    end

    alpha = math.floor(alpha / 0.05 + 0.5) * 0.05
    if alpha < 0 then
        alpha = 0
    elseif alpha > 1 then
        alpha = 1
    end

    EX_DB.idleAlpha = alpha
    return alpha
end

local function RoundToNearest(value)
    if not value then
        return 0
    end
    if value >= 0 then
        return math.floor(value + 0.5)
    end
    return math.ceil(value - 0.5)
end

NormalizeModuleDB()
NormalizeBindingChoices()

local function IsBundleLayoutEnabled()
    return EX_DB.bundleLayout == true
end

local function IsUtilityButtonOrderSwapped()
    return EX_DB.swapCountdownAndReadyCheck == true
end

local function IsHoverShowEnabled()
    return EX_DB.hoverShow == true and not isEditModeActive
end

local function StopPanelFade()
    if not Panel then return end
    Panel._fadeFromAlpha = nil
    Panel._fadeToAlpha = nil
    Panel._fadeElapsed = nil
    Panel:SetScript("OnUpdate", nil)
end

local function GetIdlePanelAlpha()
    if not IsHoverShowEnabled() then
        return 1
    end
    return NormalizeIdleAlpha()
end

local function CancelPendingPanelFade()
    HoverFadeToken = HoverFadeToken + 1
end

local function StartPanelFade(targetAlpha)
    if not Panel or not Panel:IsShown() then return end

    targetAlpha = math.max(0, math.min(1, tonumber(targetAlpha) or 1))

    StopPanelFade()

    local currentAlpha = Panel:GetAlpha() or 1
    if math.abs(currentAlpha - targetAlpha) < 0.01 then
        Panel:SetAlpha(targetAlpha)
        return
    end

    Panel._fadeFromAlpha = currentAlpha
    Panel._fadeToAlpha = targetAlpha
    Panel._fadeElapsed = 0
    Panel:SetScript("OnUpdate", function(self, elapsed)
        local duration = PANEL_FADE_DURATION
        local nextElapsed = math.min((self._fadeElapsed or 0) + elapsed, duration)
        self._fadeElapsed = nextElapsed

        local progress = nextElapsed / duration
        local alpha = self._fadeFromAlpha + (self._fadeToAlpha - self._fadeFromAlpha) * progress
        self:SetAlpha(alpha)

        if progress >= 1 then
            self:SetAlpha(self._fadeToAlpha)
            StopPanelFade()
        end
    end)
end

local function RefreshPanelAlphaState(immediate)
    if not Panel then return end

    CancelPendingPanelFade()

    if not Panel:IsShown() then
        StopPanelFade()
        return
    end

    if isEditModeActive then
        StopPanelFade()
        Panel:SetAlpha(1)
        return
    end

    if not IsHoverShowEnabled() then
        StopPanelFade()
        Panel:SetAlpha(1)
        return
    end

    if Panel:IsMouseOver() then
        StopPanelFade()
        Panel:SetAlpha(1)
        return
    end

    if immediate then
        StopPanelFade()
        Panel:SetAlpha(GetIdlePanelAlpha())
    end
end

local function HandlePanelHoverEnter()
    if not Panel or not Panel:IsShown() or not IsHoverShowEnabled() then return end
    CancelPendingPanelFade()
    StopPanelFade()
    Panel:SetAlpha(1)
end

local function HandlePanelHoverLeave()
    if not Panel or not Panel:IsShown() or not IsHoverShowEnabled() then return end

    CancelPendingPanelFade()
    local fadeToken = HoverFadeToken
    C_Timer.After(PANEL_FADE_OUT_DELAY, function()
        if fadeToken ~= HoverFadeToken then return end
        if not Panel or not Panel:IsShown() then return end
        if isEditModeActive or Panel:IsMouseOver() then return end
        StartPanelFade(GetIdlePanelAlpha())
    end)
end

local function SyncLockPanelWidget()
    local grid = _G.ExwindGrid
    local ui = ExwindTools.UI
    if not grid or type(grid.Widgets) ~= "table" or not ui or ui.CurrentModule ~= EXWIND_MODULE_KEY then
        return
    end

    local widget = grid.Widgets.lockPanel
    if widget and widget.SetChecked then
        widget:SetChecked(RuntimeLockPanel)
    end
end

local function GetPanelWidth(buttonCount)
    local count = tonumber(buttonCount) or 0
    if count < 1 then
        count = 1
    end
    local spacing = NormalizeButtonSpacing()
    return PANEL_PADDING * 2 + BTN_SIZE * count + spacing * math.max(0, count - 1)
end

local function GetPanelMetrics(buttonCount)
    local count = math.max(1, tonumber(buttonCount) or 0)
    if not IsBundleLayoutEnabled() then
        return GetPanelWidth(count), PANEL_PADDING * 2 + BTN_SIZE
    end

    local width = GetPanelWidth(1)
    local spacing = NormalizeButtonSpacing()
    local height = PANEL_PADDING * 2 + BTN_SIZE * count + spacing * math.max(0, count - 1)
    return width, height
end

local function GetWorldMarkerID(iconMarker)
    local displayOrder = 9 - iconMarker
    return WORLD_RAID_MARKER_ORDER[displayOrder] or iconMarker
end

local function IsInPartyOrRaid()
    local state = ExwindTools.State
    if state and (state.IsInParty == true or state.IsInRaid == true) then
        return true
    end
    if _G.IsInRaid and _G.IsInRaid() then
        return true
    end
    if _G.IsInGroup and _G.IsInGroup() then
        return true
    end
    return false
end

local function CanPlayerMark()
    if _G.IsInRaid and _G.IsInRaid() then
        return _G.UnitIsGroupLeader("player") or _G.UnitIsGroupAssistant("player")
    end
    return true
end

local function GetRestrictionReason()
    local restrictedAPI = _G.C_RestrictedActions
    local restrictType = _G.Enum and _G.Enum.AddOnRestrictionType
    if not restrictedAPI or type(restrictedAPI.IsRestrictionActive) ~= "function" or not restrictType then
        return nil
    end

    if restrictType.Encounter and restrictedAPI.IsRestrictionActive(restrictType.Encounter) then
        return L["首领战斗限制中"]
    end
    if restrictType.ChallengeMode and restrictedAPI.IsRestrictionActive(restrictType.ChallengeMode) then
        return L["大秘境限制中"]
    end
    if restrictType.PvPMatch and restrictedAPI.IsRestrictionActive(restrictType.PvPMatch) then
        return L["PvP对局限制中"]
    end
    if restrictType.Map and restrictedAPI.IsRestrictionActive(restrictType.Map) then
        return L["副本地图限制中"]
    end
    if restrictType.Combat and restrictedAPI.IsRestrictionActive(restrictType.Combat) then
        return L["战斗限制中"]
    end

    return nil
end

local function GetChatRestrictionReason()
    local chatInfo = _G.C_ChatInfo
    if chatInfo and type(chatInfo.InChatMessagingLockdown) == "function" then
        local isRestricted = chatInfo.InChatMessagingLockdown()
        if isRestricted then
            return L["聊天通讯限制中"]
        end
    end

    local restrictedAPI = _G.C_RestrictedActions
    local restrictType = _G.Enum and _G.Enum.AddOnRestrictionType
    if restrictedAPI and type(restrictedAPI.IsRestrictionActive) == "function" and restrictType and restrictType.Chat then
        if restrictedAPI.IsRestrictionActive(restrictType.Chat) then
            return L["聊天通讯限制中"]
        end
    end

    return nil
end

local function CanUseCountdown()
    if not IsInPartyOrRaid() then
        return false, L["团队倒数只在队伍/团队内生效"]
    end

    local reason = GetChatRestrictionReason()
    if reason then
        return false, reason
    end

    return true, nil
end

local function CanUseReadyCheck()
    if not IsInPartyOrRaid() then
        return false, L["就位确认只在队伍/团队内生效"]
    end

    local reason = GetChatRestrictionReason()
    if reason then
        return false, reason
    end

    return true, nil
end

local function SetRaidIcon(texture, index)
    if not texture then return end

    texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    if _G.SetRaidTargetIconTexture then
        _G.SetRaidTargetIconTexture(texture, index)
    end
end

local function SetRemoveAtlas(texture)
    if not texture then return end
    texture:SetAtlas("GM-raidMarker-remove", false)
end

local function ApplyAtlasContentScale(texture, atlasName)
    if not texture then return end
    local scale = ATLAS_CONTENT_SCALE[atlasName] or 1
    texture:SetSize(BTN_SIZE * scale, BTN_SIZE * scale)
end

local function SavePanelPosition()
    if not Panel then return end

    local point, _, relativePoint, xOfs, yOfs = Panel:GetPoint()
    if not point or not relativePoint then
        return
    end

    EX_DB.posPoint = point
    EX_DB.posRelativePoint = relativePoint
    EX_DB.posX = RoundToNearest(xOfs or 0)
    EX_DB.posY = RoundToNearest(yOfs or 0)
end

local function ApplyPanelPosition()
    if not Panel then return end
    Panel:ClearAllPoints()
    Panel:SetPoint(
        EX_DB.posPoint or "CENTER",
        UIParent,
        EX_DB.posRelativePoint or "CENTER",
        EX_DB.posX or 0,
        EX_DB.posY or 0
    )
end

local function ApplyPanelScale()
    if not Panel then return end
    Panel:SetScale(NormalizePanelScale())
end

local function GetTooltipBindingText()
    local raidBinding = GetBindingChoice(EX_DB.raidMarkerBinding, "left")
    local worldBinding = GetBindingChoice(EX_DB.worldMarkerBinding, "right")
    local raidLabel = BINDING_DEFS[raidBinding] and BINDING_DEFS[raidBinding].label or L["左键"]
    local worldLabel = BINDING_DEFS[worldBinding] and BINDING_DEFS[worldBinding].label or L["右键"]
    return raidLabel, worldLabel
end

local function HideMarkerTooltip()
    if GameTooltip then
        GameTooltip:Hide()
    end
end

local function GetTooltipAnchor(button)
    if not IsBundleLayoutEnabled() then
        return "ANCHOR_TOP"
    end

    local uiCenterX = UIParent and UIParent.GetCenter and UIParent:GetCenter()
    local buttonCenterX = button and button.GetCenter and button:GetCenter()
    if not uiCenterX or not buttonCenterX then
        return "ANCHOR_RIGHT"
    end

    local uiScale = UIParent:GetEffectiveScale() or 1
    local buttonScale = button:GetEffectiveScale() or 1
    if (buttonCenterX * buttonScale) <= (uiCenterX * uiScale) then
        return "ANCHOR_RIGHT"
    end

    return "ANCHOR_LEFT"
end

local function ShowMarkerTooltip(button)
    if not button or not GameTooltip then return end

    local raidLabel, worldLabel = GetTooltipBindingText()
    GameTooltip:SetOwner(button, GetTooltipAnchor(button))
    GameTooltip:ClearLines()

    if button.isRemoveButton then
        GameTooltip:AddLine(L["移除"], 1, 0.30, 0.30)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(string.format(L["%s：清除全部标记"], raidLabel), 1, 1, 1)
        GameTooltip:AddLine(string.format(L["%s：清除全部光柱"], worldLabel), 0.75, 1, 0.75)
    elseif button.isCountdownButton then
        GameTooltip:AddLine(L["团队倒数"], 1, 0.82, 0)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(string.format(L["左键：开始 %s 秒倒数"], NormalizeCountdownSeconds()), 1, 1, 1)
        GameTooltip:AddLine(L["右键：取消当前倒数"], 0.75, 1, 0.75)

        local canUse, reason = CanUseCountdown()
        if not canUse and reason then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(string.format(L["当前不可操作：%s"], reason), 1, 0.25, 0.25, true)
        end
    elseif button.isReadyCheckButton then
        GameTooltip:AddLine(L["就位确认"], 1, 0.82, 0)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L["左键：发起就位确认"], 1, 1, 1)

        local canUse, reason = CanUseReadyCheck()
        if not canUse and reason then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(string.format(L["当前不可操作：%s"], reason), 1, 0.25, 0.25, true)
        end
    else
        GameTooltip:AddLine(string.format(L["%s：标记"], raidLabel), 1, 1, 1)
        GameTooltip:AddLine(string.format(L["%s：光柱"], worldLabel), 0.75, 1, 0.75)
    end

    local restrictionReason = GetRestrictionReason()
    if restrictionReason then
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(string.format(L["当前不可操作：%s"], restrictionReason), 1, 0.25, 0.25, true)
    elseif (_G.IsInRaid and _G.IsInRaid()) and not CanPlayerMark() then
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L["当前团队中需要队长或助理权限"], 1, 0.25, 0.25, true)
    end

    GameTooltip:Show()
end

local function SetMarkerButtonState(button, isEnabled, worldActive)
    if not button or not button.icon then return end

    if button.inputBlocker then
        button.inputBlocker:SetShown(not isEnabled)
    end

    if not isEnabled then
        button.icon:SetDesaturated(true)
        button.icon:SetAlpha(0.32)
        button.icon:SetVertexColor(0.55, 0.55, 0.55)
        return
    end

    button.icon:SetDesaturated(false)
    if worldActive then
        button.icon:SetAlpha(1)
        button.icon:SetVertexColor(0.45, 1.00, 0.60)
    else
        button.icon:SetAlpha(0.92)
        button.icon:SetVertexColor(1, 1, 1)
    end
end

local function SetRemoveButtonState(button, isEnabled, worldActive)
    if not button or not button.icon then return end

    if button.inputBlocker then
        button.inputBlocker:SetShown(not isEnabled)
    end

    if not isEnabled then
        button.icon:SetDesaturated(true)
        button.icon:SetAlpha(0.32)
        button.icon:SetVertexColor(0.55, 0.55, 0.55)
        return
    end

    button.icon:SetDesaturated(false)
    if worldActive then
        button.icon:SetAlpha(1)
        button.icon:SetVertexColor(1.00, 0.42, 0.42)
    else
        button.icon:SetAlpha(0.92)
        button.icon:SetVertexColor(1, 1, 1)
    end
end

local function SetUtilityButtonState(button, isEnabled, tintR, tintG, tintB)
    if not button or not button.icon or not button:IsShown() then return end

    if button.inputBlocker then
        button.inputBlocker:SetShown(not isEnabled)
    end

    if not isEnabled then
        button.icon:SetDesaturated(true)
        button.icon:SetAlpha(0.32)
        button.icon:SetVertexColor(0.55, 0.55, 0.55)
        return
    end

    button.icon:SetDesaturated(false)
    button.icon:SetAlpha(1)
    button.icon:SetVertexColor(tintR or 1, tintG or 1, tintB or 1)
end

local function ClearButtonBindings(button)
    if not button then return end
    for _, bindingKey in ipairs(BINDING_ORDER) do
        local bindingDef = BINDING_DEFS[bindingKey]
        button:SetAttribute(bindingDef.typeAttr, nil)
        button:SetAttribute(bindingDef.actionAttr, nil)
        button:SetAttribute(bindingDef.markerAttr, nil)
        button:SetAttribute(bindingDef.unitAttr, nil)
    end
end

local function ApplyButtonBindings()
    if not Panel then return end

    NormalizeBindingChoices()

    if _G.InCombatLockdown and _G.InCombatLockdown() then
        PendingBindingRefresh = true
        return
    end

    PendingBindingRefresh = false

    local raidBinding = GetBindingChoice(EX_DB.raidMarkerBinding, "left")
    local worldBinding = GetBindingChoice(EX_DB.worldMarkerBinding, "right")
    local raidDef = BINDING_DEFS[raidBinding]
    local worldDef = BINDING_DEFS[worldBinding]

    for marker = 1, 8 do
        local button = MarkerButtons[marker]
        if button then
            ClearButtonBindings(button)

            button:SetAttribute(raidDef.typeAttr, "raidtarget")
            button:SetAttribute(raidDef.actionAttr, "toggle")
            button:SetAttribute(raidDef.markerAttr, marker)
            button:SetAttribute(raidDef.unitAttr, "target")

            button:SetAttribute(worldDef.typeAttr, "worldmarker")
            button:SetAttribute(worldDef.actionAttr, "toggle")
            button:SetAttribute(worldDef.markerAttr, GetWorldMarkerID(marker))
        end
    end

    if RemoveButton then
        ClearButtonBindings(RemoveButton)

        RemoveButton:SetAttribute(raidDef.typeAttr, "raidtarget")
        RemoveButton:SetAttribute(raidDef.actionAttr, "clear-all")

        RemoveButton:SetAttribute(worldDef.typeAttr, "worldmarker")
        RemoveButton:SetAttribute(worldDef.actionAttr, "clear")
    end
end

local function UpdateButtonLayout()
    if not Panel or not ButtonArea then return end

    local orderedButtons = {}
    for marker = 8, 1, -1 do
        orderedButtons[#orderedButtons + 1] = MarkerButtons[marker]
    end

    orderedButtons[#orderedButtons + 1] = RemoveButton

    local firstUtilityButton = CountdownButton
    local secondUtilityButton = ReadyCheckButton
    local firstUtilityEnabled = EX_DB.enableCountdownButton == true
    local secondUtilityEnabled = EX_DB.enableReadyCheckButton == true

    if IsUtilityButtonOrderSwapped() then
        firstUtilityButton = ReadyCheckButton
        secondUtilityButton = CountdownButton
        firstUtilityEnabled = EX_DB.enableReadyCheckButton == true
        secondUtilityEnabled = EX_DB.enableCountdownButton == true
    end

    if firstUtilityEnabled then
        orderedButtons[#orderedButtons + 1] = firstUtilityButton
    end
    if secondUtilityEnabled then
        orderedButtons[#orderedButtons + 1] = secondUtilityButton
    end

    local width, height = GetPanelMetrics(#orderedButtons)
    Panel:SetWidth(width)
    ButtonArea:SetWidth(width - PANEL_PADDING * 2)
    ButtonArea:SetHeight(height - PANEL_PADDING * 2)
    Panel:SetHeight(height)

    if CountdownButton then
        CountdownButton:Hide()
    end
    if ReadyCheckButton then
        ReadyCheckButton:Hide()
    end

    local function LayoutRow(buttons, yOffset)
        local rowCount = #buttons
        if rowCount < 1 then
            return
        end

        local spacing = NormalizeButtonSpacing()
        local rowWidth = BTN_SIZE * rowCount + spacing * math.max(0, rowCount - 1)
        local startX = math.floor((ButtonArea:GetWidth() - rowWidth) * 0.5 + 0.5)
        for index, button in ipairs(buttons) do
            button:ClearAllPoints()
            button:SetPoint("TOPLEFT", ButtonArea, "TOPLEFT", startX + (index - 1) * (BTN_SIZE + spacing), yOffset)
            button:Show()
        end
    end

    if IsBundleLayoutEnabled() then
        local spacing = NormalizeButtonSpacing()
        for index, button in ipairs(orderedButtons) do
            LayoutRow({ button }, -((index - 1) * (BTN_SIZE + spacing)))
        end
    else
        LayoutRow(orderedButtons, 0)
    end
end

local function RefreshEditOverlay()
    if not Panel then return end

    if isEditModeActive and isEditModeVisible then
        ExwindTools:ShowExwindToolsEditOverlay(EXWIND_MODULE_KEY, Panel, {
            title = L["团队标记面板"],
            ownerFrame = Panel,
        })
    else
        ExwindTools:HideExwindToolsEditOverlay(Panel)
    end
end

local function ApplyPanelVisibility()
    if not Panel then return end

    local shouldShow
    if isEditModeActive then
        shouldShow = isEditModeVisible and true or false
    else
        shouldShow = EX_DB.showPanel and true or false
    end

    if _G.InCombatLockdown and _G.InCombatLockdown() then
        PendingShowState = shouldShow
        RefreshEditOverlay()
        return
    end

    PendingShowState = nil
    CancelPendingPanelFade()
    StopPanelFade()
    if shouldShow then
        Panel:Show()
    else
        Panel:SetAlpha(1)
        Panel:Hide()
    end

    RefreshPanelAlphaState(true)
    RefreshEditOverlay()
end

local function UpdatePanelVisualState()
    if not Panel then return end

    local canMarkByRole = CanPlayerMark()
    local restrictionReason = GetRestrictionReason()
    local canMark = canMarkByRole and not restrictionReason
    local anyWorldMarkerActive = false

    for marker = 1, 8 do
        local button = MarkerButtons[marker]
        local worldActive = canMark and _G.IsRaidMarkerActive and _G.IsRaidMarkerActive(GetWorldMarkerID(marker)) or
            false
        if worldActive then
            anyWorldMarkerActive = true
        end
        SetMarkerButtonState(button, canMark, worldActive)
    end

    SetRemoveButtonState(RemoveButton, canMark, anyWorldMarkerActive)

    local canCountdown = CanUseCountdown()
    local canReadyCheck = CanUseReadyCheck()
    SetUtilityButtonState(CountdownButton, canCountdown, 0.20, 0.85, 1.00)
    SetUtilityButtonState(ReadyCheckButton, canReadyCheck, 1.00, 0.82, 0.20)
end

local function AttachTooltipHandlers(button)
    if not button then return end

    button:SetScript("OnEnter", function(self)
        HandlePanelHoverEnter()
        if self.visualRoot then
            self.visualRoot:SetScale(BTN_HOVER_SCALE)
        end
        ShowMarkerTooltip(self)
    end)
    button:SetScript("OnLeave", function(self)
        if self.visualRoot then
            self.visualRoot:SetScale(1)
        end
        HideMarkerTooltip()
        HandlePanelHoverLeave()
    end)
end

local function RegisterSecurePanelClicks(button)
    if not button then return end
    button:RegisterForClicks("AnyUp", "LeftButtonDown", "RightButtonDown")
end

local function CreateInputBlocker(parentButton)
    local blocker = CreateFrame("Button", nil, parentButton)
    blocker:SetAllPoints(parentButton)
    blocker:SetFrameLevel(parentButton:GetFrameLevel() + 8)
    RegisterSecurePanelClicks(blocker)
    blocker:SetScript("OnClick", function() end)
    blocker:SetScript("OnEnter", function()
        HandlePanelHoverEnter()
        if parentButton.visualRoot then
            parentButton.visualRoot:SetScale(BTN_HOVER_SCALE)
        end
        ShowMarkerTooltip(parentButton)
    end)
    blocker:SetScript("OnLeave", function()
        if parentButton.visualRoot then
            parentButton.visualRoot:SetScale(1)
        end
        HideMarkerTooltip()
        HandlePanelHoverLeave()
    end)
    blocker:Hide()
    return blocker
end

local function CreateMarkerButton(parent, marker)
    local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
    button:SetSize(BTN_SIZE, BTN_SIZE)
    RegisterSecurePanelClicks(button)
    button.marker = marker

    button.visualRoot = CreateFrame("Frame", nil, button)
    button.visualRoot:SetAllPoints(button)
    button.visualRoot:EnableMouse(false)

    button.icon = button.visualRoot:CreateTexture(nil, "ARTWORK")
    button.icon:SetSize(BTN_SIZE, BTN_SIZE)
    button.icon:SetPoint("CENTER")
    SetRaidIcon(button.icon, marker)

    button.highlight = button.visualRoot:CreateTexture(nil, "HIGHLIGHT")
    button.highlight:SetAllPoints(button.icon)
    button.highlight:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    button.highlight:SetBlendMode("ADD")
    button.highlight:SetAlpha(0.22)
    SetRaidIcon(button.highlight, marker)

    button.inputBlocker = CreateInputBlocker(button)
    AttachTooltipHandlers(button)

    button:HookScript("PostClick", function()
        C_Timer.After(0, UpdatePanelVisualState)
    end)

    return button
end

local function CreateRemoveButton(parent)
    local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
    button:SetSize(BTN_SIZE, BTN_SIZE)
    RegisterSecurePanelClicks(button)
    button.isRemoveButton = true

    button.visualRoot = CreateFrame("Frame", nil, button)
    button.visualRoot:SetAllPoints(button)
    button.visualRoot:EnableMouse(false)

    button.icon = button.visualRoot:CreateTexture(nil, "ARTWORK")
    button.icon:SetPoint("CENTER")
    SetRemoveAtlas(button.icon)
    ApplyAtlasContentScale(button.icon, "GM-raidMarker-remove")

    button.highlight = button.visualRoot:CreateTexture(nil, "HIGHLIGHT")
    button.highlight:SetPoint("CENTER")
    button.highlight:SetBlendMode("ADD")
    button.highlight:SetAlpha(0.22)
    SetRemoveAtlas(button.highlight)
    ApplyAtlasContentScale(button.highlight, "GM-raidMarker-remove")

    button.inputBlocker = CreateInputBlocker(button)
    AttachTooltipHandlers(button)

    button:HookScript("PostClick", function()
        C_Timer.After(0, UpdatePanelVisualState)
    end)

    return button
end

local function CreateUtilityButton(parent, atlasName, buttonType, onClick)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(BTN_SIZE, BTN_SIZE)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    if buttonType == "countdown" then
        button.isCountdownButton = true
    elseif buttonType == "readycheck" then
        button.isReadyCheckButton = true
    end

    button.visualRoot = CreateFrame("Frame", nil, button)
    button.visualRoot:SetAllPoints(button)
    button.visualRoot:EnableMouse(false)

    button.icon = button.visualRoot:CreateTexture(nil, "ARTWORK")
    button.icon:SetPoint("CENTER")
    button.icon:SetAtlas(atlasName, false)
    ApplyAtlasContentScale(button.icon, atlasName)

    button.highlight = button.visualRoot:CreateTexture(nil, "HIGHLIGHT")
    button.highlight:SetPoint("CENTER")
    button.highlight:SetBlendMode("ADD")
    button.highlight:SetAlpha(0.22)
    button.highlight:SetAtlas(atlasName, false)
    ApplyAtlasContentScale(button.highlight, atlasName)

    button.inputBlocker = CreateInputBlocker(button)
    AttachTooltipHandlers(button)

    button:SetScript("OnClick", function(_, mouseButton)
        if onClick then
            onClick(mouseButton)
        end
        C_Timer.After(0, UpdatePanelVisualState)
    end)

    return button
end

local function EnsurePanel()
    if Panel then return end

    Panel = CreateFrame("Frame", "ExwindRaidMarkerPanel", UIParent)
    local initialWidth, initialHeight = GetPanelMetrics(11)
    Panel:SetSize(initialWidth, initialHeight)
    Panel:SetFrameStrata("MEDIUM")
    Panel:SetClampedToScreen(true)
    Panel:SetMovable(true)
    Panel:EnableMouse(true)
    Panel:RegisterForDrag("LeftButton")
    Panel:Hide()
    Panel:SetAlpha(1)

    Panel:SetScript("OnDragStart", function(self)
        local canDragInEditMode = isEditModeActive and isEditModeVisible
        if not canDragInEditMode and RuntimeLockPanel then return end
        if _G.InCombatLockdown and _G.InCombatLockdown() then return end
        HandlePanelHoverEnter()
        self:StartMoving()
    end)

    Panel:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        SavePanelPosition()
        if self:IsMouseOver() then
            HandlePanelHoverEnter()
        else
            HandlePanelHoverLeave()
        end
    end)

    Panel:SetScript("OnEnter", function()
        HandlePanelHoverEnter()
    end)

    Panel:SetScript("OnLeave", function()
        HandlePanelHoverLeave()
    end)

    ButtonArea = CreateFrame("Frame", nil, Panel)
    ButtonArea:SetSize(initialWidth - PANEL_PADDING * 2, initialHeight - PANEL_PADDING * 2)
    ButtonArea:SetPoint("TOPLEFT", PANEL_PADDING, -PANEL_PADDING)

    for marker = 1, 8 do
        MarkerButtons[marker] = CreateMarkerButton(ButtonArea, marker)
    end

    RemoveButton = CreateRemoveButton(ButtonArea)

    CountdownButton = CreateUtilityButton(ButtonArea, "GM-icon-countdown-hover", "countdown", function(mouseButton)
        local canUse, reason = CanUseCountdown()
        if not canUse then
            if reason then
                ExwindTools:Print(reason)
            end
            return
        end

        local partyInfo = _G.C_PartyInfo
        if not partyInfo or type(partyInfo.DoCountdown) ~= "function" then
            ExwindTools:Print(L["团队倒数发起失败"])
            return
        end

        local countdownValue = NormalizeCountdownSeconds()
        local failureText = L["团队倒数发起失败"]
        if mouseButton == "RightButton" then
            countdownValue = 0
            failureText = L["团队倒数取消失败"]
        elseif mouseButton ~= "LeftButton" then
            return
        end

        local ok = pcall(partyInfo.DoCountdown, countdownValue)
        if not ok then
            ExwindTools:Print(failureText)
        end
    end)

    ReadyCheckButton = CreateUtilityButton(ButtonArea, "GM-icon-readyCheck-hover", "readycheck", function(mouseButton)
        if mouseButton ~= "LeftButton" then
            return
        end

        local canUse, reason = CanUseReadyCheck()
        if not canUse then
            if reason then
                ExwindTools:Print(reason)
            end
            return
        end

        local partyInfo = _G.C_PartyInfo
        local ok = partyInfo and type(partyInfo.DoReadyCheck) == "function" and
            pcall(partyInfo.DoReadyCheck)
        if not ok then
            ExwindTools:Print(L["就位确认发起失败"])
        end
    end)

    ExwindTools:RegisterHUD(EXWIND_MODULE_KEY, Panel)
end

local function RefreshPanel()
    NormalizeModuleDB()
    NormalizeBindingChoices()
    NormalizeCountdownSeconds()
    NormalizePanelScale()
    NormalizeButtonSpacing()
    NormalizeIdleAlpha()

    EnsurePanel()
    UpdateButtonLayout()
    ApplyPanelPosition()
    ApplyPanelScale()
    ApplyButtonBindings()
    ApplyPanelVisibility()
    UpdatePanelVisualState()
    RefreshPanelAlphaState(true)
end

-- =============================================================
-- 4. 事件与状态订阅
-- =============================================================

ExwindTools:RegisterEvent("PLAYER_ENTERING_WORLD", EXWIND_MODULE_KEY, function()
    RefreshPanel()
end)

ExwindTools:RegisterEvent("RAID_TARGET_UPDATE", EXWIND_MODULE_KEY, function()
    UpdatePanelVisualState()
end)

ExwindTools:RegisterEvent("PLAYER_TARGET_CHANGED", EXWIND_MODULE_KEY, function()
    UpdatePanelVisualState()
end)

ExwindTools:RegisterEvent("GROUP_ROSTER_UPDATE", EXWIND_MODULE_KEY, function()
    UpdatePanelVisualState()
end)

ExwindTools:RegisterEvent("PARTY_LEADER_CHANGED", EXWIND_MODULE_KEY, function()
    UpdatePanelVisualState()
end)

ExwindTools:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED", EXWIND_MODULE_KEY, function()
    UpdatePanelVisualState()
end)

ExwindTools:RegisterEvent("PLAYER_REGEN_ENABLED", EXWIND_MODULE_KEY, function()
    if PendingShowState ~= nil then
        ApplyPanelVisibility()
    end
    if PendingBindingRefresh then
        ApplyButtonBindings()
    end
    UpdatePanelVisualState()
end)

ExwindTools:WatchState(EXWIND_MODULE_KEY .. ".ButtonClicked", EXWIND_MODULE_KEY, function(info)
    if not info or not info.key then return end

    if info.key == "btn_reset_pos" then
        EX_DB.posPoint = EX_DEFAULTS.posPoint
        EX_DB.posRelativePoint = EX_DEFAULTS.posRelativePoint
        EX_DB.posX = EX_DEFAULTS.posX
        EX_DB.posY = EX_DEFAULTS.posY
        ApplyPanelPosition()
    end
end)

ExwindTools:WatchState(EXWIND_MODULE_KEY .. ".DatabaseChanged", EXWIND_MODULE_KEY, function(info)
    if not info or not info.key then return end

    if info.key == "showPanel" then
        ApplyPanelVisibility()
    elseif info.key == "lockPanel" then
        RuntimeLockPanel = (info.value ~= false)
        EX_DB.lockPanel = nil
        SyncLockPanelWidget()
        UpdatePanelVisualState()
    elseif info.key == "scale" then
        ApplyPanelScale()
    elseif info.key == "bundleLayout" then
        UpdateButtonLayout()
        ApplyPanelPosition()
        UpdatePanelVisualState()
    elseif info.key == "buttonSpacing" then
        UpdateButtonLayout()
        ApplyPanelPosition()
        UpdatePanelVisualState()
    elseif info.key == "hoverShow" then
        RefreshPanelAlphaState(true)
    elseif info.key == "idleAlpha" then
        NormalizeIdleAlpha()
        RefreshPanelAlphaState(true)
    elseif info.key == "raidMarkerBinding" or info.key == "worldMarkerBinding" then
        NormalizeBindingChoices(info.key)
        ApplyButtonBindings()
        UpdatePanelVisualState()
    elseif info.key == "countdownSeconds" then
        NormalizeCountdownSeconds()
        UpdatePanelVisualState()
    elseif info.key == "enableCountdownButton" or info.key == "enableReadyCheckButton" or
        info.key == "swapCountdownAndReadyCheck" then
        UpdateButtonLayout()
        UpdatePanelVisualState()
    end
end)

ExwindTools:WatchState(EXWIND_MODULE_KEY .. ".PanelRendered", EXWIND_MODULE_KEY, function()
    SyncLockPanelWidget()
end)

ExwindTools:RegisterEditModeHandler(EXWIND_MODULE_KEY, {
    EnterEditMode = function()
        isEditModeActive = true
        isEditModeVisible = true
        RefreshPanel()
    end,
    ExitEditMode = function()
        isEditModeActive = false
        isEditModeVisible = true
        RefreshPanel()
    end,
    SetEditVisible = function(_, visible)
        isEditModeVisible = (visible ~= false)
        ApplyPanelVisibility()
    end,
    RefreshEditMode = function(_, enabled, visible)
        isEditModeActive = enabled and true or false
        isEditModeVisible = (visible ~= false)
        RefreshPanel()
    end,
})

-- =============================================================
-- 5. 初始化与模块报告
-- =============================================================

C_Timer.After(0, function()
    RefreshPanel()
end)

ExwindTools:ReportReady(EXWIND_MODULE_KEY)
