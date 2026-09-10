local _, ns = ...
local L = ns.L

local Anchoring = {}
ns.Anchoring = Anchoring

local LEM = ns.LibEQOL.EditMode

local NONE = "NONE"
Anchoring.NONE = NONE

local watchedFrames = setmetatable({}, { __mode = "k" })
local pointHookedFrames = setmetatable({}, { __mode = "k" })
local anchorApplyInProgress = setmetatable({}, { __mode = "k" })
local anchorApplyQueued = setmetatable({}, { __mode = "k" })
local nativePoints = setmetatable({}, { __mode = "k" })
local appliedConfigKeys = setmetatable({}, { __mode = "k" })

-- Native Blizzard viewers use a separate config key from custom CMC frames, but
-- share the same direct anchor enforcement path.
local NATIVE_VIEWER_CONFIGS = {
    EssentialCooldownViewer = "nativeEssential",
    UtilityCooldownViewer = "nativeUtility",
    BuffIconCooldownViewer = "nativeBuffIcons",
    BuffBarCooldownViewer = "nativeBuffBar",
}
Anchoring.NATIVE_VIEWER_CONFIGS = NATIVE_VIEWER_CONFIGS

local function RequestSettingsRefresh()
    LEM.internal:RequestRefreshSettings()
end

local STANDARD_TARGETS = {
    { value = "PlayerFrame", label = L["Player Frame"] },
    { value = "TargetFrame", label = L["Target Frame"] },
    { value = "FocusFrame", label = L["Focus Frame"] },
    { value = "PersonalResourceDisplayFrame", label = L["Personal Resource Display"] },
    { value = "EssentialCooldownViewer", label = L["Essential Viewer"] },
    { value = "UtilityCooldownViewer", label = L["Utility Viewer"] },
    { value = "BuffIconCooldownViewer", label = L["Buff Icon Viewer"] },
    { value = "BuffBarCooldownViewer", label = L["Buff Bar Viewer"] },
}

-- EQoL is not ready yet - frame is always present
local ADDON_UNIT_FRAME_TARGETS = {
    { value = "EQOLUFPlayerFrame", label = "EQoL Player Frame" },
    { value = "EQOLUFTargetFrame", label = "EQoL Target Frame" },
    { value = "EQOLUFFocusFrame", label = "EQoL Focus Frame" },
    { value = "MSUF_player", label = "MSUF Player Frame" },
    { value = "MSUF_target", label = "MSUF Target Frame" },
    { value = "MSUF_focus", label = "MSUF Focus Frame" },
    { value = "EllesmereUIUnitFrames_Player", label = "Ellesmere " .. L["Player Frame"] },
    { value = "EllesmereUIUnitFrames_Target", label = "Ellesmere " .. L["Target Frame"] },
    { value = "EllesmereUIUnitFrames_Focus", label = "Ellesmere " .. L["Focus Frame"] },
}

local ANCHOR_POINTS = {
    { text = L["Top Left"], value = "TOPLEFT" },
    { text = L["Top"], value = "TOP" },
    { text = L["Top Right"], value = "TOPRIGHT" },
    { text = L["Left"], value = "LEFT" },
    { text = L["Center"], value = "CENTER" },
    { text = L["Right"], value = "RIGHT" },
    { text = L["Bottom Left"], value = "BOTTOMLEFT" },
    { text = L["Bottom"], value = "BOTTOM" },
    { text = L["Bottom Right"], value = "BOTTOMRIGHT" },
}

---@param configKey string
---@return CMCAnchorConfig?
local function EnsureConfig(configKey)
    local editMode = ns.db.profile.editMode
    local frameCfg = editMode and editMode[configKey]
    if not frameCfg then
        return nil
    end
    if not frameCfg.anchor then
        frameCfg.anchor = { to = NONE, point = "CENTER", relativePoint = "CENTER", x = 0, y = 0 }
    end
    return frameCfg.anchor
end
Anchoring.EnsureConfig = EnsureConfig

-- Maps a CMC frame name back to its anchor config, used for cycle detection through
-- chains of custom trackers / buff containers.
local WouldCycle

local function AnchorConfigForFrameName(name)
    if not name then
        return nil
    end
    local editMode = ns.db.profile.editMode
    if not editMode then
        return nil
    end
    local nativeConfigKey = NATIVE_VIEWER_CONFIGS[name]
    if nativeConfigKey then
        local nativeConfig = editMode[nativeConfigKey]
        return nativeConfig and nativeConfig.anchor
    end
    local ti = name:match("^CMCTracker(%d+)$")
    if ti then
        local c = editMode["tracker" .. ti]
        return c and c.anchor
    end
    local bi = name:match("^CMCBuffContainer(%d+)$")
    if bi then
        local c = editMode["buffContainer" .. bi]
        return c and c.anchor
    end
    return nil
end

