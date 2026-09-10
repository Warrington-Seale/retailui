-- DelveSpeedTracker: event handling, DB initialization, slash commands.
local ADDON_NAME, namespace = ...
local DST = namespace.DST
local AF = namespace.AF
local CopyTableSafe = namespace.CopyTableSafe
local DeepMergeDefaults = namespace.DeepMergeDefaults
local StopRippleAndUnparentMapHighlight = namespace.StopRippleAndUnparentMapHighlight

local LAYOUT = DST.LAYOUT

local function ApplyDBDefaults()
    local defaults = DST.DB_DEFAULTS
    if not DelveSpeedTrackerDB then
        DelveSpeedTrackerDB = CopyTableSafe(defaults)
    else
        DeepMergeDefaults(DelveSpeedTrackerDB, defaults)
    end
    if DelveSpeedTrackerDB.layout and type(DelveSpeedTrackerDB.layout) == "table" then
        for k, v in pairs(DelveSpeedTrackerDB.layout) do
            if DST.LAYOUT_DEFAULTS[k] ~= nil then
                DST.LAYOUT[k] = v
            end
        end
        DST:RecomputeLayout()
        if AF.SetAddonFont and LAYOUT.FONT_KEY and LAYOUT.FONT_KEY ~= "" then
            AF.SetAddonFont("DelveSpeedTracker", LAYOUT.FONT_KEY)
        end
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        ApplyDBDefaults()
        DST:CreateUI()
        DST:CreateMinimapButton()

        SLASH_DELVESPEEDTRACKER1 = "/dst"
        SlashCmdList["DELVESPEEDTRACKER"] = function()
            if DST.Frame then
                if DST.Frame:IsShown() then DST.Frame:Hide() else DST.Frame:Show() end
            end
        end

        SLASH_DELVESPEEDTRACKERDEBUGPOI1 = "/dstdebugpoi"
        SlashCmdList["DELVESPEEDTRACKERDEBUGPOI"] = function(msg)
            local m = (msg or ""):lower()
            if m:find("trace", 1, true) then
                if DST.DebugTraceLocalization then
                    DST:DebugTraceLocalization()
                end
            elseif m:find("full", 1, true) or m:find("verbose", 1, true) then
                DST:DebugCheckPOIAndAchievements(true)
            else
                DST:DebugCheckPOIAndAchievements(false)
            end
        end

        SLASH_DELVESPEEDTRACKERDEBUGTRACE1 = "/dstdebugtrace"
        SlashCmdList["DELVESPEEDTRACKERDEBUGTRACE"] = function()
            if DST.DebugTraceLocalization then
                DST:DebugTraceLocalization()
            end
        end

        SLASH_DELVESPEEDTRACKERDEBUGLAYOUT1 = "/dstdebuglayout"
        SlashCmdList["DELVESPEEDTRACKERDEBUGLAYOUT"] = function()
            if DST.ToggleLayoutDebugOverlay then
                DST:ToggleLayoutDebugOverlay()
            end
        end

        -- Warm delve variant cache while map is usually closed (avoids C_UIWidgetManager during map hover).
        if C_Timer and C_Timer.After then
            C_Timer.After(0, function()
                if DST and DST.GetCurrentDelveVariants then
                    DST:GetCurrentDelveVariants()
                end
            end)
        end
        if DelveSpeedTrackerDB.windowShown then
            DST.Frame:Show()
            -- UpdateUI runs at end of CreateUI while the frame is still hidden; reposition-after-resize
            -- is skipped until visible. Refresh once the frame is shown so size/anchor use valid coords.
            if C_Timer and C_Timer.After then
                C_Timer.After(0, function()
                    if DST and DST.UpdateUI then DST:UpdateUI() end
                end)
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        namespace.achievementVariantMap = nil
        namespace.achievementDelveNameMap = nil
        namespace.achievementDelveNameMapReverse = nil
        namespace.cachedActiveVariants = nil
        -- Warm variant cache while map is usually closed (avoids widget API during map POI tooltips).
        if C_Timer and C_Timer.After then
            C_Timer.After(0, function()
                if DST and DST.GetCurrentDelveVariants then
                    DST:GetCurrentDelveVariants()
                end
            end)
        end
        if DST.Frame then
            C_Timer.After(1, function() DST:UpdateUI() end)
        end
        if AF.Libs.LibDBIcon and AF.Libs.LibDBIcon.Show and AF.Libs.LibDBIcon:IsRegistered("DelveSpeedTracker") then
            AF.Libs.LibDBIcon:Show("DelveSpeedTracker")
        end
    elseif event == "PLAYER_REGEN_DISABLED" then
        if namespace.HideAddonTooltip then namespace.HideAddonTooltip() end
        StopRippleAndUnparentMapHighlight()
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- UpdateUI is skipped while InCombat; refresh delve cache once combat ends.
        if DST and DST.Frame and DST.Frame:IsShown() and DST.UpdateUI then
            DST:UpdateUI()
        elseif DST and DST.GetCurrentDelveVariants then
            DST:GetCurrentDelveVariants()
        end
    end
end)
