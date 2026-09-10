local _, FTA = ...

FTA.UI = FTA.UI or {}

local DEFAULT_WIDTH  = 360
local DEFAULT_HEIGHT = 460

local MIN_WIDTH  = 360
local MIN_HEIGHT = 320

local MIN_HEIGHT_MINIMIZED = 120

local EMBED_URL   = "https://youtu.be/Hn8SceLFago"
local EMBED_LABEL = "Watch my new 10-90 Speedrun using the updated 12.0.7 route!"
local EMBED_TEX   = "Interface\\AddOns\\FollowTheArrow\\Images\\1090DHSR.tga"

local function EnsureProfileDefaults()
  FTADB = FTADB or {}
  FTADB.profile = FTADB.profile or {}
  FTADB.profile.ui = FTADB.profile.ui or {}
  FTADB.profile.general = FTADB.profile.general or {}

  local gen = FTADB.profile.general
  if gen.textOnlyMainWindow == nil then gen.textOnlyMainWindow = false end

  local ui = FTADB.profile.ui
  ui.main = ui.main or {}

  ui.main.point = ui.main.point or "CENTER"
  ui.main.x     = ui.main.x or 0
  ui.main.y     = ui.main.y or 0
  ui.main.w     = ui.main.w or DEFAULT_WIDTH
  ui.main.h     = ui.main.h or DEFAULT_HEIGHT

  if ui.main.minimized == nil then ui.main.minimized = false end
  if ui.main.restoreH == nil then ui.main.restoreH = ui.main.h end

  ui.mainScale = ui.mainScale or 1.0
  ui.textScale = ui.textScale or 1.0
  ui.mainBgAlpha = ui.mainBgAlpha or 0.85

  ui.showNotesInCurrent = (ui.showNotesInCurrent ~= false)
end

local function Clamp(v, lo, hi)
  if v < lo then return lo end
  if v > hi then return hi end
  return v
end

local function PrintURL(url, label)
  url = tostring(url or "")
  if url == "" then return end
  label = tostring(label or url)
  print("|cff00ccff|Hurl:" .. url .. "|h[" .. label .. "]|h|r")
end

local function EnsureEmbedURLPopup()
  if not StaticPopupDialogs or StaticPopupDialogs["FTA_EMBED_URL"] then return end

  StaticPopupDialogs["FTA_EMBED_URL"] = {
    text = "Video Link:",
    button1 = OKAY,
    hasEditBox = true,
    editBoxWidth = 320,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    OnShow = function(self)
      local eb = _G[self:GetName() .. "EditBox"]
      if eb then
        eb:SetText(tostring(self.data or ""))
        eb:HighlightText()
        eb:SetFocus()
      end
    end,
    OnHide = function(self)
      local eb = self.editBox
      if eb then
        eb:SetText("")
        eb:ClearFocus()
      end
    end,
    EditBoxOnEnterPressed = function(self)
      self:GetParent():Hide()
    end,
  }
end

function FTA.UI:ShowEmbedURL(url)
  EnsureEmbedURLPopup()

  url = tostring(url or "")
  if url == "" then return end

  local dialog = StaticPopup_Show("FTA_EMBED_URL", nil, nil, url)
  if dialog then
    local eb = _G[dialog:GetName() .. "EditBox"]
    if eb then
      eb:SetText(url)
      eb:HighlightText()
      eb:SetFocus()
    end
  end
end

local function HasRouteAPI()
  return FTA.StepEngine
    and type(FTA.StepEngine.GetRouteList) == "function"
    and type(FTA.StepEngine.GetModulesForRoute) == "function"
end

local function GetActiveModuleId()
  return FTACharDB and FTACharDB.progress and FTACharDB.progress.activeModuleId
end

local function GetActiveRouteId()
  return FTACharDB and FTACharDB.progress and FTACharDB.progress.activeRouteId
end

local function EnsureCharDB()
  FTACharDB = FTACharDB or {}
  FTACharDB.progress = FTACharDB.progress or {}
  FTACharDB.progress.stepIndexByModule = FTACharDB.progress.stepIndexByModule or {}
end

local function ShortLabel(label, maxLen)
  label = tostring(label or "")
  maxLen = maxLen or 18
  if #label > maxLen then return label:sub(1, maxLen) .. "…" end
  return label
end

local function FindModuleRouteId(moduleId)
  if not (FTA.Modules and moduleId) then return nil end
  local m = FTA.Modules[moduleId]
  if not m then return nil end
  return m.routeId
end

local function PickFirstModuleInRoute(routeId)
  if not HasRouteAPI() then
    return nil
  end
  local list = FTA.StepEngine:GetModulesForRoute(routeId)
  if type(list) ~= "table" or not list[1] then return nil end
  return list[1].id
end

local function StoreBaseFont(fs)
  if not fs or fs._ftaBaseFont then return end
  local path, size, flags = fs:GetFont()
  fs._ftaBaseFont = { path = path, size = size, flags = flags }
end

