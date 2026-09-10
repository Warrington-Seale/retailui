-- Castle Nathria

local L = BigWigs:NewBossLocale("Shriekwing", "itIT")
if L then
	L.pickup_lantern = "%s ha raccolto la lanterna!"
	L.dropped_lantern = "Lantern lasciata da %s!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "itIT")
if L then
	L.killed = "%s Ucciso"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "itIT")
if L then
	L.shield_remaining = "%s rimanente: %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "itIT")
if L then
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "Urlo ripetitivo della vita per Miasma"
	L.custom_on_repeating_yell_miasma_desc = "Urla messaggi ripetitivi con Miasma Insaziabile per segnalare agli altri quando sei sotto il 75% di vita."

	L.custom_on_repeating_say_laser = "Messaggio Espulsione Instabile"
	L.custom_on_repeating_say_laser_desc = "Ripeti messaggi per Espulsione Instabile per aiutare a muovere i giocatori che non hanno visto il primo messaggio."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "itIT")
if L then
	L.tear = "Squarcio" -- Short for Dimensional Tear
	L.seeds = "Semi" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "itIT")
if L then
	L.times = "%dx %s"

	L.level = "%s (Livello |cffffff00%d|r)"
	L.full = "%s (|cffff0000PIENO|r)"

	L.anima_adds = "Adds Animum Concentrato"
	L.anima_adds_desc = "Mostra un timer per la comparsa degli Adds di Animum Concentrato."

	L.custom_off_experimental = "Abilita funzioni sperimentali"
	L.custom_off_experimental_desc = "Queste funzioni |cffff0000non sono state testate|r e potrebbero creare |cffff0000spam|r."

	L.anima_tracking = "Tracciamento Animum |cffff0000(Experimental)|r"
	L.anima_tracking_desc = "Barre e messaggi per i tracciamento dei livelli di animum nei contenitori.|n|cffaaff00Suggerimento: Potresti preferire tenere disabilitati le barre e il box informazioni, dipende dalle tue preferenze personali."

	L.desires = "Desideri"
	L.bottles = "Bottiglie"
	L.sins = "Peccati"
end

L = BigWigs:NewBossLocale("The Council of Blood", "itIT")
if L then
	L.custom_on_repeating_dark_recital = "Ripetizione per Esibizione Oscura"
	L.custom_on_repeating_dark_recital_desc = "Messaggi ripetuti per Esibizione Oscura con icone {rt1}, {rt2} per trovare il tuo compagno di ballo."

	L.dance_assist = "Assistente Danza"
	L.dance_assist_desc = "Mostra avvisi direzionali per la fase della danza."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Danza in Avanti |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Danza a Destra |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Danza Indietro |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Danza a Sinistra |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "Saltelli in avanti" -- Prance Forward!
	L.dance_yell_right = "Spallucce a destra" -- Shimmy right!
	L.dance_yell_down = "Via alle danze" -- Boogie down!
	L.dance_yell_down_2 = "Via alle danze" -- Boogie down!
	L.dance_yell_left = "Volteggio a sinistra" -- Sashay left!
end

L = BigWigs:NewBossLocale("Sludgefist", "itIT")
if L then
	L.stomp_shift = "Carica & Spostamento" -- Destructive Stomp + Seismic Shift

	L.fun_info = "Info sui danni"
	L.fun_info_desc = "Mostra un messaggio che indica la salute persa dal boss durante Urto Distruttivo."

	L.health_lost = "Picchiapoltiglia è sceso del %.1f%%!"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "itIT")
if L then
	L.first_blade = "Prima Lama"
	L.second_blade = "Seconda Lama"

	L.skirmishers = "Schermagliatrici" -- Short for Stone Legion Skirmishers
	L.eruption = "Eruzione" -- Short for Reverberating Eruption

	L.goliath_short = "Mastodonte"
	L.goliath_desc = "Mostra avvisi e timer per la comparsa del Mastodonte della Legione di Pietra."

	L.commando_short = "Commando"
	L.commando_desc = "Mostra avvisi quando viene ucciso un Commando della Legione di Pietra."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "itIT")
