-- =============================================================
-- [[ 噬灭变身计时 ]]
-- { Key = "ExTools.TransformTimer", Name = "噬灭变身计时", Desc = "直接监控玩家身上的虚空变形 Buff，并显示持续秒数。", Category = 4 },
-- =============================================================

local ExwindTools = _G.ExwindTools
if not ExwindTools then return end

local L = (ExwindTools and ExwindTools.L) or setmetatable({}, { __index = function(_, key) return key end })
local EXDB = _G.EXDB

local EXWIND_MODULE_KEY = "ExTools.TransformTimer"
local DEMON_HUNTER_CLASS_ID = 12
local DEVOURER_SPEC_ID = 1480
local TRANSFORM_AURA_SPELL_ID = 1217607
local TRACKED_CAST_SPELL_ID = 1221150
local OUT_OF_COMBAT_ICON_ID = 1305156

local UIParent = _G.UIParent
local CreateFrame = _G.CreateFrame
local GetTime = _G.GetTime
local PlaySoundFile = _G.PlaySoundFile
local string_format = string.format
local math_floor = math.floor
local math_max = math.max

local LibCustomGlow = LibStub("LibCustomGlow-1.0", true)
local LSM = LibStub("LibSharedMedia-3.0", true)
local SOUND_ALERT_COUNT = 5

local function RegisterLayout()
    local layout = {
        { key = "header", type = "header", x = 2, y = 1, w = 52, h = 2, label = L["噬灭变身计时"], labelSize = 25 },
        { key = "locked", type = "checkbox", x = 2, y = 8, w = 10, h = 2, label = L["锁定位置"] },
        { key = "preview", type = "checkbox", x = 14, y = 8, w = 10, h = 2, label = L["预览"] },
        { key = "showCountText", type = "checkbox", x = 26, y = 8, w = 14, h = 2, label = L["显示次数"] },
        { key = "useOutOfCombatIcon", type = "checkbox", x = 2, y = 12, w = 18, h = 2, label = L["脱战触发时替换图标"] },
        { key = "onlyShowOutOfCombatTransform", type = "checkbox", x = 22, y = 12, w = 24, h = 2, label = L["只显示脱战后还有变身"] },
        { key = "activeIconMode", type = "dropdown", x = 2, y = 16, w = 18, h = 2, label = L["变身存在时"], items = { { L["高亮"], "高亮" }, { L["正常"], "正常" } } },
        { key = "inactiveIconMode", type = "dropdown", x = 23, y = 16, w = 18, h = 2, label = L["变身消失时"], items = { { L["褪色"], "褪色" }, { L["正常"], "正常" } } },
        { key = "timerIcon", type = "icongroup", x = 1, y = 20, w = 54, h = 28, label = L["变身图标"], labelSize = 20 },
        { key = "timerFont", type = "fontgroup", x = 1, y = 50, w = 54, h = 18, label = L["计时文字"], labelSize = 20 },
        { key = "countFont", type = "fontgroup", x = 1, y = 70, w = 54, h = 18, label = L["次数文字"], labelSize = 20 },
        { key = "timerGlow", type = "glow_settings", x = 1, y = 90, w = 54, h = 17, label = L["图标高亮"], labelSize = 20 },
    }

    layout[#layout + 1] = {
        key = "soundAlertHeader",
        type = "subheader",
        x = 1,
        y = 108,
        w = 54,
        h = 2,
        label = "定时音效",
        labelSize = 20,
    }
    layout[#layout + 1] = {
        key = "soundAlertDesc",
        type = "description",
        x = 2,
        y = 111,
        w = 54,
        h = 2,
        label = "变身开始后达到指定秒数时，播放对应音效。",
    }

    local baseY = 114
    for i = 1, SOUND_ALERT_COUNT do
        local rowY = baseY + ((i - 1) * 3)
        layout[#layout + 1] = {
            key = "soundAlert" .. i .. "Enabled",
            type = "checkbox",
            x = 2,
            y = rowY,
            w = 7,
            h = 2,
            label = string_format("启用%d", i),
        }
        layout[#layout + 1] = {
            key = "soundAlert" .. i .. "Second",
            type = "input",
            x = 11,
            y = rowY,
            w = 10,
            h = 2,
            label = "秒数",
            labelPos = "left",
        }
        layout[#layout + 1] = {
            key = "soundAlert" .. i .. "Sound",
            type = "lsm_sound",
            x = 24,
            y = rowY,
            w = 29,
            h = 2,
            label = "音效",
            labelPos = "left",
        }
    end

    ExwindTools:RegisterModuleLayout(EXWIND_MODULE_KEY, layout)
