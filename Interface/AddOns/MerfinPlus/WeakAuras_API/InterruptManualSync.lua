-- Leader-only transport for optional manual Reliquary/Council interrupt rotations.
local MerfinPlus = LibStub("AceAddon-3.0"):GetAddon("MerfinPlus")
local PREFIX, MAX_BYTES, CHUNK_BYTES, MAX_CHUNKS = "MFINT1", 4096, 160, 32
local incoming, outgoing = {}, {}

local function announce(message)
  if DEFAULT_CHAT_FRAME and type(DEFAULT_CHAT_FRAME.AddMessage) == "function" then
    DEFAULT_CHAT_FRAME:AddMessage("|cff57d9ffMerfinPlus Manual Sync Interrupts:|r " .. tostring(message))
  end
end

local function shortName(value)
  local name = tostring(value or ""):match("^([^%-]+)")
  return name and name:lower() or ""
end

local function canSend()
  return IsInGroup and IsInGroup() and UnitIsGroupLeader("player")
end

local function unitForName(name)
  local wanted = shortName(name)
  if wanted == shortName(UnitName("player")) then return "player" end
  local prefix = IsInRaid and IsInRaid() and "raid" or "party"
  for index = 1, (GetNumGroupMembers and GetNumGroupMembers() or 0) do
    local unit = prefix .. index
    if shortName(UnitName(unit)) == wanted then return unit end
  end
end