if L then
	L.infobox_stacks = "%d |4Accumulo:Accumuli;: %d |4giocatore:giocatori;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "Ripetizione Urlo Predatore della Notte"
	L.custom_on_repeating_nighthunter_desc = "Ripete messaggi di urlo per l'abilità Predatore della Notte usando le icone {rt1} o {rt2} o {rt3} per trovare la tuna linea più facilmente se devi assorbire."

	L.custom_on_repeating_impale = "Ripetizione Avviso Impalamento"
	L.custom_on_repeating_impale_desc = "Ripete i messaggi di chat per l'abilità Impalamento usando '1' o '22' o '333' o '4444' per avvisare l'ordine con cui colpirà."

	L.hymn_stacks = "Inno di Nathria"
	L.hymn_stacks_desc = "Avviso per gli accumuli di Inno di Nathria presenti su di te."

	L.ravage_target = "Riflesso: Devastazione Barra di Cast del Target"
	L.ravage_target_desc = "Barra di cast che mostra il tempo mancante prima che Riflesso colpisca con Devastazione."
	L.ravage_targeted = "Devastazione a Terra" -- Testo sulla barra per quando devastazione raggiunge il suo punto d'impatto in fase 3

	L.no_mirror = "No Specchio: %d" -- Numero di giocatori che non hanno Attraverso lo Specchio
	L.mirror = "Specchio: %d" -- Numero di giocatori che hanno Attraverso lo Specchio
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "itIT")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "Moldovaak"
	L.caramain = "Caramain"
	L.sindrel = "Sindrel"
	L.hargitas = "Hargitas"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "Gargon Gigantesco"
	L.hawkeye = "Occhiolungo di Nathria"
	L.overseer = "Sovrintendente dei Serragli"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "Divoratore di Terrore"
	L.rat = "Ratto di Dimensioni Anormali"
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "Deplina"
	L.dragost = "Dragost"
	L.kullan = "Kullan"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "Antiquaria Sinistra"
	L.conservator = "Conservatore di Nathria"
	L.archivist = "Archivista di Nathria"
	L.hierarch = "Gerarca di Corte"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "Mastodonte della Legione di Pietra"
end

L = BigWigs:NewBossLocale("Castle Nathria Affixes", "itIT")
if L then
	L.custom_on_bar_icon = "Icona Barra"
	L.custom_on_bar_icon_desc = "Mostra l'Icona dell'Incursione Predestinata sulle barre."

	L.chaotic_essence = "Essenza"
	L.creation_spark = "Scintille"
	L.protoform_barrier = "Barriera"
	L.reconfiguration_emitter = "Interrompi Add"
end

-- Sanctum of Domination

L = BigWigs:NewBossLocale("The Tarragrue", "itIT")
if L then
	L.chains = "Catene" -- Chains of Eternity (Chains)
	L.remnants = "Residui" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "Residuo Fisico"
	L.magic_remnant = "Residuo Magico"
	L.fire_remnant = "Residuo del Fuoco"
	L.fire = "Fuoco"
	L.magic = "Magico"
	L.physical = "Fisico"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "itIT")
if L then
	L.chains = "Catene" -- Short for Dragging Chains
	L.death_gaze = "Sguardo della Morte" -- Corto per Sguardo della Morte Titanico
end

L = BigWigs:NewBossLocale("The Nine", "itIT")
if L then
	L.fragments = "Frammenti" -- Short for Fragments of Destiny
	L.fragment = "Frammento" -- Singular Fragment of Destiny
	L.run_away = "Scappa" -- Wings of Rage
	L.song = "Canto" -- Short for Song of Dissolution
	L.go_in = "Entra dentro" -- Reverberating Refrain
	L.valkyr = "Val'kyr" -- Short for Call of the Val'kyr
	L.blades = "Spade" -- Agatha's Eternal Blade
	L.big_bombs = "Bombe Grandi" -- Corto per Impatto Vigoroso di Daschla
	L.big_bomb = "Bomba Grande" -- Attached to the countdown
	L.shield = "Scudo" -- Annhylde's Bright Aegis
	L.soaks = "Assorbire" -- Aradne's Falling Strike
	L.small_bombs = "Bombe Piccole" -- Brynja's Mournful Dirge
	L.recall = "Richiamo" -- Short for Word of Recall

	L.blades_yell = "Cadete sotto i colpi della mia spada!!"
	L.soaks_yell = "Siete tutti inferiori!"
	L.shield_yell = "Il mio scudo non vacilla mai!"

	L.berserk_stage1 = "Berserk Fase 1"
	L.berserk_stage2 = "Berserk Fase 2"

	L.image_special = "%s [Skyja]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "itIT")
