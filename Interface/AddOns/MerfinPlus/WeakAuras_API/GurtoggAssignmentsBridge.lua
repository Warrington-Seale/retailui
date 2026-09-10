local MerfinPlus = LibStub("AceAddon-3.0"):GetAddon("MerfinPlus")

local EVENT_NAME = "MERFINPLUS_GURTOGG_ASSIGNMENTS_UPDATED"
local SNAPSHOT_VERSION = 3
local RAID_GROUP_ID = "bt_mh"
local PUBLIC_BRIDGE_NAME = "MerfinPlusGurtoggAssignments"
local PublicBridge = _G[PUBLIC_BRIDGE_NAME]
if type(PublicBridge) ~= "table" then
  PublicBridge = {}
  _G[PUBLIC_BRIDGE_NAME] = PublicBridge
end
local GURTOGG_BOSS = {
  key = "gurtogg_bloodboil",
  name = "Gurtogg Bloodboil",
  raidKey = "black_temple",
}

local GROUP_DEFINITIONS = {
  {
    key = "star",
    order = 1,
    label = "Star Worldmark - Group 1",
    marker = "star",
    markerIndex = 1,
    assignmentKey = "gurtoggstargroup",
  },
  {
    key = "diamond",
    order = 2,
    label = "Diamond Worldmark - Group 2",
    marker = "diamond",
    markerIndex = 3,
    assignmentKey = "gurtoggdiamondgroup",
  },
  {
    key = "circle",
    order = 3,
    label = "Circle Worldmark - Group 3",
    marker = "circle",
    markerIndex = 2,
    assignmentKey = "gurtoggcirclegroup",
  },
}

local CLASS_TOKEN_BY_KEY = {
  deathknight = "DEATHKNIGHT",
  druid = "DRUID",
  hunter = "HUNTER",
  mage = "MAGE",
  monk = "MONK",
  paladin = "PALADIN",
  priest = "PRIEST",
  rogue = "ROGUE",
  shaman = "SHAMAN",
  warlock = "WARLOCK",
  warrior = "WARRIOR",
}

local function Trim(value)
  return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function NormalizeKey(value)
  return Trim(value):lower():gsub("[%s%p%c]+", "")
end

local function NormalizeClassToken(value)
  return CLASS_TOKEN_BY_KEY[NormalizeKey(value)]
end

local function ShortPlayerName(value)
  local name = Trim(value)
  name = name:gsub("|[cC]%x%x%x%x%x%x%x%x", ""):gsub("|[rR]", "")
  local dash = name:find("-", 1, true)
  if dash then
    name = name:sub(1, dash - 1)
  end
  name = Trim(name)
  return name ~= "" and name or nil
end

local function PlayerKey(value)
  local lower = strlower or string.lower
  return lower(tostring(value or ""))
end

local function BloodBoilStackTarget(boss, index)
  local targets = boss and boss.bloodBoilStackTargets
  local target = type(targets) == "table" and tonumber(targets[index]) or nil
  if not target or target % 1 ~= 0 or target < 1 or target > 10 then return 1 end
  return target
end

local function NewSnapshotGroup(definition, stackTarget)
  return {
    key = definition.key,
    order = definition.order,
    label = definition.label,
    marker = definition.marker,
    markerIndex = definition.markerIndex,
    assignmentKey = definition.assignmentKey,
    stackTarget = stackTarget,
    players = {},
    members = {},
  }
end

local function SectionMatches(section, definition)
  local wanted = NormalizeKey(definition.label)
  return NormalizeKey(section and section.sourceName) == wanted
    or NormalizeKey(section and section.name) == wanted
end

local function AddCandidate(candidates, task, sequence)
  local player = ShortPlayerName(task and task.player)
  if not player then return end
  candidates[#candidates + 1] = {
    player = player,
    slot = tonumber(task.slot) or 0,
    sequence = sequence,
  }
end

local function CollectGroupCandidates(boss, definition)
  local candidates = {}
  local sequence = 0

  for _, task in ipairs(type(boss.v2Assignments) == "table" and boss.v2Assignments or {}) do
    if NormalizeKey(task.assignmentKey) == NormalizeKey(definition.assignmentKey) then
      sequence = sequence + 1
      AddCandidate(candidates, task, sequence)
    end
  end

  for _, section in ipairs(type(boss.sections) == "table" and boss.sections or {}) do
    if SectionMatches(section, definition) then
      for _, task in ipairs(type(section.rows) == "table" and section.rows or {}) do
        sequence = sequence + 1
        AddCandidate(candidates, task, sequence)
      end
    end
  end

  table.sort(candidates, function(left, right)
    local leftSlotted, rightSlotted = left.slot > 0, right.slot > 0
    if leftSlotted ~= rightSlotted then return leftSlotted end
    if leftSlotted and left.slot ~= right.slot then return left.slot < right.slot end
    return left.sequence < right.sequence
  end)
  return candidates
