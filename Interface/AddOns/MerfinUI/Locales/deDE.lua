local addonName, Private = ...
local L = Private.L or {}
Private.L = L

if (GAME_LOCALE or GetLocale()) ~= 'deDE' then
  return
end

L['Welcome to the installation for %s.'] = 'Willkommen bei der Installation für %s.'
L['Skip Process'] = 'Prozess überspringen'
L['Importance: |cff4beb2cOptional|r'] = 'Wichtigkeit: |cff4beb2cOptional|r'
L['Importance: |cff4beb2cHigh|r'] = 'Wichtigkeit: |cff4beb2cHoch|r'
L['Click the button to adjust the settings.'] = 'Klicken Sie auf die Schaltfläche, um die Einstellungen anzupassen.'
L['Welcome'] = 'Willkommen'
L['Account Settings'] = 'Kontoeinstellungen'
L['Chat Settings'] = 'Chat-Einstellungen'
L['Installation Complete'] = 'Installation abgeschlossen'
L['This installer contains profiles for various addons in MerfinUI.'] = 'Dieses Installationsprogramm enthält Profile für verschiedene Add-ons in MerfinUI.'
L['Before starting the installation process, I highly recommend backing up your current WTF folder to preserve your existing settings, just in case.'] =
  'Bevor Sie mit der Installation beginnen, empfehle ich Ihnen dringend, Ihren aktuellen WTF-Ordner zu sichern, um für alle Fälle Ihre vorhandenen Einstellungen beizubehalten.'
L["Don't forget to click Finished in the final step. This will reload your UI and apply all the settings."] =
  'Vergessen Sie nicht, im letzten Schritt auf „Fertig“ zu klicken. Dadurch wird Ihr UI neu geladen und alle Einstellungen übernommen.'
L['The World of Warcraft game client stores all its configurations in console variables (CVars). These variables control various aspects of the game, including graphics, sound, and the user interface.'] =
  'Der World of Warcraft-Spielclient speichert alle seine Konfigurationen in Konsolenvariablen (CVars). Diese Variablen steuern verschiedene Aspekte des Spiels, einschließlich Grafik, Sound und Benutzeroberfläche.'
L['This step also includes settings for addons like Questie and Leatrix.'] = 'Dieser Schritt umfasst auch Einstellungen für Add-ons wie Questie und Leatrix.'
L['Load CVars'] = 'Laden Sie CVars'
L['This will set up the chat windows to look like this:\n\nGNL - Clog - LT - /W - LFG.'] =
  'Dadurch werden die Chatfenster so eingerichtet, dass sie wie folgt aussehen:\n\nGNL - Clog - LT - /W - LFG.'
L['Setup Chat'] = 'Chat einrichten'
L["Click the button below to apply the layout of your choice, depending on your role: DPS/Tank or Healer. Use Healer-H if you prefer horizontal party frames (similar to your raid frames). Choose Healer-V if you'd like your party frames to grow vertically. I personally prefer the vertical layout, but it's up to you!"] =
  'Klicken Sie auf die Schaltfläche unten, um je nach Rolle das Layout Ihrer Wahl anzuwenden: DPS/Tank oder Healer. Verwenden Sie Healer-H, wenn Sie horizontale Gruppenrahmen bevorzugen (ähnlich wie Ihre Raidframes). Wählen Sie Healer-V, wenn Sie möchten, dass Ihre Partyrahmen vertikal wachsen. Ich persönlich bevorzuge die vertikale Anordnung, aber es liegt an Ihnen!'
L['You must have these plugins downloaded and enabled:\nAddOnSkins, ProjectAzilroka'] =
  'Sie müssen diese Plugins heruntergeladen und aktiviert haben:\nAddOnSkins, ProjectAzilroka'
L['Normal Theme'] = 'Normales Design'
L['Dark Theme'] = 'Dunkles Design'
L['Here you can choose how to display Combat Text (damage, healing numbers, etc.). If you prefer the normal numbers above the mobs, click on Blizzard. If you prefer damage numbers to be stacked in one place, use xCT — either xCT DPS/Tank or xCT Healer, depending on your spec.'] =
  'Hier können Sie auswählen, wie der Kampftext angezeigt werden soll (Schaden, Heilungszahlen usw.). Wenn Sie die normalen Zahlen gegenüber den Mobs bevorzugen, klicken Sie auf Blizzard. Wenn Sie es vorziehen, dass die Schadenszahlen an einem Ort gestapelt werden, verwenden Sie xCT – entweder xCT DPS/Tank oder xCT Healer, abhängig von Ihrer Spezifikation.'
