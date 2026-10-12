--[[
    NAEI HUB v4.0 - COMPLETE FIXED EDITION
    FIX: มีทั้ง Loader สวย + Hub หลักครบแล้ว
    Logo: https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg
]]
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local NAEI = {}
NAEI.Version = "4.0-FIXED"
NAEI.Theme = {
    Background = Color3.fromRGB(18,18,20), Background2 = Color3.fromRGB(24,24,27),
    Card = Color3.fromRGB(32,32,36), CardHover = Color3.fromRGB(42,42,48),
    Primary = Color3.fromRGB(168,85,255), PrimaryAccent = Color3.fromRGB(120,119,255),
    Text = Color3.fromRGB(250,250,252), SubText = Color3.fromRGB(161,161,170),
    Muted = Color3.fromRGB(113,113,122), Border = Color3.fromRGB(39,39,42),
    ToggleOff = Color3.fromRGB(63,63,70), Success = Color3.fromRGB(34,197,94), Danger=Color3.fromRGB(239,68,68)
}
NAEI.LogoUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg"
NAEI.LogoFile = "naei_v4_logo.jpg"

local function Create(c,p) local o=Instance.new(c) for k,v in pairs(p or {}) do pcall(function() o[k]=v end) end return o end
local function Corner(o,r) Instance.new("UICorner",o).CornerRadius=UDim.new(0,r or 10) return o end
local function Stroke(o,c,t,th) local s=Instance.new("UIStroke") s.Color=c or NAEI.Theme.Border s.Transparency=t or 0.5 s.Thickness=th or 1 s.Parent=o return s end
local function Tween(o,tm,prop,info) TweenService:Create(o, info or TweenInfo.new(tm, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), prop):Play() end
local function GetParent() return typeof(gethui)=="function" and select(2,pcall(gethui)) or LocalPlayer:WaitForChild("PlayerGui") end
local function LoadImageFromUrl(url, fileName)
    local getAsset = getcustomasset or getsynasset
    if not (getAsset and writefile and isfile) then return url end
    local ok, asset = pcall(function() if not isfile(fileName) then writefile(fileName, game:HttpGet(url)) end return getAsset(fileName) end)
    return ok and asset or url
end

