--[[
╔══════════════════════════════════════════════════════════════╗
║                 NAEI HUB UI LIBRARY V3                      ║
║              PREMIUM GLASS / NEON PURPLE                    ║
║                                                              ║
║  • Premium Loading Screen                                    ║
║  • Glass Window                                               ║
║  • Neon Purple Glow                                           ║
║  • Animated Border                                            ║
║  • Modern Sidebar                                             ║
║  • Animated Tabs                                              ║
║  • Collapsible Sections                                       ║
║  • Premium Buttons                                            ║
║  • iOS Style Toggles                                          ║
║  • Premium Textboxes                                          ║
║  • Notifications                                              ║
║  • Mobile / PC                                                ║
║  • Drag                                                       ║
║  • Minimize                                                   ║
║  • RightShift Toggle                                          ║
║                                                              ║
║  API COMPATIBLE WITH YU.LUA                                  ║
╚══════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

---------------------------------------------------------------
-- LIBRARY
---------------------------------------------------------------

local Library = {}

---------------------------------------------------------------
-- CONFIG
---------------------------------------------------------------

Library.Config = {
    Name = "NAEI HUB",
    Version = "V3.0",

    LoadingScreen = true,
    LoadingTime = 2.8,

    Accent = Color3.fromRGB(126, 92, 255),
    Accent2 = Color3.fromRGB(168, 85, 247),

    DesktopSize = Vector2.new(720, 460),
    MobileSize = Vector2.new(350, 470),

    MinSize = Vector2.new(300, 320)
}

---------------------------------------------------------------
-- THEME
---------------------------------------------------------------

Library.Theme = {

    Background = Color3.fromRGB(245, 246, 252),

    Window = Color3.fromRGB(255, 255, 255),

    Sidebar = Color3.fromRGB(248, 248, 253),

    Card = Color3.fromRGB(252, 252, 255),

    CardHover = Color3.fromRGB(244, 240, 255),

    Input = Color3.fromRGB(244, 245, 250),

    Border = Color3.fromRGB(225, 221, 240),

    Text = Color3.fromRGB(27, 25, 38),

    Muted = Color3.fromRGB(125, 121, 143),

    Accent = Color3.fromRGB(126, 92, 255),

    Accent2 = Color3.fromRGB(168, 85, 247),

    Glow = Color3.fromRGB(147, 112, 255),

    Success = Color3.fromRGB(34, 197, 94),

    Danger = Color3.fromRGB(239, 68, 68),

    Warning = Color3.fromRGB(245, 158, 11)
}

---------------------------------------------------------------
-- SETTINGS
---------------------------------------------------------------

Library.Settings = {

    LoadingEnabled = true,

    LoadingDuration = 2.8,

    LoadingTitle = "NAEI HUB",

    LoadingSubtitle = "Premium Interface",

    LoadingText = "กำลังเตรียมระบบ..."
}

---------------------------------------------------------------
-- INTERNAL
---------------------------------------------------------------

Library._Gui = nil
Library._Window = nil
Library._Minimized = false
Library._Tabs = {}
Library._ActiveTab = nil

---------------------------------------------------------------
-- UTILITIES
---------------------------------------------------------------

local function Tween(obj, props, duration, style, direction)

    if not obj then
        return
    end

    local info = TweenInfo.new(
        duration or .25,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )

    pcall(function()
        TweenService:Create(
            obj,
            info,
            props
        ):Play()
    end)
end

local function Corner(obj, radius)

    local c = Instance.new("UICorner")

    c.CornerRadius =
        UDim.new(0, radius or 12)

    c.Parent = obj

    return c
end

local function Stroke(
    obj,
    color,
    thickness,
    transparency
)

    local s = Instance.new("UIStroke")

    s.Color =
        color or Library.Theme.Border

    s.Thickness =
        thickness or 1

    s.Transparency =
        transparency or 0

    s.ApplyStrokeMode =
        Enum.ApplyStrokeMode.Border

    s.Parent = obj

    return s
end

local function Gradient(
    obj,
    c1,
    c2,
    rotation
)

    local g = Instance.new("UIGradient")

    g.Color = ColorSequence.new({

        ColorSequenceKeypoint.new(
            0,
            c1 or Library.Theme.Accent
        ),

        ColorSequenceKeypoint.new(
            1,
            c2 or Library.Theme.Accent2
        )
    })

    g.Rotation =
        rotation or 0

    g.Parent = obj

    return g
end

local function Text(
    parent,
    text,
    size,
    color,
    font
)

    local t = Instance.new("TextLabel")

    t.BackgroundTransparency = 1

    t.Text = text or ""

    t.TextSize =
        size or 13

    t.TextColor3 =
        color or Library.Theme.Text

    t.Font =
        font or Enum.Font.GothamMedium

    t.TextXAlignment =
        Enum.TextXAlignment.Left

    t.TextYAlignment =
        Enum.TextYAlignment.Center

    t.Parent = parent

    return t
end

local function Padding(
    parent,
    left,
    right,
    top,
    bottom
)

    local p = Instance.new("UIPadding")

    p.PaddingLeft =
        UDim.new(0, left or 0)

    p.PaddingRight =
        UDim.new(0, right or 0)

    p.PaddingTop =
        UDim.new(0, top or 0)

    p.PaddingBottom =
        UDim.new(0, bottom or 0)

    p.Parent = parent

    return p
end

---------------------------------------------------------------
-- THEME
---------------------------------------------------------------

function Library:SetThemeColor(color)

    Library.Theme.Accent = color

    if Library._Gui then

        for _, obj in
            ipairs(Library._Gui:GetDescendants()) do

            if obj:IsA("UIStroke") then

                if obj.Name == "AccentStroke" then
                    obj.Color = color
                end

            end
        end
    end
end

---------------------------------------------------------------
-- NOTIFICATION
---------------------------------------------------------------

function Library:SendNotification(
    title,
    message,
    duration
)

    if not Library._Gui then
        return
    end

    local holder =
        Library._Gui:FindFirstChild(
            "Notifications"
        )

    if not holder then

        holder = Instance.new("Frame")

        holder.Name =
            "Notifications"

        holder.AnchorPoint =
            Vector2.new(1, 0)

        holder.Position =
            UDim2.new(
                1,
                -18,
                0,
                18
            )

        holder.Size =
            UDim2.fromOffset(
                300,
                400
            )

        holder.BackgroundTransparency =
            1

        holder.Parent =
            Library._Gui

        local layout =
            Instance.new("UIListLayout")

        layout.Padding =
            UDim.new(0, 10)

        layout.HorizontalAlignment =
            Enum.HorizontalAlignment.Right

        layout.VerticalAlignment =
            Enum.VerticalAlignment.Top

        layout.Parent =
            holder
    end

    local Card =
        Instance.new("Frame")

    Card.Size =
        UDim2.fromOffset(
            290,
            72
        )

    Card.BackgroundColor3 =
        Library.Theme.Window

    Card.BorderSizePixel = 0

    Card.Parent =
        holder

    Corner(Card, 17)

    local st =
        Stroke(
            Card,
            Library.Theme.Accent,
            1,
            .55
        )

    st.Name =
        "AccentStroke"

    local Glow =
        Instance.new("Frame")

    Glow.Size =
        UDim2.new(
            0,
            4,
            1,
            -20
        )

    Glow.Position =
        UDim2.fromOffset(
            8,
            10
        )

    Glow.BackgroundColor3 =
        Library.Theme.Accent

    Glow.BorderSizePixel = 0

    Glow.Parent = Card

    Corner(Glow, 3)

    local Title =
        Text(
            Card,
            tostring(title),
            13,
            Library.Theme.Text,
            Enum.Font.GothamBold
        )

    Title.Position =
        UDim2.fromOffset(
            24,
            10
        )

    Title.Size =
        UDim2.new(
            1,
            -35,
            0,
            22
        )

    local Message =
        Text(
            Card,
            tostring(message),
            11,
            Library.Theme.Muted
        )

    Message.Position =
        UDim2.fromOffset(
            24,
            34
        )

    Message.Size =
        UDim2.new(
            1,
            -35,
            0,
            25
        )

    Card.Position =
        UDim2.new(
            1,
            320,
            0,
            0
        )

    Tween(
        Card,
        {
            Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    0
                )
        },
        .35
    )

    task.delay(
        duration or 3,
        function()

            if Card.Parent then

                Tween(
                    Card,
                    {
                        Position =
                            UDim2.new(
                                1,
                                320,
                                0,
                                0
                            )
                    },
                    .3
                )

                task.wait(.32)

                Card:Destroy()
            end
        end
    )
end

---------------------------------------------------------------
-- LOADING SCREEN
---------------------------------------------------------------

function Library:CreateLoadingScreen(
    gui,
    callback
)

    if not Library.Settings.LoadingEnabled then

        if callback then
            callback()
        end

        return
    end

    local Root =
        Instance.new("Frame")

    Root.Name =
        "PremiumLoading"

    Root.Size =
        UDim2.fromScale(1, 1)

    Root.BackgroundColor3 =
        Library.Theme.Background

    Root.BorderSizePixel = 0

    Root.ZIndex = 5000

    Root.Parent = gui

    -----------------------------------------------------------
    -- BACKGROUND
    -----------------------------------------------------------

    local Back =
        Instance.new("Frame")

    Back.Size =
        UDim2.fromScale(1, 1)

    Back.BackgroundColor3 =
        Library.Theme.Background

    Back.BorderSizePixel = 0

    Back.Parent = Root

    local BackGradient =
        Gradient(
            Back,
            Color3.fromRGB(
                255,
                255,
                255
            ),
            Color3.fromRGB(
                239,
                234,
                255
            ),
            35
        )

    -----------------------------------------------------------
    -- GLOW CIRCLES
    -----------------------------------------------------------

    local function GlowCircle(
        size,
        pos,
        transparency
    )

        local c =
            Instance.new("Frame")

        c.Size =
            UDim2.fromOffset(
                size,
                size
            )

        c.Position =
            pos

        c.BackgroundColor3 =
            Library.Theme.Accent

        c.BackgroundTransparency =
            transparency

        c.BorderSizePixel = 0

        c.Parent =
            Root

        Corner(
            c,
            size / 2
        )

        return c
    end

    local C1 =
        GlowCircle(
            260,
            UDim2.new(
                -.12,
                0,
                -.18,
                0
            ),
            .90
        )

    local C2 =
        GlowCircle(
            330,
            UDim2.new(
                .78,
                0,
                .72,
                0
            ),
            .93
        )

    local C3 =
        GlowCircle(
            150,
            UDim2.new(
                .80,
                0,
                .05,
                0
            ),
            .92
        )

    task.spawn(function()

        while Root.Parent do

            Tween(
                C1,
                {
                    Position =
                        UDim2.new(
                            -.08,
                            0,
                            -.13,
                            0
                        )
                },
                2
            )

            Tween(
                C2,
                {
                    Position =
                        UDim2.new(
                            .74,
                            0,
                            .67,
                            0
                        )
                },
                2
            )

            task.wait(2)

            Tween(
                C1,
                {
                    Position =
                        UDim2.new(
                            -.12,
                            0,
                            -.18,
                            0
                        )
                },
                2
            )

            Tween(
                C2,
                {
                    Position =
                        UDim2.new(
                            .78,
                            0,
                            .72,
                            0
                        )
                },
                2
            )

            task.wait(2)
        end
    end)

    -----------------------------------------------------------
    -- CARD
    -----------------------------------------------------------

    local Card =
        Instance.new("Frame")

    Card.AnchorPoint =
        Vector2.new(
            .5,
            .5
        )

    Card.Position =
        UDim2.fromScale(
            .5,
            .5
        )

    Card.Size =
        UDim2.fromOffset(
            390,
            300
        )

    Card.BackgroundColor3 =
        Library.Theme.Window

    Card.BorderSizePixel = 0

    Card.Parent =
        Root

    Corner(
        Card,
        28
    )

    Stroke(
        Card,
        Library.Theme.Accent,
        1.5,
        .35
    )

    -----------------------------------------------------------
    -- LOGO
    -----------------------------------------------------------

    local Logo =
        Instance.new("Frame")

    Logo.AnchorPoint =
        Vector2.new(
            .5,
            0
        )

    Logo.Position =
        UDim2.new(
            .5,
            0,
            0,
            30
        )

    Logo.Size =
        UDim2.fromOffset(
            74,
            74
        )

    Logo.BackgroundColor3 =
        Library.Theme.Accent

    Logo.BorderSizePixel = 0

    Logo.Parent =
        Card

    Corner(
        Logo,
        23
    )

    Gradient(
        Logo,
        Library.Theme.Accent,
        Library.Theme.Accent2
    )

    local LogoStroke =
        Stroke(
            Logo,
            Library.Theme.Glow,
            2,
            0
        )

    LogoStroke.Name =
        "AccentStroke"

    local LogoText =
        Text(
            Logo,
            "N",
            34,
            Color3.new(
                1,
                1,
                1
            ),
            Enum.Font.GothamBlack
        )

    LogoText.Size =
        UDim2.fromScale(
            1,
            1
        )

    LogoText.TextXAlignment =
        Enum.TextXAlignment.Center

    LogoText.TextYAlignment =
        Enum.TextYAlignment.Center

    -----------------------------------------------------------
    -- TITLE
    -----------------------------------------------------------

    local Title =
        Text(
            Card,
            Library.Settings.LoadingTitle,
            21,
            Library.Theme.Text,
            Enum.Font.GothamBlack
        )

    Title.AnchorPoint =
        Vector2.new(
            .5,
            0
        )

    Title.Position =
        UDim2.new(
            .5,
            0,
            0,
            118
        )

    Title.Size =
        UDim2.fromOffset(
            320,
            28
        )

    Title.TextXAlignment =
        Enum.TextXAlignment.Center

    -----------------------------------------------------------
    -- SUBTITLE
    -----------------------------------------------------------

    local Subtitle =
        Text(
            Card,
            Library.Settings.LoadingSubtitle,
            11,
            Library.Theme.Muted
        )

    Subtitle.AnchorPoint =
        Vector2.new(
            .5,
            0
        )

    Subtitle.Position =
        UDim2.new(
            .5,
            0,
            0,
            147
        )

    Subtitle.Size =
        UDim2.fromOffset(
            320,
            20
        )

    Subtitle.TextXAlignment =
        Enum.TextXAlignment.Center

    -----------------------------------------------------------
    -- STATUS
    -----------------------------------------------------------

    local Status =
        Text(
            Card,
            Library.Settings.LoadingText,
            11,
            Library.Theme.Muted,
            Enum.Font.GothamMedium
        )

    Status.AnchorPoint =
        Vector2.new(
            .5,
            0
        )

    Status.Position =
        UDim2.new(
            .5,
            0,
            0,
            182
        )

    Status.Size =
        UDim2.fromOffset(
            320,
            20
        )

    Status.TextXAlignment =
        Enum.TextXAlignment.Center

    -----------------------------------------------------------
    -- PROGRESS
    -----------------------------------------------------------

    local ProgressBack =
        Instance.new("Frame")

    ProgressBack.AnchorPoint =
        Vector2.new(
            .5,
            0
        )

    ProgressBack.Position =
        UDim2.new(
            .5,
            0,
            0,
            218
        )

    ProgressBack.Size =
        UDim2.fromOffset(
            290,
            8
        )

    ProgressBack.BackgroundColor3 =
        Library.Theme.Input

    ProgressBack.BorderSizePixel = 0

    ProgressBack.Parent =
        Card

    Corner(
        ProgressBack,
        4
    )

    local Progress =
        Instance.new("Frame")

    Progress.Size =
        UDim2.new(
            0,
            0,
            1,
            0
        )

    Progress.BackgroundColor3 =
        Library.Theme.Accent

    Progress.BorderSizePixel = 0

    Progress.Parent =
        ProgressBack

    Corner(
        Progress,
        4
    )

    Gradient(
        Progress,
        Library.Theme.Accent,
        Library.Theme.Accent2
    )

    -----------------------------------------------------------
    -- PERCENT
    -----------------------------------------------------------

    local Percent =
        Text(
            Card,
            "0%",
            10,
            Library.Theme.Muted,
            Enum.Font.GothamBold
        )

    Percent.AnchorPoint =
        Vector2.new(
            .5,
            0
        )

    Percent.Position =
        UDim2.new(
            .5,
            0,
            0,
            236
        )

    Percent.Size =
        UDim2.fromOffset(
            100,
            18
        )

    Percent.TextXAlignment =
        Enum.TextXAlignment.Center

    -----------------------------------------------------------
    -- LOADING
    -----------------------------------------------------------

    task.spawn(function()

        local start =
            os.clock()

        local duration =
            Library.Settings.LoadingDuration

        local messages = {

            "กำลังเริ่ม NAEI HUB...",

            "กำลังสร้าง Interface...",

            "กำลังโหลด Components...",

            "กำลังเตรียมระบบ...",

            "พร้อมใช้งาน"
        }

        while Root.Parent do

            local alpha =
                math.clamp(
                    (
                        os.clock() -
                        start
                    ) / duration,
                    0,
                    1
                )

            Progress.Size =
                UDim2.new(
                    alpha,
                    0,
                    1,
                    0
                )

            Percent.Text =
                math.floor(
                    alpha * 100
                ) .. "%"

            local index =
                math.clamp(
                    math.floor(
                        alpha *
                        (#messages - 1)
                    ) + 1,
                    1,
                    #messages
                )

            Status.Text =
                messages[index]

            if alpha >= 1 then
                break
            end

            RunService.RenderStepped:Wait()
        end

        Percent.Text =
            "100%"

        Status.Text =
            "พร้อมใช้งาน"

        task.wait(.35)

        -------------------------------------------------------
        -- FADE
        -------------------------------------------------------

        for _, obj in
            ipairs(
                Root:GetDescendants()
            ) do

            if obj:IsA("Frame") then

                Tween(
                    obj,
                    {
                        BackgroundTransparency = 1
                    },
                    .35
                )

            elseif obj:IsA("TextLabel") then

                Tween(
                    obj,
                    {
                        TextTransparency = 1
                    },
                    .3
                )

            elseif obj:IsA("UIStroke") then

                Tween(
                    obj,
                    {
                        Transparency = 1
                    },
                    .3
                )
            end
        end

        Tween(
            Root,
            {
                BackgroundTransparency = 1
            },
            .4
        )

        task.wait(.45)

        Root:Destroy()

        if callback then
            callback()
        end
    end)
end

---------------------------------------------------------------
-- WINDOW
---------------------------------------------------------------

function Library:CreateWindow(
    title,
    subtitle
)

    -----------------------------------------------------------
    -- REMOVE OLD
    -----------------------------------------------------------

    if Library._Gui then
        Library._Gui:Destroy()
    end

    -----------------------------------------------------------
    -- SCREEN GUI
    -----------------------------------------------------------

    local Gui =
        Instance.new("ScreenGui")

    Gui.Name =
        "NAEI_HUB_V3"

    Gui.ResetOnSpawn =
        false

    Gui.IgnoreGuiInset =
        true

    Gui.ZIndexBehavior =
        Enum.ZIndexBehavior.Sibling

    Gui.Parent =
        PlayerGui

    Library._Gui =
        Gui

    -----------------------------------------------------------
    -- MOBILE
    -----------------------------------------------------------

    local camera =
        workspace.CurrentCamera

    local viewport =
        camera and camera.ViewportSize
        or Vector2.new(
            800,
            600
        )

    local Mobile =
        viewport.X < 600

    local Size

    if Mobile then

        Size =
            Library.Config.MobileSize

    else

        Size =
            Library.Config.DesktopSize
    end

    -----------------------------------------------------------
    -- SHADOW
    -----------------------------------------------------------

    local Shadow =
        Instance.new("Frame")

    Shadow.AnchorPoint =
        Vector2.new(
            .5,
            .5
        )

    Shadow.Position =
        UDim2.fromScale(
            .5,
            .5
        )

    Shadow.Size =
        UDim2.fromOffset(
            Size.X + 22,
            Size.Y + 22
        )

    Shadow.BackgroundColor3 =
        Library.Theme.Accent

    Shadow.BackgroundTransparency =
        .88

    Shadow.BorderSizePixel = 0

    Shadow.Parent =
        Gui

    Corner(
        Shadow,
        27
    )

    -----------------------------------------------------------
    -- WINDOW
    -----------------------------------------------------------

    local Window =
        Instance.new("Frame")

    Window.Name =
        "MainWindow"

    Window.AnchorPoint =
        Vector2.new(
            .5,
            .5
        )

    Window.Position =
        UDim2.fromScale(
            .5,
            .5
        )

    Window.Size =
        UDim2.fromOffset(
            Size.X,
            Size.Y
        )

    Window.BackgroundColor3 =
        Library.Theme.Window

    Window.BorderSizePixel = 0

    Window.ClipsDescendants =
        true

    Window.Parent =
        Gui

    Corner(
        Window,
        24
    )

    local WindowStroke =
        Stroke(
            Window,
            Library.Theme.Accent,
            1.5,
            .45
        )

    WindowStroke.Name =
        "AccentStroke"

    Library._Window =
        Window

    -----------------------------------------------------------
    -- ANIMATED GLOW BORDER
    -----------------------------------------------------------

    local GlowGradient =
        Gradient(
            WindowStroke,
            Library.Theme.Accent,
            Library.Theme.Accent2
        )

    task.spawn(function()

        while Window.Parent do

            GlowGradient.Rotation =
                GlowGradient.Rotation + 1

            if GlowGradient.Rotation >= 360 then
                GlowGradient.Rotation = 0
            end

            task.wait(.03)
        end
    end)

    -----------------------------------------------------------
    -- TOP BAR
    -----------------------------------------------------------

    local Top =
        Instance.new("Frame")

    Top.Size =
        UDim2.new(
            1,
            0,
            0,
            64
        )

    Top.BackgroundColor3 =
        Library.Theme.Window

    Top.BorderSizePixel = 0

    Top.Parent =
        Window

    -----------------------------------------------------------
    -- LOGO
    -----------------------------------------------------------

    local Logo =
        Instance.new("Frame")

    Logo.Position =
        UDim2.fromOffset(
            16,
            12
        )

    Logo.Size =
        UDim2.fromOffset(
            40,
            40
        )

    Logo.BackgroundColor3 =
        Library.Theme.Accent

    Logo.BorderSizePixel = 0

    Logo.Parent =
        Top

    Corner(
        Logo,
        13
    )

    Gradient(
        Logo,
        Library.Theme.Accent,
        Library.Theme.Accent2
    )

    local LogoText =
        Text(
            Logo,
            "N",
            20,
            Color3.new(
                1,
                1,
                1
            ),
            Enum.Font.GothamBlack
        )

    LogoText.Size =
        UDim2.fromScale(
            1,
            1
        )

    LogoText.TextXAlignment =
        Enum.TextXAlignment.Center

    LogoText.TextYAlignment =
        Enum.TextYAlignment.Center

    -----------------------------------------------------------
    -- TITLE
    -----------------------------------------------------------

    local Title =
        Text(
            Top,
            title or "NAEI HUB",
            15,
            Library.Theme.Text,
            Enum.Font.GothamBlack
        )

    Title.Position =
        UDim2.fromOffset(
            68,
            10
        )

    Title.Size =
        UDim2.new(
            1,
            -180,
            0,
            24
        )

    local Subtitle =
        Text(
            Top,
            subtitle or "Premium Interface",
            10,
            Library.Theme.Muted
        )

    Subtitle.Position =
        UDim2.fromOffset(
            68,
            33
        )

    Subtitle.Size =
        UDim2.new(
            1,
            -180,
            0,
            18
        )

    -----------------------------------------------------------
    -- STATUS
    -----------------------------------------------------------

    local StatusDot =
        Instance.new("Frame")

    StatusDot.Position =
        UDim2.new(
            1,
            -115,
            0,
            25
        )

    StatusDot.Size =
        UDim2.fromOffset(
            8,
            8
        )

    StatusDot.BackgroundColor3 =
        Library.Theme.Success

    StatusDot.BorderSizePixel = 0

    StatusDot.Parent =
        Top

    Corner(
        StatusDot,
        4
    )

    local StatusText =
        Text(
            Top,
            "ONLINE",
            9,
            Library.Theme.Success,
            Enum.Font.GothamBold
        )

    StatusText.Position =
        UDim2.new(
            1,
            -100,
            0,
            19
        )

    StatusText.Size =
        UDim2.fromOffset(
            55,
            20
        )

    -----------------------------------------------------------
    -- MINIMIZE
    -----------------------------------------------------------

    local Minimize =
        Instance.new("TextButton")

    Minimize.Position =
        UDim2.new(
            1,
            -58,
            0,
            17
        )

    Minimize.Size =
        UDim2.fromOffset(
            32,
            32
        )

    Minimize.Text =
        "—"

    Minimize.TextSize =
        18

    Minimize.Font =
        Enum.Font.GothamBold

    Minimize.TextColor3 =
        Library.Theme.Muted

    Minimize.BackgroundColor3 =
        Library.Theme.Input

    Minimize.BorderSizePixel = 0

    Minimize.AutoButtonColor = false

    Minimize.Parent =
        Top

    Corner(
        Minimize,
        10
    )

    Minimize.MouseEnter:Connect(
        function()

            Tween(
                Minimize,
                {
                    BackgroundColor3 =
                        Library.Theme.CardHover,

                    TextColor3 =
                        Library.Theme.Accent
                },
                .15
            )
        end
    )

    Minimize.MouseLeave:Connect(
        function()

            Tween(
                Minimize,
                {
                    BackgroundColor3 =
                        Library.Theme.Input,

                    TextColor3 =
                        Library.Theme.Muted
                },
                .15
            )
        end
    )

    -----------------------------------------------------------
    -- BODY
    -----------------------------------------------------------

    local Body =
        Instance.new("Frame")

    Body.Position =
        UDim2.fromOffset(
            0,
            64
        )

    Body.Size =
        UDim2.new(
            1,
            0,
            1,
            -64
        )

    Body.BackgroundTransparency =
        1

    Body.Parent =
        Window

    -----------------------------------------------------------
    -- SIDEBAR
    -----------------------------------------------------------

    local Sidebar =
        Instance.new("Frame")

    Sidebar.Position =
        UDim2.fromOffset(
            10,
            10
        )

    Sidebar.Size =
        UDim2.new(
            0,
            Mobile and 72 or 154,
            1,
            -20
        )

    Sidebar.BackgroundColor3 =
        Library.Theme.Sidebar

    Sidebar.BorderSizePixel = 0

    Sidebar.Parent =
        Body

    Corner(
        Sidebar,
        18
    )

    Stroke(
        Sidebar,
        Library.Theme.Border,
        1,
        .45
    )

    -----------------------------------------------------------
    -- SIDEBAR TITLE
    -----------------------------------------------------------

    if not Mobile then

        local SideTitle =
            Text(
                Sidebar,
                "MENU",
                9,
                Library.Theme.Muted,
                Enum.Font.GothamBold
            )

        SideTitle.Position =
            UDim2.fromOffset(
                16,
                14
            )

        SideTitle.Size =
            UDim2.new(
                1,
                -32,
                0,
                20
            )
    end

    -----------------------------------------------------------
    -- TAB HOLDER
    -----------------------------------------------------------

    local TabHolder =
        Instance.new("ScrollingFrame")

    TabHolder.Name =
        "Tabs"

    TabHolder.Position =
        UDim2.fromOffset(
            8,
            Mobile and 10 or 38
        )

    TabHolder.Size =
        UDim2.new(
            1,
            -16,
            1,
            -48
        )

    TabHolder.BackgroundTransparency =
        1

    TabHolder.BorderSizePixel = 0

    TabHolder.ScrollBarThickness = 0

    TabHolder.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            0
        )

    TabHolder.Parent =
        Sidebar

    local TabLayout =
        Instance.new("UIListLayout")

    TabLayout.Padding =
        UDim.new(
            0,
            7
        )

    TabLayout.Parent =
        TabHolder

    -----------------------------------------------------------
    -- CONTENT
    -----------------------------------------------------------

    local Content =
        Instance.new("Frame")

    Content.Position =
        UDim2.new(
            0,
            Mobile and 90 or 174,
            0,
            10
        )

    Content.Size =
        UDim2.new(
            1,
            -(Mobile and 100 or 184),
            1,
            -20
        )

    Content.BackgroundColor3 =
        Library.Theme.Card

    Content.BorderSizePixel = 0

    Content.Parent =
        Body

    Corner(
        Content,
        18
    )

    Stroke(
        Content,
        Library.Theme.Border,
        1,
        .4
    )

    -----------------------------------------------------------
    -- CONTENT TITLE
    -----------------------------------------------------------

    local ContentTitle =
        Text(
            Content,
            "หน้าหลัก",
            16,
            Library.Theme.Text,
            Enum.Font.GothamBlack
        )

    ContentTitle.Position =
        UDim2.fromOffset(
            18,
            14
        )

    ContentTitle.Size =
        UDim2.new(
            1,
            -36,
            0,
            26
        )

    -----------------------------------------------------------
    -- CONTENT HOLDER
    -----------------------------------------------------------

    local ContentHolder =
        Instance.new("ScrollingFrame")

    ContentHolder.Name =
        "Content"

    ContentHolder.Position =
        UDim2.fromOffset(
            12,
            48
        )

    ContentHolder.Size =
        UDim2.new(
            1,
            -24,
            1,
            -58
        )

    ContentHolder.BackgroundTransparency =
        1

    ContentHolder.BorderSizePixel = 0

    ContentHolder.ScrollBarThickness = 2

    ContentHolder.ScrollBarImageColor3 =
        Library.Theme.Accent

    ContentHolder.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            0
        )

    ContentHolder.Parent =
        Content

    local ContentLayout =
        Instance.new("UIListLayout")

    ContentLayout.Padding =
        UDim.new(
            0,
            10
        )

    ContentLayout.Parent =
        ContentHolder

    ContentLayout:GetPropertyChangedSignal(
        "AbsoluteContentSize"
    ):Connect(
        function()

            ContentHolder.CanvasSize =
                UDim2.new(
                    0,
                    0,
                    0,
                    ContentLayout.AbsoluteContentSize.Y
                    + 10
                )
        end
    )

    -----------------------------------------------------------
    -- TAB API
    -----------------------------------------------------------

    local WindowObject = {}

    function WindowObject:CreateTab(
        name,
        icon
    )

        local TabButton =
            Instance.new("TextButton")

        TabButton.Name =
            tostring(name)

        TabButton.Size =
            UDim2.new(
                1,
                0,
                0,
                42
            )

        TabButton.BackgroundColor3 =
            Library.Theme.Input

        TabButton.BackgroundTransparency =
            1

        TabButton.BorderSizePixel = 0

        TabButton.AutoButtonColor = false

        TabButton.Text = ""

        TabButton.Parent =
            TabHolder

        Corner(
            TabButton,
            12
        )

        local Icon =
            Text(
                TabButton,
                icon or "•",
                15,
                Library.Theme.Muted,
                Enum.Font.GothamBold
            )

        Icon.Position =
            UDim2.fromOffset(
                Mobile and 0 or 12,
                0
            )

        Icon.Size =
            UDim2.fromOffset(
                Mobile and 72 or 25,
                42
            )

        Icon.TextXAlignment =
            Enum.TextXAlignment.Center

        local TabName

        if not Mobile then

            TabName =
                Text(
                    TabButton,
                    tostring(name),
                    11,
                    Library.Theme.Muted,
                    Enum.Font.GothamMedium
                )

            TabName.Position =
                UDim2.fromOffset(
                    40,
                    0
                )

            TabName.Size =
                UDim2.new(
                    1,
                    -48,
                    1,
                    0
                )
        end

        local Page =
            Instance.new("ScrollingFrame")

        Page.Name =
            tostring(name)

        Page.Size =
            UDim2.fromScale(
                1,
                1
            )

        Page.BackgroundTransparency =
            1

        Page.BorderSizePixel = 0

        Page.ScrollBarThickness = 2

        Page.ScrollBarImageColor3 =
            Library.Theme.Accent

        Page.CanvasSize =
            UDim2.new(
                0,
                0,
                0,
                0
            )

        Page.Visible = false

        Page.Parent =
            ContentHolder

        local Layout =
            Instance.new("UIListLayout")

        Layout.Padding =
            UDim.new(
                0,
                10
            )

        Layout.Parent =
            Page

        Layout:GetPropertyChangedSignal(
            "AbsoluteContentSize"
        ):Connect(
            function()

                Page.CanvasSize =
                    UDim2.new(
                        0,
                        0,
                        0,
                        Layout.AbsoluteContentSize.Y
                        + 15
                    )
            end
        )

        -------------------------------------------------------
        -- ACTIVATE
        -------------------------------------------------------

        local function Activate()

            for _, tab in
                ipairs(
                    Library._Tabs
                ) do

                tab.Page.Visible =
                    false

                Tween(
                    tab.Button,
                    {
                        BackgroundTransparency = 1
                    },
                    .15
                )

                Tween(
                    tab.Icon,
                    {
                        TextColor3 =
                            Library.Theme.Muted
                    },
                    .15
                )

                if tab.NameLabel then

                    Tween(
                        tab.NameLabel,
                        {
                            TextColor3 =
                                Library.Theme.Muted
                        },
                        .15
                    )
                end
            end

            Page.Visible = true

            Tween(
                TabButton,
                {
                    BackgroundTransparency =
                        0
                },
                .2
            )

            Tween(
                Icon,
                {
                    TextColor3 =
                        Library.Theme.Accent
                },
                .2
            )

            if TabName then

                Tween(
                    TabName,
                    {
                        TextColor3 =
                            Library.Theme.Accent
                    },
                    .2
                )
            end

            ContentTitle.Text =
                tostring(name)

            Library._ActiveTab =
                name
        end

        TabButton.MouseButton1Click:Connect(
            Activate
        )

        TabButton.MouseEnter:Connect(
            function()

                if Library._ActiveTab ~= name then

                    Tween(
                        TabButton,
                        {
                            BackgroundTransparency =
                                .35
                        },
                        .15
                    )
                end
            end
        )

        TabButton.MouseLeave:Connect(
            function()

                if Library._ActiveTab ~= name then

                    Tween(
                        TabButton,
                        {
                            BackgroundTransparency =
                                1
                        },
                        .15
                    )
                end
            end
        )

        local TabObject = {}

        function TabObject:AddCollapsible(
            sectionName
        )

            local Section =
                Instance.new("Frame")

            Section.Name =
                tostring(sectionName)

            Section.Size =
                UDim2.new(
                    1,
                    -4,
                    0,
                    48
                )

            Section.BackgroundColor3 =
                Library.Theme.Window

            Section.BorderSizePixel = 0

            Section.ClipsDescendants =
                true

            Section.Parent =
                Page

            Corner(
                Section,
                15
            )

            Stroke(
                Section,
                Library.Theme.Border,
                1,
                .5
            )

            ---------------------------------------------------
            -- HEADER
            ---------------------------------------------------

            local Header =
                Instance.new("TextButton")

            Header.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    48
                )

            Header.BackgroundTransparency =
                1

            Header.BorderSizePixel = 0

            Header.AutoButtonColor = false

            Header.Text = ""

            Header.Parent =
                Section

            local SectionTitle =
                Text(
                    Header,
                    tostring(sectionName),
                    12,
                    Library.Theme.Text,
                    Enum.Font.GothamBold
                )

            SectionTitle.Position =
                UDim2.fromOffset(
                    16,
                    0
                )

            SectionTitle.Size =
                UDim2.new(
                    1,
                    -55,
                    1,
                    0
                )

            local Arrow =
                Text(
                    Header,
                    "⌄",
                    16,
                    Library.Theme.Muted,
                    Enum.Font.GothamBold
                )

            Arrow.AnchorPoint =
                Vector2.new(
                    1,
                    .5
                )

            Arrow.Position =
                UDim2.new(
                    1,
                    -16,
                    .5,
                    0
                )

            Arrow.Size =
                UDim2.fromOffset(
                    20,
                    20
                )

            Arrow.TextXAlignment =
                Enum.TextXAlignment.Center

            ---------------------------------------------------
            -- ELEMENT HOLDER
            ---------------------------------------------------

            local Holder =
                Instance.new("Frame")

            Holder.Position =
                UDim2.fromOffset(
                    12,
                    53
                )

            Holder.Size =
                UDim2.new(
                    1,
                    -24,
                    0,
                    0
                )

            Holder.AutomaticSize =
                Enum.AutomaticSize.Y

            Holder.BackgroundTransparency =
                1

            Holder.Parent =
                Section

            local HolderLayout =
                Instance.new("UIListLayout")

            HolderLayout.Padding =
                UDim.new(
                    0,
                    8
                )

            HolderLayout.Parent =
                Holder

            local Open =
                false

            local function UpdateSize()

                local h =
                    Open and
                    (
                        58 +
                        HolderLayout.AbsoluteContentSize.Y
                    )
                    or 48

                Tween(
                    Section,
                    {
                        Size =
                            UDim2.new(
                                1,
                                -4,
                                0,
                                h
                            )
                    },
                    .25
                )

                Tween(
                    Arrow,
                    {
                        Rotation =
                            Open and 180 or 0
                    },
                    .25
                )
            end

            Header.MouseButton1Click:Connect(
                function()

                    Open = not Open

                    UpdateSize()
                end
            )

            ---------------------------------------------------
            -- BUTTON
            ---------------------------------------------------

            function SectionObject:AddButton(
                text,
                callback
            )

                local Button =
                    Instance.new("TextButton")

                Button.Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        42
                    )

                Button.BackgroundColor3 =
                    Library.Theme.Input

                Button.BorderSizePixel = 0

                Button.AutoButtonColor = false

                Button.Text = ""

                Button.Parent =
                    Holder

                Corner(
                    Button,
                    11
                )

                local BStroke =
                    Stroke(
                        Button,
                        Library.Theme.Border,
                        1,
                        .55
                    )

                local Label =
                    Text(
                        Button,
                        tostring(text),
                        11,
                        Library.Theme.Text,
                        Enum.Font.GothamMedium
                    )

                Label.Position =
                    UDim2.fromOffset(
                        14,
                        0
                    )

                Label.Size =
                    UDim2.new(
                        1,
                        -50,
                        1,
                        0
                    )

                local Arrow =
                    Text(
                        Button,
                        "›",
                        18,
                        Library.Theme.Muted,
                        Enum.Font.GothamBold
                    )

                Arrow.AnchorPoint =
                    Vector2.new(
                        1,
                        .5
                    )

                Arrow.Position =
                    UDim2.new(
                        1,
                        -12,
                        .5,
                        0
                    )

                Arrow.Size =
                    UDim2.fromOffset(
                        20,
                        22
                    )

                Arrow.TextXAlignment =
                    Enum.TextXAlignment.Center

                Button.MouseEnter:Connect(
                    function()

                        Tween(
                            Button,
                            {
                                BackgroundColor3 =
                                    Library.Theme.CardHover
                            },
                            .15
                        )

                        Tween(
                            Arrow,
                            {
                                TextColor3 =
                                    Library.Theme.Accent
                            },
                            .15
                        )
                    end
                )

                Button.MouseLeave:Connect(
                    function()

                        Tween(
                            Button,
                            {
                                BackgroundColor3 =
                                    Library.Theme.Input
                            },
                            .15
                        )

                        Tween(
                            Arrow,
                            {
                                TextColor3 =
                                    Library.Theme.Muted
                            },
                            .15
                        )
                    end
                )

                Button.MouseButton1Click:Connect(
                    function()

                        Tween(
                            Button,
                            {
                                Size =
                                    UDim2.new(
                                        1,
                                        -3,
                                        0,
                                        40
                                    )
                            },
                            .08
                        )

                        task.wait(.08)

                        Tween(
                            Button,
                            {
                                Size =
                                    UDim2.new(
                                        1,
                                        0,
                                        0,
                                        42
                                    )
                            },
                            .12
                        )

                        if callback then

                            task.spawn(
                                function()
                                    callback()
                                end
                            )
                        end
                    end
                )

                return Button
            end

            ---------------------------------------------------
            -- TOGGLE
            ---------------------------------------------------

            function SectionObject:AddToggle(
                text,
                default,
                callback
            )

                local State =
                    default == true

                local Button =
                    Instance.new("TextButton")

                Button.Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        48
                    )

                Button.BackgroundColor3 =
                    Library.Theme.Input

                Button.BorderSizePixel = 0

                Button.AutoButtonColor = false

                Button.Text = ""

                Button.Parent =
                    Holder

                Corner(
                    Button,
                    12
                )

                local Label =
                    Text(
                        Button,
                        tostring(text),
                        11,
                        Library.Theme.Text,
                        Enum.Font.GothamMedium
                    )

                Label.Position =
                    UDim2.fromOffset(
                        14,
                        0
                    )

                Label.Size =
                    UDim2.new(
                        1,
                        -75,
                        1,
                        0
                    )

                local Switch =
                    Instance.new("Frame")

                Switch.AnchorPoint =
                    Vector2.new(
                        1,
                        .5
                    )

                Switch.Position =
                    UDim2.new(
                        1,
                        -12,
                        .5,
                        0
                    )

                Switch.Size =
                    UDim2.fromOffset(
                        44,
                        24
                    )

                Switch.BackgroundColor3 =
                    State and
                    Library.Theme.Accent
                    or
                    Color3.fromRGB(
                        205,
                        207,
                        218
                    )

                Switch.BorderSizePixel = 0

                Switch.Parent =
                    Button

                Corner(
                    Switch,
                    12
                )

                local Knob =
                    Instance.new("Frame")

                Knob.AnchorPoint =
                    Vector2.new(
                        .5,
                        .5
                    )

                Knob.Position =
                    State and
                    UDim2.new(
                        1,
                        -12,
                        .5,
                        0
                    )
                    or
                    UDim2.new(
                        0,
                        12,
                        .5,
                        0
                    )

                Knob.Size =
                    UDim2.fromOffset(
                        18,
                        18
                    )

                Knob.BackgroundColor3 =
                    Color3.new(
                        1,
                        1,
                        1
                    )

                Knob.BorderSizePixel = 0

                Knob.Parent =
                    Switch

                Corner(
                    Knob,
                    9
                )

                local function Update(
                    fire
                )

                    Tween(
                        Switch,
                        {
                            BackgroundColor3 =
                                State and
                                Library.Theme.Accent
                                or
                                Color3.fromRGB(
                                    205,
                                    207,
                                    218
                                )
                        },
                        .2
                    )

                    Tween(
                        Knob,
                        {
                            Position =
                                State and
                                UDim2.new(
                                    1,
                                    -12,
                                    .5,
                                    0
                                )
                                or
                                UDim2.new(
                                    0,
                                    12,
                                    .5,
                                    0
                                )
                        },
                        .22
                    )

                    if fire and callback then
                        callback(State)
                    end
                end

                Button.MouseButton1Click:Connect(
                    function()

                        State =
                            not State

                        Update(true)
                    end
                )

                local ToggleObject = {}

                function ToggleObject:Set(
                    value
                )

                    State =
                        value == true

                    Update(false)
                end

                function ToggleObject:Get()

                    return State
                end

                return ToggleObject
            end

            ---------------------------------------------------
            -- TEXTBOX
            ---------------------------------------------------

            function SectionObject:AddTextbox(
                text,
                placeholder,
                callback
            )

                local HolderBox =
                    Instance.new("Frame")

                HolderBox.Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        72
                    )

                HolderBox.BackgroundColor3 =
                    Library.Theme.Input

                HolderBox.BorderSizePixel = 0

                HolderBox.Parent =
                    Holder

                Corner(
                    HolderBox,
                    12
                )

                local Label =
                    Text(
                        HolderBox,
                        tostring(text),
                        10,
                        Library.Theme.Muted,
                        Enum.Font.GothamBold
                    )

                Label.Position =
                    UDim2.fromOffset(
                        13,
                        7
                    )

                Label.Size =
                    UDim2.new(
                        1,
                        -26,
                        0,
                        18
                    )

                local Box =
                    Instance.new("TextBox")

                Box.Position =
                    UDim2.fromOffset(
                        10,
                        30
                    )

                Box.Size =
                    UDim2.new(
                        1,
                        -20,
                        32,
                        0
                    )

                Box.BackgroundColor3 =
                    Library.Theme.Window

                Box.BorderSizePixel = 0

                Box.Text =
                    ""

                Box.PlaceholderText =
                    placeholder or "พิมพ์ข้อความ..."

                Box.PlaceholderColor3 =
                    Library.Theme.Muted

                Box.TextColor3 =
                    Library.Theme.Text

                Box.TextSize =
                    11

                Box.Font =
                    Enum.Font.Gotham

                Box.ClearTextOnFocus =
                    false

                Box.Parent =
                    HolderBox

                Corner(
                    Box,
                    9
                )

                local BoxStroke =
                    Stroke(
                        Box,
                        Library.Theme.Border,
                        1,
                        .5
                    )

                Box.Focused:Connect(
                    function()

                        Tween(
                            BoxStroke,
                            {
                                Color =
                                    Library.Theme.Accent,

                                Transparency = 0
                            },
                            .2
                        )
                    end
                )

                Box.FocusLost:Connect(
                    function(
                        enterPressed
                    )

                        Tween(
                            BoxStroke,
                            {
                                Color =
                                    Library.Theme.Border,

                                Transparency = .5
                            },
                            .2
                        )

                        if callback then

                            callback(
                                Box.Text,
                                enterPressed
                            )
                        end
                    end
                )

                return Box
            end

            local SectionObject = {}

            ---------------------------------------------------
            -- ALIASES
            ---------------------------------------------------

            SectionObject.Button =
                SectionObject.AddButton

            SectionObject.Toggle =
                SectionObject.AddToggle

            SectionObject.Textbox =
                SectionObject.AddTextbox

            return SectionObject
        end

        -------------------------------------------------------
        -- STORE TAB
        -------------------------------------------------------

        table.insert(
            Library._Tabs,
            {
                Name = name,
                Button = TabButton,
                Icon = Icon,
                NameLabel = TabName,
                Page = Page
            }
        )

        -------------------------------------------------------
        -- FIRST TAB
        -------------------------------------------------------

        if #Library._Tabs == 1 then
            Activate()
        end

        return TabObject
    end

    -----------------------------------------------------------
    -- MINIMIZE
    -----------------------------------------------------------

    local Floating =
        Instance.new("TextButton")

    Floating.AnchorPoint =
        Vector2.new(
            .5,
            .5
        )

    Floating.Position =
        UDim2.fromScale(
            .5,
            .5
        )

    Floating.Size =
        UDim2.fromOffset(
            58,
            58
        )

    Floating.BackgroundColor3 =
        Library.Theme.Accent

    Floating.BorderSizePixel = 0

    Floating.Text =
        "N"

    Floating.TextSize =
        22

    Floating.TextColor3 =
        Color3.new(
            1,
            1,
            1
        )

    Floating.Font =
        Enum.Font.GothamBlack

    Floating.Visible =
        false

    Floating.Parent =
        Gui

    Corner(
        Floating,
        18
    )

    Gradient(
        Floating,
        Library.Theme.Accent,
        Library.Theme.Accent2
    )

    Floating.MouseButton1Click:Connect(
        function()

            Floating.Visible =
                false

            Window.Visible =
                true

            Shadow.Visible =
                true

            Library._Minimized =
                false
        end
    )

    Minimize.MouseButton1Click:Connect(
        function()

            Window.Visible =
                false

            Shadow.Visible =
                false

            Floating.Visible =
                true

            Library._Minimized =
                true
        end
    )

    -----------------------------------------------------------
    -- DRAG
    -----------------------------------------------------------

    local Dragging = false
    local DragStart
    local StartPosition

    Top.InputBegan:Connect(
        function(input)

            if
                input.UserInputType ==
                Enum.UserInputType.MouseButton1
                or
                input.UserInputType ==
                Enum.UserInputType.Touch
            then

                Dragging = true

                DragStart =
                    input.Position

                StartPosition =
                    Window.Position

                input.Changed:Connect(
                    function()

                        if
                            input.UserInputState ==
                            Enum.UserInputState.End
                        then

                            Dragging = false
                        end
                    end
                )
            end
        end
    )

    UserInputService.InputChanged:Connect(
        function(input)

            if not Dragging then
                return
            end

            if
                input.UserInputType ==
                Enum.UserInputType.MouseMovement
                or
                input.UserInputType ==
                Enum.UserInputType.Touch
            then

                local delta =
                    input.Position -
                    DragStart

                Window.Position =
                    UDim2.new(
                        StartPosition.X.Scale,
                        StartPosition.X.Offset +
                            delta.X,

                        StartPosition.Y.Scale,
                        StartPosition.Y.Offset +
                            delta.Y
                    )

                Shadow.Position =
                    Window.Position
            end
        end
    )

    -----------------------------------------------------------
    -- RIGHT SHIFT
    -----------------------------------------------------------

    UserInputService.InputBegan:Connect(
        function(input, processed)

            if processed then
                return
            end

            if
                input.KeyCode ==
                Enum.KeyCode.RightShift
            then

                if Library._Minimized then

                    Floating.Visible =
                        false

                    Window.Visible =
                        true

                    Shadow.Visible =
                        true

                    Library._Minimized =
                        false

                else

                    Window.Visible =
                        false

                    Shadow.Visible =
                        false

                    Floating.Visible =
                        true

                    Library._Minimized =
                        true
                end
            end
        end
    )

    -----------------------------------------------------------
    -- OPEN ANIMATION
    -----------------------------------------------------------

    Window.Size =
        UDim2.fromOffset(
            Size.X - 30,
            Size.Y - 30
        )

    Window.BackgroundTransparency =
        1

    Shadow.BackgroundTransparency =
        1

    Tween(
        Window,
        {
            Size =
                UDim2.fromOffset(
                    Size.X,
                    Size.Y
                ),

            BackgroundTransparency = 0
        },
        .45,
        Enum.EasingStyle.Back
    )

    Tween(
        Shadow,
        {
            BackgroundTransparency = .88
        },
        .45
    )

    -----------------------------------------------------------
    -- RETURN
    -----------------------------------------------------------

    return WindowObject
end

---------------------------------------------------------------
-- START LOADING
---------------------------------------------------------------

if Library.Settings.LoadingEnabled then

    task.spawn(
        function()

            local LoadingGui =
                Instance.new("ScreenGui")

            LoadingGui.Name =
                "NAEI_LOADING"

            LoadingGui.IgnoreGuiInset =
                true

            LoadingGui.ResetOnSpawn =
                false

            LoadingGui.ZIndexBehavior =
                Enum.ZIndexBehavior.Sibling

            LoadingGui.Parent =
                PlayerGui

            Library:CreateLoadingScreen(
                LoadingGui,
                function()

                    Library._LoadingFinished =
                        true
                end
            )
        end
    )
end

---------------------------------------------------------------
-- RETURN
---------------------------------------------------------------

return Library