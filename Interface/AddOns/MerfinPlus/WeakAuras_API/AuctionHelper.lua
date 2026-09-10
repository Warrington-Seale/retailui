local _, MerfinPlus = ...

local AH = _G.MerfinAuctionHelperTBC or {}
_G.MerfinAuctionHelperTBC = AH

AH.version = 1
AH.events = AH.events or {}

local API_IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
local UPDATE_EVENT = "MERFIN_AH_UPDATE"
local TSM_FRAME_PREFIX = "^TSM_FRAME:LargeApplicationFrame:"
local MIN_TSM_SEARCH_WIDTH = 280
local UPDATE_INTERVAL = 0.25
local BASE_CUSTOM_ANCHOR =
  "function()\n    local helper = _G.MerfinAuctionHelperTBC\n    if helper and helper.GetAnchorFrame then\n        return helper.GetAnchorFrame()\n    end\n    return AuctionFrame or AuctionHouseFrame or UIParent\nend"
local MATERIALS_CUSTOM_ANCHOR =
  "function()\n    local helper = _G.MerfinAuctionHelperTBC\n    if helper and helper.GetMaterialsAnchorFrame then\n        return helper.GetMaterialsAnchorFrame()\n    end\n    if helper and helper.GetAnchorFrame then\n        return helper.GetAnchorFrame()\n    end\n    return AuctionFrame or AuctionHouseFrame or UIParent\nend"

local ANCHOR_DISPLAY_IDS = {
  "[Merfin] Auction Helper Materials TBC",
  "[Merfin] Auction Helper TBC",
  "[Merfin] AH Buttons",
}

local WEAKAURA_ANCHORS = {
  [ANCHOR_DISPLAY_IDS[1]] = MATERIALS_CUSTOM_ANCHOR,
  [ANCHOR_DISPLAY_IDS[2]] = BASE_CUSTOM_ANCHOR,
  [ANCHOR_DISPLAY_IDS[3]] = BASE_CUSTOM_ANCHOR,
}

local MATERIALS_BASE_XOFFSET = -293
local MATERIALS_TSM_ANCHOR_XOFFSET = -97

local STATIC_ICON_IDS = {
  "[Merfin] AH Battle Elixir",
  "[Merfin] AH Guardian Elixir",
  "[Merfin] AH Button Alchemy",
  "[Merfin] AH Button Blacksmithing",
  "[Merfin] AH Button Cooking",
  "[Merfin] AH Button Enchants",
  "[Merfin] AH Button Enchanting",
  "[Merfin] AH Button Flask",
  "[Merfin] AH Button Food",
  "[Merfin] AH Button Gems",
  "[Merfin] AH Button Jewelcrafting",
  "[Merfin] AH Button Leatherworking",
  "[Merfin] AH Button Misc",
  "[Merfin] AH Button Potions",
  "[Merfin] AH Button Primals",
  "[Merfin] AH Button Scroll",
  "[Merfin] AH Button Tailoring",
  "[Merfin] AH Button Weapon",
  "[Merfin] AH Gem Button Blue ",
}

local BUTTON_GROUP_IDS = {
  "[Merfin] AH Button Materials",
}

local TSM_REFRESH_DELAYS = {
  0.02,
  0.12,
  0.35,
}

local browseLabels = {
  BROWSE,
  "Browse",
  "Durchsuchen",
}

local searchLabels = {
  SEARCH,
  "Search",
  "Suche",
  "Suchen",
}

local shoppingLabels = {
  "Shopping",
  "Shop",
  "Einkaufen",
}

local anchor = CreateFrame("Frame", nil, UIParent)
AH.anchor = anchor
local materialsAnchor = CreateFrame("Frame", nil, UIParent)
AH.materialsAnchor = materialsAnchor

anchor:SetSize(750, 450)
anchor:SetFrameStrata("HIGH")
anchor:SetFrameLevel(250)
anchor:EnableMouse(false)
anchor:Hide()

materialsAnchor:SetSize(750, 450)
materialsAnchor:SetFrameStrata("HIGH")
materialsAnchor:SetFrameLevel(250)
materialsAnchor:EnableMouse(false)
materialsAnchor:Hide()

