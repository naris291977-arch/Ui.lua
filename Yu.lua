-- [[ pano-ui / Library.lua ]] --
-- https://github.com/yourname/pano-ui
--
-- USAGE:
--   local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/.../Library.lua"))()
--   local Win = Library:CreateWindow("My Hub")
--   local Tab = Win:AddTab("Combat", "⚔")
--   Tab:AddToggle("Kill Aura", false, function(v) print(v) end)
--   Library:Notify("Title", "Message", 3)

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer
local Mouse            = LocalPlayer:GetMouse()

-- ══════════════════════════════════
--  Core
-- ══════════════════════════════════
local Library = {
    Theme = {
        Main       = Color3.fromRGB(10, 10, 13),
        Accent     = Color3.fromRGB(99, 102, 241),
        Section    = Color3.fromRGB(20, 20, 26),
        SectionHov = Color3.fromRGB(28, 28, 36),
        Text       = Color3.fromRGB(240, 240, 248),
        SubText    = Color3.fromRGB(130, 130, 150),
        Border     = Color3.fromRGB(38, 38, 50),
        Corner     = UDim.new(0, 12),
    },
    NotifStack      = 0,
    Keybind         = Enum.KeyCode.RightControl,
    IsOpen          = true,
    CurrentTab      = nil,
    ElementsToTheme = {},
    _ScreenGui      = nil,
}

-- ──────────────────────────────────
--  Internal Helpers
-- ──────────────────────────────────
local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(
        t     or 0.25,
        style or Enum.EasingStyle.Quart,
        dir   or Enum.EasingDirection.Out
    ), props):Play()
end

local function Shadow(parent)
    local s = Instance.new("ImageLabel", parent)
    s.Name               = "_Shadow"
    s.AnchorPoint        = Vector2.new(0.5, 0.5)
    s.BackgroundTransparency = 1
    s.Position           = UDim2.new(0.5, 0, 0.5, 8)
    s.Size               = UDim2.new(1, 40, 1, 40)
    s.ZIndex             = parent.ZIndex - 1
    s.Image              = "rbxassetid://6014261993"
    s.ImageColor3        = Color3.new(0, 0, 0)
    s.ImageTransparency  = 0.45
    s.ScaleType          = Enum.ScaleType.Slice
    s.SliceCenter        = Rect.new(49, 49, 450, 450)
    return s
end

local function Corner(parent, r)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = r or UDim.new(0, 8)
    return c
end

local function Stroke(parent, color, thick, trans)
    local s = Instance.new("UIStroke", parent)
    s.Color        = color or Color3.fromRGB(38, 38, 50)
    s.Thickness    = thick or 1
    s.Transparency = trans or 0.5
    return s
end

-- ══════════════════════════════════
--  Library:UpdateTheme(color)
--  เปลี่ยนสี Accent ทั้ง UI
-- ══════════════════════════════════
function Library:UpdateTheme(newColor)
    self.Theme.Accent = newColor
    for _, obj in pairs(self.ElementsToTheme) do
        if not obj or not obj.Parent then continue end
        if     obj:IsA("UIStroke")   then Tween(obj, {Color           = newColor})
        elseif obj:IsA("Frame")
            or obj:IsA("TextButton") then Tween(obj, {BackgroundColor3 = newColor})
        elseif obj:IsA("TextLabel")  then Tween(obj, {TextColor3       = newColor})
        end
    end
end

-- ══════════════════════════════════
--  Library:Notify(title, msg, dur)
--  แจ้งเตือนมุมขวาล่าง
-- ══════════════════════════════════
function Library:Notify(title, msg, duration)
    local Screen = game.CoreGui:FindFirstChild("_PanoNotifs")
        or Instance.new("ScreenGui", game.CoreGui)
    Screen.Name = "_PanoNotifs"

    local H   = 68
    local gap = 10
    local finalY = -(14 + H + self.NotifStack * (H + gap))

    -- Frame
    local F = Instance.new("Frame", Screen)
    F.Size             = UDim2.new(0, 270, 0, H)
    F.Position         = UDim2.new(1, 10, 1, finalY)
    F.BackgroundColor3 = self.Theme.Section
    F.BorderSizePixel  = 0
    F.ZIndex           = 100
    Corner(F, UDim.new(0, 10))
    Shadow(F)
    Stroke(F, self.Theme.Accent, 1, 0.6)

    -- Accent bar
    local Bar = Instance.new("Frame", F)
    Bar.Size             = UDim2.new(0, 3, 1, -14)
    Bar.Position         = UDim2.new(0, 0, 0, 7)
    Bar.BackgroundColor3 = self.Theme.Accent
    Bar.BorderSizePixel  = 0
    Corner(Bar, UDim.new(0, 4))

    -- Title
    local TL = Instance.new("TextLabel", F)
    TL.Text              = title
    TL.Size              = UDim2.new(1, -16, 0, 26)
    TL.Position          = UDim2.new(0, 14, 0, 6)
    TL.BackgroundTransparency = 1
    TL.TextColor3        = self.Theme.Accent
    TL.TextXAlignment    = Enum.TextXAlignment.Left
    TL.Font              = Enum.Font.GothamBold
    TL.TextSize          = 13
    TL.ZIndex            = 101

    -- Message
    local ML = Instance.new("TextLabel", F)
    ML.Text              = msg
    ML.Size              = UDim2.new(1, -18, 0, 28)
    ML.Position          = UDim2.new(0, 14, 0, 30)
    ML.BackgroundTransparency = 1
    ML.TextColor3        = self.Theme.SubText
    ML.TextXAlignment    = Enum.TextXAlignment.Left
    ML.TextWrapped       = true
    ML.Font              = Enum.Font.Gotham
    ML.TextSize          = 11
    ML.ZIndex            = 101

    -- Progress bar
    local Prog = Instance.new("Frame", F)
    Prog.Size             = UDim2.new(1, 0, 0, 2)
    Prog.Position         = UDim2.new(0, 0, 1, -2)
    Prog.BackgroundColor3 = self.Theme.Accent
    Prog.BorderSizePixel  = 0
    Corner(Prog, UDim.new(0, 2))

    self.NotifStack += 1
    F:TweenPosition(UDim2.new(1, -280, 1, finalY),
        Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.45)

    local dur = duration or 3
    task.spawn(function()
        local s = tick()
        while tick() - s < dur do
            Prog.Size = UDim2.new(1 - (tick()-s)/dur, 0, 0, 2)
            task.wait()
        end
    end)
    task.delay(dur, function()
        F:TweenPosition(UDim2.new(1, 10, 1, finalY),
            Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.4)
        task.wait(0.4)
        F:Destroy()
        self.NotifStack -= 1
    end)
