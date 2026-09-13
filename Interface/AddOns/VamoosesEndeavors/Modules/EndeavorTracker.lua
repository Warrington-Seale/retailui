-- ============================================================================
-- Vamoose's Endeavors - EndeavorTracker
-- Fetches and tracks housing endeavor data using C_NeighborhoodInitiative API.
-- House XP comes from C_NeighborhoodInitiative.GetAvailableHouseXP (12.0.5+).
-- Per-task previews + per-character completion counts are derived from the
-- activity log directly here -- no separate XP module.
-- ============================================================================

VE = VE or {}
VE.EndeavorTracker = {}

-- Midnight secret-value guards. Pattern from DandersFrames (see
-- Reference/MIDNIGHT_SECRET_VALUES.md, "Pattern A"). Fallbacks make these
-- safe on pre-Midnight clients too. Use on any value/table coming back from
-- C_Housing / C_NeighborhoodInitiative APIs or their event payloads -- inside
-- a player's own house some of those may be secret-restricted.
local issecretvalue = issecretvalue or function() return false end
local canaccesstable = canaccesstable or function() return true end

local Tracker = VE.EndeavorTracker
Tracker.frame = CreateFrame("Frame")

local function GetHouseDisplayName(info)
    return (type(info.neighborhoodName) == "string" and info.neighborhoodName ~= "" and info.neighborhoodName)
        or (type(info.houseName) == "string" and info.houseName ~= "" and info.houseName)
        or "Unknown"
end

-- ============================================================================
-- XP/per-task index builders (file-local helpers)
-- ============================================================================

-- ============================================================================
-- SHARED: House selection priority (used by both EndeavorTracker + HousingTracker)
-- Returns index, neighborhoodGUID for best match in houseInfoList
-- ============================================================================

function Tracker:FindBestHouseIndex(houseInfoList)
    if not houseInfoList or #houseInfoList == 0 then return nil, nil end

    -- Priority 1: Active neighborhood (earning XP)
    local activeGUID = C_NeighborhoodInitiative and C_NeighborhoodInitiative.GetActiveNeighborhood
        and C_NeighborhoodInitiative.GetActiveNeighborhood()
    if activeGUID then
        for i, h in ipairs(houseInfoList) do
            if h.neighborhoodGUID == activeGUID then return i, activeGUID end
        end
    end

    -- Priority 2: Saved houseGUID from last session
    local savedGUID = VE_DB and VE_DB.selectedHouseGUID
    if savedGUID then
        for i, h in ipairs(houseInfoList) do
            if h.houseGUID == savedGUID then return i, h.neighborhoodGUID end
        end
    end

    -- Priority 3: First house
    return 1, houseInfoList[1].neighborhoodGUID
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

function Tracker:Initialize()
    self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.frame:RegisterEvent("NEIGHBORHOOD_INITIATIVE_UPDATED")
    self.frame:RegisterEvent("INITIATIVE_TASKS_TRACKED_UPDATED")
    self.frame:RegisterEvent("INITIATIVE_TASKS_TRACKED_LIST_CHANGED")
    self.frame:RegisterEvent("INITIATIVE_TASK_COMPLETED")
    self.frame:RegisterEvent("INITIATIVE_COMPLETED")
    self.frame:RegisterEvent("INITIATIVE_ACTIVITY_LOG_UPDATED")
    self.frame:RegisterEvent("PLAYER_HOUSE_LIST_UPDATED")
    -- Housing events (folded in from VE.HousingTracker in v1.16)
    self.frame:RegisterEvent("HOUSE_LEVEL_FAVOR_UPDATED")
    self.frame:RegisterEvent("HOUSE_LEVEL_CHANGED")
    self.frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
    self.frame:RegisterEvent("QUEST_TURNED_IN")

    self.activityLogLoaded = false
    self.cachedActivityLog = nil
    self.activityLogLastUpdated = nil
    self.activityLogStale = false
    self.currentHouseGUID = nil

    -- XP/per-task indexes (rebuilt on activity log + live task ingest)
    self.playerContribution = 0
    self.liveTasks          = {}

    self.fetchStatus = { state = "pending", lastAttempt = nil }

    self.pendingRefreshTimer = nil
    self.lastFetchTime = nil
    self.lastRequestTime = nil
    self.hasManualSelection = false
    self.lastKnownActiveGUID = nil

    self.houseList = {}
    self.selectedHouseIndex = 1
    self.houseListLoaded = false

    -- Housing dedup cache (was VE.HousingTracker._lastFavorByGUID before fold)
    self._lastFavorByGUID = {}

    self.frame:SetScript("OnEvent", function(_, event, ...)
        self:OnEvent(event, ...)
    end)

    -- Debounced character progress save on task/endeavor state changes
    VE.EventBus:Register("VE_STATE_CHANGED", function(payload)
        if payload.action == "SET_TASKS" or payload.action == "SET_ENDEAVOR_INFO" then
            if self.saveCharProgressTimer then
                self.saveCharProgressTimer:Cancel()
            end
            self.saveCharProgressTimer = C_Timer.NewTimer(0.5, function()
                self.saveCharProgressTimer = nil
                self:SaveCurrentCharacterProgress()
            end)
        end
    end)

    VE.EventBus:Register("VE_COUPON_GAINED", function()
        VE.EndeavorTracker:QueueDataRefresh()
    end)

    if VE.Store:GetState().config.debug then
        print("|cFF2aa198[VE Tracker]|r Initialized with C_NeighborhoodInitiative API")
    end
end

-- ============================================================================
-- EVENT HANDLING
-- ============================================================================

-- Blizzard dashboard cache repair REMOVED 2026-08-25 -- see the tombstone in
-- HDGR_HousingObserver.lua: the playerHouseList write is a taint bomb that
-- kills the dashboard's protected Teleport Home / Return buttons in
-- ADDON_ACTION_FORBIDDEN. The blank House Info pane is Blizzard's own 12.1
-- bug (their forwarder throws in InitiativesFrame before feeding
-- HouseUpgradeFrame) and recovers on any real list change. There is NO
-- taint-free write into Blizzard UI state -- do not reintroduce this.

