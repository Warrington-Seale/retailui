-- =============================================================
-- [[ 玩家角色定位标记 >> ExTools.PlayerPosition ]]
-- =============================================================
local ExwindTools = _G.ExwindTools
local EXDB = _G.EXDB
if not ExwindTools then return end
local L = (ExwindTools and ExwindTools.L) or setmetatable({}, { __index = function(_, key) return key end })

local EXWIND_MODULE_KEY = "ExTools.PlayerPosition"
local isEditModeActive = false
local isEditModeVisible = true
local IndicatorFrame

local VIS_SHOW_IN_COMBAT = "show_in_combat"
local VIS_SHOW_OUT_OF_COMBAT = "show_out_of_combat"
local VIS_ONLY_IN_INSTANCE = "only_in_instance"

local VISIBILITY_OPTIONS = {
    { L["战斗中显示"], VIS_SHOW_IN_COMBAT },
    { L["战斗外显示"], VIS_SHOW_OUT_OF_COMBAT },
    { L["仅副本内"], VIS_ONLY_IN_INSTANCE },
}

local LEGACY_VISIBILITY_KEY_MAP = {
    ["战斗中显示"] = VIS_SHOW_IN_COMBAT,
    ["战斗外显示"] = VIS_SHOW_OUT_OF_COMBAT,
    ["仅副本内"] = VIS_ONLY_IN_INSTANCE,
}

local SPEC_OPTION_DEFS = {
    { specID = 71, className = "战士", specName = "武器", colorHex = "C79C6E" },
    { specID = 72, className = "战士", specName = "狂怒", colorHex = "C79C6E" },
    { specID = 73, className = "战士", specName = "防护", colorHex = "C79C6E" },
    { specID = 65, className = "圣骑士", specName = "神圣", colorHex = "F48CBA" },
    { specID = 66, className = "圣骑士", specName = "防护", colorHex = "F48CBA" },
    { specID = 70, className = "圣骑士", specName = "惩戒", colorHex = "F48CBA" },
    { specID = 253, className = "猎人", specName = "野兽控制", colorHex = "ABD473" },
    { specID = 254, className = "猎人", specName = "射击", colorHex = "ABD473" },
    { specID = 255, className = "猎人", specName = "生存", colorHex = "ABD473" },
    { specID = 259, className = "潜行者", specName = "奇袭", colorHex = "FFF468" },
    { specID = 260, className = "潜行者", specName = "狂徒", colorHex = "FFF468" },
    { specID = 261, className = "潜行者", specName = "敏锐", colorHex = "FFF468" },
    { specID = 256, className = "牧师", specName = "戒律", colorHex = "FFFFFF" },
    { specID = 257, className = "牧师", specName = "神圣", colorHex = "FFFFFF" },
    { specID = 258, className = "牧师", specName = "暗影", colorHex = "FFFFFF" },
    { specID = 250, className = "死亡骑士", specName = "鲜血", colorHex = "C41E3A" },
    { specID = 251, className = "死亡骑士", specName = "冰霜", colorHex = "C41E3A" },
    { specID = 252, className = "死亡骑士", specName = "邪恶", colorHex = "C41E3A" },
    { specID = 262, className = "萨满祭司", specName = "元素", colorHex = "0070DD" },
    { specID = 263, className = "萨满祭司", specName = "增强", colorHex = "0070DD" },
    { specID = 264, className = "萨满祭司", specName = "恢复", colorHex = "0070DD" },
    { specID = 62, className = "法师", specName = "奥术", colorHex = "3FC7EB" },
    { specID = 63, className = "法师", specName = "火焰", colorHex = "3FC7EB" },
    { specID = 64, className = "法师", specName = "冰霜", colorHex = "3FC7EB" },
    { specID = 265, className = "术士", specName = "痛苦", colorHex = "8788EE" },
    { specID = 266, className = "术士", specName = "恶魔学识", colorHex = "8788EE" },
    { specID = 267, className = "术士", specName = "毁灭", colorHex = "8788EE" },
    { specID = 268, className = "武僧", specName = "酒仙", colorHex = "00FF98" },
    { specID = 269, className = "武僧", specName = "踏风", colorHex = "00FF98" },
    { specID = 270, className = "武僧", specName = "织雾", colorHex = "00FF98" },
    { specID = 102, className = "德鲁伊", specName = "平衡", colorHex = "FF7C0A" },
    { specID = 103, className = "德鲁伊", specName = "野性", colorHex = "FF7C0A" },
    { specID = 104, className = "德鲁伊", specName = "守护", colorHex = "FF7C0A" },
    { specID = 105, className = "德鲁伊", specName = "恢复", colorHex = "FF7C0A" },
    { specID = 577, className = "恶魔猎手", specName = "浩劫", colorHex = "A330C9" },
    { specID = 581, className = "恶魔猎手", specName = "复仇", colorHex = "A330C9" },
    { specID = 1467, className = "唤魔师", specName = "湮灭", colorHex = "33937F" },
    { specID = 1468, className = "唤魔师", specName = "恩护", colorHex = "33937F" },
    { specID = 1473, className = "唤魔师", specName = "增辉", colorHex = "33937F" },
    { specID = 1480, className = "恶魔猎手", specName = "噬灭", colorHex = "A330C9" },
}

