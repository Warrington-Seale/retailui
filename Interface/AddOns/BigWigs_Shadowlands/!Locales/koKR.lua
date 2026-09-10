-- Castle Nathria

local L = BigWigs:NewBossLocale("Shriekwing", "koKR")
if L then
	L.pickup_lantern = "%s 이(가) 등불을 들었습니다!"
	L.dropped_lantern = " %s 이(가) 등불 떨어트림!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "koKR")
if L then
	L.killed = "%s 죽음"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "koKR")
if L then
	--L.shield_remaining = "%s remaining: %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "koKR")
if L then
	L.miasma = "독기" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "반복적으로 독기 체력 외치기"
	L.custom_on_repeating_yell_miasma_desc = "독기에 걸렸을때 반복적으로 외침으로써 본인이 체력 75%미만일때 알림."

	L.custom_on_repeating_say_laser = "반복적으로 순간 방출 알리기"
	L.custom_on_repeating_say_laser_desc = "순간 방출 걸렸을때 반복적으로 말을 해서 혹시나 처음 메세지를 보지 못한 사람들에게 알리기."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "koKR")
if L then
	L.tear = "균열" -- Short for Dimensional Tear
	L.seeds = "씨앗" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "koKR")
if L then
	L.times = "%dx %s"

	L.level = "%s (Level |cffffff00%d|r)"
	L.full = "%s (|cffff0000FULL|r)"

	L.anima_adds = "농축된 령 쫄"
	L.anima_adds_desc = "농축된 령 쫄이 언제 생성되는 타이머 표시."

	L.custom_off_experimental = "실험적 기능 활성화"
	L.custom_off_experimental_desc = "이 기능들은 |cffff0000테스트되지 않았고|r 그렇기에 |cffff0000무분별하게 반복될수 있음|r."

	L.anima_tracking = "령 추적 |cffff0000(실험 중)|r"
	L.anima_tracking_desc = "메세지와 바로 령 용기에 있는 령 수치를 추적.|n|cffaaff00팁: 정보 박스나 바를 기호에 따라 비활성화해야 할 수도 있음."

	L.desires = "욕망"
	L.bottles = "병에 담긴 령"
	L.sins = "죄악"
end

L = BigWigs:NewBossLocale("The Council of Blood", "koKR")
if L then
	L.custom_on_repeating_dark_recital = "어둠의 무도회 지속적으로 표시"
	L.custom_on_repeating_dark_recital_desc = "지속적으로  {rt1}, {rt2}  로 표시를 해서 본인의 짝을 찾을수 있도록 표시."

	L.dance_assist = "춤 도우미"
	L.dance_assist_desc = "춤출때 방향 표시."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t 앞으로 |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t 오른쪽으로 |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t 밑으로 |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t 왼쪽으로 |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "앞으로" -- Prance Forward!
	L.dance_yell_right = "오른쪽으로" -- Shimmy right!
	L.dance_yell_down = "밑으로" -- Boogie down!
	L.dance_yell_down_2 = "밑으로" -- Boogie down!
	L.dance_yell_left = "왼쪽으로" -- Sashay left!
end

L = BigWigs:NewBossLocale("Sludgefist", "koKR")
if L then
	L.stomp_shift = "발구르기 & 지진" -- Destructive Stomp + Seismic Shift

	L.fun_info = "데미지 표시"
	L.fun_info_desc = "파괴의 충격 중 얼마나 체력을 많이 뺐는가를 메세지로 표시."

	L.health_lost = "진흙주먹의 체력을 %.1f%% 만큼 깎았습니다!"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "koKR")
if L then
	L.first_blade = "첫번째 칼날"
	L.second_blade = "두번째 칼날"

	L.skirmishers = "척후병" -- Short for Stone Legion Skirmishers
	L.eruption = "분출" -- Short for Reverberating Eruption

	L.goliath_short = "거수"
	L.goliath_desc = "돌 군단 거수가 언제 나오는지 경고와 타이머 표시."

	L.commando_short = "특공대원"
	L.commando_desc = "돌 군단 특공대원이 잡혔을때 경고 표시."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "koKR")