function Tracker:OnEvent(event, ...)
    local debug = VE.Store:GetState().config.debug

    -- Raw chest-claim observation (armed via /ve armchest). Captures BEFORE
    -- any of our detection logic runs, so a once-a-month claim still leaves
    -- raw forensics in VE_DB.chestObservations even if our detection misfires.
    if self._chestArmed then
        self:_RecordChestObservation(event, ...)
    end

    if event == "PLAYER_ENTERING_WORLD" then
        -- Register current character for account-wide tracking
        VE_DB = VE_DB or {}
        VE_DB.myCharacters = VE_DB.myCharacters or {}
        local charName = UnitName("player")
        if charName then VE_DB.myCharacters[charName] = true end

        -- NO HOUSE-LIST REQUEST AT LOGIN. This used to call
        -- C_Housing.GetPlayerOwnedHouses() on a 2s timer and it broke Blizzard's
        -- Housing Dashboard for every VE user (2026-08-20).
        --
        -- Why: that call broadcasts PLAYER_HOUSE_LIST_UPDATED to EVERY listener,
        -- and Blizzard's HousingDashboardHouseDropdownMixin registers it as a
        -- LIFETIME event -- it listens from OnLoad, long before the dashboard is
        -- opened. It caches the list, then only re-broadcasts
        -- "HouseDropdown.HouseListUpdated" when the list CHANGES. So our request
        -- populated its cache first; when the player finally opened the dashboard,
        -- HouseInfoContent registered its callbacks, the list compared equal, the
        -- guard returned early, and the content pane sat blank forever waiting on
        -- an event that had already been consumed. The dropdown still showed the
        -- house name, because the dropdown had its own copy -- which is exactly
        -- what the bug reports looked like.
        --
        -- VE now takes the list PASSIVELY (the PLAYER_HOUSE_LIST_UPDATED handler
        -- still runs whenever anything else asks -- Blizzard's dropdown requests
        -- on every OnShow), and asks for itself only when the VE window is opened.
        --
        -- This is the "no work at login" rule. It exists for precisely this.
        --
        -- Coupons stay: C_CurrencyInfo.GetCurrencyInfo is a LOCAL cache read that
        -- broadcasts nothing and cannot affect another addon. The short timer is
        -- because currency data is not populated the instant we enter the world.
        if self._initFetchTimer then self._initFetchTimer:Cancel() end
        self._initFetchTimer = C_Timer.NewTimer(2, function()
            self._initFetchTimer = nil
            self:UpdateCoupons()
        end)

    elseif event == "NEIGHBORHOOD_INITIATIVE_UPDATED" then
        self:QueueDataRefresh()

    elseif event == "INITIATIVE_TASKS_TRACKED_UPDATED" then
        self:QueueDataRefresh()

    elseif event == "INITIATIVE_TASKS_TRACKED_LIST_CHANGED" then
        if debug then
            print("|cFF2aa198[VE Tracker]|r Task tracking list changed")
        end
        self:RefreshTrackedTasks()

    elseif event == "INITIATIVE_ACTIVITY_LOG_UPDATED" then
        -- Server signals fresh activity-log data is available. Debounce 5s -- the
        -- event can fire ~50/min when the neighborhood is active and we don't
        -- need to re-render the UI that often.
        if self._activityLogDebounce then self._activityLogDebounce:Cancel() end
        self._activityLogDebounce = C_Timer.NewTimer(5, function()
            self._activityLogDebounce = nil
            self:RefreshActivityLogCache()
        end)

    elseif event == "INITIATIVE_TASK_COMPLETED" then
        local taskName = ...
        if debug then
            print("|cFF2aa198[VE Tracker]|r Task completed: |cFFFFD100" .. tostring(taskName) .. "|r")
        end

        -- Look up task info from current state, then fall back to fresh API
        local taskID, isRepeatable = nil, false
        local state = VE.Store:GetState()
        if state and state.tasks then
            for _, task in ipairs(state.tasks) do
                if task.name == taskName then
                    taskID = task.id
                    isRepeatable = task.isRepeatable or false
                    break
                end
            end
        end
        if not taskID and C_NeighborhoodInitiative and C_NeighborhoodInitiative.GetNeighborhoodInitiativeInfo then
            local freshInfo = C_NeighborhoodInitiative.GetNeighborhoodInitiativeInfo()
            if freshInfo and freshInfo.tasks then
                for _, task in ipairs(freshInfo.tasks) do
                    if task.taskName == taskName then
                        taskID = task.ID
                        isRepeatable = task.taskType and task.taskType > 0 or false
                        break
                    end
                end
            end
        end

        -- Queue for coupon correlation (CURRENCY_DISPLAY_UPDATE fires after this).
        -- Prune on APPEND. _TrackCouponGain also prunes, but it only runs on a
        -- coupon CURRENCY_DISPLAY_UPDATE -- so tasks that award no coupons (or a
        -- capped currency) appended forever without ever reaching that purge and
        -- the queue grew for the whole session. Correlation only ever consumes
        -- the newest entry, so dropping anything past the window is safe.
        VE._pendingTaskCompletions = VE._pendingTaskCompletions or {}
        local pending = VE._pendingTaskCompletions
        local pendingNow = time()
        for i = #pending, 1, -1 do
            if pendingNow - (pending[i].timestamp or 0) > VE.Constants.PENDING_COMPLETION_TTL then
                table.remove(pending, i)
            end
        end
        table.insert(pending, {
            taskName = taskName,
            taskID = taskID,
            isRepeatable = isRepeatable,
            timestamp = pendingNow,
        })

        if VE.Vamoose and VE.Vamoose.OnTaskCompleted then
            VE.Vamoose.OnTaskCompleted(taskID, taskName)
        end

        -- Mark activity log as stale (new data available)
        self.activityLogStale = true

        -- Request fresh activity log; the response fires INITIATIVE_ACTIVITY_LOG_UPDATED
        -- which our debounced handler picks up and turns into a RefreshActivityLogCache call.
        self:RequestActivityLog()

        -- Refresh the task list so timesCompleted + Blizzard's dampened
        -- progressContributionAmount roll forward to the next rep step.
        -- (NEIGHBORHOOD_INITIATIVE_UPDATED is not guaranteed to fire on every
        -- task completion -- request explicitly.)
        self:QueueDataRefresh()

        self:RequestHouseInfo(true)

    elseif event == "INITIATIVE_COMPLETED" then
        local initiativeTitle = ...
        if debug then
            print("|cFF2aa198[VE Tracker]|r Initiative completed: " .. tostring(initiativeTitle))
        end
        self:FetchEndeavorData()

    elseif event == "PLAYER_HOUSE_LIST_UPDATED" then
        -- Debounce: Blizzard fires this multiple times on login/reload
        local houseInfoList = ...
        self._pendingHouseList = houseInfoList
        if not self._houseListTimer then
            self._houseListTimer = C_Timer.NewTimer(0.3, function()
                self._houseListTimer = nil
                local pending = self._pendingHouseList
                self._pendingHouseList = nil
                if pending then self:_ProcessHouseListUpdate(pending) end
            end)
        end

    elseif event == "HOUSE_LEVEL_FAVOR_UPDATED" then
        local houseLevelFavor = ...
        self:_DetectChestClaimViaFavorDelta(houseLevelFavor)
        self:_OnHouseLevelFavorUpdated(houseLevelFavor)

    elseif event == "HOUSE_LEVEL_CHANGED" then
        if debug then
            print("|cFF2aa198[VE Tracker]|r House level changed")
        end
        self:RequestHouseInfo()

    elseif event == "CURRENCY_DISPLAY_UPDATE" then
        local currencyType, _, quantityChange, gainSource = ...
        local couponID = (VE.Constants and VE.Constants.CURRENCY_IDS and VE.Constants.CURRENCY_IDS.COMMUNITY_COUPONS) or 3363
        if currencyType == couponID and quantityChange and quantityChange > 0 then
            self:_TrackCouponGain(quantityChange, gainSource)
        end
        -- Debounce currency updates (per CLAUDE.md Rule 9: 0.2-0.5s)
        if self._couponUpdateTimer then self._couponUpdateTimer:Cancel() end
        self._couponUpdateTimer = C_Timer.NewTimer(0.2, function()
            self._couponUpdateTimer = nil
            self:UpdateCoupons()
        end)

    elseif event == "QUEST_TURNED_IN" then
        -- KNOWN DEAD ON 12.0.5: this event was observed NOT to fire on a
        -- real chest claim (Vamoose-Khaz'goroth cycle 7, 2026-04-29 dump).
        -- The chest "quest" is implicit -- no quest log entry, no turn-in
        -- NPC, no event. _DetectChestClaimViaFavorDelta is the load-bearing
        -- path. Kept here as belt-and-braces in case Blizzard fixes it in a
        -- future patch, but DO NOT depend on this firing.
        --
        -- rewardQuestID 93262 is SHARED across every initiative (one DB2
        -- "Endeavor Completion Reward" row covers all houses). The active
        -- neighborhood at turn-in time is the only signal that disambiguates
        -- which house's chest was claimed.
        local questID = ...
        local chest = self._chest
        if chest and chest.rewardQuestID > 0 and questID == chest.rewardQuestID then
            local activeGUID = C_NeighborhoodInitiative and C_NeighborhoodInitiative.GetActiveNeighborhood
                and C_NeighborhoodInitiative.GetActiveNeighborhood()
            -- Prefer the active GUID over the viewed GUID (chest.neighborhoodGUID
            -- is whichever house the user is currently viewing in the addon).
            local snapshot = chest
            if activeGUID and activeGUID ~= chest.neighborhoodGUID then
                local cached = self._chestByHouse and self._chestByHouse[activeGUID]
                if cached then
                    snapshot = cached
                else
                    -- No cached snapshot for the active house yet -- clone the
                    -- viewed chest before mutating its GUID, otherwise we
                    -- corrupt the viewed-house cache permanently.
                    snapshot = {}
                    for k, v in pairs(chest) do snapshot[k] = v end
                    snapshot.neighborhoodGUID = activeGUID
                end
            end
            self:_RecordChestClaim(snapshot)
        end

    end
end

-- ============================================================================
-- HOUSE_LEVEL_FAVOR_UPDATED -> chest claim detector.
--
-- ***********************************************************************
-- * THIS IS THE *ONLY* WORKING DETECTION PATH. DO NOT REMOVE.            *
-- *                                                                      *
-- * QUEST_TURNED_IN(rewardQuestID 93262) was observed NOT to fire on a   *
-- * verified live claim (Vamoose-Khaz'goroth, cycle 7, 2026-04-29).      *
-- * The chest "quest" is implicit -- there is no quest log entry, no      *
-- * turn-in NPC, no QUEST_TURNED_IN event. We keep that handler as       *
-- * belt-and-braces but the favor-delta path is load-bearing.            *
-- *                                                                      *
-- * DO NOT "OPTIMIZE" THE `delta <= 0` GUARD AWAY:                       *
-- * Two HOUSE_LEVEL_FAVOR_UPDATED events fire on a real claim, ~420ms    *
-- * apart (verified, cycle 7 dump):                                      *
-- *   1) reconciliation event with the SAME favor as before (delta=0)    *
-- *   2) the actual +chest.xp event (delta=250)                          *
-- * The guard exists specifically to skip event 1 so we don't false-     *
-- * match before the real delta arrives.                                 *
-- ***********************************************************************
-- ============================================================================
function Tracker:_DetectChestClaimViaFavorDelta(houseLevelFavor)
    if not houseLevelFavor or type(houseLevelFavor) ~= "table" then return end
    if not canaccesstable(houseLevelFavor) then return end
    local guid = houseLevelFavor.houseGUID
    if not guid then return end
    -- _lastFavorByGUID[guid] = { xp, level } -- set by _OnHouseLevelFavorUpdated.
    -- Runs BEFORE _OnHouseLevelFavorUpdated this turn, so we still see the prior xp.
    local last = self._lastFavorByGUID and self._lastFavorByGUID[guid]
    local lastXP = last and last.xp
    local current = houseLevelFavor.houseFavor
    if not lastXP or issecretvalue(lastXP) then return end
    if not current or issecretvalue(current) then return end
    local delta = current - lastXP
    if delta <= 0 then return end -- skips the dupe reconciliation event; see banner above.
    -- Resolve the chest for the house this favor update is for. We index by
    -- neighborhoodGUID, not houseGUID, but the active house's chest is the
    -- only one a favor update of this size could correspond to.
    local activeChest = self:GetActiveChest()
    if not activeChest or not activeChest.available or activeChest.claimed then return end
    if activeChest.xp <= 0 then return end
    -- Exact match: server delivers chest favor as its own discrete
    -- HOUSE_LEVEL_FAVOR_UPDATED event. No rounding, no batching with other XP
    -- sources -- delta will be exactly chest.xp (250) when a chest is claimed.
    -- Verified live, Vamoose-Khaz'goroth, cycle 7, 2026-04-29: 15798->16048.
    if delta == activeChest.xp then
        if VE.Store:GetState().config.debug then
            print(("|cFF859900[VE chest]|r Detected claim via favor delta: +%d"):format(delta))
        end
        self:_RecordChestClaim(activeChest)
    end
end

-- Manual "I already claimed this" for the active house's chest, used when the
-- favor-delta detector missed it (claimed on another client, or before this
-- version was installed). Single implementation shared by /ve claimed and the
-- progress bar's right-click -- returns ok plus the cycle so each caller can
-- word its own feedback.
function Tracker:MarkActiveChestClaimed()
    local chest = self:GetActiveChest()
    if not chest or not chest.neighborhoodGUID then
        return false, "no-active-house"
    end
    if chest.claimed then
        return false, "already-claimed"
    end
    self:_RecordChestClaim(chest)
    -- Repaint immediately: the bar's chest visuals are pushed by UpdateHeader,
    -- which nothing else re-runs after a manual claim.
    if VE.RefreshUI then VE:RefreshUI() end
    return true, chest.cycleID
end

function Tracker:_RecordChestClaim(chest)
    local houseKey = chest.neighborhoodGUID
    if not houseKey then return end
    -- Refuse to persist a record without a real cycleID; otherwise a stored
    -- 0 will false-match every future ProcessInitiativeInfo call.
    if not chest.cycleID or chest.cycleID == 0 then
        if VE.Store:GetState().config.debug then
            print("|cFFdc322f[VE chest]|r Skipping claim record: no valid cycleID yet.")
        end
        return
    end
    VE_DB = VE_DB or {}
    VE_DB.chestClaims = VE_DB.chestClaims or {}
    local now = time()
    local couponAmount = 0
    if chest.currencies then
        local couponID = VE.Constants.CURRENCY_IDS.COMMUNITY_COUPONS
        for _, c in ipairs(chest.currencies) do
            if c.currencyID == couponID then couponAmount = c.amount break end
        end
    end
    local charKey = VE:GetCharacterKey()
    local rec = VE_DB.chestClaims[houseKey] or { count = 0, history = {} }
    rec.count = (rec.count or 0) + 1
    rec.lastClaimTime = now
    rec.lastClaimedBy = charKey
    rec.lastCycleID = chest.cycleID
    rec.lastInitiativeID = chest.initiativeID or 0
    rec.lastXP = chest.xp or 0
    rec.lastCoupons = couponAmount

    -- Capture available-XP before claim to figure out empirically whether
    -- the chest favor is additive or already inside GetAvailableHouseXP().
    -- We schedule a post-claim sample 1.5s later (server lag). GetHouseXP()
    -- returns nil when its return is secret-restricted (housing interior on
    -- some accounts); skip the empirical sample in that case.
    local availableBefore = self:GetHouseXP()
    rec.lastAvailableBefore = availableBefore
    if self._chestSampleTimer then self._chestSampleTimer:Cancel() end
    self._chestSampleTimer = C_Timer.NewTimer(1.5, function()
        self._chestSampleTimer = nil
        local availableAfter = self:GetHouseXP()
        if not availableBefore or not availableAfter then return end
        local r = VE_DB and VE_DB.chestClaims and VE_DB.chestClaims[houseKey]
        if r then
            r.lastAvailableAfter = availableAfter
            r.lastAvailableDelta = availableAfter - availableBefore
        end
        if VE.Store:GetState().config.debug then
            local delta = availableAfter - availableBefore
            local interpretation
            if math.abs(delta) < 5 then interpretation = "no change -> chest XP is ADDITIVE (added directly to house favor, not via the available bucket)"
            elseif delta < 0 then interpretation = ("dropped %d -> chest XP came OUT OF the available bucket (not additive)"):format(-delta)
            else interpretation = ("rose %d -> unexpected, may be unrelated task earnings"):format(delta) end
            print(("|cFF6c71c4[VE chest]|r availableXP %d -> %d (delta %+d) -- %s"):format(
                availableBefore, availableAfter, delta, interpretation))
        end
    end)

    rec.history = rec.history or {}
    table.insert(rec.history, { t = now, by = charKey, cycle = rec.lastCycleID, init = rec.lastInitiativeID, xp = rec.lastXP, coupons = couponAmount, availBefore = availableBefore })
    -- Defensive trim: count via ipairs (safe on sparse tables) rather than #.
    local count = 0
    for _ in ipairs(rec.history) do count = count + 1 end
    while count > 30 do
        table.remove(rec.history, 1)
        count = count - 1
    end
    VE_DB.chestClaims[houseKey] = rec

    chest.claimed = true
    chest.claimedAt = now
    chest.claimedBy = charKey

    if VE.Store:GetState().config.debug then
        print(("|cFF859900[VE chest]|r Recorded claim on house: cycle=%s init=%s xp=%d coupons=%d (account-total %d)"):format(
            tostring(chest.cycleID), tostring(chest.initiativeID), chest.xp or 0, couponAmount, rec.count))
    end
    if VE.EventBus then VE.EventBus:Trigger("VE_CHEST_CLAIMED", { record = rec, chest = chest }) end
