local Private = select(2, ...)
local L = Private.L
local E = unpack(ElvUI)
local Version = tostring(Private.Version)

local ReloadUI = ReloadUI
local format = string.format
local StopMusic = StopMusic

function Private:PluginInstallStepComplete(plugin)
  PluginInstallStepComplete:Hide()
  PluginInstallStepComplete.message = format(L['%s installed.'], plugin)
  PluginInstallStepComplete:Show()
end

function Private:InstallComplete()
  if GetCVarBool('Sound_EnableMusic') then
    StopMusic()
  end

  E.global.MUI.install_version = Version
  E.private.MUI.install_version = Version

  ReloadUI()
end

-- Full Installer
Private.InstallerData = {
  Title = format('|cff4beb2c%s %s|r', Private.Name, L['Installation']),
  Name = Private.Name,
  tutorialImage = 'Interface\\AddOns\\MerfinUI\\Media\\Textures\\logo_classic.png',

  Pages = {
    [1] = function()
      PluginInstallFrame.SubTitle:SetFormattedText(L['Welcome to the installation for %s.'], Private.Name .. ' ' .. Version)
      PluginInstallFrame.Desc1:SetText(L['This installer contains profiles for various addons in MerfinUI.'])
      PluginInstallFrame.Desc2:SetText(
        L['Before starting the installation process, I highly recommend backing up your current WTF folder to preserve your existing settings, just in case.']
      )
      PluginInstallFrame.Desc3:SetText(L["Don't forget to click Finished in the final step. This will reload your UI and apply all the settings."])
      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', Private.InstallComplete)
      PluginInstallFrame.Option1:SetText(L['Skip Process'])
    end,

    [2] = function()
      PluginInstallFrame.SubTitle:SetText(L['Account Settings'])
      PluginInstallFrame.Desc1:SetText(
        L['The World of Warcraft game client stores all its configurations in console variables (CVars). These variables control various aspects of the game, including graphics, sound, and the user interface.']
      )
      PluginInstallFrame.Desc2:SetText(L['This step also includes settings for addons like Questie and Leatrix.'])
      PluginInstallFrame.Desc3:SetText(L['Importance: |cff4beb2cHigh|r'])
      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', function()
        Private.Set_CVars()
      end)
      PluginInstallFrame.Option1:SetText(L['Load CVars'])
    end,

    [3] = function()
      PluginInstallFrame.SubTitle:SetText(L['Chat Settings'])
      PluginInstallFrame.Desc1:SetText(L['This will set up the chat windows to look like this:\n\nGNL - Clog - LT - /W - LFG.'])
      PluginInstallFrame.Desc2:SetText(L['Importance: |cff4beb2cOptional|r'])
      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', function()
        Private.SetupChat()
      end)
      PluginInstallFrame.Option1:SetText(L['Setup Chat'])
    end,

    [4] = function()
      PluginInstallFrame.SubTitle:SetText(L['Profiles (ElvUI)'])
      PluginInstallFrame.Desc1:SetText(
        L["Click the button below to apply the layout of your choice, depending on your role: DPS/Tank or Healer. Use Healer-H if you prefer horizontal party frames (similar to your raid frames). Choose Healer-V if you'd like your party frames to grow vertically. I personally prefer the vertical layout, but it's up to you!"]
      )
      PluginInstallFrame.Desc2:SetText(L['Importance: |cff4beb2cHigh|r'])
      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', function()
        Private.ImportElvUI('DPS/Tank')
      end)
      PluginInstallFrame.Option1:SetText('DPS/Tank')
      PluginInstallFrame.Option2:Show()
      PluginInstallFrame.Option2:SetScript('OnClick', function()
        Private.ImportElvUI('Healer-H')
      end)
      PluginInstallFrame.Option2:SetText('Healer-H')
      PluginInstallFrame.Option3:Show()
      PluginInstallFrame.Option3:SetScript('OnClick', function()
        Private.ImportElvUI('Healer-V')
      end)
      PluginInstallFrame.Option3:SetText('Healer-V')
    end,

    [5] = function()
      PluginInstallFrame.SubTitle:SetText(L['Raid Frames'])
      PluginInstallFrame.Desc1:SetText(
        L['Cell is a standalone addon included in my AddOns pack. It is a powerful raid frame addon inspired by CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smooth and intuitive experience.']
      )
      PluginInstallFrame.Desc2:SetText(L['Importance: |cff4beb2cHigh|r'])
      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', function()
        Private.ImportRaidFrames('Cell', 'DPS/Tank')
      end)
      PluginInstallFrame.Option1:SetText(L['Cell (DPS/Tank)'])

      PluginInstallFrame.Option2:Show()
      PluginInstallFrame.Option2:SetScript('OnClick', function()
        Private.ImportRaidFrames('Cell', 'Healer')
      end)
      PluginInstallFrame.Option2:SetText(L['Cell (Healer)'])

      PluginInstallFrame.Option3:Show()
      PluginInstallFrame.Option3:SetScript('OnClick', function()
        Private.ImportRaidFrames('ElvUI')
      end)
      PluginInstallFrame.Option3:SetText(L['ElvUI Frames'])
    end,

    [6] = function()
      PluginInstallFrame.SubTitle:SetText(L['Nameplates (Plater)'])
      PluginInstallFrame.Desc1:SetText(L['Click the button to adjust the settings.'])
      PluginInstallFrame.Desc2:SetText(L['Importance: |cff4beb2cHigh|r'])
      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', function()
        Private.ImportPlater()
      end)
      PluginInstallFrame.Option1:SetText('Plater')
    end,

    [7] = function()
      PluginInstallFrame.SubTitle:SetText(L['Damage Meter (Details)'])
      PluginInstallFrame.Desc1:SetText(L['Click the button to adjust the settings.'])
      PluginInstallFrame.Desc3:SetText(L['Importance: |cff4beb2cHigh|r'])
      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', function()
        Private.ImportDetails('DARK')
      end)
      PluginInstallFrame.Option1:SetText(L['Details'])
    end,

    [8] = function()
      PluginInstallFrame.SubTitle:SetText(L['Color Theme'])
      PluginInstallFrame.Desc1:SetText(L['Click on the button to set color theme.'])
      PluginInstallFrame.Desc3:SetText(L['Importance: |cff4beb2cOptional|r'])
      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', function()
        Private.ChangeTheme('DARK')
      end)
      PluginInstallFrame.Option1:SetText(L['Dark Theme'])
      PluginInstallFrame.Option2:Show()
      PluginInstallFrame.Option2:SetScript('OnClick', function()
        Private.ChangeTheme('NORMAL')
      end)
      PluginInstallFrame.Option2:SetText(L['Class Theme'])
    end,

    [9] = function()
      PluginInstallFrame.SubTitle:SetText(L['Action Bars Visibility'])
      PluginInstallFrame.Desc1:SetText(L['Click on the button to set action bars visibility.'])
      PluginInstallFrame.Desc3:SetText(L['Importance: |cff4beb2cOptional|r'])
      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', function()
        Private.ActionBarsVisibility(true)
      end)
      PluginInstallFrame.Option1:SetText(L['Show Always'])
      PluginInstallFrame.Option2:Show()
      PluginInstallFrame.Option2:SetScript('OnClick', function()
        Private.ActionBarsVisibility(false)
      end)
      PluginInstallFrame.Option2:SetText(L['Show Mouseover'])
    end,

    [10] = function()
      PluginInstallFrame.SubTitle:SetText(L['Boss Mods'])
      PluginInstallFrame.Desc1:SetText(
        L["Choose DBM if you prefer to play with DBM, or BigWigs if you're a fan of that addon. You can skip this step if you're using my Raid Auras, as they already include everything needed for raids."]
      )
      PluginInstallFrame.Desc2:SetText(L['Importance: |cff4beb2cHigh|r'])

      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', function()
        Private.ImportDBM('DPS/Tank')
      end)
      PluginInstallFrame.Option1:SetText('DBM DPS/Tank')

      PluginInstallFrame.Option2:Show()
      PluginInstallFrame.Option2:SetScript('OnClick', function()
        Private.ImportDBM('Healer')
      end)
      PluginInstallFrame.Option2:SetText('DBM Healer')

      PluginInstallFrame.Option3:Show()
      PluginInstallFrame.Option3:SetScript('OnClick', function()
        Private.ImportBigWigs()
      end)
      PluginInstallFrame.Option3:SetText('BigWigs')
    end,

    [11] = function()
      PluginInstallFrame.SubTitle:SetText(L['Combat Text'])
      PluginInstallFrame.Desc1:SetText(
        L['Choose how combat text is displayed. Use Blizzard for default floating numbers, or xCT if you prefer compact scrolling damage and healing text.']
      )
      PluginInstallFrame.Desc2:SetText(L["ATM Classic Era/SoD doesn't support xCT."])
      PluginInstallFrame.Desc3:SetText(L['Importance: |cff4beb2cHigh|r'])
      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', function()
        Private.Import_xCT('Blizzard')
      end)
      PluginInstallFrame.Option1:SetText('Blizzard')

      PluginInstallFrame.Option2:Show()
      PluginInstallFrame.Option2:SetScript('OnClick', function()
        Private.Import_xCT('DPS')
      end)
      PluginInstallFrame.Option2:SetText('xCT DPS')

      PluginInstallFrame.Option3:Show()
      PluginInstallFrame.Option3:SetScript('OnClick', function()
        Private.Import_xCT('Tank')
      end)
      PluginInstallFrame.Option3:SetText('xCT Tank')

      PluginInstallFrame.Option4:Show()
      PluginInstallFrame.Option4:SetScript('OnClick', function()
        Private.Import_xCT('Healer')
      end)
      PluginInstallFrame.Option4:SetText('xCT Healer')
    end,

    [12] = function()
      PluginInstallFrame.SubTitle:SetText(L['Method Raid Tools'])
      PluginInstallFrame.Desc1:SetText(L['Click the button to adjust the settings.'])
      PluginInstallFrame.Desc2:SetText(L['Profile contains settings for Raid Cooldowns and Notes'])
      PluginInstallFrame.Desc3:SetText(L['Importance: |cff4beb2cHigh|r'])
      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', function()
        Private.ImportMRT()
      end)
      PluginInstallFrame.Option1:SetText('MethodRaidTools')
    end,

    [13] = function()
      PluginInstallFrame.SubTitle:SetText(L['Installation Complete'])
      PluginInstallFrame.Desc1:SetText(L['You have completed the installation process.'])
      PluginInstallFrame.Desc2:SetText(L['You must click the button below to finalize the process and automatically reload your UI.'])
      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', Private.InstallComplete)
      PluginInstallFrame.Option1:SetText(L['Finished'])
    end,
  },

  StepTitles = {
    [1] = L['Welcome'],
    [2] = L['Account Settings'],
    [3] = L['Chat Settings'],
    [4] = L['Profiles (ElvUI)'],
    [5] = L['Raid Frames'],
    [6] = L['Nameplates (Plater)'],
    [7] = L['Damage Meter (Details)'],
    [8] = L['Color Theme'],
    [9] = L['Action Bars'],
    [10] = L['Boss Mods'],
    [11] = L['Combat Text (xCT+)'],
    [12] = 'Method Raid Tools',
    [13] = L['Installation Complete'],
  },

  StepTitlesColor = { 1, 1, 1 },
  StepTitlesColorSelected = { 0, 179 / 255, 1 },
  StepTitleWidth = 200,
  StepTitleButtonWidth = 180,
  StepTitleTextJustification = 'RIGHT',
}

