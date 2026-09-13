local ADDON, ns = ...
local L = ns.L

local LINKS = {
	{ label = "Discord", url = "https://soguns.xyz/discord" },
	{ label = L["Website"], url = "https://soguns.xyz" },
	{ label = L["Support"], url = "https://soguns.xyz/support" },
}

local getMeta = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
ns.version = (getMeta and getMeta(ADDON, "Version")) or ""

local frame

local function makeLinkRow(parent, y, label, url)
	local heading = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	heading:SetPoint("TOPLEFT", 20, y)
	heading:SetText(label)

	local box = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
	box:SetSize(258, 20)
	box:SetPoint("TOPLEFT", 24, y - 18)
	box:SetAutoFocus(false)
	box:SetText(url)
	box:SetCursorPosition(0)
	box:SetScript("OnEscapePressed", box.ClearFocus)
	box:SetScript("OnEnterPressed", box.ClearFocus)
	box:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
	box:SetScript("OnMouseUp", function(self) self:SetFocus(); self:HighlightText() end)

	box:SetScript("OnTextChanged", function(self, user)
		if user then self:SetText(url); self:HighlightText() end
	end)
end

local function build()
	frame = CreateFrame("Frame", "CliqueBarAboutFrame", UIParent,
		BackdropTemplateMixin and "BackdropTemplate" or nil)
	frame:SetSize(320, 230)
	frame:SetPoint("CENTER")
	frame:SetFrameStrata("DIALOG")
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	if frame.SetBackdrop then
		frame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = true, tileSize = 32, edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
	end

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -4, -4)

	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOP", 0, -16)
	title:SetText("CliqueBar")

	local version = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	version:SetPoint("TOP", title, "BOTTOM", 0, -2)
	version:SetText("v" .. (ns.version or ""))

	local y = -74
	for _, link in ipairs(LINKS) do
		makeLinkRow(frame, y, link.label, link.url)
		y = y - 46
	end

	local hint = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	hint:SetPoint("BOTTOM", 0, 16)
	hint:SetText(L["Click the box, then Ctrl-C to copy."])

	tinsert(UISpecialFrames, "CliqueBarAboutFrame")
end

function ns.ShowAbout()
	if not frame then build() end
	frame:Show()
end
