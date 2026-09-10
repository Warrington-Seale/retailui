local addonName, Private = ...
local L = Private.L
local E = unpack(ElvUI)
local PluginInstaller = E:GetModule('PluginInstaller')
local linksMediaPath = 'Interface\\AddOns\\' .. addonName .. '\\Media\\Icons\\Links\\'
local linksWidgetData = {
  socials = {
    heading = L['Socials'],
    links = {
      {
        name = 'Discord',
        icon = linksMediaPath .. 'discord',
        url = 'https://discord.gg/merfin',
      },
      {
        name = 'Patreon',
        badge = L['SUB CONTENT'],
        badgeFontSize = 9,
        icon = linksMediaPath .. 'patreon',
        url = 'https://patreon.com/MerfinUI',
      },
      {
        name = 'Twitch',
        icon = linksMediaPath .. 'twitch',
        url = 'https://twitch.tv/merfin',
      },
      {
        name = 'Boosty',
        badge = L['SUB CONTENT'],
        badgeFontSize = 9,
        icon = linksMediaPath .. 'boosty',
        url = 'https://boosty.to/merfin',
      },
    },
  },
  addons = {
    heading = L['AddOns'],
    links = {
      {
        name = 'MerfinUI',
        badge = L['SUB CONTENT'],
        icon = linksMediaPath .. 'merfinui',
        url = 'https://discord.gg/merfin',
        spinOnHover = true,
        spinInterval = 3,
      },
      {
        name = 'MerfinPlus',
        icon = linksMediaPath .. 'merfinui',
        url = 'https://www.curseforge.com/wow/addons/merfinplus',
        spinOnHover = true,
        spinInterval = 3,
      },
    },
  },
  weakAuras = {
    heading = 'WeakAuras',
    title = L['WeakAuras Package'],
    description = L['Class Auras, General Auras, Raid Packs, and more.'],
    badge = L['SUB CONTENT'],
    icon = linksMediaPath .. 'weakauras',
  },
}

local function ReloadRequired()
  E:StaticPopup_Show('MUI_RELOAD')
end

