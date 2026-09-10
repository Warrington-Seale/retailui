local _, FTA = ...

FTA.StepList = FTA.StepList or {}
FTA.StepList.rows = FTA.StepList.rows or {}

local AcquireRow
local QuestDone

local function DoSelectModule(moduleID)
  if not moduleID or moduleID == "" then return end

  if FTA.SelectModule then
    FTA:SelectModule(moduleID)
    return
  end

  if type(FTACharDB) == "table" and type(FTACharDB.progress) == "table" then
    FTACharDB.progress.activeModuleId = moduleID
    FTACharDB.progress.stepIndexByModule = FTACharDB.progress.stepIndexByModule or {}
    if FTACharDB.progress.stepIndexByModule[moduleID] == nil then
      FTACharDB.progress.stepIndexByModule[moduleID] = 1
    end
  end

  if FTA.StepEngine and FTA.StepEngine.SetActiveModule then
    FTA.StepEngine:SetActiveModule(moduleID)
  end

  if FTA.UI and FTA.UI.Refresh then
    FTA.UI:Refresh()
  elseif FTA.UI and FTA.UI.RefreshAll then
    FTA.UI:RefreshAll()
  end
end

local function ToggleManualSegment(moduleId, stepIndex, seg, segIndex)
  if not (FTA.StepEngine and FTA.StepEngine.ToggleManualSegmentComplete) then return end
  FTA.StepEngine:ToggleManualSegmentComplete(moduleId, stepIndex, seg, segIndex)
  if FTA.FullRefresh then
    FTA:FullRefresh("MANUAL_SEGMENT_TOGGLE")
  elseif FTA.UI and FTA.UI.Refresh then
    FTA.UI:Refresh()
  end
end

local function FindSegmentIndex(step, targetSeg)
  if type(step) ~= "table" or type(step.segments) ~= "table" then return nil end
  for i, seg in ipairs(step.segments) do
    if seg == targetSeg then
      return i
    end
  end
  return nil
end

local function EnsureImagePopup()
  if FTA.StepList._imgPopup then
    return FTA.StepList._imgPopup
  end

  local f = CreateFrame("Frame", "FollowTheArrow_ImagePopup", UIParent, "BackdropTemplate")
  FTA.StepList._imgPopup = f

  f:SetFrameStrata("DIALOG")
  f:SetClampedToScreen(true)
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(self) self:StartMoving() end)
  f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

  f:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  })
  f:SetBackdropColor(0, 0, 0, 0.92)

  local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", 2, 2)

  local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  title:SetPoint("TOPLEFT", 10, -8)
  title:SetText("")
  f._title = title

  local tex = f:CreateTexture(nil, "ARTWORK")
  f._tex = tex

  f:Hide()
  return f
end

local function ShowImagePopup(seg)
  if type(seg) ~= "table" then return end

  local path = seg.image or seg.full or seg.texture
  if type(path) ~= "string" or path == "" then return end

  local f = EnsureImagePopup()

  local pad = tonumber(seg.popupPad) or 8
  if pad < 2 then pad = 2 end
  if pad > 24 then pad = 24 end

  local titleText = seg.title or seg.popupTitle or ""
  f._title:SetText(titleText)

  local topPad = pad + 18
  f._tex:ClearAllPoints()
  f._tex:SetPoint("TOPLEFT", f, "TOPLEFT", pad + 4, -(topPad + 4))
  f._tex:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -(pad + 4), pad + 4)

  f._tex:SetTexture(path)

  if type(seg.texCoord) == "table" and #seg.texCoord == 4 then
    f._tex:SetTexCoord(seg.texCoord[1], seg.texCoord[2], seg.texCoord[3], seg.texCoord[4])
  else
    f._tex:SetTexCoord(0, 1, 0, 1)
  end

  local iw = tonumber(seg.imageW) or tonumber(seg.fullW) or 1600
  local ih = tonumber(seg.imageH) or tonumber(seg.fullH) or 720

  local frameW = iw + (pad * 2) + 8
  local frameH = ih + (pad * 2) + 8 + 18

  local maxW = math.floor(UIParent:GetWidth() * 0.95)
  local maxH = math.floor(UIParent:GetHeight() * 0.90)
  if frameW > maxW then frameW = maxW end
  if frameH > maxH then frameH = maxH end
  if frameW < 320 then frameW = 320 end
  if frameH < 240 then frameH = 240 end

  f:ClearAllPoints()
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  f:SetSize(frameW, frameH)
  f:Show()
end

local function EnsureButton(row)
  if row.btn then return row.btn end

  local btn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
  row.btn = btn
  btn:SetHeight(22)

  btn:SetScript("OnClick", function(self)
    DoSelectModule(self._moduleID)
  end)

  btn:SetScript("OnEnter", function(self)
    if self._tooltip and self._tooltip ~= "" then
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:SetText(self._tooltip, 1, 1, 1)
      GameTooltip:Show()
    end
  end)

  btn:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  return btn
end

