--[[
    NAEI HUB v15.0 - NEON OBSIDIAN (Upgraded)

    ตัวอย่างการใช้งาน:
    local NAEI = loadstring(...)()
    NAEI:ShowLoader({OnFinish = function()
        local Win = NAEI:CreateWindow({Title="NAEI HUB", ToggleKey=Enum.KeyCode.RightShift})
        local Tab = Win:CreateTab("Main","★")
        Tab:AddSection("Combat")
        Tab:AddToggle({Name="Auto", Flag="auto", Callback=function(v) print(v) end})
        Tab:AddSlider({Name="Speed", Min=0, Max=100, Increment=5, Default=16, Flag="speed"})
        Tab:AddDropdown({Name="Mode", Options={"A","B","C"}, Default="A", Flag="mode"})
        Tab:AddKeybind({Name="Key", Default=Enum.KeyCode.F, Flag="key"})
        Tab:AddTextBox({Name="Name", Placeholder="type...", Flag="name"})
        Tab:AddButton({Name="Save Config", Callback=function() Win:SaveConfig("default") end})
    end})
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local NAEI = {}
NAEI.Version = "15.1"
NAEI.Flags = {}
NAEI.Setters = {}
NAEI.Connections = {}
NAEI.ConfigFolder = "NAEI_HUB"
NAEI.LogoUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg"
NAEI.LogoFile = "naei_v15_1.jpg"

local T = {
    Bg = Color3.fromRGB(8, 8, 10),
    BgSub = Color3.fromRGB(14, 14, 18),
    Card = Color3.fromRGB(22, 22, 28),
    Card2 = Color3.fromRGB(30, 30, 38),
    Hover = Color3.fromRGB(42, 42, 56),
    Primary = Color3.fromRGB(255, 235, 0),
    Primary2 = Color3.fromRGB(0, 255, 190),
    Primary3 = Color3.fromRGB(140, 100, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Sub = Color3.fromRGB(160, 160, 175),
    Muted = Color3.fromRGB(90, 90, 105),
    Border = Color3.fromRGB(50, 50, 65),
    Off = Color3.fromRGB(45, 45, 58),
    Danger = Color3.fromRGB(255, 60, 90),
}
NAEI.Theme = T

local Left, Right = Enum.TextXAlignment.Left, Enum.TextXAlignment.Right

-- ================= UTILS =================
local function New(class, props)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then pcall(function() o[k] = v end) end
    end
    if props and props.Parent then o.Parent = props.Parent end
    return o
end
local function Corner(o, r) return New("UICorner", {CornerRadius = UDim.new(0, r or 14), Parent = o}) end
local function Stroke(o, c, t, tk)
    return New("UIStroke", {Color = c or T.Border, Transparency = t or 0.5, Thickness = tk or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = o})
end
local function Tween(o, t, pr, style, dir)
    local tw = TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), pr)
    tw:Play()
    return tw
end
local function Connect(sig, fn)
    local c = sig:Connect(fn)
    table.insert(NAEI.Connections, c)
    return c
end
local function GetParent()
    local ok, g = pcall(function() return gethui() end)
    if ok and g then return g end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local function GetAsset(url, file)
    local fn = getcustomasset or getsynasset
    if not (fn and writefile and isfile and game.HttpGet) then return "" end
    local ok, a = pcall(function()
        if not isfile(file) then writefile(file, game:HttpGet(url)) end
        return fn(file)
    end)
    return ok and a or ""
end
local function Label(parent, props)
    props.BackgroundTransparency = 1
    props.Font = props.Font or Enum.Font.Gotham
    props.TextXAlignment = props.TextXAlignment or Left
    props.Parent = parent
    return New("TextLabel", props)
end
local LogoAsset
local function MakeLogo(parent, props, radius)
    if LogoAsset == nil then LogoAsset = GetAsset(NAEI.LogoUrl, NAEI.LogoFile) end
    props.BackgroundTransparency = 1
    props.Image = LogoAsset
    props.ScaleType = Enum.ScaleType.Crop
    props.Parent = parent
    local img = New("ImageLabel", props)
    Corner(img, radius or 12)
    if LogoAsset == "" then -- โหลดรูปไม่ได้ -> โลโก้สำรอง "N"
        img.BackgroundTransparency = 0
        img.BackgroundColor3 = Color3.new(1, 1, 1)
        New("UIGradient", {Color = ColorSequence.new(T.Primary, T.Primary2), Rotation = 45, Parent = img})
        local t = New("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "N", TextColor3 = T.Bg,
            TextScaled = true, Font = Enum.Font.GothamBlack, Parent = img})
        New("UIPadding", {PaddingTop = UDim.new(0.18, 0), PaddingBottom = UDim.new(0.18, 0), Parent = t})
    end
    return img
end
local function SetFlag(flag, v) if flag then NAEI.Flags[flag] = v end end
local function Register(flag, setter) if flag then NAEI.Setters[flag] = setter end end

