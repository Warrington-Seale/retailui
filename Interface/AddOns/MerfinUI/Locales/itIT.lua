local addonName, Private = ...
local L = Private.L or {}
Private.L = L

if (GAME_LOCALE or GetLocale()) ~= 'itIT' then
  return
end

L['Welcome to the installation for %s.'] = "Benvenuti all'installazione di %s."
L['Skip Process'] = 'Salta processo'
L['Importance: |cff4beb2cOptional|r'] = 'Priorità: |cff4beb2cOpzionale|r'
L['Importance: |cff4beb2cHigh|r'] = 'Priorità: |cff4beb2cAlta|r'
L['Click the button to adjust the settings.'] = 'Fare clic sul pulsante per regolare le impostazioni.'
L['Welcome'] = 'Benvenuto'
L['Account Settings'] = "Impostazioni dell'account"
L['Chat Settings'] = 'Impostazioni della chat'
L['Installation Complete'] = 'Installazione completata'
L['This installer contains profiles for various addons in MerfinUI.'] = 'Questo programma di installazione contiene profili per vari componenti aggiuntivi in MerfinUI.'
L['Before starting the installation process, I highly recommend backing up your current WTF folder to preserve your existing settings, just in case.'] =
  'Prima di iniziare il processo di installazione, ti consiglio vivamente di eseguire il backup della cartella WTF corrente per preservare le impostazioni esistenti, per ogni evenienza.'
L["Don't forget to click Finished in the final step. This will reload your UI and apply all the settings."] =
  'Non dimenticare di fare clic su Fine nel passaggio finale. Questo ricaricherà il tuo UI e applicherà tutte le impostazioni.'
L['The World of Warcraft game client stores all its configurations in console variables (CVars). These variables control various aspects of the game, including graphics, sound, and the user interface.'] =
  "Il client di gioco World of Warcraft memorizza tutte le sue configurazioni nelle variabili della console (CVars). Queste variabili controllano vari aspetti del gioco, inclusa la grafica, il suono e l'interfaccia utente."
L['This step also includes settings for addons like Questie and Leatrix.'] = 'Questo passaggio include anche le impostazioni per componenti aggiuntivi come Questie e Leatrix.'
L['Load CVars'] = 'Carica CVars'
L['This will set up the chat windows to look like this:\n\nGNL - Clog - LT - /W - LFG.'] = 'Questo imposterà le finestre di chat in questo modo:\n\nGNL - Clog - LT - /W - LFG.'
L['Setup Chat'] = 'Configura chat'
L["Click the button below to apply the layout of your choice, depending on your role: DPS/Tank or Healer. Use Healer-H if you prefer horizontal party frames (similar to your raid frames). Choose Healer-V if you'd like your party frames to grow vertically. I personally prefer the vertical layout, but it's up to you!"] =
  'Fai clic sul pulsante in basso per applicare il layout che preferisci, a seconda del tuo ruolo: DPS/Tank o Healer. Usa Healer-H se preferisci i frame party orizzontali (simili ai frame raid). Scegli Healer-V se desideri che le cornici delle tue feste crescano verticalmente. Personalmente preferisco la disposizione verticale, ma dipende da te!'
L['You must have these plugins downloaded and enabled:\nAddOnSkins, ProjectAzilroka'] = 'Devi avere questi plugin scaricati e abilitati:\nAddOnSkins, ProjectAzilroka'
L['Normal Theme'] = 'Tema normale'
L['Dark Theme'] = 'Tema scuro'
L['Here you can choose how to display Combat Text (damage, healing numbers, etc.). If you prefer the normal numbers above the mobs, click on Blizzard. If you prefer damage numbers to be stacked in one place, use xCT — either xCT DPS/Tank or xCT Healer, depending on your spec.'] =
  'Qui puoi scegliere come visualizzare il testo di combattimento (danni, numeri di guarigione, ecc.). Se preferisci i numeri normali sopra i mob, clicca su Blizzard. Se preferisci che i numeri dei danni siano impilati in un unico posto, usa xCT: xCT DPS/Tank o xCT Healer, a seconda delle tue specifiche.'
