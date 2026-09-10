local _, FTA = ...

local function Tex(path, size)
  size = size or 16
  return ("|T%s:%d:%d:0:0|t"):format(path, size, size)
end

FTA.Icon = {
  Accept = Tex("Interface\\GossipFrame\\AvailableQuestIcon", 14),
  TurnIn = Tex("Interface\\GossipFrame\\ActiveQuestIcon", 14),
}

FTA.Text = FTA.Text or {}

function FTA.Text:PickupLine(questName)
  if not questName or questName == "" then
    return "Pick up quest."
  end
  return ("Pick up %s %s."):format(FTA.Icon.Accept, questName)
end

function FTA.Text:TurnInLine(questName)
  if not questName or questName == "" then
    return "Turn in quest."
  end
  return ("Turn in %s %s."):format(FTA.Icon.TurnIn, questName)
end
