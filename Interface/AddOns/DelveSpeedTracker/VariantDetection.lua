local ADDON_NAME, namespace = ...
local DST = namespace.DST
local AF = namespace.AF
local Locale = namespace.Locale
local StripColorCodes = namespace.StripColorCodes
local SecureWidgetCall = namespace.SecureWidgetCall

local VARIANT_TYPO_FIXES = {
    ["Captured Widlife"] = "Captured Wildlife",
}

--- Widget tooltip text can differ from GetAchievementCriteriaInfo wording (same meaning).
--- Keys: normalized/stripped text from the widget after NormalizeVariantFromWidget.
--- Values: English variant keys as in Data.lua (must exist in knownVariantKeys).
local VARIANT_WIDGET_TO_ENGLISH_KEY = {
    -- ruRU: POI shows "Вариант сюжета: Зеркальный блеск" but criteria use "Блеск зеркала".
    ["Зеркальный блеск"] = "Mirror Shine",
    -- koKR: widget "반짝이는 거울" vs criteria "거울의 빛" (same achievement line).
    ["반짝이는 거울"] = "Mirror Shine",
    -- koKR: widget "사로잡힌 야생동물" vs criteria "붙잡힌 야생동물".
    ["사로잡힌 야생동물"] = "Captured Wildlife",
    -- deDE: POI story line differs from achievement criteria wording for Twilight Crypts.
    ["Ungeladene Gäste"] = "Party Crasher",
}

local function FixVariantTypo(key)
    return VARIANT_TYPO_FIXES[key] or key
end

--- Map stripped criteria/widget text to English variant key (achievement map + widget aliases + typos).
local function ResolveEnglishVariantKey(stripped, achievementMap)
    if not stripped or stripped == "" then return nil end
    local key = achievementMap and achievementMap[stripped]
    if not key then
        key = VARIANT_WIDGET_TO_ENGLISH_KEY[stripped]
    end
    return FixVariantTypo(key or stripped)
end

function DST:FindBestVariantMatch(targetVariant, variants)
    if not targetVariant or not variants then return nil end
    local key = strtrim(strlower(targetVariant))
    if key == "" then return nil end
    for variantName in pairs(variants) do
        if strtrim(strlower(variantName)) == key then
            return variantName
        end
    end
    return nil
end

local function NormalizeVariantFromWidget(text)
    if not text or text == "" then return "" end
    local s = strtrim(StripColorCodes(text))
    -- Localized "Story variant:" lines (strip before any generic colon heuristic).
    s = s:gsub("^Story Variant:%s*", "")
    s = s:gsub("^Вариант сюжета:%s*", "")
    s = s:gsub("^이야기 변형:%s*", "")
    -- Timer tokens: leave as-is (colon heuristic would grab "time: 19h" etc.).
    if s:find("|4Min") or s:find("|4Sec") then
        return strtrim(s)
    end
    -- Bounty/chest blocks: many colons and newlines; never substring-match those.
    if #s > 160 or s:find("\n") then
        return strtrim(s)
    end
    -- Short lines only: "Something: Variant Name" fallback when prefix missing.
    if not (s:find("|4Min") or s:find("|4Sec")) then
        local after = s:match("^.-:%s*(.+)$")
        if after and after:find("[%a\128-\255]") then
            s = after
        end
    end
    return strtrim(s)
end

local function NormalizeVariantDisplayName(variantName)
    if not variantName or variantName == "" then return nil end
    local normalized = NormalizeVariantFromWidget(variantName)
    if normalized ~= "" then return normalized end
    local fallback = strtrim(StripColorCodes(variantName))
    return fallback ~= "" and fallback or nil
end

