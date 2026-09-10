local addonName, Private = ...
local L = Private.L or {}
Private.L = L

-- Make missing translations available
setmetatable(L, {
  __index = function(self, key)
    self[key] = key or ''
    return key
  end,
})

L['Welcome to the installation for %s.'] = 'Welcome to the installation for %s.'
L['Skip Process'] = 'Skip Process'
L['Importance: |cff4beb2cOptional|r'] = 'Priority: |cff4beb2cOptional|r'
L['Importance: |cff4beb2cHigh|r'] = 'Priority: |cff4beb2cHigh|r'
L['Click the button to adjust the settings.'] = 'Click the button to adjust the settings.'
L['Welcome'] = 'Welcome'
L['Account Settings'] = 'Account Settings'
L['Chat Settings'] = 'Chat Settings'
L['Installation Complete'] = 'Installation Complete'
L['This installer contains profiles for various addons in MerfinUI.'] = 'This installer contains profiles for various addons in MerfinUI.'
L['Before starting the installation process, I highly recommend backing up your current WTF folder to preserve your existing settings, just in case.'] =
  'Before starting the installation process, I highly recommend backing up your current WTF folder to preserve your existing settings, just in case.'
L["Don't forget to click Finished in the final step. This will reload your UI and apply all the settings."] =
  "Don't forget to click Finished in the final step. This will reload your UI and apply all the settings."
L['The World of Warcraft game client stores all its configurations in console variables (CVars). These variables control various aspects of the game, including graphics, sound, and the user interface.'] =
  'The World of Warcraft game client stores all its configurations in console variables (CVars). These variables control various aspects of the game, including graphics, sound, and the user interface.'
L['This step also includes settings for addons like Questie and Leatrix.'] = 'This step also includes settings for addons like Questie and Leatrix.'
L['Load CVars'] = 'Load CVars'
L['This will set up the chat windows to look like this:\n\nGNL - Clog - LT - /W - LFG.'] = 'This will set up the chat windows to look like this:\n\nGNL - Clog - LT - /W - LFG.'
L['Setup Chat'] = 'Setup Chat'
L["Click the button below to apply the layout of your choice, depending on your role: DPS/Tank or Healer. Use Healer-H if you prefer horizontal party frames (similar to your raid frames). Choose Healer-V if you'd like your party frames to grow vertically. I personally prefer the vertical layout, but it's up to you!"] =
  "Click the button below to apply the layout of your choice, depending on your role: DPS/Tank or Healer. Use Healer-H if you prefer horizontal party frames (similar to your raid frames). Choose Healer-V if you'd like your party frames to grow vertically. I personally prefer the vertical layout, but it's up to you!"
L['You must have these plugins downloaded and enabled:\nAddOnSkins, ProjectAzilroka'] = 'You must have these plugins downloaded and enabled:\nAddOnSkins, ProjectAzilroka'
L['Normal Theme'] = 'Normal Theme'
L['Dark Theme'] = 'Dark Theme'
L['Here you can choose how to display Combat Text (damage, healing numbers, etc.). If you prefer the normal numbers above the mobs, click on Blizzard. If you prefer damage numbers to be stacked in one place, use xCT — either xCT DPS/Tank or xCT Healer, depending on your spec.'] =
  'Here you can choose how to display Combat Text (damage, healing numbers, etc.). If you prefer the normal numbers above the mobs, click on Blizzard. If you prefer damage numbers to be stacked in one place, use xCT — either xCT DPS/Tank or xCT Healer, depending on your spec.'
L['You have completed the installation process.'] = 'You have completed the installation process.'
L['You must click the button below to finalize the process and automatically reload your UI.'] =
  'You must click the button below to finalize the process and automatically reload your UI.'
L['Finished'] = 'Finished'
L['Install'] = 'Install'
L['Re-run the installation process.'] = 'Re-run the installation process.'
L['Action Bars'] = 'Action Bars'
L['Show Grid'] = 'Show Grid'
L['Show Empty cells'] = 'Show Empty cells'
L['Show Mouseover'] = 'Show Mouseover'
L['Fonts and Textures'] = 'Fonts and Textures'
L['Shortcut to general media settings.'] = 'Shortcut to general media settings.'
L['Action Bar Settings'] = 'Action Bar Settings'
L['Click the button below to open the Action Bars options, where you can configure additional settings.'] =
  'Click the button below to open the Action Bars options, where you can configure additional settings.'
