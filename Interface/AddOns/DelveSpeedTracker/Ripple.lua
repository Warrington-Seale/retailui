local ADDON_NAME, namespace = ...
local DST = namespace.DST
local AF = namespace.AF
local InCombat = namespace.InCombat
local SecureCall = namespace.SecureWidgetCall

local TOMTOM_FROM = "DelveSpeedTracker"

local function ClearTomTomWaypointsFromAddon()
    local TomTom = _G.TomTom
    if not TomTom or type(TomTom.RemoveWaypoint) ~= "function" or not TomTom.waypoints then return end
    local toRemove = {}
    for mapId, entries in pairs(TomTom.waypoints) do
        for _, uid in pairs(entries) do
            if uid and uid.from == TOMTOM_FROM then
                toRemove[#toRemove + 1] = uid
            end
        end
    end
    for _, uid in ipairs(toRemove) do
        TomTom:RemoveWaypoint(uid)
    end
end

local function TrySetTomTomWaypoint(zoneMapId, x, y, title)
    if not zoneMapId or type(x) ~= "number" or type(y) ~= "number" then return end
    if DelveSpeedTrackerDB and DelveSpeedTrackerDB.tomtomArrowsEnabled == false then return end
    if x > 1 or y > 1 then x, y = x / 100, y / 100 end
    local TomTom = _G.TomTom
    if not TomTom or type(TomTom.AddWaypoint) ~= "function" then return end
    ClearTomTomWaypointsFromAddon()
    TomTom:AddWaypoint(zoneMapId, x, y, {
        title = (type(title) == "string" and title ~= "") and title or "Delve",
        persistent = false,
        silent = true,
        from = TOMTOM_FROM,
    })
end

local DST_RIPPLE_REF = "DelveSpeedTrackerRipple"

local function StopRippleAndUnparentMapHighlight()
    local h = DST.ActiveRipple
    if not h then return end
    DST.ActiveRipple = nil
    h:SetScript("OnUpdate", nil)
    if h._hbdp and h._hbdpRef then
        h._hbdp:RemoveAllWorldMapIcons(h._hbdpRef)
    end
    if h:IsShown() then h:Hide() end
    h:SetParent(UIParent)
    if h.rippleFrames then
        for _, r in pairs(h.rippleFrames) do
            if r and r.SetParent then
                if r:IsShown() then r:Hide() end
                r:SetParent(UIParent)
            end
        end
    end
end

local function CreateAndPlaceRipple(hbdp, zoneMapId, x, y)
    hbdp:RemoveAllWorldMapIcons(DST_RIPPLE_REF)
    StopRippleAndUnparentMapHighlight()

    local numRipples = 4
    local rippleDelay = 0.10
    local duration = 0.55
    local colors = { {0.2, 1, 0.3}, {1, 1, 0.2}, {1, 0.5, 0}, {1, 0.2, 0.2} }

    local function lerpColor(ca, cb, f)
        return ca[1] + (cb[1] - ca[1]) * f, ca[2] + (cb[2] - ca[2]) * f, ca[3] + (cb[3] - ca[3]) * f
    end
    local function colorAt(t)
        local pos = (t / duration) * #colors
        local i = math.floor(pos) % #colors
        local frac = pos % 1
        local c1 = colors[i + 1]
        local c2 = colors[(i + 1) % #colors + 1]
        return lerpColor(c1, c2, frac)
    end
    local function applyRing(frame, t)
        if t < 0 then
            frame:SetScale(4 / 80)
            frame:SetAlpha(0)
            return
        end
        local p = math.min(1, t / duration)
        local easeOut = 1 - (1 - p) * (1 - p)
        frame:SetScale((4 / 80) + (1 - 4 / 80) * easeOut)
        frame:SetAlpha(1 - easeOut)
        if frame.ringTex then
            local r, g, b = colorAt(t)
            frame.ringTex:SetVertexColor(r, g, b, 1)
        end
    end

    local rippleFrame = CreateFrame("Frame", nil, UIParent)
    rippleFrame:SetSize(80, 80)
    local tex = AF.CreateTexture(rippleFrame, AF.GetTexture("Ring"), {1, 1, 1, 1}, "OVERLAY", 0)
    tex:SetAllPoints(rippleFrame)
    rippleFrame.ringTex = tex
    rippleFrame.rippleFrames = { rippleFrame }

    for i = 2, numRipples do
        local rf = CreateFrame("Frame", nil, rippleFrame)
        rf:SetAllPoints(rippleFrame)
        local rt = AF.CreateTexture(rf, AF.GetTexture("Ring"), {1, 1, 1, 1}, "OVERLAY", 0)
        rt:SetAllPoints(rf)
        rf.ringTex = rt
        rippleFrame.rippleFrames[i] = rf
    end

    rippleFrame.animStartTime = GetTime()
    rippleFrame._hbdpRef = DST_RIPPLE_REF
    rippleFrame._hbdp = hbdp
    DST.ActiveRipple = rippleFrame

    rippleFrame:SetScript("OnUpdate", function(self)
        if InCombat() then
            DST.ActiveRipple = nil
            if self._hbdp and self._hbdpRef then self._hbdp:RemoveWorldMapIcon(self._hbdpRef, self) end
            self:SetScript("OnUpdate", nil)
            return
        end
        local t = GetTime() - (self.animStartTime or 0)
        for i = 1, numRipples do
            local frame = (i == 1) and self or self.rippleFrames[i]
            local ti = t - (i - 1) * rippleDelay
            applyRing(frame, ti)
        end
        if t >= (numRipples - 1) * rippleDelay + duration then
            DST.ActiveRipple = nil
            if self._hbdp and self._hbdpRef then self._hbdp:RemoveWorldMapIcon(self._hbdpRef, self) end
            self:SetScript("OnUpdate", nil)
        end
    end)

    rippleFrame:SetScale(4 / 80)
    rippleFrame:SetAlpha(1)
    for i = 2, numRipples do
        rippleFrame.rippleFrames[i]:SetScale(4 / 80)
        rippleFrame.rippleFrames[i]:SetAlpha(0)
    end

    hbdp:AddWorldMapIconMap(DST_RIPPLE_REF, rippleFrame, zoneMapId, x, y, 3)
end

function DST:OpenMapToDelveAndShowRipple(zoneMapId, poiID, waypointTitle, poiNx, poiNy)
    if InCombat() then return end
    local mapShown = WorldMapFrame:IsShown()
    local currentMapId = WorldMapFrame.GetMapID and WorldMapFrame:GetMapID() or nil
    local last = DST.LastClickedMapPoi
    if mapShown and currentMapId == zoneMapId and last and last.mapId == zoneMapId and last.poiID == poiID then
        if ToggleWorldMap then SecureCall(ToggleWorldMap) end
        return
    end
    DST.LastClickedMapPoi = { mapId = zoneMapId, poiID = poiID }
    if not mapShown and ToggleWorldMap then SecureCall(ToggleWorldMap) end
    if WorldMapFrame.SetMapID then SecureCall(WorldMapFrame.SetMapID, WorldMapFrame, zoneMapId) end

    -- Hardening: never query POI/widget state from a row click while the map is up.
    -- Use coordinates pre-cached during safe scans only.
    if type(poiNx) ~= "number" or type(poiNy) ~= "number" then
        return
    end
    if poiNx > 1 or poiNy > 1 then
        poiNx, poiNy = poiNx / 100, poiNy / 100
    end

    if poiNx and poiNy then
        TrySetTomTomWaypoint(zoneMapId, poiNx, poiNy, waypointTitle)
    end

    -- No pin enumeration from map click path; only place ripple from cached coords.
    if not DST.USE_RIPPLE_EFFECT then
        return
    end

    local hbdp = LibStub and LibStub("HereBeDragons-Pins-2.0", true)
    if not hbdp or type(hbdp.AddWorldMapIconMap) ~= "function" then return end
    CreateAndPlaceRipple(hbdp, zoneMapId, poiNx, poiNy)
end

namespace.StopRippleAndUnparentMapHighlight = StopRippleAndUnparentMapHighlight
namespace.ClearTomTomWaypointsFromAddon = ClearTomTomWaypointsFromAddon
