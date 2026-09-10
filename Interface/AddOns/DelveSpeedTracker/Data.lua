local ADDON_NAME, namespace = ...
local DST = namespace.DST

DST.DB_DEFAULTS = {
    framePosition = nil,
    windowShown = true,
    helpTipShown = false,
    tomtomArrowsEnabled = true,
    --- When true, body/content margins are tinted in-game (see /dstdebuglayout).
    layoutDebugOverlay = false,
    minimap = {
        hide = false,
        minimapPos = 220,
    },
}

DST.ZONE_ICON_FILE = "Interface\\MajorFactions\\MidnightMajorFactionsIcons"
DST.zoneIconTexCoords = {
    [2393] = { 0.25, 0.50, 0.00, 0.25 }, -- Silvermoon Court
    [2395] = { 0.25, 0.50, 0.00, 0.25 }, -- Silvermoon Court
    [2405] = { 0.50, 0.75, 0.25, 0.50 }, -- Voidstorm (Shadowstep Cadre)
    [2413] = { 0.25, 0.50, 0.25, 0.50 }, -- Harandar (Harati Tribe)
    [2424] = { 0.25, 0.50, 0.00, 0.25 }, -- Silvermoon Court
    [2437] = { 0.50, 0.75, 0.00, 0.25 }, -- Zul'aman (Amani Tribe)
    [2512] = { 0.25, 0.50, 0.50, 0.75 }, -- The Coiled Isle
    [2536] = { 0.25, 0.50, 0.50, 0.75 }, -- The Coiled Isle
    [2537] = { 0.25, 0.50, 0.00, 0.25 }, -- Silvermoon Court
}

DST.zoneIcons = {
    [2393] = "majorfactions_icons_silvermooncourt512",
    [2395] = "majorfactions_icons_silvermooncourt512",
    [2405] = "majorfactions_icons_shadowstepcadre512",
    [2413] = "majorfactions_icons_haratitribe512",
    [2424] = "majorfactions_icons_silvermooncourt512",
    [2437] = "majorfactions_icons_amanitribe512",
    [2512] = "majorfactions_icons_coiledisle512",
    [2536] = "majorfactions_icons_coiledisle512",
    [2537] = "majorfactions_icons_silvermooncourt512",
}

