local addonName = ...

-- Ace libs
local AceAddon = LibStub("AceAddon-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDB = LibStub("AceDB-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")

-- Addon object
local Cursor = AceAddon:NewAddon(addonName)

-- Default settings
local defaults = {
  profile = {
    enabled = true,
    circleSize = 35,
    dotSize = 5,
    hideOnMB = true,
  }
}

-- Variables
local frame, tex1, tex2
local startedLooking = false
local startedTurning = false
local pressed = {}

-----------------------------
-- Position Handling
-----------------------------

-- Updates cursor frame position
local function UpdatePosition(self)
  local x, y = GetCursorPosition()
  local scale = UIParent:GetEffectiveScale()
  self:ClearAllPoints()
  self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x/scale, y/scale)
end

-- Returns whether the cursor should be hidden
local function ShouldHide()
  if not (startedLooking or startedTurning) then
    return false
  end
  for _ in pairs(pressed) do
    return true
  end
  return false
end

-----------------------------
-- Core Settings Application
-----------------------------

-- Applies profile settings
function Cursor:ApplySettings()
  local db = self.db.profile

  if not db.enabled then
    frame:SetScript("OnUpdate", nil)
    self:UnregisterMouseDown()
    frame:Hide()
    return
  end

  frame:SetScript("OnUpdate", UpdatePosition)

  tex1:SetSize(db.circleSize, db.circleSize)
  tex2:SetSize(db.dotSize, db.dotSize)

  if db.hideOnMB then
    self:RegisterMouseDown()
  else
    self:UnregisterMouseDown()
    frame:Show()
  end
end

-----------------------------
-- Event Registration
-----------------------------

-- Registers mouse/turn events
function Cursor:RegisterMouseDown()
  if frame:GetScript("OnEvent") then return end

  frame:RegisterEvent("GLOBAL_MOUSE_DOWN")
  frame:RegisterEvent("GLOBAL_MOUSE_UP")
  frame:RegisterEvent("PLAYER_STARTED_LOOKING")
  frame:RegisterEvent("PLAYER_STOPPED_LOOKING")
  frame:RegisterEvent("PLAYER_STARTED_TURNING")
  frame:RegisterEvent("PLAYER_STOPPED_TURNING")

  frame:SetScript("OnEvent", function(_, event, button)

    if event == "GLOBAL_MOUSE_DOWN" then
      pressed[button] = true

    elseif event == "GLOBAL_MOUSE_UP" then
      pressed[button] = nil

    elseif event == "PLAYER_STARTED_LOOKING" then
      startedLooking = true

    elseif event == "PLAYER_STOPPED_LOOKING" then
      startedLooking = false

    elseif event == "PLAYER_STARTED_TURNING" then
      startedTurning = true

    elseif event == "PLAYER_STOPPED_TURNING" then
      startedTurning = false
    end

    if ShouldHide() then
      frame:Hide()
    else
      frame:Show()
    end
  end)
end

-- Unregisters mouse/turn events
function Cursor:UnregisterMouseDown()
  if not frame:GetScript("OnEvent") then return end

  frame:UnregisterEvent("GLOBAL_MOUSE_DOWN")
  frame:UnregisterEvent("GLOBAL_MOUSE_UP")
  frame:UnregisterEvent("PLAYER_STARTED_LOOKING")
  frame:UnregisterEvent("PLAYER_STOPPED_LOOKING")
  frame:UnregisterEvent("PLAYER_STARTED_TURNING")
  frame:UnregisterEvent("PLAYER_STOPPED_TURNING")

  frame:SetScript("OnEvent", nil)

  startedLooking = false
  startedTurning = false
  wipe(pressed)
end

-----------------------------
-- Options
-----------------------------

local options = {
  type = "group",
  name = addonName,
  childGroups = "tab",
  args = {}
}

options.args.general = {
  type = "group",
  name = _G.ACCESSIBILITY_GENERAL_LABEL or "General",
  childGroups = "tab",
  order = 1,

  -- Profile getter
  get = function(info)
    return Cursor.db.profile[ info[#info] ]
  end,

  -- Profile setter
  set = function(info, value)
    Cursor.db.profile[ info[#info] ] = value
    Cursor:ApplySettings()
  end,

  args = {
    enabled = {
      type = "toggle",
      name = _G.ENABLE,
      order = 1,
    },
    circleSize = {
      type = "range",
      name = "Circle Size",
      min = 10, max = 200, step = 1,
      order = 2,
    },
    dotSize = {
      type = "range",
      name = "Dot Size",
      min = 2, max = 200, step = 1,
      order = 3,
    },
    hideOnMB = {
      type = "toggle",
      name = "Hide on Mouse Down",
      order = 4,
    },
  }
}

-----------------------------
-- Initialization
-----------------------------

-- Called when addon initializes
function Cursor:OnInitialize()
  self.db = AceDB:New(addonName .. "DB", defaults)

  self.db.RegisterCallback(self, "OnProfileChanged", "ApplySettings")
  self.db.RegisterCallback(self, "OnProfileCopied", "ApplySettings")
  self.db.RegisterCallback(self, "OnProfileReset", "ApplySettings")

  frame = CreateFrame("Frame", addonName .. "AttachToMouseFrame", UIParent)
  frame:SetWidth(1)
  frame:SetHeight(1)
  frame:SetFrameStrata("HIGH")

  tex1 = frame:CreateTexture(nil, "OVERLAY")
  tex1:SetTexture("Interface\\AddOns\\" .. addonName .. "\\Media\\Aura73.tga")
  tex1:SetBlendMode("BLEND")
  tex1:SetPoint("CENTER")
  tex1:SetSnapToPixelGrid(false)
  tex1:SetTexelSnappingBias(0)

  tex2 = frame:CreateTexture(nil, "OVERLAY")
  tex2:SetTexture("Interface\\AddOns\\" .. addonName .. "\\Media\\Aura45.tga")
  tex2:SetBlendMode("BLEND")
  tex2:SetPoint("CENTER")
  tex2:SetSnapToPixelGrid(false)
  tex2:SetTexelSnappingBias(0)

  AceConfig:RegisterOptionsTable(addonName, options)
  AceConfigDialog:AddToBlizOptions(addonName, addonName)

  options.args.profiles = AceDBOptions:GetOptionsTable(self.db)
  options.args.profiles.order = 2
end

-- Called when addon enables
function Cursor:OnEnable()
  self:ApplySettings()
end
