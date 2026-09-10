local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "VOIDSTORM_SOJOURNER"
M.title = "Voidstorm"
M.defaultRadius = 5

M.routeId    = "MIDNIGHT_SOJOURNER"
M.routeTitle = "Midnight Sojourner"
M.routeOrder = 20

M.moduleOrder = 50
M.nextModuleId = "TBD" 

M.steps = {
  {
    mapID = {2405},
    title = "The Nethersent Part 1",
    segments = {
      { kind = "PICKUP", questName = "The Nethersent", questIDs = {90782}, x = 56.21, y = 71.88},
      { kind = "OBJECTIVE", questName = "The Nethersent", radius = 5, objectiveIndex = 1, questIDs = {90782}, x = 56.21, y = 71.88, text = "Free Juras {progress}." },
      { kind = "TURNIN", questName = "The Nethersent", questIDs = {90782}, x = 39.87, y = 48.98},
    },
  },
  {
    mapID = {2405},
    title = "The Nethersent Part 2",
    segments = {
      { kind = "PICKUP", questName = "Universal Language", questIDs = {90866}, x = 39.87, y = 48.98},
      { kind = "OBJECTIVE", questName = "Universal Language", radius = 150, objectiveIndex = 1, questIDs = {90866}, x = 40.70, y = 41.00, text = "Kill and loot enemies {progress}." },
      { kind = "TURNIN", questName = "Universal Language", questIDs = {90866}, x = 39.37, y = 47.95},
    },
  },
  {
    mapID = {2405},
    title = "The Nethersent Part 3",
    segments = {
      { kind = "PICKUP", questName = "Drenched In It", questIDs = {90872}, x = 39.87, y = 48.98},
      { kind = "OBJECTIVE", questName = "Drenched In It", radius = 20, objectiveIndex = 1, questIDs = {90872}, x = 39.31, y = 47.99, text = "Splash offworlders with blood {progress}." },
      { kind = "OBJECTIVE", questName = "Drenched In It", radius = 6, objectiveIndex = 2, showAfter = 2, questIDs = {90872}, x = 39.36, y = 47.92, text = "Click on the portal {progress}." },
      { kind = "TURNIN", questName = "Drenched In It", questIDs = {90872}, mapID = 2444, x = 35.06, y = 88.55},
    },
  },
  {
    mapID = {2444},
    title = "The Nethersent Part 4",
    arrow = { mode = "SEQUENCE_CHAIN", radius = 8, key = "violent:delights", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 32.90, y = 87.59, gate = { questID = {90873}, objectiveIndex = 2, atLeast = 1 } },
            { advance = "PROXIMITY", x = 37.43, y = 90.45, gate = { questID = {90873}, objectiveIndex = 2, atLeast = 2 } },
            { advance = "PROXIMITY", x = 41.50, y = 90.69, gate = { questID = {90873}, objectiveIndex = 2, atLeast = 3 } },
          },
      fallback = {
          x = 47.71, y = 69.77,
          radius = 10,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "These Violent Delights", questIDs = {90873}, x = 35.06, y = 88.55},
      { kind = "PICKUP", questName = "Their Violent Ends", questIDs = {90874}, x = 35.06, y = 88.55},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "These Violent Delights", radius = 200, objectiveIndex = 1, questIDs = {90873}, x = 37.09, y = 86.72, text = "Free Master's Prospects {progress}." },
      { kind = "OBJECTIVE", questName = "These Violent Delights", radius = 200, objectiveIndex = 2, questIDs = {90873}, x = 37.09, y = 86.72, text = "Send Unwilling Summons home {progress}." },
      { kind = "OBJECTIVE", questName = "Their Violent Ends", radius = 200, objectiveIndex = 1, questIDs = {90874}, x = 37.09, y = 86.72, text = "Kill and loot enemies {progress}." },
      { kind = "TURNIN", questName = "These Violent Delights", questIDs = {90873}, x = 35.06, y = 88.55},
      { kind = "TURNIN", questName = "Their Violent Ends", questIDs = {90874}, x = 35.06, y = 88.55},
    },
  },
  {
    mapID = {2444},
    title = "The Nethersent Part 5",
    segments = {
      { kind = "PICKUP", questName = "Across Worlds", questIDs = {90875}, x = 35.06, y = 88.55},
      { kind = "OBJECTIVE", questName = "Across Worlds", radius = 5, objectiveIndex = 1, questIDs = {90875}, x = 33.09, y = 81.14, text = "Kill and loot Snaerius {progress}." },
      { kind = "OBJECTIVE", questName = "Across Worlds", radius = 15, objectiveIndex = 2, mapID = 2405, showAfter = 2, questIDs = {90875}, x = 39.45, y = 48.42, text = "Follow the arrow {progress}." },
      { kind = "OBJECTIVE", questName = "Across Worlds", radius = 5, objectiveIndex = 2, mapID = 2405, showAfter = 3, questIDs = {90875}, x = 39.35, y = 48.02, text = "Place the Lodestar {progress}." },
      { kind = "TURNIN", questName = "Across Worlds", questIDs = {90875}, mapID = 2405, x = 39.34, y = 48.04},
    },
  },
  {
    mapID = {2405},
    title = "Shadow Puppets Part 1",
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
      { kind = "PICKUP", questName = "The Conquered Heroes", questIDs = {91145}, x = 51.82, y = 71.90},
      { kind = "PICKUP", questName = "A Born Killer", questIDs = {90914}, x = 51.20, y = 68.45},
      { kind = "OBJECTIVE", questName = "The Conquered Heroes", radius = 10, objectiveIndex = 1, questIDs = {91145}, x = 46.80, y = 56.61, text = "Follow the arrow {progress}." },
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "The Conquered Heroes", radius = 8, showAfter = 3, objectiveIndex = 2, questIDs = {91145}, x = 46.80, y = 56.61, text = "Investigate bodies {progress}." },
      { kind = "OBJECTIVE", questName = "The Conquered Heroes", radius = 15, showAfter = 5, objectiveIndex = 3, questIDs = {91145}, x = 47.02, y = 54.50, text = "Follow the arrow {progress}." },
      { kind = "TURNIN", questName = "The Conquered Heroes", mapID = {2444}, questIDs = {91145}, x = 53.97, y = 84.03},
    },
   },
   {
    mapID = {2444},
    title = "Shadow Puppets Part 2",
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
      { kind = "PICKUP", questName = "Flickering Light", questIDs = {91146}, x = 53.97, y = 84.03},
      { kind = "PICKUP", questName = "Cut Her Strings", questIDs = {91147}, x = 53.97, y = 84.03},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Flickering Light", radius = 8, objectiveIndex = 1, questIDs = {91146}, x = 46.80, y = 56.61, text = "Find traces of light {progress}." },
      { kind = "OBJECTIVE", questName = "Cut Her Strings", radius = 250, objectiveIndex = 1, questIDs = {91147}, x = 50.86, y = 79.54, text = "Defeat and right click mobs to remove shadowgrafts {progress}." },
      { kind = "OBJECTIVE", questName = "Bloodying the Plain", radius = 300, showAfter = 2, questIDs = {92641}, x = 50.86, y = 79.54, text = "Kill enemies to fill the bar {progress}." },
      { kind = "TURNIN", questName = "Flickering Light", questIDs = {91146}, x = 53.97, y = 84.03},
      { kind = "TURNIN", questName = "Cut Her Strings", questIDs = {91147}, x = 53.97, y = 84.03},
      { kind = "NOTE", text = "The bonus objective 'Bloodying the Plain' automatically appears when the other quests are picked up. This should be completed alongside the other quests." },
      { kind = "NOTE", text = "When right clicking mobs, you immediately get credit for removing shadowgrafts. You do not need to complete the channel." },
    },
  },
  {
    mapID = {2444},
    title = "Shadow Puppets Part 3",
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
    mapID = {2444},
    title = "Shadowguard's Shadow Part 1",
    segments = {
      { kind = "PICKUP", questName = "Risk for Research", questIDs = {92390}, x = 39.75, y = 84.18},
      { kind = "OBJECTIVE", questName = "Risk for Research", radius = 10, objectiveIndex = 1, questIDs = {92390}, x = 62.81, y = 66.15, text = "Follow the arrow {progress}." },
      { kind = "TURNIN", questName = "Risk for Research", questIDs = {92390}, x = 62.81, y = 66.15},
    },
  },
  {
    mapID = {2444},
    title = "Shadowguard's Shadow Part 2",
    segments = {
      { kind = "PICKUP", questName = "Object Exorcism", questIDs = {92155}, x = 62.81, y = 66.15},
      { kind = "OBJECTIVE", questName = "Object Exorcism", radius = 5, objectiveIndex = 3, questIDs = {92155}, x = 65.38, y = 64.97, text = "Click on the weapon rack {progress}." },
      { kind = "OBJECTIVE", questName = "Object Exorcism", radius = 5, objectiveIndex = 1, questIDs = {92155}, x = 65.10, y = 61.01, text = "Click on the chair {progress}." },
      { kind = "OBJECTIVE", questName = "Object Exorcism", radius = 5, objectiveIndex = 2, questIDs = {92155}, x = 64.11, y = 60.93, text = "Click on the barrel {progress}." },
      { kind = "TURNIN", questName = "Object Exorcism", questIDs = {92155}, x = 64.66, y = 64.22},
      { kind = "NOTE", text = "You can exit the chair immediately after clicking it." },
    },
  },
  {
    mapID = {2444},
    title = "Shadowguard's Shadow Part 3",
    segments = {
      { kind = "PICKUP", questName = "It Follows Me", questIDs = {92156}, x = 64.73, y = 64.15},
      { kind = "OBJECTIVE", questName = "It Follows Me", radius = 150, objectiveIndex = 1, questIDs = {92156}, x = 65.27, y = 52.57, text = "Defeat and brand Shadowguard {progress}." },
      { kind = "TURNIN", questName = "It Follows Me", questIDs = {92156}, x = 64.73, y = 64.15},
    },
  },
  {
    mapID = {2444},
    title = "Shadowguard's Shadow Part 4",
    segments = {
      { kind = "PICKUP", questName = "Ritual Activity", questIDs = {92157}, x = 64.66, y = 64.22},
      { kind = "OBJECTIVE", questName = "Ritual Activity", radius = 8, objectiveIndex = 1, questIDs = {92157}, x = 62.90, y = 66.42, text = "Click on the objects {progress}." },
      { kind = "OBJECTIVE", questName = "Ritual Activity", radius = 5, objectiveIndex = 2, showAfter = 2, questIDs = {92157}, x = 62.74, y = 66.69, text = "Sit in the chair {progress}." },
      { kind = "OBJECTIVE", questName = "Ritual Activity", radius = 15, objectiveIndex = 3, showAfter = 3, questIDs = {92157}, x = 62.74, y = 66.69, text = "Wait for the roleplay to finish {progress}." },
      { kind = "TURNIN", questName = "Ritual Activity", questIDs = {92157}, x = 62.92, y = 66.24},
    },
  },
  {
    mapID = {2444},
    title = "Shadowguard's Shadow Part 5",
    segments = {
      { kind = "PICKUP", questName = "Let It In", questIDs = {92158}, x = 62.92, y = 66.24},
      { kind = "OBJECTIVE", questName = "Let It In", radius = 8, objectiveIndex = 2, questIDs = {92158}, x = 69.04, y = 62.04, text = "Defeat the Insidious Reflection {progress}." },
      { kind = "OBJECTIVE", questName = "Let It In", radius = 5, objectiveIndex = 3, showAfter = 2, questIDs = {92158}, x = 69.10, y = 62.31, text = "Click on the entity {progress}." },
      { kind = "TURNIN", questName = "Let It In", questIDs = {92158}, x = 69.17, y = 62.32},
      { kind = "NOTE", text = "Use the extra action button to summon the enemy." },
    },
  },
  {
    mapID = {2444},
    title = "Shadowguard's Shadow Part 6",
    segments = {
      { kind = "PICKUP", questName = "A Final Destination", questIDs = {92159}, x = 69.17, y = 62.32},
      { kind = "OBJECTIVE", questName = "A Final Destination", radius = 15, objectiveIndex = 1, questIDs = {92159}, x = 57.38, y = 47.39, text = "Follow the arrow {progress}." },
      { kind = "OBJECTIVE", questName = "A Final Destination", radius = 5, objectiveIndex = 2, showAfter = 2, questIDs = {92159}, x = 58.49, y = 46.54, text = "Kill Havazza {progress}." },
      { kind = "TURNIN", questName = "A Final Destination", questIDs = {92159}, x = 57.38, y = 47.39},
    },
  },
  {
    mapID = {2444},
    title = "A Gift, Given Freely Part 1",
    segments = {
      { kind = "PICKUP", questName = "O Lonely Star", questIDs = {92603}, x = 39.92, y = 84.25},
      { kind = "OBJECTIVE", questName = "O Lonely Star", radius = 5, objectiveIndex = 1, questIDs = {92603}, x = 39.92, y = 84.25, text = "Wake up Orin {progress}." },
      { kind = "OBJECTIVE", questName = "O Lonely Star", radius = 5, objectiveIndex = 2, showAfter = 2, questIDs = {92603}, x = 39.92, y = 84.25, text = "Speak to Orin {progress}." },
      { kind = "TURNIN", questName = "O Lonely Star", questIDs = {92603}, x = 39.57, y = 38.10},
    },
  },
  {
    mapID = {2444},
    title = "A Gift, Given Freely Part 2",
    segments = {
      { kind = "PICKUP", questName = "Speak in Blood", questIDs = {92604}, x = 39.57, y = 38.10},
      { kind = "PICKUP", questName = "Honest as Bone", questIDs = {92605}, x = 39.57, y = 38.10},
      { kind = "OBJECTIVE", questName = "Speak in Blood", radius = 150, objectiveIndex = 1, questIDs = {92604}, x = 34.27, y = 36.18, text = "Kill and loot enemies for ichor {progress}." },
      { kind = "OBJECTIVE", questName = "Honest as Bone", radius = 150, objectiveIndex = 2, questIDs = {92605}, x = 34.27, y = 36.18, text = "Collect bone splinters from objects on the ground {progress}." },
      { kind = "TURNIN", questName = "Speak in Blood", questIDs = {92604}, x = 33.15, y = 36.35},
      { kind = "TURNIN", questName = "Honest as Bone", questIDs = {92605}, x = 33.15, y = 36.35},
    },
  },
  {
    mapID = {2444},
    title = "A Gift, Given Freely Part 3",
    segments = {
      { kind = "PICKUP", questName = "Take Up Your Gift", questIDs = {92606}, x = 33.15, y = 36.35},
      { kind = "OBJECTIVE", questName = "Take Up Your Gift", radius = 15, objectiveIndex = 1, questIDs = {92606}, x = 33.06, y = 36.36, text = "Run along the dotted lines to draw the circles {progress}." },
      { kind = "OBJECTIVE", questName = "Take Up Your Gift", radius = 5, objectiveIndex = 2, showAfter = 2, questIDs = {92606}, x = 33.06, y = 36.36, text = "Click on the rift {progress}." },
      { kind = "OBJECTIVE", questName = "Take Up Your Gift", radius = 5, objectiveIndex = 3, showAfter = 3, questIDs = {92606}, x = 32.87, y = 38.00, text = "Click on the chisel {progress}." },
      { kind = "TURNIN", questName = "Take Up Your Gift", questIDs = {92606}, x = 33.09, y = 36.37},
    },
  },
  {
    mapID = {2444},
    title = "A Gift, Given Freely Part 4",
    segments = {
      { kind = "PICKUP", questName = "And Carve New Shapes", questIDs = {92607}, x = 33.09, y = 36.37},
      { kind = "OBJECTIVE", questName = "And Carve New Shapes", radius = 5, objectiveIndex = 1, questIDs = {92607}, x = 33.09, y = 36.37, text = "Click on Orin {progress}." },
      { kind = "OBJECTIVE", questName = "And Carve New Shapes", radius = 5, objectiveIndex = 2, showAfter = 2, questIDs = {92607}, x = 28.61, y = 34.97, text = "Defeat Orin's Shade {progress}." },
      { kind = "TURNIN", questName = "And Carve New Shapes", questIDs = {92607}, x = 33.29, y = 37.10},
    },
  },
  {
    mapID = {2405},
    title = "Secrets in the Dark Part 1",
    segments = {
      { kind = "PICKUP", questName = "It's Not Just a Rock!", questIDs = {92939}, x = 36.90, y = 58.55},
      { kind = "OBJECTIVE", questName = "It's Not Just a Rock!", radius = 150, objectiveIndex = 1, questIDs = {92939}, x = 38.80, y = 59.31, text = "Kill and loot enemies {progress}." },
      { kind = "TURNIN", questName = "It's Not Just a Rock!", questIDs = {92939}, x = 40.19, y = 56.14},
    },
  },
  {
    mapID = {2405},
    title = "Secrets in the Dark Part 2",
    segments = {
      { kind = "PICKUP", questName = "Sifting Through Void", questIDs = {92944}, x = 40.19, y = 56.14},
      { kind = "OBJECTIVE", questName = "Sifting Through Void", radius = 8, objectiveIndex = 1, questIDs = {92944}, x = 40.23, y = 56.78, text = "Enter the vortex {progress}." },
      { kind = "OBJECTIVE", questName = "Sifting Through Void", radius = 150, objectiveIndex = 2, showAfter = 2, questIDs = {92944}, x = 38.80, y = 59.31, text = "Grab residue as you float towards the ground {progress}." },
      { kind = "TURNIN", questName = "Sifting Through Void", questIDs = {92944}, x = 40.19, y = 56.14},
      { kind = "NOTE", text = "After reaching the ground you'll need to jump into another vortex to collect more residue." },
    },
  },
  {
    mapID = {2405},
    title = "Secrets in the Dark Part 3",
    segments = {
      { kind = "PICKUP", questName = "Buried in the Dark", questIDs = {92946}, x = 40.19, y = 56.14},
      { kind = "OBJECTIVE", questName = "Buried in the Dark", radius = 8, objectiveIndex = 1, questIDs = {92946}, x = 40.23, y = 56.78, text = "Enter the vortex {progress}." },
      { kind = "OBJECTIVE", questName = "Buried in the Dark", radius = 5, objectiveIndex = 2, showAfter = 2, questIDs = {92946}, x = 38.72, y = 58.78, text = "Click on the tablet {progress}." },
      { kind = "OBJECTIVE", questName = "Buried in the Dark", radius = 5, objectiveIndex = 3, showAfter = 3, questIDs = {92946}, x = 39.34, y = 57.90, text = "Click on the tablet {progress}." },
      { kind = "OBJECTIVE", questName = "Buried in the Dark", radius = 5, objectiveIndex = 4, showAfter = 4, questIDs = {92946}, x = 39.70, y = 58.33, text = "Click on the tablet {progress}." },
      { kind = "TURNIN", questName = "Buried in the Dark", questIDs = {92946}, x = 40.19, y = 56.14},
      { kind = "NOTE", text = "You'll need to wait on some unskippable roleplay after clicking each tablet." },
      { kind = "NOTE", text = "After the quest is complete, you can click on the nearby portal as a shortcut out of the cave." },
    },
  },
  {
    mapID = {2405},
    title = "Secrets in the Dark Part 4",
    segments = {
      { kind = "PICKUP", questName = "In Over My Head", questIDs = {92948}, x = 40.19, y = 56.14},
      { kind = "OBJECTIVE", questName = "In Over My Head", radius = 8, objectiveIndex = 1, questIDs = {92948}, x = 40.23, y = 56.78, text = "Enter the vortex {progress}." },
      { kind = "OBJECTIVE", questName = "In Over My Head", radius = 5, objectiveIndex = 2, showAfter = 2, questIDs = {92948}, x = 39.66, y = 55.85, text = "Defeat Akintunde the Unstoppable {progress}." },
      { kind = "TURNIN", questName = "In Over My Head", questIDs = {92948}, x = 37.06, y = 58.97},
      { kind = "NOTE", text = "Click on the nearby portal to exit the cave." },
    },
  },
  {
    mapID = {2405},
    title = "Pathogenic Problem Part 1",
    segments = {
      { kind = "PICKUP", questName = "A Born Killer", questIDs = {90914}, x = 51.20, y = 68.45},
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
    title = "Pathogenic Problem Part 2",
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
      { kind = "TURNIN", questName = "Expunging Explorers", questIDs = {91560}, x = 34.62, y = 43.79},
      { kind = "TURNIN", questName = "Calculated Culling", questIDs = {93801}, x = 34.62, y = 43.79},
      { kind = "NOTE", text = "The second quest takes a few seconds to appear after a bit of roleplay." },
      { kind = "NOTE", text = "At this point you may need to kill a few extra enemies to collect the last few Void Essence for the quest 'A Born Killer', which you grabbed earlier." },
    },
  },
  {
    mapID = {2405},
    title = "Pathogenic Problem Part 1",
    segments = {
      { kind = "PICKUP", questName = "Bloodborne Pathogen", questIDs = {91561}, x = 34.62, y = 43.79},
      { kind = "OBJECTIVE", questName = "Bloodborne Pathogen", radius = 10, objectiveIndex = 1, questIDs = {91561}, x = 32.19, y = 44.62, text = "Kill the Mutated Pathogen {progress}." },
      { kind = "TURNIN", questName = "Bloodborne Pathogen", questIDs = {91561}, x = 34.62, y = 43.79},
    },
  },
  {
    title = "Work In Progress!",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "The Voidstorm Sojourner module is still half finished, as I wanted to get an update out ASAP for other 12.0.7 changes. The rest of these quests will be included very soon." },
    },
  },
}

FTA.Modules[M.id] = M