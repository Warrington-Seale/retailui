local ADDON_NAME, namespace = ...

local function normLocale(loc)
    if loc == "enGB" then return "enUS" end
    if loc == "esMX" then return "esES" end
    return loc or "enUS"
end

local loc = normLocale(type(GetLocale) == "function" and GetLocale() or "enUS")
local key = "L_" .. loc
namespace.L = namespace[key] or namespace.L_enUS or namespace.L
