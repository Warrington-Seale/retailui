local addonName, Private = ...
local L = Private.L
local E = unpack(ElvUI)
local SetCVar = SetCVar
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded
local GetBuildInfo = GetBuildInfo
local tonumber = tonumber

local merfinUI = 'MerfinUI v' .. Private.Version

local LoadClassColorsDB = function()
  if not IsAddOnLoaded('!ClassColors') then
    return
  end

  ClassColorsDB = {
    ['DEATHKNIGHT'] = {
      ['b'] = 0.2509803921568627,
      ['colorStr'] = 'ffff3f3f',
      ['g'] = 0.2509803921568627,
      ['r'] = 1,
    },
    ['WARRIOR'] = {
      ['b'] = 0.43,
      ['colorStr'] = 'ffc69b6d',
      ['g'] = 0.61,
      ['r'] = 0.78,
    },
    ['PALADIN'] = {
      ['b'] = 0.73,
      ['colorStr'] = 'fff48cba',
      ['g'] = 0.55,
      ['r'] = 0.96,
    },
    ['MAGE'] = {
      ['b'] = 0.92,
      ['colorStr'] = 'ff3fc6ea',
      ['g'] = 0.78,
      ['r'] = 0.25,
    },
    ['PRIEST'] = {
      ['b'] = 1,
      ['colorStr'] = 'ffffffff',
      ['g'] = 1,
      ['r'] = 1,
    },
    ['SHAMAN'] = {
      ['b'] = 0.8666667342185974,
      ['colorStr'] = 'ff0070dd',
      ['g'] = 0.4392157196998596,
      ['r'] = 0,
    },
    ['WARLOCK'] = {
      ['b'] = 0.93,
      ['colorStr'] = 'ff8787ed',
      ['g'] = 0.53,
      ['r'] = 0.53,
    },
    ['DEMONHUNTER'] = {
      ['b'] = 0.79,
      ['colorStr'] = 'ffa330c9',
      ['g'] = 0.19,
      ['r'] = 0.64,
    },
    ['ROGUE'] = {
      ['b'] = 0.41,
      ['colorStr'] = 'fffff468',
      ['g'] = 0.96,
      ['r'] = 1,
    },
    ['DRUID'] = {
      ['b'] = 0.04,
      ['colorStr'] = 'ffff7c0a',
      ['g'] = 0.49,
      ['r'] = 1,
    },
    ['MONK'] = {
      ['b'] = 0.59,
      ['colorStr'] = 'ff00ff96',
      ['g'] = 1,
      ['r'] = 0,
    },
    ['HUNTER'] = {
      ['b'] = 0.45,
      ['colorStr'] = 'ffaad372',
      ['g'] = 0.83,
      ['r'] = 0.67,
    },
  }
end

local LoadTalentedDB = function()
  if not IsAddOnLoaded('Talented') then
    return
  end

  TalentedDB['profiles'][merfinUI] = TalentedDB['profiles'][merfinUI] or {}
  TalentedDB['profiles'][merfinUI]['offset'] = 55
  TalentedDB['profiles'][merfinUI]['always_edit'] = true
  TalentedDB['profiles'][merfinUI]['framepos'] = {
    ['TalentedFrame'] = {
      ['y'] = 103.4998550415039,
      ['x'] = 408.0003051757813,
      ['anchorTo'] = 'LEFT',
      ['anchor'] = 'LEFT',
    },
  }

  TalentedDB['profileKeys'] = TalentedDB['profileKeys'] or {}
  TalentedDB['profileKeys'][Private.AceProfileName] = merfinUI
end

local LoadTomTomDB = function()
  if not IsAddOnLoaded('TomTom') then
    return
  end

  TomTomDB['profiles'][merfinUI] = TomTomDB['profiles'][merfinUI] or {}

  TomTomDB['profiles'][merfinUI]['arrow'] = TomTomDB['profiles'][merfinUI]['arrow'] or {}
  TomTomDB['profiles'][merfinUI]['arrow']['position'] = {
    'TOP', -- [1]
    nil, -- [2]
    'TOP', -- [3]
    0, -- [4]
    -350, -- [5]
  }

  TomTomDB['profiles'][merfinUI]['block'] = TomTomDB['profiles'][merfinUI]['block'] or {}
  TomTomDB['profiles'][merfinUI]['block']['enable'] = false
  TomTomDB['profiles'][merfinUI]['block']['width'] = 130
  TomTomDB['profiles'][merfinUI]['block']['fontsize'] = 17
  TomTomDB['profiles'][merfinUI]['block']['position'] = {
    'TOP', -- [1]
    nil, -- [2]
    'TOP', -- [3]
    0, -- [4]
    -70, -- [5]
  }
  TomTomDB['profiles'][merfinUI]['block']['height'] = 40

  TomTomDB['profileKeys'] = TomTomDB['profileKeys'] or {}
  TomTomDB['profileKeys'][Private.AceProfileName] = merfinUI
end

local EasyExperienceBar = function()
  if not IsAddOnLoaded('EasyExperienceBar') then
    return
  end
  EasyExperienceDB = EasyExperienceDB or {}
  EasyExperienceDB.global = EasyExperienceDB.global or {}
  local g = EasyExperienceDB.global
  g.resetReload = true
  g.hideXpBar = true
  g.questRestedText = true
  g.bartexture = 'Interface\\Addons\\MerfinPlus\\Media\\statusbar\\MerfinTexture.blp' -- ?Author did something weird
  g.showMaxLevel = false
  g.barHeight = 27
  g.questXpBar = true
  g.fontSize = 16
  g.lockBar = true
  g.font = 'Interface\\AddOns\\MerfinPlus\\Media\\font\\SFUIDisplayCondensed-Semibold.otf' -- ?Author did something weird
  g.showXpHourText = true
  g.fontOutline = 'OUTLINE'
  g.sessionTimeText = true
  g.levelTimeText = true
  g.classColour = false
  g.barWidth = 450
end

local MiniMapButtonButton = function() -- idk why they protected their addon that hard, impossible to set it from the outside
  if not IsAddOnLoaded('MinimapButtonButton') then
    return
  end

  local cmd = SlashCmdList['MinimapButtonButton']
  if not cmd then
    return
  end

  cmd('set direction rightdown')
  cmd('set autohide 0')
  cmd('set hidecompartment false')
  cmd('set buttonsperrow 6')
  if Private.GetProfileResolution() == 'QUAD_HD' then
    cmd('set scale 11')
    cmd('set buttonscale 9')
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    cmd('set scale 9')
    cmd('set buttonscale 9')
  end
end

local function MyusKnowledgePointsTracker()
  if not IsAddOnLoaded('MyusKnowledgePointsTracker') then
    return
  end
  MKPT_Config = MKPT_Config or {}
  MKPT_Config.global = MKPT_Config.global or {}
  local g = MKPT_Config.global
  g.state = g.state or {}
  g.state.firstTimeLoaded = false
  g.position = g.position or {}
  g.position.y = 0
  g.position.x = 4.000000000000000
  g.ui = g.ui or {}
  g.ui.scale = 0.8999999761581421
  g.ui.lockWindow = true
  g.ui.hideInCombat = true
  g.ui.rowBackgroundColor = g.ui.rowBackgroundColor or {}
  g.ui.rowBackgroundColor.a = 0.3999999761581421
  g.ui.backgroundColor = g.ui.backgroundColor or {}
  g.ui.backgroundColor.a = 0
end

local function TooltipRealmInfo()
  if not IsAddOnLoaded('TooltipRealmInfo') then
    return
  end
  TooltipRealmInfoDB = TooltipRealmInfoDB or {}
  local g = TooltipRealmInfoDB
  g.ttGrpFinder = true
  g.frFR_countryflag = true
  g.RAID_countryflag = false
  g.timezone = false
  g.ttPlayer = true
  g.deDE_countryflag = true
  g.INSTANCE_countryflag = false
  g.loadedmessage = false
  g.language = true
  g.BG_countryflag = false
  g.CHANNEL_countryflag = false
  g.type = false
  g.SAY_countryflag = false
  g.communities_countryflag = true
  g.countryflag = 'languageline'
  g.connectedrealms = false
  g.finder_counryflag = true
  g.ptPT_countryflag = true
  g.enGB_countryflag = true
  g.itIT_countryflag = true
  g.WHISPER_countryflag = false
  g.esES_countryflag = true
  g.ruRU_countryflag = true
  g.PARTY_countryflag = false
  g.ttFriends = true
end

local function CityGuide()
  if not IsAddOnLoaded('CityGuide') then
    return
  end

  CityGuideConfig = CityGuideConfig or {}
  local g = CityGuideConfig

  g.labelSize = 1
  g.showMapWidget = true
  g.labelPriority = 'normal'

  g.tutorialRightClicked = true
  g.tutorialMiddleClicked = false
  g.tutorialSeen = true

  g.showFactionPOIs = false
  g.showDecorPOIs = true

  g.displayMode = 'labels'
  g.iconSize = 1
  g.useTooltips = false

  g.filterByProfession = true

  g.enabledCities = g.enabledCities or {}
  g.cityLabelSizes = g.cityLabelSizes or {}
  g.cityIconSizes = g.cityIconSizes or {}
  g.condenseProfessions = g.condenseProfessions or {}
  g.factionPOIsOnly = g.factionPOIsOnly or {}
end

local function SimpleAssistedCombatIcon()
  local addonName = 'SimpleAssistedCombatIcon'

  if not IsAddOnLoaded(addonName) or not SCAIDB then
    return
  end

  SCAIDB.profiles = SCAIDB.profiles or {}
  SCAIDB.profileKeys = SCAIDB.profileKeys or {}

  local profileName = 'MerfinUI (' .. Private.ScreenHeight .. ') v' .. Private.Version

  if SCAIDB.profiles['Default'] then
    SCAIDB.profiles[profileName] = CopyTable(SCAIDB.profiles['Default'])
  else
    SCAIDB.profiles[profileName] = {}
  end

  local profile = SCAIDB.profiles[profileName]

  profile.Keybind = profile.Keybind or {}
  profile.Keybind.fontSize = 17
  profile.Keybind.font = 'Merfin Font 1'

  profile.locked = true
  profile.alpha = 0.9

  if Private.GetProfileResolution() == 'QUAD_HD' then
    profile.iconSize = 47
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    profile.iconSize = 45
  end

  profile.position = profile.position or {}
  profile.position.X = 0
  profile.position.Y = 0
  profile.position.point = 'BOTTOMLEFT'
  profile.position.relativePoint = 'TOPLEFT'
  profile.position.parent = 'ElvUF_Player'
  profile.position.parentFrame = '__other'
  profile.position.strata = 2

  profile.display = profile.display or {}
  profile.display.HideInVehicle = true
  profile.display.ALWAYS = false
  profile.display.HideAsHealer = false

  profile.border = profile.border or {}
  profile.border.thickness = 1

  profile.cooldown = profile.cooldown or {}
  profile.cooldown.HideNumbers = true
  profile.cooldown.chargeCooldown = profile.cooldown.chargeCooldown or {}
  profile.cooldown.chargeCooldown.showSwipe = true
  profile.cooldown.chargeCooldown.showCount = true
  profile.cooldown.chargeCooldown.text = profile.cooldown.chargeCooldown.text or {}
  profile.cooldown.chargeCooldown.text.font = 'Merfin Font 1'

  SCAIDB.profileKeys[Private.AceProfileName] = profileName
end

