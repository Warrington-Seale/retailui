local ADDON_NAME, namespace = ...
local DST = namespace.DST
local AF = namespace.AF
local Locale = namespace.Locale

DST.rows = {}
DST.Frame = nil
DST.MinimapButton = nil
DST.ActiveRipple = nil
DST.SettingsFrame = nil
DST.SettingsTomTomCheck = nil
-- Off by default: map click still opens map + TomTom; ripple/HBD pins are optional eye candy.
DST.USE_RIPPLE_EFFECT = false

local HOVER_HIGHLIGHT = { 0, 0.8, 0.8, 0.38 } -- fallback; replaced on CreateUI with AF color table
namespace.HOVER_HIGHLIGHT = HOVER_HIGHLIGHT

local function SetHoverHighlight(val)
    HOVER_HIGHLIGHT = val
    namespace.HOVER_HIGHLIGHT = val
end
namespace.SetHoverHighlight = SetHoverHighlight

local function GetCurrentLocale()
    return (GetLocale and GetLocale()) or "enUS"
end

local function GetLocaleFont()
    local layout = DST.LAYOUT
    if layout and layout.FONT_KEY and layout.FONT_KEY ~= "" then
        local path = AF.LSM_GetFont and AF.LSM_GetFont(layout.FONT_KEY)
        if path then return path end
        return AF.GetFont(layout.FONT_KEY)
    end
    if AF.GetAddonFont and AF.GetAddonFont("DelveSpeedTracker") then
        local fontKey = AF.GetAddonFont("DelveSpeedTracker")
        local path = AF.LSM_GetFont and AF.LSM_GetFont(fontKey)
        if path then return path end
        return AF.GetFont(fontKey)
    end
    local locale = GetCurrentLocale()
    if locale == "enUS" or locale == "enGB" then
        return AF.GetFont("Emblem")
    end
    return select(1, GameFontNormal:GetFont())
end

DST.LAYOUT_DEFAULTS = {
    DEFAULT_FRAME_X = 80,
    DEFAULT_FRAME_Y = -100,
    MIN_WIDTH = 90,
    TITLE_CLOSE_PAD = 4,
    HEADER_HEIGHT = 5,
    CONTENT_INSET_LEFT = 0,
    CONTENT_INSET_TOP = 0,
    CONTENT_INSET_RIGHT = 0,
    CONTENT_INSET_BOTTOM = 0,
    --- Padding added to measured text width (kept small; measurement includes atlas via fixed add).
    CONTENT_WIDTH_PAD = 2,
    --- Small slack inside the row (outline / Ceil / skin borders).
    ROW_TEXT_RIGHT_PAD = 4,
    --- Width reserved for |A:delves-bountiful:16:16|a in layout; >16 covers glow and rounding on long labels.
    BOUNTIFUL_ATLAS_LAYOUT_WIDTH = 20,
    ROW_HEIGHT = 21,
    ROW_INDENT = 4,
    ROW_BOX_LEFT_PAD = 1,
    ROW_ICON_SIZE = 20,
    ROW_ICON_TEXT_GAP = 2,
    ROW_TIME_RIGHT_INSET = 4,
    BACKDROP_ALPHA = 0.35,
    SECTION_GAP = 0,
    HEADER_TOP_PAD = 0,
    HEADER_TITLE_TIME_GAP = 0,
    SECTION_HEADER_OFFSET_X = 4,
    SECTION_HEADER_OFFSET_Y = 4,
    SECTION_HEADER_TEXT_OFFSET_X = -4,
    TITLE_INSET = 5,
    TITLE_OFFSET_X = 0,
    TITLE_OFFSET_Y = 0,
    EMBLEM_TITLE_SIZE = 12,
    EMBLEM_ROW_SIZE = 13,
    --- Last line of delve row tooltip ("click to open map"); slightly smaller than body lines.
    TOOLTIP_CLICK_FONT_SIZE = 12,
    TEXT_FONT_FLAG = 1,
    TEXT_SHADOW_OFFSET_X = 1,
    TEXT_SHADOW_OFFSET_Y = -1,
    FONT_KEY = "",
}

DST.LAYOUT = DST.LAYOUT or {}
local LAYOUT = DST.LAYOUT
local function ApplyLayoutDefaults()
    for k, v in pairs(DST.LAYOUT_DEFAULTS) do
        if LAYOUT[k] == nil then LAYOUT[k] = v end
    end
end
ApplyLayoutDefaults()

function DST:RecomputeLayout()
    LAYOUT.ICON_COLUMN_LEFT = (LAYOUT.ROW_INDENT or 0) + (LAYOUT.ROW_BOX_LEFT_PAD or 0)
end
DST:RecomputeLayout()

function DST:GetTextFontFlagString()
    local n = LAYOUT.TEXT_FONT_FLAG
    if n == 1 then return "OUTLINE" end
    if n == 2 then return "THICKOUTLINE" end
    return ""
end