local eventFrame = CreateFrame("Frame")
local elapsedSinceUpdate = 0
local lastOpen = nil
local lastAnchorTarget = nil

local function SafeCall(method, self, ...)
  if type(method) ~= "function" then
    return false
  end
  return pcall(method, self, ...)
end

local function SafeValue(method, self, ...)
  if type(method) ~= "function" then
    return nil
  end
  local ok, value = pcall(method, self, ...)
  if ok then
    return value
  end
  return nil
end

local function IsShown(frame)
  return SafeValue(frame and frame.IsShown, frame) and true or false
end

local function IsVisible(frame)
  return SafeValue(frame and frame.IsVisible, frame) and true or false
end

local function GetName(frame)
  return SafeValue(frame and frame.GetName, frame)
end

local function GetObjectType(frame)
  return SafeValue(frame and frame.GetObjectType, frame)
end

local function GetFrameWidth(frame)
  return SafeValue(frame and frame.GetWidth, frame) or 0
end

local function AddMessage(message, r, g, b)
  if UIErrorsFrame and UIErrorsFrame.AddMessage then
    UIErrorsFrame:AddMessage(message, r or 1, g or 0.82, b or 0, 1)
  else
    print(message)
  end
end

local function CleanText(text)
  if type(text) ~= "string" then
    return ""
  end
  text = gsub(text, "|c%x%x%x%x%x%x%x%x", "")
  text = gsub(text, "|r", "")
  text = gsub(text, "|T.-|t", "")
  text = gsub(text, "^%s+", "")
  text = gsub(text, "%s+$", "")
  return text
end

local function TextMatches(text, labels)
  text = CleanText(text)
  for i = 1, #labels do
    local label = CleanText(labels[i])
    if label ~= "" and text == label then
      return true
    end
  end
  return false
end

local function FrameText(frame)
  local text = SafeValue(frame and frame.GetText, frame)
  if type(text) == "string" and text ~= "" then
    return text
  end
  if frame and frame.text then
    text = SafeValue(frame.text.GetText, frame.text)
    if type(text) == "string" and text ~= "" then
      return text
    end
  end
  return nil
end

local function Children(parent)
  if not parent or type(parent.GetChildren) ~= "function" then
    return nil
  end
  local ok, children = pcall(function()
    return { parent:GetChildren() }
  end)
  if ok then
    return children
  end
  return nil
end

local function WalkChildren(parent, predicate, maxDepth, depth)
  depth = depth or 0
  if depth > (maxDepth or 8) then
    return nil
  end

  local children = Children(parent)
  if not children then
    return nil
  end

  for i = 1, #children do
    local child = children[i]
    if predicate(child) then
      return child
    end
  end

  for i = 1, #children do
    local found = WalkChildren(children[i], predicate, maxDepth, depth + 1)
    if found then
      return found
    end
  end

  return nil
end

local function SafeClick(frame)
  if not frame or type(frame.Click) ~= "function" then
    return false
  end
  return SafeCall(frame.Click, frame) and true or false
end

local function IsVisibleButtonWithText(frame, labels)
  return IsShown(frame) and GetObjectType(frame) == "Button" and TextMatches(FrameText(frame), labels)
end

local function IsVisibleEditBox(frame)
  if not IsShown(frame) or GetObjectType(frame) ~= "EditBox" then
    return false
  end

  local name = GetName(frame)
  if type(name) == "string" and not strmatch(name, "^TSM_EDIT_BOX:Input:") then
    return false
  end

  return true
end

function AH.IsAddonLoaded(name)
  if not API_IsAddOnLoaded then
    return false
  end

  local a, b = API_IsAddOnLoaded(name)
  if type(a) == "boolean" then
    if b ~= nil then
      return a or b
    end
    return a
  end

  return a and true or false
end

local function TSMApiAuctionVisible()
  if not TSM_API or type(TSM_API.IsUIVisible) ~= "function" then
    return nil
  end

  local ok, visible = pcall(TSM_API.IsUIVisible, "AUCTION")
  if ok then
    return visible and true or false
  end
  return nil
end

