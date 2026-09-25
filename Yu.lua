--[[
    NAEI HUB UI LIBRARY
    Cyber Glass Edition V2
    Mobile + PC Responsive
    Created by naei
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}

Library.Theme = {
    Background = Color3.fromRGB(10, 12, 18),
    Sidebar = Color3.fromRGB(15, 18, 27),
    Card = Color3.fromRGB(20, 24, 35),
    CardHover = Color3.fromRGB(29, 35, 50),

    Border = Color3.fromRGB(55, 65, 90),

    Accent = Color3.fromRGB(99, 102, 241),
    Accent2 = Color3.fromRGB(139, 92, 246),
    AccentGlow = Color3.fromRGB(129, 140, 248),

    Text = Color3.fromRGB(245, 247, 255),
    Muted = Color3.fromRGB(145, 153, 175),

    Success = Color3.fromRGB(34, 197, 94),
    Danger = Color3.fromRGB(239, 68, 68),
    Warning = Color3.fromRGB(234, 179, 8),

    Shadow = Color3.fromRGB(0, 0, 0),
}

local function tween(obj, props, duration)
    local ok, result = pcall(function()
        local t = TweenService:Create(
            obj,
            TweenInfo.new(
                duration or 0.25,
                Enum.EasingStyle.Quart,
                Enum.EasingDirection.Out
            ),
            props
        )

        t:Play()
        return t
    end)

    if ok then
        return result
    end
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Library.Theme.Border
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.3
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function padding(obj, left, right, top, bottom)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.Parent = obj
    return p
end

local function label(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextColor3 = color or Library.Theme.Text
    l.TextSize = size or 13
    l.Font = font or Enum.Font.GothamMedium
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Parent = parent
    return l
end

local function makeButton(parent, size)
    local b = Instance.new("TextButton")
    b.Size = size
    b.BackgroundColor3 = Library.Theme.Card
    b.AutoButtonColor = false
    b.Text = ""
    b.Parent = parent

    corner(b, 11)
    stroke(b, Library.Theme.Border, 1, 0.45)

    return b
end

function Library:CreateWindow(titleText, subtitleText)

    titleText = titleText or "NAEI HUB"
    subtitleText = subtitleText or "CYBER GLASS"

    local old = PlayerGui:FindFirstChild("NaeiCyberUI")
    if old then
        old:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NaeiCyberUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    Library.ScreenGui = ScreenGui

    ----------------------------------------------------------------
    -- RESPONSIVE SIZE
    ----------------------------------------------------------------

    local camera = workspace.CurrentCamera

    local function getWindowSize()
        local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)

        if viewport.X < 600 then
            return UDim2.new(1, -24, 0, math.min(430, viewport.Y - 50))
        end

        return UDim2.new(0, 690, 0, 460)
    end

    ----------------------------------------------------------------
    -- WRAPPER
    ----------------------------------------------------------------

    local Wrapper = Instance.new("Frame")
    Wrapper.Name = "Wrapper"
    Wrapper.AnchorPoint = Vector2.new(0.5, 0.5)
    Wrapper.Position = UDim2.fromScale(0.5, 0.5)
    Wrapper.Size = getWindowSize()
    Wrapper.BackgroundTransparency = 1
    Wrapper.Parent = ScreenGui

    Library.Window = Wrapper

    ----------------------------------------------------------------
    -- OUTER GLOW
    ----------------------------------------------------------------

    local Glow = Instance.new("Frame")
    Glow.Size = UDim2.new(1, 6, 1, 6)
    Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Glow.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow.BackgroundTransparency = 1
    Glow.Parent = Wrapper

    corner(Glow, 25)

    local GlowStroke = stroke(
        Glow,
        Library.Theme.AccentGlow,
        2,
        0.15
    )

    task.spawn(function()
        local time = 0

        while Glow.Parent do
            time += RunService.RenderStepped:Wait() * 2

            local alpha = (math.sin(time) + 1) / 2

            GlowStroke.Transparency =
                0.1 + alpha * 0.45
        end
    end)

    ----------------------------------------------------------------
    -- MAIN
    ----------------------------------------------------------------

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.fromScale(1, 1)
    Main.BackgroundColor3 = Library.Theme.Background
    Main.ClipsDescendants = true
    Main.Parent = Wrapper

    corner(Main, 22)
    stroke(Main, Library.Theme.Border, 1, 0.2)

    ----------------------------------------------------------------
    -- HEADER
    ----------------------------------------------------------------

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 62)
    Header.BackgroundColor3 = Library.Theme.Sidebar
    Header.BorderSizePixel = 0
    Header.Parent = Main

    corner(Header, 22)

    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, 15)
    HeaderFix.Position = UDim2.new(0, 0, 1, -15)
    HeaderFix.BackgroundColor3 = Library.Theme.Sidebar
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header

    local Title = label(
        Header,
        titleText,
        16,
        Library.Theme.Text,
        Enum.Font.GothamBold
    )

    Title.Position = UDim2.new(0, 20, 0, 9)
    Title.Size = UDim2.new(1, -125, 0, 22)
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Subtitle = label(
        Header,
        subtitleText,
        10,
        Library.Theme.AccentGlow,
        Enum.Font.GothamMedium
    )

    Subtitle.Position = UDim2.new(0, 20, 0, 32)
    Subtitle.Size = UDim2.new(1, -125, 0, 16)
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left

    ----------------------------------------------------------------
    -- HEADER BUTTON
    ----------------------------------------------------------------

    local function HeaderButton(text, color, offset)
        local b = Instance.new("TextButton")

        b.Size = UDim2.fromOffset(32, 32)
        b.Position = UDim2.new(1, offset, 0.5, -16)

        b.BackgroundColor3 = Library.Theme.Card
        b.Text = text
        b.TextColor3 = Library.Theme.Text
        b.TextSize = 15
        b.Font = Enum.Font.GothamBold

        b.AutoButtonColor = false
        b.Parent = Header

        corner(b, 9)
        stroke(b, Library.Theme.Border, 1, 0.4)

        b.MouseEnter:Connect(function()
            tween(b, {
                BackgroundColor3 = color
            })
        end)

        b.MouseLeave:Connect(function()
            tween(b, {
                BackgroundColor3 = Library.Theme.Card
            })
        end)

        return b
    end

    local Minimize = HeaderButton(
        "−",
        Library.Theme.Accent,
        -80
    )

    local Close = HeaderButton(
        "×",
        Library.Theme.Danger,
        -42
    )

    ----------------------------------------------------------------
    -- BODY
    ----------------------------------------------------------------

    local Body = Instance.new("Frame")
    Body.Size = UDim2.new(1, -20, 1, -74)
    Body.Position = UDim2.new(0, 10, 0, 68)
    Body.BackgroundTransparency = 1
    Body.Parent = Main

    ----------------------------------------------------------------
    -- SIDEBAR
    ----------------------------------------------------------------

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 175, 1, 0)
    Sidebar.BackgroundColor3 = Library.Theme.Sidebar
    Sidebar.Parent = Body

    corner(Sidebar, 15)
    stroke(Sidebar, Library.Theme.Border, 1, 0.5)

    ----------------------------------------------------------------
    -- TAB LIST
    ----------------------------------------------------------------

    local TabList = Instance.new("ScrollingFrame")

    TabList.Size = UDim2.new(1, -10, 1, -10)
    TabList.Position = UDim2.new(0, 5, 0, 5)

    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 0
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabList.CanvasSize = UDim2.new()

    TabList.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 6)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabList

    ----------------------------------------------------------------
    -- CONTENT
    ----------------------------------------------------------------

    local Content = Instance.new("Frame")

    Content.Size = UDim2.new(1, -185, 1, 0)
    Content.Position = UDim2.new(0, 185, 0, 0)

    Content.BackgroundTransparency = 1
    Content.Parent = Body

    ----------------------------------------------------------------
    -- TABLES
    ----------------------------------------------------------------

    local Pages = {}
    local Tabs = {}

    local FirstTab = true

    ----------------------------------------------------------------
    -- CREATE TAB
    ----------------------------------------------------------------

    function WindowObj_CreateTab(name, iconChar)

        iconChar = iconChar or "✦"

        local tab = Instance.new("TextButton")

        tab.Size = UDim2.new(1, 0, 0, 42)
        tab.BackgroundColor3 = Library.Theme.Sidebar
        tab.Text = ""
        tab.AutoButtonColor = false
        tab.Parent = TabList

        corner(tab, 11)

        local icon = label(
            tab,
            iconChar,
            14,
            Library.Theme.Muted,
            Enum.Font.GothamBold
        )

        icon.Size = UDim2.new(0, 38, 1, 0)
        icon.Position = UDim2.new(0, 2, 0, 0)
        icon.TextXAlignment = Enum.TextXAlignment.Center

        local text = label(
            tab,
            name,
            12,
            Library.Theme.Muted,
            Enum.Font.GothamMedium
        )

        text.Position = UDim2.new(0, 40, 0, 0)
        text.Size = UDim2.new(1, -44, 1, 0)
        text.TextXAlignment = Enum.TextXAlignment.Left

        local page = Instance.new("ScrollingFrame")

        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Library.Theme.Accent

        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.CanvasSize = UDim2.new()
        page.Visible = false

        page.Parent = Content

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 9)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page

        padding(page, 2, 7, 2, 8)

        table.insert(Pages, page)
        table.insert(Tabs, tab)

        local function activate()

            for _, p in ipairs(Pages) do
                p.Visible = false
            end

            for _, t in ipairs(Tabs) do

                t:SetAttribute("Active", false)

                tween(t, {
                    BackgroundColor3 = Library.Theme.Sidebar
                })

                for _, child in ipairs(t:GetChildren()) do

                    if child:IsA("TextLabel") then
                        tween(child, {
                            TextColor3 = Library.Theme.Muted
                        })
                    end

                end
            end

            page.Visible = true

            tab:SetAttribute("Active", true)

            tween(tab, {
                BackgroundColor3 = Library.Theme.Card
            })

            tween(icon, {
                TextColor3 = Library.Theme.Accent
            })

            tween(text, {
                TextColor3 = Library.Theme.Text
            })
        end

        tab.MouseButton1Click:Connect(activate)

        tab.MouseEnter:Connect(function()

            if not tab:GetAttribute("Active") then
                tween(tab, {
                    BackgroundColor3 = Library.Theme.Card
                })
            end

        end)

        tab.MouseLeave:Connect(function()

            if not tab:GetAttribute("Active") then
                tween(tab, {
                    BackgroundColor3 = Library.Theme.Sidebar
                })
            end

        end)

        if FirstTab then
            FirstTab = false
            activate()
        end

        local TabObject = {}

        ----------------------------------------------------------------
        -- SECTION
        ----------------------------------------------------------------

        function TabObject:AddSection(sectionTitle)

            local container = Instance.new("Frame")

            container.Size = UDim2.new(1, -4, 0, 48)
            container.BackgroundColor3 = Library.Theme.Card
            container.ClipsDescendants = true
            container.Parent = page

            corner(container, 14)
            stroke(container, Library.Theme.Border, 1, 0.45)

            local header = Instance.new("TextButton")

            header.Size = UDim2.new(1, 0, 0, 48)
            header.BackgroundTransparency = 1
            header.Text = ""
            header.Parent = container

            local title = label(
                header,
                sectionTitle,
                12,
                Library.Theme.Text,
                Enum.Font.GothamBold
            )

            title.Position = UDim2.new(0, 15, 0, 0)
            title.Size = UDim2.new(1, -45, 1, 0)
            title.TextXAlignment = Enum.TextXAlignment.Left

            local arrow = label(
                header,
                "›",
                18,
                Library.Theme.Muted,
                Enum.Font.GothamBold
            )

            arrow.Position = UDim2.new(1, -35, 0, 0)
            arrow.Size = UDim2.fromOffset(25, 48)
            arrow.TextXAlignment = Enum.TextXAlignment.Center

            local content = Instance.new("Frame")

            content.Position = UDim2.new(0, 0, 0, 48)
            content.Size = UDim2.new(1, 0, 0, 0)
            content.BackgroundTransparency = 1
            content.Parent = container

            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Padding = UDim.new(0, 7)
            contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            contentLayout.Parent = content

            padding(content, 8, 8, 5, 10)

            local opened = false

            local function updateSize()

                if opened then

                    local h =
                        48
                        + contentLayout.AbsoluteContentSize.Y
                        + 15

                    tween(
                        container,
                        {
                            Size = UDim2.new(
                                1,
                                -4,
                                0,
                                h
                            )
                        },
                        0.2
                    )

                end

            end

            contentLayout:GetPropertyChangedSignal(
                "AbsoluteContentSize"
            ):Connect(updateSize)

            header.MouseButton1Click:Connect(function()

                opened = not opened

                local height = 48

                if opened then
                    height =
                        48
                        + contentLayout.AbsoluteContentSize.Y
                        + 15
                end

                tween(
                    container,
                    {
                        Size = UDim2.new(
                            1,
                            -4,
                            0,
                            height
                        )
                    },
                    0.22
                )

                tween(
                    arrow,
                    {
                        Rotation = opened and 90 or 0
                    },
                    0.22
                )

            end)

            local Section = {}

            ----------------------------------------------------------------
            -- BUTTON
            ----------------------------------------------------------------

            function Section:AddButton(textValue, callback)

                local btn = makeButton(
                    content,
                    UDim2.new(1, 0, 0, 40)
                )

                local txt = label(
                    btn,
                    textValue,
                    12,
                    Library.Theme.Text,
                    Enum.Font.GothamMedium
                )

                txt.Position = UDim2.new(0, 13, 0, 0)
                txt.Size = UDim2.new(1, -26, 1, 0)
                txt.TextXAlignment = Enum.TextXAlignment.Left

                btn.MouseEnter:Connect(function()

                    tween(btn, {
                        BackgroundColor3 =
                            Library.Theme.CardHover
                    })

                end)

                btn.MouseLeave:Connect(function()

                    tween(btn, {
                        BackgroundColor3 =
                            Library.Theme.Sidebar
                    })

                end)

                btn.MouseButton1Click:Connect(function()

                    if callback then
                        task.spawn(function()
                            pcall(callback)
                        end)
                    end

                end)

                return btn
            end

            ----------------------------------------------------------------
            -- TOGGLE
            ----------------------------------------------------------------

            function Section:AddToggle(textValue, defaultState, callback)

                local state = defaultState == true

                local btn = makeButton(
                    content,
                    UDim2.new(1, 0, 0, 40)
                )

                local txt = label(
                    btn,
                    textValue,
                    12,
                    Library.Theme.Text,
                    Enum.Font.GothamMedium
                )

                txt.Position = UDim2.new(0, 13, 0, 0)
                txt.Size = UDim2.new(1, -65, 1, 0)
                txt.TextXAlignment = Enum.TextXAlignment.Left

                local switch = Instance.new("Frame")

                switch.Size = UDim2.fromOffset(40, 21)
                switch.Position = UDim2.new(1, -50, 0.5, -10)

                switch.BackgroundColor3 =
                    state
                    and Library.Theme.Accent
                    or Library.Theme.CardHover

                switch.Parent = btn

                corner(switch, 12)

                local dot = Instance.new("Frame")

                dot.Size = UDim2.fromOffset(15, 15)

                dot.Position =
                    state
                    and UDim2.new(1, -18, 0.5, -7)
                    or UDim2.new(0, 3, 0.5, -7)

                dot.BackgroundColor3 =
                    Library.Theme.Text

                dot.Parent = switch

                corner(dot, 8)

                local function update()

                    tween(
                        switch,
                        {
                            BackgroundColor3 =
                                state
                                and Library.Theme.Accent
                                or Library.Theme.CardHover
                        },
                        0.18
                    )

                    tween(
                        dot,
                        {
                            Position =
                                state
                                and UDim2.new(
                                    1,
                                    -18,
                                    0.5,
                                    -7
                                )
                                or UDim2.new(
                                    0,
                                    3,
                                    0.5,
                                    -7
                                )
                        },
                        0.18
                    )

                end

                btn.MouseButton1Click:Connect(function()

                    state = not state

                    update()

                    if callback then
                        task.spawn(function()
                            pcall(callback, state)
                        end)
                    end

                end)

                return btn
            end

            ----------------------------------------------------------------
            -- TEXTBOX
            ----------------------------------------------------------------

            function Section:AddTextbox(textValue, placeholder, callback)

                local frame = Instance.new("Frame")

                frame.Size =
                    UDim2.new(1, 0, 0, 42)

                frame.BackgroundColor3 =
                    Library.Theme.Sidebar

                frame.Parent = content

                corner(frame, 11)
                stroke(frame, Library.Theme.Border, 1, 0.45)

                local txt = label(
                    frame,
                    textValue,
                    11,
                    Library.Theme.Text,
                    Enum.Font.GothamMedium
                )

                txt.Position =
                    UDim2.new(0, 12, 0, 0)

                txt.Size =
                    UDim2.new(
                        0.42,
                        0,
                        1,
                        0
                    )

                txt.TextXAlignment =
                    Enum.TextXAlignment.Left

                local box = Instance.new("TextBox")

                box.Size =
                    UDim2.new(
                        0.52,
                        0,
                        0,
                        27
                    )

                box.Position =
                    UDim2.new(
                        0.46,
                        0,
                        0.5,
                        -13
                    )

                box.BackgroundColor3 =
                    Library.Theme.Card

                box.TextColor3 =
                    Library.Theme.Text

                box.PlaceholderColor3 =
                    Library.Theme.Muted

                box.PlaceholderText =
                    placeholder or "Enter..."

                box.Text = ""
                box.TextSize = 11
                box.Font = Enum.Font.Gotham
                box.ClearTextOnFocus = false
                box.Parent = frame

                corner(box, 8)
                stroke(
                    box,
                    Library.Theme.Border,
                    1,
                    0.5
                )

                padding(box, 8, 8, 0, 0)

                box.FocusLost:Connect(function(enter)

                    if callback then
                        task.spawn(function()
                            pcall(
                                callback,
                                box.Text,
                                enter
                            )
                        end)
                    end

                end)

                return frame
            end

            ----------------------------------------------------------------
            -- LABEL
            ----------------------------------------------------------------

            function Section:AddLabel(textValue)

                local l = label(
                    content,
                    textValue,
                    11,
                    Library.Theme.Muted,
                    Enum.Font.Gotham
                )

                l.Size =
                    UDim2.new(1, 0, 0, 28)

                l.TextXAlignment =
                    Enum.TextXAlignment.Left

                l.TextWrapped = true

                return l
            end

            return Section
        end

        return TabObject
    end

    ----------------------------------------------------------------
    -- NOTIFICATION
    ----------------------------------------------------------------

    local NotificationHolder = Instance.new("Frame")

    NotificationHolder.Size =
        UDim2.new(0, 290, 1, -20)

    NotificationHolder.Position =
        UDim2.new(1, -300, 0, 10)

    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.Parent = ScreenGui

    local NotificationLayout = Instance.new("UIListLayout")

    NotificationLayout.VerticalAlignment =
        Enum.VerticalAlignment.Bottom

    NotificationLayout.HorizontalAlignment =
        Enum.HorizontalAlignment.Right

    NotificationLayout.Padding =
        UDim.new(0, 8)

    NotificationLayout.Parent =
        NotificationHolder

    function Library:Notify(titleValue, description, duration)

        duration = duration or 3

        local card = Instance.new("Frame")

        card.Size =
            UDim2.new(1, 0, 0, 64)

        card.BackgroundColor3 =
            Library.Theme.Sidebar

        card.BackgroundTransparency = 0.05
        card.Parent = NotificationHolder

        corner(card, 13)
        stroke(
            card,
            Library.Theme.Accent,
            1,
            0.35
        )

        local bar = Instance.new("Frame")

        bar.Size =
            UDim2.new(0, 3, 0.65, 0)

        bar.Position =
            UDim2.new(0, 0, 0.175, 0)

        bar.BackgroundColor3 =
            Library.Theme.Accent

        bar.Parent = card

        corner(bar, 3)

        local title = label(
            card,
            titleValue,
            12,
            Library.Theme.Text,
            Enum.Font.GothamBold
        )

        title.Position =
            UDim2.new(0, 14, 0, 9)

        title.Size =
            UDim2.new(1, -20, 0, 18)

        title.TextXAlignment =
            Enum.TextXAlignment.Left

        local desc = label(
            card,
            description,
            10,
            Library.Theme.Muted,
            Enum.Font.Gotham
        )

        desc.Position =
            UDim2.new(0, 14, 0, 30)

        desc.Size =
            UDim2.new(1, -20, 0, 20)

        desc.TextXAlignment =
            Enum.TextXAlignment.Left

        card.Position =
            UDim2.new(1, 30, 0, 0)

        tween(
            card,
            {
                Position =
                    UDim2.new(0, 0, 0, 0)
            },
            0.3
        )

        task.delay(duration, function()

            if not card.Parent then
                return
            end

            tween(
                card,
                {
                    Position =
                        UDim2.new(1, 30, 0, 0),
                    BackgroundTransparency = 1
                },
                0.25
            )

            task.wait(0.3)

            if card then
                card:Destroy()
            end

        end)

    end

    -- Alias
    Library.SendNotification = Library.Notify

    ----------------------------------------------------------------
    -- MINIMIZE
    ----------------------------------------------------------------

    local minimized = false

    Minimize.MouseButton1Click:Connect(function()

        minimized = not minimized

        Body.Visible = not minimized

        local target =
            minimized
            and UDim2.new(
                Wrapper.Size.X.Scale,
                Wrapper.Size.X.Offset,
                0,
                62
            )
            or getWindowSize()

        tween(
            Wrapper,
            {
                Size = target
            },
            0.25
        )

        Minimize.Text =
            minimized and "+" or "−"

    end)

    ----------------------------------------------------------------
    -- CLOSE
    ----------------------------------------------------------------

    Close.MouseButton1Click:Connect(function()

        Library:Notify(
            "NAEI HUB",
            "UI ถูกปิดแล้ว",
            2
        )

        tween(
            Wrapper,
            {
                Size =
                    UDim2.new(
                        Wrapper.Size.X.Scale,
                        Wrapper.Size.X.Offset,
                        0,
                        0
                    )
            },
            0.22
        )

        task.wait(0.23)

        if ScreenGui then
            ScreenGui:Destroy()
        end

    end)

    ----------------------------------------------------------------
    -- RIGHT SHIFT
    ----------------------------------------------------------------

    UserInputService.InputBegan:Connect(function(input, processed)

        if processed then
            return
        end

        if input.KeyCode == Enum.KeyCode.RightShift then

            if Wrapper.Parent then
                Wrapper.Visible =
                    not Wrapper.Visible
            end

        end

    end)

    ----------------------------------------------------------------
    -- DRAG SYSTEM
    ----------------------------------------------------------------

    local dragging = false
    local dragStart
    local startPosition
    local dragInput

    Header.InputBegan:Connect(function(input)

        if
            input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch
        then

            dragging = true
            dragStart = input.Position
            startPosition = Wrapper.Position

        end

    end)

    Header.InputChanged:Connect(function(input)

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
            dragging
            and
            input == dragInput
        then

            local delta =
                input.Position - dragStart

            Wrapper.Position =
                UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset + delta.X,
                    startPosition.Y.Scale,
                    startPosition.Y.Offset + delta.Y
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

    ----------------------------------------------------------------
    -- RETURN OBJECT
    ----------------------------------------------------------------

    local Window = {}

    function Window:CreateTab(name, icon)
        return WindowObj_CreateTab(name, icon)
    end

    function Window:Notify(title, description, duration)
        Library:Notify(
            title,
            description,
            duration
        )
    end

    return Window
end

return Library