local function EnsureManualCheck(row)
  if row.manualCheck then return row.manualCheck end

  local holder = CreateFrame("Frame", nil, row, "BackdropTemplate")
  row.manualCheckHolder = holder
  holder:SetSize(28, 28)
  holder:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 14,
    insets = { left = 3, right = 3, top = 3, bottom = 3 },
  })
  holder:SetBackdropColor(0, 0, 0, 0.35)
  holder:SetBackdropBorderColor(1.0, 0.82, 0.0, 0.95)

  local cb = CreateFrame("CheckButton", nil, holder, "UICheckButtonTemplate")
  row.manualCheck = cb
  cb:SetSize(24, 24)
  cb:SetScale(1.15)
  cb:SetPoint("CENTER", holder, "CENTER", .3, -.5)

  local normal = cb:GetNormalTexture()
  if normal then
    normal:ClearAllPoints()
    normal:SetAllPoints(cb)
  end

  local pushed = cb:GetPushedTexture()
  if pushed then
    pushed:ClearAllPoints()
    pushed:SetAllPoints(cb)
  end

  local highlight = cb:GetHighlightTexture()
  if highlight then
    highlight:ClearAllPoints()
    highlight:SetAllPoints(cb)
    highlight:SetAlpha(0.15)
  end

  local checked = cb:GetCheckedTexture()
  if checked then
    checked:ClearAllPoints()
    checked:SetAllPoints(cb)
  end

  cb:SetScript("OnClick", function(self)
    ToggleManualSegment(self._moduleId, self._stepIndex, self._seg, self._segIndex)
  end)

  cb:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(self:GetChecked() and "Mark as Incomplete." or "Mark as Complete.", 1, 1, 1)
    GameTooltip:Show()
  end)

  cb:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  return cb
end

local function EnsureThumbButton(row)
  if row.thumbBtn then return row.thumbBtn end

  local b = CreateFrame("Button", nil, row, "BackdropTemplate")
  row.thumbBtn = b

  if row.thumbBorder and row.thumbBorder.Hide then
    row.thumbBorder:Hide()
  end
  row.thumbBorder = nil

  local icon = b:CreateTexture(nil, "BACKGROUND")
  row.thumbIcon = icon
  icon:ClearAllPoints()
  icon:SetPoint("TOPLEFT", b, "TOPLEFT", 2, -2)
  icon:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -2, 2)
  icon:SetTexCoord(0.07, 0.93, 0.10, 0.90)

  local borderFrame = CreateFrame("Frame", nil, b, "BackdropTemplate")
  row.thumbBorderFrame = borderFrame
  borderFrame:ClearAllPoints()
  borderFrame:SetAllPoints(b)
  borderFrame:SetBackdrop({
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 14,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
  })
  borderFrame:SetBackdropBorderColor(0.72, 0.72, 0.72, 0.95)

  local hl = b:CreateTexture(nil, "HIGHLIGHT")
  row.thumbHighlight = hl
  hl:SetAllPoints(b)
  hl:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
  hl:SetBlendMode("ADD")
  hl:SetAlpha(0.35)

  local pushed = b:CreateTexture(nil, "ARTWORK")
  row.thumbPushed = pushed
  pushed:SetAllPoints(b)
  pushed:SetColorTexture(0, 0, 0, 0.35)
  pushed:Hide()

  b:SetScript("OnMouseDown", function(self)
    if self:IsEnabled() and row.thumbPushed then
      row.thumbPushed:Show()
    end
  end)
  b:SetScript("OnMouseUp", function()
    if row.thumbPushed then row.thumbPushed:Hide() end
  end)
  b:SetScript("OnHide", function()
    if row.thumbPushed then row.thumbPushed:Hide() end
  end)

  b:SetScript("OnClick", function(self)
    if type(self._onClick) == "function" then
      self._onClick(self)
      return
    end
    DoSelectModule(self._moduleID)
  end)

  b:SetScript("OnEnter", function(self)
    if self._tooltip and self._tooltip ~= "" then
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:SetText(self._tooltip, 1, 1, 1)
      GameTooltip:Show()
    end
  end)
  b:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  b:Hide()
  return b
end

local function EnsureChoiceTile(row, i)
  row._choiceTiles = row._choiceTiles or {}
  local t = row._choiceTiles[i]
  if t then
    t:Show()
    return t
  end

  t = CreateFrame("Frame", nil, row)
  row._choiceTiles[i] = t

  local thumb = CreateFrame("Button", nil, t, "BackdropTemplate")
  t.thumbBtn = thumb

  local icon = thumb:CreateTexture(nil, "BACKGROUND")
  t.thumbIcon = icon
  icon:SetPoint("TOPLEFT", thumb, "TOPLEFT", 2, -2)
  icon:SetPoint("BOTTOMRIGHT", thumb, "BOTTOMRIGHT", -2, 2)
  icon:SetTexCoord(0.0556, 0.9444, 0.0, 1.0)

  local borderFrame = CreateFrame("Frame", nil, thumb, "BackdropTemplate")
  t.thumbBorderFrame = borderFrame
  borderFrame:SetAllPoints(thumb)
  borderFrame:SetBackdrop({
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 14,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
  })
  borderFrame:SetBackdropBorderColor(0.72, 0.72, 0.72, 0.95)

  local hl = thumb:CreateTexture(nil, "HIGHLIGHT")
  t.thumbHighlight = hl
  hl:SetAllPoints(thumb)
  hl:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
  hl:SetBlendMode("ADD")
  hl:SetAlpha(0.35)

  local pushed = thumb:CreateTexture(nil, "ARTWORK")
  t.thumbPushed = pushed
  pushed:SetAllPoints(thumb)
  pushed:SetColorTexture(0, 0, 0, 0.35)
  pushed:Hide()

  thumb:SetScript("OnMouseDown", function(self)
    if self:IsEnabled() and t.thumbPushed then t.thumbPushed:Show() end
  end)
  thumb:SetScript("OnMouseUp", function()
    if t.thumbPushed then t.thumbPushed:Hide() end
  end)
  thumb:SetScript("OnHide", function()
    if t.thumbPushed then t.thumbPushed:Hide() end
  end)

  thumb:SetScript("OnEnter", function(self)
    if self._tooltip and self._tooltip ~= "" then
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:SetText(self._tooltip, 1, 1, 1)
      GameTooltip:Show()
    end
  end)
  thumb:SetScript("OnLeave", function() GameTooltip:Hide() end)

  thumb:SetScript("OnClick", function(self)
    DoSelectModule(self._moduleID)
  end)

  local btn = CreateFrame("Button", nil, t, "UIPanelButtonTemplate")
  t.btn = btn
  btn:SetScript("OnClick", function(self)
    DoSelectModule(self._moduleID)
  end)

  btn:SetScript("OnEnter", function(self)
    if self._tooltip and self._tooltip ~= "" then
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:SetText(self._tooltip, 1, 1, 1)
      GameTooltip:Show()
    end
  end)
  btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

  return t