function AH.FindTSMAuctionFrame()
  if not AH.IsAddonLoaded("TradeSkillMaster") then
    AH.tsmFrameCache = nil
    return nil
  end

  if TSMApiAuctionVisible() == false then
    AH.tsmFrameCache = nil
    return nil
  end

  if
    IsShown(AH.tsmFrameCache)
    and type(GetName(AH.tsmFrameCache)) == "string"
    and strmatch(GetName(AH.tsmFrameCache), TSM_FRAME_PREFIX)
  then
    return AH.tsmFrameCache
  end

  AH.tsmFrameCache = nil

  local children = Children(UIParent)
  if not children then
    return nil
  end

  for i = 1, #children do
    local child = children[i]
    local name = GetName(child)
    if IsShown(child) and type(name) == "string" and strmatch(name, TSM_FRAME_PREFIX) then
      AH.tsmFrameCache = child
      return child
    end
  end

  return nil
end

function AH.IsTSMAuctionVisible()
  local visible = TSMApiAuctionVisible()
  if visible ~= nil then
    return visible
  end

  return AH.FindTSMAuctionFrame() and true or false
end

function AH.GetDefaultAuctionFrame()
  if IsShown(AuctionFrame) then
    return AuctionFrame
  end
  if IsShown(AuctionHouseFrame) then
    return AuctionHouseFrame
  end
  return nil
end

function AH.IsDefaultAuctionVisible()
  return AH.GetDefaultAuctionFrame() and true or false
end

function AH.IsAuctionOpen()
  return AH.IsDefaultAuctionVisible() or AH.IsTSMAuctionVisible()
end

function AH.HasSupportedAddon()
  return AH.IsAuctionatorAvailable()
    or AH.IsAddonLoaded("Auctioneer")
    or AH.IsAddonLoaded("Auc-Advanced")
    or AH.IsAddonLoaded("TradeSkillMaster")
    or AH.IsDefaultAuctionVisible()
end

function AH.GetAuctionAnchorFrame()
  return AH.FindTSMAuctionFrame() or AH.GetDefaultAuctionFrame()
end

function AH.GetAnchorFrame()
  return anchor
end

function AH.GetMaterialsAnchorFrame()
  return materialsAnchor
end

function AH.UpdateAnchor()
  local tsmFrame = AH.FindTSMAuctionFrame()
  local target = tsmFrame or AH.GetDefaultAuctionFrame()
  local useTSMMaterialsOffset = target and tsmFrame and target == tsmFrame
  local useTSMButtonRefresh = target and AH.IsAddonLoaded("TradeSkillMaster")
  local open = target and true or false
  local weakAurasReady = WeakAuras and WeakAuras.ScanEvents
  local needsScan = weakAurasReady and not AH.didWeakAurasScan
  local needsTSMRefresh = useTSMButtonRefresh and not AH.tsmOpenRefreshQueued
  local changed = open ~= lastOpen or target ~= lastAnchorTarget

  if not weakAurasReady then
    AH.didWeakAurasScan = false
  end

  if not changed and not needsScan and not needsTSMRefresh then
    return
  end

  lastOpen = open
  lastAnchorTarget = target

  anchor:ClearAllPoints()
  anchor:SetParent(UIParent)
  materialsAnchor:ClearAllPoints()
  materialsAnchor:SetParent(UIParent)

  if target then
    anchor:SetPoint("TOPLEFT", target, "TOPLEFT")
    anchor:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT")
    if useTSMMaterialsOffset then
      materialsAnchor:SetPoint("TOPLEFT", target, "TOPLEFT", MATERIALS_TSM_ANCHOR_XOFFSET, 0)
      materialsAnchor:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", MATERIALS_TSM_ANCHOR_XOFFSET, 0)
    else
      materialsAnchor:SetPoint("TOPLEFT", target, "TOPLEFT")
      materialsAnchor:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT")
    end
    if type(target.GetFrameStrata) == "function" then
      local strata = SafeValue(target.GetFrameStrata, target)
      if strata then
        anchor:SetFrameStrata(strata)
        materialsAnchor:SetFrameStrata(strata)
      end
    end
    if type(target.GetFrameLevel) == "function" then
      local level = (SafeValue(target.GetFrameLevel, target) or 1) + 20
      anchor:SetFrameLevel(level)
      materialsAnchor:SetFrameLevel(level)
    end
    anchor:Show()
    materialsAnchor:Show()
  else
    anchor:Hide()
    materialsAnchor:Hide()
    AH.tsmOpenRefreshQueued = false
    AH.tsmRefreshGeneration = (AH.tsmRefreshGeneration or 0) + 1
  end

  if weakAurasReady then
    AH.didWeakAurasScan = true
    WeakAuras.ScanEvents(UPDATE_EVENT, open, target or anchor)
  end

  if useTSMButtonRefresh then
    AH.QueueTSMOpenRefresh(target)
  elseif AH.tsmOpenRefreshQueued then
    AH.tsmOpenRefreshQueued = false
    AH.tsmRefreshGeneration = (AH.tsmRefreshGeneration or 0) + 1
  end
