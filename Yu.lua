-- [[ pano-ui / Library.lua — v2.5 "Aurora Pro" Ultimate Visual & Engine Overhaul ]] --
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local Debris           = game:GetService("Debris")
local LocalPlayer      = Players.LocalPlayer

local Library = {
    Theme = {
        Main       = Color3.fromRGB(6, 6, 9),
        MainAlt    = Color3.fromRGB(14, 14, 20),
        Accent     = Color3.fromRGB(138, 115, 255),
        AccentAlt  = Color3.fromRGB(72, 219, 251),
        Section    = Color3.fromRGB(13, 13, 19),
        SectionHov = Color3.fromRGB(22, 22, 32),
        Text       = Color3.fromRGB(248, 248, 252),
        SubText    = Color3.fromRGB(132, 132, 158),
        Border     = Color3.fromRGB(36, 36, 50),
        Success    = Color3.fromRGB(85, 239, 156),
        Warning    = Color3.fromRGB(254, 202, 87),
        Danger     = Color3.fromRGB(255, 107, 129),
        Corner     = UDim.new(0, 16),
        Font       = Enum.Font.GothamMedium,
        FontBold   = Enum.Font.GothamBold,
    },
    NotifStack      = 0,
    Keybind         = Enum.KeyCode.RightControl,
    IsOpen          = true,
    CurrentTab      = nil,
    ElementsToTheme = {},
    _ScreenGui      = nil,
}

--══════════════════════════════════════════
-- Core helpers
--══════════════════════════════════════════
local function Tween(obj, props, t, style, dir)
    local tw = TweenService:Create(obj, TweenInfo.new(
        t     or 0.28,
        style or Enum.EasingStyle.Quint,
        dir   or Enum.EasingDirection.Out
    ), props)
    tw:Play()
    return tw
end

local function Corner(parent, r)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = r or UDim.new(0, 10)
    return c
end

local function Stroke(parent, color, thick, trans)
    local s = Instance.new("UIStroke", parent)
    s.Color        = color or Color3.fromRGB(36, 36, 50)
    s.Thickness    = thick or 1
    s.Transparency = trans or 0.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function Gradient(parent, sequence, rotation, transp)
    local g = Instance.new("UIGradient", parent)
    g.Color = sequence
    g.Rotation = rotation or 0
    if transp then g.Transparency = transp end
    return g
end

local function AccentGradient(parent, rotation)
    return Gradient(parent, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Library.Theme.Accent),
        ColorSequenceKeypoint.new(1, Library.Theme.AccentAlt),
    }), rotation or 90)
end

local function Shadow(parent, strength)
    strength = strength or 1
    local s = Instance.new("ImageLabel", parent)
    s.Name = "_Shadow"
    s.AnchorPoint = Vector2.new(0.5, 0.5)
    s.BackgroundTransparency = 1
    s.Position = UDim2.new(0.5, 0, 0.5, 6)
    s.Size = UDim2.new(1, 50 * strength, 1, 50 * strength)
    s.ZIndex = (parent.ZIndex or 1) - 1
    s.Image = "rbxassetid://6014261993"
    s.ImageColor3 = Color3.new(0, 0, 0)
    s.ImageTransparency = 0.35
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(49, 49, 450, 450)
    return s
end

local function Glow(parent, color, strength)
    local g = Instance.new("ImageLabel", parent)
    g.Name = "_Glow"
    g.AnchorPoint = Vector2.new(0.5, 0.5)
    g.BackgroundTransparency = 1
    g.Position = UDim2.new(0.5, 0, 0.5, 0)
    g.Size = UDim2.new(1, 30 * (strength or 1), 1, 30 * (strength or 1))
    g.ZIndex = (parent.ZIndex or 1) - 1
    g.Image = "rbxassetid://6014261993"
    g.ImageColor3 = color or Library.Theme.Accent
    g.ImageTransparency = 0.5
    g.ScaleType = Enum.ScaleType.Slice
    g.SliceCenter = Rect.new(49, 49, 450, 450)
    return g
end

local function Ripple(btn, color)
    btn.ClipsDescendants = true
    btn.MouseButton1Down:Connect(function(x, y)
        local ok, rel = pcall(function() return Vector2.new(x, y) - btn.AbsolutePosition end)
        if not ok then return end
        local r = Instance.new("Frame", btn)
        r.AnchorPoint = Vector2.new(0.5, 0.5)
        r.Position = UDim2.new(0, rel.X, 0, rel.Y)
        r.Size = UDim2.new(0, 0, 0, 0)
        r.BackgroundColor3 = color or Color3.new(1, 1, 1)
        r.BackgroundTransparency = 0.5
        r.BorderSizePixel = 0
        r.ZIndex = btn.ZIndex + 5
        Corner(r, UDim.new(1, 0))
        local maxSize = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.8
        Tween(r, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.55)
        Debris:AddItem(r, 0.6)
    end)
end

local function Pulse(obj, prop, a, b, dur)
    task.spawn(function()
        while obj and obj.Parent do
            Tween(obj, {[prop] = b}, dur, Enum.EasingStyle.Sine)
            task.wait(dur)
            Tween(obj, {[prop] = a}, dur, Enum.EasingStyle.Sine)
            task.wait(dur)
        end
    end)
end

--══════════════════════════════════════════
--  UpdateTheme (Dynamic Realtime Recoloring)
--══════════════════════════════════════════
function Library:UpdateTheme(newColor, newColorAlt)
    self.Theme.Accent = newColor
    if newColorAlt then self.Theme.AccentAlt = newColorAlt end
    
    for _, obj in pairs(self.ElementsToTheme) do
        if not obj or not obj.Parent then continue end
        if obj:IsA("UIStroke") then
            Tween(obj, {Color = newColor})
        elseif obj:IsA("Frame") or obj:IsA("TextButton") then
            if obj.Name == "_Indicator" or obj.Name == "_Dot" then
                Tween(obj, {BackgroundColor3 = newColor})
            end
        elseif obj:IsA("TextLabel") then
            Tween(obj, {TextColor3 = newColor})
        elseif obj:IsA("ImageLabel") then
            Tween(obj, {ImageColor3 = newColor})
        elseif obj:IsA("UIGradient") then
            obj.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, self.Theme.Accent),
                ColorSequenceKeypoint.new(1, self.Theme.AccentAlt),
            })
        end
    end
end

--══════════════════════════════════════════
--  Notify System
--══════════════════════════════════════════
local NotifIcons = { info = "ℹ", success = "✓", warning = "!", error = "✕" }
local NotifColors = {
    info    = function() return Library.Theme.Accent end,
    success = function() return Library.Theme.Success end,
    warning = function() return Library.Theme.Warning end,
    error   = function() return Library.Theme.Danger end,
}