-- Detects whether anchoring selfFrameName to targetName would form a cycle through our
-- own frame chain (e.g. tracker 2 -> tracker 1 -> tracker 2). WoW errors on circular
-- SetPoint dependencies, so we bail to the stored position instead.
WouldCycle = function(selfFrameName, targetName)
    if not selfFrameName then
        return false
    end
    local visited = {}
    local cur = targetName
    while cur and cur ~= NONE and not visited[cur] do
        if cur == selfFrameName then
            return true
        end
        visited[cur] = true
        local cfg = AnchorConfigForFrameName(cur)
        cur = cfg and cfg.to
    end
    return false
end

-- True when the frame is configured to anchor to something other than None (whether or
-- not that target currently exists). Callers use this to skip the normal UIParent
-- positioning path.
function Anchoring:HasTarget(configKey)
    if not ns.db or not ns.db.profile then
        return false
    end
    local editMode = ns.db.profile.editMode
    local frameCfg = editMode and editMode[configKey]
    local cfg = frameCfg and frameCfg.anchor
    return (cfg and cfg.to and cfg.to ~= NONE) or false
end

function Anchoring:IsAnchorAnythingActive(frame)
    return frame and frame.anchorAythingActive == true
end

function Anchoring:WatchFrame(frame, configKey)
    if not frame or not configKey then
        return
    end

    watchedFrames[frame] = configKey
    if pointHookedFrames[frame] then
        return
    end
    pointHookedFrames[frame] = true

    hooksecurefunc(frame, "SetPoint", function(changedFrame)
        if anchorApplyInProgress[changedFrame] or Anchoring:IsAnchorAnythingActive(changedFrame) then
            return
        end

        local watchedConfigKey = watchedFrames[changedFrame]
        if not watchedConfigKey then
            return
        end
        if not Anchoring:HasTarget(watchedConfigKey) then
            Anchoring:ReleaseAnchor(changedFrame, watchedConfigKey)
            return
        end
        if anchorApplyQueued[changedFrame] then
            return
        end

        anchorApplyQueued[changedFrame] = true
        C_Timer.After(0, function()
            anchorApplyQueued[changedFrame] = nil
            if not Anchoring:IsAnchorAnythingActive(changedFrame) then
                Anchoring:ApplyAnchor(changedFrame, watchedConfigKey)
            end
        end)
    end)
end

function Anchoring:ReleaseAnchor(frame, configKey)
    if not frame or appliedConfigKeys[frame] ~= configKey or self:IsAnchorAnythingActive(frame) then
        return false
    end
    if InCombatLockdown() and frame.IsProtected and frame:IsProtected() then
        return false
    end

    local points = nativePoints[frame]
    appliedConfigKeys[frame] = nil
    nativePoints[frame] = nil
    if not points then
        return false
    end

    anchorApplyInProgress[frame] = true
    frame:ClearAllPoints()
    for _, point in ipairs(points) do
        frame:SetPoint(unpack(point))
    end
    anchorApplyInProgress[frame] = nil
    return true
end

-- Applies the configured anchor to the frame. Returns true when it actually anchored
-- (target resolves and no cycle). A configured anchor keeps ownership even while its
-- target is temporarily unavailable. Does not touch scale/alpha/strata.
function Anchoring:ApplyAnchor(frame, configKey)
    local editMode = ns.db.profile.editMode
    local frameCfg = editMode and editMode[configKey]
    local cfg = frameCfg and frameCfg.anchor
    if not cfg or not cfg.to or cfg.to == NONE then
        return false
    end
    self:WatchFrame(frame, configKey)
    if self:IsAnchorAnythingActive(frame) then
        return false
    end
    if InCombatLockdown() and frame.IsProtected and frame:IsProtected() then
        return false
    end
    local target = _G[cfg.to]
    if not target or target == frame then
        return false
    end
    if WouldCycle(frame:GetName(), cfg.to) then
        return false
    end
    local point, relativeTo, relativePoint, x, y = cfg.point or "CENTER", target, cfg.relativePoint or "CENTER", cfg.x or 0, cfg.y or 0
    local currentPoint, currentRelativeTo, currentRelativePoint, currentX, currentY = frame:GetPoint(1)
    if
        frame:GetNumPoints() == 1
        and currentPoint == point
        and currentRelativeTo == relativeTo
        and currentRelativePoint == relativePoint
        and math.abs((currentX or 0) - x) <= 0.01
        and math.abs((currentY or 0) - y) <= 0.01
    then
        appliedConfigKeys[frame] = configKey
        return true
    end

    if appliedConfigKeys[frame] ~= configKey then
        local points = {}
        for index = 1, frame:GetNumPoints() do
            points[index] = { frame:GetPoint(index) }
        end
        nativePoints[frame] = points
    end

    anchorApplyInProgress[frame] = true
    frame:ClearAllPoints()
    frame:SetPoint(point, relativeTo, relativePoint, x, y)
    anchorApplyInProgress[frame] = nil
    appliedConfigKeys[frame] = configKey
    return true