local function EnableDrag(frame, handle)
    handle = handle or frame
    local dragging, startPos, startInput, framePos
    Connect(handle.InputBegan, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, startPos, framePos = true, i.Position, frame.Position
            local c; c = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false c:Disconnect() end
            end)
        end
    end)
    Connect(handle.InputChanged, function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then startInput = i end
    end)
    Connect(UserInputService.InputChanged, function(i)
        if i == startInput and dragging then
            local d = i.Position - startPos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + d.X, framePos.Y.Scale, framePos.Y.Offset + d.Y)
        end
    end)
end

local function Hover(btn, frame, stroke)
    Connect(btn.MouseEnter, function()
        Tween(frame, 0.2, {BackgroundColor3 = T.Hover})
        if stroke then Tween(stroke, 0.2, {Color = T.Primary}) end
    end)
    Connect(btn.MouseLeave, function()
        Tween(frame, 0.2, {BackgroundColor3 = T.Card})
        if stroke then Tween(stroke, 0.2, {Color = T.Border}) end
    end)
end

local function CardFrame(parent, h)
    local f = New("Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = T.Card, Parent = parent})
    Corner(f, 14)
    New("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(185, 185, 200)), Rotation = 90, Parent = f})
    return f, Stroke(f, T.Border, 0.4, 1)
end

-- ================= PARTICLES =================
local function AddParticles(parent, count)
    for i = 1, count or 14 do
        local p = New("Frame", {
            Size = UDim2.fromOffset(math.random(2, 4), math.random(2, 4)),
            Position = UDim2.fromScale(math.random(), math.random()),
            BackgroundColor3 = i % 2 == 0 and T.Primary or T.Primary2,
            BackgroundTransparency = 0.3, BorderSizePixel = 0, Parent = parent})
        Corner(p, 100)
        task.spawn(function()
            while p.Parent do
                local t = math.random(3, 6)
                Tween(p, t, {Position = UDim2.fromScale(math.random(), math.random()), BackgroundTransparency = math.random() * 0.8},
                    Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(t)
            end
        end)
    end
end

-- ================= LOADER =================
function NAEI:ShowLoader(cfg)
    cfg = cfg or {}
    local finished = false
    local Gui = New("ScreenGui", {Name = "NAEI_LOADER", ResetOnSpawn = false, IgnoreGuiInset = true, Parent = GetParent()})
    local Blur = New("BlurEffect", {Size = 0, Parent = Lighting})
    Tween(Blur, 0.6, {Size = 22})

    local function Cleanup(callFinish)
        if finished then return end
        finished = true
        Tween(Blur, 0.3, {Size = 0})
        task.delay(0.35, function() pcall(function() Gui:Destroy() Blur:Destroy() end) end)
        if callFinish and cfg.OnFinish then task.spawn(pcall, cfg.OnFinish) end
    end

    local BG = New("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(2, 2, 4),
        BackgroundTransparency = 0.15, BorderSizePixel = 0, ClipsDescendants = true, Parent = Gui})
    AddParticles(BG, 18)

    local Card = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(0, 0), BackgroundColor3 = T.Bg, ClipsDescendants = true, Parent = Gui})
    Corner(Card, 28)
    local st = Stroke(Card, T.Primary, 0.15, 2)
    local g1 = New("UIGradient", {Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, T.Primary), ColorSequenceKeypoint.new(0.5, T.Primary2), ColorSequenceKeypoint.new(1, T.Primary3)}, Parent = st})
    Tween(Card, 0.7, {Size = UDim2.fromOffset(320, 330)}, Enum.EasingStyle.Back)
    local hb = RunService.Heartbeat:Connect(function(dt) g1.Rotation = (g1.Rotation + 120 * dt) % 360 end)

    local LogoBox = New("Frame", {Size = UDim2.fromOffset(88, 88), Position = UDim2.new(0.5, -44, 0, 32),
        BackgroundColor3 = T.Card2, Parent = Card})
    Corner(LogoBox, 24); Stroke(LogoBox, T.Primary, 0.1, 2)
    MakeLogo(LogoBox, {Size = UDim2.fromOffset(72, 72), Position = UDim2.fromOffset(8, 8)}, 18)
    local tilt = RunService.RenderStepped:Connect(function() LogoBox.Rotation = math.sin(tick() * 2) * 2 end)

    Label(Card, {Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 134), Text = cfg.Title or "NAEI HUB",
        TextColor3 = T.Text, TextSize = 22, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Center})
    Label(Card, {Size = UDim2.new(1, 0, 0, 12), Position = UDim2.fromOffset(0, 160), Text = cfg.SubTitle or "v" .. NAEI.Version .. " • NEON OBSIDIAN",
        TextColor3 = T.Primary, TextSize = 10, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Center})

    local BarBG = New("Frame", {Size = UDim2.new(1, -40, 0, 8), Position = UDim2.fromOffset(20, 215), BackgroundColor3 = T.Off,
        ClipsDescendants = true, Parent = Card})
    Corner(BarBG, 100)
    local Bar = New("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = T.Primary, Parent = BarBG})
    Corner(Bar, 100)
    New("UIGradient", {Color = ColorSequence.new(T.Primary, T.Primary2), Parent = Bar})
    local Status = Label(Card, {Size = UDim2.new(1, -110, 0, 14), Position = UDim2.fromOffset(20, 235), Text = "INITIALIZING...",
        TextColor3 = T.Muted, TextSize = 10, Font = Enum.Font.Code})
    local Percent = Label(Card, {Size = UDim2.fromOffset(60, 20), Position = UDim2.new(1, -80, 0, 231), Text = "0%",
        TextColor3 = T.Text, TextSize = 18, Font = Enum.Font.GothamBold, TextXAlignment = Right})

    local steps = {
        {">> BOOTING NEON CORE", 25}, {">> LOADING OBSIDIAN THEME", 55},
        {">> SYNCING UI", 85}, {">> WELCOME " .. string.upper(LocalPlayer.DisplayName), 100},
    }
    task.delay(8, function() if not finished then Cleanup(true) end end) -- anti stuck

    task.spawn(function()
        local last = 0
        for _, s in ipairs(steps) do
            if finished then break end
            Status.Text = s[1]
            Tween(Bar, 0.5, {Size = UDim2.new(s[2] / 100, 0, 1, 0)}, Enum.EasingStyle.Quint)
            for i = last, s[2] do
                if finished then break end
                Percent.Text = i .. "%"
                task.wait(0.012)
            end
            last = s[2]
            task.wait(0.2)
        end
        if finished then return end
        task.wait(0.3)
        Tween(Card, 0.4, {Size = UDim2.fromOffset(0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.42)
        hb:Disconnect(); tilt:Disconnect()
        Cleanup(true)
    end)
    task.delay(9, function() pcall(function() hb:Disconnect() tilt:Disconnect() end) end)
end

-- ================= NOTIFY =================
local NotifyGui
function NAEI:Notify(title, msg, duration)
    if not (NotifyGui and NotifyGui.Parent) then
        NotifyGui = New("ScreenGui", {Name = "NAEI_NOTIFY", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 100, Parent = GetParent()})
        local holder = New("Frame", {Name = "Holder", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16),
            Size = UDim2.fromOffset(280, 400), BackgroundTransparency = 1, Parent = NotifyGui})
        New("UIListLayout", {Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Bottom,
            SortOrder = Enum.SortOrder.LayoutOrder, Parent = holder})
    end
    local wrap = New("Frame", {Size = UDim2.fromOffset(280, 0), BackgroundTransparency = 1, ClipsDescendants = true,
        Parent = NotifyGui.Holder})
    local n = New("Frame", {Size = UDim2.fromOffset(280, 68), Position = UDim2.fromOffset(300, 0), BackgroundColor3 = T.Card2, Parent = wrap})
    Corner(n, 14); Stroke(n, T.Primary, 0.3, 1)
    Label(n, {Size = UDim2.new(1, -28, 0, 18), Position = UDim2.fromOffset(14, 9), Text = title or "NAEI",
        TextColor3 = T.Primary, TextSize = 13, Font = Enum.Font.GothamBold})
    Label(n, {Size = UDim2.new(1, -28, 0, 30), Position = UDim2.fromOffset(14, 29), Text = msg or "",
        TextColor3 = T.Sub, TextSize = 11, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top})
    local bar = New("Frame", {Size = UDim2.new(1, -28, 0, 2), Position = UDim2.new(0, 14, 1, -6), BackgroundColor3 = T.Primary, BorderSizePixel = 0, Parent = n})
    Tween(wrap, 0.3, {Size = UDim2.fromOffset(280, 68)})
    Tween(n, 0.5, {Position = UDim2.fromOffset(0, 0)}, Enum.EasingStyle.Back)
    local d = duration or 3
    Tween(bar, d, {Size = UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Linear)
    task.delay(d, function()
        Tween(n, 0.35, {Position = UDim2.fromOffset(300, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        Tween(wrap, 0.25, {Size = UDim2.fromOffset(280, 0)})
        task.wait(0.27)
        wrap:Destroy()
    end)
end

-- ================= WINDOW =================
function NAEI:CreateWindow(cfg)
    cfg = cfg or {}
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local req = cfg.Size or Vector2.new(640, 420)
    local scale = cfg.Scale or (vp.X < 700 and 0.72 or 0.8)
    local WSize = Vector2.new(math.min(req.X, (vp.X - 24) / scale), math.min(req.Y, (vp.Y - 24) / scale))
    local Window = {Tabs = {}}
    local alive = true

    local Gui = New("ScreenGui", {Name = "NAEI_HUB", ResetOnSpawn = false, IgnoreGuiInset = true, Parent = GetParent()})
    local Main = New("Frame", {Size = UDim2.fromOffset(0, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = T.Bg, BackgroundTransparency = 0.02, ClipsDescendants = true, Parent = Gui})
    Corner(Main, 22)
    New("UIScale", {Scale = scale, Parent = Main})
    New("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(175, 175, 190)), Rotation = 90, Parent = Main})
    local ms = Stroke(Main, T.Primary, 0.08, 2)
    local mg = New("UIGradient", {Color = ColorSequence.new(T.Primary, T.Primary2), Rotation = 45, Parent = ms})
    Connect(RunService.Heartbeat, function(dt) if Main.Visible then mg.Rotation = (mg.Rotation + 12 * dt) % 360 end end)

    local Header = New("Frame", {Size = UDim2.new(1, 0, 0, 58), BackgroundTransparency = 1, ZIndex = 10, Parent = Main})
    EnableDrag(Main, Header)
    MakeLogo(Header, {Size = UDim2.fromOffset(36, 36), Position = UDim2.fromOffset(18, 11)}, 12)
    Label(Header, {Size = UDim2.new(1, -200, 0, 18), Position = UDim2.fromOffset(62, 12), Text = cfg.Title or "NAEI HUB",
        TextColor3 = T.Text, TextSize = 16, Font = Enum.Font.GothamBold})
    Label(Header, {Size = UDim2.new(1, -200, 0, 12), Position = UDim2.fromOffset(62, 33), Text = cfg.Subtitle or ("v" .. NAEI.Version .. " • NEON OBSIDIAN"),
        TextColor3 = T.Primary, TextSize = 9, Font = Enum.Font.Code})

    local function TopBtn(txt, x)
        local b = New("TextButton", {Size = UDim2.fromOffset(36, 36), Position = UDim2.new(1, x, 0, 11), BackgroundColor3 = T.Card,
            Text = txt, TextColor3 = T.Sub, TextSize = 16, Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = Header})
        Corner(b, 12); Stroke(b, T.Border, 0.5, 1)
        Connect(b.MouseEnter, function() Tween(b, 0.2, {BackgroundColor3 = T.Hover}) end)
        Connect(b.MouseLeave, function() Tween(b, 0.2, {BackgroundColor3 = T.Card}) end)
        return b
    end
    local CloseBtn, MinBtn = TopBtn("✕", -48), TopBtn("—", -92)

    local TopDock = New("ScrollingFrame", {Size = UDim2.new(1, -24, 0, 48), Position = UDim2.fromOffset(12, 60), BackgroundColor3 = T.BgSub,
        BackgroundTransparency = 0.1, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.X, BorderSizePixel = 0, Parent = Main})
    Corner(TopDock, 16); Stroke(TopDock, T.Border, 0.3, 1)
    New("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Center, Parent = TopDock})
    New("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = TopDock})

    local Content = New("Frame", {Size = UDim2.new(1, -24, 1, -122), Position = UDim2.fromOffset(12, 116), BackgroundTransparency = 1,
        ClipsDescendants = true, Parent = Main})

    local Orb = New("ImageButton", {Size = UDim2.fromOffset(0, 0), Position = UDim2.new(0, 24, 0.5, -28), BackgroundColor3 = T.Bg,
        Visible = false, ZIndex = 50, AutoButtonColor = false, Parent = Gui})
    Corner(Orb, 100)
    local OrbGlow = New("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(2.4, 2.4),
        BackgroundTransparency = 1, Image = "rbxassetid://5028857084", ImageColor3 = T.Primary, ImageTransparency = 0.8, Parent = Orb})
    local OrbStroke = Stroke(Orb, T.Primary, 0, 2)
    local OrbGrad = New("UIGradient", {Color = ColorSequence.new{ColorSequenceKeypoint.new(0, T.Primary), ColorSequenceKeypoint.new(0.5, T.Primary2),
        ColorSequenceKeypoint.new(1, T.Primary3)}, Parent = OrbStroke})
    MakeLogo(Orb, {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(0.78, 0.78), ZIndex = 51}, 100)
    Connect(RunService.Heartbeat, function(dt)
        if Orb.Visible then
            OrbGrad.Rotation = (OrbGrad.Rotation + 90 * dt) % 360
            OrbGlow.ImageTransparency = 0.78 + 0.08 * math.sin(tick() * 2.5)
        end
    end)
    EnableDrag(Orb, Orb)

    Main.BackgroundTransparency = 1
    Tween(Main, 0.7, {Size = UDim2.fromOffset(WSize.X, WSize.Y), BackgroundTransparency = 0.02}, Enum.EasingStyle.Back)

    -- minimize / restore (debounced)
    local busy, hidden = false, false
    local function SetHidden(s)
        if busy or not alive or hidden == s then return end
        busy, hidden = true, s
        task.spawn(function()
            if s then
                Tween(Main, 0.3, {Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.wait(0.3); Main.Visible = false
                Orb.Visible = true; Orb.Size = UDim2.fromOffset(0, 0)
                Tween(Orb, 0.4, {Size = UDim2.fromOffset(56, 56)}, Enum.EasingStyle.Back)
            else
                Tween(Orb, 0.2, {Size = UDim2.fromOffset(0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.wait(0.2); Orb.Visible = false
                Main.Visible = true; Main.Size = UDim2.fromOffset(0, 0)
                Tween(Main, 0.5, {Size = UDim2.fromOffset(WSize.X, WSize.Y), BackgroundTransparency = 0.02}, Enum.EasingStyle.Back)
            end
            task.wait(0.1); busy = false
        end)
    end
    Window.SetHidden = function(_, s) SetHidden(s) end

    -- Orb: ลากได้ + คลิกเพื่อเปิด (ไม่เปิดตอนลาก)
    local orbDown
    Connect(Orb.MouseButton1Down, function() orbDown = Orb.AbsolutePosition end)
    Connect(Orb.MouseButton1Up, function()
        if orbDown and (Orb.AbsolutePosition - orbDown).Magnitude < 6 then SetHidden(false) end
    end)
    Connect(MinBtn.MouseButton1Click, function() SetHidden(true) end)
    if cfg.ToggleKey then
        Connect(UserInputService.InputBegan, function(i, gp)
            if not gp and i.KeyCode == cfg.ToggleKey then SetHidden(not hidden) end
        end)
    end

    function Window:Destroy()
        if not alive then return end
        alive = false
        Tween(Main, 0.3, {Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        for _, c in ipairs(NAEI.Connections) do pcall(function() c:Disconnect() end) end
        NAEI.Connections = {}
        Gui:Destroy()
    end
    Connect(CloseBtn.MouseButton1Click, function() task.spawn(Window.Destroy, Window) end)

    -- ===== Config save/load =====
    function Window:SaveConfig(name)
        if not (writefile and makefolder) then return NAEI:Notify("Config", "Executor ไม่รองรับ writefile", 3) end
        pcall(function() if not isfolder(NAEI.ConfigFolder) then makefolder(NAEI.ConfigFolder) end end)
        local data = {}
        for k, v in pairs(NAEI.Flags) do
            data[k] = typeof(v) == "EnumItem" and {__enum = tostring(v)} or v
        end
        local ok = pcall(function() writefile(NAEI.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data)) end)
        NAEI:Notify("Config", ok and ("บันทึก " .. name .. " แล้ว") or "บันทึกไม่สำเร็จ", 3)
    end
    function Window:LoadConfig(name)
        local path = NAEI.ConfigFolder .. "/" .. name .. ".json"
        if not (isfile and isfile(path)) then return NAEI:Notify("Config", "ไม่พบ " .. name, 3) end
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        if not ok then return NAEI:Notify("Config", "ไฟล์เสีย", 3) end
        for k, v in pairs(data) do
            local set = NAEI.Setters[k]
            if set then
                if type(v) == "table" and v.__enum then
                    local name2 = tostring(v.__enum):match("Enum%.KeyCode%.(.+)")
                    v = name2 and Enum.KeyCode[name2] or nil
                end
                if v ~= nil then pcall(set, v) end
            end
        end
        NAEI:Notify("Config", "โหลด " .. name .. " แล้ว", 3)
    end

    -- ===== TABS =====
    function Window:CreateTab(name, icon)
        local Tab = {}
        local Btn = New("TextButton", {Size = UDim2.fromOffset(124, 34), BackgroundColor3 = T.Card2, BackgroundTransparency = 1,
            Text = "", AutoButtonColor = false, Parent = TopDock})
        Corner(Btn, 12)
        local BStroke = Stroke(Btn, T.Border, 1, 1)
        local Icon = New("TextLabel", {Size = UDim2.fromOffset(22, 22), Position = UDim2.fromOffset(10, 6), BackgroundTransparency = 1,
            Text = icon or "●", TextColor3 = T.Sub, TextSize = 13, Font = Enum.Font.GothamBold, Parent = Btn})
        local Lbl = Label(Btn, {Size = UDim2.new(1, -40, 1, 0), Position = UDim2.fromOffset(34, 0), Text = name, TextColor3 = T.Sub,
            TextSize = 12, Font = Enum.Font.GothamBold, TextTruncate = Enum.TextTruncate.AtEnd})
        local Page = New("ScrollingFrame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ScrollBarThickness = 3,
            ScrollBarImageColor3 = T.Primary, BorderSizePixel = 0, CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = Content})
        New("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Page})
        New("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 12), PaddingBottom = UDim.new(0, 16), Parent = Page})

        Connect(Btn.MouseEnter, function() if not Page.Visible then Tween(Btn, 0.2, {BackgroundTransparency = 0.5}) end end)
        Connect(Btn.MouseLeave, function() if not Page.Visible then Tween(Btn, 0.2, {BackgroundTransparency = 1}) end end)

        Tab.Button, Tab.Label, Tab.Icon, Tab.Page, Tab.Stroke = Btn, Lbl, Icon, Page, BStroke
        function Tab:Select()
            for _, t in ipairs(Window.Tabs) do
                Tween(t.Button, 0.25, {BackgroundTransparency = 1})
                t.Stroke.Transparency = 1
                t.Label.TextColor3, t.Icon.TextColor3 = T.Sub, T.Sub
                t.Page.Visible = false
            end
            Tween(Btn, 0.3, {BackgroundTransparency = 0})
            BStroke.Transparency = 0.2; BStroke.Color = T.Primary
            Lbl.TextColor3, Icon.TextColor3 = T.Primary, T.Primary
            Page.Visible = true
        end
        Connect(Btn.MouseButton1Click, function() Tab:Select() end)

        -- ---- Components ----
        function Tab:AddSection(txt)
            local f = New("Frame", {Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Parent = Page})
            New("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromScale(0, 0.5), BackgroundColor3 = T.Border,
                BackgroundTransparency = 0.3, BorderSizePixel = 0, Parent = f})
            local l = Label(f, {AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 26), Position = UDim2.fromOffset(6, 0),
                BackgroundTransparency = 0, BackgroundColor3 = T.Bg, Text = "  " .. string.upper(txt) .. "  ",
                TextColor3 = T.Primary2, TextSize = 11, Font = Enum.Font.Code})
            return f
        end

        function Tab:AddLabel(text)
            local f = CardFrame(Page, 34)
            local l = Label(f, {Size = UDim2.new(1, -28, 1, 0), Position = UDim2.fromOffset(14, 0), Text = text, TextColor3 = T.Sub, TextSize = 12})
            return {Set = function(_, t) l.Text = t end, Frame = f}
        end

        function Tab:AddParagraph(c)
            c = c or {}
            local f = New("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = T.Card,
                BackgroundTransparency = 0.3, Parent = Page})
            Corner(f, 14); Stroke(f, T.Border, 0.6, 1)
            New("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14), Parent = f})
            New("UIListLayout", {Padding = UDim.new(0, 4), Parent = f})
            Label(f, {Size = UDim2.new(1, 0, 0, 16), Text = c.Title or "Info", TextColor3 = T.Text, TextSize = 13, Font = Enum.Font.GothamBold})
            Label(f, {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = c.Content or "", TextColor3 = T.Sub,
                TextSize = 11, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top})
            return f
        end

        function Tab:AddButton(c)
            c = c or {}
            local f, s = CardFrame(Page, 52)
            local b = New("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = f})
            Label(b, {Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(16, 0), Text = c.Name or "Button", TextColor3 = T.Text,
                TextSize = 13, Font = Enum.Font.GothamMedium})
            local arrow = New("Frame", {Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, -42, 0.5, -15), BackgroundColor3 = T.Primary,
                BackgroundTransparency = 0.9, Parent = b})
            Corner(arrow, 10)
            New("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "→", TextColor3 = T.Bg, TextSize = 16,
                Font = Enum.Font.GothamBold, Parent = arrow})
            Hover(b, f, s)
            Connect(b.MouseEnter, function() Tween(arrow, 0.2, {BackgroundTransparency = 0}) end)
            Connect(b.MouseLeave, function() Tween(arrow, 0.2, {BackgroundTransparency = 0.9}) end)
            Connect(b.MouseButton1Click, function()
                Tween(f, 0.06, {Size = UDim2.new(1, -6, 0, 48)})
                task.delay(0.06, function() Tween(f, 0.25, {Size = UDim2.new(1, 0, 0, 52)}, Enum.EasingStyle.Back) end)
                if c.Callback then task.spawn(pcall, c.Callback) end
            end)
            return f
        end

        function Tab:AddToggle(c)
            c = c or {}
            local state = c.Default == true
            local f = CardFrame(Page, c.Desc and 58 or 52)
            Label(f, {Size = UDim2.new(1, -90, 0, 16), Position = UDim2.fromOffset(16, c.Desc and 11 or 18), Text = c.Name or "Toggle",
                TextColor3 = T.Text, TextSize = 13, Font = Enum.Font.GothamMedium})
            if c.Desc then
                Label(f, {Size = UDim2.new(1, -90, 0, 12), Position = UDim2.fromOffset(16, 31), Text = c.Desc, TextColor3 = T.Muted, TextSize = 10})
            end
            local Track = New("Frame", {Size = UDim2.fromOffset(52, 28), Position = UDim2.new(1, -68, 0.5, -14),
                BackgroundColor3 = state and T.Primary or T.Off, Parent = f})
            Corner(Track, 14)
            local Thumb = New("Frame", {Size = UDim2.fromOffset(22, 22), Position = state and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11),
                BackgroundColor3 = Color3.new(1, 1, 1), Parent = Track})
            Corner(Thumb, 100)
            local obj = {}
            local function apply(v, silent)
                state = v; SetFlag(c.Flag, v)
                Tween(Track, 0.3, {BackgroundColor3 = v and T.Primary or T.Off})
                Tween(Thumb, 0.35, {Position = v and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)}, Enum.EasingStyle.Back)
                if not silent and c.Callback then task.spawn(pcall, c.Callback, v) end
            end
            function obj:Set(v) apply(v == true) end
            function obj:Get() return state end
            local b = New("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = f})
            Connect(b.MouseButton1Click, function() apply(not state) end)
            SetFlag(c.Flag, state); Register(c.Flag, function(v) apply(v == true) end)
            return obj
        end

        function Tab:AddSlider(c)
            c = c or {}
            local min, max, inc = c.Min or 0, c.Max or 100, c.Increment or 1
            local val = math.clamp(c.Default or min, min, max)
            local f = CardFrame(Page, 64)
            Label(f, {Size = UDim2.new(1, -100, 0, 16), Position = UDim2.fromOffset(16, 10), Text = c.Name or "Slider", TextColor3 = T.Text,
                TextSize = 13, Font = Enum.Font.GothamMedium})
            local valLbl = New("TextLabel", {Size = UDim2.fromOffset(64, 18), Position = UDim2.new(1, -78, 0, 9), BackgroundColor3 = T.BgSub,
                Text = "", TextColor3 = T.Primary, TextSize = 11, Font = Enum.Font.Code, Parent = f})
            Corner(valLbl, 6)
            local track = New("Frame", {Size = UDim2.new(1, -32, 0, 6), Position = UDim2.fromOffset(16, 42), BackgroundColor3 = T.Off, Parent = f})
            Corner(track, 100)
            local fill = New("Frame", {Size = UDim2.fromScale(0, 1), BackgroundColor3 = T.Primary, Parent = track})
            Corner(fill, 100)
            New("UIGradient", {Color = ColorSequence.new(T.Primary, T.Primary2), Parent = fill})
            local knob = New("Frame", {Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5),
                BackgroundColor3 = Color3.new(1, 1, 1), Parent = track})
            Corner(knob, 100); Stroke(knob, T.Primary, 0, 2)

            local function render(v, animate)
                local rel = (max == min) and 0 or (v - min) / (max - min)
                valLbl.Text = tostring(v) .. (c.Suffix or "")
                local t = animate and 0.1 or 0
                Tween(fill, t, {Size = UDim2.fromScale(rel, 1)}); Tween(knob, t, {Position = UDim2.fromScale(rel, 0.5)})
            end
            local function set(v, silent)
                v = math.clamp(math.floor((v - min) / inc + 0.5) * inc + min, min, max)
                v = tonumber(string.format("%.4g", v))
                if v == val and not silent then return end
                val = v; render(v, true); SetFlag(c.Flag, v)
                if not silent and c.Callback then task.spawn(pcall, c.Callback, v) end
            end
            local function fromInput(i)
                local rel = math.clamp((i.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                set(min + rel * (max - min))
            end
            local drag = false
            Connect(track.InputBegan, function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    drag = true; Page.ScrollingEnabled = false; fromInput(i)
                end
            end)
            Connect(UserInputService.InputChanged, function(i)
                if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then fromInput(i) end
            end)
            Connect(UserInputService.InputEnded, function(i)
                if drag and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
                    drag = false; Page.ScrollingEnabled = true
                end
            end)
            render(val, false); SetFlag(c.Flag, val); Register(c.Flag, function(v) set(v) end)
            return {Set = function(_, v) set(v) end, Get = function() return val end}
        end

        function Tab:AddDropdown(c)
            c = c or {}
            local opts, cur, open = c.Options or {}, c.Default, false
            local f, s = CardFrame(Page, 52)
            f.ClipsDescendants = true
            Label(f, {Size = UDim2.new(0.5, -16, 0, 52), Position = UDim2.fromOffset(16, 0), Text = c.Name or "Dropdown", TextColor3 = T.Text,
                TextSize = 13, Font = Enum.Font.GothamMedium})
            local valLbl = Label(f, {Size = UDim2.new(0.5, -44, 0, 52), Position = UDim2.new(0.5, 0, 0, 0), Text = tostring(cur or "เลือก..."),
                TextColor3 = T.Primary, TextSize = 12, Font = Enum.Font.Code, TextXAlignment = Right, TextTruncate = Enum.TextTruncate.AtEnd})
            local arrow = Label(f, {Size = UDim2.fromOffset(24, 52), Position = UDim2.new(1, -30, 0, 0), Text = "▾", TextColor3 = T.Sub,
                TextSize = 16, TextXAlignment = Enum.TextXAlignment.Center})
            local head = New("TextButton", {Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1, Text = "", Parent = f})
            local list = New("ScrollingFrame", {Size = UDim2.new(1, -20, 0, 0), Position = UDim2.fromOffset(10, 56), BackgroundTransparency = 1,
                ScrollBarThickness = 2, ScrollBarImageColor3 = T.Primary, BorderSizePixel = 0, CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = f})
            New("UIListLayout", {Padding = UDim.new(0, 4), Parent = list})
            local function listH() return math.min(#opts, 5) * 34 end
            local function resize() Tween(f, 0.25, {Size = UDim2.new(1, 0, 0, open and (52 + listH() + 12) or 52)}); list.Size = UDim2.new(1, -20, 0, listH()) end
            local function setVal(v, silent)
                cur = v; valLbl.Text = tostring(v); SetFlag(c.Flag, v)
                if not silent and c.Callback then task.spawn(pcall, c.Callback, v) end
            end
            local function build()
                for _, ch in ipairs(list:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
                for _, o in ipairs(opts) do
                    local ob = New("TextButton", {Size = UDim2.new(1, -4, 0, 30), BackgroundColor3 = T.Card2, Text = tostring(o),
                        TextColor3 = (o == cur) and T.Primary or T.Sub, TextSize = 12, Font = Enum.Font.Gotham, AutoButtonColor = false, Parent = list})
                    Corner(ob, 8)
                    Connect(ob.MouseEnter, function() Tween(ob, 0.15, {BackgroundColor3 = T.Hover}) end)
                    Connect(ob.MouseLeave, function() Tween(ob, 0.15, {BackgroundColor3 = T.Card2}) end)
                    Connect(ob.MouseButton1Click, function()
                        setVal(o); open = false; resize(); Tween(arrow, 0.25, {Rotation = 0}); build()
                    end)
                end
                resize()
            end
            Hover(head, f, s)
            Connect(head.MouseButton1Click, function() open = not open; Tween(arrow, 0.25, {Rotation = open and 180 or 0}); resize() end)
            build(); SetFlag(c.Flag, cur); Register(c.Flag, function(v) setVal(v); build() end)
            return {
                Set = function(_, v) setVal(v); build() end,
                Get = function() return cur end,
                Refresh = function(_, newOpts) opts = newOpts or {}; build() end,
            }
        end

        function Tab:AddTextBox(c)
            c = c or {}
            local f = CardFrame(Page, 52)
            Label(f, {Size = UDim2.new(0.4, -16, 1, 0), Position = UDim2.fromOffset(16, 0), Text = c.Name or "TextBox", TextColor3 = T.Text,
                TextSize = 13, Font = Enum.Font.GothamMedium})
            local box = New("TextBox", {Size = UDim2.new(0.6, -28, 0, 30), Position = UDim2.new(0.4, 0, 0.5, -15), BackgroundColor3 = T.BgSub,
                Text = c.Default or "", PlaceholderText = c.Placeholder or "", PlaceholderColor3 = T.Muted, TextColor3 = T.Primary,
                TextSize = 12, Font = Enum.Font.Code, ClearTextOnFocus = false, Parent = f})
            Corner(box, 8)
            local bs = Stroke(box, T.Border, 0.4, 1)
            Connect(box.Focused, function() Tween(bs, 0.2, {Color = T.Primary, Transparency = 0}) end)
            Connect(box.FocusLost, function(enter)
                Tween(bs, 0.2, {Color = T.Border, Transparency = 0.4})
                SetFlag(c.Flag, box.Text)
                if c.Callback then task.spawn(pcall, c.Callback, box.Text, enter) end
            end)
            SetFlag(c.Flag, box.Text); Register(c.Flag, function(v) box.Text = tostring(v); SetFlag(c.Flag, box.Text) end)
            return {Set = function(_, v) box.Text = tostring(v) end, Get = function() return box.Text end}
        end

        function Tab:AddKeybind(c)
            c = c or {}
            local key, listening = c.Default, false
            local f, s = CardFrame(Page, 52)
            Label(f, {Size = UDim2.new(1, -120, 1, 0), Position = UDim2.fromOffset(16, 0), Text = c.Name or "Keybind", TextColor3 = T.Text,
                TextSize = 13, Font = Enum.Font.GothamMedium})
            local kb = New("TextButton", {Size = UDim2.fromOffset(86, 28), Position = UDim2.new(1, -100, 0.5, -14), BackgroundColor3 = T.BgSub,
                Text = key and key.Name or "None", TextColor3 = T.Primary, TextSize = 11, Font = Enum.Font.Code, AutoButtonColor = false, Parent = f})
            Corner(kb, 8); Stroke(kb, T.Border, 0.4, 1)
            local function setKey(k) key = k; kb.Text = k and k.Name or "None"; SetFlag(c.Flag, k) end
            Connect(kb.MouseButton1Click, function() listening = true; kb.Text = "..." end)
            Connect(UserInputService.InputBegan, function(i, gp)
                if listening and i.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    setKey(i.KeyCode == Enum.KeyCode.Escape and nil or i.KeyCode)
                    if c.ChangedCallback then task.spawn(pcall, c.ChangedCallback, key) end
                elseif not gp and key and i.KeyCode == key and c.Callback then
                    task.spawn(pcall, c.Callback, key)
                end
            end)
            SetFlag(c.Flag, key); Register(c.Flag, setKey)
            return {Set = function(_, k) setKey(k) end, Get = function() return key end}
        end

        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then Tab:Select() end
        return Tab
    end

    return Window
end

return NAEI