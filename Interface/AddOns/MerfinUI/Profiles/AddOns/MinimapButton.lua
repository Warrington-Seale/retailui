local addonName, Private = ...

function Private.ImportMinimapButton()
    MinimapButtonButtonOptions = {
        ["direction"] = "leftdown",
        ["autoClose"] = false,
        ["buttonsShown"] = true,
        ["buttonScale"] = 10,
        ["blacklist"] = {
        },
        ["version"] = 7,
        ["hidecompartment"] = false,
        ["buttonsPerRow"] = 5,
        ["whitelist"] = {
            ["ZygorGuidesViewerMapIcon"] = true,
            ["CodexBrowserIcon"] = true,
            ["TrinketMenu_IconFrame"] = true,
        },
        ["scale"] = 10,
    }

    if Private.GetProfileResolution() == 'QUAD_HD' then
        MinimapButtonButtonOptions.position = {
            "TOPRIGHT",
            nil,
            "TOPRIGHT",
            -242.000732421875,
            -234.0002593994141,
        }
    elseif Private.GetProfileResolution() == 'FULL_HD' then
        MinimapButtonButtonOptions.position = {
            "RIGHT",
            nil,
            "RIGHT",
            -211.0013275146484,
            259.9998779296875,
        }
    end
end