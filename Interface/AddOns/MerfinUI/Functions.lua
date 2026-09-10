local addonName, Private = ...
MUI = _G.MUI or {}
local L = Private.L
local E, _, V, P, G = unpack(ElvUI)
local AB = E:GetModule('ActionBars')
local UF = E:GetModule('UnitFrames')
local LSM = LibStub:GetLibrary('LibSharedMedia-3.0')

local individualUnits = { 'player', 'pet', 'pettarget', 'target', 'targettarget', 'targettargettarget', 'focus', 'focustarget' }
local groupUnits = { 'party', 'raid1', 'raid2', 'raid3' }
local customTexts = { 'UnitHealth', 'UnitName', 'UnitPower', 'DeadGhostStatus', 'OfflineStatus' }

local function GetProfileMediaSettings()
  if Private.EnsureDefaults then
    Private.EnsureDefaults()
  end

  local mui = E.private and E.private.MUI
  local general = mui and mui.general
  local profileSettings = general and general.profileSettings
  return (profileSettings and profileSettings.media) or {}
end

-- @returns mouseover, showGrid bool
function Private.GetActionBarsSettings()
  local mouseover = E.private.MUI.general.profileSettings.actionbars.showMouseover
  local showGrid = E.private.MUI.general.profileSettings.actionbars.showGrid
  return mouseover, showGrid
end

-- @returns preferable resolution (default otherwise)
function Private.GetProfileResolution()
  local profileResolution = GetProfileMediaSettings().resolution
  return profileResolution or Private.Resolution
end
MUI.GetProfileResolution = Private.GetProfileResolution

function Private.GetLayoutProfileName(layout)
  local resolution = Private.GetProfileResolution() == 'QUAD_HD' and 'QUAD' or 'FHD'
  return 'MerfinUI ' .. layout .. ' ' .. resolution .. ' v' .. Private.Version
end

-- @returns main db font (default otherwise)
function Private.GetProfileFont(style)
  local profileFont = GetProfileMediaSettings().font
  if profileFont == 'SFUIDisplayCondensed-Semibold' and style == 'bold' then
    return 'SFUIDisplayCondensed-Bold'
  end
  return profileFont or Private.Font
end

-- @returns main db font for numbers (default otherwise)
function Private.GetProfileNumberFont()
  local profileFont = GetProfileMediaSettings().fontNumbers
  return profileFont or Private.Font
end

-- @returns main db texture (default otherwise)
function Private.GetProfileTexture()
  local profileTexture = GetProfileMediaSettings().texture
  return profileTexture or Private.Texture
end

-- @returns dark main color, dark backdrop color
function Private.GetDarkThemeColors()
  local color = E.private.MUI.general.layout.dark.color
  local backdropColor = E.private.MUI.general.layout.dark.backdrop
  local dead = E.private.MUI.general.layout.dark.dead
  return color, backdropColor, dead
end

-- @returns path for media file
function Private.GetMediaPath(mediaType, key)
  local hashTable = LSM:HashTable(mediaType)
  if not hashTable then
    return ''
  end
  return hashTable[key]
end

-- @returns player cast bar isEnabled
function Private.GetPlayerCastBar()
  return E.private.MUI.general.profileSettings.unitframes.playerCastBar
end

-- @returns dark main color, dark backdrop color
function Private.GetBlacklist(info)
  return E.private.MUI.general.profileSettings.blacklist[info]
end

function Private.ActionBarsSettings()
  local mouseover, showGrid = Private.GetActionBarsSettings()

  for i = 1, 6 do
    E.db.actionbar['bar' .. i].mouseover = mouseover
    E.db.actionbar['bar' .. i].showGrid = showGrid
  end

  E.db.general.totems = E.db.general.totems or {}

  E.db.actionbar.barPet.mouseover = mouseover
  E.db.actionbar.microbar.mouseover = mouseover
  E.db.actionbar.stanceBar.mouseover = mouseover
  E.db.general.totems.mouseover = mouseover

  E.db.actionbar.barPet.showGrid = showGrid
  E.db.actionbar.microbar.showGrid = showGrid
  E.db.actionbar.stanceBar.showGrid = showGrid
  E.db.general.totems.showGrid = showGrid

  E:UpdateActionBars()
end

