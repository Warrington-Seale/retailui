-- Azta'rec Helper, copyright 2026 Rothirr, all rights reserved.
-- Read it if you want. Copying any of it into another addon is theft, and
-- running it through an AI tool first does not change that. The timings and
-- coordinates were measured by hand. Nothing here is licensed to anyone.

local _, AZT = ...

-- The answer keys doubling as the party signal: each press can put the
-- pressed quarter's marker on the player, so the group can follow along
-- without running the addon themselves, and when leading a party it can also
-- call that quarter in party chat for the follower boards, as its marker
-- number or as a direction word depending on the chosen style.
-- SetRaidTarget and chat sends from addon code are dead in the fight and
-- both have to travel Blizzard's secure macro path, so every key is
-- rerouted onto a hidden secure button whose canned macro does the say and
-- the marking.
-- The capture press still happens through PostClick and nothing about
-- answering changes.
--
-- Secure wiring is frozen during combat and can only move between pulls.
-- That is why the options arm for the whole fight and sermon presses mark
-- and call too. A sermon/echo split inside one pull cannot exist.

local QUAD_CMDS = {
    N = "AZTARECHELPER_MARK_NORTH",
    E = "AZTARECHELPER_MARK_EAST",
    S = "AZTARECHELPER_MARK_SOUTH",
    W = "AZTARECHELPER_MARK_WEST",
}
local owner -- the override bindings hang here, one clear drops them all
local buttons = {}
local armed = false

local function button(q)
    local btn = buttons[q]
    if not btn then
        btn = CreateFrame("Button", "AztarecHelperMarkKey" .. q, nil, "SecureActionButtonTemplate")
        btn:RegisterForClicks("AnyDown")
        btn:SetScript("PostClick", function()
            AZT.Safe.AnswerKey(q)
        end)
        buttons[q] = btn
    end
    return btn
end

-- calling needs a party with real players and the lead. The route is the
-- leader's recording, two people calling would write over each other's boards
local function callActive()
    return AztarecHelperDB.callRoute and AZT.InPlayerParty() and UnitIsGroupLeader("player")
end