L['You have completed the installation process.'] = 'Hai completato il processo di installazione.'
L['You must click the button below to finalize the process and automatically reload your UI.'] =
  'È necessario fare clic sul pulsante in basso per finalizzare il processo e ricaricare automaticamente il tuo UI.'
L['Finished'] = 'Finito'
L['Install'] = 'Installa'
L['Re-run the installation process.'] = 'Eseguire nuovamente il processo di installazione.'
L['Action Bars'] = 'Barre di azione'
L['Show Grid'] = 'Mostra griglia'
L['Show Empty cells'] = 'Mostra celle vuote'
L['Show Mouseover'] = 'Mostra al passaggio del mouse'
L['Fonts and Textures'] = 'Caratteri e trame'
L['Shortcut to general media settings.'] = 'Collegamento alle impostazioni multimediali generali.'
L['Action Bar Settings'] = 'Impostazioni della barra delle azioni'
L['Click the button below to open the Action Bars options, where you can configure additional settings.'] =
  'Fare clic sul pulsante in basso per aprire le opzioni delle barre delle azioni, in cui è possibile configurare impostazioni aggiuntive.'
L['Shortcut to action bars settings.'] = 'Collegamento alle impostazioni delle barre delle azioni.'
L['Media'] = 'Media'
L['Default Font'] = 'Carattere predefinito'
L['The font that the core of the UI will use.'] = 'Il carattere che verrà utilizzato dal nucleo di UI.'
L['Apply Font To All'] = 'Applica carattere a tutti'
L['Applies the font and font size settings throughout the entire user interface. Note: Some font size settings may be skipped, as they use a smaller font size by default.'] =
  "Applica le impostazioni del carattere e della dimensione del carattere all'intera interfaccia utente. Nota: alcune impostazioni della dimensione del carattere potrebbero essere ignorate poiché utilizzano una dimensione del carattere più piccola per impostazione predefinita."
L['Default Texture'] = 'Trama predefinita'
L['The texture that the core of the UI will use.'] = 'La texture che utilizzerà il nucleo di UI.'
L['Apply Texture To All'] = 'Applica trama a tutti'
L['Applies the texture across the entire user interface.'] = "Applica la texture all'intera interfaccia utente."
L['Color Theme'] = 'Tema del colore'
L['Click on the button below to set color theme of ElvUI unit frames.\n- Normal Theme would enable class colorized frames;\n- Dark Theme would darken them and put Unit Names texts class colorized'] =
  'Fare clic sul pulsante in basso per impostare il tema colore dei telai delle unità ElvUI.\n- Il tema normale abiliterà i frame colorati di classe;\n- Il tema scuro li scurirebbe e renderebbe colorati i testi dei nomi delle unità'
L['Links'] = 'Collegamenti'
L['Nameplates (Plater)'] = 'Targhette (Plater)'
L['Combat Text (xCT+)'] = 'Testo di combattimento (xCT+)'
L['Profiles (ElvUI)'] = 'Profili (ElvUI)'
L['Profile contains settings for Raid Cooldowns and Notes'] = 'Il profilo contiene le impostazioni per i tempi di recupero e le note del raid'
L['OmniCD is used to display the cooldowns of your party, divided into several categories: Self Defensives, CC, Interrupts, and Raid Defensives. Depending on the layout you choose, the placement of the panels will vary. Use the same layout that you selected in ElvUI.'] =
  'OmniCD viene utilizzato per visualizzare i tempi di recupero del tuo gruppo, divisi in diverse categorie: Autodifese, CC, Interruzioni e Difensive del Raid. A seconda del layout scelto, la posizione dei pannelli varierà. Utilizza lo stesso layout selezionato in ElvUI.'
L["Choose DBM if you prefer to play with DBM, or BigWigs if you're a fan of that addon. You can skip this step if you're using my Raid Auras, as they already include everything needed for raids."] =
  "Scegli DBM se preferisci giocare con DBM o BigWigs se sei un fan di quell'add-on. Puoi saltare questo passaggio se stai utilizzando le mie Raid Aura, poiché includono già tutto il necessario per i raid."