end

local function GetItemNameAndLink(item, fallbackName)
  if item ~= nil then
    local name, link = GetItemInfo(item)
    if name then
      return name, link
    end

    if type(item) == "string" then
      local itemId = tonumber(item)
      if itemId then
        name, link = GetItemInfo(itemId)
        if name then
          return name, link
        end
      else
        return item, nil
      end
    end
  end

  return fallbackName, nil
end

function AH.OpenTSMBrowsePage()
  local tsmFrame = AH.FindTSMAuctionFrame()
  if not tsmFrame then
    return false
  end

  local browseButton = WalkChildren(tsmFrame, function(frame)
    return IsVisibleButtonWithText(frame, browseLabels)
  end, 10)

  return browseButton and SafeClick(browseButton) or false
end

function AH.FindTSMSearchInput()
  local tsmFrame = AH.FindTSMAuctionFrame()
  if not tsmFrame then
    return nil
  end

  local bestFrame = nil
  local bestWidth = 0

  WalkChildren(tsmFrame, function(frame)
    if not IsVisibleEditBox(frame) then
      return false
    end

    local width = GetFrameWidth(frame)
    if width > bestWidth then
      bestFrame = frame
      bestWidth = width
    end

    return false
  end, 10)

  if bestFrame and bestWidth >= MIN_TSM_SEARCH_WIDTH then
    return bestFrame
  end

  return nil
end

function AH.FindTSMSearchButton()
  local tsmFrame = AH.FindTSMAuctionFrame()
  if not tsmFrame then
    return nil
  end

  return WalkChildren(tsmFrame, function(frame)
    return IsVisibleButtonWithText(frame, searchLabels)
  end, 10)
end

function AH.SearchTSMFilter(searchText)
  local input = AH.FindTSMSearchInput()
  if not input then
    return false
  end

  if type(input.SetFocus) == "function" then
    SafeCall(input.SetFocus, input)
  end
  if type(input.SetText) == "function" then
    SafeCall(input.SetText, input, "")
    SafeCall(input.SetText, input, searchText)
  end
  if type(input.HighlightText) == "function" then
    SafeCall(input.HighlightText, input, 0, -1)
  end

  local searchButton = AH.FindTSMSearchButton()
  if searchButton and SafeClick(searchButton) then
    return true
  end

  local onEnter = SafeValue(input.GetScript, input, "OnEnterPressed")
  if type(onEnter) == "function" then
    local ok = pcall(onEnter, input)
    return ok and true or false
  end

  return false
end

function AH.GetAuctionatorShoppingFrame()
  return _G.AuctionatorShoppingFrame
end

function AH.GetAuctionatorShoppingTab()
  if _G.AuctionatorShoppingTab then
    return _G.AuctionatorShoppingTab
  end

  return WalkChildren(AuctionFrame, function(frame)
    return IsVisibleButtonWithText(frame, shoppingLabels)
  end, 4)
end

