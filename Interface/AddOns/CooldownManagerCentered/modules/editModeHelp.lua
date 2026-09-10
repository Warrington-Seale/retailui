local _, ns = ...
local L = ns.L

local EditModeHelp = {}
ns.EditModeHelp = EditModeHelp

local cmcSetPointInProgress = false

local viewers = {
    {
        frame = BuffIconCooldownViewer,
        viewerName = "BuffIconCooldownViewer",
        nativeAnchorKey = "nativeBuffIcons",
        growthFrom = "cooldownManager_alignBuffIcons_growFromDirection",
        growthAnchorMode = "ALIGNMENT",
    },
    {
        frame = EssentialCooldownViewer,
        viewerName = "EssentialCooldownViewer",
        nativeAnchorKey = "nativeEssential",
        growthFrom = "cooldownManager_centerEssential_growFromDirection",
        growthAnchorMode = "GRID_STACK",
    },
    {
        frame = UtilityCooldownViewer,
        viewerName = "UtilityCooldownViewer",
        nativeAnchorKey = "nativeUtility",
        growthFrom = "cooldownManager_centerUtility_growFromDirection",
        growthAnchorMode = "GRID_STACK",
    },
    {
        frame = BuffBarCooldownViewer,
        viewerName = "BuffBarCooldownViewer",
        nativeAnchorKey = "nativeBuffBar",
        growthFrom = "cooldownManager_alignBuffBars_growFromDirection",
        growthAnchorMode = "VERTICAL_STACK",
    },
}

local function IsAnchorAnythingActive(frame)
    return ns.Anchoring and ns.Anchoring:IsAnchorAnythingActive(frame)
end

local function HasConfiguredCMCAnchor(viewerInfo)
    return viewerInfo.nativeAnchorKey and ns.Anchoring and ns.Anchoring:HasTarget(viewerInfo.nativeAnchorKey)
end

function EditModeHelp:ApplyConfiguredNativeAnchors()
    if not ns.Anchoring then
        return false
    end

    local applied = false
    for _, viewerInfo in ipairs(viewers) do
        local frame = viewerInfo.frame
        if frame and viewerInfo.nativeAnchorKey then
            ns.Anchoring:WatchFrame(frame, viewerInfo.nativeAnchorKey)
            if not IsAnchorAnythingActive(frame) and ns.Anchoring:HasTarget(viewerInfo.nativeAnchorKey) then
                applied = ns.Anchoring:ApplyAnchor(frame, viewerInfo.nativeAnchorKey) or applied
            elseif not IsAnchorAnythingActive(frame) then
                ns.Anchoring:ReleaseAnchor(frame, viewerInfo.nativeAnchorKey)
            end
        end
    end
    return applied
end

local function IsFrameHorizontal(frame)
    if frame.IsHorizontal then
        return frame:IsHorizontal()
    end
    return frame.isHorizontal ~= false
end

local function GetGrowthAnchorPoint(frame, growFromDirection, growthAnchorMode)
    if growthAnchorMode == "ALIGNMENT" then
        local isHorizontal = IsFrameHorizontal(frame)
        if growFromDirection == "START" then
            return isHorizontal and "LEFT" or "BOTTOM"
        elseif growFromDirection == "END" then
            return isHorizontal and "RIGHT" or "TOP"
        elseif growFromDirection == "CENTER" then
            return "CENTER"
        end
    elseif growthAnchorMode == "GRID_STACK" then
        if IsFrameHorizontal(frame) then
            return growFromDirection == "BOTTOM" and "BOTTOM" or "TOP"
        end
        return growFromDirection == "BOTTOM" and "RIGHT" or "LEFT"
    elseif growthAnchorMode == "VERTICAL_STACK" then
        return growFromDirection == "BOTTOM" and "BOTTOM" or "TOP"
    end
    return nil
end

