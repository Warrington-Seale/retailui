--- English (US) locale for DelveSpeedTracker.
local ADDON_NAME, namespace = ...

local L = {
    ["WINDOW_TITLE"] = "Delve Difficulty",
    ["TURBO"] = "Turbo",
    ["FAST"] = "Fast",
    ["MID"] = "Mid",
    ["SLOW"] = "Slow",
    ["VERY_SLOW"] = "Very Slow",
    ["TIME_UNDER_10"] = "< 10 min",
    ["TIME_10_12"] = "10-12 min",
    ["TIME_12_15"] = "12-15 min",
    ["TIME_15_20"] = "15-20 min",
    ["TIME_20_PLUS"] = "20+ min",
    ["UNKNOWN"] = "Unknown",
    ["NO_EASY"] = "(No easy delves today)",
    ["MINIMAP_TOOLTIP_TITLE"] = "Delve Speed Tracker",
    ["MINIMAP_TOOLTIP_TOGGLE"] = "Left Click: Toggle Window",
    ["HELPTIP_CLICK_MAP"] = "Delve entries are clickable.\nClick a delve to open the world map to that zone.",
    --- Row hover tooltip: hint for the bottom line (AbstractFramework GameTooltip).
    ["TOOLTIP_CLICK_OPEN_MAP"] = "Click to open map.",
    ["POI_BOUNTIFUL_KEYWORD"] = "Bountiful",
    ["UNKNOWN_STORY_VARIANT"] = "Unknown story",
}

namespace.L_enUS = L
namespace.L = L