local function BuffReminders()
  local BR = _G.BuffReminders
  if not IsAddOnLoaded('BuffReminders') or not BR or not BR.ImportProfile then
    return
  end

  local profileString
  local res = Private.GetProfileResolution()
  if res == 'QUAD_HD' then
    profileString =
      '!BR_s0hkZWZhdWx0c7ggUGdsb3dQcm9jRHVyYXRpb24BSGZvbnRGYWNlTU1lcmZpbiBGb250IDFIZ2xvd1NpemUBSGdsb3dUeXBlAVNleHBpcmF0aW9uVGhyZXNob2xkBVgbc2hvd0NvbnN1bWFibGVzV2l0aG91dEl0ZW1z9E5wZXREaXNwbGF5TW9kZUdnZW5lcmljTWdyb3dEaXJlY3Rpb25GQ0VOVEVSVnNob3dDb25zdW1hYmxlVG9vbHRpcHP0SmJvcmRlclNpemUBU2NvbnN1bWFibGVUZXh0U2NhbGUYGVB1c2VGZWxEb21pbmF0aW9u9EhpY29uU2l6ZRgySGljb25ab29tAEh0ZXh0U2l6ZRRYGGZyZWVDb25zdW1hYmxlVmlzaWJpbGl0eaZHZHVuZ2VvbvVIc2NlbmFyaW/1R2hvdXNpbmf0RHJhaWT1SW9wZW5Xb3JsZPRDcHZw9UlpY29uQWxwaGH7P+zMzMzMzM1Sc2hvd0V4cGlyYXRpb25HbG939UtnbG93WE9mZnNldABJaWNvbldpZHRoGDpPcGV0TGFiZWxDbGFzc2VzpEtERUFUSEtOSUdIVPVGSFVOVEVS9UdXQVJMT0NL9URNQUdF9VJmcmVlQ29uc3VtYWJsZU1vZGVIb3ZlcnJpZGVScGV0U3BlY0ljb25PbkhvdmVy9UtnbG93WU9mZnNldABRZ2xvd1Byb2NTdGFydEFuaW30SXBldExhYmVsc/VNZGVsdmVGb29kT25sefVVaGVhbHRoc3RvbmVWaXNpYmlsaXR5SnJlYWR5Q2hlY2tJdGV4dEFscGhhAUdzcGFjaW5nAFVjb25zdW1hYmxlRGlzcGxheU1vZGVJc3ViX2ljb25zSXRleHRDb2xvcoMBAQFUaGlkZUV4cGlyaW5nSW5Db21iYXT1UGJ1ZmZUcmFja2luZ01vZGVIbXlfYnVmZnNMZW5hYmxlZEJ1ZmZzoUtidXJuaW5nUnVzaPRSY2F0ZWdvcnlWaXNpYmlsaXR5p0RzZWxmp0dkdW5nZW9u9U5oaWRlSW5QdlBNYXRjaPVIc2NlbmFyaW/1R2hvdXNpbmf0RHJhaWT1SW9wZW5Xb3JsZPVDcHZw9Upjb25zdW1hYmxlq0dob3VzaW5n9E5oaWRlSW5QdlBNYXRjaPVIc2NlbmFyaW/1UWR1bmdlb25EaWZmaWN1bHR5pkZub3JtYWz0S3RpbWV3YWxraW5n9EZoZXJvaWP0Sm15dGhpY1BsdXP0SGZvbGxvd2Vy9EZteXRoaWP1R2R1bmdlb271R3B2cFR5cGWiQmJn9UVhcmVuYfVSc2NlbmFyaW9EaWZmaWN1bHR5okZkZWx2ZXP1Rm90aGVyc/ROcmFpZERpZmZpY3VsdHmkRm5vcm1hbPVDbGZy9EZteXRoaWP1Rmhlcm9pY/VEcmFpZPVJb3Blbldvcmxk9ENwdnD1RmN1c3RvbYBEcmFpZKhHZHVuZ2VvbvVOaGlkZUluUHZQTWF0Y2j1SHNjZW5hcmlv9Udob3VzaW5n9E5yYWlkRGlmZmljdWx0eaFDbGZy9ERyYWlk9UlvcGVuV29ybGT1Q3B2cPVIcHJlc2VuY2WoR2R1bmdlb271TmhpZGVJblB2UE1hdGNo9UhzY2VuYXJpb/VHaG91c2luZ/ROcmFpZERpZmZpY3VsdHmhQ2xmcvREcmFpZPVJb3Blbldvcmxk9UNwdnD1Q3BldKdHZHVuZ2VvbvVOaGlkZUluUHZQTWF0Y2j0SHNjZW5hcmlv9Udob3VzaW5n9ERyYWlk9UlvcGVuV29ybGT1Q3B2cPVIdGFyZ2V0ZWSnR2R1bmdlb271TmhpZGVJblB2UE1hdGNo9UhzY2VuYXJpb/VHaG91c2luZ/REcmFpZPVJb3Blbldvcmxk9ENwdnD1VHNob3dNaXNzaW5nQ291bnRPbmx59EZsb2NrZWT1TGhpZGVJbkNvbWJhdPRRc2hvd0xvZ2luTWVzc2FnZXP0UGhpZGVXaGlsZVJlc3Rpbmf1UGhpZGVXaGlsZU1vdW50ZWT0VWhpZGVJbkxlZ2FjeUluc3RhbmNlc/RLY3VzdG9tQnVmZnOhS2J1cm5pbmdSdXNop0tvdmVybGF5VGV4dEBPc2hvd1doZW5QcmVzZW509UNrZXlLYnVybmluZ1J1c2hObG9hZENvbmRpdGlvbnOhR2hvdXNpbmf0RWNsYXNzR1dBUkxPQ0tEbmFtZUxCdXJuaW5nIFJ1c2hHc3BlbGxJRBoAAbMoU2hpZGVQZXRXaGlsZU1vdW50ZWT1UW9wdGlvbnNQYW5lbFNjYWxl+z/zMzMzMzMzUGhpZGVBbGxJblZlaGljbGX1VnBldFBhc3NpdmVPbmx5SW5Db21iYXT0T3Nob3dPbmx5SW5Hcm91cPRQY2F0ZWdvcnlTZXR0aW5nc6hEc2VsZqZJY2xpY2thYmxl9Uhwb3NpdGlvbqNBeTg7QXgARXBvaW50RkNFTlRFUlJjbGlja2FibGVIaWdobGlnaHT1SHByaW9yaXR5BFN1c2VDdXN0b21BcHBlYXJhbmNl9EVzcGxpdPRKY29uc3VtYWJsZadLc3ViSWNvblNpZGVGQk9UVE9NSWNsaWNrYWJsZfVIcG9zaXRpb26jQXk4i0F4AEVwb2ludEZDRU5URVJSY2xpY2thYmxlSGlnaGxpZ2h09Uhwcmlvcml0eQZTdXNlQ3VzdG9tQXBwZWFyYW5jZfRFc3BsaXT0RG1haW6hSHBvc2l0aW9uokF5GMhBeABGY3VzdG9tpkljbGlja2FibGX0SHBvc2l0aW9uo0F5OLNBeABFcG9pbnRGQ0VOVEVSUmNsaWNrYWJsZUhpZ2hsaWdodPVIcHJpb3JpdHkHU3VzZUN1c3RvbUFwcGVhcmFuY2X0RXNwbGl09ERyYWlkqUxidWZmVGV4dFNpemUQRXNwbGl09FN1c2VDdXN0b21BcHBlYXJhbmNl9EljbGlja2FibGX1UmNsaWNrYWJsZUhpZ2hsaWdodPVQc2hvd0J1ZmZSZW1pbmRlcvVIcHJpb3JpdHkBSHNob3dUZXh09Uhwb3NpdGlvbqNBeRg8QXgARXBvaW50RkNFTlRFUkhwcmVzZW5jZaZJY2xpY2thYmxl9Uhwb3NpdGlvbqNBeRRBeABFcG9pbnRGQ0VOVEVSUmNsaWNrYWJsZUhpZ2hsaWdodPVIcHJpb3JpdHkCU3VzZUN1c3RvbUFwcGVhcmFuY2X0RXNwbGl09ENwZXSmSWNsaWNrYWJsZfVIcG9zaXRpb26jQXk4Y0F4AEVwb2ludEZDRU5URVJSY2xpY2thYmxlSGlnaGxpZ2h09Uhwcmlvcml0eQVTdXNlQ3VzdG9tQXBwZWFyYW5jZfRFc3BsaXT0SHRhcmdldGVkpkljbGlja2FibGX0SHBvc2l0aW9uo0F5M0F4AEVwb2ludEZDRU5URVJSY2xpY2thYmxlSGlnaGxpZ2h09Uhwcmlvcml0eQNTdXNlQ3VzdG9tQXBwZWFyYW5jZfRFc3BsaXT0'
  elseif res == 'FULL_HD' then
    profileString =
      '!BR_s0hkZWZhdWx0c7gfUGdsb3dQcm9jRHVyYXRpb24BSGZvbnRGYWNlTU1lcmZpbiBGb250IDFYG3Nob3dDb25zdW1hYmxlc1dpdGhvdXRJdGVtc/RTZXhwaXJhdGlvblRocmVzaG9sZAVIZ2xvd1NpemUBR3NwYWNpbmcATnBldERpc3BsYXlNb2RlR2dlbmVyaWNWc2hvd0NvbnN1bWFibGVUb29sdGlwc/RKYm9yZGVyU2l6ZQFNZ3Jvd0RpcmVjdGlvbkZDRU5URVJQdXNlRmVsRG9taW5hdGlvbvRIaWNvblNpemUYLVNjb25zdW1hYmxlVGV4dFNjYWxlGBlIdGV4dFNpemUUSGljb25ab29tAElpY29uQWxwaGH7P+zMzMzMzM1Sc2hvd0V4cGlyYXRpb25HbG939UtnbG93WE9mZnNldABJcGV0TGFiZWxz9U9wZXRMYWJlbENsYXNzZXOkS0RFQVRIS05JR0hU9UZIVU5URVL1R1dBUkxPQ0v1RE1BR0X1WBhmcmVlQ29uc3VtYWJsZVZpc2liaWxpdHmmR2R1bmdlb271SHNjZW5hcmlv9Udob3VzaW5n9ERyYWlk9UlvcGVuV29ybGT0Q3B2cPVScGV0U3BlY0ljb25PbkhvdmVy9UtnbG93WU9mZnNldABRZ2xvd1Byb2NTdGFydEFuaW30UmZyZWVDb25zdW1hYmxlTW9kZUhvdmVycmlkZU1kZWx2ZUZvb2RPbmx59UhnbG93VHlwZQFVaGVhbHRoc3RvbmVWaXNpYmlsaXR5SnJlYWR5Q2hlY2tJdGV4dEFscGhhAVVjb25zdW1hYmxlRGlzcGxheU1vZGVJc3ViX2ljb25zSXRleHRDb2xvcoMBAQFUaGlkZUV4cGlyaW5nSW5Db21iYXT1UGJ1ZmZUcmFja2luZ01vZGVIbXlfYnVmZnNMZW5hYmxlZEJ1ZmZzoUtidXJuaW5nUnVzaPRSY2F0ZWdvcnlWaXNpYmlsaXR5p0RzZWxmp0dkdW5nZW9u9U5oaWRlSW5QdlBNYXRjaPVIc2NlbmFyaW/1R2hvdXNpbmf0RHJhaWT1SW9wZW5Xb3JsZPVDcHZw9Upjb25zdW1hYmxlq0dob3VzaW5n9E5oaWRlSW5QdlBNYXRjaPVIc2NlbmFyaW/1UWR1bmdlb25EaWZmaWN1bHR5pkZub3JtYWz0S3RpbWV3YWxraW5n9EZoZXJvaWP0Sm15dGhpY1BsdXP0SGZvbGxvd2Vy9EZteXRoaWP1R2R1bmdlb271R3B2cFR5cGWiQmJn9UVhcmVuYfVSc2NlbmFyaW9EaWZmaWN1bHR5okZkZWx2ZXP1Rm90aGVyc/ROcmFpZERpZmZpY3VsdHmkRm5vcm1hbPVDbGZy9EZteXRoaWP1Rmhlcm9pY/VEcmFpZPVJb3Blbldvcmxk9ENwdnD1RmN1c3RvbYBEcmFpZKhHZHVuZ2VvbvVOaGlkZUluUHZQTWF0Y2j1SHNjZW5hcmlv9Udob3VzaW5n9E5yYWlkRGlmZmljdWx0eaFDbGZy9ERyYWlk9UlvcGVuV29ybGT1Q3B2cPVIcHJlc2VuY2WoR2R1bmdlb271TmhpZGVJblB2UE1hdGNo9UhzY2VuYXJpb/VHaG91c2luZ/ROcmFpZERpZmZpY3VsdHmhQ2xmcvREcmFpZPVJb3Blbldvcmxk9UNwdnD1Q3BldKdHZHVuZ2VvbvVOaGlkZUluUHZQTWF0Y2j0SHNjZW5hcmlv9Udob3VzaW5n9ERyYWlk9UlvcGVuV29ybGT1Q3B2cPVIdGFyZ2V0ZWSnR2R1bmdlb271TmhpZGVJblB2UE1hdGNo9UhzY2VuYXJpb/VHaG91c2luZ/REcmFpZPVJb3Blbldvcmxk9ENwdnD1VHNob3dNaXNzaW5nQ291bnRPbmx59EZsb2NrZWT1TGhpZGVJbkNvbWJhdPRRc2hvd0xvZ2luTWVzc2FnZXP0UGhpZGVXaGlsZVJlc3Rpbmf1UGhpZGVXaGlsZU1vdW50ZWT0VWhpZGVJbkxlZ2FjeUluc3RhbmNlc/RLY3VzdG9tQnVmZnOhS2J1cm5pbmdSdXNop0tvdmVybGF5VGV4dEBPc2hvd1doZW5QcmVzZW509UNrZXlLYnVybmluZ1J1c2hObG9hZENvbmRpdGlvbnOhR2hvdXNpbmf0RWNsYXNzR1dBUkxPQ0tEbmFtZUxCdXJuaW5nIFJ1c2hHc3BlbGxJRBoAAbMoU2hpZGVQZXRXaGlsZU1vdW50ZWT1UW9wdGlvbnNQYW5lbFNjYWxl+z/zMzMzMzMzUGhpZGVBbGxJblZlaGljbGX1VnBldFBhc3NpdmVPbmx5SW5Db21iYXT0T3Nob3dPbmx5SW5Hcm91cPRQY2F0ZWdvcnlTZXR0aW5nc6hEc2VsZqZJY2xpY2thYmxl9Uhwb3NpdGlvbqNBeTg7QXgARXBvaW50RkNFTlRFUlJjbGlja2FibGVIaWdobGlnaHT1SHByaW9yaXR5BFN1c2VDdXN0b21BcHBlYXJhbmNl9EVzcGxpdPRKY29uc3VtYWJsZadLc3ViSWNvblNpZGVGQk9UVE9NSWNsaWNrYWJsZfVIcG9zaXRpb26jQXk4i0F4AEVwb2ludEZDRU5URVJSY2xpY2thYmxlSGlnaGxpZ2h09Uhwcmlvcml0eQZTdXNlQ3VzdG9tQXBwZWFyYW5jZfRFc3BsaXT0RG1haW6hSHBvc2l0aW9uokF5GQFUQXgARmN1c3RvbaZJY2xpY2thYmxl9Ehwb3NpdGlvbqNBeTizQXgARXBvaW50RkNFTlRFUlJjbGlja2FibGVIaWdobGlnaHT1SHByaW9yaXR5B1N1c2VDdXN0b21BcHBlYXJhbmNl9EVzcGxpdPREcmFpZKlMYnVmZlRleHRTaXplEEVzcGxpdPRTdXNlQ3VzdG9tQXBwZWFyYW5jZfRJY2xpY2thYmxl9VJjbGlja2FibGVIaWdobGlnaHT1UHNob3dCdWZmUmVtaW5kZXL1SHByaW9yaXR5AUhzaG93VGV4dPVIcG9zaXRpb26jQXkYPEF4AEVwb2ludEZDRU5URVJIcHJlc2VuY2WmSWNsaWNrYWJsZfVIcG9zaXRpb26jQXkUQXgARXBvaW50RkNFTlRFUlJjbGlja2FibGVIaWdobGlnaHT1SHByaW9yaXR5AlN1c2VDdXN0b21BcHBlYXJhbmNl9EVzcGxpdPRDcGV0pkljbGlja2FibGX1SHBvc2l0aW9uo0F5OGNBeABFcG9pbnRGQ0VOVEVSUmNsaWNrYWJsZUhpZ2hsaWdodPVIcHJpb3JpdHkFU3VzZUN1c3RvbUFwcGVhcmFuY2X0RXNwbGl09Eh0YXJnZXRlZKZJY2xpY2thYmxl9Ehwb3NpdGlvbqNBeTNBeABFcG9pbnRGQ0VOVEVSUmNsaWNrYWJsZUhpZ2hsaWdodPVIcHJpb3JpdHkDU3VzZUN1c3RvbUFwcGVhcmFuY2X0RXNwbGl09A=='
  end
  BR:ImportProfile(profileString, Private.MerfinProfileName)
