-- ============================================================================
-- Vamoose's Endeavors - Minimap Button & Addon Compartment
-- ============================================================================

VE = VE or {}
VE.Minimap = {}

local Minimap_Module = VE.Minimap

local ADDON_KEY = "VamoosesEndeavors"
local ICON_PATH = "Interface\\AddOns\\VamoosesEndeavors\\Textures\\ve_icon"

local launcher -- LDB data object
local DBIcon   -- LibDBIcon reference

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

    launcher = LDB:NewDataObject(ADDON_KEY, {
        type = "launcher",
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
            tooltip:AddLine("|cFFFFFFFFLeft-click:|r Toggle window", 0.7, 0.7, 0.7)
            tooltip:AddLine("|cFFFFFFFFDrag:|r Move button", 0.7, 0.7, 0.7)
        end,
    })

    -- Legacy scrub: pre-LibDBIcon VE persisted showInCompartment=true in
    -- VE_DB.minimap. LibDBIcon v55 reads that flag at Register and adds its
    -- own compartment entry (raw "VamoosesEndeavors" name + the launcher
    -- tooltip's Drag line) alongside the TOC-registered one -- the duplicate
    -- reported on CurseForge #8049631. The compartment entry is TOC-owned now.
    VE_DB.minimap.showInCompartment = nil

    DBIcon = LibStub("LibDBIcon-1.0", true)
    if DBIcon then
        DBIcon:Register(ADDON_KEY, launcher, VE_DB.minimap)
        self:UpdateVisibility()
    end
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
    GameTooltip:AddLine("|cFFFFFFFFClick:|r Toggle window", 0.7, 0.7, 0.7)
    GameTooltip:Show()
end

function VE_OnAddonCompartmentLeave()
    GameTooltip:Hide()
end

-- No-op: LDB object is created in Initialize now
function Minimap_Module:RegisterLDB() end