L['Shortcut to action bars settings.'] = 'Shortcut to action bars settings.'
L['Media'] = 'Media'
L['Default Font'] = 'Default Font'
L['The font that the core of the UI will use.'] = 'The font that the core of the UI will use.'
L['Apply Font To All'] = 'Apply Font To All'
L['Applies the font and font size settings throughout the entire user interface. Note: Some font size settings may be skipped, as they use a smaller font size by default.'] =
  'Applies the font and font size settings throughout the entire user interface. Note: Some font size settings may be skipped, as they use a smaller font size by default.'
L['Default Texture'] = 'Default Texture'
L['The texture that the core of the UI will use.'] = 'The texture that the core of the UI will use.'
L['Apply Texture To All'] = 'Apply Texture To All'
L['Applies the texture across the entire user interface.'] = 'Applies the texture across the entire user interface.'
L['Color Theme'] = 'Color Theme'
L['Click on the button below to set color theme of ElvUI unit frames.\n- Normal Theme would enable class colorized frames;\n- Dark Theme would darken them and put Unit Names texts class colorized'] =
  'Click on the button below to set color theme of ElvUI unit frames.\n- Normal Theme would enable class colorized frames;\n- Dark Theme would darken them and put Unit Names texts class colorized'
L['Links'] = 'Links'
L['Nameplates (Plater)'] = 'Nameplates (Plater)'
L['Combat Text (xCT+)'] = 'Combat Text (xCT+)'
L['Profiles (ElvUI)'] = 'Profiles (ElvUI)'
L['Profile contains settings for Raid Cooldowns and Notes'] = 'Profile contains settings for Raid Cooldowns and Notes'
L['OmniCD is used to display the cooldowns of your party, divided into several categories: Self Defensives, CC, Interrupts, and Raid Defensives. Depending on the layout you choose, the placement of the panels will vary. Use the same layout that you selected in ElvUI.'] =
  'OmniCD is used to display the cooldowns of your party, divided into several categories: Self Defensives, CC, Interrupts, and Raid Defensives. Depending on the layout you choose, the placement of the panels will vary. Use the same layout that you selected in ElvUI.'
L["Choose DBM if you prefer to play with DBM, or BigWigs if you're a fan of that addon. You can skip this step if you're using my Raid Auras, as they already include everything needed for raids."] =
  "Choose DBM if you prefer to play with DBM, or BigWigs if you're a fan of that addon. You can skip this step if you're using my Raid Auras, as they already include everything needed for raids."
L['Profile Settings'] = 'Profile Settings'
L['Set Actual Version'] = 'Set Actual Version'
L['Actualize Profile Version'] = 'Actualize Profile Version'
L['Damage Meter (Details)'] = 'Damage Meter (Details)'
L['Boss Mods'] = 'Boss Mods'
L['Action Bars Visibility'] = 'Action Bars Visibility'
L['Click on the button to set action bars visibility.'] = 'Click on the button to set action bars visibility.'
L['Click on the button to set color theme.'] = 'Click on the button to set color theme.'
L['Cell is a standalone addon included in my AddOns pack. It’s a powerful raid frame addon inspired by some of the best—CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smoother and more intuitive experience than ever before.'] =
  'Cell is a standalone addon included in my AddOns pack. It’s a powerful raid frame addon inspired by some of the best—CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smoother and more intuitive experience than ever before.'
L['Apply a clean and minimalistic Details! profile for tracking damage, healing, and more.'] =
  'Apply a clean and minimalistic Details! profile for tracking damage, healing, and more.'
L['Apply my ElvUI layouts for DPS/Tank or Healer roles. Includes both horizontal and vertical layouts for party frames.'] =
  'Apply my ElvUI layouts for DPS/Tank or Healer roles. Includes both horizontal and vertical layouts for party frames.'
L['Apply my MRT profile with raid cooldowns and notes preconfigured.'] = 'Apply my MRT profile with raid cooldowns and notes preconfigured.'
L['Apply my Plater profile to improve nameplate visibility, customization, and performance.'] =
  'Apply my Plater profile to improve nameplate visibility, customization, and performance.'
L['Backdrop'] = 'Backdrop'
L['Choose Blizzard default combat text or xCT profiles for more compact and customizable numbers.'] =
  'Choose Blizzard default combat text or xCT profiles for more compact and customizable numbers.'