function AH.IsAuctionatorAvailable()
  return AH.IsAddonLoaded("Auctionator")
    or AH.IsAddonLoaded("Auctionator_TBC")
    or AH.IsAddonLoaded("AuctionatorClassic")
    or AH.IsAddonLoaded("Auctionator_Classic")
    or _G.AuctionatorShoppingFrame ~= nil
    or _G.AuctionatorShoppingTab ~= nil
    or _G.Atr_Search_Box ~= nil
    or type(_G.Atr_Search_Onclick) == "function"
    or AH.GetAuctionatorShoppingTab() ~= nil
end

function AH.GetAuctionatorSearchBox()
  local frame = AH.GetAuctionatorShoppingFrame()
  if not frame then
    return _G.Atr_Search_Box
  end

  if frame.SearchOptions and frame.SearchOptions.SearchString then
    return frame.SearchOptions.SearchString
  end

  if frame.SearchString then
    return frame.SearchString
  end

  if _G.Atr_Search_Box then
    return _G.Atr_Search_Box
  end

  return nil
end

function AH.FindAuctionatorSearchButtonByText(parent)
  if not parent then
    return nil
  end

  return WalkChildren(parent, function(frame)
    return IsVisibleButtonWithText(frame, searchLabels)
  end, 5)
end

function AH.GetAuctionatorSearchButton()
  local frame = AH.GetAuctionatorShoppingFrame()
  if not frame then
    return nil
  end

  if frame.SearchButton and type(frame.SearchButton.Click) == "function" then
    return frame.SearchButton
  end

  if
    frame.SearchOptions
    and frame.SearchOptions.SearchButton
    and type(frame.SearchOptions.SearchButton.Click) == "function"
  then
    return frame.SearchOptions.SearchButton
  end

  if _G.AuctionatorShoppingFrameSearchButton and type(_G.AuctionatorShoppingFrameSearchButton.Click) == "function" then
    return _G.AuctionatorShoppingFrameSearchButton
  end

  if _G.Atr_Search_Button and type(_G.Atr_Search_Button.Click) == "function" then
    return _G.Atr_Search_Button
  end

  local button = AH.FindAuctionatorSearchButtonByText(frame)
  if button then
    return button
  end

  if frame.SearchOptions then
    button = AH.FindAuctionatorSearchButtonByText(frame.SearchOptions)
    if button then
      return button
    end
  end

  return nil
end

function AH.OpenAuctionatorShoppingTab()
  local shoppingTab = AH.GetAuctionatorShoppingTab()
  if shoppingTab and SafeClick(shoppingTab) then
    return true
  end

  local frame = AH.GetAuctionatorShoppingFrame()
  if IsShown(frame) then
    return true
  end

  return false
end

function AH.PressAuctionatorSearch(searchBox)
  if type(_G.Atr_Search_Onclick) == "function" then
    local ok = pcall(_G.Atr_Search_Onclick)
    if ok then
      return true
    end
  end

  local button = AH.GetAuctionatorSearchButton()
  if button and SafeClick(button) then
    return true
  end

  local onEnterPressed = SafeValue(searchBox and searchBox.GetScript, searchBox, "OnEnterPressed")
  if type(onEnterPressed) == "function" then
    local ok = pcall(onEnterPressed, searchBox)
    return ok and true or false
  end

  return false
end

function AH.SearchAuctionatorItem(item, fallbackName)
  if not AH.IsAuctionatorAvailable() then
    return false
  end

  local itemName = GetItemNameAndLink(item, fallbackName)
  if not itemName then
    AddMessage("Merfin AH: item info is not loaded yet.", 1, 0.1, 0.1)
    return true
  end

  AH.OpenAuctionatorShoppingTab()

  local function RunSearch()
    local searchBox = AH.GetAuctionatorSearchBox()
    if not searchBox then
      AddMessage("Merfin AH: Auctionator shopping search box not found.", 1, 0.1, 0.1)
      return
    end

    SafeCall(searchBox.SetFocus, searchBox)
    SafeCall(searchBox.SetText, searchBox, "")
    SafeCall(searchBox.SetText, searchBox, itemName)
    SafeCall(searchBox.HighlightText, searchBox, 0, -1)

    if not AH.PressAuctionatorSearch(searchBox) then
      AddMessage("Merfin AH: Auctionator shopping search trigger not found.", 1, 0.1, 0.1)
    end
  end

  C_Timer.After(0.05, RunSearch)
  return true