function Library:Notify(title, msg, duration, kind)
    kind = kind or "info"
    local color = (NotifColors[kind] or NotifColors.info)()

    local Screen = game.CoreGui:FindFirstChild("_PanoNotifs")
        or Instance.new("ScreenGui", game.CoreGui)
    Screen.Name = "_PanoNotifs"
    Screen.ResetOnSpawn = false

    local H = 74; local gap = 12
    local finalY = -(16 + H + self.NotifStack * (H + gap))

    local F = Instance.new("Frame", Screen)
    F.Size = UDim2.new(0, 290, 0, H)
    F.Position = UDim2.new(1, 25, 1, finalY)
    F.BackgroundColor3 = self.Theme.Section
    F.BorderSizePixel = 0
    F.ZIndex = 100
    Corner(F, UDim.new(0, 14))
    Shadow(F, 1.2)
    Stroke(F, color, 1, 0.5)

    local IconWrap = Instance.new("Frame", F)
    IconWrap.Size = UDim2.new(0, 36, 0, 36)
    IconWrap.Position = UDim2.new(0, 12, 0, 12)
    IconWrap.BackgroundColor3 = color
    IconWrap.BackgroundTransparency = 0.8
    IconWrap.BorderSizePixel = 0
    IconWrap.ZIndex = 101
    Corner(IconWrap, UDim.new(0, 10))

    local IconLbl = Instance.new("TextLabel", IconWrap)
    IconLbl.Size = UDim2.new(1, 0, 1, 0)
    IconLbl.BackgroundTransparency = 1
    IconLbl.Text = NotifIcons[kind] or NotifIcons.info
    IconLbl.TextColor3 = color
    IconLbl.Font = self.Theme.FontBold
    IconLbl.TextSize = 16
    IconLbl.ZIndex = 102

    local TL = Instance.new("TextLabel", F)
    TL.Text = title
    TL.Size = UDim2.new(1, -62, 0, 20)
    TL.Position = UDim2.new(0, 58, 0, 12)
    TL.BackgroundTransparency = 1
    TL.TextColor3 = self.Theme.Text
    TL.TextXAlignment = Enum.TextXAlignment.Left
    TL.Font = self.Theme.FontBold
    TL.TextSize = 13
    TL.ZIndex = 101

    local ML = Instance.new("TextLabel", F)
    ML.Text = msg
    ML.Size = UDim2.new(1, -68, 0, 28)
    ML.Position = UDim2.new(0, 58, 0, 32)
    ML.BackgroundTransparency = 1
    ML.TextColor3 = self.Theme.SubText
    ML.TextXAlignment = Enum.TextXAlignment.Left
    ML.TextYAlignment = Enum.TextYAlignment.Top
    ML.TextWrapped = true
    ML.Font = self.Theme.Font
    ML.TextSize = 11
    ML.ZIndex = 101

    local ProgBG = Instance.new("Frame", F)
    ProgBG.Size = UDim2.new(1, -20, 0, 3)
    ProgBG.Position = UDim2.new(0, 10, 1, -9)
    ProgBG.BackgroundColor3 = color
    ProgBG.BackgroundTransparency = 0.85
    ProgBG.BorderSizePixel = 0
    Corner(ProgBG, UDim.new(1, 0))

    local Prog = Instance.new("Frame", ProgBG)
    Prog.Size = UDim2.new(1, 0, 1, 0)
    Prog.BackgroundColor3 = color
    Prog.BorderSizePixel = 0
    Corner(Prog, UDim.new(1, 0))

    self.NotifStack += 1
    F:TweenPosition(UDim2.new(1, -305, 1, finalY), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.5, true)

    local dur = duration or 3.5
    task.spawn(function()
        local s = tick()
        while F.Parent and tick() - s < dur do
            Prog.Size = UDim2.new(1 - (tick() - s) / dur, 0, 1, 0)
            task.wait()
        end
    end)
    task.delay(dur, function()
        if not F.Parent then return end
        F:TweenPosition(UDim2.new(1, 25, 1, finalY), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 0.35, true)
        task.wait(0.35)
        F:Destroy()
        self.NotifStack -= 1
    end)
end