L['You have completed the installation process.'] = 'Sie haben den Installationsvorgang abgeschlossen.'
L['You must click the button below to finalize the process and automatically reload your UI.'] =
  'Sie müssen auf die Schaltfläche unten klicken, um den Vorgang abzuschließen und Ihr UI automatisch neu zu laden.'
L['Finished'] = 'Fertig'
L['Install'] = 'Installieren'
L['Re-run the installation process.'] = 'Führen Sie den Installationsvorgang erneut aus.'
L['Action Bars'] = 'Aktionsleisten'
L['Show Grid'] = 'Raster anzeigen'
L['Show Empty cells'] = 'Leere Zellen anzeigen'
L['Show Mouseover'] = 'Mouseover anzeigen'
L['Fonts and Textures'] = 'Schriftarten und Texturen'
L['Shortcut to general media settings.'] = 'Verknüpfung zu allgemeinen Medieneinstellungen.'
L['Action Bar Settings'] = 'Einstellungen der Aktionsleiste'
L['Click the button below to open the Action Bars options, where you can configure additional settings.'] =
  'Klicken Sie auf die Schaltfläche unten, um die Aktionsleistenoptionen zu öffnen, in denen Sie zusätzliche Einstellungen konfigurieren können.'
L['Shortcut to action bars settings.'] = 'Verknüpfung zu den Einstellungen der Aktionsleisten.'
L['Media'] = 'Medien'
L['Default Font'] = 'Standardschriftart'
L['The font that the core of the UI will use.'] = 'Die Schriftart, die der Kern des UI verwendet.'
L['Apply Font To All'] = 'Schriftart auf alle anwenden'
L['Applies the font and font size settings throughout the entire user interface. Note: Some font size settings may be skipped, as they use a smaller font size by default.'] =
  'Wendet die Schriftart- und Schriftgrößeneinstellungen auf die gesamte Benutzeroberfläche an. Hinweis: Einige Einstellungen für die Schriftgröße werden möglicherweise übersprungen, da sie standardmäßig eine kleinere Schriftgröße verwenden.'
L['Default Texture'] = 'Standardtextur'
L['The texture that the core of the UI will use.'] = 'Die Textur, die der Kern des UI verwenden wird.'
L['Apply Texture To All'] = 'Textur auf alle anwenden'
L['Applies the texture across the entire user interface.'] = 'Wendet die Textur auf die gesamte Benutzeroberfläche an.'
L['Color Theme'] = 'Farbthema'
L['Click on the button below to set color theme of ElvUI unit frames.\n- Normal Theme would enable class colorized frames;\n- Dark Theme would darken them and put Unit Names texts class colorized'] =
  'Klicken Sie auf die Schaltfläche unten, um das Farbthema der ElvUI-Einheitsrahmen festzulegen.\n- Normales Design würde klassenkolorierte Rahmen ermöglichen;\n- Dunkles Design würde sie verdunkeln und die Klassentexte der Einheitennamen einfärben'
L['Links'] = 'Links'
L['Nameplates (Plater)'] = 'Typenschilder (Plater)'
L['Combat Text (xCT+)'] = 'Kampftext (xCT+)'
L['Profiles (ElvUI)'] = 'Profile (ElvUI)'
L['Profile contains settings for Raid Cooldowns and Notes'] = 'Das Profil enthält Einstellungen für Raid-Abklingzeiten und Notizen'
L['OmniCD is used to display the cooldowns of your party, divided into several categories: Self Defensives, CC, Interrupts, and Raid Defensives. Depending on the layout you choose, the placement of the panels will vary. Use the same layout that you selected in ElvUI.'] =
  'OmniCD wird verwendet, um die Abklingzeiten Ihrer Gruppe anzuzeigen, unterteilt in mehrere Kategorien: Selbstverteidigung, CC, Unterbrechungen und Raid-Verteidigung. Abhängig vom gewählten Layout variiert die Platzierung der Paneele. Verwenden Sie dasselbe Layout, das Sie in ElvUI ausgewählt haben.'
L["Choose DBM if you prefer to play with DBM, or BigWigs if you're a fan of that addon. You can skip this step if you're using my Raid Auras, as they already include everything needed for raids."] =
  'Wählen Sie DBM, wenn Sie lieber mit DBM spielen möchten, oder BigWigs, wenn Sie ein Fan dieses Add-ons sind. Du kannst diesen Schritt überspringen, wenn du meine Raid-Auren verwendest, da diese bereits alles enthalten, was du für Raids benötigst.'