end

function AH.SearchTSMItem(item, fallbackName)
  if not AH.IsTSMAuctionVisible() then
    return false
  end

  local itemName, itemLink = GetItemNameAndLink(item, fallbackName)
  if not itemName then
    AddMessage("Merfin AH: item info is not loaded yet.", 1, 0.1, 0.1)
    return true
  end

  AH.OpenTSMBrowsePage()

  local function RunSearch()
    if itemLink and HandleModifiedItemClick then
      local ok, handled = pcall(HandleModifiedItemClick, itemLink)
      if ok and handled then
        return
      end
    end

    if not AH.SearchTSMFilter(itemName) then
      AddMessage("Merfin AH: TSM search controls not found.", 1, 0.1, 0.1)
    end
  end

  C_Timer.After(0.05, RunSearch)
  return true
end

function AH.SearchDefaultAuction(itemName)
  if not AH.IsDefaultAuctionVisible() or not QueryAuctionItems then
    return false
  end
  if CanSendAuctionQuery and not CanSendAuctionQuery() then
    AddMessage("Merfin AH: auction query is not ready yet.", 1, 0.1, 0.1)
    return true
  end

  QueryAuctionItems(itemName, nil, nil, 0, false, nil, false, true)
  return true
end

function AH.SearchItem(item, fallbackName)
  if not AH.IsAuctionOpen() then
    return false
  end

  local itemName = GetItemNameAndLink(item, fallbackName)

  if AH.SearchTSMItem(item, itemName) then
    return true
  end

  if AH.SearchAuctionatorItem(item, itemName) then
    return true
  end

  if not itemName then
    AddMessage("Merfin AH: item info is not loaded yet.", 1, 0.1, 0.1)
    return true
  end

  if AH.SearchDefaultAuction(itemName) then
    return true
  end

  return false
end

Merfin.SearchAuctionItem = function(item, fallbackName)
  return AH.SearchItem(item, fallbackName)
end

function AH.Attach(env)
  if type(env) ~= "table" or env.MerfinAuctionHelperAttached then
    return
  end

  env.MerfinAuctionHelperAttached = true

  local oldHasSupportedAddon = env.HasSupportedAddon
  local oldSearchItem = env.SearchItem

  env.IsAuctionOpen = function()
    return AH.IsAuctionOpen()
  end

  env.HasSupportedAddon = function()
    if oldHasSupportedAddon and oldHasSupportedAddon() then
      return true
    end
    return AH.HasSupportedAddon()
  end

  env.SearchItem = function()
    if AH.SearchItem(env.itemId, env.itemName) then
      return
    end

    if oldSearchItem then
      return oldSearchItem()
    end
  end

  if env.itemId == nil then
    return
  end

  env.PushVisual = function()
    WeakAuras.ScanEvents("MR_AH_ITEM_VISUAL", env.id, env.hover, env.pressed)
  end

  env.GetButtonFrame = function()
    local region = env.region
    if not region then
      return nil
    end

    local button = env.button
    if not button then
      button = CreateFrame("Button", nil, region)
      env.button = button
    end

    return button
  end

  env.HideButton = function()
    local button = env.GetButtonFrame()
    if button then
      button:Hide()
      button:ClearAllPoints()
    end
  end

  env.ShowButton = function()
    local region = env.region
    local button = env.GetButtonFrame()

    if not region or not button then
      return
    end

    button:ClearAllPoints()
    button:SetAllPoints(region)
    button:SetFrameStrata(region:GetFrameStrata())
    button:SetFrameLevel(region:GetFrameLevel() + 10)
    button:EnableMouse(true)
    button:RegisterForClicks("LeftButtonUp")
    button:Show()

    button:SetScript("OnClick", function()
      env.SearchItem()
    end)

    button:SetScript("OnEnter", function(self)
      env.hover = true
      env.PushVisual()
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:SetItemByID(env.itemId)
      GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function()
      env.hover = false
      env.pressed = false
      env.PushVisual()
      GameTooltip:Hide()
    end)

    button:SetScript("OnMouseDown", function()
      env.pressed = true
      env.PushVisual()
    end)

    button:SetScript("OnMouseUp", function()
      env.pressed = false
      env.PushVisual()
    end)

    env.PushVisual()
  end
