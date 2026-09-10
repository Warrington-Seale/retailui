local _, FTA = ...

FTA.GuideArrow = FTA.GuideArrow or {}
local GuideArrow = FTA.GuideArrow

local UPDATE_INTERVAL = 0.05
local TWO_PI = math.pi * 2

--local TEX_UP       = "Interface\\AddOns\\FollowTheArrow\\Images\\Arrow3D.tga"
local TEX_UP       = "Interface\\AddOns\\FollowTheArrow\\Images\\ArrowV2Test.tga"
local TEX_DOWN     = "Interface\\AddOns\\FollowTheArrow\\Images\\Arrow3D_Down.tga"
local TEX_FALLBACK = "Interface\\Minimap\\MinimapArrow"

local COLS, ROWS = 9, 12
local TOTAL_CELLS = COLS * ROWS

local ARROW_SIZE = 80

local function GetArrowSettings()
  if type(FTADB) ~= "table" then return nil end
  if type(FTADB.profile) ~= "table" then return nil end
  return FTADB.profile.arrow
end

local function GetArrowColor(which, dr, dg, db, da)
  local a = GetArrowSettings()
  local c = a and a.colors and a.colors[which]
  if type(c) ~= "table" then return dr, dg, db, da end

  local r = tonumber(c.r)
  local g = tonumber(c.g)
  local b = tonumber(c.b)
  local a1 = tonumber(c.a)

  if r == nil or g == nil or b == nil then
    return dr, dg, db, da
  end
  if a1 == nil then a1 = da end
  return r, g, b, a1
end

local function GetArrowDB()
  if type(FTADB) ~= "table" then return nil end
  if type(FTADB.profile) ~= "table" then return nil end
  if type(FTADB.profile.ui) ~= "table" then return nil end

  FTADB.profile.ui.arrow = FTADB.profile.ui.arrow or {}
  return FTADB.profile.ui.arrow
end

local function LoadArrowPosition(frame)
  frame:ClearAllPoints()

  local p = GetArrowDB()
  if type(p) == "table" and p.point and p.relPoint and p.x ~= nil and p.y ~= nil then
    frame:SetPoint(p.point, UIParent, p.relPoint, p.x, p.y)
  else
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
  end
end

local function SaveArrowPosition(frame)
  local p = GetArrowDB()
  if type(p) ~= "table" then return end

  local point, _, relPoint, x, y = frame:GetPoint(1)
  if point and relPoint and x and y then
    p.point = point
    p.relPoint = relPoint
    p.x = x
    p.y = y
  end
end

local function Normalize01(v)
  if type(v) ~= "number" then return nil end
  if v > 1 then return v / 100 end
  return v
end

local function PickUsableMapID(mapID)
  if type(mapID) == "number" then
    return mapID
  end
  if type(mapID) == "table" then
    local best = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    if best then
      for _, id in ipairs(mapID) do
        if id == best then return id end
      end
    end

    for _, id in ipairs(mapID) do
      if type(id) == "number" then
        local pos = C_Map and C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(id, "player")
        if pos then
          local x, y = pos:GetXY()
          if x and y then return id end
        end
      end
    end

    for _, id in ipairs(mapID) do
      if type(id) == "number" then return id end
    end
  end
  return nil
end

local function NormalizeRadians(a)
  return (a + math.pi) % (TWO_PI) - math.pi
end

local function Clamp01(v)
  if v < 0 then return 0 end
  if v > 1 then return 1 end
  return v
end

local function Now()
  return (GetTime and GetTime()) or 0
end