-- one quarter's call-and-mark script, shared between the secure key
-- buttons and the real macros the options can write
local function quadLines(q, callWith)
    -- a quarter shown as its plain letter still wears its seeded marker
    -- for the party's sake
    local icon = AZT.QuadIcon(q) or AZT.MARK_SEED[q]
    local lines = {}
    if callWith then
        -- marking always speaks in icon numbers, only the call itself
        -- changes language
        local say = AztarecHelperDB.callStyle == "arrows" and AZT.QUAD_DIR[q] or icon
        lines[#lines + 1] = ("%s %s"):format(callWith, say)
    end
    if AztarecHelperDB.keysMark then
        lines[#lines + 1] = ("/targetexact %s\n/tm %d\n/targetlasttarget"):format(UnitName("player"), icon)
    end
    return lines, icon
end

-- party chat while leading with calling on, /say under the dev solo rig,
-- no call line at all otherwise. The keys and the written macros both
-- speak through this
local function callChannel()
    if callActive() then
        return "/p"
    end
    -- the dev solo rig calls through /say instead, so one account can run
    -- the whole leader-to-follower loop without a party
    if AZT.Dev and AZT.Dev.callSay then
        return "/s"
    end
end

local function arm()
    owner = owner or CreateFrame("Frame")
    ClearOverrideBindings(owner)
    local callWith = callChannel()
    for q, cmd in pairs(QUAD_CMDS) do
        local keys = { GetBindingKey(cmd) }
        if #keys > 0 then
            local btn = button(q)
            btn:SetAttribute("type", "macro")
            btn:SetAttribute("macrotext", table.concat(quadLines(q, callWith), "\n"))
            for _, key in ipairs(keys) do
                SetOverrideBindingClick(owner, true, key, btn:GetName())
            end
        end
    end
    armed = true
end

-- Real per-character macros carrying the same script as the secure keys,
-- one per quarter, with the /azt answer riding along so a press answers
-- the wave too. Born 2026-08-26: the patch eats the secure buttons' sends
-- mid fight but leaves a macro pressed from a bar alone, so for a leader
-- the bars are the calling that still works. Rewritten in place on every
-- click, so a changed call style or quarter icon is one click from the
-- bars as well.
local MACRO_QUARTERS = { "N", "E", "S", "W" }
local MACRO_NAMES = { N = "AztCallN", E = "AztCallE", S = "AztCallS", W = "AztCallW" }
local ICON_FILE = 137000 -- plus the icon number = UI-RaidTargetingIcon_n

local function writeMacro(q, create)
    local name = MACRO_NAMES[q]
    local _, oldIcon, oldBody = GetMacroInfo(name)
    if not create and not oldBody then
        return
    end
    local lines, icon = quadLines(q, callChannel())
    lines[#lines + 1] = "/azt " .. q:lower()
    local body = table.concat(lines, "\n")
    -- the sync runs off zone and roster events, so an unchanged macro is
    -- the common case and gets left alone
    if oldBody == body and oldIcon == ICON_FILE + icon then
        return true
    end
    if oldBody then
        EditMacro(name, name, ICON_FILE + icon, body)
    else
        CreateMacro(name, ICON_FILE + icon, body, true)
    end
    return GetMacroInfo(name) ~= nil
end

function AZT.WriteCallMacros()
    local written, full = {}, false
    for _, q in ipairs(MACRO_QUARTERS) do
        if writeMacro(q, true) then
            written[#written + 1] = MACRO_NAMES[q]
        else
            full = true
        end
    end
    AZT.chat(
        ("wrote %d call macros (%s) - macro window, character tab, drag them onto your bars"):format(
            #written,
            table.concat(written, ", ")
        )
    )
    if full then
        AZT.chat("not all of them fit, this character's macro slots are full - clear one and click again")
    end
end

-- written macros follow the settings on their own: a new quarter icon off
-- the room view or a flipped style or mark option lands in them without
-- another button press. Only ever touches macros that already exist
function AZT.SyncCallMacros()
    for _, q in ipairs(MACRO_QUARTERS) do
        writeMacro(q, false)
    end
end

local function disarm()
    if owner then
        ClearOverrideBindings(owner)
    end
    armed = false
end

-- Turn keys cannot carry any of this. The macro behind a key is built for one
-- named quarter and frozen for the whole pull, while a turn has no quarter
-- until the press lands, so the rig stands down rather than mark and call the
-- wrong spot. The two options go off with it instead of sitting on and silent.
function AZT.SetRelativeTurns(on)
    AztarecHelperDB.relativeTurns = on
    if on and (AztarecHelperDB.keysMark or AztarecHelperDB.callRoute) then
        AztarecHelperDB.keysMark = false
        if AztarecHelperDB.callRoute then
            AZT.SetCallRoute(false)
        end
        AZT.chat("marking and calling: OFF - a turn key has no quarter to mark or call")
    end
    AZT.MarkKeysSync()
    if AZT.RefreshOptions then
        AZT.RefreshOptions()
    end
end

local ev = CreateFrame("Frame")

-- (re)wire to match the option, the zone and the current binds. A sync that
-- lands in combat listens for the regen edge and runs there, since the
-- wiring cannot move untill then anyway
function AZT.MarkKeysSync()
    if not AztarecHelperDB then
        return -- UPDATE_BINDINGS fires at login before saved variables load
    end
    if InCombatLockdown() then
        ev:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end
    ev:UnregisterEvent("PLAYER_REGEN_ENABLED")
    local want = AztarecHelperDB.keysMark or callActive() or (AZT.Dev and AZT.Dev.callSay)
    -- turn keys have no quarter to mark or call
    if AztarecHelperDB.relativeTurns then
        want = false
    end
    if want and AZT.InDelve() then
        arm()
    elseif armed then
        disarm()
    end
    -- the written macros follow the same events the wiring does, so they
    -- carry the call line exactly while the keys would
    AZT.SyncCallMacros()
end

local rosterWait

ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ev:RegisterEvent("UPDATE_BINDINGS")
ev:RegisterEvent("GROUP_ROSTER_UPDATE")
ev:RegisterEvent("PARTY_LEADER_CHANGED")
ev:SetScript("OnEvent", function(_, event)
    if event == "GROUP_ROSTER_UPDATE" or event == "PARTY_LEADER_CHANGED" then
        -- roster events fire in bursts while a group forms, one rewire
        -- after they settle
        if rosterWait then
            rosterWait:Cancel()
        end
        rosterWait = C_Timer.NewTimer(0.5, AZT.MarkKeysSync)
        return
    end
    AZT.MarkKeysSync()
end)
