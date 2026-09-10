-- Auto Accept Role Check
-- Automatically accepts role check popups with your current or preferred role

local addonName, addon = ...

-- Default settings
local defaults = {
    enabled = true,
    tank = false,
    healer = false,
    dps = false,
}

-- Create main frame for event handling
local eventFrame = CreateFrame("Frame")

-- Initialize saved variables
local function InitializeDB()
    if not AutoAcceptRoleCheckDB then
        AutoAcceptRoleCheckDB = CopyTable(defaults)
    end
    for key, value in pairs(defaults) do
        if AutoAcceptRoleCheckDB[key] == nil then
            AutoAcceptRoleCheckDB[key] = value
        end
    end
end

-- Main function that handles the role check
local function HandleRoleCheck()
    if not AutoAcceptRoleCheckDB.enabled then return end
    
    local tank = false
    local dps = false
    local healer = false
    
    local posTank, posHealer, posDps = UnitGetAvailableRoles("player")
    
    if posDps then
        dps = AutoAcceptRoleCheckDB.dps
    end
    if posTank then
        tank = AutoAcceptRoleCheckDB.tank
    end
    if posHealer then
        healer = AutoAcceptRoleCheckDB.healer
    end
    
    if not (tank or healer or dps) then
        local role = UnitGroupRolesAssigned("player")
        if role == "NONE" then
            local spec = GetSpecialization()
            if spec then
                role = GetSpecializationRole(spec)
            end
        end
        
        if role == "TANK" then
            tank = true
        elseif role == "DAMAGER" then
            dps = true
        elseif role == "HEALER" then
            healer = true
        end
    end
    
    local tankButton = LFDRoleCheckPopupRoleButtonTank
    local healerButton = LFDRoleCheckPopupRoleButtonHealer
    local dpsButton = LFDRoleCheckPopupRoleButtonDPS
    local acceptButton = LFDRoleCheckPopupAcceptButton
    
    if tankButton and tankButton.checkButton then
        if tankButton.checkButton:IsEnabled() then
            tankButton.checkButton:SetChecked(tank)
        end
    elseif tankButton and tankButton.CheckButton then
        if tankButton.CheckButton:IsEnabled() then
            tankButton.CheckButton:SetChecked(tank)
        end
    end
    
    if healerButton and healerButton.checkButton then
        if healerButton.checkButton:IsEnabled() then
            healerButton.checkButton:SetChecked(healer)
        end
    elseif healerButton and healerButton.CheckButton then
        if healerButton.CheckButton:IsEnabled() then
            healerButton.CheckButton:SetChecked(healer)
        end
    end
    
    if dpsButton and dpsButton.checkButton then
        if dpsButton.checkButton:IsEnabled() then
            dpsButton.checkButton:SetChecked(dps)
        end
    elseif dpsButton and dpsButton.CheckButton then
        if dpsButton.CheckButton:IsEnabled() then
            dpsButton.CheckButton:SetChecked(dps)
        end
    end
    
    if acceptButton then
        acceptButton:Enable()
        acceptButton:Click()
    end
end

-- ============================================
-- GUI Configuration Panel
-- ============================================

local configFrame = nil

local function CreateCheckbox(parent, label, dbKey, x, y)
    local cb = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
    cb:SetPoint("TOPLEFT", x, y)
    cb.Text:SetText(label)
    cb.Text:SetFontObject("GameFontNormal")
    
    cb:SetScript("OnClick", function(self)
        AutoAcceptRoleCheckDB[dbKey] = self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    end)
    
    cb.dbKey = dbKey
    return cb
end

local function CreateConfigFrame()
    if configFrame then return configFrame end
    
    -- Main frame
    configFrame = CreateFrame("Frame", "AutoAcceptRoleCheckConfig", UIParent, "BackdropTemplate")
    configFrame:SetSize(320, 280)
    configFrame:SetPoint("CENTER")
    configFrame:SetMovable(true)
    configFrame:EnableMouse(true)
    configFrame:RegisterForDrag("LeftButton")
    configFrame:SetScript("OnDragStart", configFrame.StartMoving)
    configFrame:SetScript("OnDragStop", configFrame.StopMovingOrSizing)
    configFrame:SetFrameStrata("DIALOG")
    configFrame:SetClampedToScreen(true)
    configFrame:Hide()
    
    -- Backdrop
    configFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    })
    
    -- Title bar
    local titleBg = configFrame:CreateTexture(nil, "ARTWORK")
    titleBg:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    titleBg:SetSize(240, 64)
    titleBg:SetPoint("TOP", 0, 12)
    
    local title = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", 0, 0)
    title:SetText("Auto Accept Role Check")
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, configFrame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", -5, -5)
    
    -- Enable checkbox
    local enableCB = CreateCheckbox(configFrame, "Activer l'addon", "enabled", 20, -40)
    configFrame.enableCB = enableCB
    
    -- Separator
    local sep1 = configFrame:CreateTexture(nil, "ARTWORK")
    sep1:SetColorTexture(0.5, 0.5, 0.5, 0.5)
    sep1:SetSize(280, 1)
    sep1:SetPoint("TOPLEFT", 20, -75)
    
    -- Info text
    local infoText = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    infoText:SetPoint("TOPLEFT", 20, -90)
    infoText:SetWidth(280)
    infoText:SetJustifyH("LEFT")
    infoText:SetText("|cFFFFFF00Forcer des roles specifiques :|r\n(Si aucun n'est coche, utilise ton role de spe/groupe)")
    
    -- Role checkboxes with icons
    local yOffset = -140
    
    -- Tank
    local tankIcon = configFrame:CreateTexture(nil, "ARTWORK")
    tankIcon:SetSize(24, 24)
    tankIcon:SetPoint("TOPLEFT", 20, yOffset)
    tankIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
    tankIcon:SetTexCoord(0, 0.26, 0.26, 0.52)
    
    local tankCB = CreateCheckbox(configFrame, "Tank", "tank", 50, yOffset + 3)
    configFrame.tankCB = tankCB
    
    -- Healer
    yOffset = yOffset - 35
    local healerIcon = configFrame:CreateTexture(nil, "ARTWORK")
    healerIcon:SetSize(24, 24)
    healerIcon:SetPoint("TOPLEFT", 20, yOffset)
    healerIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
    healerIcon:SetTexCoord(0.26, 0.52, 0, 0.26)
    
    local healerCB = CreateCheckbox(configFrame, "Healer", "healer", 50, yOffset + 3)
    configFrame.healerCB = healerCB
    
    -- DPS
    yOffset = yOffset - 35
    local dpsIcon = configFrame:CreateTexture(nil, "ARTWORK")
    dpsIcon:SetSize(24, 24)
    dpsIcon:SetPoint("TOPLEFT", 20, yOffset)
    dpsIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
    dpsIcon:SetTexCoord(0.26, 0.52, 0.26, 0.52)
    
    local dpsCB = CreateCheckbox(configFrame, "DPS", "dps", 50, yOffset + 3)
    configFrame.dpsCB = dpsCB
    
    -- Separator
    local sep2 = configFrame:CreateTexture(nil, "ARTWORK")
    sep2:SetColorTexture(0.5, 0.5, 0.5, 0.5)
    sep2:SetSize(280, 1)
    sep2:SetPoint("BOTTOMLEFT", 20, 45)
    
    -- Footer text
    local footerText = configFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    footerText:SetPoint("BOTTOM", 0, 20)
    footerText:SetText("|cFF888888/aarc pour ouvrir ce panneau|r")
    
    -- ESC to close
    tinsert(UISpecialFrames, "AutoAcceptRoleCheckConfig")
    
    return configFrame