if L then
	L.infobox_stacks = "%d 중첩: %d 명" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "반복적으로 밤의 사냥꾼 외치기"
	L.custom_on_repeating_nighthunter_desc = "밤의 사냥꾼 능력을 {rt1} 나 {rt2} 나 {rt3} 로 반복적으로 표시해서 맞아줘야 하는 선 찾기 쉽게 하기."

	L.custom_on_repeating_impale = "반복적으로 꿰뚫기 말하기"
	L.custom_on_repeating_impale_desc = "꿰뚫기에 걸렸을때 '1' 이나 '22' 나 '333' 이나 '4444' 로 계속 말해서 어떤 순서로 맞는지 명확하게 하기."

	L.hymn_stacks = "나스리아의 찬가"
	L.hymn_stacks_desc = "현재 본인에게 있는 나스리아의 찬가 중첩 갯수 알림."

	L.ravage_target = "사악한 환영: 유린 방향 시전바"
	L.ravage_target_desc = "사악한 환영이 유린을 어디로 쓸지 결정할때까지의 시간을 표시해주는 시전바."
	L.ravage_targeted = "유린 방향 결정" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "거울 없음: %d" -- Player amount that does not have the Through the Mirror
	L.mirror = "거울: %d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "koKR")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "몰도바크"
	L.caramain = "카라메인"
	L.sindrel = "신드렐"
	L.hargitas = "하르지타스"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "덩치 큰 가르곤"
	L.hawkeye = "나스리아 명사수"
	L.overseer = "사육장 감독관"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "공포의 탐식자"
	L.rat = "비정상적인 크기의 쥐"
	L.miasma = "독기" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "디플리나"
	L.dragost = "드래고스트"
	L.kullan = "쿨란"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "사악한 골동품 수집가"
	L.conservator = "나스리아 정원지기"
	L.archivist = "나스리아 기록관"
	L.hierarch = "궁정 신관"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "돌 군단 거수"
end

L = BigWigs:NewBossLocale("Castle Nathria Affixes", "koKR")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "불꽃"
	L.protoform_barrier = "보호막"
	--L.reconfiguration_emitter = "Interrupt Add"
end

-- Sanctum of Domination

L = BigWigs:NewBossLocale("The Tarragrue", "koKR")
if L then
	L.chains = "사슬" -- Chains of Eternity (Chains)
	L.remnants = "잔재" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "물리 잔재"
	L.magic_remnant = "마법 잔재"
	L.fire_remnant = "화염 잔재"
	L.fire = "화염"
	L.magic = "마법"
	L.physical = "물리"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "koKR")
if L then
	L.chains = "사슬" -- Short for Dragging Chains
	L.death_gaze = "죽음의 시선" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "koKR")
if L then
	L.fragments = "파편" -- Short for Fragments of Destiny
	L.fragment = "파편" -- Singular Fragment of Destiny
	L.run_away = "카이라에서 멀어지기!" -- Wings of Rage
	L.song = "노래" -- Short for Song of Dissolution
	L.go_in = "시그니로 접근!" -- Reverberating Refrain
	L.valkyr = "발키르" -- Short for Call of the Val'kyr
	L.blades = "칼날" -- Agatha's Eternal Blade
	L.big_bombs = "쎈 폭탄" -- Daschla's Mighty Impact
	L.big_bomb = "쎈 폭탄" -- Attached to the countdown
	L.shield = "방패" -- Annhylde's Bright Aegis
	L.soaks = "바닥 맞기" -- Aradne's Falling Strike
	L.small_bombs = "약한 폭탄" -- Brynja's Mournful Dirge
	L.recall = "진언" -- Short for Word of Recall

	L.blades_yell = "Fall before my blade!"
	L.soaks_yell = "You are all outmatched!"
	L.shield_yell = "My shield never falters!"

	L.berserk_stage1 = "1페이즈 광폭화"
	L.berserk_stage2 = "2페이즈 광폭화"

	L.image_special = "%s [스키야]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "koKR")
