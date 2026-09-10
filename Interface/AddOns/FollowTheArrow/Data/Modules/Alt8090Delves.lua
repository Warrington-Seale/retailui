local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "ALT_DELVES_START"
M.title = "Delves & Voidstorm Sidequests"
M.defaultRadius = 5

M.routeId    = "MIDNIGHT_ALT"
M.routeTitle = "Midnight Alt 80-90"
M.routeOrder = 10

M.moduleOrder = 10
M.nextModuleId = "TBD" 

M.steps = {
  {
    title = "Introduction",
    segments = {
      { kind = "MANUAL", key = "alt_intro_1", text = "This is the guide for 80-90 Alt Leveling. The guide is intended to be done in order from start to finish, but if you want to skip around, it should be able to handle that (within reason)."},
      { kind = "MANUAL", key = "alt_intro_2", text = "This guide includes multiple steps that require you to manually check a box in order to flag it as complete. This is used for things such as setting Hearthstone, crafting, or important explanatory dialogue like this."},
      { kind = "MANUAL", key = "alt_intro_3", text = "If you accidentally checked off a step and want to re-read it, go into the settings and click the 'Reset Optional Steps' button."},
      { kind = "MANUAL", key = "alt_intro_4", text = "I've also created a video guide which explains how the route works. You can click on the embedded thumbnail below to get a copy + pasteable version of the URL if you want to watch it."},
      { kind = "MANUAL", key = "alt_intro_5", text = "If you understand and are ready to proceed to the first step of the guide, check off all of the boxes on the right side of the main window. You can also manually skip between different steps by using the Next and Prev buttons below."},
      { kind = "VIDEO_EMBED", url = "https://youtu.be/Hn8SceLFago", texture = "Interface\\AddOns\\FollowTheArrow\\Images\\121ftaguide.tga", width = 320, height = 180, tooltipTitle = "Watch the video guide!" },
      { kind = "NOTE", text = "Although my 2 hour 80-90 speedrun was done with War Mode and the 25% Warband bonus, there are extra questlines included at the end of the guide for anyone with a lesser XP bonus. The route is still incredibly fast regardless of your XP bonus."},
    },
  },
  {
    title = "Midnight",
    segments = {
      { kind = "PICKUP", questName = "Midnight", questIDs = { 91281 }, points = { [84] = { x = 53.27, y = 54.34 }, [85] = { x = 53.40, y = 77.31 }, [2339] = { x = 44.18, y = 34.64 },} },
      { kind = "OBJECTIVE", questName = "Midnight", questIDs = { 91281 }, points = { [84] = { x = 53.27, y = 54.34 }, [85] = { x = 53.40, y = 77.31 }, [2339] = { x = 44.18, y = 34.64 },},  text = "Speak with Lady Liadrin."},
      { kind = "TURNIN", questName = "Midnight", questIDs = {91281}, points = { [84] = { x = 53.27, y = 54.34 }, [85] = { x = 53.40, y = 77.31 }, [2339] = { x = 44.18, y = 34.64 },} },
      { kind = "MANUAL", key = "turn_on_warmode", text = "Turn on War Mode (big button in the bottom right of your talent page) for 15% additional experience in the open world. This is optional, you do risk getting ganked by other players, but it is usually worth turning on." },
      { kind = "MANUAL", key = "turn_on_warmode2", text = "If you run into problems, it is very easy to disable War Mode by finding the nearest innkeeper and pressing the button once again. This is totally normal to do, and losing 15% XP won't kill your ability to follow the guide. You can also re-enable it the next time you pass through Silvermoon if you want to." },
      { kind = "NOTE", text = "Liadrin can be found in Dornogal, Stormwind, or Orgrimmar." }, 
      { kind = "NOTE", text = "Disable any gossip automation before speaking with Liadrin, or you'll immediately be sent into the Sunwell Intro upon accepting the next quest." },
      { kind = "NOTE", text = "Even though you can immediately skip the Sunwell Intro, it's worth completing this first quest, as it's a free 1.8k XP and doesn't trigger the teleport." },
    },
  },
  --{
   -- title = "Turbulent Timeways",
   -- segments = {
   --   { kind = "MANUAL", key = "turbtimeways_1", text = "The Turbulent Timeways event is currently active, and it will run until August 11th. During this event, you get a stacking XP buff from completing Timewalking Dungeons. This buffs caps out at 4 stacks. The first 3 dungeons you complete grant you a stacking 5% XP bonus, and completing the 4th dungeon gives you a new buff that provides 30% XP. Any dungeons after this simply extend the 30% buff."},
    --  { kind = "MANUAL", key = "turbtimeways_2", text = "The key thing people miss about this buff is that it affects ALL forms of experience, NOT just Timewalking Dungeons. While a 30% XP buff is obviously extremely powerful, and you should always run 4 dungeons to obtain this, you don't need to continue running Timewalking after getting the buff."},
   --   { kind = "MANUAL", key = "turbtimeways_3", showAfter = 2, text = "Since the buff is just a blanket 30% increase to all sources, it also has no impact on the route. The best sources of experience (Delves, Weeklies, and the Eversong Route) are still the best with or without a flat 30% bonus. The only difference is that you'll now finish the guide much earlier, and I've put notes throughout the guide with recommendations on when to skip to the final turn-in section."},
   --   { kind = "MANUAL", key = "turbtimeways_4", showAfter = 2, text = "To reiterate, you should ALWAYS get this 30% buff during the event, it is very efficient. If you have instant queues (usually as a Tank or Healer), do this first for all 4 dungeons, and then follow the guide. If you don't get instant queues, I'd recommend that you start following the guide while you wait for the queue to finish. It's only critical that you have the 30% buff by the final turn-in process, anything else is a bonus."},
   --   { kind = "MANUAL", key = "turbtimeways_5", showAfter = 4, text = "Spamming Timewalking dungeons after getting the 30% buff is NOT efficient, and it will be much slower than following the addon route. If you want more information as to why, check the 'Patch 12.0.7' section of the addon."},
    --  { kind = "MANUAL", key = "turbtimeways_6", showAfter = 4, text = "Although the 30% buff only lasts for 3 hours, you can fully extend it by completing another Timewalking dungeon. If you aren't close to reaching Level 90 and the buff only has ~30-45 minutes left, I would advise doing another run just to be safe."},
      --{ kind = "NOTE", text = "Although my 2 hour 80-90 speedrun was done with War Mode and the 25% Warband bonus, there are extra questlines included at the end of the guide for anyone with a lesser XP bonus. The route is still incredibly fast regardless of your XP bonus."},
   -- },
 -- },
  {
    title = "Skip the Sunwell Intro",
    segments = {
      { kind = "MANUAL", key = "liadrin_sunwell_skip", points = { [84] = { x = 53.27, y = 54.34 }, [85] = { x = 53.40, y = 77.31 }, [2339] = { x = 44.18, y = 34.64 },}, text = "Speak with Liadrin and select the 'I have heard this tale before.' dialogue choice to skip the Sunwell Intro." },
      { kind = "PICKUP", questName = "Eversong", mapID = {2393}, showAfter = 1, questIDs = {94871}, radius = 8, x = 45.44, y = 70.33},
      { kind = "PICKUP", questName = "Hope in the Darkest Corners", mapID = {2393}, showAfter = 1, questIDs = {95468}, radius = 5, x = 49.10, y = 64.64},
      { kind = "PICKUP", questName = "Down a Peg", mapID = {2393}, showAfter = 3, questIDs = {94396}, x = 33.24, y = 74.11},
      { kind = "PICKUP", questName = "Career Counseling", mapID = {2393}, showAfter = 3, questIDs = {94393}, x = 33.24, y = 74.11},
      { kind = "NOTE", text = "If you can't skip the Sunwell Intro, you're using the wrong guide! Go switch to the Midnight Campaign guide using the dropdown menu. You MUST complete the entire campaign on your first character, you can't follow this route." },
      { kind = "NOTE", text = "The Eversong quest will be picked up at the mission board in Silvermoon." },
      { kind = "NOTE", text = "The quests you're picking up now will be completed later. We're grabbing them now since we're close by, so it saves travel time in the long run." },
    },
  },
  {
    title = "Entering Harandar",
    segments = {
      { kind = "MANUAL", key = "harandar_portal_1", mapID = {2393}, radius = 10, x = 36.96, y = 67.99, text = "Interact with the portal to teleport to Harandar." },
      { kind = "MANUAL", key = "theden_hearthstone_1", mapID = {2576}, showAfter = 1, radius = 8, x = 65.44, y = 61.92, text = "Fly downstairs, speak with the Innkeeper, and set your Hearthstone. This is optional, but it does save some time later." },
      { kind = "MANUAL", key = "haranir_legends_1", mapID = {2413}, showAfter = 2, radius = 8, x = 54.18, y = 53.13, text = "Fly upstairs and speak to Zur'ashar Kassameh. He offers quests to begin the Legends of the Haranir weekly, and this is now worth doing after the 12.0.7 buffs." },
      { kind = "MANUAL", key = "haranir_legends_2", mapID = {2413}, showAfter = 2, radius = 8, x = 54.43, y = 53.20, text = "The fastest relic to complete is Aln'hara's Bloom, but you may not have this as an option. There are a lot of weird restrictions and time-gated quests tied to Legends of the Haranir. I discuss this in more detail in the 'Patch 12.0.7' section of the addon, which you can find in the top right drop down menu." },
      { kind = "MANUAL", key = "haranir_legends_7", mapID = {2413}, showAfter = 4, radius = 8, x = 54.66, y = 65.08, text = "Since a few people asked, here's a list of the different relics from fastest to slowest: Aln'hara's Bloom > Russula's Outreach = Echoless Flame >= Root of the World = Wey'nan's Ward > Cauldron of Echoes >> Sky's Hope." },
      { kind = "MANUAL", key = "haranir_legends_3", mapID = {2413}, showAfter = 4, radius = 8, x = 54.43, y = 53.20, text = "Realistically, if you are unable to select Aln'hara's Bloom, you should just pick any available relic and complete it. Once you've completed all relics, future alts can select any option they want, so your time will not be wasted regardless of your selection." },
      { kind = "MANUAL", key = "haranir_legends_4", mapID = {2413}, showAfter = 6, radius = 8, x = 54.66, y = 65.08, text = "After selecting your relic, look for the quest marker on the map, head there, and complete it. This arrow will point you towards the starting point for Aln'hara's Bloom." },
      { kind = "MANUAL", key = "haranir_legends_5", mapID = {2413}, showAfter = 6, radius = 8, x = 54.66, y = 65.08, text = "Due to how many variables are currently present, I have not added advanced logic for the relic scenarios themselves. I will try to include this in a future update, but it's relatively straightforward to complete without my guidance." },
      { kind = "MANUAL", key = "haranir_legends_6", mapID = {2413}, showAfter = 6, radius = 8, x = 54.66, y = 65.08, text = "Do not turn in the Legends of the Haranir quest after you're finished. It will be completed at the end of the guide." },
      { kind = "MANUAL", key = "shulka_litya_dailies_1", mapID = {2413}, showAfter = 9, radius = 8, x = 51.82, y = 74.24, text = "Fly to Shul'ka Li'tya and check to see what daily quests she is offering. Every single day she will offer a random assortment of dailies, but all of them involve killing a single nearby elite mob." },
      { kind = "MANUAL", key = "shulka_litya_dailies_2", mapID = {2413}, showAfter = 9, radius = 8, x = 51.82, y = 74.24, text = "On some days she will offer three quests at the same time, which makes this an incredibly efficient detour. However, since this is not always the case, I can't make it a required part of the guide. I wanted to atleast make sure you were aware of it in case the quests happened to be active." },
      { kind = "MANUAL", key = "shulka_litya_dailies_3", mapID = {2413}, showAfter = 9, radius = 8, x = 51.82, y = 74.24, text = "If only a single quest is available, it's still not a terrible idea to complete it, but this is entirely optional." },
    },
  },
  {
    title = "The Grudge Pit",
    segments = {
      { kind = "MANUAL", key = "grudgepit_flight_1", mapID = {2413}, radius = 10, x = 70.96, y = 65.57, text = "Fly to the Grudge Pit and enter it on Tier 1 or Tier 2. Notes have more info on the Tier levels." },
      { kind = "PICKUP", questName = "Delver's Call: The Grudge Pit", showAfter = 1, mapID = {2510}, questIDs = {93421}, radius = 8, x = 39.71, y = 43.29},
      { kind = "OBJECTIVE", questName = "Delver's Call: The Grudge Pit", mapID = {2510}, radius = 100, questIDs = {93421}, x = 50.97, y = 49.29, text = "Complete The Grudge Pit." },
      { kind = "MANUAL", key = "harandar_hearth_1", showAfter = 3, text = "DO NOT TURN IN THE DELVER'S CALL QUEST! This will be done later. When you're finished with the delve, use your Hearthstone to return to The Den." },
      { kind = "NOTE", text = "I recommend running Delves on Tier 2 early in the leveling process. T2 Delves give 10% more experience, so if you're easily killing everything, it's a bit more efficient. Tier 1 is still totally fine. Tier 3 is highly inefficient and should never be used." },
      { kind = "NOTE", text = "If you're a DPS, you should set Valeera to healer. Tanks can pick either DPS or Healer Valeera, it's personal preference." },
      { kind = "NOTE", text = "Detailed instructions for Delve sub-objectives are not currently supported. This will be added in a future update to account for all variants." },
    },
  },
  {
    title = "The Gulf of Memory",
    segments = {
      { kind = "MANUAL", key = "gulf_of_memory_flight", mapID = {2413}, radius = 10, x = 36.73, y = 49.66, text = "Fly to the Gulf of Memory and enter it on T1 or T2." },
      { kind = "PICKUP", questName = "Delver's Call: The Gulf of Memory", mapID = 2505, showAfter = 1, radius = 10, questIDs = {93416}, x = 50.86, y = 17.24},
      { kind = "OBJECTIVE", questName = "Delver's Call: The Gulf of Memory", objectiveIndex=1, mapID = {2505}, radius = 100, questIDs = {93416}, x = 50.23, y = 64.23, text = "Complete The Gulf of Memory." },
      { kind = "MANUAL", key = "arcantina_key_gom", showAfter = 2, text = "Once again, do not turn in your Delver's Call quest. Find the toy 'Personal Key to the Arcantina' in your toy box. Put it on your bars for easy access in the future, and then use it after finishing the delve." },
      { kind = "MANUAL", key = "arcantina_exit_gom", showAfter = 4, points = { [2541] = { x = 50.42, y = 91.25 }, [2393] = { x = 56.46, y = 70.35 }, }, text = "Walk into the nearby portal to exit The Arcantina and enter Silvermoon City. You'll be taken to the Wayfarer's Rest Inn, speak with the Innkeeper and set your Hearthstone here." },
    },
  },
  {
    title = "Voidstorm Prey",
    mapID = {2393},
    segments = {
      { kind = "MANUAL", key = "voidstorm_prey_1", radius = 6, x = 55.77, y = 65.24, text = "Exit the inn and fly towards the Orb of Translocation. Right click on it to enter Astalor's Sanctum." },
      { kind = "MANUAL", key = "voidstorm_prey_2", showAfter = 1, radius = 5, x = 56.76, y = 65.34, text = "Walk over to the Hunt Table and right click it. Select the Prey for Voidstorm (top middle purple blob on the map). If this is unavailable, complete the other quests from Astalor to unlock Prey for your account." },
      { kind = "MANUAL", key = "voidstorm_prey_3", showAfter = 2, radius = 5, x = 56.76, y = 65.34, text = "I will not be able to give you further instructions on how to complete your Prey hunt, as there are many random variables and certain information isn't accessible by addons." },
      { kind = "MANUAL", key = "voidstorm_prey_4", showAfter = 2, radius = 5, x = 56.76, y = 65.34, text = "After completing the next few delves, the addon will direct you to complete a few quest chains in Voidstorm. While there, you'll be able to make progress towards this Prey hunt passively as you complete other objectives." },
      { kind = "MANUAL", key = "voidstorm_prey_5", showAfter = 2, radius = 5, x = 56.76, y = 65.34, text = "Throughout this guide I will provide you with additional reminders to finish your Prey before exiting the zone, and to pick up new ones whenever you stop by Silvermoon City." },
      { kind = "MANUAL", key = "voidstorm_prey_6", showAfter = 2, radius = 5, x = 56.76, y = 65.34, text = "For a bit more information about the random variables behind Prey, as well as why I'm unable to help track it within the addon, refer to the 'Patch 12.0.7' section." },
    },
  },
  {
    title = "Collegiate Calamity",
    segments = {
      { kind = "MANUAL", key = "collegiate_calamity_1", mapID = {2393}, radius = 10, x = 40.35, y = 53.15, text = "Fly to the Collegiate Calamity delve and enter it on T1 or T2." },
      { kind = "PICKUP", questName = "Delver's Call: Collegiate Calamity", mapID = 2577, showAfter = 1, radius = 10, questIDs = {93384}, x = 59.55, y = 59.90},
      { kind = "OBJECTIVE", questName = "Delver's Call: Collegiate Calamity", objectiveIndex=1, mapID = {2547}, radius = 200, questIDs = {93384}, x = 46.83, y = 52.63, text = "Complete Collegiate Calamity." },
      { kind = "MANUAL", key = "leave_delve_colcal", showAfter = 2, text = "Upon finishing the Delve, right click your character portrait in the top left of your screen and select the 'Leave Delve' option." },
    },
  },
  {
    title = "The Darkway",
    segments = {
      { kind = "MANUAL", key = "darkway_1", mapID = {2393}, radius = 10, x = 39.32, y = 31.71, text = "Fly to the Darkway delve and enter it on T1 or T2." },
      { kind = "PICKUP", questName = "Delver's Call: The Darkway", mapID = 2525, showAfter = 1, radius = 10, questIDs = {93385}, x = 49.07, y = 18.63},
      { kind = "OBJECTIVE", questName = "Delver's Call: The Darkway", objectiveIndex=1, mapID = {2525}, radius = 200, questIDs = {93385}, x = 48.64, y = 53.37, text = "Complete The Darkway." },
      { kind = "MANUAL", key = "leave_delve_darkway", showAfter = 2, text = "Upon finishing the Delve, right click your character portrait in the top left of your screen and select the 'Leave Delve' option." },
    },
  },
  {
    mapID = {2424},
    title = "Parhelion Plaza",
    arrow = { mode = "SEQUENCE_CHAIN", radius = 8, key = "parhelion:delve", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 47.73, y = 41.56 },
            { advance = "PROXIMITY", x = 46.87, y = 41.03 },
          },
      fallback = {
          x = 47.71, y = 69.77,
          radius = 10,
        },
      },
    segments = {
      { kind = "CHAIN_START" },
      { kind = "MANUAL", key = "parhelion_1", mapID = {2424}, radius = 10, x = 46.37, y = 40.63, text = "Fly to the Parhelion Plaza delve and enter it on T1 or T2." },
      { kind = "PICKUP", questName = "Delver's Call: Parhelion Plaza", mapID = 2545, showAfter = 2, radius = 10, questIDs = {93386}, x = 74.48, y = 27.74},
      { kind = "OBJECTIVE", questName = "Delver's Call: Parhelion Plaza", objectiveIndex=1, mapID = {2545}, radius = 200, questIDs = {93386}, x = 47.63, y = 49.93, text = "Complete Parhelion Plaza." },
      { kind = "MANUAL", key = "leave_delve_parhelion", showAfter = 3, text = "Upon finishing the Delve, right click your character portrait in the top left of your screen and select the 'Leave Delve' option. If your Arcantina Key is back up, it may be SLIGHTLY faster to use that instead." },
      { kind = "MANUAL", key = "voidstorm_portal_1", showAfter = 5, mapID = {2393}, radius = 10, x = 35.28, y = 66.19, text = "Fly to the portal in Silvermoon and interact with it to enter Voidstorm." },
      { kind = "NOTE", text = "As of Patch 12.0.7 it is always worth it to complete Parhelion Plaza, but it's worth noting that the variant 'March of the Arcane Brigade' is INCREDIBLY slow. Unfortunately, this is up on the same day as many of the best variants for other delves, so it often feels bad to include Parhelion Plaza in leveling runs. If possible, assuming you're leveling over a longer period of time, try to complete Parhelion Plaza on a day when this variant is not active." },
    },
  },
  {
    mapID = {2405},
    title = "Entering Voidstorm",
    arrow = { mode = "SEQUENCE_CHAIN", radius = 8, key = "conquered:heroes", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 46.76, y = 56.53, gate = { questID = {91145}, objectiveIndex = 2, atLeast = 1 } },
            { advance = "PROXIMITY", x = 46.94, y = 56.26, gate = { questID = {91145}, objectiveIndex = 2, atLeast = 2 } },
            { advance = "PROXIMITY", x = 46.81, y = 56.01, gate = { questID = {91145}, objectiveIndex = 2, atLeast = 3 } },
          },
      fallback = {
          x = 47.71, y = 69.77,
          radius = 10,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Researching the Storm", questIDs = {93970}, x = 52.58, y = 72.90},
      { kind = "OBJECTIVE", questName = "Researching the Storm", radius = 8, objectiveIndex = 1, questIDs = {93970}, x = 52.63, y = 72.86, text = "Interact with the console {progress}." },
      { kind = "OBJECTIVE", questName = "Researching the Storm", radius = 8, objectiveIndex = 2, questIDs = {93970}, x = 52.63, y = 72.86, text = "Spend a point in 'Amassing Voidlust' {progress}." },
      { kind = "TURNIN", questName = "Researching the Storm", questIDs = {93970}, x = 52.58, y = 72.90},
      { kind = "PICKUP", questName = "The Conquered Heroes", showAfter = 4, questIDs = {91145}, x = 51.82, y = 71.90},
      { kind = "PICKUP", questName = "A Born Killer", showAfter = 4, questIDs = {90914}, x = 51.20, y = 68.45},
      { kind = "OBJECTIVE", questName = "The Conquered Heroes", radius = 10, objectiveIndex = 1, questIDs = {91145}, x = 46.80, y = 56.61, text = "Follow the arrow {progress}." },
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "The Conquered Heroes", radius = 8, showAfter = 7, objectiveIndex = 2, questIDs = {91145}, x = 46.80, y = 56.61, text = "Investigate bodies {progress}." },
      { kind = "OBJECTIVE", questName = "The Conquered Heroes", radius = 15, showAfter = 9, objectiveIndex = 3, questIDs = {91145}, x = 47.02, y = 54.50, text = "Follow the arrow {progress}." },
    },
  },
  {
    title = "Sunkiller Sanctum",
    segments = {
      { kind = "MANUAL", key = "sunkiller_sanctum_1", mapID = {2405}, radius = 10, x = 54.79, y = 47.22, text = "Fly to the Sunkiller Sanctum delve and enter it on T1 or T2." },
      { kind = "PICKUP", questName = "Delver's Call: Sunkiller Sanctum", mapID = 2528, showAfter = 1, radius = 10, questIDs = {93427}, x = 63.36, y = 34.90},
      { kind = "OBJECTIVE", questName = "Delver's Call: Sunkiller Sanctum", objectiveIndex=1, mapID = {2571}, radius = 150, questIDs = {93427}, x = 58.82, y = 73.63, text = "Complete Sunkiller Sanctum." },
      { kind = "MANUAL", key = "leave_delve_sunsanc", showAfter = 2, text = "Upon finishing the Delve, right click your character portrait in the top left of your screen and select the 'Leave Delve' option." },
    },
  },
  {
    mapID = {2444},
    title = "Shadow Puppets",
    arrow = { mode = "SEQUENCE_CHAIN", radius = 10, key = "flickering:light", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 50.80, y = 78.00, gate = { questID = {91146}, objectiveIndex = 1, atLeast = 1 } },
            { advance = "PROXIMITY", x = 51.63, y = 73.35, gate = { questID = {91146}, objectiveIndex = 1, atLeast = 2 } },
            { advance = "PROXIMITY", x = 47.44, y = 74.98, gate = { questID = {91146}, objectiveIndex = 1, atLeast = 3 } },
          },
      fallback = {
          x = 47.71, y = 69.77,
          radius = 10,
        },
      },
    segments = {
      { kind = "TURNIN", questName = "The Conquered Heroes", questIDs = {91145}, x = 53.97, y = 84.03},
      { kind = "PICKUP", questName = "Flickering Light", showAfter = 1, questIDs = {91146}, x = 53.97, y = 84.03},
      { kind = "PICKUP", questName = "Cut Her Strings", showAfter = 1, questIDs = {91147}, x = 53.97, y = 84.03},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Flickering Light", radius = 8, objectiveIndex = 1, questIDs = {91146}, x = 46.80, y = 56.61, text = "Find traces of light {progress}." },
      { kind = "OBJECTIVE", questName = "Cut Her Strings", radius = 250, objectiveIndex = 1, questIDs = {91147}, x = 50.86, y = 79.54, text = "Defeat and right click mobs to remove shadowgrafts {progress}." },
      { kind = "OBJECTIVE", questName = "Bloodying the Plain", radius = 300, showAfter = 3, questIDs = {92641}, x = 50.86, y = 79.54, text = "Kill enemies to fill the bar {progress}." },
      { kind = "TURNIN", questName = "Flickering Light", questIDs = {91146}, x = 53.97, y = 84.03},
      { kind = "TURNIN", questName = "Cut Her Strings", questIDs = {91147}, x = 53.97, y = 84.03},
      { kind = "NOTE", text = "The bonus objective 'Bloodying the Plain' automatically appears when the other quests are picked up. This should be completed alongside the other quests." },
      { kind = "NOTE", text = "When right clicking mobs, you immediately get credit for removing shadowgrafts. You do not need to complete the channel." },
    },
  },
  {
    mapID = {2444},
    title = "Strung Along",
    segments = {
      { kind = "PICKUP", questName = "Strung Along", questIDs = {91148}, x = 53.97, y = 84.03},
      { kind = "OBJECTIVE", questName = "Strung Along", radius = 15, objectiveIndex = 1, questIDs = {91148}, x = 53.97, y = 84.03, text = "Follow the arrow {progress}." },
      { kind = "OBJECTIVE", questName = "Strung Along", radius = 8, objectiveIndex = 2, showAfter = 2, questIDs = {91148}, x = 53.97, y = 84.03, text = "Speak to Anais {progress}." },
      { kind = "OBJECTIVE", questName = "Strung Along", radius = 15, objectiveIndex = 3, showAfter = 3, questIDs = {91148}, x = 44.26, y = 86.89, text = "Follow the arrow {progress}." },
      { kind = "TURNIN", questName = "Strung Along", questIDs = {91148}, x = 44.07, y = 87.13},
      { kind = "PICKUP", questName = "Bury Me Not", showAfter = 5, questIDs = {91149}, x = 44.07, y = 87.13},
      { kind = "OBJECTIVE", questName = "Bury Me Not", radius = 8, objectiveIndex = 1, questIDs = {91149}, x = 44.07, y = 87.13, text = "Pick up the tinder box {progress}." },
      { kind = "OBJECTIVE", questName = "Bury Me Not", radius = 8, objectiveIndex = 2, showAfter = 7, questIDs = {91149}, x = 44.42, y = 87.42, text = "Use the void portal {progress}." },
      { kind = "OBJECTIVE", questName = "Bury Me Not", radius = 10, showAfter = 8, objectiveIndex = 3, questIDs = {91149}, x = 41.94, y = 72.59, text = "Defeat Callum {progress}." },
      { kind = "OBJECTIVE", questName = "Bury Me Not", radius = 10, showAfter = 9, objectiveIndex = 4, questIDs = {91149}, x = 41.94, y = 72.59, text = "Right click Imperia to destroy her {progress}." },
      { kind = "TURNIN", questName = "Bury Me Not", questIDs = {91149}, x = 44.07, y = 87.13},
    },
  },
  {
    mapID = {2405},
    title = "Pathogenic Problem",
    segments = {
      { kind = "PICKUP", questName = "Pestilent Petals", questIDs = {91558}, x = 35.90, y = 48.23},
      { kind = "PICKUP", questName = "Virulent Vermin", questIDs = {91559}, x = 35.90, y = 48.23},
      { kind = "OBJECTIVE", questName = "Pestilent Petals", radius = 125, objectiveIndex = 1, questIDs = {91558}, x = 35.10, y = 46.81, text = "Collect mature blood petals {progress}." },
      { kind = "OBJECTIVE", questName = "Virulent Vermin", radius = 125, objectiveIndex = 1, questIDs = {91559}, x = 35.10, y = 46.81, text = "Kill and loot enemies for specialized livers {progress}." },
      { kind = "TURNIN", questName = "Pestilent Petals", questIDs = {91558}, x = 34.62, y = 43.79},
      { kind = "TURNIN", questName = "Virulent Vermin", questIDs = {91559}, x = 34.62, y = 43.79},
      { kind = "NOTE", text = "Be careful with your pulls here. The puddles deal high ticking damage, and some of these mobs hurt." },
      { kind = "NOTE", text = "You're not crazy, the liver drop rate is really low. This quest is still worth doing, trust." },
    },
  },
  {
    mapID = {2405},
    title = "Calculated Culling",
    arrow = { mode = "SEQUENCE_CHAIN", radius = 12, key = "calculated:culling", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 33.69, y = 45.46, gate = { questID = {91560}, objectiveIndex = 5, atLeast = 1 } },
            { advance = "PROXIMITY", x = 33.98, y = 46.04, gate = { questID = {91560}, objectiveIndex = 5, atLeast = 2 } },
            { advance = "PROXIMITY", x = 34.19, y = 47.33, gate = { questID = {91560}, objectiveIndex = 5, atLeast = 3 } },
            { advance = "PROXIMITY", x = 33.69, y = 48.33, gate = { questID = {91560}, objectiveIndex = 5, atLeast = 4 } },
            { advance = "PROXIMITY", x = 32.94, y = 47.33, gate = { questID = {91560}, objectiveIndex = 5, atLeast = 5 } },
            { advance = "PROXIMITY", x = 33.16, y = 46.42, gate = { questID = {91560}, objectiveIndex = 5, atLeast = 6 } },
          },
      fallback = {
          x = 47.71, y = 69.77,
          radius = 10,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Expunging Explorers", questIDs = {91560}, x = 34.62, y = 43.79},
      { kind = "OBJECTIVE", questName = "Expunging Explorers", objectiveIndex = 1, questIDs = {91560}, x = 34.57, y = 43.84, text = "Click on the blood petals {progress}." },
      { kind = "OBJECTIVE", questName = "Expunging Explorers", objectiveIndex = 2, showAfter = 2, questIDs = {91560}, x = 34.61, y = 43.85, text = "Click on the livers {progress}." },
      { kind = "OBJECTIVE", questName = "Expunging Explorers", objectiveIndex = 3, showAfter = 3, questIDs = {91560}, x = 34.60, y = 43.82, text = "Click on the cauldron {progress}." },
      { kind = "OBJECTIVE", questName = "Expunging Explorers", objectiveIndex = 4, showAfter = 4, questIDs = {91560}, x = 34.66, y = 43.87, text = "Click on the scout {progress}." },
      { kind = "PICKUP", questName = "Calculated Culling", questIDs = {93801}, showWhenQuestInLog = {91560}, showAfter = 5, x = 34.66, y = 43.87},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Expunging Explorers", objectiveIndex = 5, showAfter = 5, questIDs = {91560}, x = 34.66, y = 43.87, text = "Cure scouts {progress}." },
      { kind = "OBJECTIVE", questName = "Expunging Explorers", objectiveIndex = 6, showAfter = 8, questIDs = {91560}, x = 33.29, y = 43.97, text = "Cure Riftwalker Lorn {progress}." },
      { kind = "OBJECTIVE", questName = "Calculated Culling", radius = 125, objectiveIndex = 1, questIDs = {93801}, x = 33.79, y = 46.42, text = "Kill enemies to fill the bar {progress}." },
      { kind = "PICKUP", questName = "A Born Killer", showAfter = 5, showWhenQuestInLog = {93801}, questIDs = {90914}, x = 51.20, y = 68.45},
      { kind = "OBJECTIVE", questName = "A Born Killer", radius = 125, objectiveIndex = 1, showAfter = 5, showWhenQuestInLog = {93801}, questIDs = {90914}, x = 33.79, y = 46.42, text = "Collect Void Essence {progress}." },
      { kind = "TURNIN", questName = "Expunging Explorers", questIDs = {91560}, x = 34.62, y = 43.79},
      { kind = "TURNIN", questName = "Calculated Culling", questIDs = {93801}, x = 34.62, y = 43.79},
      { kind = "NOTE", text = "The second quest takes a few seconds to appear after a bit of roleplay." },
      { kind = "NOTE", text = "At this point you may need to kill a few extra enemies to collect the last few Void Essence for the quest 'A Born Killer', which you grabbed earlier." },
    },
  },
  {
    mapID = {2405},
    title = "Bloodborne Pathogen",
    segments = {
      { kind = "PICKUP", questName = "Bloodborne Pathogen", questIDs = {91561}, x = 34.62, y = 43.79},
      { kind = "OBJECTIVE", questName = "Bloodborne Pathogen", radius = 10, objectiveIndex = 1, questIDs = {91561}, x = 32.19, y = 44.62, text = "Kill the Mutated Pathogen {progress}." },
      { kind = "TURNIN", questName = "Bloodborne Pathogen", questIDs = {91561}, x = 34.62, y = 43.79},
      { kind = "MANUAL", key = "voidstorm_prey_final", mapID = {2405}, showAfter = 3, radius = 10, x = 34.62, y = 43.79, text = "Make sure you complete your Prey hunt in Voidstorm before moving onto the next step. Look for the red crystal world quests on your map to find the final showdown, and once it's completed you can continue along with the guide." },
      { kind = "MANUAL", key = "voidstorm_prey_finale", mapID = {2405}, showAfter = 3, radius = 10, x = 34.62, y = 43.79, text = "If the showdown isn't ready, you may need to take some minor detours to pick up traps, destroy anguish blobs, or fend off ambushes until it's ready. Upon finishing your Prey quest it will auto complete, you do not need to turn it in at Silvermoon (but you will be directed by the addon to return there later and pick up another Prey)." },
    },
  },
  {
    title = "Disable War Mode",
    mapID = {2405},
    segments = {
      { kind = "MANUAL", key = "abundance_WM_1", radius = 5, x = 35.68, y = 58.68, text = "The next step of the guide will direct you to complete the Abundance scenario, which is extremely difficult to finish while in War Mode. Thankfully the mobs don't give any XP and we won't be turning in the quest until later, so being in War Mode makes 0 difference at this moment." },
      { kind = "MANUAL", key = "abundance_WM_2", radius = 5, x = 35.68, y = 58.68, text = "For this reason, the arrow is currently directing you towards a nearby inn, which you can use to disable War Mode. Walk directly up to the innkeeper, and then click on the War Mode button in your talent page. This will disable War Mode, allowing you to safely complete Abundance." },
      { kind = "MANUAL", key = "abundance_WM_3", radius = 5, x = 35.68, y = 58.68, text = "After finishing Abundance, the only remaining step in Voidstorm is the Shadowguard Point delve, and War Mode's XP modifier doesn't work within Delves (or any instances). This means you lose absolutely nothing by turning it off here. When you finish the Delve, you will return to Silvermoon, and the addon will remind you to re-enable War Mode, if you want to." },
    },
  },
  {
    title = "Abundance",
    mapID = {2405},
    segments = {
      { kind = "PICKUP", questName = "Abundant Offerings", questIDs = {89507}, x = 38.91, y = 53.21},
      { kind = "MANUAL", key = "abundance_1", showAfter = 1, radius = 5, x = 38.85, y = 53.36, text = "Speak with Dundun to start the Abundance scenario." },
      { kind = "MANUAL", key = "abundance_2", showAfter = 2, mapID = 2582, radius = 5, x = 44.76, y = 65.34, text = "Jump into the pit to begin. You will not take fall damage." },
      { kind = "MANUAL", key = "abundance_3", showAfter = 2, mapID = 2582, radius = 150, x = 44.76, y = 65.34, text = "Defeat enemies and collect their orbs. Once you have enough, run to the shrines to deposit your Abundance." },
      { kind = "MANUAL", key = "abundance_4", showAfter = 2, mapID = 2582, radius = 150, x = 44.76, y = 65.34, text = "You have three minutes to collect as much Abundance as you can. 20,000 is needed to complete the quest, but if you fall short, you can repeat the scenario again to get whatever you're missing." },
      { kind = "MANUAL", key = "abundance_5", showAfter = 2, radius = 5, x = 38.85, y = 53.36, text = "DO NOT TURN IN THE QUEST WHEN YOU'RE FINISHED! We will hand it in at the end of the guide, alongside other weeklies and Delver's Call quests." },
      { kind = "NOTE", text = "If the quest is unavailable, you'll need to visit Zul'Aman at some point to unlock Abundance for your account. The chain starts with a purple triangle quest in Amani'Zar Village." },
    },
  },
  {
    title = "Shadowguard Point",
    segments = {
      { kind = "MANUAL", key = "shadowguard_point_1", mapID = {2405}, radius = 10, x = 37.37, y = 47.83, text = "Fly to the Shadowguard Point delve and enter it on T1 or T2." },
      { kind = "PICKUP", questName = "Delver's Call: Shadowguard Point", mapID = 2506, showAfter = 1, radius = 10, questIDs = {93428}, x = 47.59, y = 79.22},
      { kind = "OBJECTIVE", questName = "Delver's Call: Shadowguard Point", objectiveIndex=1, mapID = {2506}, radius = 100, questIDs = {93428}, x = 46.32, y = 15.70, text = "Complete Shadowguard Point." },
      { kind = "MANUAL", key = "leave_delve_shadpoint", showAfter = 2, text = "Upon finishing the delve, use either your Arcantina Key or regular Hearthstone to return to Silvermoon." },
      { kind = "MANUAL", key = "DELVESAREFINE", showAfter = 4, text = "Just because this is the end of the 'Delve Section' does not mean you're finished with all of the Delves. The rest of the Delves will be done later in the guide. There's no point in frontloading all of the Delves if it forces you to waste a ton of time traveling. You'll naturally reach the remaining Delves (Shadow Enclave, Atal'Aman, Twilight Crypts) as you follow the rest of the guide, and the addon will direct you to complete those Delves." },
    },
  },
  {
    title = "Eversong Woods",
    segments = {
      { kind = "OBJECTIVE", text = "I CAN NOT STRESS ENOUGH THAT IT IS OK FOR YOU TO COMPLETE THIS SECTION WITHOUT ALL 10 DELVES HAVING BEEN COMPLETED. THE REST WILL BE DONE LATER. IF I GET ONE MORE DISCORD DM OR YOUTUBE COMMENT SAYING 'omfg ur addon is broken i finished the delve section and im still missing delves' I AM GOING TO LOSE MY MIND."},
      { kind = "OBJECTIVE", text = "You've completed the first section of the alt route! Click the button to load the next section of the guide, Eversong Woods."},
      { kind = "MODULE_BUTTON", moduleID = "ALT_EVERSONG_WOODS", label = "Eversong Woods", thumbnail =  "Interface\\AddOns\\FollowTheArrow\\Images\\EversongWoods_Thumb" },
    },
  },
}

FTA.Modules[M.id] = M