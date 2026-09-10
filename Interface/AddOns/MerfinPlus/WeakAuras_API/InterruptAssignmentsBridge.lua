-- Guild Manager projection for the optional Reliquary/Council interrupt WeakAura.
local MerfinPlus = LibStub("AceAddon-3.0"):GetAddon("MerfinPlus")

local EVENT_NAME = "MERFINPLUS_INTERRUPT_ASSIGNMENTS_UPDATED"
local PUBLIC_NAME = "MerfinPlusInterruptAssignments"
local Public = _G[PUBLIC_NAME] or {}
_G[PUBLIC_NAME] = Public

local ROTATIONS = {
  reliquary = {
    key = "reliquary", label = "Reliquary of Souls", assignmentKey = "reliquaryspiritshockinterrupts",
    sectionNames = { "Spirit Shock Interrupt Rotation" },
    boss = { key = "ReliqoftheLost", name = "Reliquary of Souls", raidKey = "black_temple" },
  },
  council = {
    key = "council", label = "Lady Malande", assignmentKey = "councilmalandeinterrupts",
    sectionNames = { "Lady Malande Circle of Healing Interrupts" },
    boss = { key = "IllidariCouncil", name = "The Illidari Council", raidKey = "black_temple" },
  },
}

local function trim(value)
  return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalize(value)
  return trim(value):lower():gsub("[%s%p%c]+", "")
end

local function shortName(value)
  local name = trim(value):gsub("|[cC]%x%x%x%x%x%x%x%x", ""):gsub("|[rR]", "")
  name = name:match("^([^%-]+)") or name
  return name ~= "" and name or nil
end

local function collect(boss, definition)
  local candidates, sequence = {}, 0
  local sectionNames = {}
  for _, name in ipairs(definition.sectionNames or {}) do
    sectionNames[normalize(name)] = true
  end
  local function add(task)
    local player = shortName(task and task.player)
    if not player then return end
    sequence = sequence + 1
    candidates[#candidates + 1] = { name = player, slot = tonumber(task.slot) or 0, sequence = sequence }
  end
  for _, task in ipairs(type(boss and boss.v2Assignments) == "table" and boss.v2Assignments or {}) do
    if normalize(task.assignmentKey) == normalize(definition.assignmentKey) then add(task) end
  end
  for _, section in ipairs(type(boss and boss.sections) == "table" and boss.sections or {}) do
    if normalize(section.sourceName) == normalize(definition.assignmentKey)
      or sectionNames[normalize(section.sourceName)]
      or sectionNames[normalize(section.name)] then
      for _, task in ipairs(type(section.rows) == "table" and section.rows or {}) do add(task) end
    end
  end
  table.sort(candidates, function(left, right)
    local leftSlotted, rightSlotted = left.slot > 0, right.slot > 0
    if leftSlotted ~= rightSlotted then return leftSlotted end
    if leftSlotted and left.slot ~= right.slot then return left.slot < right.slot end
    return left.sequence < right.sequence
  end)
  local result = {}
  for _, candidate in ipairs(candidates) do
    if #result == 4 then break end
    result[#result + 1] = candidate.name
  end
  return result
end

local function source(entry)
  if not entry then return nil end
  return { importId = tostring(entry.id or ""), contentSignature = tostring(entry.contentSignature or "") }
end

function MerfinPlus:BuildInterruptAssignmentsSnapshot()
  local entry
  if type(self.GetActivePersonalRaidAssignmentImport) == "function" then
    entry = self:GetActivePersonalRaidAssignmentImport()
  end
  if not entry and type(self.GetRaidAssignmentImportForGroup) == "function" then
    entry = self:GetRaidAssignmentImportForGroup("bt_mh")
  end
  local snapshot = { schema = "merfinplus.interrupt.assignments", version = 1, available = false, source = source(entry), rotations = {} }
  for key, definition in pairs(ROTATIONS) do
    local boss = entry and entry.parsed and type(self.GetRaidAssignmentBoss) == "function"
      and self:GetRaidAssignmentBoss(entry.parsed, definition.boss)
    local players = collect(boss, definition)
    snapshot.rotations[key] = { key = key, label = definition.label, players = players }
    if #players > 0 then snapshot.available = true end
  end
  return snapshot
end

function MerfinPlus:GetInterruptAssignmentsSnapshot()
  if type(self.interruptAssignmentsSnapshot) ~= "table" then
    self.interruptAssignmentsSnapshot = self:BuildInterruptAssignmentsSnapshot()
  end
  return self.interruptAssignmentsSnapshot
end

function MerfinPlus:PublishInterruptAssignmentsSnapshot()
  local snapshot = self:BuildInterruptAssignmentsSnapshot()
  self.interruptAssignmentsSnapshot = snapshot
  Public.snapshot = snapshot
  if _G.WeakAuras and type(_G.WeakAuras.ScanEvents) == "function" then
    _G.WeakAuras.ScanEvents(EVENT_NAME, snapshot)
    return true
  end
  return false
end

function MerfinPlus:QueueInterruptAssignmentsPublish()
  if self.interruptAssignmentsPublishQueued then return end
  self.interruptAssignmentsPublishQueued = true
  local function publish()
    self.interruptAssignmentsPublishQueued = nil
    self:PublishInterruptAssignmentsSnapshot()
  end
  if C_Timer and type(C_Timer.After) == "function" then C_Timer.After(0, publish) else publish() end
end

function MerfinPlus:PublishReceivedInterruptManualSnapshot(snapshot, sender)
  if type(snapshot) ~= "table" or type(snapshot.rotations) ~= "table" then return false end
  snapshot.source = { mode = "weak-aura-manual", sender = tostring(sender or "") }
  snapshot.available = true
  self.interruptAssignmentsSnapshot = snapshot
  Public.snapshot = snapshot
  if _G.WeakAuras and type(_G.WeakAuras.ScanEvents) == "function" then _G.WeakAuras.ScanEvents(EVENT_NAME, snapshot) end
  return true
end

Public.GetSnapshot = function() return MerfinPlus:GetInterruptAssignmentsSnapshot() end
Public.BroadcastManualRotations = function(snapshot)
  if type(MerfinPlus.BroadcastInterruptManualAssignments) ~= "function" then return false, "Interrupt manual sync transport is unavailable." end
  return MerfinPlus:BroadcastInterruptManualAssignments(snapshot)
end
Merfin.BroadcastInterruptManualAssignments = Public.BroadcastManualRotations

if type(MerfinPlus.NotifyRaidAssignmentsChanged) == "function" then
  hooksecurefunc(MerfinPlus, "NotifyRaidAssignmentsChanged", function(owner)
    owner.interruptAssignmentsSnapshot = nil
    Public.snapshot = nil
    owner:QueueInterruptAssignmentsPublish()
  end)
end
if type(MerfinPlus.InitializeRaidAssignments) == "function" then
  hooksecurefunc(MerfinPlus, "InitializeRaidAssignments", function(owner) owner:QueueInterruptAssignmentsPublish() end)
end