end

RegisterLayout()

-- 布局需要始终注册，方便在模块管理中看到并重新启用；
-- 运行逻辑则必须受模块总开关控制，否则会出现“模块页能关、功能实际关不掉”。
if not ExwindTools:IsModuleEnabled(EXWIND_MODULE_KEY) then
    return
end

local EX_DEFAULTS = {
    activeIconMode = "高亮",
    inactiveIconMode = "褪色",
    locked = true,
    preview = false,
    showCountText = true,
    useOutOfCombatIcon = false,
    onlyShowOutOfCombatTransform = false,
    timerGlowEnabled = true,
    timerGlowStyle = "Action Button Glow",
    timerGlowColorR = 1,
    timerGlowColorG = 0.82,
    timerGlowColorB = 0,
    timerGlowColorA = 1,
    timerGlowFrequency = 0.25,
    timerGlowLines = 8,
    timerGlowScale = 1,
    timerGlowOffset = 0,
    soundAlert1Enabled = false,
    soundAlert1Second = "",
    soundAlert1Sound = "None",
    soundAlert2Enabled = false,
    soundAlert2Second = "",
    soundAlert2Sound = "None",
    soundAlert3Enabled = false,
    soundAlert3Second = "",
    soundAlert3Sound = "None",
    soundAlert4Enabled = false,
    soundAlert4Second = "",
    soundAlert4Sound = "None",
    soundAlert5Enabled = false,
    soundAlert5Second = "",
    soundAlert5Sound = "None",
    timerIcon = {
        showIcon = true,
        iconID = 7135881,
        reverse = false,
        width = 46,
        height = 46,
        x = 0,
        y = 160,
    },
    timerFont = {
        a = 1,
        b = 0,
        font = "默认",
        g = 0.82,
        outline = "OUTLINE",
        r = 1,
        shadow = true,
        shadowX = 1,
        shadowY = -1,
        size = 24,
        x = 0,
        y = -6,
    },
    countFont = {
        a = 1,
        b = 0.82,
        font = "默认",
        g = 0.95,
        outline = "OUTLINE",
        r = 1,
        shadow = true,
        shadowX = 1,
        shadowY = -1,
        size = 16,
        x = 0,
        y = -4,
    },
}

local EX_DB = ExwindTools:GetModuleDB(EXWIND_MODULE_KEY, EX_DEFAULTS)

local timerFrame = nil
local transformActive = false
local hasTimerValue = false
local isEditModeActive = false
local isEditModeVisible = true
local startTime = 0
local elapsedSeconds = 0
local soundAlertTriggered = {}
local currentTransformCastCount = 0
local SyncTransformAuraState
local currentGlowSignature = nil
local isIconGlowActive = false

local function RefreshEditOverlay()
    if not timerFrame then return end

    if isEditModeActive and isEditModeVisible then
        ExwindTools:ShowExwindToolsEditOverlay(EXWIND_MODULE_KEY, timerFrame)
    else
        ExwindTools:HideExwindToolsEditOverlay(timerFrame)
    end
end

local function FormatTime(seconds)
    seconds = seconds or 0
    return string_format("%.1f", seconds)
end

local function FormatCastCountText(count)
    count = tonumber(count) or 0
    return string_format("%d", count)