end

local function ExwindTools()
  local EX = _G.ExwindTools
  if not IsAddOnLoaded('ExwindTools') or not EX or not EX.Export then
    return
  end

  local profileString
  local res = Private.GetProfileResolution()
  if res == 'QUAD_HD' then
    profileString =
      '!EX1!vQvdWrXXvAnAG4ZeCy1Ypg7ag5FGYChg0Qv)aKZbVR(zLSri8kzdeBhnZSBlnty0mtMzwqYLV6azalW)awbdgmbBVwa2ogS9gSdy(ZrNTZTxQKRZEo(uQkvCkvAxjDvUlv05l3v1LQ4ED3ZS7Sac7JIfMP7x)6V3RF9796xpCljC3iBXdewt3gzuwCfRy6MXxExDTIUrMDQOnKy846ApmY0srxlZwQSMLx1Yda)T2kdMb1JHUPD7kDJAZ20WxLvuzn3tfvDpbQU8avU6GvkjMWww3uQfkJgbPjkPII3IE8eQiR(V1jBON211vTwEOe26Ht0RSXT0qp1PkAzT8WMOT2TOLnYSnBXU6czkB4ZL6i6wwkgnxVSHF3MAZaPQ(GjqjqYgL52ylkAk0NKnMDd90YFtZADQV8Oj0AsXYw3eMT5sAD5nRbZIzcd72nfJTzKPaPDh2ABIebTa9nHjPK3sV2YkXQdWMGXCYZ2wQV9MJPR1KU(MPi1P52rQOwS6s2y(Uc260BrFlO22SIQAivKPTSX8CNT1Rk2lYC96wk2GMMcAVDakc7IefgsitlvOZJT6f7wSlMIGnNnQhlHfbXYg3CEEUf0dG6fueAicZkc0ab2kgEanv92qNDIIzhs1qwKQ5zDfvuRluDYOyBwOGKuNSOn8ttdPgwew6Mt(oaq0g67NaPfd5P5M1SSfHMwhybkN3QytBQn9eAX9qhaAccxViWy5uDtTJQdOXU6mDQB2TOTJvkFYcgM3TYNRS2ugM6DQOIwhSAMKznw(d2u9MD7AkI)6ngTzBu3wnoF(t9wlX0XuvUVVFcrnBf7E3XmNp)zU1LGxMm(EsdpoV8pEQtXEChZmJgARDOaCPJ4M6gSw5XltivDjafD3u(pd8m7FXJ0zcvIMz9iZyin7Dmtd)OESnfRtxv3mqdS5wyGo11S7Wg65t8lYlzjlgxFRY(L4nzpUrE)DX7VxUWe6KM4CV44NAq)9W530LGnTGsm1tyRQOHmB9HAFTnVUgcBP84OBFO4Kvnt60fUP1CHfUW1C5lhZliQ0beYd5byr5nnmrBrbTvyNQhABx2ezjRRg)HfvtGQmyfv4zuvgz98vS8k9oGaxXacSYk8IOq89bDU12HbiKH1URkXlAaG)F87(8skPKV2iBv0utrRlxQY48Ud3sAdMbMravHr)36qsGZTcIEk)(lVKskpLKOzyg9r5gaEH946NwflV6k90ziAlvNKXK2aDjdRKnHcEOlCbMeHpjHIW0riyswotyII2cSJsXlycX7z8r46ZD8ncR9(LyiHSEB6akfykBTZoTq2BItsgP0LSDeV8lstR59M7Cx0LVC2Kf4lWmMe4xIZFxGPcx0TQe3wEAZkdBOTZGNzGYxVspivNwxpeca0N89rM02uIJcV2gASDN3ECu1EaZgxwj5f9WmO6fvrZRYZtvi(Wg6wB8zkXyoSf7R06OQkYq0A03AvtT3ISjJK38DacrHuv6stQUgwx7ne1y2KwyYTUQQ(wTioJit2Mo)xd2C61iLUuxB1EndJY7LGq8sQ6q4H4cMYefaWPImZcZ5fvH4nMRtVfln3rTfzQdO)TwWca0FPIygOL(JV8lFjyTZlecZxerr4X30XbXifX8cI9zz3C9cdrEPvdsaeiazMUf1siQgkECIJVshc29clrKajiRAmMD30WfDigtmoQ7E7qkrNDopWDLXCC6iM4wqW)KqfCNPr7PmNEaDyhaVILaXAgIZR3geRlMT7EWrKsydbxCJMfnAZrAQ9u5XtZ1xQHpcwdfJ0DykXaJIr9usYhGjeG)YVrNGqg1YafZAgP6svxsuTrW2m(0UfjrfixcK8qSwzgGCMusd18mWZQ)fBmhcVIseBwyXwqq0EHKSwnevGW9ZouDRTJ6talk6AmdfiDJu1P3TKOnngTWanC)obffMK1EdKKgiBwgA8l9sz35XY1)lM7ah0WxlIXm1BqtMenRBW1oefgc3edE3UHEme1irNKZ0IObjowiTyKSJg9mNC0Z80omETiqPdATnTJzouiMwv9(tObrxlZdmBczQRetottutrBBvu7Iqwg(CymPzYJ1lyCZfK0oEiluKekQXdlQTz5riSlQOsCwsdqwpHtOUzilSo2ayKL3QDhFBQUQEyX1gjKFqmai4f0uTXyh)Czp)2yAdVD2ieIIefdhua8GrciGRA6SWx4QX1qcBjXAU2LvcELd1Etnx3d4eZcV6iWYybHhYSqvfbpkmPRUf2qKOBnl)b9U8aAXnYLhXRJKGaK1G77RTXOYfPtDiW0rniKYrzsG(bOqxgcTIRcI6sCwSYvsbo1ZCGa4vIxfE1l9kwe3ixM8Roe1tPfnHokEVqUi1epvfr1ktHAcFcq3KQnyBKdwfUc5hSImMNhlakPillyJGqgs7o4vVlbSVDXeIBpQHUIMnwlJjsv0wHij03d3BRDAXLcYJIy7dXuJlhUhstJ40KSI1gqOnlJlR)BBeYMBwIReFpcdqdPtcelaQ5Ea)NwZAsq3igtMGJnqIcjKHquuKy8EPb)b)kucAxNSG1OjWhzS8FzX47V)5HxlhULMwt6dDiWn5LXRJd3kpE9c4VRrzTb5SzIkVrihRY3GmKpgUnzC7gZ2jVVweH)XjohwGdVjom4VDIdDOpeYLa)GC4hLeLeuY1W01byRbby2TbWOcZ6g4WX5WB0jen0B1mARMrB14hl(nI)olflILWXwkURMwZF4F9ZUpyAY0LP(wRxXer9(jLDFp)ONzpGJlXyG3DoSTtUFAGe)zoMEs8rfjb3WsUBBY4iqeJMYd4VNPtnz4W1YXwixe(BlNHPbDInZboRlQLnn9uSxPlXGNO9K7aN1Omli3zibfeQ(13wJkMWrDMK006nv0nHCHHw5hGGTqmanGP7sM)Og(9sztirWb6nKKLjlz1)tYlo0DsEDaaOV2fucd7leIo4HpTdESMUXC7GbwQLqBi7W9cE0ax1EAnAdQB5HAgB8rZWOSewi6zuOrljgHGdYIAdmcfQecL9DWA99qnVEWOHyMZ9mZe7V)5KrYe94udwVBkLAAn)SdEWx(YxEVu4d2nRAvDC5l)hNcXyP9r4cj7Wo937cMM)E(lbbJutijA4GkGX83bHFm0aMKK3O(hssiFTS8maRGjjPA0Ac7w7KTpfsXe63n1CYIj5D6jGkcK51T3aUAdFnAQ84L)GjeJBkAlwE7T7VNLvsrOCrdyFvYzrlp)8RuUw8qDRlDDM3RPY4EmM7MridIoTvnQlshPYWpj)b4qGqSw3dLk3NkQtMsjL7Cbo0wnS(8Nm852s7OUnaFuOjZ(8VE2x60522Bo2UFJvVyTjDjWvxLIM5tRAH1TSeG9f4FlWPMUp5dSri5Rl30h(9(RB4Zj7OND)leFjb8hEtg(DsfH5bs0SleGeB6)Zm71gYe8k1StoWlnfZgNsW77AK30A(n)MFdW33Z1AH6443Lxb1IFZMwZV6bFqWe6DD8(YoTcBk2LHFniro3cu4Kwk(tW)mW4aKcA2ErDqHW1Gyi)YpCF7dmxZagl4)rESX0MXiUovzNkf8O(3gCaxrzJWI1V(99ShD2xLraZKHTL2IuyG3)AUL(N74qIr(1aBWPV(4x4faSPNF23eNXntzjtF3Sg5ORnspzV)Vn9yuSoemMpOJ6c5sgKMezu0an4UXsxJzlepe1WVtuJmdmamVtsIAaHmEqAaG)9fUqWZ8nJBh)Xe)6BkVFDoMp9AjcdIh)y7)BKpcrHJrrId4XrppEo7AsKke7PfrZnJmjcN)vAmBfxm5P5aq6TzKufJTzvflMf)imBV1T(6iuynJjzVtFHLhbXrgvMjTrtcUalGHbPnp3LqoyqcsnqGykdL7axi3p(fY1)(YUNx2OmBW5oPajTrPa4Or1psUd(kzp7LY(875XYDYxl7rEDYi2)fxmSeS5Yxw5zFQDLDWNA0Z)ktSTTNT)35owmX))DGN3Ua0ZSfiE6T9yl8pH1aJbIDojpgIJGL56VbB8OLGLxKHV4Oykqsx5Z28Mm8zQ3vcuhD2nyCrlIHrz5s9Q5oYUZEH3n3jpw539ITxQrzfiYGK(NE3Uunw)V5ed8guQYexXcCo0lZ(biO)NNrZeh8nPeGV5(9LYKw)k2glihfrdu79AGIwx0wBRnPy5RcqGQtUfflfjfynT3AMKLGlK4EUx8IJn4hi40q2bpGtddn652z2D)25oYBLDx7uiQvmq7qTy8mHWrkJL)yYvwDsAp0f1s9qveogvH4n1DII7P3Wo9gXT3nbNdL5ZRnYXG6)Un(MprSo7SUAxvD10aGYSV2p6jml)EkFIxmvU9mOGXTr6nyWvfS2gZU)bN4K7p7z6Nsq2KhD8lUBbJBNo8Qc0qWq5o55g9dE1jEZNppt67nZT933HMkQO2kQV(X33RN7CV6yh7Kz37zy8zNp5yN(vCMOgBSXQQzL5UWrg)vFMX32oPeK7f27e7FFx)jk7UENjoYreyYYkRDLRSHgYDK32T3Xo4ln(tFCNEBK(NX29jCfKXo2rZEKxZfavTY6chcE3dZDjGcGqbdwrDRcKkqvm2Z8C529tZaWHERX2(jZlf1wxfHYEXFYeP2(ONFpmPy7jZo4Z6GHGnwxTneg2VLhdB)hn2oEhNEdfU(QQniW8r)GpGX83zhzFQZDDwlYT93GUyDTzE2JDmqz4G)Rs5WeLSN84J)27AQur56FGSx8PVoQOCp5Ba04QIUs8pXt9Cz35fY9CNiB)V)1tko7PO6WRN1srQXRgNh(GGBaNEROIgBCvRm3jpE2N8emL85EQjEPlEDwJaCMBBN4lXCn5rZE(p46WKSNQ)cRfx12kcCo0Rpvl0JT)xo7jFXRhZp7pE8x9vNkMp2t3xUTnWuj(JFM9oXR9CtvVtSZbg9Ch6lz7CkyF52MQDz5E7T7DlWvVro7XEQXtEYRJvKRpNR3gTCV3BKDp)OP0u3XpWuIbqfL9Id8LSxEWND0Z9ucKYZp)TKYIw2ku8O6BLh)BRXFVnDFDgRvizWp3FpnDFB9FylLqow4zsgU12BV1wi19mPuxWHpSHOQw9xg(b47tYTsZUpfj)tr5HWYsi1nYhvbYV1UmC7HxhKEBFO4GVEiVXzNClK6csZ3Bec3xD2FYXZ(2NDIlSp8dZJFe(K0Xt7pdRUMRo77Uti0J7ueMh)DhMBJsu(SXzYH7KpjC6Y2yhM8Rdh(nm8Q13JuRWOuMLCXJEMZL9DpkSzGEotALjpon2CXzXtY4dsbcIDV6fkzfdPHSwYafcR5(4GhGDE11sy(XPLLGKcahUQMwZ)zWGq(VxMK87OvvfKH1D6V3P7VNfuIlJdiXU6gUOM6QiRAmRpulHI0quHWThADpGGutneATWB9z1RwmYHneQCZOEhOGaOy5ClkYGakmmNKuUdFAWD6WCX)YePH5qlzyUoHb1f8t(a5rEtR5t)0p93xsj1tG9V8Oh9dlPKD7mwtEsgoREXdZPWpm33RMH52mmwv4x3Wpn4N(WCMdZ99fYdNTDSj22ldWPa)9Gfh(D9WY285Brx(Y)jpJPP187FN3boiX)2xbSy5flJL6ItSTd7GfhvZvHLfnLyHEgMrIgvOKs(MfWYXN38a89R(kGfBVyj7oF9XFYlual))uVqXIts7fWY)6g2aao)FfWsII0lN4CfwJMk9Y1Bnkt0OWz4(PumDV3l84ND12lCtjw2cblyBzj6nf1Lm(wEyA9vAZUxvKZ0iWk1yfvXk)ynb9373YFp8UtWksQI2csn)i8keWMTci5B1x3IgKtkz1VVV4BiLB3Ni3(V0CMHeyxKDW3y0BxccsLBBB3ErszFPJM9h8SF0DibbjN4W7A)lsASx505o0RpT7uk3Pp6yV5lFx3IeKxXehk5G3S04V3Zn2fEZDmFPSNAVzFPlAdpm4Bm(REWpTCPCVZPN4GN5tVdji8e4Q(lagUN(gRVZw1IKM4W7B0lDQrHUG0eE7ZpItk7o1(Fj06bggzzVwISjtRHyBX0nrYjjFKciVslDz4pSGfa2d3avQpVRnXeN9SG78)BQ0Vu8T2jRYqexNO4Rlr3sitlHHItVDG6YNWFfbmktusICDNI2ORfzr4tXUnek4MR3UOz0x7QWFZ(VnNJUrVj71lAlxk(sWPxP3zy(ZNwF(Z)mDJYOL8XZHxRxgpjwd)fFYx1Aki6TMcfQevulceGafxRZbZQw514SWpuXNfUOnDMfya5CXJo3R55Iba8DqSdgJihm()PqjjKxbyZtlJbbAoFWasTq)SpmPl9IMKW0gLPuqDWc1sRpl2yALzmFIcBdYiT1PBNxRPahasa)N5V6rgMjQ)6VI1HmWae7rNVdHRIzrPm7QBpcBs(l5RWb()DkNVBS45dFzAfmgMJJh)FH3fEbKdypKHOPDVpaQxsaW3)AgvR(BKmbaFOH2ax435hDJjnO1F3DqNWD(B6s)PdDyiRMsjRM)IF4pemF(y)9Q(x5VN7HYKc9dlX)HJCei83SalOmuuqCDm1WyfxbkwY5)APC(MbOvPiSfSAbI1cj3Bi(263hP4hSRVREuNIjuTt7ChFTroYmFQTGmTDsLHBeJeQwOwe7stXorCuAsDmyvmjHjQrfvuZ1p)z9w3BkYC4ogJ5qPr3OyYMX03ysk3GtjJINEiDyEil00jfuECtkgFlKlXlUBfehOtX4oudIfhEp9F3)DPp9JK(Vp9GZk9PNv6pc(7JK(tNv6Nm9xmR07m9C8L(U8LUkFPR3x65CxPJ7lTTV07Wx69dV(OPpTV0FKV0FQV0J6l9ZM(xKEVP)Nt)8PhDwP)vPB)Us)dsVJhn9)s629LE7Ph0x6P5l9qKzV1e2maGxu)lEaRav44hcESAhJ7PxXYxvvb6RB3pGb49kcUQ(uDVsBZEzf()rNoTELTY(6qgySZTRC7DVJFXZsU6bxUbzXgZSGD(QYpJm2wtqsbO7wrJCN8SISu6a66ox9pN7CgHh3GaDYAZ5RwjzN063tv19zzwel9q4MwqjU9ciH2oPoR4ZG1C5nmlwMfj54ZI1swGhYUsaDB)QyfoXbRUDfXv4QUiKKxADzTzpoxWSR2nmxgIVN8oVt72bSI4QhIw4XiC4Y7VZ(yXdceLpJZnKZ(2kUbs6VQHPzbRgIpPi9UHj7zGCDF2S77mtCODK0mwhXyEjRCfMXY0f5YCDB5owrxe72WwI9gIhwgLO96uBPOGTUAuY3IKeDtCeAke1YObo3cduvgM9TQ0Xw1nvJZUYUo6fPQkirBX5dZPdykC4tugF6dAHEzvLcBnU3OKY5gLpkzKr5P1OUdNjqMnSqSoJ4u4lABSXZMFkSesYKpA7oimyy(buC(yXcZnerx5k)rxb5TueKKxJy5e9nGBtHxrl1dNFJQ4jwt3BEUb4LOJIWXevwyI89gIVsZyHD1tbJYtuZHHHOBTPk)IzshAihLhvAeCxNJWZyilKGxLrazM6pktlmm3zWRAaIAHjXunu(LpDRnw5JX4eCKs64IWNH(URSz4p7GNy8DC4rpZbg7fEMjs(8tS9FGlGbSXOLYA2clbZc07WWJkeEJM0vhUsUqg3NyJLi40kLc0qOoVGcRPK3DKtQCKFDOxwOJcnyKxZYOFyUp(2P3cqrR2vgHNUDisrgrbLPQMq8d5qvbGfXTTaock1aPiwgI3KH9ycu8gI3WxEjmp(ugIODCFxAfXIxEGkmHTFSLgsN5TgQmkVJzwWc7o3qiWGjIljbcZZm8dtSJcXpaL7mErGyuxChSyR9imDAyoyur5M0vEZBmxF4wCwjaMiGV9)mjxbl61FhQBY1Fv2KkDPrYZLDxbXTMXWC)YnYxZYxf4gDxPyoITj3lyLRT1nmm3pzJtVYkcS8GjzmHSfPzYTLzlq)kJC)iyYW4QdtHn9)uEWX7UmMnByr8E52rP3Uj(o6)wWpaTs6vM3II85EAnV7AP1e2ME5NSuFjxrN8iKNBwZ9ddv2WNKySn3LjnrrwgGKVbJkVQ2dZzmx3s64oA6NcZDTuYxiGmhUnHrqAXiAhKjdbFXtmVHlnsPKmnNT7yBWLKMR)lEI(iFA0KKE(m)f(2mUISgL4tXUWckmUFoscC006kfV6Bh)W0GmyHPJFecWRQAwqq6N9WokhBSSBYOScsItUkrBtxvj(vjIr5UQMIWncLFTOO1e9tb89WFxChJWYH2LsbCNu31vdPtcMppm5(miPjFN9pNH8CkLaLILvNpo2whM7fHJlq)2(CaKuGGvgmqqsLZmwO3XeeSbo0WChEeYjRk0S8ao30DD1l4L8Ak17BvsVUJ4UJXBxvxAFudbY34CkG3RJ(9OaNjYlrvvAYeAKpoV6nf7s2KEbInxFP47QraOKC1gM744DbbhN()3p'
  elseif res == 'FULL_HD' then
    profileString =
      '!EX1!vQvdWrXXvAnAmXNj4WQLFm2bmYoav4oBqRw9dICo4D1pRKncHhjBeX2r7m727ot0ODMmZSGKXxDGm)iW)awbdgmbBVgW)ed2Ed2bm)5OZX52lvURZEuokvLkoLkTRKUk5YfD(Uu1DxDCVU7z2DeGW5CXkpt3V(1FVx)6371VE4wwWEqwIhiycnlKEzrvmJOzeDfXJVYEqgXusmKy0OAjEeKHPIwISBQYAwrvRWh8VAR0FwuV6AgwDO0dQDldDpvwrL1CVvu196R6Y9v5Q9xTKyslzndPwPmAeucrjvu0w1IMufzoWDmzJ92HMMQ5kcK0slyY(K1V9g7TEvrtZve0aT5EenTqgTBjgpoYqw3Jd1H0mnv0BPbzDVon1Uosv9HsIsIK1lZPXwvsOqFswFon2BR)vTKiM2kesMOzftlndy2MhP1v0scywmsQB1HHyKUrgHjTBZwldKiOfOVfEsk5T2NLSsK6bSfwFUfyBRn0rlr0s0SMw3uKA3ChivuRMXL1xGJGToTw12eQ9UvuvdOImSK1NVZSTEvX(qgRxZuXc00uq7UdqrynfrHHeY0sf6cyRbXEeJZueS5SjTijnjiww)2kWZnHEquFGIibIWSPaAGalfDxGMQEBmwmueRaQ6YIunpRlbXeXr1lJI0D4Iss9YIwWVejqQbfHLU5wOdaeTJ(UjrjIGC1CljmTeHMwhybkxWQyJBSDTKjI6Ioa0eeUErGXYP7HAhvpqJv1zJPz0JOLTvkFQIgMFDLpt5FlTUHwmfv06GvZumRXYBQ5gm6XXue)LBkBc0M7sXc1txrn00xMHT1QC)F3KIjSuS6JxOfOxZMwa)PE7LHVhz89U9zTa(ZChSNZapo)cpEQt5qb(EcNU(KGIUh6ONjEwdS0rILuLOzwpYickH12NL(82SOrcLeX7q2azkRPg9revtIU7ARyWyAjS6Yc1R1N4vKxYuwmQ2ML9kXBWEStEVX592hxqcDstCUxC8tDmV9YzOL0svjbYOThUJ12Y6A0M6nUWs8AWh0u5jq31qrjlDg1RPQzeS51CHfTO1CLRer3lmvgI0wRSrBvGKQgSZiAydDd0MuqBg2O6IQPI5k9xrfd5Q3qRNVIvuP7b47QgGVvvHBSeGVFOZn3bmGWzzTBJJWU4RpaY)R)MpRKsk5lnITUZHQS2VBZTuwGvGriqJOpWDmKe4BROqN2R3YlPKYtljAeKrVa3GWlShx)nvXkQUsxDgG2s1PymPDqlYWkzpyyx0fKlfP5GuYcxGHH4nilKjnqcTcBOuCdMa8UgFOIGiOniuGPOTyXmrwBKZ1lDEpL4MlHAEnV)8M3IVYvY1VddAcmB8AW4cXurI9OWMvIAjFtZUFcViss12pfffCTn2uhzzCD9GZFqvYB)Ahm4B4R81R0lsvsgPex2kuQIqhMoMsYRbN34CEL4CJpHcQ8ccya(G6AMD(mLOpx2I9vBDu1umNcYpLL3qt9vG))Hx(LVei)6ZHOQzqstvvBZMeprKPAJN)l52osG3n7PR51wTB7XPsqaE37q8D9SmdmvmfKZqMOvHPplbtuXQTeQ9j7EwGvU3EHle2bEPbjefqvjEcP6BCDD0OGBEhQWgvI7LB9eWFttm1GyFMwT0q4HiV0MojaceGmBpIjskQgiAuIJVshc2(c2mKajiZA0Ntp0WfDjgrmkQN(6skzSyZhCxPpx7oIiUje8NKQGdXe0EkZUhqn2fWRijrSMH48ATdX6Iy5OqsxyQBPHshrkPfePXj0MGqlHAUdDpeSgicPLG0(bgfH6PKKpatia)LFLyGqkyQJIyoZ0Xv1KevBcm(IEt3UKOcKlbsEiwRSDeCgusd0YmXZEGLQpxcVeiInlSyRiiAF4uSw1fvGW9Zjq9RTRgsclfAjy2kq6gPRxRhjrlAm6Wd24dyhueGOlQxhjOJke7SvXigAnMqMeeRhWJoe8fIYebE3QXE1ftqckjNTvrDs4RajIqskA0ZCYrpZtpjBEwlc01G(zJBFwdfGPmvFGKj6EQZxZidnLiYzBMApzzPI6qmoD6PmM0m5XgcRFBffWUEytuOKkQrdkMOB5riStqujklxbizNGjv7gs(QRna2Sf27T9Vjvf1aSMAHcxyqmae2g0nsYCIbA3IrtqKisWkS)WGJhI3FCvZGfLcxnUgi6e4eI2CD3tj4AhQJMBP(h0oofE1HGLSIsmKfHQkcEm8KokuyJqYEsy61)vHIo5YwqNq8tvAAhuV2MeKVk9CNCg2YD402ApcSpaUw8QW(LzEj95dxfeEL84Qwff6g8e5A1lplr5yZrT4HDZCYup0yN4C5o)wZpWlM)ahmD7GzU9Cmfn3u0t8uDevTmn6j8Xjkh3Md2lHU5jD2h)sVuUDCC2SRpFxwcuKGmnH9bfxtTnIXE2jv4x9DjORPKWcVLSgivrlfI(I(EW(AlMjxAipkYebbvJkhSxstJy3KSI5gqOULXLnWDoczZnlXvIVNWdsJPtIehgMUEbVHMZEsy5smImbGBGenkCwcrciXO9rJ(d(vOe0HgbNnza8rg2DlgbCTYHFGbMpETC4wBEnzo0Hax(xbVooCB841hglPxw7qwBgOYBcs0Q8nidP1H)2lh3H(CSt(Rvr4p2rZWIC4nYHfKXpehgrcGbk9Ay6EFS1eFmdzF4oloBBGd)T4Wpgn(kL2Qz0wnJ2QXpE0BbhD54UWHXT38AM4qh6JGSvWXBEn)UF5NE)KhL)Rxq24gABUbfde1nOuU998JEM9GVVWS0(sas8NsTqiz8jisckGd7SvkRtISaPL7ZBVZGAfXHRJJTqUy83uoltdANSah1zDsten3DAefYIJmwBj3QEzMqgZqEjiudRV9MumGd4mjPP1BOOzaP)cTYpibrbyWq3R7EBgjcUkV5uS0vjRZFsbGt3f5E7pGZ6wyjmuUObnCwW9kaXeCXZoahwZqFEDXKb66F7iRG9bo0ah0UAvOr1n9WTy3c1Af8UUN8h4Str834m09mfzhmcdxjek7BH3s)pClRhSxiM5CpZSWEhyUzLmqpb1G19(uPMxZp9Gh8LVYv2lvOGL16QRRRCL)W0iClVFcxiPhgZBFl8M827)JFW(0aYIgoOcO3JIWpoAqdssuuxwPiKVwwY2GvaSaMM0ItE4WYhfw0Z8mfyvqhFZ4Q190KHYtu(dLumQHOLy5D0H3EVNsMcUw8GwxJKnLLPF2vljlf)RxnElnF)YhOti7JR08h9D(lB8ZGh0Nx3iKorp1wcQ)pMZiW6GKtaCWoi(PZbnL7xffJjOtssjQTKwTfZM(00utAlrq4W9HNShnjQm6i46ECAPdup6Gxj0K5E(3i3lD68B9TgB3V5QxAI0oeao3bGY9hhYPHPxijlxuPRo6XIWR(EXZzGfHVuy8hDR6ETtfH5bs0iocIOyr))SnaBzidWRul2PpV00mlFkbFGJPFZR5x9R(vGw69DSwO(o(nfM(w9A08A(fp0dbMqVNT3xWVMxB)AzhCqWsBsIFnWPg4CcCJ87x0IaFh3gUd8Nq8aTXcEG4yEFQLiiDYJF8LCRf8LvnTxy9KdhDPeNwexsF7LIJd5YMasu0Pai2P7I)P4)EMXhnBsbBPm81HyiD0pAF7dazwW0e)XCyT9pRrCCAZo1Rmw(8lzqhvvNlSeMlctsjf(GRRlIFMTRmM7bCw3unNRXcLzpFDWgC8UFYl8ca20km7BKt)2OtmB9SLeKJi3eTYbE)M0JSX6iS(cGDhXroKb5Jrgfnqg(jWxpnHZ5mz2g7cp3Dojsfc70QOr3idYK7Dv6ZrXzmUA2hKEBwjvXiDRQyY2DmcZ2BDRVEcfMZSy3qtMZK6gJIis30uGNKnck5uwGN3YihmijPgiq4YHYFGlK)h(c5hyF52ZlRxMf4MNuGK2Pua0Rx9JM)GVsUZEPCp)EE88N81YDK3GmI9FXLcQOUl)Ekp3U2zUJTRrp)RmXw3wUbE37EPKib3nE(7eqpBfL4)36dkKaflHgEIDo(FaVfQZeWlej9PfJ1ESsYgvXe2j3ht9Rxw(bE(8PF18hz3tCW3Q8V(sTwUUNOOikqQjfsk9w19yOfpjQRy9agq0cAaJJoOCx49YFYJZgxzfjsNKWOwpoun2aV1ed(MuQWYlgFBd4jTbT(vmdFihfrDuh9PJeQxOT2BxksHYa4R6uBsXursbwt7RMjz5wbzWN)fV4yh7ddB3qUJDa7ggA0ZTJC7(DYFK3o3o3rybZiG2HUv01egGNnb0J4xz1gA2bPDrsiogjoKgI3vNb5srFHAjuQ9W3i3q2fUQDYXGg4RR)vFYiXIvFT1vFnncOm3R9dEsJYV3YN4ftNFphlS(Ds61V)68xBt52)XM4K7p3zgGsqUuhD8lU7W63fD4v5Rr)bYFYZn6h(Qt8wpFbM0)BLFBFGnnvurTv0qdJVV3i)5E1Xo(jZT3ZW4ZoEQXo9Ryprn1utvvZQYFHJm(R(mJV1Dqji)lS3j2)(UXtuUD(UtCKJeMjlRQ2vTQgBm)rEhNEh7GV04p9jS7Tj6)n2UFDhbzSJF0Ch51CaqvRQ(GbG3DXChcOaiGF)vuFDGubQIXEMNl)UFAgao0Bp22ozbPO26RiqUl(JMi92g987HjfBlvUJ9S2yWFt1xBJbH9BfWW2(bJT931U3abBOQA9dmF0p8dzm)D3EUDDUBWAr(T9M0fRRpZZD8JdkdB8FnkhMOK7KNy83zNtNkk)adM7Ip9nqfL)PEtGghv0vJ)j21ZLBhxi)Z965g4dUrsXzpfvhEJSwMIA8AX5HpiSr3U3kQOPMQBv5p5jY9uVotjFUDnXlDXWtJbpHWd9gFb2QPoAUZ)H3Gv5CNAGI7AUEeaQI8B91NUf6X2)lN7KV4nI)N9ho(R(QtNim2t3F(To40j(JFM9oXR9CtxVtSJbh9Ch6ly7CAyF5wNUDz5FNT5ElW1Uro3X314Po5nWkYXNZnAJw(3)nZTNFW0AQB7hyAXaOIYDXb)c2lFSND0ZTRWKcOTGnL2Kw2kuubTnZJ)114TVMV)yrAdsT9Z82BZ3)M)72ujKJQDMubBRJoARvsPrtjfhogIfev1CGYWpiF)soLA25PGfEsGhcDlHu7KxqbYf2QmChbxhKkC)OOGJBiVX5KAtK6bstByec3xDUF0jY9oNDIlSp8JWJFu(u0Xt7plREGRo37Tdi0JZueIhlnmxNsu(05S4WX4tbhQSD25K)YW5AdcVA(Di1kuGYSulD0ZCUCV3rblv65mPvK8exBkY2PhttnErsMrqjqMlBWIH1CE8yhGDE11sy(jCYwJdxvZR5F3VFi93RqY9D0QQcYC9R5TVz4Tx6PkooLX(KyxDdNGHMkYSgJgc0AGqnkeoyhbw3dgwQ5gdSw4T(n7lresQ8HRSBuFdwuaumTVffzqadpmNKu(dFAWD6WCr)IePH5qlByUyWGId)KpGnYnOPQ)pE0JcNxF3SXqYK)Yx(Y)2skPbwHyw6WCk8dZ9DQzyUUHXQc)6b(La(PnmNXWCF3WfGZwp(eB9Lb44M)8o8LNXVPflnVMF77(UWzg(xCnMMxZw94zXx5k)X)CWIPBSmw6loXwpCbSe(AXcjz6PhlNy(ZhM3Fbr)mIGq4sk5REvYXnglwUXsUD8gJ)ux4gPxw1nuV8l3Wgaa4LGf7df9)lSKCk6Lx)CUxJU(6LBS9YV)(Up4uCFAX1OSccqd)4IyHBAXYMiybFFYs0BnkUm(2FeALwA3QpvKBirYuSg)E77B4Tx7BYPIQytWktPI2es9AgbieWHBDjfFJ(7ruNCsgZb8SKBxcsmyIdLAUZucSlYDS38Y3TeeebCOATyPCV0rZ99E2p(ULG4KtC4DU)fln2RC68h6nUPVMu(tF0XERx(Z)ks539RNF)x6y3M04V)Zn2fERrVljigx(TUnRfibCB8x9GxUCP8V7PN4GNz7qlNAV5EPl(5ad3t)J1)zRAXstC49n6Lo1OWKcPj8oNFe7Zeyx7)LrRhyqKP1AjYMmTgIThrZajNI8rk4w)qnjM4SNfCC)NOs95Dwh(DlCHGXXnBxqg8DeJvbmIRtu01LShjKHz4HIsVDG6lKWFf(0ltusICFNIwORhzqU4SBdHcU55UlAg91wh(RoWDAFWm6nzVErl5sXxcoDj9sdlC(XgkCcNzOxgTWiUoCzdY4jXBb)5FYFU1uq0DnfkwjQHmjqW(w5LAL(TvmmhhCu1)uXdXlVsWkeo4VaLyiQIbDfq0GeTuVmLIOIfXJwPuS2nvM(ci4EdYOeRtZQa4vGZHeg)FWFTJmi9WqdswSzxYp()AARx4TmLcr57AzMaLzxB7Hy1H9)UqHaWz)ZSOK(W)V0d6pmxj8xVcYWy81POmp8ulkdVBVtgfzaPanJoVRBbAq4VfGcAfAqy48ZlKCc7H0fnS67br9rIa(bxVWAnCltPswloOjSEG3vkDAj4lomMO38L(Jh6WqEnLsW3p)7)9bdOFI3(u)l8279sDNuxrcau)7oYrGqHZMCVhuCq8EmTazLtfhdZTSZ)LsB)DdqlvXWCL)X3cErKloeFNd4Hu9d2931akMysvRm2xYx7KZmZNEtidl7Cz4grpPQjQvX4juSsgfLHuidwjtsAGAsrf1sdly2V99LMi7oJrFUuA00NkzZCgDMIYn4yYOOzgsdMhIXiDsbiYnPy0nrUoVOo1GCWyIrTPgeko8Eg4R)3K50pAM)2mhB2zo9SZ8XW)E0mxE2zEQmF(SZSJmZ1tML4jtvEY0GNmZDjzI6jJLNmB3tM9dV(yzoTNmFSNmx2tMr9K5zZ8ZZS3m)tzE(mJo7m)ImDSKmFVmB)XY8pNPdpz2wMJ5jZn5jZqKzVTKwmaGx8alDqtFvy7icESA7TvZOIvuxv(m61(Yq7x15sSn6J10JndALkBJ99Hm4yNBN537Eh)INLCPdoSjeF)rmkU1QUctLaH)vuJFsHO7rjb5wSz1VP0b10S)GfkmNqIPngMozTB)PQKkgTg(uDC)MgtHLUiCJlSeNEbKqBhYuE593ZvpdWtMgtrWXNfVLuf5KSJCq93uhR4j2i2PRqoIy1tbpfKzhw7m9mc8xh(m4TKL41RG37moKaRioQdHIpgIdx(aX6NfqWNaFw7BfN9jwCZK8FvdstdwnaFwf7Vjk6LavAkJiDfH57UYvAejBCYf660YDVY4el2GMI9fGhwhTNc)H4fatCvbEy5sIUZnenbIAtTzndy4uoBtCLb5PfaTlAxSRRRR(qQQHLOTy)v50fmh28sGXR(HwyCc2vCFcKsTkWlqgPapT(XDzpbYSHfG1ziwrVsrBZwgPutLSWPycOBe6pi)GokLGCdrutokaHvsElnbjfujM2rE950uWv2AdWz3O6CI909vGBcm9uioMOAhBYP3a8vAeborNnke4j65GWq0m3yLF(SOdnGTYJkno6FFH4zmKfhYTYWNSevafyAHH5odEvdsulmjMQHSllizE6SYhNXj44K0Xr(SxOlH2YMU3Ch71hF7hE0ZCGXEHNzIup)eB775a4a2JjapBrLG3W07UWL6dEJMSvxosD4uI0ptbIlB40wpBU9DMjo02jIUGnFiJPGOcRQK3TLuQKuyLOpwuJInOxq3YOFyUFYDrRr)uTibZxYYAOPyg5xMQCcWpKnvSXqawiN28XABqQjYuyzaEdg2JeMI3a86EkSrRa(ugIOJCExALrIwUVkmGDGSfhsNfShQuG32qZFXnOBiayYeYHeFb5zM(bjwsWYaL7mErGOGdU9ZAKTC5S8tGzqoyGcCt6iYfSOBiyR2lgaFcJVR)tsUcM0R(oqpKl)QSH5E)o5Rzf1nPs8eKeEzxBquZzcUV2vAM)ylY1ew5ABBddZ9J6CgvwHVv4pfJjK9jTa5dsUoOZI3vwgtS5bSH)hZt)6Jk8XXmh2Wc5(sTfOxVj(Uh42XpiTu6vwW3g5790C(lz51e0IE7NSCFjxbO8iKNBjHZxgQSUhjXiDh3GMell3tYNLrLxt7b50NNtnDCgn9JIzjlN81biZHfcpckreI2bzWqWN)KZF4sdvkjh354m2gDiPLg(8NSFY3gnjLNp1BXVxJR(Ielnn7ojOW4b444OjusYoA13f(rOrzWIZa)OeGxv14yu)NvJ1UNBflHJCncIa310uiUrORyTQKOz6xE37RxwrsStWrODnvLOJWsC3PVWSqV0pZITxoKojy(8iKl0GKG(xBG5oKRJP4RuSS6cWF7npm3HHJaq)AdT5TKp)v63NFsPZ0wK7Xufym8IdZDObTVA76Bi8iKtzvKcz3KxtPUFRYs7NUAt(sMD3E1Lscyh1HbPbgUo6hKcCOi305V0ujtq(evBWqmo5leHyE2qP4L0eausUAdZ9A4DbHiNX)3p'
  end

  local data = EX.Export:ParseImportString(profileString)
  if not data then
    return
  end

  local selected = {}
  for moduleKey in pairs(data.modules) do
    selected[moduleKey] = true
  end

  EX.Export:ApplyImport(data, selected, 'replace')
