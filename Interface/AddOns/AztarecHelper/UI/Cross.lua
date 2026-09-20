-- Azta'rec Helper, copyright 2026 Rothirr, all rights reserved.
-- Read it if you want. Copying any of it into another addon is theft, and
-- running it through an AI tool first does not change that. The timings and
-- coordinates were measured by hand. Nothing here is licensed to anyone.

local _, AZT = ...

-- The compass cross: four screen crossing lines out of the player, one per
-- cardinal, spun by the minimap compass ring so each arm keeps pointing
-- into its quarter however the player turns. The 2026-08-25 patch sealed
-- the ring's angle, but SetRotation renders sealed values, and a delve lap
-- on 2026-08-27 showed the rendered spin tracks the world correctly. So
-- this draws the compass the addon is no longer allowed to read: display
-- only, the angle itself never reaches code, recording stays by hand.

local frame
local texs = {}
local hole

-- one white texture per arm so each wears its own tint, straight from the
-- quarter it points into. White when the quarter has no marker to take a
-- color from
local ARMS = { "N", "E", "S", "W" }

-- the raid target palette, indexed the icon way, skull plain white
local MARK_RGB = {
    [1] = { 1, 0.9, 0.2 }, -- star
    [2] = { 1, 0.5, 0.1 }, -- circle
    [3] = { 0.72, 0.35, 0.9 }, -- diamond
    [4] = { 0.1, 0.9, 0.25 }, -- triangle
    [5] = { 0.82, 0.86, 0.95 }, -- moon
    [6] = { 0.2, 0.6, 1 }, -- square
    [7] = { 0.95, 0.22, 0.15 }, -- cross
    [8] = { 0.95, 0.95, 0.95 }, -- skull
}
local WHITE = { 1, 1, 1 }

--#region Ring lend

-- The ring only turns while the minimap rotates and the ring texture is
-- shown. Minimap skins hide the ring or an ancestor and some write the
-- rotation CVar back off on every reapply, so both lends are reasseted
-- every tick rather than trusted once, and handed back when the cross goes
local lent = {} -- region -> the alpha it had

-- SexyMap swaps Show for Hide on the texture itself, so lent regions go
-- through the real method off the frame metatable
local function realShow(r)
    local mt = getmetatable(r)
    local real = mt and type(mt.__index) == "table" and mt.__index.Show or r.Show
    real(r)
end

local function lendRing()
    local r = MinimapCompassTexture
    while r and r ~= UIParent do
        if not r:IsShown() then
            if lent[r] == nil then
                lent[r] = r:GetAlpha()
                r:SetAlpha(0)
            end
            realShow(r)
        end
        r = r:GetParent()
    end
end

-- GetCVarBool rather than GetCVar: this runs every tick and the string
-- return would drip garbage the whole delve
local function lendRotation()
    if not C_CVar.GetCVarBool("rotateMinimap") then
        C_CVar.SetCVar("rotateMinimap", "1")
        AztarecHelperDB.rotateLent = true
    end
end

-- rotateLent rides the saved variables so a reload or a crash inside the
-- delve still puts the player's minimap back
local function returnLends()
    for r, alpha in pairs(lent) do
        r:Hide()
        r:SetAlpha(alpha)
    end
    wipe(lent)
    if AztarecHelperDB.rotateLent then
        AztarecHelperDB.rotateLent = nil
        C_CVar.SetCVar("rotateMinimap", "0")
    end
end

--#endregion

-- Blizzard's 12.1 hotfix, announced 2026-09-14, turns the ring read into a
-- Lua error inside instances while the minimap rotates. With that there is
-- nothing left to turn the arms by, so the cross stands down for the
-- session, hands the minimap back and says why. Four lines going missing
-- without a word is what fills the comment section
AZT.CROSS_REFUSED = "The game no longer lets addons read the minimap compass in the delve, so the"
    .. " compass cross has nothing to turn by. It stays off until Blizzard opens that up again."

local function refuse()
    AZT.crossRefused = true
    AZT.CrossSync()
    AZT.chat(AZT.CROSS_REFUSED)
    if AZT.RefreshOptions then
        AZT.RefreshOptions()
    end
end

-- sized to the screen diagonal so the arms cross the whole screen at every
-- angle, the crossing lifted onto the character and the center gap cut by
-- the mask, both from their saved numbers
function AZT.CrossPlace()
    if not frame then
        return
    end
    local w, h = UIParent:GetWidth(), UIParent:GetHeight()
    local d = math.ceil(math.sqrt(w * w + h * h))
    frame:SetSize(d, d)
    frame:ClearAllPoints()
    frame:SetPoint("CENTER", 0, AztarecHelperDB.crossY)
    -- a circular hole cannot fall out of line with the spin, so the mask
    -- never needs rotating. Size 1 is as good as no gap
    hole:SetSize(math.max(AztarecHelperDB.crossHole, 1), math.max(AztarecHelperDB.crossHole, 1))
end

