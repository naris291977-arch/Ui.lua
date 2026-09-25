-- [[ NAEI HUB UI LIBRARY - WIND UI STYLE EDITION ]] --
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}

-- ธีมสีสไตล์ Wind UI (Dark Minimalist / Clean Theme)
Library.Theme = {
    Background = Color3.fromRGB(16, 16, 20),      -- สีพื้นหลังหลักเข้มสนิท
    Surface = Color3.fromRGB(24, 24, 29),         -- สีกล่องคอนเทนเนอร์
    Surface2 = Color3.fromRGB(32, 32, 39),        -- สีปุ่มหรือกล่องย่อย
    SurfaceHover = Color3.fromRGB(42, 42, 51),    -- สีเวลาเอาเมาส์ชี้
    Border = Color3.fromRGB(55, 55, 68),          -- สีขอบหลัก
    BorderSubtle = Color3.fromRGB(40, 40, 49),    -- สีขอบบางๆ
    Accent = Color3.fromRGB(255, 255, 255),       -- สีไฮไลท์หลัก (ขาวพรีเมียม)
    AccentDark = Color3.fromRGB(50, 50, 60),
    Text = Color3.fromRGB(240, 240, 245),         -- สีตัวหนังสือหลัก
    Muted = Color3.fromRGB(150, 150, 165),        -- สีตัวหนังสือรอง
    Success = Color3.fromRGB(46, 204, 113),
    Danger = Color3.fromRGB(231, 76, 60),
    Warning = Color3.fromRGB(241, 196, 15),
    Shadow = Color3.fromRGB(0, 0, 0),
}

function Library:SetTheme(newTheme)
    for key, color in pairs(newTheme) do
        if self.Theme[key] then
            self.Theme[key] = color
        end
    end
    if self._MainScreenGui then
        self._MainScreenGui:Destroy()
        warn("Theme updated! Please re-initialize your UI window.")
    end
end

local function tween(object, properties, duration)
    pcall(function()
        TweenService:Create(object, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), properties):Play()
    end)
end

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10) -- เพิ่มความโค้งมนสไตล์ Wind UI
    c.Parent = object
    return c
end