end

-- Builds the Anchor To dropdown option list for a frame, honoring which pools the
-- caller allows and excluding the frame itself. Rebuilt on demand (via the dropdown
-- generator) so newly auto-grown trackers/containers appear immediately.
function Anchoring:BuildTargetValues(selfFrameName, opts)
    opts = opts or {}
    local out = { { value = NONE, text = L["None (Edit Mode position)"] } }

    for _, t in ipairs(STANDARD_TARGETS) do
        if t.value ~= selfFrameName and _G[t.value] then
            out[#out + 1] = { value = t.value, text = t.label }
        end
    end

    for _, t in ipairs(ADDON_UNIT_FRAME_TARGETS) do
        if t.value ~= selfFrameName and _G[t.value] then
            out[#out + 1] = { value = t.value, text = t.label }
        end
    end

    local count = (ns.TrackerItemViewer and ns.TrackerItemViewer:GetTrackerCount()) or ns.db.profile.tracker_count or 0
    for i = 1, count do
        local name = "CMCTracker" .. i
        if name ~= selfFrameName and _G[name] then
            out[#out + 1] = { value = name, text = string.format(L["Custom Tracker %d"], i) }
        end
    end

    local buffCount = (ns.BuffData and ns.BuffData.GetContainerCount()) or 0
    for i = 1, buffCount do
        local name = "CMCBuffContainer" .. i
        if name ~= selfFrameName and _G[name] then
            out[#out + 1] = { value = name, text = string.format(L["Custom Buffs %d"], i) }
        end
    end

    return out
end

-- Returns a list of LEM settings (a collapsible "Anchor" section + its controls) to
-- append to a frame's Edit Mode settings.
--   opts.selfFrameName  frame name to exclude from the target list (required)
--   opts.onChanged      called after any anchor field changes (re-apply + refresh)
function Anchoring:BuildSettings(configKey, opts)
    opts = opts or {}
    local selfFrameName = opts.selfFrameName
    local onChanged = opts.onChanged or function() end

    local function cfg()
        return EnsureConfig(configKey)
    end

    local function isAnchored()
        local c = cfg()
        return c and c.to and c.to ~= NONE
    end

    local settings = {
        {
            kind = LEM.SettingType.Collapsible,
            id = "anchor",
            name = L["Anchor"],
            defaultCollapsed = true,
        },
        {
            name = L["Anchor To"],
            parentId = "anchor",
            kind = LEM.SettingType.Dropdown,
            default = NONE,
            get = function()
                return cfg().to or NONE
            end,
            set = function(_layoutName, value)
                cfg().to = value
                onChanged()
                RequestSettingsRefresh()
            end,
            generator = function(_owner, rootDescription)
                for _, v in ipairs(Anchoring:BuildTargetValues(selfFrameName, opts)) do
                    local val = v.value
                    rootDescription:CreateRadio(v.text, function()
                        return (cfg().to or NONE) == val
                    end, function()
                        cfg().to = val
                        onChanged()
                        RequestSettingsRefresh()
                    end)
                end
            end,
        },
        {
            name = L["Anchor Point"],
            parentId = "anchor",
            kind = LEM.SettingType.Dropdown,
            default = "CENTER",
            isShown = isAnchored,
            values = ANCHOR_POINTS,
            get = function()
                return cfg().point or "CENTER"
            end,
            set = function(_layoutName, value)
                cfg().point = value
                onChanged()
            end,
        },
        {
            name = L["Relative Point"],
            parentId = "anchor",
            kind = LEM.SettingType.Dropdown,
            default = "CENTER",
            isShown = isAnchored,
            values = ANCHOR_POINTS,
            get = function()
                return cfg().relativePoint or "CENTER"
            end,
            set = function(_layoutName, value)
                cfg().relativePoint = value
                onChanged()
            end,
        },
        {
            name = L["X Offset"],
            parentId = "anchor",
            kind = LEM.SettingType.Slider,
            default = 0,
            isShown = isAnchored,
            minValue = -500,
            maxValue = 500,
            valueStep = 1,
            get = function()
                return cfg().x or 0
            end,
            set = function(_layoutName, value)
                cfg().x = value
                onChanged()
            end,
            formatter = function(value)
                return string.format(L["%d px"], value)
            end,
        },
        {
            name = L["Y Offset"],
            parentId = "anchor",
            kind = LEM.SettingType.Slider,
            default = 0,
            isShown = isAnchored,
            minValue = -500,
            maxValue = 500,
            valueStep = 1,
            get = function()
                return cfg().y or 0
            end,
            set = function(_layoutName, value)
                cfg().y = value
                onChanged()
            end,
            formatter = function(value)
                return string.format(L["%d px"], value)
            end,
        },
    }

    return settings
end
