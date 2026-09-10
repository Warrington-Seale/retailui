local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "MIDNIGHT_ARATORS_JOURNEY"
M.title = "Arator's Journey"
M.defaultRadius = 5

M.routeId    = "MIDNIGHT_CAMPAIGN"
M.routeTitle = "Midnight Campaign"
M.routeOrder = 11

M.moduleOrder = 30
M.nextModuleId = "TBD" 

M.steps = {
    {
    mapID = {2393},
    title = "Arator",
    segments = {
      { kind = "PICKUP", questName = "Arator", questIDs = {89193}, x = 45.44, y = 70.33},
      { kind = "OBJECTIVE", questName = "Arator", questIDs = {89193}, x = 45.78, y = 65.79 , text = "Turn in {progress}." },
      { kind = "TURNIN", questName = "Arator", questIDs = {89193}, x = 45.78, y = 65.79},
      { kind = "NOTE", text = "If you get the quest Deepening Shadows from Commander Koruth Mountainfist, ignore it. This will be covered later in the Voidstorm module." },
    },
  },
  {
    mapID = {2424},
    title = "Meet at the Sunwell",
    segments = {
      { kind = "PICKUP", questName = "Meet at the Sunwell", mapID = 2393, questIDs = {86837}, x = 45.78, y = 65.79},
      { kind = "OBJECTIVE", questName = "Meet at the Sunwell", mapID = 2393, objectiveIndex=1, questIDs = {86837}, x = 45.30, y = 60.41, text = "Speak with Arator {progress}." },
      { kind = "TURNIN", questName = "Meet at the Sunwell", mapID = 2424, questIDs = {86837}, x = 52.89, y = 55.17 },
    },
  },
  {
    mapID = {2424},
    title = "Renewal for the Weary",
    arrow = { mode = "SEQUENCE_CHAIN", radius = 15, key = "renewal:86838", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 52.06, y = 45.62, gate = { questID = {86838}, objectiveIndex = 1, atLeast = 1 } },
            { advance = "PROXIMITY", x = 51.68, y = 45.17, gate = { questID = {86838}, objectiveIndex = 1, atLeast = 2 } },
            { advance = "PROXIMITY", x = 51.70, y = 44.43, gate = { questID = {86838}, objectiveIndex = 1, atLeast = 3 } },
            { advance = "PROXIMITY", x = 51.85, y = 43.72, gate = { questID = {86838}, objectiveIndex = 1, atLeast = 4 } },
            { advance = "PROXIMITY", x = 52.25, y = 43.24, gate = { questID = {86838}, objectiveIndex = 1, atLeast = 5 } },
            { advance = "PROXIMITY", x = 52.90, y = 43.16, gate = { questID = {86838}, objectiveIndex = 1, atLeast = 6 } },
            { advance = "PROXIMITY", x = 53.40, y = 43.87, gate = { questID = {86838}, objectiveIndex = 1, atLeast = 7 } },
            { advance = "PROXIMITY", x = 53.51, y = 44.54, gate = { questID = {86838}, objectiveIndex = 1, atLeast = 8 } },
            { advance = "PROXIMITY", x = 53.46, y = 45.31, gate = { questID = {86838}, objectiveIndex = 1, atLeast = 9 } },
            { advance = "PROXIMITY", x = 52.94, y = 45.80, gate = { questID = {86838}, objectiveIndex = 1, atLeast = 10 } },
        },
      fallback = {
          x = 52.89, y = 55.17,
          radius = 10,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Renewal for the Weary", questIDs = {86838}, x = 52.89, y = 55.17},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Renewal for the Weary", objectiveIndex=1, questIDs = {86838}, x = 52.89, y = 55.17, text = "Renew the Channelers {progress}." },
      { kind = "TURNIN", questName = "Renewal for the Weary", questIDs = {86838}, x = 52.89, y = 55.17 },
      { kind = "NOTE", text = "Use the quest item to empower the channelers. Arrow takes you on a fixed path through all 10, but you can do other orders. You can move while channeling, but the arrow won't update if you run too far." },
    },
  },
  {
    mapID = {2424},
    title = "To Light's Hope Chapel",
    segments = {
      { kind = "PICKUP", questName = "Relics of Light's Hope", mapID = 2424, questIDs = {86839}, x = 52.89, y = 55.17},
      { kind = "OBJECTIVE", questName = "Relics of Light's Hope", mapID = 2424, objectiveIndex=2, questIDs = {86839}, x = 52.89, y = 55.17, text = "Speak with Alonsus Faol {progress}." },
      { kind = "TURNIN", questName = "Relics of Light's Hope", mapID = 23, questIDs = {86839}, x = 73.91, y = 53.56 },
      { kind = "NOTE", text = "If you watched my prep video and have Gidwin's Hearthstone, now is the time to use it. Otherwise you need to fly." },
    },
  },
  {
    mapID = {23},
    title = "Flickering Hope",
    segments = {
      { kind = "PICKUP", questName = "Flickering Hope", questIDs = {86840}, x = 73.91, y = 53.56},
      { kind = "OBJECTIVE", questName = "Flickering Hope", objectiveIndex=1, radius = 100, questIDs = {86840}, x = 72.92, y = 53.98, text = "Kill scourge to fill the bar {progress}." },
      { kind = "TURNIN", questName = "Flickering Hope", questIDs = {86840}, x = 73.91, y = 53.56 },
    },
  },
  {
    mapID = {23},
    title = "Collecting Relics",
    segments = {
      { kind = "PICKUP", questName = "Relics of Paladins Past", mapID = 23, questIDs = {86841}, x = 73.91, y = 53.56},
      { kind = "OBJECTIVE", questName = "Relics of Paladins Past", objectiveIndex=1, mapID = 24, radius = 10, questIDs = {86841}, x = 41.82, y = 89.73, text = "Follow the arrow {progress}." },
      { kind = "OBJECTIVE", questName = "Relics of Paladins Past", objectiveIndex=3, showAfter = 2, mapID = 24, radius = 8, questIDs = {86841}, x = 70.34, y = 42.44, text = "Collect Maraad's Crystal {progress}." },
      { kind = "OBJECTIVE", questName = "Relics of Paladins Past", objectiveIndex=5, showAfter = 2, mapID = 24, radius = 8, questIDs = {86841}, x = 76.44, y = 32.64, text = "Collect Krohm's Hammer {progress}." },
      { kind = "OBJECTIVE", questName = "Relics of Paladins Past", objectiveIndex=6, showAfter = 2, mapID = 24, radius = 8, questIDs = {86841}, x = 79.15, y = 23.76, text = "Collect Mara's Prayer Book {progress}." },
      { kind = "OBJECTIVE", questName = "Relics of Paladins Past", objectiveIndex=4, showAfter = 2, mapID = 24, radius = 8, questIDs = {86841}, x = 72.28, y = 13.73, text = "Collect Uther's Healing Kit {progress}." },
      { kind = "OBJECTIVE", questName = "Relics of Paladins Past", objectiveIndex=2, showAfter = 2, mapID = 24, radius = 8, questIDs = {86841}, x = 60.21, y = 27.49, text = "Collect Lena's Stein {progress}." },
      { kind = "TURNIN", questName = "Relics of Paladins Past", mapID = 23, questIDs = {86841}, x = 73.91, y = 53.56 },
    },
  },
  {
    mapID = {23},
    title = "To Scarlet Monastery",
    segments = {
      { kind = "PICKUP", questName = "Scarlet Power", mapID = 23, questIDs = {86842}, x = 73.80, y = 53.52},
      { kind = "OBJECTIVE", questName = "Scarlet Power", objectiveIndex=2, mapID = 18, radius = 15, questIDs = {86842}, x = 82.23, y = 32.71, text = "Follow the arrow to Scarlet Monastery {progress}." },
      { kind = "OBJECTIVE", questName = "Scarlet Power", objectiveIndex=3, showAfter = 2, mapID = 19, radius = 10, questIDs = {86842}, x = 79.56, y = 54.32, text = "Follow the arrow {progress}." },
      { kind = "OBJECTIVE", questName = "Scarlet Power", objectiveIndex=4, showAfter = 3, mapID = 19, questIDs = {86842}, x = 78.39, y = 58.56, text = "Enter Scarlet Halls {progress}." },
      { kind = "TURNIN", questName = "Scarlet Power", mapID = 2438, questIDs = {86842}, x = 47.01, y = 89.87 },
      { kind = "NOTE", text = "If you don't have an old Challenge Mode teleport from MoP, you'll need to fly there." },
    },
  },
  {
    mapID = {2438},
    title = "Light Miswielded",
    segments = {
      { kind = "PICKUP", questName = "Light Repurposed", questIDs = {86844}, x = 47.33, y = 90.77},
      { kind = "PICKUP", questName = "Light Miswielded", questIDs = {86843}, x = 47.33, y = 90.77},
      { kind = "OBJECTIVE", questName = "Light Repurposed", objectiveIndex=1, radius = 25, questIDs = {86844}, x = 56.07, y = 79.68, text = "Kill and loot Instructor Meyer {progress}." },
      { kind = "OBJECTIVE", questName = "Light Repurposed", objectiveIndex=2, radius = 20, questIDs = {86844}, x = 61.71, y = 45.29, text = "Defeat Champion Aelyse {progress}." },
      { kind = "OBJECTIVE", questName = "Light Repurposed", objectiveIndex=3, radius = 20, questIDs = {86844}, x = 39.19, y = 15.51, text = "Kill and loot Abbot Benthar {progress}." },
      { kind = "OBJECTIVE", questName = "Light Miswielded", objectiveIndex=1, radius = 300, questIDs = {86843}, x = 49.50, y = 57.00, text = "Kill enemies to fill the bar {progress}." },
      { kind = "TURNIN", questName = "Light Repurposed", questIDs = {86844}, x = 41.32, y = 28.85},
      { kind = "TURNIN", questName = "Light Miswielded", questIDs = {86843}, x = 41.32, y = 28.85},
      { kind = "NOTE", text = "Aelyse has some unskippable roleplay before you get credit for her weapon. You can run away from her and still receive credit." },
    },
  },
  {
    mapID = {2438},
    title = "Infusion of Hope",
    segments = {
      { kind = "PICKUP", questName = "Infusion of Hope", mapID = 2438, questIDs = {92136}, x = 41.32, y = 28.85},
      { kind = "OBJECTIVE", questName = "Infusion of Hope", mapID = 2438, objectiveIndex=1, questIDs = {92136}, x = 41.32, y = 28.85, text = "Speak with Alonsus Faol {progress}." },
      { kind = "OBJECTIVE", questName = "Infusion of Hope", mapID = 2438, objectiveIndex=2, showAfter = 2, questIDs = {92136}, x = 41.32, y = 28.85, text = "Take the portal {progress}." },
      { kind = "TURNIN", questName = "Infusion of Hope", mapID = 2424, questIDs = {92136}, x = 52.56, y = 55.87},
    },
  },
  {
    mapID = {2424},
    title = "Relinquishing Relics",
    segments = {
      { kind = "PICKUP", questName = "Relinquishing Relics", questIDs = {86902}, x = 52.56, y = 55.87},
      { kind = "OBJECTIVE", questName = "Relinquishing Relics", objectiveIndex=3, questIDs = {86902}, x = 53.46, y = 45.32, text = "Speak with Valunei {progress}." },
      { kind = "OBJECTIVE", questName = "Relinquishing Relics", objectiveIndex=2, questIDs = {86902}, x = 52.95, y = 45.80, text = "Speak with Taelia {progress}." },
      { kind = "OBJECTIVE", questName = "Relinquishing Relics", objectiveIndex=4, questIDs = {86902}, x = 52.07, y = 45.62, text = "Speak with Salandria {progress}." },
      { kind = "OBJECTIVE", questName = "Relinquishing Relics", objectiveIndex=5, questIDs = {86902}, x = 51.70, y = 44.96, text = "Speak with Mehlar {progress}." },
      { kind = "OBJECTIVE", questName = "Relinquishing Relics", objectiveIndex=6, showAfter = 5, questIDs = {86902}, x = 52.47, y = 45.87, text = "Speak with Velen {progress}." },
      { kind = "TURNIN", questName = "Relinquishing Relics", questIDs = {86902}, x = 52.56, y = 55.87},
    },
  },
  {
    mapID = {2424},
    title = "To Arathi Highlands",
    segments = {
      { kind = "PICKUP", questName = "The Sunwalker Path", mapID = 2424, questIDs = {86845}, x = 52.56, y = 55.87},
      { kind = "OBJECTIVE", questName = "The Sunwalker Path", mapID = 2424, objectiveIndex=1, questIDs = {86845}, x = 52.56, y = 55.87, text = "Speak with Alonsus Faol {progress}." },
      { kind = "OBJECTIVE", questName = "The Sunwalker Path", mapID = 2424, objectiveIndex=2, showAfter = 2, questIDs = {86845}, x = 52.56, y = 55.87, text = "Take the portal {progress}." },
      { kind = "TURNIN", questName = "The Sunwalker Path", mapID = 2372, questIDs = {86845}, x = 68.93, y = 37.68},
    },
  },
  {
    mapID = {2372},
    title = "A Humble Servant",
    segments = {
      { kind = "PICKUP", questName = "Resupplying Our Suppliers", questIDs = {86846}, x = 68.93, y = 37.69},
      { kind = "PICKUP", questName = "A Humble Servant", questIDs = {91000}, x = 68.93, y = 37.69},
      { kind = "OBJECTIVE", questName = "Resupplying Our Suppliers", objectiveIndex=3, radius = 10, questIDs = {86846}, x = 70.05, y = 35.61, text = "Deliver to Tunkk {progress}." },
      { kind = "OBJECTIVE", questName = "Resupplying Our Suppliers", objectiveIndex=2, radius = 10, questIDs = {86846}, x = 69.16, y = 34.83, text = "Deliver to Slagg {progress}." },
      { kind = "OBJECTIVE", questName = "Resupplying Our Suppliers", objectiveIndex=1, radius = 10, questIDs = {86846}, x = 68.07, y = 37.72, text = "Deliver to Jun'ha {progress}." },
      { kind = "OBJECTIVE", questName = "Resupplying Our Suppliers", objectiveIndex=5, radius = 10, questIDs = {86846}, x = 69.26, y = 33.41, text = "Deliver to Keena {progress}." },
      { kind = "OBJECTIVE", questName = "Resupplying Our Suppliers", objectiveIndex=4, radius = 10, questIDs = {86846}, x = 68.35, y = 31.88, text = "Deliver to Mu'uta {progress}." },
      { kind = "OBJECTIVE", questName = "A Humble Servant", objectiveIndex=1, radius = 100, questIDs = {91000}, x = 68.64, y = 35.05, text = "Clean the town to fill the bar {progress}." },
      { kind = "TURNIN", questName = "Resupplying Our Suppliers", questIDs = {86846}, x = 68.53, y = 32.20},
      { kind = "TURNIN", questName = "A Humble Servant", questIDs = {91000}, x = 68.53, y = 32.20},
      { kind = "NOTE", text = "Focus on rubble and peons for %. Trash piles are less efficient." },
    },
  },
  {
    mapID = {2372},
    title = "Gathering Plowshares",
    segments = {
      { kind = "PICKUP", questName = "Gathering Plowshares", questIDs = {89338}, x = 68.53, y = 32.20},
      { kind = "OBJECTIVE", questName = "Gathering Plowshares", objectiveIndex=2, radius = 250, questIDs = {89338}, x = 67.07, y = 44.13, text = "Collect longswords {progress}." },
      { kind = "OBJECTIVE", questName = "Gathering Plowshares", objectiveIndex=3, radius = 250, questIDs = {89338}, x = 67.07, y = 44.13, text = "Collect axes {progress}." },
      { kind = "TURNIN", questName = "Gathering Plowshares", questIDs = {89338}, x = 68.53, y = 32.20},
      { kind = "NOTE", text = "There are tons of swords and axes, the arrow only points to the general area here." },
    },
  },
  {
    mapID = {2372},
    title = "To Burning Steppes",
    segments = {
      { kind = "PICKUP", questName = "One Final Relic", questIDs = {86822}, x = 68.65, y = 32.02},
      { kind = "OBJECTIVE", questName = "One Final Relic", objectiveIndex=1, questIDs = {86822}, x = 68.65, y = 32.02, text = "Speak with Alonsus Faol {progress}." },
      { kind = "OBJECTIVE", questName = "One Final Relic", mapID = 36, objectiveIndex=2, showAfter = 2, questIDs = {86822}, x = 33.40, y = 48.28, text = "Speak with Alonsus Faol and skip the conversation {progress}." },
      { kind = "TURNIN", questName = "One Final Relic", mapID = 36, questIDs = {86822}, x = 33.44, y = 48.61},
    },
  },
  {
    mapID = {36},
    title = "The Dark Horde",
    segments = {
      { kind = "PICKUP", questName = "Faithful Servant, Faithless Cause", questIDs = {86825}, x = 33.54, y = 48.62},
      { kind = "PICKUP", questName = "None Left Standing", questIDs = {86824}, x = 33.54, y = 48.62},
      { kind = "PICKUP", questName = "The Dark Horde", questIDs = {86823}, x = 33.54, y = 48.62},
      { kind = "OBJECTIVE", questName = "Faithful Servant, Faithless Cause", objectiveIndex=1, radius = 150, questIDs = {86825}, x = 38.13, y = 52.98, text = "Kill and loot Mar'kag {progress}." },
      { kind = "OBJECTIVE", questName = "Faithful Servant, Faithless Cause", objectiveIndex=2, showAfter = 4, radius = 200, questIDs = {86825}, x = 38.13, y = 52.98, text = "Kill and loot Mar'kag {progress}." },
      { kind = "OBJECTIVE", questName = "None Left Standing", objectiveIndex=1, radius = 200, questIDs = {86824}, x = 38.13, y = 52.98, text = "Burn banners {progress}." },
      { kind = "OBJECTIVE", questName = "The Dark Horde", objectiveIndex=1, radius = 200, questIDs = {86823}, x = 38.13, y = 52.98, text = "Kill Blackrock forces {progress}." },
      { kind = "TURNIN", questName = "Faithful Servant, Faithless Cause", questIDs = {86825}, x = 33.54, y = 48.62},
      { kind = "TURNIN", questName = "None Left Standing", questIDs = {86824}, x = 33.54, y = 48.62},
      { kind = "TURNIN", questName = "The Dark Horde", questIDs = {86823}, x = 33.54, y = 48.62},
      { kind = "NOTE", text = "Look for Mar'kag, the armored ogre, first, he has a huge patrol route that runs the entire length of the quest area. Burn banners as you go. The small orc huts have large clusters of Blackrock forces. Arrow only points to a generalized area." },
    },
  },
  {
    mapID = {36},
    title = "To Blackrock Mountain",
    segments = {
      { kind = "PICKUP", questName = "Still Scouting", questIDs = {91391}, x = 33.54, y = 48.62},
      { kind = "OBJECTIVE", questName = "Still Scouting", questIDs = {91391}, x = 21.13, y = 39.78, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "Still Scouting", questIDs = {91391}, x = 21.13, y = 39.78},
    },
  },
  {
    mapID = {36},
    title = "Blackrock Brawl",
    segments = {
      { kind = "PICKUP", questName = "Nagosh the Scarred", questIDs = {86826}, x = 21.13, y = 39.78},
      { kind = "PICKUP", questName = "Disarm the Dark Horde", questIDs = {91842}, x = 21.13, y = 39.78},
      { kind = "PICKUP", questName = "Due Recognition", questIDs = {86827}, x = 21.13, y = 39.78},
      { kind = "OBJECTIVE", questName = "Nagosh the Scarred", mapID = 33, objectiveIndex=1, radius = 60, questIDs = {86826}, x = 64.37, y = 52.78, text = "Kill and loot Nagosh the Scarred {progress}." },
      { kind = "OBJECTIVE", questName = "Nagosh the Scarred", mapID = 33, objectiveIndex=2, showAfter = 4, radius = 60, questIDs = {86826}, x = 64.37, y = 52.78, text = "Kill and loot Nagosh the Scarred {progress}." },
      { kind = "OBJECTIVE", questName = "Disarm the Dark Horde", mapID = 33, objectiveIndex=1, radius = 150, questIDs = {91842}, x = 50.35, y = 55.85, text = "Destroy weapon racks {progress}." },
      { kind = "OBJECTIVE", questName = "Due Recognition", mapID = 33, objectiveIndex=1, radius = 150, questIDs = {86827}, x = 50.35, y = 55.85, text = "Kill orcs to loot badges {progress}." },
      { kind = "TURNIN", questName = "Nagosh the Scarred", questIDs = {86826}, x = 21.13, y = 39.78},
      { kind = "TURNIN", questName = "Disarm the Dark Horde", questIDs = {91842}, x = 21.13, y = 39.78},
      { kind = "TURNIN", questName = "Due Recognition", questIDs = {86827}, x = 21.13, y = 39.78},
      { kind = "NOTE", text = "Find Nagosh first, he has a patrol route, but much smaller than last quest. Break racks and kill/loot orcs as you go. There's an extra action button that does some damage, but it's a bit clunky." },
    },
  },
  {
    mapID = {36},
    title = "Find Trollbane",
    segments = {
      { kind = "PICKUP", questName = "Not Just a Troll's Bane", questIDs = {86828}, x = 21.13, y = 39.78},
      { kind = "OBJECTIVE", questName = "Not Just a Troll's Bane", questIDs = {86828}, x = 31.57, y = 37.60, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "Not Just a Troll's Bane", questIDs = {86828}, x = 31.57, y = 37.60},
    },
  },
  {
    mapID = {36},
    title = "Warriors Without a Warlord",
    segments = {
      { kind = "PICKUP", questName = "Warriors Without a Warlord", questIDs = {86831}, x = 31.57, y = 37.60},
      { kind = "PICKUP", questName = "A True Horde of Dark Horde", questIDs = {86830}, x = 31.57, y = 37.60},
      { kind = "OBJECTIVE", questName = "Warriors Without a Warlord", objectiveIndex=1, radius = 20, questIDs = {86831}, x = 31.07, y = 34.01, text = "Kill and loot Warlord Grazla {progress}." },
      { kind = "OBJECTIVE", questName = "Warriors Without a Warlord", objectiveIndex=2, showAfter = 3, radius = 20, questIDs = {86831}, x = 31.07, y = 34.01, text = "Kill and loot Warlord Grazla {progress}." },
      { kind = "OBJECTIVE", questName = "A True Horde of Dark Horde", objectiveIndex=1, radius = 100, questIDs = {86830}, x = 34.81, y = 36.23, text = "Kill Dark Horde troops {progress}." },
      { kind = "OBJECTIVE", questName = "A True Horde of Dark Horde", objectiveIndex=2, radius = 100, questIDs = {86830}, x = 34.81, y = 36.23, text = "Kill Dark Horde Sergeants {progress}." },
      { kind = "TURNIN", questName = "Warriors Without a Warlord", questIDs = {86831}, x = 31.57, y = 37.60},
      { kind = "TURNIN", questName = "A True Horde of Dark Horde", questIDs = {86830}, x = 31.57, y = 37.60},
    },
  },
  {
    mapID = {36},
    title = "A Landmark Moment",
    segments = {
      { kind = "PICKUP", questName = "A Landmark Moment", questIDs = {86829}, x = 31.57, y = 37.60},
      { kind = "OBJECTIVE", questName = "A Landmark Moment", questIDs = {86829}, x = 36.83, y = 51.02, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "A Landmark Moment", questIDs = {86829}, x = 36.83, y = 51.02},
    },
  },
  {
    mapID = {36},
    title = "Unstoppable Force",
    segments = {
      { kind = "PICKUP", questName = "Unstoppable Force", questIDs = {91726}, x = 36.78, y = 51.08},
      { kind = "OBJECTIVE", questName = "Unstoppable Force", objectiveIndex=1, questIDs = {91726}, x = 36.78, y = 51.08, text = "Speak with Kurdran {progress}." },
      { kind = "OBJECTIVE", questName = "Unstoppable Force", objectiveIndex=2, showAfter = 2, questIDs = {91726}, x = 36.71, y = 51.08, text = "Speak with Arator {progress}." },
      { kind = "TURNIN", questName = "Unstoppable Force", questIDs = {91726}, x = 36.78, y = 51.08},
    },
  },
  {
    mapID = {36},
    title = "A Worthy Forge",
    segments = {
      { kind = "PICKUP", questName = "A Worthy Forge", questIDs = {86832}, x = 36.71, y = 51.08},
      { kind = "OBJECTIVE", questName = "A Worthy Forge", objectiveIndex=1, questIDs = {86832}, x = 36.75, y = 50.88, text = "Take the portal {progress}." },
      { kind = "TURNIN", questName = "A Worthy Forge", mapID = 2393, questIDs = {86832}, x = 45.77, y = 65.49},
    },
  },
  {
    mapID = {2393},
    title = "A Bulwark Remade",
    segments = {
      { kind = "PICKUP", questName = "A Bulwark Remade", questIDs = {86833}, x = 45.77, y = 65.49},
      { kind = "OBJECTIVE", questName = "A Bulwark Remade", objectiveIndex=1, questIDs = {86833}, x = 40.47, y = 65.97, text = "Speak with Arator {progress}." },
      { kind = "OBJECTIVE", questName = "A Bulwark Remade", objectiveIndex=2, showAfter = 2, questIDs = {86833}, x = 40.47, y = 65.97, text = "Reforge the shield {progress}." },
      { kind = "OBJECTIVE", questName = "A Bulwark Remade", objectiveIndex=3, showAfter = 3, questIDs = {86833}, x = 40.47, y = 65.97, text = "Speak with Arator and skip the conversation {progress}." },
      { kind = "TURNIN", questName = "A Bulwark Remade", questIDs = {86833}, x = 40.47, y = 65.97},
      { kind = "NOTE", text = "Order is always Dust -> Water -> Ingot -> Feather. Wait for Arator to give instructions in chat before clicking the corresponding object." },
    },
  },
  {
    mapID = {2393},
    title = "The Arcantina",
    segments = {
      { kind = "PICKUP", questName = "The Arcantina", questIDs = {86903}, x = 40.71, y = 66.07},
      { kind = "OBJECTIVE", questName = "The Arcantina", objectiveIndex=1, questIDs = {86903}, x = 40.71, y = 66.07, text = "Use the Arcantina Key {progress}." },
      { kind = "OBJECTIVE", questName = "The Arcantina", mapID = 2541, objectiveIndex=2, showAfter = 2, questIDs = {86903}, x = 60.87, y = 66.90, text = "Buy a round of drinks {progress}." },
      { kind = "OBJECTIVE", questName = "The Arcantina", mapID = 2541, objectiveIndex=3, showAfter = 3, questIDs = {86903}, x = 50.60, y = 59.00, text = "Serve drinks {progress}." },
      { kind = "OBJECTIVE", questName = "The Arcantina", mapID = 2541, objectiveIndex=4, showAfter = 4, questIDs = {86903}, x = 52.13, y = 60.60, text = "Speak with Arator and skip the conversation {progress}." },
      { kind = "TURNIN", questName = "The Arcantina", mapID = 2541, questIDs = {86903}, x = 52.13, y = 60.60},
      { kind = "NOTE", text = "This quest gives you an item called the Arcantina Key. In my speedruns, I start with Arator and continue until I reach this quest. I then fly over to the Scouting Map and begin the Harandar questline." },
      { kind = "NOTE", text = "After turning in the first Harandar breadcrumb, I return to the Scouting Map one final time and grab the Zul'Aman breadcrumb. After finishing Harandar, I fly to Zul'Aman and wait before turning in the final Harandar quest, which ends in Silvermoon." },
      { kind = "NOTE", text = "After finishing Zul'Aman, I leave the zone by using the Arcantina Key from this quest, which functions as a free portal to Silvermoon. This entire process saves roughly 2 minutes of travel time compared to doing the 3 zones in a random order." },
    },
  },
  {
    mapID = {2393},
    title = "The Journey Ends",
    segments = {
      { kind = "PICKUP", questName = "The Journey Ends", mapID = 2541, questIDs = {91787}, x = 52.13, y = 60.60},
      { kind = "OBJECTIVE", questName = "The Journey Ends", questIDs = {91787}, x = 45.44, y = 70.34, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "The Journey Ends", questIDs = {91787}, x = 45.44, y = 70.34},
      { kind = "NOTE", text = "Walk into the blue swirling portal in the doorway to return to Silvermoon." },
    },
  },
  {
    title = "Choose Your Next Adventure",
    segments = {
      { kind = "OBJECTIVE", mapID = 2393, x = 45.44, y = 70.34, text = "You've completed Arator's Journey! You can now select your next zone. Completing all three zones will unlock the final section of the campaign, Voidstorm."},
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