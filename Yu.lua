-- [[ NAEI HUB UI LIBRARY - FULL CONFIGURABLE EDITION ]] --
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}

-- ธีมเริ่มต้น (Cyberpunk Theme) สามารถเปลี่ยนภายหลังได้
Library.Theme = {
    Background = Color3.fromRGB(8, 11, 18),
    Surface = Color3.fromRGB(14, 18, 28),
    Surface2 = Color3.fromRGB(20, 26, 40),
    SurfaceHover = Color3.fromRGB(27, 35, 54),
    Border = Color3.fromRGB(0, 238, 255),
    BorderSubtle = Color3.fromRGB(40, 52, 77),
    Accent = Color3.fromRGB(0, 242, 255),
    AccentDark = Color3.fromRGB(0, 116, 145),
    Text = Color3.fromRGB(245, 249, 255),
    Muted = Color3.fromRGB(130, 146, 175),
    Success = Color3.fromRGB(52, 235, 143),
    Danger = Color3.fromRGB(255, 75, 105),
    Warning = Color3.fromRGB(255, 190, 70),
    Shadow = Color3.fromRGB(0, 0, 0),
}

-- ฟังก์ชันอัปเดตสีธีมทั้งหมดแบบ Real-time
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
        TweenService:Create(object, TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties):Play()
    end)
end

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = object
    return c
end

