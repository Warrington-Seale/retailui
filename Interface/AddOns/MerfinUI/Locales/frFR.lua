local addonName, Private = ...
local L = Private.L or {}
Private.L = L

if (GAME_LOCALE or GetLocale()) ~= 'frFR' then
  return
end

L['Welcome to the installation for %s.'] = "Bienvenue dans l'installation de %s."
L['Skip Process'] = 'Ignorer le processus'
L['Importance: |cff4beb2cOptional|r'] = 'Priorité : |cff4beb2cOptionnelle|r'
L['Importance: |cff4beb2cHigh|r'] = 'Priorité : |cff4beb2cÉlevée|r'
L['Click the button to adjust the settings.'] = 'Cliquez sur le bouton pour ajuster les paramètres.'
L['Welcome'] = 'Bienvenue'
L['Account Settings'] = 'Paramètres du compte'
L['Chat Settings'] = 'Paramètres de discussion'
L['Installation Complete'] = 'Installation terminée'
L['This installer contains profiles for various addons in MerfinUI.'] = "Ce programme d'installation contient des profils pour divers modules complémentaires dans MerfinUI."
L['Before starting the installation process, I highly recommend backing up your current WTF folder to preserve your existing settings, just in case.'] =
  "Avant de commencer le processus d'installation, je vous recommande fortement de sauvegarder votre dossier WTF actuel pour conserver vos paramètres existants, juste au cas où."
L["Don't forget to click Finished in the final step. This will reload your UI and apply all the settings."] =
  "N'oubliez pas de cliquer sur Terminé à la dernière étape. Cela rechargera votre UI et appliquera tous les paramètres."
L['The World of Warcraft game client stores all its configurations in console variables (CVars). These variables control various aspects of the game, including graphics, sound, and the user interface.'] =
  "Le client de jeu World of Warcraft stocke toutes ses configurations dans des variables de console (CVars). Ces variables contrôlent divers aspects du jeu, notamment les graphismes, le son et l'interface utilisateur."
L['This step also includes settings for addons like Questie and Leatrix.'] =
  'Cette étape inclut également les paramètres des modules complémentaires tels que Questie et Leatrix.'
L['Load CVars'] = 'Charger CVars'
L['This will set up the chat windows to look like this:\n\nGNL - Clog - LT - /W - LFG.'] =
  'Cela configurera les fenêtres de discussion pour ressembler à ceci:\n\nGNL - Clog - LT - /W - LFG.'
L['Setup Chat'] = 'Configurer le chat'
L["Click the button below to apply the layout of your choice, depending on your role: DPS/Tank or Healer. Use Healer-H if you prefer horizontal party frames (similar to your raid frames). Choose Healer-V if you'd like your party frames to grow vertically. I personally prefer the vertical layout, but it's up to you!"] =
  "Cliquez sur le bouton ci-dessous pour appliquer la mise en page de votre choix, selon votre rôle: DPS/Tank ou Healer. Utilisez Healer-H si vous préférez les cadres de groupe horizontaux (similaires à vos cadres de raid). Choisissez Healer-V si vous souhaitez que les cadres de votre fête s'agrandissent verticalement. Personnellement, je préfère la disposition verticale, mais c'est à vous de décider!"
L['You must have these plugins downloaded and enabled:\nAddOnSkins, ProjectAzilroka'] = 'Vous devez avoir téléchargé et activé ces plugins:\nAddOnSkins, ProjectAzilroka'
L['Normal Theme'] = 'Thème normal'
L['Dark Theme'] = 'Thème sombre'
L['Here you can choose how to display Combat Text (damage, healing numbers, etc.). If you prefer the normal numbers above the mobs, click on Blizzard. If you prefer damage numbers to be stacked in one place, use xCT — either xCT DPS/Tank or xCT Healer, depending on your spec.'] =
  'Ici, vous pouvez choisir comment afficher le texte de combat (dégâts, chiffres de guérison, etc.). Si vous préférez les nombres normaux au-dessus des mobs, cliquez sur Blizzard. Si vous préférez que les numéros de dégâts soient empilés au même endroit, utilisez xCT – soit xCT DPS/Tank ou xCT Healer, selon vos spécifications.'