--══════════════════════════════════════════
--  ShowLoadingAndLang
--══════════════════════════════════════════
function Library:ShowLoadingAndLang(langTable, onDone)
    local Gui = Instance.new("ScreenGui", game.CoreGui)
    Gui.Name = "_PanoLoader"
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local BG = Instance.new("Frame", Gui)
    BG.Size = UDim2.new(1, 0, 1, 0)
    BG.BackgroundColor3 = Color3.fromRGB(4, 4, 6)
    BG.BorderSizePixel = 0
    BG.ZIndex = 200

    for _ = 1, 25 do
        local d = Instance.new("Frame", BG)
        local sz = math.random(2, 5)
        d.Size = UDim2.new(0, sz, 0, sz)
        d.Position = UDim2.new(math.random(), 0, math.random(), 0)
        d.BackgroundColor3 = math.random() > 0.5 and self.Theme.Accent or self.Theme.AccentAlt
        d.BackgroundTransparency = math.random(40, 80) / 100
        d.BorderSizePixel = 0
        d.ZIndex = 201
        Corner(d, UDim.new(1, 0))
        Pulse(d, "BackgroundTransparency", d.BackgroundTransparency, math.clamp(d.BackgroundTransparency + 0.2, 0, 1), math.random(15, 30) / 10)
    end

    local LC = Instance.new("Frame", BG)
    LC.Size = UDim2.new(0, 340, 0, 270)
    LC.Position = UDim2.new(0.5, -170, 0.6, -135)
    LC.BackgroundColor3 = self.Theme.MainAlt
    LC.BackgroundTransparency = 1
    LC.BorderSizePixel = 0
    LC.ZIndex = 202
    Corner(LC, UDim.new(0, 20))
    Shadow(LC, 1.4)
    Glow(LC, self.Theme.Accent, 0.7)
    Stroke(LC, self.Theme.Accent, 1, 0.4)

    local LCLine = Instance.new("Frame", LC)
    LCLine.Size = UDim2.new(1, 0, 0, 3)
    LCLine.BorderSizePixel = 0
    LCLine.ZIndex = 203
    Corner(LCLine, UDim.new(1, 0))
    AccentGradient(LCLine)

    local IconFrame = Instance.new("Frame", LC)
    IconFrame.Size = UDim2.new(0, 70, 0, 70)
    IconFrame.Position = UDim2.new(0.5, -35, 0, 24)
    IconFrame.BackgroundColor3 = self.Theme.Accent
    IconFrame.BackgroundTransparency = 0.75
    IconFrame.BorderSizePixel = 0
    IconFrame.ZIndex = 203
    Corner(IconFrame, UDim.new(0, 20))
    Stroke(IconFrame, self.Theme.Accent, 1, 0.3)
    
    local IconLbl = Instance.new("TextLabel", IconFrame)
    IconLbl.Size = UDim2.new(1, 0, 1, 0)
    IconLbl.BackgroundTransparency = 1
    IconLbl.Text = "◈"
    IconLbl.TextScaled = true
    IconLbl.ZIndex = 204
    IconLbl.TextColor3 = self.Theme.Accent
    IconLbl.Font = self.Theme.FontBold
    Pulse(IconFrame, "BackgroundTransparency", 0.75, 0.55, 0.9)

    local function CardLabel(text, yPos, size, color, bold)
        local L = Instance.new("TextLabel", LC)
        L.Text = text
        L.Size = UDim2.new(1, -20, 0, size + 4)
        L.Position = UDim2.new(0, 10, 0, yPos)
        L.BackgroundTransparency = 1
        L.TextColor3 = color or self.Theme.Text
        L.Font = bold and self.Theme.FontBold or self.Theme.Font
        L.TextSize = size
        L.ZIndex = 203
        return L
    end

    CardLabel("pano-ui pro", 102, 23, self.Theme.Text, true)
    CardLabel("Advanced Glassmorphism UI", 134, 11, self.Theme.Accent, false)

    local BarBG = Instance.new("Frame", LC)
    BarBG.Size = UDim2.new(0.8, 0, 0, 6)
    BarBG.Position = UDim2.new(0.1, 0, 0, 172)
    BarBG.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    BarBG.BorderSizePixel = 0
    BarBG.ZIndex = 203
    Corner(BarBG, UDim.new(1, 0))
    
    local BarFill = Instance.new("Frame", BarBG)
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BorderSizePixel = 0
    BarFill.ZIndex = 204
    Corner(BarFill, UDim.new(1, 0))
    AccentGradient(BarFill)

    local StatusLbl = CardLabel("Initializing modules...", 188, 11, Color3.fromRGB(130, 130, 150), false)
    CardLabel("pano-ui  •  github/aurora", 244, 10, Color3.fromRGB(60, 60, 80), false)

    Tween(LC, {BackgroundTransparency = 0, Position = UDim2.new(0.5, -170, 0.5, -135)}, 0.6, Enum.EasingStyle.Back)

    task.spawn(function()
        task.wait(0.4)
        local steps = {
            {t = 0.35, text = "Loading core engines...", pct = 0.30},
            {t = 0.35, text = "Injecting UI styles...",   pct = 0.60},
            {t = 0.3,  text = "Securing workspace...",  pct = 0.85},
            {t = 0.25, text = "Ready! ✓",             pct = 1.00},
        }
        for _, s in ipairs(steps) do
            task.wait(s.t)
            StatusLbl.Text = s.text
            Tween(BarFill, {Size = UDim2.new(s.pct, 0, 1, 0)}, 0.3)
        end
        task.wait(0.4)

        Tween(LC, {Position = UDim2.new(-0.7, -170, 0.5, -135)}, 0.45, Enum.EasingStyle.Quart)
        task.wait(0.45)
        LC.Visible = false

        if not langTable then
            Tween(BG, {BackgroundTransparency = 1}, 0.4)
            task.wait(0.4)
            Gui:Destroy()
            onDone()
            return
        end

        local LG = Instance.new("Frame", BG)
        LG.Size = UDim2.new(0, 340, 0, 220)
        LG.Position = UDim2.new(1.2, 0, 0.5, -110)
        LG.BackgroundColor3 = self.Theme.MainAlt
        LG.BorderSizePixel = 0
        LG.ZIndex = 202
        Corner(LG, UDim.new(0, 20))
        Shadow(LG, 1.4)
        Glow(LG, self.Theme.Accent, 0.7)
        Stroke(LG, self.Theme.Accent, 1, 0.4)

        local LGLine = Instance.new("Frame", LG)
        LGLine.Size = UDim2.new(1, 0, 0, 3)
        LGLine.BorderSizePixel = 0
        LGLine.ZIndex = 203
        Corner(LGLine, UDim.new(1, 0))
        AccentGradient(LGLine)

        local GlobeLbl = Instance.new("TextLabel", LG)
        GlobeLbl.Text = "🌐"
        GlobeLbl.Size = UDim2.new(1, 0, 0, 40)
        GlobeLbl.Position = UDim2.new(0, 0, 0, 16)
        GlobeLbl.BackgroundTransparency = 1
        GlobeLbl.TextSize = 30
        GlobeLbl.ZIndex = 203

        local LGTitle = Instance.new("TextLabel", LG)
        LGTitle.Text = "Select Language"
        LGTitle.Size = UDim2.new(1, 0, 0, 24)
        LGTitle.Position = UDim2.new(0, 0, 0, 62)
        LGTitle.BackgroundTransparency = 1
        LGTitle.TextColor3 = self.Theme.Text
        LGTitle.Font = self.Theme.FontBold
        LGTitle.TextSize = 17
        LGTitle.ZIndex = 203

        local LGSub = Instance.new("TextLabel", LG)
        LGSub.Text = "เลือกภาษาที่ต้องการใช้งาน"
        LGSub.Size = UDim2.new(1, 0, 0, 18)
        LGSub.Position = UDim2.new(0, 0, 0, 88)
        LGSub.BackgroundTransparency = 1
        LGSub.TextColor3 = self.Theme.Accent
        LGSub.Font = self.Theme.Font
        LGSub.TextSize = 11
        LGSub.ZIndex = 203

        local function MakeLangBtn(label, flag, xOff, key)
            local Btn = Instance.new("TextButton", LG)
            Btn.Size = UDim2.new(0, 130, 0, 58)
            Btn.Position = UDim2.new(0.5, xOff, 0, 124)
            Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.BorderSizePixel = 0
            Btn.ZIndex = 204
            Corner(Btn, UDim.new(0, 14))
            local BS = Stroke(Btn, Color3.fromRGB(50, 50, 70), 1, 0.3)
            Ripple(Btn, self.Theme.Accent)

            local FL = Instance.new("TextLabel", Btn)
            FL.Text = flag
            FL.Size = UDim2.new(1, 0, 0, 26)
            FL.Position = UDim2.new(0, 0, 0, 6)
            FL.BackgroundTransparency = 1
            FL.TextScaled = true
            FL.ZIndex = 205

            local NL = Instance.new("TextLabel", Btn)
            NL.Text = label
            NL.Size = UDim2.new(1, 0, 0, 18)
            NL.Position = UDim2.new(0, 0, 0, 32)
            NL.BackgroundTransparency = 1
            NL.TextColor3 = Color3.fromRGB(180, 180, 200)
            NL.Font = self.Theme.FontBold
            NL.TextSize = 11
            NL.ZIndex = 205

            Btn.MouseEnter:Connect(function()
                Tween(Btn, {BackgroundColor3 = self.Theme.Accent}, 0.2)
                Tween(BS, {Color = self.Theme.Accent, Transparency = 0}, 0.2)
                Tween(NL, {TextColor3 = Color3.new(1,1,1)}, 0.2)
                Tween(Btn, {Size = UDim2.new(0, 134, 0, 61)}, 0.2)
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Btn, {BackgroundColor3 = Color3.fromRGB(20, 20, 28)}, 0.2)
                Tween(BS, {Color = Color3.fromRGB(50, 50, 70), Transparency = 0.3}, 0.2)
                Tween(NL, {TextColor3 = Color3.fromRGB(180, 180, 200)}, 0.2)
                Tween(Btn, {Size = UDim2.new(0, 130, 0, 58)}, 0.2)
            end)
            Btn.MouseButton1Click:Connect(function()
                Tween(LG, {Position = UDim2.new(-0.7, 0, 0.5, -110)}, 0.4, Enum.EasingStyle.Quart)
                Tween(BG, {BackgroundTransparency = 1}, 0.4)
                task.wait(0.4)
                Gui:Destroy()
                onDone(key, langTable[key])
            end)
        end

        MakeLangBtn("ภาษาไทย", "🇹🇭", -138, "TH")
        MakeLangBtn("English", "🇺🇸", 8, "EN")
        Tween(LG, {Position = UDim2.new(0.5, -170, 0.5, -110)}, 0.5, Enum.EasingStyle.Back)
    end)