function DST:ApplyTitlePosition()
    if not DST.Frame or not DST.Frame.header or not DST.Frame.header.text then return end
    local header = DST.Frame.header
    local titleRightAnchor = header.settingsBtn or header.closeBtn
    local inset = LAYOUT.TITLE_INSET or 5
    local offsetX = LAYOUT.TITLE_OFFSET_X or 0
    local offsetY = LAYOUT.TITLE_OFFSET_Y or 0
    AF.ClearPoints(header.text)
    AF.SetPoint(header.text, "LEFT", header, "LEFT", inset + offsetX, offsetY)
    AF.SetPoint(header.text, "RIGHT", titleRightAnchor, "LEFT", -inset + offsetX, offsetY)
end

local function ApplyTextStyle(fontString)
    if not fontString or not fontString.SetShadowOffset then return end
    fontString:SetShadowOffset(LAYOUT.TEXT_SHADOW_OFFSET_X or 1, LAYOUT.TEXT_SHADOW_OFFSET_Y or -1)
    fontString:SetShadowColor(0, 0, 0, 1)
end

local function GetContentInsets()
    return
        LAYOUT.CONTENT_INSET_LEFT or 0,
        LAYOUT.CONTENT_INSET_TOP or 0,
        LAYOUT.CONTENT_INSET_RIGHT or 0,
        LAYOUT.CONTENT_INSET_BOTTOM or 0
end

local measureFontString = nil

-- Strip color markup for cache keys / approximate compare. For *width measurement* we must keep
-- |A (atlas) and |T (texture) tokens so GetStringWidth matches on-screen width (e.g. bountiful icon).
local function StripForMeasure(s)
    if not s or type(s) ~= "string" then return "" end
    return s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|cn[%w_]+:", "")
end

local function MeasureTextWidth(text)
    if not measureFontString then
        measureFontString = UIParent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        measureFontString:Hide()
    end
    local font = GetLocaleFont()
    local fontFlags = DST:GetTextFontFlagString()
    measureFontString:SetFont(font, LAYOUT.EMBLEM_ROW_SIZE or 13, fontFlags)
    -- Full string (colors + |A atlas + |T textures) so width matches rendered rows (bountiful icon, etc.).
    measureFontString:SetText(text or "")
    return measureFontString:GetStringWidth()
end

local function MeasureTextWidthCached(text, cache)
    if not text or type(text) ~= "string" then return 0 end
    local key = "txt:" .. StripForMeasure(text)
    if cache and cache[key] then return cache[key] end
    local w = MeasureTextWidth(text)
    if cache then cache[key] = w end
    return w
end

-- GetStringWidth() often over-reports embedded |A: atlas width. Measure the colored text, then add
-- one space plus BOUNTIFUL_ATLAS_LAYOUT_WIDTH (logical 16 + slack for glow; see VariantDetection format).
local function MeasureDelveDisplayNameWidth(text)
    if not text or type(text) ~= "string" or text == "" then return 0 end
    if not text:find("|A:", 1, true) then
        return MeasureTextWidth(text)
    end
    local textNoAtlas = text:gsub("%s*|A:[^|]+|a", "")
    local w = MeasureTextWidth(textNoAtlas)
    local spaceW = MeasureTextWidth(" ")
    local atlasW = LAYOUT.BOUNTIFUL_ATLAS_LAYOUT_WIDTH or 20
    return w + spaceW + atlasW
end

local function MeasureDelveDisplayNameWidthCached(text, cache)
    if not text or type(text) ~= "string" then return 0 end
    local key = "delve:" .. StripForMeasure(text)
    if cache and cache[key] then return cache[key] end
    local w = MeasureDelveDisplayNameWidth(text)
    if cache then cache[key] = w end
    return w
end

local function GetContentWidthFromLongestEntry(activeDelves, widthCache)
    local leftOffset = LAYOUT.ICON_COLUMN_LEFT + LAYOUT.ROW_ICON_SIZE + LAYOUT.ROW_ICON_TEXT_GAP
    local headerTimeGap = LAYOUT.HEADER_TITLE_TIME_GAP or 0
    local maxTextWidth = 0
    local currentDifficultyForWidth = nil
    for _, delve in ipairs(activeDelves) do
        if currentDifficultyForWidth ~= delve.difficulty then
            currentDifficultyForWidth = delve.difficulty
            local config = DST.difficultyConfig[delve.difficulty]
            if config then
                local nameKey = Locale(config.nameKey):upper()
                local timeKey = Locale(config.timeKey)
                local headerW = MeasureTextWidthCached(nameKey, widthCache) + headerTimeGap + MeasureTextWidthCached(timeKey, widthCache)
                if headerW > maxTextWidth then maxTextWidth = headerW end
            end
        end
        local w = MeasureDelveDisplayNameWidthCached(delve.displayName, widthCache)
        if w > maxTextWidth then maxTextWidth = w end
    end
    if maxTextWidth <= 0 then
        return LAYOUT.MIN_WIDTH
    end
    return math.ceil(leftOffset + maxTextWidth + LAYOUT.CONTENT_WIDTH_PAD + (LAYOUT.ROW_TEXT_RIGHT_PAD or 0))
end

namespace.GetLocaleFont = GetLocaleFont
namespace.ApplyTextStyle = ApplyTextStyle
namespace.GetContentInsets = GetContentInsets
namespace.GetContentWidthFromLongestEntry = GetContentWidthFromLongestEntry
