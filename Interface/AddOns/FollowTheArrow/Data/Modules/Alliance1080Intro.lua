local _, FTA = ...
FTA.Modules = FTA.Modules or {}

local M = {}
M.id = "ALLY1080_PH"
M.title = "Alliance 10-80 Route"
M.defaultRadius = 5

M.routeId    = "ALLIANCE_10_80"
M.routeTitle = "Alliance 10-80"
M.routeOrder = 30

M.moduleOrder = 10
M.nextModuleId = "TBD" 

M.steps = {
    {
    title = "Work In Progress!",
    segments = {
      { kind = "OBJECTIVE", questName = "Intro", text = "The Alliance 10-80 section of this addon is still a work in progress! I hope to have it finished by Patch 12.1.5." },
      { kind = "OBJECTIVE", questName = "Intro", text = "That being said, I've already thoroughly tested the Alliance Chromie Time route over the years, and it's still the fastest 10-80 method in Midnight. If you want to begin following it right now, you should check out my video guide, linked below." },
      { kind = "VIDEO_EMBED", url = "https://youtu.be/gp_vDonu9fM", texture = "Interface\\AddOns\\FollowTheArrow\\Images\\Ally1080Thumb.tga", width = 320, height = 180, tooltipTitle = "Watch the Alliance 10-80 Video Guide!" },
      { kind = "OBJECTIVE", questName = "Intro", text = "When Follow The Arrow is updated for Alliance 10-80, this is the route that it will guide you through. I know it will be a little less efficient in the meantime since you don't have the arrow, but my guides have been helping players for years long before this addon existed. I'm confident that you'll still level up faster by following the route in the video than if you chose other methods, such as spamming random dungeons." },
      { kind = "NOTE", text = "Clicking on the embedded thumbnail will create a small text box with a copy + pastable version of the YouTube URL." },
    },
  },
}

FTA.Modules[M.id] = M