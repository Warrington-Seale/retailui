-- ============================================================================
-- Vamoose's Endeavors - Store
-- Redux-lite state management with reducers and persistence
-- ============================================================================

VE = VE or {}

-- Default state template
local DEFAULT_STATE = {
    config = {
        debug = false,
        showMinimapButton = true,
        showDashboardButton = true,
        theme = "housingtheme",  -- "dark", "light", "housingtheme", etc.
        fontFamily = "ARIALN",  -- FRIZQT__, ARIALN, skurri, MORPHEUS
        fontScale = 0,  -- -4 to +8 offset applied to all font sizes
        uiScale = 1.0,  -- 0.8 to 1.4 multiplier for entire UI
        bgOpacity = 0.9,  -- 0.3 to 1.0 background transparency
        quotesEnabled = true,  -- Squirrel quote talking head
        quotesOnlyChat = false,  -- true = chat only, false = talking head
        autoActivateOnSelect = false,  -- auto-set active endeavor when selecting house in dropdown
        pinWindow = false,  -- pin window: survive Escape, auto-open on reload
        showLoginActiveEndeavor = true,  -- announce active endeavor in chat once per login
        showInCombat = false,  -- keep the window visible in combat (default: auto-hide during combat)
    },
    -- Current endeavor season info
    endeavor = {
        seasonName = "",           -- "Reaching Beyond the Possible"
        seasonEndTime = 0,         -- Unix timestamp when season ends
        daysRemaining = 0,
        currentProgress = 0,       -- Current endeavor progress points
        maxProgress = 0,           -- Max points for full completion
        milestones = {},           -- Array of { threshold, reached, rewards }
        initiativeID = 0,          -- Current initiative ID (for per-endeavor favourites)
        chest = {                  -- Final-milestone completion chest (12.0.5)
            available = false,
            claimed = false,
            xp = 0,
            currencies = {},
            rewardQuestID = 0,
        },
    },
    -- Endeavor tasks list
    tasks = {},  -- Array of { id, name, description, points, completed, current, max }
    -- Per-character progress tracking
    characters = {
        -- ["CharName-Realm"] = {
        --     name = "CharName",
        --     realm = "Realm",
        --     class = "WARRIOR",
        --     lastUpdated = timestamp,
        --     tasks = { [taskId] = { completed, current, max } }
        -- }
    },
    -- UI state
    ui = {
        selectedCharacter = nil,  -- Currently viewed character key
    },
    -- Housing state (house level, coupons)
    housing = {
        houseGUID = nil,
        level = 0,
        xp = 0,
        xpForNextLevel = 0,
        maxLevel = 9,  -- Midnight S2 cap; HousingTracker overwrites with C_Housing.GetMaxHouseLevel
        coupons = 0,
        couponsIcon = nil,
    },
    -- Known initiative types (collected over time)
    knownInitiatives = {},  -- {[initiativeID] = {title, firstSeen, lastSeen}}
    -- Alt sharing for neighborhood leaderboards
    altSharing = {
        enabled = false,              -- Consent toggle (opt-in)
        mainCharacter = nil,          -- "CharName-RealmName" format
        lastBroadcast = 0,            -- Timestamp of last broadcast
        receivedMappings = {},        -- { ["Main-Realm"] = { alts = {...}, initiativeId = id } }
        groupingMode = "individual",  -- "individual" or "byMain"
    },
}

-- Deep copy helper
local function pick(new, old) if new ~= nil then return new end return old end

local function DeepCopy(orig)
    local copy
    if type(orig) == "table" then
        copy = {}
        for k, v in pairs(orig) do
            copy[k] = DeepCopy(v)
        end
    else
        copy = orig
    end
    return copy
end

local function ShallowCopy(t)
    local copy = {}
    for k, v in pairs(t) do copy[k] = v end
    return copy
end

-- Structural sharing. Copies the root plus each named branch along `path`, and
-- shares every untouched branch by reference. Reducers used to DeepCopy the
-- whole tree to write a single leaf -- SET_COUPONS fires on every currency
-- update and only ever touches two fields under `housing`, so the copy was
-- almost entirely wasted allocation (and GC pressure) per dispatch.
--
-- Consumers still see a fresh root table and a fresh table for the branch that
-- changed, so identity comparison keeps working where it's used. DeepCopy stays
-- for DEFAULT_STATE below, which genuinely must not alias the template.
local function CopyPath(state, ...)
    local newState = ShallowCopy(state)
    local node, newNode = state, newState
    for i = 1, select("#", ...) do
        local key = select(i, ...)
        local child = ShallowCopy(node[key])
        newNode[key] = child
        node, newNode = node[key], child
    end
    return newState, newNode