L['Choose DBM or BigWigs profiles made for raiding. Recommended if not using my Raid Auras.'] =
  'Choose DBM or BigWigs profiles made for raiding. Recommended if not using my Raid Auras.'
L['Choose between Cell or ElvUI raid frames and apply optimized layouts for raids and dungeons.'] =
  'Choose between Cell or ElvUI raid frames and apply optimized layouts for raids and dungeons.'
L['Combat Text'] = 'Combat Text'
L['Dead'] = 'Dead'
L['Details'] = 'Details'
L['Ignore Modules'] = 'Ignore Modules'
L['Installation Settings'] = 'Installation Settings'
L['Main'] = 'Primary'
L['Movers'] = 'Movers'
L['Player Castbar'] = 'Player Cast Bar'
L['Preferable Resolution'] = 'Preferable Resolution'
L['Profiles'] = 'Profiles'
L['Raid Frames'] = 'Raid Frames'
L['Re quick installation process.'] = 'Re quick installation process.'
L['Reset to Defaults'] = 'Reset to Defaults'
L['Set Default MerfinUI settings'] = 'Set Default MerfinUI settings'
L['Set important game and addon CVars to recommended values for better visuals, performance, and usability.'] =
  'Set important game and addon CVars to recommended values for better visuals, performance, and usability.'
L['Set up OmniCD to display party cooldowns (defensives, interrupts, raid CDs) with layouts matching your UI.'] =
  'Set up OmniCD to display party cooldowns (defensives, interrupts, raid CDs) with layouts matching your UI.'
L['Set up your chat windows with preconfigured tabs for general, combat log, whispers, and group content.'] =
  'Set up your chat windows with preconfigured tabs for general, combat log, whispers, and group content.'
L['Set your action bars to always show or appear on mouseover.'] = 'Set your action bars to always show or appear on mouseover.'
L['Show Always'] = 'Show Always'
L['Show the Player Cast Bar provided by ElvUI.'] = 'Show the Player Cast Bar provided by ElvUI.'
L['Switch between Normal and Dark color themes for the UI.'] = 'Switch between Normal and Dark color themes for the UI.'
L['UI Install'] = 'UI Install'
L['UI Quick Install'] = 'UI Quick Install'
L['Unit Frames'] = 'Unit Frames'
L['You can install the profile from this section as an alternative to the installer.'] = 'You can install the profile from this section as an alternative to the installer.'
L['Target Debuffs'] = 'Target Debuffs'
L['Enable or disable debuffs on the target frame.'] = 'Enable or disable debuffs on the target frame.'
L['Profile contains settings for Cooldown Manager Centered.'] = 'Profile contains settings for Cooldown Manager Centered.'
L['Profile contains settings for SenseiClassResourceBar.'] = 'Profile contains settings for SenseiClassResourceBar.'
L['Applies the Skyriding Bar profile for your selected layout.'] = 'Applies the Skyriding Bar profile for your selected layout.'
L['Profile contains settings for Simple Assisted Combat Icon.'] = 'Profile contains settings for Simple Assisted Combat Icon.'
L['Shows the same suggestions as the Single-Button-Assistant. Due to Blizzard changes, this is currently the only rotation helper possible (RIP Hekili). Helpful for learning your class/spec.'] =
  'Shows the same suggestions as the Single-Button-Assistant. Due to Blizzard changes, this is currently the only rotation helper possible (RIP Hekili). Helpful for learning your class/spec.'
L['%s import failed: %s'] = '%s import failed: %s'
L['%s installed.'] = '%s installed.'
L['%s is not available. Please enable it and reload your UI.'] = '%s is not available. Please enable it and reload your UI.'
L['%s profile installed.'] = '%s profile installed.'
L['%s profile installed: %s'] = '%s profile installed: %s'
L['%s profiles installed.'] = '%s profiles installed.'
L["ATM Classic Era/SoD doesn't support xCT."] = "ATM Classic Era/SoD doesn't support xCT."
L["ATM Classic Vanilla doesn't support xCT."] = "ATM Classic Vanilla doesn't support xCT."
L['Cell (DPS/Tank)'] = 'Cell (DPS/Tank)'
L['Cell (Healer)'] = 'Cell (Healer)'
L['Cell is a standalone addon included in my AddOns pack. It is a powerful raid frame addon inspired by CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smooth and intuitive experience.'] =
  'Cell is a standalone addon included in my AddOns pack. It is a powerful raid frame addon inspired by CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smooth and intuitive experience.'
