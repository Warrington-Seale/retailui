-- ============================================================================
-- Vamoose's Endeavors - Health / Self-Healing
-- ============================================================================
-- Three tiers:
--   Tier 1 (invariant checks) -- runs 5s after panel open; re-requests house
--     list, unsticks timers, clears stale saved GUIDs. Silent unless debug.
--   Tier 2 (schema migration) -- runs at ADDON_LOADED; bumps schemaVersion
--     and prunes legacy SavedVars from prior architectures. Yellow-logs any
--     migration actions so the user knows the addon is self-correcting.
--   Tier 3 (user nuke) -- /ve reset. Confirmation dialog, full VE_DB wipe.
-- ============================================================================

VE = VE or {}
VE.Health = {}
local Health = VE.Health

local SCHEMA_VERSION = 4

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- Heal messages print unconditionally. These are significant state changes --
-- the user should know the addon is self-correcting. Tight + factual, not noisy.
local function healLog(msg)
    print("|cFF2aa198[VE heal]|r " .. msg)
end

local function yellowLog(msg)
    print("|cFFfcd34d[VE]|r " .. msg)
end

local function redLog(msg)
    print("|cFFdc322f[VE]|r " .. msg)
end

-- ---------------------------------------------------------------------------
-- Tier 1: Invariant checks (panel-open, +5s debounce)
-- ---------------------------------------------------------------------------

local HEAL_COOLDOWN = 30 -- seconds; don't re-heal "empty list" more than once per 30s

local CHECKS = {
    {
        name = "empty-house-list",
        -- Fires whenever houseList is empty (Kierana's symptom: Blizzard returned
        -- empty but player owns houses; VE accepts the empty and calls it "loaded").
        -- Rate-limited so we don't hammer on genuinely-houseless accounts.
        test = function()
            local t = VE.EndeavorTracker
            if not t then return false end
            if #(t.houseList or {}) > 0 then return false end
            local last = t._lastHealAt or 0
            if (GetTime() - last) < HEAL_COOLDOWN then return false end
            return true
        end,
        heal = function()
            if not VE.EndeavorTracker then return nil end
            VE.EndeavorTracker._lastHealAt = GetTime()
            VE.EndeavorTracker:RequestHouseInfo()
            return "house list is empty; forced re-request via C_Housing.GetPlayerOwnedHouses"
        end,
    },
    {
        name = "stale-selected-guid",
        test = function()
            if not VE_DB or not VE_DB.selectedHouseGUID then return false end
            local t = VE.EndeavorTracker
            if not t or not t.houseListLoaded then return false end
            local list = t.houseList or {}
            if #list == 0 then return false end -- only stale if we HAVE houses
            for _, h in ipairs(list) do
                if h.houseGUID == VE_DB.selectedHouseGUID then return false end
            end
            return true
        end,
        heal = function()
            VE_DB.selectedHouseGUID = nil
            return "cleared stale selectedHouseGUID (didn't match any current-session house)"
        end,
    },
    {
        name = "contradiction-ptc-vs-houselist",
        test = function()
            if not C_NeighborhoodInitiative or not C_NeighborhoodInitiative.GetNeighborhoodInitiativeInfo then
                return false
            end
            local ok, info = pcall(C_NeighborhoodInitiative.GetNeighborhoodInitiativeInfo)
            if not ok or not info or not info.isLoaded then return false end
            if (info.playerTotalContribution or 0) <= 0 then return false end
            local t = VE.EndeavorTracker
            return t and #(t.houseList or {}) == 0
        end,
        heal = function()
            if not VE.EndeavorTracker then return nil end
            VE.EndeavorTracker:RequestHouseInfo()
            return "initiative shows player contribution but no houses loaded; re-requested house list"
        end,
    },
}

function Health:Run(trigger)
    local healedCount = 0
    for _, check in ipairs(CHECKS) do
        local ok, needsHeal = pcall(check.test)
        if ok and needsHeal then
            local hok, result = pcall(check.heal)
            if hok and result then
                healLog(check.name .. " -> " .. result)
                healedCount = healedCount + 1
            end
        end
    end
    if healedCount > 0 then
        healLog("panel-open check (" .. (trigger or "?") .. "): " .. healedCount .. " heal action(s)")
    end
end

-- ---------------------------------------------------------------------------
-- Tier 2: Schema migration (runs at ADDON_LOADED)
-- ---------------------------------------------------------------------------