local function ApplyFontScale(fs, scale)
  if not fs or not fs.GetFont or not fs.SetFont then return end
  StoreBaseFont(fs)
  local b = fs._ftaBaseFont
  if not b or not b.path or not b.size then return end
  local s = tonumber(scale) or 1.0
  if s < 0.5 then s = 0.5 end
  if s > 2.5 then s = 2.5 end
  fs:SetFont(b.path, math.max(1, math.floor(b.size * s + 0.5)), b.flags)
end

local function DropdownSelectedTextWidth(dd)
  if not dd or not dd.GetName then return 0 end
  local name = dd:GetName()
  if not name then return 0 end
  local fs = _G[name .. "Text"]
  if not fs or not fs.GetStringWidth then return 0 end
  return fs:GetStringWidth() or 0
end

local function EnsureDropdownLeftJustify(dd)
  if not dd then return end
  if UIDropDownMenu_JustifyText then
    UIDropDownMenu_JustifyText(dd, "LEFT")
  end
end

local function LayoutRouteDropdown(self)
  if not (self and self.main and self.routeDropdown) then return end

  local gen = (FTADB and FTADB.profile and FTADB.profile.general) or {}
  if gen.textOnlyMainWindow == true then
    return
  end

  local f = self.main
  local dd = self.routeDropdown

  local topY = -10

  local closeW = 32
  if self.closeBtn and self.closeBtn.GetWidth then
    local cw = self.closeBtn:GetWidth()
    if cw and cw > 0 then closeW = cw end
  end

  local rightInset = 20 + closeW + 20
  local maxW = 260
  local minW = 110

  local available = (f:GetWidth() or MIN_WIDTH) - rightInset - 14
  if available < 80 then available = 80 end

  EnsureDropdownLeftJustify(dd)

  local textW = DropdownSelectedTextWidth(dd)
  local w = textW + 22
  w = Clamp(w, minW, math.min(available, maxW))

  dd:ClearAllPoints()
  dd:SetPoint("TOPRIGHT", f, "TOPRIGHT", -rightInset, topY)

  UIDropDownMenu_SetWidth(dd, w, 0)
  if UIDropDownMenu_SetButtonWidth then
    UIDropDownMenu_SetButtonWidth(dd, w)
  end

  EnsureDropdownLeftJustify(dd)
end

function FTA.UI:IsMinimized()
  EnsureProfileDefaults()
  local ui = FTADB.profile.ui
  return ui and ui.main and ui.main.minimized == true
end

function FTA.UI:SetMinimized(v)
  EnsureProfileDefaults()
  local ui = FTADB.profile.ui
  if not ui or not ui.main then return end

  ui.main.minimized = (v == true)

  if ui.main.minimized ~= true then
    local h = ui.main.restoreH or DEFAULT_HEIGHT
    h = Clamp(h, MIN_HEIGHT, 900)
    ui.main.h = h
    if self.main and self.main.SetHeight then
      self.main:SetHeight(h)
    end
    if self.main and self.main.SetResizeBounds then
      self.main:SetResizeBounds(MIN_WIDTH, MIN_HEIGHT, 900, 900)
    end
  end

  if self.minFrame then
    self:UpdateMinimizeButtonVisual()
  end
end

function FTA.UI:ToggleMinimized()
  EnsureProfileDefaults()
  local ui = FTADB.profile.ui
  if not ui or not ui.main then return end

  local now = (ui.main.minimized ~= true)
  if now then
    ui.main.restoreH = ui.main.h or ui.main.restoreH or DEFAULT_HEIGHT
  end

  self:SetMinimized(now)
  self:Refresh()
end

function FTA.UI:UpdateMinimizeButtonVisual()
  local mm = self.minFrame
  if not mm then return end

  if self:IsMinimized() then
    if mm.MinimizeButton then mm.MinimizeButton:Hide() end
    if mm.MaximizeButton then mm.MaximizeButton:Show() end
  else
    if mm.MaximizeButton then mm.MaximizeButton:Hide() end
    if mm.MinimizeButton then mm.MinimizeButton:Show() end
  end
end

function FTA.UI:_ApplyVisibilityFromSettings()
  EnsureProfileDefaults()
  local gen = (FTADB and FTADB.profile and FTADB.profile.general) or {}

  local hideMain = (gen.hideMainWindow == true)
  if hideMain then
    if self.main and self.main:IsShown() then
      self.main:Hide()
    end
    self._hiddenBySetting = true
  else
    if self._hiddenBySetting and self.main and not self.main:IsShown() then
      self.main:Show()
    end
    self._hiddenBySetting = false
  end
end

