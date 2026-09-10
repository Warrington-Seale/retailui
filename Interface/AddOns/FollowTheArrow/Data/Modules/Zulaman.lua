local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "MIDNIGHT_ZULAMAN"
M.title = "Zul'Aman"
M.defaultRadius = 5

M.routeId    = "MIDNIGHT_CAMPAIGN"
M.routeTitle = "Midnight Campaign"
M.routeOrder = 11

M.moduleOrder = 50
M.nextModuleId = "TBD" 

M.steps = {
    {
    title = "To Zul'Aman",
    segments = {
      { kind = "PICKUP", questName = "The Gates of Zul'Aman", mapID = 2393, radius = 8, questIDs = {86708}, x = 45.60, y = 70.34},
      { kind = "OBJECTIVE", questName = "The Gates of Zul'Aman", mapID = 2395, questIDs = {86708}, x = 60.14, y = 81.45, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "The Gates of Zul'Aman", mapID = 2395, questIDs = {86708}, x = 60.14, y = 81.45},
      { kind = "NOTE", text = "If you get the quest Deepening Shadows from Commander Koruth Mountainfist, ignore it. This will be covered later in the Voidstorm module." },
    },
  },
  {
    title = "De-escalation",
    mapID = {2395},
    segments = {
      { kind = "PICKUP", questName = "The Line Must be Drawn Here", questIDs = {86710}, x = 60.14, y = 81.45},
      { kind = "OBJECTIVE", questName = "The Line Must be Drawn Here", objectiveIndex=1, questIDs = {86710}, x = 60.29, y = 81.45 , text = "Speak to Zul'jan {progress}." },
      { kind = "OBJECTIVE", questName = "The Line Must be Drawn Here", objectiveIndex=3, showAfter = 2, radius = 10, questIDs = {86710}, x = 60.37, y = 81.45 , text = "Kill the void beast {progress}." },
      { kind = "TURNIN", questName = "The Line Must be Drawn Here", mapID = 2395, questIDs = {86710}, x = 60.14, y = 81.45},
      { kind = "NOTE", text = "The void beast spawns after about 20 seconds of unskippable RP." },
    },
  },
  {
    title = "To Atal'Aman",
    segments = {
      { kind = "PICKUP", questName = "Our Mutual Enemy", mapID = 2395, questIDs = {90749}, x = 60.14, y = 81.45},
      { kind = "OBJECTIVE", questName = "Our Mutual Enemy", objectiveIndex=1, questIDs = {90749}, points = { [2395] = { x = 64.50, y = 81.50 },  [2536] = { x = 05.47, y = 46.98 },}, text = "Follow the arrow {progress}." },
      { kind = "TURNIN", questName = "Our Mutual Enemy", questIDs = {90749}, points = { [2395] = { x = 64.50, y = 81.50 },  [2536] = { x = 05.47, y = 46.98 },} },
      { kind = "NOTE", text = "It's faster to fly over the gate rather than through it." },
    },
  },
  {
    title = "Goodwill Tour",
    mapID = {2536},
    arrow = { mode = "SEQUENCE_CHAIN", radius = 8, key = "goodwill:tour", debounce = 0.75,
      nodes = {
          { advance = "PROXIMITY", x = 16.63, y = 47.76, gate = { questID = {86711}, objectiveIndex = 1, atLeast = 1 } },
          { advance = "PROXIMITY", x = 24.85, y = 48.66, gate = { questID = {86711}, objectiveIndex = 1, atLeast = 2 } },
          { advance = "PROXIMITY", x = 35.90, y = 49.38, gate = { questID = {86711}, objectiveIndex = 1, atLeast = 3 } },
        },
      fallback = {
          x = 26.51, y = 47.28,
          radius = 300,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Amani Clarion Call", questIDs = {86711}, x = 05.64, y = 47.75},
      { kind = "PICKUP", questName = "Goodwill Tour", questIDs = {86868}, x = 05.47, y = 46.98},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Amani Clarion Call", objectiveIndex=1, radius = 300, questIDs = {86711}, x = 26.51, y = 47.28, text = "Sound the drums {progress}." },
      { kind = "OBJECTIVE", questName = "Goodwill Tour", objectiveIndex=1, radius = 300, questIDs = {86868}, x = 26.51, y = 47.28, text = "Kill invading shadows {progress}." },
      { kind = "TURNIN", questName = "Amani Clarion Call", questIDs = {86711}, x = 46.02, y = 48.42},
      { kind = "TURNIN", questName = "Goodwill Tour", questIDs = {86868}, x = 46.28, y = 48.81},
    },
  },
  {
    title = "Show Your Worth",
    mapID = {2536},
    segments = {
      { kind = "PICKUP", questName = "Important Amani", questIDs = {86719}, x = 46.32, y = 48.38},
      { kind = "PICKUP", questName = "Show Us Your Worth", questIDs = {86717}, x = 46.28, y = 48.81},
      { kind = "OBJECTIVE", questName = "Important Amani", objectiveIndex=1, questIDs = {86719}, x = 50.66, y = 19.97, text = "Speak with Elder Doru {progress}." },
      { kind = "OBJECTIVE", questName = "Important Amani", objectiveIndex=2, questIDs = {86719}, x = 35.67, y = 24.62, text = "Speak with Torundo the Grizzled {progress}." },
      { kind = "OBJECTIVE", questName = "Important Amani", objectiveIndex=3, showAfter = 4, questIDs = {86719}, x = 16.83, y = 20.55, text = "Speak with Kinduru {progress}." },
      { kind = "OBJECTIVE", questName = "Important Amani", objectiveIndex=4, showAfter = 5, questIDs = {86719}, x = 17.10, y = 20.00, text = "Search for the staff {progress}." },
      { kind = "OBJECTIVE", questName = "Important Amani", objectiveIndex=5, showAfter = 6, questIDs = {86719}, x = 16.53, y = 20.72, text = "Search for the staff {progress}." },
      { kind = "OBJECTIVE", questName = "Show Us Your Worth", objectiveIndex=1, radius = 300, questIDs = {86717}, x = 34.82, y = 24.37, text = "Kill enemies to fill the bar {progress}." },
      { kind = "TURNIN", questName = "Important Amani", questIDs = {86719}, x = 16.59, y = 20.44},
      { kind = "TURNIN", questName = "Show Us Your Worth", questIDs = {86717}, x = 16.59, y = 20.44},
      { kind = "NOTE", text = "Try to get most of your % after speaking with the first two NPCs, there's better density there." },
    },
  },
  {
    title = "Armed by Light",
    mapID = {2536},
    arrow = { mode = "SEQUENCE_CHAIN", radius = 8, key = "lightwood:86716", debounce = 0.75,
      nodes = {
          { advance = "PROXIMITY", x = 16.45, y = 59.33, gate = { questID = {86721}, objectiveIndex = 1, atLeast = 1 } },
          { advance = "PROXIMITY", x = 22.30, y = 61.44, gate = { questID = {86721}, objectiveIndex = 1, atLeast = 2 } },
          { advance = "PROXIMITY", x = 23.65, y = 67.90, gate = { questID = {86721}, objectiveIndex = 1, atLeast = 3 } },
          { advance = "PROXIMITY", x = 17.91, y = 76.16, gate = { questID = {86721}, objectiveIndex = 1, atLeast = 4 } },
          { advance = "PROXIMITY", x = 22.57, y = 80.39, gate = { questID = {86721}, objectiveIndex = 2, atLeast = 1 } },
        },
      fallback = {
          x = 26.51, y = 47.28,
          radius = 300,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Armed by Light", questIDs = {86716}, x = 16.59, y = 20.44},
      { kind = "PICKUP", questName = "Everything We Worked For", questIDs = {86721}, x = 16.59, y = 20.44},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Armed by Light", objectiveIndex=1, radius = 100, questIDs = {86716}, x = 19.53, y = 64.51, text = "Kill enemies to loot lightwood weapons {progress}." },
      { kind = "OBJECTIVE", questName = "Everything We Worked For", objectiveIndex=1, questIDs = {86721}, x = 16.59, y = 20.44, text = "Extinguish fires {progress}." },
      { kind = "OBJECTIVE", questName = "Everything We Worked For", objectiveIndex=2, showAfter = 5, questIDs = {86721}, x = 16.59, y = 20.44, text = "Extinguish huge fire {progress}." },
      { kind = "TURNIN", questName = "Armed by Light", questIDs = {86716}, x = 22.58, y = 79.83},
      { kind = "TURNIN", questName = "Everything We Worked For", questIDs = {86721}, x = 22.58, y = 79.83},
    },
  },
  {
    title = "Rituals Cut Short",
    mapID = {2536},
    segments = {
      { kind = "PICKUP", questName = "Twilight Bled", questIDs = {86718}, x = 22.88, y = 79.32},
      { kind = "PICKUP", questName = "Rituals Cut Short", questIDs = {86715}, x = 23.11, y = 79.84},
      { kind = "PICKUP", questName = "The Amani Stand Strong", questIDs = {86712}, x = 22.58, y = 79.83},
      { kind = "OBJECTIVE", questName = "Twilight Bled", radius = 20, objectiveIndex=1, questIDs = {86718}, x = 34.68, y = 78.97, text = "Kill Benvis Bladespatter {progress}." },
      { kind = "OBJECTIVE", questName = "Rituals Cut Short", radius = 150, objectiveIndex=1, questIDs = {86715}, x = 34.54, y = 71.18, text = "Kill Twilight Ritualists {progress}." },
      { kind = "OBJECTIVE", questName = "Rituals Cut Short", radius = 150, objectiveIndex=2, questIDs = {86715}, x = 34.54, y = 71.18, text = "Kill Twilight Trollbreakers {progress}." },
      { kind = "OBJECTIVE", questName = "The Amani Stand Strong", radius = 150, objectiveIndex=1, questIDs = {86712}, x = 34.54, y = 71.18, text = "Arm defenders {progress}." },
      { kind = "TURNIN", questName = "Twilight Bled", questIDs = {86718}, x = 47.50, y = 46.77},
      { kind = "TURNIN", questName = "Rituals Cut Short", questIDs = {86715}, x = 47.22, y = 46.90},
      { kind = "TURNIN", questName = "The Amani Stand Strong", questIDs = {86712}, x = 49.05, y = 46.66},
      { kind = "NOTE", text = "Picking up a nearby Lightwood Axe gives you a powerful extra action ability." },
    },
  },
  {
    title = "Break the Blade",
    mapID = {2536},
    segments = {
      { kind = "PICKUP", questName = "Break the Blade", questIDs = {86720}, x = 47.52, y = 46.76},
      { kind = "OBJECTIVE", questName = "Break the Blade", radius = 10, objectiveIndex=1, questIDs = {86720}, x = 49.13, y = 47.12, text = "Use the ballista {progress}." },
      { kind = "OBJECTIVE", questName = "Break the Blade", radius = 10, showAfter = 2, objectiveIndex=2, questIDs = {86720}, x = 49.13, y = 47.12, text = "Shoot all Empowering Shadows {progress}." },
      { kind = "TURNIN", questName = "Break the Blade", questIDs = {86720}, x = 47.76, y = 47.81},
      { kind = "NOTE", text = "1 to shoot, 2 to deflect incoming projectiles. The incoming projectiles do basically no damage so you can ignore them. You can not leave the vehicle early, wait until you receive credit for breaking defenses." },
    },
  },
  {
    title = "To Amani'Zar Village",
    mapID = {2437, 2536},
    segments = {
      { kind = "PICKUP", questName = "Heart of the Amani", questIDs = {86722}, points = { [2437] = { x = 32.78, y = 54.28 },  [2536] = { x = 47.76, y = 47.81 },} },
      { kind = "OBJECTIVE", questName = "Heart of the Amani", mapID = 2437, questIDs = {86722}, x = 42.65, y = 66.85, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "Heart of the Amani", mapID = 2437, questIDs = {86722}, x = 42.65, y = 66.85},
    },
  },
  {
    title = "Isolation",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Isolation", questIDs = {86723}, x = 42.65, y = 66.85 },
      { kind = "OBJECTIVE", questName = "Isolation", objectiveIndex=1, questIDs = {86723}, x = 45.75, y = 65.51, text = "Speak with Zul'jarra and skip the conversation {progress}." },
      { kind = "TURNIN", questName = "Isolation", questIDs = {86723}, x = 45.75, y = 65.51},
      { kind = "NOTE", text = "Speak with Tavikko near the turn-in point and set your Hearthstone. This will save time later." },
    },
  },
  {
    title = "Left in the Shadows",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Left in the Shadows", questIDs = {86652}, x = 45.75, y = 65.51 },
      { kind = "OBJECTIVE", questName = "Left in the Shadows", objectiveIndex=1, questIDs = {86652}, x = 46.86, y = 67.32, text = "Help prepare meals {progress}." },
      { kind = "OBJECTIVE", questName = "Left in the Shadows", objectiveIndex=2, showAfter = 2, questIDs = {86652}, x = 45.14, y = 67.70, text = "Get the report {progress}." },
      { kind = "OBJECTIVE", questName = "Left in the Shadows", objectiveIndex=3, showAfter = 3, questIDs = {86652}, x = 43.97, y = 65.07, text = "Request shamans {progress}." },
      { kind = "OBJECTIVE", questName = "Left in the Shadows", objectiveIndex=4, showAfter = 4, questIDs = {86652}, x = 43.78, y = 68.41, text = "Speak with Kinduru {progress}." },
      { kind = "TURNIN", questName = "Left in the Shadows", questIDs = {86652}, x = 43.80, y = 68.33},
      { kind = "NOTE", text = "Speak with Tavikko near the start point and set your Hearthstone. This will save time later." },
    },
  },
  {
    title = "To Akil'zon's Reach",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "The Path of the Amani", questIDs = {86653}, x = 43.80, y = 68.33 },
      { kind = "OBJECTIVE", questName = "The Path of the Amani", radius = 10, objectiveIndex=1, questIDs = {86653}, x = 51.63, y = 70.80, text = "Follow the arrow {progress}." },
      { kind = "TURNIN", questName = "The Path of the Amani", questIDs = {86653}, x = 51.63, y = 70.80},
    },
  },
  {
    title = "Gnarldin Bashing",
    mapID = {2437},
    arrow = { mode = "SEQUENCE_CHAIN", radius = 8, key = "gnarldin:89334", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 55.28, y = 70.87, gate = { questID = {86655}, objectiveIndex = 1, atLeast = 1 } },
            { advance = "PROXIMITY", x = 56.26, y = 73.82, gate = { questID = {86655}, objectiveIndex = 1, atLeast = 2 } },
            { advance = "OBJECTIVE", radius = 12, objectiveIndex=1, questIDs = {89334}, x = 56.19, y = 74.96 },
            { advance = "PROXIMITY", x = 55.24, y = 76.26, gate = { questID = {86655}, objectiveIndex = 1, atLeast = 3 } },
            { advance = "OBJECTIVE", radius = 12, objectiveIndex=3, questIDs = {89334}, x = 55.27, y = 77.86 },
            { advance = "OBJECTIVE", radius = 12, objectiveIndex=2, questIDs = {89334}, x = 53.30, y = 74.23 },  
            { advance = "PROXIMITY", x = 53.67, y = 72.97, gate = { questID = {86655}, objectiveIndex = 1, atLeast = 4 } },
            { advance = "OBJECTIVE", objectiveIndex=1, radius = 200, questIDs = {86654}, x = 54.23, y = 72.86 },
            { advance = "OBJECTIVE", objectiveIndex=2, questIDs = {86655}, x = 51.91, y = 76.03 },
        },
      fallback = {
          x = 47.71, y = 69.77,
          radius = 10,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Ahead of the Issue", questIDs = {89334}, x = 51.63, y = 70.80},
      { kind = "PICKUP", questName = "De Ancient Path", questIDs = {86655}, x = 51.63, y = 70.80},
      { kind = "PICKUP", questName = "Gnarldin Bashing", questIDs = {86654}, x = 51.61, y = 70.73},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Ahead of the Issue", radius = 20, objectiveIndex=1, questIDs = {89334}, x = 34.68, y = 78.97, text = "Kill and loot Brulagh {progress}." },
      { kind = "OBJECTIVE", questName = "Ahead of the Issue", radius = 150, objectiveIndex=3, questIDs = {89334}, x = 34.54, y = 71.18, text = "Kill and loot Helthra {progress}." },
      { kind = "OBJECTIVE", questName = "Ahead of the Issue", radius = 150, objectiveIndex=2, questIDs = {89334}, x = 34.54, y = 71.18, text = "Kill and loot Gaahl {progress}." },
      { kind = "OBJECTIVE", questName = "De Ancient Path", radius = 150, objectiveIndex=1, questIDs = {86655}, x = 34.54, y = 71.18, text = "Light shrines {progress}." },
      { kind = "OBJECTIVE", questName = "De Ancient Path", radius = 150, objectiveIndex=2, showAfter = 8, questIDs = {86655}, x = 34.54, y = 71.18, text = "Light the final shrine {progress}." },
      { kind = "OBJECTIVE", questName = "Gnarldin Bashing", radius = 200, objectiveIndex=1, questIDs = {86654}, x = 34.54, y = 71.18, text = "Kill Gnarldin {progress}." },
      { kind = "TURNIN", questName = "Ahead of the Issue", questIDs = {89334}, x = 51.91, y = 75.95},
      { kind = "TURNIN", questName = "De Ancient Path", questIDs = {86655}, x = 51.91, y = 75.95},
      { kind = "TURNIN", questName = "Gnarldin Bashing", questIDs = {86654}, x = 51.96, y = 76.02},
      { kind = "NOTE", text = "Kill gnarldin as you follow the arrow. Arrow will wait for you to kill all 12 before proceeding to the final shrine." },
    },
  },
  {
    title = "Temple of Akil'zon",
    mapID = {2437},
    arrow = { mode = "SEQUENCE_CHAIN", radius = 8, key = "feast:86656", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 52.40, y = 82.37, gate = { questID = {86656}, objectiveIndex = 4, atLeast = 1 } },
            { advance = "PROXIMITY", x = 53.19, y = 81.08, gate = { questID = {86656}, objectiveIndex = 4, atLeast = 2 } },
            { advance = "PROXIMITY", x = 53.25, y = 80.67, gate = { questID = {86656}, objectiveIndex = 4, atLeast = 3 } },
        },
      fallback = {
          x = 47.71, y = 69.77,
          radius = 10,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Brutal Feast", questIDs = {86656}, x = 51.91, y = 75.95 },
      { kind = "OBJECTIVE", questName = "Brutal Feast", radius = 15, objectiveIndex=1, questIDs = {86656}, x = 52.40, y = 81.06, text = "Follow the arrow {progress}." },
      { kind = "OBJECTIVE", questName = "Brutal Feast", objectiveIndex=2, showAfter = 2, questIDs = {86656}, x = 52.40, y = 81.06, text = "Loot the sack of heads {progress}." },
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Brutal Feast", objectiveIndex=4, showAfter = 3, questIDs = {86656}, x = 52.40, y = 81.06, text = "Place Gnarldin heads {progress}." },
      { kind = "TURNIN", questName = "Brutal Feast", questIDs = {86656}, x = 52.40, y = 81.06},
    },
  },
  {
    title = "Leap of Faith",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Test of Conviction", questIDs = {86809}, x = 52.40, y = 81.06 },
      { kind = "OBJECTIVE", questName = "Test of Conviction", radius = 10, objectiveIndex=1, questIDs = {86809}, x = 51.22, y = 79.24, text = "Follow the arrow {progress}." },
      { kind = "OBJECTIVE", questName = "Test of Conviction", radius = 8, objectiveIndex=2, showAfter = 2, questIDs = {86809}, x = 51.05, y = 78.99, text = "Jump off the cliff {progress}." },
      { kind = "TURNIN", questName = "Test of Conviction", questIDs = {86809}, x = 52.40, y = 81.06},
      { kind = "NOTE", text = "Trust." },
    },
  },
  {
    title = "To Shadebasin Watch",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Shadebasin Watch", questIDs = {86657}, x = 52.40, y = 81.06 },
      { kind = "OBJECTIVE", questName = "Shadebasin Watch", radius = 10, objectiveIndex=2, questIDs = {86657}, x = 44.08, y = 34.50, text = "Follow the arrow {progress}." },
      { kind = "TURNIN", questName = "Shadebasin Watch", questIDs = {86657}, x = 44.08, y = 34.50},
      { kind = "NOTE", text = "Good spot for a Falling Flame, if you have one." },
    },
  },
  {
    title = "The Crypt in the Mist",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "The Crypt in the Mist", questIDs = {86658}, x = 44.08, y = 34.50 },
      { kind = "PICKUP", questName = "Rescue from the Shadows", questIDs = {86660}, x = 44.08, y = 34.50 },
      --{ kind = "OBJECTIVE", questName = "The Crypt in the Mist", radius = 70, objectiveIndex=1, questIDs = {86658}, x = 39.22, y = 39.15, text = "Follow the arrow {progress}." },
      { kind = "OBJECTIVE", questName = "The Crypt in the Mist", radius = 100, objectiveIndex=2, questIDs = {86658}, x = 37.91, y = 37.21, text = "Kill Vilebranch Trolls {progress}." },
      { kind = "OBJECTIVE", questName = "Rescue from the Shadows", radius = 100, objectiveIndex=1, questIDs = {86660}, x = 37.91, y = 37.21, text = "Rescue Witherbark {progress}." },
      { kind = "OBJECTIVE", questName = "The Crypt in the Mist", radius = 10, objectiveIndex=3, questIDs = {86658}, x = 37.54, y = 36.00, text = "Kill Ritualist Zongha {progress}." },
      { kind = "TURNIN", questName = "The Crypt in the Mist", questIDs = {86658}, x = 36.76, y = 34.97},
      { kind = "TURNIN", questName = "Rescue from the Shadows", questIDs = {86660}, x = 36.76, y = 34.97},
      { kind = "NOTE", text = "Ritualist is by the exit, arrow will point to her once all other objectives are clear." },
    },
  },
  {
    title = "Breaching the Mist",
    mapID = {2437},
    arrow = { mode = "SEQUENCE_CHAIN", radius = 8, key = "mist:86659", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 33.39, y = 34.48, gate = { questID = {86659}, objectiveIndex = 2, atLeast = 1 } },
            { advance = "PROXIMITY", x = 34.84, y = 30.92, gate = { questID = {86659}, objectiveIndex = 2, atLeast = 2 } },
            { advance = "PROXIMITY", x = 33.96, y = 32.02, gate = { questID = {86659}, objectiveIndex = 2, atLeast = 3 } },
        },
      fallback = {
          x = 47.71, y = 69.77,
          radius = 10,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Breaching the Mist", questIDs = {86659}, x = 36.76, y = 34.97 },
      { kind = "OBJECTIVE", questName = "Breaching the Mist", radius = 5, objectiveIndex=1, questIDs = {86659}, x = 35.46, y = 36.11, text = "Click on the shrine {progress}." },
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Breaching the Mist", radius = 8, showAfter = 2, objectiveIndex=2, questIDs = {86659}, x = 35.46, y = 36.11, text = "Click on the shrines {progress}." },
      { kind = "OBJECTIVE", questName = "Breaching the Mist", radius = 8, showAfter = 4, objectiveIndex=3, questIDs = {86659}, x = 32.83, y = 32.63, text = "Click the final shrine {progress}." },
      { kind = "TURNIN", questName = "Breaching the Mist", questIDs = {86659}, x = 32.40, y = 31.61},
      { kind = "NOTE", text = "I'd highly recommend completing the bonus objective to kill 12 Vilebranch trolls, it's very efficient. The nearby rare mob is also worthwhile. Currently the addon does not track this, it will be changed in an update very soon." },
    },
  },
  {
    title = "Meet Halazzi",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Halazzi's Guile", questIDs = {92084}, x = 32.40, y = 31.61 },
      { kind = "OBJECTIVE", questName = "Halazzi's Guile", objectiveIndex=1, questIDs = {92084}, x = 32.25, y = 31.56, text = "Speak to the NPC {progress}." },
      { kind = "TURNIN", questName = "Halazzi's Guile", questIDs = {92084}, x = 32.40, y = 31.61},
    },
  },
  {
    title = "Seeking Jan'alai",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Coals of a Dead Loa", questIDs = {86661}, x = 32.40, y = 31.61 },
      { kind = "OBJECTIVE", questName = "Coals of a Dead Loa", objectiveIndex=1, questIDs = {86661}, x = 38.57, y = 22.40, text = "Speak to Vun'zarah {progress}." },
      { kind = "TURNIN", questName = "Coals of a Dead Loa", questIDs = {86661}, x = 38.53, y = 22.46},
    },
  },
  {
    title = "To The Temple of Jan'alai",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "The Riddled Speaker", questIDs = {86808}, x = 38.53, y = 22.46 },
      { kind = "OBJECTIVE", questName = "The Riddled Speaker", objectiveIndex=1, radius = 10, questIDs = {86808}, x = 55.00, y = 18.33, text = "Follow the arrow {progress}." },
      { kind = "TURNIN", questName = "The Riddled Speaker", questIDs = {86808}, x = 55.00, y = 18.33},
    },
  },
  {
    title = "Embers to a Flame",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Embers to a Flame", questIDs = {86663}, x = 55.00, y = 18.33},
      { kind = "OBJECTIVE", questName = "Embers to a Flame", objectiveIndex=2, questIDs = {86663}, x = 55.09, y = 18.24, text = "Take the coal {progress}." },
      { kind = "OBJECTIVE", questName = "Embers to a Flame", objectiveIndex=3, radius = 150, showAfter = 2, questIDs = {86663}, x = 54.00, y = 22.15, text = "Kill mobs to fill the bar {progress}." },
      { kind = "OBJECTIVE", questName = "Embers to a Flame", objectiveIndex=4, showAfter = 3, questIDs = {86663}, x = 55.09, y = 18.24, text = "Place the coal {progress}." },
      { kind = "TURNIN", questName = "Embers to a Flame", questIDs = {86663}, x = 55.00, y = 18.33},
      { kind = "NOTE", text = "Bar isn't shown in the quest log, look for an orange fiery bar somewhere in your UI." },
    },
  },
  {
    title = "Seer or Sear",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Seer or Sear", questIDs = {86664}, x = 55.00, y = 18.33},
      { kind = "OBJECTIVE", questName = "Seer or Sear", objectiveIndex=1, radius = 8, questIDs = {86664}, x = 54.90, y = 21.55, text = "Light the shrine and beat Zul'jin {progress}." },
      { kind = "OBJECTIVE", questName = "Seer or Sear", objectiveIndex=2, radius = 8, showAfter = 2, questIDs = {86664}, x = 52.92, y = 18.56, text = "Light the shrine and beat Zul'jan {progress}." },
      { kind = "OBJECTIVE", questName = "Seer or Sear", objectiveIndex=3, showAfter = 3, questIDs = {86664}, x = 55.11, y = 18.20, text = "Place the flame {progress}." },
      { kind = "TURNIN", questName = "Seer or Sear", questIDs = {86664}, x = 55.00, y = 18.33},
    },
  },
  {
    title = "Face in the Fire",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Face in the Fire", questIDs = {86665}, x = 55.00, y = 18.33},
      { kind = "OBJECTIVE", questName = "Face in the Fire", objectiveIndex=1, questIDs = {86665}, x = 55.11, y = 18.20, text = "Touch the coal {progress}." },
      { kind = "OBJECTIVE", questName = "Face in the Fire", objectiveIndex=2, radius = 12, showAfter = 2, questIDs = {86665}, x = 55.11, y = 18.20, text = "Defeat Zul'jarra's Manifestation {progress}." },
      { kind = "TURNIN", questName = "Face in the Fire", questIDs = {86665}, x = 55.00, y = 18.33},
    },
  },
  {
    title = "Meet Jan'alai",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "The Flames Rise Higher", questIDs = {90772}, x = 55.00, y = 18.33},
      { kind = "OBJECTIVE", questName = "The Flames Rise Higher", objectiveIndex=1, questIDs = {90772}, x = 55.11, y = 18.32, text = "Speak with Brek {progress}." },
      { kind = "TURNIN", questName = "The Flames Rise Higher", questIDs = {90772}, x = 55.00, y = 18.33},
    },
  },
  {
    title = "Return to Amani'Zar Village",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "In the Shadow of Rebirth", questIDs = {86666}, x = 55.00, y = 18.33},
      { kind = "OBJECTIVE", questName = "In the Shadow of Rebirth", questIDs = {86666}, x = 43.84, y = 68.28, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "In the Shadow of Rebirth", questIDs = {86666}, x = 43.84, y = 68.28},
      { kind = "NOTE", text = "If you set your Hearthstone to Amani'Zar Village earlier, now is the time to use it." },
    },
  },
  {
    title = "A Taste of Vengeance",
    mapID = {2437},
    arrow = { mode = "SEQUENCE_CHAIN", radius = 8, key = "mixture:86681", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 43.58, y = 68.23, gate = { questID = {86681}, objectiveIndex = 2, atLeast = 1 } },
            { advance = "PROXIMITY", x = 43.66, y = 68.55, gate = { questID = {86681}, objectiveIndex = 2, atLeast = 2 } },
            { advance = "PROXIMITY", x = 43.86, y = 68.66, gate = { questID = {86681}, objectiveIndex = 2, atLeast = 3 } },
        },
      fallback = {
          x = 47.71, y = 69.77,
          radius = 10,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Den of Nalorakk: A Taste of Vengeance", questIDs = {86681}, x = 43.84, y = 68.28},
      { kind = "OBJECTIVE", questName = "Den of Nalorakk: A Taste of Vengeance", objectiveIndex=1, questIDs = {86681}, x = 43.57, y = 68.38, text = "Grind the herbs {progress}." },
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Den of Nalorakk: A Taste of Vengeance", objectiveIndex=2, showAfter = 2, questIDs = {86681}, x = 43.57, y = 68.38, text = "Pour the mixture {progress}." },
      { kind = "TURNIN", questName = "Den of Nalorakk: A Taste of Vengeance", questIDs = {86681}, x = 43.84, y = 68.28},
    },
  },
  {
    title = "Waking de Bear",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Den of Nalorakk: Waking de Bear", questIDs = {86682}, x = 43.84, y = 68.28},
      { kind = "OBJECTIVE", questName = "Den of Nalorakk: Waking de Bear", objectiveIndex=1, questIDs = {86682}, x = 33.59, y = 78.82, text = "Speak with Lilaju {progress}." },
      { kind = "TURNIN", questName = "Den of Nalorakk: Waking de Bear", questIDs = {86682}, x = 33.60, y = 78.77},
    },
  },
  {
    title = "Den of Nalorakk",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Den of Nalorakk: Unforgiven", mapID = 2437, questIDs = {91958}, x = 33.60, y = 78.77},
      { kind = "OBJECTIVE", questName = "Den of Nalorakk: Unforgiven", mapID = 2437, objectiveIndex=3, questIDs = {91958}, x = 33.60, y = 78.77, text = "Complete the Den of Nalorakk Dungeon {progress}." },
      { kind = "OBJECTIVE", questName = "Den of Nalorakk: Unforgiven", mapID = 2437, objectiveIndex=4, showAfter = 2, questIDs = {91958}, x = 31.57, y = 83.87, text = "Exit the dungeon and speak with Zul'jarra {progress}." },
      { kind = "TURNIN", questName = "Den of Nalorakk: Unforgiven", mapID = 2437, questIDs = {91958}, x = 31.57, y = 83.87},
      { kind = "NOTE", text = "Currently dungeon sub-objectives (boss kills, stuff you need to click on, directions, etc) are not supported by the arrow." },
      { kind = "NOTE", text = "The game tells you to do Follower Dungeons, but they are REALLY, REALLLLLLY awful right now. If you have tank or healer queues, I'd highly recommend running the dungeon on Normal, you still get full credit for the quest." },
    },
  },
  {
    title = "Hash'ey Away",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Hash'ey Away", questIDs = {86683}, x = 31.57, y = 83.87},
      { kind = "OBJECTIVE", questName = "Hash'ey Away", objectiveIndex=1, radius = 10, questIDs = {86683}, x = 43.80, y = 68.67, text = "Return to Amani'Zar Village {progress}." },
      { kind = "OBJECTIVE", questName = "Hash'ey Away", objectiveIndex=2, showAfter = 2, questIDs = {86683}, x = 43.80, y = 68.67, text = "Speak with Zul'jarra {progress}." },
      { kind = "TURNIN", questName = "Hash'ey Away", questIDs = {86683}, x = 43.48, y = 68.82},
      { kind = "NOTE", text = "If your Hearthstone is back up, you can use it to return to Amani'Zar Village a tiny bit faster." },
    },
  },
  {
    title = "To Broken Throne",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "The Blade's Edge", questIDs = {86684}, x = 43.48, y = 68.82},
      { kind = "OBJECTIVE", questName = "The Blade's Edge", objectiveIndex=1, radius = 15, questIDs = {86684}, x = 28.47, y = 77.37, text = "Follow the arrow {progress}." },
      { kind = "TURNIN", questName = "The Blade's Edge", questIDs = {86684}, x = 28.35, y = 77.38},
    },
  },
  {
    title = "Breaking Broken Throne",
    mapID = {2437},
    arrow = { mode = "SEQUENCE_CHAIN", radius = 8, key = "broken:throne", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 26.21, y = 71.98, gate = { questID = {86687}, objectiveIndex = 1, atLeast = 1 } },
            { advance = "PROXIMITY", x = 25.19, y = 70.00, gate = { questID = {86687}, objectiveIndex = 1, atLeast = 2 } },
            { advance = "PROXIMITY", x = 23.94, y = 71.43, gate = { questID = {86687}, objectiveIndex = 1, atLeast = 3 } },
            { advance = "PROXIMITY", x = 24.74, y = 74.51, gate = { questID = {86687}, objectiveIndex = 2, atLeast = 1 } },
            { advance = "PROXIMITY", x = 23.76, y = 74.33, gate = { questID = {86687}, objectiveIndex = 2, atLeast = 2 } },
            { advance = "PROXIMITY", x = 23.21, y = 75.40, gate = { questID = {86687}, objectiveIndex = 2, atLeast = 3 } },
            { advance = "PROXIMITY", x = 23.13, y = 79.87, gate = { questID = {86687}, objectiveIndex = 3, atLeast = 1 } },
            { advance = "PROXIMITY", x = 24.11, y = 79.78, gate = { questID = {86687}, objectiveIndex = 3, atLeast = 2 } },
            { advance = "PROXIMITY", x = 24.35, y = 80.53, gate = { questID = {86687}, objectiveIndex = 3, atLeast = 3 } },
            { advance = "PROXIMITY", x = 26.89, y = 81.64, gate = { questID = {86687}, objectiveIndex = 4, atLeast = 1 } },
            { advance = "PROXIMITY", x = 27.65, y = 81.75, gate = { questID = {86687}, objectiveIndex = 4, atLeast = 2 } },
            { advance = "PROXIMITY", x = 27.29, y = 80.87, gate = { questID = {86687}, objectiveIndex = 4, atLeast = 3 } },
        },
      fallback = {
          x = 47.71, y = 69.77,
          radius = 10,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Conduit Crisis", questIDs = {86687}, x = 28.35, y = 77.38},
      { kind = "PICKUP", questName = "Chip and Shatter", questIDs = {86685}, x = 28.35, y = 77.38},
      { kind = "PICKUP", questName = "Light Indiscriminate", questIDs = {86686}, x = 28.40, y = 77.41},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Conduit Crisis", radius = 150, objectiveIndex=1, questIDs = {86687}, x = 34.68, y = 78.97, text = "Destroy Jan'alai Conduits {progress}." },
      { kind = "OBJECTIVE", questName = "Conduit Crisis", radius = 150, objectiveIndex=2, questIDs = {86687}, x = 34.54, y = 71.18, text = "Destroy Halazzi Conduits {progress}." },
      { kind = "OBJECTIVE", questName = "Conduit Crisis", radius = 150, objectiveIndex=3, questIDs = {86687}, x = 34.54, y = 71.18, text = "Destroy Akil'zon Conduits {progress}." },
      { kind = "OBJECTIVE", questName = "Conduit Crisis", radius = 150, objectiveIndex=4, questIDs = {86687}, x = 34.54, y = 71.18, text = "Destroy Nalorakk Conduits {progress}." },
      { kind = "OBJECTIVE", questName = "Light Indiscriminate", radius = 200, objectiveIndex=1, questIDs = {86686}, x = 26.33, y = 77.71, text = "Heal injured warriors {progress}." },
      { kind = "OBJECTIVE", questName = "Chip and Shatter", radius = 400, objectiveIndex=1, questIDs = {86685}, x = 25.28, y = 77.38, text = "Kill enemies to fill the bar {progress}." },
      { kind = "TURNIN", questName = "Conduit Crisis", questIDs = {86687}, x = 25.70, y = 77.62},
      { kind = "TURNIN", questName = "Chip and Shatter", questIDs = {86685}, x = 25.70, y = 77.62},
      { kind = "TURNIN", questName = "Light Indiscriminate", questIDs = {86686}, x = 25.70, y = 77.66},
      { kind = "NOTE", text = "Arrow goes on a path through every conduit, then points to Injured Warriors. Kill mobs to fill the bar as you destroy conduits." },
    },
  },
  {
    title = "Clear de Way",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Clear de Way", questIDs = {91001}, x = 25.70, y = 77.62},
      { kind = "OBJECTIVE", questName = "Clear de Way", objectiveIndex=1, radius = 15, questIDs = {91001}, x = 22.54, y = 77.38, text = "Follow the arrow {progress}." },
      { kind = "TURNIN", questName = "Clear de Way", questIDs = {91001}, x = 22.54, y = 77.38},
    },
  },
  {
    title = "Blade Shattered",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Blade Shattered", questIDs = {86692}, x = 22.54, y = 77.38},
      { kind = "OBJECTIVE", questName = "Blade Shattered", objectiveIndex=1, questIDs = {86692}, x = 22.54, y = 77.38, text = "Speak with Zul'jarra {progress}." },
      { kind = "OBJECTIVE", questName = "Blade Shattered", objectiveIndex=2, showAfter = 2, questIDs = {86692}, x = 21.36, y = 77.37, text = "Kill Mor'duun {progress}." },
      { kind = "TURNIN", questName = "Blade Shattered", questIDs = {86692}, x = 21.44, y = 77.37},
    },
  },
  {
    title = "De Legend of de Hash'ey",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "De Legend of de Hash'ey", questIDs = {86693}, x = 21.44, y = 77.37},
      { kind = "OBJECTIVE", questName = "De Legend of de Hash'ey", objectiveIndex=1, questIDs = {86693}, x = 45.27, y = 66.19, text = "Speak with Zul'jarra at Amani'Zar Village {progress}." },
      { kind = "TURNIN", questName = "De Legend of de Hash'ey", questIDs = {86693}, x = 45.75, y = 65.50},
      { kind = "NOTE", text = "Once again a good spot to use Hearthstone, if it's off cooldown." },
    },
  },
  {
    title = "Broken Bridges",
    mapID = {2437},
    segments = {
      { kind = "PICKUP", questName = "Broken Bridges", questIDs = {91062}, x = 45.75, y = 65.50},
      { kind = "OBJECTIVE", questName = "Broken Bridges", objectiveIndex=1, questIDs = {91062}, x = 51.26, y = 54.37, text = "Speak with Zul'jan {progress}." },
      { kind = "TURNIN", questName = "Broken Bridges", questIDs = {91062}, x = 50.76, y = 54.47},
      { kind = "NOTE", text = "Return to Silvermoon after finishing this quest. If you've already done the Arator questline, you can use the Arcantina Key toy to save a few minutes." },
    },
  },
  {
    title = "Return to Silvermoon",
    segments = {
      { kind = "PICKUP", questName = "Reports Returned", mapID = 2437, questIDs = {91087}, x = 50.76, y = 54.47},
      { kind = "OBJECTIVE", questName = "Reports Returned", questIDs = {91087}, points = { [2437] = { x = 06.00, y = 00.01 },  [2395] = { x = 50.50, y = 27.25 }, [2393] = { x = 45.44, y = 70.33 },}, text = "Turn in {progress}." },
      { kind = "TURNIN", questName = "Reports Returned", questIDs = {91087}, points = { [2437] = { x = 06.00, y = 00.01 },  [2395] = { x = 50.50, y = 27.25 }, [2393] = { x = 45.44, y = 70.33 },} },
      { kind = "NOTE", text = "If you've already done the Arator questline, you can use the Arcantina Key toy to save a few minutes. Otherwise, you can use a Dalaran Hearthstone and portal hop to save a little time over flying." },
    },
  },
  {
    title = "Choose Your Next Adventure",
    segments = {
      { kind = "OBJECTIVE", mapID = 2393, x = 45.44, y = 70.34, text = "You've completed Zul'Aman! You can now select your next zone. Completing all three zones will unlock the final section of the campaign, Voidstorm."},
      { kind = "OBJECTIVE", text = "Interact with the nearby Scouting Map and pick the zone of your choice. Then click one of the addon buttons below to load that zone's guide. If you change your mind, you can always switch zone guides with the dropdown menu."},
      { kind = "MODULE_CHOICE_ROW",
      choices = {
        { moduleID = "MIDNIGHT_ARATORS_JOURNEY", label = "Arator's Journey", thumbnail = "Interface\\AddOns\\FollowTheArrow\\Images\\AratorThumb.tga", finalQuestID = 91787 },
        { moduleID = "MIDNIGHT_HARANDAR", label = "Harandar", thumbnail = "Interface\\AddOns\\FollowTheArrow\\Images\\HarandarThumb.tga", finalQuestID = 86898 },
        { moduleID = "MIDNIGHT_ZULAMAN", label = "Zul'Aman", thumbnail = "Interface\\AddOns\\FollowTheArrow\\Images\\ZulamanThumb.tga", finalQuestID = 91062 },
      },final = {
        moduleID="MIDNIGHT_VOIDSTORM",
        label="Voidstorm",
        thumbnail="Interface\\AddOns\\FollowTheArrow\\Images\\VoidstormThumb.tga",
      },
      thumbH = 90,
      gap = 10,

      singleWidthPct = 0.80,
      singleMinW = 90,
      singleMaxW = 160,
    },
    },
  },
}

FTA.Modules[M.id] = M