end

-- ══════════════════════════════════
--  Library:ShowLoadingAndLang(cb)
--  Loading screen → เลือกภาษา → cb()
-- ══════════════════════════════════
function Library:ShowLoadingAndLang(langTable, onDone)
    -- langTable = { TH = {...}, EN = {...} }  (optional)
    -- ถ้าไม่ส่งมาจะ skip หน้าภาษาแล้วเรียก onDone() เลย
    local Gui = Instance.new("ScreenGui", game.CoreGui)
    Gui.Name = "_PanoLoader"
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local BG = Instance.new("Frame", Gui)
    BG.Size = UDim2.new(1,0,1,0)
    BG.BackgroundColor3 = Color3.fromRGB(6,6,8)
    BG.BorderSizePixel  = 0
    BG.ZIndex           = 200

    -- Deco dots
    for _ = 1, 14 do
        local d = Instance.new("Frame", BG)
        local sz = math.random(2, 5)
        d.Size = UDim2.new(0,sz,0,sz)
        d.Position = UDim2.new(math.random(), 0, math.random(), 0)
        d.BackgroundColor3 = self.Theme.Accent
        d.BackgroundTransparency = math.random(40,80)/100
        d.BorderSizePixel = 0
        d.ZIndex = 201
        Corner(d, UDim.new(1,0))
    end

    -- ── Phase 1: Loading card ──
    local LC = Instance.new("Frame", BG)
    LC.Size             = UDim2.new(0, 320, 0, 260)
    LC.Position         = UDim2.new(0.5,-160,0.6,-130)
    LC.BackgroundColor3 = Color3.fromRGB(16,16,22)
    LC.BackgroundTransparency = 1
    LC.BorderSizePixel  = 0
    LC.ZIndex           = 202
    Corner(LC, UDim.new(0,16))
    Shadow(LC)
    Stroke(LC, self.Theme.Accent, 1, 0.5)

    -- Top accent line
    local LCLine = Instance.new("Frame", LC)
    LCLine.Size = UDim2.new(1,0,0,2)
    LCLine.BackgroundColor3 = self.Theme.Accent
    LCLine.BorderSizePixel = 0; LCLine.ZIndex = 203
    Corner(LCLine)

    -- Icon
    local IconFrame = Instance.new("Frame", LC)
    IconFrame.Size = UDim2.new(0,64,0,64)
    IconFrame.Position = UDim2.new(0.5,-32,0,20)
    IconFrame.BackgroundColor3 = self.Theme.Accent
    IconFrame.BackgroundTransparency = 0.8
    IconFrame.BorderSizePixel = 0; IconFrame.ZIndex = 203
    Corner(IconFrame, UDim.new(0,16))
    local IconLbl = Instance.new("TextLabel", IconFrame)
    IconLbl.Size = UDim2.new(1,0,1,0); IconLbl.BackgroundTransparency = 1
    IconLbl.Text = "◈"; IconLbl.TextScaled = true; IconLbl.ZIndex = 204
    IconLbl.TextColor3 = self.Theme.Accent; IconLbl.Font = Enum.Font.GothamBold

    -- Title / sub
    local function CardLabel(text, yPos, size, color, bold)
        local L = Instance.new("TextLabel", LC)
        L.Text = text; L.Size = UDim2.new(1,-20,0,size+4)
        L.Position = UDim2.new(0,10,0,yPos)
        L.BackgroundTransparency = 1; L.TextColor3 = color or Color3.fromRGB(240,240,248)
        L.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
        L.TextSize = size; L.ZIndex = 203
        return L
    end
    CardLabel("pano-ui",             96, 22, Color3.fromRGB(240,240,248), true)
    CardLabel("Lightweight UI Library",128, 11, self.Theme.Accent,        false)

    -- Bar
    local BarBG = Instance.new("Frame", LC)
    BarBG.Size = UDim2.new(0.8,0,0,5); BarBG.Position = UDim2.new(0.1,0,0,162)
    BarBG.BackgroundColor3 = Color3.fromRGB(30,30,40); BarBG.BorderSizePixel=0; BarBG.ZIndex=203
    Corner(BarBG, UDim.new(0,3))
    local BarFill = Instance.new("Frame", BarBG)
    BarFill.Size = UDim2.new(0,0,1,0); BarFill.BackgroundColor3 = self.Theme.Accent
    BarFill.BorderSizePixel=0; BarFill.ZIndex=204; Corner(BarFill, UDim.new(0,3))

    local StatusLbl = CardLabel("Initializing...", 176, 11, Color3.fromRGB(100,100,120), false)
    CardLabel("pano-ui  •  github", 234, 10, Color3.fromRGB(50,50,70), false)

    -- Animate card in
    Tween(LC, {BackgroundTransparency=0, Position=UDim2.new(0.5,-160,0.5,-130)},
        0.6, Enum.EasingStyle.Back)

    task.spawn(function()
        task.wait(0.4)
        local steps = {
            {t=0.4, text="Loading core...",    pct=0.25},
            {t=0.4, text="Building UI...",     pct=0.55},
            {t=0.35,text="Connecting...",      pct=0.80},
            {t=0.3, text="Almost ready...",    pct=0.95},
            {t=0.25,text="Done! ✓",            pct=1.00},
        }
        for _, s in ipairs(steps) do
            task.wait(s.t)
            StatusLbl.Text = s.text
            Tween(BarFill, {Size=UDim2.new(s.pct,0,1,0)}, 0.3)
        end
        task.wait(0.5)

        -- ── Phase 2: slide out Loading → slide in Lang ──
        Tween(LC, {Position=UDim2.new(-0.7,-160,0.5,-130)},
            0.45, Enum.EasingStyle.Quart)
        task.wait(0.5)
        LC.Visible = false

        if not langTable then
            -- ไม่มีภาษา → จบเลย
            Tween(BG, {BackgroundTransparency=1}, 0.4)
            task.wait(0.45); Gui:Destroy(); onDone()
            return
        end

        -- Lang card
        local LG = Instance.new("Frame", BG)
        LG.Size = UDim2.new(0,320,0,210)
        LG.Position = UDim2.new(1.2,0,0.5,-105)
        LG.BackgroundColor3 = Color3.fromRGB(16,16,22)
        LG.BorderSizePixel  = 0; LG.ZIndex = 202
        Corner(LG, UDim.new(0,16))
        Shadow(LG)
        Stroke(LG, self.Theme.Accent, 1, 0.5)

        local LGLine = Instance.new("Frame", LG)
        LGLine.Size = UDim2.new(1,0,0,2)
        LGLine.BackgroundColor3 = self.Theme.Accent
        LGLine.BorderSizePixel=0; LGLine.ZIndex=203; Corner(LGLine)

        local GlobeLbl = Instance.new("TextLabel", LG)
        GlobeLbl.Text = "🌐"; GlobeLbl.Size = UDim2.new(1,0,0,38); GlobeLbl.Position = UDim2.new(0,0,0,14)
        GlobeLbl.BackgroundTransparency=1; GlobeLbl.TextSize=28; GlobeLbl.ZIndex=203

        local LGTitle = Instance.new("TextLabel", LG)
        LGTitle.Text="Select Language"; LGTitle.Size=UDim2.new(1,0,0,24); LGTitle.Position=UDim2.new(0,0,0,58)
        LGTitle.BackgroundTransparency=1; LGTitle.TextColor3=Color3.fromRGB(240,240,248)
        LGTitle.Font=Enum.Font.GothamBold; LGTitle.TextSize=16; LGTitle.ZIndex=203

        local LGSub = Instance.new("TextLabel", LG)
        LGSub.Text="เลือกภาษาที่ต้องการ"; LGSub.Size=UDim2.new(1,0,0,18); LGSub.Position=UDim2.new(0,0,0,84)
        LGSub.BackgroundTransparency=1; LGSub.TextColor3=self.Theme.Accent
        LGSub.Font=Enum.Font.Gotham; LGSub.TextSize=11; LGSub.ZIndex=203

        local Div = Instance.new("Frame", LG)
        Div.Size=UDim2.new(0.85,0,0,1); Div.Position=UDim2.new(0.075,0,0,110)
        Div.BackgroundColor3=Color3.fromRGB(40,40,55); Div.BorderSizePixel=0; Div.ZIndex=203

        local function MakeLangBtn(label, flag, xOff, key)
            local Btn = Instance.new("TextButton", LG)
            Btn.Size = UDim2.new(0,120,0,52)
            Btn.Position = UDim2.new(0.5, xOff, 0, 120)
            Btn.BackgroundColor3 = Color3.fromRGB(22,22,30)
            Btn.Text=""; Btn.BorderSizePixel=0; Btn.ZIndex=204
            Corner(Btn, UDim.new(0,10))
            local BS = Stroke(Btn, Color3.fromRGB(60,60,80))

            local FL = Instance.new("TextLabel", Btn)
            FL.Text=flag; FL.Size=UDim2.new(1,0,0,26); FL.Position=UDim2.new(0,0,0,4)
            FL.BackgroundTransparency=1; FL.TextScaled=true; FL.ZIndex=205

            local NL = Instance.new("TextLabel", Btn)
            NL.Text=label; NL.Size=UDim2.new(1,0,0,18); NL.Position=UDim2.new(0,0,0,30)
            NL.BackgroundTransparency=1; NL.TextColor3=Color3.fromRGB(170,170,190)
            NL.Font=Enum.Font.GothamMedium; NL.TextSize=11; NL.ZIndex=205

            Btn.MouseEnter:Connect(function()
                Tween(Btn,{BackgroundColor3=self.Theme.Accent},0.2)
                Tween(BS,{Color=self.Theme.Accent},0.2)
                Tween(NL,{TextColor3=Color3.fromRGB(255,255,255)},0.2)
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Btn,{BackgroundColor3=Color3.fromRGB(22,22,30)},0.2)
                Tween(BS,{Color=Color3.fromRGB(60,60,80)},0.2)
                Tween(NL,{TextColor3=Color3.fromRGB(170,170,190)},0.2)
            end)
            Btn.MouseButton1Click:Connect(function()
                Tween(LG,{Position=UDim2.new(-0.7,0,0.5,-105)},0.4,Enum.EasingStyle.Quart)
                Tween(BG,{BackgroundTransparency=1},0.5)
                task.wait(0.5); Gui:Destroy()
                onDone(key, langTable[key])
            end)
        end

        MakeLangBtn("ภาษาไทย","🇹🇭",-130,"TH")
        MakeLangBtn("English", "🇺🇸",  10, "EN")

        Tween(LG,{Position=UDim2.new(0.5,-160,0.5,-105)},0.5,Enum.EasingStyle.Back)
    end)