L['Profile Settings'] = 'Impostazioni del profilo'
L['Set Actual Version'] = 'Imposta la versione effettiva'
L['Actualize Profile Version'] = 'Attualizza la versione del profilo'
L['Damage Meter (Details)'] = 'Misuratore di danni (Details)'
L['Boss Mods'] = 'Mod boss'
L['Action Bars Visibility'] = 'Visibilità delle barre delle azioni'
L['Click on the button to set action bars visibility.'] = 'Fare clic sul pulsante per impostare la visibilità delle barre delle azioni.'
L['Click on the button to set color theme.'] = 'Fare clic sul pulsante per impostare il tema del colore.'
L['Cell is a standalone addon included in my AddOns pack. It’s a powerful raid frame addon inspired by some of the best—CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smoother and more intuitive experience than ever before.'] =
  "Cell è un componente aggiuntivo autonomo incluso nel mio pacchetto AddOns. È un potente componente aggiuntivo per frame raid ispirato ad alcuni dei migliori: CompactRaid, Grid2, Aptechka e VuhDo. Con la sua interfaccia intuitiva, Cell offre un'esperienza più fluida e intuitiva che mai."
L['Apply a clean and minimalistic Details! profile for tracking damage, healing, and more.'] =
  'Applica un profilo Details! pulito e minimalista per monitorare danni, guarigioni e altro ancora.'
L['Apply my ElvUI layouts for DPS/Tank or Healer roles. Includes both horizontal and vertical layouts for party frames.'] =
  'Applica i miei layout ElvUI per i ruoli DPS/Tank o Healer. Include layout sia orizzontali che verticali per le cornici delle feste.'
L['Apply my MRT profile with raid cooldowns and notes preconfigured.'] = 'Applica il mio profilo MRT con cooldown raid e note preconfigurate.'
L['Apply my Plater profile to improve nameplate visibility, customization, and performance.'] =
  'Applica il mio profilo Plater per migliorare la visibilità, la personalizzazione e le prestazioni della targhetta.'
L['Backdrop'] = 'Fondale'
L['Choose Blizzard default combat text or xCT profiles for more compact and customizable numbers.'] =
  'Scegli il testo di combattimento predefinito Blizzard o i profili xCT per numeri più compatti e personalizzabili.'
L['Choose DBM or BigWigs profiles made for raiding. Recommended if not using my Raid Auras.'] =
  'Scegli i profili DBM o BigWigs realizzati per il raid. Consigliato se non utilizzo le mie Raid Aura.'
L['Choose between Cell or ElvUI raid frames and apply optimized layouts for raids and dungeons.'] =
  'Scegli tra i frame raid Cell o ElvUI e applica layout ottimizzati per raid e dungeon.'
L['Combat Text'] = 'Testo di combattimento'
L['Dead'] = 'Morto'
L['Details'] = 'Details'
L['Ignore Modules'] = 'Ignora moduli'
L['Installation Settings'] = 'Impostazioni di installazione'
L['Main'] = 'Principale'
L['Movers'] = 'Ancoraggi'
L['Player Castbar'] = 'Barra di lancio del giocatore'
L['Preferable Resolution'] = 'Risoluzione preferibile'
L['Profiles'] = 'Profili'
L['Raid Frames'] = 'Riquadri raid'
L['Re quick installation process.'] = 'Re processo di installazione rapida.'
L['Reset to Defaults'] = 'Ripristina le impostazioni predefinite'
L['Set Default MerfinUI settings'] = 'Configurare le impostazioni predefinite MerfinUI'
L['Set important game and addon CVars to recommended values for better visuals, performance, and usability.'] =
  'Imposta il gioco importante e il componente aggiuntivo CVars sui valori consigliati per immagini, prestazioni e usabilità migliori.'
L['Set up OmniCD to display party cooldowns (defensives, interrupts, raid CDs) with layouts matching your UI.'] =
  'Configura OmniCD per visualizzare i tempi di recupero del gruppo (difese, interruzioni, CD raid) con layout corrispondenti al tuo UI.'
L['Set up your chat windows with preconfigured tabs for general, combat log, whispers, and group content.'] =
  'Imposta le finestre di chat con schede preconfigurate per contenuti generali, registro di combattimento, sussurri e contenuti di gruppo.'
