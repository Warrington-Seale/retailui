local _, FTA = ...

FTA.Waypoint = {}

local function NormalizeCoord(v)
  if type(v) ~= "number" then return nil end
  if v > 1 then v = v / 100 end
  return v
end

local function IsValidCoord(v)
  return type(v) == "number" and v > 0 and v < 1
end

local function TrySetUserWaypointOnMap(mapID, x, y)
  if type(mapID) ~= "number" or mapID <= 0 then return false end
  local uiMapPoint = UiMapPoint.CreateFromCoordinates(mapID, x, y)
  if not uiMapPoint then return false end
  C_Map.SetUserWaypoint(uiMapPoint)
  if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
  end
  return true
end

local function NormalizeMapIDs(mapIDsOrID)
  local mapIDs = {}
  if type(mapIDsOrID) == "number" then
    if mapIDsOrID > 0 then mapIDs[1] = mapIDsOrID end
  elseif type(mapIDsOrID) == "table" then
    for _, id in ipairs(mapIDsOrID) do
      if type(id) == "number" and id > 0 then
        mapIDs[#mapIDs + 1] = id
      end
    end
  end
  return mapIDs
end

local function PickBestMapID(mapIDs)
  if not (C_Map and C_Map.GetPlayerMapPosition) then
    return mapIDs[1]
  end

  for _, id in ipairs(mapIDs) do
    local pos = C_Map.GetPlayerMapPosition(id, "player")
    if pos then
      return id
    end
  end

  return mapIDs[1]
end

local function SetUserWaypoint(mapIDsOrID, x, y)
  if not (C_Map and C_Map.SetUserWaypoint and C_Map.ClearUserWaypoint) then
    return false
  end

  x = NormalizeCoord(x)
  y = NormalizeCoord(y)
  if not (IsValidCoord(x) and IsValidCoord(y)) then
    return false
  end

  local mapIDs = NormalizeMapIDs(mapIDsOrID)
  if #mapIDs < 1 then return false end

  local best = PickBestMapID(mapIDs)
  if best and TrySetUserWaypointOnMap(best, x, y) then
    return true
  end

  for _, id in ipairs(mapIDs) do
    if id ~= best and TrySetUserWaypointOnMap(id, x, y) then
      return true
    end
  end

  return false
end

function FTA.Waypoint:Clear()
  
end

function FTA.Waypoint:UpdateToCurrentStep()

  return
end