function Private.ActionBarsVisibility(isAlways)
  local mouseover = not isAlways

  E.private.MUI.general.profileSettings.actionbars.showMouseover = mouseover

  for i = 1, 6 do
    E.db.actionbar['bar' .. i].mouseover = mouseover
  end

  E.db.general.totems = E.db.general.totems or {}

  E.db.actionbar.barPet.mouseover = mouseover
  E.db.actionbar.microbar.mouseover = mouseover
  E.db.actionbar.stanceBar.mouseover = mouseover
  E.db.general.totems.mouseover = mouseover

  E:UpdateActionBars()
end

function Private.ChangeTheme(theme)
  if theme == 'DARK' then
    for unitFrame in pairs(E.db.unitframe.units) do
      E.db.unitframe.units[unitFrame].colorOverride = 'FORCE_OFF'
    end

    E.db.unitframe.colors.useDeadBackdrop = true
    E.db.unitframe.colors.transparentHealth = true

    local color, backdropColor, dead = Private.GetDarkThemeColors()

    E.db.unitframe.colors.health.b = color.b
    E.db.unitframe.colors.health.g = color.g
    E.db.unitframe.colors.health.r = color.r
    E.db.unitframe.colors.health_backdrop.b = backdropColor.b
    E.db.unitframe.colors.health_backdrop.g = backdropColor.g
    E.db.unitframe.colors.health_backdrop.r = backdropColor.r
    E.db.unitframe.colors.health_backdrop_dead.b = dead.b
    E.db.unitframe.colors.health_backdrop_dead.g = dead.g
    E.db.unitframe.colors.health_backdrop_dead.r = dead.r
    E.db.unitframe.colors.happiness[1].b = 0.24705883860588
    E.db.unitframe.colors.happiness[1].g = 0.24705883860588
    E.db.unitframe.colors.happiness[1].r = 0.55294120311737
    E.db.unitframe.colors.happiness[2].b = 0.27843138575554
    E.db.unitframe.colors.happiness[2].g = 0.50588238239288
    E.db.unitframe.colors.happiness[2].r = 0.52156865596771
    E.db.unitframe.colors.happiness[3].b = 0.21176472306252
    E.db.unitframe.colors.happiness[3].g = 0.36862745881081
    E.db.unitframe.colors.happiness[3].r = 0.21176472306252

    E.db.unitframe.units['party'].customTexts.UnitName.text_format = '[classcolor][name:short]'
    E.db.unitframe.units['raid1'].customTexts.UnitName.text_format = '[classcolor][name:veryshort]'
    E.db.unitframe.units['raid2'].customTexts.UnitName.text_format = '[classcolor][name:veryshort]'
    E.db.unitframe.units['raid3'].customTexts.UnitName.text_format = '[classcolor][name:veryshort]'
    E.db.unitframe.units['boss'].customTexts.UnitName.text_format = '[classcolor][name:long]'

    E.db.unitframe.units['target'].customTexts.UnitName.text_format = '[classcolor][name:long]'
    E.db.unitframe.units['targettarget'].customTexts.UnitName.text_format = '[classcolor][name:medium]'
    E.db.unitframe.units['focus'].customTexts.UnitName.text_format = '[classcolor][name:long]'

    Private.ImportDetails('DARK')

    if E:IsAddOnEnabled('Cell') then
      Private.ApplyCellColorTheme('DARK')
    end

    Private:PluginInstallStepComplete(L['Dark Theme Applied'])
  elseif theme == 'NORMAL' then
    for unitFrame in pairs(E.db.unitframe.units) do
      E.db.unitframe.units[unitFrame].colorOverride = 'FORCE_ON'
    end

    E.db.unitframe.colors.useDeadBackdrop = false
    E.db.unitframe.colors.transparentHealth = false

    E.db.unitframe.colors.health.b = 0.17254901960784
    E.db.unitframe.colors.health.g = 0.17254901960784
    E.db.unitframe.colors.health.r = 0.1921568627451
    E.db.unitframe.colors.health_backdrop.b = 0.12549019607843
    E.db.unitframe.colors.health_backdrop.g = 0.12549019607843
    E.db.unitframe.colors.health_backdrop.r = 0.14901960784314
    E.db.unitframe.colors.health_backdrop_dead.b = 0.46274509803922
    E.db.unitframe.colors.health_backdrop_dead.g = 0.46274509803922
    E.db.unitframe.colors.health_backdrop_dead.r = 0.51764705882353
    E.db.unitframe.colors.happiness[1].b = 0.24705883860588
    E.db.unitframe.colors.happiness[1].g = 0.24705883860588
    E.db.unitframe.colors.happiness[1].r = 0.55294120311737
    E.db.unitframe.colors.happiness[2].b = 0.27843138575554
    E.db.unitframe.colors.happiness[2].g = 0.50588238239288
    E.db.unitframe.colors.happiness[2].r = 0.52156865596771
    E.db.unitframe.colors.happiness[3].b = 0.32941177487373
    E.db.unitframe.colors.happiness[3].g = 0.58823531866074
    E.db.unitframe.colors.happiness[3].r = 0.32941177487373

    E.db.unitframe.units['party'].customTexts.UnitName.text_format = '[name:short]'
    E.db.unitframe.units['raid1'].customTexts.UnitName.text_format = '[name:veryshort]'
    E.db.unitframe.units['raid2'].customTexts.UnitName.text_format = '[name:veryshort]'
    E.db.unitframe.units['raid3'].customTexts.UnitName.text_format = '[name:veryshort]'
    E.db.unitframe.units['boss'].customTexts.UnitName.text_format = '[name:long]'

    E.db.unitframe.units['target'].customTexts.UnitName.text_format = '[name:long]'
    E.db.unitframe.units['targettarget'].customTexts.UnitName.text_format = '[name:medium]'
    E.db.unitframe.units['focus'].customTexts.UnitName.text_format = '[name:long]'

    Private.ImportDetails('NORMAL')

    if E:IsAddOnEnabled('Cell') then
      Private.ApplyCellColorTheme('NORMAL')
    end

    Private:PluginInstallStepComplete(L['Normal Theme Applied'])
  end

  E:UpdateUnitFrames()