local function coloredName(name)
  local unit = unitForName(name)
  local classToken = unit and select(2, UnitClass(unit))
  local color = classToken and RAID_CLASS_COLORS and RAID_CLASS_COLORS[classToken]
  local code = color and (color.colorStr or string.format("ff%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255))
  local display = tostring(name or ""):match("^([^%-]+)") or tostring(name or "")
  return code and "|c" .. code .. display .. "|r" or display
end

local function authorized(sender)
  local wanted = shortName(sender)
  if wanted == "" then return false end
  if UnitIsGroupLeader("player") and wanted == shortName(UnitName("player")) then return true end
  -- Raid roster ranks are the authoritative cross-client identity source.
  -- Some clients do not reliably expose leader/assistant status through a
  -- party/raid unit token while an addon message is being handled.
  if IsInRaid and IsInRaid() and GetRaidRosterInfo then
    for index = 1, (GetNumGroupMembers and GetNumGroupMembers() or 0) do
      local name, rank = GetRaidRosterInfo(index)
      if shortName(name) == wanted then return tonumber(rank) == 2 end
    end
    return false
  end
  local prefix = IsInRaid and IsInRaid() and "raid" or "party"
  for index = 1, (GetNumGroupMembers and GetNumGroupMembers() or 0) do
    local unit = prefix .. index
    if shortName(UnitName(unit)) == wanted then return UnitIsGroupLeader(unit) end
  end
  return false
end

local function normalize(snapshot)
  if type(snapshot) ~= "table" or type(snapshot.rotations) ~= "table" then return nil end
  local result = { schema = "merfinplus.interrupt.assignments", version = 1, available = true, rotations = {} }
  for _, key in ipairs({ "reliquary", "council" }) do
    local rotation, output = snapshot.rotations[key], { key = key, players = {} }
    for _, value in ipairs(type(rotation) == "table" and rotation.players or {}) do
      local name = tostring(type(value) == "table" and value.name or value or ""):match("^([^%-]+)")
      if not name or name == "" or #name > 48 or #output.players == 4 then return nil end
      output.players[#output.players + 1] = name
    end
    result.rotations[key] = output
  end
  return result
end

local function encode(snapshot)
  local serializer, deflate = LibStub("AceSerializer-3.0", true), LibStub("LibDeflate", true)
  if not serializer or not deflate then return nil end
  local serialized = serializer:Serialize(snapshot)
  local compressed = type(serialized) == "string" and deflate:CompressDeflate(serialized)
  return compressed and deflate:EncodeForWoWAddonChannel(compressed) or nil
end

local function decode(payload)
  local deflate, serializer = LibStub("LibDeflate", true), LibStub("AceSerializer-3.0", true)
  if not deflate or not serializer or type(payload) ~= "string" or #payload > MAX_BYTES then return nil end
  local compressed = deflate:DecodeForWoWAddonChannel(payload)
  local serialized = compressed and deflate:DecompressDeflate(compressed)
  if type(serialized) ~= "string" then return nil end
  local ok, snapshot = serializer:Deserialize(serialized)
  return ok and normalize(snapshot) or nil
end

function MerfinPlus:BroadcastInterruptManualAssignments(snapshot)
  if not canSend() then return false, "Only the group leader can sync manual rotations." end
  local normalized, payload = normalize(snapshot), nil
  if normalized then payload = encode(normalized) end
  if not payload or #payload > MAX_BYTES then return false, "Manual interrupt rotations could not be encoded." end
  local send = C_ChatInfo and C_ChatInfo.SendAddonMessage or SendAddonMessage
  local register = C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix or RegisterAddonMessagePrefix
  if not send then return false, "Addon-message transport is unavailable." end
  if register then register(PREFIX) end
  local total = math.ceil(#payload / CHUNK_BYTES)
  if total < 1 or total > MAX_CHUNKS then return false, "Manual interrupt rotations are too large." end
  self.interruptManualSequence = (self.interruptManualSequence or 0) + 1
  local transfer = tostring((GetServerTime and GetServerTime()) or time()) .. "-" .. self.interruptManualSequence
  outgoing[transfer] = { acknowledged = {}, rejected = {} }
  local channel = IsInRaid() and "RAID" or "PARTY"
  send(PREFIX, table.concat({ "S", transfer, total }, "|"), channel)
  for index = 1, total do send(PREFIX, table.concat({ "D", transfer, index, total, payload:sub((index - 1) * CHUNK_BYTES + 1, index * CHUNK_BYTES) }, "|"), channel) end
  self:PublishReceivedInterruptManualSnapshot(normalized, UnitName("player"))
  C_Timer.After(3, function()
    local state = outgoing[transfer]
    if not state then return end
    outgoing[transfer] = nil
    local names = {}
    for _, name in pairs(state.acknowledged) do names[#names + 1] = coloredName(name) end
    table.sort(names)
    if #names > 0 then
      announce("received by " .. table.concat(names, ", ") .. ".")
    elseif next(state.rejected) then
      local failures = {}
      for name, reason in pairs(state.rejected) do failures[#failures + 1] = coloredName(name) .. " (" .. reason .. ")" end
      table.sort(failures)
      announce("not applied by " .. table.concat(failures, ". ") .. ".")
    else
      announce("sent — no receiver confirmation yet.")
    end
  end)
  return true
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:SetScript("OnEvent", function(_, event, prefix, message, channel, sender)
  if event == "PLAYER_LOGIN" then
    local register = C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix or RegisterAddonMessagePrefix
    if register then register(PREFIX) end
    return
  end
  if prefix ~= PREFIX then return end
  local kind, transfer, a, b, data = strsplit("|", message, 5)
  if kind == "A" then
    -- ACKs are deliberately whispered back to the initiating sender.  Do not
    -- require a specific chat channel here: the transfer id is sender-local
    -- and the roster check below still binds the confirmation to a group unit.
    local state = outgoing[transfer]
    if state and unitForName(sender) then state.acknowledged[shortName(sender)] = sender end
    return
  end
  if kind == "N" then
    local state = outgoing[transfer]
    if state and unitForName(sender) then state.rejected[sender] = tostring(a or "rejected") end
    return
  end
  local send = C_ChatInfo and C_ChatInfo.SendAddonMessage or SendAddonMessage
  local function reject(reason)
    if send and type(transfer) == "string" and transfer ~= "" then
      send(PREFIX, table.concat({ "N", transfer, reason }, "|"), "WHISPER", sender)
    end
  end
  if channel ~= "RAID" and channel ~= "PARTY" then return end
  if not authorized(sender) then reject("sender-not-group-leader") return end
  if kind == "S" then
    local total = tonumber(a)
    if total and total >= 1 and total <= MAX_CHUNKS then
      incoming[sender] = { transfer = transfer, total = total, chunks = {} }
      C_Timer.After(10, function() if incoming[sender] and incoming[sender].transfer == transfer then incoming[sender] = nil end end)
    else reject("invalid-start") end
    return
  end
  if kind ~= "D" then return end
  local state, index, total = incoming[sender], tonumber(a), tonumber(b)
  if not state or state.transfer ~= transfer then reject("missing-start") return end
  if state.total ~= total or not index or index < 1 or index > total or type(data) ~= "string" or #data > CHUNK_BYTES then reject("invalid-chunk") return end
  state.chunks[index] = data
  for item = 1, total do if not state.chunks[item] then return end end
  incoming[sender] = nil
  local snapshot = decode(table.concat(state.chunks))
  if snapshot then
    MerfinPlus:PublishReceivedInterruptManualSnapshot(snapshot, sender)
    announce("received and applied from " .. coloredName(sender) .. ".")
    if send then send(PREFIX, table.concat({ "A", transfer }, "|"), "WHISPER", sender) end
  else
    reject("decode-failed")
  end
end)
