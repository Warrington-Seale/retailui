local ADDON, ns = ...
local L = ns.L

local ICON_PATH = "Interface\\AddOns\\CliqueBar\\Media\\Icon.tga"
local DISCORD_ICON = "Interface\\AddOns\\CliqueBar\\Media\\discord.tga"
local SUPPORT_ICON = "Interface\\AddOns\\CliqueBar\\Media\\support.tga"
local LINK_EXTERNAL = "Interface\\AddOns\\CliqueBar\\Media\\link-external.tga"

local LINKS = {
	{ label = L["Website"], url = "https://soguns.xyz", color = { 0.19, 0.73, 0.71 }, icon = ICON_PATH },
	{ label = L["Support"], url = "https://soguns.xyz/support", color = { 0.58, 0.35, 0.72 }, icon = SUPPORT_ICON },
	{ label = "Discord", url = "https://soguns.xyz/discord", color = { 0.34, 0.40, 0.95 }, icon = DISCORD_ICON },
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

-- About header at the top of the settings list (see AboutPanel.xml for the template
-- that hosts it). Mirrors the Class Codex about-page chrome: brand header with the
-- addon icon, short description, and community links as cards with a service-color
-- gradient wash, round icons, and a gold external-link marker. Clicking a card opens
-- the copy dialog since the game has no clipboard API.
-- Class Codex card chrome, verbatim proportions: dark card, tooltip border,
-- service gradient wash, round icon, gold external-link marker.
local CARD_H, CARD_GAP, CARD_COL_GAP = 34, 5, 8
local GOLD = { 1, 0.82, 0 }
local GOLD_HL = { 1, 0.93, 0.4 }
local WARNING_BLUE = { 0.59, 0.67, 0.9 }
local ROUND_MASK = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask"

local function makeLinkCard(parent, link)
	local row = CreateFrame("Button", nil, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	row:SetHeight(CARD_H)
	row:RegisterForClicks("LeftButtonUp")
	if row.SetBackdrop then
		row:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 12,
			insets = { left = 3, right = 3, top = 3, bottom = 3 },
		})
		row:SetBackdropColor(0.08, 0.08, 0.09, 0.94)
		row:SetBackdropBorderColor(0.32, 0.32, 0.38, 0.7)
	end

	local colorBg = row:CreateTexture(nil, "BACKGROUND", nil, 1)
	colorBg:SetPoint("TOPLEFT", 3, -3)
	colorBg:SetPoint("BOTTOMRIGHT", -3, 3)
	if colorBg.SetGradient and CreateColor then
		local r, g, b = link.color[1], link.color[2], link.color[3]
		local a = 0.75
		colorBg:SetColorTexture(1, 1, 1, 1)
		colorBg:SetGradient("HORIZONTAL", CreateColor(r, g, b, a * 0.35), CreateColor(r, g, b, a))
		colorBg:Show()
	else
		colorBg:Hide()
	end

	local icon = row:CreateTexture(nil, "ARTWORK")
	icon:SetSize(18, 18)
	icon:SetPoint("TOPLEFT", row, "TOPLEFT", 11, -(CARD_H - 18) / 2)
	icon:SetTexture(link.icon)
	if row.CreateMaskTexture then
		local mask = row:CreateMaskTexture()
		mask:SetAllPoints(icon)
		mask:SetTexture(ROUND_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		icon:AddMaskTexture(mask)
	end

	local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	label:SetJustifyH("LEFT")
	label:SetWordWrap(false)
	label:SetText(link.label)

	local marker = row:CreateTexture(nil, "OVERLAY")
	marker:SetSize(13, 13)
	marker:SetPoint("RIGHT", -11, 0)
	marker:SetTexture(LINK_EXTERNAL)
	marker:SetVertexColor(GOLD[1], GOLD[2], GOLD[3])
	label:SetPoint("RIGHT", marker, "LEFT", -6, 0)
	label:SetPoint("LEFT", icon, "RIGHT", 10, 0)

	row:SetScript("OnEnter", function(self)
		if self.SetBackdropBorderColor then self:SetBackdropBorderColor(GOLD[1], GOLD[2], GOLD[3], 0.9) end
		label:SetTextColor(GOLD_HL[1], GOLD_HL[2], GOLD_HL[3])
	end)
	row:SetScript("OnLeave", function(self)
		if self.SetBackdropBorderColor then self:SetBackdropBorderColor(0.32, 0.32, 0.38, 0.7) end
		label:SetTextColor(1, 1, 1)
	end)
	row:SetScript("OnClick", function()
		StaticPopup_Show("CLIQUEBAR_COPY_LINK", link.url, nil, link.url)
	end)
	return row
end

function ns.CreateSettingsAboutCanvas()
	local canvas = CreateFrame("Frame", "CliqueBarSettingsAbout")
	canvas.OnCommit = function() end
	canvas.OnDefault = function() end
	canvas.OnRefresh = function() end

	local scroll = CreateFrame("ScrollFrame", "CliqueBarSettingsAboutScroll", canvas, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 10, -10)
	scroll:SetPoint("BOTTOMRIGHT", -28, 10)

	local content = CreateFrame("Frame", nil, scroll)
	content:SetSize(1, 1)
	scroll:SetScrollChild(content)

	local ICON_SIZE = 38

	local titleIcon = content:CreateTexture(nil, "ARTWORK")
	titleIcon:SetSize(ICON_SIZE, ICON_SIZE)
	titleIcon:SetTexture(ICON_PATH)

	local title = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetText(ns.BrandLabel())

	-- Header subline, the Class Codex "Data Updated" slot: the same blue warning
	-- the minimap tooltip uses, shown only while Clique is actually missing.
	-- Evaluated at display time — Clique's global may not exist yet when this
	-- addon initializes.
	local subline = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	subline:Hide()
	local sublineLoaded
	local function RefreshSubline()
		local loaded = _G.Clique ~= nil
		if loaded == sublineLoaded then return end
		sublineLoaded = loaded
		if loaded then
			subline:Hide()
		else
			subline:SetText(L["Clique needs to be loaded for CliqueBar to work properly"])
			subline:SetTextColor(WARNING_BLUE[1], WARNING_BLUE[2], WARNING_BLUE[3])
			subline:Show()
		end
	end
	RefreshSubline()

	local desc = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	desc:SetJustifyH("LEFT")
	desc:SetWordWrap(true)
	desc:SetTextColor(1, 1, 1)
	desc:SetText(L["A bar that mirrors your Clique click-cast bindings with keys and cooldowns."])

	local cards = {}
	for _, link in ipairs(LINKS) do
		cards[#cards + 1] = makeLinkCard(content, link)
	end

	local function Layout()
		RefreshSubline()
		local width = scroll:GetWidth()
		if not width or width < 40 then return end
		content:SetWidth(width)

		local titleH = title:GetStringHeight() or 18
		local subH = subline:IsShown() and (subline:GetStringHeight() or 12) or 0
		local blockH = subH > 0 and (titleH + 2 + subH) or titleH
		local iconTop = -2
		local blockTop = iconTop - (ICON_SIZE - blockH) / 2

		titleIcon:ClearAllPoints()
		titleIcon:SetPoint("TOPLEFT", content, "TOPLEFT", 2, iconTop)
		title:ClearAllPoints()
		title:SetPoint("TOPLEFT", content, "TOPLEFT", 2 + ICON_SIZE + 8, blockTop)
		subline:ClearAllPoints()
		subline:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)

		local y = iconTop - ICON_SIZE - 12

		desc:ClearAllPoints()
		desc:SetWidth(width - 4)
		desc:SetPoint("TOPLEFT", content, "TOPLEFT", 2, y)
		y = y - (desc:GetStringHeight() or 12) - 14

		-- Website spans the full row; Support and Discord share the row below it,
		-- each half width.
		local textW = width - 4
		local cellW = math.floor((textW - CARD_COL_GAP) / 2)
		cards[1]:ClearAllPoints()
		cards[1]:SetPoint("TOPLEFT", content, "TOPLEFT", 2, y)
		cards[1]:SetWidth(textW)
		y = y - CARD_H - CARD_GAP
		for i = 2, #cards do
			local col = (i - 2) % 2
			local card = cards[i]
			card:ClearAllPoints()
			card:SetPoint("TOPLEFT", content, "TOPLEFT", 2 + col * (cellW + CARD_COL_GAP), y)
			card:SetWidth(cellW)
			if col == 1 then y = y - CARD_H - CARD_GAP end
		end

		content:SetHeight(math.abs(y) + 10)
	end

	scroll:SetScript("OnSizeChanged", Layout)
	canvas:SetScript("OnShow", Layout)
	canvas.Layout = Layout
	return canvas
end