L['Profile Settings'] = 'Profileinstellungen'
L['Set Actual Version'] = 'Aktuelle Version festlegen'
L['Actualize Profile Version'] = 'Profilversion aktualisieren'
L['Damage Meter (Details)'] = 'Schadensanzeige (Details)'
L['Boss Mods'] = 'Boss-Mods'
L['Action Bars Visibility'] = 'Sichtbarkeit der Aktionsleisten'
L['Click on the button to set action bars visibility.'] = 'Klicken Sie auf die Schaltfläche, um die Sichtbarkeit der Aktionsleisten festzulegen.'
L['Click on the button to set color theme.'] = 'Klicken Sie auf die Schaltfläche, um das Farbthema festzulegen.'
L['Cell is a standalone addon included in my AddOns pack. It’s a powerful raid frame addon inspired by some of the best—CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smoother and more intuitive experience than ever before.'] =
  'Cell ist ein eigenständiges Raidframe-Addon aus meinem AddOns-Paket. Inspiriert von CompactRaid, Grid2, Aptechka und VuhDo bietet es übersichtliche und reaktionsschnelle Gruppenframes.'
L['Apply a clean and minimalistic Details! profile for tracking damage, healing, and more.'] =
  'Wenden Sie ein klares und minimalistisches Details!-Profil an, um Schäden, Heilung und mehr zu verfolgen.'
L['Apply my ElvUI layouts for DPS/Tank or Healer roles. Includes both horizontal and vertical layouts for party frames.'] =
  'Wenden Sie meine ElvUI-Layouts für die Rollen DPS/Tank oder Healer an. Enthält sowohl horizontale als auch vertikale Layouts für Partyrahmen.'
L['Apply my MRT profile with raid cooldowns and notes preconfigured.'] = 'Wende mein MRT-Profil mit vorkonfigurierten Raid-Abklingzeiten und Notizen an.'
L['Apply my Plater profile to improve nameplate visibility, customization, and performance.'] =
  'Wenden Sie mein Plater-Profil an, um die Sichtbarkeit, Anpassung und Leistung des Typenschilds zu verbessern.'
L['Backdrop'] = 'Hintergrund'
L['Choose Blizzard default combat text or xCT profiles for more compact and customizable numbers.'] =
  'Wählen Sie Blizzard-Standardkampftext oder xCT-Profile für kompaktere und anpassbarere Zahlen.'
L['Choose DBM or BigWigs profiles made for raiding. Recommended if not using my Raid Auras.'] =
  'Wählen Sie DBM- oder BigWigs-Profile für Raids. Empfohlen, wenn ich meine Raid-Auras nicht verwende.'
L['Choose between Cell or ElvUI raid frames and apply optimized layouts for raids and dungeons.'] =
  'Wählen Sie zwischen Cell- oder ElvUI-Raid-Frames und wenden Sie optimierte Layouts für Raids und Dungeons an.'
L['Combat Text'] = 'Kampftext'
L['Dead'] = 'Tot'
L['Details'] = 'Details'
L['Ignore Modules'] = 'Module ignorieren'
L['Installation Settings'] = 'Installationseinstellungen'
L['Main'] = 'Primär'
L['Movers'] = 'Mover'
L['Player Castbar'] = 'Spieler-Zauberleiste'
L['Preferable Resolution'] = 'Bevorzugte Auflösung'
L['Profiles'] = 'Profile'
L['Raid Frames'] = 'Raidframes'
L['Re quick installation process.'] = 'Nochmals schneller Installationsprozess.'
L['Reset to Defaults'] = 'Auf Standardeinstellungen zurücksetzen'
L['Set Default MerfinUI settings'] = 'Legen Sie die Standardeinstellungen für MerfinUI fest'
L['Set important game and addon CVars to recommended values for better visuals, performance, and usability.'] =
  'Stellen Sie wichtige Spiele und Add-ons CVars auf die empfohlenen Werte ein, um eine bessere Grafik, Leistung und Benutzerfreundlichkeit zu erzielen.'
L['Set up OmniCD to display party cooldowns (defensives, interrupts, raid CDs) with layouts matching your UI.'] =
  'Richten Sie OmniCD ein, um Gruppen-Abklingzeiten (Verteidigung, Unterbrechungen, Raid-CDs) mit Layouts anzuzeigen, die zu Ihrem UI passen.'
