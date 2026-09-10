local Private = select(2, ...)
local L = Private.L

local E = unpack(ElvUI)

function Private.ShowCopyBox(title, text, profileName)
  if not MUI_CopyFrame then
    -- frame setup
    local f = CreateFrame('Frame', 'MUI_CopyFrame', UIParent, 'PortraitFrameTemplate')
    f:SetSize(520, 260)
    f:SetPoint('CENTER')
    f:SetFrameStrata('TOOLTIP')
    f:SetFrameLevel(100)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:SetClampedToScreen(true)
    local color = CreateColorFromHexString('ff1f1e21')
    local r, g, b = color:GetRGB()
    f.Bg:SetColorTexture(r, g, b, 0.8)
    f.Bg.colorTexture = { r, g, b, 0.8 }
    MUI_CopyFramePortrait:SetTexture(Private.EditModeLogoTexture or 'Interface\\AddOns\\MerfinUI\\Media\\Textures\\logo_midnight1.png')
    -- copy feedback text
    local msg = UIParent:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightHuge')
    msg:SetPoint('CENTER', UIParent, 'CENTER', 0, 200)
    msg:SetText(L['Copied!'])
    msg:SetTextColor(0, 1, 0)
    msg:SetAlpha(0)
    msg:Hide()
    f.copyText = msg
    local ag = msg:CreateAnimationGroup()
    local delay = ag:CreateAnimation('Alpha')
    delay:SetFromAlpha(1)
    delay:SetToAlpha(1)
    delay:SetDuration(1)
    delay:SetOrder(1)
    local fade = ag:CreateAnimation('Alpha')
    fade:SetFromAlpha(1)
    fade:SetToAlpha(0)
    fade:SetDuration(0.5)
    fade:SetOrder(2)
    ag:SetScript('OnFinished', function()
      msg:Hide()
    end)
    msg.anim = ag
    msg:SetScript('OnShow', function(self)
      if self.anim:IsPlaying() then
        self.anim:Stop()
      end
      self:SetAlpha(1)
      self.anim:Play()
    end)
    -- scrollframe
    local scrollFrame = CreateFrame('ScrollFrame', nil, f, 'UIPanelScrollFrameTemplate')
    scrollFrame:SetPoint('TOPLEFT', 20, -60)
    scrollFrame:SetPoint('BOTTOMRIGHT', -30, 60)
    -- editbox
    local eb = CreateFrame('EditBox', nil, scrollFrame)
    eb:SetMultiLine(true)
    eb:SetFontObject(ChatFontNormal)
    eb:SetJustifyH('LEFT')
    eb:SetJustifyV('TOP')
    eb:SetTextInsets(5, 5, 5, 5)
    eb:SetAutoFocus(false)
    eb:SetEnabled(true)
    eb:EnableMouse(true)
    eb:EnableKeyboard(true)
    scrollFrame:SetScrollChild(eb)
    eb:SetPoint('TOPLEFT')
    scrollFrame:SetScript('OnSizeChanged', function(self)
      eb:SetWidth(self:GetWidth() - 10)
    end)
    eb:SetScript('OnChar', nil)
    eb:SetScript('OnTextChanged', function(self, userInput)
      if userInput then
        local displayText = self.originalText or ''
        displayText = displayText:gsub('\\124', '|') -- \\124 -> |
        displayText = displayText:gsub('|', '||') -- | -> ||
        self:SetText(displayText)
        self:HighlightText()
      end
    end)
    eb:SetScript('OnShow', function(self)
      self:SetFocus()
      self:HighlightText()
    end)
    eb:SetScript('OnEditFocusGained', function(self)
      self:HighlightText()
    end)
    eb:SetScript('OnEscapePressed', function(self)
      self:ClearFocus()
    end)
    eb:SetScript('OnKeyDown', function(self, key)
      if key == 'C' and IsControlKeyDown() then
        local frame = self:GetParent():GetParent()
        frame.copyText:Show()
      end
    end)
    f.editBox = eb
    -- name box
    local nameBox = CreateFrame('EditBox', nil, f)
    nameBox:SetMultiLine(false)
    nameBox:SetFontObject(ChatFontNormal)
    nameBox:SetJustifyH('LEFT')
    nameBox:SetTextInsets(5, 5, 0, 0)
    nameBox:SetSize(300, 20)
    nameBox:SetPoint('BOTTOMLEFT', f, 'BOTTOMLEFT', 20, 25)
    nameBox:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -20, 25)
    nameBox:SetAutoFocus(false)
    nameBox:SetEnabled(true)
    nameBox:EnableMouse(true)
    nameBox:EnableKeyboard(true)
    nameBox:SetScript('OnChar', nil)
    nameBox:SetScript('OnTextChanged', function(self, userInput)
      if userInput then
        self:SetText(self.originalText or '')
        self:HighlightText()
      end
    end)
    nameBox:SetScript('OnEscapePressed', function(self)
      self:ClearFocus()
    end)
    nameBox:SetScript('OnEditFocusGained', function(self)
      self:HighlightText()
    end)
    nameBox:SetScript('OnMouseUp', function(self)
      self:SetFocus()
      self:HighlightText()
    end)
    nameBox:SetScript('OnKeyDown', function(self, key)
      if key == 'C' and IsControlKeyDown() then
        local f = self:GetParent()
        f.copyText:Show()
        f:Hide()
      end
    end)
    f.nameBox = nameBox
    -- drag
    if not f.TitleContainer then
      f.TitleContainer = CreateFrame('Frame', nil, f)
      f.TitleContainer:SetAllPoints(f.TitleBg or f.TitleContainer)
      f.TitleContainer:EnableMouse(true)
    end
    f.TitleContainer:SetScript('OnMouseDown', function(_, button)
      if button == 'LeftButton' then
        f:StartMoving()
      end
    end)
    f.TitleContainer:SetScript('OnMouseUp', function(_, button)
      if button == 'LeftButton' then
        f:StopMovingOrSizing()
      end
    end)
    -- combat handling
    f:SetScript('OnShow', function(self)
      if InCombatLockdown() then
        self:Hide()
      end
      self:RegisterEvent('PLAYER_REGEN_DISABLED')
    end)
    f:SetScript('OnHide', function(self)
      self:StopMovingOrSizing()
      self:UnregisterEvent('PLAYER_REGEN_DISABLED')
    end)
    f:SetScript('OnEvent', function(self)
      if self:IsShown() then
        self:Hide()
      end
    end)

    tinsert(UISpecialFrames, f:GetName())
    f:Hide()
  end

  -- apply data
  local f = MUI_CopyFrame
  f:Show()

  MUI_CopyFrameTitleText:SetText(title or '')
  local displayText = text or ''
  displayText = displayText:gsub('\\124', '|') -- \\124 -> |
  displayText = displayText:gsub('|', '||') -- | -> ||
  f.editBox.originalText = displayText
  f.editBox:SetText(displayText)
  f.editBox:SetCursorPosition(0)
  f.editBox:HighlightText()
  f.editBox:SetFocus()

  f.nameBox.originalText = profileName or ''
  f.nameBox:SetText(profileName or '')
  f.nameBox:ClearFocus()