end

-- ============================================================================
-- RAW CHEST-CLAIM OBSERVATION (belt-and-braces forensics)
-- /ve armchest opens a capture window; every relevant event lands raw in
-- VE_DB.chestObservations along with before/after snapshots of every API
-- field we care about. Independent of our detection logic -- if both the
-- QUEST_TURNED_IN and HOUSE_LEVEL_FAVOR_UPDATED paths somehow miss, this
-- still preserves enough data to reconstruct the claim.
-- ============================================================================

local CHEST_OBSERVED_EVENTS = {
    QUEST_TURNED_IN = true,
    HOUSE_LEVEL_FAVOR_UPDATED = true,
    HOUSE_LEVEL_CHANGED = true,
    CURRENCY_DISPLAY_UPDATE = true,
    INITIATIVE_TASK_COMPLETED = true,
    INITIATIVE_COMPLETED = true,
    NEIGHBORHOOD_INITIATIVE_UPDATED = true,
}

local function shallow_copy(t)
    if type(t) ~= "table" then return t end
    local out = {}
    for k, v in pairs(t) do out[k] = v end
    return out
end

function Tracker:_SnapshotChestState()
    local snap = { t = time(), gt = GetTime() }
    if C_NeighborhoodInitiative then
        if C_NeighborhoodInitiative.GetActiveNeighborhood then
            snap.activeGUID = C_NeighborhoodInitiative.GetActiveNeighborhood()
        end
        if C_NeighborhoodInitiative.GetNeighborhoodInitiativeInfo then
            local info = C_NeighborhoodInitiative.GetNeighborhoodInitiativeInfo()
            if info then
                snap.initiativeID = info.initiativeID
                snap.currentCycleID = info.currentCycleID
                snap.neighborhoodGUID = info.neighborhoodGUID
                snap.currentProgress = info.currentProgress
                snap.title = info.title
                snap.playerTotalContribution = info.playerTotalContribution
                -- Real Blizzard milestone struct (verified cycle 7 dump 2026-04-29):
                --   milestone.milestoneOrderIndex, .requiredContributionAmount, .rewards[]
                --   reward.rewardQuestID, .favor, .money, .decorID, .decorQuantity, .title
                -- There is no separate GetMilestoneRewardInfo on 12.0.5; rewards
                -- live directly on the milestone struct. There is no top-level
                -- info.maxProgress field -- derive from final milestone threshold.
                if info.milestones and #info.milestones > 0 then
                    local final, maxThresh = nil, 0
                    for _, m in ipairs(info.milestones) do
                        local th = m.requiredContributionAmount or 0
                        if th >= maxThresh then maxThresh = th; final = m end
                    end
                    snap.maxProgress = maxThresh
                    if final then
                        local rewards
                        if final.rewards then
                            rewards = {}
                            for i, r in ipairs(final.rewards) do
                                rewards[i] = {
                                    rewardQuestID = r.rewardQuestID,
                                    favor = r.favor,
                                    money = r.money,
                                    decorID = r.decorID,
                                    decorQuantity = r.decorQuantity,
                                    title = r.title,
                                }
                            end
                        end
                        snap.finalMilestone = {
                            milestoneOrderIndex = final.milestoneOrderIndex,
                            requiredContributionAmount = final.requiredContributionAmount,
                            reached = (info.currentProgress or 0) >= (final.requiredContributionAmount or maxThresh),
                            rewards = rewards,
                        }
                        -- For each reward quest, also pull the currency rewards
                        -- via C_QuestLog (where the coupon amount actually lives).
                        if rewards and C_QuestLog and C_QuestLog.GetQuestRewardCurrencyInfo then
                            for _, r in ipairs(snap.finalMilestone.rewards) do
                                local qID = r.rewardQuestID or 0
                                if qID > 0 then
                                    r.currencies = {}
                                    local i = 1
                                    while true do
                                        local c = C_QuestLog.GetQuestRewardCurrencyInfo(qID, i, false)
                                        if not c then break end
                                        r.currencies[i] = {
                                            currencyID = c.currencyID,
                                            totalRewardAmount = c.totalRewardAmount,
                                            name = c.name,
                                        }
                                        i = i + 1
                                    end
                                    r.questCompleted = IsQuestFlaggedCompleted and IsQuestFlaggedCompleted(qID) or nil
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if self.GetHouseXP then snap.availableHouseXP = self:GetHouseXP() end
    if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
        local couponID = (VE.Constants and VE.Constants.CURRENCY_IDS and VE.Constants.CURRENCY_IDS.COMMUNITY_COUPONS) or 3363
        local cinfo = C_CurrencyInfo.GetCurrencyInfo(couponID)
        if cinfo then snap.couponBalance = cinfo.quantity end
    end
    if self._chest then
        snap.chest = {
            available = self._chest.available,
            claimed = self._chest.claimed,
            xp = self._chest.xp,
            rewardQuestID = self._chest.rewardQuestID,
            cycleID = self._chest.cycleID,
            initiativeID = self._chest.initiativeID,
            neighborhoodGUID = self._chest.neighborhoodGUID,
        }
    end
    if self._lastFavorByGUID then
        snap.lastFavorByGUID = {}
        for guid, v in pairs(self._lastFavorByGUID) do
            snap.lastFavorByGUID[guid] = { xp = v.xp, level = v.level }
        end
    end
    return snap
end

function Tracker:_RecordChestObservation(event, ...)
    if not CHEST_OBSERVED_EVENTS[event] then return end
    local obs = VE_DB and VE_DB.chestObservations
    if not obs then return end
    local n = select("#", ...)
    local args = {}
    for i = 1, n do
        local v = select(i, ...)
        args[i] = (type(v) == "table") and shallow_copy(v) or v
    end
    table.insert(obs.events, {
        t = time(),
        gt = GetTime(),
        event = event,
        args = args,
    })
    -- Hard cap: protect SavedVariables size if user forgets to disarm.
    if #obs.events > 500 then
        table.remove(obs.events, 1)
    end
end

function Tracker:ArmChestObservation(seconds)
    seconds = tonumber(seconds) or 120
    if seconds < 10 then seconds = 10 end
    if seconds > 1800 then seconds = 1800 end
    VE_DB = VE_DB or {}
    VE_DB.chestObservations = {
        version = 1,
        armedAt = time(),
        armedAtGameTime = GetTime(),
        durationSec = seconds,
        characterKey = VE.GetCharacterKey and VE:GetCharacterKey() or UnitName("player"),
        wowVersion = (GetBuildInfo and select(1, GetBuildInfo())) or "?",
        baseline = self:_SnapshotChestState(),
        events = {},
        finalSnapshot = nil,
        disarmedAt = nil,
        disarmReason = nil,
    }
    self._chestArmed = true
    if self._chestArmTimer then self._chestArmTimer:Cancel() end
    self._chestArmTimer = C_Timer.NewTimer(seconds, function()
        self._chestArmTimer = nil
        self:DisarmChestObservation("auto-timeout")
    end)
    print(("|cFF2aa198[VE chest]|r Raw capture ARMED for %ds. Click your completion chest now. Run /ve dumpchest after."):format(seconds))
    local b = VE_DB.chestObservations.baseline
    print(("|cFF93a1a1[VE chest baseline]|r availableXP=%s coupons=%s activeGUID=%s cycle=%s claimed=%s"):format(
        tostring(b.availableHouseXP), tostring(b.couponBalance), tostring(b.activeGUID),
        tostring(b.currentCycleID), tostring(b.chest and b.chest.claimed)))
end