local function FacingColor(delta)
  local perc = math.abs((math.pi - math.abs(delta)) / math.pi)
  perc = Clamp01(perc)

  local fr, fg, fb, fa = GetArrowColor("facing", 0, 1, 0, 1) 
  local mr, mg, mb, ma = GetArrowColor("mid",    1, 1, 0, 1) 
  local ar, ag, ab, aa = GetArrowColor("away",   1, 0, 0, 1) 

  local r, g, b, a
  if perc >= 0.5 then
    local t = (perc - 0.5) / 0.5
    r = mr + (fr - mr) * t
    g = mg + (fg - mg) * t
    b = mb + (fb - mb) * t
    a = ma + (fa - ma) * t
  else
    local t = perc / 0.5
    r = ar + (mr - ar) * t
    g = ag + (mg - ag) * t
    b = ab + (mb - ab) * t
    a = aa + (ma - aa) * t
  end

  local floor = 0.20
  r = floor + (1 - floor) * r
  g = floor + (1 - floor) * g

  return r, g, b, a
end

local function FormatDist(dist)
  if not dist then return "" end
  if dist < 10 then
    return ("%d yds"):format(math.floor(dist + 0.5))
  end
  return ("%d yds"):format(math.floor(dist))
end

local function GetCellTexCoord(column, row)
  local x1 = column / COLS
  local x2 = (column + 1) / COLS
  local y1 = row / ROWS
  local y2 = (row + 1) / ROWS
  return x1, x2, y1, y2
end

local texcoords = setmetatable({}, {
  __index = function(t, k)
    local col, row = k:match("(%d+):(%d+)")
    col, row = tonumber(col), tonumber(row)
    local x1, x2, y1, y2 = GetCellTexCoord(col, row)
    local obj = { x1, x2, y1, y2 }
    rawset(t, k, obj)
    return obj
  end
})

local function ComputeDeltaAndDistance(targetMapID, tx01, ty01)
  if not targetMapID then return nil end

  local facing = GetPlayerFacing()
  if not facing then return nil end

  local CMap = C_Map
  if not (CMap and CMap.GetBestMapForUnit and CMap.GetPlayerMapPosition) then
    return nil
  end

  local playerMapID = CMap.GetBestMapForUnit("player") or targetMapID
  if not playerMapID then return nil end

  local p = CMap.GetPlayerMapPosition(playerMapID, "player")
  if not p then return nil end

  local px01, py01 = p:GetXY()
  if not px01 or not py01 then return nil end

  local bearing
  local dist

  if CMap.GetWorldPosFromMapPos and CreateVector2D then
    local pContainer, pWorld = CMap.GetWorldPosFromMapPos(playerMapID, CreateVector2D(px01, py01))
    local tContainer, tWorld = CMap.GetWorldPosFromMapPos(targetMapID, CreateVector2D(tx01, ty01))

    if pContainer and tContainer and pContainer == tContainer and pWorld and tWorld then
      local wx1, wy1 = pWorld:GetXY()
      local wx2, wy2 = tWorld:GetXY()

      if wx1 and wy1 and wx2 and wy2 then
        local dxw = wx2 - wx1
        local dyw = wy2 - wy1
        dist = math.sqrt(dxw*dxw + dyw*dyw)
        bearing = math.atan2(dyw, dxw)
      end
    end
  end

  if not bearing then
    if playerMapID ~= targetMapID then
      return nil
    end
    local dx = tx01 - px01
    local dy = ty01 - py01
    bearing = math.atan2(dy, dx)
    dist = math.sqrt(dx*dx + dy*dy) * 1000
  end

  local delta = NormalizeRadians(bearing - facing)
  return delta, dist
end

local function ForceTextureVisible(tex, parent)
  tex:ClearAllPoints()
  tex:SetPoint("CENTER", parent, "CENTER", 0, 0)
  tex:SetSize(ARROW_SIZE, ARROW_SIZE)
  tex:SetDrawLayer("OVERLAY", 7)
  tex:SetBlendMode("BLEND")
  tex:SetAlpha(1)
  tex:Show()

  if tex.SetSnapToPixelGrid then tex:SetSnapToPixelGrid(false) end
  if tex.SetTexelSnappingBias then tex:SetTexelSnappingBias(0) end
end

local function HideLegacyFrames()
  local legacy = { "FTA_DebugArrow", "FTA_CrazyArrow", "FTA_CrazyTaxiArrow" }
  for _, name in ipairs(legacy) do
    local f = _G[name]
    if f and f.Hide then f:Hide() end
  end