if L then
	L.cones = "Coni" -- Grasp of Malice
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "itIT")
if L then
	L.custom_off_nameplate_defiance = "Icona Nameplate Ribellione"
	L.custom_off_nameplate_defiance_desc = "Mostra un'icona sul namepalte del Giurafauce che ha Ribellione.\n\nRichiede l'uso dei Nameplates del nemico e un'appon per nameplates supportato (KuiNameplates, Plater)."

	L.custom_off_nameplate_tormented = "Icona nameplate Tormento"
	L.custom_off_nameplate_tormented_desc = "Mostra un'icona sul namepalte del Giurafauce che ha Tormento.\n\nRichiede l'uso dei Nameplates del nemico e un'appon per nameplates supportato (KuiNameplates, Plater)."

	L.cones = "Coni" -- Torment
	L.dance = "Danza" -- Encore of Torment
	L.brands = "Marchiature" -- Brand of Torment
	L.brand = "Marchiatura" -- Single Brand of Torment
	L.spike = "Scheggia" -- Short for Agonizing Spike
	L.chains = "Catene" -- Hellscream
	L.chain = "Catena" -- Soul Manacles
	L.souls = "Anime" -- Rendered Soul

	L.chains_remaining = "%d Catene rimaste"
	L.all_broken = "TUTTE le catene spezzate"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "itIT")
if L then
	L.hammer = "Martello" -- Short for Rippling Hammer
	L.axe = "Ascia" -- Short for Cruciform Axe
	L.scythe = "Falce" -- Short for Dualblade Scythe
	L.trap = "Trappola" -- Short for Flameclasp Trap
	L.chains = "Catene" -- Short for Shadowsteel Chains
	L.embers = "Braci" -- Short for Shadowsteel Embers
	L.adds_embers = "Braci (%d) - Adds Tra Poco!"
	L.adds_killed = "Adds uccisi in %.2fs"
	L.spikes = "Palle Chiodate" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "itIT")
if L then
	L.bomb_missed = "%dx Bombe Mancate"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "itIT")
if L then
	L.rings = "Anelli"
	L.rings_active = "Anelli Attivi" -- for when they activate/are movable
	L.runes = "Rune"

	L.grimportent_countdown = "Conto alla Rovescia"
	L.grimportent_countdown_desc = "Conto alla Rovescia per i giocatori affetti da Portento Tetro"
	L.grimportent_countdown_bartext = "Vai sulla runa!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "itIT")
if L then
	L.spikes = "Scheggie" -- Short for Glacial Spikes
	L.spike = "Scheggia"
	L.miasma = "Miasma" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	L.custom_on_nameplate_fixate_desc = "Mostra un'icona sul Devota Vincolagelo che ti sta braccando.\n\nRichiede l'uso dei Nameplates del nemico e un'appon per nameplates supportato (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "itIT")
if L then
	L.chains_active = "Catene Attive"
	L.chains_active_desc = "Mostra una barra quando Catene del Dominio è attivo"

	L.custom_on_nameplate_fixate = "Icona Nameplate Rabbia"
	L.custom_on_nameplate_fixate_desc = "Mostra un'icona sul nameplate della Sentinella Oscura che ha preso di mira te.\n\nRichiede l'uso dei Nameplates del nemico e un'appon per nameplates supportato (KuiNameplates, Plater)."

	--L.intermission_chains = "Intermission Chains"
	L.chains = "Catene" -- Short for Domination Chains
	L.chain = "Catena" -- Single Domination Chain
	L.darkness = "Oscurità" -- Short for Veil of Darkness
	L.arrow = "Freccia" -- Short for Wailing Arrow
	--L.arrow_done = "DONE" -- Message when the arrow has hit
	L.wave = "Ondata" -- Short for Haunting Wave
	L.dread = "Terrore" -- Short for Crushing Dread
	L.scream = "Urlo" -- Banshee Scream

	L.knife_fling = "Coltelli!" -- "Death-touched blades fling out"
	--L.bridges = "Bridges"
	--L.rive_counter = "%s (%d/%d)"
	--L.soaks = "Soaks" -- Merciless
	--L.count_x = "%s (x%d)(%d)"
	--L.shroud_active = "Shroud (%d) - %.1f%%!"
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "itIT")
if L then
	L.custom_on_bar_icon = "Icona Barra"
	L.custom_on_bar_icon_desc = "Mostra l'icona dell'Incursione Predestinata sulle barre."

	L.chaotic_essence = "Essenza"
	L.creation_spark = "Scintille"
	L.protoform_barrier = "Barriera"
	L.reconfiguration_emitter = "Interrompi Add"
