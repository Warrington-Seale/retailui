local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "PATCH1207_PH"
M.title = "12.0.7 Leveling Updates"
M.defaultRadius = 5

M.routeId    = "TEMP1207"
M.routeTitle = "What's New?"
M.routeOrder = 1

M.moduleOrder = 10
M.nextModuleId = "TBD" 

M.steps = {
    {
    title = "What has changed as of 12.0.7?",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "Many of you are likely aware that 12.0.7 brought along a lot of buffs to different sources of experience. The addon has already been fully updated to account for these changes, and they are integrated directly into the original Alt 80-90 Route." },
      --{ kind = "OBJECTIVE", questName = "Intro", text = "Turbulent Timeways is also active starting today, and it runs until August 11th. Dungeon spamming is highly inefficient, but it is worth running four Timewalking dungeons to get a 30% XP buff. This is discussed further down in this section of the addon, and it's mentioned within the guide itself." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Very little has been actively removed from the original route, I've just added new activities to it and streamlined some of the steps. The nice thing about these changes is that many of them directly buff existing parts of the route, and the new things are able to slot in very cleanly." },
      { kind = "OBJECTIVE", questName = "Intro", text = "I recently managed to get a 10-90 time of 3 Hours and 16 Minutes, and the 80-90 section (which follows the new route) was done in only 1 Hour and 16 Minutes. The full footage of the run has been uploaded to my YouTube channel, and you can click on the embedded thumbnail below to get a copy + pasteable version of the URL if you want to watch it yourself." },
      { kind = "VIDEO_EMBED", url = "https://youtu.be/Hn8SceLFago", texture = "Interface\\AddOns\\FollowTheArrow\\Images\\1090DHSR.tga", width = 320, height = 180, tooltipTitle = "Watch my new 10-90 Speedrun!" },
      { kind = "NOTE", text = "Use the Next and Prev buttons to navigate through this section of the addon." },
    },
  },
  {
    title = "What has gotten buffed?",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "The following types of quests received buffs: Delver's Call, Dungeon Quests, Prey, and Weeklies." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Delver's Call buffs are by far the most significant. I've seen people downplay these buffs because the 'percentage increase' is lower, but Delver's Call quests were ALREADY a large source of XP. They are going from ~70k XP to 124k XP, and this is values with no other XP modifiers at level 80. This is a rather significant buff, and will single handedly shave off a full level from the end of the current Alt 80-90 route." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Dungeon quest buffs are somehow the lowest, which is surprising since normal dungeons were already an exceptionally poor way to level in Midnight. The values went from ~24k to 54k. This is trivial considering how grossly inefficient this form of leveling is, and you still will never run Normal dungeons." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The buffs to Prey and Weeklies are a bit more interesting, as both now give 101k XP, whereas before they gave ~15k XP, which is the value of a regular quest. This is still lower than post-buff Delver's Call, but it's larger than pre-buff Delver's Call, which makes them enticing enough to include at multiple points throughout the route." },
    },
  },
  {
    title = "Delver's Call",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "Just to state the obvious, running Delves and completing Delver's Call quests was ALREADY the best way to level, and it was a core part of my alt route. It got BUFFED. I really shouldn't have to point out that, yes, it will still be the fastest way to level in 12.0.7, but somehow this is an actual question I have received more than once." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The only major direct change as a result of these buffs is that all delves, even notoriously slow ones like Parhelion Plaza, are worth completing. Previously it could be argued that skipping some delves was worthwhile if they had an incredibly bad variant, but with the new values it will always be worth it to complete a delve for the Delver's Call quest." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Another interesting thing to consider with these buffs is that it actually compresses the rest of the alt route. When optimizing speedleveling, you start by looking at the most efficient sources and build a core path around that. Some activities, such as the Eversong/ZA Campaigns or a few Voidstorm sidequests, end up becoming more efficient because they can be easily included in a route that paths through all of the delves." },
      { kind = "OBJECTIVE", questName = "Intro", text = "On the other hand, some activities that might seem passable in a vacuum end up being dropped from efficient leveling routes if they don't synergize well with the other efficient sources of XP. Maybe a questline is somewhat efficient, but it's located in a far corner of the map away from anything else. We then need to factor in the travel time required to reach it and return back, which ends up lowering its relative efficiency, and this causes it to be dropped from consideration." },
      { kind = "OBJECTIVE", questName = "Intro", text = "I mention this because the initial Alt 80-90 Route was already structured as 'Delve World Tour until ~82, fuck around until ~88, skip final two levels with crafting + turn-ins'. These buffs push that threshold down to 'fuck around until ~85', which means some quests that were already in the 80-90 route will no longer make the cut for speedleveling in 12.0.7. For anything NEW trying to enter the route in 12.0.7, the bar is now EVEN HIGHER." },
    },
  },
  {
    title = "Weekly Quests",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "Blizzard's definition of 'Weekly Quests' was a bit vague, but from what I've been able to find during testing, it includes the following: Saltheril's Soiree, Legends of the Haranir, Abundance, Void Assaults, Void Invasions, and Hope in the Darkest Corners." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Hope in the Darkest Corners is a quest that you pick up in Silvermoon City. All it requires you to do is complete 10 Delves or World Quests. Since we're already doing this now as part of the route, this buff effectively translates into 100k free experience for no added work." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Void Assaults have received buffs, but I do not believe they are worth completing. Refer to what I said in the Delver's Call section about the route being compressed. The XP values from these quests may be slightly higher than normal, but they still take a decent amount of time to complete and have 0 synergy with other methods. It may not be a terrible way to level, but the same could be said about many side questlines that don't make it into the route." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The Invasion Points are also not included in the route, but they're atleast much closer to being viable. The primary issue with these zones is 1) extensive RNG depending on which objectives are active and 2) the fact that you need to complete all of the major weekly quests for them to approach viability. This means you would need to dedicate a large portion of your leveling to these zones for them to be worthwhile, and this will usually cause you to overshoot or miss out on far more valuable options. This method looks solid in a vacuum, but is difficult to integrate in practice. If you have a low Warband XP Buff it could be considered as an alternative to Eversong/Zul'Aman sidequests, otherwise it should be ignored." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The other quests have all been included, and the following sections will go into more detail on how each of them has been integrated." },
    },
  },
  {
    title = "Saltheril's Soiree",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "I was already considering adding Saltheril's Soiree to the alt route, as it has considerable overlap with the existing quests that I've included. With the changes, it is now a no-brainer addition to the guide." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The most important thing to recognize with Saltheril's Soiree is that only the 'Fortify the Runestones' weekly quest has been buffed. It now gives ~100k XP, like the other weeklies, which means it is ALWAYS worth completing this specific quest." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The only thing you ACTUALLY need to do in order to complete this quest is to tag the final boss of a runestone assault before it dies. Participation in any of the leadup activities is entirely optional. This means it could be ~5 seconds of effort for 100k XP, minus travel time, which is obviously INCREDIBLY fast." },
      { kind = "OBJECTIVE", questName = "Intro", text = "One issue with this quest is that the runestone location will randomly alternate after each assault is finished, which means it's basically impossible for me to give exact directions within the addon. In theory, there are a few runestone locations that are very close to the route, and if everything lines up you could finish the quest with next to no detour. In practice you could never control this, and it would be impossible for me to dynamically recommend detours for this quest depending on where it spawns for your specific server." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Additionally, while the other 'favor' quests at the Soiree have not been buffed, they still give a full quest's worth of XP, and many are extremely easy to complete (some even DIRECTLY overlap the existing route). This means they will still be worthwhile to complete, EXCEPT for the fact that a random selection of them will appear with each weekly reset." },
      { kind = "OBJECTIVE", questName = "Intro", text = "To top it off, players must manually select which factions to spend their favor on, which causes different quests to be unlocked for each person. In my experience, The Blood Knights are the best faction for speedrun quests, but choosing this will lock you out of the ability to earn cosmetics for another faction that week, and I don't want to trick people into doing that without realizing." },
      { kind = "OBJECTIVE", questName = "Intro", text = "As such, the implementation in Follow The Arrow for Saltheril's Soiree is currently very freeform. I'll direct you there to pick up your weekly quests, and I'll provide a bit of info to explain these issues, but you will need to adapt to your surroundings and find the best time to make a detour for the runestone." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The quests for Saltheril's Soiree are turned in during the final section, and I've adapted the routing slightly to account for this. You'll now set your hearthstone to Fairbreeze Village at an earlier step, and after turning in quests in Zul'Aman, you'll use your Hearthstone to teleport there and hand in Saltheril's Soiree quests before returning to Silvermoon City." },
    },
  },
  {
    title = "Abundance",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "Abundance is pretty straightforward. The weekly gives 100k XP, the event takes a fixed amount of time (3 minutes) to complete, and none of the mobs you kill grant experience. Honestly, it's not the BEST thing ever, especially since the mobs don't give XP, but currently it's efficient enough to be worth including in the route." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The guide will direct you to complete the Abundance zone in Voidstorm, but you can technically complete this quest at any of them. This just happens to fit cleanly into the Voidstorm route, so I've included it there." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Unfortunately you can't do anything to speed up Abundance, as you need to finish the entire 3 minute scenario to get quest credit. Reaching the score threshhold and leaving early did not seem to work when I tested it." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The downside of this quest is that, if you fail to reach the score threshold in a single run, you are forced to do the entire 3 minute scenario again. If this happens then Abundance is no longer efficient, but thankfully I've been able to consistently one-shot the scenario in Voidstorm and Zul'Aman. The other zones gave me a bit more trouble." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The Abundance weekly will be turned in at the very end, just like Delver's Call quests." },
    },
  },
  {
    title = "Legends of the Haranir",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "Legends of the Haranir is extremely fast, but there are a few quirks to this weekly quest that might cause results to vary for different players." },
      { kind = "OBJECTIVE", questName = "Intro", text = "For starters, there is timegating on the different relics available for selection. You're limited to a specific set of five relics, and until all of them have been completed you are unable to select relics six or seven. Additionally, after you complete a relic you are unable to complete it again, and you must choose an uncompleted option." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The unlock process can be brute forced if you have enough alts, as each of them can select a different relic in the same week. Once each relic has been completed a single time, all future characters will be able to select whatever relic they want, allowing you to pick the fastest one each time on new characters." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The fastest relic BY FAR is Aln'hara's Bloom, as it can be done in under 2 minutes. If you have this as an uncompleted option, or if you have already unlocked the ability to pick any relic, this is the one you should select for 80-90 leveling." },
      { kind = "OBJECTIVE", questName = "Intro", text = "With that being said, even if you aren't able to select the Bloom, it's still worth doing Legends of the Haranir while leveling, as a lot of other quests are still fast. You'll also likely want to unlock the ability to pick any relic eventually, so it's more efficient to chip away at it as you level alts." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Currently the addon just directs you to pick up your weekly quest, but it doesn't give further instructions beyond that. I didn't want to risk including a path for Aln'hara's Bloom, only to confuse people who were unable to select it. I'm working on some more advanced logic to handle situations like this and dynamically update the guide's recommendations, but that won't be included until a future update." },
    },
  },
  {
    title = "Prey",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "Prey is the most peculiar of the systems being buffed; the values are the same as weekly quests (~100k), and it's tied to each individual Prey HUNT rather than an overarching weekly quest." },
      { kind = "OBJECTIVE", questName = "Intro", text = "In a vacuum, Prey would seem to be really inefficient. It takes multiple minutes to complete a Prey hunt even if you're really lucky, and potentially ~5+ minutes if you get unlucky with trap spawns. There's also heavy variance when it comes to travel time required to the different objectives." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Thankfully Prey doesn't exist in a vacuum, so it ends up escaping the fate of other systems like Void Assaults. If you choose zones that are already in the alt route (anything except Harandar), the objectives will often directly overlap with the existing route, or will be a minor detour." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The biggest factor to consider for Prey is the random ambushes, which occur fairly often as you do standard questing. These ambushes are trivial to deal with alongside most open world pulls, and in some cases you can complete the entire Prey hunt simply by fending off multiple ambushes over a long stretch of questing." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The end result of this is that Prey becomes really fast when you consider how much time you ACTUALLY need to spend in order to work towards the final objective. If you view it as just the time required to complete the final showdown, it often ends up being ~1-2 minutes for 100k XP, which is very efficient. Finishing a hunt also spawns a portal back to Silvermoon, which COULD be useful for speedrun routing, though I didn't find it to be necessary in my recent run." },
      { kind = "OBJECTIVE", questName = "Intro", text = "As for the turn-in, the Prey quest is a click-to-complete quest which is finished automatically, provided you have some form of auto turn-in. However, if you disable the auto turn-in before engaging the final boss, and you untrack the quest before turning the auto turn-in back on, you can save the final Prey quest completion for the end segment alongside Delver's Call quests. This is a bit too advanced to be included in the actual guide, but I wanted to make sure I explained it somewhere." },
      { kind = "OBJECTIVE", questName = "Intro", text = "However, you will always need to turn in your existing Prey quest before grabbing another, so you can only perform this trick a single time towards the end of your leveling run." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Generally speaking, most players will find it worthwhile to grab a Prey quest before doing activities in Voidstorm, and then again before doing activities in Eversong. If you have high XP modifiers, you may not even reach the Zul'Aman sections of the guide, but if you do, it will be worthwhile to grab another Prey quest before you head out. This will be included in the guide routing." },
      { kind = "OBJECTIVE", questName = "Intro", text = "As is the case for many of the aforementioned activities, there is way too much variance (different prey enemies, different world quest objectives, trap locations, showdown locations, etc) in each Prey hunt, so the addon itself can not tell you what to do. All I can do is point you towards the table in Silvermoon to grab your Prey quest, and then put a reminder at the end of the zone to finish it before you leave. You will need to do a bit of thinking for yourself here." },
    },
  },
  --{
   -- title = "Turbulent Timeways",
  --  segments = {
  --    { kind = "OBJECTIVE", questName = "Intro", text = "Although this isn't a 'new' feature, Turbulent Timeways has returned in 12.0.7, and it will be active until August 11th." },
  --    { kind = "OBJECTIVE", questName = "Intro", text = "Turbulent Timeways is a special event where you get a stacking XP buff from completing Timewalking Dungeons. This buff caps out at 4 stacks. The first 3 dungeons you complete grant you a stacking 5% XP bonus, and completing the 4th dungeon gives you a new buff that provides 30% XP. Any dungeons after this simply extend the 30% buff." },
  --    { kind = "OBJECTIVE", questName = "Intro", text = "The key thing people miss about this buff is that it affects ALL forms of experience, NOT just Timewalking Dungeons. While a 30% XP buff is obviously extremely powerful, and it will be worthwhile to run 4 dungeons to obtain this, you don't need to continue running Timewalking after getting the buff." },
  --    { kind = "OBJECTIVE", questName = "Intro", text = "Since the 30% XP buff lasts for multiple hours, you can obtain it and switch over to the standard alt leveling methods (such as Delves), and this will be SIGNIFICANTLY faster than dungeons." },
   --   { kind = "OBJECTIVE", questName = "Intro", text = "Timewalking Leveling (via dungeon spamming) is not fast, sorry. I've proven this countless times over the years (even before it got heavily nerfed in TWW), and I plan to prove it yet again in a video that I'll post a few days from now." },
   --   { kind = "OBJECTIVE", questName = "Intro", text = "People often ask me to explain 'why' it's slow, but the reason is simple: it doesn't provide enough experience relative to the time investment. It's also very RNG depending on your groups, but even with extremely optimal groups it will fall behind generally efficient questing. This is not a case of 'questing speedruns are faster than timewalking', countless normal people have done the same tests and confirmed to me that my routes, even when done at a regular pace, are faster for them than Timewalking." },
  --    { kind = "OBJECTIVE", questName = "Intro", text = "Whenever this is demonstrated to detractors, the inevitable fallback is 'well, your route can't be brain-off followed, timewalking can', and that's an impossible position to argue against. I personally feel that my routes are easy enough to follow, especially with the inclusion of Follow The Arrow, but if someone wants to claim that it's not faster for THEM, I can't possibly say that they are wrong. I can only state objective facts." },
  --    { kind = "OBJECTIVE", questName = "Intro", text = "To be clear, if you ENJOY Timewalking more, then use it to level your characters. More power to you. 'Fast' leveling isn't always what matters if you're miserable. It just gets exhausting having this debate with people who clearly prefer Timewalking and want me to tell them 'yes, it's a fast way to level' when it simply isn't. It's not BAD, but it's not fast. At the very least, it is more efficient than Normal dungeons by a large margin." },
  --    { kind = "OBJECTIVE", questName = "Intro", text = "Also, if you think that I am wrong, I would be open to being corrected on this point. I have said for years that if people provide video proof to me of a speedrun primarily comprised of Timewalking spam that is faster than my routes, I will eat my words. Years ago the closest proof I was provided was boost runs with Timewalking Twink characters that came CLOSE to my runs in specific level ranges. Even then, it fell off hard at higher levels, and this method is dead as of the nerfs in The War Within. The offer stands, I will eat my words if someone beats my times with Timewalking spam, but I know for a fact that it is mathematically impossible." },
  --    { kind = "OBJECTIVE", questName = "Intro", text = "Technically speaking, the fastest 'speedrun' method for using this buff in full 1-90 runs is to obtain it early, around levels 10-30, and then carry it over into the entire rest of the process. If it starts running out, you simply run one additional dungeon to extend the duration. Even though this is extra fast when done at those lower levels (since dungeons are relatively more efficient at that stage), it will still be worthwile to run 4 dungeons for this buff if you're starting at Level 80." },
  --    { kind = "OBJECTIVE", questName = "Intro", text = "With all of that being said, I have added a few sections to the guide which explain when you should run Timewalking dungeons, as well as how to adapt the final turn-in section. The route itself is unchanged, the fastest activities are still the fastest with or without a blanket 30% buff." },
 --   },
 -- },
  {
    title = "Addon Update Plans",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "As previously mentioned, the Alt 80-90 Route has already received an initial pass to include all of the necessary changes for 12.0.7. This reflects the route used in my recent 1 Hour 38 Minute run, and should help direct players along the right path." },
      { kind = "OBJECTIVE", questName = "Intro", text = "However, routes change all the time, and it's entirely possible that a few minor optimizations were missed during my initial testing. I will continue to complete runs and update the route if I find anything new." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Also, while I acknowledge that some of the implementations for these new systems is a bit rudimentary, a lot of them are VASTLY more complex than my current logic can handle. The existing route is built upon a fairly strict chain of quests. While it can adapt a bit if players have already completed certain portions, I do expect everyone to have access to the same general quest progression." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Activities like Saltheril's Soiree, Legends of the Haranir, and Prey introduce a ton of variables that the addon wasn't originally designed to account for. A lot of these systems, like Prey, also use obscure objective tracking that I can't easily pull information out of, making it nearly impossible for me to display the player's progress within the addon and provide accurate directions." },
      { kind = "OBJECTIVE", questName = "Intro", text = "I'm looking into ways to improve the addon's logic for systems like this, and I hope to roll some of them out in the coming updates. However, certain hurdles are likely impossible to overcome simply due to technical limitations put in place by Blizzard." },
    },
  },
}

FTA.Modules[M.id] = M