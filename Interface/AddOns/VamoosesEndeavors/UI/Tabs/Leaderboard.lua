-- ============================================================================
-- Vamoose's Endeavors - Leaderboard Tab
-- Shows neighborhood contribution rankings
-- ============================================================================

VE = VE or {}
VE.UI = VE.UI or {}
VE.UI.Tabs = VE.UI.Tabs or {}

-- Helper to get current theme colors
local function GetColors()
    return VE.Constants:GetThemeColors()
end

-- My characters tracking (highlights all player's alts in leaderboard)
local function GetMyCharacters()
    VE_DB = VE_DB or {}
    VE_DB.myCharacters = VE_DB.myCharacters or {}
    return VE_DB.myCharacters
end

local function RegisterCurrentCharacter()
    local charName = UnitName("player")
    if charName then
        local myChars = GetMyCharacters()
        myChars[charName] = true
    end
end

local function IsMyCharacter(name)
    local myChars = GetMyCharacters()
    return myChars[name] == true
end

function VE.UI.Tabs:CreateLeaderboard(parent)
    local UI = VE.Constants.UI

    -- Register current character for multi-char highlighting
    RegisterCurrentCharacter()

    local container = CreateFrame("Frame", nil, parent)
    container:SetAllPoints()

    local padding = 0  -- Container edge padding (0 for full-bleed atlas backgrounds)

    -- ========================================================================
    -- LEADERBOARD HEADER (with contribution pip icon)
    -- ========================================================================

    local header = VE.UI:CreateSectionHeader(container, "Initiative Contribution")
    header:SetPoint("TOPLEFT", 0, UI.sectionHeaderYOffset)
    header:SetPoint("TOPRIGHT", 0, UI.sectionHeaderYOffset)

    -- Refresh button (left side of header)
    local refreshBtn = CreateFrame("Button", nil, header)
    refreshBtn:SetSize(16, 16)
    refreshBtn:SetPoint("LEFT", header, "LEFT", 8, 0)

    local refreshIcon = refreshBtn:CreateTexture(nil, "ARTWORK")
    refreshIcon:SetAllPoints()
    refreshIcon:SetAtlas("UI-RefreshButton")
    refreshIcon:SetAlpha(0.6)
    refreshBtn.icon = refreshIcon

    -- Timestamp (right of refresh button)
    local refreshColors = GetColors()
    local lastUpdateText = header:CreateFontString(nil, "OVERLAY")
    lastUpdateText:SetPoint("LEFT", refreshBtn, "RIGHT", 4, 0)
    VE.Theme.ApplyFont(lastUpdateText, refreshColors, "tiny")
    lastUpdateText:SetText("--:--")
    lastUpdateText:SetTextColor(refreshColors.text_dim.r, refreshColors.text_dim.g, refreshColors.text_dim.b, 0.7)
    container.lastUpdateText = lastUpdateText

    refreshBtn:SetScript("OnEnter", function(self)
        refreshIcon:SetAlpha(1.0)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("Refresh Activity Log", 1, 1, 1)
        local stale = VE.EndeavorTracker and VE.EndeavorTracker.activityLogStale
        if stale then
            GameTooltip:AddLine("New data available", 0.2, 0.8, 0.2)
        else
            GameTooltip:AddLine("Click to fetch latest data", 0.7, 0.7, 0.7)
        end
        GameTooltip:Show()
    end)

    refreshBtn:SetScript("OnLeave", function()
        refreshIcon:SetAlpha(0.6)
        GameTooltip_Hide()
    end)

    refreshBtn:SetScript("OnClick", function()
        if VE.EndeavorTracker then
            VE.EndeavorTracker:RefreshActivityLogCache()
        end
    end)

    -- Update timestamp when activity log refreshes
    VE.EventBus:Register("VE_ACTIVITY_LOG_UPDATED", function()
        lastUpdateText:SetText(date("%H:%M"))
    end)

    -- Grouping toggle button (top-right of header)
    local groupBtn = CreateFrame("Button", nil, header, "BackdropTemplate")
    groupBtn:SetSize(75, 16)
    groupBtn:SetPoint("RIGHT", header, "RIGHT", -12, 0)
    groupBtn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = nil,
    })
    local groupColors = GetColors()
    groupBtn:SetBackdropColor(groupColors.panel.r, groupColors.panel.g, groupColors.panel.b, 0.5)

    local groupLabel = groupBtn:CreateFontString(nil, "OVERLAY")
    groupLabel:SetPoint("LEFT", 6, 0)
    VE.Theme.ApplyFont(groupLabel, groupColors, "small")
    groupLabel:SetText("Grouping")
    groupLabel:SetTextColor(groupColors.text_dim.r, groupColors.text_dim.g, groupColors.text_dim.b)
    groupBtn.label = groupLabel

    local groupIcon = groupBtn:CreateTexture(nil, "ARTWORK")
    groupIcon:SetSize(14, 14)
    groupIcon:SetPoint("LEFT", groupLabel, "RIGHT", 0, 0)
    groupIcon:SetAtlas("housefinder_neighborhood-friends-icon")
    groupBtn.icon = groupIcon

    local function UpdateGroupBtnState()
        local state = VE.Store:GetState()
        local mode = state.altSharing.groupingMode or "individual"
        local colors = GetColors()
        if mode == "byMain" then
            groupBtn:SetBackdropColor(colors.accent.r, colors.accent.g, colors.accent.b, 0.4)
            groupIcon:SetAlpha(1.0)
            groupLabel:SetTextColor(colors.accent.r, colors.accent.g, colors.accent.b)
        else
            groupBtn:SetBackdropColor(colors.panel.r, colors.panel.g, colors.panel.b, 0.5)
            groupIcon:SetAlpha(0.5)
            groupLabel:SetTextColor(colors.text_dim.r, colors.text_dim.g, colors.text_dim.b)
        end
    end
    UpdateGroupBtnState()
    container.groupBtn = groupBtn
    container.UpdateGroupBtnState = UpdateGroupBtnState

    groupBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        local state = VE.Store:GetState()
        local mode = state.altSharing.groupingMode or "individual"
        if mode == "individual" then
            GameTooltip:AddLine("Group by Player", 1, 1, 1)
            GameTooltip:AddLine("Click to combine alt contributions", 0.7, 0.7, 0.7)
        else
            GameTooltip:AddLine("Individual View", 1, 1, 1)
            GameTooltip:AddLine("Click to show individual characters", 0.7, 0.7, 0.7)
        end
        GameTooltip:Show()
    end)

    groupBtn:SetScript("OnLeave", GameTooltip_Hide)

    groupBtn:SetScript("OnClick", function()
        local state = VE.Store:GetState()
        local current = state.altSharing.groupingMode or "individual"
        local newMode = current == "individual" and "byMain" or "individual"
        VE.Store:Dispatch("SET_GROUPING_MODE", { mode = newMode })
        UpdateGroupBtnState()
        if state.config.debug then
            print("|cFF2aa198[VE Leaderboard]|r Grouping mode changed to:", newMode)
        end
        VE.EventBus:Trigger("VE_GROUPING_MODE_CHANGED")  -- Sync with config checkbox
        container:Update(true)  -- Force update to re-render with new grouping
    end)

    -- Export button (left of title)
    local exportBtn = CreateFrame("Button", nil, header)
    exportBtn:SetSize(14, 14)
    exportBtn:SetPoint("RIGHT", header.label, "LEFT", -4, 0)

    local exportIcon = exportBtn:CreateTexture(nil, "ARTWORK")
    exportIcon:SetAllPoints()
    exportIcon:SetAtlas("communities-icon-searchmagnifyingglass")
    exportIcon:SetVertexColor(0.85, 0.85, 0.85)
    exportBtn.icon = exportIcon

    exportBtn:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(1, 1, 1)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:SetText("Export to CSV")
        GameTooltip:AddLine("Copy leaderboard data for spreadsheets", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)

    exportBtn:SetScript("OnLeave", function(self)
        self.icon:SetVertexColor(0.85, 0.85, 0.85)
        GameTooltip_Hide()
    end)

    exportBtn:SetScript("OnClick", function()
        container:ExportCSV()
    end)

    -- CSV Export function
    function container:ExportCSV()
        local activityData = VE.EndeavorTracker and VE.EndeavorTracker:GetActivityLogData()
        if not activityData or not activityData.taskActivity then
            print("|cFFdc322f[VE]|r No activity data to export")
            return
        end

        -- Build raw contributions per character
        local rawContributions = {}
        for _, entry in ipairs(activityData.taskActivity) do
            local playerName = entry.playerName or "Unknown"
            local amt = entry.amount or 0
            rawContributions[playerName] = (rawContributions[playerName] or 0) + amt
        end
        -- Remove characters with no contribution
        for name, amt in pairs(rawContributions) do
            if amt <= 0 then rawContributions[name] = nil end
        end

        -- Get grouped data for warband associations
        local groupedContributions, groupedNames = rawContributions, nil
        if VE.AltSharing and VE.AltSharing.GroupContributions then
            groupedContributions, groupedNames = VE.AltSharing:GroupContributions(rawContributions)
        end

        -- Build sorted warband list
        local sortedWarbands = {}
        for groupKey, amt in pairs(groupedContributions) do
            local displayName = groupKey
            if groupedNames and groupedNames[groupKey] then
                local groupData = groupedNames[groupKey]
                displayName = groupData.displayName or groupKey
                if #groupData > 1 then
                    displayName = displayName .. "'s Warband"
                end
            end
            table.insert(sortedWarbands, { key = groupKey, displayName = displayName, amount = amt })
        end
        table.sort(sortedWarbands, function(a, b) return a.amount > b.amount end)

        -- Build rank lookup
        local warbandRanks = {}
        for i, wb in ipairs(sortedWarbands) do
            warbandRanks[wb.key] = i
        end

        -- Build CSV rows (one per character)
        local csvLines = { "Rank,Character,Warband Group,Character Contribution,Warband Total" }

        for charName, charAmount in pairs(rawContributions) do
            -- Find which warband this character belongs to
            local warbandKey = charName
            local warbandDisplay = charName
            local warbandTotal = charAmount
            local rank = 0

            if groupedNames then
                -- Find the warband this character belongs to
                for key, groupData in pairs(groupedNames) do
                    for _, entry in ipairs(groupData) do
                        local entryName = type(entry) == "table" and entry.name or entry
                        if entryName == charName then
                            warbandKey = key
                            warbandDisplay = groupData.displayName or key
                            if #groupData > 1 then
                                warbandDisplay = warbandDisplay .. "'s Warband (" .. #groupData .. " chars)"
                            end
                            warbandTotal = groupedContributions[key] or charAmount
                            break
                        end
                    end
                end
            end

            rank = warbandRanks[warbandKey] or 0

            -- Escape any commas in names
            local safeChar = charName:gsub(",", ";")
            local safeWarband = warbandDisplay:gsub(",", ";")

            table.insert(csvLines, string.format("%d,%s,%s,%.1f,%.1f",
                rank, safeChar, safeWarband, charAmount, warbandTotal))
        end

        -- Sort by rank numerically (header line stays at index 1)
        local header = table.remove(csvLines, 1)
        table.sort(csvLines, function(a, b)
            local rankA = tonumber(a:match("^(%d+)")) or 999
            local rankB = tonumber(b:match("^(%d+)")) or 999
            return rankA < rankB
        end)
        table.insert(csvLines, 1, header)

        local csvText = table.concat(csvLines, "\n")

        -- Show in copy dialog
        local rowCount = #csvLines - 1  -- Exclude header
        VE.UI:ShowCSVExportWindow(csvText, rowCount)
    end

    -- ========================================================================
    -- LEADERBOARD LIST (Scrollable)
    -- ========================================================================

    local listContainer = CreateFrame("Frame", nil, container, "BackdropTemplate")
    listContainer:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, 0)
    listContainer:SetPoint("BOTTOMRIGHT", -padding, padding)
    listContainer:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = nil,
    })
    container.listContainer = listContainer

    -- Atlas background support
    local ApplyListContainerColors = VE.UI:AddAtlasBackground(listContainer)
    ApplyListContainerColors()

    -- ========================================================================
    -- SUMMARY ROW (Total for all player characters)
    -- ========================================================================
    -- Parented to listContainer rather than the scroll: the list below is now a
    -- ScrollBox, which owns its own frames and must not be given children. The
    -- summary is a fixed header, so it pins above the list and stays visible
    -- while scrolling (it used to scroll away with the rows).

    local SUMMARY_HEIGHT = 26

    local summaryRow = CreateFrame("Frame", nil, listContainer, "BackdropTemplate")
    summaryRow:SetHeight(SUMMARY_HEIGHT)
    summaryRow:SetPoint("TOPLEFT", 0, -2)
    summaryRow:SetPoint("TOPRIGHT", -2, -2)
    summaryRow:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    container.summaryRow = summaryRow

    local summaryC = GetColors()
    summaryRow:SetBackdropColor(summaryC.accent.r, summaryC.accent.g, summaryC.accent.b, 0.2)
    summaryRow:SetBackdropBorderColor(summaryC.accent.r, summaryC.accent.g, summaryC.accent.b, 0.4)

    -- Sum icon
    local summaryIcon = summaryRow:CreateTexture(nil, "ARTWORK")
    summaryIcon:SetSize(16, 16)
    summaryIcon:SetPoint("LEFT", 6, 0)
    summaryIcon:SetAtlas("housefinder_neighborhood-friends-icon")
    summaryRow.icon = summaryIcon

    -- Sum label
    local summaryLabel = summaryRow:CreateFontString(nil, "OVERLAY")
    summaryLabel:SetPoint("LEFT", summaryIcon, "RIGHT", 4, 0)
    VE.Theme.ApplyFont(summaryLabel, summaryC)
    summaryLabel:SetText("My Total")
    summaryLabel:SetTextColor(summaryC.accent.r, summaryC.accent.g, summaryC.accent.b)
    summaryRow.label = summaryLabel

    -- Character count
    local summaryCount = summaryRow:CreateFontString(nil, "OVERLAY")
    summaryCount:SetPoint("LEFT", summaryLabel, "RIGHT", 6, 0)
    VE.Theme.ApplyFont(summaryCount, summaryC, "small")
    summaryCount:SetTextColor(summaryC.text_dim.r, summaryC.text_dim.g, summaryC.text_dim.b)
    summaryRow.charCount = summaryCount

    -- Total amount
    local summaryAmount = summaryRow:CreateFontString(nil, "OVERLAY")
    summaryAmount:SetPoint("RIGHT", -8, 0)
    summaryAmount:SetJustifyH("RIGHT")
    VE.Theme.ApplyFont(summaryAmount, summaryC)
    summaryAmount:SetTextColor(summaryC.endeavor.r, summaryC.endeavor.g, summaryC.endeavor.b)
    summaryRow.amount = summaryAmount

    summaryRow:Hide()

    function container:UpdateSummaryRow(contributions)
        local myChars = GetMyCharacters()
        local totalContrib = 0
        local charCount = 0

        for name, _ in pairs(myChars) do
            if contributions[name] then
                totalContrib = totalContrib + contributions[name]
                charCount = charCount + 1
            end
        end

        if charCount > 0 then
            local colors = GetColors()
            local state = VE.Store:GetState()
            local isGrouped = state.altSharing.groupingMode == "byMain"
            self.summaryRow:SetBackdropColor(colors.accent.r, colors.accent.g, colors.accent.b, 0.2)
            self.summaryRow:SetBackdropBorderColor(colors.accent.r, colors.accent.g, colors.accent.b, 0.4)
            self.summaryRow.label:SetTextColor(colors.accent.r, colors.accent.g, colors.accent.b)
            VE.Theme.ApplyFont(self.summaryRow.label, colors)
            if isGrouped then
                self.summaryRow.charCount:SetText("(Consolidated)")
            else
                self.summaryRow.charCount:SetText("(" .. charCount .. " char" .. (charCount > 1 and "s" or "") .. ")")
            end
            self.summaryRow.charCount:SetTextColor(colors.text_dim.r, colors.text_dim.g, colors.text_dim.b)
            VE.Theme.ApplyFont(self.summaryRow.charCount, colors, "small")
            self.summaryRow.amount:SetText(string.format("%.1f", totalContrib))
            self.summaryRow.amount:SetTextColor(colors.endeavor.r, colors.endeavor.g, colors.endeavor.b)
            VE.Theme.ApplyFont(self.summaryRow.amount, colors)
            self.summaryRow:Show()
            self:AnchorList(true)
            return true
        else
            self.summaryRow:Hide()
            self:AnchorList(false)
            return false
        end
    end

    -- The summary is optional, so the list's top anchor moves with it. Anchor
    -- chains through a hidden frame don't collapse -- re-anchor on show/hide.
    function container:AnchorList(hasSummary)
        self.list:ClearAllPoints()
        self.list:SetPoint("TOPLEFT", 0, hasSummary and -(SUMMARY_HEIGHT + 4) or -2)
        self.list:SetPoint("BOTTOMRIGHT", -2, 2)
    end

    -- ========================================================================
    -- LEADERBOARD ROW (pooled)
    -- ========================================================================
    -- Runs on recycled frames: children are built once behind row._built, and
    -- every field is repainted on each call. Fonts are gated on
    -- Theme.fontGeneration -- SetFont re-measures, and nothing about the font
    -- changes on a data refresh.

    local LB_ROW_HEIGHT  = 24
    local LB_ROW_SPACING = 2
    local MAX_TOOLTIP    = 5

    local function InitLeaderboardRow(row, ed)
        if not row._built then
            -- Flat background as a plain texture, NOT SetBackdrop: pooled rows
            -- are bare "Frame"s (the ScrollBox factory creates them, so there's
            -- no BackdropTemplate mixin and SetBackdrop* would be nil). A single
            -- texture is also cheaper than a backdrop for a flat fill.
            row._bg = row:CreateTexture(nil, "BACKGROUND")
            row._bg:SetAllPoints()

            -- Addon indicator (vertical green line on left edge)
            local addonIndicator = row:CreateTexture(nil, "OVERLAY")
            addonIndicator:SetPoint("TOPLEFT", 4, 0)
            addonIndicator:SetPoint("BOTTOMLEFT", 4, 0)
            addonIndicator:SetWidth(3)
            addonIndicator:SetColorTexture(0.2, 0.8, 0.2, 1)  -- Green
            row.addonIndicator = addonIndicator

            local rank = row:CreateFontString(nil, "OVERLAY")
            rank:SetPoint("LEFT", 8, 0)
            rank:SetWidth(32)
            rank:SetJustifyH("CENTER")
            row.rank = rank

            local name = row:CreateFontString(nil, "OVERLAY")
            name:SetPoint("LEFT", rank, "RIGHT", 8, 0)
            name:SetPoint("RIGHT", -80, 0)
            name:SetJustifyH("LEFT")
            row.name = name

            local amount = row:CreateFontString(nil, "OVERLAY")
            amount:SetPoint("RIGHT", -8, 0)
            amount:SetJustifyH("RIGHT")
            row.amount = amount

            -- Scripts are wired once and read the per-row fields the
            -- initializer stamps below, so recycling can't leave a stale
            -- closure pointing at the previous row's data.
            row:EnableMouse(true)
            row:SetScript("OnEnter", function(self)
                local colors = GetColors()
                if self.isCurrentPlayer then
                    self._bg:SetColorTexture(colors.accent.r, colors.accent.g, colors.accent.b, colors.accent.a * 0.25)
                else
                    self._bg:SetColorTexture(colors.text_dim.r, colors.text_dim.g, colors.text_dim.b, colors.text_dim.a * 0.3)
                end
                -- Tooltip with character names and contributions for grouped warbands
                if self.groupedChars and #self.groupedChars > 1 then
                    local total = #self.groupedChars
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:AddLine("Characters (" .. total .. "):", 1, 0.82, 0)
                    for i, entry in ipairs(self.groupedChars) do
                        if i > MAX_TOOLTIP then break end
                        local charName = type(entry) == "table" and entry.name or entry
                        local charAmount = type(entry) == "table" and entry.amount or nil
                        if charAmount then
                            GameTooltip:AddDoubleLine("  " .. charName, string.format("%.1f", charAmount), 1, 1, 1, 0.7, 0.9, 0.7)
                        else
                            GameTooltip:AddLine("  " .. charName, 1, 1, 1)
                        end
                    end
                    if total > MAX_TOOLTIP then
                        GameTooltip:AddLine("  ... and " .. (total - MAX_TOOLTIP) .. " more", 0.6, 0.6, 0.6)
                    end
                    GameTooltip:Show()
                end
            end)
            row:SetScript("OnLeave", function(self)
                local colors = GetColors()
                if self.isCurrentPlayer then
                    self._bg:SetColorTexture(colors.accent.r, colors.accent.g, colors.accent.b, colors.accent.a * 0.15)
                else
                    self._bg:SetColorTexture(colors.panel.r, colors.panel.g, colors.panel.b, colors.panel.a * 0.5)
                end
                GameTooltip:Hide()
            end)

            row._built = true
        end

        local colors = GetColors()

        if row._fontGen ~= VE.Theme.fontGeneration then
            VE.Theme.ApplyFont(row.rank, colors)
            VE.Theme.ApplyFont(row.name, colors)
            VE.Theme.ApplyFont(row.amount, colors)
            row._fontGen = VE.Theme.fontGeneration
        end

        row.rank:SetText("#" .. ed.rank)
        row.name:SetText(ed.displayName or ed.name)
        row.amount:SetText(string.format("%.1f", ed.amount))

        -- Stashed on the row for the hover scripts above.
        row.groupedChars = ed.groupedChars

        if ed.hasAddon then
            row.addonIndicator:Show()
        else
            row.addonIndicator:Hide()
        end

        -- Gold/Silver/Bronze colors for top 3, otherwise use text_dim
        if ed.rank == 1 then
            row.rank:SetTextColor(colors.gold.r, colors.gold.g, colors.gold.b)
        elseif ed.rank == 2 then
            row.rank:SetTextColor(colors.silver.r, colors.silver.g, colors.silver.b)
        elseif ed.rank == 3 then
            row.rank:SetTextColor(colors.bronze.r, colors.bronze.g, colors.bronze.b)
        else
            row.rank:SetTextColor(colors.text_dim.r, colors.text_dim.g, colors.text_dim.b)
        end

        row.amount:SetTextColor(colors.endeavor.r, colors.endeavor.g, colors.endeavor.b)

        -- Highlight player's characters (use original name for lookup)
        row.isCurrentPlayer = IsMyCharacter(ed.name)
        if row.isCurrentPlayer then
            row.name:SetTextColor(colors.accent.r, colors.accent.g, colors.accent.b, colors.accent.a)
            row._bg:SetColorTexture(colors.accent.r, colors.accent.g, colors.accent.b, colors.accent.a * 0.15)
        else
            row.name:SetTextColor(colors.text.r, colors.text.g, colors.text.b, colors.text.a)
            row._bg:SetColorTexture(colors.panel.r, colors.panel.g, colors.panel.b, colors.panel.a * 0.5)
        end
    end

    local list = VE.UI:CreateScrollBoxList(listContainer, {
        rowHeight   = LB_ROW_HEIGHT,
        spacing     = LB_ROW_SPACING,
        initializer = InitLeaderboardRow,
    })
    container.list = list
    container:AnchorList(false)

    -- ========================================================================
    -- UPDATE FUNCTION
    -- ========================================================================

    -- Loading text. Parented to listContainer, not the list: a ScrollBox owns
    -- its own frames and must not be given children.
    local loadingColors = GetColors()
    container.loadingText = listContainer:CreateFontString(nil, "OVERLAY")
    container.loadingText:SetPoint("CENTER", listContainer, "CENTER", 0, 0)
    VE.Theme.ApplyFont(container.loadingText, loadingColors)
    container.loadingText:SetText("Loading activity data...")
    container.loadingText:SetTextColor(loadingColors.text_dim.r, loadingColors.text_dim.g, loadingColors.text_dim.b)
    container.loadingText:Hide()

    function container:Update(forceUpdate)
        -- Skip rebuild if data hasn't changed (optimization)
        local currentTimestamp = VE.EndeavorTracker and VE.EndeavorTracker.activityLogLastUpdated
        if not forceUpdate and self.lastActivityUpdate and self.lastActivityUpdate == currentTimestamp then
            return
        end
        self.lastActivityUpdate = currentTimestamp

        -- Get activity log data
        local activityData = VE.EndeavorTracker:GetActivityLogData()
        if not activityData or not activityData.taskActivity then
            -- Show loading or empty state
            if not self.emptyText then
                self.emptyText = listContainer:CreateFontString(nil, "OVERLAY")
                self.emptyText:SetPoint("CENTER", listContainer, "CENTER", 0, 0)
            end

            -- Apply theme color and font to empty text
            local colors = GetColors()
            VE.Theme.ApplyFont(self.emptyText, colors)
            self.emptyText:SetTextColor(colors.text_dim.r, colors.text_dim.g, colors.text_dim.b, colors.text_dim.a)

            -- Check fetch status to show appropriate message
            local fetchStatus = VE.EndeavorTracker and VE.EndeavorTracker.fetchStatus
            local isFetching = fetchStatus and (fetchStatus.state == "fetching" or fetchStatus.state == "pending")

            if isFetching then
                self.emptyText:SetText("Loading activity data...")
            else
                self.emptyText:SetText("Waiting for activity data...")
            end
            self.emptyText:Show()
            self.list:SetItems({})
            self.list:Hide()
            self.summaryRow:Hide()
            self:AnchorList(false)   -- keep the anchor in step with the summary
            return
        end

        if self.emptyText then
            self.emptyText:Hide()
        end
        self.list:Show()

        -- Aggregate contributions by player
        local contributions = {}
        for _, entry in ipairs(activityData.taskActivity) do
            local playerName = entry.playerName or "Unknown"
            local amt = entry.amount or 0
            contributions[playerName] = (contributions[playerName] or 0) + amt
        end
        -- Remove characters with no contribution
        for name, amt in pairs(contributions) do
            if amt <= 0 then contributions[name] = nil end
        end

        -- Apply grouping if enabled
        local groupedNames = nil
        if VE.AltSharing and VE.AltSharing.GroupContributions then
            contributions, groupedNames = VE.AltSharing:GroupContributions(contributions)
        end

        -- Sort by contribution (highest first)
        local sorted = {}
        for playerName, amt in pairs(contributions) do
            -- Build display name: use "Main's Warband" format if grouping multiple chars
            local displayName = playerName
            if groupedNames and groupedNames[playerName] then
                local groupData = groupedNames[playerName]
                -- Always use displayName when available (resolves BT:hash to character name)
                displayName = groupData.displayName or playerName
                if #groupData > 1 then
                    displayName = displayName .. "'s Warband (" .. #groupData .. ")"
                end
            end
            table.insert(sorted, { name = playerName, displayName = displayName, amount = amt })
        end
        table.sort(sorted, function(a, b) return a.amount > b.amount end)

        -- Update summary row (shows total for all player characters). This also
        -- re-anchors the list to make room for the summary when it's shown.
        self:UpdateSummaryRow(contributions)

        -- Stamp rank + addon flag onto each element; the row initializer reads
        -- only the element, so it never has to reach back into these tables.
        for i, data in ipairs(sorted) do
            data.rank = i

            -- Check if this player (or any grouped alt) has the addon
            local hasAddon = false
            if VE.AltSharing and VE.AltSharing.HasAddon then
                if groupedNames and groupedNames[data.name] then
                    -- Check all characters in the group (entries are {name, amount} tables)
                    for _, entry in ipairs(groupedNames[data.name]) do
                        local charName = type(entry) == "table" and entry.name or entry
                        if VE.AltSharing:HasAddon(charName) then
                            hasAddon = true
                            break
                        end
                    end
                else
                    hasAddon = VE.AltSharing:HasAddon(data.name)
                end
            end
            data.hasAddon = hasAddon

            -- Grouped character names for the row tooltip (if grouping is active)
            data.groupedChars = groupedNames and groupedNames[data.name] or nil
        end

        self.list:SetItems(sorted)
    end

    -- Initial update when shown
    container:SetScript("OnShow", function(self)
        -- Request fresh data
        if C_NeighborhoodInitiative and C_NeighborhoodInitiative.RequestInitiativeActivityLog then
            C_NeighborhoodInitiative.RequestInitiativeActivityLog()
        end
        -- Show loading state immediately
        self:Update()
    end)

    -- Listen for activity log updates
    VE.EventBus:Register("VE_ACTIVITY_LOG_UPDATED", function()
        if container:IsShown() then
            container:Update()
        end
    end)

    -- Listen for alt mapping updates (refresh grouped view)
    VE.EventBus:Register("VE_ALT_MAPPING_UPDATED", function()
        if container.UpdateGroupBtnState then
            container.UpdateGroupBtnState()
        end
        if container:IsShown() then
            container:Update(true)
        end
    end)

    -- Listen for theme updates to refresh colors
    VE.EventBus:Register("VE_THEME_UPDATE", function()
        ApplyListContainerColors()
        VE.UI.StyleMinimalScrollBar(container.list.scrollBar)
        if container.UpdateGroupBtnState then
            container.UpdateGroupBtnState()
        end
        -- Theme:UpdateAll already bumped Theme.fontGeneration, so this forced
        -- re-render re-fonts each pooled row exactly once.
        if container:IsShown() then
            container:Update(true)  -- force re-render so rows pick up the new theme colors
        end
    end)

    -- Listen for active neighborhood changes (when user clicks "Set as Active")
    VE.EventBus:Register("VE_ACTIVE_NEIGHBORHOOD_CHANGED", function()
        if container:IsShown() then
            container:Update()
        end
    end)

    return container
end