end

-- Sepulcher of the First Ones

L = BigWigs:NewBossLocale("Vigilant Guardian", "itIT")
if L then
	L.sentry = "Add da Tankare"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "itIT")
if L then
	L.tank_combo_desc = "Conto alla Rovescia per il lancio di Fendifauce/Squartamento al raggiungimento di 100 energia."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "itIT")
if L then
	L.sparknova = "Nova Scintillante" -- Hyperlight Sparknova
	L.relocation = "Bomba sul Difensore" -- Glyph of Relocation
	L.relocation_count = "%s S%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "Tunnel Spaziotemporali" -- Interdimensional Wormholes
	L.wormhole = "Tunnel Spaziotemporale" -- Interdimensional Wormhole
	L.rings = "Anelli S%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "itIT")
if L then
	L.staggering_barrage = "Raffica" -- Staggering Barrage
	L.obliteration_arc = "Arco" -- Obliteration Arc

	L.disintergration_halo = "Anelli" -- Disintegration Halo
	L.rings_x = "Anello x%d"
	L.rings_enrage = "Anelli (Enrage)"
	L.ring_count = "Anello (%d/%d)"

	L.custom_on_ring_timers = "Timer Individuali Aureola"
	L.custom_on_ring_timers_desc = "Aureola Disintegrante attiva una serie di anelli, verranno mostrate barre per quando questi anelli inizieranno a muoversi. Usa le impostazioni di Aureola Disintegrante."

	L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "itIT")
if L then
	L.necrotic_ritual = "Rituale"
	L.runecarvers_deathtouch = "Tocco Mortale"
	L.windswept_wings = "Spazzata"
	L.wild_stampede = "Impeto"
	L.withering_seeds = "Semi"
	L.hand_of_destruction = "Mano"
	L.nighthunter_marks_additional_desc = "|cFFFF0000Marcamento con priorità per i combattenti corpo a corpo con i primi simboli e uso del loro posizionamento fisico nell'Incursione come priorità secondaria.|r"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "itIT")
if L then
	L.protoform_cascade = "Frontale"
	L.cosmic_shift = "Respingimento"
	L.cosmic_shift_mythic = "Cambio: %s"
	L.unstable_mote = "Granuli"
	L.mote = "Granulo"

	L.custom_on_nameplate_fixate = "Icona Barra del Nome Fissa"
	L.custom_on_nameplate_fixate_desc = "Mostra un'icona sulla Barra del nome dell'Automa dell'Acquisizione che ha preso te come bersaglio.\n\nRichiede l'uso delle B arre del Nome del Nemico e un'addon per nameplates supportato (KuiNameplates, Plater)."

	L.harmonic = "Spingere"
	L.melodic = "Tirare"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "itIT")
if L then
	L.custom_off_repeating_blasphemy = "Ripetizione Blasfemia"
	L.custom_off_repeating_blasphemy_desc = "Ripetizione Blasfemia fa parlare il personaggio con le icone {rt1}, {rt3} per trovare la corrispondenza che elimina il tuo maleficio."

	L.kingsmourne_hungers = "Fame di Dominanima"
	L.blasphemy = "Marchi"
	L.befouled_barrier = "Barriera"
	L.wicked_star = "Stella"
	L.domination_word_pain = "Parola del Dominio: Dolore "
	L.army_of_the_dead = "Armata"
	L.grim_reflections = "Controlla Adds"
	L.march_of_the_damned = "Muri"
	L.dire_blasphemy = "Simboli"

	L.remnant_active = "Residuo Attivo"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "itIT")
if L then
	L.seismic_tremors = "Granuli + Tremori"
	L.earthbreaker_missiles = "Missili"
	L.crushing_prism = "Prismi"
	L.prism = "Prisma"
	L.ephemeral_fissure = "Fessura"

	L.bomb_dropped = "Bomba rilasciata"
	L.volatile_charges_new = "Nuove Bombe!"

	L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Lords of Dread", "itIT")