function Private.OptionsTable()
  local ACH = E.Libs.ACH
  local hasEditModeImports = E.Retail or E.Mists or E.Wrath or E.TBC or E.Classic
  local hasCellHealerVariants = E.Retail or E.Mists or E.Wrath or E.TBC or E.Classic

  -- Main Options
  Private.Options = ACH:Group(Private.Name, nil, 20)
  local root = Private.Options.args

  -- Install Section
  root.install = ACH:Group('', nil, 1, nil, function(info)
    return E.private.MUI.general[info[#info]]
  end, function(info, value)
    E.private.MUI.general[info[#info]] = value
  end)
  root.install.inline = true
  local install = root.install.args
  -- Manual Install
  install.installer = ACH:Execute(L['UI Install'], L['Re-run the installation process.'], 2, function()
    PluginInstaller:Queue(Private.InstallerData)
    E:ToggleOptions()
  end)
  -- Quick Install
  install.quickInstall = ACH:Execute(L['UI Quick Install'], L['Re quick installation process.'], 3, function()
    PluginInstaller:Queue(Private.InstallerQuick)
    E:ToggleOptions()
  end)

  -- Profile Settings
  root.settings = ACH:Group(L['Installation Settings'], nil, 2, nil, function(info)
    return E.private.MUI.general.profileSettings[info[#info]]
  end, function(info, value)
    E.private.MUI.general.profileSettings[info[#info]] = value
  end)
  local settings = root.settings.args
  settings.header = ACH:Header(L['Installation Settings'], 1)
  -- Media (Group)
  settings.media = ACH:Group('', nil, 3, nil, function(info)
    return E.private.MUI.general.profileSettings.media[info[#info]]
  end, function(info, value)
    E.private.MUI.general.profileSettings.media[info[#info]] = value
  end)
  settings.media.inline = true
  settings.media.args.resolution = ACH:Select(L['Preferable Resolution'], nil, 1, Private.resolutions)
  settings.media.args.texture = ACH:SharedMediaStatusbar(L['Default Texture'], L['The texture that the core of the UI will use.'], 2)
  -- Edit Mode
  settings.editmode = ACH:Group(L['Edit Mode'], nil, 4.1, nil, function(info)
    return E.private.MUI.general.profileSettings.editmode[info[#info]]
  end, function(info, value)
    E.private.MUI.general.profileSettings.editmode[info[#info]] = value
    ReloadRequired()
  end, nil, not hasEditModeImports)
  settings.editmode.inline = true
  settings.editmode.args.show = ACH:Toggle(L['Show Import Buttons'], L['Shows import buttons next to the Edit Mode import window.'], 1)
  -- Cooldown Manager
  settings.cooldownManager = ACH:Group(L['Cooldown Manager'], nil, 4.2, nil, function(info)
    return E.private.MUI.general.profileSettings.cooldownManager[info[#info]]
  end, function(info, value)
    E.private.MUI.general.profileSettings.cooldownManager[info[#info]] = value
    ReloadRequired()
  end, nil, not E.Retail)
  settings.cooldownManager.inline = true
  settings.cooldownManager.args.show = ACH:Toggle(L['Show Import Buttons'], L['Shows import buttons next to the Cooldown Manager import window.'], 1)
  -- Game Menu
  settings.gameMenu = ACH:Group(L['Game Menu'], nil, 4.3, nil, function(info)
    return E.private.MUI.general.profileSettings.gameMenu[info[#info]]
  end, function(info, value)
    E.private.MUI.general.profileSettings.gameMenu[info[#info]] = value
    ReloadRequired()
  end)
  settings.gameMenu.inline = true
  settings.gameMenu.args.show = ACH:Toggle(L['Show MerfinUI Button'], L['Shows the MerfinUI button in the Game Menu.'], 1)
  -- Ignore Modules (Group)
  settings.blacklist = ACH:Group(L['Ignore Modules'], nil, 7, nil, function(info)
    return E.private.MUI.general.profileSettings.blacklist[info[#info]]
  end, function(info, value)
    E.private.MUI.general.profileSettings.blacklist[info[#info]] = value
  end)
  settings.blacklist.inline = true
  settings.blacklist.args.movers = ACH:Toggle(L['Movers'], nil, 1)
  settings.blacklist.args.actionBars = ACH:Toggle(L['Action Bars'], nil, 2)
  -- Reset to Defaults
  settings.setDefaults = ACH:Execute(L['Reset to Defaults'], L['Set Default MerfinUI settings'], 8, function()
    Private.SetDefaults()
  end)
  -- Set Actual Version
  settings.setActualVersion = ACH:Execute(L['Set Actual Version'], L['Actualize Profile Version'], 9, function()
    Private.SetActualVersion()
  end)

  -- Profiles
  root.profiles = ACH:Group(L['Profiles'], nil, 2, nil)
  local profiles = root.profiles.args
  profiles.header = ACH:Header(L['Profiles'], 1)
  profiles.desc = ACH:Description(L['You can install the profile from this section as an alternative to the installer.'], 2, 'large')
  profiles.spacer1 = ACH:Spacer(3, 'full')

  profiles.accountSettings = ACH:Group(L['Account Settings'], nil, 4)
  profiles.accountSettings.inline = true
  profiles.accountSettings.args.desc = ACH:Description(L['Set important game and addon CVars to recommended values for better visuals, performance, and usability.'], 1, 'medium')
  profiles.accountSettings.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.accountSettings.args.apply = ACH:Execute(L['Load CVars'], nil, 3, function()
    Private.Set_CVars()
  end)

  profiles.chatSettings = ACH:Group(L['Chat Settings'], nil, 5)
  profiles.chatSettings.inline = true
  profiles.chatSettings.args.desc = ACH:Description(L['Set up your chat windows with preconfigured tabs for general, combat log, whispers, and group content.'], 1, 'medium')
  profiles.chatSettings.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.chatSettings.args.apply = ACH:Execute(L['Setup Chat'], nil, 3, function()
    Private.SetupChat()
  end)

  profiles.elvuiProfiles = ACH:Group(L['Profiles (ElvUI)'], nil, 6)
  profiles.elvuiProfiles.inline = true
  profiles.elvuiProfiles.args.desc =
    ACH:Description(L['Apply my ElvUI layouts for DPS/Tank or Healer roles. Includes both horizontal and vertical layouts for party frames.'], 1, 'medium')
  profiles.elvuiProfiles.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.elvuiProfiles.args.dpsTank = ACH:Execute('DPS/Tank', nil, 3, function()
    Private.ImportElvUI('DPS/Tank')
  end)
  profiles.elvuiProfiles.args.healerH = ACH:Execute('Healer-H', nil, 4, function()
    Private.ImportElvUI('Healer-H')
  end)
  profiles.elvuiProfiles.args.healerV = ACH:Execute('Healer-V', nil, 5, function()
    Private.ImportElvUI('Healer-V')
  end)

  profiles.raidFrames = ACH:Group(L['Raid Frames'], nil, 7, nil, nil, nil)
  profiles.raidFrames.inline = true
  profiles.raidFrames.args.desc = ACH:Description(L['Choose between Cell or ElvUI raid frames and apply optimized layouts for raids and dungeons.'], 1, 'medium')
  profiles.raidFrames.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.raidFrames.args.cellDPSTank = ACH:Execute('Cell (DPS/Tank)', nil, 3, function()
    Private.ImportRaidFrames('Cell', 'DPS/Tank')
    Private.ApplyCellColorTheme('DARK')
    ReloadRequired()
  end)
  profiles.raidFrames.args.cellHealer = ACH:Execute('Cell (Healer)', nil, 4, function()
    Private.ImportRaidFrames('Cell', 'Healer')
    Private.ApplyCellColorTheme('DARK')
    ReloadRequired()
  end, nil, nil, nil, nil, nil, nil, hasCellHealerVariants)
  profiles.raidFrames.args.cellHealerH = ACH:Execute('Cell (Healer-H)', nil, 5, function()
    Private.ImportRaidFrames('Cell', 'Healer-H')
    Private.ApplyCellColorTheme('DARK')
    ReloadRequired()
  end, nil, nil, nil, nil, nil, nil, not hasCellHealerVariants)
  profiles.raidFrames.args.cellHealerV = ACH:Execute('Cell (Healer-V)', nil, 6, function()
    Private.ImportRaidFrames('Cell', 'Healer-V')
    Private.ApplyCellColorTheme('DARK')
    ReloadRequired()
  end, nil, nil, nil, nil, nil, nil, not hasCellHealerVariants)
  profiles.raidFrames.args.elvui = ACH:Execute(L['ElvUI Frames'], nil, 7, function()
    Private.ImportRaidFrames('ElvUI')
  end)

  profiles.targetDebuffs = ACH:Group(L['Target Debuffs'], nil, 7.5, nil, nil, nil)
  profiles.targetDebuffs.inline = true
  profiles.targetDebuffs.args.desc = ACH:Description(L['Enable or disable debuffs on the target frame.'], 1, 'medium')
  profiles.targetDebuffs.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.targetDebuffs.args.enable = ACH:Execute(_G.ENABLE, nil, 3, function()
    Private.EnableTargetDebuffs(true)
    ReloadRequired()
  end)
  profiles.targetDebuffs.args.disable = ACH:Execute(_G.DISABLE, nil, 4, function()
    Private.EnableTargetDebuffs(false)
    ReloadRequired()
  end)

  profiles.nameplates = ACH:Group(L['Nameplates (Plater)'], nil, 8)
  profiles.nameplates.inline = true
  profiles.nameplates.args.desc = ACH:Description(L['Apply my Plater profile to improve nameplate visibility, customization, and performance.'], 1, 'medium')
  profiles.nameplates.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.nameplates.args.plater = ACH:Execute('Plater', nil, 3, function()
    Private.ImportPlater()
    ReloadRequired()
  end)

  profiles.details = ACH:Group(L['Damage Meter (Details)'], nil, 9)
  profiles.details.inline = true
  profiles.details.args.desc = ACH:Description(L['Apply a clean and minimalistic Details! profile for tracking damage, healing, and more.'], 1, 'medium')
  profiles.details.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.details.args.detailsButton = ACH:Execute(L['Details'], nil, 3, function()
    Private.ImportDetails('DARK')
  end)

  profiles.colorTheme = ACH:Group(L['Color Theme'], nil, 10)
  profiles.colorTheme.inline = true
  profiles.colorTheme.args.desc = ACH:Description(L['Switch between Normal and Dark color themes for the UI.'], 1, 'medium')
  profiles.colorTheme.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.colorTheme.args.normalTheme = ACH:Execute(L['Normal Theme'], nil, 3, function()
    Private.ChangeTheme('NORMAL')
    ReloadRequired()
  end)
  profiles.colorTheme.args.darkTheme = ACH:Execute(L['Dark Theme'], nil, 4, function()
    Private.ChangeTheme('DARK')
    ReloadRequired()
  end)

  profiles.actionBars = ACH:Group(L['Action Bars Visibility'], nil, 11)
  profiles.actionBars.inline = true
  profiles.actionBars.args.desc = ACH:Description(L['Set your action bars to always show or appear on mouseover.'], 1, 'medium')
  profiles.actionBars.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.actionBars.args.showAlways = ACH:Execute(L['Show Always'], nil, 3, function()
    Private.ActionBarsVisibility(true)
  end)
  profiles.actionBars.args.showMouseover = ACH:Execute(L['Show Mouseover'], nil, 4, function()
    Private.ActionBarsVisibility(false)
  end)

  profiles.senseiClassResourceBar = ACH:Group(L['Sensei Class Resource Bar'], nil, 11.4, nil, nil, nil, nil, not E.Retail)
  profiles.senseiClassResourceBar.inline = true
  profiles.senseiClassResourceBar.args.desc = ACH:Description(L['Profile contains settings for SenseiClassResourceBar.'], 1, 'medium')
  profiles.senseiClassResourceBar.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.senseiClassResourceBar.args.scrbDPSTank = ACH:Execute('SCRB DPS/Tank', nil, 3, function()
    Private.SenseiClassResourceBar('DPS/Tank')
    ReloadRequired()
  end)
  profiles.senseiClassResourceBar.args.scrbHealer = ACH:Execute('SCRB Healer', nil, 4, function()
    Private.SenseiClassResourceBar('Healer')
    ReloadRequired()
  end)

  profiles.cooldownManager = ACH:Group(L['Cooldown Manager'], nil, 11.5, nil, nil, nil, nil, not E.Retail)
  profiles.cooldownManager.inline = true
  profiles.cooldownManager.args.desc = ACH:Description(L['Profile contains settings for Cooldown Manager Centered.'], 1, 'medium')
  profiles.cooldownManager.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.cooldownManager.args.cooldownManagerDPSTank = ACH:Execute('CMC DPS/Tank', nil, 3, function()
    Private.CooldownManagerCentered('DPS/Tank')
    ReloadRequired()
  end)
  profiles.cooldownManager.args.cooldownManagerHealer = ACH:Execute('CMC Healer', nil, 4, function()
    Private.CooldownManagerCentered('Healer')
    ReloadRequired()
  end)

  profiles.bossMods = ACH:Group(L['Boss Mods'], nil, 12)
  profiles.bossMods.inline = true
  profiles.bossMods.args.desc = ACH:Description(L['Choose DBM or BigWigs profiles made for raiding. Recommended if not using my Raid Auras.'], 1, 'medium')
  profiles.bossMods.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.bossMods.args.dbmDpsTank = ACH:Execute('DBM DPS/Tank', nil, 3, function()
    Private.ImportDBM('DPS/Tank')
    ReloadRequired()
  end, nil, nil, nil, nil, nil, nil, E.Retail)
  profiles.bossMods.args.dbmHealer = ACH:Execute('DBM Healer', nil, 4, function()
    Private.ImportDBM('Healer')
    ReloadRequired()
  end, nil, nil, nil, nil, nil, nil, E.Retail)
  profiles.bossMods.args.bigWigs = ACH:Execute('BigWigs', nil, 5, function()
    Private.ImportBigWigs()
    ReloadRequired()
  end)

  profiles.falcon = ACH:Group(L['Skyriding Falcon'], nil, 11.5, nil, nil, nil, nil, not E.Retail)
  profiles.falcon.inline = true
  profiles.falcon.args.desc = ACH:Description(L['Profile contains settings for Cooldown Manager Centered.'], 1, 'medium')
  profiles.falcon.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.falcon.args.falconDPSTank = ACH:Execute('Falcon DPS/Tank', nil, 3, function()
    Private.Falcon('DPS/Tank')
    ReloadRequired()
  end)
  profiles.falcon.args.falconHealer = ACH:Execute('Falcon Healer', nil, 4, function()
    Private.Falcon('Healer')
    ReloadRequired()
  end)

  profiles.omnicd = ACH:Group('OmniCD', nil, 13, nil, nil, nil, not E.Retail, E.Retail)
  profiles.omnicd.inline = true
  profiles.omnicd.args.desc = ACH:Description(L['Set up OmniCD to display party cooldowns (defensives, interrupts, raid CDs) with layouts matching your UI.'], 1, 'medium')
  profiles.omnicd.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.omnicd.args.dpsTank = ACH:Execute('DPS/Tank', nil, 3, function()
    Private.ImportOmniCD('DPS/Tank')
    ReloadRequired()
  end)
  profiles.omnicd.args.healerH = ACH:Execute('Healer-H', nil, 4, function()
    Private.ImportOmniCD('Healer-H')
    ReloadRequired()
  end)
  profiles.omnicd.args.healerV = ACH:Execute('Healer-V', nil, 5, function()
    Private.ImportOmniCD('Healer-V')
    ReloadRequired()
  end)

  profiles.combatText = ACH:Group(L['Combat Text'], nil, 14)
  profiles.combatText.inline = true
  profiles.combatText.args.desc = ACH:Description(L['Choose Blizzard default combat text or xCT profiles for more compact and customizable numbers.'], 1, 'medium')
  profiles.combatText.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.combatText.args.blizzard = ACH:Execute('Blizzard', nil, 3, function()
    Private.Import_xCT('Blizzard')
    ReloadRequired()
  end)
  profiles.combatText.args.xctDps = ACH:Execute('xCT DPS', nil, 4, function()
    Private.Import_xCT('DPS')
    ReloadRequired()
  end, nil, nil, nil, nil, nil, E.Classic, E.Retail)
  profiles.combatText.args.xctTank = ACH:Execute('xCT Tank', nil, 4, function()
    Private.Import_xCT('Tank')
    ReloadRequired()
  end, nil, nil, nil, nil, nil, E.Classic, E.Retail)
  profiles.combatText.args.xctHealer = ACH:Execute('xCT Healer', nil, 5, function()
    Private.Import_xCT('Healer')
    ReloadRequired()
  end, nil, nil, nil, nil, nil, E.Classic, E.Retail)

  profiles.mrt = ACH:Group(L['Method Raid Tools'], nil, 15)
  profiles.mrt.inline = true
  profiles.mrt.args.desc = ACH:Description(L['Apply my MRT profile with raid cooldowns and notes preconfigured.'], 1, 'medium')
  profiles.mrt.args.spacer1 = ACH:Spacer(2, 'full')
  profiles.mrt.args.mrtButton = ACH:Execute('MethodRaidTools', nil, 3, function()
    Private.ImportMRT()
  end)

  -- Layout Settings
  root.layout = ACH:Group(L['Color Theme'], nil, 3, nil)
  local layout = root.layout.args
  layout.header = ACH:Header(L['Color Theme'], 1)
  layout.desc = ACH:Description(
    L['Click on the button below to set color theme of ElvUI unit frames.\n- Normal Theme would enable class colorized frames;\n- Dark Theme would darken them and put Unit Names texts class colorized'],
    2,
    'medium'
  )
  layout.spacer1 = ACH:Spacer(3, 'full')
  layout.darkColor = ACH:Color(L['Main'], nil, 4, true, nil, function()
    local c = E.private.MUI.general.layout.dark.color
    return c.r, c.g, c.b, c.a
  end, function(_, r, g, b, a)
    local c = E.private.MUI.general.layout.dark.color
    c.r, c.g, c.b, c.a = r, g, b, a
  end)
  layout.darkColorBackdrop = ACH:Color(L['Backdrop'], nil, 5, true, nil, function()
    local c = E.private.MUI.general.layout.dark.backdrop
    return c.r, c.g, c.b, c.a
  end, function(_, r, g, b, a)
    local c = E.private.MUI.general.layout.dark.backdrop
    c.r, c.g, c.b, c.a = r, g, b, a
  end)
  layout.darkColorDeadge = ACH:Color(L['Dead'], nil, 6, true, nil, function()
    local c = E.private.MUI.general.layout.dark.dead
    return c.r, c.g, c.b, c.a
  end, function(_, r, g, b, a)
    local c = E.private.MUI.general.layout.dark.dead
    c.r, c.g, c.b, c.a = r, g, b, a
  end)
  layout.spacer2 = ACH:Spacer(7, 'full')
  layout.setNormalTheme = ACH:Execute(L['Normal Theme'], nil, 8, function()
    Private.ChangeTheme('NORMAL')
    ReloadRequired()
  end)
  layout.setDarkTheme = ACH:Execute(L['Dark Theme'], nil, 9, function()
    Private.ChangeTheme('DARK')
    ReloadRequired()
  end)
  layout.spacer3 = ACH:Spacer(10, 'full')
  layout.setDefaults = ACH:Execute(L['Reset to Defaults'], nil, 11, function()
    Private.SetDefaultLayout()
  end)

  -- Links
  root.links = ACH:Group(L['Links'], nil, 4)
  local links = root.links.args
  Private.RegisterLinksWidget(linksWidgetData)
  links.content = {
    type = 'description',
    name = '',
    order = 1,
    width = 'full',
    dialogControl = 'MerfinUILinks',
  }

  E.Options.args.MUI = Private.Options
end