local function GetPointAndOffset(frame, growFromDirection, growthAnchorMode)
    local _, relativeTo = frame:GetPoint(1)
    if relativeTo ~= UIParent then
        return nil
    end

    local point = GetGrowthAnchorPoint(frame, growFromDirection, growthAnchorMode)
    if not point then
        return nil
    end

    local frameX, frameY = frame:GetCenter()
    local parentX, parentY = UIParent:GetCenter()

    if point == "LEFT" then
        frameX, parentX = frame:GetLeft(), UIParent:GetLeft()
    elseif point == "RIGHT" then
        frameX, parentX = frame:GetRight(), UIParent:GetRight()
    elseif point == "BOTTOM" then
        frameY, parentY = frame:GetBottom(), UIParent:GetBottom()
    elseif point == "TOP" then
        frameY, parentY = frame:GetTop(), UIParent:GetTop()
    end

    if not frameX or not frameY or not parentX or not parentY then
        return nil
    end
    return {
        point = point,
        relativeTo = UIParent,
        relativePoint = point,
        x = frameX - parentX,
        y = frameY - parentY,
    }
end
local helpText = nil
local function GetHelpText()
    if not EditModeManagerFrame:GetAccountSettingValueBool(Enum.EditModeAccountSetting.SettingsExpanded) then
        return L['To edit Cooldown Manager\nclick "Expand options", and\nenable "Cooldown Manager" above']
    end
    return L['To edit Cooldown Manager\nenable "Cooldown Manager" above']
end
local function CreateHelpText()
    if not EditModeManagerFrame then
        return
    end
    if helpText then
        if not EditModeManagerFrame:GetAccountSettingValueBool(Enum.EditModeAccountSetting.ShowCooldownViewer) then
            helpText.text:SetText(GetHelpText())
        else
            helpText.text:SetText("")
        end
        return
    end
    helpText = CreateFrame("Frame", nil, EditModeManagerFrame)
    helpText:SetSize(400, 50)
    helpText:SetPoint("TOP", EditModeManagerFrame, "BOTTOM", 0, 20)
    helpText.text = helpText:CreateFontString(nil, "OVERLAY", "GameFontNormalLargeOutline")
    helpText.text:ClearAllPoints()
    helpText.text:SetAllPoints()
    helpText.text:SetText("")
    if not EditModeManagerFrame:GetAccountSettingValueBool(Enum.EditModeAccountSetting.ShowCooldownViewer) then
        helpText.text:SetText(GetHelpText())
    end
end
local arrowsForViewers = {}

for _, viewerInfo in ipairs(viewers) do
    local viewerName = viewerInfo.viewerName
    local newArrows = {
        top = {
            frame = CreateFrame("Frame", nil, UIParent),
            anchor = "BOTTOM",
        },
        left = {
            frame = CreateFrame("Frame", nil, UIParent),
            anchor = "RIGHT",
        },
        right = {
            frame = CreateFrame("Frame", nil, UIParent),
            anchor = "LEFT",
        },
        bottom = {
            frame = CreateFrame("Frame", nil, UIParent),
            anchor = "TOP",
        },
    }
    arrowsForViewers[viewerName] = newArrows
    for _, info in pairs(newArrows) do
        local frame = info.frame
        frame:SetParent(viewerInfo.frame)
    end
end
for _, viewerInfo in ipairs(viewers) do
    local viewerName = viewerInfo.viewerName
    local arrowFrames = arrowsForViewers[viewerName]
    for name, info in pairs(arrowFrames) do
        local frame = info.frame
        frame:SetSize(10, 14)
        frame:SetScale(1)
        frame.background = frame:CreateTexture(nil, "BACKGROUND")
        frame.background:ClearAllPoints()
        frame.background:SetAllPoints()
        frame.background:SetAtlas("bags-greenarrow", false)
        frame.background:SetRotation(name == "left" and math.pi / 2 or (name == "right" and -math.pi / 2 or (name == "bottom" and math.pi or 0)))
        frame:SetFrameStrata("HIGH")
        frame:Hide()
    end
