-- Castle Nathria

local L = BigWigs:NewBossLocale("Shriekwing", "ptBR")
if L then
	L.pickup_lantern = "%s pegou a lanterna!"
	L.dropped_lantern = "Lanterna derrubada por %s!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "ptBR")
if L then
	L.killed = "%s Morto"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "ptBR")
if L then
	L.shield_remaining = "%s restante: %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "ptBR")
if L then
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "Repetir grito da quantidade de vida com Miasma"
	L.custom_on_repeating_yell_miasma_desc = "Mensagens gritadas repetitivas para o Miasma, para ajudar os outros saberem quando você está abaixo de 75% de vida."

	L.custom_on_repeating_say_laser = "Repetir dizer Ejeção Volátil"
	L.custom_on_repeating_say_laser_desc = "Mensagens ditas repetitivas para Ejeção Volátil, para ajudar os outros a se moverem."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "ptBR")
if L then
	L.tear = "Rasgo" -- Short for Dimensional Tear
	L.seeds = "Sementes" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "ptBR")
if L then
	L.times = "%dx %s"

	L.level = "%s (Nível |cffffff00%d|r)"
	L.full = "%s (|cffff0000CHEIO|r)"

	L.anima_adds = "Adds da Ânima Concentrada"
	L.anima_adds_desc = "Mostra um temporizador para quando os adds surgem dos debuffs de Ânima Concentrada."

	L.custom_off_experimental = "Habilitar funcionalidades experimentais"
	L.custom_off_experimental_desc = "Essas funcionalidades |cffff0000não foram testadas|r e podem causar |cffff0000spam|r."

	L.anima_tracking = "Rastreamento de Ânima |cffff0000(Experimental)|r"
	L.anima_tracking_desc = "Mensagens e barras para rastrear os níveis de ânima nos contêiners.|n|cffaaff00Dica: Você pode desativar a caixa de informação ou as barras, dependendo da sua preferência."

	L.desires = "Desejos"
	L.bottles = "Garrafas"
	L.sins = "Pecados"
end

L = BigWigs:NewBossLocale("The Council of Blood", "ptBR")
if L then
	L.custom_on_repeating_dark_recital = "Repetir Recital Sombrio"
	L.custom_on_repeating_dark_recital_desc = "Repetir Recital Sombrio diz mensagens com ícones {rt1}, {rt2} para encontrar seu parceiro de dança."

	L.dance_assist = "Assistente de Dança"
	L.dance_assist_desc = "Mostra avisos direcionais para o estágio da dança."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Dance pra Frente |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Dance pra Direita |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Dance pra Baixo |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Dance pra Esquerda |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "Quadril pra frente!" -- Prance Forward!
	L.dance_yell_right = "Requebra pra direita!" -- Shimmy right!
	L.dance_yell_down = "Rebola embaixo!" -- Boogie down!
	L.dance_yell_down_2 = "Rebola embaixo!" -- Boogie down!
	L.dance_yell_left = "Quebra pra esquerda!" -- Sashay left!
end

L = BigWigs:NewBossLocale("Sludgefist", "ptBR")
if L then
	L.stomp_shift = "Pisada & Mudança" -- Destructive Stomp + Seismic Shift

	L.fun_info = "Informação de Dano"
	L.fun_info_desc = "Mostra uma mensagem dizendo o quanto de vida o chefe perdeu duarnte o Impacto Destrutivo."

	L.health_lost = "Punholodo perdeu %.1f%%!"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "ptBR")
if L then
	L.first_blade = "Primeira Lâmina"
	L.second_blade = "Segunda Lâmina"

	L.skirmishers = "Escaramuçadores" -- Short for Stone Legion Skirmishers
	L.eruption = "Erupção" -- Short for Reverberating Eruption

	L.goliath_short = "Golias"
	L.goliath_desc = "Mostra avisos e temporizadores para quando forem surgir os Golias da Legião de Pedra."

	L.commando_short = "Comando"
	L.commando_desc = "Mostra avisos de quando um Comando da Legião de Pedra é morto."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "ptBR")