end

local function HideUnusedChoiceTiles(row, fromIndex)
  if not row._choiceTiles then return end
  for i = fromIndex, #row._choiceTiles do
    local t = row._choiceTiles[i]
    if t then t:Hide() end
  end
end

local function RenderModuleChoiceRow(host, width, y, rowIndex, seg)
  local row = AcquireRow(host, rowIndex); rowIndex = rowIndex + 1
  row:SetPoint("TOPLEFT", 0, y)
  row:SetPoint("TOPRIGHT", 0, y)

  if row.btn then row.btn:Hide() end
  if row.thumbBtn then row.thumbBtn:Hide() end
  if row.manualCheck then row.manualCheck:Hide() end
  if row.manualCheckHolder then row.manualCheckHolder:Hide() end

  row.text:SetText("")
  row.sub:SetText("")

  local choices = {}
  if type(seg) == "table" and type(seg.choices) == "table" then
    for _, c in ipairs(seg.choices) do
      if c and c.moduleID then
        if type(c.finalQuestID) == "number" and QuestDone(c.finalQuestID) then
        else
          table.insert(choices, c)
        end
      end
    end
  end

  if #choices == 0 and type(seg) == "table" and type(seg.final) == "table" and seg.final.moduleID then
    table.insert(choices, seg.final)
  end

  local n = #choices
  if n == 0 then
    HideUnusedChoiceTiles(row, 1)
    row:SetHeight(1)
    return y, rowIndex
  end

  local gap = tonumber(seg.gap) or 10
  if gap < 0 then gap = 0 end

  local padTop = tonumber(seg.padTop) or 4
  local padBottom = tonumber(seg.padBottom) or 8

  local thumbH = tonumber(seg.thumbH) or 90
  if thumbH < 50 then thumbH = 50 end
  if thumbH > 140 then thumbH = 140 end

  local btnH = tonumber(seg.btnH) or 22
  if btnH < 18 then btnH = 18 end
  if btnH > 28 then btnH = 28 end

  local availW = math.max(1, math.floor(width or 1))

  local singlePct   = tonumber(seg.singleWidthPct) or 0.65
  local singleMinW  = tonumber(seg.singleMinW) or 140
  local singleMaxW  = tonumber(seg.singleMaxW) or 260

  local multiMinW   = tonumber(seg.multiMinW) or 90
  local multiMaxW   = tonumber(seg.multiMaxW) or availW

  local tileW
  if n == 1 then
    tileW = math.floor(availW * singlePct)
    if tileW < singleMinW then tileW = singleMinW end
    if tileW > singleMaxW then tileW = singleMaxW end
    if tileW > availW then tileW = availW end
  else
    tileW = math.floor((availW - (gap * (n - 1))) / n)
    if tileW < multiMinW then tileW = multiMinW end
    if tileW > multiMaxW then tileW = multiMaxW end
  end

  local totalW = (tileW * n) + (gap * (n - 1))
  if totalW > availW then
    totalW = availW
  end
  local startX = math.floor((availW - totalW) / 2)

  for i = 1, n do
    local c = choices[i]
    local moduleID = c.moduleID

    local t = EnsureChoiceTile(row, i)
    t:ClearAllPoints()
    t:SetPoint("TOPLEFT", row, "TOPLEFT", startX + ((i - 1) * (tileW + gap)), -padTop)
    t:SetSize(tileW, thumbH + 4 + btnH)

    t.thumbBtn:ClearAllPoints()
    t.thumbBtn:SetPoint("TOPLEFT", t, "TOPLEFT", 0, 0)
    t.thumbBtn:SetSize(tileW, thumbH)

    t.btn:ClearAllPoints()
    t.btn:SetPoint("TOPLEFT", t.thumbBtn, "BOTTOMLEFT", 0, -4)
    t.btn:SetSize(tileW, btnH)

    t.btn:SetText(c.label or "Open Guide")
    t.btn._moduleID = moduleID
    t.btn._tooltip = c.tooltip

    t.thumbBtn._moduleID = moduleID
    t.thumbBtn._tooltip = c.tooltip
    t.thumbBtn:SetEnabled(c.disabled ~= true)
    t.btn:SetEnabled(c.disabled ~= true)

    if t.thumbIcon then
      t.thumbIcon:SetTexture(c.thumbnail or c.thumb or c.texture)
      if type(c.thumbTexCoord) == "table" and #c.thumbTexCoord == 4 then
        t.thumbIcon:SetTexCoord(c.thumbTexCoord[1], c.thumbTexCoord[2], c.thumbTexCoord[3], c.thumbTexCoord[4])
      else
        t.thumbIcon:SetTexCoord(0.0556, 0.9444, 0.0, 1.0)
      end
    end
  end

  HideUnusedChoiceTiles(row, n + 1)

  local usedH = padTop + thumbH + 4 + btnH + padBottom
  row:SetHeight(usedH)
  y = y - (row:GetHeight() + 6)

  return y, rowIndex
end

