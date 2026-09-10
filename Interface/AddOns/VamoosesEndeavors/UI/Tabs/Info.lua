-- ============================================================================
-- Vamoose's Endeavors - Info Tab
-- How-to guide displaying addon features by tab
-- ============================================================================

VE = VE or {}
VE.UI = VE.UI or {}
VE.UI.Tabs = VE.UI.Tabs or {}

local function GetColors()
    return VE.Constants:GetThemeColors()
end

-- Guide content organized by what players want to do
local GUIDE_SECTIONS = {
    {
        title = "Getting Started",
        lines = {
            "Type /ve to open the window. Use the minimap button or Housing Dashboard button as alternatives.",
            "If you own multiple houses, use the dropdown at the top to view each one. Click 'Set as Active' to switch which house earns endeavor progress.",
            "Data refreshes automatically when you complete tasks or earn rewards.",
        },
    },
    {
        title = "Tracking Your Endeavor Tasks",
        lines = {
            "The Endeavors tab lists every task in your current neighborhood initiative.",
            "Completed tasks show a green checkmark. Repeatable tasks have a circular arrow icon.",
            "Each task shows its XP reward (gold badge) and coupon reward (cyan badge).",
            "Use the sort buttons to find the best tasks: sort by XP, Coupons, or Best Next Task.",
            "Best Next Task highlights tasks in gold/silver/bronze based on their XP value.",
            "Shift-click up to 5 tasks to favourite them - they stay visible in the minimized window.",
        },
    },
    {
        title = "Your Progress",
        lines = {
            "The progress bar at the top tracks your neighborhood's initiative progress toward milestone rewards.",
            "Your House Level and XP are shown in the header alongside Community Coupons.",
            "Your personal contribution is displayed on the right. It dims when the endeavor cap is reached.",
            function()
                local chest = VE.EndeavorTracker and VE.EndeavorTracker.GetChest and VE.EndeavorTracker:GetChest() or nil
                local xp = (chest and chest.xp and chest.xp > 0) and chest.xp or nil
                local coupons
                if chest and chest.currencies then
                    local couponID = VE.Constants.CURRENCY_IDS.COMMUNITY_COUPONS
                    for _, c in ipairs(chest.currencies) do
                        if c.currencyID == couponID and c.amount > 0 then coupons = c.amount break end
                    end
                end
                if xp and coupons then
                    return ("House XP from endeavors is capped each initiative; click the completion chest at 100%% for an extra %d XP and %d coupons."):format(xp, coupons)
                elseif xp then
                    return ("House XP from endeavors is capped each initiative; click the completion chest at 100%% for an extra %d XP."):format(xp)
                else
                    return "House XP from endeavors is capped each initiative; click the completion chest at 100% to claim its bonus reward."
                end
            end,
            "Minimize the window to show just the progress bar and your favourited tasks.",
        },
    },
    {
        title = "Neighborhood Rankings",
        lines = {
            "The Rankings tab shows everyone in your neighborhood ranked by contribution.",
            "Top 3 contributors are shown in gold, silver, and bronze. Your characters are highlighted.",
            "A green bar next to a name means that player also uses this addon.",
            "Toggle 'Group by Player' to combine all of a player's alts into one entry.",
            "Hover a grouped entry to see each character's individual contribution.",
            "Export to CSV if you want to analyse the data in a spreadsheet.",
        },
    },
    {
        title = "Activity Feed",
        lines = {
            "The Activity tab shows the most popular tasks and a live feed of recent completions.",
            "Filter to just your character with 'Me Only', or all your alts with 'My Chars'.",
            "Use the task dropdown to focus on a specific task type.",
            "Switch to Coupon Earnings view (coupon icon) to see how many coupons each task earnt.",
        },
    },
    {
        title = "Playing on Multiple Characters",
        lines = {
            "Your own alts are automatically grouped together on the Rankings and Activity tabs.",
            "Enable 'Share my alts' in Settings so guildmates can see your characters as one player.",
            "Sharing is private: BattleTags are hashed and communication uses a hidden addon channel.",
            "Set your Main Character in Settings to choose which name represents your warband.",
            "Cross-faction alts are linked automatically through your BattleTag.",
        },
    },
    {
        title = "Multiple Accounts & Cross-Faction Sync",
        lines = {
            "Alt sharing uses a hidden addon channel scoped to your neighborhood. No messages appear in chat.",
            "Enable 'Share my alts' in Settings. When you log into any character, the addon broadcasts after a few seconds.",
            "To sync Alliance and Horde alts, log into each character at least once with the addon installed and sharing enabled.",
            "Your BattleTag links characters across both factions automatically. Only a privacy hash is shared, never the raw tag.",
            "Guildmates who also run the addon will receive your broadcast and group your alts on their leaderboard.",
            "To force a refresh, toggle 'Share my alts' off and back on in Settings, or simply relog.",
            "Alt data persists between sessions. You only need to be online at the same time as a guildmate once to sync.",
        },
    },
    {
        title = "Customization",
        lines = {
            "Choose from 11 themes in Settings, or press the 'T' button in the title bar to cycle quickly.",
            "Adjust UI Scale (80-140%) and background Transparency (30-100%) to suit your setup.",
            "Pick from 5 font families including Expressway.",
            "Right-click the squirrel mascot to switch between variants.",
        },
    },
}