end

local function UpdateFrameArrowsAnchors(forceHide)
    for _, viewerInfo in ipairs(viewers) do
        local viewerFrame = viewerInfo.frame
        local point = viewerFrame and viewerFrame:GetPoint(1)

        local viewerName = viewerInfo.viewerName
        local arrowFrames = arrowsForViewers[viewerName]
        for name, info in pairs(arrowFrames) do
            if point and viewerFrame then
                info.frame:SetPoint(info.anchor, viewerFrame, point, 0, 0)
            end
            info.frame:SetScale(1)

            info.frame:SetSize(10, 14)
            info.frame.background:SetScale(1)
            if info.frame.BCDMBorders then
                local regions = { info.frame:GetRegions() }
                for _, region in ipairs(regions) do
                    if region ~= info.frame.background then
                        region:Hide()
                    else
                        region:SetScale(1)
                        region:SetSize(10, 14)
                    end
                end
            end
            local pointLower = point and string.lower(point) or ""
            if
                forceHide
                or not viewerFrame
                or not viewerFrame:IsShown()
                or not point
                or not ns.Runtime.isInEditMode
                or pointLower:find(name)
                or viewerFrame.isDragging
            then
                info.frame:Hide()
            else
                info.frame:Show()
                info.frame:SetFrameStrata("HIGH")
            end
        end
    end
end

local function UpdateViewerAnchor(frame, viewerInfo)
    if
        IsAnchorAnythingActive(frame)
        or HasConfiguredCMCAnchor(viewerInfo)
        or not frame.IsInitialized
        or not frame:IsInitialized()
        or frame.layoutApplyInProgress
        or not frame:CanBeMoved()
    then
        return
    end
    local growthFrom = ns.db.profile[viewerInfo.growthFrom]
    if not viewerInfo.growthFrom or not growthFrom or growthFrom == "Disable" then
        return
    end
    if ns.Runtime.isInEditMode and EditModeManagerFrame:IsShown() then
        local data = GetPointAndOffset(frame, growthFrom, viewerInfo.growthAnchorMode)
        if not data or InCombatLockdown() then
            return
        end
        local currentPoint, currentRelativeTo, currentRelativePoint, offsetX, offsetY = frame:GetPoint()
        if
            currentPoint ~= data.point
            or currentRelativeTo ~= data.relativeTo
            or currentRelativePoint ~= data.relativePoint
            or math.abs(data.x - (offsetX or 0)) > 0.01
            or math.abs(data.y - (offsetY or 0)) > 0.01
        then
            cmcSetPointInProgress = true
            frame:ClearAllPoints()
            frame:SetPoint(data.point, data.relativeTo, data.relativePoint, data.x, data.y)
            cmcSetPointInProgress = false
            securecallfunction(EditModeManagerFrame.OnSystemPositionChange, EditModeManagerFrame, frame)
        end

        UpdateFrameArrowsAnchors()
    end
end

for _, viewerInfo in ipairs(viewers) do
    local frame = viewerInfo.frame
    if viewerInfo.nativeAnchorKey and ns.Anchoring then
        ns.Anchoring:WatchFrame(frame, viewerInfo.nativeAnchorKey)
    end
    hooksecurefunc(frame, "SetPoint", function()
        if
            cmcSetPointInProgress
            or IsAnchorAnythingActive(frame)
            or HasConfiguredCMCAnchor(viewerInfo)
            or not frame.IsInitialized
            or not frame:IsInitialized()
            or frame.layoutApplyInProgress
            or not frame:CanBeMoved()
        then
            return
        end
        C_Timer.After(0, function()
            UpdateViewerAnchor(frame, viewerInfo)
        end)
    end)
end