if L then
	L.unto_darkness = "Fase AoE"
	L.cloud_of_carrion = "Nube Necrotica"
	L.empowered_cloud_of_carrion = "Nube Potenziata" -- Empowered Cloud of Carrion
	L.leeching_claws = "Frontale (Mal'Ganis)"
	L.infiltration_of_dread = "Tra di Noi"
	L.infiltration_removed = "Impostori trovati in %.1fs" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "Trepidazione"
	L.slumber_cloud = "Nubi"
	L.anguishing_strike = "Frontale (Kintessa)"

	L.custom_on_repeating_biting_wound = "Accumulo Ferite Pungenti"
	L.custom_on_repeating_biting_wound_desc = "Accumulo Ferite Pungenti fa' parlare con messaggi ed icone {rt7} per renderlo più visibile."
end

L = BigWigs:NewBossLocale("Rygelon", "itIT")
if L then
	L.celestial_collapse = "Quasars"
	L.manifest_cosmos = "Nuclei"
	L.stellar_shroud = "Assorbimento Cure"
	L.knock = "Rinculo" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "itIT")
if L then
	L.rune_of_damnation_countdown = "Conto alla rovescia"
	L.rune_of_damnation_countdown_desc = "Conto alla rovescia per i giocatori afflitti da Runa della Dannazione"
	L.jump = "Salta dentro"

	L.relentless_domination = "Dominazione"
	L.chains_of_oppression = "Tirare le Catene"
	L.unholy_attunement = "Piloni"
	L.shattering_blast = "Esplosione sul Tank"
	L.rune_of_compulsion = "Ammaliamenti"
	L.desolation = "Assorbimento Azeroth"
	L.decimator_line = "Decimatore + Linea"
	L.chains_of_anguish = "Distribuire le Catene"
	L.chain = "Catena"
	L.chain_target = "Incatenato: %s!"
	L.chains_remaining = "%d/%d Catene Spezzate"
	L.rune_of_domination = "Assorbimento di Gruppo"

	L.final = "Ultimo %s" -- Final Unholy Attunement/Domination (last spell of a stage)

	L.azeroth_health = "Salute di Azeroth"
	L.azeroth_health_desc = "Avvisi per Salute di Azeroth"

	L.azeroth_new_health_plus = "Salute di Azeroth: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "Salute di Azeroth: -%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "Timing per gli assorbimenti del Sangue in Fase 1"
	L.mythic_blood_soak_stage_1_desc = "Mostra una barra per illustrare quale è il timing migliore per curare Azeroth, usata dall'Eco dopo la prima uccisione."
	L.mythic_blood_soak_stage_2 = "Timing per gli assorbimenti del Sangue in Fase 2"
	L.mythic_blood_soak_stage_2_desc = "Mostra una barra per illustrare quale è il timing migliore per curare Azeroth, usata dall'Eco dopo la prima uccisione."
	L.mythic_blood_soak_stage_3 = "Timing per gli assorbimenti del Sangue in Fase 3"
	L.mythic_blood_soak_stage_3_desc = "Mostra una barra per illustrare quale è il timing migliore per curare Azeroth, usata dall'Eco dopo la prima uccisione."
	L.mythic_blood_soak_bar = "Cura Azeroth"

	L.floors_open = "Pavimento Aperto"
	L.floors_open_desc = "Timer per l'apertura del pavimento per poi successivamente saltare dentro i buchi."

	L.mythic_dispel_stage_4 = "Timer per le Dissoluzioni"
	L.mythic_dispel_stage_4_desc = "Timers for when to do dispels nell'ultima fase, usata dagli Echo on their first kill"
	L.mythic_dispel_bar = "Dissoluzioni"
end

L = BigWigs:NewBossLocale("Sepulcher of the First Ones Affixes", "itIT")
if L then
	L.custom_on_bar_icon = "Icona Barra"
	L.custom_on_bar_icon_desc = "Mostra l'icona dell'Incursione Predestinata sulle barre."

	L.chaotic_essence = "Essenza"
	L.creation_spark = "Scintille"
	L.protoform_barrier = "Barriera"
	L.reconfiguration_emitter = "Interrompi Add"
end
