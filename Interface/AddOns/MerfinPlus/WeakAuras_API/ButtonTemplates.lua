Merfin = Merfin or {}
local expansion = math.floor(select(4, GetBuildInfo()) / 10000)

local UnitAffectingCombat = UnitAffectingCombat
local GetSpellInfo = GetSpellInfo

local SetClickAnimation = function(aura_env)
  local r = WeakAuras.GetRegion(aura_env.id)
  if not r or not aura_env.button then
    return
  end

  aura_env.button:SetScript("OnMouseDown", function()
    r:SetAlpha(0.65)
  end)

  aura_env.button:SetScript("OnMouseUp", function()
    r:SetAlpha(1)
  end)

  aura_env.button:SetScript("OnLeave", function()
    r:SetAlpha(1)
    GameTooltip:Hide()
  end)
end

local SetItemTooltip = function(button, tooltipContextId)
  aura_env.button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    GameTooltip:ClearLines()
    GameTooltip:SetItemByID(tooltipContextId)
    GameTooltip:Show()
  end)
  aura_env.button:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)
end

-- Clickable Reminder
Merfin.SetButtonTemplate = function(aura_env, buttonName, type, context, context2)
  if WeakAuras.IsOptionsOpen() then
    return
  end
  if UnitAffectingCombat("player") then
    return
  end

  if not aura_env.button then
    local r = WeakAuras.GetRegion(aura_env.id)
    aura_env.button = CreateFrame("Button", buttonName, r, "SecureActionButtonTemplate")
  end

  SetClickAnimation(aura_env)

  aura_env.button:SetAllPoints()
  if expansion == 2 or expansion == 3 or expansion == 5 then
    aura_env.button:RegisterForClicks("AnyUp", "AnyDown") -- TBC and WotLK are special
  else
    aura_env.button:RegisterForClicks("AnyUp")
  end
  aura_env.button:SetAttribute("type", type)
  if type == "macro" then
    aura_env.button:SetAttribute("macrotext1", context)
  elseif type == "item" then
    aura_env.button:SetAttribute("item", "item:" .. context)
  elseif type == "spell" then
    local spell = (context2 and select(1, GetSpellInfo(context))) or context
    aura_env.button:SetAttribute("spell", spell)
  end
end

-- Sets Tooltip
Merfin.SetButtonTooltipItem = function(aura_env, buttonName, itemId)
  if not aura_env.button then
    local r = WeakAuras.GetRegion(aura_env.id)
    aura_env.button = CreateFrame("Button", buttonName, r, "SecureActionButtonTemplate")
  end

  SetClickAnimation(aura_env)

  aura_env.button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    GameTooltip:ClearLines()
    GameTooltip:SetItemByID(itemId)
    GameTooltip:Show()
  end)

  aura_env.button:SetScript("OnLeave", function(self)
    local r = WeakAuras.GetRegion(aura_env.id)
    if r then
      r:SetAlpha(1)
    end

    GameTooltip:Hide()
  end)
end

-- Clickable WeakAura callback. Unlike SetButtonTemplate this is intentionally
-- not a secure action: it is used for addon data requests, not casts/items.
Merfin.SetCallbackButtonTemplate = function(aura_env, buttonName, callback)
  -- This is a normal, non-secure button.  WeakAuras runs On Init while its
  -- options panel is open, so rejecting that state would permanently skip
  -- creation until the aura is reloaded.
  local region = WeakAuras.GetRegion(aura_env.id)
  if not region or type(callback) ~= "function" then return false end
  -- Creation must stay out of combat, but an already created plain callback
  -- button may safely be shown again after WeakAuras temporarily hid it.
  if not aura_env.button then
    if UnitAffectingCombat("player") then return false end
    aura_env.button = CreateFrame("Button", buttonName, region)
  end
  local button = aura_env.button
  button:SetAllPoints()
  button:Enable()
  SetClickAnimation(aura_env)
  button:SetScript("OnClick", function(_, mouseButton) callback(mouseButton) end)
  return true
end