if L then
	L.cones = "바닥" -- Grasp of Malice
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "koKR")
if L then
	L.custom_off_nameplate_defiance = "저항 네임플레이트 아이콘"
	L.custom_off_nameplate_defiance_desc = "나락살이의 네임플레이트에 저항 아이콘을 표시합니다.\n\n네임플레이트 애드온과 적 네임플레이트 활성화 필요(KuiNameplates, Plater)."

	L.custom_off_nameplate_tormented = "고문 네임플레이트 아이콘"
	L.custom_off_nameplate_tormented_desc = "나락살이의 네임플레이트에 고문 아이콘을 표시합니다.\n\n네임플레이트 애드온과 적 네임플레이트 활성화 필요 (KuiNameplates, Plater)."

	L.cones = "바닥" -- Torment
	L.dance = "바닥" -- Encore of Torment
	L.brands = "낙인" -- Brand of Torment
	L.brand = "낙인" -- Single Brand of Torment
	L.spike = "쐐기" -- Short for Agonizing Spike
	L.chains = "족쇄" -- Hellscream
	L.chain = "수갑" -- Soul Manacles
	L.souls = "영혼" -- Rendered Soul

	L.chains_remaining = "족쇄 %d 개 남음"
	L.all_broken = "족쇄 올 클리어"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "koKR")
if L then
	L.hammer = "망치" -- Short for Rippling Hammer
	L.axe = "도끼" -- Short for Cruciform Axe
	L.scythe = "낫" -- Short for Dualblade Scythe
	L.trap = "덫" -- Short for Flameclasp Trap
	L.chains = "사슬" -- Short for Shadowsteel Chains
	L.embers = "불씨" -- Short for Shadowsteel Embers
	--L.adds_embers = "Embers (%d) - Adds Next!"
	--L.adds_killed = "Adds killed in %.2fs"
	--L.spikes = "Spiked Death" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "koKR")
if L then
	--L.bomb_missed = "%dx Bombs Missed"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "koKR")
if L then
	L.rings = "굴레"
	L.rings_active = "굴레 활성화" -- for when they activate/are movable
	L.runes = "룬"

	L.grimportent_countdown = "초읽기"
	L.grimportent_countdown_desc = "음산한 징조에 걸린 플레이어들을 위한 초읽기"
	L.grimportent_countdown_bartext = "룬으로 이동!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "koKR")
if L then
	L.spikes = "쐐기" -- Short for Glacial Spikes
	L.spike = "쐐기"
	L.miasma = "독기" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "시선집중 네임플레이트 아이콘"
	L.custom_on_nameplate_fixate_desc = "헌신자의 네임플레이트에 시선집중 아이콘을 표시합니다.\n\n네임플레이트 애드온과 적 네임플레이트 활성화 필요(KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "koKR")
if L then
	L.chains_active = "사슬 활성화"
	L.chains_active_desc = "지배의 사슬이 활성화될때를 보여주는 바 표시"

	--L.custom_on_nameplate_fixate = "시선집중 네임플레이트 아이콘"
	--L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Dark Sentinels that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."

	--L.intermission_chains = "Intermission Chains"
	L.chains = "사슬" -- Short for Domination Chains
	L.chain = "사슬" -- Single Domination Chain
	L.darkness = "장막" -- Short for Veil of Darkness
	L.arrow = "화살" -- Short for Wailing Arrow
	--L.arrow_done = "DONE" -- Message when the arrow has hit
	L.wave = "파도" -- Short for Haunting Wave
	L.dread = "공포" -- Short for Crushing Dread
	L.scream = "비명" -- Banshee Scream

	L.knife_fling = "비수 조심!" -- "Death-touched blades fling out"
	--L.bridges = "Bridges"
	--L.rive_counter = "%s (%d/%d)"
	--L.soaks = "Soaks" -- Merciless
	--L.count_x = "%s (x%d)(%d)"
	--L.shroud_active = "Shroud (%d) - %.1f%%!"
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "koKR")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "불꽃"
	L.protoform_barrier = "보호막"
	--L.reconfiguration_emitter = "Interrupt Add"