local LEGACY_SPEC_KEY_MAP = {}
local VALID_SPEC_KEYS = {}

local function GetSpecOptionValue(specID)
    return tostring(specID)
end

local function BuildSpecOptionLabel(def)
    return string.format("|cff%s%s|r - %s", def.colorHex, L[def.className] or def.className, L[def.specName] or def.specName)
end

local function BuildSpecOptions()
    local options = {}
    wipe(LEGACY_SPEC_KEY_MAP)
    wipe(VALID_SPEC_KEYS)

    for _, def in ipairs(SPEC_OPTION_DEFS) do
        local value = GetSpecOptionValue(def.specID)
        local legacyLabel = string.format("|cff%s%s|r - %s", def.colorHex, def.className, def.specName)
        options[#options + 1] = { BuildSpecOptionLabel(def), value }
        LEGACY_SPEC_KEY_MAP[legacyLabel] = value
        VALID_SPEC_KEYS[value] = true
    end

    return options
end

local SPEC_OPTIONS = BuildSpecOptions()

local function BuildDefaultVisibility()
    return {
        [VIS_SHOW_IN_COMBAT] = true,
        [VIS_SHOW_OUT_OF_COMBAT] = true,
        [VIS_ONLY_IN_INSTANCE] = true,
    }
end

local function BuildDefaultEnabledSpecs()
    local enabledSpecs = {}
    for _, def in ipairs(SPEC_OPTION_DEFS) do
        enabledSpecs[GetSpecOptionValue(def.specID)] = true
    end
    return enabledSpecs
end

local function NormalizeVisibilityConfig(source)
    local result = BuildDefaultVisibility()
    if type(source) ~= "table" then
        return result
    end

    for key, value in pairs(source) do
        local mappedKey = LEGACY_VISIBILITY_KEY_MAP[key] or key
        if result[mappedKey] ~= nil then
            result[mappedKey] = value and true or false
        end
    end

    return result
end

local function NormalizeEnabledSpecsConfig(source)
    local result = BuildDefaultEnabledSpecs()
    if type(source) ~= "table" then
        return result
    end

    for key, value in pairs(source) do
        local normalizedKey = LEGACY_SPEC_KEY_MAP[key] or (VALID_SPEC_KEYS[key] and key or nil)
        if normalizedKey then
            result[normalizedKey] = value and true or false
        end
    end

    return result
end

local function RefreshEditOverlay()
    if isEditModeActive and isEditModeVisible then
        ExwindTools:ShowExwindToolsEditOverlay(EXWIND_MODULE_KEY, IndicatorFrame)
    else
        ExwindTools:HideExwindToolsEditOverlay(IndicatorFrame)
    end
end

-- =============================================================
-- 1. Grid 布局定义
-- =============================================================
local function EX_RegisterLayout()
    local layout = {
        { key = "head", type = "header", x = 1, y = 1, w = 50, h = 2, label = L["玩家角色定位标记"], labelSize = 25 },
        { key = "desc", type = "description", x = 1, y = 4, w = 50, h = 2, label = L["优先加载本地材质(PNG)。若文件缺失，自动回退到纯代码绘图模式。"] },

        -- 基础
        { key = "div1", type = "divider", x = 1, y = 6, w = 50, h = 1 },
        { key = "enabled", type = "checkbox", x = 1, y = 8, w = 20, h = 2, label = L["启用指示器"] },
        {
            key = "shapeType",
            type = "dropdown",
            x = 1,
            y = 13,
            w = 20,
            h = 2,
            label = L["图形样式"],
            items = {
                { L["方块 (Square)"], "SQUARE" },
                { L["十字 (Cross)"], "CROSS" },
                { L["圆形 (Circle)"], "CIRCLE" },
                { L["圆环 (Ring)"], "RING" },
                { L["菱形 (Diamond)"], "DIAMOND" },
            }
        },

        { key = "scale", type = "slider", x = 21, y = 13, w = 19, h = 2, label = L["缩放"], min = 0.1, max = 1.5, step = 0.1 },
        { key = "color", type = "color", x = 18, y = 27, w = 12, h = 2, label = L["正常颜色"] },

        -- 偏移
        { key = "offsetX", type = "slider", x = 1, y = 17, w = 20, h = 2, label = L["X 轴偏移"], min = -500, max = 500, step = 1 },
        { key = "offsetY", type = "slider", x = 21, y = 17, w = 19, h = 2, label = L["Y 轴偏移"], min = -500, max = 500, step = 1 },

        -- 距离监控
        { key = "div_range", type = "divider", x = 1, y = 22, w = 50, h = 1 },
        { key = "h_range", type = "subheader", x = 1, y = 20, w = 50, h = 2, label = L["距离监控"], labelSize = 20 },
        { key = "desc_range", type = "description", x = 1, y = 23, w = 50, h = 2, label = L["当超出距离时 图标变色 (空=自动使用专精预设)"] },

        { key = "rangeSpell", type = "input", x = 1, y = 27, w = 15, h = 2, label = L["距离判定法术(ID)"], placeholder = L["默认: 专精预设"] },
        { key = "rangeColor", type = "color", x = 33, y = 27, w = 12, h = 2, label = L["超距颜色"] },

        -- 显示条件
        { key = "div2", type = "divider", x = 1, y = 33, w = 50, h = 1 },
        { key = "h_vis", type = "subheader", x = 1, y = 31, w = 50, h = 2, label = L["显示条件"], labelSize = 20 },
        {
            key = "visibility",
            type = "multiselect",
            x = 1,
            y = 36,
            w = 25,
            h = 2,
            label = L["触发场景"],
            items = VISIBILITY_OPTIONS
        },

        { key = "h_specs", type = "subheader", x = 1, y = 40, w = 50, h = 2, label = L["专精过滤 (仅在勾选的专精下启用)"] },
        {
            key = "enabledSpecs",
            type = "multiselect",
            x = 1,
            y = 44,
            w = 51,
            h = 2,
            label = L["启用专精"],
            items = SPEC_OPTIONS
        },
    }
    ExwindTools:RegisterModuleLayout(EXWIND_MODULE_KEY, layout)
end
EX_RegisterLayout()

if not ExwindTools:IsModuleEnabled(EXWIND_MODULE_KEY) then return end

-- =============================================================
-- 2. 数据初始化
-- =============================================================
local EX_DEFAULTS = {
    enabled = false,
    shapeType = "CROSS",
    scale = 0.5,
    offsetX = 0,
    offsetY = 0,

    colorR = 0.15,
    colorG = 1,
    colorB = 0.25,
    colorA = 1,

    rangeSpell = "",
    rangeColorR = 1,
    rangeColorG = 0,
    rangeColorB = 0,
    rangeColorA = 1,

    visibility = BuildDefaultVisibility(),
    enabledSpecs = BuildDefaultEnabledSpecs(),
}
local EX_DB = ExwindTools:GetModuleDB(EXWIND_MODULE_KEY, EX_DEFAULTS)
EX_DB.visibility = NormalizeVisibilityConfig(EX_DB.visibility)
EX_DB.enabledSpecs = NormalizeEnabledSpecsConfig(EX_DB.enabledSpecs)

-- =============================================================
-- 3. 核心业务逻辑
-- =============================================================
IndicatorFrame = CreateFrame("Frame", "ExwindPlayerPositionIndicator", UIParent)
IndicatorFrame:SetFrameStrata("MEDIUM") -- [v1.1 Fix] 降低层级，避免覆盖过多界面元素
IndicatorFrame:SetSize(64, 64)
IndicatorFrame:SetIgnoreParentAlpha(true)
IndicatorFrame:SetMovable(true)
IndicatorFrame:SetClampedToScreen(true)
IndicatorFrame:RegisterForDrag("LeftButton")
ExwindTools:RegisterHUD(EXWIND_MODULE_KEY, IndicatorFrame)
-- RegisterHUD 内部会强制 EnableMouse(true)，在其之后再次关闭以实现点击穿透
IndicatorFrame:EnableMouse(false)
IndicatorFrame.textures = {}
IndicatorFrame:Hide()
IndicatorFrame:SetScript("OnDragStart", function(self)
    if not isEditModeActive then
        return
    end
    self:StartMoving()
end)
IndicatorFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local frameCenterX, frameCenterY = self:GetCenter()
    local uiCenterX, uiCenterY = UIParent:GetCenter()
    if frameCenterX and frameCenterY and uiCenterX and uiCenterY then
        EX_DB.offsetX = math.floor(frameCenterX - uiCenterX + 0.5)
        EX_DB.offsetY = math.floor(frameCenterY - uiCenterY + 0.5)
    end
end)