L['You have completed the installation process.'] = "Vous avez terminé le processus d'installation."
L['You must click the button below to finalize the process and automatically reload your UI.'] =
  'Vous devez cliquer sur le bouton ci-dessous pour finaliser le processus et recharger automatiquement votre UI.'
L['Finished'] = 'Terminé'
L['Install'] = 'Installer'
L['Re-run the installation process.'] = "Réexécutez le processus d'installation."
L['Action Bars'] = "Barres d'action"
L['Show Grid'] = 'Afficher la grille'
L['Show Empty cells'] = 'Afficher les cellules vides'
L['Show Mouseover'] = 'Afficher le survol de la souris'
L['Fonts and Textures'] = 'Polices et textures'
L['Shortcut to general media settings.'] = 'Raccourci vers les paramètres généraux des médias.'
L['Action Bar Settings'] = "Paramètres de la barre d'action"
L['Click the button below to open the Action Bars options, where you can configure additional settings.'] =
  "Cliquez sur le bouton ci-dessous pour ouvrir les options des barres d'action, où vous pouvez configurer des paramètres supplémentaires."
L['Shortcut to action bars settings.'] = "Raccourci vers les paramètres des barres d'action."
L['Media'] = 'Médias'
L['Default Font'] = 'Police par défaut'
L['The font that the core of the UI will use.'] = 'La police que le noyau du UI utilisera.'
L['Apply Font To All'] = 'Appliquer la police à tous'
L['Applies the font and font size settings throughout the entire user interface. Note: Some font size settings may be skipped, as they use a smaller font size by default.'] =
  'Applique les paramètres de police et de taille de police dans toute l’interface utilisateur. Remarque: Certains paramètres de taille de police peuvent être ignorés, car ils utilisent par défaut une taille de police plus petite.'
L['Default Texture'] = 'Texture par défaut'
L['The texture that the core of the UI will use.'] = 'La texture que le noyau du UI utilisera.'
L['Apply Texture To All'] = 'Appliquer une texture à tous'
L['Applies the texture across the entire user interface.'] = 'Applique la texture sur toute l’interface utilisateur.'
L['Color Theme'] = 'Thème de couleur'
L['Click on the button below to set color theme of ElvUI unit frames.\n- Normal Theme would enable class colorized frames;\n- Dark Theme would darken them and put Unit Names texts class colorized'] =
  "Cliquez sur le bouton ci-dessous pour définir le thème de couleur des cadres d'unité ElvUI.\n- Le thème normal permettrait d'activer les cadres colorisés de classe;\n- Le thème sombre les assombrirait et mettrait la classe de textes des noms d'unités colorisée"
L['Links'] = 'Liens'
L['Nameplates (Plater)'] = 'Plaques signalétiques (Plater)'
L['Combat Text (xCT+)'] = 'Texte de combat (xCT+)'
L['Profiles (ElvUI)'] = 'Profils (ElvUI)'
L['Profile contains settings for Raid Cooldowns and Notes'] = 'Le profil contient des paramètres pour les temps de recharge et les notes du Raid.'
L['OmniCD is used to display the cooldowns of your party, divided into several categories: Self Defensives, CC, Interrupts, and Raid Defensives. Depending on the layout you choose, the placement of the panels will vary. Use the same layout that you selected in ElvUI.'] =
  "OmniCD est utilisé pour afficher les temps de recharge de votre groupe, divisés en plusieurs catégories: Autodéfensives, CC, Interruptions et Raid Défensifs. Selon la disposition que vous choisissez, l'emplacement des panneaux variera. Utilisez la même mise en page que celle que vous avez sélectionnée dans ElvUI."
L["Choose DBM if you prefer to play with DBM, or BigWigs if you're a fan of that addon. You can skip this step if you're using my Raid Auras, as they already include everything needed for raids."] =
  'Choisissez DBM si vous préférez jouer avec DBM, ou BigWigs si vous êtes fan de cet addon. Vous pouvez ignorer cette étape si vous utilisez mes Raid Auras, car elles incluent déjà tout le nécessaire pour les raids.'