function AcquireRow(parent, i)
  local rows = FTA.StepList.rows
  local row = rows[i]
  if row then
    row:SetParent(parent)
    row:Show()

    if row.btn then row.btn:Hide() end
    if row.thumbBtn then row.thumbBtn:Hide() end
    if row.manualCheck then row.manualCheck:Hide() end
    if row.manualCheckHolder then row.manualCheckHolder:Hide() end

    if row._choiceTiles then
      for _, t in ipairs(row._choiceTiles) do
        if t then t:Hide() end
      end
    end

    return row
  end

  row = CreateFrame("Frame", nil, parent)
  rows[i] = row

  row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  row.text:SetPoint("TOPLEFT", 0, 0)
  row.text:SetJustifyH("LEFT")
  row.text:SetWordWrap(true)

  row.sub = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  row.sub:SetPoint("TOPLEFT", row.text, "BOTTOMLEFT", 0, -2)
  row.sub:SetJustifyH("LEFT")
  row.sub:SetWordWrap(true)

  return row
end

local function HideExtraRows(fromIndex)
  for i = fromIndex, #FTA.StepList.rows do
    local r = FTA.StepList.rows[i]
    if r then r:Hide() end
  end
end

local function RenderHeader(host, y, label)
  local fs = host:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fs:SetPoint("TOPLEFT", 0, y)
  fs:SetText(label)
  return fs, y - 18
end

local function StepLabel(step, index)
  if not step then return "" end
  local t = step.title or step.text or step.name
  if t and t ~= "" then
    return t
  end
  return ("Step %d"):format(index or 0)
end

local function ReplaceProgressToken(text, prog)
  if type(text) ~= "string" then return text end
  if type(prog) ~= "string" then prog = "" end
  prog = prog:gsub("%%", "%%%%")
  return text:gsub("%{progress%}", prog)
end

local function RemoveProgressToken(text)
  if type(text) ~= "string" then return text end
  text = text:gsub("%{progress%}%s*", "")
  text = text:gsub("%s+%.", ".")
  return text
end

local function BuildLine(seg)
  if not seg or not seg.kind then return "" end

  if seg.kind == "NOTE" then
    return "Notes: " .. (seg.text or "")
  end

  if seg.kind == "PICKUP" then
    if seg.text and seg.text ~= "" then return seg.text end
    if FTA.Text and FTA.Text.PickupLine then
      return FTA.Text:PickupLine(seg.questName)
    end
    return "Pick up quest."
  end

  if seg.kind == "TURNIN" then
    if seg.text and seg.text ~= "" then return seg.text end
    if FTA.Text and FTA.Text.TurnInLine then
      return FTA.Text:TurnInLine(seg.questName)
    end
    return "Turn in quest."
  end

  if seg.kind == "OBJECTIVE" then
    local base = seg.text or "Complete objective {progress}."
    local prog = nil
    if (seg.showProgress ~= false) and FTA.Resolve and FTA.Resolve.GetSegmentProgressText then
      prog = FTA.Resolve:GetSegmentProgressText(seg)
    end

    if prog then
      base = ReplaceProgressToken(base, prog)
    else
      base = RemoveProgressToken(base)
    end

    return base
  end

  if seg.kind == "MANUAL" then
    return seg.text or "Complete this objective."
  end

  return seg.text or ""
end

local function GetCampaignConfig(seg)
  if type(seg) == "table" and type(seg.branches) == "table" and type(seg.final) == "table" then
    return { branches = seg.branches, final = seg.final }
  end

  if type(seg) == "table" and type(seg.campaignId) == "string" and type(FTA.Campaign) == "table" then
    local c = FTA.Campaign[seg.campaignId]
    if type(c) == "table" and type(c.branches) == "table" and type(c.final) == "table" then
      return c
    end
  end

  return nil
end

function QuestDone(finalQuestID)
  if type(finalQuestID) ~= "number" or not FTA.Quest then return false end

  if FTA.Quest.IsQuestCreditCached and FTA.Quest:IsQuestCreditCached(finalQuestID) then
    return true
  end
  if FTA.Quest.RefreshQuestCredit then
    return FTA.Quest:RefreshQuestCredit(finalQuestID) == true
  end

  if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
    local ok = C_QuestLog.IsQuestFlaggedCompleted(finalQuestID)
    if ok and FTA.Quest.MarkQuestCredit then
      FTA.Quest:MarkQuestCredit(finalQuestID)
    end
    return ok == true
  end

  return false
end

local function BuildCampaignProgressText(done, total, doneList, remaining, final)
  if done <= 0 then
    return ("You're about to start the 3-zone arc (%d/%d complete). Pick your first zone:"):format(done, total)
  elseif done == 1 then
    local first = (doneList[1] and doneList[1].title) or "your first zone"
    if #remaining == 2 then
      return ("You're finished with %s (1/%d). Now pick your second zone: %s or %s."):format(
        first, total, remaining[1].title or "Zone A", remaining[2].title or "Zone B"
      )
    end
    return ("You're finished with %s (1/%d). Now pick your next zone."):format(first, total)
  elseif done == 2 then
    local a = (doneList[1] and doneList[1].title) or "Zone A"
    local b = (doneList[2] and doneList[2].title) or "Zone B"
    local last = (remaining[1] and remaining[1].title) or "the final zone"
    return ("Now that you've finished %s and %s (2/%d), you only have %s left!"):format(a, b, total, last)
  else
    local fTitle = (final and final.title) or "the final zone"
    return ("All 3 prerequisite zones complete (3/%d). You can proceed to %s."):format(total, fTitle)
  end
end

