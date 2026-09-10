-- =============================================================
-- [[ 微型选单 ]]
-- { Key = "ExTools.MicroMenu", Name = "微型选单", Desc = "顶端微型选单：中间显示时间，左右各有可配置的面板快捷图标。", Category = 1 },
-- =============================================================
local ondev = true
if ondev then
    return
end

local ExwindTools = _G.ExwindTools
local EXDB = _G.EXDB
if not ExwindTools then return end
local L = (ExwindTools and ExwindTools.L) or setmetatable({}, { __index = function(_, key) return key end })

local EXWIND_MODULE_KEY = "ExTools.MicroMenu"
local PREVIEW_RENDERER_KEY = EXWIND_MODULE_KEY .. ".Preview"
local MAX_SLOTS = 10
local CUSTOM_ICON_MAX = 111
local EX_DB
local GetActionLabel
local NormalizeThemeId

local function IsCombatRestricted()
    local state = ExwindTools and ExwindTools.State
    if state and state.InCombat == true then
        return true
    end
    return InCombatLockdown and InCombatLockdown() or false
end

-- =============================================================
-- 动作定义
-- =============================================================
local ACTION_LIST = {
    { id = "none", label = "（无）", atlas = nil },
    {
        id = "character",
        label = "角色",
        atlas = "UI-HUD-MicroMenu-Portrait-Shadow",
        action = function()
            ToggleCharacter("PaperDollFrame")
        end
    },
    {
        id = "professions",
        label = "专业技能",
        atlas = "UI-HUD-MicroMenu-Professions-Up",
        action = function()
            ToggleProfessionsBook()
        end
    },
    {
        id = "spellbook",
        label = "法术书/天赋",
        atlas = "UI-HUD-MicroMenu-SpecTalents-Up",
        action = function()
            TogglePlayerSpellsFrame()
        end
    },
    {
        id = "achievement",
        label = "成就",
        atlas = "UI-HUD-MicroMenu-Achievements-Up",
        action = function()
            ToggleAchievementFrame()
        end
    },
    { id = "questlog", label = "任务日志", atlas = "UI-HUD-MicroMenu-Questlog-Up", action = function() ToggleQuestLog() end },
    {
        id = "housing",
        label = "家园",
        atlas = "UI-HUD-MicroMenu-Housing-Up",
        action = function()
            HousingFramesUtil.ToggleHousingDashboard()
        end
    },
    { id = "guild", label = "公会/社区", atlas = "UI-HUD-MicroMenu-GuildCommunities-Up", action = function() ToggleGuildFrame() end },
    { id = "lfg", label = "寻求组队", atlas = "UI-HUD-MicroMenu-Groupfinder-Up", action = function() ToggleLFDParentFrame() end },
    {
        id = "collections",
        label = "收藏",
        atlas = "UI-HUD-MicroMenu-Collections-Up",
        action = function()
            ToggleCollectionsJournal()
        end
    },
    { id = "ej", label = "冒险指南", atlas = "UI-HUD-MicroMenu-AdventureGuide-Up", action = function() ToggleEncounterJournal() end },
    {
        id = "store",
        label = "商城",
        atlas = "UI-HUD-MicroMenu-Shop-Up",
        action = function()
            if ToggleStoreUI then
                ToggleStoreUI("StoreMicroButton")
            end
        end
    },
    {
        id = "mainmenu",
        label = "主菜单",
        atlas = "UI-HUD-MicroMenu-GameMenu-Up",
        action = function()
            if IsCombatRestricted() then
                return
            end
            ToggleGameMenu()
        end
    },
    {
        id = "cooldownmanager",
        label = "冷却管理器",
        atlas = "icon_cooldownmanager",
        action = function()
            if not CooldownViewerSettings and UIParentLoadAddOn then
                UIParentLoadAddOn("Blizzard_CooldownViewer")
            end
            if CooldownViewerSettings and CooldownViewerSettings.TogglePanel then
                CooldownViewerSettings:TogglePanel()
            end
        end
    },
    { id = "custom", label = "自定义命令", atlas = "UI-HUD-MicroMenu-GameMenu-Up", action = nil },
}

local ACTION_BY_ID = {}
local ACTION_LABEL_TO_ID = {}
for _, actionDef in ipairs(ACTION_LIST) do
    ACTION_BY_ID[actionDef.id] = actionDef
    if actionDef.atlas then
        ACTION_LABEL_TO_ID[CreateAtlasMarkup(actionDef.atlas, 16, 16) .. " " .. actionDef.label] = actionDef.id
    end
    ACTION_LABEL_TO_ID[actionDef.label] = actionDef.id
    ACTION_LABEL_TO_ID[actionDef.id] = actionDef.id
end

