local addonName, Private = ...
local E, L, V, P, G = unpack(ElvUI)
local CH = E:GetModule('Chat')

local _G = _G
local ipairs = ipairs
local SetCVar = SetCVar

local FCF_SetWindowName = FCF_SetWindowName
local FCF_OpenNewWindow = FCF_OpenNewWindow
local FCF_ResetChatWindows = FCF_ResetChatWindows
local FCFDock_SelectWindow = FCFDock_SelectWindow
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize

local ChatFrame_AddMessageGroup = ChatFrame_AddMessageGroup
local ChatFrame_RemoveMessageGroup = ChatFrame_RemoveMessageGroup
local ChatFrame_RemoveAllMessageGroups = ChatFrame_RemoveAllMessageGroups

local localizedChannels = {
  ['enUS'] = {
    ['General'] = true, -- 1
    ['Trade'] = true, -- 2
    ['LocalDefense'] = true, -- 3
    ['LookingForGroup'] = true, -- 4
  },
  ['ruRU'] = {
    ['Общий'] = true, -- 1
    ['Торговля'] = true, -- 2
    ['ОборонаЛокальный'] = true, -- 3
    ['ПоискСпутников'] = true, -- 4
  },
  ['deDE'] = {
    ['Allgemein'] = true, -- 1
    ['Handel'] = true, -- 2
    ['LokaleVerteidigung'] = true, -- 3
    ['SucheNachGruppe'] = true, -- 4
  },
}
function Private.SetupChat()
  local fontSize
  fontSize = Private.GetProfileResolution() == 'QUAD_HD' and 14 or 13

  -- CVars Chat
  SetCVar('chatClassColorOverride', 0)
  SetCVar('chatMouseScroll', 1)
  SetCVar('chatStyle', 'classic')
  SetCVar('colorChatNamesByClass', 1)
  SetCVar('whisperMode', 'inline')
  SetCVar('wholeChatWindowClickable', 0)

  -- CVars Voice Transcription
  SetCVar('speechToText', 0)
  SetCVar('textToSpeech', 0)

  -- Reset to default
  FCF_ResetChatWindows()

  -- Create new windows
  FCF_OpenNewWindow() -- id 3
  FCF_OpenNewWindow() -- id 4
  FCF_OpenNewWindow() -- id 5
  -- FCF_OpenNewWindow() -- id 6

  -- Rename all windows
  for _, name in ipairs(_G.CHAT_FRAMES) do
    local frame = _G[name]
    local id = frame:GetID()

    -- Update tab colors
    if E.private.chat.enable then
      CH:UpdateChatTabs()
      CH:FCFTab_UpdateColors(CH:GetTab(_G[name]))
    end

    if id == 1 then
      FCF_SetWindowName(frame, 'GNL')
    elseif id == 2 then
      FCF_SetWindowName(frame, 'CLog')
    elseif id == 3 then
      VoiceTranscriptionFrame_UpdateVisibility(frame)
      VoiceTranscriptionFrame_UpdateVoiceTab(frame)
      VoiceTranscriptionFrame_UpdateEditBox(frame)
    elseif id == 4 then
      FCF_SetWindowName(frame, 'LT')
    elseif id == 5 then
      FCF_SetWindowName(frame, '/W')
    elseif id == 6 then
      FCF_SetWindowName(frame, 'LFG')
    end

    -- Set font size
    FCF_SetChatWindowFontSize(nil, frame, fontSize)
  end

  -- Tab setup: LT (Loot)
  local lootChats = { 'LOOT', 'MONEY' }
  ChatFrame_RemoveAllMessageGroups(_G.ChatFrame4)
  for _, k in ipairs(lootChats) do
    ChatFrame_AddMessageGroup(_G.ChatFrame4, k)
  end

  -- Tab setup: /W (Whisper)
  local whisperChats = { 'WHISPER', 'WHISPER_INFORM', 'BN_WHISPER' }
  ChatFrame_RemoveAllMessageGroups(_G.ChatFrame5)
  for _, k in ipairs(whisperChats) do
    ChatFrame_AddMessageGroup(_G.ChatFrame5, k)
  end

  -- Tab setup: RAID
  local raidChats = { 'GLOBAL', 'GENERAL' }
  ChatFrame_RemoveAllMessageGroups(_G.ChatFrame6)
  for _, k in ipairs(raidChats) do
    ChatFrame_AddMessageGroup(_G.ChatFrame6, k)
  end

  FCFDock_SelectWindow(_G.GENERAL_CHAT_DOCK, _G.ChatFrame1)

  -- Turning off some channels in General tab
  --ChatFrame_RemoveMessageGroup(_G.ChatFrame1, 'WHISPER')
  --ChatFrame_RemoveMessageGroup(_G.ChatFrame1, 'BN_WHISPER')
  ChatFrame_RemoveMessageGroup(_G.ChatFrame1, 'GENERAL')
  ChatFrame_RemoveMessageGroup(_G.ChatFrame1, 'GLOBAL')
  ChatFrame_RemoveMessageGroup(_G.ChatFrame1, 'LOOT')
  ChatFrame_RemoveMessageGroup(_G.ChatFrame1, 'MONEY')

  if localizedChannels[Private.Locale] then
    for channelName in pairs(localizedChannels[Private.Locale]) do
      ChatFrame_RemoveChannel(_G.ChatFrame1, channelName)
      if ChatFrame_AddChannel then
        ChatFrame_AddChannel(_G.ChatFrame6, channelName)
      end
    end
  end

  Private:PluginInstallStepComplete(L['Chat Settings'])
end