local function BuildAchievementVariantMap()
    if namespace.achievementVariantMap and next(namespace.achievementVariantMap) then return end
    local map = {}
    local delves = DST.delves
    if not delves then return end
    for _, delveInfo in pairs(delves) do
        local aid = delveInfo.storyAchievementID
        local order = delveInfo.variantOrder
        if aid and order and type(order) == "table" then
            local n = GetAchievementNumCriteria and GetAchievementNumCriteria(aid) or 0
            for i = 1, n do
                local criteriaString = GetAchievementCriteriaInfo and select(1, GetAchievementCriteriaInfo(aid, i))
                if criteriaString and criteriaString ~= "" and order[i] then
                    local stripped = strtrim(StripColorCodes(criteriaString))
                    if stripped ~= "" then map[stripped] = order[i] end
                end
            end
        end
    end
    if next(map) then namespace.achievementVariantMap = map else namespace.achievementVariantMap = nil end
end

local function BuildAchievementDelveNameMap()
    if namespace.achievementDelveNameMap and next(namespace.achievementDelveNameMap) then return end
    local map = {}
    local delves = DST.delves
    if not delves or not GetAchievementInfo then return end
    for delveName, delveInfo in pairs(delves) do
        local aid = delveInfo.storyAchievementID
        if aid and delveName and delveName ~= "" then
            local locName = select(2, GetAchievementInfo(aid))
            if locName and locName ~= "" then
                map[delveName] = strtrim(StripColorCodes(locName))
            end
        end
    end
    if next(map) then
        namespace.achievementDelveNameMap = map
        local rev = {}
        for en, loc in pairs(map) do rev[loc] = en end
        namespace.achievementDelveNameMapReverse = rev
    else
        namespace.achievementDelveNameMap = nil
        namespace.achievementDelveNameMapReverse = nil
    end
end

local function StripStorySuffix(name)
    if not name or name == "" then return name end
    return strtrim(name:gsub("%s%-%s.+$", ""))
end

local function ResolveDelveNameFromPoiName(poiName, mapId)
    if not poiName or poiName == "" then return nil end
    local strippedPoiName = StripStorySuffix(poiName)

    -- Delve table keys are the actual English delve names, which is what the
    -- POI displays — try this direct match before the achievement-title path.
    for delveName, delveInfo in pairs(DST.delves) do
        if (not mapId or delveInfo.mapId == mapId)
            and StripStorySuffix(delveName) == strippedPoiName then
            return delveName
        end
    end

    BuildAchievementDelveNameMap()
    local rev = namespace.achievementDelveNameMapReverse
    if rev and rev[poiName] then
        return rev[poiName]
    end
    local map = namespace.achievementDelveNameMap
    if not map then return nil end
    for en, loc in pairs(map) do
        if (not mapId or (DST.delves[en] and DST.delves[en].mapId == mapId))
            and StripStorySuffix(loc) == strippedPoiName then
            return en
        end
    end
    return nil
end

local function GetUnlistedVariantKey(delveInfo)
    if not delveInfo or not delveInfo.variants then return nil end
    local order = delveInfo.variantOrder
    if not order then return next(delveInfo.variants) end
    local inOrder = {}
    for _, k in ipairs(order) do inOrder[k] = true end
    for variantKey in pairs(delveInfo.variants) do
        if not inOrder[variantKey] then return variantKey end
    end
    return nil
end

local function PoiDescriptionIsBountiful(description)
    if not description or description == "" then return false end
    local bountKw = Locale("POI_BOUNTIFUL_KEYWORD")
    if bountKw == "POI_BOUNTIFUL_KEYWORD" then bountKw = "Bountiful" end
    return description:lower():find(bountKw:lower(), 1, true) ~= nil
end

local function GetPoiNormalizedPosition(poiInfo)
    if not poiInfo then return nil, nil end
    local x, y = nil, nil
    if poiInfo.position and type(poiInfo.position) == "table" then
        x, y = poiInfo.position.x, poiInfo.position.y
    elseif type(poiInfo.x) == "number" and type(poiInfo.y) == "number" then
        x, y = poiInfo.x, poiInfo.y
    elseif poiInfo.normalizedPosition and type(poiInfo.normalizedPosition) == "table" then
        x, y = poiInfo.normalizedPosition.x, poiInfo.normalizedPosition.y
    elseif poiInfo.mapPosition and type(poiInfo.mapPosition) == "table" then
        x, y = poiInfo.mapPosition.x, poiInfo.mapPosition.y
    end
    if type(x) == "number" and type(y) == "number" then
        if x > 1 or y > 1 then
            x, y = x / 100, y / 100
        end
        return x, y
    end
    return nil, nil