local function AddArrowsToTrinketRacialTracker()
    local count = (ns.TrackerItemViewer and ns.TrackerItemViewer:GetTrackerCount()) or (ns.db and ns.db.profile and ns.db.profile.tracker_count) or 2
    for i = 1, count do
        local viewerName = "CMCTracker" .. i
        -- Skip (rather than return) so a missing/absent tracker doesn't block
        -- arrow setup for the remaining trackers.
        if not arrowsForViewers[viewerName] and _G[viewerName] then
            local arrowFrames = {
                top = {
                    frame = CreateFrame("Frame", nil, UIParent),
                    anchor = "BOTTOM",
                },
                left = {
                    frame = CreateFrame("Frame", nil, UIParent),
                    anchor = "RIGHT",
                },
                right = {
                    frame = CreateFrame("Frame", nil, UIParent),
                    anchor = "LEFT",
                },
                bottom = {
                    frame = CreateFrame("Frame", nil, UIParent),
                    anchor = "TOP",
                },
            }
            for name, info in pairs(arrowFrames) do
                local frame = info.frame
                frame:SetSize(10, 14)
                frame:SetScale(1)
                frame.background = frame:CreateTexture(nil, "BACKGROUND")
                frame.background:ClearAllPoints()
                frame.background:SetAllPoints()
                frame.background:SetAtlas("bags-greenarrow", false)
                frame.background:SetRotation(name == "left" and math.pi / 2 or (name == "right" and -math.pi / 2 or (name == "bottom" and math.pi or 0)))
                frame:SetFrameStrata("HIGH")
                frame:Hide()
            end
            arrowsForViewers[viewerName] = arrowFrames
            table.insert(viewers, {
                frame = _G[viewerName],
                viewerName = viewerName,
            })
        end
    end
end

local function AddArrowsToBuffContainers()
    if not (ns.BuffData and ns.BuffData.IsEnabled()) then
        return
    end
    local count = ns.BuffData.GetContainerCount() or 0
    for i = 1, count do
        local viewerName = "CMCBuffContainer" .. i
        if not arrowsForViewers[viewerName] and _G[viewerName] then
            local arrowFrames = {
                top = {
                    frame = CreateFrame("Frame", nil, UIParent),
                    anchor = "BOTTOM",
                },
                left = {
                    frame = CreateFrame("Frame", nil, UIParent),
                    anchor = "RIGHT",
                },
                right = {
                    frame = CreateFrame("Frame", nil, UIParent),
                    anchor = "LEFT",
                },
                bottom = {
                    frame = CreateFrame("Frame", nil, UIParent),
                    anchor = "TOP",
                },
            }
            for name, info in pairs(arrowFrames) do
                local frame = info.frame
                frame:SetSize(10, 14)
                frame:SetScale(1)
                frame.background = frame:CreateTexture(nil, "BACKGROUND")
                frame.background:ClearAllPoints()
                frame.background:SetAllPoints()
                frame.background:SetAtlas("bags-greenarrow", false)
                frame.background:SetRotation(name == "left" and math.pi / 2 or (name == "right" and -math.pi / 2 or (name == "bottom" and math.pi or 0)))
                frame:SetFrameStrata("HIGH")
                frame:Hide()
            end
            arrowsForViewers[viewerName] = arrowFrames
            table.insert(viewers, {
                frame = _G[viewerName],
                viewerName = viewerName,
            })
        end
    end
end

local ticker = nil
hooksecurefunc(EditModeManagerFrame, "Show", function()
    CreateHelpText()
    AddArrowsToTrinketRacialTracker()
    AddArrowsToBuffContainers()
    if ticker then
        ticker:Cancel()
        ticker = nil
    end
    C_Timer.After(0, function()
        UpdateFrameArrowsAnchors()
    end)
    ticker = C_Timer.NewTicker(0.5, function()
        CreateHelpText()
        UpdateFrameArrowsAnchors()
    end)
end)

hooksecurefunc(EditModeManagerFrame, "Hide", function()
    C_Timer.After(0, function()
        UpdateFrameArrowsAnchors()
        if ticker then
            ticker:Cancel()
            ticker = nil
        end
    end)
end)