function FTA.UI:_ApplyTextOnlyMode()
  if not self.main then return end
  EnsureProfileDefaults()

  local gen = (FTADB and FTADB.profile and FTADB.profile.general) or {}
  local ui = (FTADB and FTADB.profile and FTADB.profile.ui) or {}

  local on = (gen.textOnlyMainWindow == true)
  self._textOnly = on

  if on then
    if self.main.SetBackdrop then self.main:SetBackdrop(nil) end
  else
    if self._normalBackdrop and self.main.SetBackdrop then
      self.main:SetBackdrop(self._normalBackdrop)
    end
  end

  local a = tonumber(ui.mainBgAlpha) or 0.85
  a = Clamp(a, 0.0, 1.0)
  if on then a = 0 end
  if self.main.SetBackdropColor then
    self.main:SetBackdropColor(0, 0, 0, a)
  end

  local function Shown(obj, v)
    if not obj then return end
    if v then
      if obj.Show then obj:Show() end
    else
      if obj.Hide then obj:Hide() end
    end
  end

  Shown(self.title, not on)
  Shown(self.byline, not on)
  Shown(self.settingsBtn, not on)
  Shown(self.closeBtn, not on)
  Shown(self.minFrame, not on)
  Shown(self.routeDropdown, not on)
  Shown(self.activeModuleTitle, not on)
  Shown(self.activeModuleTitleUnderline, not on)
  Shown(self.prevBtn, not on)
  Shown(self.nextBtn, not on)
  Shown(self.syncBtn, not on)
  Shown(self.stepCounter, not on)
  Shown(self.resizeGrip, (not on) and (self._locked ~= true) and (self:IsMinimized() ~= true))

  if self.scrollFrame then
    if on then
      self.scrollFrame:ClearAllPoints()
      self.scrollFrame:SetPoint("TOPLEFT", 10, -10)
      self.scrollFrame:SetPoint("BOTTOMRIGHT", -10, 10)
    else
      self.scrollFrame:ClearAllPoints()
      self.scrollFrame:SetPoint("TOPLEFT", 14, -72)
      self.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 48)
    end

    local sb = self.scrollFrame.ScrollBar
    if sb then
      if on then
        sb:Hide()
      else
        sb:Show()
      end
    end
  end
end

function FTA.UI:ApplyWindowSettings()
  EnsureProfileDefaults()
  if not self.main then return end
  local ui = FTADB.profile.ui
  local qol = FTADB.profile.qol or {}

  local mainScale = tonumber(ui.mainScale) or 1.0
  if mainScale < 0.5 then mainScale = 0.5 end
  if mainScale > 2.5 then mainScale = 2.5 end
  self.main:SetScale(mainScale)

  local textScale = tonumber(ui.textScale) or 1.0
  ApplyFontScale(self.title, textScale)
  ApplyFontScale(self.byline, textScale)
  ApplyFontScale(self.activeModuleTitle, textScale)
  ApplyFontScale(self.stepCounter, textScale)

  local locked = (qol.lockMainWindow == true)
  self._locked = locked

  if locked then
    self.main:EnableMouse(false)
    self.main:SetMovable(false)
    self.main:SetResizable(false)
    self.main:RegisterForDrag()

    if self.resizeGrip then
      self.resizeGrip:Hide()
      self.resizeGrip:EnableMouse(false)
    end
  else
    self.main:EnableMouse(true)
    self.main:SetMovable(true)
    self.main:SetResizable(true)
    self.main:RegisterForDrag("LeftButton")

    if self.resizeGrip then
      self.resizeGrip:Show()
      self.resizeGrip:EnableMouse(true)
    end
  end

  if self:IsMinimized() then
    if self.resizeGrip then
      self.resizeGrip:Hide()
      self.resizeGrip:EnableMouse(false)
    end
    self.main:SetResizable(false)
    self.main:RegisterForDrag("LeftButton")
  end

  self:_ApplyTextOnlyMode()
  LayoutRouteDropdown(self)
end

function FTA.UI:_ApplyMinimizedLayout()
  if not self.main then return end

  local minimized = self:IsMinimized()
  local textOnly = (self._textOnly == true)

  if minimized then
    if self.prevBtn then self.prevBtn:Hide() end
    if self.nextBtn then self.nextBtn:Hide() end
    if self.syncBtn then self.syncBtn:Hide() end
    if self.stepCounter then self.stepCounter:Hide() end
    if self.resizeGrip then self.resizeGrip:Hide() end

    if self.scrollFrame and not textOnly then
      self.scrollFrame:ClearAllPoints()
      self.scrollFrame:SetPoint("TOPLEFT", 14, -72)
      self.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 16)
    end
  else
    if not textOnly then
      if self.prevBtn then self.prevBtn:Show() end
      if self.nextBtn then self.nextBtn:Show() end
      if self.syncBtn then self.syncBtn:Show() end
      if self.stepCounter then self.stepCounter:Show() end
      if self.resizeGrip and (self._locked ~= true) then
        self.resizeGrip:Show()
      end

      if self.scrollFrame then
        self.scrollFrame:ClearAllPoints()
        self.scrollFrame:SetPoint("TOPLEFT", 14, -72)
        self.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 48)
      end
    else
      if self.prevBtn then self.prevBtn:Hide() end
      if self.nextBtn then self.nextBtn:Hide() end
      if self.syncBtn then self.syncBtn:Hide() end
      if self.stepCounter then self.stepCounter:Hide() end
      if self.resizeGrip then self.resizeGrip:Hide() end
    end
  end
end