end

local function WeakAurasReady()
  return WeakAurasSaved and WeakAurasSaved.displays and WeakAuras and WeakAuras.Add
end

local function AddWeakAuraDisplay(displays, id)
  local data = displays and displays[id]
  if not data then
    return false
  end

  WeakAuras.Add(data, true)
  return true
end

local function RememberOriginal(id, data)
  AH.originalWeakAuraData = AH.originalWeakAuraData or {}
  if AH.originalWeakAuraData[id] then
    return
  end

  AH.originalWeakAuraData[id] = {
    anchorFrameType = data.anchorFrameType,
    anchorFrameFrame = data.anchorFrameFrame,
    customAnchor = data.customAnchor,
    xOffset = data.xOffset,
    hadAnchorFrameFrame = data.anchorFrameFrame ~= nil,
    hadCustomAnchor = data.customAnchor ~= nil,
    hadXOffset = data.xOffset ~= nil,
  }
end

function AH.EnsureWeakAuraStaticIcons(force)
  if not WeakAurasReady() or (AH.staticIconsApplied and not force) then
    return false
  end

  local displays = WeakAurasSaved and WeakAurasSaved.displays
  local added = false

  for i = 1, #STATIC_ICON_IDS do
    local id = STATIC_ICON_IDS[i]
    local data = displays[id]
    if data and data.regionType == "icon" then
      data.iconSource = 0
      added = AddWeakAuraDisplay(displays, id) or added
    end
  end

  AH.staticIconsApplied = true
  return added
end

function AH.ApplyWeakAuraRuntimePatch()
  if AH.runtimePatchApplied or not AH.IsAddonLoaded("TradeSkillMaster") or not WeakAurasReady() then
    return false
  end

  local displays = WeakAurasSaved and WeakAurasSaved.displays

  for id, customAnchor in pairs(WEAKAURA_ANCHORS) do
    local data = displays[id]
    if data then
      RememberOriginal(id, data)
      data.anchorFrameType = "CUSTOM"
      data.customAnchor = customAnchor
      data.anchorFrameFrame = nil
      if id == "[Merfin] Auction Helper Materials TBC" then
        data.xOffset = MATERIALS_BASE_XOFFSET
      end
      WeakAuras.Add(data, true)
    end
  end

  AH.runtimePatchApplied = true
  AH.UpdateAnchor()
  return true
end

local function ScanWeakAuraOpen(target)
  if not (WeakAuras and WeakAuras.ScanEvents) then
    return false
  end

  WeakAuras.ScanEvents(UPDATE_EVENT, true, target or AH.GetAuctionAnchorFrame() or anchor)
  return true
end

function AH.RefreshTSMButtonAuras(target, generation)
  if not AH.IsAddonLoaded("TradeSkillMaster") or not AH.IsAuctionOpen() or not WeakAurasReady() then
    return false
  end

  if not AH.runtimePatchApplied then
    AH.ApplyWeakAuraRuntimePatch()
  end

  local displays = WeakAurasSaved and WeakAurasSaved.displays

  for i = 1, #ANCHOR_DISPLAY_IDS do
    AddWeakAuraDisplay(displays, ANCHOR_DISPLAY_IDS[i])
  end

  for i = 1, #BUTTON_GROUP_IDS do
    AddWeakAuraDisplay(displays, BUTTON_GROUP_IDS[i])
  end

  AH.EnsureWeakAuraStaticIcons(true)
  AH.tsmButtonRefreshGeneration = generation or AH.tsmRefreshGeneration
  return ScanWeakAuraOpen(target)
end