-- Quick Installer
Private.QuickInstall = function(layout, theme)
  local roleLayout = (layout == 'Healer-H' or layout == 'Healer-V') and 'Healer' or layout
  local frameLayout = layout == 'Healer' and 'Healer-H' or layout

  Private.Set_CVars()
  Private.SetupChat()
  Private.ImportPlater()
  Private.ImportMRT()
  Private.ImportElvUI(frameLayout)
  Private.ImportDBM(roleLayout)

  if E:IsAddOnEnabled('xCT') then
    Private.Import_xCT(roleLayout)
  else
    Private.Import_xCT('Blizzard')
  end

  if E:IsAddOnEnabled('Cell') then
    Private.ImportRaidFrames('Cell', frameLayout)
  else
    Private.ImportRaidFrames('ElvUI')
  end

  Private.ChangeTheme(theme)

  Private:InstallComplete()
end

Private.InstallerQuick = {
  Title = format('|cff4beb2c%s %s|r', Private.Name, L['Quick Installation']),
  Name = Private.Name,
  tutorialImage = 'Interface\\AddOns\\MerfinUI\\Media\\Textures\\logo_classic.png',

  Pages = {
    [1] = function()
      PluginInstallFrame.SubTitle:SetFormattedText(L['Welcome to the Quick installation for %s.'], Private.Name .. ' ' .. Version)
      PluginInstallFrame.Desc1:SetText(
        L["This installer will quickly set up all addons and profiles (except for WeakAuras, as neither the full installer currently handles WeakAuras). With just one click, everything will be configured, followed by a reload at the end. If you're unsure, consider using the standard installer instead."]
      )
      PluginInstallFrame.Option1:Show()
      PluginInstallFrame.Option1:SetScript('OnClick', function()
        Private.QuickInstall('DPS/Tank', 'DARK')
      end)
      PluginInstallFrame.Option1:SetText(L['DPS/Tank'] .. ' ' .. L['Dark'])
      PluginInstallFrame.Option2:Show()
      PluginInstallFrame.Option2:SetScript('OnClick', function()
        Private.QuickInstall('Healer', 'DARK')
      end)
      PluginInstallFrame.Option2:SetText(L['Healer'] .. ' ' .. L['Dark'])
      PluginInstallFrame.Option3:Show()
      PluginInstallFrame.Option3:SetScript('OnClick', function()
        Private.QuickInstall('DPS/Tank', 'NORMAL')
      end)
      PluginInstallFrame.Option3:SetText(L['DPS/Tank'] .. ' ' .. L['Class'])
      PluginInstallFrame.Option4:Show()
      PluginInstallFrame.Option4:SetScript('OnClick', function()
        Private.QuickInstall('Healer', 'NORMAL')
      end)
      PluginInstallFrame.Option4:SetText(L['Healer'] .. ' ' .. L['Class'])
    end,
  },

  StepTitles = {
    [1] = L['Quick Install'],
  },

  StepTitlesColor = { 1, 1, 1 },
  StepTitlesColorSelected = { 0, 179 / 255, 1 },
  StepTitleWidth = 200,
  StepTitleButtonWidth = 180,
  StepTitleTextJustification = 'RIGHT',
}