end

local LoadQuestieDB = function()
  if not IsAddOnLoaded('Questie') then
    return
  end

  QuestieConfig['profiles'][merfinUI] = QuestieConfig['profiles'][merfinUI] or {}

  QuestieConfig['profiles'][merfinUI]['trackerFontObjective'] = Private.Font
  QuestieConfig['profiles'][merfinUI]['trackerFontZone'] = Private.Font
  QuestieConfig['profiles'][merfinUI]['trackerFontQuest'] = Private.Font
  QuestieConfig['profiles'][merfinUI]['trackerSetpoint'] = 'TOPRIGHT'
  QuestieConfig['profiles'][merfinUI]['trackerFontHeader'] = Private.Font
  QuestieConfig['profiles'][merfinUI]['trackerEnabled'] = false
  QuestieConfig['profiles'][merfinUI]['globalScale'] = 1.1
  QuestieConfig['profiles'][merfinUI]['globalMiniMapScale'] = 0.8

  if Private.GetProfileResolution() == 'QUAD_HD' then
    QuestieConfig['profiles'][merfinUI]['TrackerLocation'] = {
      'TOPRIGHT', -- [1]
      'UIParent', -- [2]
      'TOPRIGHT', -- [3]
      -0, -- [4]
      -278.5003662109375, -- [5]
    }

    QuestieConfig['profiles'][merfinUI]['trackerFontSizeZone'] = 15
    QuestieConfig['profiles'][merfinUI]['trackerFontSizeHeader'] = 15
    QuestieConfig['profiles'][merfinUI]['trackerFontSizeObjective'] = 15
    QuestieConfig['profiles'][merfinUI]['trackerFontSizeQuest'] = 15
    QuestieConfig['profiles'][merfinUI]['TrackerHeight'] = 669.0003662109375
    QuestieConfig['profiles'][merfinUI]['TrackerWidth'] = 297.0004577636719
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    QuestieConfig['profiles'][merfinUI]['TrackerLocation'] = {
      'TOPRIGHT', -- [1]
      'UIParent', -- [2]
      'TOPRIGHT', -- [3]
      -14.0001220703125, -- [4]
      -258.499755859375, -- [5]
    }

    QuestieConfig['profiles'][merfinUI]['trackerFontSizeZone'] = 13
    QuestieConfig['profiles'][merfinUI]['trackerFontSizeHeader'] = 13
    QuestieConfig['profiles'][merfinUI]['trackerFontSizeObjective'] = 13
    QuestieConfig['profiles'][merfinUI]['trackerFontSizeQuest'] = 13
    QuestieConfig['profiles'][merfinUI]['TrackerHeight'] = 360
    QuestieConfig['profiles'][merfinUI]['TrackerWidth'] = 249
  end

  QuestieConfig['profileKeys'] = QuestieConfig['profileKeys'] or {}
  QuestieConfig['profileKeys'][Private.AceProfileName] = merfinUI
