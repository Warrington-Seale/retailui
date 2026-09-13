-- ============================================================================
-- Vamoose's Endeavors - Init
-- Addon initialization and slash commands
-- ============================================================================

VE = VE or {}
VE.frame = CreateFrame("Frame")
VE.frame:RegisterEvent("ADDON_LOADED")
VE.frame:RegisterEvent("PLAYER_LOGIN")
VE.frame:RegisterEvent("PLAYER_LOGOUT")

function VE:OnInitialize()
    -- Initialize SavedVariables
    VE_DB = VE_DB or {}

    -- Tier 2 sanity sweep: schema migration + config type validation.
    -- MUST run before Store:LoadFromSavedVariables so Store reads healed data.
    if VE.Health and VE.Health.RunSchemaSweep then
        VE.Health:RunSchemaSweep()
    end

    -- Load persisted state
    VE.Store:LoadFromSavedVariables()

    -- Apply saved theme
    VE.Constants:ApplyTheme()

    -- Initialize Theme Engine (must be after theme is applied)
    if VE.Theme and VE.Theme.Initialize then
        VE.Theme:Initialize()
    end

    VE._version = C_AddOns.GetAddOnMetadata("VamoosesEndeavors", "Version") or "Dev"
end

function VE:OnEnable()
    -- Track session start time for coupon gain tracking
    VE._sessionStart = time()

    -- Restore this character's cached housing values before the UI is built, so
    -- the header opens with real numbers instead of zeros while the live house
    -- data is still in flight. Must be here, not OnInitialize -- the cache is
    -- keyed by character and name/realm aren't populated at ADDON_LOADED.
    VE.Store:RestoreHousing()

    -- Trigger addon enabled event
    VE.EventBus:Trigger("VE_ADDON_ENABLED")

    -- Initialize UI
    if VE.CreateMainWindow then
        VE:CreateMainWindow()
    end

    -- Initialize Endeavor Tracker
    if VE.EndeavorTracker and VE.EndeavorTracker.Initialize then
        VE.EndeavorTracker:Initialize()
    end

    -- Initialize Alt Sharing
    if VE.AltSharing and VE.AltSharing.Initialize then
        VE.AltSharing:Initialize()
    end

    -- Version message (debug only; silent by default per p3lim feedback)
    if VE.Store:GetState().config.debug then
        print("|cFF2aa198[VE]|r Vamoose's Endeavors v" .. VE._version .. ". Type /ve to open.")
    end

    -- Register slash commands (inside OnEnable to avoid file-scope taint chain)
    VE:InitSlashCommands()

    -- Initialize Minimap Button
    if VE.Minimap and VE.Minimap.Initialize then
        VE.Minimap:Initialize()
    end

    -- Auto-show if pinned (after all modules initialized)
    if VE.Store:GetState().config.pinWindow and VE.MainFrame then
        VE.MainFrame:Show()
    end
end

-- Event Handler
VE.frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == "VamoosesEndeavors" then
            VE:OnInitialize()
        end
    elseif event == "PLAYER_LOGIN" then
        VE:OnEnable()
        self:UnregisterEvent("PLAYER_LOGIN")
    elseif event == "PLAYER_LOGOUT" then
        VE.Store:Flush()
    end
end)

-- The Housing Dashboard button was REMOVED 2026-08-20. It parented a NAMED
-- global frame (VE_DashboardButton) into Blizzard's InitiativesFrame at
-- ADDON_LOADED -- before Blizzard_HousingDashboard runs its own deferred
-- OneTimeInit, since that addon is LoadOnDemand. Two taint vectors (named global
-- + an addon frame in a Blizzard child list during init), and players were
-- reporting a BLANK housing dashboard, which is what a silent taint bail looks
-- like. VE is reachable from the minimap button and /ve; the shortcut was not
-- worth being a suspect we could not rule out.
--
-- If it is ever wanted back: create it unnamed, and on first dashboard OPEN
-- rather than ADDON_LOADED, so VE is never in the frame during Blizzard's init.

-- Toggle main window (alias for minimap/compartment)
function VE:Toggle()
    self:ToggleWindow()
end

-- Toggle main window
function VE:ToggleWindow()
    if not self.MainFrame then
        self:CreateMainWindow()
    end
    if self.MainFrame:IsShown() then
        self.MainFrame:Hide()
        if self._healthTimer then self._healthTimer:Cancel(); self._healthTimer = nil end
    else
        self.MainFrame:Show()
        -- Ask for the house list HERE, not at login. See the note in
        -- EndeavorTracker's PLAYER_ENTERING_WORLD handler: requesting it at login
        -- primed Blizzard's dashboard dropdown cache before its content pane had
        -- registered, and left that pane permanently blank. Opening this window is
        -- a deliberate user action, so the request belongs here.
        if VE.EndeavorTracker and VE.EndeavorTracker.RequestHouseInfo then
            VE.EndeavorTracker:RequestHouseInfo()
        end
        self:RefreshUI()
        -- Tier 1 health check: 5s after panel open. Cancelled on close.
        if self._healthTimer then self._healthTimer:Cancel() end
        self._healthTimer = C_Timer.NewTimer(5, function()
            self._healthTimer = nil
            if VE.Health and VE.Health.Run then VE.Health:Run("panel-open") end
        end)
    end
