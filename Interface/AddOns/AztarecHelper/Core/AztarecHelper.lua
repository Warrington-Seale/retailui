-- Azta'rec Helper, copyright 2026 Rothirr, all rights reserved.
-- Read it if you want. Copying any of it into another addon is theft, and
-- running it through an AI tool first does not change that. The timings and
-- coordinates were measured by hand. Nothing here is licensed to anyone.

local ADDON, AZT = ...

AZT.VERSION = "2.4.8"

-- Venomfall Deeps boss room, measured on PTR 12.1.0.
-- UnitPosition returns (a, b, z, inst). The addon prints them as world=b,a.
-- Axis a points NORTH, axis b points WEST. Facing = radians CCW from north.
AZT.ROOM = {
    instanceMapID = 3079,
    uiMapID = 2634,
    centerA = 181.70, -- first UnitPosition return at room center
    centerB = 0.60, -- second UnitPosition return at room center
    radius = 36, -- wall distance from center (yd)
    pad = 15, -- extra view drawn beyond the wall (yd)
    -- uiMap 2634's picture in world yards, top-left corner and spans. The
    -- room view aligns the map art with these, re-measuring when it can.
    mapOriginA = 305,
    mapSpanA = 340,
    mapOriginB = 255,
    mapSpanB = 510,
}

local DEFAULTS = {
    enabled = true,
    autoRecord = true, -- start/stop recording with combat automatically
    nameFilter = "", -- substring filter for target/nameplate casts, "" logs every hostile cast
    posOnCast = true, -- append a player position probe to every cast line
    roomView = true, -- the main room view window
    roomSlim = true, -- room view cut down to the room, Opts and Info tucked in the corners
    windowScale = {}, -- size per floating window, keyed like the locks, missing means 1
    mapArt = false, -- draw Blizzard's map art tiles behind the room view
    waveText = true, -- floating wave countdown window
    soloBoard = false, -- the route board drawn from the own recording, not just the leader's calls
    cross = true, -- the compass cross over the screen, arms tinted by the quarter markers
    crossSermon = false, -- cross only draws while a sermon or its echoes run
    crossRoute = true, -- through the echoes the cross keeps the safe arm and fades the rest
    crossY = 0, -- the character stands under screen center, this lifts the crossing onto them
    crossHole = 500, -- the gap over the character, px, so they stay visible
    arrow = true, -- quest-style arrow showing the move for each echo
    arrowColor = "gold", -- key into AZT.ARROW_COLORS
    arrowCompass = false, -- arrow points the way the room view does, no spoken cues
    relativeTurns = false, -- quarter keys answer turns instead, after the first wave
    cues = true, -- the recorded solo cues during your own echoes
    cueVoice = "relative", -- what the cues say: "relative", "markers", "colors" or "custom"
    cueWords = {}, -- the Custom voice's word per quarter letter, blank falls back to the marker
    ttsVolume = 100, -- how loud everything the addon says over tts is
    callVoice = true, -- follower: read the leader's direction calls out loud
    keysMark = false, -- answer keys also mark the player for the party
    callRoute = false, -- leader: answer keys also call the quarter's number in party chat
    callStyle = "markers", -- what the calls say, "markers" or "arrows"
    follow = false, -- follower: collect the leader's calls and show the route
    cueChannel = "Master", -- sound channel the calls play through
    quadIcons = {}, -- world marker icon per quarter letter, board display only
    anywhere = false, -- escape hatch: treat every zone as the delve
    log = {}, -- persisted log lines (survive /reload and crashes)
}

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")

f:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name ~= ADDON then
            return
        end
        AztarecHelperDB = AztarecHelperDB or {}
        for k, v in pairs(DEFAULTS) do
            if AztarecHelperDB[k] == nil then
                AztarecHelperDB[k] = v
            end
        end
        if type(AztarecHelperDB.log) ~= "table" then
            AztarecHelperDB.log = {}
        end
        if type(AztarecHelperDB.windowScale) ~= "table" then
            AztarecHelperDB.windowScale = {}
        end
        if type(AztarecHelperDB.cueWords) ~= "table" then
            AztarecHelperDB.cueWords = {}
        end
        -- 2.4.0 folded the cue voice switch and the colors checkbox into one
        -- pick. The old booleans date back to 1.7.0, so any install that has
        -- them carries its choice over
        if AztarecHelperDB.cueMarks ~= nil then
            AztarecHelperDB.cueVoice = AztarecHelperDB.cueMarks
                    and (AztarecHelperDB.cueColors and "colors" or "markers")
                or "relative"
            AztarecHelperDB.cueMarks = nil
            AztarecHelperDB.cueColors = nil
        end
        -- 2.4.0 also starts the cross on for everyone, once. Turning it off
        -- after that sticks like any setting. The gap default grew to 500
        -- with it, so anyone still sitting on the old 150 comes along
        if not AztarecHelperDB.crossOnOnce then
            AztarecHelperDB.crossOnOnce = true
            AztarecHelperDB.cross = true
            if AztarecHelperDB.crossHole == 150 then
                AztarecHelperDB.crossHole = 500
            end
        end
        -- the grid rotation toggle is gone so clear its leftovers from old SVs
        AztarecHelperDB.quadRot = nil
        AztarecHelperDB.quadRotMigrated = nil
        if not AztarecHelperDB.mapArtOffOnce then
            AztarecHelperDB.mapArtOffOnce = true
            AztarecHelperDB.mapArt = false
        end
        if not AztarecHelperDB.quadIconsSeeded then
            AztarecHelperDB.quadIconsSeeded = true
            if next(AztarecHelperDB.quadIcons) == nil then
                for q, i in pairs(AZT.MARK_SEED) do
                    AztarecHelperDB.quadIcons[q] = i
                end
            end
        end
        -- 1.3.0 removed the position-fed pieces, so clear their leftovers
        AztarecHelperDB.moveWarn = nil
        AztarecHelperDB.viewMode = nil
        AztarecHelperDB.viewModeMigrated = nil
        AztarecHelperDB.keyDebug = nil
        -- the updates notice went with 2.0.3, the entry goes straight to the
        -- automatic offer now
        AztarecHelperDB.nerfNoticeSeen = nil
        -- 2.0.4 made the delve rotation a setting that automatic forces, the
        -- remembered choice and its offer box went with it
        AztarecHelperDB.autoRotate = nil
        -- 2.2.0 took automatic recording out for good, so everything only
        -- it read goes too
        AztarecHelperDB.manualMode = nil
        AztarecHelperDB.delveRotate = nil
        AztarecHelperDB.waveTick = nil
        AztarecHelperDB.autoAsked = nil
        AztarecHelperDB.misreadSeen = nil
        AztarecHelperDB.misreadMuted = nil
        -- Talking Head was never a channel PlaySoundFile accepts
        if AztarecHelperDB.cueChannel == "Talking Head" then
            AztarecHelperDB.cueChannel = "Master"
        end
        -- 1.3.4 muted the spoken cues under the compass arrow and 1.3.6
        -- unmutes them. Anyone already on the compass keeps their cue
        -- toggle as it stands and skips the ask box new compass users get
        if AztarecHelperDB.arrowCompass then
            AztarecHelperDB.compassCueAsked = true
        end
    elseif event == "PLAYER_LOGIN" then
        AZT.Safe.RestorePull()
        if AZT.Recorder then
            AZT.Recorder.Init()
        end
    end
end)

local function chat(msg)
    print("|cff33ff99AZT|r: " .. msg)
end
AZT.chat = chat

-- Are we in the nemesis delve? The instance map id is the primary signal.
-- The zone name is the fallback in case Blizzard renumbers it for live, and
-- /azt anywhere overrides the whole question for the day both signals break.
function AZT.InDelve()
    if AztarecHelperDB and AztarecHelperDB.anywhere then
        return true
    end
    local ok, _, _, _, _, _, _, _, instMapID = pcall(GetInstanceInfo)
    if ok and instMapID == AZT.ROOM.instanceMapID then
        return true
    end
    local okZ, zt = pcall(GetZoneText)
    return (okZ and zt == "Venomfall Deeps") or false
end

-- The recon logger lives in DevTools.lua, which is not shipped. It overrides
-- this with the real recorder. Shipped builds silently drop log lines.
function AZT.Log() end

-- is a fight on by any signal: the regen flag, the lockdown API or an
-- armed encounter. Every parked window hides behind this one answer
function AZT.Fighting()
    return AZT.inCombat or InCombatLockdown() or (AZT.Safe and AZT.Safe.IsArmed and AZT.Safe.IsArmed()) or false
end

