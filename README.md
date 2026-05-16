# pano-ui

> Lightweight Roblox UI Library — Build beautiful UIs with ease

---

## Installation

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/naris291977-arch/Ui.lua/refs/heads/main/Yu.lua"
))()
        Quick Start
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/naris291977-arch/Ui.lua/refs/heads/main/Yu.lua"
))()

local Win = Library:CreateWindow("My Hub")
local Tab = Win:AddTab("Main", "⚙")

Tab:AddButton("Click Me", function()
    Library:Notify("Hello", "Button pressed!", 3)
end)

Tab:AddToggle("God Mode", false, function(v)
    print(v)
end)

Tab:AddSlider("Speed", 1, 100, 16, function(v)
    print(v)
end)

Tab:AddDropdown("Color", {"Red","Blue","Green"}, function(v)
    print(v)
end)

Library:Notify("pano-ui", "Loaded!", 3)
    API
Library:CreateWindow(title)
Creates the main window. Returns Tabs.
Win:AddTab(name, icon)
Adds a tab to the sidebar. Returns Elements.
Tab:AddButton(text, callback)
A clickable button.
Tab:AddToggle(text, default, callback)
An on/off switch. Callback receives true or false.
Tab:AddSlider(text, min, max, default, callback)
A draggable slider. Supports mobile. Callback receives a number.
Tab:AddDropdown(text, list, callback)
A dropdown menu. Callback receives the selected string.
Tab:AddSection(text)
A section label divider.
Library:Notify(title, msg, duration)
Shows a notification bottom-right. Duration is in seconds.
Library:UpdateTheme(color)
Changes the accent color across the whole UI.
Library:ShowLoadingAndLang(langTable, callback)
Shows loading screen then language picker.
Pass nil as langTable to skip language selection.
Callback receives (langKey, T).
Theme Colors
Default accent: RGB(99, 102, 241)
Library:UpdateTheme(Color3.fromRGB(99,  102, 241)) -- Indigo
Library:UpdateTheme(Color3.fromRGB(220, 50,  50))  -- Crimson
Library:UpdateTheme(Color3.fromRGB(52,  211, 153)) -- Emerald
Library:UpdateTheme(Color3.fromRGB(251, 191, 36))  -- Gold
Library:UpdateTheme(Color3.fromRGB(244, 63,  94))  -- Rose
 Keybind
Right Control — toggle UI open/close
Library.Keybind = Enum.KeyCode.RightShift -- change keybind
Mobile Support
Drag window by holding the header
Slider supports touch input
Minimized bar is draggable on touch
Full Example
    local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/naris291977-arch/Ui.lua/refs/heads/main/Yu.lua"
))()

Library:ShowLoadingAndLang(nil, function()

    local Win = Library:CreateWindow("My Hub")

    local Main = Win:AddTab("Main", "⚙")
    Main:AddSection("Player")
    Main:AddToggle("God Mode", false, function(v)
        print("God Mode:", v)
    end)
    Main:AddSlider("Walk Speed", 1, 100, 16, function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end)
    Main:AddButton("Reset", function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end)

    local Visual = Win:AddTab("Visual", "◈")
    Visual:AddSection("Theme")
    Visual:AddDropdown("Accent", {"Indigo","Crimson","Emerald","Gold","Rose"}, function(v)
        local c = {
            Indigo  = Color3.fromRGB(99,  102, 241),
            Crimson = Color3.fromRGB(220, 50,  50),
            Emerald = Color3.fromRGB(52,  211, 153),
            Gold    = Color3.fromRGB(251, 191, 36),
            Rose    = Color3.fromRGB(244, 63,  94),
        }
        Library:UpdateTheme(c[v])
        Library:Notify("Theme", "Changed to " .. v, 2)
    end)

    Library:Notify("pano-ui", "Loaded successfully!", 4)

end)
License
MIT — free to use and modify.
