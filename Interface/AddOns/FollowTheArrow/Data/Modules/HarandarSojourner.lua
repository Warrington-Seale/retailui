local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "Harandar_SOJOURNER"
M.title = "Harandar"
M.defaultRadius = 5

M.routeId    = "MIDNIGHT_SOJOURNER"
M.routeTitle = "Midnight Sojourner"
M.routeOrder = 20

M.moduleOrder = 40
M.nextModuleId = "TBD" 

M.steps = {
  {
    mapID = {2413},
    title = "A Goblin in Harandar Part 1",
    segments = {
      { kind = "PICKUP", questName = "Go Get Orweyna!", questIDs = {90533}, x = 47.08, y = 45.79},
      { kind = "OBJECTIVE", questName = "Go Get Orweyna!", questIDs = {90533}, objectiveIndex=1, x = 54.18, y = 55.29, text = "Speak to Orweyna {progress}."},
      { kind = "OBJECTIVE", questName = "Go Get Orweyna!", questIDs = {90533}, objectiveIndex=2, showAfter = 2, x = 53.90, y = 55.22, text = "Purchase a Handcrafted Plush from Imhayo {progress}."},
      { kind = "OBJECTIVE", questName = "Go Get Orweyna!", questIDs = {90533}, objectiveIndex=3, radius = 6, showAfter = 3, x = 47.08, y = 45.84, text = "Click on Nahuut {progress}."},
      { kind = "TURNIN", questName = "Go Get Orweyna!", questIDs = {90533}, x = 47.17, y = 45.77},
    },
  },
  {
    mapID = {2413},
    title = "A Goblin in Harandar Part 2",
    segments = {
      { kind = "PICKUP", questName = "The Home of the Haranir", questIDs = {90534}, x = 47.17, y = 45.77},
      { kind = "OBJECTIVE", questName = "The Home of the Haranir", questIDs = {90534}, objectiveIndex=1, x = 51.82, y = 50.49, text = "Click on the shredder {progress}."},
      { kind = "OBJECTIVE", questName = "The Home of the Haranir", questIDs = {90534}, objectiveIndex=2, showAfter = 2, mapID = 2576, x = 45.82, y = 79.69, text = "Click on the weapon rack (downstairs) {progress}."},
      { kind = "OBJECTIVE", questName = "The Home of the Haranir", questIDs = {90534}, objectiveIndex=3, showAfter = 3, mapID = 2576, x = 65.94, y = 59.81, text = "Click on the soup (downstairs) {progress}."},
      { kind = "TURNIN", questName = "The Home of the Haranir", questIDs = {90534}, mapID = 2576, x = 47.94, y = 22.63},
    },
  },
  {
    mapID = {2576},
    title = "A Goblin in Harandar Part 3",
    segments = {
      { kind = "PICKUP", questName = "Leave Your Mark", questIDs = {90535}, x = 48.00, y = 22.32},
      { kind = "OBJECTIVE", questName = "Leave Your Mark", questIDs = {90535}, objectiveIndex=1, x = 48.02, y = 23.19, text = "Click on the paint {progress}."},
      { kind = "OBJECTIVE", questName = "Leave Your Mark", questIDs = {90535}, objectiveIndex=2, showAfter = 2, x = 48.28, y = 22.90, text = "Click on the wall {progress}."},
      { kind = "TURNIN", questName = "Leave Your Mark", questIDs = {90535}, mapID = 2576, x = 48.00, y = 22.32},
    },
  },
  {
    mapID = {2413},
    title = "Haranir Never Say Die Part 1",
    arrow = { mode = "SEQUENCE_CHAIN", radius = 8, key = "hiding:children", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 49.54, y = 43.10, gate = { questID = {91550}, objectiveIndex = 3, atLeast = 1 } },
            { advance = "PROXIMITY", x = 50.38, y = 40.79, gate = { questID = {91550}, objectiveIndex = 3, atLeast = 2 } },
            { advance = "PROXIMITY", x = 51.37, y = 41.53, gate = { questID = {91550}, objectiveIndex = 3, atLeast = 3 } },
            { advance = "PROXIMITY", x = 51.72, y = 39.54, gate = { questID = {91550}, objectiveIndex = 3, atLeast = 4 } },
        },
      fallback = {
          x = 47.71, y = 69.77,
          radius = 10,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "A Game of Silence and Shadow", questIDs = {91550}, x = 48.76, y = 44.31},
      { kind = "OBJECTIVE", questName = "A Game of Silence and Shadow", questIDs = {91550}, objectiveIndex=1, x = 48.76, y = 44.31, text = "Speak to Shao'mal {progress}."},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "A Game of Silence and Shadow", questIDs = {91550}, objectiveIndex=3, showAfter = 2, x = 48.76, y = 44.31, text = "Find the children {progress}."},
      { kind = "TURNIN", questName = "A Game of Silence and Shadow", questIDs = {91550}, x = 53.90, y = 41.26},
      { kind = "NOTE", text = "'0/1 Wait for children to hide (Optional)' might be the funniest quest objective I've ever seen." },
    },
  },
  {
    mapID = {2413},
    title = "Haranir Never Say Die Part 2",
    segments = {
      { kind = "PICKUP", questName = "De-nest-stration", questIDs = {91551}, x = 53.90, y = 41.26},
      { kind = "PICKUP", questName = "Feathered Fury", questIDs = {91552}, x = 53.90, y = 41.26},
      { kind = "OBJECTIVE", questName = "De-nest-stration", questIDs = {91551}, objectiveIndex=1, radius = 150, x = 55.69, y = 45.79, text = "Destroy Nests {progress}."},
      { kind = "OBJECTIVE", questName = "Feathered Fury", questIDs = {91552}, objectiveIndex=1, radius = 150, x = 55.69, y = 45.79, text = "Kill Petalwings {progress}."},
      { kind = "TURNIN", questName = "De-nest-stration", questIDs = {91551}, x = 57.30, y = 49.02},
      { kind = "TURNIN", questName = "Feathered Fury", questIDs = {91552}, x = 57.30, y = 49.02},
    },
  },
  {
    mapID = {2413},
    title = "Haranir Never Say Die Part 3",
    segments = {
      { kind = "PICKUP", questName = "Haranir Never Say Die!", questIDs = {91553}, x = 57.30, y = 49.02},
      { kind = "OBJECTIVE", questName = "Haranir Never Say Die!", questIDs = {91553}, objectiveIndex=1, radius = 8, x = 57.81, y = 49.70, text = "Kill the Behemoth Petalwing {progress}."},
      { kind = "TURNIN", questName = "Haranir Never Say Die!", questIDs = {91553}, x = 58.44, y = 49.14},
    },
  },
  {
    mapID = {2413},
    title = "Legend of Aln'sharan Part 1",
    segments = {
      { kind = "PICKUP", questName = "Tales of the Sky", questIDs = {90467}, x = 67.78, y = 27.49},
      { kind = "PICKUP", questName = "Ugh, Chores!", questIDs = {90468}, x = 67.78, y = 27.49},
      { kind = "OBJECTIVE", questName = "Tales of the Sky", questIDs = {90467}, objectiveIndex=1, radius = 80, x = 69.60, y = 31.20, text = "Collect Stray Skyshards {progress}."},
      { kind = "OBJECTIVE", questName = "Ugh, Chores!", questIDs = {90468}, objectiveIndex=1, radius = 120, x = 69.60, y = 31.20, text = "Kill and loot Cascades Fenhunters {progress}."},
      { kind = "TURNIN", questName = "Tales of the Sky", questIDs = {90467}, x = 69.40, y = 29.24},
      { kind = "TURNIN", questName = "Ugh, Chores!", questIDs = {90468}, x = 69.40, y = 29.24},
    },
  },
  {
    mapID = {2413},
    title = "Legend of Aln'sharan Part 2",
    segments = {
      { kind = "PICKUP", questName = "Carry On, Wayward Kuri", questIDs = {90469}, x = 69.40, y = 29.24},
      { kind = "OBJECTIVE", questName = "Carry On, Wayward Kuri", questIDs = {90469}, objectiveIndex=1, x = 69.69, y = 26.56, text = "Follow the arrow {progress}."},
      { kind = "TURNIN", questName = "Carry On, Wayward Kuri", questIDs = {90469}, x = 69.69, y = 26.56},
    },
  },
  {
    mapID = {2413},
    title = "Legend of Aln'sharan Part 3",
    segments = {
      { kind = "PICKUP", questName = "Skyglass Scavenging", questIDs = {90470}, x = 69.69, y = 26.56},
      { kind = "OBJECTIVE", questName = "Skyglass Scavenging", questIDs = {90470}, objectiveIndex=1, radius = 60, x = 71.45, y = 27.68, text = "Recover Skyglass {progress}."},
      { kind = "TURNIN", questName = "Skyglass Scavenging", questIDs = {90470}, x = 69.69, y = 26.56},
      { kind = "NOTE", text = "Some glass can be picked up manually, some piles need to be collected by Kuri. You can call her with the extra action button." },
    },
  },
  {
    mapID = {2413},
    title = "Legend of Aln'sharan Part 4",
    segments = {
      { kind = "PICKUP", questName = "The Legend of Aln'sharan", questIDs = {90474}, x = 69.69, y = 26.56},
      { kind = "OBJECTIVE", questName = "The Legend of Aln'sharan", questIDs = {90474}, objectiveIndex=1, x = 66.16, y = 25.50, text = "Use the extra action button to throw skyshards {progress}."},
      { kind = "TURNIN", questName = "The Legend of Aln'sharan", questIDs = {90474}, x = 66.16, y = 25.50},
    },
  },
  {
    mapID = {2413},
    title = "Peril Among Petals Part 1",
    segments = {
      { kind = "PICKUP", questName = "The Blooming Lattice", questIDs = {91063}, x = 65.38, y = 22.64},
      { kind = "OBJECTIVE", questName = "The Blooming Lattice", questIDs = {91063}, objectiveIndex=1, x = 66.16, y = 25.50, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "The Blooming Lattice", questIDs = {91063}, x = 60.82, y = 29.89},
    },
  },
  {
    mapID = {2413},
    title = "Peril Among Petals Part 2",
    segments = {
      { kind = "PICKUP", questName = "Purloining Petals", questIDs = {91065}, x = 60.82, y = 29.89},
      { kind = "PICKUP", questName = "Nipping the Buds", questIDs = {91086}, x = 60.82, y = 29.89},
      { kind = "PICKUP", questName = "Petal Bristles", questIDs = {91085}, x = 60.82, y = 29.89},
      { kind = "OBJECTIVE", questName = "Purloining Petals", questIDs = {91065}, objectiveIndex=4, x = 55.32, y = 30.61, text = "Collect Paint-Speckled Gourd {progress}."},
      { kind = "OBJECTIVE", questName = "Nipping the Buds", questIDs = {91086}, objectiveIndex=2, x = 54.91, y = 31.60, text = "Kill Prime Bloodwarden Kazat {progress}."},
      { kind = "OBJECTIVE", questName = "Purloining Petals", questIDs = {91065}, objectiveIndex=3, x = 54.85, y = 32.07, text = "Collect Splattered Scroll {progress}."},
      { kind = "OBJECTIVE", questName = "Purloining Petals", questIDs = {91065}, objectiveIndex=1, x = 55.33, y = 28.33, text = "Collect Well-Worn Ladle {progress}."},
      { kind = "OBJECTIVE", questName = "Purloining Petals", questIDs = {91065}, objectiveIndex=2, x = 54.53, y = 28.30, text = "Collect Pilfered Crafting Drill {progress}."},
      { kind = "OBJECTIVE", questName = "Petal Bristles", questIDs = {91085}, radius = 150, objectiveIndex=1, x = 55.36, y = 29.69, text = "Collect Petalwing Plumes {progress}."},
      { kind = "OBJECTIVE", questName = "Nipping the Buds", questIDs = {91086}, radius = 150, objectiveIndex=1, x = 55.36, y = 29.69, text = "Kill Rutaani {progress}."},
      { kind = "TURNIN", questName = "Purloining Petals", questIDs = {91065}, x = 60.82, y = 29.89},
      { kind = "TURNIN", questName = "Nipping the Buds", questIDs = {91086}, x = 60.82, y = 29.89},
      { kind = "TURNIN", questName = "Petal Bristles", questIDs = {91085}, x = 60.82, y = 29.89},
      { kind = "NOTE", text = "Plumes can be found on the ground or looted off any petalwings that you kill." },
    },
  },
  {
    mapID = {2413},
    title = "Peril Among Petals Part 3",
    segments = {
      { kind = "PICKUP", questName = "Behind the Falls", questIDs = {91088}, x = 60.82, y = 29.89},
      { kind = "OBJECTIVE", questName = "Behind the Falls", questIDs = {91088}, objectiveIndex=1, x = 66.16, y = 25.50, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "Behind the Falls", questIDs = {91088}, x = 56.10, y = 24.83},
    },
  },
  {
    mapID = {2413},
    title = "Peril Among Petals Part 4",
    segments = {
      { kind = "PICKUP", questName = "Memories in Stone", questIDs = {91136}, x = 56.10, y = 24.83},
      { kind = "OBJECTIVE", questName = "Memories in Stone", questIDs = {91136}, objectiveIndex=1, x = 56.10, y = 24.83, text = "Speak to Su'meera {progress}."},
      { kind = "OBJECTIVE", questName = "Memories in Stone", questIDs = {91136}, objectiveIndex=2, showAfter = 2, radius = 10, x = 56.10, y = 24.83, text = "Defend Su'meera {progress}."},
      { kind = "TURNIN", questName = "Memories in Stone", questIDs = {91136}, x = 55.71, y = 26.53},
      { kind = "NOTE", text = "There are three waves of mobs before the defend objective is complete." },
    },
  },
  {
    mapID = {2413},
    title = "Late Bloomers Part 1",
    segments = {
      { kind = "PICKUP", questName = "Late Bloomers", questIDs = {90537}, x = 36.96, y = 25.98},
      { kind = "OBJECTIVE", questName = "Late Bloomers", questIDs = {90537}, radius = 10, objectiveIndex=1, x = 48.74, y = 32.06, text = "Follow the arrow {progress}."},
      { kind = "OBJECTIVE", questName = "Late Bloomers", questIDs = {90537}, objectiveIndex=2, showAfter = 2, x = 48.69, y = 31.97, text = "Click on the corpse {progress}."},
      { kind = "OBJECTIVE", questName = "Late Bloomers", questIDs = {90537}, objectiveIndex=3, showAfter = 2, x = 48.72, y = 32.19, text = "Click on the seed sack {progress}."},
      { kind = "OBJECTIVE", questName = "Late Bloomers", questIDs = {90537}, objectiveIndex=4, showAfter = 4, x = 48.81, y = 32.13, text = "Speak to Ney'leia {progress}."},
      { kind = "TURNIN", questName = "Late Bloomers", questIDs = {90537}, x = 48.94, y = 29.74},
    },
  },
  {
    mapID = {2413},
    title = "Late Bloomers Part 2",
    segments = {
      { kind = "PICKUP", questName = "Rutaani Rescue", questIDs = {90540}, x = 48.94, y = 29.74},
      { kind = "PICKUP", questName = "Back in the Bag", questIDs = {90569}, x = 48.94, y = 29.74},
      { kind = "OBJECTIVE", questName = "Rutaani Rescue", questIDs = {90540}, radius = 150, objectiveIndex=1, x = 48.16, y = 26.17, text = "Rescue Rutaani {progress}."},
      { kind = "OBJECTIVE", questName = "Back in the Bag", questIDs = {90569}, radius = 150, objectiveIndex=1, x = 48.16, y = 26.17, text = "Kill and loot fungarians for seeds {progress}."},
      { kind = "TURNIN", questName = "Rutaani Rescue", questIDs = {90540}, x = 48.94, y = 29.74},
      { kind = "TURNIN", questName = "Back in the Bag", questIDs = {90569}, x = 48.94, y = 29.74},
    },
  },
  {
    mapID = {2413},
    title = "Late Bloomers Part 3",
    segments = {
      { kind = "PICKUP", questName = "Caves of the Cleft", questIDs = {90963}, x = 48.94, y = 29.74},
      { kind = "OBJECTIVE", questName = "Caves of the Cleft", questIDs = {90963}, objectiveIndex=1, x = 66.16, y = 25.50, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "Caves of the Cleft", questIDs = {90963}, x = 49.69, y = 23.31},
    },
  },
  {
    mapID = {2413},
    title = "Late Bloomers Part 4",
    segments = {
      { kind = "PICKUP", questName = "Gomphusta", questIDs = {90602}, x = 49.69, y = 23.31},
      { kind = "PICKUP", questName = "Gathering Glowshrooms", questIDs = {90601}, x = 49.69, y = 23.31},
      { kind = "OBJECTIVE", questName = "Gomphusta", questIDs = {90602}, radius = 6, objectiveIndex=1, x = 48.64, y = 21.61, text = "Kill Gomphusta {progress}."},
      { kind = "OBJECTIVE", questName = "Gomphusta", questIDs = {90602}, radius = 5, objectiveIndex=2, showAfter = 3, x = 48.63, y = 22.42, text = "Open the chest {progress}."},
      { kind = "OBJECTIVE", questName = "Gathering Glowshrooms", questIDs = {90601}, radius = 50, objectiveIndex=1, x = 49.09, y = 22.41, text = "Collect Glowshrooms {progress}."},
      { kind = "TURNIN", questName = "Gomphusta", questIDs = {90602}, x = 49.69, y = 23.31},
      { kind = "TURNIN", questName = "Gathering Glowshrooms", questIDs = {90601}, x = 49.69, y = 23.31},
    },
  },
  {
    mapID = {2413},
    title = "Harandar's Kitchen Part 1",
    segments = {
      { kind = "PICKUP", questName = "Carcass Cuisine", questIDs = {91587}, x = 40.87, y = 23.17},
      { kind = "PICKUP", questName = "Soil-Based Alternatives", questIDs = {91586}, x = 40.87, y = 23.17},
      { kind = "PICKUP", questName = "Fresh from the Garden", questIDs = {91585}, x = 40.87, y = 23.17},
      { kind = "OBJECTIVE", questName = "Carcass Cuisine", questIDs = {91587}, radius = 6, objectiveIndex=1, x = 39.14, y = 22.48, text = "Kill and loot the Sporeglider Bloomterror {progress}."},
      { kind = "OBJECTIVE", questName = "Carcass Cuisine", questIDs = {91587}, radius = 6, objectiveIndex=2, showAfter = 4, x = 39.14, y = 22.48, text = "Kill and loot the Sporeglider Bloomterror {progress}."},
      { kind = "OBJECTIVE", questName = "Soil-Based Alternatives", questIDs = {91586}, radius = 80, objectiveIndex=1, x = 40.30, y = 24.19, text = "Collect soil {progress}."},
      { kind = "OBJECTIVE", questName = "Fresh from the Garden", questIDs = {91585}, radius = 80, objectiveIndex=1, x = 40.30, y = 24.19, text = "Kill and loot Frillfish {progress}."},
      { kind = "OBJECTIVE", questName = "Fresh from the Garden", questIDs = {91585}, radius = 80, objectiveIndex=2, x = 40.30, y = 24.19, text = "Kill and loot Root Drifters {progress}."},
      { kind = "TURNIN", questName = "Carcass Cuisine", questIDs = {91587}, x = 40.87, y = 23.17},
      { kind = "TURNIN", questName = "Soil-Based Alternatives", questIDs = {91586}, x = 40.87, y = 23.17},
      { kind = "TURNIN", questName = "Fresh from the Garden", questIDs = {91585}, x = 40.87, y = 23.17},
      { kind = "NOTE", text = "Root Drift Jelly is just one of those annoying quest objectives with a low drop rate." },
    },
  },
  {
    mapID = {2413},
    title = "Harandar's Kitchen Part 2",
    segments = {
      { kind = "PICKUP", questName = "Harandar's Kitchen", questIDs = {91588}, x = 40.87, y = 23.17},
      { kind = "OBJECTIVE", questName = "Harandar's Kitchen", questIDs = {91588}, radius = 5, objectiveIndex=3, x = 41.06, y = 23.55, text = "Click on the campfire {progress}."},
      { kind = "OBJECTIVE", questName = "Harandar's Kitchen", questIDs = {91588}, radius = 5, objectiveIndex=2, x = 40.17, y = 22.66, text = "Click on the knife {progress}."},
      { kind = "OBJECTIVE", questName = "Harandar's Kitchen", questIDs = {91588}, radius = 5, objectiveIndex=1, x = 39.72, y = 21.92, text = "Click on the wash bed {progress}."},
      { kind = "TURNIN", questName = "Harandar's Kitchen", questIDs = {91588}, x = 40.87, y = 23.17},
    },
  },
  {
    mapID = {2413},
    title = "Harandar's Kitchen Part 3",
    segments = {
      { kind = "PICKUP", questName = "Root Dash Delivery", questIDs = {91589}, x = 40.87, y = 23.17},
      { kind = "OBJECTIVE", questName = "Root Dash Delivery", questIDs = {91589}, radius = 5, objectiveIndex=1, x = 40.75, y = 23.16, text = "Click on the box {progress}."},
      { kind = "OBJECTIVE", questName = "Root Dash Delivery", questIDs = {91589}, radius = 6, showAfter = 2, objectiveIndex=2, x = 36.57, y = 26.85, text = "Serve the salad {progress}."},
      { kind = "OBJECTIVE", questName = "Root Dash Delivery", questIDs = {91589}, radius = 6, showAfter = 2, objectiveIndex=3, x = 36.57, y = 26.85, text = "Serve the fish {progress}."},
      { kind = "OBJECTIVE", questName = "Root Dash Delivery", questIDs = {91589}, radius = 6, showAfter = 2, objectiveIndex=4, x = 36.57, y = 26.85, text = "Serve the ribs {progress}."},
      { kind = "OBJECTIVE", questName = "Root Dash Delivery", questIDs = {91589}, radius = 6, showAfter = 2, objectiveIndex=5, x = 36.57, y = 26.85, text = "Serve the dirt {progress}."},
      { kind = "TURNIN", questName = "Root Dash Delivery", questIDs = {91589}, x = 36.66, y = 26.84},
    },
  },
  {
    mapID = {2413},
    title = "Cultivating Hope Part 1",
    segments = {
      { kind = "PICKUP", questName = "The Former Rootwarden", questIDs = {91872}, x = 34.88, y = 24.97},
      { kind = "OBJECTIVE", questName = "The Former Rootwarden", questIDs = {91872}, radius = 5, objectiveIndex=1, x = 40.75, y = 23.16, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "The Former Rootwarden", questIDs = {91872}, x = 42.55, y = 34.11},
    },
  },
  {
    mapID = {2413},
    title = "Cultivating Hope Part 2",
    segments = {
      { kind = "PICKUP", questName = "Buffer Zone", questIDs = {91873}, x = 42.55, y = 34.11},
      { kind = "OBJECTIVE", questName = "Buffer Zone", questIDs = {91873}, radius = 200, objectiveIndex=1, x = 41.99, y = 32.01, text = "Kill nearby enemies {progress}."},
      { kind = "TURNIN", questName = "Buffer Zone", questIDs = {91873}, x = 42.32, y = 34.18},
    },
  },
  {
    mapID = {2413},
    title = "Cultivating Hope Part 3",
    segments = {
      { kind = "PICKUP", questName = "Natural Remedy", questIDs = {91875}, x = 42.32, y = 34.18},
      { kind = "OBJECTIVE", questName = "Natural Remedy", questIDs = {91875}, radius = 200, objectiveIndex=1, x = 41.99, y = 32.01, text = "Kill and loot Wandering Stalkers {progress}."},
      { kind = "TURNIN", questName = "Natural Remedy", questIDs = {91875}, x = 42.44, y = 34.42},
    },
  },
  {
    mapID = {2413},
    title = "Cultivating Hope Part 4",
    segments = {
      { kind = "PICKUP", questName = "Flare Up", questIDs = {91874}, x = 42.44, y = 34.42},
      { kind = "OBJECTIVE", questName = "Flare Up", questIDs = {91874}, radius = 300, objectiveIndex=1, x = 34.75, y = 37.75, text = "Fly near fires to douse them {progress}."},
      { kind = "TURNIN", questName = "Flare Up", questIDs = {91874}, x = 42.58, y = 33.60},
    },
  },
  {
    mapID = {2413},
    title = "Cultivating Hope Part 5",
    segments = {
      { kind = "PICKUP", questName = "Tending Hope", questIDs = {91876}, x = 42.58, y = 33.60},
      { kind = "OBJECTIVE", questName = "Tending Hope", questIDs = {91876}, radius = 30, objectiveIndex=1, x = 42.52, y = 33.81, text = "Apply salve to root segments {progress}."},
      { kind = "TURNIN", questName = "Tending Hope", questIDs = {91876}, x = 42.52, y = 33.81},
    },
  },
  {
    mapID = {2413},
    title = "Bloomtown Part 1",
    segments = {
      { kind = "PICKUP", questName = "Light Disturbance", questIDs = {92732}, x = 31.40, y = 64.97},
      { kind = "OBJECTIVE", questName = "Light Disturbance", questIDs = {92732}, radius = 5, objectiveIndex=1, x = 42.52, y = 33.81, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "Light Disturbance", questIDs = {92732}, x = 40.64, y = 62.99},
    },
  },
  {
    mapID = {2413},
    title = "Bloomtown Part 2",
    arrow = { mode = "SEQUENCE_CHAIN", radius = 8, key = "light:stroll", debounce = 0.75,
      nodes = {
            { advance = "PROXIMITY", x = 40.85, y = 64.01, gate = { questID = {92736}, objectiveIndex = 1, atLeast = 1 } },
            { advance = "PROXIMITY", x = 40.84, y = 65.28, gate = { questID = {92736}, objectiveIndex = 1, atLeast = 2 } },
            { advance = "PROXIMITY", x = 41.23, y = 66.66, gate = { questID = {92736}, objectiveIndex = 1, atLeast = 3 } },
            { advance = "PROXIMITY", x = 41.66, y = 67.44, gate = { questID = {92736}, objectiveIndex = 1, atLeast = 4 } },
        },
      fallback = {
          x = 47.71, y = 69.77,
          radius = 10,
        },
      },
    segments = {
      { kind = "PICKUP", questName = "Light Stroll", questIDs = {92736}, x = 40.64, y = 62.99},
      { kind = "CHAIN_START" },
      { kind = "OBJECTIVE", questName = "Light Stroll", questIDs = {92736}, radius = 5, objectiveIndex=1, x = 42.52, y = 33.81, text = "Click on clues {progress}."},
      { kind = "TURNIN", questName = "Light Stroll", questIDs = {92736}, x = 41.68, y = 67.80},
      { kind = "NOTE", text = "For some reason the 'Clues Found' step has '(Optional)' next to it, but this is untrue. The turn-in does not become available until all clues are found." },
    },
  },
  {
    mapID = {2413},
    title = "Bloomtown Part 3",
    segments = {
      { kind = "PICKUP", questName = "Light Carnage", questIDs = {92737}, x = 41.68, y = 67.80},
      { kind = "PICKUP", questName = "Potatoad Tots", questIDs = {92738}, x = 41.68, y = 67.80},
      { kind = "OBJECTIVE", questName = "Light Carnage", questIDs = {92737}, radius = 80, objectiveIndex=1, x = 38.86, y = 70.63, text = "Kill Lightfrenzied Potatoads {progress}."},
      { kind = "OBJECTIVE", questName = "Potatoad Tots", questIDs = {92738}, radius = 80, objectiveIndex=1, x = 38.86, y = 70.63, text = "Collect Potadpoles {progress}."},
      { kind = "TURNIN", questName = "Light Carnage", questIDs = {92737}, x = 37.34, y = 72.34},
      { kind = "TURNIN", questName = "Potatoad Tots", questIDs = {92738}, x = 37.34, y = 72.34},
    },
  },
  {
    mapID = {2413},
    title = "Bloomtown Part 4",
    segments = {
      { kind = "PICKUP", questName = "O.K. Bloomer", questIDs = {92739}, x = 37.34, y = 72.34},
      { kind = "OBJECTIVE", questName = "O.K. Bloomer", questIDs = {92739}, radius = 6, objectiveIndex=1, x = 35.98, y = 74.21, text = "Kill Adzikel {progress}."},
      { kind = "TURNIN", questName = "O.K. Bloomer", questIDs = {92739}, x = 31.40, y = 64.97},
    },
  },
  {
    mapID = {2413},
    title = "The Silence at Fungara Village Part 1",
    segments = {
      { kind = "PICKUP", questName = "The Silence at Fungara Village", questIDs = {91375}, x = 33.33, y = 66.68},
      { kind = "OBJECTIVE", questName = "The Silence at Fungara Village", questIDs = {91375}, radius = 5, objectiveIndex=1, x = 42.52, y = 33.81, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "The Silence at Fungara Village", questIDs = {91375}, x = 43.91, y = 71.70},
    },
  },
  {
    mapID = {2413},
    title = "The Silence at Fungara Village Part 2",
    segments = {
      { kind = "PICKUP", questName = "Spawn of the Dead", questIDs = {91377}, x = 43.91, y = 71.70},
      { kind = "PICKUP", questName = "Little Monsters", questIDs = {91376}, x = 43.91, y = 71.70},
      { kind = "OBJECTIVE", questName = "Spawn of the Dead", questIDs = {91377}, radius = 60, objectiveIndex=1, x = 45.74, y = 70.35, text = "Click on Blooming Corpses {progress}."},
      { kind = "OBJECTIVE", questName = "Little Monsters", questIDs = {91376}, radius = 120, objectiveIndex=1, x = 45.74, y = 70.35, text = "Kill and loot fungarians or sporegliders {progress}."},
      { kind = "TURNIN", questName = "Spawn of the Dead", questIDs = {91377}, x = 44.12, y = 66.44},
      { kind = "TURNIN", questName = "Little Monsters", questIDs = {91376}, x = 44.12, y = 66.44},
    },
  },
  {
    mapID = {2413},
    title = "The Silence at Fungara Village Part 3",
    segments = {
      { kind = "PICKUP", questName = "You Are Legend", questIDs = {91378}, x = 44.12, y = 66.44},
      { kind = "PICKUP", questName = "Decayed Land", questIDs = {91379}, x = 44.12, y = 66.44},
      { kind = "OBJECTIVE", questName = "You Are Legend", questIDs = {91378}, radius = 60, objectiveIndex=1, x = 42.83, y = 66.44, text = "Kill nearby enemies {progress}."},
      { kind = "OBJECTIVE", questName = "Decayed Land", questIDs = {91379}, radius = 60, objectiveIndex=1, x = 42.83, y = 66.44, text = "Destroy Fruiting Mycelium {progress}."},
      { kind = "TURNIN", questName = "You Are Legend", questIDs = {91378}, x = 44.12, y = 66.44},
      { kind = "TURNIN", questName = "Decayed Land", questIDs = {91379}, x = 44.12, y = 66.44},
    },
  },
  {
    mapID = {2413},
    title = "The Silence at Fungara Village Part 4",
    segments = {
      { kind = "PICKUP", questName = "Reticent Evil", questIDs = {91381}, x = 44.12, y = 66.44},
      { kind = "OBJECTIVE", questName = "Reticent Evil", questIDs = {91381}, radius = 6, objectiveIndex=1, x = 45.78, y = 66.80, text = "Destroy Agericus Decanimatus {progress}."},
      { kind = "OBJECTIVE", questName = "Reticent Evil", questIDs = {91381}, radius = 6, objectiveIndex=2, showAfter = 2, x = 45.78, y = 66.80, text = "Kill the Zombified Guardian {progress}."},
      { kind = "TURNIN", questName = "Reticent Evil", questIDs = {91381}, x = 44.12, y = 66.44},
    },
  },
  {
    mapID = {2413},
    title = "Hunter's Rite Part 1",
    segments = {
      { kind = "PICKUP", questName = "A Hunter's Plight", questIDs = {92882}, x = 69.42, y = 52.84},
      { kind = "OBJECTIVE", questName = "A Hunter's Plight", questIDs = {92882}, radius = 5, objectiveIndex=1, x = 70.47, y = 50.71, text = "Speak to Akazi {progress}."},
      { kind = "TURNIN", questName = "A Hunter's Plight", questIDs = {92882}, x = 70.47, y = 50.71},
    },
  },
  {
    mapID = {2413},
    title = "Hunter's Rite Part 2",
    segments = {
      { kind = "PICKUP", questName = "A Hunter's Duty", questIDs = {92883}, x = 70.47, y = 50.71},
      { kind = "OBJECTIVE", questName = "A Hunter's Duty", questIDs = {92883}, radius = 150, objectiveIndex=1, x = 70.10, y = 43.60, text = "Kill and loot Chloroceros {progress}."},
      { kind = "OBJECTIVE", questName = "A Hunter's Duty", questIDs = {92883}, radius = 150, objectiveIndex=2, x = 70.10, y = 43.60, text = "Kill and loot Slithering Grovecrawlers {progress}."},
      { kind = "OBJECTIVE", questName = "A Hunter's Duty", questIDs = {92883}, radius = 100, objectiveIndex=4, x = 70.47, y = 50.71, text = "Collect Sporeglider Tail Spores {progress}."},
      { kind = "OBJECTIVE", questName = "A Hunter's Duty", questIDs = {92883}, radius = 100, objectiveIndex=3, x = 72.04, y = 37.83, text = "Kill and loot Spiteful Lashers {progress}."},
      { kind = "TURNIN", questName = "A Hunter's Duty", questIDs = {92883}, x = 69.98, y = 52.88},
    },
  },
  {
    mapID = {2413},
    title = "Hunter's Rite Part 3",
    segments = {
      { kind = "PICKUP", questName = "A Hunter's Weapon", questIDs = {92884}, x = 69.98, y = 52.88},
      { kind = "OBJECTIVE", questName = "A Hunter's Weapon", questIDs = {92884}, objectiveIndex=1, x = 70.01, y = 52.69, text = "Click on the bone {progress}."},
      { kind = "OBJECTIVE", questName = "A Hunter's Weapon", questIDs = {92884}, showAfter = 2, objectiveIndex=2, x = 70.01, y = 52.67, text = "Click on the Tail Spore {progress}."},
      { kind = "OBJECTIVE", questName = "A Hunter's Weapon", questIDs = {92884}, showAfter = 3, objectiveIndex=3, x = 69.96, y = 52.79, text = "Click on the spear {progress}."},
      { kind = "OBJECTIVE", questName = "A Hunter's Weapon", questIDs = {92884}, showAfter = 4, objectiveIndex=4, x = 70.47, y = 50.71, text = "Speak to Akazi {progress}."},
      { kind = "TURNIN", questName = "A Hunter's Weapon", questIDs = {92884}, x = 70.47, y = 50.71},
    },
  },
  {
    mapID = {2413},
    title = "Hunter's Rite Part 4",
    segments = {
      { kind = "PICKUP", questName = "A Hunter's Prey", questIDs = {92885}, x = 70.47, y = 50.71},
      { kind = "OBJECTIVE", questName = "A Hunter's Prey", questIDs = {92885}, objectiveIndex=1, x = 69.01, y = 54.95, text = "Speak to Ketan {progress}."},
      { kind = "OBJECTIVE", questName = "A Hunter's Prey", questIDs = {92885}, radius = 6, showAfter = 2, objectiveIndex=2, x = 68.58, y = 54.07, text = "Kill Radooni {progress}."},
      { kind = "TURNIN", questName = "A Hunter's Prey", questIDs = {92885}, x = 70.47, y = 50.71},
    },
  },
  {
    mapID = {2413},
    title = "Predator Reintroduction Part 1",
    segments = {
      { kind = "PICKUP", questName = "Drift Them Away", questIDs = {92864}, x = 69.54, y = 50.57},
      { kind = "PICKUP", questName = "Feeding the Buds", questIDs = {92865}, x = 69.54, y = 50.57},
      { kind = "OBJECTIVE", questName = "Feeding the Buds", questIDs = {92865}, radius = 80, objectiveIndex=1, x = 69.81, y = 43.54, text = "Kill and loot Chloroceros {progress}."},
      { kind = "OBJECTIVE", questName = "Drift Them Away", questIDs = {92864}, radius = 60, objectiveIndex=1, x = 69.63, y = 38.31, text = "Kill Cascade Drifters {progress}."},
      { kind = "OBJECTIVE", questName = "Drift Them Away", questIDs = {92864}, radius = 60, objectiveIndex=2, x = 69.63, y = 38.31, text = "Destroy egg sacks {progress}."},
      { kind = "OBJECTIVE", questName = "Feeding the Buds", questIDs = {92865}, showAfter = 3, objectiveIndex=5, x = 69.38, y = 50.63, text = "Feed N'ala {progress}."},
      { kind = "OBJECTIVE", questName = "Feeding the Buds", questIDs = {92865}, showAfter = 3, objectiveIndex=4, x = 69.51, y = 50.50, text = "Feed T'omm {progress}."},
      { kind = "OBJECTIVE", questName = "Feeding the Buds", questIDs = {92865}, showAfter = 3, objectiveIndex=3, x = 69.64, y = 50.60, text = "Feed F'liks {progress}."},
      { kind = "OBJECTIVE", questName = "Feeding the Buds", questIDs = {92865}, showAfter = 3, objectiveIndex=2, x = 69.78, y = 50.52, text = "Feed Grumpy {progress}."},
      { kind = "TURNIN", questName = "Drift Them Away", questIDs = {92864}, x = 69.54, y = 50.57},
      { kind = "TURNIN", questName = "Feeding the Buds", questIDs = {92865}, x = 69.54, y = 50.57},
    },
  },
  {
    mapID = {2413},
    title = "Predator Reintroduction Part 2",
    segments = {
      { kind = "PICKUP", questName = "Re-Hydra-ted", questIDs = {92866}, x = 69.54, y = 50.57},
      { kind = "OBJECTIVE", questName = "Re-Hydra-ted", questIDs = {92866}, radius = 10, objectiveIndex=1, x = 69.58, y = 50.64, text = "Pick up the budlings {progress}."},
      { kind = "OBJECTIVE", questName = "Re-Hydra-ted", questIDs = {92866}, showAfter = 2, objectiveIndex=4, x = 69.92, y = 45.43, text = "Feed T'omm {progress}."},
      { kind = "OBJECTIVE", questName = "Re-Hydra-ted", questIDs = {92866}, showAfter = 2, objectiveIndex=2, x = 68.96, y = 42.09, text = "Feed Grumpy {progress}."},
      { kind = "OBJECTIVE", questName = "Re-Hydra-ted", questIDs = {92866}, showAfter = 2, objectiveIndex=5, x = 71.20, y = 40.32, text = "Feed N'ala {progress}."},
      { kind = "OBJECTIVE", questName = "Re-Hydra-ted", questIDs = {92866}, showAfter = 2, objectiveIndex=3, x = 71.26, y = 41.10, text = "Feed F'liks {progress}."},
      { kind = "TURNIN", questName = "Re-Hydra-ted", questIDs = {92866}, x = 69.54, y = 50.57},
    },
  },
  {
    mapID = {2413},
    title = "A Palette of Feelings Part 1",
    segments = {
      { kind = "PICKUP", questName = "Dusk Among Pigments", questIDs = {92694}, x = 70.53, y = 51.19},
      { kind = "OBJECTIVE", questName = "Dusk Among Pigments", questIDs = {92694}, objectiveIndex=1, x = 69.78, y = 50.52, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "Dusk Among Pigments", questIDs = {92694}, x = 74.03, y = 53.07},
    },
  },
  {
    mapID = {2413},
    title = "A Palette of Feelings Part 2",
    segments = {
      { kind = "PICKUP", questName = "The Stroke of Storms", questIDs = {92695}, x = 74.03, y = 53.07},
      { kind = "OBJECTIVE", questName = "The Stroke of Storms", questIDs = {92695}, objectiveIndex=1, x = 72.28, y = 55.68, text = "Click on the visionstone {progress}."},
      { kind = "OBJECTIVE", questName = "The Stroke of Storms", questIDs = {92695}, radius = 60, showAfter = 2, objectiveIndex=2, x = 72.54, y = 54.44, text = "Kill enemies and click on globules {progress}."},
      { kind = "OBJECTIVE", questName = "The Stroke of Storms", questIDs = {92695}, showAfter = 3, objectiveIndex=3, x = 72.28, y = 55.68, text = "Click on the visionstone {progress}."},
      { kind = "TURNIN", questName = "The Stroke of Storms", questIDs = {92695}, x = 72.38, y = 55.69},
    },
  },
  {
    mapID = {2413},
    title = "A Palette of Feelings Part 3",
    segments = {
      { kind = "PICKUP", questName = "Colors Born Anew", questIDs = {92696}, x = 72.38, y = 55.69},
      { kind = "OBJECTIVE", questName = "Colors Born Anew", questIDs = {92696}, radius = 60, objectiveIndex=1, x = 72.21, y = 57.58, text = "Kill and loot mushrooms for pigments {progress}."},
      { kind = "OBJECTIVE", questName = "Colors Born Anew", questIDs = {92696}, radius = 60, objectiveIndex=2, x = 72.21, y = 57.58, text = "Click on plants and drag the root away to destroy them {progress}."},
      { kind = "TURNIN", questName = "Colors Born Anew", questIDs = {92696}, x = 72.38, y = 55.69},
    },
  },
  {
    mapID = {2413},
    title = "A Palette of Feelings Part 4",
    segments = {
      { kind = "PICKUP", questName = "Hues of Tomorrow", questIDs = {92697}, x = 72.38, y = 55.69},
      { kind = "OBJECTIVE", questName = "Hues of Tomorrow", questIDs = {92697}, objectiveIndex=1, x = 74.00, y = 53.21, text = "Click on the cauldron to make paintings {progress}."},
      { kind = "TURNIN", questName = "Hues of Tomorrow", questIDs = {92697}, x = 74.00, y = 53.16},
      { kind = "NOTE", text = "Use the controls to move the brush across the canvas. You need to make a path that hits all cauldrons on the canvas, and you can't backtrack or cross over black stones." },
    },
  },
  {
    mapID = {2413},
    title = "The Grudge Pit Part 1",
    segments = {
      { kind = "PICKUP", questName = "Be Grudge You", questIDs = {90615}, x = 70.33, y = 52.90},
      { kind = "OBJECTIVE", questName = "Be Grudge You", questIDs = {90615}, x = 71.77, y = 64.06, text = "Turn in {progress}."},
      { kind = "TURNIN", questName = "Be Grudge You", questIDs = {90615}, x = 71.77, y = 64.06},
      { kind = "PICKUP", questName = "You Strong?", showAfter = 3, questIDs = {90616}, x = 71.77, y = 64.06},
      { kind = "OBJECTIVE", questName = "You Strong?", questIDs = {90616}, radius = 50, x = 71.60, y = 66.02, text = "Kill enemies to fill the bar {progress}."},
      { kind = "TURNIN", questName = "You Strong?", questIDs = {90616}, x = 71.77, y = 64.06},
    },
  },
  {
    title = "The Grudge Pit Part 2",
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
    title = "The Grudge Pit Part 3",
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
    title = "The Grudge Pit Part 4",
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
    title = "The Grudge Pit Part 5",
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
    title = "The Grudge Pit Part 6",
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
    title = "The Grudge Pit Part 7",
    mapID = {2413},
    segments = {
      { kind = "PICKUP", questName = "Not-Yet Defeated Champions", questIDs = {90622}, x = 71.77, y = 64.06 },
      { kind = "OBJECTIVE", questName = "Not-Yet Defeated Champions", objectiveIndex=2, radius = 12, questIDs = {90622}, x = 72.29, y = 65.19, text = "Follow the arrow {progress}." },
      { kind = "OBJECTIVE", questName = "Not-Yet Defeated Champions", objectiveIndex=4, showAfter = 2, radius = 20, questIDs = {90622}, x = 71.19, y = 65.77, text = "Defeat the enemies {progress}." },
      { kind = "TURNIN", questName = "Not-Yet Defeated Champions", questIDs = {90622}, x = 71.77, y = 64.06},
    },
  },  
  {
    title = "Work In Progress!",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "Most of the Harandar Sojourner questlines have been added, but a handful are still missing and will be added in a future update. For now I wanted to prioritize any chains that had actual use for leveling, and then focus on Sojourner for the other zones." },
      { kind = "OBJECTIVE", questName = "Intro", text = "'Trials of the Shul'ka', as well as 'The Greenspeaker's Vigil', are both locked behind main campaign progress. Since the Harandar campaign is VERY slow and should never be considered for alt leveling, this also renders them useless for actual leveling." },
    },
  },
}

FTA.Modules[M.id] = M