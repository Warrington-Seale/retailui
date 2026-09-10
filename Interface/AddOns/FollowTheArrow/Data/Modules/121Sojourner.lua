local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "12.1_SIDEQUEST_ROUTE"
M.title = "Coiled Isle Sidequests"
M.defaultRadius = 5

M.routeId    = "MIDNIGHT_ENDGAME"
M.routeTitle = "Midnight Endgame"
M.routeOrder = 2

M.moduleOrder = 20
M.nextModuleId = "TBD" 

M.steps = {
  {
    title = "Introduction",
    segments = {
      { kind = "MANUAL", key = "12.1sq_intro_1", text = "This is the guide for the Level 90 Sidequests on the Coiled Isle. Specifically, this guide will direct you to complete all side quests that are part of the 'Snake Charmed, I'm Sure' Achievement, which tracks completion credit for side quests in this zone."},
      { kind = "MANUAL", key = "12.1sq_intro_2", text = "This guide is ONLY for Level 90s and can not be used for leveling. If you're looking for my leveling guides, click on the drop down list in the top right of this panel and select one of the other guides."},
      { kind = "MANUAL", key = "12.1sq_intro_3", text = "This guide includes multiple steps that require you to manually check a box in order to flag it as complete. This is used for certain instructions that can't be easily tracked through in-game flags, or important explanatory dialogue like this."},
      { kind = "MANUAL", key = "12.1sq_intro_4", text = "If you accidentally checked off a step and want to re-read it, go into the settings and click the 'Reset Optional Steps' button."},
      { kind = "MANUAL", key = "12.1sq_intro_6", text = "If you understand and are ready to proceed to the first step of the guide, check off all of the boxes on the right side of the main window. You can also manually skip between different steps by using the Next and Prev buttons below."},

    },
  },
  {
    mapID = {2512},
    title = "Tokka's Crew Part 1",
    segments = {
      { kind = "PICKUP", questName = "Venom Fishing: Proof is in the Ooze", questIDs = {96110}, x = 57.17, y = 48.56},
      { kind = "OBJECTIVE", questName = "Venom Fishing: Proof is in the Ooze", radius = 5, objectiveIndex = 1, questIDs = {96110}, x = 51.64, y = 49.77, text = "Speak to Second Mate Sluggs and learn fishing {progress}." },
      { kind = "OBJECTIVE", questName = "Venom Fishing: Proof is in the Ooze", radius = 30, objectiveIndex = 2, showAfter = 2, questIDs = {96110}, x = 47.89, y = 49.88, text = "Fish in the river for Venom-Cursed Killifish {progress}." },
      { kind = "TURNIN", questName = "Venom Fishing: Proof is in the Ooze", questIDs = {96110}, radius = 5, x = 57.17, y = 48.56},
      { kind = "NOTE", text = "Yes, fishing is actually required. If you don't want to do this, just press the Next button until you reach Part 1 of the next questline." },
    },
  },
  {
    mapID = {2512},
    title = "Tokka's Crew Part 2",
    segments = {
      { kind = "PICKUP", questName = "Venom Fishing: My Second-Best", questIDs = {98343}, x = 57.17, y = 48.56},
      { kind = "OBJECTIVE", questName = "Venom Fishing: My Second-Best", radius = 5, objectiveIndex = 1, questIDs = {98343}, x = 51.64, y = 49.77, text = "Follow the arrow {progress}." },
      { kind = "TURNIN", questName = "Venom Fishing: My Second-Best", questIDs = {98343}, radius = 5, x = 51.64, y = 49.77},
    },
  },
  {
    mapID = {2512},
    title = "Tokka's Crew Part 3",
    segments = {
      { kind = "PICKUP", questName = "A Request from the Captain", questIDs = {98414}, x = 51.64, y = 49.77},
      { kind = "OBJECTIVE", questName = "A Request from the Captain", radius = 5, objectiveIndex = 1, questIDs = {98414}, x = 57.17, y = 48.56, text = "Turn in {progress}." },
      { kind = "TURNIN", questName = "A Request from the Captain", questIDs = {98414}, radius = 5, x = 57.17, y = 48.56},
    },
  },
  {
    mapID = {2512},
    title = "Tokka's Crew Part 4",
    segments = {
      { kind = "PICKUP", questName = "Venom Fishing: Shell of Yourself", questIDs = {96111}, x = 57.17, y = 48.56},
      { kind = "OBJECTIVE", questName = "Venom Fishing: Shell of Yourself", radius = 190, objectiveIndex = 1, questIDs = {96111}, x = 60.81, y = 80.20, text = "Collect wood debris {progress}." },
      { kind = "OBJECTIVE", questName = "Venom Fishing: Shell of Yourself", radius = 5, objectiveIndex = 2, showAfter = 2, questIDs = {96111}, x = 54.69, y = 78.73, text = "Create a wood pile {progress}." },
      { kind = "OBJECTIVE", questName = "Venom Fishing: Shell of Yourself", radius = 10, objectiveIndex = 4, showAfter = 3, questIDs = {96111}, x = 54.69, y = 78.73, text = "Kill and loot Master Grenadier Birdie {progress}." },
      { kind = "TURNIN", questName = "Venom Fishing: Shell of Yourself", questIDs = {96111}, radius = 5, x = 57.17, y = 48.56},
      { kind = "NOTE", text = "Click on the wood pile a second time to summon Master Grenadier Birdie." },
      { kind = "NOTE", text = "There are supposed to be two additional quests in this chain, but I couldn't find them on the PTR. Either it's timegated, or I'm just blind. Once I manage to get these quests done on live servers, they'll be included in the addon." },
    },
  },
  --{
    --mapID = {2512},
    --title = "Don't be Afrayed Part 1",
    --segments = {
      --{ kind = "PICKUP", questName = "Ghosts of the Ring", radius = 8, questIDs = {93841}, x = 58.56, y = 47.24},
      --{ kind = "OBJECTIVE", questName = "Ghosts of the Ring", radius = 5, objectiveIndex = 1, questIDs = {93841}, x = 51.64, y = 49.77, text = "Turn in {progress}." },
      --{ kind = "TURNIN", questName = "Ghosts of the Ring", questIDs = {93841}, radius = 15, x = 66.04, y = 53.33},
      --{ kind = "NOTE", text = "Both the questgiver and the turn-in NPC have small patrol ranges." },
    --},
  --},
  --{
   -- mapID = {2512},
   -- title = "Don't be Afrayed Part 2",
    --segments = {
      --{ kind = "PICKUP", questName = "Bloom and Fade", radius = 15, questIDs = {92932}, x = 66.04, y = 53.33},
      --{ kind = "PICKUP", questName = "Ectoplasmic Extractions", radius = 15, questIDs = {92933}, x = 66.04, y = 53.33},
      --{ kind = "OBJECTIVE", questName = "Bloom and Fade", radius = 8, objectiveIndex = 1, questIDs = {92933}, x = 64.69, y = 59.19, text = "Help First Mate Nama {progress}." },
      --{ kind = "OBJECTIVE", questName = "Ectoplasmic Extractions", radius = 140, objectiveIndex = 2, showAfter = 3, questIDs = {92933}, x = 65.45, y = 61.58, text = "Free Lost Tortollans {progress}." },
      --{ kind = "TURNIN", questName = "Bloom and Fade", questIDs = {92932}, radius = 5, x = 67.47, y = 62.25},
      --{ kind = "TURNIN", questName = "Ectoplasmic Extractions", questIDs = {92933}, radius = 5, x = 67.46, y = 62.31},
    --},
  --},
  {
    title = "Work In Progress!",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "The remaining sidequests are still a work in progress, as I ran into some issues testing them on the PTR." },
      { kind = "OBJECTIVE", questName = "Intro", text = "These questlines should be added within a day of the patch going live." },
    },
  },
}

FTA.Modules[M.id] = M