end

local LoadLeatrixDB = function()
  LeaPlusDB = LeaPlusDB or {}
  LeaPlusDB.EnhanceProfessions = 'On'
  LeaPlusDB.EnhanceQuestDifficulty = 'On'

  LeaPlusDB = {
    ['HideMiniZoomBtns'] = 'Off',
    ['ViewPortBottom'] = 0,
    ['BuffFrameX'] = -205,
    ['MuteCustomList'] = '',
    ['ManageWidget'] = 'Off',
    ['TimerY'] = -96,
    ['SetWeatherDensity'] = 'Off',
    ['ClassColPlayer'] = 'On',
    ['ShowMinimapIcon'] = 'On',
    ['TipCursorY'] = 0,
    ['FlightBarContribute'] = 'On',
    ['InvKey'] = 'inv',
    ['FlightBarY'] = -66,
    ['MinimapR'] = 'TOPRIGHT',
    ['NoGryphons'] = 'Off',
    ['FrmEnabled'] = 'Off',
    ['TipCursorX'] = 0,
    ['MinimapModder'] = 'Off',
    ['LeaStartPage'] = 5,
    ['FlightBarSpeech'] = 'Off',
    ['DressupItemButtons'] = 'On',
    ['DismountNoTaxi'] = 'On',
    ['InviteFromWhisper'] = 'Off',
    ['MinimapScale'] = 1,
    ['TimerScale'] = 1,
    ['MuteYawns'] = 'Off',
    ['AutoReleasePvP'] = 'Off',
    ['HideMacroText'] = 'Off',
    ['MinimapX'] = -17,
    ['AutoResNoCombat'] = 'On',
    ['WowheadLinkComments'] = 'Off',
    ['VanityAltLayout'] = 'Off',
    ['TipHideInCombat'] = 'Off',
    ['UseArrowKeysInChat'] = 'Off',
    ['ManageDurability'] = 'Off',
    ['AcceptPartyFriends'] = 'Off',
    ['PlusPanelAlpha'] = 0,
    ['WidgetX'] = 0,
    ['FlightBarWidth'] = 230,
    ['RestoreChatMessages'] = 'Off',
    ['FirstRunMessageSeen'] = true,
    ['NoCooldownDuration'] = 'On',
    ['MuteGameSounds'] = 'Off',
    ['SquareMinimap'] = 'Off',
    ['DismountNoMoving'] = 'On',
    ['KeepAudioSynced'] = 'Off',
    ['NoRestedEmotes'] = 'Off',
    ['MuteScreech'] = 'Off',
    ['CombatPlates'] = 'Off',
    ['FlightBarA'] = 'TOP',
    ['TipHideShiftOverride'] = 'On',
    ['HideZoneText'] = 'Off',
    ['TimerX'] = -5,
    ['EnhanceDressup'] = 'Off',
    ['ShowFlightTimes'] = 'Off',
    ['RecentChatSize'] = 170,
    ['NoBagAutomation'] = 'Off',
    ['ShowWhoPinged'] = 'On',
    ['UseEasyChatResizing'] = 'Off',
    ['MoreFontSizes'] = 'Off',
    ['AutoQuestShift'] = 'Off',
    ['HideMiniAddonButtons'] = 'On',
    ['LeaPlusQuestFontSize'] = 12,
    ['TipShowTarget'] = 'On',
    ['CharAddonList'] = 'Off',
    ['BuffFrameY'] = -13,
    ['MuteChimes'] = 'Off',
    ['MusicContinent'] = 'Zones',
    ['NoDuelRequests'] = 'Off',
    ['FlightBarBackground'] = 'On',
    ['AhExtras'] = 'Off',
    ['ViewPortTop'] = 0,
    ['MinimapSize'] = 140,
    ['QuestFontChange'] = 'Off',
    ['HideErrorMessages'] = 'Off',
    ['TipOffsetX'] = -13,
    ['BlockDuelSpam'] = 'Off',
    ['FriendlyGuild'] = 'On',
    ['MainPanelR'] = 'CENTER',
    ['WidgetScale'] = 1,
    ['DurabilityScale'] = 1,
    ['FlightMapX'] = 0,
    ['EnhanceQuestTaller'] = 'On',
    ['AhBuyoutOnly'] = 'Off',
    ['BuffFrameScale'] = 1,
    ['FlightMapR'] = 'TOPLEFT',
    ['DressupAnimControl'] = 'On',
    ['NoClassBar'] = 'Off',
    ['DismountNoResource'] = 'On',
    ['TimerR'] = 'TOP',
    ['FlightBarFillBar'] = 'Off',
    ['UnivGroupColor'] = 'Off',
    ['EnhanceQuestDifficulty'] = 'On',
    ['TooltipAnchorMenu'] = 1,
    ['NoScreenEffects'] = 'Off',
    ['MinimapNoScale'] = 'Off',
    ['EnhanceProfessions'] = 'On',
    ['MainPanelX'] = 447.9999084472656,
    ['AutoSellExcludeList'] = '',
    ['DurabilityY'] = -192,
    ['ShowVolume'] = 'Off',
    ['NoPartyInvites'] = 'Off',
    ['WidgetY'] = -15,
    ['MinimapA'] = 'TOPRIGHT',
    ['EnhanceQuestLog'] = 'On',
    ['MuteReady'] = 'Off',
    ['ViewPortLeft'] = 0,
    ['MuteCustomSounds'] = 'Off',
    ['BlockDrunkenSpam'] = 'Off',
    ['FlightBarScale'] = 2,
    ['MainPanelY'] = -3.000022411346436,
    ['MuteStriders'] = 'Off',
    ['MaxCameraZoom'] = 'Off',
    ['AutoQuestAvailable'] = 'On',
    ['FasterMovieSkip'] = 'Off',
    ['BuffFrameA'] = 'TOPRIGHT',
    ['PlusPanelScale'] = 1,
    ['CooldownsOnPlayer'] = 'Off',
    ['ShowWowheadLinks'] = 'Off',
    ['ShowFreeBagSlots'] = 'Off',
    ['HideMiniClock'] = 'Off',
    ['EasyItemDestroy'] = 'Off',
    ['AutoQuestCompleted'] = 'On',
    ['FasterLooting'] = 'Off',
    ['NoConfirmLoot'] = 'Off',
    ['ClassColFrames'] = 'Off',
    ['WidgetA'] = 'TOP',
    ['NoStickyChat'] = 'Off',
    ['ViewPortResizeBottom'] = 0,
    ['LeaPlusMailFontSize'] = 15,
    ['ViewPortResizeTop'] = 0,
    ['WidgetR'] = 'TOP',
    ['StandAndDismount'] = 'Off',
    ['NoFriendRequests'] = 'Off',
    ['AutoRepairShowSummary'] = 'On',
    ['AhGoldOnly'] = 'Off',
    ['FlightBarDestination'] = 'On',
    ['ShowBagSearchBox'] = 'Off',
    ['DurabilityStatus'] = 'Off',
    ['NoChatButtons'] = 'Off',
    ['EnhanceQuestLevels'] = 'On',
    ['MuteLogin'] = 'Off',
    ['ViewPortRight'] = 0,
    ['NoCombatLogTab'] = 'Off',
    ['TipNoHealthBar'] = 'Off',
    ['ClassColorsInChat'] = 'Off',
    ['ManageBuffs'] = 'Off',
    ['MoveChatEditBoxToTop'] = 'Off',
    ['ViewPortEnable'] = 'Off',
    ['BuffFrameR'] = 'TOPRIGHT',
    ['ShowRaidToggle'] = 'Off',
    ['ShowVendorPrice'] = 'Off',
    ['MinimapY'] = -22,
    ['MiniExcludeList'] = '',
    ['NoChatFade'] = 'Off',
    ['MuteMechSteps'] = 'Off',
    ['NoScreenGlow'] = 'Off',
    ['AutoQuestKeyMenu'] = 1,
    ['FilterChatMessages'] = 'Off',
    ['ViewPortAlpha'] = 0,
    ['AutoAcceptSummon'] = 'Off',
    ['DurabilityX'] = 0,
    ['FlightBarR'] = 'TOP',
    ['LeaPlusTaxiIconSize'] = 10,
    ['UnclampChat'] = 'Off',
    ['LeaPlusTaxiMapScale'] = 1.9,
    ['LeaPlusBookFontSize'] = 15,
    ['MaxChatHstory'] = 'Off',
    ['MailFontChange'] = 'Off',
    ['FlightBarX'] = 0,
    ['MuteTrains'] = 'Off',
    ['MainPanelA'] = 'CENTER',
    ['CombineAddonButtons'] = 'Off',
    ['TipShowRank'] = 'On',
    ['PlayerChainMenu'] = 2,
    ['TipModEnable'] = 'Off',
    ['HideMiniTracking'] = 'Off',
    ['ShowTrainAllBtn'] = 'On',
    ['ShowPlayerChain'] = 'Off',
    ['FlightMapY'] = 61,
    ['MuteInterface'] = 'Off',
    ['EnhanceTrainers'] = 'On',
    ['AutoSellJunk'] = 'Off',
    ['AutoRepairGear'] = 'Off',
    ['WeatherLevel'] = 3,
    ['ManageTimer'] = 'Off',
    ['AutoAcceptRes'] = 'Off',
    ['ShowReadyTimer'] = 'Off',
    ['AutoSellShowSummary'] = 'On',
    ['TipOffsetY'] = 94,
    ['AutomateGossip'] = 'Off',
    ['NoSharedQuests'] = 'Off',
    ['ShowCooldowns'] = 'Off',
    ['BookFontChange'] = 'Off',
    ['HideMiniZoneText'] = 'Off',
    ['ShowVanityControls'] = 'Off',
    ['LeaPlusTipSize'] = 1,
    ['MuteFizzle'] = 'Off',
    ['HideDressupStats'] = 'Off',
    ['TimerA'] = 'TOP',
    ['RecentChatWindow'] = 'Off',
    ['hide'] = false,
    ['HideKeybindText'] = 'Off',
    ['MiniClusterScale'] = 1,
    ['FlightMapA'] = 'TOPLEFT',
    ['TipShowOtherRank'] = 'Off',
    ['ShowCooldownID'] = 'On',
    ['NoHitIndicators'] = 'Off',
    ['EnhanceFlightMap'] = 'On',
    ['AutoReleaseNoAlterac'] = 'Off',
    ['InviteFriendsOnly'] = 'Off',
    ['ShowDruidPowerBar'] = 'Off',
    ['AutoReleaseDelay'] = 200,
    ['ClassColTarget'] = 'On',
    ['AutomateQuests'] = 'Off',
    ['DurabilityR'] = 'TOPRIGHT',
    ['DurabilityA'] = 'TOPRIGHT',
  }