end

local function ResetSoundAlertFlags()
    for i = 1, SOUND_ALERT_COUNT do
        soundAlertTriggered[i] = false
    end
end

local function GetSoundAlertSecond(index)
    local rawValue = EX_DB["soundAlert" .. index .. "Second"]
    local seconds = tonumber(rawValue)
    if not seconds or seconds <= 0 then
        return nil
    end

    return seconds
end

local function PlayConfiguredSoundAlert(index)
    if not LSM or not PlaySoundFile then return end

    local soundKey = EX_DB["soundAlert" .. index .. "Sound"]
    if type(soundKey) ~= "string" or soundKey == "" or soundKey == "None" then
        return
    end

    local soundPath = LSM:Fetch("sound", soundKey)
    if soundPath then
        PlaySoundFile(soundPath, "Master")
    end
end

local function CheckSoundAlerts(elapsed)
    if not transformActive then return end

    elapsed = elapsed or 0
    for i = 1, SOUND_ALERT_COUNT do
        if EX_DB["soundAlert" .. i .. "Enabled"] == true and soundAlertTriggered[i] ~= true then
            local triggerSecond = GetSoundAlertSecond(i)
            if triggerSecond and elapsed >= triggerSecond then
                soundAlertTriggered[i] = true
                PlayConfiguredSoundAlert(i)
            end
        end
    end
end

local function IsDevourerDemonHunterActive()
    local state = ExwindTools.State or {}
    return state.ClassID == DEMON_HUNTER_CLASS_ID and state.SpecID == DEVOURER_SPEC_ID
end

local function GetTimerIcon()
    local inCombat = ExwindTools.State and ExwindTools.State.InCombat
    if EX_DB.useOutOfCombatIcon == true and not EX_DB.preview and inCombat ~= true then
        return OUT_OF_COMBAT_ICON_ID
    end

    if EX_DB.timerIcon and EX_DB.timerIcon.iconID then
        return EX_DB.timerIcon.iconID
    end

    if _G.C_Spell and _G.C_Spell.GetSpellTexture then
        return _G.C_Spell.GetSpellTexture(TRANSFORM_AURA_SPELL_ID) or 236171
    end

    if _G.GetSpellTexture then
        return _G.GetSpellTexture(TRANSFORM_AURA_SPELL_ID) or 236171
    end

    return 236171
end

local function ShouldShowOnlyOutOfCombatTransform()
    local inCombat = ExwindTools.State and ExwindTools.State.InCombat
    return EX_DB.onlyShowOutOfCombatTransform == true
        and EX_DB.preview ~= true
        and EX_DB.useOutOfCombatIcon == true
        and inCombat ~= true
        and IsDevourerDemonHunterActive()
        and transformActive == true
end

local function StopIconGlow()
    if not timerFrame or not timerFrame.IconGlow or not LibCustomGlow then return end

    if LibCustomGlow.ButtonGlow_Stop then LibCustomGlow.ButtonGlow_Stop(timerFrame.IconGlow) end
    if LibCustomGlow.PixelGlow_Stop then LibCustomGlow.PixelGlow_Stop(timerFrame.IconGlow, "TransformTimer") end
    if LibCustomGlow.AutoCastGlow_Stop then LibCustomGlow.AutoCastGlow_Stop(timerFrame.IconGlow, "TransformTimer") end
    if LibCustomGlow.ProcGlow_Stop then LibCustomGlow.ProcGlow_Stop(timerFrame.IconGlow, "TransformTimer") end
    currentGlowSignature = nil
    isIconGlowActive = false
end

local function BuildGlowSignature()
    return table.concat({
        tostring(EX_DB.timerGlowEnabled),
        tostring(EX_DB.timerGlowStyle or "Action Button Glow"),
        tostring(EX_DB.timerGlowColorR or 1),
        tostring(EX_DB.timerGlowColorG or 0.82),
        tostring(EX_DB.timerGlowColorB or 0),
        tostring(EX_DB.timerGlowColorA or 1),
        tostring(EX_DB.timerGlowFrequency or 0.25),
        tostring(EX_DB.timerGlowLines or 8),
        tostring(EX_DB.timerGlowScale or 1),
        tostring(EX_DB.timerGlowOffset or 0),
    }, "|")