end

-- Character key for per-character SavedVariables, or nil when identity isn't
-- resolvable yet. VE:GetCharacterKey concatenates directly and would error on a
-- nil name, and QueueSave can fire from a dispatch during ADDON_LOADED -- before
-- the player's name/realm are populated. Returning nil lets callers skip that
-- save; the next one (1s debounce) picks it up with a real key.
-- exception(boundary): UnitName / GetNormalizedRealmName return nil pre-PLAYER_LOGIN
local function CurrentCharKey()
    local name = UnitName("player")
    if not name or name == "" then return nil end
    local realm = GetNormalizedRealmName()
    if not realm or realm == "" then
        local fallback = GetRealmName()
        realm = fallback and fallback:gsub("%s", "") or nil
    end
    if not realm or realm == "" then return nil end
    return name .. "-" .. realm
end

VE.Store = {
    state = DeepCopy(DEFAULT_STATE),
    reducers = {},
    saveTimer = nil,
}

function VE.Store:GetState()
    return self.state
end

function VE.Store:RegisterReducer(action, reducerFn)
    self.reducers[action] = reducerFn
end

function VE.Store:Dispatch(action, payload)
    -- Note: Store dispatch logging removed - too verbose even for debug mode

    local reducer = self.reducers[action]
    if reducer then
        local newState = reducer(self.state, payload)
        if newState then
            self.state = newState
            if not self.suppressNotify then
                VE.EventBus:Trigger("VE_STATE_CHANGED", { action = action, state = self.state })
            end
            self:QueueSave()
        end
    else
        if self.state.config.debug then
            print("|cFFdc322f[VE Store]|r No reducer found for:", action)
        end
    end
end

-- ============================================================================
-- SAVEDVARIABLES PERSISTENCE
-- ============================================================================

function VE.Store:LoadFromSavedVariables()
    if not VE_DB then
        VE_DB = {}
    end

    -- Restore config
    if VE_DB.config then
        for key, value in pairs(VE_DB.config) do
            self.state.config[key] = value
        end
    end

    -- Restore character data
    if VE_DB.characters then
        self.state.characters = VE_DB.characters
    end

    -- Restore UI state
    if VE_DB.ui then
        self.state.ui.selectedCharacter = VE_DB.ui.selectedCharacter
    end

    -- Restore known initiatives (account-wide collection)
    if VE_DB.knownInitiatives then
        self.state.knownInitiatives = VE_DB.knownInitiatives
    end

    -- Restore alt sharing state
    if VE_DB.altSharing then
        self.state.altSharing.enabled = VE_DB.altSharing.enabled or false
        self.state.altSharing.mainCharacter = VE_DB.altSharing.mainCharacter
        -- Don't restore lastBroadcast - allow fresh broadcast each session
        self.state.altSharing.receivedMappings = VE_DB.altSharing.receivedMappings or {}
        self.state.altSharing.groupingMode = VE_DB.altSharing.groupingMode or "individual"
    end

    if self.state.config.debug then
        print("|cFF2aa198[VE Store]|r Loaded state from SavedVariables")
    end
end

-- Restore this character's last-known housing display values.
--
-- Called from OnEnable (PLAYER_LOGIN), NOT LoadFromSavedVariables (ADDON_LOADED):
-- the cache is keyed by character and name/realm aren't populated that early.
-- Nothing async has landed by PLAYER_LOGIN (the house-list request is at T+2s),
-- so this can't overwrite fresher data -- and when the live values do arrive they
-- dispatch through the same reducers and replace these.
function VE.Store:RestoreHousing()
    local charKey = CurrentCharKey()
    if not charKey then return end

    local cached = VE_DB and VE_DB.housingByChar and VE_DB.housingByChar[charKey]
    if not cached then return end

    self:Dispatch("SET_HOUSE_LEVEL", {
        level = cached.level,
        xp = cached.xp,
        xpForNextLevel = cached.xpForNextLevel,
        maxLevel = cached.maxLevel,
    })
    self:Dispatch("SET_COUPONS", {
        count = cached.coupons,
        iconID = cached.couponsIcon,
    })

    if self.state.config.debug then
        print("|cFF2aa198[VE Store]|r Restored cached housing for " .. charKey)
    end
end

function VE.Store:QueueSave()
    if self.saveTimer then
        self.saveTimer:Cancel()
    end
    self.saveTimer = C_Timer.NewTimer(1, function()
        self:SaveToSavedVariables()
    end)
end