function FTA.UI:_AutoSizeForMinimized()
  if not (self.main and self.scrollChild and self.scrollFrame) then return end
  if not self:IsMinimized() then return end

  local ui = FTADB.profile.ui
  local targetChildH = tonumber(self.scrollChild._ftaContentHeight) or self.scrollChild:GetHeight() or 1
  if targetChildH < 1 then targetChildH = 1 end

  local scale = self.main.GetScale and self.main:GetScale() or 1.0
  if scale < 0.2 then scale = 0.2 end

  local topInset = 72
  local bottomInset = 22

  local desired = topInset + targetChildH + bottomInset
  desired = math.floor(desired + 0.5)

  local minH = MIN_HEIGHT_MINIMIZED
  if desired < minH then desired = minH end
  if desired > 900 then desired = 900 end

  self.main:SetHeight(desired)

  ui.main.h = desired
end

function FTA.UI:CreateMain()
  EnsureProfileDefaults()
  if self.main then return self.main end

  local ui = FTADB.profile.ui

  if ui.main.w < MIN_WIDTH then ui.main.w = MIN_WIDTH end
  if ui.main.h < MIN_HEIGHT then ui.main.h = MIN_HEIGHT end

  local f = CreateFrame("Frame", "FollowTheArrowMainFrame", UIParent, "BackdropTemplate")
  self.main = f

  f:SetSize(ui.main.w, ui.main.h)
  f:SetPoint(ui.main.point, UIParent, ui.main.point, ui.main.x, ui.main.y)
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetClampedToScreen(true)

  f:SetResizable(true)
  if f.SetResizeBounds then
    f:SetResizeBounds(MIN_WIDTH, MIN_HEIGHT, 900, 900)
  end

  f:SetScript("OnDragStart", function(frame)
    if FTA.UI and FTA.UI._locked then return end
    frame:StartMoving()
  end)

  f:SetScript("OnDragStop", function(frame)
    frame:StopMovingOrSizing()
    local point, _, _, xOfs, yOfs = frame:GetPoint(1)
    ui.main.point = point
    ui.main.x = xOfs
    ui.main.y = yOfs
  end)

  f:SetScript("OnSizeChanged", function(frame, w, h)
    if FTA.UI and FTA.UI:IsMinimized() then
      ui.main.w = Clamp(w, MIN_WIDTH, 900)
      LayoutRouteDropdown(FTA.UI)
      return
    end

    ui.main.w = Clamp(w, MIN_WIDTH, 900)
    ui.main.h = Clamp(h, MIN_HEIGHT, 900)
    LayoutRouteDropdown(FTA.UI)
  end)

  self._normalBackdrop = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
  }

  f:SetBackdrop(self._normalBackdrop)
  f:SetBackdropColor(0, 0, 0, Clamp(tonumber(ui.mainBgAlpha) or 0.85, 0.0, 1.0))

  local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 14, -10)
  title:SetText("Follow The Arrow")
  self.title = title

  local gear = CreateFrame("Button", nil, f)
  gear:SetSize(16, 16)
  gear:SetPoint("LEFT", title, "RIGHT", 6, -1)

  gear:SetFrameStrata(f:GetFrameStrata() or "MEDIUM")
  gear:SetFrameLevel((f:GetFrameLevel() or 1) + 50)
  gear:EnableMouse(true)
  gear:SetHitRectInsets(-4, -4, -4, -4)

  gear:SetNormalTexture("Interface\\Buttons\\UI-OptionsButton")
  gear:SetHighlightTexture("Interface\\Buttons\\UI-OptionsButton")

  local n = gear:GetNormalTexture()
  if n then
    n:SetAllPoints()
    n:SetAlpha(1)
  end

  local h = gear:GetHighlightTexture()
  if h then
    h:SetAllPoints()
    h:SetAlpha(0.35)
  end

  gear:SetScript("OnClick", function()
    if FTA.Settings and FTA.Settings.Open then
      FTA.Settings:Open()
    end
  end)

  gear:SetScript("OnEnter", function()
    GameTooltip:SetOwner(gear, "ANCHOR_TOP")
    GameTooltip:SetText("Settings", 1, 1, 1)
    GameTooltip:AddLine("Open Follow The Arrow options.", 0.8, 0.8, 0.8, true)
    GameTooltip:Show()
  end)

  gear:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  self.settingsBtn = gear

  local byline = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  byline:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
  byline:SetJustifyH("LEFT")
  byline:SetText("By: Harldan")
  self.byline = byline

  local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", -4, -4)
  close:SetScript("OnClick", function()
    f:Hide()
    if FTA.UI and FTA.UI.Refresh then
      FTA.UI:Refresh()
    end
  end)
  self.closeBtn = close

  local mm = CreateFrame("Frame", nil, f, "MaximizeMinimizeButtonFrameTemplate")
  mm:SetPoint("TOPRIGHT", close, "BOTTOMRIGHT", 0, -2)
  mm:SetFrameLevel((f:GetFrameLevel() or 1) + 50)
  self.minFrame = mm

  if mm.MinimizeButton then
    mm.MinimizeButton:EnableMouse(true)
    mm.MinimizeButton:SetHitRectInsets(-4, -4, -4, -4)
    mm.MinimizeButton:SetScript("OnClick", function()
      if FTA.UI and FTA.UI.ToggleMinimized then
        FTA.UI:ToggleMinimized()
      end
    end)
    mm.MinimizeButton:SetScript("OnEnter", nil)
    mm.MinimizeButton:SetScript("OnLeave", nil)
  end

  if mm.MaximizeButton then
    mm.MaximizeButton:EnableMouse(true)
    mm.MaximizeButton:SetHitRectInsets(-4, -4, -4, -4)
    mm.MaximizeButton:SetScript("OnClick", function()
      if FTA.UI and FTA.UI.ToggleMinimized then
        FTA.UI:ToggleMinimized()
      end
    end)
    mm.MaximizeButton:SetScript("OnEnter", nil)
    mm.MaximizeButton:SetScript("OnLeave", nil)
  end

  self:UpdateMinimizeButtonVisual()

  local routeDD = CreateFrame("Frame", "FollowTheArrowRouteDropdown", f, "UIDropDownMenuTemplate")
  UIDropDownMenu_SetText(routeDD, "Select guide...")
  EnsureDropdownLeftJustify(routeDD)
  self.routeDropdown = routeDD
  LayoutRouteDropdown(self)

  local modTitle = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  modTitle:SetPoint("TOPLEFT", byline, "BOTTOMLEFT", 0, -8)
  modTitle:SetJustifyH("LEFT")
  modTitle:SetText("")
  self.activeModuleTitle = modTitle

  local underline = f:CreateTexture(nil, "ARTWORK")
  underline:SetHeight(2)
  underline:SetColorTexture(0.85, 0.82, 0.6, 0.45)
  underline:Hide()
  self.activeModuleTitleUnderline = underline

  self.activeModuleTitleLine = nil

  local function SetDropdownToActive()
    if not HasRouteAPI() then
      UIDropDownMenu_SetText(routeDD, "Select guide...")
      EnsureDropdownLeftJustify(routeDD)
      LayoutRouteDropdown(FTA.UI)
      return
    end

    local activeRouteId = GetActiveRouteId()

    if (not activeRouteId or activeRouteId == "") then
      local activeModId = GetActiveModuleId()
      local rid = FindModuleRouteId(activeModId)
      if rid then
        EnsureCharDB()
        FTACharDB.progress.activeRouteId = rid
        activeRouteId = rid
      end
    end

    if not activeRouteId or activeRouteId == "" then
      UIDropDownMenu_SetText(routeDD, "Select guide...")
      EnsureDropdownLeftJustify(routeDD)
      LayoutRouteDropdown(FTA.UI)
      return
    end

    local routes = FTA.StepEngine:GetRouteList()
    local label = activeRouteId
    if type(routes) == "table" then
      for _, r in ipairs(routes) do
        if r and r.id == activeRouteId then
          label = r.title or r.id
          break
        end
      end
    end

    UIDropDownMenu_SetText(routeDD, ShortLabel(label, 22))
    EnsureDropdownLeftJustify(routeDD)
    LayoutRouteDropdown(FTA.UI)
  end

  self._SetRouteDropdownToActive = SetDropdownToActive
  self._SetModuleDropdownToActive = nil

  UIDropDownMenu_Initialize(routeDD, function(_, level, menuList)
    if not HasRouteAPI() then
      local info = UIDropDownMenu_CreateInfo()
      info.keepShownOnClick = false
      info.text = "Route grouping unavailable"
      info.notCheckable = true
      info.disabled = true
      UIDropDownMenu_AddButton(info, level)
      return
    end

    local activeRouteId = GetActiveRouteId()
    local activeModId = GetActiveModuleId()

    if level == 1 then
      local routes = FTA.StepEngine:GetRouteList()
      if type(routes) ~= "table" or #routes < 1 then
        local info = UIDropDownMenu_CreateInfo()
        info.keepShownOnClick = false
        info.text = "No routes"
        info.notCheckable = true
        info.disabled = true
        UIDropDownMenu_AddButton(info, level)
        return
      end

      do
        local info = UIDropDownMenu_CreateInfo()
        info.keepShownOnClick = false
        info.text = "Select guide..."
        info.notCheckable = true
        info.func = function()
          EnsureCharDB()
          FTACharDB.progress.activeModuleId = nil
          FTACharDB.progress.activeRouteId = nil
          SetDropdownToActive()
          if CloseDropDownMenus then CloseDropDownMenus() end
          if FTA.UI and FTA.UI.Refresh then
            FTA.UI:Refresh()
          end
        end
        UIDropDownMenu_AddButton(info, level)
      end

      do
        local info = UIDropDownMenu_CreateInfo()
        info.text = " "
        info.notCheckable = true
        info.disabled = true
        UIDropDownMenu_AddButton(info, level)
      end

      for _, r in ipairs(routes) do
        if r and r.id then
          local rid = r.id
          local rtitle = r.title or r.id

          local info = UIDropDownMenu_CreateInfo()
          info.keepShownOnClick = false
          info.text = rtitle
          info.notCheckable = false
          info.checked = (rid == activeRouteId)

          info.hasArrow = true
          info.menuList = rid

          info.func = function()
            EnsureCharDB()
            FTACharDB.progress.activeRouteId = rid

            if FTA.SelectRoute then
              FTA:SelectRoute(rid)
            else
              local firstId = PickFirstModuleInRoute(rid)
              if firstId then
                if FTA.SelectModule then
                  FTA:SelectModule(firstId, { resetStep = false })
                elseif FTA.StepEngine and FTA.StepEngine.SetActiveModule then
                  FTA.StepEngine:SetActiveModule(firstId)
                else
                  FTACharDB.progress.activeModuleId = firstId
                  FTACharDB.progress.stepIndexByModule[firstId] = FTACharDB.progress.stepIndexByModule[firstId] or 1
                  if FTA.StepEngine and FTA.StepEngine.OnStepChanged then
                    FTA.StepEngine:OnStepChanged()
                  end
                end
              end
            end

            SetDropdownToActive()
            if CloseDropDownMenus then CloseDropDownMenus() end
            if FTA.UI and FTA.UI.Refresh then
              FTA.UI:Refresh()
            end
          end

          UIDropDownMenu_AddButton(info, level)
        end
      end

      return
    end

    if level == 2 then
      local routeId = menuList
      if type(routeId) ~= "string" or routeId == "" then routeId = "UNGROUPED" end

      local mods = FTA.StepEngine:GetModulesForRoute(routeId)
      if type(mods) ~= "table" or #mods < 1 then
        local info = UIDropDownMenu_CreateInfo()
        info.keepShownOnClick = false
        info.text = "No modules"
        info.notCheckable = true
        info.disabled = true
        UIDropDownMenu_AddButton(info, level)
        return
      end

      for _, entry in ipairs(mods) do
        if entry and entry.id then
          local mid = entry.id
          local mod = FTA.Modules and FTA.Modules[mid]
          local label = (mod and (mod.title or mod.name)) or entry.title or mid

          local info = UIDropDownMenu_CreateInfo()
          info.keepShownOnClick = false
          info.text = label
          info.notCheckable = false
          info.checked = (mid == activeModId)

          info.func = function()
            EnsureCharDB()
            FTACharDB.progress.activeRouteId = routeId

            if FTA.SelectModule then
              FTA:SelectModule(mid, { resetStep = false })
            elseif FTA.StepEngine and FTA.StepEngine.SetActiveModule then
              FTA.StepEngine:SetActiveModule(mid)
            else
              FTACharDB.progress.activeModuleId = mid
              FTACharDB.progress.stepIndexByModule[mid] = FTACharDB.progress.stepIndexByModule[mid] or 1
              if FTA.StepEngine and FTA.StepEngine.OnStepChanged then
                FTA.StepEngine:OnStepChanged()
              end
            end

            SetDropdownToActive()
            if CloseDropDownMenus then CloseDropDownMenus() end
            if FTA.UI and FTA.UI.Refresh then
              FTA.UI:Refresh()
            end
          end

          UIDropDownMenu_AddButton(info, level)
        end
      end
    end
  end)

  local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", 14, -72)
  scroll:SetPoint("BOTTOMRIGHT", -30, 48)
  self.scrollFrame = scroll

  local content = CreateFrame("Frame", nil, scroll)
  content:SetSize(1, 1)
  scroll:SetScrollChild(content)
  self.scrollChild = content

  local prev = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  prev:SetSize(70, 22)
  prev:SetPoint("BOTTOMLEFT", 14, 14)
  prev:SetText("Prev")
  prev:SetScript("OnClick", function()
    if FTA.StepEngine and FTA.StepEngine.PrevStep then
      FTA.StepEngine:PrevStep()
    end
  end)
  self.prevBtn = prev

  local nextB = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  nextB:SetSize(70, 22)
  nextB:SetPoint("BOTTOMLEFT", prev, "BOTTOMRIGHT", 10, 0)
  nextB:SetText("Next")
  nextB:SetScript("OnClick", function()
    if FTA.StepEngine and FTA.StepEngine.NextStep then
      FTA.StepEngine:NextStep()
    end
  end)
  self.nextBtn = nextB

  local sync = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  sync:SetSize(25, 25)
  sync:SetPoint("LEFT", nextB, "RIGHT", 10, 0)
  sync:SetText("")

  local tex = sync:CreateTexture(nil, "ARTWORK")
  tex:SetAllPoints(sync)
  tex:SetTexture("Interface\\Buttons\\UI-RefreshButton")
  sync._icon = tex

  sync:SetScript("OnClick", function()
    if FTA.StepEngine and FTA.StepEngine.SyncNow then
      FTA.StepEngine:SyncNow(25)
    elseif FTA.StepEngine and FTA.StepEngine.SyncForward then
      FTA.StepEngine:SyncForward()
      FTA.StepEngine:OnStepChanged()
    end
  end)

  sync:SetScript("OnEnter", function()
    GameTooltip:SetOwner(sync, "ANCHOR_TOP")
    GameTooltip:SetText("Sync guide", 1, 1, 1)
    GameTooltip:AddLine("Re-check quests and advance steps until correct.", 0.8, 0.8, 0.8, true)
    GameTooltip:Show()
  end)

  sync:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  self.syncBtn = sync

  local counter = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  counter:SetPoint("BOTTOMRIGHT", -14, 18)
  counter:SetText("")
  self.stepCounter = counter

  local grip = CreateFrame("Button", nil, f)
  grip:SetSize(16, 16)
  grip:SetPoint("BOTTOMRIGHT", -6, 6)
  grip:EnableMouse(true)
  grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
  grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
  grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
  grip:SetScript("OnMouseDown", function()
    if FTA.UI and FTA.UI._locked then return end
    if FTA.UI and FTA.UI:IsMinimized() then return end
    f:StartSizing("BOTTOMRIGHT")
  end)
  grip:SetScript("OnMouseUp", function() f:StopMovingOrSizing() end)
  self.resizeGrip = grip

  self:ApplyWindowSettings()

  f:Hide()
  return f
