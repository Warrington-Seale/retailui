local addonName, Private = ...
local L = Private.L
local merfinUI = Private.MerfinProfileName

local DisableAddOn = DisableAddOn or C_AddOns.DisableAddOn

local E, _, V, P, G = unpack(ElvUI)

local OnBoss = function(merfinUI) end

local CreateEmptyTable = function(tableName)
  BigWigs3DB['namespaces'][tableName] = BigWigs3DB['namespaces'][tableName] or {}
  BigWigs3DB['namespaces'][tableName]['profiles'] = BigWigs3DB['namespaces'][tableName]['profiles'] or {}
  BigWigs3DB['namespaces'][tableName]['profiles'][merfinUI] = {}
  return BigWigs3DB['namespaces'][tableName]['profiles'][merfinUI]
end

function Private.ImportBigWigs()
  if not E:IsAddOnEnabled('BigWigs') then
    Private:Print(string.format(L['You need to enable %s.'], 'BigWigs'))
    return
  end

  if E:IsAddOnEnabled('DBM-Core') then
    DisableAddOn('DBM-Core')
  end

  local merfinUI = Private.MerfinProfileName

  BigWigs3DB = BigWigs3DB or {}
  BigWigs3DB['namespaces'] = BigWigs3DB['namespaces'] or {}

  local pluginBars = CreateEmptyTable('BigWigs_Plugins_Bars')
  pluginBars['emphasizeRestart'] = false
  pluginBars['fill'] = true
  pluginBars['growup'] = true
  pluginBars['emphasizeGrowup'] = true
  pluginBars['texture'] = Private.GetProfileTexture()
  pluginBars['barStyle'] = 'ElvUI'
  pluginBars['fontName'] = Private.GetProfileFont('Bolt')
  pluginBars['emphasizeTime'] = 10
  pluginBars['outline'] = 'OUTLINE'
  pluginBars['visibleBarLimit'] = 5
  pluginBars['visibleBarLimitEmph'] = 4

  local pluginCountdown = CreateEmptyTable('BigWigs_Plugins_Countdown')
  pluginCountdown['outline'] = 'OUTLINE'
  pluginCountdown['voice'] = 'English: Amy'
  pluginCountdown['position'] = { 'CENTER', 'CENTER', nil, 0 }
  pluginCountdown['fontName'] = Private.Font

  local pluginAltPower = CreateEmptyTable('BigWigs_Plugins_AltPower')
  pluginAltPower['fontName'] = Private.Font
  pluginAltPower['position'] = { 'BOTTOMRIGHT', 'BOTTOMRIGHT', -315, 327 }

  local pluginInfobox = CreateEmptyTable('BigWigs_Plugins_InfoBox')

  local pluginProximity = CreateEmptyTable('BigWigs_Plugins_Proximity')
  pluginProximity['fontName'] = Private.Font
  pluginProximity['lock'] = false

  local pluginMessages = CreateEmptyTable('BigWigs_Plugins_Messages')
  pluginMessages['outline'] = 'OUTLINE'
  pluginMessages['emphFontName'] = Private.Font
  pluginMessages['emphPosition'] = { 'TOP', 'TOP', nil, -206 }
  pluginMessages['fontName'] = Private.Font
  pluginMessages['emphOutline'] = 'OUTLINE'
  pluginMessages['growUpwards'] = true

  local pluginColors = CreateEmptyTable('BigWigs_Plugins_Colors')
  pluginColors['barTextShadow'] = {
    ['BigWigs_Plugins_Colors'] = {
      ['default'] = { 1, 1, nil, 0 },
    },
  }
  pluginColors['barColor'] = {
    ['BigWigs_Plugins_Colors'] = {
      ['default'] = { 0.1294117718935013, 0.5882353186607361, 0.9529412388801575 },
    },
  }
  pluginColors['barBackground'] = {
    ['BigWigs_Plugins_Colors'] = {
      ['default'] = { 0.2000000178813934, 0.2000000178813934, 0.2000000178813934, 0.7019608020782471 },
    },
  }
  pluginColors['barEmphasized'] = {
    ['BigWigs_Plugins_Colors'] = {
      ['default'] = { nil, 0.5960784554481506 },
    },
  }

  local pluginNameplates = CreateEmptyTable('BigWigs_Plugins_Nameplates')
  pluginNameplates['iconFontName'] = 'Merfin Font 1'
  pluginNameplates['iconFontSize'] = 8
  pluginNameplates['iconHeight'] = 20
  pluginNameplates['iconExpireGlowType'] = 'proc'
  pluginNameplates['iconZoom'] = 0.3
  pluginNameplates['iconWidth'] = 20
  pluginNameplates['iconOffsetX'] = -3

  BigWigs3DB['namespaces']['BigWigs_Plugins_Pull'] = BigWigs3DB['namespaces']['BigWigs_Plugins_Pull'] or {}
  BigWigs3DB['namespaces']['BigWigs_Plugins_Pull']['profiles'] = BigWigs3DB['namespaces']['BigWigs_Plugins_Pull']['profiles'] or {}
  BigWigs3DB['namespaces']['BigWigs_Plugins_Pull']['profiles'][merfinUI] = {
    ['voice'] = 'English: Amy',
  }

  if Private.GetProfileResolution() == 'QUAD_HD' then
    pluginCountdown['fontSize'] = 47

    pluginAltPower['fontSize'] = 14

    pluginInfobox['posx'] = 197
    pluginInfobox['posy'] = 512

    pluginProximity['fontSize'] = 16
    pluginProximity['width'] = 120
    pluginProximity['height'] = 101
    pluginProximity['posx'] = 716
    pluginProximity['posy'] = 443

    pluginMessages['fontSize'] = 15
    pluginMessages['emphFontSize'] = 37
    pluginMessages['emphPosition'] = { 'TOP', 'TOP', nil, -208 }
    pluginMessages['normalPosition'] = { 'TOP', nil, nil, -190 }

    pluginBars['normalHeight'] = 23
    pluginBars['normalWidth'] = 200
    pluginBars['expHeight'] = 25
    pluginBars['expWidth'] = 229
    pluginBars['fontSize'] = 13
    pluginBars['fontSizeEmph'] = 14
    pluginBars['normalPosition'] = { 'BOTTOMLEFT', 'TOPLEFT', 25, 75, 'ElvUF_TargetTarget' }
    pluginBars['expPosition'] = { 'BOTTOMLEFT', 'TOPLEFT', 29, 75, 'ElvUF_Target' }
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    pluginCountdown['fontSize'] = 47

    pluginAltPower['fontSize'] = 14

    pluginInfobox['posx'] = 197
    pluginInfobox['posy'] = 512

    pluginProximity['fontSize'] = 16
    pluginProximity['width'] = 120
    pluginProximity['height'] = 101
    pluginProximity['posx'] = 716
    pluginProximity['posy'] = 443

    pluginMessages['fontSize'] = 15
    pluginMessages['emphFontSize'] = 37
    pluginMessages['emphPosition'] = { 'TOP', 'TOP', nil, -208 }
    pluginMessages['normalPosition'] = { 'TOP', nil, nil, -190 }

    pluginBars['normalHeight'] = 20
    pluginBars['normalWidth'] = 170
    pluginBars['expHeight'] = 20
    pluginBars['expWidth'] = 190
    pluginBars['fontSize'] = 12
    pluginBars['fontSizeEmph'] = 12
    pluginBars['normalPosition'] = { 'BOTTOMLEFT', 'TOPLEFT', 25, 75, 'ElvUF_TargetTarget' }
    pluginBars['expPosition'] = { 'BOTTOMRIGHT', 'TOPRIGHT', -1, 75, 'ElvUF_Target' }
  end

  BigWigs3DB['profileKeys'] = BigWigs3DB['profileKeys'] or {}
  BigWigs3DB['profileKeys'][Private.AceProfileName] = merfinUI

  OnBoss(merfinUI)

  Private:PluginInstallStepComplete('BigWigs')
end