local function BuildActionDropdownItems()
    local items = {}
    for _, actionDef in ipairs(ACTION_LIST) do
        local text = actionDef.label
        if actionDef.atlas then
            text = CreateAtlasMarkup(actionDef.atlas, 16, 16) .. " " .. actionDef.label
        end
        items[#items + 1] = { text, actionDef.id }
    end
    return items
end

ExwindTools.GetMicroMenuActionItems = BuildActionDropdownItems

-- =============================================================
-- 图标主题
-- =============================================================
local BLIZZARD_ICON_IDS = {
    "character", "professions", "spellbook", "achievement",
    "questlog", "housing", "guild", "lfg",
    "collections", "ej", "store", "mainmenu",
    "cooldownmanager", "custom",
}

local ADDON_PATH = "Interface\\AddOns\\ExwindTools\\Textures\\Icons\\"
local ICON_THEMES = {
    {
        id = "blizzard",
        name = "暴雪原版",
        type = "blizzard",
    },
    {
        id = "custom",
        name = "自定义图库",
        type = "custom",
        path = ADDON_PATH .. "custom\\",
        fallbackPath = ADDON_PATH .. "cyberpunk\\",
    },
}

local THEME_BY_ID = {}
local THEME_NAME_TO_ID = {}
for _, theme in ipairs(ICON_THEMES) do
    THEME_BY_ID[theme.id] = theme
    THEME_NAME_TO_ID[theme.name] = theme.id
    THEME_NAME_TO_ID[theme.id] = theme.id
end
THEME_NAME_TO_ID["cyberpunk"] = "custom"

local function ResolveThemeForStoredIcon(themeId, iconId)
    return THEME_BY_ID[NormalizeThemeId(themeId)] or THEME_BY_ID.blizzard
end

local IconTextureProbe = nil

local function GetIconTextureProbe()
    if IconTextureProbe then
        return IconTextureProbe
    end

    local probeFrame = CreateFrame("Frame", nil, UIParent)
    probeFrame:Hide()
    IconTextureProbe = probeFrame:CreateTexture(nil, "ARTWORK")
    return IconTextureProbe
end

local function CanLoadCustomTexture(path)
    if type(path) ~= "string" or path == "" then
        return false
    end

    local probe = GetIconTextureProbe()
    probe:SetTexture(nil)
    local ok = probe:SetTexture(path)
    probe:SetTexture(nil)
    return ok == true
end

local function ResolveCustomTexturePath(theme, iconId)
    if not theme or theme.type ~= "custom" or not iconId or iconId == "" then
        return nil
    end

    local primaryPath = theme.path .. iconId .. ".tga"
    if CanLoadCustomTexture(primaryPath) then
        return primaryPath
    end

    if type(theme.fallbackPath) == "string" and theme.fallbackPath ~= "" then
        local fallbackPath = theme.fallbackPath .. iconId .. ".tga"
        if CanLoadCustomTexture(fallbackPath) then
            return fallbackPath
        end
    end

    return primaryPath
end

local function BuildIconPickerChoices()
    local choices = {}

    for _, iconId in ipairs(BLIZZARD_ICON_IDS) do
        local actionDef = ACTION_BY_ID[iconId]
        if actionDef and actionDef.atlas then
            choices[#choices + 1] = {
                themeId = "blizzard",
                iconId = iconId,
                label = GetActionLabel(iconId),
                themeName = THEME_BY_ID.blizzard.name,
            }
        end
    end

    for _, theme in ipairs(ICON_THEMES) do
        if theme.type == "custom" then
            for i = 1, CUSTOM_ICON_MAX do
                local iconId = tostring(i)
                local texturePath = ResolveCustomTexturePath(theme, iconId)
                if texturePath and CanLoadCustomTexture(texturePath) then
                    choices[#choices + 1] = {
                        themeId = theme.id,
                        iconId = iconId,
                        label = "图标 " .. iconId,
                        themeName = theme.name,
                    }
                end
            end
        end
    end

    return choices
end

local function BuildThemeDropdownItems()
    local items = {}
    for _, theme in ipairs(ICON_THEMES) do
        items[#items + 1] = { theme.name, theme.id }
    end
    return items
end

ExwindTools.GetMicroMenuThemeItems = BuildThemeDropdownItems

local DEFAULT_LEFT_ACTIONS = {
    "character", "questlog", "achievement", "lfg", "guild",
    "none", "none", "none", "none", "none",
}

local DEFAULT_RIGHT_ACTIONS = {
    "spellbook", "professions", "collections", "ej", "housing",
    "none", "none", "none", "none", "none",
}

local function CreateDefaultSlot(primaryAction)
    return {
        icon = "",
        tooltip = "",
        leftClick = {
            action = primaryAction or "none",
            cmd = "",
        },
        rightClick = {
            action = "none",
            cmd = "",
        },
    }
end

local function CreateDefaultSlotList(defaultActions)
    local slots = {}
    for i = 1, MAX_SLOTS do
        slots[i] = CreateDefaultSlot(defaultActions[i] or "none")
    end
    return slots
end

local EX_DEFAULTS = {
    schemaVersion = 2,
    enabled = true,
    locked = true,
    iconSize = 28,
    barScale = 1.0,
    showBackground = true,
    bgAlpha = 0.6,
    timeFormat = "24小时制",
    showSeconds = false,
    posX = 0,
    posY = 0,
    posAnchor = "TOP",

    timeFontSize = 0,
    timeOffsetX = 0,
    timeOffsetY = 0,

    iconTheme = "blizzard",

    leftCount = 5,
    rightCount = 5,

    selectedSlotSide = "left",
    selectedSlotIndex = 1,

    slots = {
        left = CreateDefaultSlotList(DEFAULT_LEFT_ACTIONS),
        right = CreateDefaultSlotList(DEFAULT_RIGHT_ACTIONS),
    },
}

local function BuildSlotPath(side, index)
    return "slots." .. side .. "." .. index
end

local function BuildSelectedSlotTitle(side, index)
    return (side == "right" and L["右"] or L["左"]) .. index
end

local function BuildSlotEditorItems(selectedSide, selectedIndex)
    local slotPath = BuildSlotPath(selectedSide or "left", selectedIndex or 1)
    local slot
    if EX_DB and type(EX_DB.slots) == "table" and type(EX_DB.slots[selectedSide or "left"]) == "table" then
        slot = EX_DB.slots[selectedSide or "left"][selectedIndex or 1]
    end

    local leftAction = type(slot) == "table" and type(slot.leftClick) == "table" and slot.leftClick.action or "none"
    local rightAction = type(slot) == "table" and type(slot.rightClick) == "table" and slot.rightClick.action or "none"
    local leftIsCustom = leftAction == "custom"
    local rightIsCustom = rightAction == "custom"

    local children = {
        {
            key = "left_action",
            parentKey = slotPath,
            subKey = "leftClick.action",
            type = "dropdown",
            x = 1,
            y = 67,
            w = leftIsCustom and 24 or 50,
            h = 2,
            label = "左键点击",
            items = "func:ExwindTools.GetMicroMenuActionItems"
        },
        {
            key = "right_action",
            parentKey = slotPath,
            subKey = "rightClick.action",
            type = "dropdown",
            x = 1,
            y = 71,
            w = rightIsCustom and 24 or 50,
            h = 2,
            label = "右键点击",
            items = "func:ExwindTools.GetMicroMenuActionItems"
        },
    }

    if leftIsCustom then
        children[#children + 1] = {
            key = "left_cmd",
            parentKey = slotPath,
            subKey = "leftClick.cmd",
            type = "input",
            x = 27,
            y = 67,
            w = 24,
            h = 2,
            label = "左键命令",
            placeholder = "/target boss1"
        }
    end

    if rightIsCustom then
        children[#children + 1] = {
            key = "right_cmd",
            parentKey = slotPath,
            subKey = "rightClick.cmd",
            type = "input",
            x = 27,
            y = 71,
            w = 24,
            h = 2,
            label = "右键命令",
            placeholder = "/focus mouseover"
        }
    end

    return children
end

local function BuildLayout(selectedSide, selectedIndex)
    local currentSide = EX_DB and EX_DB.selectedSlotSide or selectedSide or "left"
    local currentIndex = EX_DB and EX_DB.selectedSlotIndex or selectedIndex or 1
    local selectedTitle = BuildSelectedSlotTitle(currentSide, currentIndex)
    local layout = {
        { key = "header", type = "header", x = 1, y = 1, w = 50, h = 2, label = "微型选单" },
        {
            key = "desc",
            type = "description",
            x = 1,
            y = 3,
            w = 50,
            h = 2,
            label = "顶端微型选单：上方预览直接选中槽位，下方只编辑当前槽位。"
        },

        { key = "div_basic", type = "divider", x = 1, y = 6, w = 50, h = 1 },
        { key = "sh_basic", type = "subheader", x = 1, y = 7, w = 50, h = 1, label = "基础设置" },

        { key = "enabled", type = "checkbox", x = 1, y = 9, w = 8, h = 2, label = "启用" },
        { key = "locked", type = "checkbox", x = 10, y = 9, w = 8, h = 2, label = "锁定位置" },
        { key = "showBackground", type = "checkbox", x = 19, y = 9, w = 8, h = 2, label = "显示背景" },

        { key = "iconSize", type = "slider", x = 1, y = 12, w = 16, h = 2, label = "图标大小", min = 16, max = 64, step = 1 },
        { key = "barScale", type = "slider", x = 19, y = 12, w = 16, h = 2, label = "整体缩放", min = 0.5, max = 2.0, step = 0.05 },
        { key = "bgAlpha", type = "slider", x = 36, y = 12, w = 14, h = 2, label = "背景透明度", min = 0, max = 1, step = 0.05 },

        { key = "div_theme", type = "divider", x = 1, y = 15, w = 50, h = 1 },
        { key = "sh_theme", type = "subheader", x = 1, y = 16, w = 50, h = 1, label = "图标风格" },
        { key = "iconTheme", type = "dropdown", x = 1, y = 18, w = 16, h = 2, label = "整体风格", items = "func:ExwindTools.GetMicroMenuThemeItems" },
        { key = "leftCount", type = "slider", x = 19, y = 18, w = 14, h = 2, label = "左侧数量", min = 0, max = MAX_SLOTS, step = 1 },
        { key = "rightCount", type = "slider", x = 35, y = 18, w = 14, h = 2, label = "右侧数量", min = 0, max = MAX_SLOTS, step = 1 },

        { key = "div_time", type = "divider", x = 1, y = 21, w = 50, h = 1 },
        { key = "sh_time", type = "subheader", x = 1, y = 22, w = 50, h = 1, label = "时间文字" },
        { key = "timeFormat", type = "dropdown", x = 1, y = 24, w = 16, h = 2, label = "时间格式", items = "24小时制:24小时制,12小时制:12小时制" },
        { key = "showSeconds", type = "checkbox", x = 19, y = 24, w = 8, h = 2, label = "显示秒数" },
        { key = "timeFontSize", type = "slider", x = 28, y = 24, w = 12, h = 2, label = "字体大小（0=自动）", min = 0, max = 36, step = 1 },
        { key = "timeOffsetX", type = "slider", x = 1, y = 27, w = 16, h = 2, label = "时间 X 偏移", min = -200, max = 200, step = 1 },
        { key = "timeOffsetY", type = "slider", x = 19, y = 27, w = 16, h = 2, label = "时间 Y 偏移", min = -50, max = 50, step = 1 },

        { key = "div_pos", type = "divider", x = 1, y = 30, w = 50, h = 1 },
        { key = "sh_pos", type = "subheader", x = 1, y = 31, w = 50, h = 1, label = "位置" },
        { key = "posAnchor", type = "dropdown", x = 1, y = 33, w = 20, h = 2, label = "锚点", items = "TOP:TOP,TOPLEFT:TOPLEFT,TOPRIGHT:TOPRIGHT,CENTER:CENTER,BOTTOM:BOTTOM" },
        { key = "posX", type = "slider", x = 22, y = 33, w = 14, h = 2, label = "X 偏移", min = -1000, max = 1000, step = 1 },
        { key = "posY", type = "slider", x = 37, y = 33, w = 13, h = 2, label = "Y 偏移", min = -600, max = 600, step = 1 },
        { key = "btn_reset_pos", type = "button", x = 1, y = 36, w = 12, h = 2, label = "重置位置" },

        { key = "div_preview", type = "divider", x = 1, y = 39, w = 50, h = 1 },
        { key = "sh_preview", type = "subheader", x = 1, y = 40, w = 50, h = 1, label = "槽位预览" },
        { key = "slotPreview", type = "custom", renderer = PREVIEW_RENDERER_KEY, x = 1, y = 42, w = 50, h = 10 },
        { key = "preview_hint", type = "description", x = 1, y = 53, w = 50, h = 2, label = "点击上方图标选择要编辑的槽位；下方设置只作用于当前槽位。" },

        { key = "div_slot", type = "divider", x = 1, y = 56, w = 50, h = 1 },
        { key = "sh_slot", type = "subheader", x = 1, y = 57, w = 50, h = 1, label = "当前槽位：" .. selectedTitle },
        { key = "slot_desc", type = "description", x = 1, y = 59, w = 50, h = 2, label = "图标、左键与右键动作分别独立设置；悬浮提示固定显示左右键动作。" },
        { key = "btn_select_icon", type = "button", x = 1, y = 62, w = 11, h = 2, label = "选择图案" },
    }

    for _, item in ipairs(BuildSlotEditorItems(currentSide, currentIndex)) do
        layout[#layout + 1] = item
    end

    return layout
end

local function EX_RegisterLayout(selectedSide, selectedIndex)
    ExwindTools:RegisterModuleLayout(EXWIND_MODULE_KEY, BuildLayout(selectedSide, selectedIndex))
end

EX_RegisterLayout("left", 1)

-- =============================================================
-- 载入检查
-- =============================================================
if not ExwindTools:IsModuleEnabled(EXWIND_MODULE_KEY) then return end

EX_DB = ExwindTools:GetModuleDB(EXWIND_MODULE_KEY, EX_DEFAULTS)
local isEditModeActive = false
local isEditModeVisible = true

-- =============================================================
-- 工具函数
-- =============================================================
local function NormalizeActionId(value, fallback)
    local id = ACTION_LABEL_TO_ID[value or ""]
    if ACTION_BY_ID[id] then
        return id
    end
    if ACTION_BY_ID[value] then
        return value
    end
    return fallback or "none"
end

NormalizeThemeId = function(value)
    return THEME_NAME_TO_ID[value or ""] or "blizzard"
end

local function RunCustomCmd(cmd)
    if not cmd or cmd == "" then return end
    cmd = cmd:match("^%s*(.-)%s*$")
    if cmd == "" then return end
    local slash, args = cmd:match("^(/[^%s]+)%s*(.*)")
    if slash then
        slash = slash:upper()
        for key, handler in pairs(_G.SlashCmdList) do
            local i = 1
            while true do
                local registered = _G["SLASH_" .. key .. i]
                if not registered then break end
                if registered:upper() == slash then
                    handler(args or "")
                    return
                end
                i = i + 1
            end
        end
    end
    local editBox = ChatEdit_ChooseBoxForSend and ChatEdit_ChooseBoxForSend()
    if editBox then
        editBox:SetText(cmd)
        ChatEdit_SendText(editBox, 0)
    end
end

local function NormalizeClickData(clickData, fallbackAction)
    if type(clickData) ~= "table" then
        clickData = {}
    end
    clickData.action = NormalizeActionId(clickData.action, fallbackAction or "none")
    clickData.cmd = type(clickData.cmd) == "string" and clickData.cmd or ""
    return clickData
end

local function NormalizeSlot(slot, fallbackAction)
    if type(slot) ~= "table" then
        slot = {}
    end

    slot.icon = type(slot.icon) == "string" and slot.icon or ""
    if slot.tooltip == nil and type(slot.tip) == "string" then
        slot.tooltip = slot.tip
    end
    slot.tooltip = type(slot.tooltip) == "string" and slot.tooltip or ""
    slot.leftClick = NormalizeClickData(slot.leftClick or {
        action = slot.action,
        cmd = slot.cmd,
    }, fallbackAction or "none")
    slot.rightClick = NormalizeClickData(slot.rightClick, "none")

    if slot.icon ~= "" then
        local themeId, iconId = slot.icon:match("^(.+):(.+)$")
        themeId = NormalizeThemeId(themeId)
        if THEME_BY_ID[themeId] and iconId and iconId ~= "" then
            slot.icon = ResolveThemeForStoredIcon(themeId, iconId).id .. ":" .. iconId
        else
            slot.icon = ""
        end
    end

    if slot.icon == "" then
        local actionId = slot.leftClick.action ~= "none" and slot.leftClick.action or slot.rightClick.action
        if actionId and actionId ~= "none" then
            local preferredThemeId = NormalizeThemeId(EX_DB and EX_DB.iconTheme or "blizzard")
            local resolvedTheme = ResolveThemeForStoredIcon(preferredThemeId, actionId)
            slot.icon = resolvedTheme.id .. ":" .. actionId
        end
    end

    return slot
end

local function EnsureSlotList(side)
    if type(EX_DB.slots) ~= "table" then
        EX_DB.slots = {}
    end
    if type(EX_DB.slots[side]) ~= "table" then
        EX_DB.slots[side] = {}
    end
    local fallbackList = side == "left" and DEFAULT_LEFT_ACTIONS or DEFAULT_RIGHT_ACTIONS
    for i = 1, MAX_SLOTS do
        EX_DB.slots[side][i] = NormalizeSlot(EX_DB.slots[side][i], fallbackList[i] or "none")
    end
end

local function MigrateLegacySlots()
    if type(EX_DB.slots) == "table" and type(EX_DB.slots.left) == "table" and type(EX_DB.slots.right) == "table" then
        return
    end

    EX_DB.slots = { left = {}, right = {} }
    for i = 1, MAX_SLOTS do
        local leftSlot = CreateDefaultSlot(DEFAULT_LEFT_ACTIONS[i] or "none")
        leftSlot.leftClick.action = NormalizeActionId(EX_DB["left" .. i .. "_action"], leftSlot.leftClick.action)
        leftSlot.leftClick.cmd = type(EX_DB["left" .. i .. "_cmd"]) == "string" and EX_DB["left" .. i .. "_cmd"] or ""
        leftSlot.icon = type(EX_DB["left" .. i .. "_icon"]) == "string" and EX_DB["left" .. i .. "_icon"] or ""
        leftSlot.tooltip = type(EX_DB["left" .. i .. "_tip"]) == "string" and EX_DB["left" .. i .. "_tip"] or ""
        EX_DB.slots.left[i] = NormalizeSlot(leftSlot, DEFAULT_LEFT_ACTIONS[i] or "none")

        local rightSlot = CreateDefaultSlot(DEFAULT_RIGHT_ACTIONS[i] or "none")
        rightSlot.leftClick.action = NormalizeActionId(EX_DB["right" .. i .. "_action"], rightSlot.leftClick.action)
        rightSlot.leftClick.cmd = type(EX_DB["right" .. i .. "_cmd"]) == "string" and EX_DB["right" .. i .. "_cmd"] or ""
        rightSlot.icon = type(EX_DB["right" .. i .. "_icon"]) == "string" and EX_DB["right" .. i .. "_icon"] or ""
        rightSlot.tooltip = type(EX_DB["right" .. i .. "_tip"]) == "string" and EX_DB["right" .. i .. "_tip"] or ""
        EX_DB.slots.right[i] = NormalizeSlot(rightSlot, DEFAULT_RIGHT_ACTIONS[i] or "none")
    end
end

local function GetSlot(side, index)
    EnsureSlotList(side)
    index = math.max(1, math.min(MAX_SLOTS, tonumber(index) or 1))
    return EX_DB.slots[side][index]
end

local function EnsureSelectedSlotVisible()
    local side = EX_DB.selectedSlotSide == "right" and "right" or "left"
    local index = math.max(1, math.min(MAX_SLOTS, tonumber(EX_DB.selectedSlotIndex) or 1))
    local changed = false

    local count = side == "left" and tonumber(EX_DB.leftCount) or tonumber(EX_DB.rightCount)
    count = math.max(0, math.min(MAX_SLOTS, count or 0))
    if count <= 0 then
        local otherSide = side == "left" and "right" or "left"
        local otherCount = otherSide == "left" and tonumber(EX_DB.leftCount) or tonumber(EX_DB.rightCount)
        otherCount = math.max(0, math.min(MAX_SLOTS, otherCount or 0))
        if otherCount > 0 then
            side = otherSide
            index = math.min(index, otherCount)
            changed = true
        else
            side = "left"
            index = 1
            changed = true
        end
    elseif index > count then
        index = count
        changed = true
    end

    if EX_DB.selectedSlotSide ~= side or EX_DB.selectedSlotIndex ~= index then
        EX_DB.selectedSlotSide = side
        EX_DB.selectedSlotIndex = index
        changed = true
    end
    return changed
end

local function NormalizeDatabase()
    MigrateLegacySlots()
    EX_DB.schemaVersion = 2
    EX_DB.iconTheme = NormalizeThemeId(EX_DB.iconTheme)
    EX_DB.leftCount = math.max(0, math.min(MAX_SLOTS, tonumber(EX_DB.leftCount) or 5))
    EX_DB.rightCount = math.max(0, math.min(MAX_SLOTS, tonumber(EX_DB.rightCount) or 5))
    EnsureSlotList("left")
    EnsureSlotList("right")
    if EX_DB.timeFormat ~= "12小时制" then
        EX_DB.timeFormat = "24小时制"
    end
    EnsureSelectedSlotVisible()
end

NormalizeDatabase()
EX_RegisterLayout(EX_DB.selectedSlotSide, EX_DB.selectedSlotIndex)

local function GetSelectedSlotInfo()
    EnsureSelectedSlotVisible()
    local side = EX_DB.selectedSlotSide == "right" and "right" or "left"
    local index = math.max(1, math.min(MAX_SLOTS, tonumber(EX_DB.selectedSlotIndex) or 1))
    return side, index, GetSlot(side, index)
end

local function SelectSlot(side, index)
    if side ~= "left" and side ~= "right" then
        return false
    end
    local count = side == "left" and EX_DB.leftCount or EX_DB.rightCount
    count = math.max(0, math.min(MAX_SLOTS, tonumber(count) or 0))
    index = math.max(1, math.min(MAX_SLOTS, tonumber(index) or 1))
    if count > 0 then
        index = math.min(index, count)
    end
    local changed = EX_DB.selectedSlotSide ~= side or EX_DB.selectedSlotIndex ~= index
    EX_DB.selectedSlotSide = side
    EX_DB.selectedSlotIndex = index
    EnsureSelectedSlotVisible()
    return changed
end

local function GetCurrentTheme()
    return THEME_BY_ID[NormalizeThemeId(EX_DB.iconTheme)]
end

local function GetSlotBinding(slot, mouseButton)
    if mouseButton == "RightButton" then
        return NormalizeClickData(slot and slot.rightClick, "none")
    end
    return NormalizeClickData(slot and slot.leftClick, "none")
end

local function GetSlotPrimaryActionId(slot)
    local leftAction = GetSlotBinding(slot, "LeftButton").action
    if leftAction ~= "none" then
        return leftAction
    end
    return GetSlotBinding(slot, "RightButton").action
end

local function GetSlotIconInfo(side, index)
    local slot = GetSlot(side, index)
    local override = slot.icon
    if type(override) == "string" and override ~= "" then
        local themeId, iconId = override:match("^(.+):(.+)$")
        themeId = NormalizeThemeId(themeId)
        if THEME_BY_ID[themeId] and iconId then
            return ResolveThemeForStoredIcon(themeId, iconId).id, iconId
        end
    end
    return nil, nil
end

local function GetAtlasAspectRatio(atlas)
    if not atlas or not C_Texture or not C_Texture.GetAtlasInfo then
        return nil
    end

    local atlasInfo = C_Texture.GetAtlasInfo(atlas)
    if not atlasInfo or not atlasInfo.width or not atlasInfo.height or atlasInfo.width <= 0 or atlasInfo.height <= 0 then
        return nil
    end
    return atlasInfo.width / atlasInfo.height
end

local function ResolveThemeForIcon(themeId, iconId)
    return ResolveThemeForStoredIcon(themeId, iconId)
end

local function IsBlizzardCharacterIcon(themeId, iconId)
    local theme = ResolveThemeForIcon(themeId, iconId)
    return theme.type == "blizzard" and iconId == "character"
end

local function EnsureCharacterPortraitLayers(host)
    if not host then
        return
    end

    if not host.characterPortraitTex then
        local portrait = host:CreateTexture(nil, "ARTWORK", nil, 1)
        portrait:SetTexCoord(0.2, 0.8, 0.0666, 0.9)
        host.characterPortraitTex = portrait
    end

    if not host.characterPortraitMask then
        local mask = host:CreateMaskTexture(nil, "OVERLAY")
        mask:SetAtlas("UI-HUD-MicroMenu-Portrait-Mask", false)
        host.characterPortraitMask = mask
        host.characterPortraitTex:AddMaskTexture(mask)
    end
end

local function HideCharacterPortraitLayers(host)
    if not host then
        return
    end

    if host.characterPortraitTex then
        host.characterPortraitTex:Hide()
    end
    if host.characterPortraitMask then
        host.characterPortraitMask:Hide()
    end
end

local function LayoutIconTexture(tex, host, themeId, iconId, scale)
    tex:ClearAllPoints()

    local width, height = host:GetSize()
    if not width or not height or width <= 0 or height <= 0 then
        tex:SetAllPoints(host)
        return
    end

    scale = scale or 1
    local targetWidth = width * scale
    local targetHeight = height * scale
    local theme = ResolveThemeForIcon(themeId, iconId)
    if theme.type == "blizzard" then
        local actionDef = ACTION_BY_ID[iconId]
        local aspect = actionDef and GetAtlasAspectRatio(actionDef.atlas)
        if aspect and aspect > 0 then
            targetWidth = width * scale
            targetHeight = targetWidth / aspect
            if targetHeight > height * scale then
                targetHeight = height * scale
                targetWidth = targetHeight * aspect
            end
        end
    end

    tex:SetPoint("CENTER", host, "CENTER", 0, 0)
    tex:SetSize(targetWidth, targetHeight)
end

local function LayoutCharacterPortrait(host, scale)
    if not host or not host.normalTex then
        return
    end

    EnsureCharacterPortraitLayers(host)
    LayoutIconTexture(host.normalTex, host, "blizzard", "character", scale)

    local shadowWidth, shadowHeight = host.normalTex:GetSize()
    if not shadowWidth or not shadowHeight or shadowWidth <= 0 or shadowHeight <= 0 then
        shadowWidth, shadowHeight = host:GetSize()
    end

    local leftInset = shadowWidth * (7 / 32)
    local rightInset = shadowWidth * (7 / 32)
    local topInset = shadowHeight * (7 / 40)
    local bottomInset = shadowHeight * (7 / 40)

    host.characterPortraitTex:ClearAllPoints()
    host.characterPortraitTex:SetPoint("CENTER", host, "CENTER", 0, 0)
    host.characterPortraitTex:SetSize(math.max(1, shadowWidth - leftInset - rightInset),
        math.max(1, shadowHeight - topInset - bottomInset))

    host.characterPortraitMask:ClearAllPoints()
    host.characterPortraitMask:SetPoint("CENTER", host, "CENTER", 0, 0)
    host.characterPortraitMask:SetSize(shadowWidth * (35 / 32), shadowHeight * (65 / 40))
end

local function ApplyIconToTex(tex, themeId, iconId, scale)
    local host = tex and tex:GetParent()
    if host and IsBlizzardCharacterIcon(themeId, iconId) then
        tex:SetAtlas("UI-HUD-MicroMenu-Portrait-Shadow", false)
        tex:SetTexCoord(0, 1, 0, 1)
        tex:SetAlpha(1)
        tex:Show()

        EnsureCharacterPortraitLayers(host)
        SetPortraitTexture(host.characterPortraitTex, "player")
        host.characterPortraitTex:SetDesaturated(false)
        host.characterPortraitTex:SetAlpha(1)
        host.characterPortraitTex:Show()
        host.characterPortraitMask:Show()
        LayoutCharacterPortrait(host, scale)
        return
    end

    if host then
        HideCharacterPortraitLayers(host)
    end

    local theme = ResolveThemeForIcon(themeId, iconId)
    if theme.type == "blizzard" then
        local actionDef = ACTION_BY_ID[iconId]
        if actionDef and actionDef.atlas then
            tex:SetAtlas(actionDef.atlas, false)
        else
            tex:SetColorTexture(0.3, 0.3, 0.3, 0.5)
        end
        tex:SetTexCoord(0, 1, 0, 1)
    else
        local texturePath = ResolveCustomTexturePath(theme, iconId)
        local ok = texturePath and tex:SetTexture(texturePath)
        if ok == true then
            tex:SetTexCoord(0, 1, 0, 1)
        else
            tex:SetColorTexture(0.3, 0.3, 0.3, 0.5)
            tex:SetTexCoord(0, 1, 0, 1)
        end
    end
    tex:SetAlpha(1)
    tex:Show()
    LayoutIconTexture(tex, host, themeId, iconId, scale)
end

local function ApplyButtonIcon(btn, side, slotIndex, scale)
    local themeId, iconId = GetSlotIconInfo(side, slotIndex)
    if iconId == "none" or not iconId or iconId == "" then
        btn.normalTex:SetColorTexture(0.3, 0.3, 0.3, 0.5)
        btn.normalTex:SetTexCoord(0, 1, 0, 1)
        btn.normalTex:SetAlpha(0.4)
        HideCharacterPortraitLayers(btn)
        LayoutIconTexture(btn.normalTex, btn, themeId, iconId, scale)
        return
    end
    ApplyIconToTex(btn.normalTex, themeId, iconId, scale)
end

GetActionLabel = function(actionId)
    local actionDef = ACTION_BY_ID[actionId]
    return actionDef and actionDef.label or ACTION_BY_ID.none.label
end

local function GetTimeString()
    local d = date("*t")
    local hour, minute, sec = d.hour, d.min, d.sec
    local format24 = EX_DB.timeFormat ~= "12小时制"
    if format24 then
        if EX_DB.showSeconds then
            return string.format("%02d:%02d:%02d", hour, minute, sec)
        end
        return string.format("%02d:%02d", hour, minute)
    end

    local ampm = hour >= 12 and "PM" or "AM"
    local h12 = hour % 12
    if h12 == 0 then h12 = 12 end
    if EX_DB.showSeconds then
        return string.format("%d:%02d:%02d %s", h12, minute, sec, ampm)
    end
    return string.format("%d:%02d %s", h12, minute, ampm)
end

local function GetSlotSummaryLines(side, index)
    local slot = GetSlot(side, index)
    local leftBinding = GetSlotBinding(slot, "LeftButton")
    local rightBinding = GetSlotBinding(slot, "RightButton")
    return {
        "|cffffd100" .. L["左键"] .. "：|r" .. GetActionLabel(leftBinding.action),
        "|cff66c2ff" .. L["右键"] .. "：|r" .. GetActionLabel(rightBinding.action),
    }
end

local function RunSlotAction(side, index, mouseButton)
    local slot = GetSlot(side, index)
    local binding = GetSlotBinding(slot, mouseButton)
    local actionDef = ACTION_BY_ID[binding.action]
    if not actionDef or actionDef.id == "none" then
        return
    end
    if actionDef.id == "custom" then
        RunCustomCmd(binding.cmd)
        return
    end
    if actionDef.action then
        local ok, err = pcall(actionDef.action)
        if not ok then
            EXDebug("MicroMenu 按钮执行失败: %s", tostring(err))
        end
    end
end

local function RefreshLayoutPanel()
    EX_RegisterLayout(EX_DB.selectedSlotSide, EX_DB.selectedSlotIndex)
    if ExwindTools.UI and ExwindTools.UI.RefreshContentKeepModuleScroll then
        ExwindTools.UI:RefreshContentKeepModuleScroll()
    elseif ExwindTools.UI and ExwindTools.UI.RefreshContent then
        ExwindTools.UI:RefreshContent()
    end
end

-- =============================================================
-- 图标选择器
-- =============================================================
local IconPicker = {
    frame = nil,
    targetSide = nil,
    targetIndex = nil,
    scrollRow = 0,
}

local PICKER_CELL_SIZE = 44
local PICKER_PADDING = 12
local PICKER_COLUMN_COUNT = 10
local PICKER_VISIBLE_ROWS = 8

local function IconPicker_Close()
    if IconPicker.frame then
        IconPicker.frame:Hide()
    end
end

local function IconPicker_Refresh()
    local frame = IconPicker.frame
    if not frame or not IconPicker.targetSide or not IconPicker.targetIndex then
        IconPicker_Close()
        return
    end

    if frame.cells then
        for _, cell in ipairs(frame.cells) do
            cell:Hide()
            cell:SetParent(nil)
        end
    end
    frame.cells = {}

    local choices = BuildIconPickerChoices()
    local columnCount = math.min(PICKER_COLUMN_COUNT, math.max(1, #choices))
    local totalRows = math.max(1, math.ceil(#choices / columnCount))
    local maxScrollRow = math.max(0, totalRows - PICKER_VISIBLE_ROWS)
    IconPicker.scrollRow = math.max(0, math.min(IconPicker.scrollRow or 0, maxScrollRow))
    local startIndex = IconPicker.scrollRow * columnCount + 1
    local endIndex = math.min(#choices, startIndex + columnCount * PICKER_VISIBLE_ROWS - 1)
    local visibleCount = math.max(0, endIndex - startIndex + 1)
    local rowCount = math.max(1, math.ceil(visibleCount / columnCount))
    local totalW = PICKER_PADDING * 2 + columnCount * PICKER_CELL_SIZE + math.max(0, columnCount - 1) * 2
    local totalH = PICKER_PADDING * 2 + 24 + rowCount * PICKER_CELL_SIZE + math.max(0, rowCount - 1) * 2 + 8
    frame:SetSize(totalW, totalH)

    if not frame.titleText then
        frame.titleText = frame:CreateFontString(nil, "OVERLAY")
        frame.titleText:SetFont(ExwindTools.MAIN_FONT, 13, "OUTLINE")
        frame.titleText:SetTextColor(1, 1, 1, 1)
        frame.titleText:SetPoint("TOPLEFT", frame, "TOPLEFT", PICKER_PADDING, -PICKER_PADDING)
    end
    frame.titleText:SetText(L["选择图案"] ..
        "  [" .. BuildSelectedSlotTitle(IconPicker.targetSide, IconPicker.targetIndex) .. "]")

    if not frame.scrollText then
        frame.scrollText = frame:CreateFontString(nil, "OVERLAY")
        frame.scrollText:SetFont(ExwindTools.MAIN_FONT, 12, "OUTLINE")
        frame.scrollText:SetTextColor(0.95, 0.82, 0.25, 1)
        frame.scrollText:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -28, -PICKER_PADDING)
    end
    if maxScrollRow > 0 then
        frame.scrollText:SetText((IconPicker.scrollRow + 1) .. "/" .. (maxScrollRow + 1))
        frame.scrollText:Show()
    else
        frame.scrollText:SetText("")
        frame.scrollText:Hide()
    end

    local slot = GetSlot(IconPicker.targetSide, IconPicker.targetIndex)
    local currentIcon = slot.icon or ""
    for index = startIndex, endIndex do
        local choice = choices[index]
        local displayIndex = index - startIndex
        local row = math.floor(displayIndex / columnCount)
        local col = displayIndex % columnCount
        local cellX = PICKER_PADDING + col * (PICKER_CELL_SIZE + 2)
        local cellY = -(PICKER_PADDING + 24 + row * (PICKER_CELL_SIZE + 2))

        local cell = CreateFrame("Button", nil, frame)
        cell:SetSize(PICKER_CELL_SIZE, PICKER_CELL_SIZE)
        cell:SetPoint("TOPLEFT", frame, "TOPLEFT", cellX, cellY)
        cell:EnableMouse(true)
        cell:RegisterForClicks("AnyUp")

        local bg = cell:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetColorTexture(0.15, 0.15, 0.15, 0.9)
        cell.bg = bg

        local choiceValue = choice.themeId .. ":" .. choice.iconId
        if currentIcon == choiceValue then
            local border = cell:CreateTexture(nil, "OVERLAY")
            border:SetAllPoints()
            border:SetColorTexture(1, 0.8, 0, 0.4)
        end

        cell.normalTex = cell:CreateTexture(nil, "ARTWORK")
        cell.normalTex:SetAllPoints()
        ApplyIconToTex(cell.normalTex, choice.themeId, choice.iconId)

        cell:SetScript("OnEnter", function(self)
            self.bg:SetColorTexture(0.3, 0.6, 1.0, 0.4)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(choice.themeName .. " · " .. choice.label, 1, 1, 1)
            GameTooltip:Show()
        end)
        cell:SetScript("OnLeave", function(self)
            self.bg:SetColorTexture(0.15, 0.15, 0.15, 0.9)
            GameTooltip:Hide()
        end)
        cell:SetScript("OnClick", function()
            slot.icon = choiceValue
            ExwindTools:UpdateState(EXWIND_MODULE_KEY .. ".IconPickerApplied",
                { side = IconPicker.targetSide, index = IconPicker.targetIndex, ts = GetTime() })
            IconPicker_Close()
        end)

        frame.cells[#frame.cells + 1] = cell
    end

    if not frame.closeBtn then
        frame.closeBtn = CreateFrame("Button", nil, frame)
        frame.closeBtn:SetSize(22, 22)
        local closeTex = frame.closeBtn:CreateTexture(nil, "BACKGROUND")
        closeTex:SetAllPoints()
        closeTex:SetColorTexture(0.6, 0.1, 0.1, 0.9)
        local closeLbl = frame.closeBtn:CreateFontString(nil, "OVERLAY")
        closeLbl:SetFont(ExwindTools.MAIN_FONT, 13, "OUTLINE")
        closeLbl:SetTextColor(1, 1, 1, 1)
        closeLbl:SetText("✕")
        closeLbl:SetAllPoints()
        frame.closeBtn:SetScript("OnClick", IconPicker_Close)
        frame.closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
    end

    frame:Show()
end

local function IconPicker_Open(side, index)
    if not IconPicker.frame then
        local frame = CreateFrame("Frame", "ExMicroMenuIconPicker", UIParent, "BackdropTemplate")
        frame:SetFrameStrata("TOOLTIP")
        frame:SetFrameLevel(100)
        frame:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
        })
        frame:SetBackdropColor(0.05, 0.05, 0.08, 0.97)
        frame:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:EnableMouseWheel(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
        frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
        frame:SetScript("OnMouseWheel", function(_, delta)
            local choices = BuildIconPickerChoices()
            local columnCount = math.min(PICKER_COLUMN_COUNT, math.max(1, #choices))
            local totalRows = math.max(1, math.ceil(#choices / columnCount))
            local maxScrollRow = math.max(0, totalRows - PICKER_VISIBLE_ROWS)
            if delta > 0 and (IconPicker.scrollRow or 0) > 0 then
                IconPicker.scrollRow = IconPicker.scrollRow - 1
                IconPicker_Refresh()
            elseif delta < 0 and (IconPicker.scrollRow or 0) < maxScrollRow then
                IconPicker.scrollRow = IconPicker.scrollRow + 1
                IconPicker_Refresh()
            end
        end)
        frame:SetScript("OnKeyDown", function(_, key)
            if key == "ESCAPE" then
                IconPicker_Close()
            end
        end)
        frame:SetPropagateKeyboardInput(true)
        frame:Hide()
        IconPicker.frame = frame
    end

    IconPicker.targetSide = side
    IconPicker.targetIndex = index
    IconPicker.scrollRow = 0
    IconPicker.frame:ClearAllPoints()
    IconPicker.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    IconPicker_Refresh()
end

-- =============================================================
-- 设置页预览 renderer
-- =============================================================
local function RefreshPreviewWidget()
    local widgets = ExwindTools.Grid and ExwindTools.Grid.Widgets
    local widget = widgets and widgets.slotPreview
    if widget and widget._customRenderer and type(widget._customRenderer.update) == "function" then
        widget._customRenderer.update(widget, widget._customContext)
    end
end

local function EnsurePreviewButton(host, side, index, parent)
    host.slotButtons = host.slotButtons or { left = {}, right = {} }
    local list = host.slotButtons[side]
    if list[index] then
        if parent and list[index]:GetParent() ~= parent then
            list[index]:SetParent(parent)
            list[index]:SetFrameLevel((parent:GetFrameLevel() or 0) + 4)
        end
        list[index]._slotSide = side
        list[index]._slotIndex = index
        return list[index]
    end

    local btn = CreateFrame("Button", nil, parent or host)
    btn:EnableMouse(true)
    btn:RegisterForClicks("AnyUp")
    btn:SetFrameLevel(((parent or host):GetFrameLevel() or 0) + 4)

    btn.bg = btn:CreateTexture(nil, "BACKGROUND")
    btn.bg:SetAllPoints()
    btn.bg:SetColorTexture(0.08, 0.08, 0.1, 0.95)

    btn.normalTex = btn:CreateTexture(nil, "ARTWORK")
    btn.normalTex:SetAllPoints()

    btn.border = btn:CreateTexture(nil, "OVERLAY")
    btn.border:SetAllPoints()
    btn.border:SetColorTexture(1, 0.82, 0.22, 0)

    btn.indexText = btn:CreateFontString(nil, "OVERLAY")
    btn.indexText:SetFont(ExwindTools.MAIN_FONT, 10, "OUTLINE")
    btn.indexText:SetTextColor(1, 1, 1, 0.85)
    btn.indexText:SetPoint("TOP", btn, "BOTTOM", 0, -2)

    btn._slotSide = side
    btn._slotIndex = index

    btn:SetScript("OnClick", function(self)
        SelectSlot(self._slotSide, self._slotIndex)
        RefreshLayoutPanel()
        C_Timer.After(0, RefreshPreviewWidget)
    end)
    btn:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(0.16, 0.18, 0.22, 0.98)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(BuildSelectedSlotTitle(self._slotSide, self._slotIndex), 1, 1, 1)
        local summaryLines = GetSlotSummaryLines(self._slotSide, self._slotIndex)
        for _, line in ipairs(summaryLines) do
            GameTooltip:AddLine(line, 1, 1, 1)
        end
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function(self)
        self.bg:SetColorTexture(0.08, 0.08, 0.1, 0.95)
        GameTooltip:Hide()
    end)

    list[index] = btn
    return btn
end

local function LayoutPreviewButtons(host, side, count, anchorFrame, iconSize, gap, padding)
    host.slotButtons = host.slotButtons or { left = {}, right = {} }
    local list = host.slotButtons[side]
    for i = 1, MAX_SLOTS do
        local btn = EnsurePreviewButton(host, side, i, anchorFrame)
        if i <= count then
            btn:SetSize(iconSize, iconSize)
            btn:ClearAllPoints()
            btn:SetPoint("LEFT", anchorFrame, "LEFT", padding + (i - 1) * (iconSize + gap), 0)
            btn.indexText:SetText((side == "right" and L["右"] or L["左"]) .. i)
            ApplyButtonIcon(btn, side, i)
            local isSelected = EX_DB.selectedSlotSide == side and tonumber(EX_DB.selectedSlotIndex) == i
            btn.border:SetColorTexture(1, 0.82, 0.22, isSelected and 0.35 or 0)
            btn:Show()
            btn.indexText:Show()
        else
            btn:Hide()
            btn.indexText:Hide()
        end
    end
end

local PreviewRenderer = {
    mount = function(host)
        if host._microMenuPreviewBuilt then
            return
        end

        host:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            edgeSize = 1,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        host:SetBackdropColor(0.03, 0.04, 0.07, 0.92)
        host:SetBackdropBorderColor(0.18, 0.22, 0.28, 0.95)
        if host.EnableMouse then
            host:EnableMouse(false)
        end

        host.leftPanel = CreateFrame("Frame", nil, host)
        host.centerPanel = CreateFrame("Frame", nil, host)
        host.rightPanel = CreateFrame("Frame", nil, host)

        for _, panel in ipairs({ host.leftPanel, host.centerPanel, host.rightPanel }) do
            panel.bg = panel:CreateTexture(nil, "BACKGROUND")
            panel.bg:SetAllPoints()
        end

        host.timeText = host.centerPanel:CreateFontString(nil, "OVERLAY")
        host.timeText:SetTextColor(1, 1, 1, 1)
        host.timeText:SetPoint("CENTER")

        host.hintText = host:CreateFontString(nil, "OVERLAY")
        host.hintText:SetFont(ExwindTools.MAIN_FONT, 11, "OUTLINE")
        host.hintText:SetTextColor(0.8, 0.84, 0.9, 1)
        host.hintText:SetPoint("BOTTOM", host, "BOTTOM", 0, 6)
        host.hintText:SetText(L["点击图标切换当前槽位"])

        host._microMenuPreviewBuilt = true
    end,
    update = function(host)
        local width = math.max(240, host:GetWidth())
        local height = math.max(90, host:GetHeight())
        local leftCount = math.max(0, math.min(MAX_SLOTS, tonumber(EX_DB.leftCount) or 0))
        local rightCount = math.max(0, math.min(MAX_SLOTS, tonumber(EX_DB.rightCount) or 0))
        local maxCount = math.max(leftCount, rightCount, 1)
        local gap = 4
        local padding = 8
        local centerWidth = math.min(140, math.max(90, math.floor(width * 0.22)))
        local sideWidth = math.max(70, math.floor((width - centerWidth - 8) * 0.5))
        local iconSize = math.min(math.max(18, tonumber(EX_DB.iconSize) or 28), 34)
        iconSize = math.min(iconSize, math.floor((sideWidth - padding * 2 - (maxCount - 1) * gap) / maxCount))
        iconSize = math.max(16, iconSize)
        local barHeight = iconSize + padding * 2
        local topY = -12

        host.leftPanel:ClearAllPoints()
        host.leftPanel:SetSize(sideWidth, barHeight)
        host.leftPanel:SetPoint("TOPLEFT", host, "TOPLEFT", 0, topY)

        host.centerPanel:ClearAllPoints()
        host.centerPanel:SetSize(centerWidth, barHeight)
        host.centerPanel:SetPoint("LEFT", host.leftPanel, "RIGHT", 0, 0)

        host.rightPanel:ClearAllPoints()
        host.rightPanel:SetSize(sideWidth, barHeight)
        host.rightPanel:SetPoint("LEFT", host.centerPanel, "RIGHT", 0, 0)

        local bgAlpha = EX_DB.showBackground and math.max(0, math.min(1, tonumber(EX_DB.bgAlpha) or 0.6)) or 0
        host.leftPanel.bg:SetColorTexture(0, 0, 0, bgAlpha)
        host.centerPanel.bg:SetColorTexture(0, 0, 0, bgAlpha)
        host.rightPanel.bg:SetColorTexture(0, 0, 0, bgAlpha)

        local timeFontSize = (EX_DB.timeFontSize and EX_DB.timeFontSize > 0) and EX_DB.timeFontSize or
            math.floor(iconSize * 0.75)
        host.timeText:SetFont(ExwindTools.MAIN_FONT, math.max(10, timeFontSize), "OUTLINE")
        host.timeText:ClearAllPoints()
        host.timeText:SetPoint("CENTER", host.centerPanel, "CENTER", EX_DB.timeOffsetX or 0, EX_DB.timeOffsetY or 0)
        host.timeText:SetText(GetTimeString())

        LayoutPreviewButtons(host, "left", leftCount, host.leftPanel, iconSize, gap, padding)
        LayoutPreviewButtons(host, "right", rightCount, host.rightPanel, iconSize, gap, padding)
    end,
    release = function(host)
        if host.slotButtons then
            for _, list in pairs(host.slotButtons) do
                for _, btn in pairs(list) do
                    btn:Hide()
                    if btn.indexText then
                        btn.indexText:Hide()
                    end
                end
            end
        end
        GameTooltip:Hide()
    end,
}

if ExwindTools.Grid and ExwindTools.Grid.RegisterCustomRenderer then
    ExwindTools.Grid:RegisterCustomRenderer(PREVIEW_RENDERER_KEY, PreviewRenderer)
end

-- =============================================================
-- HUD
-- =============================================================
local mainFrame = nil
local leftFrame = nil
local rightFrame = nil
local leftBtns = {}
local rightBtns = {}
local timeText = nil
local ticker = nil
local editHandleFrame = nil

local function UpdateButtonBinding(btn, side, slotIndex)
    btn._side = side
    btn._slotIndex = slotIndex
    ApplyButtonIcon(btn, side, slotIndex)
end

local function CreateIconButton(parent, side, slotIndex)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(EX_DB.iconSize, EX_DB.iconSize)
    btn:EnableMouse(true)
    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    local normalTex = btn:CreateTexture(nil, "ARTWORK")
    normalTex:SetAllPoints()
    btn.normalTex = normalTex

    btn:SetScript("OnEnter", function(self)
        ApplyButtonIcon(self, self._side, self._slotIndex, 1.3)

        local slot = GetSlot(self._side, self._slotIndex)
        local leftBinding = GetSlotBinding(slot, "LeftButton")
        local rightBinding = GetSlotBinding(slot, "RightButton")

        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:SetText("|cffffd100" .. L["左键"] .. "：|r" .. GetActionLabel(leftBinding.action), 1, 1, 1)
        GameTooltip:AddLine("|cff66c2ff" .. L["右键"] .. "：|r" .. GetActionLabel(rightBinding.action), 1, 1, 1)
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function(self)
        ApplyButtonIcon(self, self._side, self._slotIndex, 1)
        GameTooltip:Hide()
    end)
    btn:SetScript("OnClick", function(self, mouseButton)
        RunSlotAction(self._side, self._slotIndex, mouseButton)
    end)

    UpdateButtonBinding(btn, side, slotIndex)
    return btn
end

local function EnsureEditHandleFrame()
    if editHandleFrame then
        return
    end

    editHandleFrame = CreateFrame("Frame", nil, UIParent)
    editHandleFrame:Hide()
end

local function ShouldShowCustomHUD()
    if isEditModeActive then
        return isEditModeVisible and true or false
    end
    return EX_DB.enabled and true or false
end

local function RefreshEditOverlay()
    if not editHandleFrame then
        return
    end

    if mainFrame and isEditModeActive and isEditModeVisible then
        local leftAnchor = leftFrame or mainFrame
        local rightAnchor = rightFrame or mainFrame
        editHandleFrame:ClearAllPoints()
        editHandleFrame:SetPoint("TOPLEFT", leftAnchor, "TOPLEFT", 0, 0)
        editHandleFrame:SetPoint("BOTTOMRIGHT", rightAnchor, "BOTTOMRIGHT", 0, 0)
        editHandleFrame:Show()
        ExwindTools:ShowExwindToolsEditOverlay(EXWIND_MODULE_KEY, editHandleFrame, {
            title = L["微型选单"],
            ownerFrame = mainFrame,
        })
    else
        ExwindTools:HideExwindToolsEditOverlay(editHandleFrame)
        editHandleFrame:Hide()
    end
end

local function ApplyHUDVisibility()
    if not mainFrame then
        RefreshEditOverlay()
        return
    end

    if ShouldShowCustomHUD() then
        mainFrame:Show()
    else
        mainFrame:Hide()
    end

    mainFrame:EnableMouse((isEditModeActive and isEditModeVisible) or not EX_DB.locked)
    RefreshEditOverlay()
end

local function BuildHUD()
    EnsureEditHandleFrame()

    if mainFrame then
        RefreshEditOverlay()
        mainFrame:Hide()
        mainFrame:SetParent(nil)
        mainFrame = nil
        leftFrame = nil
        rightFrame = nil
        leftBtns = {}
        rightBtns = {}
        timeText = nil
    end
    if not EX_DB.enabled and not isEditModeActive then
        return
    end

    local iconSize = EX_DB.iconSize
    local iconGap = 4
    local padding = 8
    local leftCount = math.min(EX_DB.leftCount or 5, MAX_SLOTS)
    local rightCount = math.min(EX_DB.rightCount or 5, MAX_SLOTS)
    local barHeight = iconSize + padding * 2

    mainFrame = CreateFrame("Frame", "ExMicroMenuFrame", UIParent)
    mainFrame:SetFrameStrata("MEDIUM")
    mainFrame:SetFrameLevel(10)
    mainFrame:SetScale(EX_DB.barScale)
    mainFrame:SetMovable(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetSize(100, barHeight)

    local timeBg = mainFrame:CreateTexture(nil, "BACKGROUND")
    timeBg:SetAllPoints()
    timeBg:SetColorTexture(0, 0, 0, EX_DB.showBackground and EX_DB.bgAlpha or 0)

    timeText = mainFrame:CreateFontString(nil, "OVERLAY")
    local tfs = (EX_DB.timeFontSize and EX_DB.timeFontSize > 0) and EX_DB.timeFontSize or math.floor(iconSize * 0.75)
    timeText:SetFont(ExwindTools.MAIN_FONT, tfs, "OUTLINE")
    timeText:SetTextColor(1, 1, 1, 1)
    timeText:SetPoint("CENTER", mainFrame, "CENTER", EX_DB.timeOffsetX or 0, EX_DB.timeOffsetY or 0)
    timeText:SetText(GetTimeString())

    mainFrame:SetScript("OnDragStart", function(self)
        local canDragInEditMode = isEditModeActive and isEditModeVisible
        if not canDragInEditMode and EX_DB.locked then return end
        self:StartMoving()
    end)
    mainFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, _, x, y = self:GetPoint()
        EX_DB.posX = math.floor(x or 0)
        EX_DB.posY = math.floor(y or 0)
        EX_DB.posAnchor = point or "TOP"
    end)

    ExwindTools:RegisterHUD(EXWIND_MODULE_KEY, mainFrame)
    mainFrame:EnableMouse((isEditModeActive and isEditModeVisible) or not EX_DB.locked)

    if leftCount > 0 then
        local leftWidth = padding + leftCount * iconSize + (leftCount - 1) * iconGap + padding
        leftFrame = CreateFrame("Frame", nil, mainFrame)
        leftFrame:SetFrameStrata("MEDIUM")
        leftFrame:SetFrameLevel(10)
        leftFrame:SetSize(leftWidth, barHeight)
        leftFrame:SetPoint("RIGHT", mainFrame, "LEFT", 0, 0)

        local leftBg = leftFrame:CreateTexture(nil, "BACKGROUND")
        leftBg:SetAllPoints()
        leftBg:SetColorTexture(0, 0, 0, EX_DB.showBackground and EX_DB.bgAlpha or 0)

        local curX = padding
        for i = 1, leftCount do
            local btn = CreateIconButton(leftFrame, "left", i)
            btn:SetPoint("LEFT", leftFrame, "LEFT", curX, 0)
            curX = curX + iconSize + iconGap
            leftBtns[i] = btn
        end
    end

    if rightCount > 0 then
        local rightWidth = padding + rightCount * iconSize + (rightCount - 1) * iconGap + padding
        rightFrame = CreateFrame("Frame", nil, mainFrame)
        rightFrame:SetFrameStrata("MEDIUM")
        rightFrame:SetFrameLevel(10)
        rightFrame:SetSize(rightWidth, barHeight)
        rightFrame:SetPoint("LEFT", mainFrame, "RIGHT", 0, 0)

        local rightBg = rightFrame:CreateTexture(nil, "BACKGROUND")
        rightBg:SetAllPoints()
        rightBg:SetColorTexture(0, 0, 0, EX_DB.showBackground and EX_DB.bgAlpha or 0)

        local curX = padding
        for i = 1, rightCount do
            local btn = CreateIconButton(rightFrame, "right", i)
            btn:SetPoint("LEFT", rightFrame, "LEFT", curX, 0)
            curX = curX + iconSize + iconGap
            rightBtns[i] = btn
        end
    end

    mainFrame:ClearAllPoints()
    local anchor = EX_DB.posAnchor or "TOP"
    mainFrame:SetPoint(anchor, UIParent, anchor, EX_DB.posX or 0, EX_DB.posY or 0)
    ApplyHUDVisibility()
end

local blizzMicroMenuOrigPoint = nil
local function SetBlizzardMicroMenuVisible(visible)
    local container = _G.MicroMenuContainer
    if not container then return end
    if visible then
        container:ClearAllPoints()
        if blizzMicroMenuOrigPoint then
            container:SetPoint(unpack(blizzMicroMenuOrigPoint))
        else
            container:SetPoint("TOP", UIParent, "TOP", 0, 0)
        end
        return
    end

    if not blizzMicroMenuOrigPoint then
        local point, relativeTo, relativePoint, x, y = container:GetPoint()
        if point then
            blizzMicroMenuOrigPoint = { point, relativeTo, relativePoint, x, y }
        end
    end
    container:ClearAllPoints()
    container:SetPoint("TOP", UIParent, "BOTTOM", 0, -9999)
end

local function TickTime()
    if timeText and timeText:IsShown() then
        timeText:SetText(GetTimeString())
    end
end

local function StartTicker()
    if ticker then
        ticker:Cancel()
        ticker = nil
    end
    ticker = C_Timer.NewTicker(1, TickTime)
end

local function RefreshHUDButtons()
    for i, btn in ipairs(leftBtns) do
        UpdateButtonBinding(btn, "left", i)
    end
    for i, btn in ipairs(rightBtns) do
        UpdateButtonBinding(btn, "right", i)
    end
end

local function RefreshAll()
    local ok, err = pcall(BuildHUD)
    if not ok then
        EXDebug("MicroMenu BuildHUD 出错: %s", tostring(err))
    end

    if ShouldShowCustomHUD() then
        StartTicker()
    else
        if ticker then
            ticker:Cancel()
            ticker = nil
        end
    end

    ApplyHUDVisibility()
    SetBlizzardMicroMenuVisible(not ShouldShowCustomHUD())
end

-- =============================================================
-- 状态订阅
-- =============================================================
ExwindTools:RegisterEvent("PLAYER_ENTERING_WORLD", EXWIND_MODULE_KEY, function()
    C_Timer.After(0.5, RefreshAll)
end)

ExwindTools:RegisterEvent("UNIT_PORTRAIT_UPDATE", EXWIND_MODULE_KEY, function(_, unit)
    if unit and unit ~= "player" then
        return
    end
    RefreshHUDButtons()
    RefreshPreviewWidget()
    if IconPicker.frame and IconPicker.frame:IsShown() then
        IconPicker_Refresh()
    end
end)

ExwindTools:RegisterEvent("PORTRAITS_UPDATED", EXWIND_MODULE_KEY, function()
    RefreshHUDButtons()
    RefreshPreviewWidget()
    if IconPicker.frame and IconPicker.frame:IsShown() then
        IconPicker_Refresh()
    end
end)

ExwindTools:WatchState(EXWIND_MODULE_KEY .. ".DatabaseChanged", EXWIND_MODULE_KEY, function(info)
    if not info or not info.key then return end

    if info.key == "leftCount" or info.key == "rightCount" then
        local selectionChanged = EnsureSelectedSlotVisible()
        RefreshAll()
        RefreshPreviewWidget()
        if selectionChanged then
            RefreshLayoutPanel()
        end
        return
    end

    local rebuildKeys = {
        enabled = true,
        iconSize = true,
        barScale = true,
        showBackground = true,
        bgAlpha = true,
        posAnchor = true,
        posX = true,
        posY = true,
        showSeconds = true,
        timeFormat = true,
        timeFontSize = true,
        timeOffsetX = true,
        timeOffsetY = true,
    }
    if rebuildKeys[info.key] then
        RefreshAll()
        RefreshPreviewWidget()
        return
    end

    if info.key == "iconTheme"
        or info.key == "left_cmd"
        or info.key == "right_cmd"
    then
        RefreshHUDButtons()
        RefreshPreviewWidget()
        return
    end

    if info.key == "left_action" or info.key == "right_action" then
        RefreshHUDButtons()
        RefreshPreviewWidget()
        RefreshLayoutPanel()
        return
    end

    if info.key == "locked" and mainFrame then
        ApplyHUDVisibility()
    end
end)

ExwindTools:WatchState(EXWIND_MODULE_KEY .. ".IconPickerApplied", EXWIND_MODULE_KEY, function()
    RefreshHUDButtons()
    RefreshPreviewWidget()
end)

ExwindTools:WatchState(EXWIND_MODULE_KEY .. ".PanelRendered", EXWIND_MODULE_KEY, function()
    RefreshPreviewWidget()
end)

ExwindTools:WatchState(EXWIND_MODULE_KEY .. ".ButtonClicked", EXWIND_MODULE_KEY, function(info)
    if not info or not info.key then return end

    if info.key == "btn_reset_pos" then
        EX_DB.posX = 0
        EX_DB.posY = 0
        EX_DB.posAnchor = "TOP"
        if mainFrame then
            mainFrame:ClearAllPoints()
            mainFrame:SetPoint("TOP", UIParent, "TOP", 0, 0)
        end
        return
    end

    if info.key == "btn_select_icon" then
        local side, index = GetSelectedSlotInfo()
        IconPicker_Open(side, index)
        return
    end
end)

ExwindTools:RegisterEditModeHandler(EXWIND_MODULE_KEY, {
    EnterEditMode = function()
        isEditModeActive = true
        isEditModeVisible = true
        RefreshAll()
    end,
    ExitEditMode = function()
        isEditModeActive = false
        isEditModeVisible = true
        RefreshAll()
    end,
    SetEditVisible = function(_, visible)
        isEditModeVisible = (visible ~= false)
        if ShouldShowCustomHUD() then
            StartTicker()
        elseif ticker then
            ticker:Cancel()
            ticker = nil
        end
        ApplyHUDVisibility()
        SetBlizzardMicroMenuVisible(not ShouldShowCustomHUD())
    end,
    RefreshEditMode = function(_, enabled, visible)
        isEditModeActive = enabled and true or false
        isEditModeVisible = (visible ~= false)
        RefreshAll()
    end,
})

ExwindTools:ReportReady(EXWIND_MODULE_KEY)
