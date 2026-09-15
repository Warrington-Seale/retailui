-- ============================================================================
-- Vamoose's Endeavors - Minimap Button, Addon Compartment & Data Broker
-- ============================================================================

VE = VE or {}
VE.Minimap = {}

local Minimap_Module = VE.Minimap

local ADDON_KEY = "VamoosesEndeavors"
local ICON_PATH = "Interface\\AddOns\\VamoosesEndeavors\\Textures\\ve_icon"
local BROKER_NO_HOUSE_TEXT = "--"

local dataObject -- LDB data object (data source: minimap button + broker displays)
local DBIcon     -- LibDBIcon reference

-- ============================================================================
-- SELECTED HOUSE READOUT
-- The house selected in VE's dropdown and its endeavor progress, shared by the
-- broker text and the minimap / compartment tooltips.
--
-- The house list is NOT requested at login (see EndeavorTracker's
-- PLAYER_ENTERING_WORLD note -- it blanked Blizzard's dashboard). Until the VE
-- window or the Housing Dashboard asks for it there is no house to name.
-- ============================================================================

-- Mirrors the house dropdown's label so the readout and the window agree.
local function SelectedHouseName()
    local index = VE.EndeavorTracker:GetSelectedHouseIndex()
    local house = VE.EndeavorTracker:GetHouseList()[index]
    if not house then return nil end -- exception(nullable): house list not loaded this session
    -- exception(boundary): C_Housing houseName is 0 (number) for unnamed houses
    local name = type(house.houseName) == "string" and house.houseName ~= "" and house.houseName
    return name or ("House " .. index)
end

-- Returns pct, current, max -- or nil when maxProgress is 0 (data still in
-- flight, the selected house isn't the active endeavor, or the neighborhood is
-- between endeavors). pct caps at 100: currentProgress keeps counting past
-- maxProgress, and VE's progress bar treats anything at or past max as done.
local function SelectedProgress()
    local endeavor = VE.Store:GetState().endeavor
    if endeavor.maxProgress <= 0 then return nil end
    local pct = math.min(100, math.floor(endeavor.currentProgress / endeavor.maxProgress * 100))
    return pct, endeavor.currentProgress, endeavor.maxProgress
end

local function BuildBrokerText()
    local houseName = SelectedHouseName()
    if not houseName then return BROKER_NO_HOUSE_TEXT end
    local pct = SelectedProgress()
    if not pct then return houseName end
    return ("%s - %d%%"):format(houseName, pct)
end

local function AddSelectedHouseLines(tooltip)
    local houseName = SelectedHouseName()
    if not houseName then
        tooltip:AddLine("Open the window to load your house", 0.7, 0.7, 0.7)
        return
    end
    tooltip:AddDoubleLine("House:", houseName, 0.7, 0.7, 0.7, 1, 1, 1)
    local pct, current, max = SelectedProgress()
    if not pct then return end
    local progress = current >= max and "Complete" or ("%d / %d (%d%%)"):format(current, max, pct)
    tooltip:AddDoubleLine("Progress:", progress, 0.7, 0.7, 0.7, 1, 1, 1)
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

function Minimap_Module:Initialize()
    -- Ensure minimap savedvars table exists (LibDBIcon reads/writes minimapPos, hide, lock)
    VE_DB = VE_DB or {}
    if not VE_DB.minimap then
        VE_DB.minimap = {
            minimapPos = 200,
            hide = false,
            lock = false,
        }
    end

    if not LibStub then return end

    local LDB = LibStub("LibDataBroker-1.1", true)
    if not LDB then return end

    dataObject = LDB:NewDataObject(ADDON_KEY, {
        type = "data source",
        text = BROKER_NO_HOUSE_TEXT,
        icon = ICON_PATH,
        label = "Vamoose's Endeavors",
        OnClick = function(_, button)
            if button == "LeftButton" then
                VE:Toggle()
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("|cFF2aa198Vamoose's Endeavors|r")
            tooltip:AddLine("Track Housing Endeavor progress", 0.7, 0.7, 0.7)
            tooltip:AddLine(" ")
            AddSelectedHouseLines(tooltip)
            tooltip:AddLine(" ")
            tooltip:AddLine("|cFFFFFFFFLeft-click:|r Toggle window", 0.7, 0.7, 0.7)
            tooltip:AddLine("|cFFFFFFFFDrag:|r Move button", 0.7, 0.7, 0.7)
        end,
    })

    -- Selection changes land as a dispatch (SelectHouse clears tasks,
    -- SET_HOUSE_GUID) or a house-list event (list arrival, dashboard sync);
    -- progress lands as SET_ENDEAVOR_INFO. LDB drops unchanged writes, so the
    -- per-dispatch refresh costs a string format and nothing downstream.
    self:RefreshBrokerText()
    VE.EventBus:Register("VE_STATE_CHANGED", function() self:RefreshBrokerText() end)
    VE.EventBus:Register("VE_HOUSE_LIST_UPDATED", function() self:RefreshBrokerText() end)

    -- Legacy scrub: pre-LibDBIcon VE persisted showInCompartment=true in
    -- VE_DB.minimap. LibDBIcon v55 reads that flag at Register and adds its
    -- own compartment entry (raw "VamoosesEndeavors" name + the data object
    -- tooltip's Drag line) alongside the TOC-registered one -- the duplicate
    -- reported on CurseForge #8049631. The compartment entry is TOC-owned now.
    VE_DB.minimap.showInCompartment = nil

    DBIcon = LibStub("LibDBIcon-1.0", true)
    if DBIcon then
        DBIcon:Register(ADDON_KEY, dataObject, VE_DB.minimap)
        self:UpdateVisibility()
    end
end

-- ============================================================================
-- DATA BROKER READOUT
-- "<selected house> - <endeavor progress>%" for Titan-style broker displays.
-- Displays differ on which field they read, so text and value carry the same
-- string.
-- ============================================================================

function Minimap_Module:RefreshBrokerText()
    local text = BuildBrokerText()
    dataObject.text = text
    dataObject.value = text
end

-- ============================================================================
-- VISIBILITY CONTROLS
-- ============================================================================

function Minimap_Module:UpdateVisibility()
    if not DBIcon or not DBIcon:IsRegistered(ADDON_KEY) then return end

    local storeConfig = VE.Store and VE.Store:GetState() and VE.Store:GetState().config
    local show = storeConfig and storeConfig.showMinimapButton
    if show == nil then
        show = VE_DB.minimap and not VE_DB.minimap.hide
    end

    if show then
        DBIcon:Show(ADDON_KEY)
    else
        DBIcon:Hide(ADDON_KEY)
    end
end

function Minimap_Module:Show()
    if DBIcon and DBIcon:IsRegistered(ADDON_KEY) then
        if VE_DB.minimap then VE_DB.minimap.hide = false end
        if VE.Store then
            VE.Store:Dispatch("SET_CONFIG", { key = "showMinimapButton", value = true })
        end
        DBIcon:Show(ADDON_KEY)
    end
end

function Minimap_Module:Hide()
    if DBIcon and DBIcon:IsRegistered(ADDON_KEY) then
        if VE_DB.minimap then VE_DB.minimap.hide = true end
        if VE.Store then
            VE.Store:Dispatch("SET_CONFIG", { key = "showMinimapButton", value = false })
        end
        DBIcon:Hide(ADDON_KEY)
    end
end

function Minimap_Module:Toggle()
    if DBIcon and DBIcon:IsRegistered(ADDON_KEY) then
        local btn = DBIcon:GetMinimapButton(ADDON_KEY)
        if btn and btn:IsShown() then
            self:Hide()
        else
            self:Show()
        end
    end
end

-- No-op: LibDBIcon owns all positioning now
function Minimap_Module:UpdatePosition() end

-- ============================================================================
-- ADDON COMPARTMENT (referenced by TOC AddonCompartmentFunc directives).
-- Blizzard registers the entry from the TOC at PLAYER_ENTERING_WORLD using
-- ## Title as the text and ## IconTexture as the icon (HDG pattern).
-- ============================================================================

function VE_OnAddonCompartmentClick(_, buttonName)
    if buttonName == "LeftButton" then
        VE:Toggle()
    end
end

function VE_OnAddonCompartmentEnter(_, menuItem)
    GameTooltip:SetOwner(menuItem, "ANCHOR_RIGHT")
    GameTooltip:AddLine("|cFF2aa198Vamoose's Endeavors|r", 1, 1, 1)
    GameTooltip:AddLine("Track Housing Endeavor progress", 0.7, 0.7, 0.7)
    GameTooltip:AddLine(" ")
    AddSelectedHouseLines(GameTooltip)
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("|cFFFFFFFFClick:|r Toggle window", 0.7, 0.7, 0.7)
    GameTooltip:Show()
end

function VE_OnAddonCompartmentLeave()
    GameTooltip:Hide()
end

-- No-op: LDB object is created in Initialize now
function Minimap_Module:RegisterLDB() end
