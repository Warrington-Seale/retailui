-- Azta'rec Helper, copyright 2026 Rothirr, all rights reserved.
-- Read it if you want. Copying any of it into another addon is theft, and
-- running it through an AI tool first does not change that. The timings and
-- coordinates were measured by hand. Nothing here is licensed to anyone.

local _, AZT = ...

-- The reading box. One frame for the instructions behind the room view's
-- button and for the questions the addon asks on the way into the delve.

local box

-- taller reads scroll rather than grow the box past this
local MAX_BODY = 380

local INSTR_TITLE = "How to use it"

local INSTR = "|cffffd100The fight:|r during Sermon of Ula'tek the boss slams three quarters of the "
    .. "room at once and leaves one safe, a few waves in a row, the ground showing where. "
    .. "Then the echoes repeat the same order with nothing on the ground.\n\n"
    .. "|cffffd100Record the safe spots:|r while the ground shows them, press the safe quarter's key "
    .. "or click it on the room view, one answer per wave. A missed wave is caught up by "
    .. "your next press.\n\n"
    .. "|cffffd100Dodge the echoes:|r the room view lights the safe quarter green and the one after "
    .. "it yellow, the arrow points your move and the voice calls it out loud. Go where "
    .. "they say.\n\n"
    .. "|cffffd100Practice:|r /azt practice runs a pretend sermon with no boss around. Every setting "
    .. "explains itself in its tooltip."

local function build()
    box = CreateFrame("Frame", "AztarecHelperNotice", UIParent, "BackdropTemplate")
    box:SetSize(480, 100)
    box:SetPoint("CENTER", 0, 140)
    -- above the settings panel, the boxes can open while it is up
    box:SetFrameStrata("FULLSCREEN_DIALOG")
    box:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    box:SetBackdropColor(0, 0, 0, 0.85)
    box:EnableMouse(true)
    box:SetMovable(true)
    box:RegisterForDrag("LeftButton")
    box:SetScript("OnDragStart", box.StartMoving)
    box:SetScript("OnDragStop", box.StopMovingOrSizing)

    local title = box:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -12)
    box.title = title

    -- the body rides a scroll frame, so a long read, the collected release
    -- notes mostly, caps the box and rolls under the wheel instead of
    -- running off the screen
    local scroll = CreateFrame("ScrollFrame", nil, box)
    local content = CreateFrame("Frame", nil, scroll)
    scroll:SetScrollChild(content)
    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        local v = self:GetVerticalScroll() - delta * 40
        self:SetVerticalScroll(math.min(math.max(v, 0), self:GetVerticalScrollRange()))
    end)
    local body = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOPLEFT")
    body:SetJustifyH("LEFT")
    body:SetSpacing(2)
    box.scroll, box.content, box.body = scroll, content, body

    -- a box can carry a link into the settings in its sentence. The links
    -- live in the body so its frame takes the clicks, and the box closes
    -- first so the settings do not open under it
    content:EnableMouse(true)
    content:SetHyperlinksEnabled(true)
    content:SetScript("OnHyperlinkClick", function(_, link)
        if link == "azt:options" then
            box:Hide()
            AZT.OpenOptions()
        elseif link == "azt:cross" then
            -- the news notes about the cross switch it in place, no trip
            -- through the settings needed
            AZT.SetCross(true)
            AZT.chat("compass cross: ON")
        elseif link == "azt:crossoff" then
            AZT.SetCross(false)
            AZT.chat("compass cross: OFF")
        end
    end)

    -- one button for reading, two when the box is asking something
    local right = CreateFrame("Button", nil, box, "UIPanelButtonTemplate")
    right:SetSize(150, 22)
    right:SetPoint("BOTTOM", 0, 12)
    box.right = right

    local left = CreateFrame("Button", nil, box, "UIPanelButtonTemplate")
    left:SetSize(150, 22)
    left:SetPoint("RIGHT", right, "LEFT", -8, 0)
    box.left = left

    -- a new frame starts shown, and the queue below reads shown as busy
    box:Hide()
    table.insert(UISpecialFrames, "AztarecHelperNotice")
end

-- text with one dismiss button, or a question with a choice on either side
-- One box, so asks that land together queue up behind it and take their
-- turn as it closes. Delve entry can raise two at once, the patch note
-- and a party role ask.
local queue = {}
local show

local function showNext()
    local nxt = table.remove(queue, 1)
    if nxt then
        show(nxt.title, nxt.text, nxt.ask)
    end
end

