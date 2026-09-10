local E, L, V, P, G = unpack(ElvUI)
local addonName, Private = ...

Private.resolutions = {
  FULL_HD = 'Full HD (1920-1080px)',
  QUAD_HD = 'Quad HD (2560-1440px)',
}

V.MUI = {
  general = {
    profileSettings = {
      media = {
        resolution = Private.Resolution,
        texture = Private.Texture,
      },
      editmode = {
        show = true,
      },
      cooldownManager = {
        show = true,
      },
      gameMenu = {
        show = true,
      },
      actionbars = {
        showGrid = false,
        showMouseover = true,
      },
      unitframes = {
        playerCastBar = (E.Retail and true) or false,
        useElvIndicators = false,
      },
      blacklist = {
        movers = false,
        actionBars = false,
      },
    },
    layout = {
      dark = {
        color = { r = 0.1803921568627451, g = 0.1607843137254902, b = 0.1607843137254902, a = 1 },
        backdrop = not E.Cata and { r = 0.98039221763611, g = 0.98039221763611, b = 0.98039221763611, a = 1 } or { r = 0.5490196078431373, g = 0.4549019607843137, b = 0.4549019607843137, a = 1 },
        dead = { r = 0.65882352941176, g = 0.086274509803922, b = 0.086274509803922, a = 1 },
      },
    },
  },
}

-- E.global
G.MUI = {}

local function CopyDefaults(dest, src)
  for key, value in pairs(src) do
    if type(value) == 'table' then
      if type(dest[key]) ~= 'table' then
        dest[key] = {}
      end

      CopyDefaults(dest[key], value)
    elseif dest[key] == nil then
      dest[key] = value
    end
  end
end

function Private.EnsureDefaults()
  E.private.MUI = E.private.MUI or {}
  CopyDefaults(E.private.MUI, V.MUI)
end
