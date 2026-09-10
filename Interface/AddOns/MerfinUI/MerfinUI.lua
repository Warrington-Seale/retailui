local E = unpack(ElvUI)
local EP = LibStub('LibElvUIPlugin-1.0')
local PI = E:GetModule('PluginInstaller')

local print = print
local ReloadUI = ReloadUI
local stformat = string.format
local CreateFrame = CreateFrame
local GameMenuButtonAddons = GameMenuButtonAddons
local GameMenuButtonLogout = GameMenuButtonLogout
local GameMenuFrame = GameMenuFrame
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local hooksecurefunc = hooksecurefunc
local type = type
local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local addonName, Private = ...
local L = Private.L

local screenWidth, screenHeight = GetPhysicalScreenSize()

Private.Locale = GAME_LOCALE or GetLocale()
Private.Name = '|cff40c7ebMerfinUI|r'
Private.Version = tonumber(GetAddOnMetadata(addonName, 'Version'))
Private.Resolution = screenWidth >= 2530 and 'QUAD_HD' or 'FULL_HD'
Private.ScreenHeight = screenHeight
Private.Font = 'Merfin Font 1'
Private.Texture = 'Merfin Main Texture'
Private.AceProfileName = string.format('%s - %s', UnitName('player'), GetRealmName('player'))
Private.MerfinProfileName = 'MerfinUI (' .. Private.ScreenHeight .. ') v' .. Private.Version
Private.BuildInfo = select(4, GetBuildInfo())

local MUI = E:NewModule(addonName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')

function Private:Print(msg)
  print(stformat('%s: %s', Private.Name, msg))
end

E.PopupDialogs.MUI_RELOAD = {
  text = L['Reload required. Continue?'],
  button1 = ACCEPT,
  button2 = CANCEL,
  OnAccept = ReloadUI,
  whileDead = 1,
  hideOnEscape = false,
}

function Private.OpenOptions()
  E:ToggleOptions()
  E.Libs.AceConfigDialog:SelectGroup('ElvUI', 'MUI')
end

local function ClickGameMenu()
  Private.OpenOptions()

  if not InCombatLockdown() then
    HideUIPanel(GameMenuFrame)
  end
end

local function SkinGameMenuButton(button)
  local S = E:GetModule('Skins', true)

  if S and E.private.skins.blizzard.enable and E.private.skins.blizzard.misc and not button.IsSkinned then
    S:HandleButton(button, nil, nil, nil, true)

    if button.backdrop then
      button.backdrop:SetInside(nil, 1, 1)
    end
  end
end

local function UsesModernGameMenu()
  return GameMenuFrame and GameMenuFrame.buttonPool and type(GameMenuFrame.Layout) == 'function'
end

local classicGameMenuLogoutPoint
local classicGameMenuUpdateWrapped

local function RestoreClassicGameMenuLogout()
  if not classicGameMenuLogoutPoint or not GameMenuButtonLogout then
    return
  end

  GameMenuButtonLogout:ClearAllPoints()
  GameMenuButtonLogout:SetPoint(classicGameMenuLogoutPoint.point, classicGameMenuLogoutPoint.relativeTo, classicGameMenuLogoutPoint.relativePoint, classicGameMenuLogoutPoint.xOfs, classicGameMenuLogoutPoint.yOfs)
end

local function PositionModernGameMenuButton(button)
  if not GameMenuFrame.buttonPool then
    return
  end

  local buttonHeight = (button.GetHeight and button:GetHeight()) or (E.Retail and 35) or 21
  local elvButton = GameMenuFrame.ElvUI
  if not elvButton then
    return
  end

  button:ClearAllPoints()
  button:SetPoint('TOPLEFT', elvButton, 'BOTTOMLEFT')

  local elvBottom = elvButton.GetBottom and elvButton:GetBottom()
  if elvBottom then
    for menuButton in GameMenuFrame.buttonPool:EnumerateActive() do
      local top = menuButton.GetTop and menuButton:GetTop()

      if top and top <= elvBottom and menuButton.NudgePoint then
        menuButton:NudgePoint(nil, -buttonHeight)
      end
    end
  end

  if type(GameMenuFrame.Layout) == 'function' or not button.MerfinUIHeightAdjusted then
    GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + buttonHeight)
    button.MerfinUIHeightAdjusted = true
  end