end

function Private.CreateImportProfileButtons(parent, profiles, titlePrefix, profilePrefix, buttonText)
  if parent.MUIButtons then
    return
  end

  local S = E:GetModule('Skins')
  parent.MUIButtons = {}

  local spacingX = 5
  local spacingY = 5
  local startY = -58
  local width = 235
  local height = 16

  for i, info in ipairs(profiles) do
    local btn = CreateFrame('Button', nil, parent, 'UIPanelButtonTemplate')
    S:HandleButton(btn)

    btn:SetText(buttonText and buttonText(info) or info.name)
    btn.title = info.name

    local fs = btn:GetFontString()
    fs:ClearAllPoints()
    fs:SetPoint('LEFT', btn, 'LEFT', 6, 0)
    fs:SetPoint('RIGHT', btn, 'RIGHT', -6, 0)
    fs:SetJustifyH('LEFT')

    local col = (i - 1) % 2
    local row = math.floor((i - 1) / 2)

    local btnWidth = (i % 2 == 0) and (width - 15) or width
    btn:SetSize(btnWidth, height)
    btn:SetPoint('TOPLEFT', parent, 'TOPRIGHT', col * (width + spacingX), startY - (row * (height + spacingY)))

    btn:SetScript('OnClick', function()
      Private.ShowCopyBox((titlePrefix or '') .. btn.title, info.data, (profilePrefix or '') .. info.name)
    end)

    parent.MUIButtons[i] = btn
  end
