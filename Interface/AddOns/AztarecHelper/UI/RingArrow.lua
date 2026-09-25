-- Azta'rec Helper, copyright 2026 Rothirr, all rights reserved.
-- Read it if you want. Copying any of it into another addon is theft, and
-- running it through an AI tool first does not change that. The timings and
-- coordinates were measured by hand. Nothing here is licensed to anyone.

local _, AZT = ...

-- The compass arrow that turns with the world. The game still turns the
-- minimap compass ring with the player in the delve, and after the hotfix
-- only reading its angle and swapping its art are closed. So the ring itself
-- is lent into the arrow window and made to show the silver party arrow that
-- sits on the same sheet as the ring, through its texcoords, turned to the
-- safe quarter's direction inside the ring's own turning. Its angle is never
-- read. The minimap gets the ring back, rotation setting and all, whenever
-- the arrow stops pointing.

local RingArrow = {}
AZT.RingArrow = RingArrow

local ring = MinimapCompassTexture
local held -- how the ring sat on the minimap before it was lent
local lastQ, lastRGB, lastAlpha, lastLook -- what it shows now, so an unchanged tick costs nothing

-- The ring is set by atlas, so its texcoords run 0 to 1 over the atlas rect
-- only, x 1 to 439 and y 58 to 518 of its 512 by 1024 file, and go on past
-- it into the rest of the sheet. Both looks point up, as u0, u1, v0, v1:
-- silver is the party arrow at x 443 to 500, y 177 to 234, boxed square so
-- it keeps its shape. Chevron is the ring's own north mark, a thin strip
-- stretched tall the way it was found by hand
local LOOKS = {
    silver = { (443 - 1) / 438, (500 - 1) / 438, (177 - 58) / 460, (234 - 58) / 460 },
    chevron = { 0.33, 0.67, 0.006, 0.074 },
}

-- a quarter is a compass direction since the room is read north up, so
-- the arrow picture is turned that many quarter turns clockwise
local QUARTER_TURNS = { N = 0, E = 1, S = 2, W = 3 }

-- Minimap skins hide the ring, Leatrix's square map among them, and SexyMap
-- swaps the texture's own Show for Hide. Lending the ring out of the minimap
-- already leaves a hidden minimap or cluster behind, and the real Show off
-- the frame metatable, which no addon can shadow, gets past the rest
local function realShow()
    local mt = getmetatable(ring)
    local show = mt and type(mt.__index) == "table" and mt.__index.Show or ring.Show
    show(ring)
end

-- one quarter turn clockwise hands each corner the point its neighbour
-- showed. Corner order is UL, LL, UR, LR
local function turned(n, ulx, uly, llx, lly, urx, ury, lrx, lry)
    if n == 0 then
        return ulx, uly, llx, lly, urx, ury, lrx, lry
    end
    return turned(n - 1, llx, lly, lrx, lry, ulx, uly, urx, ury)
end

local function take(spot)
    if held then
        return
    end
    held = {
        parent = ring:GetParent(),
        w = ring:GetWidth(),
        h = ring:GetHeight(),
        points = {},
        coords = { ring:GetTexCoord() },
        color = { ring:GetVertexColor() },
        alpha = ring:GetAlpha(),
        layer = { ring:GetDrawLayer() },
        shown = ring:IsShown(),
    }
    for i = 1, ring:GetNumPoints() do
        held.points[i] = { ring:GetPoint(i) }
    end
    ring:SetParent(spot:GetParent())
    ring:SetDrawLayer("ARTWORK")
    ring:ClearAllPoints()
    ring:SetAllPoints(spot)
    -- the ring only turns while the minimap rotates. rotateLent rides the
    -- saved varaibles so a crash still hands it back at login
    if not C_CVar.GetCVarBool("rotateMinimap") then
        C_CVar.SetCVar("rotateMinimap", "1")
        AztarecHelperDB.rotateLent = true
    end
end

-- Points the ring's silver arrow at quarter q from where the arrow art
-- would sit, in the colour and brightness given. Nothing to point at
-- answers false so the caller can fall back
function RingArrow.Point(spot, q, rgb, alpha)
    local n = QUARTER_TURNS[q]
    if not (ring and n) then
        return false
    end
    -- a skin that hides the ring again on its own schedule gets undone on
    -- the next tick
    local look = LOOKS[AztarecHelperDB.compassLook] or LOOKS.silver
    if q == lastQ and rgb == lastRGB and alpha == lastAlpha and look == lastLook and ring:IsShown() then
        return true
    end
    take(spot)
    local u0, u1, v0, v1 = unpack(look)
    ring:SetTexCoord(turned(n, u0, v0, u0, v1, u1, v0, u1, v1))
    ring:SetVertexColor(rgb[1], rgb[2], rgb[3], 1)
    ring:SetAlpha(alpha)
    realShow()
    lastQ, lastRGB, lastAlpha, lastLook = q, rgb, alpha, look
    return true
end

-- between waves the arrow blanks without handing the ring back, so the
-- minimap is not flipped in and out of rotating every echo
function RingArrow.Blank()
    if held and lastQ then
        ring:SetAlpha(0)
        lastQ, lastRGB = nil, nil
    end
end

function RingArrow.Release()
    if not held then
        return
    end
    ring:SetParent(held.parent)
    ring:SetDrawLayer(unpack(held.layer))
    ring:ClearAllPoints()
    for _, p in ipairs(held.points) do
        ring:SetPoint(unpack(p))
    end
    ring:SetSize(held.w, held.h)
    ring:SetTexCoord(unpack(held.coords))
    ring:SetVertexColor(unpack(held.color))
    ring:SetAlpha(held.alpha)
    ring:SetShown(held.shown)
    held, lastQ, lastRGB = nil, nil, nil
    if AztarecHelperDB.rotateLent then
        AztarecHelperDB.rotateLent = nil
        C_CVar.SetCVar("rotateMinimap", "0")
    end
end