end

local function SetSpriteForAngle(tex, angle)
  local cell = math.floor(angle / TWO_PI * TOTAL_CELLS + 0.5) % TOTAL_CELLS
  local column = cell % COLS
  local row = math.floor(cell / COLS)
  local key = column .. ":" .. row
  tex:SetTexCoord(unpack(texcoords[key]))
end

local function TryAdvanceChain(mode, key)
  if type(key) ~= "string" or key == "" then return false end
  if not (FTA and FTA.StepEngine) then return false end

  if mode == "WAYPOINT_CHAIN" or mode == "SEQUENCE_CHAIN" then
    if type(FTA.StepEngine.AdvanceChainIndex) == "function" then
      FTA.StepEngine:AdvanceChainIndex(key, 1)
      return true
    end
  end
  return false
end

local function UpdateDistAnchor(self)
  if not (self and self.frame and self.distText) then return end

  local baseScale = tonumber(self._baseScale) or 1.0
  if baseScale < 0.2 then baseScale = 0.2 end
  if baseScale > 3.0 then baseScale = 3.0 end

  local overflow = 0
  if baseScale > 1.0 then
    overflow = (ARROW_SIZE * (baseScale - 1.0)) * 0.5
  end

  local pad = 2 + overflow

  local f = self.frame
  local d = self.distText

  local uiH = UIParent and UIParent.GetHeight and UIParent:GetHeight() or 0
  local fBottom = f.GetBottom and f:GetBottom() or nil
  local fTop = f.GetTop and f:GetTop() or nil

  local mode = "BELOW"
  if uiH > 0 and fBottom and d.GetStringHeight then
    local textH = d:GetStringHeight() or 12
    local textScale = tonumber(self._textScaleForAnchor) or 1.0
    local needBelow = pad + (textH * textScale) + 6

    if (fBottom - needBelow) < 0 then
      mode = "ABOVE"
      if fTop then
        local needAbove = pad + (textH * textScale) + 6
        if (fTop + needAbove) > uiH then
          mode = "BELOW"
        end
      end
    end
  end

  if self._distAnchorMode == mode and self._distAnchorPad == pad then
    return
  end
  self._distAnchorMode = mode
  self._distAnchorPad = pad

  d:ClearAllPoints()
  if mode == "ABOVE" then
    d:SetPoint("BOTTOM", f, "TOP", 0, pad)
  else
    d:SetPoint("TOP", f, "BOTTOM", 0, -pad)
  end
end

function GuideArrow:_ApplySettings()
  if not self.frame then return end

  local a = GetArrowSettings() or {}
  local scale = tonumber(a.scale) or 1.0
  local textScale = tonumber(a.textScale) or 1.0
  local locked = (a.locked == true)

  if scale < 0.2 then scale = 0.2 end
  if scale > 3.0 then scale = 3.0 end
  if textScale < 0.2 then textScale = 0.2 end
  if textScale > 3.0 then textScale = 3.0 end

  self._baseScale = scale
  self._textScaleForAnchor = textScale

  if self.distText and self.distText.SetScale then
    self.distText:SetScale(textScale)
  end

  self._locked = locked

  if self.frame.EnableMouse then
    self.frame:EnableMouse(not locked)
  end

  if locked then
    self.frame:StopMovingOrSizing()
  end

  UpdateDistAnchor(self)
end