L['Set up your chat windows with preconfigured tabs for general, combat log, whispers, and group content.'] =
  'Richten Sie Ihre Chat-Fenster mit vorkonfigurierten Registerkarten für Allgemein, Kampfprotokoll, Flüsternachrichten und Gruppeninhalte ein.'
L['Set your action bars to always show or appear on mouseover.'] = 'Stellen Sie Ihre Aktionsleisten so ein, dass sie beim Mouseover immer angezeigt oder angezeigt werden.'
L['Show Always'] = 'Immer anzeigen'
L['Show the Player Cast Bar provided by ElvUI.'] = 'Zeigen Sie die von ElvUI bereitgestellte Player-Cast-Leiste an.'
L['Switch between Normal and Dark color themes for the UI.'] = 'Wechseln Sie zwischen den Farbthemen „Normal“ und „Dunkel“ für den UI.'
L['UI Install'] = 'UI Installieren'
L['UI Quick Install'] = 'UI Schnellinstallation'
L['Unit Frames'] = 'Einheitenrahmen'
L['You can install the profile from this section as an alternative to the installer.'] =
  'Alternativ zum Installationsprogramm können Sie das Profil in diesem Abschnitt installieren.'
L['Target Debuffs'] = 'Ziel-Debuffs'
L['Enable or disable debuffs on the target frame.'] = 'Debuffs für den Ziel-Frame aktivieren oder deaktivieren.'
L['Profile contains settings for Cooldown Manager Centered.'] = 'Das Profil enthält Einstellungen für Cooldown Manager Centered.'
L['Profile contains settings for SenseiClassResourceBar.'] = 'Das Profil enthält Einstellungen für SenseiClassResourceBar.'
L['Applies the Skyriding Bar profile for your selected layout.'] = 'Wendet das Skyriding Bar-Profil für Ihr ausgewähltes Layout an.'
L['Profile contains settings for Simple Assisted Combat Icon.'] = 'Das Profil enthält Einstellungen für Simple Assisted Combat Icon.'
L['Shows the same suggestions as the Single-Button-Assistant. Due to Blizzard changes, this is currently the only rotation helper possible (RIP Hekili). Helpful for learning your class/spec.'] =
  'Zeigt die gleichen Vorschläge wie Single-Button-Assistant. Aufgrund von Blizzard-Änderungen ist dies derzeit der einzig mögliche Rotationshelfer (RIP Hekili). Hilfreich beim Erlernen Ihrer Klasse/Spezifikation.'
L['%s import failed: %s'] = '%s-Import fehlgeschlagen: %s'
L['%s installed.'] = '%s installiert.'
L['%s is not available. Please enable it and reload your UI.'] = '%s ist nicht verfügbar. Bitte aktivieren Sie es und laden Sie Ihr UI neu.'
L['%s profile installed.'] = '%s-Profil installiert.'
L['%s profile installed: %s'] = 'Installiertes %s-Profil: %s'
L['%s profiles installed.'] = '%s-Profile installiert.'
L["ATM Classic Era/SoD doesn't support xCT."] = 'ATM Classic Era/SoD unterstützt xCT nicht.'
L["ATM Classic Vanilla doesn't support xCT."] = 'ATM Classic Vanilla unterstützt xCT nicht.'
L['Cell (DPS/Tank)'] = 'Cell (DPS/Tank)'
L['Cell (Healer)'] = 'Cell (Healer)'
L['Cell is a standalone addon included in my AddOns pack. It is a powerful raid frame addon inspired by CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smooth and intuitive experience.'] =
  'Cell ist ein eigenständiges Raidframe-Addon aus meinem AddOns-Paket. Inspiriert von CompactRaid, Grid2, Aptechka und VuhDo bietet es übersichtliche und reaktionsschnelle Gruppenframes.'
L['Choose how combat text is displayed. Use Blizzard for default floating numbers, or xCT if you prefer compact scrolling damage and healing text.'] =
  'Wählen Sie, wie Kampftext angezeigt wird. Verwenden Sie Blizzard für Standard-Floating-Zahlen oder xCT, wenn Sie kompakten Scroll-Schadens- und Heilungstext bevorzugen.'
