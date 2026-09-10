local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "LEVEL7080_PH"
M.title = "War Within 70-80"
M.defaultRadius = 5

M.routeId    = "LEVEL_70_80"
M.routeTitle = "Levels 70-80"
M.routeOrder = 50

M.moduleOrder = 10
M.nextModuleId = "TBD" 

M.steps = {
    {
    title = "Why is this a separate route?",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "You may notice that I have sections for Alliance and Horde 10-80 already, and in those sections I've included the associated video guides for the full 10-80 process. So why bother making this section specifically for 70-80?" },
      { kind = "OBJECTIVE", questName = "Intro", text = "Two reasons. First, while those video guides are technically fully applicable to current Midnight 10-80 leveling, they were created back during TWW. At that point, Chromie Time only scaled from 10-70, so I covered all War Within content in a separate video guide." },
      { kind = "OBJECTIVE", questName = "Intro", text = "For some reason, Blizzard chose to not add War Within content to Chromie Time after Midnight was released, despite nerfing the XP scaling so that 10-80 currently takes the same amount of time as 10-70 used to take. This is why, despite being made last expansion, my TWW Chromie Time guides are still fully accurate for 10-80, since nothing has actually changed." },
      { kind = "OBJECTIVE", questName = "Intro", text = "In theory, this would simply make TWW leveling optional. If you want to do it from 70-80, you can, but you could also just use my Chromie Time routes all the way to 80. Unfortunately, this game is made by Blizzard Entertainment, so naturally they completely bungled the Chromie Time changes." },
      { kind = "OBJECTIVE", questName = "Intro", text = "If you level a fresh character from 10-80 with Chromie Time, everything will work as intended. However, if you have an existing character in the 70-80 range, it is impossible to enable Chromie Time, meaning you can't follow that route. This is the second reason why I've added this section, it's the only way to level from 70-80 for characters with that bug." },
      { kind = "NOTE", text = "Use the Next and Prev buttons to navigate through this section of the addon." },
    },
  },
  {
    title = "My character is bugged, what now?",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "Luckily for you, my old 70-80 route and associated video guide are still fully applicable in Midnight, and you can get through those ten levels in less than 30 minutes." },
      { kind = "OBJECTIVE", questName = "Intro", text = "In fact, I suspect that following this guide will actually be faster than the tail end of my Chromie Time 10-80 routes. When I eventually add the Ally/Horde 10-80 paths to Follow The Arrow, this route will be baked into it, and I will remove this placeholder section of the addon." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Below I've linked my old 70-80 video guide, which still contains 95% of the information you'll need. However, I've added some extra info sections to the addon that go into a bit more detail on a few minor things that have changed." },
      { kind = "VIDEO_EMBED", url = "https://youtu.be/bBSvIC6ZAfk", texture = "Interface\\AddOns\\FollowTheArrow\\Images\\7080Thumb.tga", width = 320, height = 180, tooltipTitle = "Watch the War Within 70-80 Video Guide!" },
      { kind = "NOTE", text = "Clicking on the embedded thumbnail will create a small text box with a copy + pastable version of the YouTube URL." },
    },
  },
  {
    title = "War Within Crafting",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "In my video guide, I mention that crafting is an OPTION, but I didn't put a ton of emphasis on it because it requires spending gold. Thankfully, the prices of materials are all dirt cheap now that TWW is old content, so everyone should be able to easily afford to follow the Crafting section." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Additionally, while Crafting was only enough to get from ~70-72 when TWW was current, it now gets you all the way from 70-76 in less than 5 minutes. It is ABSURDLY fast, and it is without a doubt the most important leveling method discussed in my guide." },
      { kind = "OBJECTIVE", questName = "Intro", text = "Also, in the guide I discuss a mechanic called 'Dreamsurges', which you were able to use to get 50% additional experience from your crafts. This was nerfed, and the current version is so buggy that it's not worth using at all anymore. You can just do all of your crafts within Dornogal to reach Level 76." },
      { kind = "OBJECTIVE", questName = "Intro", text = "As mentioned in the video, you can find a detailed shopping list and crafting instructions on my website, 'www.harldan.com'. It is listed under the guide 'Levels 70-80 (Alt Leveling)'. My website is a bit out of date, since I've been focused on making the addon this expansion, but this shopping section will eventually be added to FTA when the 10-80 routes are complete." },
    },
  },
  {
    title = "Delves",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "Unfortunately, Delves have been completely gutted since the time of my 70-80 video. They are no longer a fast way to level in The War Within." },
      { kind = "OBJECTIVE", questName = "Intro", text = "The good news is that there is still a great option for the remaining levels, so the loss of Delves isn't that important." },
    },
  },
  {
    title = "Isle of Dorn Questing",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "The fastest way by far to obtain the remaining ~4-5 levels is to quest in Isle of Dorn. It is a fantastic zone for leveling, likely better than some of the existing Chromie Time options." },
      { kind = "OBJECTIVE", questName = "Intro", text = "In my video, I recommend starting the Isle of Dorn Campaign and then completing side quest hubs alongside it as you progress. You CAN still do this, it's not a terrible option, but you don't actually need that much XP anymore to reach Level 80." },
      { kind = "OBJECTIVE", questName = "Intro", text = "If you complete the entirety of the Rambleshire and Freywold Village hubs, you should get more than enough XP to reach Level 80. I understand that new players may not instinctively know where to start these hubs, so in that case it might be best to just do the campaign path and level slightly slower." },
      { kind = "OBJECTIVE", questName = "Intro", text = "DO NOT try to level through the 'War Within Recap' questline. It is awful and slow." },
    },
  },
}

FTA.Modules[M.id] = M