function VE.Store:SaveToSavedVariables()
    VE_DB = VE_DB or {}

    -- Save config
    VE_DB.config = {
        debug = self.state.config.debug,
        showMinimapButton = self.state.config.showMinimapButton,
        showDashboardButton = self.state.config.showDashboardButton,
        theme = self.state.config.theme,
        fontFamily = self.state.config.fontFamily,
        fontScale = self.state.config.fontScale,
        uiScale = self.state.config.uiScale,
        bgOpacity = self.state.config.bgOpacity,
        quotesEnabled = self.state.config.quotesEnabled,
        quotesOnlyChat = self.state.config.quotesOnlyChat,
        autoActivateOnSelect = self.state.config.autoActivateOnSelect,
        pinWindow = self.state.config.pinWindow,
        showLoginActiveEndeavor = self.state.config.showLoginActiveEndeavor,
        showInCombat = self.state.config.showInCombat,
    }

    -- Save character data (persistent across sessions)
    VE_DB.characters = self.state.characters

    -- Save UI state (merge to preserve taskSort, showRewardsHighlight)
    VE_DB.ui = VE_DB.ui or {}
    VE_DB.ui.selectedCharacter = self.state.ui.selectedCharacter

    -- Save known initiatives (account-wide collection)
    VE_DB.knownInitiatives = self.state.knownInitiatives

    -- Save housing display values, keyed by character.
    --
    -- Housing state is PER CHARACTER but VE_DB is account-wide, so an unkeyed
    -- blob would show one alt's house level and coupon count on another. Keyed
    -- by charKey, each character restores only its own.
    --
    -- houseGUID is deliberately NOT persisted: it drives API requests, and a
    -- stale GUID would be re-queried against a house that may no longer be
    -- selected. This cache is display-only -- it fills the header until the
    -- live GetPlayerOwnedHouses + HOUSE_LEVEL_FAVOR_UPDATED round-trip lands
    -- (~2s after login), replacing the zeros players saw before.
    local charKey = CurrentCharKey()
    if charKey then
        VE_DB.housingByChar = VE_DB.housingByChar or {}
        VE_DB.housingByChar[charKey] = {
            level = self.state.housing.level,
            xp = self.state.housing.xp,
            xpForNextLevel = self.state.housing.xpForNextLevel,
            maxLevel = self.state.housing.maxLevel,
            coupons = self.state.housing.coupons,
            couponsIcon = self.state.housing.couponsIcon,
            savedAt = time(),
        }
    end

    -- Save alt sharing state
    VE_DB.altSharing = {
        enabled = self.state.altSharing.enabled,
        mainCharacter = self.state.altSharing.mainCharacter,
        lastBroadcast = self.state.altSharing.lastBroadcast,
        receivedMappings = self.state.altSharing.receivedMappings,
        groupingMode = self.state.altSharing.groupingMode,
    }

    if self.state.config.debug then
        print("|cFF2aa198[VE Store]|r Saved state to SavedVariables")
    end
end

function VE.Store:Flush()
    if self.saveTimer then
        self.saveTimer:Cancel()
        self.saveTimer = nil
    end
    self:SaveToSavedVariables()
end

-- ============================================================================
-- REDUCERS
-- ============================================================================

-- SET_CONFIG: Update a config value
VE.Store:RegisterReducer("SET_CONFIG", function(state, payload)
    local newState, config = CopyPath(state, "config")
    if payload.key then
        config[payload.key] = payload.value
    end
    return newState
end)

-- SET_ENDEAVOR_INFO: Update current endeavor season info
VE.Store:RegisterReducer("SET_ENDEAVOR_INFO", function(state, payload)
    local newState = CopyPath(state)
    newState.endeavor = {
        seasonName = payload.seasonName or state.endeavor.seasonName,
        seasonEndTime = pick(payload.seasonEndTime, state.endeavor.seasonEndTime),
        daysRemaining = pick(payload.daysRemaining, state.endeavor.daysRemaining),
        currentProgress = pick(payload.currentProgress, state.endeavor.currentProgress),
        maxProgress = pick(payload.maxProgress, state.endeavor.maxProgress),
        milestones = payload.milestones or state.endeavor.milestones,
        initiativeID = pick(payload.initiativeID, state.endeavor.initiativeID),
        chest = payload.chest or state.endeavor.chest,
    }
    return newState
end)

-- SET_TASKS: Update the endeavor tasks list
VE.Store:RegisterReducer("SET_TASKS", function(state, payload)
    local newState = CopyPath(state)
    newState.tasks = payload.tasks or {}
    return newState
end)

-- UPDATE_CHARACTER_PROGRESS: Save current character's task progress
VE.Store:RegisterReducer("UPDATE_CHARACTER_PROGRESS", function(state, payload)
    local newState, characters = CopyPath(state, "characters")
    local charKey = payload.charKey

    characters[charKey] = {
        name = payload.name,
        realm = payload.realm,
        class = payload.class,
        lastUpdated = time(),
        tasks = payload.tasks or {},
    }

    return newState
end)