L['Profile Settings'] = 'Paramètres du profil'
L['Set Actual Version'] = 'Définir la version réelle'
L['Actualize Profile Version'] = 'Actualiser la version du profil'
L['Damage Meter (Details)'] = 'Compteur de dégâts (Details)'
L['Boss Mods'] = 'Mods de patron'
L['Action Bars Visibility'] = "Visibilité des barres d'action"
L['Click on the button to set action bars visibility.'] = "Cliquez sur le bouton pour définir la visibilité des barres d'action."
L['Click on the button to set color theme.'] = 'Cliquez sur le bouton pour définir le thème de couleur.'
L['Cell is a standalone addon included in my AddOns pack. It’s a powerful raid frame addon inspired by some of the best—CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smoother and more intuitive experience than ever before.'] =
  "Cell est un addon autonome inclus dans mon pack AddOns. Il s'agit d'un puissant module complémentaire de cadre de raid inspiré de certains des meilleurs: CompactRaid, Grid2, Aptechka et VuhDo. Avec son interface conviviale, Cell offre une expérience plus fluide et plus intuitive que jamais."
L['Apply a clean and minimalistic Details! profile for tracking damage, healing, and more.'] =
  'Appliquez un profil Details! propre et minimaliste pour suivre les dégâts, la guérison et bien plus encore.'
L['Apply my ElvUI layouts for DPS/Tank or Healer roles. Includes both horizontal and vertical layouts for party frames.'] =
  'Appliquez mes mises en page ElvUI pour les rôles DPS/Tank ou Healer. Comprend des dispositions horizontales et verticales pour les cadres de fête.'
L['Apply my MRT profile with raid cooldowns and notes preconfigured.'] = 'Appliquez mon profil MRT avec des temps de recharge et des notes de raid préconfigurés.'
L['Apply my Plater profile to improve nameplate visibility, customization, and performance.'] =
  'Appliquez mon profil Plater pour améliorer la visibilité, la personnalisation et les performances de la plaque signalétique.'
L['Backdrop'] = 'Toile de fond'
L['Choose Blizzard default combat text or xCT profiles for more compact and customizable numbers.'] =
  'Choisissez le texte de combat par défaut Blizzard ou les profils xCT pour des nombres plus compacts et personnalisables.'
L['Choose DBM or BigWigs profiles made for raiding. Recommended if not using my Raid Auras.'] =
  "Choisissez les profils DBM ou BigWigs conçus pour les raids. Recommandé si vous n'utilisez pas mes Raid Auras."
L['Choose between Cell or ElvUI raid frames and apply optimized layouts for raids and dungeons.'] =
  'Choisissez entre les cadres de raid Cell ou ElvUI et appliquez des dispositions optimisées pour les raids et les donjons.'
L['Combat Text'] = 'Texte de combat'
L['Dead'] = 'Mort'
L['Details'] = 'Details'
L['Ignore Modules'] = 'Ignorer les modules'
L['Installation Settings'] = "Paramètres d'installation"
L['Main'] = 'Principal'
L['Movers'] = 'Ancrages'
L['Player Castbar'] = 'Barre d\'incantation du joueur'
L['Preferable Resolution'] = 'Résolution préférable'
L['Profiles'] = 'Profils'
L['Raid Frames'] = 'Cadres de raid'
L['Re quick installation process.'] = "Re processus d'installation rapide."
L['Reset to Defaults'] = 'Réinitialiser aux valeurs par défaut'
L['Set Default MerfinUI settings'] = 'Définir les paramètres MerfinUI par défaut'
L['Set important game and addon CVars to recommended values for better visuals, performance, and usability.'] =
  "Définissez le jeu important et l'addon CVars sur les valeurs recommandées pour de meilleurs visuels, performances et convivialité."
L['Set up OmniCD to display party cooldowns (defensives, interrupts, raid CDs) with layouts matching your UI.'] =
  'Configurez OmniCD pour afficher les temps de recharge des groupes (défensives, interruptions, CD de raid) avec des dispositions correspondant à votre UI.'
