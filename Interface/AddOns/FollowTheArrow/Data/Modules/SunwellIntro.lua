local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "MIDNIGHT_SUNWELL_INTRO"
M.title = "Sunwell Intro Scenario"
M.defaultRadius = 5

M.routeId    = "MIDNIGHT_CAMPAIGN"
M.routeTitle = "Midnight Campaign"
M.routeOrder = 11

M.moduleOrder = 10
M.nextModuleId = "MIDNIGHT_EVERSONG_WOODS" 

M.steps = {

  {
    title = "Introduction",
    segments = {
      { kind = "MANUAL", key = "midcamp_intro_1", text = "This is the guide for 80-90 Campaign Leveling. The guide is intended to be used during your FIRST character in Midnight, as completing the entire Campaign is required to unlock other endgame features."},
      { kind = "MANUAL", key = "midcamp_intro_2", text = "If you're looking for the faster route that is designed for Alt Leveling, click on the drop down list in the top right of this panel and select the other guide."},
      { kind = "MANUAL", key = "midcamp_intro_3", text = "This guide includes multiple steps that require you to manually check a box in order to flag it as complete. This is used for things such as setting Hearthstone, crafting, or important explanatory dialogue like this."},
      { kind = "MANUAL", key = "midcamp_intro_4", text = "If you accidentally checked off a step and want to re-read it, go into the settings and click the 'Reset Optional Steps' button."},
      { kind = "MANUAL", key = "midcamp_intro_5", text = "I've also created a video guide which explains how the route works. You can click on the embedded thumbnail below to get a copy + pasteable version of the URL if you want to watch it."},
      { kind = "MANUAL", key = "midcamp_intro_6", text = "If you understand and are ready to proceed to the first step of the guide, check off all of the boxes on the right side of the main window. You can also manually skip between different steps by using the Next and Prev buttons below."},
      { kind = "VIDEO_EMBED", url = "https://youtu.be/V13c9xEbdgE", texture = "Interface\\AddOns\\FollowTheArrow\\Images\\CampaignThumb.tga", width = 320, height = 180, tooltipTitle = "Watch the video guide!" },
    },
  },
  {
    title = "Midnight",
    segments = {
      { kind = "PICKUP", questName = "Midnight", questIDs = { 91281 }, points = { [84] = { x = 53.27, y = 54.34 }, [85] = { x = 53.40, y = 77.31 }, [2339] = { x = 44.18, y = 34.64 },} },
      { kind = "OBJECTIVE", questName = "Midnight", questIDs = { 91281 }, points = { [84] = { x = 53.27, y = 54.34 }, [85] = { x = 53.40, y = 77.31 }, [2339] = { x = 44.18, y = 34.64 },},  text = "Speak with Lady Liadrin."},
      { kind = "TURNIN", questName = "Midnight", questIDs = {91281}, points = { [84] = { x = 53.27, y = 54.34 }, [85] = { x = 53.40, y = 77.31 }, [2339] = { x = 44.18, y = 34.64 },} },
      { kind = "NOTE", text = "Liadrin can be found in Dornogal, Stormwind, or Orgrimmar." },
    },
  },
  {
    title = "Enter The Sunwell",
    segments = {
      { kind = "PICKUP", questName = "A Voice from the Light", questIDs = {88719}, points = { [84] = { x = 53.27, y = 54.34 }, [85] = { x = 53.40, y = 77.31 }, [2339] = { x = 44.18, y = 34.64 },} },
      { kind = "OBJECTIVE", questName = "A Voice from the Light", questIDs = {88719}, objectiveIndex = 1, points = { [84] = { x = 53.27, y = 54.34 }, [85] = { x = 53.40, y = 77.31 }, [2339] = { x = 44.18, y = 34.64 },}, text = "Speak with Liadrin." },
      { kind = "OBJECTIVE", questName = "A Voice from the Light", questIDs = {88719}, objectiveIndex = 2, points = { [84] = { x = 53.27, y = 54.34 }, [85] = { x = 53.40, y = 77.31 }, [2339] = { x = 44.18, y = 34.64 }, [2432] = { x = 48.50, y = 38.40 },}, showAfter = 2, text = "Wait for the teleport." },
      { kind = "TURNIN", mapID = 2432,  questName = "A Voice from the Light", questIDs = {88719}, x = 48.50, y = 38.40 },
      { kind = "NOTE", text = "You can enter the Sunwell by speaking with Liadrin or using the Light's Summon quest item." },
    },
  },
  {
    mapID = {2432} ,
    title = "Walk With Liadrin",
    segments = {
      { kind = "PICKUP", questName = "Last Bastion of the Light", questIDs = {86769}, x = 48.50, y = 38.40 },
      { kind = "OBJECTIVE", questName = "Last Bastion of the Light", questIDs = {86769}, x = 46.01, y = 44.36 , text = "Turn in {progress}." },
      { kind = "TURNIN", questName = "Last Bastion of the Light", questIDs = {86769}, x = 46.01, y = 44.36 },
      { kind = "NOTE", text = "Liadrin is VERY SLOW. It takes her 28 seconds to reach her destination, she moves at a fixed speed." },
    },
  },
  {
    title = "Parhelion Plaza",
    segments = {
      { kind = "PICKUP", mapID = 2432, questName = "Champions of Quel'danas", questIDs = {86770}, points = { [2432] = { x = 46.01, y = 44.36 }, [2565] = { x = 74.34, y = 49.31 },} },
      { kind = "PICKUP", mapID = 2432, questName = "My Son", questIDs = {89271}, points = { [2432] = { x = 45.98, y = 44.63 }, [2565] = { x = 75.00, y = 52.00 },} },
      { kind = "PICKUP", mapID = 2432, questName = "Where Heroes Hold", questIDs = {86780}, points = { [2432] = { x = 45.98, y = 44.63 }, [2565] = { x = 75.00, y = 52.00 },} },
      { kind = "OBJECTIVE", mapID = 2565, questName = "My Son", questIDs = {89271}, points = { [2432] = { x = 44.42, y = 51.32 }, [2565] = { x = 65.40, y = 87.57 },}, text = "Speak with Arator {progress}." },
      { kind = "OBJECTIVE", mapID = 2565, questName = "Champions of Quel'danas", questIDs = {86770}, objectiveIndex=2, points = { [2432] = { x = 41.90, y = 51.00 }, [2565] = { x = 54.15, y = 84.17 },}, text = "Speak with Alonsus Faol {progress}." },
      { kind = "OBJECTIVE", mapID = 2565, questName = "Champions of Quel'danas", questIDs = {86770}, objectiveIndex=3, points = { [2432] = { x = 41.57, y = 44.60 }, [2565] = { x = 51.30, y = 50.05 },}, text = "Speak with Lothraxion {progress}." },
      { kind = "OBJECTIVE", mapID = 2565, questName = "Champions of Quel'danas", questIDs = {86770}, objectiveIndex=1, points = { [2432] = { x = 45.23, y = 38.40 }, [2565] = { x = 70.31, y = 17.38 },}, text = "Speak with Faerin Lothar {progress}." },
      { kind = "OBJECTIVE", mapID = 2565, questName = "Where Heroes Hold", questIDs = {86780}, objectiveIndex=1, points = { [2432] = { x = 41.10, y = 44.40 }, [2565] = { x = 48.40, y = 50.55 },}, radius = 180, text = "Kill enemies to fill the bar {progress}." },
      { kind = "TURNIN", mapID = 2432, questName = "Champions of Quel'danas", questIDs = {86770}, points = { [2432] = { x = 35.42, y = 44.14 }, [2565] = { x = 17.20, y = 47.76 },} },
      { kind = "TURNIN", mapID = 2432, questName = "Where Heroes Hold", questIDs = {86780}, points = { [2432] = { x = 35.34, y = 43.82 }, [2565] = { x = 17.00, y = 45.88 },} },
      { kind = "TURNIN", mapID = 2432, questName = "My Son", questIDs = {89271}, points = { [2432] = { x = 35.34, y = 43.82 }, [2565] = { x = 17.00, y = 45.88 },} },
      { kind = "NOTE", text = "Speak with Arator first, as he can heal injured defenders for you. Non-elite voidwalkers are the most efficient mobs to kill for %." },
    },
  },
  {
    title = "Rescue Civilians",
          arrow = { mode = "SEQUENCE_CHAIN", radius = 3, key = "86805:rescues", debounce = 0.75,
      nodes = {
          { advance = "PROXIMITY", points = { [2432] = { x = 36.48, y = 43.90 }, [2565] = { x = 23.83, y = 45.75 }, }, gate = { questID = {86805}, atLeast = 3 } },
          { advance = "PROXIMITY", points = { [2432] = { x = 37.95, y = 46.30 }, [2565] = { x = 31.08, y = 60.30 }, }, gate = { questID = {86805}, atLeast = 5 } },
          { advance = "PROXIMITY", points = { [2432] = { x = 38.50, y = 45.12 }, [2565] = { x = 35.41, y = 54.10 }, }, gate = { questID = {86805}, atLeast = 9 } },
          { advance = "PROXIMITY", points = { [2432] = { x = 38.40, y = 43.55 }, [2565] = { x = 33.46, y = 45.35 }, }, gate = { questID = {86805}, atLeast = 13 } },
          { advance = "PROXIMITY", points = { [2432] = { x = 39.45, y = 46.84 }, [2565] = { x = 40.06, y = 63.62 }, }, gate = { questID = {86805}, atLeast = 16 } },
          { advance = "OBJECTIVE", questIDs = {89012}, objectiveIndex=1, radius = 15, points = { [2432] = { x = 41.07, y = 49.50 }, [2565] = { x = 49.56, y = 74.47 },} },
          { advance = "PROXIMITY", points = { [2432] = { x = 41.64, y = 47.15 }, [2565] = { x = 50.38, y = 65.20 }, }, gate = { questID = {86805}, objectiveIndex = 1, atLeast = 19 } },
        },
      fallback = {
          points = { [2432] = { x = 39.00, y = 44.80 }, [2565] = { x = 35.50, y = 54.00 }, },
          radius = 120,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "The Hour of Need", questIDs = {86805}, points = { [2432] = { x = 35.40, y = 44.00 }, [2565] = { x = 17.60, y = 48.65 },}},
      { kind = "PICKUP", questName = "A Safe Path", questIDs = {89012}, points = { [2432] = { x = 35.51, y = 44.24 }, [2565] = { x = 17.60, y = 48.65 },}},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "A Safe Path", questIDs = {89012}, points = { [2432] = { x = 41.07, y = 49.50 }, [2565] = { x = 49.56, y = 74.47 },}, radius = 10, text = "Kill Gloomstress {progress}." },
      { kind = "OBJECTIVE", questName = "The Hour of Need", questIDs = {86805}, points = { [2432] = { x = 39.00, y = 44.80 }, [2565] = { x = 35.50, y = 54.00 },}, objectiveIndex = 1, text = "Rescue Civilians {progress}." },
      { kind = "OBJECTIVE", questName = "The Hour of Need", questIDs = {86805}, points = { [2432] = { x = 41.31, y = 56.80 }, [2565] = { x = 48.93, y = 115.50 },}, objectiveIndex = 2, showAfter=5, text = "Follow the arrow." },
      { kind = "TURNIN", questName = "The Hour of Need", questIDs = {86805}, points = { [2432] = { x = 41.31, y = 56.80 }, [2565] = { x = 48.93, y = 115.50 },} },
      { kind = "TURNIN", questName = "A Safe Path", questIDs = {89012}, points = { [2432] = { x = 41.31, y = 56.80 }, [2565] = { x = 48.93, y = 115.50 },} },
      { kind = "NOTE", text = "Speaking with Scared Civilians is the most efficient way to rescue 20. Arator sometimes heals Injured Civilians." },
    },
  },
  {
    mapID = {2432},
    title = "Dragonhawk Rescue",
          arrow = { mode = "SEQUENCE_CHAIN", radius = 30, key = "86806:boats", debounce = 0.75,
      nodes = {
          { advance = "PROXIMITY", x = 36.34, y = 67.24, gate = { questID = {86806}, objectiveIndex = 3, atLeast = 1 } },
          { advance = "PROXIMITY", x = 29.43, y = 70.54, gate = { questID = {86806}, objectiveIndex = 3, atLeast = 2 } },
          { advance = "PROXIMITY", x = 28.75, y = 75.64, gate = { questID = {86806}, objectiveIndex = 3, atLeast = 3 } },
        },
      fallback = {
          points = { [2432] = { x = 31.00, y = 72.00 } },
          radius = 120,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Luminous Wings", questIDs = {86806}, x = 41.20, y = 56.80 },
      { kind = "OBJECTIVE", questName = "Luminous Wings", questIDs = {86806}, objectiveIndex=1, x = 41.00, y = 58.00, text = "Ride the Dragonhawk." },
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Luminous Wings", questIDs = {86806}, objectiveIndex=3, x = 36.20, y = 67.40 , showAfter=2, radius = 10, text = "Rescue civilians {progress}." },
      { kind = "OBJECTIVE", questName = "Luminous Wings", questIDs = {86806}, objectiveIndex=2, x = 31.00, y = 72.00 , showAfter=2,radius = 120, text = "Kill blobs or squids {progress}." },
      { kind = "TURNIN", questName = "Luminous Wings", questIDs = {86806}, x = 41.20, y = 56.80 },
      { kind = "NOTE", text = "Use 1 to shoot. Fly close to a civilian boat and press 2 to rescue them. 3 gives a speed boost. You can dismount the dragonhawk as soon as all objectives are complete." },
    },
  },
  {
    title = "Cross the Plaza",
    segments = {
      { kind = "PICKUP", questName = "The Gate", questIDs = {86807}, points = { [2432] = { x = 41.31, y = 56.58 }, [2565] = { x = 48.93, y = 115.50 },} },
      { kind = "OBJECTIVE", questName = "The Gate", questIDs = {86807}, points = { [2432] = { x = 41.25, y = 39.15 }, [2565] = { x = 49.08, y = 22.38 },}, text = "Follow the arrow." },
      { kind = "TURNIN", questName = "The Gate", questIDs = {86807}, points = { [2432] = { x = 41.25, y = 39.15 }, [2565] = { x = 49.08, y = 22.38 },} },
      { kind = "NOTE", text = "Ignore the nearby bonus objective, it's not worth it. The same is true for all future bonus objectives within the Sunwell Intro." },
    },
  },
  {
    title = "Dawnstar Village",
          arrow = { mode = "SEQUENCE_CHAIN", radius = 5, key = "dawnstar:route", debounce = 0.75,
      nodes = {
          { advance = "PROXIMITY", radius = 5, points = { [2432] = { x = 42.80, y = 35.73 },  [2565] = { x = 57.10, y = 00.01 },}, gate = { questID = {91274}, objectiveIndex = 1, atLeast = 1 }},
          { advance = "PROXIMITY", radius = 5, points = { [2432] = { x = 44.42, y = 35.46 },  [2565] = { x = 57.80, y = 00.10 },}, gate = { questID = {91274}, objectiveIndex = 1, atLeast = 2 } },
          { advance = "OBJECTIVE", questIDs = {86834}, objectiveIndex=2, radius = 20, points = { [2432] = { x = 46.35, y = 33.55 }, [2565] = { x = 57.80, y = 00.10 },} },
          { advance = "PROXIMITY", radius = 5, points = { [2432] = { x = 43.26, y = 29.52 },  [2565] = { x = 57.80, y = 00.10 },}, gate = { questID = {91274}, objectiveIndex = 1, atLeast = 3 } },
          { advance = "OBJECTIVE", questIDs = {86834}, objectiveIndex=1, radius = 40, points = { [2432] = { x = 41.62, y = 27.96 }, [2565] = { x = 57.80, y = 00.10 },} },
          { advance = "PROXIMITY", radius = 5, points = { [2432] = { x = 38.86, y = 31.93 },  [2565] = { x = 57.80, y = 00.10 },}, gate = { questID = {91274}, objectiveIndex = 1, atLeast = 4 } },
          { advance = "OBJECTIVE", questIDs = {86834}, objectiveIndex=3, radius = 20, points = { [2432] = { x = 37.11, y = 30.13 }, [2565] = { x = 57.80, y = 00.10 },} },
          { advance = "PROXIMITY", radius = 5, points = { [2432] = { x = 42.48, y = 25.51 },  [2565] = { x = 57.80, y = 00.10 },}, gate = { questID = {91274}, objectiveIndex = 1, atLeast = 5 } },
        },
      fallback = {
          points = { [2432] = { x = 45.40, y = 27.00 } },
          radius = 120,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Voidborn Banishing", questIDs = {86834}, points = { [2432] = { x = 41.40, y = 39.20 }, [2565] = { x = 49.66, y = 21.35 },}, radius = 10},
      { kind = "PICKUP", questName = "Severing the Void", questIDs = {91274}, points = { [2432] = { x = 41.40, y = 39.20 }, [2565] = { x = 49.66, y = 21.35 },}, radius = 10},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Severing the Void", questIDs = {91274}, objectiveIndex=1, points = { [2432] = { x = 42.80, y = 35.73 },  [2565] = { x = 57.10, y = 00.01 },}, text = "Activate Sentinels {progress}." },
      { kind = "OBJECTIVE", questName = "Voidborn Banishing", questIDs = {86834}, objectiveIndex=2, points = { [2432] = { x = 46.40, y = 33.40 }, [2565] = { x = 56.60, y = 10.50 },}, text = "Kill Blightclaw {progress}." },
      { kind = "OBJECTIVE", questName = "Voidborn Banishing", questIDs = {86834}, objectiveIndex=1, points = { [2432] = { x = 41.40, y = 27.60 }, [2565] = { x = 56.60, y = 10.50 },}, radius = 20, text = "Kill The Wasting {progress}." },
      { kind = "OBJECTIVE", questName = "Voidborn Banishing", questIDs = {86834}, objectiveIndex=3, points = { [2432] = { x = 37.00, y = 30.20 }, [2565] = { x = 56.60, y = 10.50 },}, text = "Kill Latrunculon {progress}." },
      { kind = "TURNIN", mapID = 2432, questName = "Voidborn Banishing", questIDs = {86834}, x = 45.40, y = 27.00 },
      { kind = "TURNIN", mapID = 2432, questName = "Severing the Void", questIDs = {91274}, x = 45.40, y = 27.00 },
      { kind = "NOTE", text = "The Wasting patrols in a small circle." },
    },
  },
  {
    mapID = {2432},
    title = "Kael'thas Weapons",
          arrow = { mode = "SEQUENCE_CHAIN", radius = 5, key = "kaelthas:weapons", debounce = 0.75,
      nodes = {
          { advance = "OBJECTIVE", questIDs = {86811}, objectiveIndex=2, radius = 15, points = { [2432] = { x = 49.37, y = 22.36 },} },
          { advance = "PROXIMITY", radius = 10, points = { [2432] = { x = 49.18, y = 23.38 },}, gate = { questID = {86848}, objectiveIndex = 1, atLeast = 1 } },
          { advance = "PROXIMITY", radius = 20, points = { [2432] = { x = 47.68, y = 28.82 },}, gate = { questID = {86848}, objectiveIndex = 1, atLeast = 5 } },
          { advance = "PROXIMITY", radius = 15, points = { [2432] = { x = 44.87, y = 23.73 },}, gate = { questID = {86848}, objectiveIndex = 1, atLeast = 7 } },
        },
      fallback = {
          points = { [2432] = { x = 47.18, y = 24.90 } },
          radius = 200,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Ethereal Eradication", questIDs = {86811}, x = 45.39, y = 26.98},
      { kind = "PICKUP", questName = "Light's Arsenal", questIDs = {86848}, x = 45.22, y = 26.92},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Light's Arsenal", questIDs = {86848}, x = 45.20, y = 27.00 , radius = 40, text = "Collect Weapons {progress}." },
      { kind = "OBJECTIVE", questName = "Ethereal Eradication", questIDs = {86811}, objectiveIndex=2, radius = 15, x = 49.37, y = 22.36 , text = "Kill Norkonahl the Looter {progress}." },
      { kind = "OBJECTIVE", questName = "Ethereal Eradication", questIDs = {86811}, objectiveIndex=1, x = 47.18, y = 24.90 , radius = 200, text = "Kill Ethereals {progress}." },
      { kind = "TURNIN", questName = "Ethereal Eradication", questIDs = {86811}, x = 45.39, y = 26.98},
      { kind = "TURNIN", questName = "Light's Arsenal", questIDs = {86848}, x = 45.22, y = 26.92},
      { kind = "NOTE", text = "You can use the weapons you pick up to deal massive damage. Weapons are scattered across multiple floors of the buildings." },
    },
  },
  {
    mapID = {2432},
    title = "Reach the Harbor",
    segments = {
      { kind = "PICKUP", questName = "Wrath Unleashed", questIDs = {86849}, x = 45.39, y = 26.98},
      { kind = "OBJECTIVE", questName = "Wrath Unleashed", questIDs = {86849}, objectiveIndex=4, radius = 8, x = 45.70, y = 11.32 , text = "Speak with Turalyon and channel in the light area." },
      { kind = "TURNIN", questName = "Wrath Unleashed", questIDs = {86849}, x = 45.85, y = 11.54},
      { kind = "NOTE", text = "Radinax Control Gem can ignore the slow effect, otherwise run into the light bubbles." },
    },
  },
  {
    title = "Dragonhawk RP Flight",
    segments = {
      { kind = "PICKUP", mapID = 2432, questName = "Broken Sun", questIDs = {86850}, x = 45.85, y = 11.54},
      { kind = "OBJECTIVE", mapID = 2432, questName = "Broken Sun", questIDs = {86850}, objectiveIndex=1, x = 39.60, y = 16.40 , radius = 10, text = "Reach the Dragonhawk." },
      { kind = "OBJECTIVE", mapID = 2432, questName = "Broken Sun", questIDs = {86850}, objectiveIndex=2, x = 51.80, y = 56.27, showAfter = 2, radius = 5, text = "Wait for the RP to complete." },
      { kind = "TURNIN", questName = "Broken Sun", questIDs = {86850}, radius = 10, points = { [2432] = { x = 52.88, y = 50.06 },  [2566] = { x = 51.74, y = 81.29 },} },
      { kind = "NOTE", text = "RP Flight is unskippable. You can refresh buffs (even food) while riding the dragonhawk." },
    },
  },
  {
    mapID = {2566},
    title = "Defend the Sunwell",
    segments = {
      { kind = "PICKUP", questName = "Light's Last Stand", questIDs = {86852}, radius = 10, points = { [2432] = { x = 52.66, y = 50.07 },  [2566] = { x = 51.74, y = 81.29 },} },
      { kind = "OBJECTIVE", questName = "Light's Last Stand", questIDs = {86852}, objectiveIndex=2, points = { [2432] = { x = 52.64, y = 44.57 },  [2566] = { x = 50.95, y = 43.94 },}, radius = 100, text = "Kill enemies to fill the bar {progress}." },
      { kind = "OBJECTIVE", questName = "Light's Last Stand", questIDs = {86852}, objectiveIndex=4, x = 51.23, y = 21.94 , showAfter = 2, text = "Kill Imperatus {progress}." },
      { kind = "TURNIN", questName = "Light's Last Stand", questIDs = {86852}, points = { [2424] = { x = 52.66, y = 88.20 },  [2566] = { x = 51.23, y = 21.94 },}},
      { kind = "NOTE", text = "Non-elite voidwalkers are best for %. Imperatus objective only activates once you reach 100%." },
    },
  },
  {
    title = "Onwards to Silvermoon",
    segments = {
      { kind = "PICKUP", questName = "Silvermoon Negotiations", mapID = 2424, questIDs = {86733}, x = 52.53, y = 88.19 },
      { kind = "OBJECTIVE", questName = "Silvermoon Negotiations", mapID = 2393, questIDs = {86733}, x = 45.43, y = 70.34 , text = "Fly to Silvermoon."},
      { kind = "TURNIN", questName = "Silvermoon Negotiations", mapID = 2393, questIDs = {86733}, x = 45.43, y = 70.34 },
    },
  },
  {
    title = "Eversong Woods",
    segments = {
      { kind = "OBJECTIVE", mapID = 2393, x = 45.44, y = 70.34, text = "You've completed the Sunwell Intro! Click the button below to continue the guide."},
      { kind = "MODULE_BUTTON", moduleID = "MIDNIGHT_EVERSONG_WOODS", label = "Eversong Woods", thumbnail =  "Interface\\AddOns\\FollowTheArrow\\Images\\EversongWoods_Thumb" },
    },
  },
}

FTA.Modules[M.id] = M