end

local function GetVariantNameFromWidgets(widgets, achievementMap, knownVariantKeys)
    if not widgets then return nil end

    local function TryGetTextFromWidget(widgetID)
        if not widgetID then return nil end
        if C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo then
            local info = SecureWidgetCall(C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo, widgetID)
            if info and info.text and info.text ~= "" then return info.text, info.orderIndex end
        end
        if C_UIWidgetManager.GetTextWidgetVisualizationInfo then
            local info = SecureWidgetCall(C_UIWidgetManager.GetTextWidgetVisualizationInfo, widgetID)
            if info and info.text and info.text ~= "" then return info.text, info.orderIndex end
        end
        if C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo then
            local info = SecureWidgetCall(C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo, widgetID)
            if info and info.text and info.text ~= "" then return info.text, info.orderIndex end
        end
        return nil
    end

    local function ToKnownVariantKey(text)
        if not text or text == "" then return nil end
        local stripped = NormalizeVariantFromWidget(text)
        if stripped == "" then return nil end
        local key = ResolveEnglishVariantKey(stripped, achievementMap)
        if knownVariantKeys and key and knownVariantKeys[key] then
            return key
        end
        return nil
    end

    for _, widget in pairs(widgets) do
        if widget and widget.widgetID then
            local text = select(1, TryGetTextFromWidget(widget.widgetID))
            local knownKey = ToKnownVariantKey(text)
            if knownKey then
                return text
            end
        end
    end

    for _, widget in pairs(widgets) do
        if widget and widget.widgetID then
            local text, orderIndex = TryGetTextFromWidget(widget.widgetID)
            if text then
                -- orderIndex 0 is usually the story line, but bountiful POIs also use 0 on
                -- timer/chest widgets — only return if it resolves to a known variant.
                if (orderIndex or 0) == 0 and ToKnownVariantKey(text) then
                    return text
                end
                local whiteMatch = text:find("WHITE_FONT_COLOR:", 1, true)
                if whiteMatch then
                    local v = text:match("WHITE_FONT_COLOR:(.*)")
                    if v and strtrim(v) ~= "" then return strtrim(v) end
                end
                if achievementMap then
                    local normalized = NormalizeVariantFromWidget(text)
                    if normalized ~= "" then
                        local rk = ResolveEnglishVariantKey(normalized, achievementMap)
                        if rk and knownVariantKeys and knownVariantKeys[rk] then
                            return normalized
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function TryAddPoiToActiveVariants(activeVariants, delveInfo, areaPoiID, poiInfo, achievementMap, knownVariantKeys)
    local widgets = nil
    if poiInfo and poiInfo.tooltipWidgetSet then
        widgets = SecureWidgetCall(C_UIWidgetManager.GetAllWidgetsBySetID, poiInfo.tooltipWidgetSet)
    end
    local variantName = GetVariantNameFromWidgets(widgets, achievementMap, knownVariantKeys)
    local descBountiful = PoiDescriptionIsBountiful(poiInfo.description or "")
    local isBountiful = (poiInfo.atlasName == "delves-bountiful") or descBountiful
    local poiName = (poiInfo.name and poiInfo.name ~= "") and strtrim(StripColorCodes(poiInfo.name)) or nil
    local poiX, poiY = GetPoiNormalizedPosition(poiInfo)

    if variantName and variantName ~= "" then
        local stripped = NormalizeVariantFromWidget(variantName)
        if stripped == "" then stripped = strtrim(StripColorCodes(variantName)) end
        local englishKey = ResolveEnglishVariantKey(stripped, achievementMap)
        if englishKey and englishKey ~= "" and knownVariantKeys and knownVariantKeys[englishKey] then
            activeVariants[englishKey] = {
                bountiful = isBountiful,
                mapId = delveInfo.mapId,
                areaPoiID = areaPoiID,
                poiName = poiName,
                variantDisplayName = NormalizeVariantDisplayName(variantName),
                poiX = poiX,
                poiY = poiY,
            }
            return true
        end
    end
    
    -- Safeguard: if the delve POI is known but the story variant text could not be resolved,
    -- keep the delve visible and use an average fallback rank ("B", unknown story).
    local resolvedDelveName = ResolveDelveNameFromPoiName(poiName, delveInfo and delveInfo.mapId)
    if resolvedDelveName then
        local unknownKey = "__UNKNOWN__:" .. resolvedDelveName
        local info = DST.delves[resolvedDelveName]
        activeVariants[unknownKey] = {
            bountiful = isBountiful,
            mapId = (info and info.mapId) or (delveInfo and delveInfo.mapId),
            areaPoiID = areaPoiID,
            poiName = poiName,
            variantDisplayName = nil,
            unknownStory = true,
            detectedDelveName = resolvedDelveName,
            poiX = poiX,
            poiY = poiY,
        }
        return true
    end
    return false