local function stroke(object, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Library.Theme.BorderSubtle
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.3
    s.Parent = object
    return s
end

local function label(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Library.Theme.Text
    l.TextSize = size or 12
    l.Font = font or Enum.Font.GothamMedium
    l.Parent = parent
    return l
end

function Library:CreateWindow(hubTitleText, subTitleText)
    hubTitleText = hubTitleText or "Wind UI"
    subTitleText = subTitleText or "v1.0.0"

    local old = PlayerGui:FindFirstChild("NaeiWindUI")
    if old then pcall(function() old:Destroy() end) end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NaeiWindUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    Library._MainScreenGui = ScreenGui

    local GuiScale = Instance.new("UIScale")
    GuiScale.Scale = 1
    GuiScale.Parent = ScreenGui

    local function updateScale()
        local camera = workspace.CurrentCamera
        if not camera then return end
        local viewport = camera.ViewportSize
        GuiScale.Scale = math.clamp(math.min(viewport.X / 620, viewport.Y / 440), 0.5, 1.1)
    end
    updateScale()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end

    -- Notification System
    local NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "NotificationHolder"
    NotifHolder.Size = UDim2.new(0, 280, 1, 0)
    NotifHolder.Position = UDim2.new(1, -290, 0, 0)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Parent = ScreenGui

    local NotifLayout = Instance.new("UIListLayout")
    NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.Padding = UDim.new(0, 10)
    NotifLayout.Parent = NotifHolder

    function Library:SendNotification(titleText, descText, duration)
        duration = duration or 3
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 60)
        card.BackgroundColor3 = Library.Theme.Surface
        card.BackgroundTransparency = 1
        card.BorderSizePixel = 0
        card.Parent = NotifHolder
        
        corner(card, 12)
        stroke(card, Library.Theme.Border, 1, 0.4)
        
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, 4, 0.6, 0)
        line.Position = UDim2.new(0, 0, 0.2, 0)
        line.BackgroundColor3 = Library.Theme.Accent
        line.BorderSizePixel = 0
        line.Parent = card
        corner(line, 2)
        
        local t = label(card, titleText, 13, Library.Theme.Text, Enum.Font.GothamBold)
        t.Size = UDim2.new(1, -24, 0, 20)
        t.Position = UDim2.new(0, 14, 0, 9)
        t.TextXAlignment = Enum.TextXAlignment.Left
        
        local d = label(card, descText, 11, Library.Theme.Muted, Enum.Font.Gotham)
        d.Size = UDim2.new(1, -24, 0, 20)
        d.Position = UDim2.new(0, 14, 0, 29)
        d.TextXAlignment = Enum.TextXAlignment.Left
        
        card.Position = UDim2.new(1, 40, 0, 0)
        tween(card, {BackgroundTransparency = 0.05, Position = UDim2.new(0, 0, 0, 0)}, 0.3)
        
        task.spawn(function()
            task.wait(duration)
            tween(card, {BackgroundTransparency = 1, Position = UDim2.new(1, 40, 0, 0)}, 0.3)
            task.wait(0.3)
            card:Destroy()
        end)
    end

    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 620, 0, 440)
    MainFrame.Position = UDim2.new(0.5, -310, 0.5, -220)
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = ScreenGui

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 6)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Library.Theme.Shadow
    Shadow.ImageTransparency = 0.4
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    MainFrame.ZIndex = 2
    
    corner(MainFrame, 14) -- ความโค้งหลัก
    stroke(MainFrame, Library.Theme.Border, 1, 0.4)

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 52)
    TopBar.BackgroundColor3 = Library.Theme.Surface
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    TopBar.ZIndex = 4
    corner(TopBar, 14)

    -- Fix มุมล่างของ TopBar ให้เหลี่ยมเสมอกัน
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Size = UDim2.new(1, 0, 0, 10)
    TopBarFix.Position = UDim2.new(0, 0, 1, -10)
    TopBarFix.BackgroundColor3 = Library.Theme.Surface
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Parent = TopBar

    local HubTitle = label(TopBar, hubTitleText, 13, Library.Theme.Text, Enum.Font.GothamBold)
    HubTitle.Size = UDim2.new(0, 200, 0, 18)
    HubTitle.Position = UDim2.new(0, 16, 0, 9)
    HubTitle.TextXAlignment = Enum.TextXAlignment.Left

    local Subtitle = label(TopBar, subTitleText, 10, Library.Theme.Muted, Enum.Font.Gotham)
    Subtitle.Size = UDim2.new(0, 200, 0, 14)
    Subtitle.Position = UDim2.new(0, 16, 0, 27)
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left

    local function controlButton(text, color, x)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 26, 0, 26)
        b.Position = UDim2.new(1, x, 0.5, -13)
        b.BackgroundColor3 = Library.Theme.Surface2
        b.Text = text
        b.TextColor3 = Library.Theme.Text
        b.TextSize = 14
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = false
        b.Parent = TopBar
        corner(b, 8)
        stroke(b, Library.Theme.BorderSubtle, 1, 0.3)
        b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = color, TextColor3 = Library.Theme.Background}) end)
        b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = Library.Theme.Surface2, TextColor3 = Library.Theme.Text}) end)
        return b
    end

    local MinimizeBtn = controlButton("−", Library.Theme.Accent, -72)
    local CloseBtn = controlButton("×", Library.Theme.Danger, -40)

    -- Sidebar Navigation
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, -68)
    Sidebar.Position = UDim2.new(0, 10, 0, 58)
    Sidebar.BackgroundColor3 = Library.Theme.Surface
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    corner(Sidebar, 12)
    stroke(Sidebar, Library.Theme.BorderSubtle, 1, 0.4)

    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(1, -12, 1, -12)
    TabList.Position = UDim2.new(0, 6, 0, 6)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 0
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabList.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 4)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabList

    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Size = UDim2.new(1, -172, 1, -68)
    ContainerHolder.Position = UDim2.new(0, 166, 0, 58)
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Parent = MainFrame

    local Pages, TabButtons = {}, {}
    local FirstTab = true

    local WindowObj = {}

    function WindowObj:CreateTab(name, iconChar)
        iconChar = iconChar or "•"
        local tab = Instance.new("TextButton")
        tab.Size = UDim2.new(1, 0, 0, 36)
        tab.BackgroundColor3 = Library.Theme.Surface
        tab.BorderSizePixel = 0
        tab.Text = ""
        tab.AutoButtonColor = false
        tab.Parent = TabList
        corner(tab, 8)

        local icon = label(tab, iconChar, 12, Library.Theme.Muted, Enum.Font.GothamBold)
        icon.Size = UDim2.new(0, 28, 1, 0)
        icon.Position = UDim2.new(0, 4, 0, 0)
        icon.TextXAlignment = Enum.TextXAlignment.Center
        icon.TextYAlignment = Enum.TextYAlignment.Center

        local title = label(tab, name, 11, Library.Theme.Muted, Enum.Font.GothamMedium)
        title.Size = UDim2.new(1, -32, 1, 0)
        title.Position = UDim2.new(0, 32, 0, 0)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextYAlignment = Enum.TextYAlignment.Center

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = Library.Theme.Border
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.Parent = ContainerHolder

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page

        local pagePadding = Instance.new("UIPadding")
        pagePadding.PaddingRight = UDim.new(0, 6)
        pagePadding.PaddingBottom = UDim.new(0, 6)
        pagePadding.Parent = page

        tab.MouseEnter:Connect(function()
            if tab:GetAttribute("Active") ~= true then
                tween(tab, {BackgroundColor3 = Library.Theme.SurfaceHover})
                tween(icon, {TextColor3 = Library.Theme.Text})
            end
        end)
        tab.MouseLeave:Connect(function()
            if tab:GetAttribute("Active") ~= true then
                tween(tab, {BackgroundColor3 = Library.Theme.Surface})
                tween(icon, {TextColor3 = Library.Theme.Muted})
            end
        end)

        tab.MouseButton1Click:Connect(function()
            for _, p in ipairs(Pages) do p.Visible = false end
            for _, b in ipairs(TabButtons) do
                b:SetAttribute("Active", false)
                tween(b, {BackgroundColor3 = Library.Theme.Surface})
                for _, child in ipairs(b:GetChildren()) do
                    if child:IsA("TextLabel") then tween(child, {TextColor3 = Library.Theme.Muted}) end
                end
            end
            page.Visible = true
            tab:SetAttribute("Active", true)
            tween(tab, {BackgroundColor3 = Library.Theme.Surface2})
            tween(icon, {TextColor3 = Library.Theme.Accent})
            tween(title, {TextColor3 = Library.Theme.Text})
        end)

        table.insert(Pages, page)
        table.insert(TabButtons, tab)

        if FirstTab then
            FirstTab = false
            tab:SetAttribute("Active", true)
            tab.BackgroundColor3 = Library.Theme.Surface2
            icon.TextColor3 = Library.Theme.Accent
            title.TextColor3 = Library.Theme.Text
            page.Visible = true
        end

        local TabObj = {}

        function TabObj:AddCollapsible(titleText)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -6, 0, 40)
            container.BackgroundColor3 = Library.Theme.Surface
            container.BorderSizePixel = 0
            container.ClipsDescendants = true
            container.Parent = page
            corner(container, 10)
            stroke(container, Library.Theme.BorderSubtle, 1, 0.4)

            local header = Instance.new("TextButton")
            header.Size = UDim2.new(1, 0, 0, 40)
            header.BackgroundTransparency = 1
            header.Text = ""
            header.AutoButtonColor = false
            header.Parent = container

            local t = label(header, titleText, 12, Library.Theme.Text, Enum.Font.GothamBold)
            t.Size = UDim2.new(1, -30, 1, 0)
            t.Position = UDim2.new(0, 14, 0, 0)
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.TextYAlignment = Enum.TextYAlignment.Center

            local arrow = label(header, "▾", 12, Library.Theme.Muted, Enum.Font.GothamBold)
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -28, 0, 0)
            arrow.TextXAlignment = Enum.TextXAlignment.Center
            arrow.TextYAlignment = Enum.TextYAlignment.Center

            local content = Instance.new("Frame")
            content.Size = UDim2.new(1, 0, 0, 0)
            content.Position = UDim2.new(0, 0, 0, 40)
            content.BackgroundTransparency = 1
            content.Parent = container

            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 6)
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Parent = content

            local isOpen = false
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then
                    tween(container, {Size = UDim2.new(1, -6, 0, 40 + layout.AbsoluteContentSize.Y + 12)}, 0.2)
                end
            end)
            header.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local targetHeight = isOpen and (40 + layout.AbsoluteContentSize.Y + 12) or 40
                tween(container, {Size = UDim2.new(1, -6, 0, targetHeight)}, 0.25)
                tween(arrow, {Rotation = isOpen and 180 or 0}, 0.25)
            end)

            local SectionObj = {}

            function SectionObj:AddButton(text, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -12, 0, 34)
                btn.BackgroundColor3 = Library.Theme.Surface2
                btn.BorderSizePixel = 0
                btn.Text = ""
                btn.AutoButtonColor = false
                btn.Parent = content
                corner(btn, 8)
                stroke(btn, Library.Theme.BorderSubtle, 1, 0.4)

                local txt = label(btn, text, 11, Library.Theme.Text, Enum.Font.GothamMedium)
                txt.Size = UDim2.new(1, -20, 1, 0)
                txt.Position = UDim2.new(0, 12, 0, 0)
                txt.TextXAlignment = Enum.TextXAlignment.Left
                txt.TextYAlignment = Enum.TextYAlignment.Center

                btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = Library.Theme.SurfaceHover}) end)
                btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = Library.Theme.Surface2}) end)
                btn.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
                return btn
            end

            function SectionObj:AddToggle(text, defaultState, callback)
                local toggled = defaultState or false
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -12, 0, 34)
                btn.BackgroundColor3 = Library.Theme.Surface2
                btn.BorderSizePixel = 0
                btn.Text = ""
                btn.AutoButtonColor = false
                btn.Parent = content
                corner(btn, 8)
                stroke(btn, Library.Theme.BorderSubtle, 1, 0.4)

                local txt = label(btn, text, 11, Library.Theme.Text, Enum.Font.GothamMedium)
                txt.Size = UDim2.new(1, -50, 1, 0)
                txt.Position = UDim2.new(0, 12, 0, 0)
                txt.TextXAlignment = Enum.TextXAlignment.Left
                txt.TextYAlignment = Enum.TextYAlignment.Center

                local switchBg = Instance.new("Frame")
                switchBg.Size = UDim2.new(0, 32, 0, 16)
                switchBg.Position = UDim2.new(1, -40, 0.5, -8)
                switchBg.BackgroundColor3 = toggled and Library.Theme.Accent or Library.Theme.SurfaceHover
                switchBg.Parent = btn
                corner(switchBg, 8)

                local switchDot = Instance.new("Frame")
                switchDot.Size = UDim2.new(0, 12, 0, 12)
                switchDot.Position = toggled and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                switchDot.BackgroundColor3 = toggled and Library.Theme.Background or Library.Theme.Text
                switchDot.Parent = switchBg
                corner(switchDot, 6)

                btn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    tween(switchBg, {BackgroundColor3 = toggled and Library.Theme.Accent or Library.Theme.SurfaceHover}, 0.2)
                    tween(switchDot, {
                        Position = toggled and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
                        BackgroundColor3 = toggled and Library.Theme.Background or Library.Theme.Text
                    }, 0.2)
                    if callback then pcall(function() callback(toggled) end) end
                end)
                return btn
            end

            return SectionObj
        end

        return TabObj
    end

    -- Toggle Menu via RightShift
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightShift and ScreenGui.Parent then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    local minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        Sidebar.Visible = not minimized
        ContainerHolder.Visible = not minimized
        local targetSize = minimized and UDim2.new(0, 620, 0, 52) or UDim2.new(0, 620, 0, 440)
        tween(MainFrame, {Size = targetSize}, 0.25)
        MinimizeBtn.Text = minimized and "+" or "−"
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Library:SendNotification("System", "UI Closed.", 2)
        tween(MainFrame, {Size = UDim2.new(0, 620, 0, 0)}, 0.2)
        task.wait(0.2)
        ScreenGui:Destroy()
    end)

    -- Dragging Window
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, input.Position, MainFrame.Position
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return WindowObj
end

return Library