if L then
	L.infobox_stacks = "%d |4Pilha:Pilhas;: %d |4jogador:jogadores;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "Repetir grito de Caçador Noturno"
	L.custom_on_repeating_nighthunter_desc = "Mensagens gritadas repetitivas para a habilidade Caçador Noturno usando ícones {rt1} ou {rt2} ou {rt3} para encontrar seu alinhamento se você for fazer o soak."

	L.custom_on_repeating_impale = "Repetir dizer Impalado"
	L.custom_on_repeating_impale_desc = "Dizer mensagens repetitivas para a habilidade Impalar, usando '1' ou '22' ou '333' ou '4444' para deixar claro em qual ordem você será acertado."

	L.hymn_stacks = "Hino Nathriano"
	L.hymn_stacks_desc = "Alertas para a quantidade de pilhas de Hino Nathriano que estão em você."

	L.ravage_target = "Reflexão: Barra de Conjuração no Alvo de Assolar"
	L.ravage_target_desc = "Uma barra de conjuração mostrando o tempo até a reflexão marcar a localização para Assolar."
	L.ravage_targeted = "Assolar no Alvo" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "Sem Espelho: %d" -- Player amount that does not have the Through the Mirror
	L.mirror = "Espelho: %d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "ptBR")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "Moldovaak"
	L.caramain = "Caraman"
	L.sindrel = "Sindrel"
	L.hargitas = "Hargitas"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "Gargono Colossal"
	L.hawkeye = "Espia Nathriano"
	L.overseer = "Feitora do Canil"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "Devorador Medonho"
	L.rat = "Rato de Tamanho Anormal"
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "Deplina"
	L.dragost = "Dragost"
	L.kullan = "Kullan"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "Antiquária Sinistra"
	L.conservator = "Conservador Nathriano"
	L.archivist = "Arquivista-chefe Nathriana"
	L.hierarch = "Hierarca da Corte"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "Golias da Legião de Pedra"
end

L = BigWigs:NewBossLocale("Castle Nathria Affixes", "ptBR")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "Centelhas"
	L.protoform_barrier = "Barreira"
	--L.reconfiguration_emitter = "Interrupt Add"
end

-- Sanctum of Domination

L = BigWigs:NewBossLocale("The Tarragrue", "ptBR")
if L then
	L.chains = "Correntes" -- Chains of Eternity (Chains)
	L.remnants = "Resquícios" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "Resquício Físico"
	L.magic_remnant = "Resquício Mágico"
	L.fire_remnant = "Resquício de Fogo"
	L.fire = "Fogo"
	L.magic = "Mágico"
	L.physical = "Físico"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "ptBR")
if L then
	L.chains = "Correntes" -- Short for Dragging Chains
	L.death_gaze = "Mirada da Morte" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "ptBR")
if L then
	L.fragments = "Fragmentos" -- Short for Fragments of Destiny
	L.fragment = "Fragmento" -- Singular Fragment of Destiny
	L.run_away = "Corra pra longe" -- Wings of Rage
	L.song = "Canção" -- Short for Song of Dissolution
	L.go_in = "Vá para dentro" -- Reverberating Refrain
	L.valkyr = "Val'kyren" -- Short for Call of the Val'kyr
	L.blades = "Lâminas" -- Agatha's Eternal Blade
	L.big_bombs = "Bombas Grandes" -- Daschla's Mighty Impact
	L.big_bomb = "Bomba Grande" -- Attached to the countdown
	L.shield = "Escudo" -- Annhylde's Bright Aegis
	L.soaks = "Soaks" -- Aradne's Falling Strike
	L.small_bombs = "Bombas Pequenas" -- Brynja's Mournful Dirge
	L.recall = "Revocação" -- Short for Word of Recall

	L.blades_yell = "Morram pela minha lâmina!"
	L.soaks_yell = "Vocês estão em desvantajem!"
	L.shield_yell = "Meu escudo jamais estremece!"

	L.berserk_stage1 = "Estágio 1 do Berserk"
	L.berserk_stage2 = "Estágio 2 do Berserk"

	L.image_special = "%s [Skyja]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "ptBR")