-- a delve companion NPC counts as a group to IsInGroup, so party play asks
-- the roster for an actual player before believing it
function AZT.InPlayerParty()
    if not IsInGroup() or IsInRaid() then
        return false
    end
    for i = 1, 4 do
        local unit = "party" .. i
        if UnitExists(unit) and UnitIsPlayer(unit) then
            return true
        end
    end
    return false
end

-- world marker flags carry the same eight symbols as the raid target icons
AZT.MARK_TEX = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d"

-- the icons a fresh install wears: star north, square east, triangle south,
-- circle west. The seeding and the mark keys' letter fallback both read this
AZT.MARK_SEED = { N = 1, E = 6, S = 4, W = 2 }

-- the room is read north up everywhere, so a quarter is also a direction.
-- These name the tutorial pointer arrows, which is what lets a quarter be
-- drawn as its arrow and called by a word the voice can read
AZT.ARROW_ATLAS = "NPE_Arrow%s"
AZT.QUAD_DIR = { N = "Up", E = "Right", S = "Down", W = "Left" }

-- the marker index a quarter wears, the party leader's synced icon winning
-- over the own pick. Nothing back means the quarter shows its bare letter.
function AZT.QuadIcon(q)
    return (AZT.Follow and AZT.Follow.IconFor(q)) or (AztarecHelperDB.quadIcons and AztarecHelperDB.quadIcons[q])
end

-- a quarter as the player sees it: the party leader's icon when one is
-- synced over, else the marker icon they picked for it or the compass
-- letter. Everything that names a quarter goes through here so the board,
-- the arrow and the chat lines all speak the same language.
function AZT.QuadName(q, size)
    size = size or 14
    local dir = AZT.QUAD_DIR[q]
    if dir and AZT.Follow and AZT.Follow.Arrows() then
        return ("|A:" .. AZT.ARROW_ATLAS .. ":%d:%d|a"):format(dir, size, size)
    end
    local idx = AZT.QuadIcon(q)
    if idx then
        return ("|T" .. AZT.MARK_TEX .. ":%d|t"):format(idx, size)
    end
    return q
end

local HELP = {
    "/azt room          - toggle the room view (auto-shows in the delve)",
    "/azt map           - toggle the map art backdrop behind the room view",
    "/azt cross         - toggle the compass cross, marker colored direction lines over the screen",
    "/azt crossy <px>   - lift the cross center onto your character",
    "/azt crosshole <px> - the empty circle over your character, 0 closes it",
    "/azt crossroute    - toggle the cross keeping only the safe arm through the echoes",
    "/azt n|e|s|w       - answer a wave with that quarter (bindable keys too)",
    "/azt replay        - replay the last recorded route with real timings",
    "/azt practice      - a pretend sermon to record and get echoed, no boss needed",
    "/azt cue           - toggle the solo spoken cues during the echoes",
    "/azt turns         - toggle answering in relative turns after the first wave",
    "/azt call          - toggle calling the route for the party while you lead",
    "/azt follow        - toggle following the leader's calls",
    "/azt review        - what the last pull recorded and where you died",
    "/azt reset         - clear the recorded route",
    "/azt options       - open the settings panel",
    "/azt anywhere      - treat where you stand as the delve, for when detection breaks",
    "/azt help          - how the recording and the callouts work",
    "/azt version       - addon version",
}
AZT.HELP = HELP -- DevTools.lua appends its command list when present