L['Cooldown Manager'] = 'Cooldown Manager'
L['Cooldown Manager Centered'] = 'Cooldown Manager Centered'
L['Copied!'] = 'Kopiert!'
L['Current Layout: |cff00c0ff%s|r'] = 'Aktuelles Layout: |cff00c0ff%s|r'
L['Current Layout: |cff00ff00%s|r'] = 'Aktuelles Layout: |cff00ff00%s|r'
L['DPS/Tank'] = 'DPS/Tank'
L['Edit Mode'] = 'Bearbeitungsmodus'
L['Edit Mode is not available.'] = 'Der Bearbeitungsmodus ist nicht verfügbar.'
L['ElvUI Frames'] = 'ElvUI-Frames'
L['Healer'] = 'Healer'
L['Import or select the correct Edit Mode layout so chat and UI elements are positioned correctly.'] =
  'Importieren Sie das richtige Bearbeitungsmodus-Layout oder wählen Sie es aus, damit Chat- und UI-Elemente richtig positioniert sind.'
L['Method Raid Tools'] = 'Method Raid Tools'
L['Open Edit Mode'] = 'Öffnen Sie den Bearbeitungsmodus'
L['Please make sure the correct profile is selected, or parts of the UI may be misplaced.'] =
  'Bitte stellen Sie sicher, dass das richtige Profil ausgewählt ist, da sonst Teile des UI möglicherweise verlegt werden.'
L['Profile version was updated to v%s.'] = 'Die Profilversion wurde auf v%s aktualisiert.'
L['Quick Install'] = 'Schnelle Installation'
L['Reload required. Continue?'] = 'Neuladen erforderlich. Weitermachen?'
L['Sensei Class Resource Bar'] = 'Sensei Class Resource Bar'
L['Settings are applied directly to your Edit Mode profile.'] = 'Die Einstellungen werden direkt auf Ihr Bearbeitungsmodus-Profil angewendet.'
L['Show Import Buttons'] = 'Schaltflächen zum Importieren anzeigen'
L['Game Menu'] = 'Spielmenü'
L['Show MerfinUI Button'] = 'MerfinUI-Button anzeigen'
L['Shows the MerfinUI button in the Game Menu.'] = 'Zeigt den MerfinUI-Button im Spielmenü an.'
L['Shows import buttons next to the Cooldown Manager import window.'] = 'Zeigt Importschaltflächen neben dem Cooldown Manager-Importfenster an.'
L['Shows import buttons next to the Edit Mode import window.'] = 'Zeigt Importschaltflächen neben dem Importfenster im Bearbeitungsmodus an.'
L['Skyriding Falcon'] = 'Skyriding Falcon'
L["This installer will quickly set up all addons and profiles (except for WeakAuras, as neither the full installer currently handles WeakAuras). With just one click, everything will be configured, followed by a reload at the end. If you're unsure, consider using the standard installer instead."] =
  'Dieses Installationsprogramm richtet schnell alle Add-ons und Profile ein (mit Ausnahme von WeakAuras, da derzeit keines der vollständigen Installationsprogramme WeakAuras unterstützt). Mit nur einem Klick ist alles konfiguriert und am Ende erfolgt ein Neuladen. Wenn Sie sich nicht sicher sind, sollten Sie stattdessen das Standardinstallationsprogramm verwenden.'
L['Unknown'] = 'Unbekannt'
L['Welcome to the Quick installation for %s.'] = 'Willkommen zur Schnellinstallation für %s.'
L['You need to enable %s first.'] = 'Sie müssen zuerst %s aktivieren.'
L['You need to enable %s to apply profile settings.'] = 'Sie müssen %s aktivieren, um Profileinstellungen anzuwenden.'
L['You need to enable %s.'] = 'Sie müssen %s aktivieren.'
L['Edit Mode layout imported and saved as %s.'] = 'Das Layout im Bearbeitungsmodus wurde importiert und als %s gespeichert.'
L['Failed to import Edit Mode layout.'] = 'Der Import des Bearbeitungsmodus-Layouts ist fehlgeschlagen.'
L['Class'] = 'Klasse'
L['Class Theme'] = 'Klassendesign'
L['Dark'] = 'Dunkel'
L['Installation'] = 'Installation'
L['Quick Installation'] = 'Schnelle Installation'
L['Dark Theme Applied'] = 'Dunkles Design angewendet'
L['Normal Theme Applied'] = 'Normales Design angewendet'
L['Blizzard Combat Text'] = 'Blizzard Kampftext'
L['Socials'] = 'Soziale Netzwerke'
L['AddOns'] = 'AddOns'
L['SUB CONTENT'] = 'ABO-INHALT'
L['WeakAuras Package'] = 'WeakAuras-Paket'
L['Aura packs and class content included with your subscription.'] =
  'Aura-Pakete und Klasseninhalte sind in deinem Abonnement enthalten.'
L['Class Auras, General Auras, Raid Packs, and more.'] =
  'Klassen-Auren, allgemeine Auren, Raid-Pakete und mehr.'
