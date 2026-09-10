local addonName, Private = ...
local L = Private.L
local merfinUI = Private.MerfinProfileName

local E, _, V, P, G = unpack(ElvUI)

function Private.ImportDBM(layout)
  if not E:IsAddOnEnabled('DBM-Core') then
    Private:Print(string.format(L['You need to enable %s to apply profile settings.'], 'DBM'))
  end

  if C_AddOns.IsAddOnLoaded('BigWigs') then
    C_AddOns.DisableAddOn('BigWigs')
  end

  DBM_AllSavedOptions = DBM_AllSavedOptions or {}
  DBT_AllPersistentOptions = DBT_AllPersistentOptions or {}

  DBM_AllSavedOptions[merfinUI] = {
    ['DontShowFarWarnings'] = true,
    ['FilterInterrupt2'] = 'TandFandBossCooldown',
    ['SpecialWarningFlashAlph2'] = 0.3,
    ['SpecialWarningFlashCount4'] = 2,
    ['AFKHealthWarning'] = false,
    ['DontShowHudMap2'] = false,
    ['AlwaysPlayVoice'] = false,
    ['ShowSWarningsInChat'] = true,
    ['SpamSpecRoledefensive'] = false,
    ['OverrideBossAnnounce'] = false,
    ['InfoFrameX'] = -314.9888610839844,
    ['SpamSpecRolestack'] = false,
    ['DontRestoreIcons'] = false,
    ['ArrowPoint'] = 'TOP',
    ['DontShowNameplateIcons'] = false,
    ['SpecialWarningFlash5'] = true,
    ['SWarnNameInNote'] = true,
    ['DontShowPTCountdownText'] = false,
    ['EventSoundMusic'] = 'None',
    ['FilterInterruptNoteName'] = false,
    ['EventSoundMusicCombined'] = false,
    ['SpecialWarningFlash1'] = true,
    ['SpecialWarningFlashAlph3'] = 0.4,
    ['SpecialWarningVibrate3'] = true,
    ['FilterTInterruptCooldown'] = true,
    ['FilterTInterruptHealer'] = false,
    ['SpecialWarningSound2'] = 'Interface\\AddOns\\DBM-Core\\sounds\\ClassicSupport\\UR_Algalon_BHole01.ogg',
    ['InfoFramePoint'] = 'RIGHT',
    ['WarningFont'] = Private.GetMediaPath('font', Private.Font),
    ['OverrideBossSay'] = false,
    ['SpamSpecRoleswitch'] = false,
    ['SpecialWarningFlashCol2'] = {
      1, -- [1]
      0.5, -- [2]
      0, -- [3]
    },
    ['WarningAlphabetical'] = true,
    ['SpamSpecRoletaunt'] = false,
    ['ShowAllVersions'] = true,
    ['FilterBInterruptCooldown'] = true,
    ['CheckGear'] = true,
    ['ShowPizzaMessage'] = true,
    ['ShowGuildMessages'] = true,
    ['SpecialWarningX'] = -0.9999198317527771,
    ['WorldBossAlert'] = true,
    ['WarningPoint'] = 'TOP',
    ['DontShowTargetAnnouncements'] = true,
    ['DontShowPT2'] = false,
    ['FilterTrashWarnings2'] = true,
    ['LogCurrentMythicZero'] = false,
    ['SpamSpecInformationalOnly'] = false,
    ['WorldBuffAlert'] = true,
    ['HideTooltips'] = false,
    ['RangeFrameSound2'] = 'none',
    ['SpamSpecRoledispel'] = false,
    ['SpamSpecRoleinterrupt'] = false,
    ['ChosenVoicePack2'] = 'VEM',
    ['EventSoundEngage2'] = 'None',
    ['MoviesSeen'] = {},
    ['PullVoice'] = 'Corsica',
    ['ShowQueuePop'] = true,
    ['SpecialWarningFlashCol4'] = {
      1, -- [1]
      0, -- [2]
      1, -- [3]
    },
    ['SpecialWarningSound3'] = 'Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.ogg',
    ['SpamSpecRolesoak'] = false,
    ['ShowWarningsInChat'] = true,
    ['ChatFrame'] = 'DEFAULT_CHAT_FRAME',
    ['ShowReminders'] = true,
    ['SpecialWarningFontCol'] = {
      1, -- [1]
      0.7, -- [2]
      0, -- [3]
    },
    ['InfoFrameFontStyle'] = 'None',
    ['OverrideBossTimer'] = false,
    ['WarningFontStyle'] = 'OUTLINE',
    ['VPReplacesSA1'] = true,
    ['InfoFrameY'] = 191.8703308105469,
    ['SpecialWarningSound'] = 569200,
    ['WarningIconRight'] = true,
    ['UseSoundChannel'] = 'Master',
    ['LatencyThreshold'] = 250,
    ['WarningX'] = 0.9998323321342468,
    ['ShowRespawn'] = true,
    ['SpecialWarningFlashCount5'] = 3,
    ['InfoFrameLines'] = 0,
    ['DontAutoGossip'] = false,
    ['WorldBossNearAlert'] = false,
    ['LogCurrentRaids'] = true,
    ['DebugLevel'] = 1,
    ['LFDEnhance'] = true,
    ['VPReplacesSA3'] = true,
    ['BadTimerAlert'] = false,
    ['DontShowPTNoID'] = false,
    ['RangeFramePoint'] = 'LEFT',
    ['DontShowPTText'] = false,
    ['AlwaysShowSpeedKillTimer2'] = false,
    ['FilterDispel'] = true,
    ['SpecialWarningFontSize2'] = 23.02217864990234,
    ['ShowGuildMessagesPlus'] = false,
    ['VPReplacesGTFO'] = true,
    ['SpecialWarningFlashDura1'] = 0.3,
    ['LogCurrentMythicRaids'] = true,
    ['HideGarrisonToasts'] = true,
    ['ArrowPosY'] = -150,
    ['SpecialWarningFont'] = Private.GetMediaPath('font', Private.Font),
    ['SpecialWarningFontShadow'] = true,
    ['EventMusicMythicFilter'] = true,
    ['HideBossEmoteFrame2'] = true,
    ['DisableChatBubbles'] = false,
    ['NPAuraSize'] = 40,
    ['HideObjectivesFrame'] = true,
    ['SpecialWarningShortText'] = true,
    ['SpecialWarningFlashCol5'] = {
      0.2, -- [1]
      1, -- [2]
      1, -- [3]
    },
    ['DontShowEventTimers'] = false,
    ['FilterBInterruptHealer'] = false,
    ['SpecialWarningVibrate4'] = true,
    ['SWarnClassColor'] = true,
    ['DontShowSpecialWarningText'] = false,
    ['UseNameplateHandoff'] = true,
    ['SpecialWarningFlashDura3'] = 1,
    ['EventSoundPullTimer'] = 'None',
    ['DontShowRangeFrame'] = false,
    ['SpecialWarningVibrate2'] = false,
    ['AutoAcceptGuildInvite'] = false,
    ['SpecialWarningFlashAlph4'] = 0.4,
    ['VPReplacesCustom'] = false,
    ['DontShowTimersWithNameplates'] = true,
    ['PTCountThreshold2'] = 5,
    ['SpecialWarningFlashCount2'] = 1,
    ['VPReplacesAnnounce'] = true,
    ['EventSoundDungeonBGM'] = 'None',
    ['oRA3AnnounceConsumables'] = false,
    ['CountdownVoice2'] = 'Kolt',
    ['DisableRaidIcons'] = false,
    ['EnableWBSharing'] = true,
    ['ArrowPosX'] = 0,
    ['VPReplacesSA4'] = true,
    ['AITimer'] = true,
    ['LogTWDungeons'] = false,
    ['WarningShortText'] = true,
    ['SpecialWarningFlash4'] = true,
    ['DisableSFX'] = false,
    ['SpecialWarningSound4'] = 552035,
    ['AutologBosses'] = false,
    ['LogCurrentHeroic'] = false,
    ['DontShowTrashTimers'] = false,
    ['GUIX'] = 276,
    ['SpecialWarningFlashDura4'] = 0.7,
    ['WarningColors'] = {
      {
        ['r'] = 0.4117647409439087,
        ['g'] = 0.8000000715255737,
        ['b'] = 0.9411765336990356,
      }, -- [1]
      {
        ['r'] = 0.9490196704864502,
        ['g'] = 0.9490196704864502,
        ['b'] = 0,
      }, -- [2]
      {
        ['r'] = 1,
        ['g'] = 0.501960813999176,
        ['b'] = 0,
      }, -- [3]
      {
        ['r'] = 1,
        ['g'] = 0.1019607931375504,
        ['b'] = 0.1019607931375504,
      }, -- [4]
    },
    ['VPDontMuteSounds'] = false,
    ['SpecialWarningFlashCol3'] = {
      1, -- [1]
      0, -- [2]
      0, -- [3]
    },
    ['InfoFrameFontSize'] = 12,
    ['InfoFrameCols'] = 0,
    ['SWarningAlphabetical'] = true,
    ['AutoRespond'] = true,
    ['BlockNoteShare'] = false,
    ['RecordOnlyBosses'] = false,
    ['WarningFontSize'] = 18.70220565795898,
    ['DontPlaySpecialWarningSound'] = false,
    ['ModelSoundValue'] = 'Short',
    ['CountdownVoice3'] = 'Smooth',
    ['ShortTimerText'] = true,
    ['LogCurrentMPlus'] = true,
    ['SpecialWarningY'] = 303.9999694824219,
    ['ShowEngageMessage'] = true,
    ['VPReplacesSA2'] = true,
    ['ReplaceMyConfigOnOverride'] = false,
    ['MovieFilter2'] = 'Never',
    ['DontDoSpecialWarningVibrate'] = false,
    ['RaidWarningSound'] = 566558,
    ['DontRestoreRange'] = false,
    ['EventSoundVictory2'] = 'Interface\\AddOns\\DBM-Core\\sounds\\Victory\\SmoothMcGroove_Fanfare.ogg',
    ['SpecialWarningFlashCount3'] = 3,
    ['RoleSpecAlert'] = true,
    ['WhisperStats'] = false,
    ['SilentMode'] = false,
    ['LogOnlyNonTrivial'] = true,
    ['DontPlayPTCountdown'] = false,
    ['SpecialWarningFlashAlph5'] = 0.5,
    ['SpecialWarningDuration2'] = 1.5,
    ['DoNotLogLFG'] = true,
    ['GroupOptionsExcludeIcon'] = false,
    ['WarningIconLeft'] = true,
    ['RangeFrameLocked'] = false,
    ['SpecialWarningFlashDura2'] = 0.4,
    ['FilterTTargetFocus'] = true,
    ['SpamSpecRolegtfo'] = false,
    ['AutoExpandSpellGroups'] = true,
    ['LogTrivialRaids'] = false,
    ['GUIPoint'] = 'LEFT',
    ['SettingsMessageShown'] = true,
    ['SpecialWarningFlashDura5'] = 1,
    ['CustomSounds'] = 0,
    ['SpecialWarningVibrate1'] = false,
    ['LastRevision'] = 0,
    ['DontSetIcons'] = false,
    ['FilterBTargetFocus'] = true,
    ['RangeFrameSound1'] = 'none',
    ['CountdownVoice'] = 'Corsica',
    ['WarningY'] = -296.5001220703125,
    ['LogTrivialDungeons'] = false,
    ['DontShowUserTimers'] = false,
    ['RangeFrameUpdates'] = 'Average',
    ['DontShowInfoFrame'] = false,
    ['DisableStatusWhisper'] = false,
    ['EventDungMusicMythicFilter'] = true,
    ['GUIY'] = 15.99972438812256,
    ['RangeFrameFrames'] = 'radar',
    ['DontPlayCountdowns'] = false,
    ['OverrideBossIcon'] = false,
    ['SpecialWarningIcon'] = true,
    ['InfoFrameFont'] = Private.GetMediaPath('font', Private.Font),
    ['SpecialWarningFlashAlph1'] = 0.3,
    ['ShowDefeatMessage'] = true,
    ['FilterTankSpec'] = true,
    ['WarningDuration2'] = 1.5,
    ['NewsMessageShown2'] = 1,
    ['InfoFrameShowSelf'] = false,
    ['WarningFontShadow'] = true,
    ['SpecialWarningFlashCol1'] = {
      1, -- [1]
      1, -- [2]
      0, -- [3]
    },
    ['RLReadyCheckSound'] = true,
    ['DontShowBossTimers'] = false,
    ['SpecialWarningFontStyle'] = 'OUTLINE',
    ['DontShowSpecialWarningFlash'] = false,
    ['NoAnnounceOverride'] = true,
    ['AutoReplySound'] = true,
    ['DontSendBossGUIDs'] = false,
    ['DontShowBossAnnounces'] = false,
    ['BadIDAlert'] = false,
    ['EventSoundWipe'] = 'None',
    ['AutoAcceptFriendInvite'] = false,
    ['WarningIconChat'] = true,
    ['SpecialWarningFlashCount1'] = 1,
    ['HideGuildChallengeUpdates'] = true,
    ['SpecialWarningSound5'] = 554236,
    ['DontSendYells'] = false,
    ['SpecialWarningVibrate5'] = true,
    ['SpecialWarningFlash2'] = true,
    ['GUIHeight'] = 803.9998168945312,
    ['SpecialWarningFlash3'] = true,
    ['DisableGuildStatus'] = false,
    ['Enabled'] = true,
    ['DebugMode'] = false,
    ['GUIWidth'] = 824.9999389648438,
    ['FilterVoidFormSay'] = true,
    ['AdvancedAutologBosses'] = false,
    ['GroupOptionsBySpell'] = true,
    ['SpecialWarningPoint'] = 'CENTER',
    ['FakeBWVersion'] = false,
    ['StripServerName'] = true,
    ['DontPlayTrivialSpecialWarningSound'] = true,
    ['EnableModels'] = true,
    ['LogTWRaids'] = false,
    ['CoreSavedRevision'] = 20230711081027,
    ['InfoFrameLocked'] = false,
    ['NoTimerOverridee'] = true,
    ['HelpMessageVersion'] = 3,
    ['RangeFrameRadarPoint'] = 'CENTER',
  }

  DBT_AllPersistentOptions[merfinUI] = {
    ['AddOnSkins'] = {
      ['StartColorPR'] = 1,
      ['Scale'] = 1,
      ['HugeBarsEnabled'] = true,
      ['StartColorR'] = 1,
      ['EndColorPR'] = 0.5,
      ['Sort'] = 'Invert',
      ['ExpandUpwardsLarge'] = true,
      ['ExpandUpwards'] = true,
      ['EndColorDG'] = 0,
      ['Alpha'] = 1,
      ['StartColorIR'] = 0.47,
      ['DisableRightClick'] = true,
      ['StartColorUIR'] = 1,
      ['StartColorAG'] = 0.545,
      ['StartColorIG'] = 0.97,
      ['TDecimal'] = 11,
      ['StartColorRR'] = 0.5,
      ['StartColorUIG'] = 1,
      ['FillUpLargeBars'] = true,
      ['HugeScale'] = 1,
      ['BarYOffset'] = -1,
      ['StartColorDG'] = 0.3,
      ['StartColorAR'] = 0.375,
      ['TextColorR'] = 1,
      ['EndColorAER'] = 1,
      ['StartColorIB'] = 1,
      ['IconRight'] = false,
      ['Font'] = Private.GetMediaPath('font', Private.Font),
      ['EndColorB'] = 0,
      ['EndColorAEB'] = 0.247,
      ['HugeSort'] = 'Invert',
      ['BarXOffset'] = 0,
      ['NoBarFade'] = false,
      ['EndColorAR'] = 0.15,
      ['EndColorG'] = 0,
      ['EndColorDR'] = 1,
      ['StartColorDB'] = 1,
      ['StartColorAER'] = 1,
      ['FadeBars'] = true,
      ['TextColorB'] = 1,
      ['EndColorIB'] = 1,
      ['InlineIcons'] = true,
      ['StartColorAEG'] = 0.466,
      ['EndColorRB'] = 0.3,
      ['EndColorIR'] = 0.047,
      ['DynamicColor'] = true,
      ['EndColorRR'] = 0.11,
      ['Bar7ForceLarge'] = false,
      ['BarStyle'] = 'NoAnim',
      ['EnlargeBarTime'] = 11,
      ['Spark'] = false,
      ['StartColorDR'] = 0.9,
      ['StartColorRG'] = 1,
      ['FontFlag'] = 'OUTLINE',
      ['EndColorAB'] = 1,
      ['IconLocked'] = true,
      ['EndColorPG'] = 0.41,
      ['StartColorPG'] = 0.776,
      ['EndColorIG'] = 0.88,
      ['EndColorAEG'] = 0.043,
      ['EndColorDB'] = 1,
      ['StartColorAEB'] = 0.459,
      ['Texture'] = Private.GetMediaPath('statusbar', Private.GetProfileTexture()),
      ['TextColorG'] = 1,
      ['KeepBars'] = true,
      ['HugeAlpha'] = 1,
      ['ColorByType'] = true,
      ['IconLeft'] = true,
      ['EndColorUIG'] = 0.92156862745098,
      ['EndColorUIB'] = 0.0117647058823529,
      ['StartColorAB'] = 1,
      ['Bar7CustomInline'] = true,
      ['FillUpBars'] = true,
      ['DesaturateValue'] = 1,
      ['HugeBarYOffset'] = -1,
      ['FlashBar'] = false,
      ['EndColorUIR'] = 1,
      ['EndColorRG'] = 1,
      ['StartColorUIB'] = 0.0627450980392157,
      ['StartColorG'] = 0.7,
      ['EndColorPB'] = 0.285,
      ['EndColorR'] = 1,
      ['StartColorPB'] = 0.42,
      ['StartColorRB'] = 0.5,
      ['EndColorAG'] = 0.385,
      ['StartColorB'] = 0,
      ['HugeBarXOffset'] = 0,
      ['Skin'] = 'AddOnSkins',
      ['ClickThrough'] = false,
    },
  }

  if Private.GetProfileResolution() == 'QUAD_HD' then
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.HugeTimerX = layout == 'Healer' and 466 or 298
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.HugeTimerY = layout == 'Healer' and -220 or -183
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.HugeTimerPoint = 'CENTER'

    DBT_AllPersistentOptions[merfinUI].AddOnSkins.TimerX = layout == 'Healer' and -556 or 548
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.TimerY = layout == 'Healer' and -219 or -185
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.TimerPoint = layout == 'Healer' and 'RIGHT' or 'CENTER'

    DBT_AllPersistentOptions[merfinUI].AddOnSkins.Width = 200
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.Height = 23

    DBT_AllPersistentOptions[merfinUI].AddOnSkins.HugeWidth = 229
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.HugeHeight = 25

    DBT_AllPersistentOptions[merfinUI].AddOnSkins.FontSize = 13

    DBM_AllSavedOptions[merfinUI].RangeFrameX = 325.5723571777344
    DBM_AllSavedOptions[merfinUI].RangeFrameY = -37.76520538330078

    DBM_AllSavedOptions[merfinUI].RangeFrameRadarX = 268.9998168945313
    DBM_AllSavedOptions[merfinUI].RangeFrameRadarY = 147.1132659912109

    DBM_AllSavedOptions[merfinUI].InfoFrameX = 309
    DBM_AllSavedOptions[merfinUI].InfoFrameY = 299
    DBM_AllSavedOptions[merfinUI].InfoFramePoint = 'LEFT'
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.HugeTimerX = layout == 'Healer' and 386 or 288
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.HugeTimerY = layout == 'Healer' and -125 or -115
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.HugeTimerPoint = 'CENTER'

    DBT_AllPersistentOptions[merfinUI].AddOnSkins.TimerX = layout == 'Healer' and -362 or -459
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.TimerY = layout == 'Healer' and -125 or -116
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.TimerPoint = 'RIGHT'

    DBT_AllPersistentOptions[merfinUI].AddOnSkins.Width = 170
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.Height = 20

    DBT_AllPersistentOptions[merfinUI].AddOnSkins.HugeWidth = 190
    DBT_AllPersistentOptions[merfinUI].AddOnSkins.HugeHeight = 20

    DBT_AllPersistentOptions[merfinUI].AddOnSkins.FontSize = 12

    DBM_AllSavedOptions[merfinUI].RangeFrameX = 289.5726013183594
    DBM_AllSavedOptions[merfinUI].RangeFrameY = 35.2346076965332
    DBM_AllSavedOptions[merfinUI].RangeFramePoint = 'CENTER'

    DBM_AllSavedOptions[merfinUI].RangeFrameRadarX = 105
    DBM_AllSavedOptions[merfinUI].RangeFrameRadarY = 0

    DBM_AllSavedOptions[merfinUI].InfoFrameX = 241
    DBM_AllSavedOptions[merfinUI].InfoFrameY = 239
    DBM_AllSavedOptions[merfinUI].InfoFramePoint = 'LEFT'
  end

  DBM_UsedProfile = merfinUI

  Private:PluginInstallStepComplete('DBM')
end
