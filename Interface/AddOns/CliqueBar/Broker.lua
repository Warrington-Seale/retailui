local _, ns = ...
local L = ns.L
local CliqueBar = ns.addon

local ICON = "Interface\\AddOns\\CliqueBar\\Media\\Icon.tga"

function CliqueBar:SetupBroker()
	local LDB = LibStub("LibDataBroker-1.1", true)
	local LDBIcon = LibStub("LibDBIcon-1.0", true)
	if not LDB then return end

	local dataObject = LDB:NewDataObject("CliqueBar", {
		type = "launcher",
		label = "CliqueBar",
		icon = ICON,
		OnClick = function(_, button)
			if button == "RightButton" then
				self.db.profile.locked = not self.db.profile.locked
				self:ApplyLock()
				self:Print(self.db.profile.locked and L["Bar locked."] or L["Bar unlocked - drag to move."])
			else
				self:OpenOptions()
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine("CliqueBar")
			local count = self.entries and #self.entries or 0
			tooltip:AddLine(string.format(L["%d bindings shown"], count), 1, 1, 1)
			tooltip:AddLine(" ")
			tooltip:AddLine(L["Left-click: open options"], 0.6, 0.6, 0.6)
			tooltip:AddLine(L["Right-click: lock/unlock the bar"], 0.6, 0.6, 0.6)
		end,
	})
	self.dataObject = dataObject

	if LDBIcon then
		LDBIcon:Register("CliqueBar", dataObject, self.db.profile.minimap)
		self.LDBIcon = LDBIcon
	end

	-- Show up in the addon compartment (the drawer at the top of the minimap).
	if AddonCompartmentFrame and AddonCompartmentFrame.RegisterAddon and not self.compartmentAdded then
		self.compartmentAdded = true
		AddonCompartmentFrame:RegisterAddon({
			text = "CliqueBar",
			icon = ICON,
			notCheckable = true,
			func = function(_, arg1, arg2)
				local mouseButton = (arg1 == "LeftButton" or arg1 == "RightButton") and arg1
					or (type(arg2) == "table" and arg2.buttonName) or nil
				if mouseButton == "RightButton" then
					self.db.profile.locked = not self.db.profile.locked
					self:ApplyLock()
				else
					self:OpenOptions()
				end
			end,
			funcOnEnter = function(button)
				GameTooltip:SetOwner(button, "ANCHOR_LEFT")
				GameTooltip:AddLine("CliqueBar")
				GameTooltip:AddLine(L["Left-click: open options"], 0.6, 0.6, 0.6)
				GameTooltip:AddLine(L["Right-click: lock/unlock the bar"], 0.6, 0.6, 0.6)
				GameTooltip:Show()
			end,
			funcOnLeave = function() GameTooltip:Hide() end,
		})
	end
end

-- Right-click menu on the minimap/broker icon or the bar: toggle the lock or jump to
-- the options. Prefers the modern MenuUtil context menu, falls back to EasyMenu.
function CliqueBar:ShowContextMenu(anchor)
	if MenuUtil and MenuUtil.CreateContextMenu then
		MenuUtil.CreateContextMenu(anchor or UIParent, function(_, root)
			root:CreateTitle("CliqueBar")
			root:CreateCheckbox(L["Lock bar"],
				function() return self.db.profile.locked end,
				function()
					self.db.profile.locked = not self.db.profile.locked
					self:ApplyLock()
				end)
			root:CreateButton(L["Show options"], function() self:OpenOptions() end)
		end)
		return
	end

	if not self.contextMenu then
		self.contextMenu = CreateFrame("Frame", "CliqueBarContextMenu", UIParent, "UIDropDownMenuTemplate")
	end
	local menu = {
		{ text = "CliqueBar", isTitle = true, notCheckable = true },
		{
			text = L["Lock bar"],
			checked = function() return self.db.profile.locked end,
			func = function()
				self.db.profile.locked = not self.db.profile.locked
				self:ApplyLock()
			end,
		},
		{
			text = L["Show options"],
			notCheckable = true,
			func = function() self:OpenOptions() end,
		},
	}
	if EasyMenu then
		EasyMenu(menu, self.contextMenu, anchor or "cursor", 0, 0, "MENU")
	else
		self:OpenOptions()
	end
end

function CliqueBar:ToggleMinimap()
	if not self.LDBIcon then return end
	if self.db.profile.minimap.hide then
		self.LDBIcon:Hide("CliqueBar")
	else
		self.LDBIcon:Show("CliqueBar")
	end
end

function CliqueBar:UpdateBroker()
end