local TEXTURE_PATHS = {
    ["SQUARE"] = "Interface\\AddOns\\ExwindTools\\Textures\\PlayerPosition\\Square.png",
    ["CROSS"] = "Interface\\AddOns\\ExwindTools\\Textures\\PlayerPosition\\Cross.png",
    ["CIRCLE"] = "Interface\\AddOns\\ExwindTools\\Textures\\PlayerPosition\\Circle.png",
    ["RING"] = "Interface\\AddOns\\ExwindTools\\Textures\\PlayerPosition\\Ring.png",
    ["DIAMOND"] = "Interface\\AddOns\\ExwindTools\\Textures\\PlayerPosition\\Diamond.png",
}

-- 获取或创建 Texture
local function GetTex(idx)
    if not IndicatorFrame.textures[idx] then
        IndicatorFrame.textures[idx] = IndicatorFrame:CreateTexture(nil, "ARTWORK")
    end
    local t = IndicatorFrame.textures[idx]
    t:ClearAllPoints()
    t:SetTexCoord(0, 1, 0, 1)
    t:Show()
    t:SetRotation(0)
    return t
end

-- 绘制图形
local function DrawShape(shape)
    for _, tex in ipairs(IndicatorFrame.textures) do tex:Hide() end
    local w, h = IndicatorFrame:GetSize()

    local path = TEXTURE_PATHS[shape]
    if path then
        local t = GetTex(1); t:SetAllPoints()
        if t:SetTexture(path) then return end -- Success
    end

    -- Fallback: Code Drawing
    if shape == "SQUARE" then
        local t = GetTex(1); t:SetAllPoints(); t:SetColorTexture(1, 1, 1, 1)
    elseif shape == "CROSS" then
        local thickness = 0.125
        local t1 = GetTex(1); t1:SetPoint("CENTER"); t1:SetSize(w * thickness, h); t1:SetColorTexture(1, 1, 1, 1)
        local t2 = GetTex(2); t2:SetPoint("CENTER"); t2:SetSize(w, h * thickness); t2:SetColorTexture(1, 1, 1, 1)
    elseif shape == "DIAMOND" then
        local t = GetTex(1); t:SetSize(w * 0.707, h * 0.707); t:SetPoint("CENTER"); t:SetColorTexture(1, 1, 1, 1); t
            :SetRotation(math.rad(45))
    else
        local t = GetTex(1); t:SetAllPoints(); t:SetColorTexture(1, 1, 1, 1)
    end