end

local function StartIconGlow()
    if not timerFrame or not timerFrame.IconGlow or not LibCustomGlow or not EX_DB.timerGlowEnabled then return end

    local glowSignature = BuildGlowSignature()
    if isIconGlowActive and currentGlowSignature == glowSignature then
        return
    end

    StopIconGlow()

    local color = {
        EX_DB.timerGlowColorR or 1,
        EX_DB.timerGlowColorG or 0.82,
        EX_DB.timerGlowColorB or 0,
        EX_DB.timerGlowColorA or 1,
    }
    local style = EX_DB.timerGlowStyle or "Action Button Glow"
    local frequency = EX_DB.timerGlowFrequency or 0.25
    local lines = EX_DB.timerGlowLines or 8
    local scale = EX_DB.timerGlowScale or 1
    local offset = EX_DB.timerGlowOffset or 0
    local frameLevel = timerFrame.IconGlow:GetFrameLevel() + 5

    if style == "Pixel Glow" and LibCustomGlow.PixelGlow_Start then
        LibCustomGlow.PixelGlow_Start(timerFrame.IconGlow, color, lines, frequency, 8, scale, offset, offset, true,
            "TransformTimer", frameLevel)
    elseif style == "Autocast Shine" and LibCustomGlow.AutoCastGlow_Start then
        LibCustomGlow.AutoCastGlow_Start(timerFrame.IconGlow, color, lines, frequency, scale, offset, offset,
            "TransformTimer", frameLevel)
    elseif style == "Proc Glow" and LibCustomGlow.ProcGlow_Start then
        LibCustomGlow.ProcGlow_Start(timerFrame.IconGlow, {
            key = "TransformTimer",
            color = color,
            startAnim = true,
            xOffset = offset,
            yOffset = offset,
        })
    elseif LibCustomGlow.ButtonGlow_Start then
        LibCustomGlow.ButtonGlow_Start(timerFrame.IconGlow, color, frequency, frameLevel)
    end

    currentGlowSignature = glowSignature
    isIconGlowActive = true
end

local function ApplyIconState()
    if not timerFrame or not timerFrame.Icon then return end

    if not timerFrame.Icon:IsShown() then
        StopIconGlow()
        return
    end

    local active = (transformActive and IsDevourerDemonHunterActive()) or EX_DB.preview
    local mode = active and (EX_DB.activeIconMode or "高亮") or (EX_DB.inactiveIconMode or "褪色")

    timerFrame.Icon:SetDesaturated(mode == "褪色")

    if mode == "高亮" then
        StartIconGlow()
    else
        StopIconGlow()
    end
end

local function UpdateCountText()
    if not timerFrame or not timerFrame.CountText then return end
    if EX_DB.showCountText ~= true then
        timerFrame.CountText:SetText("")
        return
    end

    local displayCount = currentTransformCastCount
    if EX_DB.preview and displayCount <= 0 then
        displayCount = 3
    end

    timerFrame.CountText:SetText(FormatCastCountText(displayCount))
end

local function UpdateText()
    if not timerFrame or not timerFrame.Text then return end

    if transformActive then
        elapsedSeconds = GetTime() - startTime
        CheckSoundAlerts(elapsedSeconds)
    elseif EX_DB.preview and not hasTimerValue then
        elapsedSeconds = 12.3
    end

    timerFrame.Text:SetText(FormatTime(elapsedSeconds))
    UpdateCountText()
end

