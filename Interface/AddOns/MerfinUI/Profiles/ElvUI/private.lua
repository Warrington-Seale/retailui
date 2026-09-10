local addonName, Private = ...
local E, L, V, P, G = unpack(ElvUI)

function Private.PrivateDB()
  E.private.general.chatBubbleFont = Private.Font
  E.private.general.chatBubbleFontSize = 10
  E.private.general.chatBubbleName = true
  E.private.general.chatBubbles = 'backdrop_noborder'
  E.private.general.dmgfont = Private.Font
  E.private.general.glossTex = Private.GetProfileTexture()
  E.private.general.namefont = Private.Font
  E.private.general.nameplateFont = Private.Font
  E.private.general.nameplateFontSize = 9
  E.private.general.nameplateLargeFont = Private.Font
  E.private.general.nameplateLargeFontSize = 9
  E.private.general.normTex = Private.GetProfileTexture()
  E.private.general.totemBar = false
  E.private.general.totemTracker = false

  if Private.GetProfileResolution() == 'QUAD_HD' then
    E.private.general.nameplateFontSize = 9
    E.private.general.nameplateLargeFontSize = 9
  elseif Private.GetProfileResolution() == 'FULL_HD' then
    E.private.general.nameplateFontSize = 8
    E.private.general.nameplateLargeFontSize = 8
  end

  E.private.install_complete = 2.42

  E.private.nameplates.enable = false

  E.private.bags.enable = true
  E.private.bags.bagBar = false
end