function GuideArrow:_TryFireOnArrive()
  self._arriveLast = self._arriveLast or {}
  self._arriveLastIdx = self._arriveLastIdx or {}

  local oa = self.target and self.target.onArrive
  if not oa then return false end

  local key = oa.key or "default"
  local debounce = oa.debounce or 0.75
  local t = Now()

  if oa.mode == "SEQUENCE_CHAIN" and type(oa.idx) == "number" then
    if self._arriveLastIdx[key] == oa.idx then
      return false
    end
  end

  local lastT = self._arriveLast[key]
  if lastT and (t - lastT) < debounce then
    return false
  end

  self._arriveLast[key] = t
  if oa.mode == "SEQUENCE_CHAIN" and type(oa.idx) == "number" then
    self._arriveLastIdx[key] = oa.idx
  end

  local didSomething = false

  if type(oa.mode) == "string" then
    if TryAdvanceChain(oa.mode, oa.key or key) then
      didSomething = true
    end
  end

  if (not didSomething) and type(oa.fn) == "function" then
    local ok, err = pcall(oa.fn, oa)
    if not ok and FTA and FTA.Print then
      FTA:Print("GuideArrow onArrive fn error: " .. tostring(err))
    end
    didSomething = true
  end

  if (not didSomething) and FTA and type(FTA.OnArrowArrive) == "function" then
    local ok, err = pcall(FTA.OnArrowArrive, FTA, oa)
    if not ok and FTA.Print then
      FTA:Print("FTA:OnArrowArrive error: " .. tostring(err))
    end
    didSomething = true
  end

  if didSomething then
    self:RequestRefresh()
    return true
  end

  return false
end

function GuideArrow:_RefreshFromEngine()
  if not (FTA.StepEngine and FTA.StepEngine.GetCurrentStep) then
    self.target = nil
    return
  end
  if not (FTA.Resolve and FTA.Resolve.GetCurrentTarget) then
    self.target = nil
    return
  end

  local mod, _, step = FTA.StepEngine:GetCurrentStep()
  if not mod or not step then
    self.target = nil
    return
  end

  local tgt = FTA.Resolve:GetCurrentTarget(mod, step)
  if not tgt then
    self.target = nil
    return
  end

  self:SetTarget(tgt)
end

function GuideArrow:SetTarget(tgt)
  if not tgt or tgt.x == nil or tgt.y == nil then
    self.target = nil
    return
  end

  local mapIDs = nil
  if type(tgt.mapIDs) == "table" and #tgt.mapIDs > 0 then
    mapIDs = tgt.mapIDs
  elseif tgt.mapID ~= nil then
    mapIDs = tgt.mapID
  end

  local mapID = PickUsableMapID(mapIDs)
  if not mapID then
    self.target = nil
    return
  end

  local x01 = Normalize01(tgt.x)
  local y01 = Normalize01(tgt.y)
  if not x01 or not y01 then
    self.target = nil
    return
  end

  self.target = {
    mapIDs = mapIDs,
    mapID  = mapID,
    x01    = x01,
    y01    = y01,
    radius = tgt.radius or 20,
    arriveBehavior = tgt.arriveBehavior,
    arriveShowDown = tgt.arriveShowDown,
    onArrive       = tgt.onArrive,
  }
end

function GuideArrow:RequestRefresh()
  self._needsRefresh = true

  if self.frame then
    self:_ApplySettings()
  end

  if self.frame and self._uiEnabled ~= false and not self.frame:IsShown() then
    self.frame:Show()
  end
end

function GuideArrow:SetEnabled(enabled)
  self._uiEnabled = (enabled == true)

  if not self.frame then return end

  if self._uiEnabled then
    self.frame:Show()
    self:RequestRefresh()
  else
    self.frame:Hide()
  end
end

function GuideArrow:IsEnabled()
  return self._uiEnabled ~= false
end

