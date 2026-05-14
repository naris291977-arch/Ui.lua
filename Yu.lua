-- [[ pano.lua — Complete UI Library with Loading & Language ]] --
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════════════════════
--  UI LIBRARY CORE
-- ═══════════════════════════════════════════════════════════
local Library = {
    Theme = {
        Main       = Color3.fromRGB(10, 10, 13),
        Accent     = Color3.fromRGB(99, 102, 241),
        Section    = Color3.fromRGB(20, 20, 26),
        SectionHov = Color3.fromRGB(28, 28, 36),
        Text       = Color3.fromRGB(240, 240, 248),
        SubText    = Color3.fromRGB(130, 130, 150),
        Border     = Color3.fromRGB(38, 38, 50),
        Corner     = UDim.new(0, 12)
    },
    NotifStack = 0,
    Keybind = Enum.KeyCode.RightControl,
    IsOpen = true,
    CurrentTab = nil,
    ElementsToTheme = {}
}

local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(
        t or 0.25,
        style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out
    ), props):Play()
end

local function MakeShadow(parent)
    local sh = Instance.new("ImageLabel", parent)
    sh.AnchorPoint = Vector2.new(0.5, 0.5)
    sh.BackgroundTransparency = 1
    sh.Position = UDim2.new(0.5, 0, 0.5, 8)
    sh.Size = UDim2.new(1, 40, 1, 40)
    sh.ZIndex = parent.ZIndex - 1
    sh.Image = "rbxassetid://6014261993"
    sh.ImageColor3 = Color3.fromRGB(0, 0, 0)
    sh.ImageTransparency = 0.45
    sh.ScaleType = Enum.ScaleType.Slice
    sh.SliceCenter = Rect.new(49, 49, 450, 450)
end

-- ═══════════════════════════════════════════════════════════
--  NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════
function Library:Notify(title, msg, duration)
    local Screen = game.CoreGui:FindFirstChild("PeHub_Notifs")
        or Instance.new("ScreenGui", game.CoreGui)
    Screen.Name = "PeHub_Notifs"

    local notifHeight = 68
    local gap = 10
    local bottomPadding = 14
    local finalY = -(bottomPadding + notifHeight + (self.NotifStack * (notifHeight + gap)))

    local Frame = Instance.new("Frame", Screen)
    Frame.Size = UDim2.new(0, 270, 0, notifHeight)
    Frame.Position = UDim2.new(1, 10, 1, finalY)
    Frame.BackgroundColor3 = self.Theme.Section
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 10
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    MakeShadow(Frame)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = self.Theme.Accent
    Stroke.Thickness = 1
    Stroke.Transparency = 0.6

    local AccentBar = Instance.new("Frame", Frame)
    AccentBar.Size = UDim2.new(0, 3, 1, -14)
    AccentBar.Position = UDim2.new(0, 0, 0, 7)
    AccentBar.BackgroundColor3 = self.Theme.Accent
    AccentBar.BorderSizePixel = 0
    Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(0, 4)

    local TL = Instance.new("TextLabel", Frame)
    TL.Text = title
    TL.Size = UDim2.new(1, -16, 0, 26)
    TL.Position = UDim2.new(0, 14, 0, 6)
    TL.TextColor3 = self.Theme.Accent
    TL.BackgroundTransparency = 1
    TL.TextXAlignment = Enum.TextXAlignment.Left
    TL.Font = Enum.Font.GothamBold
    TL.TextSize = 13
    TL.ZIndex = 11

    local ML = Instance.new("TextLabel", Frame)
    ML.Text = msg
    ML.Position = UDim2.new(0, 14, 0, 30)
    ML.Size = UDim2.new(1, -18, 0, 28)
    ML.TextColor3 = self.Theme.SubText
    ML.BackgroundTransparency = 1
    ML.TextXAlignment = Enum.TextXAlignment.Left
    ML.TextWrapped = true
    ML.Font = Enum.Font.Gotham
    ML.TextSize = 11
    ML.ZIndex = 11

    local Prog = Instance.new("Frame", Frame)
    Prog.Size = UDim2.new(1, 0, 0, 2)
    Prog.Position = UDim2.new(0, 0, 1, -2)
    Prog.BackgroundColor3 = self.Theme.Accent
    Prog.BorderSizePixel = 0
    Instance.new("UICorner", Prog).CornerRadius = UDim.new(0, 2)

    self.NotifStack += 1
    Frame:TweenPosition(UDim2.new(1, -280, 1, finalY), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.45)

    task.spawn(function()
        local dur = duration or 3
        local start = tick()
        while tick() - start < dur do
            Prog.Size = UDim2.new(1 - ((tick() - start) / dur), 0, 0, 2)
            task.wait()
        end
    end)
    task.delay(duration or 3, function()
        Frame:TweenPosition(UDim2.new(1, 10, 1, finalY), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.4)
        task.wait(0.4)
        Frame:Destroy()
        self.NotifStack -= 1
    end)
end