end

-- Refresh UI
function VE:RefreshUI()
    local frame = self.MainFrame
    if not frame or not frame:IsShown() then return end

    -- Refresh housing display (coupons + house level)
    if frame.UpdateHousingDisplay then
        frame:UpdateHousingDisplay()
    end

    -- Refresh header (always visible)
    if frame.UpdateHeader then
        frame:UpdateHeader()
    end

    -- Refresh the endeavors view (task list only)
    if frame.endeavorsTab and frame.endeavorsTab.Update then
        frame.endeavorsTab:Update()
    end
end

-- Rebuild UI after theme change

-- Endeavor countdown span, largest whole unit only ("3 Days", "1 Day",
-- "18 Hours", "42 Minutes"). Returns nil when nothing is left to count.
--
-- Whole days alone were not enough: the header floored the remaining seconds to
-- days, so the last stretch of an endeavor read "1 Days Remaining" for a full
-- day and then blanked entirely once under 24 hours -- exactly when the
-- countdown matters most. Callers append their own suffix.
function VE:FormatDuration(seconds)
    if not seconds or seconds <= 0 then return nil end
    if seconds >= 86400 then
        local days = math.floor(seconds / 86400)
        return days .. (days == 1 and " Day" or " Days")
    end
    if seconds >= 3600 then
        local hours = math.floor(seconds / 3600)
        return hours .. (hours == 1 and " Hour" or " Hours")
    end
    if seconds >= 60 then
        local minutes = math.floor(seconds / 60)
        return minutes .. (minutes == 1 and " Minute" or " Minutes")
    end
    return "Under a Minute"
end

-- Get current character key
function VE:GetCharacterKey()
    local name = UnitName("player")
    local realm = GetNormalizedRealmName() or GetRealmName():gsub("%s", "")
    return name .. "-" .. realm
end

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