L['Choose how combat text is displayed. Use Blizzard for default floating numbers, or xCT if you prefer compact scrolling damage and healing text.'] =
  'Choose how combat text is displayed. Use Blizzard for default floating numbers, or xCT if you prefer compact scrolling damage and healing text.'
L['Cooldown Manager'] = 'Cooldown Manager'
L['Cooldown Manager Centered'] = 'Cooldown Manager Centered'
L['Copied!'] = 'Copied!'
L['Current Layout: |cff00c0ff%s|r'] = 'Current Layout: |cff00c0ff%s|r'
L['Current Layout: |cff00ff00%s|r'] = 'Current Layout: |cff00ff00%s|r'
L['DPS/Tank'] = 'DPS/Tank'
L['Edit Mode'] = 'Edit Mode'
L['Edit Mode is not available.'] = 'Edit Mode is not available.'
L['ElvUI Frames'] = 'ElvUI Frames'
L['Healer'] = 'Healer'
L['Import or select the correct Edit Mode layout so chat and UI elements are positioned correctly.'] =
  'Import or select the correct Edit Mode layout so chat and UI elements are positioned correctly.'
L['Method Raid Tools'] = 'Method Raid Tools'
L['Open Edit Mode'] = 'Open Edit Mode'
L['Please make sure the correct profile is selected, or parts of the UI may be misplaced.'] =
  'Please make sure the correct profile is selected, or parts of the UI may be misplaced.'
L['Profile version was updated to v%s.'] = 'Profile version was updated to v%s.'
L['Quick Install'] = 'Quick Install'
L['Reload required. Continue?'] = 'Reload required. Continue?'
L['Sensei Class Resource Bar'] = 'Sensei Class Resource Bar'
L['Settings are applied directly to your Edit Mode profile.'] = 'Settings are applied directly to your Edit Mode profile.'
L['Show Import Buttons'] = 'Show Import Buttons'
L['Game Menu'] = 'Game Menu'
L['Show MerfinUI Button'] = 'Show MerfinUI Button'
L['Shows the MerfinUI button in the Game Menu.'] = 'Shows the MerfinUI button in the Game Menu.'
L['Shows import buttons next to the Cooldown Manager import window.'] = 'Shows import buttons next to the Cooldown Manager import window.'
L['Shows import buttons next to the Edit Mode import window.'] = 'Shows import buttons next to the Edit Mode import window.'
L['Skyriding Falcon'] = 'Skyriding Falcon'
L["This installer will quickly set up all addons and profiles (except for WeakAuras, as neither the full installer currently handles WeakAuras). With just one click, everything will be configured, followed by a reload at the end. If you're unsure, consider using the standard installer instead."] =
  "This installer will quickly set up all addons and profiles (except for WeakAuras, as neither the full installer currently handles WeakAuras). With just one click, everything will be configured, followed by a reload at the end. If you're unsure, consider using the standard installer instead."
L['Unknown'] = 'Unknown'
L['Welcome to the Quick installation for %s.'] = 'Welcome to the Quick installation for %s.'
L['You need to enable %s first.'] = 'You need to enable %s first.'
L['You need to enable %s to apply profile settings.'] = 'You need to enable %s to apply profile settings.'
L['You need to enable %s.'] = 'You need to enable %s.'
L['Edit Mode layout imported and saved as %s.'] = 'Edit Mode layout imported and saved as %s.'
L['Failed to import Edit Mode layout.'] = 'Failed to import Edit Mode layout.'
L['Class'] = 'Class'
L['Class Theme'] = 'Class Theme'
L['Dark'] = 'Dark'
L['Installation'] = 'Installation'
L['Quick Installation'] = 'Quick Installation'
L['Dark Theme Applied'] = 'Dark Theme Applied'
L['Normal Theme Applied'] = 'Normal Theme Applied'
L['Blizzard Combat Text'] = 'Blizzard Combat Text'
L['Socials'] = 'Socials'
L['AddOns'] = 'AddOns'
L['SUB CONTENT'] = 'SUB CONTENT'
L['WeakAuras Package'] = 'WeakAuras Package'
L['Aura packs and class content included with your subscription.'] =
  'Aura packs and class content included with your subscription.'
L['Class Auras, General Auras, Raid Packs, and more.'] = 'Class Auras, General Auras, Raid Packs, and more.'