L['Set up your chat windows with preconfigured tabs for general, combat log, whispers, and group content.'] =
  'Configurez vos fenêtres de discussion avec des onglets préconfigurés pour le contenu général, le journal de combat, les chuchotements et le groupe.'
L['Set your action bars to always show or appear on mouseover.'] = "Définissez vos barres d'action pour qu'elles s'affichent ou apparaissent toujours au survol de la souris."
L['Show Always'] = 'Afficher toujours'
L['Show the Player Cast Bar provided by ElvUI.'] = 'Afficher la barre de diffusion du joueur fournie par ElvUI.'
L['Switch between Normal and Dark color themes for the UI.'] = 'Basculez entre les thèmes de couleurs Normal et Foncé pour le UI.'
L['UI Install'] = 'UI Installer'
L['UI Quick Install'] = 'UI Installation rapide'
L['Unit Frames'] = "Cadres d'unité"
L['You can install the profile from this section as an alternative to the installer.'] =
  "Vous pouvez installer le profil à partir de cette section comme alternative au programme d'installation."
L['Target Debuffs'] = 'Débuffs de cible'
L['Enable or disable debuffs on the target frame.'] = "Activez ou désactivez les débuffs sur l'image cible."
L['Profile contains settings for Cooldown Manager Centered.'] = 'Le profil contient les paramètres de Cooldown Manager Centered.'
L['Profile contains settings for SenseiClassResourceBar.'] = 'Le profil contient les paramètres de SenseiClassResourceBar.'
L['Applies the Skyriding Bar profile for your selected layout.'] = 'Applique le profil Skyriding Bar pour la disposition sélectionnée.'
L['Profile contains settings for Simple Assisted Combat Icon.'] = 'Le profil contient les paramètres de Simple Assisted Combat Icon.'
L['Shows the same suggestions as the Single-Button-Assistant. Due to Blizzard changes, this is currently the only rotation helper possible (RIP Hekili). Helpful for learning your class/spec.'] =
  "Affiche les mêmes suggestions que le Single-Button-Assistant. En raison des modifications apportées à Blizzard, il s'agit actuellement du seul assistant de rotation possible (RIP Hekili). Utile pour apprendre votre classe/spécification."
L['%s import failed: %s'] = "Échec de l'importation %s: %s"
L['%s installed.'] = '%s installé.'
L['%s is not available. Please enable it and reload your UI.'] = "%s n’est pas disponible. Veuillez l'activer et recharger votre UI."
L['%s profile installed.'] = 'Profil %s installé.'
L['%s profile installed: %s'] = 'Profil %s installé: %s'
L['%s profiles installed.'] = 'Profils %s installés.'
L["ATM Classic Era/SoD doesn't support xCT."] = 'ATM Classic Era/SoD ne prend pas en charge xCT.'
L["ATM Classic Vanilla doesn't support xCT."] = 'ATM Classic Vanilla ne prend pas en charge xCT.'
L['Cell (DPS/Tank)'] = 'Cell (DPS/Tank)'
L['Cell (Healer)'] = 'Cell (Healer)'
L['Cell is a standalone addon included in my AddOns pack. It is a powerful raid frame addon inspired by CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smooth and intuitive experience.'] =
  "Cell est un addon autonome inclus dans mon pack AddOns. Il s'agit d'un puissant module complémentaire de cadre de raid inspiré de CompactRaid, Grid2, Aptechka et VuhDo. Avec son interface conviviale, Cell offre une expérience fluide et intuitive."
L['Choose how combat text is displayed. Use Blizzard for default floating numbers, or xCT if you prefer compact scrolling damage and healing text.'] =
  'Choisissez comment le texte de combat est affiché. Utilisez Blizzard pour les nombres flottants par défaut, ou xCT si vous préférez les dégâts de défilement compacts et le texte de guérison.'
