--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║              NAEI HUB UI LIBRARY V2                         ║
    ║          BRIGHT PREMIUM GLASS + GLOW EDITION                ║
    ║                                                              ║
    ║  Features:                                                   ║
    ║  • Premium Loading Screen                                    ║
    ║  • Animated Glow Border                                      ║
    ║  • Progress Loading                                          ║
    ║  • Glass / Bright UI                                         ║
    ║  • Responsive Mobile / PC                                    ║
    ║  • Tabs                                                      ║
    ║  • Collapsible Sections                                      ║
    ║  • Buttons                                                    ║
    ║  • Toggles                                                    ║
    ║  • Textboxes                                                  ║
    ║  • Notifications                                              ║
    ║  • Minimize                                                   ║
    ║  • Close                                                      ║
    ║  • Drag                                                       ║
    ║  • RightShift Toggle                                         ║
    ╚══════════════════════════════════════════════════════════════╝
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}

----------------------------------------------------------------
-- THEME
----------------------------------------------------------------

Library.Theme = {

    Background = Color3.fromRGB(244, 246, 251),

    Surface = Color3.fromRGB(255, 255, 255),

    Surface2 = Color3.fromRGB(239, 242, 248),

    SurfaceHover = Color3.fromRGB(228, 233, 243),

    Border = Color3.fromRGB(204, 211, 228),

    BorderSubtle = Color3.fromRGB(220, 225, 237),

    Accent = Color3.fromRGB(99, 102, 241),

    Accent2 = Color3.fromRGB(139, 92, 246),

    AccentGlow = Color3.fromRGB(129, 140, 248),

    Text = Color3.fromRGB(28, 32, 43),

    Muted = Color3.fromRGB(108, 117, 138),

    Success = Color3.fromRGB(34, 197, 94),

    Danger = Color3.fromRGB(239, 68, 68),

    Warning = Color3.fromRGB(245, 158, 11),

    Shadow = Color3.fromRGB(125, 135, 160),

}

----------------------------------------------------------------
-- SETTINGS
----------------------------------------------------------------

Library.Settings = {

    LoadingEnabled = true,

    LoadingDuration = 2.8,

    LoadingTitle = "NAEI HUB",

    LoadingSubtitle = "Premium Interface",

    LoadingText = "กำลังเตรียมระบบ...",

}

----------------------------------------------------------------
-- INTERNAL
----------------------------------------------------------------

Library._MainScreenGui = nil
Library._LoadingFinished = false

----------------------------------------------------------------
-- UTILITIES
----------------------------------------------------------------