if L then
	L.cones = "Cones" -- Grasp of Malice
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "ptBR")
if L then
	L.custom_off_nameplate_defiance = "Ícone de placa de identificação para Defiance"
	L.custom_off_nameplate_defiance_desc = "Mostra um ícone na placa de identificação do Górjuro que tem Defiance.\n\nRequer o uso de Placas de Identificação Inimigas e um addon suportado (KuiNameplates, Plater)."

	L.custom_off_nameplate_tormented = "Ícone de placa de identificação para Atormentado"
	L.custom_off_nameplate_tormented_desc = "Mostra um ícone na placa de identificação do Górjuro que tem Atormentado.\n\nRequer o uso de Placas de Identificação Inimigas e um addon suportado (KuiNameplates, Plater)."

	L.cones = "Cones" -- Torment
	L.dance = "Dança" -- Encore of Torment
	L.brands = "Marcas" -- Brand of Torment
	L.brand = "Marca" -- Single Brand of Torment
	L.spike = "Espeto" -- Short for Agonizing Spike
	L.chains = "Correntes" -- Hellscream
	L.chain = "Corrente" -- Soul Manacles
	L.souls = "Almas" -- Rendered Soul

	L.chains_remaining = "%d Correntes restantes"
	L.all_broken = "Todas as Correntes foram quebradas"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "ptBR")
if L then
	L.hammer = "Martelo" -- Short for Rippling Hammer
	L.axe = "Machado" -- Short for Cruciform Axe
	L.scythe = "Foice" -- Short for Dualblade Scythe
	L.trap = "Armadilha" -- Short for Flameclasp Trap
	L.chains = "Correntes" -- Short for Shadowsteel Chains
	L.embers = "Brasas" -- Short for Shadowsteel Embers
	L.adds_embers = "Brasas (%d) - Inimigos Adicionais A Seguir!"
	L.adds_killed = "Inimigos Adicionais mortos em %.2fs"
	L.spikes = "Morte Espinhosa" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "ptBR")
if L then
	L.bomb_missed = "%dx Bombas Perdidas"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "ptBR")
if L then
	L.rings = "Anéis"
	L.rings_active = "Anéis Ativos" -- for when they activate/are movable
	L.runes = "Runas"

	L.grimportent_countdown = "Contagem Regressiva"
	L.grimportent_countdown_desc = "Contagem Regressiva para jogadores que estão afetados pelo Augúrio Temível"
	L.grimportent_countdown_bartext = "Vá para a runa!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "ptBR")
if L then
	L.spikes = "Espetos" -- Short for Glacial Spikes
	L.spike = "Espeto"
	L.miasma = "Miasma" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "Ícone de placa de identificação para Fixação"
	L.custom_on_nameplate_fixate_desc = "Mostra um ícone na placa de identificação para quando os Devotados Atagelo estão fixados em você.\n\nRequer o uso de Placas de Identificação Inimigas e um addon suportado  (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "ptBR")
if L then
	L.chains_active = "Correntes Ativas"
	L.chains_active_desc = "Mostra uma barra para quando as Correntes da Dominação forem ativadas"

	L.custom_on_nameplate_fixate = "Ícone de placa de identificação para Fixação"
	L.custom_on_nameplate_fixate_desc = "Mostra um ícone na placa de identificação para quando as Sentinelas Sombrias estão fixadas em você.\n\nRequer o uso de Placas de Identificação Inimigas e um addon suportado  (KuiNameplates, Plater)."

	--L.intermission_chains = "Intermission Chains"
	L.chains = "Correntes" -- Short for Domination Chains
	L.chain = "Corrente" -- Single Domination Chain
	L.darkness = "Trevas" -- Short for Veil of Darkness
	L.arrow = "Seta" -- Short for Wailing Arrow
	--L.arrow_done = "DONE" -- Message when the arrow has hit
	L.wave = "Onda" -- Short for Haunting Wave
	L.dread = "Pavor" -- Short for Crushing Dread
	L.scream = "Grito" -- Banshee Scream

	L.knife_fling = "Olha a faca!" -- "Death-touched blades fling out"
	--L.bridges = "Bridges"
	--L.rive_counter = "%s (%d/%d)"
	--L.soaks = "Soaks" -- Merciless
	--L.count_x = "%s (x%d)(%d)"
	--L.shroud_active = "Shroud (%d) - %.1f%%!"
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "ptBR")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "Centelhas"
	L.protoform_barrier = "Barreira"
	--L.reconfiguration_emitter = "Interrupt Add"