end

--══════════════════════════════════════════
--  CreateWindow
--══════════════════════════════════════════
function Library:CreateWindow(title)
    local SG = Instance.new("ScreenGui", game.CoreGui)
    SG.Name = "_PanoUI"
    SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self._ScreenGui = SG

    local isMobile = UserInputService.TouchEnabled
    local W = isMobile and 520 = 640
    local H = isMobile and 350 = 420

    local Main = Instance.new("Frame", SG)
    Main.Size = UDim2.new(0, W, 0, H)
    Main.Position = UDim2.new(0.5, -W / 2, 0.6, -H / 2)
    Main.BackgroundColor3 = self.Theme.Main
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.BackgroundTransparency = 1
    Corner(Main, self.Theme.Corner)
    Shadow(Main, 1.5)
    local MainStroke = Stroke(Main, self.Theme.Accent, 1, 0.65)
    table.insert(self.ElementsToTheme, MainStroke)

    Gradient(Main, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 20, 32)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 15)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 9)),
    }), 120)

    Tween(Main, {BackgroundTransparency = 0, Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2)}, 0.5, Enum.EasingStyle.Back)

    local TopLine = Instance.new("Frame", Main)
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BorderSizePixel = 0
    TopLine.ZIndex = 5
    AccentGradient(TopLine)
    table.insert(self.ElementsToTheme, TopLine)

    -- Header
    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 56)
    Header.BackgroundTransparency = 1

    local PDot = Instance.new("Frame", Header)
    PDot.Name = "_Dot"
    PDot.Size = UDim2.new(0, 9, 0, 9)
    PDot.Position = UDim2.new(0, 18, 0.5, -4)
    PDot.BackgroundColor3 = self.Theme.Accent
    PDot.BorderSizePixel = 0
    Corner(PDot, UDim.new(1, 0))
    table.insert(self.ElementsToTheme, PDot)
    Glow(PDot, self.Theme.Accent, 0.4)
    Pulse(PDot, "BackgroundTransparency", 0, 0.5, 0.8)

    local TitleL = Instance.new("TextLabel", Header)
    TitleL.Text = title:upper()
    TitleL.Size = UDim2.new(0, 320, 0, 26)
    TitleL.Position = UDim2.new(0, 36, 0, 10)
    TitleL.TextColor3 = self.Theme.Text
    TitleL.Font = self.Theme.FontBold
    TitleL.TextSize = 16
    TitleL.TextXAlignment = Enum.TextXAlignment.Left
    TitleL.BackgroundTransparency = 1

    local SubL = Instance.new("TextLabel", Header)
    SubL.Text = "pano-ui pro  •  optimized edition"
    SubL.Size = UDim2.new(0, 240, 0, 14)
    SubL.Position = UDim2.new(0, 36, 0, 33)
    SubL.TextColor3 = self.Theme.Accent
    SubL.Font = self.Theme.Font
    SubL.TextSize = 10
    SubL.TextXAlignment = Enum.TextXAlignment.Left
    SubL.BackgroundTransparency = 1
    table.insert(self.ElementsToTheme, SubL)

    -- Window Controls (Minimize & Close)
    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Size = UDim2.new(0, 34, 0, 34)
    CloseBtn.Position = UDim2.new(1, -46, 0.5, -17)
    CloseBtn.BackgroundColor3 = self.Theme.Section
    CloseBtn.Text = "✕"
    CloseBtn.AutoButtonColor = false
    CloseBtn.TextColor3 = self.Theme.SubText
    CloseBtn.Font = self.Theme.FontBold
    CloseBtn.TextSize = 13
    CloseBtn.BorderSizePixel = 0
    CloseBtn.ZIndex = 6
    Corner(CloseBtn, UDim.new(0, 10))
    Ripple(CloseBtn, self.Theme.Danger)
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {BackgroundColor3 = self.Theme.Danger, TextColor3 = Color3.new(1,1,1)}) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {BackgroundColor3 = self.Theme.Section, TextColor3 = self.Theme.SubText}) end)
    CloseBtn.MouseButton1Click:Connect(function() SG:Destroy() end)

    local MinBtn = Instance.new("TextButton", Header)
    MinBtn.Size = UDim2.new(0, 34, 0, 34)
    MinBtn.Position = UDim2.new(1, -86, 0.5, -17)
    MinBtn.BackgroundColor3 = self.Theme.Section
    MinBtn.Text = "—"
    MinBtn.AutoButtonColor = false
    MinBtn.TextColor3 = self.Theme.SubText
    MinBtn.Font = self.Theme.FontBold
    MinBtn.TextSize = 14
    MinBtn.BorderSizePixel = 0
    MinBtn.ZIndex = 6
    Corner(MinBtn, UDim.new(0, 10))
    Ripple(MinBtn, self.Theme.Accent)
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundColor3 = self.Theme.Accent, TextColor3 = Color3.new(1,1,1)}) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundColor3 = self.Theme.Section, TextColor3 = self.Theme.SubText}) end)

    -- Minimized pill bar
    local MinBar = Instance.new("Frame", SG)
    MinBar.Size = UDim2.new(0, 230, 0, 42)
    MinBar.Position = UDim2.new(0.5, -115, 0, 10)
    MinBar.BackgroundColor3 = self.Theme.Section
    MinBar.BorderSizePixel = 0
    MinBar.Visible = false
    MinBar.ZIndex = 20
    Corner(MinBar, UDim.new(0, 14))
    Shadow(MinBar, 1)
    local MBS = Stroke(MinBar, self.Theme.Accent, 1, 0.5)
    table.insert(self.ElementsToTheme, MBS)

    local MBStrip = Instance.new("Frame", MinBar)
    MBStrip.Name = "_Indicator"
    MBStrip.Size = UDim2.new(0, 3, 0.7, 0)
    MBStrip.Position = UDim2.new(0, 0, 0.15, 0)
    MBStrip.BorderSizePixel = 0
    AccentGradient(MBStrip, 0)
    Corner(MBStrip, UDim.new(0, 4))
    table.insert(self.ElementsToTheme, MBStrip)

    local MBLabel = Instance.new("TextLabel", MinBar)
    MBLabel.Text = title:upper()
    MBLabel.Size = UDim2.new(1, -78, 1, 0)
    MBLabel.Position = UDim2.new(0, 16, 0, 0)
    MBLabel.TextColor3 = self.Theme.Text
    MBLabel.Font = self.Theme.FontBold
    MBLabel.TextSize = 12
    MBLabel.TextXAlignment = Enum.TextXAlignment.Left
    MBLabel.BackgroundTransparency = 1
    MBLabel.ZIndex = 21

    local MBRestore = Instance.new("TextButton", MinBar)
    MBRestore.Size = UDim2.new(0, 30, 0, 30)
    MBRestore.Position = UDim2.new(1, -36, 0.5, -15)
    MBRestore.BackgroundColor3 = self.Theme.Accent
    MBRestore.Text = "▲"
    MBRestore.AutoButtonColor = false
    MBRestore.TextColor3 = Color3.fromRGB(255, 255, 255)
    MBRestore.Font = self.Theme.FontBold
    MBRestore.TextSize = 11
    MBRestore.BorderSizePixel = 0
    MBRestore.ZIndex = 22
    Corner(MBRestore, UDim.new(0, 8))
    Ripple(MBRestore, Color3.new(1,1,1))
    table.insert(self.ElementsToTheme, MBRestore)

    local function SetMin(v)
        if v then
            Tween(Main, {Size = UDim2.new(0, W, 0, 0), BackgroundTransparency = 0.3}, 0.3)
            task.delay(0.3, function()
                Main.Visible = false
                Main.Size = UDim2.new(0, W, 0, H)
                Main.BackgroundTransparency = 0
                MinBar.Visible = true
                MinBar.Position = UDim2.new(0.5, -115, 0, -46)
                Tween(MinBar, {Position = UDim2.new(0.5, -115, 0, 10)}, 0.4, Enum.EasingStyle.Back)
            end)
        else
            MinBar.Visible = false
            Main.Visible = true
            Main.Size = UDim2.new(0, W, 0, 0)
            Tween(Main, {Size = UDim2.new(0, W, 0, H)}, 0.4, Enum.EasingStyle.Back)
        end
    end
    MinBtn.MouseButton1Click:Connect(function() SetMin(true) end)
    MBRestore.MouseButton1Click:Connect(function() SetMin(false) end)

    -- Dragging Handler for MinBar & Main
    local bDrag, bDragStart, bStartPos
    MinBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            bDrag = true; bDragStart = i.Position; bStartPos = MinBar.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if bDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - bDragStart
            MinBar.Position = UDim2.new(bStartPos.X.Scale, bStartPos.X.Offset + d.X, bStartPos.Y.Scale, bStartPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then bDrag = false end
    end)

    local Div = Instance.new("Frame", Main)
    Div.Size = UDim2.new(1, -24, 0, 1)
    Div.Position = UDim2.new(0, 12, 0, 56)
    Div.BackgroundColor3 = self.Theme.Border
    Div.BorderSizePixel = 0
    Div.BackgroundTransparency = 0.3

    -- Profile card
    local PF = Instance.new("Frame", Main)
    PF.Size = UDim2.new(0, 165, 0, 50)
    PF.Position = UDim2.new(0, 10, 1, -58)
    PF.BackgroundColor3 = self.Theme.Section
    PF.BackgroundTransparency = 0.15
    PF.BorderSizePixel = 0
    Corner(PF, UDim.new(0, 12))
    Stroke(PF, self.Theme.Border, 1, 0.4)

    local Av = Instance.new("ImageLabel", PF)
    Av.Size = UDim2.new(0, 36, 0, 36)
    Av.Position = UDim2.new(0, 7, 0.5, -18)
    Av.BackgroundColor3 = self.Theme.Border
    pcall(function()
        Av.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    Corner(Av, UDim.new(1, 0))
    Stroke(Av, self.Theme.Accent, 2, 0.3)

    local PN = Instance.new("TextLabel", PF)
    PN.Text = LocalPlayer.DisplayName
    PN.Size = UDim2.new(1, -50, 0, 18)
    PN.Position = UDim2.new(0, 48, 0, 8)
    PN.TextColor3 = self.Theme.Text
    PN.Font = self.Theme.FontBold
    PN.TextSize = 11
    PN.TextXAlignment = Enum.TextXAlignment.Left
    PN.BackgroundTransparency = 1
    PN.TextTruncate = Enum.TextTruncate.AtEnd

    local StatusDot = Instance.new("Frame", PF)
    StatusDot.Size = UDim2.new(0, 6, 0, 6)
    StatusDot.Position = UDim2.new(0, 48, 0, 30)
    StatusDot.BackgroundColor3 = self.Theme.Success
    StatusDot.BorderSizePixel = 0
    Corner(StatusDot, UDim.new(1, 0))
    Pulse(StatusDot, "BackgroundTransparency", 0, 0.5, 0.7)

    local PS = Instance.new("TextLabel", PF)
    PS.Text = "ONLINE V2.5"
    PS.Size = UDim2.new(1, -60, 0, 14)
    PS.Position = UDim2.new(0, 60, 0, 27)
    PS.TextColor3 = self.Theme.SubText
    PS.Font = self.Theme.Font
    PS.TextSize = 9
    PS.TextXAlignment = Enum.TextXAlignment.Left
    PS.BackgroundTransparency = 1

    -- Sidebar & Page Area
    local SB = Instance.new("Frame", Main)
    SB.Size = UDim2.new(0, 165, 1, -120)
    SB.Position = UDim2.new(0, 10, 0, 64)
    SB.BackgroundColor3 = self.Theme.Section
    SB.BackgroundTransparency = 0.5
    SB.BorderSizePixel = 0
    Corner(SB, UDim.new(0, 12))
    Stroke(SB, self.Theme.Border, 1, 0.5)

    local TabHolder = Instance.new("ScrollingFrame", SB)
    TabHolder.Size = UDim2.new(1, 0, 1, -10)
    TabHolder.Position = UDim2.new(0, 0, 0, 8)
    TabHolder.BackgroundTransparency = 1
    TabHolder.ScrollBarThickness = 0
    TabHolder.BorderSizePixel = 0
    TabHolder.CanvasSize = UDim2.new(0,0,0,0)
    TabHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local THL = Instance.new("UIListLayout", TabHolder)
    THL.Padding = UDim.new(0, 5)
    THL.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", TabHolder).PaddingLeft = UDim.new(0, 6)

    local PageHolder = Instance.new("Frame", Main)
    PageHolder.Size = UDim2.new(1, -195, 1, -128)
    PageHolder.Position = UDim2.new(0, 185, 0, 64)
    PageHolder.BackgroundTransparency = 1

    -- Header drag handler
    local drag, dragStart, dragPos
    Header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; dragStart = i.Position; dragPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            Main.Position = UDim2.new(dragPos.X.Scale, dragPos.X.Offset + d.X, dragPos.Y.Scale, dragPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == self.Keybind then
            self.IsOpen = not self.IsOpen
            SG.Enabled = self.IsOpen
        end
    end)

    local Tabs = {}

    function Tabs:AddTab(name, icon)
        icon = icon or "◈"

        local TB = Instance.new("TextButton", TabHolder)
        TB.Size = UDim2.new(1, -10, 0, 38)
        TB.BackgroundColor3 = Library.Theme.Accent
        TB.BackgroundTransparency = 1
        TB.Text = ""
        TB.AutoButtonColor = false
        TB.BorderSizePixel = 0
        Corner(TB, UDim.new(0, 10))
        Ripple(TB, Library.Theme.Accent)

        local TInd = Instance.new("Frame", TB)
        TInd.Name = "_Indicator"
        TInd.Size = UDim2.new(0, 3, 0.6, 0)
        TInd.Position = UDim2.new(0, 0, 0.2, 0)
        TInd.BackgroundTransparency = 1
        TInd.BorderSizePixel = 0
        AccentGradient(TInd, 0)
        Corner(TInd, UDim.new(0, 4))
        table.insert(Library.ElementsToTheme, TInd)

        local TIcoBG = Instance.new("Frame", TB)
        TIcoBG.Size = UDim2.new(0, 26, 0, 26)
        TIcoBG.Position = UDim2.new(0, 8, 0.5, -13)
        TIcoBG.BackgroundColor3 = Library.Theme.Accent
        TIcoBG.BackgroundTransparency = 1
        TIcoBG.BorderSizePixel = 0
        Corner(TIcoBG, UDim.new(0, 8))

        local TIco = Instance.new("TextLabel", TIcoBG)
        TIco.Text = icon
        TIco.Size = UDim2.new(1, 0, 1, 0)
        TIco.TextColor3 = Library.Theme.SubText
        TIco.Font = Library.Theme.FontBold
        TIco.TextSize = 13
        TIco.BackgroundTransparency = 1

        local TLbl = Instance.new("TextLabel", TB)
        TLbl.Text = name
        TLbl.Size = UDim2.new(1, -44, 1, 0)
        TLbl.Position = UDim2.new(0, 40, 0, 0)
        TLbl.TextColor3 = Library.Theme.SubText
        TLbl.Font = Library.Theme.FontBold
        TLbl.TextSize = 12
        TLbl.TextXAlignment = Enum.TextXAlignment.Left
        TLbl.BackgroundTransparency = 1

        local Page = Instance.new("CanvasGroup", PageHolder)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.GroupTransparency = 1
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0

        local PS2 = Instance.new("ScrollingFrame", Page)
        PS2.Size = UDim2.new(1, 0, 1, 0)
        PS2.BackgroundTransparency = 1
        PS2.ScrollBarThickness = 3
        PS2.ScrollBarImageColor3 = Library.Theme.Accent
        PS2.BorderSizePixel = 0
        PS2.CanvasSize = UDim2.new(0,0,0,0)
        PS2.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local PSL = Instance.new("UIListLayout", PS2)
        PSL.Padding = UDim.new(0, 8)
        Instance.new("UIPadding", PS2).PaddingTop = UDim.new(0, 4)

        local function SetActive(on)
            if on then
                Tween(TB, {BackgroundTransparency = 0.85}, 0.2)
                Tween(TInd, {BackgroundTransparency = 0}, 0.2)
                Tween(TIcoBG, {BackgroundTransparency = 0.75}, 0.2)
                Tween(TIco, {TextColor3 = Library.Theme.Accent}, 0.2)
                Tween(TLbl, {TextColor3 = Library.Theme.Text}, 0.2)
            else
                Tween(TB, {BackgroundTransparency = 1}, 0.2)
                Tween(TInd, {BackgroundTransparency = 1}, 0.2)
                Tween(TIcoBG, {BackgroundTransparency = 1}, 0.2)
                Tween(TIco, {TextColor3 = Library.Theme.SubText}, 0.2)
                Tween(TLbl, {TextColor3 = Library.Theme.SubText}, 0.2)
            end
        end

        TB.MouseButton1Click:Connect(function()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    Tween(v, {BackgroundTransparency = 1}, 0.2)
                    local ind = v:FindFirstChildWhichIsA("Frame")
                    if ind then Tween(ind, {BackgroundTransparency = 1}, 0.2) end
                    for _, l in pairs(v:GetDescendants()) do
                        if l:IsA("TextLabel") then Tween(l, {TextColor3 = Library.Theme.SubText}, 0.2) end
                        if l:IsA("Frame") and l.Name ~= "_Shadow" and l.Name ~= "_Glow" then Tween(l, {BackgroundTransparency = 1}, 0.2) end
                    end
                end
            end
            for _, v in pairs(PageHolder:GetChildren()) do
                if v:IsA("CanvasGroup") then v.Visible = false; v.GroupTransparency = 1 end
            end
            SetActive(true)
            Page.Visible = true
            Tween(Page, {GroupTransparency = 0}, 0.3)
        end)

        if not Library.CurrentTab then
            Library.CurrentTab = TB
            SetActive(true)
            Page.Visible = true
            Page.GroupTransparency = 0
        end

        local function Base(h)
            local f = Instance.new("Frame", PS2)
            f.Size = UDim2.new(1, -8, 0, h)
            f.BackgroundColor3 = Library.Theme.Section
            f.BackgroundTransparency = 0.15
            f.BorderSizePixel = 0
            f.ClipsDescendants = true
            Corner(f, UDim.new(0, 10))
            Stroke(f, Library.Theme.Border, 1, 0.5)
            return f
        end

        local function Lbl(parent, text, x, y, w, h2)
            local L = Instance.new("TextLabel", parent)
            L.Text = text
            L.Size = UDim2.new(w or 0.7, 0, 0, h2 or 30)
            L.Position = UDim2.new(0, x or 14, 0, y or 0)
            L.TextColor3 = Library.Theme.Text
            L.BackgroundTransparency = 1
            L.TextXAlignment = Enum.TextXAlignment.Left
            L.Font = Library.Theme.Font
            L.TextSize = 12
            return L
        end

        local Elements = {}

        function Elements:AddSection(text)
            local F = Instance.new("Frame", PS2)
            F.Size = UDim2.new(1, -8, 0, 26)
            F.BackgroundTransparency = 1

            local Dot = Instance.new("Frame", F)
            Dot.Name = "_Dot"
            Dot.Size = UDim2.new(0, 5, 0, 5)
            Dot.Position = UDim2.new(0, 2, 0.5, -2)
            Dot.BorderSizePixel = 0
            Dot.BackgroundColor3 = Library.Theme.Accent
            Corner(Dot, UDim.new(1, 0))
            table.insert(Library.ElementsToTheme, Dot)

            local L = Instance.new("TextLabel", F)
            L.Text = text:upper()
            L.Size = UDim2.new(1, -16, 1, 0)
            L.Position = UDim2.new(0, 14, 0, 0)
            L.BackgroundTransparency = 1
            L.TextColor3 = Library.Theme.Accent
            L.Font = Library.Theme.FontBold
            L.TextSize = 10
            L.TextXAlignment = Enum.TextXAlignment.Left
            table.insert(Library.ElementsToTheme, L)

            local Line = Instance.new("Frame", F)
            Line.Size = UDim2.new(1, -16 - L.TextBounds.X - 10, 0, 1)
            Line.AnchorPoint = Vector2.new(1, 0.5)
            Line.Position = UDim2.new(1, 0, 0.5, 0)
            Line.BackgroundColor3 = Library.Theme.Border
            Line.BorderSizePixel = 0
        end

        function Elements:AddButton(text, callback)
            local F = Base(40)
            local Btn = Instance.new("TextButton", F)
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Ripple(Btn, Library.Theme.Accent)

            local Ico = Instance.new("TextLabel", Btn)
            Ico.Text = "▷"
            Ico.Size = UDim2.new(0, 22, 1, 0)
            Ico.Position = UDim2.new(0, 12, 0, 0)
            Ico.TextColor3 = Library.Theme.Accent
            Ico.Font = Library.Theme.FontBold
            Ico.TextSize = 12
            Ico.BackgroundTransparency = 1
            table.insert(Library.ElementsToTheme, Ico)
            Lbl(Btn, text, 34, 0)

            Btn.MouseEnter:Connect(function()
                Tween(F, {BackgroundColor3 = Library.Theme.SectionHov, BackgroundTransparency = 0}, 0.18)
                Tween(Ico, {Position = UDim2.new(0, 16, 0, 0)}, 0.18)
            end)
            Btn.MouseLeave:Connect(function()
                Tween(F, {BackgroundColor3 = Library.Theme.Section, BackgroundTransparency = 0.15}, 0.18)
                Tween(Ico, {Position = UDim2.new(0, 12, 0, 0)}, 0.18)
            end)
            Btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        function Elements:AddToggle(text, default, callback)
            local F = Base(42)
            Lbl(F, text, 14, 0, 0.6, 42)

            local Box = Instance.new("Frame", F)
            Box.Size = UDim2.new(0, 42, 0, 24)
            Box.Position = UDim2.new(1, -54, 0.5, -12)
            Box.BackgroundColor3 = default and Library.Theme.Accent or Color3.fromRGB(36, 36, 48)
            Box.BorderSizePixel = 0
            Corner(Box, UDim.new(1, 0))
            table.insert(Library.ElementsToTheme, Box)

            local Dot2 = Instance.new("Frame", Box)
            Dot2.Size = UDim2.new(0, 18, 0, 18)
            Dot2.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            Dot2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dot2.BorderSizePixel = 0
            Corner(Dot2, UDim.new(1, 0))

            local state = default
            local TB2 = Instance.new("TextButton", F)
            TB2.Size = UDim2.new(1, 0, 1, 0)
            TB2.BackgroundTransparency = 1
            TB2.Text = ""
            TB2.MouseButton1Click:Connect(function()
                state = not state
                Tween(Box, {BackgroundColor3 = state and Library.Theme.Accent or Color3.fromRGB(36, 36, 48)}, 0.2)
                Tween(Dot2, {Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}, 0.2, Enum.EasingStyle.Back)
                pcall(callback, state)
            end)
        end

        function Elements:AddSlider(text, min, max, default, callback)
            local F = Base(64)
            local SLbl = Lbl(F, text, 14, 6, 0.6)

            local ValBubble = Instance.new("Frame", F)
            ValBubble.Size = UDim2.new(0, 44, 0, 20)
            ValBubble.AnchorPoint = Vector2.new(1, 0)
            ValBubble.Position = UDim2.new(1, -12, 0, 6)
            ValBubble.BackgroundColor3 = Library.Theme.Accent
            ValBubble.BackgroundTransparency = 0.8
            ValBubble.BorderSizePixel = 0
            Corner(ValBubble, UDim.new(0, 6))
            
            local ValLbl = Instance.new("TextLabel", ValBubble)
            ValLbl.Size = UDim2.new(1, 0, 1, 0)
            ValLbl.BackgroundTransparency = 1
            ValLbl.Text = tostring(default)
            ValLbl.TextColor3 = Library.Theme.Accent
            ValLbl.Font = Library.Theme.FontBold
            ValLbl.TextSize = 11

            local Track = Instance.new("Frame", F)
            Track.Size = UDim2.new(1, -28, 0, 6)
            Track.Position = UDim2.new(0, 14, 0, 40)
            Track.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            Track.BorderSizePixel = 0
            Corner(Track, UDim.new(1, 0))

            local Fill = Instance.new("Frame", Track)
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BorderSizePixel = 0
            AccentGradient(Fill, 0)
            Corner(Fill, UDim.new(1, 0))

            local Knob = Instance.new("Frame", Track)
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.AnchorPoint = Vector2.new(0.5, 0.5)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.BorderSizePixel = 0
            Knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
            Corner(Knob, UDim.new(1, 0))
            local KnobStroke = Stroke(Knob, Library.Theme.Accent, 2, 0)
            table.insert(Library.ElementsToTheme, KnobStroke)

            local sliding = false
            local function UpdateFromX(x)
                local p = math.clamp((x - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local val = math.round(min + (max - min) * p)
                ValLbl.Text = tostring(val)
                Fill.Size = UDim2.new(p, 0, 1, 0)
                Knob.Position = UDim2.new(p, 0, 0.5, 0)
                pcall(callback, val)
            end

            Track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    Tween(Knob, {Size = UDim2.new(0, 20, 0, 20)}, 0.15)
                    UpdateFromX(i.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if not sliding then return end
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    UpdateFromX(i.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    if sliding then Tween(Knob, {Size = UDim2.new(0, 16, 0, 16)}, 0.15) end
                    sliding = false
                end
            end)
        end

        function Elements:AddDropdown(text, list, callback)
            local cH, oH = 42, 42 + (#list * 32) + 6
            local F = Base(cH)
            F.ClipsDescendants = true

            local H2 = Instance.new("TextButton", F)
            H2.Size = UDim2.new(1, 0, 0, 42)
            H2.BackgroundTransparency = 1
            H2.Text = ""
            H2.AutoButtonColor = false
            Lbl(H2, text, 14, 0, 0.55, 42)

            local Arr = Instance.new("TextLabel", H2)
            Arr.Text = "▼"
            Arr.Size = UDim2.new(0, 20, 0, 42)
            Arr.Position = UDim2.new(1, -30, 0, 0)
            Arr.TextColor3 = Library.Theme.SubText
            Arr.Font = Library.Theme.FontBold
            Arr.TextSize = 10
            Arr.BackgroundTransparency = 1

            local SelL = Instance.new("TextLabel", H2)
            SelL.Size = UDim2.new(0, 100, 0, 42)
            SelL.Position = UDim2.new(1, -132, 0, 0)
            SelL.Text = list[1] or ""
            SelL.TextColor3 = Library.Theme.Accent
            SelL.Font = Library.Theme.FontBold
            SelL.TextSize = 11
            SelL.BackgroundTransparency = 1
            SelL.TextXAlignment = Enum.TextXAlignment.Right
            table.insert(Library.ElementsToTheme, SelL)

            local open = false
            H2.MouseButton1Click:Connect(function()
                open = not open
                Tween(F, {Size = UDim2.new(1, -8, 0, open and oH or cH)}, 0.28)
                Tween(Arr, {TextColor3 = open and Library.Theme.Accent or Library.Theme.SubText, Rotation = open and 180 or 0}, 0.25)
            end)

            for i, v in pairs(list) do
                local iB = Instance.new("TextButton", F)
                iB.Size = UDim2.new(1, -16, 0, 28)
                iB.Position = UDim2.new(0, 8, 0, 42 + (i - 1) * 32 + 4)
                iB.BackgroundColor3 = Library.Theme.SectionHov
                iB.BackgroundTransparency = 0.4
                iB.AutoButtonColor = false
                iB.Text = ""
                iB.BorderSizePixel = 0
                Corner(iB, UDim.new(0, 7))
                Ripple(iB, Library.Theme.Accent)

                local iL = Instance.new("TextLabel", iB)
                iL.Text = v
                iL.Size = UDim2.new(1, -14, 1, 0)
                iL.Position = UDim2.new(0, 10, 0, 0)
                iL.BackgroundTransparency = 1
                iL.TextColor3 = Library.Theme.SubText
                iL.Font = Library.Theme.Font
                iL.TextSize = 11
                iL.TextXAlignment = Enum.TextXAlignment.Left

                iB.MouseEnter:Connect(function() Tween(iL, {TextColor3 = Library.Theme.Text}, 0.15) end)
                iB.MouseLeave:Connect(function() Tween(iL, {TextColor3 = Library.Theme.SubText}, 0.15) end)
                iB.MouseButton1Click:Connect(function()
                    SelL.Text = v
                    open = false
                    Tween(F, {Size = UDim2.new(1, -8, 0, cH)}, 0.28)
                    Tween(Arr, {Rotation = 0}, 0.25)
                    pcall(callback, v)
                end)
            end
        end

        function Elements:AddLabel(text)
            local F = Base(34)
            local L = Instance.new("TextLabel", F)
            L.Text = text
            L.Size = UDim2.new(1, -24, 1, 0)
            L.Position = UDim2.new(0, 14, 0, 0)
            L.BackgroundTransparency = 1
            L.TextColor3 = Library.Theme.SubText
            L.Font = Library.Theme.Font
            L.TextSize = 11
            L.TextXAlignment = Enum.TextXAlignment.Left
            L.TextWrapped = true
            return L
        end

        function Elements:AddInput(text, placeholder, callback)
            local F = Base(64)
            Lbl(F, text, 14, 6, 0.7)

            local Box = Instance.new("Frame", F)
            Box.Size = UDim2.new(1, -28, 0, 30)
            Box.Position = UDim2.new(0, 14, 0, 28)
            Box.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
            Box.BorderSizePixel = 0
            Corner(Box, UDim.new(0, 8))
            local BoxStroke = Stroke(Box, Library.Theme.Border, 1, 0.4)

            local TBox = Instance.new("TextBox", Box)
            TBox.Size = UDim2.new(1, -20, 1, 0)
            TBox.Position = UDim2.new(0, 10, 0, 0)
            TBox.BackgroundTransparency = 1
            TBox.Text = ""
            TBox.PlaceholderText = placeholder or ""
            TBox.PlaceholderColor3 = Library.Theme.SubText
            TBox.TextColor3 = Library.Theme.Text
            TBox.Font = Library.Theme.Font
            TBox.TextSize = 12
            TBox.TextXAlignment = Enum.TextXAlignment.Left
            TBox.ClearTextOnFocus = false

            TBox.Focused:Connect(function() Tween(BoxStroke, {Color = Library.Theme.Accent, Transparency = 0}, 0.2) end)
            TBox.FocusLost:Connect(function(enter)
                Tween(BoxStroke, {Color = Library.Theme.Border, Transparency = 0.4}, 0.2)
                pcall(callback, TBox.Text, enter)
            end)
        end

        return Elements
    end

    return Tabs
end

return Library