end

function Private.CreateEditModeImportArrow()
  if E.Retail then
    return
  end

  local manager = EditModeManagerFrame
  if not manager or manager.MUIImportArrow then
    return
  end

  local arrow = CreateFrame('Frame', nil, UIParent)
  arrow:SetSize(128, 32)
  arrow:SetFrameStrata('TOOLTIP')
  arrow:SetFrameLevel(100)
  arrow:Hide()
  manager.MUIImportArrow = arrow

  local texture = arrow:CreateTexture(nil, 'OVERLAY')
  texture:SetAllPoints()
  texture:SetTexture('Interface\\AddOns\\MerfinUI\\Media\\Textures\\editmode_import_arrow.png')

  local flash = arrow:CreateAnimationGroup()
  flash:SetLooping('REPEAT')

  local fadeOut = flash:CreateAnimation('Alpha')
  fadeOut:SetFromAlpha(1)
  fadeOut:SetToAlpha(0.25)
  fadeOut:SetDuration(0.35)
  fadeOut:SetOrder(1)

  local fadeIn = flash:CreateAnimation('Alpha')
  fadeIn:SetFromAlpha(0.25)
  fadeIn:SetToAlpha(1)
  fadeIn:SetDuration(0.35)
  fadeIn:SetOrder(2)

  local hideDelay = arrow:CreateAnimationGroup()
  local delay = hideDelay:CreateAnimation('Translation')
  delay:SetOffset(0, 0)
  delay:SetDuration(0.01)
  if delay.SetEndDelay then
    delay:SetEndDelay(4.99)
  else
    delay:SetDuration(5)
  end
  delay:SetOrder(1)

  local importText = HUD_EDIT_MODE_IMPORT_LAYOUT or IMPORT or 'Import'
  local function SafeIsShown(frame)
    if not frame or not frame.IsShown then
      return
    end

    local ok, isShown = pcall(frame.IsShown, frame)
    return ok and isShown
  end

  local function SafeIsVisible(frame)
    if frame and frame.IsVisible then
      local ok, isVisible = pcall(frame.IsVisible, frame)
      if ok then
        return isVisible
      end
    end

    return SafeIsShown(frame)
  end

  local function IsImportDialogShown()
    return SafeIsShown(EditModeImportLayoutDialog)
  end

  local function IsNearEditModeManager(frame)
    if not frame.GetCenter or not manager.GetLeft then
      return
    end

    local ok, x, y = pcall(frame.GetCenter, frame)
    if not ok or not x or not y then
      return
    end

    local left, right, top, bottom = manager:GetLeft(), manager:GetRight(), manager:GetTop(), manager:GetBottom()
    if left then
      left = left - 120
      right = right + 220
      top = top + 120
      bottom = bottom - 180
    end

    return left and right and top and bottom and x >= left and x <= right and y <= top and y >= bottom
  end

  local function IsImportLayoutButton(frame)
    if not frame or not frame.GetElementDescription or not MenuUtil or not MenuUtil.GetElementText then
      return
    end

    local ok, description = pcall(frame.GetElementDescription, frame)
    if not ok or not description then
      return
    end

    local text
    ok, text = pcall(MenuUtil.GetElementText, description)
    if not ok then
      return
    end

    return text == importText and IsNearEditModeManager(frame)
  end

  local function IsImportText(region)
    if not region or not region.GetObjectType then
      return
    end

    local ok, objectType = pcall(region.GetObjectType, region)
    if not ok or objectType ~= 'FontString' or not region.GetText then
      return
    end

    if region.IsShown and not SafeIsShown(region) then
      return
    end

    local text
    ok, text = pcall(region.GetText, region)
    return ok and text == importText and IsNearEditModeManager(region)
  end

  local function FindImportTarget()
    if not EnumerateFrames then
      return
    end

    local frame = EnumerateFrames()
    while frame do
      local isShown = SafeIsShown(frame)
      if isShown and IsImportLayoutButton(frame) then
        return frame
      end

      if isShown and frame.GetNumRegions and frame.GetRegions then
        local numRegions
        local ok
        ok, numRegions = pcall(frame.GetNumRegions, frame)
        if ok then
          local regions
          ok, regions = pcall(function()
            return { frame:GetRegions() }
          end)
          if not ok then
            regions = nil
          end

          for i = 1, numRegions do
            local region = regions and regions[i]
            if IsImportText(region) then
              return region
            end
          end
        end
      end

      frame = EnumerateFrames(frame)
    end
  end

  local flashing
  local activeTarget
  local installerPromptActive
  local flashRun = 0
  local function IsTargetVisible(target)
    if not target then
      return
    end

    local parent = target.GetParent and target:GetParent()
    if parent and not SafeIsVisible(parent) then
      return
    end

    return SafeIsVisible(target) and IsNearEditModeManager(target) and (IsImportLayoutButton(target) or IsImportText(target))
  end

  local function AnchorArrowToTarget(target)
    arrow:ClearAllPoints()
    arrow:SetPoint('LEFT', target, 'RIGHT', 8, 0)
  end

  local function HideArrow(runID)
    if runID and runID ~= flashRun then
      return
    end

    flashRun = flashRun + 1

    if hideDelay:IsPlaying() then
      hideDelay:Stop()
    end

    if flash:IsPlaying() then
      flash:Stop()
    end

    flashing = false
    activeTarget = nil
    arrow:Hide()
  end

  local function TryShowArrow()
    if flashing or not installerPromptActive then
      return
    end

    if not SafeIsShown(manager) or IsImportDialogShown() or (InCombatLockdown and InCombatLockdown()) then
      HideArrow()
      return
    end

    local importTarget = FindImportTarget()
    if importTarget then
      flashing = true
      activeTarget = importTarget
      flashRun = flashRun + 1

      AnchorArrowToTarget(importTarget)
      arrow:SetAlpha(1)
      arrow:Show()
      flash:Play()
      hideDelay.runID = flashRun
      hideDelay:Play()
    else
      arrow:Hide()
    end
  end

  arrow:SetScript('OnUpdate', function()
    if flashing and IsImportDialogShown() then
      installerPromptActive = false
      HideArrow()
    elseif flashing and not IsTargetVisible(activeTarget) then
      HideArrow()
    elseif flashing then
      AnchorArrowToTarget(activeTarget)
    end
  end)

  local function QueuePositionArrow()
    if flashing or not installerPromptActive then
      return
    end

    if C_Timer and C_Timer.After then
      C_Timer.After(0, TryShowArrow)
      C_Timer.After(0.05, TryShowArrow)
      C_Timer.After(0.10, TryShowArrow)
      C_Timer.After(0.20, TryShowArrow)
      C_Timer.After(0.35, TryShowArrow)
    else
      TryShowArrow()
    end
  end

  hideDelay:SetScript('OnFinished', function(self)
    HideArrow(self.runID)
  end)

  function arrow:QueueInstallerPrompt()
    installerPromptActive = true
    QueuePositionArrow()
  end

  arrow:RegisterEvent('PLAYER_REGEN_DISABLED')
  arrow:SetScript('OnEvent', function()
    installerPromptActive = false
    HideArrow()
  end)

  if manager.LayoutDropdown and manager.LayoutDropdown.HookScript then
    manager.LayoutDropdown:HookScript('OnMouseDown', QueuePositionArrow)
    manager.LayoutDropdown:HookScript('OnMouseUp', QueuePositionArrow)
  end
end

function Private.QueueEditModeImportArrow()
  if E.Retail then
    return
  end

  local manager = EditModeManagerFrame
  if not manager then
    return
  end

  if not manager.MUIImportArrow then
    Private.CreateEditModeImportArrow()
  end

  if manager.MUIImportArrow and manager.MUIImportArrow.QueueInstallerPrompt then
    manager.MUIImportArrow:QueueInstallerPrompt()
  end
end