-- =================================================================
-- 1. LOADER ใหม่ สวยกว่าเดิม 1000x
-- =================================================================
function NAEI:ShowLoader(config)
    config=config or {}
    local onFinish=config.OnFinish or function() end
    local ScreenGui=Create("ScreenGui",{Name="NAEI_LOADER", ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling}) ScreenGui.Parent=GetParent()
    local Blur=Create("BlurEffect",{Size=0, Parent=game:GetService("Lighting")}) Tween(Blur,0.5,{Size=20})

    local BG=Create("Frame",{Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.fromRGB(10,10,12), Parent=ScreenGui})
    local BgImg=Create("ImageLabel",{Size=UDim2.fromScale(1.2,1.2), Position=UDim2.fromScale(-0.1,-0.1), BackgroundTransparency=1, Image=LoadImageFromUrl(NAEI.LogoUrl, NAEI.LogoFile), ImageTransparency=0.92, ScaleType=Enum.ScaleType.Crop, Parent=BG})

    -- Card กลางจอ
    local Card=Create("Frame",{Size=UDim2.fromOffset(340,400), AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5), BackgroundColor3=Color3.fromRGB(28,28,32), BackgroundTransparency=0.05, Parent=ScreenGui})
    Corner(Card,24) Stroke(Card, Color3.new(1,1,1), 0.9, 1)
    local outer=Stroke(Card, NAEI.Theme.Primary, 0.2, 2) local g=Instance.new("UIGradient",outer) g.Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.PrimaryAccent)
    task.spawn(function() while Card.Parent do g.Rotation=(g.Rotation+1)%360 task.wait(0.02) end end)
    Card.Size=UDim2.fromOffset(0,0) Tween(Card,0.6,{Size=UDim2.fromOffset(340,400)}, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out))

    -- Logo วงกลม + แหวนหมุน
    local LogoWrap=Create("Frame",{Size=UDim2.fromOffset(120,120), Position=UDim2.new(0.5,-60,0,35), BackgroundColor3=Color3.fromRGB(20,20,23), Parent=Card}) Corner(LogoWrap,100) Stroke(LogoWrap, NAEI.Theme.Primary, 0.3, 2)
    local Logo=Create("ImageLabel",{Size=UDim2.fromOffset(100,100), Position=UDim2.fromOffset(10,10), BackgroundTransparency=1, Image=LoadImageFromUrl(NAEI.LogoUrl, NAEI.LogoFile), ScaleType=Enum.ScaleType.Crop, Parent=LogoWrap}) Corner(Logo,100)
    local Ring=Create("Frame",{Size=UDim2.fromOffset(140,140), Position=UDim2.new(0.5,-70,0,25), BackgroundTransparency=1, Parent=Card}) Corner(Ring,100) Stroke(Ring, NAEI.Theme.Primary, 0.7, 2) Ring.Rotation=0
    local Ring2=Create("Frame",{Size=UDim2.fromOffset(160,160), Position=UDim2.new(0.5,-80,0,15), BackgroundTransparency=1, Parent=Card}) Corner(Ring2,100) Stroke(Ring2, NAEI.Theme.PrimaryAccent, 0.85, 1)
    task.spawn(function() while Ring.Parent do Ring.Rotation+=2 Ring2.Rotation-=1 task.wait() end end)
    local scale=Instance.new("UIScale",LogoWrap) task.spawn(function() while LogoWrap.Parent do Tween(scale,1,{Scale=1.08},TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)) task.wait(1) Tween(scale,1,{Scale=1},TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)) task.wait(1) end end)

    Create("TextLabel",{Size=UDim2.new(1,0,0,28), Position=UDim2.fromOffset(0,170), BackgroundTransparency=1, Text=config.Title or "NAEI HUB", TextColor3=NAEI.Theme.Text, TextSize=22, Font=Enum.Font.GothamBold, Parent=Card})
    Create("TextLabel",{Size=UDim2.new(1,0,0,16), Position=UDim2.fromOffset(0,200), BackgroundTransparency=1, Text=config.SubTitle or "ULTIMATE EDITION • v4.0", TextColor3=NAEI.Theme.SubText, TextSize=11, Font=Enum.Font.Gotham, Parent=Card})

    local BarBG=Create("Frame",{Size=UDim2.new(1,-40,0,6), Position=UDim2.fromOffset(20,250), BackgroundColor3=Color3.fromRGB(50,50,55), Parent=Card}) Corner(BarBG,100)
    local Bar=Create("Frame",{Size=UDim2.new(0,0,1,0), BackgroundColor3=NAEI.Theme.Primary, Parent=BarBG}) Corner(Bar,100) Instance.new("UIGradient",Bar).Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.PrimaryAccent)
    local Status=Create("TextLabel",{Size=UDim2.new(1,-40,0,18), Position=UDim2.fromOffset(20,265), BackgroundTransparency=1, Text="Loading...", TextColor3=NAEI.Theme.Muted, TextSize=11, Font=Enum.Font.Gotham, TextXAlignment=Center, Parent=Card})
    local Percent=Create("TextLabel",{Size=UDim2.new(1,-40,0,18), Position=UDim2.fromOffset(20,285), BackgroundTransparency=1, Text="0%", TextColor3=NAEI.Theme.Primary, TextSize=12, Font=Enum.Font.GothamBold, TextXAlignment=Center, Parent=Card})

    local steps={{"Initializing",20},{"Connecting",45},{"Verifying Logo",70},{"Almost Ready",90},{"Welcome "..LocalPlayer.DisplayName,100}}
    task.spawn(function()
        local last=0 for _,s in ipairs(steps) do Status.Text=s[1] Tween(Bar,0.5,{Size=UDim2.new(s[2]/100,0,1,0)}) for i=last,s[2] do Percent.Text=i.."%" task.wait(0.015) end last=s[2] task.wait(0.25) end
        task.wait(0.4) Tween(Blur,0.3,{Size=0}) Tween(Card,0.4,{Size=UDim2.fromOffset(0,0)},TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In)) Tween(BG,0.3,{BackgroundTransparency=1}) task.wait(0.4) ScreenGui:Destroy() Blur:Destroy() onFinish()
    end)
end

