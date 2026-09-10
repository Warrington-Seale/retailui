-- MerfinPlus Assignments option shell.
local MerfinPlus = LibStub("AceAddon-3.0"):GetAddon("MerfinPlus")
local LSM = LibStub("LibSharedMedia-3.0", true)
local DEFAULT_WIDGET_FONT_NAME = "SFUIDisplayCondensed-Semibold"

function MerfinPlus:BuildAssignmentsOptions()
  local function Settings()
    return self:GetAssignmentSettings()
  end

  local function RefreshWidgets()
    self:ApplyAssignmentWidgetSettings()
    self:UpdateAssignmentWidgetVisibility()
  end

  local function ApplyWidgetOption(key)
    local prefix = type(key) == "string"
      and (key:match("^(assignmentWidget)") or key:match("^(raidLeaderWidget)"))
    if prefix and self.ApplyAssignmentWidgetSetting then
      self:ApplyAssignmentWidgetSetting(prefix)
      return
    end
    RefreshWidgets()
  end

  local function GetWidgetFontValues()
    if not LSM or not LSM.HashTable then
      return { [DEFAULT_WIDGET_FONT_NAME] = DEFAULT_WIDGET_FONT_NAME }
    end
    local registered = LSM:HashTable("font")
    local values = {}
    for name in pairs(registered or {}) do
      values[name] = name
    end
    if not next(values) then
      values[DEFAULT_WIDGET_FONT_NAME] = DEFAULT_WIDGET_FONT_NAME
    end
    return values
  end

  local function ValidWidgetFont(value)
    return type(value) == "string"
      and value ~= ""
      and LSM
      and LSM.Fetch
      and type(LSM:Fetch("font", value, true)) == "string"
  end

  local function ToggleOption(name, key, order, onSet, hidden)
    return {
      type = "toggle",
      name = name,
      order = order,
      width = "full",
      hidden = hidden,
      get = function()
        return Settings()[key] == true
      end,
      set = function(_, value)
        Settings()[key] = value == true
        if onSet then
          onSet(value == true)
        else
          RefreshWidgets()
        end
      end,
    }
  end

  local function RangeOption(name, key, minimum, maximum, step, order, isPercent)
    return {
      type = "range",
      name = name,
      order = order,
      min = minimum,
      max = maximum,
      step = step,
      isPercent = isPercent == true,
      get = function()
        return Settings()[key]
      end,
      set = function(_, value)
        Settings()[key] = value
        ApplyWidgetOption(key)
      end,
    }
  end

  local function ColorOption(name, prefix, order, border)
    local suffix = border and "Border" or "Header"
    return {
      type = "color",
      name = name,
      order = order,
      hasAlpha = false,
      get = function()
        local settings = Settings()
        return settings[prefix .. suffix .. "R"], settings[prefix .. suffix .. "G"], settings[prefix .. suffix .. "B"]
      end,
      set = function(_, r, g, b)
        local settings = Settings()
        settings[prefix .. suffix .. "R"] = r
        settings[prefix .. suffix .. "G"] = g
        settings[prefix .. suffix .. "B"] = b
        ApplyWidgetOption(prefix .. suffix)
      end,
    }
  end

  local function WidgetSettingsGroup(name, prefix, order, hidden)
    return {
      type = "group",
      name = name,
      order = order,
      inline = true,
      width = 0.5,
      hidden = hidden,
      args = {
        headerColor = ColorOption("Header Color", prefix, 10, false),
        width = RangeOption("Width", prefix .. "HeaderWidth", 240, 520, 1, 20),
        height = RangeOption("Height", prefix .. "HeaderHeight", 22, 64, 1, 30),
        headerAlpha = RangeOption("Header Opacity", prefix .. "HeaderAlpha", 0, 1, 0.01, 40, true),
        bodyAlpha = RangeOption("Assignment Background Opacity", prefix .. "BodyAlpha", 0, 1, 0.01, 50, true),
        titleOffsetX = RangeOption("Header Title X Offset", prefix .. "TitleOffsetX", -200, 200, 1, 60),
        titleOffsetY = RangeOption("Header Title Y Offset", prefix .. "TitleOffsetY", -80, 80, 1, 70),
        font = {
          type = "select",
          name = self:T("Font"),
          order = 80,
          values = GetWidgetFontValues,
          dialogControl = "MerfinPlusDropdown",
          get = function()
            local value = Settings()[prefix .. "HeaderFont"]
            return ValidWidgetFont(value) and value or DEFAULT_WIDGET_FONT_NAME
          end,
          set = function(_, value)
            Settings()[prefix .. "HeaderFont"] =
              ValidWidgetFont(value) and value or DEFAULT_WIDGET_FONT_NAME
            ApplyWidgetOption(prefix .. "HeaderFont")
          end,
        },
        fontSize = RangeOption("Font Size", prefix .. "FontSize", 8, 24, 1, 90),
        titleSpacing = RangeOption("Header Title Spacing", prefix .. "TitleSpacing", 0, 20, 1, 100),
        logoOffsetX = RangeOption("Header Icon X Offset", prefix .. "LogoOffsetX", -120, 120, 1, 110),
        logoOffsetY = RangeOption("Header Icon Y Offset", prefix .. "LogoOffsetY", -80, 80, 1, 120),
        logoSize = RangeOption("Header Icon Size", prefix .. "LogoSize", 12, 52, 1, 130),
        showLogo = ToggleOption("Show Icon Logo", prefix .. "ShowLogo", 140, function()
          ApplyWidgetOption(prefix .. "ShowLogo")
        end),
        showBorder = ToggleOption("Show Border", prefix .. "ShowBorder", 150, function()
          ApplyWidgetOption(prefix .. "ShowBorder")
        end),
        borderColor = ColorOption("Border Color", prefix, 160, true),
        borderThickness = RangeOption("Border Thickness", prefix .. "BorderThickness", 1, 6, 1, 170),
        alignment = {
          type = "select",
          name = self:T("Aligning"),
          order = 180,
          values = {
            Up = self:T("Up"),
            Down = self:T("Down"),
            Left = self:T("Left"),
            Right = self:T("Right"),
          },
          sorting = { "Up", "Down", "Left", "Right" },
          get = function()
            return Settings()[prefix .. "Alignment"] or "Down"
          end,
          set = function(_, value)
            Settings()[prefix .. "Alignment"] = value
            ApplyWidgetOption(prefix .. "Alignment")
          end,
        },
      },
    }
  end

  return {
    type = "group",
    name = self:T("Assignments"),
    childGroups = "tab",
    args = {
      raid = {
        type = "group",
        name = self:T("Raid Assignments"),
        order = 10,
        args = {
          content = {
            type = "execute",
            name = "",
            dialogControl = "MerfinPlusRaidAssignments",
            func = function() end,
            width = "full",
            order = 10,
          },
        },
      },
      settings = {
        type = "group",
        name = self:T("Settings"),
        order = 30,
        args = {
          general = {
            type = "group",
            name = self:T("Settings"),
            inline = true,
            order = 10,
            width = "full",
            args = {
              showAssignmentWidget = ToggleOption("Show Assignment Widget", "showAssignmentWidget", 20),
              showRaidLeaderWidget = ToggleOption("Show Raid Leader Widget", "showRaidLeaderWidget", 30),
              assignmentDivider = {
                type = "header",
                name = self:T("Assignment Widget Visibility"),
                order = 40,
              },
              assignmentAlways = ToggleOption("Assignment: Show always", "assignmentWidgetShowAlways", 50, function(value)
                local settings = Settings()
                settings.assignmentWidgetLoadOnlyInRaid = not value
                RefreshWidgets()
              end),
              assignmentRaid = ToggleOption("Assignment: Load only in Raid", "assignmentWidgetLoadOnlyInRaid", 60, function(value)
                local settings = Settings()
                settings.assignmentWidgetShowAlways = not value
                RefreshWidgets()
              end),
              raidLeaderDivider = {
                type = "header",
                name = self:T("Raid Leader Widget Visibility"),
                order = 70,
              },
              raidLeaderAlways = ToggleOption("Raid Leader: Show always", "raidLeaderWidgetShowAlways", 80, function(value)
                local settings = Settings()
                settings.raidLeaderWidgetLoadOnlyInRaid = not value
                RefreshWidgets()
              end),
              raidLeaderRaid = ToggleOption("Raid Leader: Load only in Raid", "raidLeaderWidgetLoadOnlyInRaid", 90, function(value)
                local settings = Settings()
                settings.raidLeaderWidgetShowAlways = not value
                RefreshWidgets()
              end),
            },
          },
          assignmentWidget = WidgetSettingsGroup("Assignment Widget", "assignmentWidget", 20),
          raidLeaderWidget = WidgetSettingsGroup("Raid Leader Widget", "raidLeaderWidget", 30),
        },
      },
      preboss = {
        type = "group",
        name = self:T("Pre-Boss Groups"),
        order = 20,
        args = {
          content = {
            type = "execute",
            name = "",
            dialogControl = "MerfinPlusPreBossGroups",
            func = function() end,
            width = "full",
            order = 10,
          },
        },
      },
    },
  }
end