-- Delve Loremaster: Midnight (61741). variantOrder matches GetAchievementCriteriaInfo order. S=Turbo .. F=Very Slow.
DST.delves = {
    ["Sunkiller Sanctum"]    = { mapId = 2405, storyAchievementID = 61732, variantOrder = { "Core of the Problem", "The Gravitational Effect", "Not What I Expected" }, variants = {
        ["Core of the Problem"]       = "B",
        ["The Gravitational Effect"]  = "C",
        ["Not What I Expected"]        = "D",
    } },
    ["The Grudge Pit"]       = { mapId = 2413, storyAchievementID = 61724, variantOrder = { "Dastardly Rotstalk", "Arena Champion", "Lightbloom Invasion", "Fungal Pharmacon" }, variants = {
        ["Dastardly Rotstalk"]        = "D",
        ["Arena Champion"]            = "A",
        ["Lightbloom Invasion"]       = "F",
        ["Fungal Pharmacon"]          = "B",
    } },
    ["Parhelion Plaza"]      = { mapId = 2424, storyAchievementID = 61725, variantOrder = { "Holding the Line", "March of the Arcane Brigade", "Bombing Run", "Caustic Crush" }, variants = {
        ["Holding the Line"]          = "B",
        ["March of the Arcane Brigade"] = "F",
        ["Bombing Run"]               = "D",
        ["Caustic Crush"]             = "B",
    } },
    ["Twilight Crypts"]      = { mapId = 2437, storyAchievementID = 61730, variantOrder = { "Party Crasher", "Trapped!", "Loosed Loa", "Why'd it Have to Be Snakes?" }, variants = {
        ["Party Crasher"]             = "C",
        ["Trapped!"]                  = "C",
        ["Loosed Loa"]                = "F",
        ["Why'd it Have to Be Snakes?"] = "B",
    } },
    ["Collegiate Calamity"]  = { mapId = 2395, storyAchievementID = 61726, variantOrder = { "Invasive Glow", "Academy Under Siege", "Faculty of Fear", "Academic Antitoxin" }, variants = {
        ["Invasive Glow"]             = "S",
        ["Academy Under Siege"]        = "D",
        ["Faculty of Fear"]            = "D",
        ["Academic Antitoxin"]         = "B",
    } },
    ["The Darkway"]          = { mapId = 2395, storyAchievementID = 61728, variantOrder = { "Focusers Under Pressure", "Leyline Technician", "Ogre Powered" }, variants = {
        ["Focusers Under Pressure"]   = "A",
        ["Leyline Technician"]        = "F",
        ["Ogre Powered"]              = "S",
    } },
    ["Shadowguard Point"]    = { mapId = 2405, storyAchievementID = 61733, variantOrder = { "Stolen Mana", "Calamitous", "Captured Wildlife", "Basilisk Blitz" }, variants = {
        ["Stolen Mana"]               = "A",
        ["Calamitous"]                = "C",
        ["Captured Wildlife"]          = "D",
        ["Basilisk Blitz"]             = "B",
    } },
    ["The Gulf of Memory"]   = { mapId = 2413, storyAchievementID = 61731, variantOrder = { "Descent of the Haranir", "Alnmoth Munchies", "Sporasaur Special" }, variants = {
        ["Descent of the Haranir"]     = "B",
        ["Alnmoth Munchies"]           = "B",
        ["Sporasaur Special"]          = "S",
    } },
    ["The Shadow Enclave"]   = { mapId = 2395, storyAchievementID = 61727, variantOrder = { "Traitor's Due", "Shadowy Supplies", "Mirror Shine", "Basilisk Blitz" }, variants = {
        ["Traitor's Due"]             = "S",
        ["Shadowy Supplies"]           = "F",
        ["Mirror Shine"]               = "D",
        ["Basilisk Blitz"]             = "B",
    } },
    ["Atal'Aman"]            = { mapId = 2437, storyAchievementID = 61729, variantOrder = { "Totem Annihilation", "Ritual Interrupted", "Toadly Unbecoming", "Venomous Vapors" }, variants = {
        ["Totem Annihilation"]        = "C",
        ["Ritual Interrupted"]         = "F",
        ["Toadly Unbecoming"]          = "S",
        ["Venomous Vapors"]            = "B",
    } },
    ["Gnarldor Isle"]        = { mapId = 2512, storyAchievementID = 63437, variantOrder = { "Olds and Ends", "Minchi's Osseous Adventure", "Speaking Their Language" }, variants = {
        ["Olds and Ends"]             = "B",
        ["Minchi's Osseous Adventure"] = "C",
        ["Speaking Their Language"]   = "A",
    } },
    ["The Ring of Glory"]    = { mapId = 2512, storyAchievementID = 63436, variantOrder = { "Open Night", "Game Day", "Adopt-a-thon" }, variants = {
        ["Open Night"]                = "B",
        ["Game Day"]                  = "S",
        ["Adopt-a-thon"]              = "D",
    } },
}

DST.difficultyConfig = {
    ["S"] = { nameKey = "TURBO",       timeKey = "TIME_UNDER_10",  color = "|cff22C55E", priority = 1 },
    ["A"] = { nameKey = "FAST",        timeKey = "TIME_10_12",     color = "|cff84CC16", priority = 2 },
    ["B"] = { nameKey = "MID",         timeKey = "TIME_12_15",     color = "|cffF97316", priority = 3 },
    ["C"] = { nameKey = "SLOW",        timeKey = "TIME_15_20",     color = "|cffEF4444", priority = 4 },
    ["D"] = { nameKey = "VERY_SLOW",   timeKey = "TIME_20_PLUS",   color = "|cffB91C1C", priority = 5 },
}