end

function FTA.UI:ToggleMain(forceShow)
  local f = self.main or self:CreateMain()

  local gen = (FTADB and FTADB.profile and FTADB.profile.general) or {}

  if gen.hideMainWindow == true then
    if f:IsShown() then
      f:Hide()
    end

    if FTA.GuideArrow and FTA.GuideArrow.SetEnabled then
      local isOn = false
      if FTA.GuideArrow.IsEnabled then
        isOn = (FTA.GuideArrow:IsEnabled() == true)
      elseif FTA.GuideArrow.frame and FTA.GuideArrow.frame.IsShown then
        isOn = (FTA.GuideArrow.frame:IsShown() == true)
      end

      if forceShow == true then
        FTA.GuideArrow:SetEnabled(gen.hideArrow ~= true)
      elseif forceShow == false then
        FTA.GuideArrow:SetEnabled(false)
      else
        if isOn then
          FTA.GuideArrow:SetEnabled(false)
        else
          FTA.GuideArrow:SetEnabled(gen.hideArrow ~= true)
        end
      end
    end

    self:Refresh()
    return
  end

  if forceShow == true then
    f:Show()
  elseif forceShow == false then
    f:Hide()
  else
    if f:IsShown() then f:Hide() else f:Show() end
  end

  if FTA.GuideArrow and FTA.GuideArrow.SetEnabled then
    if f:IsShown() then
      FTA.GuideArrow:SetEnabled(gen.hideArrow ~= true)
    else
      FTA.GuideArrow:SetEnabled(false)
    end
  end

  self:Refresh()