end

local function PositionClassicGameMenuButton(button)
  if not GameMenuButtonLogout then
    return
  end

  local anchor = GameMenuFrame.ElvUI or GameMenuButtonAddons
  if anchor then
    button:SetSize(GameMenuButtonLogout:GetSize())
    if button.backdrop then
      button.backdrop:SetInside(nil, 0, 0)
    end

    button:ClearAllPoints()
    button:SetPoint('TOPLEFT', anchor, 'BOTTOMLEFT', 0, -1)
  end

  local point, relTo, relativePoint, xOfs, offY = GameMenuButtonLogout:GetPoint()
  if relTo ~= button then
    classicGameMenuLogoutPoint = { point = point, relativeTo = relTo, relativePoint = relativePoint, xOfs = xOfs, yOfs = offY }

    GameMenuButtonLogout:ClearAllPoints()
    GameMenuButtonLogout:SetPoint('TOPLEFT', button, 'BOTTOMLEFT', 0, offY or -16)
  end

  if not button.MerfinUIHeightAdjusted then
    GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() - 4)
    button.MerfinUIHeightAdjusted = true
  end
end

local function PositionGameMenuButton()
  local button = GameMenuFrame and GameMenuFrame.MerfinUI
  if not button then
    return
  end

  button:SetText(Private.Name)

  if UsesModernGameMenu() then
    PositionModernGameMenuButton(button)
  else
    PositionClassicGameMenuButton(button)
  end
end

local function CreateGameMenuButton()
  local button

  if UsesModernGameMenu() then
    button = CreateFrame('Button', 'MerfinUI_GameMenuButton', GameMenuFrame, 'MainMenuFrameButtonTemplate')
    button:SetSize(E.Retail and 200 or 144, E.Retail and 35 or 21)
    hooksecurefunc(GameMenuFrame, 'Layout', PositionGameMenuButton)
  else
    button = CreateFrame('Button', 'MerfinUI_GameMenuButton', GameMenuFrame, 'GameMenuButtonTemplate')

    if GameMenuButtonLogout then
      button:SetSize(GameMenuButtonLogout:GetSize())
    end

    if GameMenuButtonAddons then
      button:SetPoint('TOPLEFT', GameMenuButtonAddons, 'BOTTOMLEFT', 0, -1)
    end

    if type(_G.GameMenuFrame_UpdateVisibleButtons) == 'function' then
      if not classicGameMenuUpdateWrapped then
        local UpdateVisibleButtons = _G.GameMenuFrame_UpdateVisibleButtons
        _G.GameMenuFrame_UpdateVisibleButtons = function(...)
          RestoreClassicGameMenuLogout()
          UpdateVisibleButtons(...)
          PositionGameMenuButton()
        end

        classicGameMenuUpdateWrapped = true
      end
    elseif GameMenuFrame.HookScript then
      GameMenuFrame:HookScript('OnShow', PositionGameMenuButton)
    end
  end

  return button
end