function GuideArrow:Init()
  if self.frame then return end

  HideLegacyFrames()

  local f = CreateFrame("Frame", "FTA_GuideArrow", UIParent)
  f:SetSize(ARROW_SIZE, ARROW_SIZE)
  LoadArrowPosition(f)
  f:SetFrameStrata("HIGH")
  f:SetAlpha(1)
  f:Show()

  f:EnableMouse(true)
  f:SetMovable(true)
  f:SetClampedToScreen(true)
  f:RegisterForDrag("LeftButton")

  f:SetScript("OnDragStart", function(self)
    if InCombatLockdown() then return end
    if GuideArrow._locked then return end
    GuideArrow._dragging = true
    self:StartMoving()
  end)

  f:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    GuideArrow._dragging = false
    SaveArrowPosition(self)
    UpdateDistAnchor(GuideArrow)
  end)

  local arrowHolder = CreateFrame("Frame", nil, f)
  arrowHolder:SetAllPoints(f)

  local tex = arrowHolder:CreateTexture(nil, "OVERLAY")
  ForceTextureVisible(tex, arrowHolder)

  local distText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  distText:SetText("")

  self.frame = f
  self._uiEnabled = (self._uiEnabled ~= false)
  self.arrowHolder = arrowHolder
  self.tex = tex
  self.distText = distText

  self.target = nil
  self._accum = 0
  self._pulseT = 0
  self._arriveLast = {}
  self._needsRefresh = true
  self._lastRefreshT = 0
  self._baseScale = 1.0
  self._textScaleForAnchor = 1.0
  self._locked = false
  self._distAnchorMode = nil
  self._distAnchorPad = nil
  self._dragging = false

  self:_ApplySettings()

  local ef = CreateFrame("Frame")
  self._eventFrame = ef

  ef:RegisterEvent("PLAYER_ENTERING_WORLD")
  ef:RegisterEvent("ZONE_CHANGED")
  ef:RegisterEvent("ZONE_CHANGED_INDOORS")
  ef:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  ef:RegisterEvent("NEW_WMO_CHUNK")

  ef:RegisterEvent("QUEST_LOG_UPDATE")
  ef:RegisterEvent("QUEST_ACCEPTED")
  ef:RegisterEvent("QUEST_REMOVED")
  ef:RegisterEvent("QUEST_TURNED_IN")
  ef:RegisterEvent("SUPER_TRACKING_CHANGED")

  ef:SetScript("OnEvent", function()
    GuideArrow:RequestRefresh()
  end)

  f:SetScript("OnUpdate", function(_, elapsed)
    GuideArrow:_OnUpdate(elapsed)
  end)
end