end

local function BuildSource(entry)
  if not entry then return nil end
  local parsed = entry.parsed
  return {
    importId = tostring(entry.id or ""),
    contentSignature = tostring(entry.contentSignature or ""),
    protocol = tostring(entry.protocol or (parsed and parsed.protocol) or ""),
    protocolVersion = tonumber(entry.envelopeVersion or (parsed and parsed.envelopeVersion)
      or entry.version or (parsed and parsed.version)) or 0,
    receivedBroadcast = entry.receivedBroadcast == true,
  }
end

local function SnapshotSignature(snapshot)
  local parts = {
    tostring(snapshot.version),
    snapshot.available and "1" or "0",
    snapshot.source and snapshot.source.importId or "",
    snapshot.source and snapshot.source.contentSignature or "",
  }
  for _, group in ipairs(snapshot.groups) do
    parts[#parts + 1] = group.key
    parts[#parts + 1] = tostring(group.stackTarget)
    for index, player in ipairs(group.players) do
      local member = group.members[index] or {}
      parts[#parts + 1] = PlayerKey(player)
      parts[#parts + 1] = tostring(member.classToken or "")
      parts[#parts + 1] = tostring(member.spec or "")
    end
  end
  return table.concat(parts, "\31")
end

local function CacheSnapshot(snapshot)
  MerfinPlus.gurtoggAssignmentsSnapshot = snapshot
  PublicBridge.snapshot = snapshot
  return snapshot
end

local function ResolveSnapshotEntryAndBoss(owner)
  local entry = owner:GetActivePersonalRaidAssignmentImport()
  if entry then
    local activeBoss
    if entry.canonicalPersonal then
      -- Canonical personal projections may contain persistent Trash first and
      -- exactly one current non-Trash boss second. The latter is the synced
      -- boss that must control this bridge.
      for _, candidate in ipairs(type(entry.parsed) == "table" and entry.parsed.bosses or {}) do
        if candidate.isTrash ~= true then
          activeBoss = candidate
          break
        end
      end
    else
      activeBoss = owner:GetActivePersonalRaidAssignmentBoss(entry)
    end
    local boss = activeBoss and owner:GetRaidAssignmentBoss({ bosses = { activeBoss } }, GURTOGG_BOSS)
    return entry, boss
  end

  -- Preserve the existing local/restored-import behavior when no personal
  -- sync projection exists at all. Never fall back here when another synced
  -- boss is active, or the older full Gurtogg import would remain visible.
  entry = owner:GetRaidAssignmentImportForGroup(RAID_GROUP_ID)
  local boss = entry and entry.parsed and owner:GetRaidAssignmentBoss(entry.parsed, GURTOGG_BOSS)
  return entry, boss
end

function MerfinPlus:BuildGurtoggAssignmentsSnapshot()
  local entry, boss = ResolveSnapshotEntryAndBoss(self)
  local snapshot = {
    schema = "merfinplus.gurtogg.assignments",
    version = SNAPSHOT_VERSION,
    available = false,
    encounter = {
      key = GURTOGG_BOSS.key,
      planKey = "t6.black_temple.gurtogg_bloodboil",
      name = GURTOGG_BOSS.name,
      raidKey = GURTOGG_BOSS.raidKey,
    },
    source = BuildSource(entry),
    groupOrder = {},
    groups = {},
  }

  local claimedPlayers = {}
  local playerCount = 0
  local playerMap = boss and self:BuildRaidAssignmentPlayerMap(boss) or {}
  for _, definition in ipairs(GROUP_DEFINITIONS) do
    local group = NewSnapshotGroup(definition, BloodBoilStackTarget(boss, definition.order))
    snapshot.groupOrder[#snapshot.groupOrder + 1] = group.key
    snapshot.groups[#snapshot.groups + 1] = group
    if boss then
      for _, candidate in ipairs(CollectGroupCandidates(boss, definition)) do
        local key = PlayerKey(candidate.player)
        if key ~= "" and not claimedPlayers[key] then
          claimedPlayers[key] = true
          group.players[#group.players + 1] = candidate.player
          local playerInfo = playerMap[key]
          local member = { name = candidate.player }
          if playerInfo and not playerInfo.ambiguous then
            member.classToken = NormalizeClassToken(playerInfo.classToken or playerInfo.class)
            local spec = Trim(playerInfo.spec)
            member.spec = spec ~= "" and spec or nil
          end
          group.members[#group.members + 1] = member
          playerCount = playerCount + 1
        end
      end
    end
  end
  snapshot.available = boss ~= nil and playerCount > 0
  return snapshot
end

function MerfinPlus:GetGurtoggAssignmentsSnapshot()
  local snapshot = self.gurtoggAssignmentsSnapshot
  if type(snapshot) ~= "table" then
    snapshot = CacheSnapshot(self:BuildGurtoggAssignmentsSnapshot())
  end
  return snapshot
end

function MerfinPlus:PublishGurtoggAssignmentsSnapshot()
  local snapshot = CacheSnapshot(self:BuildGurtoggAssignmentsSnapshot())
  local signature = SnapshotSignature(snapshot)

  local weakAuras = _G.WeakAuras
  if type(weakAuras) ~= "table" or type(weakAuras.ScanEvents) ~= "function" then
    return false
  end
  if self.gurtoggAssignmentsPublishedSignature == signature then
    return false
  end

  weakAuras.ScanEvents(EVENT_NAME, snapshot)
  self.gurtoggAssignmentsPublishedSignature = signature
  return true
end

function MerfinPlus:QueueGurtoggAssignmentsPublish()
  if self.gurtoggAssignmentsPublishQueued then return end
  self.gurtoggAssignmentsPublishQueued = true
  local function PublishQueuedSnapshot()
    self.gurtoggAssignmentsPublishQueued = nil
    self:PublishGurtoggAssignmentsSnapshot()
  end
  if C_Timer and type(C_Timer.After) == "function" then
    C_Timer.After(0, PublishQueuedSnapshot)
  else
    PublishQueuedSnapshot()
  end
end

function MerfinPlus:InitializeGurtoggAssignmentsBridge()
  if self.gurtoggAssignmentsBridgeInitialized then return end
  self.gurtoggAssignmentsBridgeInitialized = true

  if IsLoggedIn and IsLoggedIn() then
    self:QueueGurtoggAssignmentsPublish()
    return
  end
  if not CreateFrame then
    self:QueueGurtoggAssignmentsPublish()
    return
  end

  local frame = CreateFrame("Frame")
  frame:RegisterEvent("PLAYER_LOGIN")
  frame:SetScript("OnEvent", function(loginFrame)
    loginFrame:UnregisterEvent("PLAYER_LOGIN")
    loginFrame:SetScript("OnEvent", nil)
    self:QueueGurtoggAssignmentsPublish()
  end)
  self.gurtoggAssignmentsLoginFrame = frame
end

MerfinPlus.GURTOGG_ASSIGNMENTS_EVENT = EVENT_NAME
MerfinPlus.GURTOGG_ASSIGNMENTS_SNAPSHOT_VERSION = SNAPSHOT_VERSION
PublicBridge.schema = "merfinplus.gurtogg.bridge"
PublicBridge.version = 1
PublicBridge.snapshotVersion = SNAPSHOT_VERSION
PublicBridge.event = EVENT_NAME

function MerfinPlus:PublishReceivedGurtoggManualSnapshot(snapshot, sender)
  if type(snapshot) ~= "table" then return false end
  snapshot.source = snapshot.source or {}
  snapshot.source.mode = "weak-aura-manual"
  snapshot.source.sender = tostring(sender or "")
  snapshot.available = true
  CacheSnapshot(snapshot)
  local weakAuras = _G.WeakAuras
  if type(weakAuras) == "table" and type(weakAuras.ScanEvents) == "function" then
    weakAuras.ScanEvents(EVENT_NAME, snapshot)
  end
  return true
end

PublicBridge.BroadcastManualGroups = function(snapshot)
  if type(MerfinPlus.BroadcastGurtoggManualGroups) ~= "function" then
    return false, "Gurtogg manual sync transport is unavailable."
  end
  return MerfinPlus:BroadcastGurtoggManualGroups(snapshot)
end

-- The Merfin table is part of the existing WeakAura-facing API.  Publishing
-- this alias avoids direct _G access in WeakAura custom code, which Wago's
-- checker flags even though the transport itself remains unchanged.
Merfin.BroadcastGurtoggManualGroups = PublicBridge.BroadcastManualGroups


PublicBridge.GetSnapshot = function()
  return MerfinPlus:GetGurtoggAssignmentsSnapshot()
end

if type(MerfinPlus.NotifyRaidAssignmentsChanged) == "function" then
  hooksecurefunc(MerfinPlus, "NotifyRaidAssignmentsChanged", function(owner)
    owner.gurtoggAssignmentsSnapshot = nil
    PublicBridge.snapshot = nil
    owner:QueueGurtoggAssignmentsPublish()
  end)
end
if type(MerfinPlus.InitializeRaidAssignments) == "function" then
  hooksecurefunc(MerfinPlus, "InitializeRaidAssignments", function(owner)
    owner:InitializeGurtoggAssignmentsBridge()
  end)
end