end

-- Sepulcher of the First Ones

L = BigWigs:NewBossLocale("Vigilant Guardian", "koKR")
if L then
	L.sentry = "탱 쫄"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "koKR")
if L then
	L.tank_combo_desc = "기력 100일때 균열 아귀/난도질 타이머."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "koKR")
if L then
	L.sparknova = "초광속 불꽃 회오리" -- Hyperlight Sparknova
	L.relocation = "탱 폭탄" -- Glyph of Relocation
	--L.relocation_count = "%s S%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "차원 균열" -- Interdimensional Wormholes
	L.wormhole = "차원 균열" -- Interdimensional Wormhole
	L.rings = "%d 페이즈 고리" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "koKR")
if L then
	L.staggering_barrage = "탄막" -- Staggering Barrage
	L.obliteration_arc = "절멸" -- Obliteration Arc

	L.disintergration_halo = "후광" -- Disintegration Halo
	L.rings_x = "후광 x%d"
	L.rings_enrage = "후광 (광폭)"
	L.ring_count = "후광 (%d/%d)"

	L.custom_on_ring_timers = "개별 후광 타이머"
	L.custom_on_ring_timers_desc = "분해의 후광은 고리를 한 세트로 생성합니다. 이 옵션은 각각 고리가 언제 퍼지기 시작하는지 보여줍니다. 분해의 후광의 설정을 사용함."

	L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "koKR")
if L then
	L.necrotic_ritual = "괴저 의식"
	L.runecarvers_deathtouch = "죽음의 손길"
	L.windswept_wings = "바람"
	L.wild_stampede = "쇄도"
	L.withering_seeds = "씨앗"
	L.hand_of_destruction = "파괴의 손"
	--L.nighthunter_marks_additional_desc = "|cFFFF0000Marking with a priority for melee on the first markers and using their raid group position as secondary priority.|r"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "koKR")
if L then
	L.protoform_cascade = "구슬 조심"
	L.cosmic_shift = "넉백"
	L.cosmic_shift_mythic = "넉백: %s"
	L.unstable_mote = "불안정한 티끌"
	L.mote = "티끌"

	L.custom_on_nameplate_fixate = "시선고정 네임플레이트 아이콘"
	L.custom_on_nameplate_fixate_desc = "본인에게 시선고정된 수집 자동기계의 네임플레이트에 아이콘을 표시합니다.\n\n적 네임플레이트 활성화 및 지원하는 네임플레이트 애드온이 필요함(KuiNameplates, Plater)."

	L.harmonic = "밀기"
	L.melodic = "당기기"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "koKR")
if L then
	L.custom_off_repeating_blasphemy = "신성 모독 계속 알림"
	L.custom_off_repeating_blasphemy_desc = "신성 모독 걸렸을 때 자동으로 {rt1}, {rt3} 를 표시해서 짝을 찾아 디버프 없애기."

	L.kingsmourne_hungers = "사자한"
	L.blasphemy = "징표"
	L.befouled_barrier = "치유량 흡수 방벽"
	L.wicked_star = "부메랑"
	L.domination_word_pain = "고통"
	L.army_of_the_dead = "사군"
	L.grim_reflections = "공포 쫄"
	L.march_of_the_damned = "행진"
	L.dire_blasphemy = "징표"

	L.remnant_active = "잔재 활성화"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "koKR")
if L then
	L.seismic_tremors = "지진 진동 + 티끌 생성"
	L.earthbreaker_missiles = "투사체"
	L.crushing_prism = "분광경"
	L.prism = "분광경"
	L.ephemeral_fissure = "균열"

	L.bomb_dropped = "폭탄 떨어트림"
	--L.volatile_charges_new = "New Bombs!"

	L.absorb_text = "%s (%.0f%%)"