function Tracker:DisarmChestObservation(reason)
    if not self._chestArmed and not (VE_DB and VE_DB.chestObservations and not VE_DB.chestObservations.disarmedAt) then
        print("|cFFdc322f[VE chest]|r No active capture window.")
        return
    end
    self._chestArmed = false
    if self._chestArmTimer then self._chestArmTimer:Cancel(); self._chestArmTimer = nil end
    local obs = VE_DB and VE_DB.chestObservations
    if obs then
        obs.disarmedAt = time()
        obs.disarmReason = reason or "manual"
        obs.finalSnapshot = self:_SnapshotChestState()
        print(("|cFF2aa198[VE chest]|r Capture window CLOSED (%s). %d events captured. Run /ve dumpchest to print, or inspect VE_DB.chestObservations."):format(
            obs.disarmReason, #obs.events))
    end
end

-- Format a value as a Lua-ish literal (recursive, indented). Used by
-- DumpChestObservation to serialize the captured tables into a blob that's
-- copy-pasteable into a text file or a Lua interpreter.
local function fmt_lit(v, indent, seen)
    indent = indent or ""
    if type(v) == "string" then
        return string.format("%q", v)
    elseif type(v) == "number" or type(v) == "boolean" then
        return tostring(v)
    elseif type(v) == "nil" then
        return "nil"
    elseif type(v) == "table" then
        seen = seen or {}
        if seen[v] then return "<cycle>" end
        seen[v] = true
        local parts = {}
        local keys, isArray = {}, true
        for k in pairs(v) do
            keys[#keys + 1] = k
            if type(k) ~= "number" then isArray = false end
        end
        if isArray then
            table.sort(keys)
        else
            table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
        end
        local nextIndent = indent .. "  "
        for _, k in ipairs(keys) do
            local keyStr = isArray and "" or (type(k) == "string" and k:match("^[%a_][%w_]*$") and (k .. " = ") or ("[" .. fmt_lit(k, nextIndent, seen) .. "] = "))
            parts[#parts + 1] = nextIndent .. keyStr .. fmt_lit(v[k], nextIndent, seen)
        end
        if #parts == 0 then return "{}" end
        return "{\n" .. table.concat(parts, ",\n") .. ",\n" .. indent .. "}"
    end
    return "<" .. type(v) .. ">"
end

function Tracker:DumpChestObservation()
    local obs = VE_DB and VE_DB.chestObservations
    if not obs then
        print("|cFFdc322f[VE chest]|r No observations recorded. Run /ve armchest first.")
        return
    end
    if not (VE.UI and VE.UI.ShowCSVExportWindow) then
        print("|cFFdc322f[VE chest]|r Copy window unavailable; run |cFFffd700/dump VE_DB.chestObservations|r instead.")
        return
    end

    local lines = {}
    local function L(s) lines[#lines + 1] = s end
    local b = obs.baseline or {}

    L(("-- VE chest observation dump  char=%s  wow=%s"):format(tostring(obs.characterKey), tostring(obs.wowVersion)))
    L(("-- armed=%s  disarmed=%s  reason=%s  duration=%ds  events=%d"):format(
        date("%Y-%m-%d %H:%M:%S", obs.armedAt),
        obs.disarmedAt and date("%Y-%m-%d %H:%M:%S", obs.disarmedAt) or "(active)",
        tostring(obs.disarmReason), obs.durationSec or 0, #obs.events))
    L("")
    L("-- ============================================================")
    L("-- BASELINE (taken at /ve armchest)")
    L("-- ============================================================")
    L("baseline = " .. fmt_lit(obs.baseline or {}, ""))
    L("")
    L("-- ============================================================")
    L(("-- EVENTS (%d captured, ordered, t = seconds since arm)"):format(#obs.events))
    L("-- ============================================================")
    local t0 = obs.armedAtGameTime or 0
    for i, ev in ipairs(obs.events) do
        local rel = (ev.gt or 0) - t0
        local detail = ""
        if ev.event == "QUEST_TURNED_IN" then
            detail = ("  -- questID=%s xp=%s money=%s"):format(tostring(ev.args and ev.args[1]), tostring(ev.args and ev.args[2]), tostring(ev.args and ev.args[3]))
        elseif ev.event == "HOUSE_LEVEL_FAVOR_UPDATED" then
            local p = (ev.args and ev.args[1]) or {}
            -- tostring(secret) errors; render secret-restricted fields as "[secret]" instead.
            local function safeStr(v)
                if v == nil then return "nil" end
                if issecretvalue(v) then return "[secret]" end
                return tostring(v)
            end
            if canaccesstable(p) then
                detail = ("  -- houseGUID=%s favor=%s level=%s"):format(safeStr(p.houseGUID), safeStr(p.houseFavor), safeStr(p.houseLevel))
            else
                detail = "  -- [secret payload]"
            end
        elseif ev.event == "CURRENCY_DISPLAY_UPDATE" then
            detail = ("  -- type=%s qtyChange=%s gainSource=%s"):format(
                tostring(ev.args and ev.args[1]), tostring(ev.args and ev.args[3]), tostring(ev.args and ev.args[4]))
        elseif ev.event == "INITIATIVE_TASK_COMPLETED" then
            detail = ("  -- taskName=%s"):format(tostring(ev.args and ev.args[1]))
        end
        L(("[%d] @+%.2fs  %s%s"):format(i, rel, ev.event, detail))
        L("    args = " .. fmt_lit(ev.args or {}, "    "))
    end
    L("")
    L("-- ============================================================")
    L("-- FINAL SNAPSHOT (taken at /ve disarmchest or auto-timeout)")
    L("-- ============================================================")
    if obs.finalSnapshot then
        local f = obs.finalSnapshot
        local availDelta, coupDelta
        if type(b.availableHouseXP) == "number" and type(f.availableHouseXP) == "number" then
            availDelta = f.availableHouseXP - b.availableHouseXP
        end
        if type(b.couponBalance) == "number" and type(f.couponBalance) == "number" then
            coupDelta = f.couponBalance - b.couponBalance
        end
        L(("-- availableHouseXP delta = %s    couponBalance delta = %s"):format(tostring(availDelta), tostring(coupDelta)))
        L("finalSnapshot = " .. fmt_lit(obs.finalSnapshot, ""))
    else
        L("-- (no final snapshot -- capture window still active, run /ve disarmchest)")
    end

    local blob = table.concat(lines, "\n")
    print(("|cFF2aa198[VE chest]|r Opening copy window: %d events, ~%d chars."):format(#obs.events, #blob))
    VE.UI:ShowCSVExportWindow(blob, #obs.events, ("Chest Dump (%d events)"):format(#obs.events))
end

function Tracker:_ProcessHouseListUpdate(houseInfoList)
    local debug = VE.Store:GetState().config.debug
    if debug then
        print("|cFF2aa198[VE Tracker]|r House list updated with " .. (houseInfoList and #houseInfoList or 0) .. " houses")
    end

    self.houseList = houseInfoList or {}
    self.houseListLoaded = true

    -- Preserve user's dropdown selection if still valid in the new list
    if self.hasManualSelection and self.currentHouseGUID then
        for i, h in ipairs(self.houseList) do
            if h.houseGUID == self.currentHouseGUID then
                self.selectedHouseIndex = i
                self:QueueDataRefresh()
                return
            end
        end
        self.hasManualSelection = false
    end

    local selectedIndex, neighborhoodGUID = self:FindBestHouseIndex(houseInfoList)

    if selectedIndex then
        self.selectedHouseIndex = selectedIndex
        self.currentHouseGUID = houseInfoList[selectedIndex].houseGUID
        VE_DB = VE_DB or {}
        VE_DB.selectedHouseGUID = self.currentHouseGUID
    end

    local selectedHouseInfo = houseInfoList and houseInfoList[selectedIndex]
    if selectedHouseInfo and selectedHouseInfo.houseGUID then
        VE.Store:Dispatch("SET_HOUSE_GUID", { houseGUID = selectedHouseInfo.houseGUID })
        if C_Housing and C_Housing.GetCurrentHouseLevelFavor then
            pcall(C_Housing.GetCurrentHouseLevelFavor, selectedHouseInfo.houseGUID)
        end
    end

    -- Active endeavor reminder (once on login, separate from version message)
    -- Uses selectedHouseInfo already resolved by FindBestHouseIndex above
    local showLoginMsg = VE.Store:GetState().config.showLoginActiveEndeavor
    if showLoginMsg and not VE._activeHouseShown and selectedHouseInfo then
        VE._activeHouseShown = true
        local name = GetHouseDisplayName(selectedHouseInfo)
        if name then
            local faction
            if C_Housing and C_Housing.DoesFactionMatchNeighborhood and neighborhoodGUID then
                local matches = C_Housing.DoesFactionMatchNeighborhood(neighborhoodGUID)
                local playerFaction = UnitFactionGroup("player")
                if playerFaction == "Alliance" then
                    faction = matches and "Alliance" or "Horde"
                elseif playerFaction == "Horde" then
                    faction = matches and "Horde" or "Alliance"
                end
            end
            local tag = faction and (" (|cFF" .. (faction == "Alliance" and "4488ff" or "ff4444") .. faction .. "|r)") or ""
            -- ProcessInitiativeInfo will pick up _pendingLoginMsg and print with the time left.
            -- That fires reliably via NEIGHBORHOOD_INITIATIVE_UPDATED -- no fallback timer needed.
            self._pendingLoginMsg = { name = name, tag = tag }
        end
    end

    VE.EventBus:Trigger("VE_HOUSE_LIST_UPDATED", { houseList = self.houseList, selectedIndex = selectedIndex })

    self:_RequestNeighborhoodData(neighborhoodGUID)
    self:QueueDataRefresh()
end

-- Tell the server we're viewing this neighborhood and ask it to push us the data.
-- Server responses fire NEIGHBORHOOD_INITIATIVE_UPDATED + INITIATIVE_ACTIVITY_LOG_UPDATED
-- which our handlers turn into QueueDataRefresh + RefreshActivityLogCache automatically.
function Tracker:_RequestNeighborhoodData(neighborhoodGUID)
    if not C_NeighborhoodInitiative or not neighborhoodGUID then return end
    C_NeighborhoodInitiative.SetViewingNeighborhood(neighborhoodGUID)
    C_NeighborhoodInitiative.RequestNeighborhoodInitiativeInfo()
    self:RequestActivityLog()
end

-- ============================================================================
-- DATA FETCHING
-- ============================================================================

function Tracker:UpdateFetchStatus(state)
    self.fetchStatus.state = state
    self.fetchStatus.lastAttempt = time()
end

function Tracker:GetViewingNeighborhoodGUID()
    if self.houseList and self.selectedHouseIndex and self.houseList[self.selectedHouseIndex] then
        return self.houseList[self.selectedHouseIndex].neighborhoodGUID
    end
    return nil
end

function Tracker:IsViewingActiveNeighborhood()
    if not C_NeighborhoodInitiative then return false end
    local activeGUID = C_NeighborhoodInitiative.GetActiveNeighborhood and C_NeighborhoodInitiative.GetActiveNeighborhood()
    local viewingGUID = self:GetViewingNeighborhoodGUID()
    if not activeGUID or not viewingGUID then return false end
    return activeGUID == viewingGUID
end

function Tracker:QueueDataRefresh()
    if self.pendingRefreshTimer then
        self.pendingRefreshTimer:Cancel()
    end
    self.pendingRefreshTimer = C_Timer.NewTimer(0.3, function()
        self.pendingRefreshTimer = nil
        self:FetchEndeavorData()
        if not InCombatLockdown() and VE.MainFrame and VE.MainFrame:IsShown() and VE.RefreshUI then
            VE:RefreshUI()
        end
    end)
end

function Tracker:ValidateRequirements()
    if not C_NeighborhoodInitiative then return "api_unavailable" end
    if not C_NeighborhoodInitiative.IsInitiativeEnabled() then return "disabled" end
    if not C_NeighborhoodInitiative.PlayerMeetsRequiredLevel() then return "low_level" end
    if not C_NeighborhoodInitiative.PlayerHasInitiativeAccess() then return "no_access" end
    return "ok"
end

function Tracker:ClearEndeavorData(seasonName)
    self:UpdateFetchStatus("loaded")
    VE.Store:Dispatch("SET_ENDEAVOR_INFO", {
        seasonName = seasonName or "No Active Endeavor",
        seasonEndTime = 0,
        currentProgress = 0,
        maxProgress = 0,
        milestones = {},
        initiativeID = 0,
    })
    VE.Store:Dispatch("SET_TASKS", { tasks = {} })
    self.activityLogLoaded = false
    VE.EventBus:Trigger("VE_ACTIVITY_LOG_UPDATED", { timestamp = nil })
end

function Tracker:FetchEndeavorData()
    local debug = VE.Store:GetState().config.debug

    -- Debounce: skip if fetched within last 1 second
    local now = GetTime()
    if self.lastFetchTime and (now - self.lastFetchTime) < 1 then return end
    self.lastFetchTime = now

    local skipRequest = self.lastRequestTime and (now - self.lastRequestTime) < 2

    self:UpdateFetchStatus("fetching")

    -- Validate API access
    local req = self:ValidateRequirements()
    if req ~= "ok" then
        if debug then
            print("|cFFdc322f[VE Tracker]|r API check failed: " .. req)
        end
        return
    end

    -- Re-assert viewing neighborhood if user has a manual selection
    -- (Blizzard house menu can silently reset this)
    if self.hasManualSelection then
        local manualGUID = self:GetViewingNeighborhoodGUID()
        if manualGUID and C_NeighborhoodInitiative.SetViewingNeighborhood then
            C_NeighborhoodInitiative.SetViewingNeighborhood(manualGUID)
        end
    end

    -- Request fresh data if not recently requested
    if not skipRequest then
        self.lastRequestTime = now
        C_NeighborhoodInitiative.RequestNeighborhoodInitiativeInfo()
    end

    local initiativeInfo = C_NeighborhoodInitiative.GetNeighborhoodInitiativeInfo()

    if not initiativeInfo or not initiativeInfo.isLoaded then
        if debug then
            print("|cFF2aa198[VE Tracker]|r Initiative data not loaded yet, waiting for NEIGHBORHOOD_INITIATIVE_UPDATED...")
        end
        -- No retry timer needed. RequestNeighborhoodInitiativeInfo() always fires
        -- NEIGHBORHOOD_INITIATIVE_UPDATED when the server responds, and our event
        -- handler calls QueueDataRefresh -> FetchEndeavorData. Panel-open health
        -- check covers the edge case where the event never arrives.
        self:UpdateFetchStatus("waiting")
        return
    end

    self:UpdateFetchStatus("loaded")

    -- Detect active neighborhood changes
    local activeGUID = C_NeighborhoodInitiative.GetActiveNeighborhood and C_NeighborhoodInitiative.GetActiveNeighborhood()
    local dataGUID = initiativeInfo.neighborhoodGUID
    local expectedGUID = self:GetViewingNeighborhoodGUID()

    if activeGUID and activeGUID ~= self.lastKnownActiveGUID then
        self.lastKnownActiveGUID = activeGUID
        self.hasManualSelection = false -- active neighborhood changed, respect it
        VE.EventBus:Trigger("VE_ACTIVE_NEIGHBORHOOD_CHANGED")
    end

    -- Clear pending-active flag once the API confirms the change settled.
    if self._pendingActiveGUID and activeGUID == self._pendingActiveGUID then
        self._pendingActiveGUID = nil
    end
    -- During the SetActiveNeighborhood settle window, treat the pending GUID as
    -- effectively-active so we don't trip the "viewing non-active" branch below.
    local effectiveActive = (self._pendingActiveGUID == dataGUID) and self._pendingActiveGUID or activeGUID

    -- Stale data guard: if the returned data doesn't match what we're viewing,
    -- discard and wait for the correct response (avoids flash-wipe during rapid switching)
    if dataGUID and expectedGUID and dataGUID ~= expectedGUID then
        if debug then
            print("|cFF2aa198[VE Tracker]|r Stale data (got " .. tostring(dataGUID) .. ", expected " .. tostring(expectedGUID) .. "), discarding")
        end
        return
    end

    -- Sync dropdown if Blizzard dashboard changed the viewing neighborhood
    -- Skip if user has a manual selection (Blizzard menu can reset viewing neighborhood)
    if dataGUID and self.houseList and not self.hasManualSelection then
        local selectedGUID = self.selectedHouseIndex and self.houseList[self.selectedHouseIndex]
                             and self.houseList[self.selectedHouseIndex].neighborhoodGUID
        if dataGUID ~= selectedGUID then
            for i, houseInfo in ipairs(self.houseList) do
                if houseInfo.neighborhoodGUID == dataGUID then
                    if debug then
                        print("|cFF2aa198[VE Tracker]|r Syncing dropdown to match Blizzard's selection: house " .. i)
                    end
                    self.selectedHouseIndex = i
                    self.currentHouseGUID = houseInfo.houseGUID
                    VE_DB = VE_DB or {}
                    VE_DB.selectedHouseGUID = houseInfo.houseGUID
                    VE.EventBus:Trigger("VE_HOUSE_LIST_UPDATED", { houseList = self.houseList, selectedIndex = i })
                    break
                end
            end
        end
    end

    -- If viewing a non-active neighborhood, clear data
    if dataGUID and effectiveActive and dataGUID ~= effectiveActive then
        if debug then
            print("|cFF2aa198[VE Tracker]|r Viewing non-active neighborhood, clearing data")
        end
        self:ClearEndeavorData("Not Active Endeavor")
        return
    end

    if initiativeInfo.initiativeID == 0 then
        if debug then
            print("|cFF2aa198[VE Tracker]|r No active initiative (choosing phase)")
        end
        self:ClearEndeavorData("No Active Endeavor")
        return
    end

    self:ProcessInitiativeInfo(initiativeInfo)
end

function Tracker:RequestActivityLog()
    if C_NeighborhoodInitiative and C_NeighborhoodInitiative.RequestInitiativeActivityLog then
        C_NeighborhoodInitiative.RequestInitiativeActivityLog()
    end
end

function Tracker:RefreshAll()
    local debug = VE.Store:GetState().config.debug
    self:UpdateFetchStatus("fetching")

    if not C_NeighborhoodInitiative then
        if debug then
            print("|cFFdc322f[VE Tracker]|r RefreshAll: C_NeighborhoodInitiative not available")
        end
        return
    end

    if debug then
        print("|cFF2aa198[VE Tracker]|r RefreshAll: Requesting data for current viewing neighborhood")
    end
    C_NeighborhoodInitiative.RequestNeighborhoodInitiativeInfo()
    self:RequestActivityLog()
end

-- ============================================================================
-- DATA PROCESSING
-- ============================================================================

function Tracker:ProcessInitiativeInfo(info)
    -- Absolute end time, not a whole-day count: the header needs sub-day
    -- precision to keep counting through the final 24 hours. nil when the API
    -- reports no duration, so the reducer keeps whatever it already had.
    local endTime = (info.duration and info.duration > 0) and (time() + info.duration) or nil

    -- Process milestones
    local milestones = {}
    local maxProgress = 0
    local finalMilestone = nil
    if info.milestones then
        for _, milestone in ipairs(info.milestones) do
            local threshold = milestone.requiredContributionAmount or 0
            if threshold > maxProgress then
                maxProgress = threshold
                finalMilestone = milestone
            end
            table.insert(milestones, {
                threshold = threshold,
                reached = (info.currentProgress or 0) >= threshold,
                rewards = milestone.rewards,
            })
        end
    end
    if maxProgress == 0 then
        maxProgress = info.progressRequired or 100
    end

    -- Derive completion-chest reward (12.0.5 InitiativeMilestoneRewardInfo).
    -- Final milestone carries `favor` (House XP) + a rewardQuestID that pays
    -- one or more currencies (typically Coupons 3363). Player must click the
    -- chest in the neighborhood -- there is no addon-callable claim API.
    -- Chest always pays 250 House XP (confirmed by Vamoose). Blizzard's
    -- InitiativeMilestoneRewardInfo.favor field returns 0 even on 12.0.5 so
    -- we don't try to read it.
    local CHEST_XP = 250
    local chest = { available = false, claimed = false, xp = 0, currencies = {}, rewardQuestID = 0 }
    if finalMilestone and finalMilestone.rewards then
        -- Lua quirk: `0 or X` evaluates to 0, not X (zero is truthy). So we
        -- can't fall back through `requiredContributionAmount or maxProgress`
        -- when the API hands back 0/missing -- that would make `0 >= 0` true
        -- right after a cycle rollover before milestone data finishes
        -- streaming, lighting the chest at 0% progress. Pick the first
        -- positive value; fail closed (chest stays unavailable) if neither.
        local required = finalMilestone.requiredContributionAmount
        if not required or required <= 0 then required = maxProgress end
        local progress = info.currentProgress or 0
        local reached = required > 0 and progress >= required
        chest.available = reached
        for _, r in ipairs(finalMilestone.rewards) do
            local qID = r.rewardQuestID or 0
            if qID > 0 then
                chest.rewardQuestID = qID
                -- IsQuestFlaggedCompleted intentionally NOT consulted: it
                -- clears each cycle and is shared across all initiatives
                -- (single quest 93262), so it can't disambiguate per-house
                -- claim state. VE_DB.chestClaims is the source of truth.
                if C_QuestLog and C_QuestLog.GetQuestRewardCurrencyInfo then
                    local i = 1
                    while true do
                        local c = C_QuestLog.GetQuestRewardCurrencyInfo(qID, i, false)
                        if not c then break end
                        table.insert(chest.currencies, {
                            currencyID = c.currencyID,
                            amount = c.totalRewardAmount or 0,
                            name = c.name,
                            texture = c.texture,
                        })
                        i = i + 1
                    end
                end
            end
        end
    end
    if chest.rewardQuestID > 0 then
        chest.xp = CHEST_XP
    end

    -- Cycle-scoped claim record. Chest is ACCOUNT-WIDE per-house: each
    -- house has its own initiative + chest, claiming on one alt claims it
    -- for all alts on that house. Keyed by neighborhoodGUID.
    -- cycleID nil/0 means the API hasn't given us a real cycle yet -- leave
    -- it nil rather than 0 so the equality check can't false-match a stored
    -- 0 against a future-stored 0 (which would mark the chest claimed
    -- forever on that house).
    chest.cycleID = (type(info.currentCycleID) == "number" and info.currentCycleID > 0) and info.currentCycleID or nil
    chest.initiativeID = info.initiativeID or 0
    chest.neighborhoodGUID = info.neighborhoodGUID
    local houseKey = info.neighborhoodGUID
    if houseKey and chest.cycleID and VE_DB and VE_DB.chestClaims then
        local rec = VE_DB.chestClaims[houseKey]
        if rec and rec.lastCycleID and rec.lastCycleID == chest.cycleID then
            chest.claimed = true
            chest.claimedAt = rec.lastClaimTime
            chest.claimedBy = rec.lastClaimedBy
        end
    end

    self._chest = chest
    -- Per-house snapshots so QUEST_TURNED_IN + /ve status can resolve the
    -- ACTIVE house even when the user is viewing a different one in the UI.
    if chest.neighborhoodGUID then
        self._chestByHouse = self._chestByHouse or {}
        self._chestByHouse[chest.neighborhoodGUID] = chest
        self._infoByHouse = self._infoByHouse or {}
        self._infoByHouse[chest.neighborhoodGUID] = {
            seasonName = info.title or "",
            currentProgress = info.currentProgress or 0,
            maxProgress = maxProgress,
            endTime = endTime,
            cycleID = info.currentCycleID or 0,
            initiativeID = info.initiativeID or 0,
            playerTotalContribution = info.playerTotalContribution or 0,
        }
    end

    if VE.Store:GetState().config.debug and finalMilestone then
        print(("|cFF6c71c4[VE chest]|r final milestone idx=%s threshold=%s rewards=%d"):format(
            tostring(finalMilestone.milestoneOrderIndex), tostring(finalMilestone.requiredContributionAmount),
            finalMilestone.rewards and #finalMilestone.rewards or 0))
        if finalMilestone.rewards then
            for i, r in ipairs(finalMilestone.rewards) do
                print(("|cFF6c71c4  [%d]|r favor=%s money=%s decorID=%s decorQty=%s questID=%s title=%q"):format(
                    i, tostring(r.favor), tostring(r.money), tostring(r.decorID),
                    tostring(r.decorQuantity), tostring(r.rewardQuestID), tostring(r.title or "")))
            end
        end
    end

    VE.Store:Dispatch("SET_ENDEAVOR_INFO", {
        seasonName = info.title or "Unknown Endeavor",
        seasonEndTime = endTime,
        currentProgress = info.currentProgress or 0,
        maxProgress = maxProgress,
        milestones = milestones,
        description = info.description,
        initiativeID = info.initiativeID,
        playerTotalContribution = info.playerTotalContribution or 0,
        chest = chest,
    })

    -- Deferred login message (now we know how long is left)
    if self._pendingLoginMsg then
        local msg = self._pendingLoginMsg
        self._pendingLoginMsg = nil
        local span = VE:FormatDuration(info.duration)
        local timeStr = span and (" -- |cFFe5c040" .. span .. " remaining|r") or ""
        -- Append chest status (silent when chest is locked-not-yet-at-100%
        -- to avoid noise; only shows when actionable or already-done).
        local chestStr = ""
        local chestReady = false
        if chest and chest.xp and chest.xp > 0 then
            if chest.claimed then
                chestStr = " -- |cFF859900chest claimed|r"
            elseif chest.available then
                local couponAmount = 0
                if chest.currencies then
                    local couponID = (VE.Constants and VE.Constants.CURRENCY_IDS and VE.Constants.CURRENCY_IDS.COMMUNITY_COUPONS) or 3363
                    for _, c in ipairs(chest.currencies) do
                        if c.currencyID == couponID then couponAmount = c.amount or 0; break end
                    end
                end
                local rewardStr = ("+%d XP"):format(chest.xp)
                if couponAmount > 0 then rewardStr = rewardStr .. (" + %d coupons"):format(couponAmount) end
                chestStr = (" -- |cFFb58900chest READY|r |cFFffd700(%s)|r"):format(rewardStr)
                chestReady = true
            end
        end
        print("|cFF2aa198[VE]|r Active endeavor: |cFFffd700" .. msg.name .. "|r" .. msg.tag .. timeStr .. chestStr)
        if chestReady then
            print("|cFF2aa198[VE]|r |cFF93a1a1(type |cFFffd700/ve claimed|r|cFF93a1a1 if you have already claimed chest for this house)|r")
        end
    end

    -- Re-request favor now that Store has the new seasonEndTime.
    -- Clear favor dedup cache so the update reaches _OnHouseLevelFavorUpdated
    -- (max-level houses have unchanged favor, normally deduped).
    if self.currentHouseGUID and C_Housing and C_Housing.GetCurrentHouseLevelFavor then
        self._lastFavorByGUID[self.currentHouseGUID] = nil
        pcall(C_Housing.GetCurrentHouseLevelFavor, self.currentHouseGUID)
    end

    -- Record initiative for collection
    if info.initiativeID and info.initiativeID > 0 and info.title then
        VE.Store:Dispatch("RECORD_INITIATIVE", {
            initiativeID = info.initiativeID,
            title = info.title,
            description = info.description,
        })
    end

    -- Process tasks
    local tasks = {}
    local hasMissingCoupons = false
    if info.tasks then
        for _, task in ipairs(info.tasks) do
            if not task.supersedes or task.supersedes == 0 then
                local isRepeatable = task.taskType and task.taskType > 0
                local couponReward, couponBase = self:GetTaskCouponReward(task)
                if couponReward == nil then
                    hasMissingCoupons = true
                    couponReward = 0
                    couponBase = 0
                end
                table.insert(tasks, {
                    id = task.ID,
                    name = task.taskName,
                    description = task.description or "",
                    points = task.progressContributionAmount or 0,
                    progressContributionAmount = task.progressContributionAmount or 0,
                    completed = task.completed or false,
                    current = self:GetTaskProgress(task),
                    max = self:GetTaskMax(task),
                    taskType = task.taskType,
                    tracked = task.tracked or false,
                    sortOrder = task.sortOrder or 999,
                    requirementsList = task.requirementsList,
                    timesCompleted = task.timesCompleted,
                    isRepeatable = isRepeatable,
                    rewardQuestID = task.rewardQuestID,
                    couponReward = couponReward,
                    couponBase = couponBase,
                })
            end
        end

        table.sort(tasks, function(a, b)
            if a.completed ~= b.completed then
                return not a.completed
            end
            return (a.sortOrder or 999) < (b.sortOrder or 999)
        end)
    end

    -- Check for task progress changes (squirrel quotes)
    if VE.Vamoose and VE.Vamoose.OnTaskProgress then
        local oldTasks = VE.Store:GetState().tasks or {}
        local oldProgress = {}
        for _, task in ipairs(oldTasks) do
            if task.id and task.current and task.max then
                oldProgress[task.id] = task.current
            end
        end
        for _, task in ipairs(tasks) do
            if task.id and task.current and task.max and not task.completed then
                local oldCurrent = oldProgress[task.id]
                if oldCurrent and task.current > oldCurrent then
                    VE.Vamoose.OnTaskProgress(task.id, task.name, task.current, task.max)
                end
            end
        end
    end

    -- Cache live tasks BEFORE dispatching SET_TASKS so CalculateNextContribution
    -- has them when UI renders from the state change.
    self.liveTasks = info.tasks or {}

    VE.Store:Dispatch("SET_TASKS", { tasks = tasks })

    -- Retry if coupon data wasn't ready (cancel-replace so back-to-back fetches
    -- with missing coupons don't pile up overlapping retries).
    if hasMissingCoupons then
        if self._couponRetryTimer then self._couponRetryTimer:Cancel() end
        self._couponRetryTimer = C_Timer.NewTimer(2, function()
            self._couponRetryTimer = nil
            VE.EndeavorTracker:FetchEndeavorData()
        end)
    end
end

function Tracker:GetTaskProgress(task)
    if task.requirementsList and #task.requirementsList > 0 then
        local req = task.requirementsList[1]
        if req.requirementText then
            local current = req.requirementText:match("(%d+)%s*/%s*%d+")
            if current then return tonumber(current) or 0 end
        end
    end
    return task.completed and 1 or 0
end

function Tracker:GetTaskMax(task)
    if task.requirementsList and #task.requirementsList > 0 then
        local req = task.requirementsList[1]
        if req.requirementText then
            local max = req.requirementText:match("%d+%s*/%s*(%d+)")
            if max then return tonumber(max) or 1 end
        end
    end
    return 1
end

-- Blizzard's own dampener, added in 12.1 (Blizzard_FrameXMLUtil/QuestUtils.lua
-- runs quest favor and currency rewards through it before showing them). It
-- knows the task's repetition count, so it answers what the NEXT completion
-- actually pays -- authoritative where our curve was only a forecast.
-- exception(boundary): absent on 12.0.7, which the TOC still supports; the
-- undampened base is the honest answer there rather than a guessed multiplier.
local function ScaleTaskReward(taskID, amount)
    if amount <= 0 then return amount end
    if not (taskID and C_NeighborhoodInitiative.GetInitiativeTaskRewardScaling) then return amount end
    return C_NeighborhoodInitiative.GetInitiativeTaskRewardScaling(taskID, amount)
end

-- Returns (couponReward, couponBase) for a task: the dampened amount the next
-- completion pays, and the undampened base from Blizzard's quest reward data
-- (which the tooltip's DR ladder is built from). Returns nil,nil while that
-- quest data is still loading (caller retries).
function Tracker:GetTaskCouponReward(task)
    if not task.rewardQuestID or task.rewardQuestID == 0 then
        return 0, 0
    end
    if not (C_QuestLog and C_QuestLog.GetQuestRewardCurrencies) then
        return 0, 0
    end
    local rewards = C_QuestLog.GetQuestRewardCurrencies(task.rewardQuestID)
    if not rewards or #rewards == 0 then
        return nil, nil
    end
    local base = 0
    local couponID = VE.Constants and VE.Constants.CURRENCY_IDS and VE.Constants.CURRENCY_IDS.COMMUNITY_COUPONS or 3363
    for _, reward in ipairs(rewards) do
        if reward.currencyID == couponID then
            base = reward.totalRewardAmount or 0
            break
        end
    end
    return ScaleTaskReward(task.ID, base), base
end

function Tracker:RefreshTrackedTasks()
    if not C_NeighborhoodInitiative then return end
    local trackedInfo = C_NeighborhoodInitiative.GetTrackedInitiativeTasks()
    if not trackedInfo or not trackedInfo.trackedIDs then return end

    local state = VE.Store:GetState()
    local changed = false
    local updated = {}
    for _, task in ipairs(state.tasks) do
        local newTracked = tContains(trackedInfo.trackedIDs, task.id)
        if newTracked ~= task.tracked then changed = true end
        local copy = {}
        for k, v in pairs(task) do copy[k] = v end
        copy.tracked = newTracked
        table.insert(updated, copy)
    end
    if changed then
        VE.Store:Dispatch("SET_TASKS", { tasks = updated })
    end
end

-- ============================================================================
-- ACTIVITY LOG
-- ============================================================================

function Tracker:RefreshActivityLogCache()
    if not C_NeighborhoodInitiative or not C_NeighborhoodInitiative.GetInitiativeActivityLogInfo then return end

    local logInfo = C_NeighborhoodInitiative.GetInitiativeActivityLogInfo()
    if not logInfo or not logInfo.isLoaded then return end

    self.cachedActivityLog = logInfo
    self.activityLogLoaded = true
    self.activityLogLastUpdated = time()
    self.activityLogStale = false

    self:_RebuildXPIndexes()

    VE.EventBus:Trigger("VE_ACTIVITY_LOG_UPDATED", { timestamp = self.activityLogLastUpdated })
end

function Tracker:IsActivityLogLoaded()
    return self.activityLogLoaded
end

-- ============================================================================
-- XP / per-task API (was VE.XPEngine before v1.16)
-- Indexes are rebuilt by _RebuildXPIndexes whenever the activity log refreshes.
-- House switch -> SetViewingNeighborhood -> server pushes new log ->
-- INITIATIVE_ACTIVITY_LOG_UPDATED -> debounced rebuild. No persistence,
-- no instant-restore -- header shows 0 briefly until the first log lands.
-- ============================================================================

function Tracker:GetActivityLogData()
    return self.cachedActivityLog
end

-- Returns available house XP this cycle, straight from Blizzard's 12.0.5 API.
-- Returns nil when the value is secret-restricted (player housing interior on
-- some accounts) -- callers must check and degrade gracefully. type() does NOT
-- distinguish secret numbers from real ones (type(secret) == "number" today),
-- so the explicit issecretvalue check is required.
function Tracker:GetHouseXP()
    local fn = C_NeighborhoodInitiative and C_NeighborhoodInitiative.GetAvailableHouseXP
    if not fn then return 0 end
    local ok, value = pcall(fn)
    if not ok or type(value) ~= "number" then return 0 end
    if issecretvalue(value) then return nil end
    return value
end

function Tracker:GetPlayerContribution()
    return self.playerContribution or 0
end

-- Completion-chest snapshot derived from final InitiativeMilestoneRewardInfo.
-- Returns the snapshot for the user's CURRENTLY-VIEWED house (whatever
-- the addon UI dropdown is set to). Use GetActiveChest() for the chest
-- that actually earns XP for the player.
-- { available, claimed, xp, currencies, rewardQuestID, neighborhoodGUID, ... }
function Tracker:GetChest()
    return self._chest or { available = false, claimed = false, xp = 0, currencies = {}, rewardQuestID = 0 }
end

-- Chest for the player's ACTIVE neighborhood (the one earning XP / where
-- the player can actually claim the chest). Falls back to the viewed
-- snapshot if the active house hasn't been processed yet.
function Tracker:GetActiveChest()
    local activeGUID = self:GetActiveNeighborhoodGUID()
    if activeGUID and self._chestByHouse and self._chestByHouse[activeGUID] then
        return self._chestByHouse[activeGUID]
    end
    return self:GetChest()
end

function Tracker:GetActiveNeighborhoodGUID()
    return C_NeighborhoodInitiative and C_NeighborhoodInitiative.GetActiveNeighborhood
        and C_NeighborhoodInitiative.GetActiveNeighborhood() or nil
end

-- Cached snapshot for the active house (or nil if we haven't seen it yet).
function Tracker:GetActiveInfo()
    local activeGUID = self:GetActiveNeighborhoodGUID()
    if activeGUID and self._infoByHouse then return self._infoByHouse[activeGUID], activeGUID end
    return nil, activeGUID
end

-- GetAvailableHouseXP() is the cycle cap counting down. Add the unclaimed
-- chest favor to project the maximum house XP still earnable this cycle.
-- Returns nil-projected when GetHouseXP is secret-restricted; callers should
-- treat that as "unknown" and skip arithmetic display.
function Tracker:GetProjectedHouseXP()
    local remaining = self:GetHouseXP()
    local chest = self:GetActiveChest()
    local bonus = (chest.available and not chest.claimed) and (chest.xp or 0) or 0
    if not remaining then return nil, nil, bonus end
    return remaining + bonus, remaining, bonus
end

-- DR curve 87592 (the only curve Blizzard uses for repeatable initiative tasks):
-- rep 0 = 100%, rep 1 = 90%, ... rep 5+ = 50% floor. Still drives the step
-- COLOURS and the tooltip's future-completions ladder -- ScaleTaskReward only
-- answers for the next completion, not the ones after it.
-- See Reference/VE_DB2_DATA_REFERENCE.md.
local function DRFactor(timesCompleted)
    local n = timesCompleted or 0
    if n >= 5 then return 0.50, 5, true end
    return 1.0 - (n * 0.10), n, false
end

-- DR step info for a task. Returns nil if DR doesn't apply (single / finite).
-- step: 0..5 (which DR rung the NEXT completion lands on).
-- multiplier: 1.0..0.5
-- atFloor: true when step == 5 (50%, no further dampening).
function Tracker:GetDRStepInfo(task)
    if not task then return nil end
    -- All repeatable tasks (RepeatableFinite==1, RepeatableInfinite==2) dampen.
    -- Single tasks (taskType==0) get no DR.
    if (task.taskType or 0) <= 0 then return nil end
    local mult, step, atFloor = DRFactor(task.timesCompleted)
    return { step = step, multiplier = mult, atFloor = atFloor }
end

-- Predicted progress contribution for the next completion of taskName.
-- Blizzard's GetInitiativeTaskInfo already returns progressContributionAmount as
-- the DAMPENED forecast for the next completion (verified empirically: same task
-- shows 45 at rep 1, 40 at rep 2 against base 50). So we just trust that value.
function Tracker:CalculateNextContribution(taskName)
    for _, t in ipairs(self.liveTasks or {}) do
        local name = t.taskName or t.name
        if name == taskName then
            return t.progressContributionAmount or 0
        end
    end
    return 0
end

-- Top 3 incomplete repeatable tasks ranked by next contribution.
function Tracker:GetTaskRankings()
    local candidates = {}
    for _, task in ipairs(self.liveTasks or {}) do
        local taskType = task.taskType or 0
        local taskID = task.ID or task.id
        if taskType > 0 and taskID and not task.completed then
            local nextXP = self:CalculateNextContribution(task.taskName or task.name)
            if nextXP > 0 then
                candidates[#candidates + 1] = { id = taskID, nextXP = nextXP }
            end
        end
    end

    table.sort(candidates, function(a, b) return a.nextXP > b.nextXP end)

    local rankings = {}
    for rank = 1, math.min(3, #candidates) do
        rankings[candidates[rank].id] = { rank = rank, nextXP = candidates[rank].nextXP }
    end
    return rankings
end

-- Rebuild per-task indexes from the cached activity log. Called from
-- RefreshActivityLogCache whenever the log refreshes.
-- playerContribution is the ACCOUNT total (sum across all myCharacters that
-- have logged in with VE) so the header matches the leaderboard's grouped row.
function Tracker:_RebuildXPIndexes()
    local log = (self.cachedActivityLog and self.cachedActivityLog.taskActivity) or {}
    local myCharacters = (VE_DB and VE_DB.myCharacters) or {}

    self.charContributions = {}  -- { [charName] = amount } for account characters
    local total = 0
    for i = 1, #log do
        local entry = log[i]
        local pn = entry.playerName
        if pn and myCharacters[pn] then
            local amt = entry.amount or 0
            self.charContributions[pn] = (self.charContributions[pn] or 0) + amt
            total = total + amt
        end
    end
    self.playerContribution = total
end

-- Returns { [charName] = amount } across this account's characters.
function Tracker:GetCharContributions()
    return self.charContributions or {}
end

-- Wipe XP indexes on house switch so the header reads 0 until the new
-- house's activity log lands (and _RebuildXPIndexes repopulates).
function Tracker:_WipeXPIndexes()
    self.playerContribution = 0
    self.charContributions  = {}
    self.liveTasks          = {}
end

-- ============================================================================
-- CHARACTER PROGRESS
-- ============================================================================

function Tracker:SaveCurrentCharacterProgress()
    local charKey = VE:GetCharacterKey()
    local name = UnitName("player")
    local realm = GetNormalizedRealmName() or GetRealmName():gsub("%s", "")
    local _, class = UnitClass("player")

    local state = VE.Store:GetState()
    local taskProgress = {}
    for _, task in ipairs(state.tasks) do
        taskProgress[task.id] = {
            completed = task.completed,
            current = task.current,
            max = task.max,
        }
    end

    VE.Store:Dispatch("UPDATE_CHARACTER_PROGRESS", {
        charKey = charKey,
        name = name,
        realm = realm,
        class = class,
        tasks = taskProgress,
        endeavorInfo = {
            seasonName = state.endeavor.seasonName,
            currentProgress = state.endeavor.currentProgress,
            maxProgress = state.endeavor.maxProgress,
        },
    })
end

function Tracker:GetTrackedCharacters()
    local state = VE.Store:GetState()
    local characters = {}
    if not state.characters then return characters end

    for charKey, charData in pairs(state.characters) do
        table.insert(characters, {
            key = charKey,
            name = charData.name,
            realm = charData.realm,
            class = charData.class,
            lastUpdated = charData.lastUpdated,
        })
    end

    table.sort(characters, function(a, b)
        return a.name < b.name
    end)

    return characters
end

function Tracker:GetCharacterProgress(charKey)
    local state = VE.Store:GetState()
    return state.characters[charKey]
end

-- ============================================================================
-- TASK TRACKING API
-- ============================================================================

function Tracker:TrackTask(taskID)
    if C_NeighborhoodInitiative and C_NeighborhoodInitiative.AddTrackedInitiativeTask then
        C_NeighborhoodInitiative.AddTrackedInitiativeTask(taskID)
    end
end

function Tracker:UntrackTask(taskID)
    if C_NeighborhoodInitiative and C_NeighborhoodInitiative.RemoveTrackedInitiativeTask then
        C_NeighborhoodInitiative.RemoveTrackedInitiativeTask(taskID)
    end
end

function Tracker:GetTaskLink(taskID)
    if C_NeighborhoodInitiative and C_NeighborhoodInitiative.GetInitiativeTaskChatLink then
        return C_NeighborhoodInitiative.GetInitiativeTaskChatLink(taskID)
    end
    return nil
end

function Tracker:GetTaskByName(taskName)
    local state = VE.Store:GetState()
    if not state or not state.tasks then return nil end
    for _, task in ipairs(state.tasks) do
        if task.name == taskName then return task end
    end
    return nil
end

-- ============================================================================
-- HOUSE MANAGEMENT
-- ============================================================================

function Tracker:SelectHouse(index)
    if not self.houseList or #self.houseList == 0 then return end
    if index < 1 or index > #self.houseList then return end

    local houseInfo = self.houseList[index]
    if not houseInfo or not houseInfo.neighborhoodGUID then return end

    self.selectedHouseIndex = index
    self.hasManualSelection = true
    VE_DB = VE_DB or {}
    VE_DB.selectedHouseGUID = houseInfo.houseGUID
    self.currentHouseGUID = houseInfo.houseGUID

    local debug = VE.Store:GetState().config.debug

    if debug then
        print("|cFF2aa198[VE Tracker]|r Selecting house: " .. GetHouseDisplayName(houseInfo) .. " in neighborhood " .. tostring(houseInfo.neighborhoodGUID))
    end

    self:UpdateFetchStatus("fetching")

    -- Clear old data to prevent cross-contamination (tasks cleared via SET_HOUSE_GUID
    -- to avoid double VE_STATE_CHANGED; new tasks arrive from FetchEndeavorData shortly).
    -- XP indexes wiped so the header shows 0 until the new house's activity log lands.
    self.activityLogLoaded = false
    self.cachedActivityLog = nil
    -- MUST clear the timestamp alongside the cache. The Activity and Leaderboard
    -- tabs skip a rebuild when activityLogLastUpdated matches what they last
    -- rendered; leaving the old house's timestamp in place made that guard fire
    -- on the switch, so both tabs kept showing the PREVIOUS neighborhood's rows
    -- (attributed to the newly-selected house) until a fresh log happened to land.
    self.activityLogLastUpdated = nil
    self:_WipeXPIndexes()

    if VE.Vamoose and VE.Vamoose.ResetTracking then
        VE.Vamoose.ResetTracking()
    end
    VE.EventBus:Trigger("VE_ACTIVITY_LOG_UPDATED", { timestamp = nil })

    if houseInfo.houseGUID then
        -- Batch: clear tasks + set GUID in one dispatch cycle
        VE.Store:Dispatch("SET_TASKS", { tasks = {} })  -- clears old tasks
        VE.Store.suppressNotify = true  -- suppress VE_STATE_CHANGED for this one
        VE.Store:Dispatch("SET_HOUSE_GUID", { houseGUID = houseInfo.houseGUID })
        VE.Store.suppressNotify = nil
        if C_Housing and C_Housing.GetCurrentHouseLevelFavor then
            pcall(C_Housing.GetCurrentHouseLevelFavor, houseInfo.houseGUID)
        end
    end

    self:_RequestNeighborhoodData(houseInfo.neighborhoodGUID)
    if debug then
        print("|cFF2aa198[VE Tracker]|r Called SetViewingNeighborhood and RequestNeighborhoodInitiativeInfo (not active yet)")
    end

    -- Auto-activate: also set as active endeavor if config enabled
    if VE.Store:GetState().config.autoActivateOnSelect then
        self:SetAsActiveEndeavor()
    end
end

function Tracker:SetAsActiveEndeavor()
    if not self.selectedHouseIndex or not self.houseList then return end
    local houseInfo = self.houseList[self.selectedHouseIndex]
    if not houseInfo or not houseInfo.neighborhoodGUID then return end

    local debug = VE.Store:GetState().config.debug

    if C_NeighborhoodInitiative and C_NeighborhoodInitiative.SetActiveNeighborhood then
        C_NeighborhoodInitiative.SetActiveNeighborhood(houseInfo.neighborhoodGUID)

        if debug then
            print("|cFF2aa198[VE Tracker]|r Set active neighborhood: " .. tostring(houseInfo.neighborhoodGUID))
        end

        self.currentHouseGUID = houseInfo.houseGUID
        self.activityLogLoaded = false
        self:_WipeXPIndexes()

        -- SetActiveNeighborhood is async (0.5-2s settle). During that window
        -- C_NeighborhoodInitiative.GetActiveNeighborhood() still returns the OLD
        -- value, so FetchEndeavorData would mistake the new house for "viewing
        -- non-active" and clear data. Track the pending GUID and treat it as
        -- effectively-active until the API catches up.
        self._pendingActiveGUID = houseInfo.neighborhoodGUID

        print("|cFF2aa198[VE]|r Active Endeavor switched to |cFFffd700" .. GetHouseDisplayName(houseInfo) .. "|r. |cFFcb4b16All task progress/XP now applies to this house.|r")

        self:UpdateFetchStatus("fetching")
        VE.EventBus:Trigger("VE_ACTIVITY_LOG_UPDATED", { timestamp = nil })
        VE.EventBus:Trigger("VE_ACTIVE_NEIGHBORHOOD_CHANGED")

        -- Delay the requests: SetActiveNeighborhood is async (0.5-2s stale window).
        -- The responses fire NEIGHBORHOOD_INITIATIVE_UPDATED + INITIATIVE_ACTIVITY_LOG_UPDATED
        -- which our event handlers turn into QueueDataRefresh + RefreshActivityLogCache.
        if self._setActiveRequestTimer then self._setActiveRequestTimer:Cancel() end
        self._setActiveRequestTimer = C_Timer.NewTimer(1.5, function()
            self._setActiveRequestTimer = nil
            C_NeighborhoodInitiative.RequestNeighborhoodInitiativeInfo()
            self:RequestActivityLog()
        end)
    end
end

function Tracker:GetHouseList()
    return self.houseList or {}
end

function Tracker:GetSelectedHouseIndex()
    return self.selectedHouseIndex or 1
end

-- ============================================================================
-- HOUSING (folded in from VE.HousingTracker in v1.16)
-- ============================================================================

-- Request house info. levelOnly=true skips the house list and just refreshes XP
-- for the cached house GUID (used after task completion to avoid stale-list races).
-- Any housing request while Blizzard_HousingDashboard is unloaded warms the
-- client house cache; the dashboard's own eventual first load then replies
-- synchronously mid-OnLoad and its House Info pane strands blank for the
-- session (proven 2026-08-25 -- VE stranded it even with the list call gated,
-- via the favor path). Robust invariant: LOAD THE DASHBOARD FIRST. A
-- Blizzard-signed addon runs secure regardless of the load caller -- no taint.
function Tracker:EnsureBlizzardDashboard()
    if not C_AddOns.IsAddOnLoaded("Blizzard_HousingDashboard") then
        C_AddOns.LoadAddOn("Blizzard_HousingDashboard")
    end
end

function Tracker:RequestHouseInfo(levelOnly)
    local state = VE.Store:GetState()
    self:EnsureBlizzardDashboard()
    if not levelOnly and C_Housing and C_Housing.GetPlayerOwnedHouses then
        -- Full refresh: PLAYER_HOUSE_LIST_UPDATED handler requests favor for the selected house
        pcall(C_Housing.GetPlayerOwnedHouses)
    elseif state.housing.houseGUID and C_Housing and C_Housing.GetCurrentHouseLevelFavor then
        if state.config.debug then
            print("|cFF2aa198[VE Tracker]|r Requesting fresh level for cached houseGUID")
        end
        pcall(C_Housing.GetCurrentHouseLevelFavor, state.housing.houseGUID)
    end
end

-- Process HOUSE_LEVEL_FAVOR_UPDATED: dedup, look up max level + next-level XP, dispatch to Store.
function Tracker:_OnHouseLevelFavorUpdated(houseLevelFavor)
    local debug = VE.Store:GetState().config.debug
    local state = VE.Store:GetState()

    if not houseLevelFavor or type(houseLevelFavor) ~= "table" then
        VE.Store:Dispatch("SET_HOUSE_LEVEL", { level = 0, xp = 0, xpForNextLevel = 0 })
        return
    end
    -- Payload table itself may be secret-restricted in housing interior;
    -- bail before indexing so we don't crash on field access.
    if not canaccesstable(houseLevelFavor) then return end

    local guid = houseLevelFavor.houseGUID
    local currentLevel = houseLevelFavor.houseLevel
    local currentXP = houseLevelFavor.houseFavor

    -- Bail if EITHER field is secret -- we'd taint _lastFavorByGUID forever
    -- if we cached a secret xp/level, and downstream arithmetic would crash.
    if issecretvalue(currentLevel) or issecretvalue(currentXP) then return end
    currentLevel = currentLevel or 1
    currentXP = currentXP or 0

    -- Skip updates for houses we're not tracking
    if guid and state.housing.houseGUID and guid ~= state.housing.houseGUID then return end

    -- Skip redundant updates (same favor+level per GUID)
    local key = guid or "unknown"
    local last = self._lastFavorByGUID[key]
    if last and last.xp == currentXP and last.level == currentLevel then return end
    self._lastFavorByGUID[key] = { xp = currentXP, level = currentLevel }

    if debug then
        print(string.format("|cFF2aa198[VE Tracker]|r Favor: %s level=%d favor=%d", tostring(guid), currentLevel, currentXP))
        local prevXP = state.housing.xp or 0
        if type(prevXP) == "number" and not issecretvalue(prevXP) and currentXP ~= prevXP then
            print(string.format("|cFF2aa198[VE Tracker]|r XP changed: %d -> %d (delta: %+d)", prevXP, currentXP, currentXP - prevXP))
        end
    end

    -- Get max level. Fallback matches current season cap (Midnight S2 = 9), and
    -- now only covers the API being absent, not it erroring: both calls below are
    -- SYNCHRONOUS value getters (MCP-verified, "safe to call inline"), so they are
    -- read strictly. The pcalls they replaced caught nothing and would have turned
    -- a rename into a silent fallback -- the 12.1 IsInsideOwnHouse lesson.
    local maxLevel = 9
    if C_Housing and C_Housing.GetMaxHouseLevel then
        maxLevel = C_Housing.GetMaxHouseLevel() or maxLevel  -- exception(boundary): cold-cache nil keeps the season cap
    end

    local xpForNextLevel = 0
    if currentLevel < maxLevel and C_Housing and C_Housing.GetHouseLevelFavorForLevel then
        xpForNextLevel = C_Housing.GetHouseLevelFavorForLevel(currentLevel + 1) or 0  -- exception(boundary): cold-cache nil
    end

    VE.Store:Dispatch("SET_HOUSE_LEVEL", {
        level = currentLevel,
        xp = currentXP,
        xpForNextLevel = xpForNextLevel,
        maxLevel = maxLevel,
    })
end

-- Pull current coupon balance + snapshot for cross-alt tooltip.
function Tracker:UpdateCoupons()
    if not C_CurrencyInfo or not C_CurrencyInfo.GetCurrencyInfo then return end
    local couponID = (VE.Constants and VE.Constants.CURRENCY_IDS and VE.Constants.CURRENCY_IDS.COMMUNITY_COUPONS) or 3363
    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(couponID)
    if not currencyInfo then return end

    VE.Store:Dispatch("SET_COUPONS", {
        count = currencyInfo.quantity or 0,
        iconID = currencyInfo.iconFileID,
    })

    -- Snapshot this character's coupon balance for the cross-alt tooltip.
    VE_DB = VE_DB or {}
    VE_DB.characterCoupons = VE_DB.characterCoupons or {}
    local _, classFile = UnitClass("player")
    local realm = GetNormalizedRealmName() or (GetRealmName() and GetRealmName():gsub("%s", "")) or ""
    VE_DB.characterCoupons[VE:GetCharacterKey()] = {
        name     = UnitName("player"),
        realm    = realm,
        class    = classFile,
        faction  = UnitFactionGroup("player"),
        coupons  = currencyInfo.quantity or 0,
        lastSeen = time(),
    }
end

-- Correlate a CURRENCY_DISPLAY_UPDATE coupon gain with the most recent task completion
-- (the activity log lags behind the currency update, so we use the in-memory queue).
function Tracker:_TrackCouponGain(amount, source)
    VE_DB = VE_DB or {}
    VE_DB.couponGains = VE_DB.couponGains or {}

    local now = time()
    local charName = UnitName("player")
    local correlatedTask, correlatedTaskID
    local debug = VE.Store:GetState().config.debug

    if VE._pendingTaskCompletions then
        -- Purge expired entries in reverse so removals don't shift indexes.
        -- Append-side prune is the one that bounds the queue; this catches
        -- entries that expired between the last append and this gain.
        for i = #VE._pendingTaskCompletions, 1, -1 do
            if now - (VE._pendingTaskCompletions[i].timestamp or 0) > VE.Constants.PENDING_COMPLETION_TTL then
                table.remove(VE._pendingTaskCompletions, i)
            end
        end
        for i, pending in ipairs(VE._pendingTaskCompletions) do
            if not pending.taskName then break end -- defensive: nil taskName would error on table index
            correlatedTask = pending.taskName
            correlatedTaskID = pending.taskID
            table.remove(VE._pendingTaskCompletions, i)
            break
        end
    end

    -- Only store when correlated (avoids logging currency transfers, weekly rewards, etc.)
    if correlatedTask then
        table.insert(VE_DB.couponGains, {
            amount = amount, source = source, timestamp = now,
            character = charName, taskName = correlatedTask, taskID = correlatedTaskID,
        })
        while #VE_DB.couponGains > 100 do
            table.remove(VE_DB.couponGains, 1)
        end
    end

    VE.EventBus:Trigger("VE_COUPON_GAINED", { amount = amount, taskName = correlatedTask })

    if debug then
        local taskStr = correlatedTask and (" -> " .. correlatedTask) or ""
        print(string.format("|cFF2aa198[VE]|r Coupon gain: +%d%s", amount, taskStr))
    end
end
