local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "ALT_CRAFTING_END"
M.title = "Crafting & Delve Turn-ins"
M.defaultRadius = 5

M.routeId    = "MIDNIGHT_ALT"
M.routeTitle = "Midnight Alt 80-90"
M.routeOrder = 10

M.moduleOrder = 40
M.nextModuleId = "TBD" 

M.steps = {
    {
    title = "Important! Read First!",
    segments = {
      { kind = "MANUAL", key = "final_section_1", mapID = {2437}, radius = 10, x = 45.44, y = 65.00, text = "This section is primarily for people who followed the entire rest of the guide. It will direct you to finish your 30 first crafts and hand in all of the pre-completed quests throughout the route. If you're only interested in crafting, you can skip to that section of this module, but the rest of the steps will be useless for anyone approaching it out of order." },
      { kind = "MANUAL", key = "final_section_2", mapID = {2437}, radius = 10, x = 45.44, y = 65.00, text = "Generally speaking, you'll want to be around Level 85/86 before starting this section of the guide. This is not an ironclad rule, but it will usually allow you to reach level 90, depending on your Warband Mentor Bonus or other modifiers like Darkmoon Faire buff. Note that the guide will include a few bonus quests at the end, in case you barely fell short of Level 90." },
      --{ kind = "MANUAL", key = "final_section_7", mapID = {2437}, radius = 10, x = 45.44, y = 65.00, text = "If you have the 30% Turbulent Timeways buff, this recommendation can be moved up by roughly one level, to 84/85. Make sure you still have the buff during the entire turn-in process. If it's close to expiring, you may want to run a single additional dungeon to refresh the duration." },
      { kind = "MANUAL", key = "final_section_6", mapID = {2437}, radius = 10, x = 45.44, y = 65.00, text = "Just to reiterate, if you are short of the final turn-in threshold right now, you can continue following the routes in Eversong or Zul'Aman, wherever you left off, or you can navigate to the Sojourner modules in the addon. There are plenty of solid questlines that weren't directly included in the alt route, and they should be more than enough to get you up to Level 86." },
      { kind = "MANUAL", key = "final_section_3", mapID = {2437}, radius = 10, x = 45.44, y = 65.00, text = "You should also have War Mode on for the entirety of this section. I don't care if you're scared of PvP, 99% of this section takes place in sanctuary areas, it's a free 15% bonus at this point." },
      { kind = "MANUAL", key = "final_section_4", mapID = {2437}, radius = 10, x = 45.44, y = 65.00, text = "When turning in Delver's Call quests, be mindful of your current experience level. If you are about to level up, you should wait before handing in one of these quests. For example, if you are 1 bar away from Level 87, and you turn in a Delver's Call quest, it will cause you to level up, and you'll gain a lot of overflow XP into the next level. However, all of that XP is scaled to Level 86. If you had instead turned in some smaller quests or completed a few first crafts, barely hit 87, and THEN turned in the Delver's Call quest, it would give you XP scaled up to level 87. This is fairly minor (you lose ~2k XP each time it happens), but it is something to keep in mind if you want to be as efficient as possible with your turn-ins." },
      { kind = "PICKUP", questName = "Delver's Call: Atal'Aman", mapID = {2437}, showAfter = 5, questIDs = {93409}, x = 45.44, y = 65.00},
      { kind = "PICKUP", questName = "Delver's Call: Twilight Crypts", mapID = {2437}, showAfter = 5, questIDs = {93410}, x = 45.44, y = 65.00},
      { kind = "TURNIN", questName = "Delver's Call: Atal'Aman", mapID = {2437}, showAfter = 5, questIDs = {93409}, x = 45.44, y = 65.00},
      { kind = "TURNIN", questName = "Delver's Call: Twilight Crypts", mapID = {2437}, showAfter = 5, questIDs = {93410}, x = 45.44, y = 65.00},
      { kind = "MANUAL", key = "final_section_5", mapID = {2437}, showAfter = 5, radius = 10, x = 45.44, y = 65.00, text = "Use your Hearthstone to return to Fairbreeze Village." },
    },
  },
  {
    mapID = {2395},
    title = "Saltheril's Soiree Turn-Ins",
    segments = {
      { kind = "MANUAL", key = "saltherils_end_1", radius = 30, x = 42.65, y = 46.31, text = "Turn in your 'Fortify the Runestones' quest at the NPC for whichever faction you selected. If you somehow forgot to complete this quest, you should do it now." },
      { kind = "MANUAL", key = "saltherils_end_2", radius = 30, x = 42.65, y = 46.31, text = "If you completed any other quests unlocked via Saltheril's Favor, turn them in now. You may have chosen to unlock some and not complete them, which is totally fine." },
    },
  },
  {
    mapID = {2393},
    title = "Silvermoon Turn-Ins",
    segments = {
      { kind = "PICKUP", questName = "Delver's Call: Collegiate Calamity", questIDs = {93384}, x = 52.76, y = 77.90},
      { kind = "PICKUP", questName = "Delver's Call: Shadow Enclave", questIDs = {93372}, x = 52.76, y = 77.90},
      { kind = "PICKUP", questName = "Delver's Call: Parhelion Plaza", questIDs = {93386}, x = 52.76, y = 77.90},
      { kind = "PICKUP", questName = "Delver's Call: The Darkway", questIDs = {93385}, x = 52.54, y = 78.88},
      { kind = "TURNIN", questName = "Delver's Call: Collegiate Calamity", questIDs = {93384}, x = 52.76, y = 77.90},
      { kind = "TURNIN", questName = "Delver's Call: Shadow Enclave", questIDs = {93372}, x = 52.76, y = 77.90},
      { kind = "TURNIN", questName = "Delver's Call: Parhelion Plaza", questIDs = {93386}, x = 52.76, y = 77.90},
      { kind = "TURNIN", questName = "Delver's Call: The Darkway", questIDs = {93385}, x = 52.54, y = 78.88},
      { kind = "PICKUP", questName = "Hope in the Darkest Corners", mapID = {2393}, questIDs = {95468}, radius = 5, x = 49.10, y = 64.64},
      { kind = "TURNIN", questName = "Hope in the Darkest Corners", mapID = {2393}, questIDs = {95468}, radius = 5, x = 49.10, y = 64.64},
      --{ kind = "PICKUP", questName = "No Loose Ends", questIDs = {91827}, mapID = {2395}, x = 61.89, y = 68.33},
      --{ kind = "TURNIN", questName = "No Loose Ends", questIDs = {91827}, x = 45.43, y = 70.33},
      { kind = "PICKUP", questName = "Arator", questIDs = {89193}, x = 45.44, y = 70.33},
      { kind = "OBJECTIVE", questName = "Arator", questIDs = {89193}, x = 45.78, y = 65.79 , text = "Turn in {progress}." },
      { kind = "TURNIN", questName = "Arator", questIDs = {89193}, x = 45.78, y = 65.79},
      { kind = "NOTE", text = "The 'Arator' quest is obtained by selecting Arator's Journey on the scouting map. This is a free 2k XP." },
      --{ kind = "NOTE", text = "If you finished the route early and never obtained the quest 'No Loose Ends', you can skip to the next step of the guide." },
    },
  },
  {
    mapID = {2393},
    title = "Important Crafting Information",
    segments = {
      { kind = "MANUAL", key = "crafting_info_1", radius = 10, x = 45.67, y = 55.69, text = "The next few steps in the guide will help you get experience from crafting professions. Since this tends to be confusing for a lot of new players, I've included this step with detailed information about how the system works." },
      { kind = "MANUAL", key = "crafting_info_2", radius = 10, x = 45.67, y = 55.69, text = "The most important thing you need to understand is that prior experience with crafting is NOT AT ALL REQUIRED for this to be a viable strategy. In fact, this is EASIER if you have 0 experience with crafting. Veteran players may already have existing professions that they don't want to abandon, so it could be difficult for them to follow this guide. New players will be starting professions from scratch, and the guide is written with that assumption in mind." },
      { kind = "MANUAL", key = "crafting_info_9", radius = 10, x = 45.67, y = 55.69, text = "If you already completed your first crafts, or if you have an EXTREME aversion to crafting leveling (get over it tbh, it's cheap, simple, and fast), you'll need another ~75% of a level to reach Level 90 from this point. Return to the Eversong/Zul'Aman routes and complete additional quests until you've gotten another 75% of a level. Alternatively, you can finish the rest of this section and then quest at Level 89 until you're done. You'll have less risk of overshooting, but mob scaling will be more punishing." },
      { kind = "MANUAL", key = "crafting_info_3", showAfter = 3, radius = 10, x = 45.67, y = 55.69, text = "If you're worried about the gold cost for profession leveling, don't be. The setup recommended in my guide is extremely cheap, you've earned more than enough gold while leveling to afford this. If you find that the materials for a particular item are especially expensive for some reason, just skip that craft and do the other ones. Even if you don't complete every recommended craft, it's still a great source of XP." },
      { kind = "MANUAL", key = "crafting_info_4", showAfter = 4, radius = 10, x = 45.67, y = 55.69, text = "The experience earned from crafting is tied to something known as a 'First Craft Bonus'. You'll be able to see text in the crafting window which indicates whether something provides you with this bonus, and there's also a filter you can apply in the profession window which sorts your current recipes to only show ones that provide you with the bonus." },
      { kind = "MANUAL", key = "crafting_info_5", showAfter = 5, radius = 10, x = 45.67, y = 55.69, text = "In total, you can receive experience from 30 First Craft Bonuses. This 30 bonus cap is shared across ALL professions, but you can obtain it with any combination. So, for example, you can get all 30 crafts using Engineering, or you can get 15 with Engineering and 15 with Enchanting." },
      { kind = "MANUAL", key = "crafting_info_6", showAfter = 6, radius = 10, x = 45.67, y = 55.69, text = "The first 20 of 30 First Crafts provide you with a full quest's worth of experience each. The final 10 of 30 First Crafts have diminishing returns, so craft 21/30 provides 90% of a quest's worth of XP, craft 30/30 provides 10% of a quest's worth of XP. For this reason, it's not that big of a deal if you decide to skip the final few crafts to save a bit of gold." },
      { kind = "MANUAL", key = "crafting_info_7", showAfter = 7, radius = 10, x = 45.67, y = 55.69, text = "You can get your 30 first crafts from any profession, though some are obviously better than others. My guide will only include instructions for Engineering + Enchanting, as it is an incredibly cheap and fast combination. If you have existing professions that you don't want to clear, just figure out an optimal way to earn the 30 crafts on your own. I will not be adding additional first-craft recommendations for other professions unless I genuinely believe they are more efficient than my current Engi + Enchant setup." },
      { kind = "MANUAL", key = "crafting_info_8", showAfter = 8, radius = 10, x = 45.67, y = 55.69, text = "Although I have attempted to provide a crafting setup that is as cheap as possible, I will never be able to fully guarantee that it is THE cheapest setup. Prices fluctuate all the time, and some materials may increase in price due to the added demand from my guides. This is not an exaggeration. In TWW I recommended a full enchanting setup, and some players bought up some of the suggested materials in bulk and tried to jack up the market price after my guide was posted. Thankfully this setup uses very few rare materials, so it should be fairly safe from market fluctuations." },
    },
  },
  {
    mapID = {2393},
    title = "Crafting Start",
    segments = {
      { kind = "PICKUP", questName = "Crafters Needed", questIDs = {93723}, x = 45.01, y = 55.18},
      { kind = "OBJECTIVE", questName = "Crafters Needed", questIDs = {93723}, x = 45.00, y = 55.60 , text = "Speak to Mar'nah {progress}." },
      { kind = "MANUAL", key = "free_craftmat_1", showAfter = 1, radius = 10, x = 45.01, y = 55.18, text = "The reward from this quest lets you choose a bag of free crafting materials. There are multiple choices, I recommend 'Collection of Eversong Minerals'. Some of the materials are used for Engineering crafts, and they have a solid market value, so you can sell the leftovers for gold if you want." },
      { kind = "TURNIN", questName = "Crafters Needed", showAfter = 3, questIDs = {93723}, x = 45.01, y = 55.18},
    },
  },
  {
    mapID = {2393},
    title = "Engineering",
    segments = {
      { kind = "MANUAL", key = "crafting_engi_1", x = 43.52, y = 54.10, text = "Speak to Danwe and train Midnight Engineering, as well as all other available recipes." },
      { kind = "MANUAL", key = "crafting_engi_2", showAfter = 1, x = 43.47, y = 53.74, text = "Speak to the Engineering vendor, Yatheon. Purchase 1x Malleable Wireframe, and 21x Pile of Junk. You can also purchase an Arclight Spanner and Gyromatic Micro-Adjustor if you don't have them. These are baked into any crafting tools, if you have them, but for new players the vendor items will be cheaper." },
      { kind = "MANUAL", key = "crafting_engi_3", showAfter = 2, radius = 10, x = 51.10, y = 76.11, text = "Fly to the auction house, or locate a nearby player on a Brutosaur mount. Purchase the following items: 29x Evercore, 4x Mote of Wild Magic, 3x Mote of Primal Energy, 3x Mote of Light, 2x Mote of Pure Void, x5 Eversinging Dust. Quality is irrelevant, buy whichever is cheaper." },
      { kind = "PICKUP", questName = "Crafting Orders: Engineering", showAfter = 3, questIDs = {93727}, x = 45.01, y = 55.18},
      { kind = "OBJECTIVE", questName = "Crafting Orders: Engineering", showAfter = 3, questIDs = {93727}, x = 43.51, y = 53.97 , text = "Return to the Engineering Bench and interact with it {progress}." },
      { kind = "TURNIN", questName = "Crafting Orders: Engineering", questIDs = {93727}, x = 43.52, y = 54.10},
      { kind = "MANUAL", key = "crafting_engi_4", showAfter = 3, x = 43.52, y = 54.10, text = "You can pick up the quest 'Engineering Services Requested'. It's possible to complete this while leveling by finishing Patron Orders (found in the Crafting Orders tab of the Profession window), but there's no guarantee that the right crafts will be available, as they change every few hours. If you can find some cheap crafts to complete here, then the quest is a free 15k XP, but since it's RNG, I won't bake it into the guide." },
      { kind = "MANUAL", key = "crafting_engi_5", showAfter = 7, x = 43.51, y = 53.97, text = "The first items you'll craft to level Engineering are the leather goggles, Evercore Shades. This craft has an orange '2 ^' number to the left, which indicates that crafting it will provide you with 2 guaranteed skill-ups." },
      { kind = "MANUAL", key = "crafting_engi_6", showAfter = 8, x = 43.51, y = 53.97, text = "Craft Evercore Shades 15 times. This provides you with a single First Craft bonus, and it will get you to 31 Engineering Skill." },
      { kind = "MANUAL", key = "crafting_engi_7", showAfter = 9, x = 43.52, y = 54.10, text = "Speak to the trainer and learn the other helmet recipes, as well as the Evercore Dome Dinger and Soul Sprocket. In your profession window, select 'Filter', and check the box for 'First Craft Bonus'. Craft each of these recipes a single time (excluding Song Gear and Perfected Cogwheel). If you are lucky, you will reach 35 skill. If you are unlucky, just craft up to two additional Dome Dingers until you reach 35, as this recipe is guaranteed to give a skill up." },
      { kind = "MANUAL", key = "crafting_engi_8", showAfter = 10, x = 43.52, y = 54.10, text = "Speak to the trainer once again, learn every recipe that begins with the word 'Evercore'. Craft all of the remaining 'Evercore X' recipes a single time for the First Craft bonuses. You're now finished with Engineering. Do not vendor the items you made, they will be used for Disenchanting." },
    },
  },
  {
    mapID = {2393},
    title = "Enchanting",
    segments = {
      { kind = "MANUAL", key = "crafting_ench_1", x = 48.01, y = 53.85, text = "Speak to Dolothos and train Midnight Enchanting, as well as all other available recipes." },
      { kind = "MANUAL", key = "crafting_ench_2", showAfter = 1, x = 47.94, y = 53.44, text = "Speak to the Enchanting vendor, Lyna. Purchase 4x Enchanting Vellum, and 1x Refulgent Copper Rod." },
      { kind = "MANUAL", key = "crafting_ench_3", showAfter = 2, x = 47.98, y = 53.65, text = "Craft a single Runed Refulgent Copped Rod. Equip it." },
      { kind = "MANUAL", key = "crafting_ench_4", showAfter = 3, x = 47.98, y = 53.65, text = "Find the Disenchant ability in your Profession window and place it somewhere on your bars. Use this ability to break down any green or blue items sitting in your bags. You should have a ton left over from the leveling process. Ideally you should break down enough items to reach 20 Enchanting skill. Disenchanting isn't always guaranteed to provide a skillup, so the exact number of items will vary. Click the checkbox for this step once you've run out of items to disenchant." },
      { kind = "MANUAL", key = "crafting_ench_5", showAfter = 4, x = 47.98, y = 53.65, text = "You may notice a quest from the Enchanting trainer. This asks you for a random material, usually a Dawn Crystal. Currently these are extremely expensive, so it's not worth completing the quest. If you want to light some gold on fire, it is technically an 'easy' 15k XP." },
      { kind = "MANUAL", key = "crafting_ench_6", showAfter = 5, x = 51.10, y = 76.11, text = "After you finish Disenchanting, check how much Eversinging Dust (if any) you have in your bags. You will need x44 Eversinging Dust for the next step. Subtract whatever you have from this total, and buy the remaining dust off the auction house." },
      { kind = "MANUAL", key = "crafting_ench_7", showAfter = 6, x = 48.01, y = 53.85, text = "Speak to the trainer and learn the recipe for 'Enchant Ring - Thalassian Versatility'. Craft this recipe and 'Enchant Ring - Thalassian Haste'. You can either apply this enchant directly to one of your rings, or use it on a vellum." },
      { kind = "MANUAL", key = "crafting_ench_8", showAfter = 7, x = 39.54, y = 50.99, text = "Mount up and fly to the top floor of this building in Thalassian University. Inside this room you will find a special Enchanting trainer named Jennara Sunglow. Learn every single available recipe from her." },
      { kind = "MANUAL", key = "crafting_ench_9", showAfter = 8, x = 47.98, y = 53.65, text = "Return to the Enchanting table. Craft all available Gleeful Glamours a single time." },
      { kind = "MANUAL", key = "crafting_ench_10", showAfter = 9, x = 39.54, y = 50.99, text = "Return to Jennara Sunglow and learn any new recipes from her. If you were unlucky with skill ups, you may not have any new recipes at this point. If that happens, you have two options. First, you can choose to end your crafting here and simply continue along with the guide. We are within the final 5 crafts at this point, so they have significant diminishing returns. It's totally fine to stop here. Alternatively, you can buy extra Eversinging Dust and spam crafts until you hit a new skill breakpoint (either 20 or 25) to learn additional recipes. This is a personal judgement call." },
      { kind = "MANUAL", key = "crafting_ench_11", showAfter = 10, x = 47.98, y = 53.65, text = "Return to the Enchanting table. Craft any newly obtained Gleeful Glamour recipes a single time." },
      { kind = "MANUAL", key = "crafting_ench_12", showAfter = 11, x = 48.01, y = 53.85, text = "If you managed to reach 25 skill, speak with the trainer and learn the recipes for 'Enchant Ring - Nature's Wrath' and 'Illusory Adornment - Blooming Light'. You may also want to return to Jennara Sunglow to train new glamours if the previous two crafts are what pushed you over the edge into 25 skill. Again, if you are not at 25 skill, it's totally fine to stop at this point, the final crafts are very low value." },
      { kind = "MANUAL", key = "crafting_ench_13", showAfter = 12, x = 47.98, y = 53.65, text = "Craft the remaining First Craft Bonus recipes a single time each. This completes your 30 first crafts across all professions! Feel free to post any leftover materials on the auction house to recoup some of the cost." },
    },
  },
  {
    title = "Voidstorm Turn-Ins",
    segments = {
      { kind = "MANUAL", key = "voidstorm_portal_2", mapID = {2393}, radius = 10, x = 35.28, y = 66.19, text = "Fly to the portal and interact with it to enter Voidstorm." },
      { kind = "PICKUP", questName = "A Born Killer", mapID = {2405}, showAfter = 1, questIDs = {90914}, x = 51.20, y = 68.45},
      { kind = "OBJECTIVE", questName = "A Born Killer", mapID = {2405}, showAfter = 1, questIDs = {90914}, x = 51.20, y = 68.45, text = "You forgot to finish A Born Killer. Kill and loot any enemies in Voidstorm until it's finished {objective}."},
      { kind = "TURNIN", questName = "A Born Killer", mapID = {2405}, showAfter = 1, questIDs = {90914}, x = 51.20, y = 68.45},
      { kind = "PICKUP", questName = "Delver's Call: Sunkiller Sanctum", mapID = {2405}, showAfter = 1, questIDs = {93427}, x = 51.35, y = 67.60},
      { kind = "TURNIN", questName = "Delver's Call: Sunkiller Sanctum", mapID = {2405}, showAfter = 1, questIDs = {93427}, x = 51.35, y = 67.60},
      { kind = "PICKUP", questName = "Delver's Call: Shadowguard Point", mapID = {2405}, showAfter = 1, questIDs = {93428}, x = 51.35, y = 67.60},
      { kind = "TURNIN", questName = "Delver's Call: Shadowguard Point", mapID = {2405}, showAfter = 1, questIDs = {93428}, x = 51.35, y = 67.60},
      { kind = "MANUAL", key = "harandar_voidstorm_port_1", mapID = {2405}, showAfter = 8, radius = 8, x = 51.71, y = 70.40, text = "Fly to the portal and interact with it to enter Harandar." },
    },
  },
  {
    mapID = {2413},
    title = "Harandar Turn-Ins",
    segments = {
      { kind = "PICKUP", questName = "Delver's Call: The Gulf of Memory", questIDs = {93416}, x = 54.18, y = 53.13},
      { kind = "OBJECTIVE", questName = "Delver's Call: The Gulf of Memory", questIDs = {93416}, x = 54.18, y = 53.13, text = "Turn in"},
      { kind = "TURNIN", questName = "Delver's Call: The Gulf of Memory", questIDs = {93416}, x = 54.18, y = 53.13},
      { kind = "MANUAL", key = "haranir_legends_final", mapID = {2413}, radius = 10, x = 54.18, y = 53.13, text = "I can't currently track which relic you selected, but don't forget to complete your Legends of the Haranir quest while you're here." },
      { kind = "PICKUP", questName = "Abundant Offerings", questIDs = {89507}, x = 66.11, y = 61.49},
      { kind = "OBJECTIVE", questName = "Abundant Offerings", questIDs = {89507}, x = 66.17, y = 61.69, text = "Congratz, you've unlocked the rarest objective in the entire guide by failing to properly complete the Abundance quest earlier! Go talk to Dundun and do it now, better late than never {objective}."},
      { kind = "TURNIN", questName = "Abundant Offerings", questIDs = {89507}, x = 66.11, y = 61.49},
      { kind = "PICKUP", questName = "Delver's Call: The Grudge Pit", questIDs = {93421}, x = 71.77, y = 64.06},
      { kind = "TURNIN", questName = "Delver's Call: The Grudge Pit", questIDs = {93421}, x = 71.77, y = 64.06},
      { kind = "PICKUP", questName = "You Strong?", questIDs = {90616}, showAfter = 5, x = 71.77, y = 64.06},
      { kind = "OBJECTIVE", questName = "You Strong?", questIDs = {90616}, radius = 50, x = 71.60, y = 66.02, text = "Kill enemies to fill the bar {progress}."},
      { kind = "TURNIN", questName = "You Strong?", questIDs = {90616}, x = 71.77, y = 64.06},
      { kind = "NOTE", text = "Ideally you'll reach level 90 after handing in these quests. If you don't, just continue following the bonus quests until you do." },
    },
  },
  {
    title = "A Few Fun Guys",
    mapID = {2413},
    arrow = { mode = "SEQUENCE_CHAIN", radius = 8, key = "fewfunguys:90617", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 71.44, y = 64.88, gate = { questID = {90617}, objectiveIndex = 2, atLeast = 1 } },
            { advance = "PROXIMITY", x = 70.71, y = 66.00, gate = { questID = {90617}, objectiveIndex = 2, atLeast = 2 } },
            { advance = "PROXIMITY", x = 70.91, y = 66.56, gate = { questID = {90617}, objectiveIndex = 2, atLeast = 3 } },
        },
      fallback = {
          x = 47.71, y = 69.77,
          radius = 10,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "A Few Fun Guys", questIDs = {90617}, x = 71.77, y = 64.06 },
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "A Few Fun Guys", objectiveIndex=2, radius = 8, questIDs = {90617}, x = 71.77, y = 64.06, text = "Find recruits {progress}." },
      { kind = "TURNIN", questName = "A Few Fun Guys", questIDs = {90617}, x = 71.77, y = 64.06},
    },
  },
  {
    title = "What Doesn't Kill Them",
    mapID = {2413},
    segments = {
      { kind = "PICKUP", questName = "What Doesn't Kill Them", questIDs = {90619}, x = 71.77, y = 64.06 },
      { kind = "OBJECTIVE", questName = "What Doesn't Kill Them", objectiveIndex=1, radius = 8, questIDs = {90619}, x = 72.13, y = 62.86, text = "Defeat Brakko {progress}." },
      { kind = "OBJECTIVE", questName = "What Doesn't Kill Them", objectiveIndex=2, radius = 8, questIDs = {90619}, x = 72.07, y = 62.54, text = "Defeat Ziny {progress}." },
      { kind = "OBJECTIVE", questName = "What Doesn't Kill Them", objectiveIndex=3, radius = 8, questIDs = {90619}, x = 71.90, y = 62.65, text = "Defeat Tuktuk {progress}." },
      { kind = "TURNIN", questName = "What Doesn't Kill Them", questIDs = {90619}, x = 72.13, y = 62.87},
      { kind = "PICKUP", questName = "We Ready Now", showAfter = 5, questIDs = {91450}, x = 72.13, y = 62.87 },
      { kind = "TURNIN", questName = "We Ready Now", questIDs = {91450}, x = 71.77, y = 64.06 },
      { kind = "NOTE", text = "You can interact with all 3 NPCs and fight them all at once, this is faster than doing it one by one." },
    },
  },
  {
    title = "The Most Important Thing",
    mapID = {2413},
    segments = {
      { kind = "PICKUP", questName = "The Most Important Thing", questIDs = {91270}, x = 71.80, y = 63.93 },
      { kind = "OBJECTIVE", questName = "The Most Important Thing", objectiveIndex=1, radius = 3, questIDs = {91270}, x = 71.75, y = 63.96, text = "Speak to Brakko {progress}." },
      { kind = "OBJECTIVE", questName = "The Most Important Thing", objectiveIndex=2, radius = 3, questIDs = {91270}, x = 71.83, y = 63.99, text = "Speak to Ziny {progress}." },
      { kind = "OBJECTIVE", questName = "The Most Important Thing", objectiveIndex=3, radius = 3, questIDs = {91270}, x = 71.80, y = 63.93, text = "Speak to Tuktuk {progress}." },
      { kind = "OBJECTIVE", questName = "The Most Important Thing", objectiveIndex=4, showAfter = 4, radius = 3, questIDs = {91270}, x = 71.80, y = 63.93, text = "Choose a team name {progress}." },
      { kind = "TURNIN", questName = "The Most Important Thing", questIDs = {91270}, x = 71.80, y = 63.93},
      { kind = "NOTE", text = "Questgiver takes a few seconds to RP walk towards your location. You can meet them halfway and pick up the quest early." },
      { kind = "NOTE", text = "The team name is purely flavor, pick whatever you want." },
    },
  },
  {
    title = "To The Ring",
    mapID = {2413},
    segments = {
      { kind = "PICKUP", questName = "To The Ring", questIDs = {90620}, x = 71.77, y = 64.06 },
      { kind = "OBJECTIVE", questName = "To The Ring", objectiveIndex=2, radius = 12, questIDs = {90620}, x = 72.29, y = 65.19, text = "Follow the arrow {progress}." },
      { kind = "OBJECTIVE", questName = "To The Ring", objectiveIndex=3, showAfter = 2, radius = 12, questIDs = {90620}, x = 71.19, y = 65.77, text = "Defeat waves of enemies {progress}." },
      { kind = "OBJECTIVE", questName = "To The Ring", objectiveIndex=4, showAfter = 3, radius = 12, questIDs = {90620}, x = 71.19, y = 65.77, text = "Wait until you get disqualified {progress}." },
      { kind = "TURNIN", questName = "To The Ring", questIDs = {90620}, x = 71.76, y = 63.96},
      { kind = "NOTE", text = "This quest is really janky. Run to the target area and walk around a bit until you get the waves of enemies to spawn." },
    },
  },
  {
    title = "Tiny Heroes' Journeys",
    mapID = {2413},
    segments = {
      { kind = "PICKUP", questName = "Tiny Heroes' Journeys", questIDs = {90621}, x = 71.77, y = 64.06 },
      { kind = "PICKUP", questName = "Mushrooming Courage", showAfter = 1, radius = 3, questIDs = {92616}, x = 71.75, y = 63.96 },
      { kind = "PICKUP", questName = "Mushrooming Confidence", showAfter = 1, radius = 3, questIDs = {92618}, x = 71.81, y = 63.93 },
      { kind = "PICKUP", questName = "Mushrooming Resilience", showAfter = 1, radius = 3, questIDs = {92617}, x = 71.83, y = 63.98 },
      { kind = "OBJECTIVE", questName = "Mushrooming Resilience", objectiveIndex=1, radius = 50, questIDs = {92617}, x = 70.05, y = 62.57, text = "Kill 'Scary Enemies', this applies to a few random types of mobs, hover over them to see if they count {progress}." },
      { kind = "OBJECTIVE", questName = "Mushrooming Courage", objectiveIndex=1, radius = 50, questIDs = {92616}, x = 68.89, y = 67.12, text = "Kill sporebats {progress}." },
      { kind = "OBJECTIVE", questName = "Mushrooming Confidence", objectiveIndex=1, showAfter = 6, radius = 5, questIDs = {92618}, x = 67.67, y = 67.36, text = "Follow the arrow {progress}." },
      { kind = "OBJECTIVE", questName = "Mushrooming Confidence", objectiveIndex=3, radius = 5, questIDs = {92618}, x = 67.67, y = 67.36, text = "Speak to Tuktuk 3 times, then wait on RP {progress}." },
      { kind = "TURNIN", questName = "Mushrooming Confidence", questIDs = {92618}, x = 67.67, y = 67.36},
      { kind = "TURNIN", questName = "Mushrooming Courage", radius = 10, questIDs = {92616}, x = 67.67, y = 67.36 },
      { kind = "TURNIN", questName = "Mushrooming Resilience", radius = 10, questIDs = {92617}, x = 67.67, y = 67.36 },
      { kind = "OBJECTIVE", questName = "Tiny Heroes' Journeys", objectiveIndex=2, radius = 5, questIDs = {90621}, x = 71.76, y = 63.96, text = "Complete Brakko's Quest." },
      { kind = "OBJECTIVE", questName = "Tiny Heroes' Journeys", objectiveIndex=3, radius = 5, questIDs = {90621}, x = 71.76, y = 63.96, text = "Complete Ziny's Quest." },
      { kind = "OBJECTIVE", questName = "Tiny Heroes' Journeys", objectiveIndex=4, radius = 5, questIDs = {90621}, x = 71.76, y = 63.96, text = "Complete Tuktuk's Quest." },
      { kind = "TURNIN", questName = "Tiny Heroes' Journeys", questIDs = {90621}, x = 71.78, y = 64.06},
      { kind = "NOTE", text = "Brakko and Ziny follow you around, speak to them to hand in the completed quests at any location." },
    },
  },
  {
    title = "Not-Yet Defeated Champions",
    mapID = {2413},
    segments = {
      { kind = "PICKUP", questName = "Not-Yet Defeated Champions", questIDs = {90622}, x = 71.77, y = 64.06 },
      { kind = "OBJECTIVE", questName = "Not-Yet Defeated Champions", objectiveIndex=2, radius = 12, questIDs = {90622}, x = 72.29, y = 65.19, text = "Follow the arrow {progress}." },
      { kind = "OBJECTIVE", questName = "Not-Yet Defeated Champions", objectiveIndex=4, showAfter = 2, radius = 20, questIDs = {90622}, x = 71.19, y = 65.77, text = "Defeat the enemies {progress}." },
      { kind = "TURNIN", questName = "Not-Yet Defeated Champions", questIDs = {90622}, x = 71.77, y = 64.06},
    },
  },
  {
    title = "Continue Finishing Sidequests",
    mapID = {2437},
    segments = {
      { kind = "OBJECTIVE", text = "As mentioned earlier, this is the overflow section of the guide. You should hit 90 at any point now. Click the button below to view the Eversong Woods Sojourner module, which will walk you through a few additional sidequest chains in Silvermoon City. You can also use the drop down menu to navigate to Sojourner modules for other zones."},
      { kind = "MODULE_BUTTON", moduleID = "EVERSONG_WOODS_SOJOURNER", label = "Eversong Sojourner", thumbnail =  "Interface\\AddOns\\FollowTheArrow\\Images\\EversongWoods_Thumb.tga" },
    },
  },
}

FTA.Modules[M.id] = M