function show(title, text, ask)
    if not box then
        build()
        box:SetScript("OnHide", showNext)
    end
    -- a different box waits its turn, but asking for the one already on
    -- screen just redraws it, else a mashed button stacks copies that each
    -- want their own Got it
    if box:IsShown() and box.title:GetText() ~= title then
        queue[#queue + 1] = { title = title, text = text, ask = ask }
        return
    end
    box.title:SetText(title)
    box.body:SetWidth(box:GetWidth() - 36)
    box.body:SetText(text)
    local bodyH = box.body:GetStringHeight()
    box.content:SetSize(box:GetWidth() - 36, bodyH)
    local seen = math.min(bodyH, MAX_BODY)
    box.scroll:ClearAllPoints()
    box.scroll:SetPoint("TOPLEFT", 18, -38)
    box.scroll:SetPoint("TOPRIGHT", -18, -38)
    box.scroll:SetHeight(seen)
    box.scroll:SetVerticalScroll(0)
    box:SetHeight(38 + seen + 48)
    box.left:SetShown((ask and ask.leftText) and true or false)
    box.right:ClearAllPoints()
    if ask then
        if ask.leftText then
            box.left:SetText(ask.leftText)
            box.left:SetScript("OnClick", function()
                box:Hide()
                ask.left()
            end)
            -- shifted right so the pair sits centred with the left button
            box.right:SetPoint("BOTTOM", 79, 12)
        else
            -- an ask without a left side is one button that does something
            box.right:SetPoint("BOTTOM", 0, 12)
        end
        box.right:SetText(ask.rightText)
        box.right:SetScript("OnClick", function()
            box:Hide()
            ask.right()
        end)
    else
        box.right:SetPoint("BOTTOM", 0, 12)
        box.right:SetText("Got it")
        box.right:SetScript("OnClick", function()
            box:Hide()
        end)
    end
    box:Show()
end

function AZT.ShowInstructions()
    show(INSTR_TITLE, INSTR)
end

-- What the News button on the room view opens, newest first. Add an entry
-- for every release with a feature to show, a sentence or two each,
-- internal fixes stay in the changelog. The box shows every entry the
-- player has not read yet, so a note is never missed by skipping versions,
-- and a bump without an entry relights nothing. The whole list stays,
-- an All notes button reads it back as the archive
local NEWS = {
    {
        v = "2.4.7",
        text = "The cross trimming down to the safe arm through the echoes has a switch now,"
            .. " Cross arms in the |Hazt:options|h|cff71d5ffsettings|r|h. Set it to All and"
            .. " all four lines stay up the whole way, the way they did before the trimming"
            .. " came in.",
    },
    {
        v = "2.4.6",
        text = 'The "keybinds not set" note under the room can be clicked now and takes'
            .. " you to the |Hazt:options|h|cff71d5ffsettings|r|h where the quarter keys"
            .. " get bound.",
    },
    {
        v = "2.4.5",
        text = "The compass cross points the way through the echoes now: the safe quarter's"
            .. " arm stays bright, the next one goes faint and the other two disappear, so"
            .. " the line to run along is the only one left.",
    },
    {
        v = "2.4.3",
        text = "The practice drill's starting countdown runs in the wave countdown window"
            .. " now rather than ticking into chat.",
    },
    {
        v = "2.4.1",
        text = "The practice drill tells you which waves you got wrong when it ends, the safe"
            .. " quarter beside what you answered. /azt practice or the button in the"
            .. " |Hazt:options|h|cff71d5ffoptions|r|h runs it.",
    },
    {
        v = "2.4.0",
        text = "The cues can say your own words now: a Custom cue voice in the"
            .. " |Hazt:options|h|cff71d5ffoptions|r|h with a box per quarter, numbers, another"
            .. " language, whatever your group calls them. A blank quarter falls back to its"
            .. " marker name. The compass cross also starts on for everyone,"
            .. " |Hazt:crossoff|h|cff71d5ffturn it off right here|r|h if it is not your thing.",
    },
    {
        v = "2.3.1",
        text = "The compass cross: four lines out of your character across the screen, each"
            .. " pointing into its quarter and wearing its marker color, turning with you off"
            .. " the minimap compass. A tickbox in the |Hazt:options|h|cff71d5ffoptions|r|h,"
            .. " with a switch to only draw it during the Sermon and its echoes, or"
            .. " |Hazt:cross|h|cff71d5ffturn it on right here|r|h.",
    },
    {
        v = "2.2.0",
        text = "The remains of automatic recording are cleaned out. The Recording switch, the"
            .. " minimap rotation setting and the ring diagnostics are gone, recording by hand"
            .. " is simply how the addon works now.",
    },
    {
        v = "2.1.13",
        text = "The August 25 patch broke automatic recording for good. Recording is by hand from"
            .. " here, keys or clicks while the ground shows the safe quarter, and everything"
            .. " else works as before.",
    },
    {
        v = "2.1.11",
        text = "Automatic recording can ping as it writes each wave down, a tickbox in the"
            .. " |Hazt:options|h|cff71d5ffoptions|r|h.",
    },
    {
        v = "2.1.8",
        text = "The last pull survives reloads and disconnects now, so /azt review and /azt replay"
            .. " still know your route and your death after one.",
    },
    {
        v = "2.1.6",
        text = "Every window has a size slider of its own in the |Hazt:options|h|cff71d5ffoptions|r|h,"
            .. " and the slim room view got Info and News buttons in its corners.",
    },
}

local function unseenCount()
    local seen = AztarecHelperDB.newsSeen
    for i, n in ipairs(NEWS) do
        if n.v == seen then
            return i - 1
        end
    end
    return #NEWS
end

function AZT.NewsUnseen()
    return unseenCount() > 0
end

local function newsBody(count)
    local parts = {}
    for i = 1, count do
        parts[i] = "|cffffd100" .. NEWS[i].v .. "|r  " .. NEWS[i].text
    end
    return table.concat(parts, "\n\n")
end

local function showAllNews()
    show("Release notes", newsBody(#NEWS))
end

function AZT.ShowWhatsNew()
    -- nothing missed still reads as the latest note, the button always talks
    local count = math.max(unseenCount(), 1)
    AztarecHelperDB.newsSeen = NEWS[1].v
    if count == #NEWS then
        showAllNews()
        return
    end
    show("What's new", newsBody(count), {
        leftText = "All notes",
        left = showAllNews,
        rightText = "Got it",
        right = function() end,
    })
end

-- The compass arrow changes what the arrow points at, but the voice has no
-- compass mode, it keeps talking as if you face the boss. Said once when
-- the compass is first ticked, with the choice in hand, instead of
-- silently mixing the two readings. Anyone who ran the compass before this
-- ask existed is grandfathered by the bootstrap and keeps their cue toggle
-- as it stands.
local COMPASS_TITLE = "Compass arrow and the spoken cues"
local COMPASS_CUES = "With compass arrow, the arrow points the way the room view does "
    .. "but the voices still talk as if you are facing the boss. "
    .. "Disable Solo spoken cues in options if you want the arrow to be the only cue. "

function AZT.ShowCompassCueAsk()
    AztarecHelperDB.compassCueAsked = true
    show(COMPASS_TITLE, COMPASS_CUES, {
        leftText = "Turn cues off",
        left = function()
            AztarecHelperDB.cues = false
            AZT.chat("solo spoken cues: OFF")
        end,
        rightText = "Keep the cues",
        right = function() end,
    })
end

-- Party play, offered when the role calls for it: the leader hears about
-- calling, everyone else about following. Core/Follow.lua decides when to
-- show these, once per stint in a role, and the options keep both
-- changeable at any time.
local CALL_TITLE = "Call the route for your party?"
local CALL_TEXT = "You lead this group. With calling on, your answer keys also name each"
    .. " quarter in party chat as you record, by its marker number or as a direction if you"
    .. " switch that on, and party members running the addon see your route on the boss's"
    .. " timing. The calls ride the key presses themselves, so answer with your keys, a"
    .. " click on the room view answers for you alone and says nothing. The keys work"
    .. " as before otherwise. One ask for the group: keep party chat quiet during the"
    .. " fight, since stray lines land on the followers' boards as garbage. Declining"
    .. " means you record and answer for yourself only."
    .. " Either way you can change your mind under Party in the options."

function AZT.ShowCallAsk()
    show(CALL_TITLE, CALL_TEXT, {
        leftText = "Call the route",
        left = function()
            AZT.SetCallRoute(true)
            AZT.chat("route calling: ON while you lead")
        end,
        rightText = "Record for myself",
        right = function() end,
    })
end

local FOLLOW_TITLE = "Follow the leader's calls?"
local FOLLOW_TEXT = "Someone else leads this group. With following on, their route calls show"
    .. " on a board of their own and on the wave countdown, timed by the boss like always."
    .. " A leader who calls directions rather than markers gets read out loud as well, which"
    .. " is its own tickbox under Party. The addon can show the calls but never read them, so"
    .. " the arrow and the solo cues lock off while you follow,"
    .. " and any party chat during the sermon lands on the board. Declining means you"
    .. " record and answer for yourself like when solo. Either way"
    .. " you can change your mind under Party in the options."

function AZT.ShowFollowAsk()
    show(FOLLOW_TITLE, FOLLOW_TEXT, {
        leftText = "Follow the calls",
        left = function()
            AZT.SetFollow(true)
            AZT.chat("following the leader: ON")
        end,
        rightText = "Record for myself",
        right = function() end,
    })
end

-- The 2026-08-25 patch closed automatic recording for good, every channel
-- the facing could leak through went secret at once. Said plainly, once,
-- to everyone on the way in, and the mode itself is gone from the addon
local PATCH_TITLE = "Azta'rec Helper: automatic recording is gone"
local PATCH_TEXT = "The August 25 patch broke automatic recording, and this time nothing"
    .. " survived to work around it with. Recording is by hand from here: answer each wave with"
    .. " your quarter keys or a click on the room view while the ground still shows it."
    .. " Everything else works as before, and the practice drill in the"
    .. " |Hazt:options|h|cff71d5ffoptions|r|h gets the keys into your fingers without a pull."

-- a named door for /azt patchbox, the delve entry below is the real caller
function AZT.ShowPatchWarn()
    show(PATCH_TITLE, PATCH_TEXT)
end

local ef = CreateFrame("Frame")
ef:RegisterEvent("PLAYER_ENTERING_WORLD")
ef:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ef:SetScript("OnEvent", function()
    if not AZT.InDelve() then
        return
    end
    if not AztarecHelperDB.autoGoneSeen then
        AztarecHelperDB.autoGoneSeen = true
        AZT.ShowPatchWarn()
    end
end)
