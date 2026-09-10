local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "LEVEL110_PH"
M.title = "Leveling From 1-10"
M.defaultRadius = 5

M.routeId    = "LEVEL110_TEMP"
M.routeTitle = "Levels 1-10"
M.routeOrder = 29

M.moduleOrder = 10
M.nextModuleId = "TBD" 

M.steps = {
    {
    title = "Work In Progress!",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "I'm still in the process of developing the 1-80 sections of the addon, and I hope to have them finished for both factions before the release of Patch 12.1." },
      { kind = "OBJECTIVE", questName = "Intro", text = "However, Levels 1-10 are a bit of a weird case, and I'm unsure exactly how I'll approach this section of the addon." },
      { kind = "OBJECTIVE", questName = "Intro", text = "I've added a few sections below which explain some of the different methods for leveling from 1-10, and why it would be a bit tricky to integrate them all into Follow The Arrow." },
      { kind = "NOTE", text = "Use the Next and Prev buttons to navigate through this section of the addon." },
    },
  },
  {
    title = "Allied Races",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "If you create an Allied Race character, they already start at Level 10, rendering 1-10 moot." },
      { kind = "OBJECTIVE", questName = "Intro", text = "New players don't have instant access to Allied Races, but they have a separate way to bypass 1-10, discussed in the next section. This means the vast majority of players will never even engage with this level range." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Although not everyone will want to level as an Allied Race, they tend to be fairly popular options regardless, as many of their racial abilities are tuned well. This means there's usually no point in creating a non-Allied Race once you have it as an option." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The unlock process for many of these races is extremely simple, so even fresh accounts will be able to access Allied Races with little investment. In the future I will likely add a section to the addon which guides you through the different racial unlock questlines." },
    },
  },
  {
    title = "Fresh Account Housing Skip",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "If you're playing on a new account (or one that never bothered to unlock housing), you have access to a permanent level 1-10 skip, even on non-Allied Races." },
      { kind = "OBJECTIVE", questName = "Intro", text = "When creating a Level 1 character, pick Exile's Reach. After exiting the boat (the quests take under 2 minutes to finish), you're presented with an option to skip Exile's Reach entirely, and this sets your character's level to 10." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The game directs you to complete the Housing tutorial, but you can just leave the area, abandon the quest, and repeat this process infinitely on any fresh level 1 character." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Currently this option goes away forever if you complete the Housing tutorial, so many players don't even realize it's a thing. It's also unfortunate that this infinite 1-10 skip, while useful, requires you to never engage with a core feature of the game." },
      { kind = "OBJECTIVE", questName = "Intro", text = "I'm hoping that the option going away is just a bug, and that Blizzard will eventually make this a default option for all accounts. If that happens, 1-10 will effectively cease to exist as an actual level range that you need to complete. While I would prefer for this to not be the case, it's a far better option than the current system, which is unintuitive and rewards players for ignoring Housing entirely." },
    },
  },
  {
    title = "The Speedrun Options",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "If you don't want to level an Allied Race, but you don't have access to the skip, you have two options. You can either level through Exile's Reach the normal way, or you can choose your selected race's original starting zone." },
      { kind = "OBJECTIVE", questName = "Intro", text = "I'll touch upon Exile's Reach in the next section. As for the original starting zones, most of them are REALLY slow. Some, like Goblin/Worgen/Panda keep you locked inside until roughly Level 15. There are some glitches that you can use to escape these zones, but they are very complicated and not realistically replicable by new players." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The Worgen and Panda starting zones are not terrible options for Levels 1-5, but they are VASTLY slower from that point onwards. Since you can't leave early, you're forced into an extremely inefficient path all the way to Level 15, making Exile's Reach a better option." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Most other races can leave their starting zones whenever they want, and the initial quests will only get you to roughly level 6, provided you complete everything. This is a better option, but the lack of flying mounts means that 5-10 will feel incredibly slow, especially if you're forced to start in an isolated area of the world, such as with Night Elves or Tauren." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The end result is that Exile's Reach ends up being faster on average for ALMOST every single race, with the exception of Human and Undead. Human starts in Elwynn Forest, which is the first zone in my 10-80 route. Since it can be started as early as Level 5, Humans can complete their starting zone and immediately jump into the efficient leveling path. Undead players can do the same thing on Horde, as that route begins with Silverpine Forest, which is just south of the Undead starting zone." },
      { kind = "OBJECTIVE", questName = "Intro", text = "I will consider making routes specifically for Human/Undead, since they were the races I selected for my 1-80 speedruns prior to the Housing skip being added in Midnight. However, I feel it would be pointless to even add routes for any other races, as they are better off selecting Exile's Reach, and that's assuming the user doesn't have access to the skip." },
    },
  },
  {
    title = "Exile's Reach",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "So, assuming you don't want to play an Allied Race, you don't have the skip, and you don't want to level a Human or an Undead, Exile's Reach is your only real option. Here's the problem: this zone is ASS." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Exile's Reach has always been a fairly slow way to level, which is understandable, seeing as it's meant to be a tutorial. Unfortunately, Blizzard 'Improved' Exile's Reach with the launch of Midnight, and this 'Improvement' somehow made it SIGNIFICANTLY WORSE." },
      { kind = "OBJECTIVE", questName = "Intro", text = "It still fumbles when it comes to introducing players to any meaningful MMO mechanics, so you'll still need to do a lot of external research if you want to fully understand the game. Now it just takes a bit longer, and the story is completely mangled, so there's no real reason to care about it." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Despite these flaws, it's still a fairly compact and streamlined questing experience that gets you all the way from 1-10, so it will usually outpace the speed of non Human/Undead starts." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The problem with this is that Exile's Reach is almost entirely linear and does an excessive amount of hand holding. There would be virtually 0 benefit to adding a Follow The Arrow route for this zone, as the few players who even choose to level here would either be brand new (and wouldn't even know about my addon) or they would be able to easily figure out where to go just by following the in-game instructions." },
      { kind = "OBJECTIVE", questName = "Intro", text = "That said, even if the zone itself is easy, developing a route for it would still require a lot of time investment on my part, which I could instead put towards adding other interesting features. As such, I don't feel that it would be worth it to add an Exile's Reach path to this addon, even once the Ally/Horde 10-80 sections are complete." },
    },
  },
  {
    title = "DKs, DHs, and Evokers",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "If you're choosing to level as a DH/DK/Evoker, you will start at Level 8 and be forced to complete your class starting zone, regardless of your racial choice." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The exception to this is any Allied Race DKs (or Panda DKs), who start off at Level 10 and bypass their starting zone, or Void Elf DHs." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Since there is no realistic way to bypass these zones for players that want to try these specific Race/Class combos, I will probably add routes to FTA for the DH/Evoker starting zones at a minimum. The DK starting zone is pretty old and janky, so TBD on if I care enough to add that." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Unfortunately these zones do suffer from the same issue as Goblin/Worgen/Panda, where you're locked in until around Level 15, and they are slower than the speedrun route. That said, once you exit your locked starting zone you can just jump straight into the 10-80 routes without any issues." },
    },
  },
}

FTA.Modules[M.id] = M