L['Set your action bars to always show or appear on mouseover.'] = 'Imposta le barre delle azioni in modo che vengano sempre visualizzate o visualizzate al passaggio del mouse.'
L['Show Always'] = 'Mostra sempre'
L['Show the Player Cast Bar provided by ElvUI.'] = 'Mostra la barra del cast del giocatore fornita da ElvUI.'
L['Switch between Normal and Dark color themes for the UI.'] = 'Passa tra i temi di colore Normale e Scuro per UI.'
L['UI Install'] = 'UI Installa'
L['UI Quick Install'] = 'UI Installazione rapida'
L['Unit Frames'] = 'Cornici unità'
L['You can install the profile from this section as an alternative to the installer.'] =
  'È possibile installare il profilo da questa sezione in alternativa al programma di installazione.'
L['Target Debuffs'] = 'Debuff bersaglio'
L['Enable or disable debuffs on the target frame.'] = 'Abilita o disabilita i debuff sul frame di destinazione.'
L['Profile contains settings for Cooldown Manager Centered.'] = 'Il profilo contiene le impostazioni per Cooldown Manager Centered.'
L['Profile contains settings for SenseiClassResourceBar.'] = 'Il profilo contiene le impostazioni per SenseiClassResourceBar.'
L['Applies the Skyriding Bar profile for your selected layout.'] = 'Applica il profilo Skyriding Bar per il layout selezionato.'
L['Profile contains settings for Simple Assisted Combat Icon.'] = 'Il profilo contiene le impostazioni per Simple Assisted Combat Icon.'
L['Shows the same suggestions as the Single-Button-Assistant. Due to Blizzard changes, this is currently the only rotation helper possible (RIP Hekili). Helpful for learning your class/spec.'] =
  "Mostra gli stessi suggerimenti di Single-Button-Assistant. A causa delle modifiche a Blizzard, questo è attualmente l'unico assistente di rotazione possibile (RIP Hekili). Utile per imparare la tua classe/specifica."
L['%s import failed: %s'] = 'Importazione %s non riuscita: %s'
L['%s installed.'] = '%s installato.'
L['%s is not available. Please enable it and reload your UI.'] = '%s non è disponibile. Abilitalo e ricarica il tuo UI.'
L['%s profile installed.'] = 'Profilo %s installato.'
L['%s profile installed: %s'] = 'Profilo %s installato: %s'
L['%s profiles installed.'] = 'Profili %s installati.'
L["ATM Classic Era/SoD doesn't support xCT."] = 'ATM Classic Era/SoD non supporta xCT.'
L["ATM Classic Vanilla doesn't support xCT."] = 'ATM Classic Vanilla non supporta xCT.'
L['Cell (DPS/Tank)'] = 'Cell (DPS/Tank)'
L['Cell (Healer)'] = 'Cell (Healer)'
L['Cell is a standalone addon included in my AddOns pack. It is a powerful raid frame addon inspired by CompactRaid, Grid2, Aptechka, and VuhDo. With its user-friendly interface, Cell offers a smooth and intuitive experience.'] =
  "Cell è un componente aggiuntivo autonomo incluso nel mio pacchetto AddOns. È un potente componente aggiuntivo del frame raid ispirato a CompactRaid, Grid2, Aptechka e VuhDo. Con la sua interfaccia user-friendly, Cell offre un'esperienza fluida e intuitiva."
L['Choose how combat text is displayed. Use Blizzard for default floating numbers, or xCT if you prefer compact scrolling damage and healing text.'] =
  'Scegli come viene visualizzato il testo del combattimento. Utilizza Blizzard per i numeri mobili predefiniti o xCT se preferisci danni a scorrimento compatti e testo curativo.'
