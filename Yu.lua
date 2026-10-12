--[[
    NAEI HUB v2.1 - OBSIDIAN LOADER EDITION
    Logo URI: https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local NAEI = {}
NAEI.Version = "2.1-Loader"
NAEI.Theme = {
    Background = Color3.fromRGB(18,18,20),
    Background2 = Color3.fromRGB(24,24,27),
    Card = Color3.fromRGB(32,32,36),
    CardHover = Color3.fromRGB(42,42,48),
    Primary = Color3.fromRGB(168,85,255),
    PrimaryAccent = Color3.fromRGB(120,119,255),
    Text = Color3.fromRGB(250,250,252),
    SubText = Color3.fromRGB(161,161,170),
    Muted = Color3.fromRGB(113,113,122),
    Border = Color3.fromRGB(39,39,42),
    Success = Color3.fromRGB(34,197,94),
}
NAEI.LogoUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg"
NAEI.LogoFile = "naei_logo_loader.jpg"
NAEI.BackgroundUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg" -- ใช้รูปเดียวกันทำเบลอหลังได้

local function Create(c,p) local o=Instance.new(c) for k,v in pairs(p or {}) do pcall(function() o[k]=v end) end return o end
local function Corner(o,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 10) c.Parent=o return c end
local function Stroke(o,c,t,th) local s=Instance.new("UIStroke") s.Color=c or NAEI.Theme.Border s.Transparency=t or 0.5 s.Thickness=th or 1 s.Parent=o return s end
local function Tween(o,tm,prop,info) TweenService:Create(o, info or TweenInfo.new(tm, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), prop):Play() end
local function GetParent() return typeof(gethui)=="function" and select(2,pcall(gethui)) or LocalPlayer:WaitForChild("PlayerGui") end

-- โหลดรูปจาก URL เป็น asset ในเครื่อง (รองรับทุก Executor)
local function LoadImageFromUrl(url, fileName)
    local getAsset = getcustomasset or getsynasset
    if not (getAsset and writefile and isfile) then
        return url -- ถ้า executor ไม่รองรับ ให้ใช้ url ตรงๆ
    end
    local success, asset = pcall(function()
        if not isfile(fileName) then
            local data = game:HttpGet(url)
            writefile(fileName, data)
        end
        return getAsset(fileName)
    end)
    if success and asset then return asset else return url end
end

--=========================================================
-- LOADING SCREEN - สวยจัดๆ 1000x
--=========================================================
function NAEI:ShowLoader(config)
    config = config or {}
    local title = config.Title or "NAEI HUB"
    local sub = config.SubTitle or "OBSIDIAN EDITION"
    local onFinish = config.OnFinish or function() end

    local ScreenGui = Create("ScreenGui", {Name="NAEI_LOADER_"..math.random(1000,9999), ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    ScreenGui.Parent = GetParent()

    local Blur = Create("BlurEffect", {Size=0, Parent=game:GetService("Lighting")})
    Tween(Blur, 0.5, {Size=24})

    -- Fullscreen Background
    local BG = Create("Frame", {Size=UDim2.fromScale(1,1), BackgroundColor3=NAEI.Theme.Background, Parent=ScreenGui})
    local BgImage = Create("ImageLabel", {
        Size=UDim2.fromScale(1.2,1.2), Position=UDim2.fromScale(-0.1,-0.1),
        BackgroundTransparency=1, Image=LoadImageFromUrl(NAEI.LogoUrl, NAEI.LogoFile),
        ImageTransparency=0.92, ScaleType=Enum.ScaleType.Crop, Parent=BG
    })
    Corner(BgImage, 0)
    -- Parallax ขยับเบาๆ
    RunService.RenderStepped:Connect(function()
        if BgImage.Parent then
            BgImage.Position = UDim2.fromScale(-0.1 + math.sin(tick()*0.2)*0.02, -0.1 + math.cos(tick()*0.2)*0.02)
        end
    end)

    local Vignette = Create("Frame", {Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.3, Parent=BG})
    Instance.new("UIGradient", Vignette).Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18,18,20)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18,18,20):Lerp(Color3.new(0,0,0), 0.5)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
    }

    -- Center Card
    local Card = Create("Frame", {
        Size=UDim2.fromOffset(320, 380), AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
        BackgroundColor3=NAEI.Theme.Card, BackgroundTransparency=0.15, Parent=ScreenGui
    })
    Corner(Card, 24)
    Stroke(Card, Color3.new(1,1,1), 0.9, 1)

    local GradStroke = Stroke(Card, NAEI.Theme.Primary, 0.7, 1.5)
    local G = Instance.new("UIGradient", GradStroke)
    G.Color = ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.PrimaryAccent)
    G.Rotation = 0
    task.spawn(function() while Card.Parent do for i=0,360,1 do G.Rotation=i task.wait(0.015) end end end)

    Card.Size = UDim2.fromOffset(0,0)
    Tween(Card, 0.6, {Size=UDim2.fromOffset(320,380)}, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out))

    -- Logo Container แบบวงกลมมีแสง
    local LogoRing = Create("Frame", {Size=UDim2.fromOffset(120,120), Position=UDim2.new(0.5,-60,0,40), BackgroundColor3=NAEI.Theme.Background2, Parent=Card})
    Corner(LogoRing, 100)
    Stroke(LogoRing, NAEI.Theme.Primary, 0.4, 2)

    local LogoRing2 = Create("Frame", {Size=UDim2.fromOffset(140,140), Position=UDim2.new(0.5,-70,0,30), BackgroundTransparency=1, Parent=Card})
    Corner(LogoRing2, 100)
    Stroke(LogoRing2, NAEI.Theme.Primary, 0.8, 1.5)
    -- หมุนวงนอก
    task.spawn(function() while LogoRing2.Parent do LogoRing2.Rotation = LogoRing2.Rotation + 1 task.wait(0.01) end end)

    local LogoImage = Create("ImageLabel", {
        Size=UDim2.fromOffset(100,100), Position=UDim2.fromOffset(10,10),
        BackgroundTransparency=1, Image=LoadImageFromUrl(NAEI.LogoUrl, NAEI.LogoFile),
        ScaleType=Enum.ScaleType.Crop, Parent=LogoRing
    })
    Corner(LogoImage, 100)
    -- Pulse Animation
    local pulseScale = Instance.new("UIScale", LogoRing)
    task.spawn(function() while LogoRing.Parent do Tween(pulseScale, 1, {Scale=1.08}, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)) task.wait(1) Tween(pulseScale, 1, {Scale=1}, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)) task.wait(1) end end)

    Create("TextLabel", {Size=UDim2.new(1,0,0,28), Position=UDim2.fromOffset(0,175), BackgroundTransparency=1, Text=title, TextColor3=NAEI.Theme.Text, TextSize=22, Font=Enum.Font.GothamBold, Parent=Card})
    Create("TextLabel", {Size=UDim2.new(1,0,0,18), Position=UDim2.fromOffset(0,202), BackgroundTransparency=1, Text=sub, TextColor3=NAEI.Theme.SubText, TextSize=12, Font=Enum.Font.Gotham, Parent=Card})

    -- Loading Bar สวยๆ
    local BarBG = Create("Frame", {Size=UDim2.new(1,-48,0,6), Position=UDim2.fromOffset(24,250), BackgroundColor3=Color3.fromRGB(50,50,55), Parent=Card}) Corner(BarBG, 100)
    local BarFill = Create("Frame", {Size=UDim2.new(0,0,1,0), BackgroundColor3=NAEI.Theme.Primary, Parent=BarBG}) Corner(BarFill, 100)
    local BarGrad = Instance.new("UIGradient", BarFill) BarGrad.Color = ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.PrimaryAccent)

    local Status = Create("TextLabel", {Size=UDim2.new(1,-48,0,18), Position=UDim2.fromOffset(24,265), BackgroundTransparency=1, Text="Initializing...", TextColor3=NAEI.Theme.Muted, TextSize=11, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Center, Parent=Card})
    local Percent = Create("TextLabel", {Size=UDim2.new(1,-48,0,18), Position=UDim2.fromOffset(24,283), BackgroundTransparency=1, Text="0%", TextColor3=NAEI.Theme.Primary, TextSize=12, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Center, Parent=Card})

    -- Fake Loading Steps
    local steps = {
        {"Loading assets...", 20},
        {"Connecting to NAEI...", 45},
        {"Verifying logo...", 70},
        {"Almost ready...", 90},
        {"Welcome!", 100},
    }

    task.spawn(function()
        for i, step in ipairs(steps) do
            Status.Text = step[1]
            Tween(BarFill, 0.5, {Size=UDim2.new(step[2]/100,0,1,0)})
            for p = (steps[i-1] and steps[i-1][2] or 0), step[2] do
                Percent.Text = p.."%"
                task.wait(0.015)
            end
            task.wait(0.3)
        end
        task.wait(0.4)
        -- Fade Out
        Tween(Blur, 0.3, {Size=0})
        Tween(Card, 0.4, {Size=UDim2.fromOffset(0,0), BackgroundTransparency=1}, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In))
        Tween(BG, 0.4, {BackgroundTransparency=1})
        task.wait(0.4)
        ScreenGui:Destroy()
        Blur:Destroy()
        onFinish()
    end)

    return ScreenGui
end

-- วิธีเรียกใช้ 2 บรรทัดจบ
-- NAEI:ShowLoader({Title="NAEI HUB", SubTitle="LOADING...", OnFinish=function() -- เปิดหน้าต่างหลักตรงนี้ end})

return NAEI