local function RenderTextRow(host, width, y, rowIndex, text, color, indentBullet, opts)
  local row = AcquireRow(host, rowIndex); rowIndex = rowIndex + 1
  row:SetPoint("TOPLEFT", 0, y)
  row:SetPoint("TOPRIGHT", 0, y)

  if row.btn then row.btn:Hide() end
  if row.thumbBtn then row.thumbBtn:Hide() end

  local textWidth = width

  if opts and opts.manual == true then
    local cb = EnsureManualCheck(row)
    local holder = row.manualCheckHolder

    holder:ClearAllPoints()
    holder:SetPoint("TOPRIGHT", row, "TOPRIGHT", -3, 0)
    holder:Show()

    cb._moduleId = opts.moduleId
    cb._stepIndex = opts.stepIndex
    cb._seg = opts.seg
    cb._segIndex = opts.segIndex
    cb:SetChecked(opts.checked == true)
    cb:Show()

    textWidth = math.max(1, width - 34)
  else
    if row.manualCheck then row.manualCheck:Hide() end
    if row.manualCheckHolder then row.manualCheckHolder:Hide() end
  end

  row.text:SetWidth(textWidth)
  row.text:SetTextColor(color[1], color[2], color[3], color[4] or 1)

  if indentBullet then
    row.text:SetText("• " .. (text or ""))
  else
    row.text:SetText(text or "")
  end

  row.sub:SetText("")

  local hText = row.text:GetStringHeight()
  local minH = (opts and opts.manual == true) and 30 or 0
  row:SetHeight(math.max(hText + 6, minH))
  y = y - (row:GetHeight() + 4)

  return y, rowIndex
end

local function RenderImagePopupRow(host, width, y, rowIndex, seg)
  local row = AcquireRow(host, rowIndex); rowIndex = rowIndex + 1
  row:SetPoint("TOPLEFT", 0, y)
  row:SetPoint("TOPRIGHT", 0, y)

  if row.btn then row.btn:Hide() end
  if row.manualCheck then row.manualCheck:Hide() end
  if row.manualCheckHolder then row.manualCheckHolder:Hide() end

  row.text:SetText("")
  row.sub:SetText("")

  local thumbPath = seg and (seg.thumbnail or seg.thumb)
  local thumbW = tonumber(seg and (seg.thumbW or seg.thumbnailW)) or 160
  local thumbH = tonumber(seg and (seg.thumbH or seg.thumbnailH)) or 90
  local padTop = tonumber(seg and seg.thumbPadTop) or 2
  local padBottom = tonumber(seg and seg.thumbPadBottom) or 6

  if type(thumbPath) ~= "string" or thumbPath == "" then
    if row.thumbBtn then row.thumbBtn:Hide() end
    row:SetHeight(1)
    return y, rowIndex
  end

  local maxThumbW = (width or thumbW)
  if thumbW > maxThumbW then thumbW = maxThumbW end
  if thumbW < 40 then thumbW = 40 end

  local tb = EnsureThumbButton(row)
  tb:ClearAllPoints()
  tb:SetSize(thumbW, thumbH)
  tb:SetPoint("TOP", row, "TOP", 0, -padTop)

  tb._tooltip = seg.tooltip or "Click to enlarge"
  tb._moduleID = nil

  if row.thumbIcon then
    row.thumbIcon:SetTexture(thumbPath)
    if type(seg.thumbTexCoord) == "table" and #seg.thumbTexCoord == 4 then
      row.thumbIcon:SetTexCoord(seg.thumbTexCoord[1], seg.thumbTexCoord[2], seg.thumbTexCoord[3], seg.thumbTexCoord[4])
    else
      row.thumbIcon:SetTexCoord(0.0556, 0.9444, 0.0, 1.0)
    end
  end

  tb._onClick = function()
    ShowImagePopup(seg)
  end

  tb:SetEnabled(seg.disabled ~= true)
  tb:Show()

  local usedH = padTop + thumbH + padBottom
  row:SetHeight(usedH)
  y = y - (row:GetHeight() + 6)

  if seg.label and seg.label ~= "" then
    y, rowIndex = RenderTextRow(host, width, y, rowIndex, seg.label, {0.78, 0.78, 0.78, 1}, false)
  end

  return y, rowIndex
end

local function RenderVideoEmbedRow(host, width, y, rowIndex, seg)
  local row = AcquireRow(host, rowIndex); rowIndex = rowIndex + 1
  row:SetPoint("TOPLEFT", 0, y)
  row:SetPoint("TOPRIGHT", 0, y)

  if row.btn then row.btn:Hide() end
  if row.manualCheck then row.manualCheck:Hide() end
  if row.manualCheckHolder then row.manualCheckHolder:Hide() end

  row.text:SetText("")
  row.sub:SetText("")

  local thumbPath = seg and (seg.thumbnail or seg.thumb or seg.texture)
  local thumbW = tonumber(seg and (seg.width or seg.thumbW or seg.thumbnailW)) or 320
  local thumbH = tonumber(seg and (seg.height or seg.thumbH or seg.thumbnailH)) or 180
  local padTop = tonumber(seg and seg.thumbPadTop) or 2
  local padBottom = tonumber(seg and seg.thumbPadBottom) or 6

  if type(thumbPath) ~= "string" or thumbPath == "" then
    if row.thumbBtn then row.thumbBtn:Hide() end
    row:SetHeight(1)
    return y, rowIndex
  end

  local maxThumbW = (width or thumbW)
  if thumbW > maxThumbW then thumbW = maxThumbW end
  if thumbW < 40 then thumbW = 40 end

  local tb = EnsureThumbButton(row)
  tb:ClearAllPoints()
  tb:SetSize(thumbW, thumbH)
  tb:SetPoint("TOP", row, "TOP", 0, -padTop)

  tb._tooltip = seg.tooltip or seg.tooltipTitle or seg.label or "Click to copy video URL"
  tb._moduleID = nil

  if row.thumbIcon then
    row.thumbIcon:SetTexture(thumbPath)
    if type(seg.thumbTexCoord) == "table" and #seg.thumbTexCoord == 4 then
      row.thumbIcon:SetTexCoord(seg.thumbTexCoord[1], seg.thumbTexCoord[2], seg.thumbTexCoord[3], seg.thumbTexCoord[4])
    elseif type(seg.texCoord) == "table" and #seg.texCoord == 4 then
      row.thumbIcon:SetTexCoord(seg.texCoord[1], seg.texCoord[2], seg.texCoord[3], seg.texCoord[4])
    else
      row.thumbIcon:SetTexCoord(0, 1, 0, 1)
    end
  end

  tb._onClick = function()
    if FTA.UI and FTA.UI.ShowEmbedURL then
      FTA.UI:ShowEmbedURL(seg.url)
    end
  end

  tb:SetEnabled(seg.disabled ~= true)
  tb:Show()

  local usedH = padTop + thumbH + padBottom
  row:SetHeight(usedH)
  y = y - (row:GetHeight() + 6)

  if seg.label and seg.label ~= "" then
    y, rowIndex = RenderTextRow(host, width, y, rowIndex, seg.label, {0.78, 0.78, 0.78, 1}, false)
  end

  return y, rowIndex