end

-- 获取当前生效的 Range 监控法术
local function GetRangeSpell()
    -- 1. 优先使用用户手动输入的
    local userSpell = EX_DB.rangeSpell
    if userSpell and userSpell ~= "" then
        -- Try number conversion
        local spellID = tonumber(userSpell)
        return spellID or userSpell
    end

    -- 2. 尝试获取专精预设
    if ExwindTools.State and ExwindTools.DB_Static then
        local specID = ExwindTools.State.SpecID
        if specID and specID > 0 and ExwindTools.DB_Static.SpecByID then
            local specInfo = ExwindTools.DB_Static.SpecByID[specID]
            if specInfo and specInfo.RangeSpell then
                return specInfo.RangeSpell
            end
        end
    end

    return nil
end

-- 颜色更新 logic (Range Check)
local function UpdateColor()
    local r, g, b, a = EX_DB.colorR or 1, EX_DB.colorG or 1, EX_DB.colorB or 1, EX_DB.colorA or 1

    -- Range Check Logic
    local spell = GetRangeSpell()
    if spell and UnitExists("target") then
        local inRange = C_Spell.IsSpellInRange(spell, "target")
        if inRange == false then
            -- Out of Range
            r, g, b, a = EX_DB.rangeColorR or 1, EX_DB.rangeColorG or 0, EX_DB.rangeColorB or 0, EX_DB.rangeColorA or 1
        end
    end

    for _, t in ipairs(IndicatorFrame.textures) do
        if t:IsShown() then t:SetVertexColor(r, g, b, a) end
    end
