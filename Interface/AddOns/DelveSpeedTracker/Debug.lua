local ADDON_NAME, namespace = ...
local DST = namespace.DST
local InCombat = namespace.InCombat
local StripColorCodes = namespace.StripColorCodes
local NormalizeVariantFromWidget = namespace.NormalizeVariantFromWidget
local GetVariantNameFromWidgets = namespace.GetVariantNameFromWidgets
local BuildAchievementVariantMap = namespace.BuildAchievementVariantMap
local BuildAchievementDelveNameMap = namespace.BuildAchievementDelveNameMap
local BuildActiveDelvesList = namespace.BuildActiveDelvesList
local FixVariantTypo = namespace.FixVariantTypo
local ResolveEnglishVariantKey = namespace.ResolveEnglishVariantKey
local SecureWidgetCall = namespace.SecureWidgetCall

local function ChatPrint(msg)
    if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
        DEFAULT_CHAT_FRAME:AddMessage("|cff7DD3FC[DST]|r " .. tostring(msg))
    end
end

--- Long strings (widget text, descriptions) split so chat does not truncate silently.
local function ChatPrintLong(prefix, text, maxChunk)
    maxChunk = maxChunk or 340
    if text == nil then
        ChatPrint(prefix .. "(nil)")
        return
    end
    text = tostring(text)
    if #text <= maxChunk then
        ChatPrint(prefix .. text)
        return
    end
    ChatPrint(prefix .. "(len=" .. #text .. ", split)")
    local pos = 1
    local n = 0
    while pos <= #text and n < 40 do
        n = n + 1
        ChatPrint("  | " .. text:sub(pos, pos + maxChunk - 1))
        pos = pos + maxChunk
    end
end

--- Clear cached achievement lookups so the next build reflects current locale.
local function InvalidateAchievementCaches()
    namespace.achievementVariantMap = nil
    namespace.achievementDelveNameMap = nil
    namespace.achievementDelveNameMapReverse = nil
    namespace.cachedActiveVariants = nil
end

--- Try every widget text API we use in VariantDetection; include widgetType for unknown types.
local function DumpWidgetSetDeep(widgetSet)
    if not widgetSet then return {} end
    local widgets = SecureWidgetCall(C_UIWidgetManager.GetAllWidgetsBySetID, widgetSet)
    if not widgets then return {} end
    local out = {}
    for _, w in pairs(widgets) do
        if w and w.widgetID then
            local wid = w.widgetID
            local wtype = w.widgetType
            local pieces = {}
            if C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo then
                local info = SecureWidgetCall(C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo, wid)
                if info and info.text and info.text ~= "" then
                    pieces[#pieces + 1] = ("TextWithState[o=%s]=%s"):format(tostring(info.orderIndex), info.text)
                end
            end
            if C_UIWidgetManager.GetTextWidgetVisualizationInfo then
                local info = SecureWidgetCall(C_UIWidgetManager.GetTextWidgetVisualizationInfo, wid)
                if info and info.text and info.text ~= "" then
                    pieces[#pieces + 1] = ("Text[o=%s]=%s"):format(tostring(info.orderIndex), info.text)
                end
            end
            if C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo then
                local info = SecureWidgetCall(C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo, wid)
                if info and info.text and info.text ~= "" then
                    pieces[#pieces + 1] = ("IconAndText[o=%s]=%s"):format(tostring(info.orderIndex), info.text)
                end
            end
            out[#out + 1] = {
                widgetID = wid,
                widgetType = wtype,
                pieces = pieces,
            }
        end
    end
    return out
end

--- Full localization / POI trace for missing delve (e.g. RU client + Shadow Enclave).
--- Run out of combat. Clears achievement caches first.
function DST:DebugTraceLocalization()
    if InCombat() then
        ChatPrint("Debug trace blocked in combat.")
        return
    end

    InvalidateAchievementCaches()
    BuildAchievementVariantMap()
    BuildAchievementDelveNameMap()

    local achievementMap = namespace.achievementVariantMap or {}
    local achievementDelveNameMap = namespace.achievementDelveNameMap or {}
    local achievementDelveNameMapReverse = namespace.achievementDelveNameMapReverse or {}

    local knownVariantKeys = {}
    for _, delveInfo in pairs(DST.delves or {}) do
        if delveInfo and delveInfo.variants then
            for variantKey in pairs(delveInfo.variants) do
                knownVariantKeys[variantKey] = true
            end
        end
    end

    ChatPrint("========== DST DEBUG TRACE (locale / POI / achievements) ==========")
    ChatPrint(("Locale GetLocale()=%s"):format(tostring(GetLocale and GetLocale() or "?")))

    -- 1) MapId collisions: GetCurrentDelveVariants only iterates ONE delveInfo per mapId (pairs order).
    local byMap = {}
    for delveName, delveInfo in pairs(DST.delves or {}) do
        if delveInfo and delveInfo.mapId then
            byMap[delveInfo.mapId] = byMap[delveInfo.mapId] or {}
            table.insert(byMap[delveInfo.mapId], delveName)
        end
    end
    ChatPrint("--- MapId shared by multiple configured delves (scan uses first in pairs() order) ---")
    for mapId, names in pairs(byMap) do
        if #names > 1 then
            table.sort(names)
            ChatPrint(("  mapId=%d  (%d delves): %s"):format(mapId, #names, table.concat(names, " | ")))
        end
    end

    local processedMaps = {}
    ChatPrint("--- First delve per mapId as iterated by pairs(DST.delves) (same as GetCurrentDelveVariants) ---")
    for delveName, delveInfo in pairs(DST.delves or {}) do
        if delveInfo and delveInfo.mapId and not processedMaps[delveInfo.mapId] then
            processedMaps[delveInfo.mapId] = true
            ChatPrint(("  mapId=%d  <- first seen delve key: %s"):format(delveInfo.mapId, delveName))
        end
    end

    -- 2) Each configured delve: achievement title + criteria strings + map to variantOrder
    ChatPrint("--- Per-delve story achievements (localized titles) + criteria -> variantKey ---")
    local delveKeys = {}
    for k in pairs(DST.delves or {}) do delveKeys[#delveKeys + 1] = k end
    table.sort(delveKeys)

    for _, delveName in ipairs(delveKeys) do
        local delveInfo = DST.delves[delveName]
        if delveInfo then
            local aid = delveInfo.storyAchievementID
            local order = delveInfo.variantOrder
            local titleLoc = "(no GetAchievementInfo)"
            if aid and GetAchievementInfo then
                local t = select(2, GetAchievementInfo(aid))
                if t and t ~= "" then titleLoc = strtrim(StripColorCodes(t)) end
            end
            ChatPrint((">> %s | mapId=%s | storyAchievementID=%s"):format(
                delveName, tostring(delveInfo.mapId), tostring(aid)))
            ChatPrint(("   achievementTitle(loc)=%s"):format(titleLoc))
            local revLoc = achievementDelveNameMap[delveName]
            if revLoc then
                ChatPrint(("   achievementDelveNameMap[en]=%s"):format(revLoc))
            end
            if aid and GetAchievementNumCriteria and GetAchievementCriteriaInfo then
                local n = GetAchievementNumCriteria(aid) or 0
                ChatPrint(("   criteria count=%d (variantOrder len=%s)"):format(n, order and #order or "nil"))
                for i = 1, n do
                    local raw = select(1, GetAchievementCriteriaInfo(aid, i))
                    local stripped = raw and strtrim(StripColorCodes(raw)) or ""
                    local expectKey = order and order[i]
                    local mapped = stripped ~= "" and achievementMap[stripped] or nil
                    ChatPrintLong(("   crit[%d] expectKey=%s | raw="):format(i, tostring(expectKey)), raw or "")
                    ChatPrint(("        stripped=%s | achievementVariantMap[stripped]=%s"):format(
                        stripped, tostring(mapped)))
                end
            end
        end
    end

    -- 3) Reverse map: localized achievement title -> English delve key (POI name fallback)
    ChatPrint("--- achievementDelveNameMapReverse (POI name must match this for fallback path) ---")
    if next(achievementDelveNameMapReverse) then
        for loc, en in pairs(achievementDelveNameMapReverse) do
            ChatPrint(("  loc[%s] -> en[%s]"):format(tostring(loc), tostring(en)))
        end
    else
        ChatPrint("  (empty)")
    end

    -- 4) activeVariants + delves with no matching variant
    local activeVariants = DST:GetCurrentDelveVariants(true)
    ChatPrint("--- activeVariants (resolved English variant keys this week) ---")
    if activeVariants and next(activeVariants) then
        local ks = {}
        for k in pairs(activeVariants) do ks[#ks + 1] = k end
        table.sort(ks)
        for _, k in ipairs(ks) do
            local v = activeVariants[k]
            ChatPrint(("  %s | bountiful=%s mapId=%s areaPoiID=%s poiName=%s display=%s"):format(
                k,
                tostring(v and v.bountiful),
                tostring(v and v.mapId),
                tostring(v and v.areaPoiID),
                tostring(v and v.poiName),
                tostring(v and v.variantDisplayName)
            ))
        end
    else
        ChatPrint("  (none)")
    end

    ChatPrint("--- Delves with NO variant key present in activeVariants (likely missing / mismatch) ---")
    for _, delveName in ipairs(delveKeys) do
        local delveInfo = DST.delves[delveName]
        if delveInfo and delveInfo.variants then
            local hit = false
            for vk in pairs(delveInfo.variants) do
                if activeVariants and activeVariants[vk] then
                    hit = true
                    break
                end
            end
            if not hit then
                ChatPrint(("  MISSING: %s (mapId=%s aid=%s)"):format(
                    delveName, tostring(delveInfo.mapId), tostring(delveInfo.storyAchievementID)))
            end
        end
    end

    -- 5) Every POI on every delve map: widget dump + normalization + map lookup
    ChatPrint("--- All map POIs: widget text, NormalizeVariantFromWidget, achievementVariantMap lookup ---")
    local processedMaps2 = {}
    for _, delveInfo in pairs(DST.delves or {}) do
        if delveInfo and delveInfo.mapId and not processedMaps2[delveInfo.mapId] then
            processedMaps2[delveInfo.mapId] = true
            local mapId = delveInfo.mapId
            local pois = C_AreaPoiInfo.GetDelvesForMap(mapId)
            local nPoi = pois and #pois or 0
            ChatPrint(("--- mapId=%d  GetDelvesForMap count=%s ---"):format(mapId, tostring(nPoi)))
            if pois then
                for _, areaPoiID in ipairs(pois) do
                    local poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(mapId, areaPoiID)
                    local name = (poiInfo and poiInfo.name and poiInfo.name ~= "") and strtrim(StripColorCodes(poiInfo.name)) or nil
                    local desc = poiInfo and poiInfo.description or nil
                    local atlasName = poiInfo and poiInfo.atlasName or nil
                    local widgetSet = poiInfo and poiInfo.tooltipWidgetSet or nil
                    ChatPrint(("  POI map=%d id=%d | name=%s | atlas=%s | widgetSet=%s"):format(
                        mapId, areaPoiID, name or "nil", atlasName or "nil", widgetSet and tostring(widgetSet) or "nil"))
                    if desc and desc ~= "" then
                        ChatPrintLong("    description=", desc)
                    end
                    local revMatch = name and achievementDelveNameMapReverse[name] or nil
                    if name then
                        ChatPrint(("    POI name -> reverse[poiName]=%s"):format(tostring(revMatch)))
                    end
                    if widgetSet then
                        local deep = DumpWidgetSetDeep(widgetSet)
                        for i = 1, #deep do
                            local d = deep[i]
                            ChatPrint(("    widget[%d] id=%s type=%s"):format(i, tostring(d.widgetID), tostring(d.widgetType)))
                            for p = 1, #(d.pieces or {}) do
                                ChatPrintLong("      ", d.pieces[p])
                            end
                            if not d.pieces or #d.pieces == 0 then
                                ChatPrint("      (no text from Text/TextWithState/IconAndText APIs)")
                            end
                        end
                        local widgets = SecureWidgetCall(C_UIWidgetManager.GetAllWidgetsBySetID, widgetSet)
                        local detected = GetVariantNameFromWidgets(widgets, achievementMap, knownVariantKeys)
                        local norm = detected and NormalizeVariantFromWidget(detected) or nil
                        local stripped = norm and norm ~= "" and norm or (detected and strtrim(StripColorCodes(detected)) or nil)
                        local directMap = stripped and achievementMap[stripped] or nil
                        local resolvedKey = stripped and ResolveEnglishVariantKey(stripped, achievementMap) or nil
                        local ok = resolvedKey and knownVariantKeys[resolvedKey] and resolvedKey or nil
                        ChatPrint(("    GetVariantNameFromWidgets -> %s"):format(tostring(detected)))
                        ChatPrint(("    Normalize -> %s | achievementMap[stripped]=%s | ResolveEnglishVariantKey -> %s | validKey=%s"):format(
                            tostring(norm), tostring(directMap), tostring(resolvedKey), tostring(ok)))
                    end
                end
            end
        end
    end

    ChatPrint("========== END DST DEBUG TRACE ==========")
    ChatPrint("Tip: compare crit[i] stripped strings to widget text; if they differ, mapping fails.")
    ChatPrint("Tip: mapId with multiple delves: variant detection uses global achievementVariantMap; POI fallback needs exact POI name == localized achievement title.")
end

---@param verbose boolean|nil If true, prints per-POI details.
---@return table report
function DST:DebugCheckPOIAndAchievements(verbose)
    verbose = not not verbose

    if InCombat() then
        ChatPrint("Debug scan blocked in combat.")
        return nil
    end

    BuildAchievementVariantMap()
    BuildAchievementDelveNameMap()

    local achievementMap = namespace.achievementVariantMap or {}
    local achievementDelveNameMapReverse = namespace.achievementDelveNameMapReverse or {}

    local function GetWidgetTextDump(widgets)
        if not widgets then return nil end
        local out = {}
        for _, widget in pairs(widgets) do
            if widget and widget.widgetID then
                local entry = {
                    widgetID = widget.widgetID,
                    widgetType = widget.widgetType,
                    textWithState = nil,
                    textWithStateOrderIndex = nil,
                    text = nil,
                    textOrderIndex = nil,
                    iconAndText = nil,
                    iconAndTextOrderIndex = nil,
                }
                if C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo then
                    local info = SecureWidgetCall(C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo, widget.widgetID)
                    if info and info.text and info.text ~= "" then
                        entry.textWithState = info.text
                        entry.textWithStateOrderIndex = info.orderIndex
                    end
                end
                if C_UIWidgetManager.GetTextWidgetVisualizationInfo then
                    local info = SecureWidgetCall(C_UIWidgetManager.GetTextWidgetVisualizationInfo, widget.widgetID)
                    if info and info.text and info.text ~= "" then
                        entry.text = info.text
                        entry.textOrderIndex = info.orderIndex
                    end
                end
                if C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo then
                    local info = SecureWidgetCall(C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo, widget.widgetID)
                    if info and info.text and info.text ~= "" then
                        entry.iconAndText = info.text
                        entry.iconAndTextOrderIndex = info.orderIndex
                    end
                end
                if entry.textWithState or entry.text or entry.iconAndText then
                    out[#out + 1] = entry
                end
            end
        end
        return out
    end

    if verbose then
        ChatPrint("=== Achievement criteria -> variant mapping ===")
        for delveName, delveInfo in pairs(DST.delves or {}) do
            local aid = delveInfo and delveInfo.storyAchievementID
            local order = delveInfo and delveInfo.variantOrder
            if aid and order and type(order) == "table" then
                local n = (GetAchievementNumCriteria and GetAchievementNumCriteria(aid)) or 0
                ChatPrint(("Achievement: delve=%s aid=%d criteriaCount=%d"):format(tostring(delveName), aid, n))
                for i = 1, n do
                    local raw = GetAchievementCriteriaInfo and select(1, GetAchievementCriteriaInfo(aid, i))
                    if raw and raw ~= "" then
                        local stripped = strtrim(StripColorCodes(raw))
                        local variantKey = order[i]
                        ChatPrint(("  criteria[%d]=%s -> variantKey=%s"):format(i, stripped, tostring(variantKey)))
                    else
                        ChatPrint(("  criteria[%d]=<empty> -> variantKey=%s"):format(i, tostring(order[i])))
                    end
                end
            end
        end

        ChatPrint("=== Localized delve names (english -> localized) ===")
        if namespace.achievementDelveNameMap then
            for en, loc in pairs(namespace.achievementDelveNameMap) do
                ChatPrint(("  %s = %s"):format(en, tostring(loc)))
            end
        else
            ChatPrint("  (achievementDelveNameMap not available)")
        end

        ChatPrint("=== achievementVariantMap (normalized criteria text -> variant key) ===")
        if achievementMap and next(achievementMap) then
            for criteriaText, variantKey in pairs(achievementMap) do
                ChatPrint(("  %s -> %s"):format(tostring(criteriaText), tostring(variantKey)))
            end
        else
            ChatPrint("  (achievementVariantMap empty)")
        end
    end

    local knownVariantKeys = {}
    for _, delveInfo in pairs(DST.delves or {}) do
        if delveInfo and delveInfo.variants then
            for variantKey in pairs(delveInfo.variants) do
                knownVariantKeys[variantKey] = true
            end
        end
    end

    local activeVariants = DST:GetCurrentDelveVariants(true)
    local activeDelves = BuildActiveDelvesList(activeVariants, DST.delves)

    local report = {
        activeDelves = activeDelves,
        totals = {
            mapsScanned = 0,
            poisScanned = 0,
            poisWithWidgetSet = 0,
            poisDetectedVariantText = 0,
            poisResolvedVariantKey = 0,
            poisMatchedActiveVariant = 0,
            poisUnmatchedVariant = 0,
        },
        perPOI = {},
    }

    local processedMaps = {}
    local delves = DST.delves or {}
    for _, delveInfo in pairs(delves) do
        if delveInfo and delveInfo.mapId and not processedMaps[delveInfo.mapId] then
            processedMaps[delveInfo.mapId] = true
            report.totals.mapsScanned = report.totals.mapsScanned + 1

            local mapId = delveInfo.mapId
            local pois = C_AreaPoiInfo.GetDelvesForMap(mapId)
            if pois then
                for _, areaPoiID in ipairs(pois) do
                    report.totals.poisScanned = report.totals.poisScanned + 1

                    local poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(mapId, areaPoiID)
                    local name = (poiInfo and poiInfo.name and poiInfo.name ~= "") and strtrim(StripColorCodes(poiInfo.name)) or nil
                    local description = poiInfo and poiInfo.description or nil
                    local atlasName = poiInfo and poiInfo.atlasName or nil
                    local widgetSet = poiInfo and poiInfo.tooltipWidgetSet or nil
                    if widgetSet then report.totals.poisWithWidgetSet = report.totals.poisWithWidgetSet + 1 end

                    local widgets = nil
                    if widgetSet then
                        widgets = SecureWidgetCall(C_UIWidgetManager.GetAllWidgetsBySetID, widgetSet)
                    end

                    local detectedVariantText = GetVariantNameFromWidgets(widgets, achievementMap, knownVariantKeys)
                    local detectedNormalizedVariant = detectedVariantText and NormalizeVariantFromWidget(detectedVariantText) or nil

                    local resolvedVariantKey = nil
                    local stripped = detectedNormalizedVariant
                    if detectedVariantText and detectedVariantText ~= "" then
                        if stripped == "" then
                            stripped = strtrim(StripColorCodes(detectedVariantText))
                        end

                        resolvedVariantKey = ResolveEnglishVariantKey(stripped, achievementMap)

                        if not (resolvedVariantKey and knownVariantKeys[resolvedVariantKey]) then
                            resolvedVariantKey = nil
                        end
                    end

                    if detectedVariantText then report.totals.poisDetectedVariantText = report.totals.poisDetectedVariantText + 1 end
                    if resolvedVariantKey then
                        report.totals.poisResolvedVariantKey = report.totals.poisResolvedVariantKey + 1
                        if activeVariants and activeVariants[resolvedVariantKey] then
                            report.totals.poisMatchedActiveVariant = report.totals.poisMatchedActiveVariant + 1
                        end
                    else
                        report.totals.poisUnmatchedVariant = report.totals.poisUnmatchedVariant + 1
                    end

                    local poiEntry = {
                        mapId = mapId,
                        areaPoiID = areaPoiID,
                        name = name,
                        atlasName = atlasName,
                        widgetSet = widgetSet,
                        detectedVariantText = detectedVariantText,
                        detectedNormalizedVariant = detectedNormalizedVariant,
                        resolvedVariantKey = resolvedVariantKey,
                        matchedStoryVariant = resolvedVariantKey and activeVariants and activeVariants[resolvedVariantKey] and true or false,
                        widgetTextDump = verbose and GetWidgetTextDump(widgets) or nil,
                        description = description,
                    }
                    report.perPOI[#report.perPOI + 1] = poiEntry

                    if verbose then
                        ChatPrint(("POI: map=%d poi=%d name=%s atlas=%s widgetSet=%s"):format(
                            mapId, areaPoiID, name or "(no name)", atlasName or "nil",
                            widgetSet and tostring(widgetSet) or "nil"
                        ))
                        if description and description ~= "" then
                            ChatPrint(("  description: %s"):format(tostring(description)))
                        end
                        ChatPrint(("  detectedVariantText=%s normalized=%s resolvedVariantKey=%s matchedActive=%s"):format(
                            detectedVariantText and tostring(detectedVariantText) or "nil",
                            detectedNormalizedVariant and tostring(detectedNormalizedVariant) or "nil",
                            resolvedVariantKey and tostring(resolvedVariantKey) or "nil",
                            tostring(poiEntry.matchedStoryVariant)
                        ))
                        if poiEntry.widgetTextDump and #poiEntry.widgetTextDump > 0 then
                            for i = 1, #poiEntry.widgetTextDump do
                                local w = poiEntry.widgetTextDump[i]
                                local parts = {}
                                if w.textWithState then parts[#parts + 1] = ("TextWithState(order=%s)=%s"):format(tostring(w.textWithStateOrderIndex), tostring(w.textWithState)) end
                                if w.text then parts[#parts + 1] = ("Text(order=%s)=%s"):format(tostring(w.textOrderIndex), tostring(w.text)) end
                                if w.iconAndText then parts[#parts + 1] = ("IconAndText(order=%s)=%s"):format(tostring(w.iconAndTextOrderIndex), tostring(w.iconAndText)) end
                                ChatPrint(("  widgetTextDump[%d]: id=%s type=%s %s"):format(
                                    i, tostring(w.widgetID), tostring(w.widgetType), table.concat(parts, " | ")
                                ))
                            end
                        else
                            ChatPrint("  widgetTextDump: <none from supported widget text APIs>")
                        end
                    end
                end
            end
        end
    end

    ChatPrint(("Active stories: %d entries | maps=%d pois=%d widgets=%d resolvedVariantKeys=%d unmatched=%d"):format(
        #activeDelves,
        report.totals.mapsScanned,
        report.totals.poisScanned,
        report.totals.poisWithWidgetSet,
        report.totals.poisResolvedVariantKey,
        report.totals.poisUnmatchedVariant
    ))

    if activeDelves and #activeDelves > 0 then
        if verbose then
            ChatPrint("=== Active delves computed from activeVariants ===")
            for i = 1, #activeDelves do
                local d = activeDelves[i]
                ChatPrint(("  %d) %s | difficulty=%s variant=%s bountiful=%s mapId=%s areaPoiID=%s poiName=%s"):format(
                    i, d.delveName, tostring(d.difficulty), tostring(d.variantName),
                    d.isBountiful and "yes" or "no", tostring(d.mapId), tostring(d.areaPoiID), tostring(d.displayName)
                ))
            end
        else
            local maxPrint = math.min(10, #activeDelves)
            for i = 1, math.min(maxPrint, #activeDelves) do
                local d = activeDelves[i]
                ChatPrint(("  %d) %s | %s variant=%s bountiful=%s"):format(
                    i, d.delveName, d.difficulty, d.variantName, d.isBountiful and "yes" or "no"
                ))
            end
            if #activeDelves > maxPrint then
                ChatPrint(("  ... (%d more)"):format(#activeDelves - maxPrint))
            end
        end
    end

    if verbose and activeVariants and next(activeVariants) then
        ChatPrint("=== activeVariants raw table ===")
        for k, v in pairs(activeVariants) do
            ChatPrint(("  variantKey=%s bountiful=%s mapId=%s areaPoiID=%s poiName=%s variantDisplayName=%s"):format(
                tostring(k), tostring(v.bountiful), tostring(v.mapId),
                tostring(v.areaPoiID), tostring(v.poiName), tostring(v.variantDisplayName)
            ))
        end
    end

    return report
end
