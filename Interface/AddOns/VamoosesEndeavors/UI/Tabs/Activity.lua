-- ============================================================================
-- Vamoose's Endeavors - Activity Tab
-- Shows top 5 activities and recent activity feed
-- ============================================================================

VE = VE or {}
VE.UI = VE.UI or {}
VE.UI.Tabs = VE.UI.Tabs or {}

-- Helper to get current theme colors
local function GetColors()
    return VE.Constants:GetThemeColors()
end

function VE.UI.Tabs:CreateActivity(parent)
    local UI = VE.Constants.UI

    local container = CreateFrame("Frame", nil, parent)
    container:SetAllPoints()

    local padding = 0  -- Container edge padding (0 for full-bleed atlas backgrounds)

    -- ========================================================================
    -- TOP ACTIVITIES SECTION
    -- ========================================================================

    local topHeader = VE.UI:CreateSectionHeader(container, "Top 5 Tasks")
    topHeader:SetPoint("TOPLEFT", 0, UI.sectionHeaderYOffset)
    topHeader:SetPoint("TOPRIGHT", 0, UI.sectionHeaderYOffset)

    -- Refresh button (left side of header)
    local refreshBtn = CreateFrame("Button", nil, topHeader)
    refreshBtn:SetSize(16, 16)
    refreshBtn:SetPoint("LEFT", topHeader, "LEFT", 8, 0)

    local refreshIcon = refreshBtn:CreateTexture(nil, "ARTWORK")
    refreshIcon:SetAllPoints()
    refreshIcon:SetAtlas("UI-RefreshButton")
    refreshIcon:SetAlpha(0.6)
    refreshBtn.icon = refreshIcon

    -- Timestamp (right of refresh button)
    local refreshColors = VE.Constants:GetThemeColors()
    local lastUpdateText = topHeader:CreateFontString(nil, "OVERLAY")
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

    local topContainer = CreateFrame("Frame", nil, container, "BackdropTemplate")
    topContainer:SetPoint("TOPLEFT", topHeader, "BOTTOMLEFT", 0, 0)
    topContainer:SetPoint("TOPRIGHT", topHeader, "BOTTOMRIGHT", 0, 0)
    topContainer:SetHeight(130) -- 5 rows x 24 + padding
    topContainer:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = nil,
    })
    container.topContainer = topContainer

    -- Atlas background support
    local ApplyTopContainerColors = VE.UI:AddAtlasBackground(topContainer)

    -- ========================================================================
    -- ACTIVITY FEED SECTION
    -- ========================================================================

    local feedHeader = VE.UI:CreateSectionHeader(container, "Recent Activity")
    feedHeader:SetPoint("TOPLEFT", topContainer, "BOTTOMLEFT", 0, 0)
    feedHeader:SetPoint("TOPRIGHT", topContainer, "BOTTOMRIGHT", 0, 0)

    -- Decimal precision control (1-3)
    container.decimalPrecision = 1

    -- Constant for the session. Was previously re-read per row inside the row
    -- painter, once for every entry on every refresh.
    local currentPlayerName = UnitName("player")

    -- Filter state
    container.filterMeOnly = false
    container.filterMyChars = false  -- Filter for all player's known characters
    container.filterTaskName = nil  -- nil = "All Tasks"
    container.uniqueTaskNames = {}  -- Populated during update

    -- "Me Only" filter toggle (icon button)
    local meOnlyBtn = CreateFrame("Button", nil, feedHeader, "BackdropTemplate")
    meOnlyBtn:SetSize(18, 14)
    meOnlyBtn:SetPoint("LEFT", feedHeader, "LEFT", 8, 0)
    meOnlyBtn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    local C = GetColors()
    meOnlyBtn:SetBackdropColor(C.panel.r, C.panel.g, C.panel.b, 0.8)
    meOnlyBtn:SetBackdropBorderColor(C.border.r, C.border.g, C.border.b, 0.5)

    local meOnlyIcon = meOnlyBtn:CreateTexture(nil, "ARTWORK")
    meOnlyIcon:SetSize(12, 12)
    meOnlyIcon:SetPoint("CENTER", 0, 0)
    meOnlyIcon:SetAtlas("housefinder_neighborhood-list-friend-icon")
    meOnlyIcon:SetDesaturated(true)
    meOnlyIcon:SetAlpha(0.5)
    meOnlyBtn.icon = meOnlyIcon

    function meOnlyBtn:UpdateAppearance()
        local colors = GetColors()
        if container.filterMeOnly then
            self:SetBackdropColor(colors.success.r, colors.success.g, colors.success.b, 0.4)
            self:SetBackdropBorderColor(colors.success.r, colors.success.g, colors.success.b, 0.8)
            self.icon:SetDesaturated(false)
            self.icon:SetAlpha(1)
        else
            self:SetBackdropColor(colors.panel.r, colors.panel.g, colors.panel.b, 0.8)
            self:SetBackdropBorderColor(colors.border.r, colors.border.g, colors.border.b, 0.5)
            self.icon:SetDesaturated(true)
            self.icon:SetAlpha(0.5)
        end
    end

    meOnlyBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Filter: Current Character Only")
        GameTooltip:AddLine(container.filterMeOnly and "Click to show all players" or "Click to show only your activities", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    meOnlyBtn:SetScript("OnLeave", GameTooltip_Hide)
    container.meOnlyBtn = meOnlyBtn

    -- "My Chars" filter toggle (all player's alts)
    local myCharsBtn = CreateFrame("Button", nil, feedHeader, "BackdropTemplate")
    myCharsBtn:SetSize(18, 14)
    myCharsBtn:SetPoint("LEFT", meOnlyBtn, "RIGHT", 2, 0)
    myCharsBtn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    myCharsBtn:SetBackdropColor(C.panel.r, C.panel.g, C.panel.b, 0.8)
    myCharsBtn:SetBackdropBorderColor(C.border.r, C.border.g, C.border.b, 0.5)

    local myCharsIcon = myCharsBtn:CreateTexture(nil, "ARTWORK")
    myCharsIcon:SetSize(12, 12)
    myCharsIcon:SetPoint("CENTER", 0, 0)
    myCharsIcon:SetAtlas("housefinder_neighborhood-friends-icon")
    myCharsIcon:SetDesaturated(true)
    myCharsIcon:SetAlpha(0.5)
    myCharsBtn.icon = myCharsIcon

    function myCharsBtn:UpdateAppearance()
        local colors = GetColors()
        if container.filterMyChars then
            self:SetBackdropColor(colors.accent.r, colors.accent.g, colors.accent.b, 0.4)
            self:SetBackdropBorderColor(colors.accent.r, colors.accent.g, colors.accent.b, 0.8)
            self.icon:SetDesaturated(false)
            self.icon:SetAlpha(1)
        else
            self:SetBackdropColor(colors.panel.r, colors.panel.g, colors.panel.b, 0.8)
            self:SetBackdropBorderColor(colors.border.r, colors.border.g, colors.border.b, 0.5)
            self.icon:SetDesaturated(true)
            self.icon:SetAlpha(0.5)
        end
    end

    myCharsBtn:SetScript("OnClick", function()
        container.filterMyChars = not container.filterMyChars
        -- Disable "Me Only" if "My Chars" is enabled (mutually exclusive)
        if container.filterMyChars then
            container.filterMeOnly = false
            meOnlyBtn:UpdateAppearance()
        end
        myCharsBtn:UpdateAppearance()
        container:Update(true)
    end)
    myCharsBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Filter: My Characters")
        GameTooltip:AddLine(container.filterMyChars and "Click to show all players" or "Click to show only your alts", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    myCharsBtn:SetScript("OnLeave", GameTooltip_Hide)
    container.myCharsBtn = myCharsBtn

    -- Export to CSV button
    local exportBtn = CreateFrame("Button", nil, feedHeader)
    exportBtn:SetSize(14, 14)
    exportBtn:SetPoint("LEFT", myCharsBtn, "RIGHT", 4, 0)
    local exportIcon = exportBtn:CreateTexture(nil, "ARTWORK")
    exportIcon:SetAllPoints()
    exportIcon:SetAtlas("communities-icon-searchmagnifyingglass")
    exportIcon:SetVertexColor(1, 1, 1)
    exportBtn.icon = exportIcon
    exportBtn:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(1, 1, 1)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Export to CSV")
        GameTooltip:AddLine("Click to view activity data in CSV format", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    exportBtn:SetScript("OnLeave", function(self)
        self.icon:SetVertexColor(1, 1, 1)
        GameTooltip_Hide()
    end)
    exportBtn:SetScript("OnClick", function()
        local activityData = VE.EndeavorTracker:GetActivityLogData()
        if not activityData or not activityData.taskActivity or #activityData.taskActivity == 0 then
            print("|cffff9900VE:|r No activity data to export.")
            return
        end
        -- Build taskID -> isRepeatable lookup from Store
        local repeatableLookup = {}
        local tasks = VE.Store:GetState().tasks or {}
        for _, t in ipairs(tasks) do
            if t.id then repeatableLookup[t.id] = t.isRepeatable end
        end
        -- Build CSV with all available API fields (matches Blizzard API names).
        -- Accumulate into a table + concat once: appending to a string in the
        -- loop recopies the whole CSV per entry (O(n^2)) and litters one
        -- throwaway string per row, which spikes GC on a large log.
        local parts = { "playerName,taskName,taskID,amount,completionTime,timestamp,Repeatable\n" }
        for _, entry in ipairs(activityData.taskActivity) do
            local player = entry.playerName or "Unknown"
            local task = entry.taskName or "Unknown"
            local taskID = entry.taskID or 0
            local xp = entry.amount or 0
            local timestamp = entry.completionTime or 0
            local timeStr = ""
            if timestamp > 0 then
                timeStr = date("%Y-%m-%d %H:%M:%S", timestamp)
            end
            -- Escape commas in task names
            task = task:gsub(",", ";")
            local repeatable = repeatableLookup[entry.taskID] and "Yes" or "No"
            parts[#parts + 1] = string.format("%s,%s,%d,%.3f,%s,%d,%s\n",
                player, task, taskID, xp, timeStr, timestamp, repeatable)
        end
        -- Show in popup window
        VE.UI:ShowCSVExportWindow(table.concat(parts), #activityData.taskActivity)
    end)
    container.exportBtn = exportBtn

    -- Coupon view toggle button (uses currency texture)
    container.showCouponView = false
    local couponBtn = CreateFrame("Button", nil, feedHeader, "BackdropTemplate")
    couponBtn:SetSize(18, 14)
    couponBtn:SetPoint("LEFT", exportBtn, "RIGHT", 4, 0)
    couponBtn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    couponBtn:SetBackdropColor(C.panel.r, C.panel.g, C.panel.b, 0.8)
    couponBtn:SetBackdropBorderColor(C.border.r, C.border.g, C.border.b, 0.5)

    -- Get currency texture for Community Coupons
    local couponIcon = couponBtn:CreateTexture(nil, "ARTWORK")
    couponIcon:SetSize(12, 12)
    couponIcon:SetPoint("CENTER", 0, 0)
    local currencyInfo = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo
        and C_CurrencyInfo.GetCurrencyInfo(VE.Constants.CURRENCY_IDS.COMMUNITY_COUPONS or 3363)
    if currencyInfo and currencyInfo.iconFileID then
        couponIcon:SetTexture(currencyInfo.iconFileID)
    else
        couponIcon:SetAtlas("legionarmy-circle-button")
        local f = CreateFrame("Frame")
        f:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
        f:SetScript("OnEvent", function(self)
            local info = C_CurrencyInfo.GetCurrencyInfo(VE.Constants.CURRENCY_IDS.COMMUNITY_COUPONS or 3363)
            if info and info.iconFileID then
                couponIcon:SetTexture(info.iconFileID)
                self:UnregisterAllEvents()
                self:SetScript("OnEvent", nil)
            end
        end)
    end
    couponIcon:SetDesaturated(false)
    couponIcon:SetAlpha(1)
    couponBtn.icon = couponIcon

    function couponBtn:UpdateAppearance()
        local colors = GetColors()
        -- Use cyan for coupons (fallback to accent if not defined)
        local couponColor = colors.coupon or {r=0.16, g=0.63, b=0.60, a=1}  -- Cyan fallback
        if container.showCouponView then
            self:SetBackdropColor(couponColor.r, couponColor.g, couponColor.b, 0.4)
            self:SetBackdropBorderColor(couponColor.r, couponColor.g, couponColor.b, 0.8)
            self.icon:SetDesaturated(false)
            self.icon:SetAlpha(1)
        else
            self:SetBackdropColor(colors.panel.r, colors.panel.g, colors.panel.b, 0.8)
            self:SetBackdropBorderColor(colors.border.r, colors.border.g, colors.border.b, 0.5)
            self.icon:SetDesaturated(false)
            self.icon:SetAlpha(1)
        end
    end

    couponBtn:SetScript("OnClick", function()
        container.showCouponView = not container.showCouponView
        couponBtn:UpdateAppearance()
        container:Update(true)
    end)
    couponBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Toggle: Coupon Earnings")
        local gainCount = VE_DB and VE_DB.couponGains and #VE_DB.couponGains or 0
        GameTooltip:AddLine(container.showCouponView
            and "Click to show activity log"
            or ("Click to show coupon earnings (" .. gainCount .. " tracked)"), 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    couponBtn:SetScript("OnLeave", GameTooltip_Hide)
    container.couponBtn = couponBtn

    -- Update meOnlyBtn to disable myChars when enabled
    meOnlyBtn:SetScript("OnClick", function()
        container.filterMeOnly = not container.filterMeOnly
        -- Disable "My Chars" if "Me Only" is enabled (mutually exclusive)
        if container.filterMeOnly then
            container.filterMyChars = false
            myCharsBtn:UpdateAppearance()
        end
        meOnlyBtn:UpdateAppearance()
        container:Update(true)
    end)

    -- Task filter dropdown button (right side of header)
    local taskFilterBtn = CreateFrame("Button", nil, feedHeader, "BackdropTemplate")
    taskFilterBtn:SetSize(90, 14)
    taskFilterBtn:SetPoint("RIGHT", feedHeader, "RIGHT", -30, 1)
    taskFilterBtn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    taskFilterBtn:SetBackdropColor(C.panel.r, C.panel.g, C.panel.b, 0.8)
    taskFilterBtn:SetBackdropBorderColor(C.border.r, C.border.g, C.border.b, 0.5)

    local taskFilterText = taskFilterBtn:CreateFontString(nil, "OVERLAY")
    taskFilterText:SetPoint("LEFT", 4, 0)
    taskFilterText:SetPoint("RIGHT", -12, 0)
    taskFilterText:SetJustifyH("LEFT")
    taskFilterText:SetWordWrap(false)
    VE.Theme.ApplyFont(taskFilterText, C)  -- Apply font before SetText
    taskFilterText:SetText("All Tasks")
    taskFilterText:SetTextColor(C.text_dim.r, C.text_dim.g, C.text_dim.b)
    taskFilterBtn.text = taskFilterText

    local taskFilterArrow = taskFilterBtn:CreateTexture(nil, "OVERLAY")
    taskFilterArrow:SetSize(8, 8)
    taskFilterArrow:SetPoint("RIGHT", -2, 0)
    taskFilterArrow:SetAtlas("housing-stair-arrow-down-default")
    taskFilterBtn.arrow = taskFilterArrow

    function taskFilterBtn:UpdateAppearance()
        local colors = GetColors()
        if container.filterTaskName then
            self:SetBackdropColor(colors.accent.r, colors.accent.g, colors.accent.b, 0.3)
            self:SetBackdropBorderColor(colors.accent.r, colors.accent.g, colors.accent.b, 0.8)
            self.text:SetTextColor(colors.accent.r, colors.accent.g, colors.accent.b)
            -- Truncate long task names
            local displayName = container.filterTaskName or ""
            if #displayName > 12 then
                displayName = string.sub(displayName, 1, 11) .. "..."
            end
            self.text:SetText(displayName)
        else
            self:SetBackdropColor(colors.panel.r, colors.panel.g, colors.panel.b, 0.8)
            self:SetBackdropBorderColor(colors.border.r, colors.border.g, colors.border.b, 0.5)
            self.text:SetTextColor(colors.text_dim.r, colors.text_dim.g, colors.text_dim.b)
            self.text:SetText("All Tasks")
        end
        VE.Theme.ApplyFont(self.text, colors)
    end

    -- Task filter dropdown menu
    local taskDropdown = CreateFrame("Frame", "VE_TaskFilterDropdown", taskFilterBtn, "BackdropTemplate")
    taskDropdown:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    taskDropdown:SetBackdropColor(C.panel.r, C.panel.g, C.panel.b, 0.95)
    taskDropdown:SetBackdropBorderColor(C.border.r, C.border.g, C.border.b, 1)
    taskDropdown:SetFrameStrata("DIALOG")
    taskDropdown:SetPoint("TOPLEFT", taskFilterBtn, "BOTTOMLEFT", 0, -2)
    taskDropdown:SetSize(180, 100)
    taskDropdown:Hide()
    taskDropdown.items = {}
    container.taskDropdown = taskDropdown

    local function BuildTaskDropdown()
        local colors = GetColors()
        -- Hide existing items
        for _, item in ipairs(taskDropdown.items) do
            item:Hide()
        end

        -- Build list: "All Tasks" + unique task names
        local tasks = { { name = nil, display = "All Tasks" } }
        for _, taskName in ipairs(container.uniqueTaskNames) do
            table.insert(tasks, { name = taskName, display = taskName })
        end

        local yOffset = 2
        local itemHeight = 16
        for i, taskData in ipairs(tasks) do
            local item = taskDropdown.items[i]
            if not item then
                item = CreateFrame("Button", nil, taskDropdown, "BackdropTemplate")
                item:SetHeight(itemHeight)
                item:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
                item:SetBackdropColor(0, 0, 0, 0)
                local itemText = item:CreateFontString(nil, "OVERLAY")
                itemText:SetPoint("LEFT", 4, 0)
                itemText:SetPoint("RIGHT", -4, 0)
                itemText:SetJustifyH("LEFT")
                itemText:SetWordWrap(false)
                item.text = itemText
                item:SetScript("OnEnter", function(self)
                    self:SetBackdropColor(colors.accent.r, colors.accent.g, colors.accent.b, 0.3)
                end)
                item:SetScript("OnLeave", function(self)
                    self:SetBackdropColor(0, 0, 0, 0)
                end)
                taskDropdown.items[i] = item
            end

            item:SetPoint("TOPLEFT", 2, -yOffset)
            item:SetPoint("TOPRIGHT", -2, -yOffset)
            VE.Theme.ApplyFont(item.text, colors)  -- Apply font before SetText
            item.text:SetText(taskData.display)

            if taskData.name == container.filterTaskName then
                item.text:SetTextColor(colors.accent.r, colors.accent.g, colors.accent.b)
            else
                item.text:SetTextColor(colors.text.r, colors.text.g, colors.text.b)
            end

            item:SetScript("OnClick", function()
                container.filterTaskName = taskData.name
                taskFilterBtn:UpdateAppearance()
                taskDropdown:Hide()
                container:Update(true)
            end)
            item:Show()

            yOffset = yOffset + itemHeight
        end

        taskDropdown:SetHeight(yOffset + 4)
        taskDropdown:SetBackdropColor(colors.panel.r, colors.panel.g, colors.panel.b, 0.95)
        taskDropdown:SetBackdropBorderColor(colors.border.r, colors.border.g, colors.border.b, 1)
    end

    taskFilterBtn:SetScript("OnClick", function()
        if taskDropdown:IsShown() then
            taskDropdown:Hide()
        else
            BuildTaskDropdown()
            taskDropdown:Show()
        end
    end)
    taskFilterBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Filter: By Task Type")
        GameTooltip:AddLine("Click to select a specific task", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    taskFilterBtn:SetScript("OnLeave", GameTooltip_Hide)
    container.taskFilterBtn = taskFilterBtn

    -- Close dropdown when clicking elsewhere
    taskDropdown:SetScript("OnShow", function()
        taskDropdown:SetPropagateKeyboardInput(true)
    end)
    taskDropdown:SetScript("OnHide", function() end)

    -- Decrease decimals arrow (rotated left)
    local decArrow = CreateFrame("Button", nil, feedHeader)
    decArrow:SetSize(12, 12)
    decArrow:SetPoint("RIGHT", feedHeader, "RIGHT", -18, 0)
    local decTex = decArrow:CreateTexture(nil, "ARTWORK")
    decTex:SetAllPoints()
    decTex:SetAtlas("housing-floor-arrow-up-disabled")
    decTex:SetRotation(math.rad(90)) -- Rotate to point left
    decArrow.tex = decTex
    decArrow:SetScript("OnClick", function()
        if container.decimalPrecision > 1 then
            container.decimalPrecision = container.decimalPrecision - 1
            container:Update(true)
        end
    end)
    decArrow:SetScript("OnEnter", function(self)
        self.tex:SetAlpha(1)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Decrease decimal places")
        GameTooltip:Show()
    end)
    decArrow:SetScript("OnLeave", function(self)
        self.tex:SetAlpha(0.7)
        GameTooltip:Hide()
    end)
    decTex:SetAlpha(0.7)

    -- Increase decimals arrow (rotated right)
    local incArrow = CreateFrame("Button", nil, feedHeader)
    incArrow:SetSize(12, 12)
    incArrow:SetPoint("RIGHT", feedHeader, "RIGHT", -4, 0)
    local incTex = incArrow:CreateTexture(nil, "ARTWORK")
    incTex:SetAllPoints()
    incTex:SetAtlas("housing-floor-arrow-up-disabled")
    incTex:SetRotation(math.rad(-90)) -- Rotate to point right
    incArrow.tex = incTex
    incArrow:SetScript("OnClick", function()
        if container.decimalPrecision < 3 then
            container.decimalPrecision = container.decimalPrecision + 1
            container:Update(true)
        end
    end)
    incArrow:SetScript("OnEnter", function(self)
        self.tex:SetAlpha(1)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Increase decimal places")
        GameTooltip:Show()
    end)
    incArrow:SetScript("OnLeave", function(self)
        self.tex:SetAlpha(0.7)
        GameTooltip:Hide()
    end)
    incTex:SetAlpha(0.7)

    local feedContainer = CreateFrame("Frame", nil, container, "BackdropTemplate")
    feedContainer:SetPoint("TOPLEFT", feedHeader, "BOTTOMLEFT", 0, 0)
    feedContainer:SetPoint("BOTTOMRIGHT", -padding, padding)
    feedContainer:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = nil,
    })
    container.feedContainer = feedContainer

    -- Atlas background support
    local ApplyFeedContainerColors = VE.UI:AddAtlasBackground(feedContainer)

    -- Apply container colors (both containers)
    local function ApplyContainerColors()
        ApplyTopContainerColors()
        ApplyFeedContainerColors()
    end
    ApplyContainerColors()

    -- Pool for top task rows (fixed 5 -- plain frames, no scroll needed)
    container.topRows = {}

    -- ========================================================================
    -- CREATE TOP TASK ROW
    -- ========================================================================

    local function CreateTopTaskRow(parentFrame)
        local C = GetColors()
        local row = CreateFrame("Frame", nil, parentFrame, "BackdropTemplate")
        row:SetHeight(24)
        row:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = nil,
        })
        row:SetBackdropColor(C.panel.r, C.panel.g, C.panel.b, C.panel.a * 0.5)

        -- Rank
        local rank = row:CreateFontString(nil, "OVERLAY")
        rank:SetPoint("LEFT", 8, 0)
        rank:SetWidth(24)
        rank:SetJustifyH("CENTER")
        rank:SetTextColor(C.gold.r, C.gold.g, C.gold.b)
        VE.Theme.ApplyFont(rank, C)
        row.rank = rank

        -- Task name
        local name = row:CreateFontString(nil, "OVERLAY")
        name:SetPoint("LEFT", rank, "RIGHT", 8, 0)
        name:SetPoint("RIGHT", -80, 0)
        name:SetJustifyH("LEFT")
        name:SetTextColor(C.text.r, C.text.g, C.text.b)
        VE.Theme.ApplyFont(name, C)
        row.name = name

        -- Completion count
        local count = row:CreateFontString(nil, "OVERLAY")
        count:SetPoint("RIGHT", -8, 0)
        count:SetJustifyH("RIGHT")
        count:SetTextColor(C.accent.r, C.accent.g, C.accent.b)
        VE.Theme.ApplyFont(count, C)
        row.count = count

        function row:SetData(rankNum, taskName, completions)
            local colors = GetColors()

            -- Same font gating as the pooled feed rows: SetFont re-measures, and
            -- nothing about the font changes on a data refresh.
            if self._fontGen ~= VE.Theme.fontGeneration then
                VE.Theme.ApplyFont(self.rank, colors)
                VE.Theme.ApplyFont(self.name, colors)
                VE.Theme.ApplyFont(self.count, colors)
                self._fontGen = VE.Theme.fontGeneration
            end

            self.rank:SetText("#" .. rankNum)
            self.name:SetText(taskName)
            self.count:SetText(completions .. "x")

            if rankNum == 1 then
                self.rank:SetTextColor(colors.gold.r, colors.gold.g, colors.gold.b)
            elseif rankNum == 2 then
                self.rank:SetTextColor(colors.silver.r, colors.silver.g, colors.silver.b)
            elseif rankNum == 3 then
                self.rank:SetTextColor(colors.bronze.r, colors.bronze.g, colors.bronze.b)
            else
                self.rank:SetTextColor(colors.text_dim.r, colors.text_dim.g, colors.text_dim.b)
            end

            self.name:SetTextColor(colors.text.r, colors.text.g, colors.text.b, colors.text.a)
            self.count:SetTextColor(colors.accent.r, colors.accent.g, colors.accent.b, colors.accent.a)

            self:SetBackdropColor(colors.panel.r, colors.panel.g, colors.panel.b, colors.panel.a * 0.5)
        end

        return row
    end

    -- ========================================================================
    -- ACTIVITY ROW (pooled, shared by the feed and coupon views)
    -- ========================================================================
    -- One initializer, one set of FontStrings. The feed and coupon views have
    -- identical column geometry (time | who | task | amount) and differ only in
    -- which source fields feed them, so they share this pool. They MUST share a
    -- single lazy-init key: two initializers over one "Frame" pool leak each
    -- other's FontStrings onto recycled rows (Lattice/cookbook/03-scrollboxes.md,
    -- "Cross-kind frame-pool contamination").
    --
    -- Update() normalizes both sources into { kind, when, who, task, amount,
    -- isMe }, so field-name drift between the two views can't come back.

    local ROW_HEIGHT  = 20
    local ROW_SPACING = 1

    -- decimalPrecision is clamped to 1..3 by the arrows above. Precomputed so
    -- the initializer doesn't concatenate a format string per row per repaint.
    local AMOUNT_FORMATS = { [1] = "+%.1f", [2] = "+%.2f", [3] = "+%.3f" }
    -- Wide enough for the worst case the precision arrows can produce
    -- ("+999.999"), so the column never has to steal from the task name mid-cycle.
    local AMOUNT_COL_W = 52
    local COUPON_FALLBACK = { r = 0.16, g = 0.63, b = 0.60, a = 1 }

    local function FormatTimeAgo(when)
        if not when then return "" end
        local diff = time() - when
        if diff < 60 then return "<1m" end
        if diff < 3600 then return math.floor(diff / 60) .. "m" end
        if diff < 86400 then return math.floor(diff / 3600) .. "h" end
        return math.floor(diff / 86400) .. "d"
    end

    local function InitActivityRow(row, ed)
        if not row._built then
            row._bg = row:CreateTexture(nil, "BACKGROUND")
            row._bg:SetAllPoints()

            row._time = row:CreateFontString(nil, "OVERLAY")
            row._time:SetPoint("LEFT", 6, 0)
            row._time:SetWidth(40)
            row._time:SetJustifyH("LEFT")

            row._who = row:CreateFontString(nil, "OVERLAY")
            row._who:SetPoint("LEFT", row._time, "RIGHT", 4, 0)
            row._who:SetWidth(70)
            row._who:SetJustifyH("LEFT")

            -- Amount gets a REAL column, and the task name's right edge is
            -- anchored to it. Previously the amount was a free-floating
            -- right-aligned string and the task reserved a fixed 40px for it --
            -- which left only 34px of clearance, so at decimal precision 2-3 a
            -- double-digit contribution ("+12.345") grew straight over the task
            -- name. Anchoring the two makes the overlap structurally impossible
            -- whatever the value.
            row._amount = row:CreateFontString(nil, "OVERLAY")
            row._amount:SetPoint("RIGHT", -6, 0)
            row._amount:SetWidth(AMOUNT_COL_W)
            row._amount:SetJustifyH("RIGHT")

            row._task = row:CreateFontString(nil, "OVERLAY")
            row._task:SetPoint("LEFT", row._who, "RIGHT", 4, 0)
            row._task:SetPoint("RIGHT", row._amount, "LEFT", -4, 0)
            row._task:SetJustifyH("LEFT")

            row._built = true
        end

        local colors = GetColors()

        -- SetFont re-measures the string, so it's the expensive half of a
        -- repaint. Fonts only move when the theme/font config does, which
        -- Theme:UpdateAll stamps -- so a data refresh skips this entirely.
        if row._fontGen ~= VE.Theme.fontGeneration then
            VE.Theme.ApplyFont(row._time, colors)
            VE.Theme.ApplyFont(row._who, colors)
            VE.Theme.ApplyFont(row._task, colors)
            VE.Theme.ApplyFont(row._amount, colors)
            row._fontGen = VE.Theme.fontGeneration
        end

        row._bg:SetColorTexture(colors.panel.r, colors.panel.g, colors.panel.b, colors.panel.a * 0.3)

        row._time:SetText(FormatTimeAgo(ed.when))
        row._who:SetText(ed.who or "Unknown")
        row._task:SetText(ed.task or "Unknown Task")

        -- Coupons are whole currency units; feed amounts are fractional
        -- post-DR contribution and honour the decimal-precision arrows.
        if ed.kind == "coupon" then
            row._amount:SetText("+" .. (ed.amount or 0))
        else
            local fmt = AMOUNT_FORMATS[container.decimalPrecision] or AMOUNT_FORMATS[1]
            row._amount:SetText(string.format(fmt, ed.amount or 0))
        end

        row._time:SetTextColor(colors.text_dim.r, colors.text_dim.g, colors.text_dim.b, colors.text_dim.a)
        row._task:SetTextColor(colors.text.r, colors.text.g, colors.text.b, colors.text.a)

        local amountColor
        if ed.kind == "coupon" then
            amountColor = colors.coupon or COUPON_FALLBACK
        else
            amountColor = colors.endeavor
        end
        row._amount:SetTextColor(amountColor.r, amountColor.g, amountColor.b, amountColor.a or 1)

        local whoColor = ed.isMe and colors.success or colors.accent
        row._who:SetTextColor(whoColor.r, whoColor.g, whoColor.b, whoColor.a)
    end

    local feedList = VE.UI:CreateScrollBoxList(feedContainer, {
        rowHeight   = ROW_HEIGHT,
        spacing     = ROW_SPACING,
        initializer = InitActivityRow,
    })
    container.feedList = feedList

    -- Empty/placeholder states. These hang off feedContainer rather than the
    -- list: the ScrollBox owns its own frames and must not be given children.
    local function GetPlaceholder()
        if not container.placeholder then
            local fs = feedContainer:CreateFontString(nil, "OVERLAY")
            fs:SetPoint("CENTER", feedContainer, "CENTER", 0, 0)
            fs:SetJustifyH("CENTER")
            container.placeholder = fs
        end
        return container.placeholder
    end

    -- Show `text` instead of the list (empty log, no filter matches, no
    -- coupons). Passing nil clears the placeholder and shows the list again.
    local function SetPlaceholder(text)
        if not text then
            if container.placeholder then container.placeholder:Hide() end
            feedList:Show()
            return
        end
        local fs = GetPlaceholder()
        local colors = GetColors()
        VE.Theme.ApplyFont(fs, colors)
        fs:SetTextColor(colors.text_dim.r, colors.text_dim.g, colors.text_dim.b, colors.text_dim.a)
        fs:SetText(text)
        fs:Show()
        feedList:SetItems({})
        feedList:Hide()
    end

    -- ========================================================================
    -- UPDATE FUNCTION
    -- ========================================================================

    function container:Update(forceUpdate)
        -- Skip rebuild if data hasn't changed (optimization)
        local currentTimestamp = VE.EndeavorTracker and VE.EndeavorTracker.activityLogLastUpdated
        if not forceUpdate and self.lastActivityUpdate and self.lastActivityUpdate == currentTimestamp then
            return
        end
        self.lastActivityUpdate = currentTimestamp

        -- Top-5 rows are plain frames (fixed count, no scroll); the feed's rows
        -- are pooled by the ScrollBox and released by swapping the dataset.
        for _, row in ipairs(self.topRows) do
            row:Hide()
        end

        -- ================================================================
        -- COUPON VIEW MODE
        -- ================================================================
        if self.showCouponView then
            VE_DB = VE_DB or {}
            local couponGains = VE_DB.couponGains or {}

            -- Only task-correlated gains (ignore weekly rewards, etc.)
            local items = {}
            for _, gain in ipairs(couponGains) do
                if gain.taskName then
                    items[#items + 1] = {
                        kind   = "coupon",
                        when   = gain.timestamp,
                        who    = gain.character,
                        task   = gain.taskName,
                        amount = gain.amount,
                        isMe   = gain.character == currentPlayerName,
                    }
                end
            end

            if #items == 0 then
                SetPlaceholder("No coupon earnings tracked yet.\nComplete tasks to see actual rewards.")
                return
            end

            table.sort(items, function(a, b) return (a.when or 0) > (b.when or 0) end)
            SetPlaceholder(nil)
            self.feedList:SetItems(items)
            return
        end

        -- Get activity log data
        local activityData = VE.EndeavorTracker:GetActivityLogData()
        if not activityData or not activityData.taskActivity or #activityData.taskActivity == 0 then
            -- Check fetch status to show appropriate message
            local fetchStatus = VE.EndeavorTracker and VE.EndeavorTracker.fetchStatus
            local isFetching = fetchStatus and (fetchStatus.state == "fetching" or fetchStatus.state == "pending")
            SetPlaceholder(isFetching and "Loading activity data..." or "Waiting for activity data...")
            return
        end

        -- ====================================================================
        -- TOP 5 TASKS
        -- ====================================================================

        -- Aggregate completions by task
        local taskCounts = {}
        for _, entry in ipairs(activityData.taskActivity) do
            local taskName = entry.taskName or "Unknown"
            taskCounts[taskName] = (taskCounts[taskName] or 0) + 1
        end

        -- Sort by count (highest first)
        local sortedTasks = {}
        for taskName, taskCount in pairs(taskCounts) do
            table.insert(sortedTasks, { name = taskName, count = taskCount })
        end
        table.sort(sortedTasks, function(a, b) return a.count > b.count end)

        -- Display top 5
        local yOffset = 2
        local rowHeight = 24
        local rowSpacing = 2

        for i = 1, math.min(5, #sortedTasks) do
            local data = sortedTasks[i]
            local row = self.topRows[i]
            if not row then
                row = CreateTopTaskRow(self.topContainer)
                self.topRows[i] = row
            end

            row:SetPoint("TOPLEFT", 2, -yOffset)
            row:SetPoint("TOPRIGHT", -2, -yOffset)
            row:SetData(i, data.name, data.count)
            row:Show()

            yOffset = yOffset + rowHeight + rowSpacing
        end

        -- ====================================================================
        -- ACTIVITY FEED (most recent first)
        -- ====================================================================

        -- Build unique task names from task list (faster than activity log)
        local state = VE.Store:GetState()
        if state.tasks and #state.tasks > 0 then
            self.uniqueTaskNames = {}
            for _, task in ipairs(state.tasks) do
                if task.name then
                    table.insert(self.uniqueTaskNames, task.name)
                end
            end
            table.sort(self.uniqueTaskNames)
        end

        -- Build set of known character names for "My Chars" filter
        -- Uses VE_DB.myCharacters (same as Leaderboard tab) which persists all logged-in alts
        local myCharNames = {}
        if self.filterMyChars then
            VE_DB = VE_DB or {}
            VE_DB.myCharacters = VE_DB.myCharacters or {}
            for charName, _ in pairs(VE_DB.myCharacters) do
                myCharNames[charName] = true
            end
            -- Always include current player
            myCharNames[currentPlayerName] = true
        end

        -- Filter + normalize into the shared row shape in one pass. The row
        -- initializer reads only these fields, so the feed and coupon views
        -- can't drift apart on source field names again.
        local items = {}
        for _, entry in ipairs(activityData.taskActivity) do
            local keep = true
            if self.filterMeOnly and entry.playerName ~= currentPlayerName then
                keep = false
            elseif self.filterMyChars and not myCharNames[entry.playerName] then
                keep = false
            elseif self.filterTaskName and entry.taskName ~= self.filterTaskName then
                keep = false
            end
            if keep then
                items[#items + 1] = {
                    kind   = "feed",
                    when   = entry.completionTime,
                    who    = entry.playerName,
                    task   = entry.taskName,
                    amount = entry.amount,
                    isMe   = entry.playerName == currentPlayerName,
                }
            end
        end
        table.sort(items, function(a, b) return (a.when or 0) > (b.when or 0) end)

        -- Show "no results" if filters excluded everything
        if #items == 0 then
            SetPlaceholder("No activity matches your filters.")
            return
        end

        SetPlaceholder(nil)
        self.feedList:SetItems(items)
    end

    -- Initial update when shown
    container:SetScript("OnShow", function(self)
        -- Request fresh data
        if C_NeighborhoodInitiative and C_NeighborhoodInitiative.RequestInitiativeActivityLog then
            C_NeighborhoodInitiative.RequestInitiativeActivityLog()
        end
        -- Force update -- cache may have refreshed while tab was hidden (stale check would skip)
        self:Update(true)
    end)

    -- Listen for activity log updates
    VE.EventBus:Register("VE_ACTIVITY_LOG_UPDATED", function()
        if container:IsShown() then
            container:Update()
        end
    end)

    -- Listen for active neighborhood changes (when user clicks "Set as Active")
    VE.EventBus:Register("VE_ACTIVE_NEIGHBORHOOD_CHANGED", function()
        if container:IsShown() then
            container:Update()
        end
    end)

    -- Listen for theme updates to refresh colors
    VE.EventBus:Register("VE_THEME_UPDATE", function()
        ApplyContainerColors()
        -- Update filter button appearances
        if container.meOnlyBtn then container.meOnlyBtn:UpdateAppearance() end
        if container.myCharsBtn then container.myCharsBtn:UpdateAppearance() end
        if container.couponBtn then container.couponBtn:UpdateAppearance() end
        if container.taskFilterBtn then container.taskFilterBtn:UpdateAppearance() end
        -- Update dropdown colors
        if container.taskDropdown then
            local colors = GetColors()
            container.taskDropdown:SetBackdropColor(colors.panel.r, colors.panel.g, colors.panel.b, 0.95)
            container.taskDropdown:SetBackdropBorderColor(colors.border.r, colors.border.g, colors.border.b, 1)
        end
        VE.UI.StyleMinimalScrollBar(container.feedList.scrollBar)
        -- Theme:UpdateAll already bumped Theme.fontGeneration, so the forced
        -- re-render re-fonts each row exactly once. A hidden tab skips this and
        -- picks the new fonts up on its next Update -- the generation stamp on
        -- each pooled row is what makes that self-correcting.
        if container:IsShown() then
            container:Update(true)  -- force re-render so rows pick up the new theme colors
        end
    end)

    return container
end