end

local LoadPallyPowerDB = function()
  if not PallyPowerDB then
    return
  end
  local newProfileName = 'MerfinUI v' .. Private.Version

  PallyPowerDB['profiles'] = PallyPowerDB['profiles'] or {}
  PallyPowerDB['profileKeys'] = PallyPowerDB['profileKeys'] or {}

  PallyPowerDB['profiles'][newProfileName] = {
    ['auras'] = false,
    ['skin'] = 'normTex2',
    ['rfbuff'] = false,
    ['enable'] = true,
    ['border'] = 'None',
    ['WrathTransition'] = true,
    ['hideHighGroups'] = true,
    ['rf'] = false,
  }

  PallyPowerDB['profileKeys'][Private.AceProfileName] = newProfileName

  PallyPowerFrame:ClearAllPoints()

  if Private.GetProfileResolution() == 'QUAD_HD' then
    PallyPowerFrame:SetPoint('CENTER', 'UIParent', 'LEFT', 210, 125)
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    PallyPowerFrame:SetPoint('CENTER', 'UIParent', 'LEFT', 210, 125)
  end

  PallyPowerFrame:SetUserPlaced(true)
end

local LoadBagSackDB = function()
  BugSackDB = {
    ['auto'] = false,
    ['fontSize'] = 'GameFontHighlight',
    ['useMaster'] = false,
    ['altwipe'] = true,
    ['mute'] = true,
    ['soundMedia'] = 'BugSack: Fatality',
    ['chatframe'] = false,
  }

  BugSackLDBIconDB = {}
