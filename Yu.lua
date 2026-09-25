-- [[ NAEI HUB UI LIBRARY - BRIGHT PREMIUM WIND UI WITH GLOW BORDER ]] --
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}

-- ปรับโทนสีให้สว่าง สะอาดตา และดูโมเดิร์นขึ้น
Library.Theme = {
    Background = Color3.fromRGB(245, 246, 250),
    Surface = Color3.fromRGB(255, 255, 255),
    Surface2 = Color3.fromRGB(238, 240, 245),
    SurfaceHover = Color3.fromRGB(225, 230, 240),
    Border = Color3.fromRGB(210, 215, 230),
    BorderSubtle = Color3.fromRGB(220, 225, 235),
    Accent = Color3.fromRGB(99, 102, 241),      -- สีฟ้าครามพรีเมียม
    AccentGlow = Color3.fromRGB(129, 140, 248), -- สีสำหรับเส้นวิ่ง
    Text = Color3.fromRGB(30, 35, 45),
    Muted = Color3.fromRGB(110, 120, 140),
    Success = Color3.fromRGB(34, 197, 94),
    Danger = Color3.fromRGB(239, 68, 68),
    Shadow = Color3.fromRGB(150, 160, 180),
}

function Library:SetTheme(newTheme)
    for key, color in pairs(newTheme) do
        if self.Theme[key] then self.Theme[key] = color end
    end
    if self._MainScreenGui then
        self._MainScreenGui:Destroy()
    end
end

local function tween(object, properties, duration)
    pcall(function()
        TweenService:Create(object, TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties):Play()
    end)