L['Cooldown Manager'] = 'Cooldown Manager'
L['Cooldown Manager Centered'] = 'Cooldown Manager Centered'
L['Copied!'] = 'Copiato!'
L['Current Layout: |cff00c0ff%s|r'] = 'Disposizione corrente: |cff00c0ff%s|r'
L['Current Layout: |cff00ff00%s|r'] = 'Disposizione corrente: |cff00ff00%s|r'
L['DPS/Tank'] = 'DPS/Tank'
L['Edit Mode'] = 'Modalità Modifica'
L['Edit Mode is not available.'] = 'La modalità Modifica non è disponibile.'
L['ElvUI Frames'] = 'Riquadri ElvUI'
L['Healer'] = 'Healer'
L['Import or select the correct Edit Mode layout so chat and UI elements are positioned correctly.'] =
  'Importa o seleziona il layout corretto della modalità di modifica in modo che gli elementi chat e UI siano posizionati correttamente.'
L['Method Raid Tools'] = 'Method Raid Tools'
L['Open Edit Mode'] = 'Apri la modalità Modifica'
L['Please make sure the correct profile is selected, or parts of the UI may be misplaced.'] =
  'Assicurati che sia selezionato il profilo corretto, altrimenti parti di UI potrebbero andare fuori posto.'
L['Profile version was updated to v%s.'] = 'La versione del profilo è stata aggiornata a v%s.'
L['Quick Install'] = 'Installazione rapida'
L['Reload required. Continue?'] = 'Ricarica necessaria. Continuare?'
L['Sensei Class Resource Bar'] = 'Sensei Class Resource Bar'
L['Settings are applied directly to your Edit Mode profile.'] = 'Le impostazioni vengono applicate direttamente al tuo profilo in modalità Modifica.'
L['Show Import Buttons'] = 'Mostra pulsanti di importazione'
L['Game Menu'] = 'Menu di gioco'
L['Show MerfinUI Button'] = 'Mostra pulsante MerfinUI'
L['Shows the MerfinUI button in the Game Menu.'] = 'Mostra il pulsante MerfinUI nel menu di gioco.'
L['Shows import buttons next to the Cooldown Manager import window.'] = 'Mostra i pulsanti di importazione accanto alla finestra di importazione Cooldown Manager.'
L['Shows import buttons next to the Edit Mode import window.'] = 'Mostra i pulsanti di importazione accanto alla finestra di importazione della modalità Modifica.'
L['Skyriding Falcon'] = 'Skyriding Falcon'
L["This installer will quickly set up all addons and profiles (except for WeakAuras, as neither the full installer currently handles WeakAuras). With just one click, everything will be configured, followed by a reload at the end. If you're unsure, consider using the standard installer instead."] =
  "Questo programma di installazione configurerà rapidamente tutti i componenti aggiuntivi e i profili (ad eccezione di WeakAuras, poiché nessuno dei due programmi di installazione completi attualmente gestisce WeakAuras). Con un solo clic tutto sarà configurato e alla fine verrà ricaricato. Se non sei sicuro, considera invece l'utilizzo del programma di installazione standard."
L['Unknown'] = 'Sconosciuto'
L['Welcome to the Quick installation for %s.'] = "Benvenuti nell'installazione rapida di %s."
L['You need to enable %s first.'] = 'È necessario prima abilitare %s.'
L['You need to enable %s to apply profile settings.'] = 'È necessario abilitare %s per applicare le impostazioni del profilo.'
L['You need to enable %s.'] = 'È necessario abilitare %s.'
L['Edit Mode layout imported and saved as %s.'] = 'Layout della modalità Modifica importato e salvato come %s.'
L['Failed to import Edit Mode layout.'] = 'Impossibile importare il layout della modalità di modifica.'
L['Class'] = 'Classe'
L['Class Theme'] = 'Tema di classe'
L['Dark'] = 'Buio'
L['Installation'] = 'Installazione'
L['Quick Installation'] = 'Installazione rapida'
L['Dark Theme Applied'] = 'Tema scuro applicato'
L['Normal Theme Applied'] = 'Tema normale applicato'
L['Blizzard Combat Text'] = 'Blizzard Testo di combattimento'
L['Socials'] = 'Social'
L['AddOns'] = 'Componenti aggiuntivi'
L['SUB CONTENT'] = 'CONTENUTO ABB.'
L['WeakAuras Package'] = 'Pacchetto WeakAuras'
L['Class Auras, General Auras, Raid Packs, and more.'] =
  'Aure di classe, aure generali, pacchetti raid e altro ancora.'