end

local function RefreshConfigFrame()
    if not configFrame then return end
    configFrame.enableCB:SetChecked(AutoAcceptRoleCheckDB.enabled)
    configFrame.tankCB:SetChecked(AutoAcceptRoleCheckDB.tank)
    configFrame.healerCB:SetChecked(AutoAcceptRoleCheckDB.healer)
    configFrame.dpsCB:SetChecked(AutoAcceptRoleCheckDB.dps)
end

local function ToggleConfigFrame()
    CreateConfigFrame()
    RefreshConfigFrame()
    if configFrame:IsShown() then
        configFrame:Hide()
    else
        configFrame:Show()
    end
end

-- ============================================
-- Minimap Button
-- ============================================

local function CreateMinimapButton()
    local minimapBtn = CreateFrame("Button", "AutoAcceptRoleCheckMinimapButton", Minimap)
    minimapBtn:SetSize(32, 32)
    minimapBtn:SetFrameStrata("MEDIUM")
    minimapBtn:SetFrameLevel(8)
    minimapBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    
    local overlay = minimapBtn:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(53, 53)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    overlay:SetPoint("TOPLEFT")
    
    local icon = minimapBtn:CreateTexture(nil, "BACKGROUND")
    icon:SetSize(20, 20)
    icon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
    icon:SetTexCoord(0, 0.26, 0.26, 0.52)
    icon:SetPoint("CENTER", 0, 0)
    
    local background = minimapBtn:CreateTexture(nil, "ARTWORK")
    background:SetSize(24, 24)
    background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    background:SetPoint("CENTER", 0, 0)
    background:SetVertexColor(0, 0, 0, 0.6)
    
    -- Position around minimap
    local angle = math.rad(220)
    local radius = 80
    minimapBtn:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
    
    -- Dragging around minimap
    minimapBtn:RegisterForDrag("LeftButton")
    minimapBtn:SetScript("OnDragStart", function(self)
        self.dragging = true
    end)
    
    minimapBtn:SetScript("OnDragStop", function(self)
        self.dragging = false
    end)
    
    minimapBtn:SetScript("OnUpdate", function(self)
        if self.dragging then
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            px, py = px / scale, py / scale
            local angle = math.atan2(py - my, px - mx)
            local radius = 80
            self:ClearAllPoints()
            self:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
        end
    end)
    
    minimapBtn:SetScript("OnClick", function(self, button)
        ToggleConfigFrame()
    end)
    
    minimapBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("Auto Accept Role Check")
        GameTooltip:AddLine("|cFFFFFFFFClic pour ouvrir les options|r", 1, 1, 1)
        GameTooltip:Show()
    end)
    
    minimapBtn:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    
    return minimapBtn
end

-- ============================================
-- Event Handling
-- ============================================

local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon == addonName then
            InitializeDB()
            CreateMinimapButton()
            print("|cFF00FF00[AutoAcceptRoleCheck]|r Charge ! Clique sur le bouton minimap ou tape /aarc")
            eventFrame:UnregisterEvent("ADDON_LOADED")
        end
    elseif event == "LFG_ROLE_CHECK_SHOW" then
        C_Timer.After(0.1, HandleRoleCheck)
    end
end

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("LFG_ROLE_CHECK_SHOW")
eventFrame:SetScript("OnEvent", OnEvent)

-- ============================================
-- Slash Commands
-- ============================================

SLASH_AUTOACCEPTROLECHECK1 = "/aarc"
SLASH_AUTOACCEPTROLECHECK2 = "/autoacceptrolecheck"

SlashCmdList["AUTOACCEPTROLECHECK"] = function(msg)
    ToggleConfigFrame()
end