-- SET_SELECTED_CHARACTER: Change which character is being viewed
VE.Store:RegisterReducer("SET_SELECTED_CHARACTER", function(state, payload)
    local newState, ui = CopyPath(state, "ui")
    ui.selectedCharacter = payload.charKey
    return newState
end)

-- ============================================================================
-- HOUSING REDUCERS
-- ============================================================================

-- SET_HOUSE_GUID: Cache the current house GUID
VE.Store:RegisterReducer("SET_HOUSE_GUID", function(state, payload)
    local newState, housing = CopyPath(state, "housing")
    housing.houseGUID = payload.houseGUID
    return newState
end)

-- SET_HOUSE_LEVEL: Update house level and XP
VE.Store:RegisterReducer("SET_HOUSE_LEVEL", function(state, payload)
    local newState, housing = CopyPath(state, "housing")
    housing.level = pick(payload.level, state.housing.level)
    housing.xp = pick(payload.xp, state.housing.xp)
    housing.xpForNextLevel = pick(payload.xpForNextLevel, state.housing.xpForNextLevel)
    housing.maxLevel = pick(payload.maxLevel, state.housing.maxLevel)
    return newState
end)

-- SET_COUPONS: Update community coupons count
VE.Store:RegisterReducer("SET_COUPONS", function(state, payload)
    local newState, housing = CopyPath(state, "housing")
    housing.coupons = payload.count or 0
    housing.couponsIcon = payload.iconID
    return newState
end)


-- RECORD_INITIATIVE: Track discovered initiative types
VE.Store:RegisterReducer("RECORD_INITIATIVE", function(state, payload)
    if not payload.initiativeID or payload.initiativeID == 0 then return state end
    local newState, knownInitiatives = CopyPath(state, "knownInitiatives")
    local id = payload.initiativeID
    local existing = state.knownInitiatives[id]
    knownInitiatives[id] = {
        title = payload.title or (existing and existing.title) or "Unknown",
        description = payload.description or (existing and existing.description) or "",
        firstSeen = existing and existing.firstSeen or time(),
        lastSeen = time(),
    }
    return newState
end)

-- ============================================================================
-- ALT SHARING REDUCERS
-- ============================================================================

-- SET_ALT_SHARING_ENABLED: Toggle consent for sharing alt data
VE.Store:RegisterReducer("SET_ALT_SHARING_ENABLED", function(state, payload)
    local newState, altSharing = CopyPath(state, "altSharing")
    altSharing.enabled = payload.enabled or false
    return newState
end)

-- SET_MAIN_CHARACTER: Set the player's designated main character
VE.Store:RegisterReducer("SET_MAIN_CHARACTER", function(state, payload)
    local newState, altSharing = CopyPath(state, "altSharing")
    altSharing.mainCharacter = payload.mainCharacter -- "CharName-RealmName" or nil
    return newState
end)

-- SET_LAST_BROADCAST: Update last broadcast timestamp
VE.Store:RegisterReducer("SET_LAST_BROADCAST", function(state, payload)
    local newState, altSharing = CopyPath(state, "altSharing")
    altSharing.lastBroadcast = payload.timestamp or time()
    return newState
end)

-- UPDATE_RECEIVED_MAPPING: Store received alt data from another player
VE.Store:RegisterReducer("UPDATE_RECEIVED_MAPPING", function(state, payload)
    if not payload.mainCharacter then return state end
    local newState, receivedMappings = CopyPath(state, "altSharing", "receivedMappings")
    receivedMappings[payload.mainCharacter] = {
        alts = payload.alts or {},
        initiativeId = payload.initiativeId,
    }
    return newState
end)

-- SET_GROUPING_MODE: Toggle leaderboard grouping mode
VE.Store:RegisterReducer("SET_GROUPING_MODE", function(state, payload)
    local newState, altSharing = CopyPath(state, "altSharing")
    altSharing.groupingMode = payload.mode or "individual"
    return newState
end)

-- CLEAR_STALE_MAPPINGS: Remove mappings from ended initiatives
VE.Store:RegisterReducer("CLEAR_STALE_MAPPINGS", function(state, payload)
    local activeInitiativeId = payload.activeInitiativeId
    if not activeInitiativeId then return state end
    local newState, receivedMappings = CopyPath(state, "altSharing", "receivedMappings")
    for mainChar, data in pairs(receivedMappings) do
        if data.initiativeId ~= activeInitiativeId then
            receivedMappings[mainChar] = nil
        end
    end
    return newState
end)
