local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "MIDNIGHT_CAMPAIGN_BONUS"
M.title = "Adventure Mode"
M.defaultRadius = 5

M.routeId    = "MIDNIGHT_CAMPAIGN"
M.routeTitle = "Midnight Campaign"
M.routeOrder = 10

M.moduleOrder = 70
M.nextModuleId = "TBD" 

M.steps = {
    {
    mapID = {2393},
    title = "Adventure Mode",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "Now that the Campaign is finished, you have unlocked Adventure Mode. This causes all content in Midnight to scale with you as you level, allowing you to do whatever you want in order to reach 90." },
        { kind = "OBJECTIVE", questName = "Intro", text = "I have added a dedicated alt leveling route, and you can select it by picking 'Midnight Alt 80-90' in the dropdown menu. However, it might be a bit difficult to follow if you're jumping in midway, so I've included this section, which provides you with detailed written explanations for the various leveling methods." },
        { kind = "OBJECTIVE", questName = "Intro", text = "There is no quest tracking or arrow logic in this module, just click the Prev and Next buttons to switch between the different leveling method descriptions." },
    },
  },
  {
    mapID = {2393},
    title = "Delves",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "Delves were the fastest way to level in TWW, and the same is true for Midnight. You already completed two delves during the campaign, but there are 8 available in total. Technically, there are 10 delves, but 2 are timegated until late March." },
        { kind = "OBJECTIVE", questName = "Intro", text = "The main way to level via delves is by doing a world tour. Each delve has an associated Delver's Call quest, and these give amazing XP. You fly around, run each delve once, and then hand in the quests when you're done. They also benefit from the extra Warmode XP." },
        { kind = "OBJECTIVE", questName = "Intro", text = "Currently I've seen discussion over spamming certain delve variants for easy mob grinding XP. It seems like Shadowguard Point is a good option for this on some variants currently, but this tends to fall behind world tours when fully optimized. I'll continue testing." },
        { kind = "OBJECTIVE", questName = "Intro", text = "As you might expect, some delves and variants are better than others. Around the launch of Midnight Season 1 I'll have a full Endgame Delve Guide posted, and alongside that I'll make a complete Delve Variant Tier List. When that is complete, it will be integrated into the addon." },
        { kind = "OBJECTIVE", questName = "Intro", text = "After finishing Campaign, clearing the remaining delves may be enough on its own to get you to 90. When leveling alts, you will need to supplement this with other sources." },
    },
  },
  {
    mapID = {2393},
    title = "Crafting",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "When you level up crafting professions, there's a First Craft bonus on every item. As the name implies, the first time you craft it, you get a chunk of experience. Considering how fast you're able to craft 30 items, this is an extremely easy source of XP." },
        { kind = "OBJECTIVE", questName = "Intro", text = "You can only earn experience from 30 first crafts in total. The final 10 also receive diminishing returns. First craft bonuses are shared across all profs, but you can combine some, ex. 15 in Engineering, 15 in Enchanting." },
        { kind = "OBJECTIVE", questName = "Intro", text = "Speaking of which, I have been told that Engineering, Enchanting, Tailoring, and Leatherworking are the most efficient professions in terms of mat requirements relative to first crafts. I have not tested this myself, so take it with a grain of salt." },
        { kind = "OBJECTIVE", questName = "Intro", text = "When you complete the profession intro questline in Silvermoon, you can choose a bag of supplies that gives you a ton of free mats. This makes profession leveling really accessible, even for people with little to no gold." },
        { kind = "OBJECTIVE", questName = "Intro", text = "You can also funnel alts you don't care about into Silvermoon, collect their free bag, and then send the mats over to your main." },
          { kind = "OBJECTIVE", questName = "Intro", text = "The addon will eventually include optimized material shopping lists for getting 30 first crafts." },
    },
  },
  {
    mapID = {2393},
    title = "Sidequests",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "As a general rule, most sidequests aren't incredibly efficient. There's a reason I didn't prioritize including them in my Campaign guide (though some will be added eventually)." },
        { kind = "OBJECTIVE", questName = "Intro", text = "With that said, there are certain individual side quest chains that can be worthwhile to complete. Like I said, a lot of these will EVENTUALLY be integrated into the main guide, but they still work if you do them now." },
        { kind = "OBJECTIVE", questName = "Intro", text = "Based on my testing, I found that Eversong Woods and Zul'Aman had some of the most efficient side quest chains. If you finish all delves and are still short XP, being completing side quests in Eversong and you should reach 90." },
        { kind = "OBJECTIVE", questName = "Intro", text = "Within the next few days my addon will be updated to include full routes for Sojourner of X Zone achievements (complete all side questlines). I'll be rolling these out zone by zone as I complete them over the weekend." },
    },
  },
  {
    mapID = {2393},
    title = "Dungeons",
    segments = {
        { kind = "OBJECTIVE", questName = "Intro", text = "Dungeons are kinda slow. They give less XP than delves, take longer, and have queue times. They are only remotely efficient with a full optimized 5 stack with instant queues, and even then you would be better suited running delves." },
        { kind = "OBJECTIVE", questName = "Intro", text = "Timewalking dungeons, when they are available, are sometimes passable. Outside of events like Turbulent Timeways, they are usually slower than optimized Delves + Crafting + Quests, but they can be a nice brain off method." },
        { kind = "OBJECTIVE", questName = "Intro", text = "If you're going to run dungeons, always queue for random dungeons. The bulk of the value comes from the random dungeon bonus." },
    },
  },
  {
    mapID = {2393},
    title = "Something Different?",
    segments = {
        { kind = "OBJECTIVE", questName = "Intro", text = "If you think I've missed a crucial detail in my guide, let me know! Speedleveling strats are always evolving, and unless we share information it will never be possible for a single person to find the fastest path." },
        { kind = "OBJECTIVE", questName = "Intro", text = "Also, just to reiterate what I've said in my streams/videos, if you have any general feedback for the addon please let me know. This info is being added as part of the very first update, and it includes some bugfixes for issues testers brought to my attention. I'm sitting on an even longer list of issues that I plan to fix eventually." },
        { kind = "OBJECTIVE", questName = "Intro", text = "Thank you for giving my first ever addon a chance! You're awesome!" },
    },
  },
}

FTA.Modules[M.id] = M