end

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 16)
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
    l = Instance.new("TextLabel")
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
    subTitleText = subTitleText or "Next-Gen Experience"

    local old = PlayerGui:FindFirstChild("NaeiUltraWindUI")
    if old then pcall(function() old:Destroy() end) end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NaeiUltraWindUI"
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
        GuiScale.Scale = math.clamp(math.min(viewport.X / 640, viewport.Y / 440), 0.5, 1.1)
    end
    updateScale()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end

    -- Notification System
    local NotifHolder = Instance.new("Frame")
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
        card.Size = UDim2.new(1, 0, 0, 64)
        card.BackgroundColor3 = Library.Theme.Surface
        card.BackgroundTransparency = 1
        card.Parent = NotifHolder
        
        corner(card, 18)
        stroke(card, Library.Theme.Border, 1, 0.2)
        
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, 4, 0.5, 0)
        line.Position = UDim2.new(0, 0, 0.25, 0)
        line.BackgroundColor3 = Library.Theme.Accent
        line.Parent = card
        corner(line, 2)
        
        local t = label(card, titleText, 13, Library.Theme.Text, Enum.Font.GothamBold)
        t.Size = UDim2.new(1, -24, 0, 20)
        t.Position = UDim2.new(0, 16, 0, 11)
        t.TextXAlignment = Enum.TextXAlignment.Left
        
        local d = label(card, descText, 11, Library.Theme.Muted, Enum.Font.Gotham)
        d.Size = UDim2.new(1, -24, 0, 20)
        d.Position = UDim2.new(0, 16, 0, 31)
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

    -- Main Frame Wrapper (สำหรับใส่เส้นวิ่งเรืองแสงรอบขอบ)
    local GlowContainer = Instance.new("Frame")
    GlowContainer.Name = "GlowContainer"
    GlowContainer.Size = UDim2.new(0, 644, 0, 434)
    GlowContainer.Position = UDim2.new(0.5, -322, 0.5, -217)
    GlowContainer.BackgroundTransparency = 1
    GlowContainer.Parent = ScreenGui

    -- สร้างกรอบเส้นวิ่งเรืองแสงรอบขอบ (Glow Border Effect)
    local GlowStroke = stroke(GlowContainer, Library.Theme.AccentGlow, 2, 0)
    corner(GlowContainer, 24)

    -- เอฟเฟกต์ไล่ระดับความโปร่งใสของเส้นขอบให้ดูวิ่งวน
    task.spawn(function()
        local t = 0
        while GlowContainer.Parent do
            t = t + RunService.RenderStepped:Wait() * 2.5
            local alpha = (math.sin(t) + 1) / 2 -- สลับความโปร่งใส 0 ถึง 1 นุ่มนวล
            GlowStroke.Transparency = 0.1 + (alpha * 0.7)
        end
    end)

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.Position = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = GlowContainer

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 8)
    Shadow.Size = UDim2.new(1, 50, 1, 50)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Library.Theme.Shadow
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    MainFrame.ZIndex = 2
    
    corner(MainFrame, 22)

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 58)
    TopBar.BackgroundColor3 = Library.Theme.Surface
    TopBar.Parent = MainFrame
    TopBar.ZIndex = 4
    corner(TopBar, 22)

    local TopBarFix = Instance.new("Frame")
    TopBarFix.Size = UDim2.new(1, 0, 0, 16)
    TopBarFix.Position = UDim2.new(0, 0, 1, -16)
    TopBarFix.BackgroundColor3 = Library.Theme.Surface
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Parent = TopBar

    local HubTitle = label(TopBar, hubTitleText, 14, Library.Theme.Text, Enum.Font.GothamBold)
    HubTitle.Size = UDim2.new(0, 200, 0, 18)
    HubTitle.Position = UDim2.new(0, 20, 0, 10)
    HubTitle.TextXAlignment = Enum.TextXAlignment.Left

    local Subtitle = label(TopBar, subTitleText, 10, Library.Theme.Muted, Enum.Font.Gotham)
    Subtitle.Size = UDim2.new(0, 200, 0, 14)
    Subtitle.Position = UDim2.new(0, 20, 0, 31)
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left

    local function controlButton(text, color, x)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 30, 0, 30)
        b.Position = UDim2.new(1, x, 0.5, -15)
        b.BackgroundColor3 = Library.Theme.Surface2
        b.Text = text
        b.TextColor3 = Library.Theme.Text
        b.TextSize = 14
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = false
        b.Parent = TopBar
        corner(b, 10)
        stroke(b, Library.Theme.BorderSubtle, 1, 0.3)
        b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = color, TextColor3 = Library.Theme.Surface}) end)
        b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = Library.Theme.Surface2, TextColor3 = Library.Theme.Text}) end)
        return b
    end

    local MinimizeBtn = controlButton("−", Library.Theme.Accent, -80)
    local CloseBtn = controlButton("×", Library.Theme.Danger, -44)

    -- Sidebar Navigation
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, -74)
    Sidebar.Position = UDim2.new(0, 12, 0, 64)
    Sidebar.BackgroundColor3 = Library.Theme.Surface
    Sidebar.Parent = MainFrame
    corner(Sidebar, 18)
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
    TabLayout.Padding = UDim.new(0, 6)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabList

    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Size = UDim2.new(1, -186, 1, -74)
    ContainerHolder.Position = UDim2.new(0, 184, 0, 64)
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Parent = MainFrame

    local Pages, TabButtons = {}, {}
    local FirstTab = true

    local WindowObj = {}

    function WindowObj:CreateTab(name, iconChar)
        iconChar = iconChar or "•"
        local tab = Instance.new("TextButton")
        tab.Size = UDim2.new(1, 0, 0, 42)
        tab.BackgroundColor3 = Library.Theme.Surface
        tab.Text = ""
        tab.AutoButtonColor = false
        tab.Parent = TabList
        corner(tab, 12)

        local icon = label(tab, iconChar, 13, Library.Theme.Muted, Enum.Font.GothamBold)
        icon.Size = UDim2.new(0, 32, 1, 0)
        icon.Position = UDim2.new(0, 4, 0, 0)
        icon.TextXAlignment = Enum.TextXAlignment.Center
        icon.TextYAlignment = Enum.TextYAlignment.Center

        local title = label(tab, name, 12, Library.Theme.Muted, Enum.Font.GothamMedium)
        title.Size = UDim2.new(1, -36, 1, 0)
        title.Position = UDim2.new(0, 36, 0, 0)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextYAlignment = Enum.TextYAlignment.Center

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Library.Theme.Border
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.Parent = ContainerHolder

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 10)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page

        local pagePadding = Instance.new("UIPadding")
        pagePadding.PaddingRight = UDim.new(0, 8)
        pagePadding.PaddingBottom = UDim.new(0, 8)
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
            container.Size = UDim2.new(1, -6, 0, 46)
            container.BackgroundColor3 = Library.Theme.Surface
            container.ClipsDescendants = true
            container.Parent = page
            corner(container, 14)
            stroke(container, Library.Theme.BorderSubtle, 1, 0.4)

            local header = Instance.new("TextButton")
            header.Size = UDim2.new(1, 0, 0, 46)
            header.BackgroundTransparency = 1
            header.Text = ""
            header.AutoButtonColor = false
            header.Parent = container

            local t = label(header, titleText, 12, Library.Theme.Text, Enum.Font.GothamBold)
            t.Size = UDim2.new(1, -36, 1, 0)
            t.Position = UDim2.new(0, 16, 0, 0)
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.TextYAlignment = Enum.TextYAlignment.Center

            local arrow = label(header, "▾", 13, Library.Theme.Muted, Enum.Font.GothamBold)
            arrow.Size = UDim2.new(0, 24, 1, 0)
            arrow.Position = UDim2.new(1, -32, 0, 0)
            arrow.TextXAlignment = Enum.TextXAlignment.Center
            arrow.TextYAlignment = Enum.TextYAlignment.Center

            local content = Instance.new("Frame")
            content.Size = UDim2.new(1, 0, 0, 0)
            content.Position = UDim2.new(0, 0, 0, 46)
            content.BackgroundTransparency = 1
            content.Parent = container

            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 8)
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Parent = content

            local isOpen = false
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then
                    tween(container, {Size = UDim2.new(1, -6, 0, 46 + layout.AbsoluteContentSize.Y + 16)}, 0.2)
                end
            end)
            header.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local targetHeight = isOpen and (46 + layout.AbsoluteContentSize.Y + 16) or 46
                tween(container, {Size = UDim2.new(1, -6, 0, targetHeight)}, 0.25)
                tween(arrow, {Rotation = isOpen and 180 or 0}, 0.25)
            end)

            local SectionObj = {}

            function SectionObj:AddButton(text, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -16, 0, 40)
                btn.BackgroundColor3 = Library.Theme.Surface2
                btn.Text = ""
                btn.AutoButtonColor = false
                btn.Parent = content
                corner(btn, 12)
                stroke(btn, Library.Theme.BorderSubtle, 1, 0.4)

                local txt = label(btn, text, 12, Library.Theme.Text, Enum.Font.GothamMedium)
                txt.Size = UDim2.new(1, -28, 1, 0)
                txt.Position = UDim2.new(0, 14, 0, 0)
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
                btn.Size = UDim2.new(1, -16, 0, 40)
                btn.BackgroundColor3 = Library.Theme.Surface2
                btn.Text = ""
                btn.AutoButtonColor = false
                btn.Parent = content
                corner(btn, 12)
                stroke(btn, Library.Theme.BorderSubtle, 1, 0.4)

                local txt = label(btn, text, 12, Library.Theme.Text, Enum.Font.GothamMedium)
                txt.Size = UDim2.new(1, -64, 1, 0)
                txt.Position = UDim2.new(0, 14, 0, 0)
                txt.TextXAlignment = Enum.TextXAlignment.Left
                txt.TextYAlignment = Enum.TextYAlignment.Center

                local switchBg = Instance.new("Frame")
                switchBg.Size = UDim2.new(0, 40, 0, 22)
                switchBg.Position = UDim2.new(1, -48, 0.5, -11)
                switchBg.BackgroundColor3 = toggled and Library.Theme.Accent or Library.Theme.SurfaceHover
                switchBg.Parent = btn
                corner(switchBg, 11)

                local switchDot = Instance.new("Frame")
                switchDot.Size = UDim2.new(0, 16, 0, 16)
                switchDot.Position = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
                switchDot.BackgroundColor3 = Library.Theme.Surface
                switchDot.Parent = switchBg
                corner(switchDot, 8)

                btn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    tween(switchBg, {BackgroundColor3 = toggled and Library.Theme.Accent or Library.Theme.SurfaceHover}, 0.2)
                    tween(switchDot, {
                        Position = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
                    }, 0.2)
                    if callback then pcall(function() callback(toggled) end) end
                end)
                return btn
            end

            function SectionObj:AddTextbox(text, placeholder, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -16, 0, 40)
                frame.BackgroundColor3 = Library.Theme.Surface2
                frame.Parent = content
                corner(frame, 12)
                stroke(frame, Library.Theme.BorderSubtle, 1, 0.4)

                local txt = label(frame, text, 12, Library.Theme.Text, Enum.Font.GothamMedium)
                txt.Size = UDim2.new(0.5, -14, 1, 0)
                txt.Position = UDim2.new(0, 14, 0, 0)
                txt.TextXAlignment = Enum.TextXAlignment.Left
                txt.TextYAlignment = Enum.TextYAlignment.Center

                local boxBg = Instance.new("Frame")
                boxBg.Size = UDim2.new(0, 130, 0, 26)
                boxBg.Position = UDim2.new(1, -138, 0.5, -13)
                boxBg.BackgroundColor3 = Library.Theme.Surface
                boxBg.Parent = frame
                corner(boxBg, 8)
                stroke(boxBg, Library.Theme.BorderSubtle, 1, 0.5)

                local box = Instance.new("TextBox")
                box.Size = UDim2.new(1, -12, 1, 0)
                box.Position = UDim2.new(0, 6, 0, 0)
                box.BackgroundTransparency = 1
                box.PlaceholderText = placeholder or "Enter text..."
                box.Text = ""
                box.TextColor3 = Library.Theme.Text
                box.PlaceholderColor3 = Library.Theme.Muted
                box.TextSize = 11
                box.Font = Enum.Font.Gotham
                box.TextXAlignment = Enum.TextXAlignment.Left
                box.Parent = boxBg

                box.FocusLost:Connect(function(enterPressed)
                    if callback then
                        pcall(function() callback(box.Text, enterPressed) end)
                    end
                end)

                return frame
            end

            return SectionObj
        end

        return TabObj
    end

    -- Toggle Menu via RightShift
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightShift and ScreenGui.Parent then
            GlowContainer.Visible = not GlowContainer.Visible
        end
    end)

    local minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        Sidebar.Visible = not minimized
        ContainerHolder.Visible = not minimized
        local targetSize = minimized and UDim2.new(0, 644, 0, 58) or UDim2.new(0, 644, 0, 434)
        tween(GlowContainer, {Size = targetSize}, 0.25)
        MinimizeBtn.Text = minimized and "+" or "−"
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Library:SendNotification("System", "UI Closed successfully.", 2)
        tween(GlowContainer, {Size = UDim2.new(0, 644, 0, 0)}, 0.2)
        task.wait(0.2)
        ScreenGui:Destroy()
    end)

    -- Dragging Window
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, input.Position, GlowContainer.Position
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
            GlowContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