local function ApplyStyle()
    if not timerFrame then return end

    local iconCfg = EX_DB.timerIcon or {}
    local fontCfg = EX_DB.timerFont or {}
    local countFontCfg = EX_DB.countFont or {}
    local width = iconCfg.width or 46
    local height = iconCfg.height or 46
    local showIcon = iconCfg.showIcon ~= false
    local showHandle = (isEditModeActive and isEditModeVisible) or
        ((not isEditModeActive) and (EX_DB.preview or (not EX_DB.locked)))

    timerFrame:SetSize(math_max(width, 140), height + 64)
    timerFrame:ClearAllPoints()
    timerFrame:SetPoint("CENTER", UIParent, "CENTER", iconCfg.x or 0, iconCfg.y or 160)

    timerFrame.Icon:SetSize(width, height)
    timerFrame.Icon:ClearAllPoints()
    timerFrame.Icon:SetPoint("TOP", timerFrame, "TOP", 0, 0)
    timerFrame.Icon:SetTexture(GetTimerIcon())
    timerFrame.Icon:SetShown(showIcon)

    timerFrame.IconGlow:SetSize(width, height)
    timerFrame.IconGlow:ClearAllPoints()
    timerFrame.IconGlow:SetPoint("CENTER", timerFrame.Icon, "CENTER")
    timerFrame.IconGlow:SetShown(showIcon)

    if EXDB and EXDB.ApplyFont then
        EXDB:ApplyFont(timerFrame.Text, fontCfg)
        EXDB:ApplyFont(timerFrame.CountText, countFontCfg)
    elseif _G.LibStub then
        local LSM = LibStub("LibSharedMedia-3.0")
        local fontPath = LSM and LSM:Fetch("font", fontCfg.font or "默认") or "Fonts\\FRIZQT__.TTF"
        timerFrame.Text:SetFont(fontPath, fontCfg.size or 24, fontCfg.outline or "OUTLINE")
        timerFrame.Text:SetTextColor(fontCfg.r or 1, fontCfg.g or 1, fontCfg.b or 1, fontCfg.a or 1)

        local countFontPath = LSM and LSM:Fetch("font", countFontCfg.font or "默认") or "Fonts\\FRIZQT__.TTF"
        timerFrame.CountText:SetFont(countFontPath, countFontCfg.size or 16, countFontCfg.outline or "OUTLINE")
        timerFrame.CountText:SetTextColor(countFontCfg.r or 1, countFontCfg.g or 1, countFontCfg.b or 1,
            countFontCfg.a or 1)
    end

    timerFrame.Text:ClearAllPoints()
    if showIcon then
        timerFrame.Text:SetPoint("TOP", timerFrame.Icon, "BOTTOM", fontCfg.x or 0, fontCfg.y or -6)
    else
        timerFrame.Text:SetPoint("CENTER", timerFrame, "CENTER", fontCfg.x or 0, fontCfg.y or 0)
    end
    timerFrame.Text:SetJustifyH("CENTER")

    timerFrame.CountText:ClearAllPoints()
    timerFrame.CountText:SetPoint("TOP", timerFrame.Text, "BOTTOM", countFontCfg.x or 0, countFontCfg.y or -4)
    timerFrame.CountText:SetJustifyH("CENTER")
    timerFrame.CountText:SetShown(EX_DB.showCountText == true)

    if showHandle then
        timerFrame:SetBackdropColor(0, 0.5, 0, 0.35)
        timerFrame:SetBackdropBorderColor(0, 1, 0, 0.8)
        timerFrame:EnableMouse(true)
    else
        timerFrame:SetBackdropColor(0, 0, 0, 0)
        timerFrame:SetBackdropBorderColor(0, 0, 0, 0)
        timerFrame:EnableMouse(false)
    end

    UpdateText()
    ApplyIconState()

    local shouldShow = (isEditModeActive and isEditModeVisible)
        or EX_DB.preview
        or (IsDevourerDemonHunterActive() and (transformActive or hasTimerValue))

    if EX_DB.onlyShowOutOfCombatTransform == true and not isEditModeActive and not EX_DB.preview then
        shouldShow = ShouldShowOnlyOutOfCombatTransform()
    end

    if shouldShow then
        timerFrame:Show()
    else
        timerFrame:Hide()
    end

    RefreshEditOverlay()