local function SetupGameMenuButton()
  if not GameMenuFrame or GameMenuFrame.MerfinUI then
    return
  end
  if not E.private.MUI.general.profileSettings.gameMenu.show then
    return
  end

  if E.Cata then
    if not GameMenuButtonLogout then
      return
    end

    if E.SetupGameMenu and not GameMenuFrame.ElvUI then
      E:SetupGameMenu()
    end

    local button = CreateFrame('Button', 'MerfinUI_GameMenuButton', GameMenuFrame, 'GameMenuButtonTemplate')
    local logoutPoint

    local function RestoreLogout()
      if not logoutPoint then
        return
      end

      GameMenuButtonLogout:ClearAllPoints()
      GameMenuButtonLogout:SetPoint(logoutPoint.point, logoutPoint.relativeTo, logoutPoint.relativePoint, logoutPoint.xOfs, logoutPoint.yOfs)
    end

    local function PositionButton()
      local anchor = GameMenuFrame.ElvUI or GameMenuButtonAddons
      if not anchor or anchor == button then
        return
      end

      local width, height = GameMenuButtonAddons:GetSize()
      local _, _, _, _, anchorY = anchor:GetPoint()

      if GameMenuFrame.ElvUI then
        GameMenuFrame.ElvUI:SetSize(width, height)
      end

      button:SetText(Private.Name)
      button:SetSize(width, height)
      if button.backdrop then
        button.backdrop:SetInside(nil, 0, 0)
      end
      button:ClearAllPoints()
      button:SetPoint('TOPLEFT', anchor, 'BOTTOMLEFT', 0, anchorY or -1)

      local point, relativeTo, relativePoint, xOfs, yOfs = GameMenuButtonLogout:GetPoint()
      if relativeTo ~= button then
        logoutPoint = { point = point, relativeTo = relativeTo, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs }
      end

      GameMenuButtonLogout:ClearAllPoints()
      GameMenuButtonLogout:SetPoint('TOPLEFT', button, 'BOTTOMLEFT', 0, yOfs or -16)

      if not button.MerfinUIHeightAdjusted then
        GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() - 4)
        button.MerfinUIHeightAdjusted = true
      end
    end

    button:SetSize(GameMenuButtonAddons:GetSize())
    button:SetScript('OnClick', ClickGameMenu)
    GameMenuFrame.MerfinUI = button

    SkinGameMenuButton(button)
    if button.backdrop then
      button.backdrop:SetInside(nil, 0, 0)
    end

    if type(_G.GameMenuFrame_UpdateVisibleButtons) == 'function' then
      local UpdateVisibleButtons = _G.GameMenuFrame_UpdateVisibleButtons
      _G.GameMenuFrame_UpdateVisibleButtons = function(...)
        RestoreLogout()
        UpdateVisibleButtons(...)
        PositionButton()
      end
    elseif GameMenuFrame.HookScript then
      GameMenuFrame:HookScript('OnShow', PositionButton)
    end

    if GameMenuFrame.HookScript then
      GameMenuFrame:HookScript('OnHide', RestoreLogout)
    end

    return
  end

  if E.SetupGameMenu and not GameMenuFrame.ElvUI then
    E:SetupGameMenu()
  end

  local button = CreateGameMenuButton()
  button:SetScript('OnClick', ClickGameMenu)
  GameMenuFrame.MerfinUI = button

  SkinGameMenuButton(button)
end

function MUI:PLAYER_ENTERING_WORLD(_, isInitial, isReload) end

function MUI:RegisterEvents()
  MUI:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function MUI:Toggles(msg)
  msg = strtrim(msg or ''):lower()

  if msg == '' or msg == 'install' then
    PI:Queue(Private.InstallerData)
  elseif msg == 'config' then
    Private.OpenOptions()
  end
end

function MUI:RegisterCommands()
  self:RegisterChatCommand('merfin', 'Toggles')
  self:RegisterChatCommand('merfinui', 'Toggles')
  self:RegisterChatCommand('mui', 'Toggles')
end

local Initialize = function()
  Private.EnsureDefaults()

  if E.private.MUI.install_version == nil then
    PI:Queue(Private.InstallerData)
  end

  EP:RegisterPlugin(addonName, Private.OptionsTable)
  MUI:RegisterCommands()
  SetupGameMenuButton()

  -- import buttons
  if Private.ShowEditModeImportButtons() then
    Private.CreateEditModeImportButtons()
    Private.CreateEditModeImportArrow()
  end
  if Private.ShowCooldownManagerImportButtons() then
    Private.CreateCooldownManagerButtons()
  end
end

local loader = CreateFrame('Frame')
loader:RegisterEvent('ADDON_LOADED')
loader:SetScript('OnEvent', function(self, _, loadedAddon)
  if loadedAddon ~= addonName then
    return
  end

  self:UnregisterEvent('ADDON_LOADED')
  E:RegisterModule(addonName, Initialize)
end)