-- Drops a top-level VE_DB key if present, returns a description for the log.
local function dropKey(key, label)
    if VE_DB[key] == nil then return nil end
    if type(VE_DB[key]) == "table" and not next(VE_DB[key]) then
        VE_DB[key] = nil
        return nil
    end
    VE_DB[key] = nil
    return label
end

-- Version-keyed migrations. Each returns a list of messages describing changes.
-- Sparse table -- the runner skips missing version keys gracefully.
local MIGRATIONS = {
    [3] = function()
        -- GetAvailableHouseXP (12.0.5) replaced Observer + scale derivation.
        -- Drop the SavedVars that powered those subsystems and the per-house
        -- XP cache from v1.15.x (no longer written; activity log drives display).
        local msgs = {}
        msgs[#msgs + 1] = dropKey("xpObserver", "removed legacy xpObserver baselines")
        msgs[#msgs + 1] = dropKey("neighborhoodScales", "removed legacy neighborhoodScales")
        msgs[#msgs + 1] = dropKey("learnedFormula", "removed legacy learnedFormula")
        msgs[#msgs + 1] = dropKey("taskRules", "removed legacy taskRules")
        msgs[#msgs + 1] = dropKey("formulaCheckpoint", "removed legacy formulaCheckpoint")
        msgs[#msgs + 1] = dropKey("houseData", "removed legacy houseData cache")
        if VE_DB.config and VE_DB.config.xpTrackingMode then
            VE_DB.config.xpTrackingMode = nil
            msgs[#msgs + 1] = "removed legacy config.xpTrackingMode"
        end
        return msgs
    end,
    [4] = function()
        -- DR is now driven by Blizzard's curve 87592 (decoded from DB2);
        -- the empirical taskActualCoupons history that fed the old "actual or
        -- base" coupon model is no longer read.
        local msgs = {}
        msgs[#msgs + 1] = dropKey("taskActualCoupons", "removed legacy taskActualCoupons (DR curve replaces empirical model)")
        return msgs
    end,
}

function Health:RunSchemaSweep()
    VE_DB = VE_DB or {}
    local from = VE_DB.schemaVersion or 0
    if from >= SCHEMA_VERSION then return end

    local healed = {}
    for v = from + 1, SCHEMA_VERSION do
        local fn = MIGRATIONS[v]
        if fn then
            local ok, msgs = pcall(fn)
            if ok and msgs then
                for _, m in ipairs(msgs) do healed[#healed + 1] = "v" .. v .. ": " .. m end
            end
        end
    end
    VE_DB.schemaVersion = SCHEMA_VERSION

    if #healed > 0 then
        yellowLog("Sanity sweep: " .. table.concat(healed, "; "))
    end
end

-- ---------------------------------------------------------------------------
-- Tier 3: User-initiated nuclear reset (/ve reset)
-- ---------------------------------------------------------------------------

StaticPopupDialogs["VE_NUCLEAR_RESET_CONFIRM"] = {
    text = "Reset Vamoose's Endeavors to factory defaults?\n\nThis will wipe all alt data, preferences, and house state.\n\nThis cannot be undone.",
    button1 = YES,
    button2 = NO,
    OnAccept = function() Health:_PerformNuke() end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

function Health:NuclearReset()
    StaticPopup_Show("VE_NUCLEAR_RESET_CONFIRM")
end

function Health:_PerformNuke()
    -- Wipe SavedVariables
    VE_DB = {}
    VE_DB.schemaVersion = SCHEMA_VERSION

    -- Reset in-memory tracker state
    if VE.EndeavorTracker then
        VE.EndeavorTracker.houseList = {}
        VE.EndeavorTracker.houseListLoaded = false
        VE.EndeavorTracker.selectedHouseIndex = 1
        VE.EndeavorTracker.currentHouseGUID = nil
        VE.EndeavorTracker.hasManualSelection = false
    end

    -- Re-init Store from the now-empty VE_DB (seeds defaults)
    if VE.Store and VE.Store.LoadFromSavedVariables then
        VE.Store:LoadFromSavedVariables()
    end

    -- Re-request housing data to rebuild state
    if VE.EndeavorTracker then
        VE.EndeavorTracker:RequestHouseInfo()
    end

    redLog("All VE data reset to defaults.")
    redLog("Close and reopen the window with /ve to refresh the display.")
end
