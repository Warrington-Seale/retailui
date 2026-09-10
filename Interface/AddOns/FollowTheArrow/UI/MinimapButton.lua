local _, FTA = ...

FTA.MinimapButton = FTA.MinimapButton or {}

local ICON_TEXTURE = "Interface\\Icons\\INV_Misc_Map_01"
local BUTTON_RADIUS = 102

local function EnsureDefaults()
  FTADB = FTADB or {}
  FTADB.profile = FTADB.profile or {}
  FTADB.profile.minimap = FTADB.profile.minimap or {}

  local mm = FTADB.profile.minimap

  if mm.hide == nil then
    mm.hide = false
  end

  if mm.angle == nil then
    mm.angle = 225
  end
end

local function GetAngle()
  EnsureDefaults()
  return FTADB.profile.minimap.angle or 225
end

local function SetAngle(angle)
  EnsureDefaults()
  FTADB.profile.minimap.angle = angle
end

local function UpdatePosition(button)
  local angle = math.rad(GetAngle())
  local x = math.cos(angle) * BUTTON_RADIUS
  local y = math.sin(angle) * BUTTON_RADIUS
  button:ClearAllPoints()
  button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

local function UpdateDragPosition(button)
  local mx, my = Minimap:GetCenter()
  local px, py = GetCursorPosition()
  local scale = UIParent:GetScale()
  px = px / scale
  py = py / scale

  local angle = math.deg(math.atan2(py - my, px - mx))
  if angle < 0 then
    angle = angle + 360
  end

  SetAngle(angle)
  UpdatePosition(button)
end

local function ToggleMainWindow()
  if FTA.UI and FTA.UI.ToggleMain then
    FTA.UI:ToggleMain()
    return
  end

  local frame = FTA.UI and FTA.UI.main
  if frame then
    if frame:IsShown() then
      frame:Hide()
    else
      frame:Show()
      if FTA.UI.Refresh then
        FTA.UI:Refresh()
      end
    end
  end
end

local function OpenSettings()
  if FTA.Settings and FTA.Settings.Open then
    FTA.Settings:Open()
  end
end

function FTA:MinimapButton_Show()
  EnsureDefaults()
  FTADB.profile.minimap.hide = false
  if self.MinimapButton and self.MinimapButton.button then
    self.MinimapButton.button:Show()
    UpdatePosition(self.MinimapButton.button)
  end
end

function FTA:MinimapButton_Hide()
  EnsureDefaults()
  FTADB.profile.minimap.hide = true
  if self.MinimapButton and self.MinimapButton.button then
    self.MinimapButton.button:Hide()
  end
end

function FTA:MinimapButton_Init()
  EnsureDefaults()

  if self.MinimapButton and self.MinimapButton.button then
    if FTADB.profile.minimap.hide then
      self.MinimapButton.button:Hide()
    else
      self.MinimapButton.button:Show()
      UpdatePosition(self.MinimapButton.button)
    end
    return
  end

  local button = CreateFrame("Button", "FollowTheArrowMinimapButton", Minimap)
  button:SetSize(31, 31)
  button:SetFrameStrata("MEDIUM")
  button:SetFrameLevel(8)
  button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  button:RegisterForDrag("LeftButton")
  button:SetMovable(true)
  button:SetClampedToScreen(true)

  local icon = button:CreateTexture(nil, "ARTWORK")
  icon:SetSize(20, 20)
  icon:SetPoint("CENTER", 0, 0)
  icon:SetTexture(ICON_TEXTURE)
  icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

  local overlay = button:CreateTexture(nil, "OVERLAY")
  overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  overlay:SetSize(53, 53)
  overlay:SetPoint("TOPLEFT", 0, 0)

  local highlight = button:CreateTexture(nil, "HIGHLIGHT")
  highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
  highlight:SetBlendMode("ADD")
  highlight:SetSize(31, 31)
  highlight:SetPoint("CENTER", 0, 0)

  button.icon = icon
  button.overlay = overlay
  button.highlight = highlight

  button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Follow The Arrow")
    GameTooltip:AddLine("Left-click: Toggle main window.", 1, 1, 1)
    GameTooltip:AddLine("Right-click: Open settings.", 1, 1, 1)
    GameTooltip:Show()
  end)

  button:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  button:SetScript("OnClick", function(_, mouseButton)
    if mouseButton == "RightButton" then
      OpenSettings()
    else
      ToggleMainWindow()
    end
  end)

  button:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", UpdateDragPosition)
  end)

  button:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
    UpdateDragPosition(self)
  end)

  self.MinimapButton.button = button

  if FTADB.profile.minimap.hide then
    button:Hide()
  else
    button:Show()
    UpdatePosition(button)
  end
end