end

-- OnUpdate Loop
local throttle = 0
IndicatorFrame:SetScript("OnUpdate", function(self, elapsed)
    throttle = throttle + elapsed
    if throttle > 0.1 then
        UpdateColor()
        throttle = 0
    end
end)

-- Visibility logic
local function UpdateIndicatorVisibility()
    if isEditModeActive then
        if isEditModeVisible then
            IndicatorFrame:Show()
            IndicatorFrame:EnableMouse(true)
        else
            IndicatorFrame:Hide()
            IndicatorFrame:EnableMouse(false)
        end
        RefreshEditOverlay()
        return
    end

    if not EX_DB.enabled then
        IndicatorFrame:Hide()
        IndicatorFrame:EnableMouse(false)
        RefreshEditOverlay()
        return
    end

    local inInstance = ExwindTools.State.InInstance
    if EX_DB.visibility[VIS_ONLY_IN_INSTANCE] and not inInstance then
        IndicatorFrame:Hide()
        IndicatorFrame:EnableMouse(false)
        RefreshEditOverlay()
        return
    end

    local specID = tonumber(ExwindTools.State.SpecID) or 0
    local specKey = specID > 0 and GetSpecOptionValue(specID) or nil
    if specKey and EX_DB.enabledSpecs and EX_DB.enabledSpecs[specKey] == false then
        IndicatorFrame:Hide()
        IndicatorFrame:EnableMouse(false)
        RefreshEditOverlay()
        return
    end

    local show = ExwindTools.State.InCombat and EX_DB.visibility[VIS_SHOW_IN_COMBAT] or EX_DB.visibility[VIS_SHOW_OUT_OF_COMBAT]
    IndicatorFrame:EnableMouse(false)
    if show then IndicatorFrame:Show() else IndicatorFrame:Hide() end
    RefreshEditOverlay()
end

-- Main Refresh
local function RefreshIndicator()
    IndicatorFrame:ClearAllPoints()
    IndicatorFrame:SetPoint("CENTER", UIParent, "CENTER", EX_DB.offsetX, EX_DB.offsetY)
    IndicatorFrame:SetScale(EX_DB.scale or 1)

    DrawShape(EX_DB.shapeType or "SQUARE")
    UpdateColor()
    UpdateIndicatorVisibility()
end

-- Events
ExwindTools:WatchState("InCombat", EXWIND_MODULE_KEY, UpdateIndicatorVisibility)
ExwindTools:WatchState("InInstance", EXWIND_MODULE_KEY, UpdateIndicatorVisibility)
ExwindTools:WatchState(EXWIND_MODULE_KEY .. ".DatabaseChanged", EXWIND_MODULE_KEY, RefreshIndicator)

-- Spec Change Event (Since we filter by spec)
ExwindTools:WatchState("SpecID", EXWIND_MODULE_KEY, UpdateIndicatorVisibility)

-- Init
C_Timer.After(1, function()
    RefreshIndicator()
    local current = GetRangeSpell() or L["无"]
    -- print("|cff00ff00[ExwindTools] PlayerPosition: Ready (RangeSpell: "..tostring(current)..")|r")
end)

ExwindTools:RegisterEditModeHandler(EXWIND_MODULE_KEY, {
    EnterEditMode = function()
        isEditModeActive = true
        isEditModeVisible = true
        RefreshIndicator()
    end,
    ExitEditMode = function()
        isEditModeActive = false
        isEditModeVisible = true
        RefreshIndicator()
    end,
    SetEditVisible = function(_, visible)
        isEditModeVisible = (visible ~= false)
        RefreshIndicator()
    end,
})

ExwindTools:ReportReady(EXWIND_MODULE_KEY)