SLASH_AZT1 = "/azt"
SlashCmdList["AZT"] = function(msg)
    msg = msg or ""
    local cmd, rest = msg:match("^(%S*)%s*(.-)%s*$")
    cmd = cmd:lower()

    if cmd == "room" then
        AZT.ToggleRoomView()
    elseif cmd == "map" then
        AZT.ToggleMapArt()
    elseif cmd == "cross" then
        AZT.SetCross(not AztarecHelperDB.cross)
        chat("compass cross: " .. (AztarecHelperDB.cross and "ON - it draws in the delve" or "OFF"))
        if AztarecHelperDB.cross and AZT.crossRefused then
            chat(AZT.CROSS_REFUSED)
        end
    elseif cmd == "crossy" then
        local n = tonumber(rest)
        if n then
            -- the setters hold the number to the settings bar's span, so
            -- the echo says where it actually landed
            chat(("cross center lifted %d px"):format(AZT.SetCrossLift(n)))
            AZT.RefreshOptions()
        else
            chat(
                ("usage: /azt crossy <pixels>, -%d to %d, negative sinks it"):format(
                    AZT.CROSS_LIFT_MAX,
                    AZT.CROSS_LIFT_MAX
                )
            )
        end
    elseif cmd == "crosshole" then
        local n = tonumber(rest)
        if n then
            chat(("cross gap set to %d px"):format(AZT.SetCrossGap(n)))
            AZT.RefreshOptions()
        else
            chat(("usage: /azt crosshole <pixels>, 0 to %d, 0 closes the gap"):format(AZT.CROSS_GAP_MAX))
        end
    elseif cmd == "crossroute" then
        AztarecHelperDB.crossRoute = not AztarecHelperDB.crossRoute
        if AztarecHelperDB.crossRoute then
            chat("cross arms: ROUTE - only the safe arm stays through the echoes")
        else
            chat("cross arms: ALL - all four stay up")
        end
        AZT.RefreshOptions()
    elseif cmd == "n" or cmd == "e" or cmd == "s" or cmd == "w" then
        AZT.Safe.AnswerKey(cmd:upper())
    elseif cmd == "replay" then
        AZT.Safe.Replay()
    elseif cmd == "practice" then
        AZT.Safe.Practice()
    elseif cmd == "anywhere" then
        AztarecHelperDB.anywhere = not AztarecHelperDB.anywhere
        -- everything zone gated re-decides right now instead of waiting for
        -- the next zone change
        if AZT.Safe and AZT.Safe.ZoneSync then
            AZT.Safe.ZoneSync()
        end
        AZT.MarkKeysSync()
        if AZT.Follow then
            AZT.Follow.Sync()
        end
        if AZT.RoomZoneSync then
            AZT.RoomZoneSync()
        end
        if AZT.CrossSync then
            AZT.CrossSync()
        end
        if AztarecHelperDB.anywhere then
            chat("treating every zone as the delve - costs idle work, /azt anywhere again to turn off")
        else
            chat("back to delve detection")
        end
    elseif cmd == "cue" then
        AztarecHelperDB.cues = not AztarecHelperDB.cues
        chat("solo spoken cues: " .. (AztarecHelperDB.cues and "ON" or "OFF"))
    elseif cmd == "turns" then
        AZT.SetRelativeTurns(not AztarecHelperDB.relativeTurns)
        if AztarecHelperDB.relativeTurns then
            chat("relative turns: ON - first wave still names its quarter, marking and calling are off")
        else
            chat("relative turns: OFF - back to naming the quarter you ran to")
        end
    elseif cmd == "call" then
        -- calling belongs to the leader alone. The command refuses
        -- anyone else so two routes never fight over the boards
        if not AztarecHelperDB.callRoute and AztarecHelperDB.relativeTurns then
            chat("your keys answer relative turns, and a turn has no quarter to call - /azt turns first")
        elseif not AztarecHelperDB.callRoute and not (AZT.InPlayerParty() and UnitIsGroupLeader("player")) then
            chat("route calling is for the party leader - take the lead first")
        else
            AZT.SetCallRoute(not AztarecHelperDB.callRoute)
            if AztarecHelperDB.callRoute then
                chat(
                    "route calling: ON - ask the party to keep chat quiet in the fight, stray lines land on their boards"
                )
            else
                chat("route calling: OFF")
            end
        end
    elseif cmd == "follow" then
        if not AztarecHelperDB.follow and AZT.InPlayerParty() and UnitIsGroupLeader("player") then
            chat("following is for party members - you lead, call the route instead")
        else
            AZT.SetFollow(not AztarecHelperDB.follow)
            chat("following the leader: " .. (AztarecHelperDB.follow and "ON" or "OFF"))
        end
    elseif cmd == "review" then
        AZT.Safe.Review()
    elseif cmd == "reset" then
        AZT.Safe.Reset()
        chat("recorded route cleared")
    elseif cmd == "options" or cmd == "opt" then
        AZT.OpenOptions()
    elseif cmd == "help" then
        AZT.ShowInstructions()
    elseif cmd == "version" then
        chat(ADDON .. " v" .. AZT.VERSION)
    elseif AZT.Dev and AZT.Dev.HandleCommand(cmd, rest) then -- luacheck: ignore 542
        -- handled by DevTools.lua
    else
        chat("commands:")
        for _, line in ipairs(HELP) do
            print("  " .. line)
        end
    end
end

-- global for the AddOn Compartment entry in the .toc
function AztarecHelper_OnCompartment()
    AZT.OpenOptions()
end
