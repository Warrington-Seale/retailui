local ADDON_NAME, namespace = ...

namespace.AF = _G.AbstractFramework
if not namespace.AF then
    error(ADDON_NAME .. " requires AbstractFramework to be loaded first!")
end

local DST = {}
namespace.DST = DST
_G.DelveSpeedTracker = DST