end

local function CreateTimerFrame()
    if timerFrame then return timerFrame end

    local f = CreateFrame("Frame", "ExTransformTimerFrame", UIParent, "BackdropTemplate")
    f:SetFrameStrata("MEDIUM")
    f:SetMovable(true)
    f:SetClampedToScreen(true)
    f:RegisterForDrag("LeftButton")
    f:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })

    f.Icon = f:CreateTexture(nil, "ARTWORK")
    f.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    f.IconGlow = CreateFrame("Frame", nil, f)
    f.IconGlow:SetFrameLevel(f:GetFrameLevel() + 3)
    f.IconGlow:EnableMouse(false)

    f.Text = f:CreateFontString(nil, "OVERLAY")
    f.Text:SetJustifyH("CENTER")

    f.CountText = f:CreateFontString(nil, "OVERLAY")
    f.CountText:SetJustifyH("CENTER")

    f:SetScript("OnDragStart", function(self)
        if (isEditModeActive and isEditModeVisible) or (not EX_DB.locked) or EX_DB.preview then
            self:StartMoving()
        end
    end)

    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()

        local cx, cy = UIParent:GetCenter()
        local sx, sy = self:GetCenter()
        if sx and sy and cx and cy then
            local scale = self:GetScale()
            EX_DB.timerIcon = EX_DB.timerIcon or {}
            EX_DB.timerIcon.x = math_floor(sx * scale - cx)
            EX_DB.timerIcon.y = math_floor(sy * scale - cy)

            if ExwindTools.UI and ExwindTools.UI.MainFrame and ExwindTools.UI.MainFrame:IsShown() then
                ExwindTools.UI:RefreshContent()
            end
        end
    end)

    timerFrame = f
    ExwindTools:RegisterHUD(EXWIND_MODULE_KEY, f)
    ApplyStyle()
    return f
end

local function StopTimer()
    if transformActive then
        elapsedSeconds = GetTime() - startTime
    end

    transformActive = false
    hasTimerValue = true
    ResetSoundAlertFlags()

    if timerFrame then
        timerFrame:SetScript("OnUpdate", nil)
        UpdateText()
        ApplyStyle()
    end
end

local function RefreshTalentEligibility()
    if IsDevourerDemonHunterActive() or EX_DB.preview then
        SyncTransformAuraState()
        ApplyStyle()
        return
    end

    transformActive = false
    hasTimerValue = false
    startTime = 0
    elapsedSeconds = 0
    currentTransformCastCount = 0
    ResetSoundAlertFlags()

    if timerFrame then
        timerFrame:SetScript("OnUpdate", nil)
        StopIconGlow()
        ApplyStyle()
    end
end

local function StartTimer()
    if not IsDevourerDemonHunterActive() then return end

    CreateTimerFrame()
    if not timerFrame then return end

    transformActive = true
    hasTimerValue = true
    startTime = GetTime()
    elapsedSeconds = 0
    ResetSoundAlertFlags()

    timerFrame:SetScript("OnUpdate", function()
        UpdateText()
    end)
    ApplyStyle()
end

local function RegisterTransformCast()
    if transformActive then
        currentTransformCastCount = (currentTransformCastCount or 0) + 1
        if timerFrame then
            UpdateCountText()
        end
        return
    end
end

local function GetPlayerTransformAura()
    if _G.C_UnitAuras and type(_G.C_UnitAuras.GetPlayerAuraBySpellID) == "function" then
        return _G.C_UnitAuras.GetPlayerAuraBySpellID(TRANSFORM_AURA_SPELL_ID)
    end

    return nil
end