end

local function RenderModuleButtonRow(host, width, y, rowIndex, seg)
  local row = AcquireRow(host, rowIndex); rowIndex = rowIndex + 1
  row:SetPoint("TOPLEFT", 0, y)
  row:SetPoint("TOPRIGHT", 0, y)

  if row.manualCheck then row.manualCheck:Hide() end
  if row.manualCheckHolder then row.manualCheckHolder:Hide() end

  row.text:SetText("")
  row.sub:SetText("")

  local thumbPath = seg and (seg.thumbnail or seg.thumb or seg.texture)
  local thumbW = tonumber(seg and (seg.thumbW or seg.thumbnailW)) or 160
  local thumbH = tonumber(seg and (seg.thumbH or seg.thumbnailH)) or 90
  local thumbPadTop = tonumber(seg and seg.thumbPadTop) or 2
  local thumbPadBottom = tonumber(seg and seg.thumbPadBottom) or 8

  local btnH = 22
  local btnPadTop = tonumber(seg and seg.btnPadTop) or 0

  local minBtnW = tonumber(seg and seg.minWidth) or 140
  local maxBtnW = tonumber(seg and seg.maxWidth) or 260
  local pct = tonumber(seg and seg.widthPct) or 0.65

  local btnW = math.floor((width or 0) * pct)
  if btnW < minBtnW then btnW = minBtnW end
  if btnW > maxBtnW then btnW = maxBtnW end
  if btnW > (width or btnW) then btnW = width end

  local usedThumbH = 0

  if type(thumbPath) == "string" and thumbPath ~= "" then
    local maxThumbW = (width or thumbW)
    if thumbW > maxThumbW then thumbW = maxThumbW end
    if thumbW < 40 then thumbW = 40 end

    local tb = EnsureThumbButton(row)
    tb:ClearAllPoints()
    tb:SetSize(thumbW, thumbH)
    tb:SetPoint("TOP", row, "TOP", 0, -thumbPadTop)
    tb._moduleID = seg.moduleID
    tb._tooltip = seg.tooltip
    tb._onClick = nil

    if row.thumbIcon then
      row.thumbIcon:SetTexture(thumbPath)
      if type(seg.thumbTexCoord) == "table" and #seg.thumbTexCoord == 4 then
        row.thumbIcon:SetTexCoord(seg.thumbTexCoord[1], seg.thumbTexCoord[2], seg.thumbTexCoord[3], seg.thumbTexCoord[4])
      else
        row.thumbIcon:SetTexCoord(0.0556, 0.9444, 0.0, 1.0)
      end
    end

    tb:SetEnabled(seg.disabled ~= true)
    tb:Show()

    usedThumbH = thumbPadTop + thumbH + thumbPadBottom
    btnW = thumbW
  else
    if row.thumbBtn then row.thumbBtn:Hide() end
  end

  local btn = EnsureButton(row)
  btn:ClearAllPoints()
  btn:SetSize(btnW, btnH)
  btn:SetPoint("TOP", row, "TOP", 0, -(usedThumbH + btnPadTop))
  btn:SetText(seg.label or "Open Guide")
  btn._moduleID = seg.moduleID
  btn._tooltip = seg.tooltip
  btn:SetEnabled(seg.disabled ~= true)
  btn:Show()

  row:SetHeight(usedThumbH + btnPadTop + btnH)
  y = y - (row:GetHeight() + 6)

  return y, rowIndex
end

local function ExpandCampaignChoiceSegments(seg)
  local cfg = GetCampaignConfig(seg)
  if not cfg then
    return { { kind = "NOTE", text = "Campaign config missing for this choice block." } }
  end

  local branches = cfg.branches
  local final = cfg.final
  local total = #branches

  local doneList, remaining = {}, {}
  local done = 0

  for _, b in ipairs(branches) do
    if b and type(b.finalQuestID) == "number" and QuestDone(b.finalQuestID) then
      done = done + 1
      table.insert(doneList, b)
    else
      table.insert(remaining, b)
    end
  end

  local out = {}

  local txt = BuildCampaignProgressText(done, total, doneList, remaining, final)
  table.insert(out, { kind = "NOTE", text = txt })

  if done >= total then
    if final and final.moduleID then
      table.insert(out, {
        kind = "MODULE_BUTTON",
        moduleID = final.moduleID,
        label = ("Continue to %s"):format(final.title or "Next Zone"),
        thumbnail = final.thumbnail,
      })
    end
    return out
  end

  for _, r in ipairs(remaining) do
    if r and r.moduleID then
      table.insert(out, {
        kind = "MODULE_BUTTON",
        moduleID = r.moduleID,
        label = ("Start %s"):format(r.title or "Zone"),
        thumbnail = r.thumbnail,
      })
    end
  end

  return out