end

L = BigWigs:NewBossLocale("Lords of Dread", "koKR")
if L then
	L.unto_darkness = "광역기 페이즈"
	L.cloud_of_carrion = "부패의 구름"
	L.empowered_cloud_of_carrion = "아픈 부패의 구름" -- Empowered Cloud of Carrion
	L.leeching_claws = "전방기 (말가)"
	L.infiltration_of_dread = "어몽어스"
	L.infiltration_removed = " %.1f초만에 임포스터 컷!" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "공포"
	L.slumber_cloud = "수면 구름"
	L.anguishing_strike = "전방기 (킨테사)"

	--L.custom_on_repeating_biting_wound = "Repeating Biting Wound"
	--L.custom_on_repeating_biting_wound_desc = "Repeating Biting Wound say messages with icons {rt7} to make it more visible."
end

L = BigWigs:NewBossLocale("Rygelon", "koKR")
if L then
	L.celestial_collapse = "준항성"
	L.manifest_cosmos = "핵"
	L.stellar_shroud = "치유량 흡수"
	L.knock = "주변 넉백" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "koKR")
if L then
	L.rune_of_damnation_countdown = "초읽기"
	L.rune_of_damnation_countdown_desc = "저주의 룬에 걸린사람들을 위한 초읽기"
	L.jump = "뛰엇!"

	--L.relentless_domination = "Domination"
	L.chains_of_oppression = "고핀 사슬"
	L.unholy_attunement = "수정탑"
	--L.shattering_blast = "Tank Blast"
	L.rune_of_compulsion = "정배 룬"
	--L.desolation = "Azeroth Soak"
	L.decimator_line = "학살 + 선"
	L.chains_of_anguish = "산개 사슬"
	L.chain = "사슬"
	L.chain_target = " %s 에게 사슬!"
	L.chains_remaining = "%d/%d 사슬 파괴 완료"
	L.rune_of_domination = "같이 맞아주기"

	L.final = "이번 페이즈 마지막 %s" -- Final Unholy Attunement/Domination (last spell of a stage)

	L.azeroth_health = "아제로스 체력"
	L.azeroth_health_desc = "아제로스 체력 경고"

	L.azeroth_new_health_plus = "아제로스 체력: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "아제로스 체력: -%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "1페이즈 피 흡수 타이밍"
	L.mythic_blood_soak_stage_1_desc = "아제로스를 힐할수 있는 좋은 타이밍이 언제인지 보이기. 에코가 첫킬 당시 사용."
	L.mythic_blood_soak_stage_2 = "2페이즈 피 흡수 타이밍"
	L.mythic_blood_soak_stage_2_desc = "아제로스를 힐할수 있는 좋은 타이밍이 언제인지 보이기. 에코가 첫킬 당시 사용."
	L.mythic_blood_soak_stage_3 = "3페이즈 피 흡수 타이밍"
	L.mythic_blood_soak_stage_3_desc = "아제로스를 힐할수 있는 좋은 타이밍이 언제인지 보이기. 에코가 첫킬 당시 사용."
	L.mythic_blood_soak_bar = "아제로스 힐"

	L.floors_open = "바닥 열림"
	L.floors_open_desc = "떨어질 수 있게 바닥이 다시 열리기까지의 시간."

	L.mythic_dispel_stage_4 = "해제 타이머"
	L.mythic_dispel_stage_4_desc = "마지막 페이즈에 해제 타이밍- 에코가 첫킬 당시 사용."
	L.mythic_dispel_bar = "해제"
end

L = BigWigs:NewBossLocale("Sepulcher of the First Ones Affixes", "koKR")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "불꽃"
	L.protoform_barrier = "보호막"
	--L.reconfiguration_emitter = "Interrupt Add"
end