function VE.UI.Tabs:CreateInfo(parent)
    local UI = VE.Constants.UI

    local container = CreateFrame("Frame", nil, parent)
    container:SetAllPoints()

    -- ========================================================================
    -- HEADER
    -- ========================================================================

    local header = VE.UI:CreateSectionHeader(container, "How to Use")
    header:SetPoint("TOPLEFT", 0, UI.sectionHeaderYOffset)
    header:SetPoint("TOPRIGHT", 0, UI.sectionHeaderYOffset)

    -- ========================================================================
    -- SCROLLABLE CONTENT
    -- ========================================================================

    local scrollContainer = CreateFrame("Frame", nil, container, "BackdropTemplate")
    scrollContainer:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, 0)
    scrollContainer:SetPoint("BOTTOMRIGHT", 0, 0)
    scrollContainer:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = nil,
    })
    container.scrollContainer = scrollContainer

    local ApplyPanelColors = VE.UI:AddAtlasBackground(scrollContainer)
    ApplyPanelColors()

    local scrollFrame, scrollContent = VE.UI:CreateScrollFrame(scrollContainer)
    container.scrollFrame = scrollFrame
    container.scrollContent = scrollContent
    container.elements = {}

    -- ========================================================================
    -- BUILD GUIDE CONTENT
    -- ========================================================================

    -- Pools for reusable UI elements (FontStrings/Textures can't be destroyed)
    container._fontPool = {}
    container._texPool = {}
    container._fontUsed = 0
    container._texUsed = 0

    local function AcquireFont()
        container._fontUsed = container._fontUsed + 1
        local fs = container._fontPool[container._fontUsed]
        if not fs then
            fs = scrollContent:CreateFontString(nil, "OVERLAY")
            VE.Theme:Register(fs, "RowText")
            container._fontPool[container._fontUsed] = fs
        end
        fs:ClearAllPoints()
        fs:Show()
        return fs
    end

    local function AcquireTexture()
        container._texUsed = container._texUsed + 1
        local tex = container._texPool[container._texUsed]
        if not tex then
            tex = scrollContent:CreateTexture(nil, "ARTWORK")
            container._texPool[container._texUsed] = tex
        end
        tex:ClearAllPoints()
        tex:Show()
        return tex
    end

    function container:BuildGuide()
        local C = GetColors()

        -- Hide all previously used elements
        for i = 1, self._fontUsed do self._fontPool[i]:Hide() end
        for i = 1, self._texUsed do self._texPool[i]:Hide() end
        self._fontUsed = 0
        self._texUsed = 0

        local yOffset = -10

        for sectionIdx, section in ipairs(GUIDE_SECTIONS) do
            -- Section title
            local title = AcquireFont()
            title:SetPoint("TOPLEFT", 12, yOffset)
            title:SetPoint("TOPRIGHT", -12, yOffset)
            title:SetJustifyH("LEFT")
            VE.Theme.ApplyFont(title, C, "body")
            title:SetTextColor(C.accent.r, C.accent.g, C.accent.b)
            title:SetText(section.title)
            title._colorType = "accent"

            yOffset = yOffset - (title:GetStringHeight() or 14) - 6

            -- Bullet points
            for _, line in ipairs(section.lines) do
                local text
                if type(line) == "function" then
                    local ok, result = pcall(line)
                    text = (ok and type(result) == "string") and result or ""
                else
                    text = line or ""
                end
                local bullet = AcquireFont()
                bullet:SetPoint("TOPLEFT", 22, yOffset)
                bullet:SetPoint("TOPRIGHT", -12, yOffset)
                bullet:SetJustifyH("LEFT")
                bullet:SetWordWrap(true)
                VE.Theme.ApplyFont(bullet, C, "small")
                bullet:SetTextColor(C.text.r, C.text.g, C.text.b)
                bullet:SetText("- " .. text)
                bullet._colorType = "text"

                yOffset = yOffset - (bullet:GetStringHeight() or 12) - 3
            end

            -- Spacing between sections
            yOffset = yOffset - 8

            -- Divider line (except after last section)
            if sectionIdx < #GUIDE_SECTIONS then
                local divider = AcquireTexture()
                divider:SetPoint("TOPLEFT", 12, yOffset)
                divider:SetPoint("TOPRIGHT", -12, yOffset)
                divider:SetHeight(1)
                divider:SetColorTexture(C.border.r, C.border.g, C.border.b, 0.3)
                yOffset = yOffset - 8
            end
        end

        scrollContent:SetHeight(math.abs(yOffset) + 10)
    end

    -- ========================================================================
    -- THEME UPDATE
    -- ========================================================================

    function container:ApplyTheme()
        ApplyPanelColors()
        self:BuildGuide()
    end

    VE.EventBus:Register("VE_STATE_CHANGED", function(payload)
        if payload.action == "SET_CONFIG" and payload.state.config.theme then
            container:ApplyTheme()
        end
    end)

    container:SetScript("OnShow", function()
        container:BuildGuide()
    end)

    return container
end