end

local function IsMinimized()
  return FTA and FTA.UI and type(FTA.UI.IsMinimized) == "function" and FTA.UI:IsMinimized() == true
end

local function CenterCurrentStep(host, currentTop, currentBottom, moduleId, idx)
  if not host or not currentTop or not currentBottom or not moduleId or not idx then return end
  if not FTA or not FTA.UI or not FTA.UI.scrollFrame then return end

  local scroll = FTA.UI.scrollFrame
  if not scroll.SetVerticalScroll then return end

  local key = tostring(moduleId) .. ":" .. tostring(idx)
  if host._ftaLastCenteredStepKey == key then return end
  host._ftaLastCenteredStepKey = key

  local viewH = scroll:GetHeight() or 0
  local contentH = host:GetHeight() or host._ftaContentHeight or 0
  if viewH <= 0 or contentH <= 0 then return end

  local centerY = -((currentTop + currentBottom) * 0.5)
  local target = centerY - (viewH * 0.5)

  local maxScroll = contentH - viewH
  if maxScroll < 0 then maxScroll = 0 end
  if target < 0 then target = 0 end
  if target > maxScroll then target = maxScroll end

  C_Timer.After(0, function()
    if scroll and scroll.SetVerticalScroll then
      scroll:SetVerticalScroll(target)
    end
  end)
end