end

-- Sepulcher of the First Ones

L = BigWigs:NewBossLocale("Vigilant Guardian", "ptBR")
if L then
	L.sentry = "Tank Add"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "ptBR")
if L then
	L.tank_combo_desc = "Temporizador de habilidade para Gorja da Fenda/Dilacerar com 100 de energia."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "ptBR")
if L then
	L.sparknova = "Nova Centelhante de Hiperluz" -- Hyperlight Sparknova
	L.relocation = "Tank Bomb" -- Glyph of Relocation
	L.relocation_count = "%s S%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "Rasgos Dimensionais" -- Interdimensional Wormholes
	L.wormhole = "Rasgo Dimensional" -- Interdimensional Wormhole
	L.rings = "Aneis S%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "ptBR")
if L then
	L.staggering_barrage = "Bombardeio Cambaleante" -- Staggering Barrage
	L.obliteration_arc = "Arco da Obliteração" -- Obliteration Arc

	L.disintergration_halo = "Anéis" -- Disintegration Halo
	L.rings_x = "Anéis x%d"
	L.rings_enrage = "Anéis (Frenesi)"
	L.ring_count = "Anel (%d/%d)"

	L.custom_on_ring_timers = "Temporizador de anel individual"
	L.custom_on_ring_timers_desc = "Halo Desintegrador aciona um conjunto de anéis, esta opção mostrará barras quando cada um dos anéis começar a se mover. Usa as configurações do Halo Desintegrador."

	L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "ptBR")
if L then
	L.necrotic_ritual = "Ritual Necrótico"
	L.runecarvers_deathtouch = "Toque Mortal"
	L.windswept_wings = "Vento"
	L.wild_stampede = "Debandada"
	L.withering_seeds = "Sementes"
	L.hand_of_destruction = "Mão"
	L.nighthunter_marks_additional_desc = "|cFFFF0000Marcando com prioridade jogadores corpo a corpo nas primeiras marcações e usando a posição do grupo de raide como prioridade secundária.|r"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "ptBR")
if L then
	L.protoform_cascade = "Frontal"
	L.cosmic_shift = "Recuo"
	L.cosmic_shift_mythic = "Mudança: %s"
	L.unstable_mote = "Grânulos"
	L.mote = "Grânulo"

	L.custom_on_nameplate_fixate = "Icone de fixar nas placas de identificação"
	L.custom_on_nameplate_fixate_desc = "Mostra um ícone na placa de identificação em Automa de Aquisições que estão fixados em você.\n\nRequer o uso de placas de identificação de inimigos e um addon de placas de identificação suportado (KuiNameplates, Plater)."

	L.harmonic = "Empurrão"
	L.melodic = "Puxão"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "ptBR")
if L then
	L.custom_off_repeating_blasphemy = "Repetição de Blasfêmia"
	L.custom_off_repeating_blasphemy_desc = "Repetição de Blasfêmia fala mensagems com ícones {rt1}, {rt3} para encontrar pares para remover seus debuffs."

	L.kingsmourne_hungers = "Régio Lamento"
	L.blasphemy = "Marcas"
	L.befouled_barrier = "Barreira"
	L.wicked_star = "Estrela"
	L.domination_word_pain = "PD:Dor"
	L.army_of_the_dead = "Exército"
	L.grim_reflections = "Adds de Medo"
	L.march_of_the_damned = "Paredes"
	L.dire_blasphemy = "Marcas"

	L.remnant_active = "Remanescente ativo"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "ptBR")