local function tween(object, properties, duration, style, direction)

    pcall(function()

        local info = TweenInfo.new(

            duration or 0.25,

            style or Enum.EasingStyle.Quart,

            direction or Enum.EasingDirection.Out

        )

        TweenService:Create(

            object,

            info,

            properties

        ):Play()

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

    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    s.Parent = object

    return s

end

local function label(parent, text, size, color, font)

    local l = Instance.new("TextLabel")

    l.BackgroundTransparency = 1

    l.Text = text or ""

    l.TextColor3 = color or Library.Theme.Text

    l.TextSize = size or 12

    l.Font = font or Enum.Font.GothamMedium

    l.TextXAlignment = Enum.TextXAlignment.Left

    l.TextYAlignment = Enum.TextYAlignment.Center

    l.Parent = parent

    return l

end

local function createGradient(object)

    local gradient = Instance.new("UIGradient")

    gradient.Color = ColorSequence.new({

        ColorSequenceKeypoint.new(

            0,

            Library.Theme.Accent

        ),

        ColorSequenceKeypoint.new(

            0.5,

            Library.Theme.Accent2

        ),

        ColorSequenceKeypoint.new(

            1,

            Library.Theme.AccentGlow

        )

    })

    gradient.Rotation = 0

    gradient.Parent = object

    return gradient

end

----------------------------------------------------------------
-- THEME
----------------------------------------------------------------

function Library:SetTheme(newTheme)

    for key, color in pairs(newTheme) do

        if self.Theme[key] then

            self.Theme[key] = color

        end

    end

    if self._MainScreenGui then

        self._MainScreenGui:Destroy()

        self._MainScreenGui = nil

    end

end

----------------------------------------------------------------
-- LOADING SCREEN
----------------------------------------------------------------

function Library:CreateLoadingScreen(ScreenGui, onFinished)

    local LoadingRoot = Instance.new("Frame")

    LoadingRoot.Name = "PremiumLoading"

    LoadingRoot.Size = UDim2.fromScale(1, 1)

    LoadingRoot.BackgroundColor3 = Color3.fromRGB(244, 246, 251)

    LoadingRoot.BorderSizePixel = 0

    LoadingRoot.ZIndex = 1000

    LoadingRoot.Parent = ScreenGui

    ------------------------------------------------------------
    -- BACKGROUND GRADIENT
    ------------------------------------------------------------

    local BackgroundGradient = Instance.new("UIGradient")

    BackgroundGradient.Color = ColorSequence.new({

        ColorSequenceKeypoint.new(

            0,

            Color3.fromRGB(250, 251, 255)

        ),

        ColorSequenceKeypoint.new(

            0.5,

            Color3.fromRGB(244, 246, 251)

        ),

        ColorSequenceKeypoint.new(

            1,

            Color3.fromRGB(236, 240, 249)

        )

    })

    BackgroundGradient.Rotation = 35

    BackgroundGradient.Parent = LoadingRoot

    ------------------------------------------------------------
    -- DECORATIVE CIRCLES
    ------------------------------------------------------------

    local function createCircle(size, position, transparency)

        local circle = Instance.new("Frame")

        circle.Size = UDim2.fromOffset(size, size)

        circle.Position = position

        circle.BackgroundColor3 = Library.Theme.Accent

        circle.BackgroundTransparency = transparency

        circle.BorderSizePixel = 0

        circle.ZIndex = 1001

        circle.Parent = LoadingRoot

        corner(circle, size / 2)

        return circle

    end

    local Circle1 = createCircle(

        260,

        UDim2.new(-0.12, 0, -0.15, 0),

        0.92

    )

    local Circle2 = createCircle(

        320,

        UDim2.new(0.78, 0, 0.72, 0),

        0.94

    )

    local Circle3 = createCircle(

        150,

        UDim2.new(0.78, 0, 0.05, 0),

        0.95

    )

    task.spawn(function()

        while LoadingRoot.Parent do

            tween(

                Circle1,

                {

                    Position = UDim2.new(

                        -0.10,

                        0,

                        -0.13,

                        0

                    )

                },

                2

            )

            task.wait(2)

            tween(

                Circle1,

                {

                    Position = UDim2.new(

                        -0.12,

                        0,

                        -0.15,

                        0

                    )

                },

                2

            )

            task.wait(2)

        end

    end)

    ------------------------------------------------------------
    -- CENTER CARD
    ------------------------------------------------------------

    local Card = Instance.new("Frame")

    Card.AnchorPoint = Vector2.new(0.5, 0.5)

    Card.Position = UDim2.fromScale(0.5, 0.5)

    Card.Size = UDim2.fromOffset(390, 300)

    Card.BackgroundColor3 = Library.Theme.Surface

    Card.BackgroundTransparency = 0.05

    Card.BorderSizePixel = 0

    Card.ZIndex = 1005

    Card.Parent = LoadingRoot

    corner(Card, 30)

    stroke(

        Card,

        Library.Theme.Border,

        1,

        0.25

    )

    ------------------------------------------------------------
    -- CARD SHADOW
    ------------------------------------------------------------

    local Shadow = Instance.new("ImageLabel")

    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)

    Shadow.Position = UDim2.new(0.5, 0, 0.5, 12)

    Shadow.Size = UDim2.new(1, 70, 1, 70)

    Shadow.BackgroundTransparency = 1

    Shadow.Image = "rbxassetid://6014261993"

    Shadow.ImageColor3 = Library.Theme.Shadow

    Shadow.ImageTransparency = 0.72

    Shadow.ScaleType = Enum.ScaleType.Slice

    Shadow.SliceCenter = Rect.new(

        49,

        49,

        450,

        450

    )

    Shadow.ZIndex = 1004

    Shadow.Parent = Card

    ------------------------------------------------------------
    -- LOGO
    ------------------------------------------------------------

    local Logo = Instance.new("Frame")

    Logo.AnchorPoint = Vector2.new(0.5, 0)

    Logo.Position = UDim2.new(0.5, 0, 0, 32)

    Logo.Size = UDim2.fromOffset(72, 72)

    Logo.BackgroundColor3 = Library.Theme.Accent

    Logo.BorderSizePixel = 0

    Logo.ZIndex = 1007

    Logo.Parent = Card

    corner(Logo, 22)

    createGradient(Logo)

    local LogoStroke = stroke(

        Logo,

        Library.Theme.AccentGlow,

        2,

        0

    )

    local LogoText = label(

        Logo,

        "N",

        32,

        Color3.new(1, 1, 1),

        Enum.Font.GothamBlack

    )

    LogoText.Size = UDim2.fromScale(1, 1)

    LogoText.TextXAlignment = Enum.TextXAlignment.Center

    LogoText.TextYAlignment = Enum.TextYAlignment.Center

    LogoText.ZIndex = 1008

    ------------------------------------------------------------
    -- TITLE
    ------------------------------------------------------------

    local Title = label(

        Card,

        Library.Settings.LoadingTitle,

        20,

        Library.Theme.Text,

        Enum.Font.GothamBlack

    )

    Title.AnchorPoint = Vector2.new(0.5, 0)

    Title.Position = UDim2.new(0.5, 0, 0, 118)

    Title.Size = UDim2.fromOffset(300, 28)

    Title.TextXAlignment = Enum.TextXAlignment.Center

    Title.ZIndex = 1007

    ------------------------------------------------------------
    -- SUBTITLE
    ------------------------------------------------------------

    local Subtitle = label(

        Card,

        Library.Settings.LoadingSubtitle,

        11,

        Library.Theme.Muted,

        Enum.Font.Gotham

    )

    Subtitle.AnchorPoint = Vector2.new(0.5, 0)

    Subtitle.Position = UDim2.new(0.5, 0, 0, 147)

    Subtitle.Size = UDim2.fromOffset(300, 20)

    Subtitle.TextXAlignment = Enum.TextXAlignment.Center

    Subtitle.ZIndex = 1007

    ------------------------------------------------------------
    -- STATUS
    ------------------------------------------------------------

    local Status = label(

        Card,

        Library.Settings.LoadingText,

        11,

        Library.Theme.Muted,

        Enum.Font.GothamMedium

    )

    Status.AnchorPoint = Vector2.new(0.5, 0)

    Status.Position = UDim2.new(0.5, 0, 0, 183)

    Status.Size = UDim2.fromOffset(320, 20)

    Status.TextXAlignment = Enum.TextXAlignment.Center

    Status.ZIndex = 1007

    ------------------------------------------------------------
    -- PROGRESS BACKGROUND
    ------------------------------------------------------------

    local ProgressBackground = Instance.new("Frame")

    ProgressBackground.AnchorPoint = Vector2.new(0.5, 0)

    ProgressBackground.Position = UDim2.new(0.5, 0, 0, 218)

    ProgressBackground.Size = UDim2.fromOffset(290, 8)

    ProgressBackground.BackgroundColor3 = Library.Theme.Surface2

    ProgressBackground.BorderSizePixel = 0

    ProgressBackground.ZIndex = 1007

    ProgressBackground.Parent = Card

    corner(ProgressBackground, 5)

    stroke(

        ProgressBackground,

        Library.Theme.BorderSubtle,

        1,

        0.5

    )

    ------------------------------------------------------------
    -- PROGRESS
    ------------------------------------------------------------

    local Progress = Instance.new("Frame")

    Progress.Size = UDim2.new(0, 0, 1, 0)

    Progress.BackgroundColor3 = Library.Theme.Accent

    Progress.BorderSizePixel = 0

    Progress.ZIndex = 1008

    Progress.Parent = ProgressBackground

    corner(Progress, 5)

    createGradient(Progress)

    ------------------------------------------------------------
    -- PERCENT
    ------------------------------------------------------------

    local Percent = label(

        Card,

        "0%",

        10,

        Library.Theme.Muted,

        Enum.Font.GothamBold

    )

    Percent.AnchorPoint = Vector2.new(0.5, 0)

    Percent.Position = UDim2.new(0.5, 0, 0, 235)

    Percent.Size = UDim2.fromOffset(100, 18)

    Percent.TextXAlignment = Enum.TextXAlignment.Center

    Percent.ZIndex = 1007

    ------------------------------------------------------------
    -- LOADING DOTS
    ------------------------------------------------------------

    local DotContainer = Instance.new("Frame")

    DotContainer.AnchorPoint = Vector2.new(0.5, 0)

    DotContainer.Position = UDim2.new(0.5, 0, 0, 260)

    DotContainer.Size = UDim2.fromOffset(80, 16)

    DotContainer.BackgroundTransparency = 1

    DotContainer.ZIndex = 1007

    DotContainer.Parent = Card

    local dots = {}

    for i = 1, 3 do

        local dot = Instance.new("Frame")

        dot.Size = UDim2.fromOffset(6, 6)

        dot.Position = UDim2.new(

            0,

            (i - 1) * 20 + 19,

            0.5,

            -3

        )

        dot.BackgroundColor3 = Library.Theme.Accent

        dot.BorderSizePixel = 0

        dot.ZIndex = 1008

        dot.Parent = DotContainer

        corner(dot, 3)

        dots[i] = dot

    end

    task.spawn(function()

        local index = 1

        while LoadingRoot.Parent do

            for i, dot in ipairs(dots) do

                tween(

                    dot,

                    {

                        Size = i == index

                            and UDim2.fromOffset(9, 9)

                            or UDim2.fromOffset(6, 6)

                    },

                    0.2

                )

            end

            index = index + 1

            if index > #dots then

                index = 1

            end

            task.wait(0.22)

        end

    end)

    ------------------------------------------------------------
    -- LOGO ROTATION
    ------------------------------------------------------------

    task.spawn(function()

        while Logo.Parent do

            tween(

                Logo,

                {

                    Rotation = 5

                },

                0.8,

                Enum.EasingStyle.Sine

            )

            task.wait(0.8)

            tween(

                Logo,

                {

                    Rotation = -5

                },

                0.8,

                Enum.EasingStyle.Sine

            )

            task.wait(0.8)

        end

    end)

    ------------------------------------------------------------
    -- LOADING PROCESS
    ------------------------------------------------------------

    task.spawn(function()

        local duration = Library.Settings.LoadingDuration

        local startTime = os.clock()

        local messages = {

            "กำลังเริ่มระบบ...",

            "กำลังสร้างอินเทอร์เฟซ...",

            "กำลังโหลดส่วนประกอบ...",

            "กำลังเตรียมระบบ...",

            "เกือบเสร็จแล้ว..."

        }

        local messageIndex = 1

        while true do

            local elapsed = os.clock() - startTime

            local alpha = math.clamp(

                elapsed / duration,

                0,

                1

            )

            local percent = math.floor(alpha * 100)

            Progress.Size = UDim2.new(

                alpha,

                0,

                1,

                0

            )

            Percent.Text = tostring(percent) .. "%"

            local newIndex = math.clamp(

                math.floor(alpha * #messages) + 1,

                1,

                #messages

            )

            if newIndex ~= messageIndex then

                messageIndex = newIndex

                tween(

                    Status,

                    {

                        TextTransparency = 1

                    },

                    0.12

                )

                task.wait(0.12)

                Status.Text = messages[messageIndex]

                tween(

                    Status,

                    {

                        TextTransparency = 0

                    },

                    0.15

                )

            end

            if alpha >= 1 then

                break

            end

            RunService.RenderStepped:Wait()

        end

        Progress.Size = UDim2.new(1, 0, 1, 0)

        Percent.Text = "100%"

        Status.Text = "พร้อมใช้งาน"

        task.wait(0.35)

        --------------------------------------------------------
        -- FADE OUT
        --------------------------------------------------------

        tween(

            Card,

            {

                BackgroundTransparency = 1,

                Position = UDim2.new(

                    0.5,

                    0,

                    0.48,

                    0

                )

            },

            0.45

        )

        tween(

            Logo,

            {

                BackgroundTransparency = 1

            },

            0.35

        )

        tween(

            LogoText,

            {

                TextTransparency = 1

            },

            0.3

        )

        tween(

            Title,

            {

                TextTransparency = 1

            },

            0.3

        )

        tween(

            Subtitle,

            {

                TextTransparency = 1

            },

            0.3

        )

        tween(

            Status,

            {

                TextTransparency = 1

            },

            0.3

        )

        tween(

            Percent,

            {

                TextTransparency = 1

            },

            0.3

        )

        tween(

            DotContainer,

            {

                BackgroundTransparency = 1

            },

            0.3

        )

        tween(

            ProgressBackground,

            {

                BackgroundTransparency = 1

            },

            0.3

        )

        task.wait(0.5)

        LoadingRoot:Destroy()

        Library._LoadingFinished = true

        if onFinished then

            pcall(onFinished)

        end

    end)

end

----------------------------------------------------------------
-- NOTIFICATION
----------------------------------------------------------------

function Library:SendNotification(titleText, descText, duration)

    duration = duration or 3

    if not self._NotificationHolder then

        return

    end

    local card = Instance.new("Frame")

    card.Size = UDim2.new(1, 0, 0, 72)

    card.BackgroundColor3 = Library.Theme.Surface

    card.BackgroundTransparency = 1

    card.BorderSizePixel = 0

    card.Parent = self._NotificationHolder

    corner(card, 18)

    stroke(

        card,

        Library.Theme.Border,

        1,

        0.25

    )

    ------------------------------------------------------------
    -- Accent
    ------------------------------------------------------------

    local AccentLine = Instance.new("Frame")

    AccentLine.Size = UDim2.new(0, 4, 0.6, 0)

    AccentLine.Position = UDim2.new(0, 0, 0.2, 0)

    AccentLine.BackgroundColor3 = Library.Theme.Accent

    AccentLine.BorderSizePixel = 0

    AccentLine.Parent = card

    corner(AccentLine, 3)

    createGradient(AccentLine)

    ------------------------------------------------------------
    -- TITLE
    ------------------------------------------------------------

    local Title = label(

        card,

        titleText or "Notification",

        13,

        Library.Theme.Text,

        Enum.Font.GothamBold

    )

    Title.Size = UDim2.new(1, -30, 0, 20)

    Title.Position = UDim2.new(0, 17, 0, 11)

    ------------------------------------------------------------
    -- DESCRIPTION
    ------------------------------------------------------------

    local Description = label(

        card,

        descText or "",

        11,

        Library.Theme.Muted,

        Enum.Font.Gotham

    )

    Description.Size = UDim2.new(1, -30, 0, 30)

    Description.Position = UDim2.new(0, 17, 0, 31)

    Description.TextWrapped = true

    ------------------------------------------------------------
    -- PROGRESS
    ------------------------------------------------------------

    local Progress = Instance.new("Frame")

    Progress.Size = UDim2.new(1, 0, 0, 2)

    Progress.Position = UDim2.new(0, 0, 1, -2)

    Progress.BackgroundColor3 = Library.Theme.Accent

    Progress.BorderSizePixel = 0

    Progress.Parent = card

    corner(Progress, 2)

    card.Position = UDim2.new(1, 40, 0, 0)

    tween(

        card,

        {

            BackgroundTransparency = 0.04,

            Position = UDim2.new(0, 0, 0, 0)

        },

        0.3

    )

    tween(

        Progress,

        {

            Size = UDim2.new(0, 0, 0, 2)

        },

        duration,

        Enum.EasingStyle.Linear

    )

    task.spawn(function()

        task.wait(duration)

        tween(

            card,

            {

                BackgroundTransparency = 1,

                Position = UDim2.new(1, 40, 0, 0)

            },

            0.3

        )

        task.wait(0.35)

        if card then

            card:Destroy()

        end

    end)

end

----------------------------------------------------------------
-- CREATE WINDOW
----------------------------------------------------------------

function Library:CreateWindow(

    hubTitleText,

    subTitleText

)

    hubTitleText = hubTitleText or "NAEI HUB"

    subTitleText = subTitleText or "Premium Experience"

    ------------------------------------------------------------
    -- REMOVE OLD
    ------------------------------------------------------------

    local old = PlayerGui:FindFirstChild(

        "NaeiUltraWindUI"

    )

    if old then

        pcall(function()

            old:Destroy()

        end)

    end

    ------------------------------------------------------------
    -- SCREEN GUI
    ------------------------------------------------------------

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "NaeiUltraWindUI"

    ScreenGui.ResetOnSpawn = false

    ScreenGui.IgnoreGuiInset = true

    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    ScreenGui.Parent = PlayerGui

    Library._MainScreenGui = ScreenGui

    ------------------------------------------------------------
    -- SCALE
    ------------------------------------------------------------

    local GuiScale = Instance.new("UIScale")

    GuiScale.Scale = 1

    GuiScale.Parent = ScreenGui

    local function updateScale()

        local camera = workspace.CurrentCamera

        if not camera then

            return

        end

        local viewport = camera.ViewportSize

        local widthScale = viewport.X / 700

        local heightScale = viewport.Y / 480

        GuiScale.Scale = math.clamp(

            math.min(widthScale, heightScale),

            0.48,

            1.08

        )

    end

    updateScale()

    if workspace.CurrentCamera then

        workspace.CurrentCamera:GetPropertyChangedSignal(

            "ViewportSize"

        ):Connect(updateScale)

    end

    ------------------------------------------------------------
    -- NOTIFICATION HOLDER
    ------------------------------------------------------------

    local NotifHolder = Instance.new("Frame")

    NotifHolder.Name = "Notifications"

    NotifHolder.AnchorPoint = Vector2.new(1, 1)

    NotifHolder.Position = UDim2.new(

        1,

        -18,

        1,

        -18

    )

    NotifHolder.Size = UDim2.fromOffset(

        290,

        400

    )

    NotifHolder.BackgroundTransparency = 1

    NotifHolder.ZIndex = 500

    NotifHolder.Parent = ScreenGui

    local NotifLayout = Instance.new("UIListLayout")

    NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder

    NotifLayout.Padding = UDim.new(0, 8)

    NotifLayout.Parent = NotifHolder

    Library._NotificationHolder = NotifHolder

    ------------------------------------------------------------
    -- LOADING SCREEN
    ------------------------------------------------------------

    if Library.Settings.LoadingEnabled then

        Library:CreateLoadingScreen(ScreenGui)

    end

    ------------------------------------------------------------
    -- MAIN CONTAINER
    ------------------------------------------------------------

    local GlowContainer = Instance.new("Frame")

    GlowContainer.Name = "GlowContainer"

    GlowContainer.AnchorPoint = Vector2.new(0.5, 0.5)

    GlowContainer.Position = UDim2.fromScale(

        0.5,

        0.5

    )

    GlowContainer.Size = UDim2.fromOffset(

        680,

        460

    )

    GlowContainer.BackgroundTransparency = 1

    GlowContainer.Visible = not Library.Settings.LoadingEnabled

    GlowContainer.ZIndex = 10

    GlowContainer.Parent = ScreenGui

    ------------------------------------------------------------
    -- OUTER GLOW
    ------------------------------------------------------------

    local OuterGlow = Instance.new("Frame")

    OuterGlow.Size = UDim2.new(

        1,

        18,

        1,

        18

    )

    OuterGlow.Position = UDim2.new(

        0,

        -9,

        0,

        -9

    )

    OuterGlow.BackgroundColor3 = Library.Theme.AccentGlow

    OuterGlow.BackgroundTransparency = 0.93

    OuterGlow.BorderSizePixel = 0

    OuterGlow.ZIndex = 9

    OuterGlow.Parent = GlowContainer

    corner(OuterGlow, 32)

    ------------------------------------------------------------
    -- GLOW BORDER
    ------------------------------------------------------------

    local GlowStroke = stroke(

        GlowContainer,

        Library.Theme.AccentGlow,

        2,

        0.05

    )

    corner(

        GlowContainer,

        28

    )

    task.spawn(function()

        local t = 0

        while GlowContainer.Parent do

            local dt = RunService.RenderStepped:Wait()

            t = t + dt * 2.2

            local alpha =

                (math.sin(t) + 1) / 2

            GlowStroke.Transparency =

                0.08 + alpha * 0.62

        end

    end)

    ------------------------------------------------------------
    -- MAIN FRAME
    ------------------------------------------------------------

    local MainFrame = Instance.new("Frame")

    MainFrame.Name = "MainFrame"

    MainFrame.Size = UDim2.fromScale(1, 1)

    MainFrame.BackgroundColor3 = Library.Theme.Background

    MainFrame.BorderSizePixel = 0

    MainFrame.ClipsDescendants = true

    MainFrame.ZIndex = 10

    MainFrame.Parent = GlowContainer

    corner(MainFrame, 25)

    ------------------------------------------------------------
    -- SHADOW
    ------------------------------------------------------------

    local Shadow = Instance.new("ImageLabel")

    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)

    Shadow.Position = UDim2.new(

        0.5,

        0,

        0.5,

        12

    )

    Shadow.Size = UDim2.new(

        1,

        70,

        1,

        70

    )

    Shadow.BackgroundTransparency = 1

    Shadow.Image = "rbxassetid://6014261993"

    Shadow.ImageColor3 = Library.Theme.Shadow

    Shadow.ImageTransparency = 0.6

    Shadow.ScaleType = Enum.ScaleType.Slice

    Shadow.SliceCenter = Rect.new(

        49,

        49,

        450,

        450

    )

    Shadow.ZIndex = 1

    Shadow.Parent = MainFrame

    ------------------------------------------------------------
    -- TOP BAR
    ------------------------------------------------------------

    local TopBar = Instance.new("Frame")

    TopBar.Size = UDim2.new(

        1,

        0,

        0,

        66

    )

    TopBar.BackgroundColor3 = Library.Theme.Surface

    TopBar.BorderSizePixel = 0

    TopBar.ZIndex = 20

    TopBar.Parent = MainFrame

    corner(TopBar, 25)

    local TopBarFix = Instance.new("Frame")

    TopBarFix.Size = UDim2.new(

        1,

        0,

        0,

        22

    )

    TopBarFix.Position = UDim2.new(

        0,

        0,

        1,

        -22

    )

    TopBarFix.BackgroundColor3 = Library.Theme.Surface

    TopBarFix.BorderSizePixel = 0

    TopBarFix.ZIndex = 20

    TopBarFix.Parent = TopBar

    ------------------------------------------------------------
    -- TITLE DOT
    ------------------------------------------------------------

    local TitleDot = Instance.new("Frame")

    TitleDot.Size = UDim2.fromOffset(

        10,

        10

    )

    TitleDot.Position = UDim2.new(

        0,

        20,

        0.5,

        -5

    )

    TitleDot.BackgroundColor3 = Library.Theme.Accent

    TitleDot.BorderSizePixel = 0

    TitleDot.ZIndex = 23

    TitleDot.Parent = TopBar

    corner(TitleDot, 5)

    createGradient(TitleDot)

    ------------------------------------------------------------
    -- TITLE
    ------------------------------------------------------------

    local HubTitle = label(

        TopBar,

        hubTitleText,

        15,

        Library.Theme.Text,

        Enum.Font.GothamBlack

    )

    HubTitle.Size = UDim2.new(

        0,

        250,

        0,

        22

    )

    HubTitle.Position = UDim2.new(

        0,

        38,

        0,

        10

    )

    HubTitle.ZIndex = 23

    ------------------------------------------------------------
    -- SUBTITLE
    ------------------------------------------------------------

    local Subtitle = label(

        TopBar,

        subTitleText,

        10,

        Library.Theme.Muted,

        Enum.Font.Gotham

    )

    Subtitle.Size = UDim2.new(

        0,

        250,

        0,

        17

    )

    Subtitle.Position = UDim2.new(

        0,

        38,

        0,

        33

    )

    Subtitle.ZIndex = 23

    ------------------------------------------------------------
    -- STATUS
    ------------------------------------------------------------

    local StatusDot = Instance.new("Frame")

    StatusDot.Size = UDim2.fromOffset(

        7,

        7

    )

    StatusDot.Position = UDim2.new(

        1,

        -125,

        0.5,

        -3

    )

    StatusDot.BackgroundColor3 = Library.Theme.Success

    StatusDot.BorderSizePixel = 0

    StatusDot.ZIndex = 23

    StatusDot.Parent = TopBar

    corner(StatusDot, 4)

    local StatusText = label(

        TopBar,

        "ONLINE",

        9,

        Library.Theme.Success,

        Enum.Font.GothamBold

    )

    StatusText.Size = UDim2.fromOffset(

        55,

        20

    )

    StatusText.Position = UDim2.new(

        1,

        -113,

        0.5,

        -10

    )

    StatusText.ZIndex = 23

    ------------------------------------------------------------
    -- CONTROL BUTTON
    ------------------------------------------------------------

    local function controlButton(

        text,

        color,

        x

    )

        local b = Instance.new("TextButton")

        b.Size = UDim2.fromOffset(

            32,

            32

        )

        b.Position = UDim2.new(

            1,

            x,

            0.5,

            -16

        )

        b.BackgroundColor3 = Library.Theme.Surface2

        b.Text = text

        b.TextColor3 = Library.Theme.Text

        b.TextSize = 15

        b.Font = Enum.Font.GothamBold

        b.AutoButtonColor = false

        b.BorderSizePixel = 0

        b.ZIndex = 25

        b.Parent = TopBar

        corner(b, 11)

        stroke(

            b,

            Library.Theme.BorderSubtle,

            1,

            0.35

        )

        b.MouseEnter:Connect(function()

            tween(

                b,

                {

                    BackgroundColor3 = color,

                    TextColor3 = Color3.new(

                        1,

                        1,

                        1

                    )

                },

                0.15

            )

        end)

        b.MouseLeave:Connect(function()

            tween(

                b,

                {

                    BackgroundColor3 = Library.Theme.Surface2,

                    TextColor3 = Library.Theme.Text

                },

                0.15

            )

        end)

        return b

    end

    local MinimizeBtn = controlButton(

        "−",

        Library.Theme.Accent,

        -78

    )

    local CloseBtn = controlButton(

        "×",

        Library.Theme.Danger,

        -38

    )

    ------------------------------------------------------------
    -- SIDEBAR
    ------------------------------------------------------------

    local Sidebar = Instance.new("Frame")

    Sidebar.Size = UDim2.new(

        0,

        170,

        1,

        -82

    )

    Sidebar.Position = UDim2.new(

        0,

        12,

        0,

        70

    )

    Sidebar.BackgroundColor3 = Library.Theme.Surface

    Sidebar.BorderSizePixel = 0

    Sidebar.ZIndex = 15

    Sidebar.Parent = MainFrame

    corner(Sidebar, 20)

    stroke(

        Sidebar,

        Library.Theme.BorderSubtle,

        1,

        0.35

    )

    ------------------------------------------------------------
    -- SIDEBAR HEADER
    ------------------------------------------------------------

    local SideHeader = label(

        Sidebar,

        "NAVIGATION",

        9,

        Library.Theme.Muted,

        Enum.Font.GothamBold

    )

    SideHeader.Size = UDim2.new(

        1,

        -24,

        0,

        22

    )

    SideHeader.Position = UDim2.new(

        0,

        12,

        0,

        10

    )

    ------------------------------------------------------------
    -- TAB LIST
    ------------------------------------------------------------

    local TabList = Instance.new("ScrollingFrame")

    TabList.Size = UDim2.new(

        1,

        -12,

        1,

        -42

    )

    TabList.Position = UDim2.new(

        0,

        6,

        0,

        36

    )

    TabList.BackgroundTransparency = 1

    TabList.BorderSizePixel = 0

    TabList.ScrollBarThickness = 0

    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y

    TabList.ZIndex = 17

    TabList.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")

    TabLayout.Padding = UDim.new(

        0,

        7

    )

    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    TabLayout.Parent = TabList

    ------------------------------------------------------------
    -- CONTENT HOLDER
    ------------------------------------------------------------

    local ContainerHolder = Instance.new("Frame")

    ContainerHolder.Size = UDim2.new(

        1,

        -194,

        1,

        -82

    )

    ContainerHolder.Position = UDim2.new(

        0,

        184,

        0,

        70

    )

    ContainerHolder.BackgroundTransparency = 1

    ContainerHolder.ZIndex = 15

    ContainerHolder.Parent = MainFrame

    ------------------------------------------------------------
    -- DATA
    ------------------------------------------------------------

    local Pages = {}

    local TabButtons = {}

    local FirstTab = true

    local WindowObj = {}

    ------------------------------------------------------------
    -- CREATE TAB
    ------------------------------------------------------------

    function WindowObj:CreateTab(

        name,

        iconChar

    )

        iconChar = iconChar or "•"

        --------------------------------------------------------
        -- TAB
        --------------------------------------------------------

        local tab = Instance.new("TextButton")

        tab.Size = UDim2.new(

            1,

            0,

            0,

            44

        )

        tab.BackgroundColor3 = Library.Theme.Surface

        tab.Text = ""

        tab.AutoButtonColor = false

        tab.BorderSizePixel = 0

        tab.ZIndex = 18

        tab.Parent = TabList

        corner(tab, 13)

        --------------------------------------------------------
        -- ACTIVE INDICATOR
        --------------------------------------------------------

        local ActiveLine = Instance.new("Frame")

        ActiveLine.Size = UDim2.new(

            0,

            3,

            0.5,

            0

        )

        ActiveLine.Position = UDim2.new(

            0,

            0,

            0.25,

            0

        )

        ActiveLine.BackgroundColor3 = Library.Theme.Accent

        ActiveLine.BackgroundTransparency = 1

        ActiveLine.BorderSizePixel = 0

        ActiveLine.ZIndex = 20

        ActiveLine.Parent = tab

        corner(ActiveLine, 2)

        --------------------------------------------------------
        -- ICON
        --------------------------------------------------------

        local icon = label(

            tab,

            iconChar,

            13,

            Library.Theme.Muted,

            Enum.Font.GothamBold

        )

        icon.Size = UDim2.fromOffset(

            34,

            44

        )

        icon.Position = UDim2.new(

            0,

            7,

            0,

            0

        )

        icon.TextXAlignment = Enum.TextXAlignment.Center

        icon.ZIndex = 20

        --------------------------------------------------------
        -- TITLE
        --------------------------------------------------------

        local title = label(

            tab,

            name,

            11,

            Library.Theme.Muted,

            Enum.Font.GothamMedium

        )

        title.Size = UDim2.new(

            1,

            -45,

            1,

            0

        )

        title.Position = UDim2.new(

            0,

            42,

            0,

            0

        )

        title.ZIndex = 20

        --------------------------------------------------------
        -- PAGE
        --------------------------------------------------------

        local page = Instance.new("ScrollingFrame")

        page.Size = UDim2.fromScale(

            1,

            1

        )

        page.BackgroundTransparency = 1

        page.BorderSizePixel = 0

        page.ScrollBarThickness = 3

        page.ScrollBarImageColor3 = Library.Theme.Accent

        page.AutomaticCanvasSize = Enum.AutomaticSize.Y

        page.CanvasSize = UDim2.new(

            0,

            0,

            0,

            0

        )

        page.Visible = false

        page.ZIndex = 16

        page.Parent = ContainerHolder

        local layout = Instance.new("UIListLayout")

        layout.Padding = UDim.new(

            0,

            10

        )

        layout.SortOrder = Enum.SortOrder.LayoutOrder

        layout.Parent = page

        local pagePadding = Instance.new("UIPadding")

        pagePadding.PaddingLeft = UDim.new(

            0,

            2

        )

        pagePadding.PaddingRight = UDim.new(

            0,

            8

        )

        pagePadding.PaddingBottom = UDim.new(

            0,

            12

        )

        pagePadding.Parent = page

        --------------------------------------------------------
        -- HOVER
        --------------------------------------------------------

        tab.MouseEnter:Connect(function()

            if tab:GetAttribute("Active") ~= true then

                tween(

                    tab,

                    {

                        BackgroundColor3 = Library.Theme.SurfaceHover

                    },

                    0.15

                )

                tween(

                    icon,

                    {

                        TextColor3 = Library.Theme.Text

                    },

                    0.15

                )

            end

        end)

        tab.MouseLeave:Connect(function()

            if tab:GetAttribute("Active") ~= true then

                tween(

                    tab,

                    {

                        BackgroundColor3 = Library.Theme.Surface

                    },

                    0.15

                )

                tween(

                    icon,

                    {

                        TextColor3 = Library.Theme.Muted

                    },

                    0.15

                )

            end

        end)

        --------------------------------------------------------
        -- SELECT
        --------------------------------------------------------

        tab.MouseButton1Click:Connect(function()

            for _, p in ipairs(Pages) do

                p.Visible = false

            end

            for _, b in ipairs(TabButtons) do

                b:SetAttribute(

                    "Active",

                    false

                )

                tween(

                    b,

                    {

                        BackgroundColor3 = Library.Theme.Surface

                    },

                    0.15

                )

                local childIcon = b:FindFirstChildWhichIsA(

                    "TextLabel"

                )

                if childIcon then

                    tween(

                        childIcon,

                        {

                            TextColor3 = Library.Theme.Muted

                        },

                        0.15

                    )

                end

            end

            page.Visible = true

            tab:SetAttribute(

                "Active",

                true

            )

            tween(

                tab,

                {

                    BackgroundColor3 = Library.Theme.Surface2

                },

                0.15

            )

            tween(

                icon,

                {

                    TextColor3 = Library.Theme.Accent

                },

                0.15

            )

            tween(

                title,

                {

                    TextColor3 = Library.Theme.Text

                },

                0.15

            )

            tween(

                ActiveLine,

                {

                    BackgroundTransparency = 0

                },

                0.15

            )

        end)

        table.insert(

            Pages,

            page

        )

        table.insert(

            TabButtons,

            tab

        )

        --------------------------------------------------------
        -- FIRST TAB
        --------------------------------------------------------

        if FirstTab then

            FirstTab = false

            tab:SetAttribute(

                "Active",

                true

            )

            tab.BackgroundColor3 =

                Library.Theme.Surface2

            icon.TextColor3 =

                Library.Theme.Accent

            title.TextColor3 =

                Library.Theme.Text

            ActiveLine.BackgroundTransparency = 0

            page.Visible = true

        end

        --------------------------------------------------------
        -- TAB OBJECT
        --------------------------------------------------------

        local TabObj = {}

        --------------------------------------------------------
        -- COLLAPSIBLE
        --------------------------------------------------------

        function TabObj:AddCollapsible(

            titleText

        )

            local container = Instance.new("Frame")

            container.Size = UDim2.new(

                1,

                -6,

                0,

                48

            )

            container.BackgroundColor3 =

                Library.Theme.Surface

            container.BorderSizePixel = 0

            container.ClipsDescendants = true

            container.ZIndex = 20

            container.Parent = page

            corner(container, 16)

            stroke(

                container,

                Library.Theme.BorderSubtle,

                1,

                0.35

            )

            ----------------------------------------------------
            -- HEADER
            ----------------------------------------------------

            local header = Instance.new("TextButton")

            header.Size = UDim2.new(

                1,

                0,

                0,

                48

            )

            header.BackgroundTransparency = 1

            header.Text = ""

            header.AutoButtonColor = false

            header.ZIndex = 22

            header.Parent = container

            local headerTitle = label(

                header,

                titleText,

                12,

                Library.Theme.Text,

                Enum.Font.GothamBold

            )

            headerTitle.Size = UDim2.new(

                1,

                -50,

                1,

                0

            )

            headerTitle.Position = UDim2.new(

                0,

                16,

                0,

                0

            )

            headerTitle.ZIndex = 23

            local arrow = label(

                header,

                "⌄",

                15,

                Library.Theme.Muted,

                Enum.Font.GothamBold

            )

            arrow.Size = UDim2.fromOffset(

                28,

                48

            )

            arrow.Position = UDim2.new(

                1,

                -36,

                0,

                0

            )

            arrow.TextXAlignment = Enum.TextXAlignment.Center

            arrow.ZIndex = 23

            ----------------------------------------------------
            -- CONTENT
            ----------------------------------------------------

            local content = Instance.new("Frame")

            content.Size = UDim2.new(

                1,

                0,

                0,

                0

            )

            content.Position = UDim2.new(

                0,

                0,

                0,

                48

            )

            content.BackgroundTransparency = 1

            content.ZIndex = 21

            content.Parent = container

            local contentLayout = Instance.new("UIListLayout")

            contentLayout.Padding = UDim.new(

                0,

                8

            )

            contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

            contentLayout.Parent = content

            local contentPadding = Instance.new("UIPadding")

            contentPadding.PaddingLeft = UDim.new(

                0,

                8

            )

            contentPadding.PaddingRight = UDim.new(

                0,

                8

            )

            contentPadding.PaddingBottom = UDim.new(

                0,

                12

            )

            contentPadding.Parent = content

            local isOpen = false

            local function updateHeight()

                if isOpen then

                    local height =

                        48 +

                        contentLayout.AbsoluteContentSize.Y +

                        12

                    tween(

                        container,

                        {

                            Size = UDim2.new(

                                1,

                                -6,

                                0,

                                height

                            )

                        },

                        0.22

                    )

                end

            end

            contentLayout:GetPropertyChangedSignal(

                "AbsoluteContentSize"

            ):Connect(updateHeight)

            ----------------------------------------------------
            -- HEADER CLICK
            ----------------------------------------------------

            header.MouseButton1Click:Connect(function()

                isOpen = not isOpen

                local height = isOpen

                    and (

                        48 +

                        contentLayout.AbsoluteContentSize.Y +

                        12

                    )

                    or 48

                tween(

                    container,

                    {

                        Size = UDim2.new(

                            1,

                            -6,

                            0,

                            height

                        )

                    },

                    0.25

                )

                tween(

                    arrow,

                    {

                        Rotation = isOpen and 180 or 0

                    },

                    0.25

                )

            end)

            ----------------------------------------------------
            -- SECTION OBJECT
            ----------------------------------------------------

            local SectionObj = {}

            ----------------------------------------------------
            -- BUTTON
            ----------------------------------------------------

            function SectionObj:AddButton(

                textValue,

                callback

            )

                local btn = Instance.new("TextButton")

                btn.Size = UDim2.new(

                    1,

                    0,

                    0,

                    42

                )

                btn.BackgroundColor3 =

                    Library.Theme.Surface2

                btn.Text = ""

                btn.AutoButtonColor = false

                btn.BorderSizePixel = 0

                btn.ZIndex = 24

                btn.Parent = content

                corner(btn, 12)

                stroke(

                    btn,

                    Library.Theme.BorderSubtle,

                    1,

                    0.35

                )

                local txt = label(

                    btn,

                    textValue,

                    11,

                    Library.Theme.Text,

                    Enum.Font.GothamMedium

                )

                txt.Size = UDim2.new(

                    1,

                    -40,

                    1,

                    0

                )

                txt.Position = UDim2.new(

                    0,

                    14,

                    0,

                    0

                )

                txt.ZIndex = 25

                local Arrow = label(

                    btn,

                    "›",

                    16,

                    Library.Theme.Muted,

                    Enum.Font.GothamBold

                )

                Arrow.Size = UDim2.fromOffset(

                    24,

                    42

                )

                Arrow.Position = UDim2.new(

                    1,

                    -28,

                    0,

                    0

                )

                Arrow.TextXAlignment = Enum.TextXAlignment.Center

                Arrow.ZIndex = 25

                btn.MouseEnter:Connect(function()

                    tween(

                        btn,

                        {

                            BackgroundColor3 =

                                Library.Theme.SurfaceHover

                        },

                        0.15

                    )

                    tween(

                        Arrow,

                        {

                            TextColor3 =

                                Library.Theme.Accent

                        },

                        0.15

                    )

                end)

                btn.MouseLeave:Connect(function()

                    tween(

                        btn,

                        {

                            BackgroundColor3 =

                                Library.Theme.Surface2

                        },

                        0.15

                    )

                    tween(

                        Arrow,

                        {

                            TextColor3 =

                                Library.Theme.Muted

                        },

                        0.15

                    )

                end)

                btn.MouseButton1Click:Connect(function()

                    if callback then

                        pcall(callback)

                    end

                end)

                return btn

            end

            ----------------------------------------------------
            -- TOGGLE
            ----------------------------------------------------

            function SectionObj:AddToggle(

                textValue,

                defaultState,

                callback

            )

                local toggled =

                    defaultState == true

                local btn = Instance.new("TextButton")

                btn.Size = UDim2.new(

                    1,

                    0,

                    0,

                    42

                )

                btn.BackgroundColor3 =

                    Library.Theme.Surface2

                btn.Text = ""

                btn.AutoButtonColor = false

                btn.BorderSizePixel = 0

                btn.ZIndex = 24

                btn.Parent = content

                corner(btn, 12)

                stroke(

                    btn,

                    Library.Theme.BorderSubtle,

                    1,

                    0.35

                )

                local txt = label(

                    btn,

                    textValue,

                    11,

                    Library.Theme.Text,

                    Enum.Font.GothamMedium

                )

                txt.Size = UDim2.new(

                    1,

                    -75,

                    1,

                    0

                )

                txt.Position = UDim2.new(

                    0,

                    14,

                    0,

                    0

                )

                ------------------------------------------------
                -- SWITCH
                ------------------------------------------------

                local switchBg = Instance.new("Frame")

                switchBg.Size = UDim2.fromOffset(

                    42,

                    22

                )

                switchBg.Position = UDim2.new(

                    1,

                    -52,

                    0.5,

                    -11

                )

                switchBg.BackgroundColor3 = toggled

                    and Library.Theme.Accent

                    or Library.Theme.SurfaceHover

                switchBg.BorderSizePixel = 0

                switchBg.ZIndex = 26

                switchBg.Parent = btn

                corner(switchBg, 11)

                local switchDot = Instance.new("Frame")

                switchDot.Size = UDim2.fromOffset(

                    16,

                    16

                )

                switchDot.Position = toggled

                    and UDim2.new(

                        1,

                        -19,

                        0.5,

                        -8

                    )

                    or UDim2.new(

                        0,

                        3,

                        0.5,

                        -8

                    )

                switchDot.BackgroundColor3 =

                    Color3.new(

                        1,

                        1,

                        1

                    )

                switchDot.BorderSizePixel = 0

                switchDot.ZIndex = 27

                switchDot.Parent = switchBg

                corner(switchDot, 8)

                ------------------------------------------------
                -- UPDATE
                ------------------------------------------------

                local function updateToggle()

                    tween(

                        switchBg,

                        {

                            BackgroundColor3 = toggled

                                and Library.Theme.Accent

                                or Library.Theme.SurfaceHover

                        },

                        0.2

                    )

                    tween(

                        switchDot,

                        {

                            Position = toggled

                                and UDim2.new(

                                    1,

                                    -19,

                                    0.5,

                                    -8

                                )

                                or UDim2.new(

                                    0,

                                    3,

                                    0.5,

                                    -8

                                )

                        },

                        0.2

                    )

                end

                btn.MouseButton1Click:Connect(function()

                    toggled = not toggled

                    updateToggle()

                    if callback then

                        pcall(function()

                            callback(toggled)

                        end)

                    end

                end)

                function SectionObj:SetToggle(value)

                    toggled = value == true

                    updateToggle()

                end

                return btn

            end

            ----------------------------------------------------
            -- TEXTBOX
            ----------------------------------------------------

            function SectionObj:AddTextbox(

                textValue,

                placeholder,

                callback

            )

                local frame = Instance.new("Frame")

                frame.Size = UDim2.new(

                    1,

                    0,

                    0,

                    48

                )

                frame.BackgroundColor3 =

                    Library.Theme.Surface2

                frame.BorderSizePixel = 0

                frame.ZIndex = 24

                frame.Parent = content

                corner(frame, 13)

                stroke(

                    frame,

                    Library.Theme.BorderSubtle,

                    1,

                    0.35

                )

                local txt = label(

                    frame,

                    textValue,

                    11,

                    Library.Theme.Text,

                    Enum.Font.GothamMedium

                )

                txt.Size = UDim2.new(

                    0.42,

                    0,

                    1,

                    0

                )

                txt.Position = UDim2.new(

                    0,

                    13,

                    0,

                    0

                )

                ------------------------------------------------
                -- INPUT BACKGROUND
                ------------------------------------------------

                local boxBg = Instance.new("Frame")

                boxBg.Size = UDim2.new(

                    0,

                    145,

                    0,

                    30

                )

                boxBg.Position = UDim2.new(

                    1,

                    -153,

                    0.5,

                    -15

                )

                boxBg.BackgroundColor3 =

                    Library.Theme.Surface

                boxBg.BorderSizePixel = 0

                boxBg.ZIndex = 26

                boxBg.Parent = frame

                corner(boxBg, 9)

                local BoxStroke = stroke(

                    boxBg,

                    Library.Theme.BorderSubtle,

                    1,

                    0.4

                )

                ------------------------------------------------
                -- TEXTBOX
                ------------------------------------------------

                local box = Instance.new("TextBox")

                box.Size = UDim2.new(

                    1,

                    -14,

                    1,

                    0

                )

                box.Position = UDim2.new(

                    0,

                    7,

                    0,

                    0

                )

                box.BackgroundTransparency = 1

                box.ClearTextOnFocus = false

                box.PlaceholderText =

                    placeholder or "Enter text..."

                box.Text = ""

                box.TextColor3 =

                    Library.Theme.Text

                box.PlaceholderColor3 =

                    Library.Theme.Muted

                box.TextSize = 10

                box.Font = Enum.Font.Gotham

                box.TextXAlignment =

                    Enum.TextXAlignment.Left

                box.ZIndex = 27

                box.Parent = boxBg

                box.Focused:Connect(function()

                    tween(

                        BoxStroke,

                        {

                            Color =

                                Library.Theme.Accent,

                            Transparency = 0

                        },

                        0.15

                    )

                end)

                box.FocusLost:Connect(function(

                    enterPressed

                )

                    tween(

                        BoxStroke,

                        {

                            Color =

                                Library.Theme.BorderSubtle,

                            Transparency = 0.4

                        },

                        0.15

                    )

                    if callback then

                        pcall(function()

                            callback(

                                box.Text,

                                enterPressed

                            )

                        end)

                    end

                end)

                return frame

            end

            return SectionObj

        end

        return TabObj

    end

    ------------------------------------------------------------
    -- MINIMIZE
    ------------------------------------------------------------

    local minimized = false

    MinimizeBtn.MouseButton1Click:Connect(function()

        minimized = not minimized

        Sidebar.Visible = not minimized

        ContainerHolder.Visible = not minimized

        StatusDot.Visible = not minimized

        StatusText.Visible = not minimized

        local targetSize = minimized

            and UDim2.fromOffset(

                680,

                66

            )

            or UDim2.fromOffset(

                680,

                460

            )

        tween(

            GlowContainer,

            {

                Size = targetSize

            },

            0.28

        )

        MinimizeBtn.Text = minimized

            and "+"

            or "−"

    end)

    ------------------------------------------------------------
    -- CLOSE
    ------------------------------------------------------------

    CloseBtn.MouseButton1Click:Connect(function()

        Library:SendNotification(

            "NAEI HUB",

            "กำลังปิด UI...",

            1.2

        )

        tween(

            GlowContainer,

            {

                Size = UDim2.fromOffset(

                    680,

                    0

                )

            },

            0.25

        )

        task.wait(0.27)

        if ScreenGui then

            ScreenGui:Destroy()

        end

    end)

    ------------------------------------------------------------
    -- RIGHT SHIFT
    ------------------------------------------------------------

    UserInputService.InputBegan:Connect(function(

        input,

        processed

    )

        if processed then

            return

        end

        if input.KeyCode == Enum.KeyCode.RightShift then

            if ScreenGui.Parent then

                GlowContainer.Visible =

                    not GlowContainer.Visible

            end

        end

    end)

    ------------------------------------------------------------
    -- DRAG SYSTEM
    ------------------------------------------------------------

    local dragging = false

    local dragInput = nil

    local dragStart = nil

    local startPos = nil

    TopBar.InputBegan:Connect(function(input)

        if

            input.UserInputType ==

                Enum.UserInputType.MouseButton1

            or

            input.UserInputType ==

                Enum.UserInputType.Touch

        then

            dragging = true

            dragStart = input.Position

            startPos = GlowContainer.Position

        end

    end)

    TopBar.InputChanged:Connect(function(input)

        if

            input.UserInputType ==

                Enum.UserInputType.MouseMovement

            or

            input.UserInputType ==

                Enum.UserInputType.Touch

        then

            dragInput = input

        end

    end)

    UserInputService.InputChanged:Connect(function(input)

        if

            input == dragInput

            and dragging

        then

            local delta =

                input.Position -

                dragStart

            GlowContainer.Position = UDim2.new(

                startPos.X.Scale,

                startPos.X.Offset + delta.X,

                startPos.Y.Scale,

                startPos.Y.Offset + delta.Y

            )

        end

    end)

    UserInputService.InputEnded:Connect(function(input)

        if

            input.UserInputType ==

                Enum.UserInputType.MouseButton1

            or

            input.UserInputType ==

                Enum.UserInputType.Touch

        then

            dragging = false

        end

    end)

    ------------------------------------------------------------
    -- SHOW AFTER LOADING
    ------------------------------------------------------------

    if Library.Settings.LoadingEnabled then

        task.spawn(function()

            while ScreenGui.Parent

                and not Library._LoadingFinished do

                task.wait()

            end

            if ScreenGui.Parent then

                GlowContainer.Visible = true

                GlowContainer.Size = UDim2.fromOffset(

                    620,

                    400

                )

                tween(

                    GlowContainer,

                    {

                        Size = UDim2.fromOffset(

                            680,

                            460

                        )

                    },

                    0.45,

                    Enum.EasingStyle.Back

                )

            end

        end)

    else

        GlowContainer.Visible = true

    end

    ------------------------------------------------------------
    -- INITIAL NOTIFICATION
    ------------------------------------------------------------

    task.spawn(function()

        if Library.Settings.LoadingEnabled then

            while not Library._LoadingFinished do

                task.wait()

            end

            task.wait(0.35)

        end

        Library:SendNotification(

            "NAEI HUB",

            "ระบบพร้อมใช้งานแล้ว",

            2.5

        )

    end)

    return WindowObj

end

----------------------------------------------------------------
-- RETURN
----------------------------------------------------------------

return Library