local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "PATCH121_ENDGAME"
M.title = "Patch 12.1 Endgame Guides"
M.defaultRadius = 5

M.routeId    = "TEMP1207"
M.routeTitle = "What's New?"
M.routeOrder = 1

M.moduleOrder = 9
M.nextModuleId = "TBD" 

M.steps = {
    {
    title = "What has been added in Patch 12.1?",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "As usual, Patch 12.1 is adding a new endgame campaign that you need to complete in order to unlock all of the new content." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The first part of this questline was added in 12.0.7, and was included in an update earlier this week. I've now included all campaign quests in the addon, though some of them may not be available on the week of August 11th." },
      { kind = "OBJECTIVE", questName = "Intro", text = "You can access this new campaign questline by selecting 'Midnight Endgame' from the top right dropdown menu, and then selecting 'Patch 12.1 Campaign'." },
      --{ kind = "OBJECTIVE", questName = "Intro", text = "When the patch releases on August 11th, all remaining Patch 12.1 questlines will be added in an update. This will include all campaign quests and all side quests." },
      { kind = "OBJECTIVE", questName = "Intro", text = "All of the side quests will also be included in the addon, but it will take another day or two before they're fully completed." },
      --{ kind = "VIDEO_EMBED", url = "https://youtu.be/Hn8SceLFago", texture = "Interface\\AddOns\\FollowTheArrow\\Images\\1090DHSR.tga", width = 320, height = 180, tooltipTitle = "Watch the 12.1 Video Guide!" },
      { kind = "NOTE", text = "Use the Next and Prev buttons to navigate through this section of the addon." },
    },
  },
  {
    title = "This isn't leveling, why does this matter?",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "I hope this isn't a thought that many people have, but it is something I have seen expressed by a few commenters. This is not a sudden change, I have already expressed that the plan is for Follow The Arrow to cover a lot of content in this game, not just leveling." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Leveling is obviously the place where an addon like this makes the most sense, and it was obviously the first thing I focused on when developing it for Midnight's launch." },
      { kind = "OBJECTIVE", questName = "Intro", text = "I had initially hoped to include certain endgame questlines earlier on, but I found that adding in all of the campaign, alt, and sojourner routes already took up a massive amount of time, and I considered that to be a higher priority." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Since every player will be forced to complete the 12.1 Campaign Questline, I figured that a route for it would be universally beneficial to the playerbase, so I prioritized having it complete in time for the patch." },
    },
  },
  {
    title = "So you're doing this instead of 1-80 guides?",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "No. I'm aware that many people are eagerly awaiting the inclusion of 1-80 guides, but I hope you can understand that this isn't a 'one or the other' situation." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The 1-80 guides are currently a work in progress, and while I had hoped to have them complete by the release of Patch 12.1, I realized a few months ago that it would require far more time and effort than I initially realized. I was already feeling a bit burnt out from working on the addon early in Season 1, so I decided to take a short break from development after finishing the updated 12.0.7 Alt 80-90 Guide." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Once my guild finishes Mythic Venomous Deeps Prog (likely late September or Early October) I will return to work on the 1-80 routes, and I hope to have both factions completed before 12.1.5. Alliance will be done first, Horde will be done second. I'm not going to drip feed these guides zone by zone, when they're fully complete they will be included in the addon." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Since getting the 12.1 quests included was significantly less work, and more immediately relevant, I figured this was a higher priority than making slightly more progress towards the 1-80 guides." },
    },
  },
  {
    title = "Other Endgame Guides",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "Going forward, I will continue to add relevant endgame guides to Follow The Arrow, including a few that I missed already." },
      { kind = "OBJECTIVE", questName = "Intro", text = "While I likely won't bother with certain questlines, such as the original 12.0 Campaign which had completely meaningless rewards, I do plan to add things like the Omnium Folio questline. Since this will be relevant until the end of the expac, I'm sure some late returning players would appreciate having this included." },
      { kind = "OBJECTIVE", questName = "Intro", text = "I also plan to include any important questlines for 12.1.5, 12.2, and other future patches when they release. Inclusions will be handled on a case by case basis, only stuff that I consider relevant for endgame progression will be added. Random questlines for secret mounts, pets, or other cosmetics are not a priority." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Around the time of Patch 12.1.5 I also plan to expand the addon to include more advanced tools for Delves. Delves play a crucial role in both the leveling process and endgame progression, so this is something I've wanted to add for a while." },
      { kind = "OBJECTIVE", questName = "Intro", text = "I'm not sure what I'll actually be able to include, and what will be impossible due to addon limitations, but my hope is that the addon can give you custom optimized paths through every single Delve variant. This way you can level or farm gear as fast as possible without worrying about which variants are active." },
      { kind = "OBJECTIVE", questName = "Intro", text = "I also plan to post an updated Delve Tier List video, and the rankings will be baked into the addon. This will allow players to easily see whether the Delve they're about to run is a fast variant or a slow one." },
    },
  },
}

FTA.Modules[M.id] = M