end

-- ══════════════════════════════════
--  Library:CreateWindow(title)
--  สร้างหน้าต่างหลัก → return Tabs API
-- ══════════════════════════════════
function Library:CreateWindow(title)
    local SG = Instance.new("ScreenGui", game.CoreGui)
    SG.Name = "_PanoUI"
    SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self._ScreenGui = SG

    local isMobile = UserInputService.TouchEnabled
    local W = isMobile and 480 or 590
    local H = isMobile and 320 or 380

    -- Main frame
    local Main = Instance.new("Frame", SG)
    Main.Size               = UDim2.new(0,W,0,H)
    Main.Position           = UDim2.new(0.5,-W/2,0.6,-H/2)
    Main.BackgroundColor3   = self.Theme.Main
    Main.BorderSizePixel    = 0
    Main.ClipsDescendants   = true
    Main.BackgroundTransparency = 1
    Corner(Main, self.Theme.Corner)
    Shadow(Main)
    Stroke(Main, self.Theme.Accent, 1, 0.7)

    -- Gradient
    local Grad = Instance.new("UIGradient", Main)
    Grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(26,26,36)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,13)),
    }); Grad.Rotation = 135

    -- Animate in
    Tween(Main, {BackgroundTransparency=0, Position=UDim2.new(0.5,-W/2,0.5,-H/2)},
        0.5, Enum.EasingStyle.Back)

    -- Top accent line
    local TopLine = Instance.new("Frame", Main)
    TopLine.Size = UDim2.new(1,0,0,2)
    TopLine.BackgroundColor3 = self.Theme.Accent
    TopLine.BorderSizePixel  = 0
    table.insert(self.ElementsToTheme, TopLine)

    -- ── Header ──
    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1,0,0,50); Header.BackgroundTransparency = 1

    -- Pulse dot
    local PDot = Instance.new("Frame", Header)
    PDot.Size = UDim2.new(0,8,0,8); PDot.Position = UDim2.new(0,16,0.5,-4)
    PDot.BackgroundColor3 = self.Theme.Accent; PDot.BorderSizePixel = 0
    Corner(PDot, UDim.new(1,0))
    table.insert(self.ElementsToTheme, PDot)
    task.spawn(function()
        while PDot and PDot.Parent do
            Tween(PDot,{BackgroundTransparency=0.65},0.8)
            task.wait(0.8)
            Tween(PDot,{BackgroundTransparency=0},0.8)
            task.wait(0.8)
        end
    end)

    local TitleL = Instance.new("TextLabel", Header)
    TitleL.Text = title:upper(); TitleL.Size = UDim2.new(0,300,0,26); TitleL.Position = UDim2.new(0,32,0,7)
    TitleL.TextColor3 = self.Theme.Text; TitleL.Font = Enum.Font.GothamBold; TitleL.TextSize = 15
    TitleL.TextXAlignment = Enum.TextXAlignment.Left; TitleL.BackgroundTransparency = 1

    local SubL = Instance.new("TextLabel", Header)
    SubL.Text = "pano-ui library"; SubL.Size = UDim2.new(0,200,0,14); SubL.Position = UDim2.new(0,32,0,30)
    SubL.TextColor3 = self.Theme.Accent; SubL.Font = Enum.Font.Gotham; SubL.TextSize = 10
    SubL.TextXAlignment = Enum.TextXAlignment.Left; SubL.BackgroundTransparency = 1
    table.insert(self.ElementsToTheme, SubL)

    -- Minimize button
    local MinBtn = Instance.new("TextButton", Header)
    MinBtn.Size = UDim2.new(0,32,0,32); MinBtn.Position = UDim2.new(1,-44,0.5,-16)
    MinBtn.BackgroundColor3 = self.Theme.Section; MinBtn.Text = "—"
    MinBtn.TextColor3 = self.Theme.SubText; MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14; MinBtn.BorderSizePixel = 0
    Corner(MinBtn, UDim.new(0,8))
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn,{BackgroundColor3=self.Theme.Accent,TextColor3=self.Theme.Text}) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn,{BackgroundColor3=self.Theme.Section,TextColor3=self.Theme.SubText}) end)

    -- Minimized bar
    local MinBar = Instance.new("Frame", SG)
    MinBar.Size = UDim2.new(0,210,0,38); MinBar.Position = UDim2.new(0.5,-105,0,10)
    MinBar.BackgroundColor3 = self.Theme.Section; MinBar.BorderSizePixel = 0
    MinBar.Visible = false; MinBar.ZIndex = 20
    Corner(MinBar, UDim.new(0,10))
    Shadow(MinBar)
    Stroke(MinBar, self.Theme.Accent, 1, 0.6)

    local MBStrip = Instance.new("Frame", MinBar)
    MBStrip.Size = UDim2.new(0,3,0.7,0); MBStrip.Position = UDim2.new(0,0,0.15,0)
    MBStrip.BackgroundColor3 = self.Theme.Accent; MBStrip.BorderSizePixel = 0
    Corner(MBStrip, UDim.new(0,4))
    table.insert(self.ElementsToTheme, MBStrip)

    local MBLabel = Instance.new("TextLabel", MinBar)
    MBLabel.Text = title:upper(); MBLabel.Size = UDim2.new(1,-72,1,0); MBLabel.Position = UDim2.new(0,14,0,0)
    MBLabel.TextColor3 = self.Theme.Text; MBLabel.Font = Enum.Font.GothamBold; MBLabel.TextSize = 12
    MBLabel.TextXAlignment = Enum.TextXAlignment.Left; MBLabel.BackgroundTransparency = 1; MBLabel.ZIndex = 21

    local MBRestore = Instance.new("TextButton", MinBar)
    MBRestore.Size = UDim2.new(0,28,0,28); MBRestore.Position = UDim2.new(1,-34,0.5,-14)
    MBRestore.BackgroundColor3 = self.Theme.Accent; MBRestore.Text = "▲"
    MBRestore.TextColor3 = Color3.fromRGB(255,255,255); MBRestore.Font = Enum.Font.GothamBold
    MBRestore.TextSize = 10; MBRestore.BorderSizePixel = 0; MBRestore.ZIndex = 22
    Corner(MBRestore, UDim.new(0,6))
    table.insert(self.ElementsToTheme, MBRestore)

    local function SetMin(v)
        if v then
            Tween(Main,{Size=UDim2.new(0,W,0,0)},0.3)
            task.delay(0.3,function()
                Main.Visible=false; Main.Size=UDim2.new(0,W,0,H)
                MinBar.Visible=true; MinBar.Position=UDim2.new(0.5,-105,0,-40)
                Tween(MinBar,{Position=UDim2.new(0.5,-105,0,10)},0.35)
            end)
        else
            MinBar.Visible=false; Main.Visible=true
            Main.Size=UDim2.new(0,W,0,0)
            Tween(Main,{Size=UDim2.new(0,W,0,H)},0.35)
        end
    end
    MinBtn.MouseButton1Click:Connect(function() SetMin(true) end)
    MBRestore.MouseButton1Click:Connect(function() SetMin(false) end)

    -- MinBar drag
    local bDrag,bDragStart,bStartPos
    MinBar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then bDrag=true;bDragStart=i.Position;bStartPos=MinBar.Position end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if bDrag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-bDragStart
            MinBar.Position=UDim2.new(bStartPos.X.Scale,bStartPos.X.Offset+d.X,bStartPos.Y.Scale,bStartPos.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then bDrag=false end
    end)

    -- Divider
    local Div = Instance.new("Frame", Main)
    Div.Size = UDim2.new(1,-20,0,1); Div.Position = UDim2.new(0,10,0,50)
    Div.BackgroundColor3 = self.Theme.Border; Div.BorderSizePixel = 0

    -- Profile strip (bottom-left)
    local PF = Instance.new("Frame", Main)
    PF.Size = UDim2.new(0,155,0,44); PF.Position = UDim2.new(0,8,1,-52)
    PF.BackgroundColor3 = self.Theme.Section; PF.BackgroundTransparency = 0.3; PF.BorderSizePixel = 0
    Corner(PF, UDim.new(0,10))

    local Av = Instance.new("ImageLabel", PF)
    Av.Size = UDim2.new(0,32,0,32); Av.Position = UDim2.new(0,6,0.5,-16)
    Av.BackgroundColor3 = self.Theme.Border
    pcall(function()
        Av.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    Corner(Av, UDim.new(1,0))

    local PN = Instance.new("TextLabel", PF)
    PN.Text = LocalPlayer.DisplayName; PN.Size = UDim2.new(1,-44,0,18); PN.Position = UDim2.new(0,42,0,6)
    PN.TextColor3 = self.Theme.Text; PN.Font = Enum.Font.GothamBold; PN.TextSize = 11
    PN.TextXAlignment = Enum.TextXAlignment.Left; PN.BackgroundTransparency = 1

    local PS = Instance.new("TextLabel", PF)
    PS.Text = "● USER"; PS.Size = UDim2.new(1,-44,0,14); PS.Position = UDim2.new(0,42,0,24)
    PS.TextColor3 = self.Theme.Accent; PS.Font = Enum.Font.Gotham; PS.TextSize = 9
    PS.TextXAlignment = Enum.TextXAlignment.Left; PS.BackgroundTransparency = 1
    table.insert(self.ElementsToTheme, PS)

    -- Sidebar
    local SB = Instance.new("Frame", Main)
    SB.Size = UDim2.new(0,152,1,-105); SB.Position = UDim2.new(0,10,0,58)
    SB.BackgroundColor3 = self.Theme.Section; SB.BackgroundTransparency = 0.6; SB.BorderSizePixel = 0
    Corner(SB, UDim.new(0,10))

    local TabHolder = Instance.new("ScrollingFrame", SB)
    TabHolder.Size = UDim2.new(1,0,1,-10); TabHolder.Position = UDim2.new(0,0,0,8)
    TabHolder.BackgroundTransparency = 1; TabHolder.ScrollBarThickness = 0; TabHolder.BorderSizePixel = 0
    local THL = Instance.new("UIListLayout", TabHolder)
    THL.Padding = UDim.new(0,4); THL.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", TabHolder).PaddingLeft = UDim.new(0,5)

    -- Page area
    local PageHolder = Instance.new("Frame", Main)
    PageHolder.Size = UDim2.new(1,-182,1,-115); PageHolder.Position = UDim2.new(0,170,0,58)
    PageHolder.BackgroundTransparency = 1

    -- Header drag
    local drag,dragStart,dragPos
    Header.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true;dragStart=i.Position;dragPos=Main.Position end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-dragStart
            Main.Position=UDim2.new(dragPos.X.Scale,dragPos.X.Offset+d.X,dragPos.Y.Scale,dragPos.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)

    -- Keybind
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode==self.Keybind then
            self.IsOpen=not self.IsOpen; SG.Enabled=self.IsOpen
        end
    end)

    -- ══════════════════════════════
    --  Tabs API
    -- ══════════════════════════════
    local Tabs = {}

    --[[
        Win:AddTab(name, icon)
        → returns Elements table with:
            :AddButton(text, callback)
            :AddToggle(text, default, callback)
            :AddSlider(text, min, max, default, callback)
            :AddDropdown(text, list, callback)
            :AddSection(text)
    ]]
    function Tabs:AddTab(name, icon)
        icon = icon or "◈"

        local TB = Instance.new("TextButton", TabHolder)
        TB.Size = UDim2.new(1,-8,0,34); TB.BackgroundColor3 = Library.Theme.Section
        TB.BackgroundTransparency = 1; TB.Text = ""; TB.AutoButtonColor = false; TB.BorderSizePixel = 0
        Corner(TB, UDim.new(0,8))

        local TInd = Instance.new("Frame", TB)
        TInd.Size = UDim2.new(0,3,0.6,0); TInd.Position = UDim2.new(0,0,0.2,0)
        TInd.BackgroundColor3 = Library.Theme.Accent; TInd.BackgroundTransparency = 1; TInd.BorderSizePixel = 0
        Corner(TInd, UDim.new(0,4))

        local TIco = Instance.new("TextLabel", TB)
        TIco.Text = icon; TIco.Size = UDim2.new(0,22,1,0); TIco.Position = UDim2.new(0,10,0,0)
        TIco.TextColor3 = Library.Theme.SubText; TIco.Font = Enum.Font.GothamBold
        TIco.TextSize = 13; TIco.BackgroundTransparency = 1

        local TLbl = Instance.new("TextLabel", TB)
        TLbl.Text = name; TLbl.Size = UDim2.new(1,-36,1,0); TLbl.Position = UDim2.new(0,34,0,0)
        TLbl.TextColor3 = Library.Theme.SubText; TLbl.Font = Enum.Font.GothamMedium
        TLbl.TextSize = 12; TLbl.TextXAlignment = Enum.TextXAlignment.Left; TLbl.BackgroundTransparency = 1

        local Page = Instance.new("CanvasGroup", PageHolder)
        Page.Size = UDim2.new(1,0,1,0); Page.Visible = false; Page.GroupTransparency = 1
        Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0

        local PS2 = Instance.new("ScrollingFrame", Page)
        PS2.Size = UDim2.new(1,0,1,0); PS2.BackgroundTransparency = 1
        PS2.ScrollBarThickness = 2; PS2.ScrollBarImageColor3 = Library.Theme.Accent; PS2.BorderSizePixel = 0
        local PSL = Instance.new("UIListLayout", PS2); PSL.Padding = UDim.new(0,6)
        Instance.new("UIPadding", PS2).PaddingTop = UDim.new(0,4)

        local function SetActive(on)
            if on then
                Tween(TB,{BackgroundTransparency=0.7},0.2); Tween(TInd,{BackgroundTransparency=0},0.2)
                Tween(TIco,{TextColor3=Library.Theme.Accent},0.2); Tween(TLbl,{TextColor3=Library.Theme.Text},0.2)
            else
                Tween(TB,{BackgroundTransparency=1},0.2); Tween(TInd,{BackgroundTransparency=1},0.2)
                Tween(TIco,{TextColor3=Library.Theme.SubText},0.2); Tween(TLbl,{TextColor3=Library.Theme.SubText},0.2)
            end
        end

        TB.MouseButton1Click:Connect(function()
            for _,v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    Tween(v,{BackgroundTransparency=1},0.2)
                    local ind=v:FindFirstChildWhichIsA("Frame")
                    if ind then Tween(ind,{BackgroundTransparency=1},0.2) end
                    for _,l in pairs(v:GetChildren()) do
                        if l:IsA("TextLabel") then Tween(l,{TextColor3=Library.Theme.SubText},0.2) end
                    end
                end
            end
            for _,v in pairs(PageHolder:GetChildren()) do
                if v:IsA("CanvasGroup") then v.Visible=false; v.GroupTransparency=1 end
            end
            SetActive(true); Page.Visible=true; Tween(Page,{GroupTransparency=0},0.3)
        end)

        if not Library.CurrentTab then
            Library.CurrentTab=TB; SetActive(true); Page.Visible=true; Page.GroupTransparency=0
        end

        -- Element builders
        local function Base(h)
            local f=Instance.new("Frame",PS2)
            f.Size=UDim2.new(1,-8,0,h); f.BackgroundColor3=Library.Theme.Section; f.BorderSizePixel=0
            Corner(f, UDim.new(0,8))
            Stroke(f, Library.Theme.Border, 1, 0.5)
            return f
        end
        local function Lbl(parent,text,x,y,w,h2)
            local L=Instance.new("TextLabel",parent)
            L.Text=text; L.Size=UDim2.new(w or 0.7,0,0,h2 or 28); L.Position=UDim2.new(0,x or 14,0,y or 0)
            L.TextColor3=Library.Theme.Text; L.BackgroundTransparency=1
            L.TextXAlignment=Enum.TextXAlignment.Left
            L.Font=Enum.Font.GothamMedium; L.TextSize=12
            return L
        end

        local Elements = {}

        --[[  Elements:AddSection(text)  ]]
        function Elements:AddSection(text)
            local F=Instance.new("Frame",PS2)
            F.Size=UDim2.new(1,-8,0,22); F.BackgroundTransparency=1
            local L=Instance.new("TextLabel",F)
            L.Text=("── %s ──"):format(text:upper())
            L.Size=UDim2.new(1,0,1,0); L.BackgroundTransparency=1
            L.TextColor3=Library.Theme.Accent; L.Font=Enum.Font.GothamBold
            L.TextSize=10; L.TextXAlignment=Enum.TextXAlignment.Left
            table.insert(Library.ElementsToTheme,L)
        end

        --[[  Elements:AddButton(text, function() end)  ]]
        function Elements:AddButton(text, callback)
            local F=Base(38)
            local Btn=Instance.new("TextButton",F)
            Btn.Size=UDim2.new(1,0,1,0); Btn.BackgroundTransparency=1; Btn.Text=""; Btn.AutoButtonColor=false
            local Ico=Instance.new("TextLabel",Btn)
            Ico.Text="▷"; Ico.Size=UDim2.new(0,20,1,0); Ico.Position=UDim2.new(0,10,0,0)
            Ico.TextColor3=Library.Theme.Accent; Ico.Font=Enum.Font.GothamBold; Ico.TextSize=12; Ico.BackgroundTransparency=1
            table.insert(Library.ElementsToTheme,Ico)
            Lbl(Btn,text,32,0)
            Btn.MouseEnter:Connect(function() Tween(F,{BackgroundColor3=Library.Theme.SectionHov}) end)
            Btn.MouseLeave:Connect(function() Tween(F,{BackgroundColor3=Library.Theme.Section}) end)
            Btn.MouseButton1Click:Connect(function()
                Tween(F,{BackgroundColor3=Library.Theme.Accent},0.1)
                task.delay(0.12,function() Tween(F,{BackgroundColor3=Library.Theme.Section}) end)
                callback()
            end)
        end

        --[[  Elements:AddToggle(text, default, function(bool) end)  ]]
        function Elements:AddToggle(text, default, callback)
            local F=Base(40); Lbl(F,text,14,0,0.65,40)
            local Box=Instance.new("Frame",F)
            Box.Size=UDim2.new(0,40,0,22); Box.Position=UDim2.new(1,-50,0.5,-11)
            Box.BackgroundColor3=default and Library.Theme.Accent or Color3.fromRGB(45,45,55)
            Box.BorderSizePixel=0; Corner(Box,UDim.new(1,0))
            local Dot2=Instance.new("Frame",Box)
            Dot2.Size=UDim2.new(0,16,0,16)
            Dot2.Position=default and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
            Dot2.BackgroundColor3=Color3.fromRGB(255,255,255); Dot2.BorderSizePixel=0
            Corner(Dot2,UDim.new(1,0))
            local state=default
            local TB2=Instance.new("TextButton",F)
            TB2.Size=UDim2.new(1,0,1,0); TB2.BackgroundTransparency=1; TB2.Text=""
            TB2.MouseButton1Click:Connect(function()
                state=not state
                Tween(Box,{BackgroundColor3=state and Library.Theme.Accent or Color3.fromRGB(45,45,55)})
                Tween(Dot2,{Position=state and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)})
                callback(state)
            end)
        end

        --[[  Elements:AddSlider(text, min, max, default, function(num) end)  ]]
        function Elements:AddSlider(text, min, max, default, callback)
            local F=Base(54)
            local SLbl=Lbl(F,text..":  "..default,14,4)
            local Track=Instance.new("Frame",F)
            Track.Size=UDim2.new(1,-28,0,5); Track.Position=UDim2.new(0,14,0,34)
            Track.BackgroundColor3=Color3.fromRGB(35,35,45); Track.BorderSizePixel=0
            Corner(Track,UDim.new(0,3))
            local Fill=Instance.new("Frame",Track)
            Fill.Size=UDim2.new((default-min)/(max-min),0,1,0)
            Fill.BackgroundColor3=Library.Theme.Accent; Fill.BorderSizePixel=0
            Corner(Fill,UDim.new(0,3))
            table.insert(Library.ElementsToTheme,Fill)
            local Knob=Instance.new("Frame",Track)
            Knob.Size=UDim2.new(0,14,0,14); Knob.BackgroundColor3=Color3.fromRGB(255,255,255); Knob.BorderSizePixel=0
            Knob.Position=UDim2.new((default-min)/(max-min),-7,0.5,-7)
            Corner(Knob,UDim.new(1,0))
            local sliding=false
            local function Upd()
                local p=math.clamp((Mouse.X-Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1)
                local val=math.round(min+(max-min)*p)
                SLbl.Text=text..":  "..val
                Fill.Size=UDim2.new(p,0,1,0); Knob.Position=UDim2.new(p,-7,0.5,-7); callback(val)
            end
            Track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true;Upd() end end)
            UserInputService.InputChanged:Connect(function(i) if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then Upd() end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end end)
        end

        --[[  Elements:AddDropdown(text, {list}, function(selected) end)  ]]
        function Elements:AddDropdown(text, list, callback)
            local cH,oH=40,40+(#list*32)
            local F=Base(cH); F.ClipsDescendants=true
            local H2=Instance.new("TextButton",F)
            H2.Size=UDim2.new(1,0,0,40); H2.BackgroundTransparency=1; H2.Text=""; H2.AutoButtonColor=false
            Lbl(H2,text,14,0,0.6,40)
            local Arr=Instance.new("TextLabel",H2)
            Arr.Text="▼"; Arr.Size=UDim2.new(0,20,0,40); Arr.Position=UDim2.new(1,-28,0,0)
            Arr.TextColor3=Library.Theme.SubText; Arr.Font=Enum.Font.GothamBold; Arr.TextSize=10; Arr.BackgroundTransparency=1
            local SelL=Instance.new("TextLabel",H2)
            SelL.Size=UDim2.new(0,80,0,40); SelL.Position=UDim2.new(1,-110,0,0)
            SelL.Text=list[1] or ""; SelL.TextColor3=Library.Theme.Accent
            SelL.Font=Enum.Font.Gotham; SelL.TextSize=11; SelL.BackgroundTransparency=1
            SelL.TextXAlignment=Enum.TextXAlignment.Right
            table.insert(Library.ElementsToTheme,SelL)
            local open=false
            H2.MouseButton1Click:Connect(function()
                open=not open
                Tween(F,{Size=UDim2.new(1,-8,0,open and oH or cH)},0.25)
                Tween(Arr,{TextColor3=open and Library.Theme.Accent or Library.Theme.SubText},0.2)
            end)
            for i,v in pairs(list) do
                local iB=Instance.new("TextButton",F)
                iB.Size=UDim2.new(1,-16,0,28); iB.Position=UDim2.new(0,8,0,40+(i-1)*32+2)
                iB.BackgroundColor3=Library.Theme.SectionHov; iB.BackgroundTransparency=0.5
                iB.Text=v; iB.TextColor3=Library.Theme.SubText; iB.Font=Enum.Font.Gotham
                iB.TextSize=11; iB.BorderSizePixel=0; Corner(iB,UDim.new(0,6))
                iB.MouseEnter:Connect(function() Tween(iB,{TextColor3=Library.Theme.Text}) end)
                iB.MouseLeave:Connect(function() Tween(iB,{TextColor3=Library.Theme.SubText}) end)
                iB.MouseButton1Click:Connect(function()
                    SelL.Text=v; open=false
                    Tween(F,{Size=UDim2.new(1,-8,0,cH)},0.25); callback(v)
                end)
            end
        end

        return Elements
    end

    return Tabs
end

return Library