L['Cooldown Manager'] = 'Cooldown Manager'
L['Cooldown Manager Centered'] = 'Cooldown Manager Centered'
L['Copied!'] = 'Copié!'
L['Current Layout: |cff00c0ff%s|r'] = 'Disposition actuelle: |cff00c0ff%s|r'
L['Current Layout: |cff00ff00%s|r'] = 'Disposition actuelle: |cff00ff00%s|r'
L['DPS/Tank'] = 'DPS/Tank'
L['Edit Mode'] = 'Mode édition'
L['Edit Mode is not available.'] = "Le mode édition n'est pas disponible."
L['ElvUI Frames'] = 'Cadres ElvUI'
L['Healer'] = 'Healer'
L['Import or select the correct Edit Mode layout so chat and UI elements are positioned correctly.'] =
  "Importez ou sélectionnez la mise en page correcte du mode d'édition afin que les éléments de discussion et UI soient correctement positionnés."
L['Method Raid Tools'] = 'Method Raid Tools'
L['Open Edit Mode'] = 'Ouvrir le mode édition'
L['Please make sure the correct profile is selected, or parts of the UI may be misplaced.'] =
  'Veuillez vous assurer que le profil correct est sélectionné, sinon des parties du UI pourraient être égarées.'
L['Profile version was updated to v%s.'] = 'La version du profil a été mise à jour vers v%s.'
L['Quick Install'] = 'Installation rapide'
L['Reload required. Continue?'] = 'Rechargement requis. Continuer?'
L['Sensei Class Resource Bar'] = 'Sensei Class Resource Bar'
L['Settings are applied directly to your Edit Mode profile.'] = 'Les paramètres sont appliqués directement à votre profil en mode édition.'
L['Show Import Buttons'] = "Afficher les boutons d'importation"
L['Game Menu'] = 'Menu du jeu'
L['Show MerfinUI Button'] = 'Afficher le bouton MerfinUI'
L['Shows the MerfinUI button in the Game Menu.'] = 'Affiche le bouton MerfinUI dans le menu du jeu.'
L['Shows import buttons next to the Cooldown Manager import window.'] = "Affiche les boutons d'importation à côté de la fenêtre d'importation Cooldown Manager."
L['Shows import buttons next to the Edit Mode import window.'] = "Affiche les boutons d'importation à côté de la fenêtre d'importation du mode édition."
L['Skyriding Falcon'] = 'Skyriding Falcon'
L["This installer will quickly set up all addons and profiles (except for WeakAuras, as neither the full installer currently handles WeakAuras). With just one click, everything will be configured, followed by a reload at the end. If you're unsure, consider using the standard installer instead."] =
  "Ce programme d'installation configurera rapidement tous les modules complémentaires et profils (à l'exception de WeakAuras, car ni le programme d'installation complet ne gère actuellement WeakAuras). En un seul clic, tout sera configuré, suivi d'un rechargement à la fin. Si vous n'êtes pas sûr, envisagez plutôt d'utiliser le programme d'installation standard."
L['Unknown'] = 'Inconnu'
L['Welcome to the Quick installation for %s.'] = "Bienvenue dans l'installation rapide de %s."
L['You need to enable %s first.'] = "Vous devez d'abord activer %s."
L['You need to enable %s to apply profile settings.'] = 'Vous devez activer %s pour appliquer les paramètres de profil.'
L['You need to enable %s.'] = 'Vous devez activer %s.'
L['Edit Mode layout imported and saved as %s.'] = 'Disposition du mode édition importée et enregistrée sous %s.'
L['Failed to import Edit Mode layout.'] = "Échec de l'importation de la mise en page en mode édition."
L['Class'] = 'Classe'
L['Class Theme'] = 'Thème de classe'
L['Dark'] = 'Sombre'
L['Installation'] = 'Mise en place'
L['Quick Installation'] = 'Installation rapide'
L['Dark Theme Applied'] = 'Thème sombre appliqué'
L['Normal Theme Applied'] = 'Thème normal appliqué'
L['Blizzard Combat Text'] = 'Blizzard Texte de combat'
L['Socials'] = 'Réseaux sociaux'
L['AddOns'] = 'Extensions'
L['SUB CONTENT'] = 'CONTENU ABO'
L['WeakAuras Package'] = 'Pack WeakAuras'
L['Class Auras, General Auras, Raid Packs, and more.'] =
  'Auras de classe, auras générales, packs de raid et plus encore.'
