-- Azta'rec Helper, copyright 2026 Rothirr, all rights reserved.
-- Read it if you want. Copying any of it into another addon is theft, and
-- running it through an AI tool first does not change that. The timings and
-- coordinates were measured by hand. Nothing here is licensed to anyone.

local _, AZT = ...

-- The safe-spot arrow. Walks the recorded route through the echoes, showing
-- the move out of the quarter the last wave left you in. The relative
-- reading keeps one colour the whole way, the player's pick, since the
-- encounter hides the moment a wave lands and a colour that changes on a
-- guess is worse than one that does not change at all. The compass reading
-- is the minimap ring turning with the world (RingArrow.lua) and wears the
-- safe quarter's marker colour, which changes on the wave's own schedule
-- and not on a guess. It parks dimmed around the delve out of combat so it
-- can be dragged into place. In combat it only exists while the memory
-- game runs.

local arrowFrame

-- Two ways to read the arrow, and mixing them is what gives people mixed
-- signals. Relative assumes you look at the boss from your quarter, same
-- vocabulary as the spoken cues. Compass drops the assumption and holds
-- north up instead
local TURN_RAD = { stay = math.pi, forward = 0, left = math.pi / 2, right = -math.pi / 2 }
local QUAD_ROT = { N = 0, E = -math.pi / 2, S = math.pi, W = math.pi / 2 }

-- no rgb means the art draws as it was painted, which is gold
AZT.ARROW_COLORS = {
    gold = { label = "Gold", rgb = nil },
    red = { label = "Red", rgb = { 0.95, 0.3, 0.25 } },
    green = { label = "Green", rgb = { 0.3, 0.95, 0.4 } },
    white = { label = "White", rgb = { 1, 1, 1 } },
    cyan = { label = "Cyan", rgb = { 0.35, 0.85, 1 } },
    violet = { label = "Violet", rgb = { 0.78, 0.55, 1 } },
}
AZT.ARROW_ORDER = { "gold", "red", "green", "white", "cyan", "violet" }

function AZT.ArrowColor()
    return AZT.ARROW_COLORS[AztarecHelperDB.arrowColor or "gold"] or AZT.ARROW_COLORS.gold
end

local TURN_SMOOTH = 0.18 -- fraction of the remaining turn applied per tick
local SAFE_HOLD = 1.5 -- an echo overdue by this long means the run stopped, so stop pointing
local UPDATE_HZ = 20 -- pointer refresh rate
local PARK_ALPHA = 0.8 -- parked brightness
local LABEL_LIFT = 9 -- the caption sits this many px above the frame bottom
local TURN_SNAP = 1.8 -- turns bigger than this many radians snap instead of easing
local MARK_SIZE = 44 -- the quarter's mark under the arrow
local WHITE = { 1, 1, 1 } -- the compass arrow is silver, so gold's missing tint leaves it plain