function GuideArrow:_OnUpdate(elapsed)
  if self._uiEnabled == false then
    if self.frame and self.frame:IsShown() then
      self.frame:Hide()
    end
    return
  end

  if not self.frame or not self.tex then return end

  UpdateDistAnchor(self)

  self._accum = self._accum + elapsed
  if self._accum < UPDATE_INTERVAL then return end
  self._accum = 0

  if self._needsRefresh then
    local t = Now()
    if (t - (self._lastRefreshT or 0)) >= 0.05 then
      self._needsRefresh = false
      self._lastRefreshT = t
      self:_ApplySettings()
      self:_RefreshFromEngine()
    end
  end

  if not self.target then
    if self.distText then self.distText:SetText("") end
    self.frame:Hide()
    return
  end

  if self.target.mapIDs ~= nil then
    local best = PickUsableMapID(self.target.mapIDs)
    if best then
      self.target.mapID = best
    end
  end

  local delta, dist = ComputeDeltaAndDistance(self.target.mapID, self.target.x01, self.target.y01)
  if not delta or not dist then
    self._needsRefresh = true
    if self.distText then self.distText:SetText("") end
    self.frame:Hide()
    return
  end

  local inRadius = (dist <= (self.target.radius or 20))
  if self.distText then
    self.distText:SetText("(" .. FormatDist(dist) .. ")")
  end

  local baseScale = self._baseScale or 1.0

  if inRadius then
    local behavior = self.target.arriveBehavior

    if behavior == "ADVANCE" then
      self:_TryFireOnArrive()

      if self.target.arriveShowDown then
        local ok = self.tex:SetTexture(TEX_DOWN)
        if ok then
          self.tex:SetTexCoord(0, 1, 0, 1)
          local fr, fg, fb, fa = GetArrowColor("facing", 0, 1, 0, 1)
          self.tex:SetVertexColor(fr, fg, fb, fa or 1)
        else
          self.tex:SetTexture(TEX_FALLBACK)
          self.tex:SetTexCoord(0, 1, 0, 1)
          self.tex:SetVertexColor(1.0, 0.7, 0.0, 1)
        end

        self._pulseT = (self._pulseT or 0) + elapsed
        local base = 1.00
        local amp = 0.004
        local freq = 1.25
        local bounceAmp = 6
        local phase = self._pulseT * (TWO_PI * freq)
        local pulse = base + amp * math.sin(phase)
        local yOffset = math.abs(math.sin(phase)) * bounceAmp

        if self.arrowHolder then
          self.arrowHolder:SetScale(baseScale * pulse)
        end

        self.tex:ClearAllPoints()
        self.tex:SetPoint("CENTER", self.arrowHolder or self.frame, "CENTER", 0, yOffset)
        self.tex:SetSize(ARROW_SIZE, ARROW_SIZE)

        self.frame:Show()
        return
      end

      if self.arrowHolder then
        self.arrowHolder:SetScale(baseScale)
      else
        self.tex:SetScale(baseScale)
      end

      self.tex:ClearAllPoints()
      self.tex:SetPoint("CENTER", self.arrowHolder or self.frame, "CENTER", 0, 0)
      self.tex:SetSize(ARROW_SIZE, ARROW_SIZE)
    else
      local ok = self.tex:SetTexture(TEX_DOWN)
      if not ok then
        self.tex:SetTexture(TEX_FALLBACK)
        self.tex:SetTexCoord(0, 1, 0, 1)
        self.tex:SetVertexColor(1.0, 0.7, 0.0, 1)
        if self.arrowHolder then
          self.arrowHolder:SetScale(baseScale)
        else
          self.tex:SetScale(baseScale)
        end

        self.tex:ClearAllPoints()
        self.tex:SetPoint("CENTER", self.arrowHolder or self.frame, "CENTER", 0, 0)
        self.tex:SetSize(ARROW_SIZE, ARROW_SIZE)

        self.frame:Show()
        return
      end

      self.tex:SetTexCoord(0, 1, 0, 1)
      local fr, fg, fb, fa = GetArrowColor("facing", 0, 1, 0, 1)
      self.tex:SetVertexColor(fr, fg, fb, fa or 1)

      self._pulseT = (self._pulseT or 0) + elapsed
      local base = 1.00
      local amp = 0.004
      local freq = 1.25
      local bounceAmp = 6
      local phase = self._pulseT * (TWO_PI * freq)
      local pulse = base + amp * math.sin(phase)
      local yOffset = math.abs(math.sin(phase)) * bounceAmp

      if self.arrowHolder then
        self.arrowHolder:SetScale(baseScale * pulse)
      end

      self.tex:ClearAllPoints()
      self.tex:SetPoint("CENTER", self.arrowHolder or self.frame, "CENTER", 0, yOffset)
      self.tex:SetSize(ARROW_SIZE, ARROW_SIZE)

      self.frame:Show()
      return
    end
  end

  if self.arrowHolder then
    self.arrowHolder:SetScale(baseScale)
  else
    self.tex:SetScale(baseScale)
  end

  self.tex:ClearAllPoints()
  self.tex:SetPoint("CENTER", self.arrowHolder or self.frame, "CENTER", 0, 0)
  self.tex:SetSize(ARROW_SIZE, ARROW_SIZE)

  local ok = self.tex:SetTexture(TEX_UP)
  if not ok then
    self.tex:SetTexture(TEX_FALLBACK)
    self.tex:SetTexCoord(0, 1, 0, 1)
    self.tex:SetVertexColor(1.0, 0.7, 0.0, 1)
    self.frame:Show()
    return
  end

  SetSpriteForAngle(self.tex, delta)

  local r, g, b, a = FacingColor(delta)
  self.tex:SetVertexColor(r, g, b, a or 1)

  self.frame:Show()
end

function GuideArrow:ForceRefreshNow()
  if self.frame and not self.frame:IsShown() then
    self.frame:Show()
  end
  self._needsRefresh = false
  self._lastRefreshT = 0
  self:_ApplySettings()
  self:_RefreshFromEngine()
end