end

local LoadNovaWorldBuff = function()
  if not NWBdatabase then
    return
  end
  NWBdatabase.global = NWBdatabase.global or {}

  NWBdatabase.global.resetLayers17 = false
  NWBdatabase.global.minimapLayerFontSize = 13
  NWBdatabase.global.resetTimerData1 = false
  NWBdatabase.global.resetSongflowers = false
  NWBdatabase.global.convertSettings = false
  NWBdatabase.global.resetDailyData = false
  NWBdatabase.global.wipeTerokkarData4 = false
  NWBdatabase.global.disableAllGuildMsgs = 0
  NWBdatabase.global.disableFlashAllLevels = true
  NWBdatabase.global.versions = { [3.23] = 1768664404 }
  NWBdatabase.global.disableSoundsAllLevels = true
end

local LoadEditModeAccountSetting = function()
  if not C_EditMode or not C_EditMode.SetAccountSetting or not C_EditMode.GetAccountSettings or not Enum or not Enum.EditModeAccountSetting then
    return
  end

  local preset = {
    ShowGrid = 1,
    GridSpacing = 20,
    SettingsExpanded = 1,
    ShowTargetAndFocus = 0,
    ShowStanceBar = 0,
    ShowPetActionBar = 0,
    ShowPossessActionBar = 0,
    ShowCastBar = 0,
    ShowEncounterBar = 0,
    ShowExtraAbilities = 0,
    ShowBuffsAndDebuffs = 0,
    DeprecatedShowDebuffFrame = 0,
    ShowPartyFrames = 0,
    ShowRaidFrames = 0,
    ShowTalkingHeadFrame = 0,
    ShowVehicleLeaveButton = 0,
    ShowBossFrames = 0,
    ShowArenaFrames = 0,
    ShowLootFrame = 0,
    ShowHudTooltip = 0,
    ShowStatusTrackingBar2 = 1,
    ShowDurabilityFrame = 0,
    EnableSnap = 0,
    EnableAdvancedOptions = 1,
    ShowPetFrame = 0,
    ShowTimerBars = 0,
    ShowVehicleSeatIndicator = 0,
    ShowArchaeologyBar = 0,
    ShowCooldownViewer = 1,
    ShowPersonalResourceDisplay = 0,
    ShowEncounterEvents = 1,
    ShowDamageMeter = 1,
    ShowExternalDefensives = 1,
  }

  local current = C_EditMode.GetAccountSettings()
  if not current then
    return
  end

  for name, value in pairs(preset) do
    local id = Enum.EditModeAccountSetting[name]

    if id and current[id] and current[id].value ~= value then
      pcall(C_EditMode.SetAccountSetting, id, value)
    end
  end