-- =================================================================
-- 2. HUB หลัก - ตัวนี้ที่หายไป ผมใส่มาให้ครบแล้ว
-- =================================================================
function NAEI:CreateWindow(cfg)
    cfg=cfg or {} local Window={Tabs={}} local ScreenGui=Create("ScreenGui",{Name="NAEI_HUB", ResetOnSpawn=false, IgnoreGuiInset=true}) ScreenGui.Parent=GetParent()
    local Main=Create("Frame",{Size=UDim2.fromOffset(580,380), Position=UDim2.new(0.5,-290,0.5,-190), BackgroundColor3=NAEI.Theme.Background, BackgroundTransparency=0.05, Parent=ScreenGui}) Corner(Main,16) Stroke(Main, NAEI.Theme.Border,0.2,1)
    local Header=Create("Frame",{Size=UDim2.new(1,0,0,52), BackgroundTransparency=1, Parent=Main})
    local Logo=Create("ImageLabel",{Size=UDim2.fromOffset(32,32), Position=UDim2.fromOffset(14,10), BackgroundTransparency=1, Image=LoadImageFromUrl(NAEI.LogoUrl, NAEI.LogoFile), ScaleType=Enum.ScaleType.Crop, Parent=Header}) Corner(Logo,8)
    Create("TextLabel",{Size=UDim2.new(1,-180,0,20), Position=UDim2.fromOffset(56,8), BackgroundTransparency=1, Text=cfg.Title or "Naei Hub", TextColor3=NAEI.Theme.Text, TextSize=15, Font=Enum.Font.GothamBold, TextXAlignment=Left, Parent=Header})
    Create("TextLabel",{Size=UDim2.new(1,-180,0,14), Position=UDim2.fromOffset(56,28), BackgroundTransparency=1, Text=cfg.Subtitle or "Fixed Edition", TextColor3=NAEI.Theme.SubText, TextSize=11, Font=Enum.Font.Gotham, TextXAlignment=Left, Parent=Header})
    local Close=Create("TextButton",{Size=UDim2.fromOffset(32,32), Position=UDim2.new(1,-42,0,10), BackgroundColor3=NAEI.Theme.Card, Text="✕", TextColor3=NAEI.Theme.SubText, AutoButtonColor=false, Parent=Header}) Corner(Close,9)
    Close.Activated:Connect(function() ScreenGui:Destroy() end)
    local Sidebar=Create("Frame",{Size=UDim2.new(0,160,1,-62), Position=UDim2.fromOffset(8,52), BackgroundColor3=Color3.fromRGB(14,14,16), BackgroundTransparency=0.2, Parent=Main}) Corner(Sidebar,12)
    local TabHolder=Create("ScrollingFrame",{Size=UDim2.new(1,-8,1,-16), Position=UDim2.fromOffset(4,8), BackgroundTransparency=1, ScrollBarThickness=0, CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y, Parent=Sidebar}) Instance.new("UIListLayout",TabHolder).Padding=UDim.new(0,6)
    local Content=Create("Frame",{Size=UDim2.new(1,-176,1,-62), Position=UDim2.new(0,176,0,52), BackgroundTransparency=1, Parent=Main})

    -- Drag
    local drag, sPos, dPos Header.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true sPos=i.Position dPos=Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-sPos Main.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y) end end)
    UserInputService.InputEnded:Connect(function() drag=false end)

    function Window:CreateTab(name)
        local Tab={} local Btn=Create("TextButton",{Size=UDim2.new(1,-8,0,38), BackgroundColor3=NAEI.Theme.Card, BackgroundTransparency=1, Text="", AutoButtonColor=false, Parent=TabHolder}) Corner(Btn,10)
        Create("TextLabel",{Size=UDim2.new(1,-16,1,0), Position=UDim2.fromOffset(12,0), BackgroundTransparency=1, Text=name, TextColor3=NAEI.Theme.SubText, TextSize=12, Font=Enum.Font.GothamMedium, TextXAlignment=Left, Parent=Btn})
        local Page=Create("ScrollingFrame",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, ScrollBarThickness=2, ScrollBarImageColor3=NAEI.Theme.Primary, CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=false, Parent=Content}) Instance.new("UIListLayout",Page).Padding=UDim.new(0,8) Instance.new("UIPadding",Page).PaddingTop=UDim.new(0,6)
        Tab.Button=Btn Tab.Page=Page
        function Tab:Select() for _,t in ipairs(Window.Tabs) do t.Button.BackgroundTransparency=1 t.Page.Visible=false end Btn.BackgroundTransparency=0.2 Btn.BackgroundColor3=NAEI.Theme.Primary Page.Visible=true end
        Btn.Activated:Connect(function() Tab:Select() end)
        function Tab:AddSection(txt) local f=Create("Frame",{Size=UDim2.new(1,0,0,24), BackgroundTransparency=1, Parent=Page}) Create("TextLabel",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text=string.upper(txt), TextColor3=NAEI.Theme.Primary, TextSize=11, Font=Enum.Font.GothamBold, TextXAlignment=Left, Parent=f}) end
        function Tab:AddButton(c) c=c or {} local f=Create("Frame",{Size=UDim2.new(1,0,0,42), BackgroundColor3=NAEI.Theme.Card, Parent=Page}) Corner(f,10) local b=Create("TextButton",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text=c.Name or "Button", TextColor3=NAEI.Theme.Text, TextSize=13, Font=Enum.Font.GothamMedium, Parent=f}) b.Activated:Connect(function() if c.Callback then c.Callback() end end) return f end
        function Tab:AddToggle(c) c=c or {} local state=c.Default==true local f=Create("Frame",{Size=UDim2.new(1,0,0,46), BackgroundColor3=NAEI.Theme.Card, Parent=Page}) Corner(f,10) Create("TextLabel",{Size=UDim2.new(1,-70,1,0), Position=UDim2.fromOffset(12,0), BackgroundTransparency=1, Text=c.Name, TextColor3=NAEI.Theme.Text, TextSize=13, TextXAlignment=Left, Parent=f}) local tr=Create("Frame",{Size=UDim2.fromOffset(44,24), Position=UDim2.new(1,-56,0.5,-12), BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.ToggleOff, Parent=f}) Corner(tr,12) local th=Create("Frame",{Size=UDim2.fromOffset(18,18), Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9), BackgroundColor3=Color3.new(1,1,1), Parent=tr}) Corner(th,100) local btn=Create("TextButton",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", Parent=f}) btn.Activated:Connect(function() state=not state tr.BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.ToggleOff th.Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9) if c.Callback then c.Callback(state) end end) end
        table.insert(Window.Tabs,Tab) if #Window.Tabs==1 then Tab:Select() end return Tab
    end
    function Window:Destroy() ScreenGui:Destroy() end
    return Window
end

return NAEI