if L then
	L.seismic_tremors = "Grânulos + Tremores"
	L.earthbreaker_missiles = "Mísseis"
	L.crushing_prism = "Prismas"
	L.prism = "Prisma"
	L.ephemeral_fissure = "Fenda"

	L.bomb_dropped = "Bomba Derrubada"
	--L.volatile_charges_new = "New Bombs!"

	L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Lords of Dread", "ptBR")
if L then
	L.unto_darkness = "Fase de AOE"
	L.cloud_of_carrion = "Podridão"
	L.empowered_cloud_of_carrion = "Grande podridão" -- Empowered Cloud of Carrion
	L.leeching_claws = "Frontal (M)"
	L.infiltration_of_dread = "Among Us"
	L.infiltration_removed = "Impostores encontrados em %.1fs" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "Medos"
	L.slumber_cloud = "Núvems"
	L.anguishing_strike = "Frontal (K)"

	L.custom_on_repeating_biting_wound = "Repetição de Feridas penetrantes"
	L.custom_on_repeating_biting_wound_desc = "Repetição de feridas penetrantes fala mensagems com ícone {rt7} para torná-lo mais visível."
end

L = BigWigs:NewBossLocale("Rygelon", "ptBR")
if L then
	L.celestial_collapse = "Quasares"
	L.manifest_cosmos = "Núcleos"
	L.stellar_shroud = "Absorve Cura"
	L.knock = "Empurrão" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "ptBR")
if L then
	L.rune_of_damnation_countdown = "Contagem"
	L.rune_of_damnation_countdown_desc = "Contagem para jogadores afetados por Runa de Danação"
	L.jump = "Pule dentro"

	L.relentless_domination = "Dominação"
	L.chains_of_oppression = "Puxão de Correntes"
	L.unholy_attunement = "Pilares"
	L.shattering_blast = "Impacto no Tank"
	L.rune_of_compulsion = "Enfeitiçar"
	L.desolation = "Soak de Azeroth"
	L.decimator_line = "Decimatore + Linha"
	L.chains_of_anguish = "Espalhar Correntes"
	L.chain = "Corrente"
	L.chain_target = "Acorrentando %s!"
	L.chains_remaining = "%d/%d Correntes Quebradas"
	L.rune_of_domination = "Soak em Grupo"

	L.final = "%s Final" -- Final Unholy Attunement/Domination (last spell of a stage)

	L.azeroth_health = "Saúde de Azeroth"
	L.azeroth_health_desc = "Avisos para Saúde de Azeroth"

	L.azeroth_new_health_plus = "Saúde de Azeroth: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "Saúde de Azeroth: -%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "Estágio 1, Temporizadores para soaks de sangue"
	L.mythic_blood_soak_stage_1_desc = "Mostra uma barra com temporizadores quando está em um bom momento para curar azeroth, usado pela Echo em sua primeira morte."
	L.mythic_blood_soak_stage_2 = "Estágio 2, Temporizadores para soaks de sangue"
	L.mythic_blood_soak_stage_2_desc = "Mostra uma barra com temporizadores quando está em um bom momento para curar azeroth, usado pela Echo em sua primeira morte."
	L.mythic_blood_soak_stage_3 = "Estágio 3, Temporizadores para soaks de sangue"
	L.mythic_blood_soak_stage_3_desc = "Mostra uma barra com temporizadores quando está em um bom momento para curar azeroth, usado pela Echo em sua primeira morte."
	L.mythic_blood_soak_bar = "Cure Azeroth"

	L.floors_open = "Abertura de chão"
	L.floors_open_desc = "Tempo até que o chão se abra e você possa cair em buracos abertos."

	L.mythic_dispel_stage_4 = "Tempos de Dispell"
	L.mythic_dispel_stage_4_desc = "Temporizadores para quando fazer dispell no último estágio, usado pela Echo em sua primeira morte"
	L.mythic_dispel_bar = "Dispels"
end

L = BigWigs:NewBossLocale("Sepulcher of the First Ones Affixes", "ptBR")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "Centelhas"
	L.protoform_barrier = "Barreira"
	--L.reconfiguration_emitter = "Interrupt Add"
end