end

--- Snapshot of last full scan; used while world map is open to avoid C_UIWidgetManager calls
--- interleaving with Blizzard GameTooltip POI widget layout (taint on textHeight).
local function CopyActiveVariantsForCache(t)
    local out = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            out[k] = {}
            for k2, v2 in pairs(v) do
                out[k][k2] = v2
            end
        else
            out[k] = v
        end
    end
    return out
end

---@param forceFull boolean|nil When true, always scan (e.g. debug); ignores map-open cache.
function DST:GetCurrentDelveVariants(forceFull)
    -- Never call C_UIWidgetManager / POI widget reads while the map is open: it taints Blizzard's
    -- GameTooltip + QuestMapFrame numeric layout (secret number errors on hover).
    if WorldMapFrame and WorldMapFrame:IsShown() then
        if namespace.cachedActiveVariants then
            return namespace.cachedActiveVariants
        end
        return {}
    end
    local activeVariants = {}
    local processedMaps = {}
    BuildAchievementVariantMap()
    local achievementMap = namespace.achievementVariantMap or {}
    local delves = DST.delves
    if not delves then return activeVariants end

    local knownVariantKeys = {}
    for delveName, delveInfo in pairs(delves) do
        if delveInfo and delveInfo.variants then
            for variantKey in pairs(delveInfo.variants) do
                knownVariantKeys[variantKey] = true
            end
        end
    end

    for _, delveInfo in pairs(delves) do
        if delveInfo and delveInfo.mapId and not processedMaps[delveInfo.mapId] then
            processedMaps[delveInfo.mapId] = true
            local pois = C_AreaPoiInfo.GetDelvesForMap(delveInfo.mapId)
            if pois then
                for _, areaPoiID in ipairs(pois) do
                    local poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(delveInfo.mapId, areaPoiID)
                    if poiInfo then
                        TryAddPoiToActiveVariants(activeVariants, delveInfo, areaPoiID, poiInfo, achievementMap, knownVariantKeys)
                    end
                end
            end
        end
    end
    namespace.cachedActiveVariants = CopyActiveVariantsForCache(activeVariants)
    return activeVariants
end

local function ShortDelveName(name)
    return name:gsub("^The ", ""):gsub(" Sanctum$", ""):gsub(" Cavern$", ""):gsub(" Mines$", "")
end

local function GetDelveDisplayName(delveName)
    BuildAchievementDelveNameMap()
    local map = namespace.achievementDelveNameMap
    if map and map[delveName] then
        return map[delveName]
    end
    return ShortDelveName(delveName)
end

local function NormalizeVariantData(variantData, defaultMapId)
    if type(variantData) == "table" then
        return {
            bountiful = variantData.bountiful or (variantData == "bountiful"),
            mapId = variantData.mapId or defaultMapId,
            areaPoiID = variantData.areaPoiID,
            poiName = (variantData.poiName and variantData.poiName ~= "") and variantData.poiName or nil,
            variantDisplayName = (variantData.variantDisplayName and variantData.variantDisplayName ~= "") and variantData.variantDisplayName or nil,
            poiX = variantData.poiX,
            poiY = variantData.poiY,
        }
    end
    return {
        bountiful = (variantData == "bountiful"),
        mapId = defaultMapId,
        areaPoiID = nil,
        poiName = nil,
        variantDisplayName = nil,
        poiX = nil,
        poiY = nil,
    }