local function buildArrow()
    arrowFrame = CreateFrame("Frame", "AztarecHelperArrow", UIParent)
    arrowFrame:SetSize(96, 142)
    AZT.MakeMovable(arrowFrame, "arrow", "TOP", 0, -100)

    -- our own arrow art. Blizzard's guide arrow blp turned out to carry
    -- baked-in translucency no blend mode gets around, so this ships as a
    -- proper opaque texture instead
    local tex = arrowFrame:CreateTexture(nil, "ARTWORK")
    tex:SetSize(88, 88)
    tex:SetPoint("TOP", 0, -18)
    tex:SetTexture("Interface\\AddOns\\AztarecHelper\\Media\\arrow")
    tex:Hide()

    local label = arrowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("BOTTOM", 0, LABEL_LIFT)
    arrowFrame.label = label

    -- the quarter's mark sits under the arrow
    local function setMark(q)
        label:SetText(q and AZT.QuadName(q, MARK_SIZE) or "")
        label:SetTextColor(1, 1, 1, 1)
    end
    arrowFrame.setMark = setMark
    AZT.AttachLock(arrowFrame, "arrow")
    arrowFrame:Hide()

    -- the colour multiplies onto the desaturated art. Passing none leaves the
    -- art alone, which is how gold stays gold.
    local lastRot, lastAlpha, lastRGB
    local function showPointer(rot, alpha, rgb)
        -- same arrow as last tick, nothing to redraw. It earns its keep
        -- between echoes, where the arrow sits unchanged for seconds.
        if rot == lastRot and alpha == lastAlpha and rgb == lastRGB and tex:IsShown() then
            return
        end
        AZT.RingArrow.Blank()
        if not pcall(tex.SetRotation, tex, rot) then
            tex:Hide()
            lastRot = nil
            return
        end
        lastRot, lastAlpha, lastRGB = rot, alpha, rgb
        tex:SetDesaturated(rgb and true or false)
        if rgb then
            tex:SetVertexColor(rgb[1], rgb[2], rgb[3], alpha)
        else
            tex:SetVertexColor(1, 1, 1, alpha)
        end
        tex:Show()
    end
    local function hidePointer()
        AZT.RingArrow.Blank()
        tex:Hide()
        lastRot = nil
    end
    arrowFrame.showPointer = showPointer

    -- the compass reading: the minimap's own ring shows the arrow in place
    -- of the art and turns with the world. False means the art has to do
    local function pointRing(q, rgb, alpha)
        if not (AztarecHelperDB.arrowCompass and AZT.RingArrow.Point(tex, q, rgb or WHITE, alpha)) then
            return false
        end
        tex:Hide()
        lastRot = nil
        return true
    end
    arrowFrame.pointRing = pointRing

    -- a quarter's marker colour, the arrow colour when it wears none
    local function quadRGB(q)
        local idx = AZT.QuadIcon(q)
        return idx and AZT.MARK_RGB[idx] or AZT.ArrowColor().rgb
    end

    local shownRot = 0

    -- ease toward a new direction so 90 degree corrections glide, but snap
    -- through about-faces since an eased 180 reads as lag
    local function easeTo(rot)
        local delta = (rot - shownRot + math.pi) % (2 * math.pi) - math.pi
        if math.abs(delta) > TURN_SNAP then
            shownRot = rot
        else
            shownRot = shownRot + delta * TURN_SMOOTH
        end
        return shownRot
    end

    local elapsed = 0
    arrowFrame:SetScript("OnUpdate", function(_, dt)
        elapsed = elapsed + dt
        if elapsed < 1 / UPDATE_HZ then
            return
        end
        elapsed = 0
        local w = AZT.Wave
        if w and w.phase == "record" then
            -- the compass arrow stays out of the sermon, except on its last
            -- wave, where it already points where the first echo sends you
            if AztarecHelperDB.arrowCompass then
                local total, first = AZT.Safe.SermonWaves(), AZT.Safe.FirstAnswer()
                if total and w.idx >= total and first and pointRing(first, quadRGB(first), 1) then
                    setMark(first)
                else
                    hidePointer()
                    setMark(nil)
                end
                return
            end
            -- no move to show during the Sermon, so it points at your feet.
            showPointer(easeTo(math.pi), 1, AZT.ArrowColor().rgb)
            setMark(nil)
            return
        end
        local safeNow = AZT.safeNow
        if not safeNow then
            return -- parked, ArrowSync painted the waiting state already
        end
        local list = AZT.safeList
        local blank = not (w and (w.phase == "echo" or w.phase == "replay") and w.idx > 0 and list)
        -- an echo this far overdue means the run stopped, so stop pointing
        -- instead of holding a move nothing is coming for
        if not blank and w.gap and w.startedAt then
            local okG, since = pcall(function()
                return GetTime() - w.startedAt
            end)
            blank = okG and type(since) == "number" and since > w.gap + SAFE_HOLD
        end
        if blank then
            hidePointer()
            setMark(safeNow)
            return
        end
        setMark(safeNow)
        if pointRing(safeNow, quadRGB(safeNow), 1) then
            return
        end
        -- the quarter the last wave left you in is where the move starts
        local fromQ = w.idx > 1 and list[w.idx - 1] or list[#list]
        local rot
        if AztarecHelperDB.arrowCompass then
            rot = QUAD_ROT[safeNow]
        else
            local turn = AZT.Safe.TurnFromTo(fromQ, safeNow)
            rot = turn and TURN_RAD[turn]
        end
        if rot then
            showPointer(easeTo(rot), 1, AZT.ArrowColor().rgb)
        else
            -- an unknown step in the route, nothing honest to point at
            hidePointer()
        end
    end)
end

function AZT.ArrowSync()
    local live = AZT.safeNow ~= nil
    local recording = AZT.Wave and AZT.Wave.phase == "record"
    -- grey and grabbable around the delve out of combat. Once anything says
    -- a fight is on (regen flag, lockdown API, armed encounter) it only
    -- exists while the memory game itself is running.
    local fighting = AZT.Fighting()
    local idleParked = AZT.InDelve() and not fighting
    -- a follower's route is sealed calls with no turn to point, so the whole
    -- arrow locks off while follower mode is on. The player's own arrow
    -- setting stays stored for when they stop following
    local on = AztarecHelperDB.arrow
        and (live or recording or idleParked)
        and not (AZT.Follow and AZT.Follow.Suppress())
    -- the minimap has its ring back the moment the compass arrow is gone
    if not (on and AztarecHelperDB.arrowCompass) then
        AZT.RingArrow.Release()
    end
    if not arrowFrame then
        if not on then
            return
        end
        buildArrow()
    end
    arrowFrame:SetShown(on and true or false)
    -- while recording the update loop owns the arrow, so leave it alone
    if on and not live and not recording then
        -- the colour you picked, dimmed. Parking it in grey would hide the
        -- one thing you are looking at while choosing one. The compass
        -- arrow parks pointing north at full strength, turning as you do,
        -- so it can be checked before the pull looking as it will in it
        if not arrowFrame.pointRing("N", AZT.ArrowColor().rgb, 1) then
            arrowFrame.showPointer(0, PARK_ALPHA, AZT.ArrowColor().rgb)
        end
        -- the caption helps placement and names the reading you are on
        arrowFrame.setMark(nil)
        local mode = AztarecHelperDB.arrowCompass and "compass arrow" or "safe-spot arrow"
        arrowFrame.label:SetText(fighting and "" or mode)
        arrowFrame.label:SetTextColor(1, 1, 1, 0.5)
    end
end