-- the spans the settings bars run, and the chat commands land inside the
-- same ones, so a typed number can never put the crossing off screen or
-- the fill past its track
AZT.CROSS_GAP_MAX = 800
AZT.CROSS_LIFT_MAX = 300

local function clamp(v, lo, hi)
    return math.floor(math.min(math.max(v, lo), hi) + 0.5)
end

function AZT.SetCrossGap(v)
    AztarecHelperDB.crossHole = clamp(v, 0, AZT.CROSS_GAP_MAX)
    AZT.CrossPlace()
    return AztarecHelperDB.crossHole
end

function AZT.SetCrossLift(v)
    AztarecHelperDB.crossY = clamp(v, -AZT.CROSS_LIFT_MAX, AZT.CROSS_LIFT_MAX)
    AZT.CrossPlace()
    return AztarecHelperDB.crossY
end

local function build()
    frame = CreateFrame("Frame", "AztarecHelperCross", UIParent)
    -- bottom strata, the whole UI stays clickable on top of it
    frame:SetFrameStrata("BACKGROUND")
    frame:Hide()
    -- the gap over the character: a transparent disc masked onto every
    -- arm, CLAMPTOWHITE so everything past the mask's rect stays visible
    hole = frame:CreateMaskTexture()
    hole:SetTexture("Interface\\AddOns\\AztarecHelper\\Media\\crossmask.png", "CLAMPTOWHITE", "CLAMPTOWHITE")
    hole:SetPoint("CENTER", frame)
    for _, q in ipairs(ARMS) do
        local t = frame:CreateTexture(nil, "ARTWORK")
        -- png so the mostly transparent art stays small on disk. The
        -- extension is spelled out, extensionless paths only try blp and tga
        t:SetTexture("Interface\\AddOns\\AztarecHelper\\Media\\arm_" .. q:lower() .. ".png")
        t:SetAllPoints(frame)
        t:AddMaskTexture(hole)
        texs[q] = t
    end
    AZT.CrossPlace()

    local elapsed = 0
    frame:SetScript("OnUpdate", function(_, dt)
        elapsed = elapsed + dt
        if elapsed < 1 / 30 then
            return
        end
        elapsed = 0
        lendRotation()
        lendRing()
        local rot
        if MinimapCompassTexture then
            local ok, r = pcall(MinimapCompassTexture.GetRotation, MinimapCompassTexture)
            if not ok then
                refuse()
                return
            end
            rot = r
        end
        -- when the switch says so the echoes trim the cross to the route,
        -- safe arm full, next one faint, the other two gone. A wave that was
        -- never answered has no arm to keep, so the whole cross stays up for
        -- that one instead of vanishing
        local trimTo = AztarecHelperDB.crossRoute and AZT.safeNow or nil
        if trimTo == "?" then
            trimTo = nil
        end
        for _, q in ipairs(ARMS) do
            local t = texs[q]
            -- the sink takes sealed values today, but a build could close
            -- that too, so a refusal blanks the arm instead of erroring
            if rot ~= nil and pcall(t.SetRotation, t, rot) then
                t:Show()
            else
                t:Hide()
            end
            -- tints re-read every pass, so a marker changed in the quarter
            -- menus or synced from the leader recolors its arm right away
            local c = MARK_RGB[AZT.QuadIcon(q)] or WHITE
            local a = 1
            if trimTo and q ~= trimTo then
                a = q == AZT.nextNow and 0.25 or 0
            end
            t:SetVertexColor(c[1], c[2], c[3], a)
        end
    end)
end

-- The lend holds for the whole delve visit so the player's minimap is not
-- flapping on and off around every pull, only the drawing follows the
-- Sermon setting. Wave edges land here too, through setWave's fan out
function AZT.CrossSync()
    local lend = AztarecHelperDB.cross and AZT.InDelve() and not AZT.crossRefused
    local show = lend and (not AztarecHelperDB.crossSermon or (AZT.Wave and AZT.Wave.phase ~= nil))
    if lend and not frame then
        build()
    end
    if frame then
        frame:SetShown(show and true or false)
    end
    if lend then
        AZT.CrossPlace()
        lendRotation()
    else
        returnLends()
    end
end

function AZT.SetCross(v)
    AztarecHelperDB.cross = v and true or false
    AZT.CrossSync()
    if AZT.RefreshOptions then
        AZT.RefreshOptions()
    end
end

local ef = CreateFrame("Frame")
ef:RegisterEvent("PLAYER_LOGIN")
ef:RegisterEvent("PLAYER_ENTERING_WORLD")
ef:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ef:RegisterEvent("DISPLAY_SIZE_CHANGED")
ef:RegisterEvent("UI_SCALE_CHANGED")
ef:SetScript("OnEvent", function(_, event)
    if event == "DISPLAY_SIZE_CHANGED" or event == "UI_SCALE_CHANGED" then
        AZT.CrossPlace()
    else
        -- PLAYER_LOGIN included: a lend stranded by a crash pays itself
        -- back here whenever the cross does not immediately want it again
        AZT.CrossSync()
    end
end)