function FTA.StepList:Render(host)
  if host._ftaHeaders then
    for _, fs in ipairs(host._ftaHeaders) do fs:Hide() end
  end
  host._ftaHeaders = {}
  host._ftaContentHeight = 1

  local mod, idx, currentStep = FTA.StepEngine:GetCurrentStep()
  if not mod then
    HideExtraRows(1)
    return
  end

  local moduleId = FTA.StepEngine:GetActiveModuleId()

  local steps = mod.steps or {}
  local ui = FTADB.profile.ui
  local qol = FTADB.profile.qol or {}
  local minimized = IsMinimized()

  local hideCompleted = minimized or (qol.hideCompleted == true)
  local hideUpcoming = minimized or (qol.hideUpcoming == true)

  local width = host:GetWidth()
  local y = 0
  local rowIndex = 1
  local currentTop = nil
  local currentBottom = nil

  if minimized then
    if currentStep then
      local isDone = (FTA.Resolve and FTA.Resolve.IsStepSatisfied and FTA.Resolve:IsStepSatisfied(currentStep, moduleId, idx) == true)

      if isDone then
        y, rowIndex = RenderTextRow(host, width, y, rowIndex, "You've completed this step!", {0.78, 0.78, 0.78, 1}, false)
      else
        local displaySegs = currentStep.segments or {}
        if FTA.Resolve and FTA.Resolve.GetDisplaySegmentsForStep then
          displaySegs = FTA.Resolve:GetDisplaySegmentsForStep(currentStep, moduleId, idx)
        end

        for _, seg in ipairs(displaySegs) do
          if seg and (seg.kind == "PICKUP" or seg.kind == "TURNIN" or seg.kind == "OBJECTIVE" or seg.kind == "MANUAL") then
            local line = BuildLine(seg)
            local segIndex = FindSegmentIndex(currentStep, seg)
            local manualChecked = false
            if seg.kind == "MANUAL" and FTA.StepEngine and FTA.StepEngine.IsManualSegmentComplete then
              manualChecked = FTA.StepEngine:IsManualSegmentComplete(moduleId, idx, seg, segIndex) == true
            end

            y, rowIndex = RenderTextRow(
              host,
              width,
              y,
              rowIndex,
              line,
              {1, 1, 1, 1},
              true,
              seg.kind == "MANUAL" and {
                manual = true,
                moduleId = moduleId,
                stepIndex = idx,
                seg = seg,
                segIndex = segIndex,
                checked = manualChecked,
              } or nil
            )
          end
        end
      end

      y = y - 2
    end

    HideExtraRows(rowIndex)

    local used = -y
    if used < 1 then used = 1 end
    host._ftaContentHeight = used + 2
    host:SetHeight(host._ftaContentHeight)
    return
  end

  if (not hideCompleted) and (idx > 1) then
    local h1, ny = RenderHeader(host, y, "Completed")
    table.insert(host._ftaHeaders, h1)
    y = ny

    local completedMax = idx - 1
    local showCompleted = math.max(0, math.min(completedMax, 6))
    local completedStart = completedMax - showCompleted + 1

    for s = completedStart, completedMax do
      local step = steps[s]
      if step then
        local row = AcquireRow(host, rowIndex); rowIndex = rowIndex + 1
        row:SetPoint("TOPLEFT", 0, y)
        row:SetPoint("TOPRIGHT", 0, y)

        if row.btn then row.btn:Hide() end
        if row.thumbBtn then row.thumbBtn:Hide() end
        if row.manualCheck then row.manualCheck:Hide() end
        if row.manualCheckHolder then row.manualCheckHolder:Hide() end

        row.text:SetWidth(width)
        row.text:SetTextColor(0.65, 0.65, 0.65, 1)
        row.text:SetText(StepLabel(step, s))

        row.sub:SetWidth(width)
        row.sub:SetText("")

        local hText = row.text:GetStringHeight()
        row:SetHeight(hText + 6)
        y = y - (row:GetHeight() + 6)
      end
    end
  end

  local h2, ny2 = RenderHeader(host, y, "Current")
  table.insert(host._ftaHeaders, h2)
  y = ny2
  currentTop = y

  if currentStep then
    do
      local row = AcquireRow(host, rowIndex); rowIndex = rowIndex + 1
      row:SetPoint("TOPLEFT", 0, y)
      row:SetPoint("TOPRIGHT", 0, y)

      if row.btn then row.btn:Hide() end
      if row.thumbBtn then row.thumbBtn:Hide() end
      if row.manualCheck then row.manualCheck:Hide() end
      if row.manualCheckHolder then row.manualCheckHolder:Hide() end

      row.text:SetWidth(width)
      row.text:SetTextColor(1, 1, 1, 1)
      row.text:SetText(StepLabel(currentStep, idx))

      row.sub:SetWidth(width)
      row.sub:SetText("")

      local hText = row.text:GetStringHeight()
      row:SetHeight(hText + 6)
      y = y - (row:GetHeight() + 8)
    end

    local isDone = (FTA.Resolve and FTA.Resolve.IsStepSatisfied and FTA.Resolve:IsStepSatisfied(currentStep, moduleId, idx) == true)

    if isDone then
      y, rowIndex = RenderTextRow(host, width, y, rowIndex, "You've completed this step!", {0.78, 0.78, 0.78, 1}, false)
    else
      local displaySegs = currentStep.segments or {}
      if FTA.Resolve and FTA.Resolve.GetDisplaySegmentsForStep then
        displaySegs = FTA.Resolve:GetDisplaySegmentsForStep(currentStep, moduleId, idx)
      end

      for _, seg in ipairs(displaySegs) do
        if seg and seg.kind == "CAMPAIGN_PROGRESS_CHOICE" then
          local expanded = ExpandCampaignChoiceSegments(seg)
          for _, x in ipairs(expanded) do
            if x.kind == "MODULE_BUTTON" then
              y, rowIndex = RenderModuleButtonRow(host, width, y, rowIndex, x)
            else
              local isNote = (x.kind == "NOTE")
              if isNote and ui.showNotesInCurrent == false then
              else
                local color = isNote and {0.78, 0.78, 0.78, 1} or {1, 1, 1, 1}
                local line = BuildLine(x)
                y, rowIndex = RenderTextRow(host, width, y, rowIndex, line, color, not isNote)
              end
            end
          end

        elseif seg and seg.kind == "MODULE_BUTTON" then
          y, rowIndex = RenderModuleButtonRow(host, width, y, rowIndex, seg)

        elseif seg and seg.kind == "MODULE_CHOICE_ROW" then
          y, rowIndex = RenderModuleChoiceRow(host, width, y, rowIndex, seg)

        elseif seg and seg.kind == "IMAGE_POPUP" then
          y, rowIndex = RenderImagePopupRow(host, width, y, rowIndex, seg)

        elseif seg and seg.kind == "VIDEO_EMBED" then
          y, rowIndex = RenderVideoEmbedRow(host, width, y, rowIndex, seg)

        else
          local isNote = (seg.kind == "NOTE")
          if isNote and ui.showNotesInCurrent == false then
          else
            local color = isNote and {0.78, 0.78, 0.78, 1} or {1, 1, 1, 1}
            local line = BuildLine(seg)
            local segIndex = FindSegmentIndex(currentStep, seg)
            local manualChecked = false

            if seg.kind == "MANUAL" and FTA.StepEngine and FTA.StepEngine.IsManualSegmentComplete then
              manualChecked = FTA.StepEngine:IsManualSegmentComplete(moduleId, idx, seg, segIndex) == true
            end

            y, rowIndex = RenderTextRow(
              host,
              width,
              y,
              rowIndex,
              line,
              color,
              not isNote,
              seg.kind == "MANUAL" and {
                manual = true,
                moduleId = moduleId,
                stepIndex = idx,
                seg = seg,
                segIndex = segIndex,
                checked = manualChecked,
              } or nil
            )
          end
        end
      end
    end

    y = y - 8
    currentBottom = y
  end

  if (not hideUpcoming) and (idx < #steps) then
    local h3, ny3 = RenderHeader(host, y, "Upcoming")
    table.insert(host._ftaHeaders, h3)
    y = ny3

    local upcomingShown = 8
    local count = 0
    for s = idx + 1, #steps do
      if count >= upcomingShown then break end
      local step = steps[s]
      if step then
        count = count + 1
        local row = AcquireRow(host, rowIndex); rowIndex = rowIndex + 1
        row:SetPoint("TOPLEFT", 0, y)
        row:SetPoint("TOPRIGHT", 0, y)

        if row.btn then row.btn:Hide() end
        if row.thumbBtn then row.thumbBtn:Hide() end
        if row.manualCheck then row.manualCheck:Hide() end
        if row.manualCheckHolder then row.manualCheckHolder:Hide() end

        row.text:SetWidth(width)
        row.text:SetTextColor(0.78, 0.78, 0.78, 1)
        row.text:SetText(StepLabel(step, s))

        row.sub:SetWidth(width)
        row.sub:SetText("")

        local hText = row.text:GetStringHeight()
        row:SetHeight(hText + 6)
        y = y - (row:GetHeight() + 6)
      end
    end
  end

  HideExtraRows(rowIndex)

  local used = -y
  if used < 1 then used = 1 end
  host._ftaContentHeight = used + 2
  host:SetHeight(host._ftaContentHeight)

  CenterCurrentStep(host, currentTop, currentBottom, moduleId, idx)
end