SyncTransformAuraState = function()
    if EX_DB.preview then
        return
    end

    if not IsDevourerDemonHunterActive() then
        return
    end

    local aura = GetPlayerTransformAura()
    local hasAura = aura ~= nil

    if hasAura then
        if not transformActive then
            currentTransformCastCount = 0
            StartTimer()
        end
        return
    end

    if transformActive then
        StopTimer()
    elseif timerFrame and (hasTimerValue or EX_DB.preview) then
        ApplyStyle()
    end
end

local function ApplyEditModePresentation()
    CreateTimerFrame()
    if not timerFrame then
        return
    end

    if not isEditModeActive then
        ApplyStyle()
        return
    end

    if isEditModeVisible then
        timerFrame:Show()
        ApplyStyle()
    else
        timerFrame:Hide()
        RefreshEditOverlay()
    end
end

ExwindTools:WatchState(EXWIND_MODULE_KEY .. ".DatabaseChanged", EXWIND_MODULE_KEY, function(info)
    if not info or not info.key then return end

    if info.key == "preview" then
        if isEditModeActive then
            ApplyEditModePresentation()
        else
            if EX_DB.preview then
                CreateTimerFrame()
                ApplyStyle()
            else
                ApplyStyle()
            end
        end
        return
    end

    ApplyStyle()
end)

ExwindTools:WatchState("ClassID", EXWIND_MODULE_KEY, function()
    RefreshTalentEligibility()
end)

ExwindTools:WatchState("SpecID", EXWIND_MODULE_KEY, function()
    RefreshTalentEligibility()
end)

ExwindTools:WatchState("InCombat", EXWIND_MODULE_KEY, function(newValue, oldValue)
    if timerFrame and (transformActive or hasTimerValue or EX_DB.preview) then
        ApplyStyle()
    end
end)

ExwindTools:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", EXWIND_MODULE_KEY,
    function(_, unitTarget, castGUID, spellID, castBarID)
        if unitTarget ~= "player" then return end
        if not IsDevourerDemonHunterActive() then return end
        spellID = tonumber(spellID)

        if spellID == TRACKED_CAST_SPELL_ID and transformActive then
            RegisterTransformCast()
        end
    end)

ExwindTools:RegisterEvent("UNIT_AURA", EXWIND_MODULE_KEY, function(_, unitTarget)
    if unitTarget ~= "player" then return end
    if not IsDevourerDemonHunterActive() then return end

    SyncTransformAuraState()
end)

ExwindTools:RegisterEvent("PLAYER_ENTERING_WORLD", EXWIND_MODULE_KEY, function()
    EX_DB.preview = false
    currentTransformCastCount = 0
    ResetSoundAlertFlags()
    CreateTimerFrame()
    RefreshTalentEligibility()
    SyncTransformAuraState()
end)

ExwindTools:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", EXWIND_MODULE_KEY, function(_, unit)
    if unit == "player" then
        RefreshTalentEligibility()
    end
end)

ExwindTools:RegisterEvent("TRAIT_CONFIG_UPDATED", EXWIND_MODULE_KEY, function()
    RefreshTalentEligibility()
end)

ExwindTools:RegisterEditModeHandler(EXWIND_MODULE_KEY, {
    EnterEditMode = function()
        isEditModeActive = true
        CreateTimerFrame()
    end,
    ExitEditMode = function()
        isEditModeActive = false
        isEditModeVisible = true
        ApplyEditModePresentation()
        if ExwindTools.UI and ExwindTools.UI.MainFrame and ExwindTools.UI.MainFrame:IsShown() and ExwindTools.UI.RefreshContent then
            ExwindTools.UI:RefreshContent()
        end
    end,
    SetEditVisible = function(_, visible)
        isEditModeVisible = (visible == true)
        ApplyEditModePresentation()
        if ExwindTools.UI and ExwindTools.UI.MainFrame and ExwindTools.UI.MainFrame:IsShown() and ExwindTools.UI.RefreshContent then
            ExwindTools.UI:RefreshContent()
        end
    end,
})

ExwindTools:ReportReady(EXWIND_MODULE_KEY)
