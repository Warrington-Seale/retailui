local name,ZGV = ...

-- #GLOBALS ZygorGuidesViewer

local GuideMenu = ZGV.GuideMenu


GuideMenu.Messages = {}
-- Notification messages
GuideMenu.Messages.welcome = { 
	action = function() ZGV.GuideMenu:Show("Featured") end,
	title = "Welcome to Zygor Guides",
	text = [[See the guides for **Midnight**]],
	--displaytime = 5,
}



GuideMenu.Messages.guides = { 
	action = function() ZGV.GuideMenu:Show("Home") ZGV.Widgets.Registered.zygormessage:ShowPopup() end,
	title = "New in this update",
	text = [[Added **Midnight** guides]],
	--	displaytime = 5
}

GuideMenu.Bulletin={
	{"title", text=[[Latest Zygor Updates:]]},

	{"section", text=[[Midnight]] },

	{"text", text=[[Midnight content is now live]]},
	{"list", text=[[Click here to load the **Midnight Intro & Campaign (Full Zone)** guide]], guide="Leveling Guides\\Midnight (80-90)\\Full Zones (Story + Side Quests)\\Midnight Intro & Campaign (Full Zone)"},

}


--[=[
GuideMenu.Messages.features = { 
	action = function() print("features") end,
	title = "New features have been added.",
	text = [[]],
	displaytime = 99999,
}
--]=]

-- ZygorMessage widget
GuideMenu.ZygorMessage = [[
Welcome to Zygor's Midnight Guides

Known issues:
* We suggest using a specific path for your first character. Some Sojourner quest chapters are locked behind quest progress. Your subsequent characters can begin with full zone guides if you prefer.
* First, load the Midnight Intro & Campaign (Full Zone) guide and follow it to complete the Eversong Woods (Full Zone) guide.
* Then, complete the Zul'Aman (Full Zone) and Arator's Journey (Full Zone) guides.
* After the previous 3 guides are complete, finish the Harandar (Story Only) guide and proceed to the Voidstorm (Story Only) guide.
* Leveling guides have level 90 only content that is hidden until max level. Reload them to complete the remaining quest chapters for Sojourner in each zone.
* Additional content and bugfixes will be coming soon.

Key Updates:
* Added early access content.

Please contact Customer Support if you encounter any issues.
]]