end

function FTA.UI:ResetMain()
  EnsureProfileDefaults()
  local ui = FTADB.profile.ui

  ui.main.point = "CENTER"
  ui.main.x = 0
  ui.main.y = 0
  ui.main.w = DEFAULT_WIDTH
  ui.main.h = DEFAULT_HEIGHT
  ui.main.restoreH = ui.main.h
  ui.main.minimized = false

  if ui.main.w < MIN_WIDTH then ui.main.w = MIN_WIDTH end
  if ui.main.h < MIN_HEIGHT then ui.main.h = MIN_HEIGHT end

  local f = self.main or self:CreateMain()
  f:ClearAllPoints()
  f:SetPoint(ui.main.point, UIParent, ui.main.point, ui.main.x, ui.main.y)
  f:SetSize(ui.main.w, ui.main.h)
  self:Refresh()
end

function FTA.UI:Refresh()
  if not self.main then return end

  EnsureProfileDefaults()
  local ui = FTADB.profile.ui

  self:_ApplyVisibilityFromSettings()
  self:ApplyWindowSettings()
  self:UpdateMinimizeButtonVisual()
  self:_ApplyMinimizedLayout()

  local gen = (FTADB and FTADB.profile and FTADB.profile.general) or {}
  local hideArrow = (gen.hideArrow == true)

  local stepDone = false
  if FTA.StepEngine and FTA.StepEngine.GetCurrentStep then
    local _, _, step = FTA.StepEngine:GetCurrentStep()
    if step and FTA.Resolve and FTA.Resolve.IsStepSatisfied then
      stepDone = (FTA.Resolve:IsStepSatisfied(step) == true)
    end
  end

  if stepDone then
    hideArrow = true
  end

  if FTA.GuideArrow and FTA.GuideArrow.SetEnabled then
    if hideArrow then
      FTA.GuideArrow:SetEnabled(false)
    else
      if self.main and self.main:IsShown() then
        FTA.GuideArrow:SetEnabled(true)
      else
        if self._hiddenBySetting ~= true then
          FTA.GuideArrow:SetEnabled(false)
        end
      end
    end
  end

  if self._SetRouteDropdownToActive then
    self._SetRouteDropdownToActive()
  end

  local text = ""
  if FTA.StepEngine and FTA.StepEngine.GetCurrentStep then
    local mod, idx = FTA.StepEngine:GetCurrentStep()
    if mod and mod.steps and idx then
      text = ("Step %d / %d"):format(idx, #mod.steps)
    end
  end
  if self.stepCounter then
    self.stepCounter:SetText(text)
  end

  if FTA.StepList and FTA.StepList.Render and self.scrollChild then
    local mod = nil
    if FTA.StepEngine and FTA.StepEngine.GetCurrentStep then
      mod = select(1, FTA.StepEngine:GetCurrentStep())
    end

    if self.activeModuleTitle then
      if mod and mod.title then
        self.activeModuleTitle:SetText(mod.title)
        if self._textOnly ~= true then
          self.activeModuleTitle:Show()
        else
          self.activeModuleTitle:Hide()
        end

        if self.activeModuleTitleUnderline then
          if self._textOnly ~= true then
            local title = self.activeModuleTitle
            local underline = self.activeModuleTitleUnderline

            title:SetWidth(0)
            local wTitle = title:GetStringWidth() or 0

            underline:ClearAllPoints()
            underline:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
            underline:SetWidth(wTitle)
            underline:Show()
          else
            self.activeModuleTitleUnderline:Hide()
          end
        end
      else
        self.activeModuleTitle:SetText("")
        self.activeModuleTitle:Hide()

        if self.activeModuleTitleUnderline then
          self.activeModuleTitleUnderline:Hide()
        end
      end
    end

    local w = (self.scrollFrame and self.scrollFrame:GetWidth()) or (self.main:GetWidth() - 44)
    self.scrollChild:SetWidth(w)

    if not mod then
      if FTA.StepList and FTA.StepList.Render then
        FTA.StepList:Render(self.scrollChild)
      end

      for i = 1, self.scrollChild:GetNumChildren() do
        local child = select(i, self.scrollChild:GetChildren())
        if child and child.Hide then
          child:Hide()
        end
      end

      local msg = self.scrollChild._emptyMessage
      if not msg then
        msg = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        msg:SetPoint("TOPLEFT", 10, -10)
        msg:SetJustifyH("LEFT")
        msg:SetJustifyV("TOP")
        self.scrollChild._emptyMessage = msg
      end

      msg:SetWidth(math.max(1, w - 20))
      msg:SetText("Select a guide from the dropdown above to begin.\n\nRoutes group multiple modules (zones) together.\n\nChoose a route, then pick the starting module.\n\nYou can find my latest leveling guide or speedrun video below, clicking the thumbnail will bring up a copy + pasteable YouTube URL.")
      msg:Show()

      local embed = self.scrollChild._embedThumb
      if not embed then
        embed = CreateFrame("Button", nil, self.scrollChild, "BackdropTemplate")
        self.scrollChild._embedThumb = embed

        embed:SetSize(320, 180)
        embed:SetPoint("TOP", msg, "BOTTOM", 0, -12)

        local t = embed:CreateTexture(nil, "ARTWORK")
        local border = CreateFrame("Frame", nil, embed, "BackdropTemplate")
        embed._border = border
        border:SetAllPoints(embed)
        border:SetBackdrop({
          edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
          edgeSize = 14,
          insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        border:SetBackdropBorderColor(0.72, 0.72, 0.72, 0.95)
        embed._tex = t
        t:ClearAllPoints()
        t:SetPoint("TOPLEFT", embed, "TOPLEFT", 2, -2)
        t:SetPoint("BOTTOMRIGHT", embed, "BOTTOMRIGHT", -2, 2)
        t:SetTexture(EMBED_TEX)

        local hl = embed:CreateTexture(nil, "HIGHLIGHT")
        embed._hl = hl
        hl:ClearAllPoints()
        hl:SetPoint("TOPLEFT", embed, "TOPLEFT", 2, -2)
        hl:SetPoint("BOTTOMRIGHT", embed, "BOTTOMRIGHT", -2, 2)
        hl:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
        hl:SetBlendMode("ADD")
        hl:SetAlpha(0.25)

        embed:SetScript("OnClick", function()
          if FTA.UI and FTA.UI.ShowEmbedURL then
            FTA.UI:ShowEmbedURL(EMBED_URL)
          end
        end)

        embed:SetScript("OnEnter", function()
          GameTooltip:SetOwner(embed, "ANCHOR_RIGHT")
          GameTooltip:SetText("Watch my new 10-90 Speedrun using the updated 12.0.7 route!", 1, 1, 1)
          GameTooltip:AddLine("Clicking this will open a text box with the YouTube URL.", 0.8, 0.8, 0.8, true)
          GameTooltip:Show()
        end)

        embed:SetScript("OnLeave", function()
          GameTooltip:Hide()
        end)
      end

      if self._textOnly ~= true then
        embed:Show()
      else
        embed:Hide()
      end

      self.scrollChild:SetHeight(280)
    else
      if self.scrollChild._emptyMessage then
        self.scrollChild._emptyMessage:Hide()
      end

      if self.scrollChild._embedThumb then
        self.scrollChild._embedThumb:Hide()
      end

      FTA.StepList:Render(self.scrollChild)

      local top = self.scrollChild:GetTop()
      local maxDist = 0
      for i = 1, self.scrollChild:GetNumChildren() do
        local child = select(i, self.scrollChild:GetChildren())
        if child and child:IsShown() then
          local b = child:GetBottom()
          if top and b then
            local dist = top - b
            if dist > maxDist then maxDist = dist end
          end
        end
      end
      if maxDist < 1 then maxDist = 1 end
      self.scrollChild:SetHeight(math.max(1, maxDist + 8))

      self:_AutoSizeForMinimized()
    end
  end
end