end

function Private.SetDefaultLayout()
  E.private.MUI.general.layout.dark.color = { r = 0.1803921568627451, g = 0.1607843137254902, b = 0.1607843137254902, a = 1 }
  E.private.MUI.general.layout.dark.backdrop = { r = 0.5490196078431373, g = 0.4549019607843137, b = 0.4549019607843137, a = 1 }
  E.private.MUI.general.layout.dark.dead = { r = 1, g = 0.25098039215686, b = 0.25098039215686, a = 1 }
end

function Private.SetDefaults()
  Private.EnsureDefaults()

  E.private.MUI.general.profileSettings.media.resolution = Private.Resolution
  E.private.MUI.general.profileSettings.media.font = Private.Font
  E.private.MUI.general.profileSettings.media.texture = Private.Texture
  E.private.MUI.general.profileSettings.editmode.show = true
  E.private.MUI.general.profileSettings.cooldownManager.show = true
  E.private.MUI.general.profileSettings.gameMenu.show = true
  E.private.MUI.general.profileSettings.actionbars.showMouseover = true
  E.private.MUI.general.profileSettings.actionbars.showGrid = false
  E.private.MUI.general.profileSettings.blacklist.movers = false
  E.private.MUI.general.profileSettings.blacklist.actionBars = false
  Private.ActionBarsSettings()
end

function Private.ChangeFontWA() end

function Private.SetActualVersion()
  local Version = C_AddOns and C_AddOns.GetAddOnMetadata(addonName, 'Version') or GetAddOnMetadata(addonName, 'Version')
  E.global.MUI.install_version = Version
  E.private.MUI.install_version = Version
  Private:Print(string.format(L['Profile version was updated to v%s.'], Version))
end

local fontSizeAdd = {
  ['Expressway'] = -1,
}
function Private.SetFontSize(default)
  local font = Private.Font
  local add = fontSizeAdd[font]
  if add then
    return default + add
  end
  return default
end

function Private.EnableTargetDebuffs(val)
  E.db.unitframe.units.target.debuffs.enable = val
end

function Private.ShowEditModeImportButtons()
  return Private.CreateEditModeImportButtons and E.private.MUI.general.profileSettings.editmode.show
end

function Private.ShowCooldownManagerImportButtons()
  return Private.CreateCooldownManagerButtons and E.private.MUI.general.profileSettings.cooldownManager.show
end