local function stroke(object, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Library.Theme.BorderSubtle
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.2
    s.Parent = object
    return s
end

local function label(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Library.Theme.Text
    l.TextSize = size or 11
    l.Font = font or Enum.Font.Gotham
    l.Parent = parent
    return l
end

-- สร้างหน้าต่างหลัก (Window)
function Library:CreateWindow(hubTitleText, subTitleText)
    hubTitleText = hubTitleText or "NAEI HUB"
    subTitleText = subTitleText or "PRO EDITION"

    local old = PlayerGui:FindFirstChild("NaeiHubUI")
    if old then pcall(function() old:Destroy() end) end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NaeiHubUI"
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
        GuiScale.Scale = math.clamp(camera.ViewportSize.X / 900, 0.72, 1.12)
    end
    updateScale()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end

    -- Notification System
    local NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "NotificationHolder"
    NotifHolder.Size = UDim2.new(0, 260, 1, 0)
    NotifHolder.Position = UDim2.new(1, -270, 0, 0)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Parent = ScreenGui

    local NotifLayout = Instance.new("UIListLayout")
    NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.Padding = UDim.new(0, 8)
    NotifLayout.Parent = NotifHolder

    function Library:SendNotification(titleText, descText, duration)
        duration = duration or 3
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 56)
        card.BackgroundColor3 = Library.Theme.Surface
        card.BackgroundTransparency = 1
        card.BorderSizePixel = 0
        card.Parent = NotifHolder
        
        corner(card, 8)
        stroke(card, Library.Theme.Accent, 1, 0.5)
        
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, 3, 0.6, 0)
        line.Position = UDim2.new(0, 0, 0.2, 0)
        line.BackgroundColor3 = Library.Theme.Accent
        line.BorderSizePixel = 0
        line.Parent = card
        corner(line, 2)
        
        local t = label(card, titleText, 12, Library.Theme.Text, Enum.Font.GothamBold)
        t.Size = UDim2.new(1, -20, 0, 18)
        t.Position = UDim2.new(0, 12, 0, 8)
        t.TextXAlignment = Enum.TextXAlignment.Left
        
        local d = label(card, descText, 10, Library.Theme.Muted, Enum.Font.Gotham)
        d.Size = UDim2.new(1, -20, 0, 18)
        d.Position = UDim2.new(0, 12, 0, 26)
        d.TextXAlignment = Enum.TextXAlignment.Left
        
        card.Position = UDim2.new(1, 40, 0, 0)
        tween(card, {BackgroundTransparency = 0.1, Position = UDim2.new(0, 0, 0, 0)}, 0.3)
        
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
    MainFrame.Size = UDim2.new(0, 500, 0, 340)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -170)
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = ScreenGui

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
    Shadow.Size = UDim2.new(1, 34, 1, 34)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Library.Theme.Shadow
    Shadow.ImageTransparency = 0.45
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    MainFrame.ZIndex = 2
    corner(MainFrame, 14)
    stroke(MainFrame, Library.Theme.Border, 1.2, 0.4)

    local Glow = Instance.new("Frame")
    Glow.Size = UDim2.new(1, 0, 0, 2)
    Glow.BackgroundColor3 = Library.Theme.Accent
    Glow.BorderSizePixel = 0
    Glow.Parent = MainFrame
    Glow.ZIndex = 3
    corner(Glow, 2)

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Library.Theme.Surface
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    TopBar.ZIndex = 4
    corner(TopBar, 14)

    local TopBarFix = Instance.new("Frame")
    TopBarFix.Size = UDim2.new(1, 0, 0, 10)
    TopBarFix.Position = UDim2.new(0, 0, 1, -10)
    TopBarFix.BackgroundColor3 = Library.Theme.Surface
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Parent = TopBar

    local BrandMark = Instance.new("Frame")
    BrandMark.Size = UDim2.new(0, 30, 0, 30)
    BrandMark.Position = UDim2.new(0, 12, 0.5, -15)
    BrandMark.BackgroundColor3 = Library.Theme.AccentDark
    BrandMark.Parent = TopBar
    corner(BrandMark, 8)
    stroke(BrandMark, Library.Theme.Accent, 1, 0.3)

    local Mark = label(BrandMark, string.sub(hubTitleText, 1, 1), 15, Library.Theme.Accent, Enum.Font.GothamBlack)
    Mark.Size = UDim2.new(1, 0, 1, 0)
    Mark.TextXAlignment = Enum.TextXAlignment.Center
    Mark.TextYAlignment = Enum.TextYAlignment.Center

    local HubTitle = label(TopBar, hubTitleText, 12, Library.Theme.Text, Enum.Font.GothamBold)
    HubTitle.Size = UDim2.new(0, 140, 0, 16)
    HubTitle.Position = UDim2.new(0, 52, 0, 9)
    HubTitle.TextXAlignment = Enum.TextXAlignment.Left

    local Subtitle = label(TopBar, subTitleText, 8, Library.Theme.Accent, Enum.Font.GothamMedium)
    Subtitle.Size = UDim2.new(0, 140, 0, 14)
    Subtitle.Position = UDim2.new(0, 52, 0, 26)
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left

    local Status = Instance.new("Frame")
    Status.Size = UDim2.new(0, 74, 0, 20)
    Status.Position = UDim2.new(1, -114, 0.5, -10)
    Status.BackgroundColor3 = Color3.fromRGB(12, 45, 36)
    Status.Parent = TopBar
    corner(Status, 10)
    stroke(Status, Library.Theme.Success, 1, 0.4)

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 5, 0, 5)
    StatusDot.Position = UDim2.new(0, 8, 0.5, -2)
    StatusDot.BackgroundColor3 = Library.Theme.Success
    StatusDot.Parent = Status
    corner(StatusDot, 3)

    local StatusText = label(Status, "ACTIVE", 9, Library.Theme.Success, Enum.Font.GothamBold)
    StatusText.Size = UDim2.new(1, -18, 1, 0)
    StatusText.Position = UDim2.new(0, 17, 0, 0)
    StatusText.TextXAlignment = Enum.TextXAlignment.Left

    local function controlButton(text, color, x)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 22, 0, 22)
        b.Position = UDim2.new(1, x, 0.5, -11)
        b.BackgroundColor3 = Library.Theme.Surface2
        b.Text = text
        b.TextColor3 = Library.Theme.Text
        b.TextSize = 13
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = false
        b.Parent = TopBar
        corner(b, 6)
        stroke(b, Library.Theme.BorderSubtle, 1, 0.3)
        b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = color, TextColor3 = Library.Theme.Background}) end)
        b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = Library.Theme.Surface2, TextColor3 = Library.Theme.Text}) end)
        return b
    end

    local MinimizeBtn = controlButton("−", Library.Theme.Accent, -60)
    local CloseBtn = controlButton("×", Library.Theme.Danger, -32)

    -- Sidebar Navigation
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 125, 1, -64)
    Sidebar.Position = UDim2.new(0, 8, 0, 56)
    Sidebar.BackgroundColor3 = Library.Theme.Surface
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    corner(Sidebar, 10)
    stroke(Sidebar, Library.Theme.BorderSubtle, 1, 0.4)

    local NavTitle = label(Sidebar, "NAVIGATION", 8, Library.Theme.Muted, Enum.Font.GothamBold)
    NavTitle.Size = UDim2.new(1, -20, 0, 14)
    NavTitle.Position = UDim2.new(0, 10, 0, 10)
    NavTitle.TextXAlignment = Enum.TextXAlignment.Left

    local TabList = Instance.new("Frame")
    TabList.Size = UDim2.new(1, -16, 1, -34)
    TabList.Position = UDim2.new(0, 8, 0, 28)
    TabList.BackgroundTransparency = 1
    TabList.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 6)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabList

    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Size = UDim2.new(1, -145, 1, -64)
    ContainerHolder.Position = UDim2.new(0, 138, 0, 56)
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Parent = MainFrame

    local Pages, TabButtons = {}, {}
    local FirstTab = true

    -- Window Object with Elements
    local WindowObj = {}

    function WindowObj:CreateTab(name, iconChar)
        iconChar = iconChar or "◆"
        local tab = Instance.new("TextButton")
        tab.Size = UDim2.new(1, 0, 0, 34)
        tab.BackgroundColor3 = Library.Theme.Surface
        tab.BorderSizePixel = 0
        tab.Text = ""
        tab.AutoButtonColor = false
        tab.Parent = TabList
        corner(tab, 8)

        local icon = label(tab, iconChar, 13, Library.Theme.Muted, Enum.Font.GothamBold)
        icon.Size = UDim2.new(0, 26, 1, 0)
        icon.Position = UDim2.new(0, 6, 0, 0)
        icon.TextXAlignment = Enum.TextXAlignment.Center
        icon.TextYAlignment = Enum.TextYAlignment.Center

        local title = label(tab, name, 11, Library.Theme.Muted, Enum.Font.GothamSemibold)
        title.Size = UDim2.new(1, -32, 1, 0)
        title.Position = UDim2.new(0, 32, 0, 0)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextYAlignment = Enum.TextYAlignment.Center

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = Library.Theme.Accent
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.Parent = ContainerHolder

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page

        tab.MouseEnter:Connect(function()
            if tab:GetAttribute("Active") ~= true then
                tween(tab, {BackgroundColor3 = Library.Theme.SurfaceHover})
                tween(icon, {TextColor3 = Library.Theme.Accent})
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

        -- 1. Collapsible Section
        function TabObj:AddCollapsible(titleText)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -6, 0, 38)
            container.BackgroundColor3 = Library.Theme.Surface
            container.BorderSizePixel = 0
            container.ClipsDescendants = true
            container.Parent = page
            corner(container, 8)
            stroke(container, Library.Theme.BorderSubtle, 1, 0.4)

            local header = Instance.new("TextButton")
            header.Size = UDim2.new(1, 0, 0, 38)
            header.BackgroundTransparency = 1
            header.Text = ""
            header.AutoButtonColor = false
            header.Parent = container

            local t = label(header, titleText, 11, Library.Theme.Text, Enum.Font.GothamBold)
            t.Size = UDim2.new(1, -30, 1, 0)
            t.Position = UDim2.new(0, 12, 0, 0)
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.TextYAlignment = Enum.TextYAlignment.Center

            local arrow = label(header, "▼", 10, Library.Theme.Muted, Enum.Font.GothamBold)
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -26, 0, 0)
            arrow.TextXAlignment = Enum.TextXAlignment.Center
            arrow.TextYAlignment = Enum.TextYAlignment.Center

            local content = Instance.new("Frame")
            content.Size = UDim2.new(1, 0, 0, 0)
            content.Position = UDim2.new(0, 0, 0, 38)
            content.BackgroundTransparency = 1
            content.Parent = container

            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 6)
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Parent = content

            local isOpen = false
            header.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local targetHeight = isOpen and (38 + layout.AbsoluteContentSize.Y + 10) or 38
                tween(container, {Size = UDim2.new(1, -6, 0, targetHeight)}, 0.25)
                tween(arrow, {Rotation = isOpen and 180 or 0}, 0.25)
            end)

            local SectionObj = {}
            function SectionObj:AddButton(text, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -6, 0, 36)
                btn.BackgroundColor3 = Library.Theme.Surface2
                btn.BorderSizePixel = 0
                btn.Text = ""
                btn.AutoButtonColor = false
                btn.Parent = content
                corner(btn, 8)
                stroke(btn, Library.Theme.BorderSubtle, 1, 0.5)

                local txt = label(btn, text, 11, Library.Theme.Text, Enum.Font.GothamSemibold)
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
                btn.Size = UDim2.new(1, -6, 0, 36)
                btn.BackgroundColor3 = Library.Theme.Surface2
                btn.BorderSizePixel = 0
                btn.Text = ""
                btn.AutoButtonColor = false
                btn.Parent = content
                corner(btn, 8)
                stroke(btn, Library.Theme.BorderSubtle, 1, 0.5)

                local txt = label(btn, text, 11, Library.Theme.Text, Enum.Font.GothamSemibold)
                txt.Size = UDim2.new(1, -50, 1, 0)
                txt.Position = UDim2.new(0, 12, 0, 0)
                txt.TextXAlignment = Enum.TextXAlignment.Left
                txt.TextYAlignment = Enum.TextYAlignment.Center

                local switchBg = Instance.new("Frame")
                switchBg.Size = UDim2.new(0, 34, 0, 18)
                switchBg.Position = UDim2.new(1, -42, 0.5, -9)
                switchBg.BackgroundColor3 = toggled and Library.Theme.Accent or Library.Theme.SurfaceHover
                switchBg.Parent = btn
                corner(switchBg, 9)

                local switchDot = Instance.new("Frame")
                switchDot.Size = UDim2.new(0, 14, 0, 14)
                switchDot.Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                switchDot.BackgroundColor3 = Library.Theme.Text
                switchDot.Parent = switchBg
                corner(switchDot, 7)

                btn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    tween(switchBg, {BackgroundColor3 = toggled and Library.Theme.Accent or Library.Theme.SurfaceHover}, 0.2)
                    tween(switchDot, {Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.2)
                    if callback then pcall(function() callback(toggled) end) end
                end)
                return btn
            end

            function SectionObj:AddSlider(text, min, max, default, callback)
                local value = default or min
                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, -6, 0, 48)
                card.BackgroundColor3 = Library.Theme.Surface2
                card.BorderSizePixel = 0
                card.Parent = content
                corner(card, 8)
                stroke(card, Library.Theme.BorderSubtle, 1, 0.5)

                local txt = label(card, text, 11, Library.Theme.Text, Enum.Font.GothamSemibold)
                txt.Size = UDim2.new(1, -60, 0, 20)
                txt.Position = UDim2.new(0, 12, 0, 6)
                txt.TextXAlignment = Enum.TextXAlignment.Left

                local valLabel = label(card, tostring(value), 11, Library.Theme.Accent, Enum.Font.GothamBold)
                valLabel.Size = UDim2.new(0, 50, 0, 20)
                valLabel.Position = UDim2.new(1, -55, 0, 6)
                valLabel.TextXAlignment = Enum.TextXAlignment.Right

                local sliderBar = Instance.new("Frame")
                sliderBar.Size = UDim2.new(1, -24, 0, 6)
                sliderBar.Position = UDim2.new(0, 12, 0, 32)
                sliderBar.BackgroundColor3 = Library.Theme.SurfaceHover
                sliderBar.Parent = card
                corner(sliderBar, 3)

                local fillBar = Instance.new("Frame")
                fillBar.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                fillBar.BackgroundColor3 = Library.Theme.Accent
                fillBar.Parent = sliderBar
                corner(fillBar, 3)

                local dragging = false
                local function update(input)
                    local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + ((max - min) * pos) + 0.5)
                    valLabel.Text = tostring(value)
                    fillBar.Size = UDim2.new(pos, 0, 1, 0)
                    if callback then pcall(function() callback(value) end) end
                end

                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        update(input)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        update(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                return card
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
        Status.Visible = not minimized
        local targetSize = minimized and UDim2.new(0, 500, 0, 50) or UDim2.new(0, 500, 0, 340)
        tween(MainFrame, {Size = targetSize}, 0.3)
        MinimizeBtn.Text = minimized and "+" or "−"
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Library:SendNotification("NAEI HUB", "UI Closed.", 2)
        tween(MainFrame, {Size = UDim2.new(0, 400, 0, 0)}, 0.2)
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