-- ═══════════════════════════════════════════════════════════
--  THEME UPDATER
-- ═══════════════════════════════════════════════════════════
function Library:UpdateTheme(newColor)
    self.Theme.Accent = newColor
    for _, obj in pairs(self.ElementsToTheme) do
        if not obj or not obj.Parent then continue end
        if obj:IsA("UIStroke") then Tween(obj, {Color = newColor})
        elseif obj:IsA("Frame") or obj:IsA("TextButton") then Tween(obj, {BackgroundColor3 = newColor})
        elseif obj:IsA("TextLabel") then Tween(obj, {TextColor3 = newColor})
        end
    end
end

-- ═══════════════════════════════════════════════════════════
--  CREATE MAIN WINDOW
-- ═══════════════════════════════════════════════════════════
function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "PeHub_Elite"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local isMobile = UserInputService.TouchEnabled
    local W = isMobile and 480 or 590
    local H = isMobile and 320 or 380

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, W, 0, H)
    Main.Position = UDim2.new(0.5, -W/2, 0.6, -H/2)
    Main.BackgroundColor3 = self.Theme.Main
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.BackgroundTransparency = 1
    Instance.new("UICorner", Main).CornerRadius = self.Theme.Corner
    MakeShadow(Main)

    Tween(Main, {BackgroundTransparency = 0, Position = UDim2.new(0.5, -W/2, 0.5, -H/2)}, 0.5, Enum.EasingStyle.Back)

    local Grad = Instance.new("UIGradient", Main)
    Grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 36)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 13))
    })
    Grad.Rotation = 135

    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = self.Theme.Accent
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.7

    local TopLine = Instance.new("Frame", Main)
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BackgroundColor3 = self.Theme.Accent
    TopLine.BorderSizePixel = 0
    table.insert(self.ElementsToTheme, TopLine)

    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundTransparency = 1

    local Dot = Instance.new("Frame", Header)
    Dot.Size = UDim2.new(0, 8, 0, 8)
    Dot.Position = UDim2.new(0, 16, 0.5, -4)
    Dot.BackgroundColor3 = self.Theme.Accent
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    table.insert(self.ElementsToTheme, Dot)

    task.spawn(function()
        while Dot and Dot.Parent do
            Tween(Dot, {BackgroundTransparency = 0.6}, 0.8)
            task.wait(0.8)
            Tween(Dot, {BackgroundTransparency = 0}, 0.8)
            task.wait(0.8)
        end
    end)

    local TitleLbl = Instance.new("TextLabel", Header)
    TitleLbl.Text = title:upper()
    TitleLbl.Size = UDim2.new(0, 300, 0, 26)
    TitleLbl.Position = UDim2.new(0, 32, 0, 8)
    TitleLbl.TextColor3 = self.Theme.Text
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 15
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.BackgroundTransparency = 1

    local MinBtn = Instance.new("TextButton", Header)
    MinBtn.Size = UDim2.new(0, 32, 0, 32)
    MinBtn.Position = UDim2.new(1, -44, 0.5, -16)
    MinBtn.BackgroundColor3 = self.Theme.Section
    MinBtn.Text = "—"
    MinBtn.TextColor3 = self.Theme.SubText
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14
    MinBtn.BorderSizePixel = 0
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundColor3 = self.Theme.Accent, TextColor3 = self.Theme.Text}) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundColor3 = self.Theme.Section, TextColor3 = self.Theme.SubText}) end)

    local MinBar = Instance.new("Frame", ScreenGui)
    MinBar.Size = UDim2.new(0, 210, 0, 38)
    MinBar.Position = UDim2.new(0.5, -105, 0, 10)
    MinBar.BackgroundColor3 = self.Theme.Section
    MinBar.BorderSizePixel = 0
    MinBar.Visible = false
    MinBar.ZIndex = 20
    Instance.new("UICorner", MinBar).CornerRadius = UDim.new(0, 10)
    MakeShadow(MinBar)

    local BarStroke = Instance.new("UIStroke", MinBar)
    BarStroke.Color = self.Theme.Accent
    BarStroke.Thickness = 1
    BarStroke.Transparency = 0.6

    local BarStrip = Instance.new("Frame", MinBar)
    BarStrip.Size = UDim2.new(0, 3, 0.7, 0)
    BarStrip.Position = UDim2.new(0, 0, 0.15, 0)
    BarStrip.BackgroundColor3 = self.Theme.Accent
    BarStrip.BorderSizePixel = 0
    Instance.new("UICorner", BarStrip).CornerRadius = UDim.new(0, 4)
    table.insert(self.ElementsToTheme, BarStrip)

    local BarIcon = Instance.new("TextLabel", MinBar)
    BarIcon.Text = "🔪"
    BarIcon.Size = UDim2.new(0, 30, 1, 0)
    BarIcon.Position = UDim2.new(0, 8, 0, 0)
    BarIcon.TextColor3 = self.Theme.Accent
    BarIcon.Font = Enum.Font.GothamBold
    BarIcon.TextSize = 14
    BarIcon.BackgroundTransparency = 1
    BarIcon.ZIndex = 21

    local BarLabel = Instance.new("TextLabel", MinBar)
    BarLabel.Text = title:upper()
    BarLabel.Size = UDim2.new(1, -72, 1, 0)
    BarLabel.Position = UDim2.new(0, 40, 0, 0)
    BarLabel.TextColor3 = self.Theme.Text
    BarLabel.Font = Enum.Font.GothamBold
    BarLabel.TextSize = 12
    BarLabel.TextXAlignment = Enum.TextXAlignment.Left
    BarLabel.BackgroundTransparency = 1
    BarLabel.ZIndex = 21

    local BarRestore = Instance.new("TextButton", MinBar)
    BarRestore.Size = UDim2.new(0, 28, 0, 28)
    BarRestore.Position = UDim2.new(1, -34, 0.5, -14)
    BarRestore.BackgroundColor3 = self.Theme.Accent
    BarRestore.Text = "▲"
    BarRestore.TextColor3 = Color3.fromRGB(255, 255, 255)
    BarRestore.Font = Enum.Font.GothamBold
    BarRestore.TextSize = 10
    BarRestore.BorderSizePixel = 0
    BarRestore.ZIndex = 22
    Instance.new("UICorner", BarRestore).CornerRadius = UDim.new(0, 6)
    table.insert(self.ElementsToTheme, BarRestore)

    local function SetMinimized(isMin)
        if isMin then
            Tween(Main, {Size = UDim2.new(0, W, 0, 0)}, 0.3)
            task.delay(0.3, function()
                Main.Visible = false
                Main.Size = UDim2.new(0, W, 0, H)
                MinBar.Visible = true
                MinBar.Position = UDim2.new(0.5, -105, 0, -40)
                Tween(MinBar, {Position = UDim2.new(0.5, -105, 0, 10)}, 0.35)
            end)
        else
            MinBar.Visible = false
            Main.Visible = true
            Main.Size = UDim2.new(0, W, 0, 0)
            Tween(Main, {Size = UDim2.new(0, W, 0, H)}, 0.35)
        end
    end

    MinBtn.MouseButton1Click:Connect(function() SetMinimized(true) end)
    BarRestore.MouseButton1Click:Connect(function() SetMinimized(false) end)

    -- Drag window
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Keybind toggle
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Library.Keybind then
            Library.IsOpen = not Library.IsOpen
            ScreenGui.Enabled = Library.IsOpen
        end
    end)

    local Divider = Instance.new("Frame", Main)
    Divider.Size = UDim2.new(1, -20, 0, 1)
    Divider.Position = UDim2.new(0, 10, 0, 50)
    Divider.BackgroundColor3 = self.Theme.Border
    Divider.BorderSizePixel = 0

    local ProfileFrame = Instance.new("Frame", Main)
    ProfileFrame.Size = UDim2.new(0, 160, 0, 44)
    ProfileFrame.Position = UDim2.new(0, 8, 1, -52)
    ProfileFrame.BackgroundColor3 = self.Theme.Section
    ProfileFrame.BackgroundTransparency = 0.3
    ProfileFrame.BorderSizePixel = 0
    Instance.new("UICorner", ProfileFrame).CornerRadius = UDim.new(0, 10)

    local AvatarImg = Instance.new("ImageLabel", ProfileFrame)
    AvatarImg.Size = UDim2.new(0, 32, 0, 32)
    AvatarImg.Position = UDim2.new(0, 6, 0.5, -16)
    AvatarImg.BackgroundColor3 = self.Theme.Border
    AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

    local NameLabel = Instance.new("TextLabel", ProfileFrame)
    NameLabel.Text = LocalPlayer.DisplayName
    NameLabel.Size = UDim2.new(1, -46, 0, 18)
    NameLabel.Position = UDim2.new(0, 44, 0, 6)
    NameLabel.TextColor3 = self.Theme.Text
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 11
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.BackgroundTransparency = 1

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 152, 1, -105)
    Sidebar.Position = UDim2.new(0, 10, 0, 58)
    Sidebar.BackgroundColor3 = self.Theme.Section
    Sidebar.BackgroundTransparency = 0.6
    Sidebar.BorderSizePixel = 0
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

    local TabHolder = Instance.new("ScrollingFrame", Sidebar)
    TabHolder.Size = UDim2.new(1, 0, 1, -10)
    TabHolder.Position = UDim2.new(0, 0, 0, 8)
    TabHolder.BackgroundTransparency = 1
    TabHolder.ScrollBarThickness = 0
    TabHolder.BorderSizePixel = 0
    local THL = Instance.new("UIListLayout", TabHolder)
    THL.Padding = UDim.new(0, 4)
    THL.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", TabHolder).PaddingLeft = UDim.new(0, 5)

    local PageHolder = Instance.new("Frame", Main)
    PageHolder.Size = UDim2.new(1, -182, 1, -115)
    PageHolder.Position = UDim2.new(0, 170, 0, 58)
    PageHolder.BackgroundTransparency = 1

    -- ========== TAB SYSTEM ==========
    local Tabs = {}

    function Tabs:AddTab(name, icon)
        icon = icon or "◈"
        local TabBtn = Instance.new("TextButton", TabHolder)
        TabBtn.Size = UDim2.new(1, -8, 0, 34)
        TabBtn.BackgroundColor3 = Library.Theme.Section
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.BorderSizePixel = 0
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        local TabInd = Instance.new("Frame", TabBtn)
        TabInd.Size = UDim2.new(0, 3, 0.6, 0)
        TabInd.Position = UDim2.new(0, 0, 0.2, 0)
        TabInd.BackgroundColor3 = Library.Theme.Accent
        TabInd.BackgroundTransparency = 1
        TabInd.BorderSizePixel = 0
        Instance.new("UICorner", TabInd).CornerRadius = UDim.new(0, 4)

        local TabIco = Instance.new("TextLabel", TabBtn)
        TabIco.Text = icon
        TabIco.Size = UDim2.new(0, 22, 1, 0)
        TabIco.Position = UDim2.new(0, 10, 0, 0)
        TabIco.TextColor3 = Library.Theme.SubText
        TabIco.Font = Enum.Font.GothamBold
        TabIco.TextSize = 13
        TabIco.BackgroundTransparency = 1

        local TabLbl = Instance.new("TextLabel", TabBtn)
        TabLbl.Text = name
        TabLbl.Size = UDim2.new(1, -36, 1, 0)
        TabLbl.Position = UDim2.new(0, 34, 0, 0)
        TabLbl.TextColor3 = Library.Theme.SubText
        TabLbl.Font = Enum.Font.GothamMedium
        TabLbl.TextSize = 12
        TabLbl.TextXAlignment = Enum.TextXAlignment.Left
        TabLbl.BackgroundTransparency = 1

        local Page = Instance.new("CanvasGroup", PageHolder)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.GroupTransparency = 1
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0

        local PageScroll = Instance.new("ScrollingFrame", Page)
        PageScroll.Size = UDim2.new(1, 0, 1, 0)
        PageScroll.BackgroundTransparency = 1
        PageScroll.ScrollBarThickness = 2
        PageScroll.ScrollBarImageColor3 = Library.Theme.Accent
        PageScroll.BorderSizePixel = 0
        local PSL = Instance.new("UIListLayout", PageScroll)
        PSL.Padding = UDim.new(0, 6)
        Instance.new("UIPadding", PageScroll).PaddingTop = UDim.new(0, 4)

        local function SetActive(active)
            if active then
                Tween(TabBtn, {BackgroundTransparency = 0.7}, 0.2)
                Tween(TabInd, {BackgroundTransparency = 0}, 0.2)
                Tween(TabIco, {TextColor3 = Library.Theme.Accent}, 0.2)
                Tween(TabLbl, {TextColor3 = Library.Theme.Text}, 0.2)
            else
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.2)
                Tween(TabInd, {BackgroundTransparency = 1}, 0.2)
                Tween(TabIco, {TextColor3 = Library.Theme.SubText}, 0.2)
                Tween(TabLbl, {TextColor3 = Library.Theme.SubText}, 0.2)
            end
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    Tween(v, {BackgroundTransparency = 1}, 0.2)
                    local ind = v:FindFirstChildWhichIsA("Frame")
                    if ind then Tween(ind, {BackgroundTransparency = 1}, 0.2) end
                    for _, lbl in pairs(v:GetChildren()) do
                        if lbl:IsA("TextLabel") then Tween(lbl, {TextColor3 = Library.Theme.SubText}, 0.2) end
                    end
                end
            end
            for _, v in pairs(PageHolder:GetChildren()) do
                if v:IsA("CanvasGroup") then
                    v.Visible = false
                    v.GroupTransparency = 1
                end
            end
            SetActive(true)
            Page.Visible = true
            Tween(Page, {GroupTransparency = 0}, 0.3)
        end)

        if not Library.CurrentTab then
            Library.CurrentTab = TabBtn
            SetActive(true)
            Page.Visible = true
            Page.GroupTransparency = 0
        end

        local function MakeBase(h)
            local f = Instance.new("Frame", PageScroll)
            f.Size = UDim2.new(1, -8, 0, h)
            f.BackgroundColor3 = Library.Theme.Section
            f.BorderSizePixel = 0
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
            local s = Instance.new("UIStroke", f)
            s.Color = Library.Theme.Border
            s.Thickness = 1
            s.Transparency = 0.5
            return f
        end

        local function MakeLabel(parent, text, xOff, yOff, wScale, h)
            local L = Instance.new("TextLabel", parent)
            L.Text = text
            L.Size = UDim2.new(wScale or 0.7, 0, 0, h or 28)
            L.Position = UDim2.new(0, xOff or 14, 0, yOff or 0)
            L.TextColor3 = Library.Theme.Text
            L.BackgroundTransparency = 1
            L.TextXAlignment = Enum.TextXAlignment.Left
            L.Font = Enum.Font.GothamMedium
            L.TextSize = 12
            return L
        end

        local Elements = {}

        function Elements:AddSection(text)
            local F = Instance.new("Frame", PageScroll)
            F.Size = UDim2.new(1, -8, 0, 22)
            F.BackgroundTransparency = 1
            local L = Instance.new("TextLabel", F)
            L.Text = ("── %s ──"):format(text:upper())
            L.Size = UDim2.new(1, 0, 1, 0)
            L.BackgroundTransparency = 1
            L.TextColor3 = Library.Theme.Accent
            L.Font = Enum.Font.GothamBold
            L.TextSize = 10
            L.TextXAlignment = Enum.TextXAlignment.Left
            table.insert(Library.ElementsToTheme, L)
        end

        function Elements:AddButton(text, callback)
            local F = MakeBase(38)
            local Btn = Instance.new("TextButton", F)
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""
            Btn.AutoButtonColor = false
            local Ico = Instance.new("TextLabel", Btn)
            Ico.Text = "▷"
            Ico.Size = UDim2.new(0, 20, 1, 0)
            Ico.Position = UDim2.new(0, 10, 0, 0)
            Ico.TextColor3 = Library.Theme.Accent
            Ico.Font = Enum.Font.GothamBold
            Ico.TextSize = 12
            Ico.BackgroundTransparency = 1
            table.insert(Library.ElementsToTheme, Ico)
            MakeLabel(Btn, text, 32, 0)
            Btn.MouseEnter:Connect(function() Tween(F, {BackgroundColor3 = Library.Theme.SectionHov}) end)
            Btn.MouseLeave:Connect(function() Tween(F, {BackgroundColor3 = Library.Theme.Section}) end)
            Btn.MouseButton1Click:Connect(function()
                Tween(F, {BackgroundColor3 = Library.Theme.Accent}, 0.1)
                task.delay(0.12, function() Tween(F, {BackgroundColor3 = Library.Theme.Section}) end)
                callback()
            end)
        end

        function Elements:AddToggle(text, default, callback)
            local F = MakeBase(40)
            MakeLabel(F, text, 14, 0, 0.65, 40)
            local Box = Instance.new("Frame", F)
            Box.Size = UDim2.new(0, 40, 0, 22)
            Box.Position = UDim2.new(1, -50, 0.5, -11)
            Box.BackgroundColor3 = default and Library.Theme.Accent or Color3.fromRGB(45, 45, 55)
            Box.BorderSizePixel = 0
            Instance.new("UICorner", Box).CornerRadius = UDim.new(1, 0)
            local Dot2 = Instance.new("Frame", Box)
            Dot2.Size = UDim2.new(0, 16, 0, 16)
            Dot2.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            Dot2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dot2.BorderSizePixel = 0
            Instance.new("UICorner", Dot2).CornerRadius = UDim.new(1, 0)
            local state = default
            local TB = Instance.new("TextButton", F)
            TB.Size = UDim2.new(1, 0, 1, 0)
            TB.BackgroundTransparency = 1
            TB.Text = ""
            TB.MouseButton1Click:Connect(function()
                state = not state
                Tween(Box, {BackgroundColor3 = state and Library.Theme.Accent or Color3.fromRGB(45, 45, 55)})
                Tween(Dot2, {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)})
                callback(state)
            end)
        end

        function Elements:AddSlider(text, min, max, default, callback)
            local F = MakeBase(54)
            local Lbl = MakeLabel(F, text .. ":  " .. default, 14, 4)
            local Track = Instance.new("Frame", F)
            Track.Size = UDim2.new(1, -28, 0, 5)
            Track.Position = UDim2.new(0, 14, 0, 34)
            Track.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            Track.BorderSizePixel = 0
            Instance.new("UICorner", Track).CornerRadius = UDim.new(0, 3)
            local Fill = Instance.new("Frame", Track)
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Library.Theme.Accent
            Fill.BorderSizePixel = 0
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 3)
            table.insert(Library.ElementsToTheme, Fill)
            local Knob = Instance.new("Frame", Track)
            Knob.Size = UDim2.new(0, 14, 0, 14)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.BorderSizePixel = 0
            Knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
            local sliding = false
            local function Update()
                local p = math.clamp((Mouse.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local val = math.round(min + (max - min) * p)
                Lbl.Text = text .. ":  " .. val
                Fill.Size = UDim2.new(p, 0, 1, 0)
                Knob.Position = UDim2.new(p, -7, 0.5, -7)
                callback(val)
            end
            Track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    Update()
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then Update() end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)
        end

        function Elements:AddDropdown(text, list, callback)
            local closed_h, open_h = 40, 40 + (#list * 32)
            local F = MakeBase(closed_h)
            F.ClipsDescendants = true
            local H2 = Instance.new("TextButton", F)
            H2.Size = UDim2.new(1, 0, 0, 40)
            H2.BackgroundTransparency = 1
            H2.Text = ""
            H2.AutoButtonColor = false
            MakeLabel(H2, text, 14, 0, 0.6, 40)
            local Arrow = Instance.new("TextLabel", H2)
            Arrow.Text = "▼"
            Arrow.Size = UDim2.new(0, 20, 0, 40)
            Arrow.Position = UDim2.new(1, -28, 0, 0)
            Arrow.TextColor3 = Library.Theme.SubText
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextSize = 10
            Arrow.BackgroundTransparency = 1
            local SelLbl = Instance.new("TextLabel", H2)
            SelLbl.Size = UDim2.new(0, 80, 0, 40)
            SelLbl.Position = UDim2.new(1, -110, 0, 0)
            SelLbl.Text = list[1] or ""
            SelLbl.TextColor3 = Library.Theme.Accent
            SelLbl.Font = Enum.Font.Gotham
            SelLbl.TextSize = 11
            SelLbl.BackgroundTransparency = 1
            SelLbl.TextXAlignment = Enum.TextXAlignment.Right
            table.insert(Library.ElementsToTheme, SelLbl)
            local open = false
            H2.MouseButton1Click:Connect(function()
                open = not open
                Tween(F, {Size = UDim2.new(1, -8, 0, open and open_h or closed_h)}, 0.25)
                Tween(Arrow, {TextColor3 = open and Library.Theme.Accent or Library.Theme.SubText}, 0.2)
            end)
            for i, v in pairs(list) do
                local iBtn = Instance.new("TextButton", F)
                iBtn.Size = UDim2.new(1, -16, 0, 28)
                iBtn.Position = UDim2.new(0, 8, 0, 40 + (i - 1) * 32 + 2)
                iBtn.BackgroundColor3 = Library.Theme.SectionHov
                iBtn.BackgroundTransparency = 0.5
                iBtn.Text = v
                iBtn.TextColor3 = Library.Theme.SubText
                iBtn.Font = Enum.Font.Gotham
                iBtn.TextSize = 11
                iBtn.BorderSizePixel = 0
                Instance.new("UICorner", iBtn).CornerRadius = UDim.new(0, 6)
                iBtn.MouseEnter:Connect(function() Tween(iBtn, {TextColor3 = Library.Theme.Text}) end)
                iBtn.MouseLeave:Connect(function() Tween(iBtn, {TextColor3 = Library.Theme.SubText}) end)
                iBtn.MouseButton1Click:Connect(function()
                    SelLbl.Text = v
                    open = false
                    Tween(F, {Size = UDim2.new(1, -8, 0, closed_h)}, 0.25)
                    callback(v)
                end)
            end
        end

        return Elements
    end

    return Tabs
end

-- ═══════════════════════════════════════════════════════════
--  LOADING + LANGUAGE SELECTOR
-- ═══════════════════════════════════════════════════════════
function Library:ShowLoadingAndLang(onDone)
    local Gui = Instance.new("ScreenGui", game.CoreGui)
    Gui.Name = "PeHub_Loader"
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local BG = Instance.new("Frame", Gui)
    BG.Size = UDim2.new(1, 0, 1, 0)
    BG.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
    BG.BorderSizePixel = 0
    BG.ZIndex = 50

    local BGGrad = Instance.new("UIGradient", BG)
    BGGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 8))
    })
    BGGrad.Rotation = 45

    -- จุดตกแต่ง
    for i = 1, 14 do
        local dot = Instance.new("Frame", BG)
        local sz = math.random(2, 5)
        dot.Size = UDim2.new(0, sz, 0, sz)
        dot.Position = UDim2.new(math.random(), 0, math.random(), 0)
        dot.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
        dot.BackgroundTransparency = math.random(40, 80) / 100
        dot.BorderSizePixel = 0
        dot.ZIndex = 51
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    end

    -- LOADING CARD
    local LoadCard = Instance.new("Frame", BG)
    LoadCard.Size = UDim2.new(0, 320, 0, 260)
    LoadCard.Position = UDim2.new(0.5, -160, 0.6, -130)
    LoadCard.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    LoadCard.BorderSizePixel = 0
    LoadCard.ZIndex = 52
    LoadCard.BackgroundTransparency = 1
    Instance.new("UICorner", LoadCard).CornerRadius = UDim.new(0, 16)
    MakeShadow(LoadCard)

    local LC_Stroke = Instance.new("UIStroke", LoadCard)
    LC_Stroke.Color = Color3.fromRGB(99, 102, 241)
    LC_Stroke.Thickness = 1
    LC_Stroke.Transparency = 0.5

    local LC_TopLine = Instance.new("Frame", LoadCard)
    LC_TopLine.Size = UDim2.new(1, 0, 0, 2)
    LC_TopLine.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
    LC_TopLine.BorderSizePixel = 0
    LC_TopLine.ZIndex = 53
    Instance.new("UICorner", LC_TopLine).CornerRadius = UDim.new(0, 2)

    local LogoFrame = Instance.new("Frame", LoadCard)
    LogoFrame.Size = UDim2.new(0, 64, 0, 64)
    LogoFrame.Position = UDim2.new(0.5, -32, 0, 20)
    LogoFrame.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
    LogoFrame.BackgroundTransparency = 0.8
    LogoFrame.BorderSizePixel = 0
    LogoFrame.ZIndex = 53
    Instance.new("UICorner", LogoFrame).CornerRadius = UDim.new(0, 16)

    local LogoIcon = Instance.new("TextLabel", LogoFrame)
    LogoIcon.Size = UDim2.new(1, 0, 1, 0)
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Text = "🔪"
    LogoIcon.TextScaled = true
    LogoIcon.ZIndex = 54

    local TitleLbl = Instance.new("TextLabel", LoadCard)
    TitleLbl.Text = "pano.lua"
    TitleLbl.Size = UDim2.new(1, 0, 0, 30)
    TitleLbl.Position = UDim2.new(0, 0, 0, 96)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.TextColor3 = Color3.fromRGB(240, 240, 248)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 22
    TitleLbl.ZIndex = 53

    local SubLbl = Instance.new("TextLabel", LoadCard)
    SubLbl.Text = "Murder Mystery Edition"
    SubLbl.Size = UDim2.new(1, 0, 0, 18)
    SubLbl.Position = UDim2.new(0, 0, 0, 128)
    SubLbl.BackgroundTransparency = 1
    SubLbl.TextColor3 = Color3.fromRGB(99, 102, 241)
    SubLbl.Font = Enum.Font.Gotham
    SubLbl.TextSize = 12
    SubLbl.ZIndex = 53

    local BarBG = Instance.new("Frame", LoadCard)
    BarBG.Size = UDim2.new(0.8, 0, 0, 5)
    BarBG.Position = UDim2.new(0.1, 0, 0, 162)
    BarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    BarBG.BorderSizePixel = 0
    BarBG.ZIndex = 53
    Instance.new("UICorner", BarBG).CornerRadius = UDim.new(0, 3)

    local BarFill = Instance.new("Frame", BarBG)
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
    BarFill.BorderSizePixel = 0
    BarFill.ZIndex = 54
    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0, 3)

    local StatusLbl = Instance.new("TextLabel", LoadCard)
    StatusLbl.Text = "Initializing..."
    StatusLbl.Size = UDim2.new(1, 0, 0, 20)
    StatusLbl.Position = UDim2.new(0, 0, 0, 175)
    StatusLbl.BackgroundTransparency = 1
    StatusLbl.TextColor3 = Color3.fromRGB(100, 100, 120)
    StatusLbl.Font = Enum.Font.Gotham
    StatusLbl.TextSize = 11
    StatusLbl.ZIndex = 53

    local VerLbl = Instance.new("TextLabel", LoadCard)
    VerLbl.Text = "v4.2 ELITE  •  by pano"
    VerLbl.Size = UDim2.new(1, 0, 0, 16)
    VerLbl.Position = UDim2.new(0, 0, 0, 232)
    VerLbl.BackgroundTransparency = 1
    VerLbl.TextColor3 = Color3.fromRGB(60, 60, 80)
    VerLbl.Font = Enum.Font.Gotham
    VerLbl.TextSize = 10
    VerLbl.ZIndex = 53

    Tween(LoadCard, {
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5, -160, 0.5, -130)
    }, 0.6, Enum.EasingStyle.Back)

    local steps = {
        {t = 0.4, text = "Initializing...", pct = 0.20},
        {t = 0.4, text = "Loading modules...", pct = 0.50},
        {t = 0.35, text = "Connecting...", pct = 0.75},
        {t = 0.3, text = "Almost ready...", pct = 0.95},
        {t = 0.25, text = "Done!", pct = 1.00},
    }

    task.spawn(function()
        task.wait(0.3)
        for _, s in ipairs(steps) do
            task.wait(s.t)
            StatusLbl.Text = s.text
            Tween(BarFill, {Size = UDim2.new(s.pct, 0, 1, 0)}, 0.3)
        end
        task.wait(0.5)

        -- LANGUAGE SELECTOR
        Tween(LoadCard, {Position = UDim2.new(-0.6, -160, 0.5, -130)}, 0.45, Enum.EasingStyle.Quart)
        task.wait(0.5)
        LoadCard.Visible = false

        local LangCard = Instance.new("Frame", BG)
        LangCard.Size = UDim2.new(0, 320, 0, 220)
        LangCard.Position = UDim2.new(1.2, 0, 0.5, -110)
        LangCard.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
        LangCard.BorderSizePixel = 0
        LangCard.ZIndex = 52
        Instance.new("UICorner", LangCard).CornerRadius = UDim.new(0, 16)
        MakeShadow(LangCard)

        local LC2_Stroke = Instance.new("UIStroke", LangCard)
        LC2_Stroke.Color = Color3.fromRGB(99, 102, 241)
        LC2_Stroke.Thickness = 1
        LC2_Stroke.Transparency = 0.5

        local LC2_TopLine = Instance.new("Frame", LangCard)
        LC2_TopLine.Size = UDim2.new(1, 0, 0, 2)
        LC2_TopLine.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
        LC2_TopLine.BorderSizePixel = 0
        LC2_TopLine.ZIndex = 53
        Instance.new("UICorner", LC2_TopLine).CornerRadius = UDim.new(0, 2)

        local GlobeLbl = Instance.new("TextLabel", LangCard)
        GlobeLbl.Text = "🌐"
        GlobeLbl.Size = UDim2.new(1, 0, 0, 40)
        GlobeLbl.Position = UDim2.new(0, 0, 0, 16)
        GlobeLbl.BackgroundTransparency = 1
        GlobeLbl.TextSize = 28
        GlobeLbl.ZIndex = 53

        local LangTitle = Instance.new("TextLabel", LangCard)
        LangTitle.Text = "Select Language"
        LangTitle.Size = UDim2.new(1, 0, 0, 24)
        LangTitle.Position = UDim2.new(0, 0, 0, 62)
        LangTitle.BackgroundTransparency = 1
        LangTitle.TextColor3 = Color3.fromRGB(240, 240, 248)
        LangTitle.Font = Enum.Font.GothamBold
        LangTitle.TextSize = 16
        LangTitle.ZIndex = 53

        local LangSub = Instance.new("TextLabel", LangCard)
        LangSub.Text = "เลือกภาษาที่ต้องการใช้งาน"
        LangSub.Size = UDim2.new(1, 0, 0, 18)
        LangSub.Position = UDim2.new(0, 0, 0, 88)
        LangSub.BackgroundTransparency = 1
        LangSub.TextColor3 = Color3.fromRGB(99, 102, 241)
        LangSub.Font = Enum.Font.Gotham
        LangSub.TextSize = 11
        LangSub.ZIndex = 53

        local Div2 = Instance.new("Frame", LangCard)
        Div2.Size = UDim2.new(0.85, 0, 0, 1)
        Div2.Position = UDim2.new(0.075, 0, 0, 114)
        Div2.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        Div2.BorderSizePixel = 0
        Div2.ZIndex = 53

        local function MakeLangBtn(text, flag, xOffset, langKey)
            local Btn = Instance.new("TextButton", LangCard)
            Btn.Size = UDim2.new(0, 120, 0, 52)
            Btn.Position = UDim2.new(0.5, xOffset, 0, 126)
            Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
            Btn.Text = ""
            Btn.BorderSizePixel = 0
            Btn.ZIndex = 54
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)

            local BStroke = Instance.new("UIStroke", Btn)
            BStroke.Color = Color3.fromRGB(60, 60, 80)
            BStroke.Thickness = 1

            local FlagLbl = Instance.new("TextLabel", Btn)
            FlagLbl.Text = flag
            FlagLbl.Size = UDim2.new(1, 0, 0, 26)
            FlagLbl.Position = UDim2.new(0, 0, 0, 4)
            FlagLbl.BackgroundTransparency = 1
            FlagLbl.TextScaled = true
            FlagLbl.ZIndex = 55

            local NameLbl = Instance.new("TextLabel", Btn)
            NameLbl.Text = text
            NameLbl.Size = UDim2.new(1, 0, 0, 18)
            NameLbl.Position = UDim2.new(0, 0, 0, 30)
            NameLbl.BackgroundTransparency = 1
            NameLbl.TextColor3 = Color3.fromRGB(170, 170, 190)
            NameLbl.Font = Enum.Font.GothamMedium
            NameLbl.TextSize = 11
            NameLbl.ZIndex = 55

            Btn.MouseEnter:Connect(function()
                Tween(Btn, {BackgroundColor3 = Color3.fromRGB(99, 102, 241)}, 0.2)
                Tween(BStroke, {Color = Color3.fromRGB(99, 102, 241)}, 0.2)
                Tween(NameLbl, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Btn, {BackgroundColor3 = Color3.fromRGB(22, 22, 30)}, 0.2)
                Tween(BStroke, {Color = Color3.fromRGB(60, 60, 80)}, 0.2)
                Tween(NameLbl, {TextColor3 = Color3.fromRGB(170, 170, 190)}, 0.2)
            end)
            Btn.MouseButton1Click:Connect(function()
                Tween(LangCard, {Position = UDim2.new(-0.6, 0, 0.5, -110)}, 0.4, Enum.EasingStyle.Quart)
                Tween(BG, {BackgroundTransparency = 1}, 0.5)
                task.wait(0.5)
                Gui:Destroy()
                if onDone then onDone(langKey) end
            end)
        end

        MakeLangBtn("ภาษาไทย", "🇹🇭", -130, "TH")
        MakeLangBtn("English", "🇺🇸", 10, "EN")

        Tween(LangCard, {Position = UDim2.new(0.5, -160, 0.5, -110)}, 0.5, Enum.EasingStyle.Back)
    end)
end

return Library