function VE:InitSlashCommands()
SLASH_VE1 = "/ve"
SLASH_VE2 = "/endeavors"
SlashCmdList["VE"] = function(msg)
    local command = msg:lower():match("^(%S*)")

    if command == "" or command == "show" then
        VE:ToggleWindow()
    elseif command == "debug" then
        local state = VE.Store:GetState()
        VE.Store:Dispatch("SET_CONFIG", { key = "debug", value = not state.config.debug })
        print("|cFF2aa198[VE]|r Debug mode:", state.config.debug and "OFF" or "ON")
    elseif command == "reset" then
        if VE.Health and VE.Health.NuclearReset then
            VE.Health:NuclearReset()
        end
    elseif command == "claimed" then
        -- Manual mark-claimed when our auto-detection missed (e.g. claimed
        -- before this version was installed). Marks the active house's
        -- chest as claimed for the current cycle.
        local ok, info = VE.EndeavorTracker:MarkActiveChestClaimed()
        if ok then
            print(("|cFF859900[VE]|r Marked chest as claimed for the active house, cycle %s."):format(tostring(info)))
        elseif info == "already-claimed" then
            print("|cFFb58900[VE]|r That chest is already marked claimed. Use |cFFffd700/ve unclaimed|r to clear it.")
        else
            print("|cFFdc322f[VE]|r No active house initiative loaded; can't mark claimed.")
        end
    elseif command == "unclaimed" then
        local chest = VE.EndeavorTracker:GetActiveChest()
        local key = chest and chest.neighborhoodGUID
        if key and VE_DB and VE_DB.chestClaims and VE_DB.chestClaims[key] then
            -- Cancel an in-flight post-claim sample timer so its closure
            -- doesn't write back into the record we're about to clear.
            if VE.EndeavorTracker._chestSampleTimer then
                VE.EndeavorTracker._chestSampleTimer:Cancel()
                VE.EndeavorTracker._chestSampleTimer = nil
            end
            VE_DB.chestClaims[key] = nil
            -- Clear cached chest snapshots so the next ProcessInitiativeInfo
            -- rebuilds with claimed=false.
            VE.EndeavorTracker._chest = nil
            if VE.EndeavorTracker._chestByHouse then
                VE.EndeavorTracker._chestByHouse[key] = nil
            end
            print("|cFFb58900[VE]|r Cleared chest claim record for the active house. Run /ve status to refresh.")
        else
            print("|cFFdc322f[VE]|r No claim record found for the active house.")
        end
    elseif command == "armchest" then
        local secs = tonumber(msg:match("^%S+%s+(%d+)")) or 120
        VE.EndeavorTracker:ArmChestObservation(secs)
    elseif command == "disarmchest" then
        VE.EndeavorTracker:DisarmChestObservation("manual")
    elseif command == "dumpchest" then
        VE.EndeavorTracker:DumpChestObservation()
    elseif command == "status" or command == "chest" or command == "progress" then
        local activeInfo, activeGUID = VE.EndeavorTracker:GetActiveInfo()
        local viewedState = VE.Store:GetState().endeavor or {}
        -- Both shapes carry an absolute end stamp, under different names: the
        -- per-house snapshot calls it endTime, the store branch seasonEndTime.
        local source, e, endTime
        if activeInfo then
            source = "active house"; e = activeInfo; endTime = activeInfo.endTime or 0
        else
            source = activeGUID and "viewed house (active not yet processed)" or "viewed house (no active set)"
            e = viewedState
            endTime = viewedState.seasonEndTime or 0
        end
        local cur, max = e.currentProgress or 0, e.maxProgress or 0
        local pct = max > 0 and (cur / max * 100) or 0
        local chest = VE.EndeavorTracker:GetActiveChest() or {}
        local projected, fromTasks, chestBonus = VE.EndeavorTracker:GetProjectedHouseXP()
        local span = endTime > 0 and VE:FormatDuration(endTime - time()) or nil
        print(("|cFF2aa198[VE]|r %s -- %.1f / %d  (%.1f%%)  -- %s left  |cFF93a1a1(%s)|r"):format(
            (e.seasonName and e.seasonName ~= "") and e.seasonName or "Endeavor",
            cur, max, pct,
            span or "unknown time",
            source))
        print(("|cFF2aa198[VE]|r Your contribution: |cFFffd700%.1f|r"):format(VE.EndeavorTracker:GetPlayerContribution()))
        -- chest XP is ADDITIVE: lands directly on house favor on claim, not via
        -- the available bucket (verified Vamoose-Khaz'goroth, cycle 7, 2026-04-29:
        -- availableXP 3232->3232 across the +250 favor delta).
        if chestBonus > 0 then
            print(("|cFF2aa198[VE]|r House XP -- tasks: |cFF2aa198%d|r in available bucket  +  chest: |cFFe5c040%d|r direct to favor  =  |cFFffd700%d|r cycle total"):format(
                fromTasks, chestBonus, projected))
        else
            print(("|cFF2aa198[VE]|r House XP -- tasks: |cFF2aa198%d|r in available bucket  (chest claimed/unavailable)"):format(fromTasks))
        end
        local chestStatus
        if chest.claimed then
            chestStatus = "|cFF859900claimed|r"
        elseif chest.available then
            chestStatus = "|cFFb58900READY -- click the chest in your neighborhood|r"
        else
            chestStatus = ("|cFF93a1a1locked (need %.0f more progress)|r"):format(math.max(0, max - cur))
        end
        local rewardLine = ""
        if chest.xp and chest.xp > 0 then
            rewardLine = ("  reward: |cFFffd700%d XP|r"):format(chest.xp)
            if chest.currencies then
                local couponID = VE.Constants.CURRENCY_IDS.COMMUNITY_COUPONS
                for _, c in ipairs(chest.currencies) do
                    if c.currencyID == couponID and c.amount > 0 then
                        rewardLine = rewardLine .. (" + |cFFffd700%d coupons|r"):format(c.amount)
                        break
                    end
                end
            end
        end
        print(("|cFF2aa198[VE]|r Chest: %s%s"):format(chestStatus, rewardLine))

        -- Per-house claim history (account-wide, persists across cycles)
        local houseKey = chest.neighborhoodGUID
        local rec = houseKey and VE_DB and VE_DB.chestClaims and VE_DB.chestClaims[houseKey]
        if rec and rec.count and rec.count > 0 then
            local agoSec = rec.lastClaimTime and (time() - rec.lastClaimTime) or 0
            local ago
            if agoSec < 3600 then ago = math.floor(agoSec / 60) .. "m ago"
            elseif agoSec < 86400 then ago = math.floor(agoSec / 3600) .. "h ago"
            else ago = math.floor(agoSec / 86400) .. "d ago" end
            local byStr = rec.lastClaimedBy and ("  by |cFF93a1a1" .. rec.lastClaimedBy .. "|r") or ""
            print(("|cFF2aa198[VE]|r Lifetime claims on this house: |cFFffd700%d|r  (last: %s, cycle %s)%s"):format(
                rec.count, ago, tostring(rec.lastCycleID or "?"), byStr))
        else
            print("|cFF2aa198[VE]|r No chest claims recorded on this house yet (tracking starts now).")
        end
    else
        print("|cFF2aa198[VE]|r Commands: |cFFffd700/ve|r (toggle window), |cFFffd700/ve status|r (progress + chest), |cFFffd700/ve claimed|r (mark active chest as claimed), |cFFffd700/ve unclaimed|r (clear claim), |cFFffd700/ve armchest [secs]|r (raw chest-claim capture, default 120s), |cFFffd700/ve disarmchest|r, |cFFffd700/ve dumpchest|r (print captured events), |cFFffd700/ve debug|r (toggle debug mode), |cFFffd700/ve reset|r (factory reset, asks for confirmation)")
    end
end
end

