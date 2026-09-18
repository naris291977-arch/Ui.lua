--//========================================================
--// PEPE UI LIBRARY V6
--// Modern White / Purple
--// Mobile First
--// Responsive / Animated / Compact
--//========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}

--========================================================
-- CONFIG
--========================================================

Library.Config = {
    Name = "PEPE UI",
    Version = "V6.0",

    Logo = "rbxassetid://0",

    LoadingScreen = true,
    LoadingTime = 1.0,

    Accent = Color3.fromRGB(126, 92, 255),

    DesktopSize = Vector2.new(620, 390),
    MobileSize = Vector2.new(340, 440),

    MinSize = Vector2.new(300, 300),
}

Library.Theme = {
    Background = Color3.fromRGB(246, 246, 250),
    Card = Color3.fromRGB(255, 255, 255),

    Text = Color3.fromRGB(30, 30, 42),
    SubText = Color3.fromRGB(135, 135, 150),

    Border = Color3.fromRGB(225, 225, 235),
    Muted = Color3.fromRGB(218, 218, 228),

    Accent = Library.Config.Accent,

    Success = Color3.fromRGB(45, 190, 115),
    Danger = Color3.fromRGB(235, 80, 95),
}

Library._AccentObjects = {}

--========================================================
-- UTILITY
--========================================================

local function Tween(Object, Properties, Time)
    if not Object or not Object.Parent then
        return
    end

    local T = TweenService:Create(
        Object,
        TweenInfo.new(
            Time or 0.2,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        Properties
    )

    T:Play()
    return T
end

local function Corner(Object, Radius)
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, Radius or 10)
    C.Parent = Object
    return C
end

local function Stroke(Object, Color, Transparency)
    local S = Instance.new("UIStroke")

    S.Color = Color or Library.Theme.Border
    S.Transparency = Transparency or 0.15
    S.Thickness = 1

    S.Parent = Object

    return S
end

local function RegisterAccent(Object, Property)
    table.insert(Library._AccentObjects, {
        Object = Object,
        Property = Property
    })
end

local function AddPadding(Object, Left, Right, Top, Bottom)
    local P = Instance.new("UIPadding")

    P.PaddingLeft = UDim.new(0, Left or 0)
    P.PaddingRight = UDim.new(0, Right or 0)
    P.PaddingTop = UDim.new(0, Top or 0)
    P.PaddingBottom = UDim.new(0, Bottom or 0)

    P.Parent = Object

    return P
end

local function AddShadow(Object)
    local Shadow = Instance.new("ImageLabel")

    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.fromScale(0.5, 0.5)
    Shadow.Size = UDim2.new(1, 30, 1, 30)

    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.fromRGB(50, 40, 80)
    Shadow.ImageTransparency = 0.88
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)

    Shadow.ZIndex = Object.ZIndex - 1
    Shadow.Parent = Object

    return Shadow
end

function Library:SetThemeColor(Color)

    if typeof(Color) ~= "Color3" then
        return
    end

    Library.Theme.Accent = Color

    for _, Data in ipairs(Library._AccentObjects) do

        if Data.Object and Data.Object.Parent then

            pcall(function()
                Data.Object[Data.Property] = Color
            end)

        end

    end
end

--========================================================
-- SCREEN GUI
--========================================================

local GUI = Instance.new("ScreenGui")

GUI.Name = "PEPE_UI_LIBRARY_V6"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    GUI.ScreenInsets = Enum.ScreenInsets.None
end)

GUI.Parent = PlayerGui

--========================================================
-- NOTIFICATION SYSTEM
--========================================================

function Library:Notify(Data)

    Data = Data or {}

    local Holder = GUI:FindFirstChild("Notifications")

    if not Holder then

        Holder = Instance.new("Frame")

        Holder.Name = "Notifications"
        Holder.AnchorPoint = Vector2.new(1, 0)
        Holder.Position = UDim2.new(1, -15, 0, 15)

        Holder.Size = UDim2.fromOffset(300, 400)

        Holder.BackgroundTransparency = 1
        Holder.Parent = GUI

        local Layout = Instance.new("UIListLayout")

        Layout.Padding = UDim.new(0, 8)
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        Layout.VerticalAlignment = Enum.VerticalAlignment.Top

        Layout.Parent = Holder
    end

    local Notification = Instance.new("Frame")

    Notification.Size = UDim2.new(1, 0, 0, 68)
    Notification.BackgroundColor3 = Library.Theme.Card
    Notification.BorderSizePixel = 0
    Notification.Parent = Holder

    Corner(Notification, 14)
    Stroke(Notification)
    AddShadow(Notification)

    local Accent = Instance.new("Frame")

    Accent.Position = UDim2.fromOffset(7, 10)
    Accent.Size = UDim2.new(0, 4, 1, -20)

    Accent.BackgroundColor3 = Library.Theme.Accent
    Accent.BorderSizePixel = 0
    Accent.Parent = Notification

    Corner(Accent, 5)

    RegisterAccent(Accent, "BackgroundColor3")

    local Title = Instance.new("TextLabel")

    Title.Position = UDim2.fromOffset(20, 9)
    Title.Size = UDim2.new(1, -30, 0, 18)

    Title.BackgroundTransparency = 1
    Title.Text = Data.Title or "Notification"

    Title.TextColor3 = Library.Theme.Text
    Title.TextSize = 10
    Title.Font = Enum.Font.GothamBold

    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Notification

    local Content = Instance.new("TextLabel")

    Content.Position = UDim2.fromOffset(20, 29)
    Content.Size = UDim2.new(1, -30, 0, 30)

    Content.BackgroundTransparency = 1
    Content.Text = Data.Content or ""

    Content.TextColor3 = Library.Theme.SubText
    Content.TextSize = 8
    Content.Font = Enum.Font.Gotham

    Content.TextWrapped = true
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.Parent = Notification

    Notification.Position = UDim2.new(1, 20, 0, 0)

    Tween(Notification, {
        Position = UDim2.new(0, 0, 0, 0)
    }, 0.3)

    task.delay(Data.Duration or 3, function()

        if Notification and Notification.Parent then

            Tween(Notification, {
                Position = UDim2.new(1, 20, 0, 0)
            }, 0.25)

            task.wait(0.3)

            if Notification then
                Notification:Destroy()
            end

        end

    end)
end

--========================================================
-- LOADING SCREEN
--========================================================