end

local LoadMerfinPlusDB = function()
  MerfinPlusSaved = MerfinPlusSaved or {}

  MerfinPlusSaved['profiles'] = MerfinPlusSaved['profiles'] or {}
  MerfinPlusSaved['profileKeys'] = MerfinPlusSaved['profileKeys'] or {}

  local profileName = 'MerfinUI (' .. Private.Version .. ')'

  MerfinPlusSaved['profiles'][profileName] = {
    ['font1'] = Merfin.GetDefaultFont(),
    ['font2'] = Merfin.GetDefaultFont(),
  }

  MerfinPlusSaved['profileKeys'][Private.AceProfileName] = profileName
end

function Private.Set_CVars()
  local useModernCVars = E.Retail or E.Mists or E.TBC

  -- Bitfield CVars
  if useModernCVars and CVarCallbackRegistry and CVarCallbackRegistry.SetCVarBitfieldMask then
    pcall(function()
      for c, v in pairs({
        nameplateFriendlyPlayerAuraDisplay = 0,
        nameplateThreatDisplay = 6,
        nameplateCastBarDisplay = 23,
        nameplateEnemyNpcAuraDisplay = 7,
        nameplateEnemyPlayerAuraDisplay = 3,
        nameplateSimplifiedTypes = 0,
      }) do
        CVarCallbackRegistry:SetCVarBitfieldMask(c, v)
      end
    end)
    -- Getter
    -- for c,e in pairs({
    --     nameplateFriendlyPlayerAuraDisplay=Enum.NamePlateFriendlyPlayerAuraDisplay,
    --     nameplateThreatDisplay=Enum.NamePlateThreatDisplay,
    --     nameplateCastBarDisplay=Enum.NamePlateCastBarDisplay,
    --     nameplateEnemyNpcAuraDisplay=Enum.NamePlateEnemyNpcAuraDisplay,
    --     nameplateEnemyPlayerAuraDisplay=Enum.NamePlateEnemyPlayerAuraDisplay,
    --     nameplateSimplifiedTypes=Enum.NamePlateSimplifiedType,
    -- }) do
    --     local r=0
    --     for _,i in pairs(e) do
    --         if C_CVar.GetCVarBitfield(c,i) then
    --             r=r+i
    --         end
    --     end
    --     print(c, r)
    -- end
  end

  -- CVars
  local CVars = not useModernCVars
      and {
        -- Character CVars
        nameplateShowDebuffsOnFriendly = 0,
        nameplateShowEnemies = 1,
        nameplateSelectedScale = 1,
        nameplateShowFriendlyPets = 0,
        ShowClassColorInNameplate = 1,
        ShowClassColorInFriendlyNameplate = 1,
        nameplateMotion = 1,
        NameplatePersonalHideDelayAlpha = 1,
        nameplateShowFriendlyNPCs = 0,
        NamePlateHorizontalScale = 1,
        nameplateMaxDistance = 41,
        NamePlateClassificationScale = 1,
        nameplateShowFriends = 1,
        nameplateSelectedAlpha = 1,
        nameplateShowEnemyGuardians = 1,
        lfgSelectedRoles = 8,
        nameplateShowOnlyNames = 1,
        autoLootDefault = 1,
        nameplateShowEnemyTotems = 1,
        nameplateNotSelectedAlpha = 1,
        consolidateBuffs = 1,
        nameplateRemovalAnimation = 1,
        clampTargetNameplateToScreen = 1,
        nameplateMinScale = 1,
        autoFilledMultiCastSlots = 15,
        nameplateLargerScale = 1.1,
        nameplateShowEnemyPets = 1,
        -- SoftTargetEnemy = 3,
        nameplateShowEnemyMinions = 1,
        -- Accounts CVars
        cameraDistanceMaxZoomFactor = 4,
        wholeChatWindowClickable = 0,
        lockActionBars = 1,
        showTutorials = 0,
        showNewbieTips = 0,
        floatingCombatTextCombatDamageDirectionalScale = 1,
        profanityFilter = 0,
        talentFrameShown = 1,
        scriptErrors = 1,
        floatingCombatTextLowManaHealth = 0,
        instantQuestText = 1,
        guildShowOffline = 0,
        UnitNameFriendlyPetName = 0,
        UnitNameFriendlyTotemName = 0,
        alwaysShowActionBars = 1,
        colorChatNamesByClass = 1,
        floatingCombatTextCombatDamageAllAutos = 0,
        floatingCombatTextFloatMode = 0,
        deselectOnClick = 1,
        showTargetOfTarget = 1,
        cameraYawMoveSpeed = 160,
        cameraPitchMoveSpeed = 80,
        floatingCombatTextCombatLogPeriodicSpells = 0,
        addFriendInfoShown = 1,
        floatingCombatTextCombatDamage = 1,
        floatingCombatTextCombatHealing = 1,
        UnitNameFriendlyGuardianName = 0,
        floatingCombatTextReactives = 0,
        lootUnderMouse = 1,
        nameplateTargetRadialPosition = 1,
        UnitNameFriendlyMinionName = 0,
        UnitNameNPC = 1,
        floatingCombatTextPetMeleeDamage = 0,
        AllowDangerousScripts = 1,
        showKeyring = 1,
        floatingCombatTextPetSpellDamage = 0,
        cameraSmoothStyle = 0,
      }
    or {
      -- Character CVars
      autoLootDefault = 1,
      autoFilledMultiCastSlots = 15,
      nameplateTargetRadialPosition = 1,

      -- Account CVars
      cameraDistanceMaxZoomFactor = 4,
      wholeChatWindowClickable = 0,
      lockActionBars = 1,
      showTutorials = 0,
      profanityFilter = 0,
      scriptErrors = 1,
      guildShowOffline = 0,
      UnitNameFriendlyPetName = 0,
      UnitNameFriendlyTotemName = 0,
      colorChatNamesByClass = 1,
      deselectOnClick = 1,
      showTargetOfTarget = 1,
      cameraYawMoveSpeed = 160,
      cameraPitchMoveSpeed = 80,
      addFriendInfoShown = 1,
      lootUnderMouse = 1,
      UnitNameFriendlyMinionName = 0,
      UnitNameNPC = 1,
      UnitNameFriendlyGuardianName = 0,
      cameraSmoothStyle = 0,
      -- Auto Track accepted Quest
      autoQuestWatch = 1,

      -- Floating Combat Text (v2 system)
      floatingCombatTextCombatDamage_v2 = 1,
      floatingCombatTextCombatHealing_v2 = 1,
      floatingCombatTextCombatDamageAllAutos_v2 = 0,
      floatingCombatTextCombatLogPeriodicSpells_v2 = 0,
      floatingCombatTextFloatMode_v2 = 0,
      floatingCombatTextLowManaHealth_v2 = 0,
      floatingCombatTextReactives_v2 = 0,
      floatingCombatTextPetMeleeDamage_v2 = 0,
      floatingCombatTextPetSpellDamage_v2 = 0,
      floatingCombatTextCombatDamageDirectionalScale_v2 = 1,

      -- nameplate CVars
      nameplateShowOnlyNames = 1,
      nameplateShowDebuffsOnFriendly = 0,
      nameplateShowEnemies = 1,
      nameplateSelectedScale = 1,
      nameplateShowFriendlyNPCs = 0,
      nameplateMaxDistance = 41,
      nameplateSelectedAlpha = 1,
      nameplateShowEnemyGuardians = 1,
      nameplateShowEnemyTotems = 1,
      nameplateMinScale = 1,
      nameplateShowEnemyPets = 1,
      nameplateShowEnemyMinions = 1,

      nameplateShowCastBars = 1,
      nameplateShowClassColor = 1,
      nameplateShowFriendlyClassColor = 1,
      nameplateShowFriendlyNpcs = 0,
      nameplateShowFriendlyPlayerGuardians = 0,
      nameplateShowFriendlyPlayerMinions = 0,
      nameplateShowFriendlyPlayerPets = 0,
      nameplateShowFriends = 0,
      nameplateShowFriendlyPlayers = 0,
      nameplateShowFriendlyPlayerTotems = 0,

      nameplateShowOffscreen = 0,
      nameplateDebuffPadding = 0,
      nameplateAuraScale = 1,
      nameplateShowOnlyNameForFriendlyPlayerUnits = 1,
      nameplateUseClassColorForFriendlyPlayerUnitNames = 1,
      nameplateSize = 4,
      nameplateStyle = 0,
    }

  for CVar, variable in pairs(CVars) do
    SetCVar(CVar, variable)
  end

  LoadLeatrixDB()
  LoadQuestieDB()
  LoadPallyPowerDB()
  LoadBagSackDB()
  LoadTomTomDB()
  LoadTalentedDB()
  LoadClassColorsDB()
  LoadMerfinPlusDB()
  LoadNovaWorldBuff()

  if E.TBC then
    Private.ImportMinimapButton()
  end

  if E.Retail then
    EasyExperienceBar()
    MiniMapButtonButton()
    LoadEditModeAccountSetting()
    SimpleAssistedCombatIcon()
    CityGuide()
    MyusKnowledgePointsTracker()
    TooltipRealmInfo()
    BuffReminders()
    ExwindTools()
  end

  Private:PluginInstallStepComplete(L['Account Settings'])
end