function AH.QueueTSMOpenRefresh(target)
  if AH.tsmOpenRefreshQueued then
    return
  end

  AH.tsmOpenRefreshQueued = true
  AH.tsmRefreshGeneration = (AH.tsmRefreshGeneration or 0) + 1
  local generation = AH.tsmRefreshGeneration

  for i = 1, #TSM_REFRESH_DELAYS do
    C_Timer.After(TSM_REFRESH_DELAYS[i], function()
      if
        generation ~= AH.tsmRefreshGeneration
        or not AH.IsAddonLoaded("TradeSkillMaster")
        or not AH.IsAuctionOpen()
      then
        return
      end

      local currentTarget = AH.GetAuctionAnchorFrame() or target
      if AH.tsmButtonRefreshGeneration ~= generation then
        AH.RefreshTSMButtonAuras(currentTarget, generation)
      else
        ScanWeakAuraOpen(currentTarget)
      end
    end)
  end
end

function AH.RestoreWeakAuraSavedData()
  local displays = WeakAurasSaved and WeakAurasSaved.displays
  if not displays then
    return
  end

  for id in pairs(WEAKAURA_ANCHORS) do
    local data = displays[id]
    if data then
      data.anchorFrameType = "SELECTFRAME"
      data.anchorFrameFrame = "AuctionFrame"
      data.customAnchor = nil
    end
  end

  local materials = displays["[Merfin] Auction Helper Materials TBC"]
  if materials then
    materials.xOffset = MATERIALS_BASE_XOFFSET
  end

  for i = 1, #STATIC_ICON_IDS do
    local id = STATIC_ICON_IDS[i]
    local data = displays[id]
    if data and data.regionType == "icon" then
      data.iconSource = 0
    end
  end

  local materialsButtons = displays["[Merfin] AH Button Materials"]
  if materialsButtons and materialsButtons.regionType == "dynamicgroup" then
    materialsButtons.iconSource = nil
  end

  AH.runtimePatchApplied = false
end

eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_LOGOUT")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
eventFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")
eventFrame:SetScript("OnEvent", function(_, event, addonName)
  if event == "PLAYER_LOGOUT" then
    AH.RestoreWeakAuraSavedData()
    return
  end

  C_Timer.After(0.05, AH.UpdateAnchor)
  if event == "AUCTION_HOUSE_SHOW" then
    C_Timer.After(0.15, AH.UpdateAnchor)
    C_Timer.After(0.35, AH.UpdateAnchor)
  end

  if
    event == "PLAYER_LOGIN"
    or event == "PLAYER_ENTERING_WORLD"
    or addonName == "TradeSkillMaster"
    or addonName == "WeakAuras"
  then
    C_Timer.After(0.1, AH.EnsureWeakAuraStaticIcons)
    C_Timer.After(0.1, AH.ApplyWeakAuraRuntimePatch)
    C_Timer.After(0.5, function()
      AH.EnsureWeakAuraStaticIcons()
      AH.ApplyWeakAuraRuntimePatch()
    end)
  end
end)
eventFrame:SetScript("OnUpdate", function(_, elapsed)
  elapsedSinceUpdate = elapsedSinceUpdate + elapsed
  if elapsedSinceUpdate < UPDATE_INTERVAL then
    return
  end
  elapsedSinceUpdate = 0
  AH.UpdateAnchor()
end)

SLASH_MERFIN_AH_HELPER1 = "/mah"
SlashCmdList.MERFIN_AH_HELPER = function(message)
  message = message or ""
  local command, rest = strmatch(message, "^(%S*)%s*(.-)$")
  if command == "status" or command == "" then
    local target = AH.GetAuctionAnchorFrame()
    local targetName = target and GetName(target) or tostring(target)
    print(
      "Merfin AH: open="
        .. tostring(AH.IsAuctionOpen())
        .. " tsm="
        .. tostring(AH.IsTSMAuctionVisible())
        .. " anchor="
        .. tostring(anchor:IsShown())
        .. " target="
        .. tostring(targetName)
    )
  elseif command == "search" and rest ~= "" then
    AH.SearchItem(rest)
  else
    print("Merfin AH: /mah status, /mah search <itemId or name>")
  end
end

AH.UpdateAnchor()
C_Timer.After(0.1, AH.EnsureWeakAuraStaticIcons)
C_Timer.After(0.1, AH.ApplyWeakAuraRuntimePatch)
C_Timer.After(1, function()
  AH.EnsureWeakAuraStaticIcons()
  AH.ApplyWeakAuraRuntimePatch()
end)