local function LoadingScreen()

    local Loading = Instance.new("Frame")

    Loading.Name = "Loading"
    Loading.Size = UDim2.fromScale(1, 1)

    Loading.BackgroundColor3 = Library.Theme.Background
    Loading.BorderSizePixel = 0

    Loading.ZIndex = 1000
    Loading.Parent = GUI

    local Card = Instance.new("Frame")

    Card.AnchorPoint = Vector2.new(0.5, 0.5)
    Card.Position = UDim2.fromScale(0.5, 0.5)

    Card.Size = UDim2.fromOffset(330, 190)

    Card.BackgroundColor3 = Library.Theme.Card
    Card.BorderSizePixel = 0

    Card.ZIndex = 1001
    Card.Parent = Loading

    Corner(Card, 22)
    Stroke(Card)
    AddShadow(Card)

    local Logo = Instance.new("ImageLabel")

    Logo.AnchorPoint = Vector2.new(0.5, 0)
    Logo.Position = UDim2.new(0.5, 0, 0, 20)

    Logo.Size = UDim2.fromOffset(55, 55)

    Logo.BackgroundColor3 = Library.Theme.Accent
    Logo.Image = Library.Config.Logo

    Logo.BorderSizePixel = 0
    Logo.ZIndex = 1002
    Logo.Parent = Card

    Corner(Logo, 15)

    RegisterAccent(Logo, "BackgroundColor3")

    local Title = Instance.new("TextLabel")

    Title.Position = UDim2.fromOffset(15, 83)
    Title.Size = UDim2.new(1, -30, 0, 22)

    Title.BackgroundTransparency = 1
    Title.Text = Library.Config.Name

    Title.TextColor3 = Library.Theme.Text
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold

    Title.ZIndex = 1002
    Title.Parent = Card

    local Sub = Instance.new("TextLabel")

    Sub.Position = UDim2.fromOffset(15, 106)
    Sub.Size = UDim2.new(1, -30, 0, 18)

    Sub.BackgroundTransparency = 1
    Sub.Text = "กำลังโหลด Library..."

    Sub.TextColor3 = Library.Theme.SubText
    Sub.TextSize = 8
    Sub.Font = Enum.Font.Gotham

    Sub.ZIndex = 1002
    Sub.Parent = Card

    local BarBG = Instance.new("Frame")

    BarBG.Position = UDim2.new(0, 25, 1, -32)
    BarBG.Size = UDim2.new(1, -50, 0, 6)

    BarBG.BackgroundColor3 = Library.Theme.Muted
    BarBG.BorderSizePixel = 0

    BarBG.ZIndex = 1002
    BarBG.Parent = Card

    Corner(BarBG, 10)

    local Bar = Instance.new("Frame")

    Bar.Size = UDim2.new(0, 0, 1, 0)

    Bar.BackgroundColor3 = Library.Theme.Accent
    Bar.BorderSizePixel = 0

    Bar.ZIndex = 1003
    Bar.Parent = BarBG

    Corner(Bar, 10)

    RegisterAccent(Bar, "BackgroundColor3")

    Tween(Bar, {
        Size = UDim2.new(1, 0, 1, 0)
    }, Library.Config.LoadingTime)

    task.wait(Library.Config.LoadingTime)

    Tween(Loading, {
        BackgroundTransparency = 1
    }, 0.25)

    task.wait(0.3)

    Loading:Destroy()
end

--========================================================
-- WINDOW
--========================================================

