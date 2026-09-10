local ADDON_NAME, namespace = ...
local DST = namespace.DST
local AF = namespace.AF
local L = namespace.L or {}

local function InCombat()
    return InCombatLockdown and InCombatLockdown()
end

local function CopyTableSafe(src)
    if type(src) ~= "table" then return nil end
    if _G.CopyTable and type(_G.CopyTable) == "function" then return _G.CopyTable(src) end
    local t = {}
    for k, v in pairs(src) do t[k] = v end
    return t
end

local function DeepMergeDefaults(target, defaults)
    for k, v in pairs(defaults) do
        if target[k] == nil then
            target[k] = type(v) == "table" and CopyTableSafe(v) or v
        elseif type(v) == "table" and type(target[k]) == "table" then
            DeepMergeDefaults(target[k], v)
        end
    end
end

local function Locale(key)
    local value = L[key]
    return (value ~= nil) and value or key
end

local function StripColorCodes(text)
    if not text or text == "" then return "" end
    return text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|cn[%w_]+:", ""):gsub("|A:[^|]+|a", ""):gsub("|T[^|]+|t", "")
end

-- Call a Blizzard API function without propagating addon taint.
-- securecallfunction (WoW 10.0.2+) executes the target in a secure context so
-- Blizzard internals never attribute the call to our addon.  Used for both
-- C_UIWidgetManager reads and UI panel operations (ToggleWorldMap, SetMapID)
-- to prevent "secret number tainted by ..." and ADDON_ACTION_BLOCKED errors.
local function SecureWidgetCall(func, ...)
    if not func then return nil end
    if securecallfunction then
        return securecallfunction(func, ...)
    end
    return func(...)
end

namespace.InCombat = InCombat
namespace.CopyTableSafe = CopyTableSafe
namespace.DeepMergeDefaults = DeepMergeDefaults
namespace.Locale = Locale
namespace.StripColorCodes = StripColorCodes
namespace.SecureWidgetCall = SecureWidgetCall

-- ---------------------------------------------------------------------------
-- Addon-owned tooltip (never GameTooltip)
-- Using AF.Tooltip / GameTooltip from addon code taints Blizzard's shared
-- tooltip; POI/widget layouts in instances (delves) then error with
-- "secret number value tainted by ..." when comparing layout metrics.
-- ---------------------------------------------------------------------------

local addonTooltipFrame

local function GetAddonTooltipFrame()
    if addonTooltipFrame then
        return addonTooltipFrame
    end
    local f = CreateFrame("Frame", "DelveSpeedTrackerAddonTooltip", UIParent, "BackdropTemplate")
    f:SetFrameStrata("TOOLTIP")
    f:SetFrameLevel(2000)
    f:SetClampedToScreen(true)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    f:SetBackdropColor(0, 0, 0, 0.9)
    f.lines = {}
    local maxLines = 12
    f.maxLines = maxLines
    for i = 1, maxLines do
        local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fs:SetJustifyH("LEFT")
        fs:SetJustifyV("TOP")
        fs:SetNonSpaceWrap(true)
        f.lines[i] = fs
    end
    addonTooltipFrame = f
    return f
end

--- Hide the addon tooltip frame (safe to call anytime).
function namespace.HideAddonTooltip()
    if addonTooltipFrame then
        addonTooltipFrame:Hide()
    end
end

--- lineSpecs: array of { text = string, r, g, b, size = number? }
--- Anchors tooltip pointFrom on anchorFrame at pointTo with offsets.
--- @return Frame|nil the tooltip frame (for reposition helpers)
function namespace.ShowAddonTooltip(anchorFrame, pointFrom, pointTo, ox, oy, lineSpecs, borderR, borderG, borderB)
    if not anchorFrame or not lineSpecs or #lineSpecs == 0 then
        return nil
    end

    local GetLocaleFont = namespace.GetLocaleFont
    local ApplyTextStyle = namespace.ApplyTextStyle
    local fontPath = (GetLocaleFont and GetLocaleFont()) or "Fonts\\FRIZQT__.TTF"
    local fontFlag = ""
    local DST = namespace.DST
    if DST and DST.GetTextFontFlagString then
        fontFlag = DST:GetTextFontFlagString()
    end

    local TOOLTIP_TEXT_WIDTH = 280
    local PAD = 8
    local GAP = 4

    borderR = borderR ~= nil and borderR or 0.5
    borderG = borderG ~= nil and borderG or 0.5
    borderB = borderB ~= nil and borderB or 0.5

    local f = GetAddonTooltipFrame()
    f:SetBackdropBorderColor(borderR, borderG, borderB, 1)

    local n = #lineSpecs
    if n > f.maxLines then
        n = f.maxLines
    end

    for i = 1, f.maxLines do
        local fs = f.lines[i]
        if i <= n then
            local spec = lineSpecs[i]
            local text = spec.text
            local r = spec.r ~= nil and spec.r or 1
            local g = spec.g ~= nil and spec.g or 1
            local b = spec.b ~= nil and spec.b or 1
            local size = spec.size or 13
            fs:SetFont(fontPath, size, fontFlag)
            fs:SetWidth(TOOLTIP_TEXT_WIDTH)
            fs:SetText(text or "")
            fs:SetTextColor(r, g, b)
            if ApplyTextStyle then
                ApplyTextStyle(fs)
            end
            fs:Show()
        else
            fs:Hide()
        end
    end

    local y = -PAD
    for i = 1, n do
        local fs = f.lines[i]
        fs:ClearAllPoints()
        fs:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, y)
        local h = fs:GetStringHeight() or 0
        y = y - h
        if i < n then
            y = y - GAP
        end
    end

    local totalH = -y + PAD
    f:SetSize(TOOLTIP_TEXT_WIDTH + 2 * PAD, totalH)

    f:ClearAllPoints()
    f:SetPoint(pointFrom, anchorFrame, pointTo, ox or 0, oy or 0)
    f:Show()
    f:Raise()

    return f
end
