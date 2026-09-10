local addonName = ... ---@type string
local ns = select(2,...) ---@class addOnNamespace

---@class FalconFlags
ns.Flags = {
  BarBehaviour = {
    HIDE_CHARGES = 1,
    HIDE_SPEED = 2,
    HIDE_GROUNDED = 4,
    HIDE_FULL_GROUNDED = 8,
  },
  Font = {
    MONOCHROME = 1,
    OUTLINE = 2,
    THICKOUTLINE = 4,
    SLUG = 8,
  }
}