function Library:CreateWindow(Data)

    Data = Data or {}

    local WindowObject = {}

    local Camera = workspace.CurrentCamera

    local function IsMobile()

        if not Camera then
            Camera = workspace.CurrentCamera
        end

        if not Camera then
            return false
        end

        return Camera.ViewportSize.X < 600
    end

    local Mobile = IsMobile()

    local WindowSize

    if Mobile then
        WindowSize = Library.Config.MobileSize
    else
        WindowSize = Library.Config.DesktopSize
    end

    --====================================================
    -- MAIN
    --====================================================

    local Main = Instance.new("Frame")

    Main.Name = "Window"

    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.fromScale(0.5, 0.5)

    Main.Size = UDim2.fromOffset(
        WindowSize.X,
        WindowSize.Y
    )

    Main.BackgroundColor3 = Library.Theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true

    Main.Parent = GUI

    Corner(Main, 20)
    Stroke(Main)
    AddShadow(Main)

    WindowObject.Main = Main

    --====================================================
    -- SIDEBAR
    --====================================================

    local SidebarWidth = Mobile and 62 or 155

    local Sidebar = Instance.new("Frame")

    Sidebar.Name = "Sidebar"

    Sidebar.Size = UDim2.new(
        0,
        SidebarWidth,
        1,
        0
    )

    Sidebar.BackgroundColor3 = Library.Theme.Card
    Sidebar.BorderSizePixel = 0

    Sidebar.Parent = Main

    --====================================================
    -- LOGO
    --====================================================

    local Logo = Instance.new("ImageLabel")

    Logo.AnchorPoint = Vector2.new(0.5, 0)

    Logo.Position = UDim2.new(
        0.5,
        0,
        0,
        13
    )

    Logo.Size = UDim2.fromOffset(
        Mobile and 36 or 38,
        Mobile and 36 or 38
    )

    Logo.BackgroundColor3 = Library.Theme.Accent
    Logo.Image = Library.Config.Logo

    Logo.BorderSizePixel = 0
    Logo.Parent = Sidebar

    Corner(Logo, 11)

    RegisterAccent(Logo, "BackgroundColor3")

    --====================================================
    -- APP NAME
    --====================================================

    if not Mobile then

        local Name = Instance.new("TextLabel")

        Name.Position = UDim2.fromOffset(59, 11)
        Name.Size = UDim2.new(1, -65, 0, 19)

        Name.BackgroundTransparency = 1

        Name.Text =
            Data.Name
            or Library.Config.Name

        Name.TextColor3 = Library.Theme.Text
        Name.TextSize = 11
        Name.Font = Enum.Font.GothamBold

        Name.TextXAlignment = Enum.TextXAlignment.Left
        Name.Parent = Sidebar

        local Version = Instance.new("TextLabel")

        Version.Position = UDim2.fromOffset(59, 29)
        Version.Size = UDim2.new(1, -65, 0, 13)

        Version.BackgroundTransparency = 1

        Version.Text =
            Data.Version
            or Library.Config.Version

        Version.TextColor3 = Library.Theme.SubText
        Version.TextSize = 7
        Version.Font = Enum.Font.Gotham

        Version.TextXAlignment = Enum.TextXAlignment.Left
        Version.Parent = Sidebar

    end

    --====================================================
    -- TAB LIST
    --====================================================

    local TabList = Instance.new("ScrollingFrame")

    TabList.Position = UDim2.fromOffset(
        7,
        Mobile and 62 or 65
    )

    TabList.Size = UDim2.new(
        1,
        -14,
        1,
        -125
    )

    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0

    TabList.ScrollBarThickness = 0
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)

    TabList.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")

    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    TabLayout.Parent = TabList

    --====================================================
    -- PROFILE
    --====================================================

    local Profile = Instance.new("Frame")

    Profile.Position = UDim2.new(
        0,
        7,
        1,
        -52
    )

    Profile.Size = UDim2.new(
        1,
        -14,
        0,
        43
    )

    Profile.BackgroundColor3 = Library.Theme.Background
    Profile.BorderSizePixel = 0

    Profile.Parent = Sidebar

    Corner(Profile, 12)

    local Avatar = Instance.new("ImageLabel")

    Avatar.Size = UDim2.fromOffset(30, 30)

    Avatar.Position = UDim2.new(
        0,
        6,
        0.5,
        -15
    )

    Avatar.BackgroundColor3 = Library.Theme.Accent

    Avatar.BorderSizePixel = 0
    Avatar.Parent = Profile

    Corner(Avatar, 10)

    Avatar.Image =
        "https://www.roblox.com/headshot-thumbnail/image?userId="
        .. LocalPlayer.UserId
        .. "&width=150&height=150&format=png"

    if not Mobile then

        local Display = Instance.new("TextLabel")

        Display.Position = UDim2.fromOffset(43, 5)
        Display.Size = UDim2.new(1, -48, 0, 16)

        Display.BackgroundTransparency = 1

        Display.Text = LocalPlayer.DisplayName

        Display.TextColor3 = Library.Theme.Text
        Display.TextSize = 8
        Display.Font = Enum.Font.GothamBold

        Display.TextXAlignment = Enum.TextXAlignment.Left
        Display.Parent = Profile

        local Username = Instance.new("TextLabel")

        Username.Position = UDim2.fromOffset(43, 21)
        Username.Size = UDim2.new(1, -48, 0, 13)

        Username.BackgroundTransparency = 1

        Username.Text = "@" .. LocalPlayer.Name

        Username.TextColor3 = Library.Theme.SubText
        Username.TextSize = 7
        Username.Font = Enum.Font.Gotham

        Username.TextXAlignment = Enum.TextXAlignment.Left
        Username.Parent = Profile

    end

    --====================================================
    -- CONTENT
    --====================================================

    local Content = Instance.new("Frame")

    Content.Position = UDim2.new(
        0,
        SidebarWidth,
        0,
        0
    )

    Content.Size = UDim2.new(
        1,
        -SidebarWidth,
        1,
        0
    )

    Content.BackgroundTransparency = 1
    Content.Parent = Main

    --====================================================
    -- TOPBAR
    --====================================================

    local Topbar = Instance.new("Frame")

    Topbar.Position = UDim2.fromOffset(0, 0)
    Topbar.Size = UDim2.new(1, 0, 0, 57)

    Topbar.BackgroundColor3 = Library.Theme.Card
    Topbar.BorderSizePixel = 0

    Topbar.Parent = Content

    local TopLine = Instance.new("Frame")

    TopLine.Position = UDim2.new(0, 0, 1, -1)
    TopLine.Size = UDim2.new(1, 0, 0, 1)

    TopLine.BackgroundColor3 = Library.Theme.Border
    TopLine.BorderSizePixel = 0

    TopLine.Parent = Topbar

    local PageTitle = Instance.new("TextLabel")

    PageTitle.Position = UDim2.fromOffset(18, 9)
    PageTitle.Size = UDim2.new(1, -90, 0, 22)

    PageTitle.BackgroundTransparency = 1
    PageTitle.Text = "Dashboard"

    PageTitle.TextColor3 = Library.Theme.Text
    PageTitle.TextSize = 14
    PageTitle.Font = Enum.Font.GothamBold

    PageTitle.TextXAlignment = Enum.TextXAlignment.Left
    PageTitle.Parent = Topbar

    local PageSub = Instance.new("TextLabel")

    PageSub.Position = UDim2.fromOffset(18, 31)
    PageSub.Size = UDim2.new(1, -90, 0, 14)

    PageSub.BackgroundTransparency = 1
    PageSub.Text = "Welcome back"

    PageSub.TextColor3 = Library.Theme.SubText
    PageSub.TextSize = 7
    PageSub.Font = Enum.Font.Gotham

    PageSub.TextXAlignment = Enum.TextXAlignment.Left
    PageSub.Parent = Topbar

    --====================================================
    -- MINIMIZE
    --====================================================

    local Minimize = Instance.new("TextButton")

    Minimize.Size = UDim2.fromOffset(31, 31)

    Minimize.Position = UDim2.new(
        1,
        -42,
        0,
        12
    )

    Minimize.BackgroundColor3 = Library.Theme.Background

    Minimize.Text = "—"

    Minimize.TextColor3 = Library.Theme.SubText
    Minimize.TextSize = 14
    Minimize.Font = Enum.Font.GothamBold

    Minimize.BorderSizePixel = 0
    Minimize.Parent = Topbar

    Corner(Minimize, 9)

    --====================================================
    -- FLOATING BUTTON
    --====================================================

    local Floating = Instance.new("ImageButton")

    Floating.Size = UDim2.fromOffset(50, 50)

    Floating.Position = UDim2.new(
        0,
        18,
        0.5,
        -25
    )

    Floating.BackgroundColor3 = Library.Theme.Accent
    Floating.Image = Library.Config.Logo

    Floating.BorderSizePixel = 0
    Floating.Visible = false

    Floating.Parent = GUI

    Corner(Floating, 15)

    RegisterAccent(
        Floating,
        "BackgroundColor3"
    )

    AddShadow(Floating)

    --====================================================
    -- MINIMIZE EVENTS
    --====================================================

    Minimize.MouseButton1Click:Connect(function()

        Tween(Main, {
            Size = UDim2.fromOffset(
                math.max(300, Main.AbsoluteSize.X - 30),
                math.max(250, Main.AbsoluteSize.Y - 30)
            )
        }, 0.15)

        task.wait(0.08)

        Main.Visible = false
        Floating.Visible = true

    end)

    Floating.MouseButton1Click:Connect(function()

        Floating.Visible = false
        Main.Visible = true

        Main.Size = UDim2.fromOffset(
            0,
            0
        )

        Tween(Main, {
            Size = UDim2.fromOffset(
                WindowSize.X,
                WindowSize.Y
            )
        }, 0.3)

    end)

    --====================================================
    -- DRAG SYSTEM
    --====================================================

    local Dragging = false
    local DragStart
    local StartPosition

    local function StartDrag(Input)

        Dragging = true

        DragStart = Input.Position
        StartPosition = Main.Position

    end

    local function UpdateDrag(Input)

        if not Dragging then
            return
        end

        local Delta =
            Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,

            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )

    end

    Topbar.InputBegan:Connect(function(Input)

        if
            Input.UserInputType
                == Enum.UserInputType.MouseButton1
            or
            Input.UserInputType
                == Enum.UserInputType.Touch
        then

            StartDrag(Input)

        end

    end)

    UserInputService.InputChanged:Connect(function(Input)

        if
            Input.UserInputType
                == Enum.UserInputType.MouseMovement
            or
            Input.UserInputType
                == Enum.UserInputType.Touch
        then

            UpdateDrag(Input)

        end

    end)

    UserInputService.InputEnded:Connect(function(Input)

        if
            Input.UserInputType
                == Enum.UserInputType.MouseButton1
            or
            Input.UserInputType
                == Enum.UserInputType.Touch
        then

            Dragging = false

        end

    end)

    --====================================================
    -- CREATE TAB
    --====================================================

    local FirstTab = true

    function WindowObject:CreateTab(TabData)

        TabData = TabData or {}

        local TabObject = {}

        --================================================
        -- TAB BUTTON
        --================================================

        local TabButton = Instance.new("TextButton")

        TabButton.Size = UDim2.new(
            1,
            0,
            0,
            38
        )

        TabButton.BackgroundColor3 =
            Library.Theme.Accent

        TabButton.BackgroundTransparency = 1

        TabButton.Text = ""
        TabButton.BorderSizePixel = 0

        TabButton.Parent = TabList

        Corner(TabButton, 10)

        local Icon = Instance.new("TextLabel")

        Icon.Size = UDim2.fromOffset(
            Mobile and 62 or 34,
            38
        )

        Icon.BackgroundTransparency = 1

        Icon.Text =
            TabData.Icon
            or "•"

        Icon.TextColor3 =
            Library.Theme.SubText

        Icon.TextSize = 13
        Icon.Font = Enum.Font.GothamBold

        Icon.Parent = TabButton

        local Label = Instance.new("TextLabel")

        Label.Position = UDim2.fromOffset(
            Mobile and 0 or 34,
            0
        )

        Label.Size = UDim2.new(
            1,
            Mobile and 0 or -38,
            1,
            0
        )

        Label.BackgroundTransparency = 1

        Label.Text =
            Mobile
            and ""
            or (TabData.Name or "Tab")

        Label.TextColor3 =
            Library.Theme.SubText

        Label.TextSize = 8
        Label.Font = Enum.Font.GothamMedium

        Label.TextXAlignment =
            Enum.TextXAlignment.Left

        Label.Parent = TabButton

        --================================================
        -- ACTIVE INDICATOR
        --================================================

        local Indicator = Instance.new("Frame")

        Indicator.Position = UDim2.new(
            0,
            0,
            0.5,
            -8
        )

        Indicator.Size = UDim2.fromOffset(
            3,
            16
        )

        Indicator.BackgroundColor3 =
            Library.Theme.Accent

        Indicator.BorderSizePixel = 0

        Indicator.Visible = false
        Indicator.Parent = TabButton

        Corner(Indicator, 5)

        RegisterAccent(
            Indicator,
            "BackgroundColor3"
        )

        --================================================
        -- PAGE
        --================================================

        local Page = Instance.new("ScrollingFrame")

        Page.Position = UDim2.fromOffset(
            15,
            67
        )

        Page.Size = UDim2.new(
            1,
            -30,
            1,
            -80
        )

        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0

        Page.ScrollBarThickness = 2

        Page.ScrollBarImageColor3 =
            Library.Theme.Accent

        Page.CanvasSize =
            UDim2.new(0, 0, 0, 0)

        Page.Visible = false

        Page.Parent = Content

        local Layout = Instance.new("UIListLayout")

        Layout.Padding = UDim.new(0, 7)

        Layout.Parent = Page

        Layout:GetPropertyChangedSignal(
            "AbsoluteContentSize"
        ):Connect(function()

            Page.CanvasSize = UDim2.new(
                0,
                0,
                0,
                Layout.AbsoluteContentSize.Y + 12
            )

        end)

        --================================================
        -- SELECT
        --================================================

        local function Select()

            for _, Child in ipairs(
                TabList:GetChildren()
            ) do

                if Child:IsA("TextButton") then

                    Child.BackgroundTransparency = 1

                    local L =
                        Child:FindFirstChildWhichIsA(
                            "TextLabel"
                        )

                    if L and L ~= Label then

                        L.TextColor3 =
                            Library.Theme.SubText

                    end

                    local I =
                        Child:FindFirstChild(
                            "Frame"
                        )

                    if I then
                        I.Visible = false
                    end

                end

            end

            for _, Child in ipairs(
                Content:GetChildren()
            ) do

                if Child:IsA("ScrollingFrame") then
                    Child.Visible = false
                end

            end

            Page.Visible = true

            TabButton.BackgroundColor3 =
                Library.Theme.Accent:Lerp(
                    Color3.new(1, 1, 1),
                    0.88
                )

            TabButton.BackgroundTransparency = 0

            Label.TextColor3 =
                Library.Theme.Accent

            Icon.TextColor3 =
                Library.Theme.Accent

            Indicator.Visible = true

            PageTitle.Text =
                TabData.Name
                or "Tab"

            PageSub.Text =
                "Configure "
                .. (TabData.Name or "Tab")

        end

        TabButton.MouseButton1Click:Connect(
            Select
        )

        --================================================
        -- SECTION
        --================================================

        function TabObject:CreateSection(Text)

            local Section = Instance.new("TextLabel")

            Section.Size = UDim2.new(
                1,
                0,
                0,
                22
            )

            Section.BackgroundTransparency = 1

            Section.Text =
                string.upper(
                    Text or "SECTION"
                )

            Section.TextColor3 =
                Library.Theme.Text

            Section.TextSize = 9
            Section.Font = Enum.Font.GothamBold

            Section.TextXAlignment =
                Enum.TextXAlignment.Left

            Section.Parent = Page

            return Section
        end

        --================================================
        -- LABEL
        --================================================

        function TabObject:CreateLabel(Text)

            local LabelObject =
                Instance.new("TextLabel")

            LabelObject.Size =
                UDim2.new(1, 0, 0, 30)

            LabelObject.BackgroundTransparency = 1

            LabelObject.Text =
                Text or ""

            LabelObject.TextColor3 =
                Library.Theme.SubText

            LabelObject.TextSize = 8
            LabelObject.Font = Enum.Font.Gotham

            LabelObject.TextWrapped = true

            LabelObject.TextXAlignment =
                Enum.TextXAlignment.Left

            LabelObject.Parent = Page

            return LabelObject
        end

        --================================================
        -- PARAGRAPH
        --================================================

        function TabObject:CreateParagraph(Data)

            Data = Data or {}

            local Box = Instance.new("Frame")

            Box.Size =
                UDim2.new(1, 0, 0, 67)

            Box.BackgroundColor3 =
                Library.Theme.Card

            Box.BorderSizePixel = 0

            Box.Parent = Page

            Corner(Box, 13)
            Stroke(Box)

            local AccentLine =
                Instance.new("Frame")

            AccentLine.Position =
                UDim2.fromOffset(8, 12)

            AccentLine.Size =
                UDim2.new(0, 3, 1, -24)

            AccentLine.BackgroundColor3 =
                Library.Theme.Accent

            AccentLine.BorderSizePixel = 0

            AccentLine.Parent = Box

            Corner(AccentLine, 5)

            RegisterAccent(
                AccentLine,
                "BackgroundColor3"
            )

            local Title =
                Instance.new("TextLabel")

            Title.Position =
                UDim2.fromOffset(19, 8)

            Title.Size =
                UDim2.new(1, -30, 0, 18)

            Title.BackgroundTransparency = 1

            Title.Text =
                Data.Title
                or "Information"

            Title.TextColor3 =
                Library.Theme.Text

            Title.TextSize = 9
            Title.Font = Enum.Font.GothamBold

            Title.TextXAlignment =
                Enum.TextXAlignment.Left

            Title.Parent = Box

            local ContentText =
                Instance.new("TextLabel")

            ContentText.Position =
                UDim2.fromOffset(19, 28)

            ContentText.Size =
                UDim2.new(1, -30, 0, 30)

            ContentText.BackgroundTransparency = 1

            ContentText.Text =
                Data.Content
                or ""

            ContentText.TextColor3 =
                Library.Theme.SubText

            ContentText.TextSize = 8
            ContentText.Font = Enum.Font.Gotham

            ContentText.TextWrapped = true

            ContentText.TextXAlignment =
                Enum.TextXAlignment.Left

            ContentText.Parent = Box

            return Box
        end

        --================================================
        -- BUTTON
        --================================================

        function TabObject:CreateButton(Data)

            Data = Data or {}

            local Button =
                Instance.new("TextButton")

            Button.Size =
                UDim2.new(1, 0, 0, 40)

            Button.BackgroundColor3 =
                Library.Theme.Card

            Button.Text =
                Data.Name
                or "Button"

            Button.TextColor3 =
                Library.Theme.Text

            Button.TextSize = 9
            Button.Font = Enum.Font.GothamMedium

            Button.BorderSizePixel = 0

            Button.AutoButtonColor = false

            Button.Parent = Page

            Corner(Button, 11)
            Stroke(Button)

            Button.MouseEnter:Connect(function()

                Tween(Button, {
                    BackgroundColor3 =
                        Library.Theme.Accent:Lerp(
                            Color3.new(1, 1, 1),
                            0.91
                        )
                }, 0.12)

            end)

            Button.MouseLeave:Connect(function()

                Tween(Button, {
                    BackgroundColor3 =
                        Library.Theme.Card
                }, 0.12)

            end)

            Button.MouseButton1Click:Connect(
                function()

                    Tween(Button, {
                        Size =
                            UDim2.new(
                                1,
                                -4,
                                0,
                                38
                            )
                    }, 0.08)

                    task.delay(0.08, function()

                        Tween(Button, {
                            Size =
                                UDim2.new(
                                    1,
                                    0,
                                    0,
                                    40
                                )
                        }, 0.08)

                    end)

                    if Data.Callback then
                        Data.Callback()
                    end

                end
            )

            return Button
        end

        --================================================
        -- TOGGLE
        --================================================

        function TabObject:CreateToggle(Data)

            Data = Data or {}

            local State =
                Data.CurrentValue == true

            local Holder =
                Instance.new("TextButton")

            Holder.Size =
                UDim2.new(1, 0, 0, 42)

            Holder.BackgroundColor3 =
                Library.Theme.Card

            Holder.Text = ""

            Holder.BorderSizePixel = 0

            Holder.AutoButtonColor = false

            Holder.Parent = Page

            Corner(Holder, 11)
            Stroke(Holder)

            local Label =
                Instance.new("TextLabel")

            Label.Position =
                UDim2.fromOffset(12, 0)

            Label.Size =
                UDim2.new(1, -65, 1, 0)

            Label.BackgroundTransparency = 1

            Label.Text =
                Data.Name
                or "Toggle"

            Label.TextColor3 =
                Library.Theme.Text

            Label.TextSize = 9
            Label.Font = Enum.Font.GothamMedium

            Label.TextXAlignment =
                Enum.TextXAlignment.Left

            Label.Parent = Holder

            local Switch =
                Instance.new("Frame")

            Switch.Size =
                UDim2.fromOffset(40, 22)

            Switch.Position =
                UDim2.new(
                    1,
                    -51,
                    0.5,
                    -11
                )

            Switch.BackgroundColor3 =
                Color3.fromRGB(
                    215,
                    215,
                    225
                )

            Switch.BorderSizePixel = 0
            Switch.Parent = Holder

            Corner(Switch, 20)

            local Dot =
                Instance.new("Frame")

            Dot.Size =
                UDim2.fromOffset(16, 16)

            Dot.Position =
                UDim2.new(
                    0,
                    3,
                    0.5,
                    -8
                )

            Dot.BackgroundColor3 =
                Color3.new(1, 1, 1)

            Dot.BorderSizePixel = 0

            Dot.Parent = Switch

            Corner(Dot, 20)

            local function Update(
                FireCallback
            )

                if State then

                    Tween(Switch, {
                        BackgroundColor3 =
                            Library.Theme.Accent
                    })

                    Tween(Dot, {
                        Position =
                            UDim2.new(
                                1,
                                -19,
                                0.5,
                                -8
                            )
                    })

                else

                    Tween(Switch, {
                        BackgroundColor3 =
                            Color3.fromRGB(
                                215,
                                215,
                                225
                            )
                    })

                    Tween(Dot, {
                        Position =
                            UDim2.new(
                                0,
                                3,
                                0.5,
                                -8
                            )
                    })

                end

                if FireCallback
                    and Data.Callback
                then
                    Data.Callback(State)
                end

            end

            Holder.MouseButton1Click:Connect(
                function()

                    State = not State

                    Update(true)

                end
            )

            Update(false)

            return {

                Set = function(_, Value)

                    State = Value == true

                    Update(true)

                end,

                Get = function()
                    return State
                end

            }
        end

        --================================================
        -- SLIDER
        --================================================

        function TabObject:CreateSlider(Data)

            Data = Data or {}

            local Min =
                Data.Range
                and Data.Range[1]
                or 0

            local Max =
                Data.Range
                and Data.Range[2]
                or 100

            local Value =
                Data.CurrentValue
                or Min

            local Holder =
                Instance.new("Frame")

            Holder.Size =
                UDim2.new(1, 0, 0, 60)

            Holder.BackgroundColor3 =
                Library.Theme.Card

            Holder.BorderSizePixel = 0
            Holder.Parent = Page

            Corner(Holder, 11)
            Stroke(Holder)

            local Label =
                Instance.new("TextLabel")

            Label.Position =
                UDim2.fromOffset(12, 7)

            Label.Size =
                UDim2.new(1, -70, 0, 18)

            Label.BackgroundTransparency = 1

            Label.Text =
                Data.Name
                or "Slider"

            Label.TextColor3 =
                Library.Theme.Text

            Label.TextSize = 9
            Label.Font = Enum.Font.GothamMedium

            Label.TextXAlignment =
                Enum.TextXAlignment.Left

            Label.Parent = Holder

            local ValueLabel =
                Instance.new("TextLabel")

            ValueLabel.Position =
                UDim2.new(
                    1,
                    -55,
                    0,
                    7
                )

            ValueLabel.Size =
                UDim2.fromOffset(43, 18)

            ValueLabel.BackgroundTransparency = 1

            ValueLabel.Text =
                tostring(Value)

            ValueLabel.TextColor3 =
                Library.Theme.Accent

            ValueLabel.TextSize = 9
            ValueLabel.Font = Enum.Font.GothamBold

            ValueLabel.TextXAlignment =
                Enum.TextXAlignment.Right

            ValueLabel.Parent = Holder

            RegisterAccent(
                ValueLabel,
                "TextColor3"
            )

            local Bar =
                Instance.new("Frame")

            Bar.Position =
                UDim2.fromOffset(12, 37)

            Bar.Size =
                UDim2.new(
                    1,
                    -24,
                    0,
                    6
                )

            Bar.BackgroundColor3 =
                Library.Theme.Muted

            Bar.BorderSizePixel = 0

            Bar.Parent = Holder

            Corner(Bar, 10)

            local Fill =
                Instance.new("Frame")

            Fill.Size =
                UDim2.new(
                    math.clamp(
                        (Value - Min)
                            / math.max(
                                Max - Min,
                                1
                            ),
                        0,
                        1
                    ),
                    0,
                    1,
                    0
                )

            Fill.BackgroundColor3 =
                Library.Theme.Accent

            Fill.BorderSizePixel = 0

            Fill.Parent = Bar

            Corner(Fill, 10)

            RegisterAccent(
                Fill,
                "BackgroundColor3"
            )

            local Dragging = false

            local function SetValue(NewValue)

                NewValue =
                    math.clamp(
                        NewValue,
                        Min,
                        Max
                    )

                local Increment =
                    Data.Increment
                    or 1

                NewValue =
                    math.floor(
                        NewValue
                            / Increment
                            + 0.5
                    ) * Increment

                Value = NewValue

                local Percent =
                    (Value - Min)
                    / math.max(
                        Max - Min,
                        1
                    )

                Fill.Size =
                    UDim2.new(
                        Percent,
                        0,
                        1,
                        0
                    )

                ValueLabel.Text =
                    tostring(Value)

                if Data.Callback then
                    Data.Callback(Value)
                end
            end

            local function InputChanged(Input)

                if Bar.AbsoluteSize.X <= 0 then
                    return
                end

                local Percent =
                    math.clamp(
                        (
                            Input.Position.X
                            - Bar.AbsolutePosition.X
                        )
                        / Bar.AbsoluteSize.X,
                        0,
                        1
                    )

                SetValue(
                    Min
                    + (
                        Max - Min
                    ) * Percent
                )
            end

            Bar.InputBegan:Connect(
                function(Input)

                    if
                        Input.UserInputType
                            == Enum.UserInputType.MouseButton1
                        or
                        Input.UserInputType
                            == Enum.UserInputType.Touch
                    then

                        Dragging = true

                        InputChanged(Input)

                    end

                end
            )

            UserInputService.InputChanged:Connect(
                function(Input)

                    if not Dragging then
                        return
                    end

                    if
                        Input.UserInputType
                            == Enum.UserInputType.MouseMovement
                        or
                        Input.UserInputType
                            == Enum.UserInputType.Touch
                    then

                        InputChanged(Input)

                    end

                end
            )

            UserInputService.InputEnded:Connect(
                function(Input)

                    if
                        Input.UserInputType
                            == Enum.UserInputType.MouseButton1
                        or
                        Input.UserInputType
                            == Enum.UserInputType.Touch
                    then

                        Dragging = false

                    end

                end
            )

            return {

                Set = function(_, NewValue)
                    SetValue(NewValue)
                end,

                Get = function()
                    return Value
                end

            }
        end

        --================================================
        -- DROPDOWN
        --================================================

        function TabObject:CreateDropdown(Data)

            Data = Data or {}

            local Options =
                Data.Options
                or {}

            local Current =
                Data.CurrentOption
                or Options[1]

            local Holder =
                Instance.new("Frame")

            Holder.Size =
                UDim2.new(1, 0, 0, 42)

            Holder.BackgroundColor3 =
                Library.Theme.Card

            Holder.BorderSizePixel = 0

            Holder.ClipsDescendants = true
            Holder.Parent = Page

            Corner(Holder, 11)
            Stroke(Holder)

            local Button =
                Instance.new("TextButton")

            Button.Size =
                UDim2.new(1, 0, 0, 42)

            Button.BackgroundTransparency = 1

            Button.Text = ""

            Button.AutoButtonColor = false

            Button.Parent = Holder

            local Label =
                Instance.new("TextLabel")

            Label.Position =
                UDim2.fromOffset(12, 0)

            Label.Size =
                UDim2.new(
                    0.5,
                    0,
                    1,
                    0
                )

            Label.BackgroundTransparency = 1

            Label.Text =
                Data.Name
                or "Dropdown"

            Label.TextColor3 =
                Library.Theme.Text

            Label.TextSize = 9
            Label.Font = Enum.Font.GothamMedium

            Label.TextXAlignment =
                Enum.TextXAlignment.Left

            Label.Parent = Button

            local CurrentLabel =
                Instance.new("TextLabel")

            CurrentLabel.Position =
                UDim2.new(
                    0.5,
                    0,
                    0,
                    0
                )

            CurrentLabel.Size =
                UDim2.new(
                    0.5,
                    -28,
                    1,
                    0
                )

            CurrentLabel.BackgroundTransparency = 1

            CurrentLabel.Text =
                tostring(Current or "")

            CurrentLabel.TextColor3 =
                Library.Theme.Accent

            CurrentLabel.TextSize = 8
            CurrentLabel.Font = Enum.Font.GothamBold

            CurrentLabel.TextXAlignment =
                Enum.TextXAlignment.Right

            CurrentLabel.Parent = Button

            RegisterAccent(
                CurrentLabel,
                "TextColor3"
            )

            local Arrow =
                Instance.new("TextLabel")

            Arrow.Position =
                UDim2.new(
                    1,
                    -25,
                    0,
                    0
                )

            Arrow.Size =
                UDim2.fromOffset(
                    18,
                    42
                )

            Arrow.BackgroundTransparency = 1

            Arrow.Text = "⌄"

            Arrow.TextColor3 =
                Library.Theme.SubText

            Arrow.TextSize = 11
            Arrow.Font = Enum.Font.GothamBold

            Arrow.Parent = Button

            local List =
                Instance.new("Frame")

            List.Position =
                UDim2.fromOffset(
                    8,
                    45
                )

            List.Size =
                UDim2.new(
                    1,
                    -16,
                    0,
                    0
                )

            List.BackgroundTransparency = 1
            List.Parent = Holder

            local ListLayout =
                Instance.new("UIListLayout")

            ListLayout.Padding =
                UDim.new(0, 3)

            ListLayout.Parent = List

            local Open = false

            local function Rebuild()

                for _, Child in ipairs(
                    List:GetChildren()
                ) do

                    if Child:IsA(
                        "TextButton"
                    ) then
                        Child:Destroy()
                    end

                end

                for _, Option in ipairs(
                    Options
                ) do

                    local OptionButton =
                        Instance.new(
                            "TextButton"
                        )

                    OptionButton.Size =
                        UDim2.new(
                            1,
                            0,
                            0,
                            28
                        )

                    OptionButton.BackgroundColor3 =
                        Library.Theme.Background

                    OptionButton.Text =
                        tostring(Option)

                    OptionButton.TextColor3 =
                        Library.Theme.Text

                    OptionButton.TextSize = 8
                    OptionButton.Font =
                        Enum.Font.Gotham

                    OptionButton.BorderSizePixel = 0
                    OptionButton.AutoButtonColor = false

                    OptionButton.Parent = List

                    Corner(
                        OptionButton,
                        8
                    )

                    OptionButton.MouseEnter:Connect(
                        function()

                            Tween(
                                OptionButton,
                                {
                                    BackgroundColor3 =
                                        Library.Theme.Accent:Lerp(
                                            Color3.new(
                                                1,
                                                1,
                                                1
                                            ),
                                            0.9
                                        )
                                },
                                0.1
                            )

                        end
                    )

                    OptionButton.MouseLeave:Connect(
                        function()

                            Tween(
                                OptionButton,
                                {
                                    BackgroundColor3 =
                                        Library.Theme.Background
                                },
                                0.1
                            )

                        end
                    )

                    OptionButton.MouseButton1Click:Connect(
                        function()

                            Current = Option

                            CurrentLabel.Text =
                                tostring(Current)

                            if Data.Callback then
                                Data.Callback(
                                    Current
                                )
                            end

                            Open = false

                            Arrow.Text = "⌄"

                            Tween(
                                Holder,
                                {
                                    Size =
                                        UDim2.new(
                                            1,
                                            0,
                                            0,
                                            42
                                        )
                                },
                                0.2
                            )

                        end
                    )

                end
            end

            Button.MouseButton1Click:Connect(
                function()

                    Open = not Open

                    if Open then

                        Rebuild()

                        local Height =
                            math.min(
                                #Options * 31
                                    + 51,
                                185
                            )

                        Arrow.Text = "⌃"

                        Tween(
                            Holder,
                            {
                                Size =
                                    UDim2.new(
                                        1,
                                        0,
                                        0,
                                        Height
                                    )
                            },
                            0.2
                        )

                    else

                        Arrow.Text = "⌄"

                        Tween(
                            Holder,
                            {
                                Size =
                                    UDim2.new(
                                        1,
                                        0,
                                        0,
                                        42
                                    )
                            },
                            0.2
                        )

                    end
                end
            )

            return {

                Set = function(_, Value)

                    Current = Value

                    CurrentLabel.Text =
                        tostring(Value)

                    if Data.Callback then
                        Data.Callback(Value)
                    end

                end,

                Refresh = function(
                    _,
                    NewOptions
                )

                    Options =
                        NewOptions
                        or {}

                    Rebuild()

                end,

                Get = function()
                    return Current
                end

            }
        end

        --================================================
        -- INPUT
        --================================================

        function TabObject:CreateInput(Data)

            Data = Data or {}

            local Holder =
                Instance.new("Frame")

            Holder.Size =
                UDim2.new(1, 0, 0, 45)

            Holder.BackgroundColor3 =
                Library.Theme.Card

            Holder.BorderSizePixel = 0

            Holder.Parent = Page

            Corner(Holder, 11)
            Stroke(Holder)

            local Box =
                Instance.new("TextBox")

            Box.Position =
                UDim2.fromOffset(10, 7)

            Box.Size =
                UDim2.new(
                    1,
                    -20,
                    1,
                    -14
                )

            Box.BackgroundColor3 =
                Library.Theme.Background

            Box.PlaceholderText =
                Data.PlaceholderText
                or "พิมพ์ข้อความ..."

            Box.PlaceholderColor3 =
                Library.Theme.SubText

            Box.Text =
                Data.CurrentValue
                or ""

            Box.TextColor3 =
                Library.Theme.Text

            Box.TextSize = 9
            Box.Font = Enum.Font.Gotham

            Box.ClearTextOnFocus = false
            Box.BorderSizePixel = 0

            Box.Parent = Holder

            Corner(Box, 9)

            Box.Focused:Connect(
                function()

                    Tween(
                        Box,
                        {
                            BackgroundColor3 =
                                Library.Theme.Accent:Lerp(
                                    Color3.new(
                                        1,
                                        1,
                                        1
                                    ),
                                    0.92
                                )
                        },
                        0.15
                    )

                end
            )

            Box.FocusLost:Connect(
                function()

                    Tween(
                        Box,
                        {
                            BackgroundColor3 =
                                Library.Theme.Background
                        },
                        0.15
                    )

                    if Data.Callback then
                        Data.Callback(
                            Box.Text
                        )
                    end

                end
            )

            return {

                Set = function(_, Value)
                    Box.Text =
                        tostring(Value)
                end,

                Get = function()
                    return Box.Text
                end

            }
        end

        --================================================
        -- DIVIDER
        --================================================

        function TabObject:CreateDivider()

            local Divider =
                Instance.new("Frame")

            Divider.Size =
                UDim2.new(1, 0, 0, 1)

            Divider.BackgroundColor3 =
                Library.Theme.Border

            Divider.BorderSizePixel = 0

            Divider.Parent = Page

            return Divider
        end

        --================================================
        -- COLOR PICKER
        --================================================

        function TabObject:CreateColorPicker(Data)

            Data = Data or {}

            local Current =
                Data.Color
                or Library.Theme.Accent

            local Button =
                Instance.new("TextButton")

            Button.Size =
                UDim2.new(1, 0, 0, 42)

            Button.BackgroundColor3 =
                Library.Theme.Card

            Button.Text = ""

            Button.BorderSizePixel = 0

            Button.AutoButtonColor = false

            Button.Parent = Page

            Corner(Button, 11)
            Stroke(Button)

            local Label =
                Instance.new("TextLabel")

            Label.Position =
                UDim2.fromOffset(12, 0)

            Label.Size =
                UDim2.new(
                    1,
                    -55,
                    1,
                    0
                )

            Label.BackgroundTransparency = 1

            Label.Text =
                Data.Name
                or "Color"

            Label.TextColor3 =
                Library.Theme.Text

            Label.TextSize = 9
            Label.Font = Enum.Font.GothamMedium

            Label.TextXAlignment =
                Enum.TextXAlignment.Left

            Label.Parent = Button

            local Preview =
                Instance.new("Frame")

            Preview.Size =
                UDim2.fromOffset(
                    28,
                    28
                )

            Preview.Position =
                UDim2.new(
                    1,
                    -39,
                    0.5,
                    -14
                )

            Preview.BackgroundColor3 =
                Current

            Preview.BorderSizePixel = 0

            Preview.Parent = Button

            Corner(Preview, 9)

            local Colors = {

                Color3.fromRGB(
                    126,
                    92,
                    255
                ),

                Color3.fromRGB(
                    90,
                    100,
                    255
                ),

                Color3.fromRGB(
                    0,
                    170,
                    255
                ),

                Color3.fromRGB(
                    0,
                    190,
                    130
                ),

                Color3.fromRGB(
                    255,
                    170,
                    40
                ),

                Color3.fromRGB(
                    255,
                    80,
                    120
                ),

                Color3.fromRGB(
                    190,
                    70,
                    255
                ),

                Color3.fromRGB(
                    40,
                    40,
                    50
                ),

            }

            Button.MouseButton1Click:Connect(
                function()

                    local Popup =
                        Instance.new("Frame")

                    Popup.AnchorPoint =
                        Vector2.new(
                            0.5,
                            0.5
                        )

                    Popup.Position =
                        UDim2.fromScale(
                            0.5,
                            0.5
                        )

                    Popup.Size =
                        UDim2.fromOffset(
                            230,
                            165
                        )

                    Popup.BackgroundColor3 =
                        Library.Theme.Card

                    Popup.BorderSizePixel = 0

                    Popup.ZIndex = 100

                    Popup.Parent = GUI

                    Corner(Popup, 16)
                    Stroke(Popup)
                    AddShadow(Popup)

                    local Title =
                        Instance.new(
                            "TextLabel"
                        )

                    Title.Position =
                        UDim2.fromOffset(
                            13,
                            9
                        )

                    Title.Size =
                        UDim2.new(
                            1,
                            -50,
                            0,
                            20
                        )

                    Title.BackgroundTransparency = 1

                    Title.Text =
                        "เลือกสีหลัก"

                    Title.TextColor3 =
                        Library.Theme.Text

                    Title.TextSize = 10
                    Title.Font =
                        Enum.Font.GothamBold

                    Title.TextXAlignment =
                        Enum.TextXAlignment.Left

                    Title.ZIndex = 101

                    Title.Parent = Popup

                    local Close =
                        Instance.new(
                            "TextButton"
                        )

                    Close.Size =
                        UDim2.fromOffset(
                            26,
                            26
                        )

                    Close.Position =
                        UDim2.new(
                            1,
                            -34,
                            0,
                            7
                        )

                    Close.BackgroundColor3 =
                        Library.Theme.Background

                    Close.Text = "×"

                    Close.TextColor3 =
                        Library.Theme.Text

                    Close.TextSize = 13
                    Close.Font =
                        Enum.Font.GothamBold

                    Close.BorderSizePixel = 0

                    Close.ZIndex = 101
                    Close.Parent = Popup

                    Corner(Close, 8)

                    Close.MouseButton1Click:Connect(
                        function()
                            Popup:Destroy()
                        end
                    )

                    for Index, Color in ipairs(
                        Colors
                    ) do

                        local X =
                            (Index - 1) % 4

                        local Y =
                            math.floor(
                                (Index - 1) / 4
                            )

                        local ColorButton =
                            Instance.new(
                                "TextButton"
                            )

                        ColorButton.Size =
                            UDim2.fromOffset(
                                40,
                                40
                            )

                        ColorButton.Position =
                            UDim2.fromOffset(
                                14
                                    + X * 49,
                                43
                                    + Y * 45
                            )

                        ColorButton.BackgroundColor3 =
                            Color

                        ColorButton.Text = ""

                        ColorButton.BorderSizePixel = 0

                        ColorButton.ZIndex = 101

                        ColorButton.Parent = Popup

                        Corner(
                            ColorButton,
                            10
                        )

                        ColorButton.MouseButton1Click:Connect(
                            function()

                                Current = Color

                                Preview.BackgroundColor3 =
                                    Color

                                Library:SetThemeColor(
                                    Color
                                )

                                if Data.Callback then
                                    Data.Callback(
                                        Color
                                    )
                                end

                                Popup:Destroy()

                            end
                        )

                    end

                end
            )

            return {

                Set = function(_, Color)

                    if typeof(Color)
                        ~= "Color3"
                    then
                        return
                    end

                    Current = Color

                    Preview.BackgroundColor3 =
                        Color

                    Library:SetThemeColor(
                        Color
                    )

                end,

                Get = function()
                    return Current
                end

            }
        end

        --================================================
        -- FIRST TAB
        --================================================

        if FirstTab then

            FirstTab = false

            task.defer(function()
                Select()
            end)

        end

        return TabObject
    end

    --====================================================
    -- WINDOW METHODS
    --====================================================

    function WindowObject:SetSize(Size)

        if typeof(Size) ~= "UDim2" then
            return
        end

        Tween(
            Main,
            {
                Size = Size
            },
            0.25
        )

    end

    function WindowObject:SetPosition(Position)

        if typeof(Position) ~= "UDim2" then
            return
        end

        Tween(
            Main,
            {
                Position = Position
            },
            0.25
        )

    end

    function WindowObject:Minimize()

        Main.Visible = false
        Floating.Visible = true

    end

    function WindowObject:Restore()

        Floating.Visible = false
        Main.Visible = true

    end

    function WindowObject:Destroy()

        if GUI then
            GUI:Destroy()
        end

    end

    return WindowObject