end

local function BuildActiveDelvesList(activeVariants, delves)
    local activeDelves = {}
    local unknownStoryLabel = Locale("UNKNOWN_STORY_VARIANT")
    if unknownStoryLabel == "UNKNOWN_STORY_VARIANT" then
        unknownStoryLabel = "Unknown story"
    end
    for delveName, delveInfo in pairs(delves) do
        local foundMatch = false
        for detectedVariant, variantData in pairs(activeVariants) do
            if not foundMatch then
                local match = DST:FindBestVariantMatch(detectedVariant, delveInfo.variants)
                if match then
                    local difficulty = delveInfo.variants[match]
                    local config = DST.difficultyConfig[difficulty]
                    local v = NormalizeVariantData(variantData, delveInfo.mapId)
                    local displayBase = v.poiName or GetDelveDisplayName(delveName)
                    local variantDisplayName = v.variantDisplayName or match
                    local bountifulLabel = v.bountiful and (" (" .. Locale("POI_BOUNTIFUL_KEYWORD") .. ")") or ""

                    if config then
                        table.insert(activeDelves, {
                            delveName = delveName,
                            variantName = match,
                            difficulty = difficulty,
                            priority = config.priority,
                            timeKey = config.timeKey,
                            mapId = v.mapId,
                            areaPoiID = v.areaPoiID,
                            isBountiful = v.bountiful,
                            poiX = v.poiX,
                            poiY = v.poiY,
                            displayName = v.bountiful and
                                string.format("|cffFFD700%s|r |A:delves-bountiful:16:16:0:0|a", displayBase) or
                                string.format("|cffCBD5E1%s|r", displayBase),
                            tooltipLines = {
                                displayBase .. bountifulLabel,
                                variantDisplayName,
                                config.color .. Locale(config.nameKey) .. "|r",
                                config.color .. Locale(config.timeKey) .. "|r",
                            },
                        })
                        foundMatch = true
                    end
                end
            end
        end
        if not foundMatch then
            local unknownData = activeVariants["__UNKNOWN__:" .. delveName]
            if type(unknownData) == "table" then
                local v = NormalizeVariantData(unknownData, delveInfo.mapId)
                local difficulty = "B"
                local config = DST.difficultyConfig[difficulty]
                if config then
                    local displayBase = v.poiName or GetDelveDisplayName(delveName)
                    local bountifulLabel = v.bountiful and (" (" .. Locale("POI_BOUNTIFUL_KEYWORD") .. ")") or ""
                    table.insert(activeDelves, {
                        delveName = delveName,
                        variantName = unknownStoryLabel,
                        difficulty = difficulty,
                        priority = config.priority,
                        timeKey = config.timeKey,
                        mapId = v.mapId,
                        areaPoiID = v.areaPoiID,
                        isBountiful = v.bountiful,
                        poiX = v.poiX,
                        poiY = v.poiY,
                        displayName = v.bountiful and
                            string.format("|cffFFD700%s|r |A:delves-bountiful:16:16:0:0|a", displayBase) or
                            string.format("|cffCBD5E1%s|r", displayBase),
                        tooltipLines = {
                            displayBase .. bountifulLabel,
                            unknownStoryLabel,
                            config.color .. Locale(config.nameKey) .. "|r",
                            config.color .. Locale(config.timeKey) .. "|r",
                        },
                    })
                end
            end
        end
    end
    table.sort(activeDelves, function(a, b) return a.priority < b.priority end)
    return activeDelves
end

namespace.FixVariantTypo = FixVariantTypo
namespace.ResolveEnglishVariantKey = ResolveEnglishVariantKey
namespace.NormalizeVariantFromWidget = NormalizeVariantFromWidget
namespace.GetVariantNameFromWidgets = GetVariantNameFromWidgets
namespace.BuildAchievementVariantMap = BuildAchievementVariantMap
namespace.BuildAchievementDelveNameMap = BuildAchievementDelveNameMap
namespace.BuildActiveDelvesList = BuildActiveDelvesList
