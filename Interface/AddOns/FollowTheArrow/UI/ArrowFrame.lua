local _, FTA = ...

FTA.ArrowUI = FTA.ArrowUI or {}

local function FormatYards(dist)
  if not dist then return "" end
  if dist < 10 then
    return ("%d yds"):format(math.floor(dist + 0.5))
  end
  return ("%d yds"):format(math.floor(dist))
end

function FTA.ArrowUI:Create()
  if self.frame then return self end

  local f = CreateFrame("Frame", "FollowTheArrow_ArrowFrame", UIParent, "BackdropTemplate")
  self.frame = f
  f:SetSize(64, 64)
  f:SetPoint("CENTER", UIParent, "CENTER", 280, 0)
  f:SetClampedToScreen(true)
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(frame) frame:StartMoving() end)
  f:SetScript("OnDragStop", function(frame) frame:StopMovingOrSizing() end)

  f:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 8,
    edgeSize = 10,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
  })
  f:SetBackdropColor(0, 0, 0, 0.35)

  local tex = f:CreateTexture(nil, "ARTWORK")
  self.tex = tex
  tex:SetPoint("CENTER", 0, 8)
  tex:SetSize(40, 40)

  tex:SetTexture("Interface\\Minimap\\MinimapArrow")
  tex:SetVertexColor(1, 1, 1, 1)

  local dist = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  self.distText = dist
  dist:SetPoint("TOP", tex, "BOTTOM", 0, -2)
  dist:SetText("")

  ReanchorDistText(self)

  f:Hide()
  return self
end

local function ReanchorDistText(self)
  if not self or not self.frame or not self.distText or not self.tex then return end

  local f = self.frame
  local t = self.distText
  local tex = self.tex

  local _, cy = f:GetCenter()
  if not cy then return end

  local screenH = UIParent and UIParent:GetHeight() or 1080
  local scale = f.GetScale and f:GetScale() or 1.0
  local pad = 2 + (10 * scale)

  local mode = (cy < (screenH * 0.35)) and "ABOVE" or "BELOW"
  if self._distAnchorMode == mode and self._distAnchorPad == pad then return end
  self._distAnchorMode = mode
  self._distAnchorPad = pad

  t:ClearAllPoints()
  if mode == "ABOVE" then
    t:SetPoint("BOTTOM", tex, "TOP", 0, pad)
  else
    t:SetPoint("TOP", tex, "BOTTOM", 0, -pad)
  end
end

function FTA.ArrowUI:SetTarget(target)
  self.target = target
end

function FTA.ArrowUI:ShowArrow()
  if self.frame and not self.frame:IsShown() then
    self.frame:Show()
  end
end

function FTA.ArrowUI:HideArrow()
  if self.frame and self.frame:IsShown() then
    self.frame:Hide()
  end
end

function FTA.ArrowUI:SetRotation(radians)
  if self.tex and radians then
    self.tex:SetRotation(radians - (math.pi / 2))
  end
end

function FTA.ArrowUI:SetDistance(distYards, vertHint)
  if not self.distText then return end
  local s = FormatYards(distYards)
  if vertHint then
    s = ("%s %s"):format(vertHint, s)
  end
  self.distText:SetText(s)
end