end

--========================================================
-- LOADING
--========================================================

if Library.Config.LoadingScreen then

    task.spawn(
        LoadingScreen
    )

end

--========================================================
-- EXAMPLE
--========================================================

local Window =
    Library:CreateWindow({

        Name = "PEPE HUB",
        Version = "V6.0"

    })

--========================================================
-- MAIN TAB
--========================================================

local Main =
    Window:CreateTab({

        Name = "หน้าหลัก",
        Icon = "⌂"

    })

Main:CreateSection(
    "Dashboard"
)

Main:CreateParagraph({

    Title = "PEPE UI V6",

    Content =
        "UI รุ่นใหม่ รองรับ PC และ Mobile พร้อมระบบ Animation และ Responsive Layout"

})

Main:CreateToggle({

    Name = "เปิดระบบตัวอย่าง",

    CurrentValue = false,

    Callback = function(Value)

        print(
            "Toggle:",
            Value
        )

    end

})

Main:CreateButton({

    Name = "ทดสอบ Notification",

    Callback = function()

        Library:Notify({

            Title = "สำเร็จ",

            Content =
                "PEPE UI V6 ทำงานเรียบร้อยแล้ว",

            Duration = 3

        })

    end

})

Main:CreateSlider({

    Name = "ความเร็ว",

    Range = {
        1,
        100
    },

    Increment = 1,

    CurrentValue = 50,

    Callback = function(Value)

        print(
            "Speed:",
            Value
        )

    end

})

Main:CreateDropdown({

    Name = "โหมด",

    Options = {

        "Normal",
        "Fast",
        "Extreme"

    },

    CurrentOption = "Normal",

    Callback = function(Value)

        print(
            "Mode:",
            Value
        )

    end

})

--========================================================
-- SETTINGS
--========================================================

local Settings =
    Window:CreateTab({

        Name = "ตั้งค่า",
        Icon = "⚙"

    })

Settings:CreateSection(
    "Appearance"
)

Settings:CreateColorPicker({

    Name = "สีหลัก",

    Color =
        Color3.fromRGB(
            126,
            92,
            255
        ),

    Callback = function(Color)

        print(
            "Color changed:",
            Color
        )

    end

})

Settings:CreateInput({

    Name = "ชื่อ",

    PlaceholderText =
        "ใส่ชื่อ...",

    Callback = function(Text)

        print(
            "Input:",
            Text
        )

    end

})

Settings:CreateDivider()

Settings:CreateParagraph({

    Title = "เกี่ยวกับ",

    Content =
        "PEPE UI V6 • Modern White / Purple • Mobile Friendly"

})

return Library