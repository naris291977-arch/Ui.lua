--[[
    NAEI HUB v5.0 - ULTRA BEAUTIFUL FIXED
    แก้: เล็ก + ลากได้ + สวย + มีลูกเล่น
    Logo: https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg
]]
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local NAEI = {}
NAEI.Version = "5.0-Ultra"
NAEI.Theme = {
    Bg = Color3.fromRGB(18,18,20), Bg2 = Color3.fromRGB(24,24,27),
    Card = Color3.fromRGB(32,32,36), Hover = Color3.fromRGB(44,44,50),
    Primary = Color3.fromRGB(168,85,255), Primary2 = Color3.fromRGB(120,119,255),
    Text = Color3.fromRGB(245,245,247), Sub = Color3.fromRGB(161,161,170), Muted = Color3.fromRGB(100,100,105),
    Border = Color3.fromRGB(40,40,45), Off = Color3.fromRGB(60,60,65)
}
NAEI.LogoUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg"
NAEI.LogoFile = "naei_v5.jpg"

local function New(c,p) local o=Instance.new(c) for k,v in pairs(p or {}) do pcall(function() o[k]=v end) end return o end
local function Corner(o,r) New("UICorner",{CornerRadius=UDim.new(0,r or 10), Parent=o}) end
local function Stroke(o,c,t,th) local s=New("UIStroke",{Color=c or NAEI.Theme.Border, Transparency=t or 0.5, Thickness=th or 1, Parent=o}) return s end
local function Tween(o,time,props,style) TweenService:Create(o, TweenInfo.new(time, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play() end
local function GetParent() return typeof(gethui)=="function" and select(2,pcall(gethui)) or LocalPlayer:WaitForChild("PlayerGui") end
local function GetAsset(url,file) local f=getcustomasset or getsynasset if not (f and writefile and isfile) then return url end local ok,a=pcall(function() if not isfile(file) then writefile(file, game:HttpGet(url)) end return f(file) end) return ok and a or url end

-- Ripple Effect
local function Ripple(btn)
    btn.ClipsDescendants=true
    btn.MouseButton1Down:Connect(function(x,y)
        local r=New("Frame",{Size=UDim2.fromOffset(0,0), Position=UDim2.fromOffset(x-btn.AbsolutePosition.X, y-btn.AbsolutePosition.Y), AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.new(1,1,1), BackgroundTransparency=0.7, Parent=btn}) Corner(r,100)
        Tween(r,0.5,{Size=UDim2.fromOffset(300,300), BackgroundTransparency=1}, TweenInfo.new(0.5, Enum.EasingStyle.Expo))
        task.delay(0.5,function() r:Destroy() end)
    end)
end

-- ================= LOADER สวยๆ เล็กๆ =================
function NAEI:ShowLoader(cfg)
    cfg=cfg or {}
    local onFinish=cfg.OnFinish or function() end
    local Gui=New("ScreenGui",{Name="NAEI_LOADER", ResetOnSpawn=false, IgnoreGuiInset=true}) Gui.Parent=GetParent()
    local Blur=New("BlurEffect",{Size=0, Parent=game:GetService("Lighting")}) Tween(Blur,0.4,{Size=16})

    local BG=New("Frame",{Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.fromRGB(12,12,14), Parent=Gui})
    local BgImg=New("ImageLabel",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Image=GetAsset(NAEI.LogoUrl, NAEI.LogoFile), ImageTransparency=0.93, ScaleType=Enum.ScaleType.Crop, Parent=BG})

    local Card=New("Frame",{Size=UDim2.fromOffset(300,320), AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5), BackgroundColor3=Color3.fromRGB(30,30,35), BackgroundTransparency=0.08, Parent=Gui}) Corner(Card,20) Stroke(Card, Color3.new(1,1,1),0.88,1)
    local out=Stroke(Card, NAEI.Theme.Primary,0.3,1.5) local grad=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2), Parent=out}) task.spawn(function() while Card.Parent do grad.Rotation=(grad.Rotation+2)%360 task.wait(0.02) end end)
    Card.Size=UDim2.fromOffset(0,0) Tween(Card,0.6,{Size=UDim2.fromOffset(300,320)}, TweenInfo.new(0.6, Enum.EasingStyle.Back))

    -- Logo
    local LogoBox=New("Frame",{Size=UDim2.fromOffset(90,90), Position=UDim2.new(0.5,-45,0,28), BackgroundColor3=Color3.fromRGB(22,22,26), Parent=Card}) Corner(LogoBox,100) Stroke(LogoBox, NAEI.Theme.Primary,0.4,2)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(74,74), Position=UDim2.fromOffset(8,8), BackgroundTransparency=1, Image=GetAsset(NAEI.LogoUrl, NAEI.LogoFile), ScaleType=Enum.ScaleType.Crop, Parent=LogoBox}) Corner(Logo,100)
    local Ring=New("Frame",{Size=UDim2.fromOffset(110,110), Position=UDim2.new(0.5,-55,0,18), BackgroundTransparency=1, Parent=Card}) Corner(Ring,100) Stroke(Ring, NAEI.Theme.Primary,0.7,1.5)
    local Ring2=New("Frame",{Size=UDim2.fromOffset(130,130), Position=UDim2.new(0.5,-65,0,8), BackgroundTransparency=1, Parent=Card}) Corner(Ring2,100) Stroke(Ring2, NAEI.Theme.Primary2,0.9,1)
    task.spawn(function() while Ring.Parent do Ring.Rotation+=2 Ring2.Rotation-=1.5 task.wait() end end)
    local sc=New("UIScale",{Scale=1, Parent=LogoBox}) task.spawn(function() while LogoBox.Parent do Tween(sc,0.8,{Scale=1.06},TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)) task.wait(0.8) Tween(sc,0.8,{Scale=1},TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)) task.wait(0.8) end end)

    New("TextLabel",{Size=UDim2.new(1,0,0,22), Position=UDim2.fromOffset(0,132), BackgroundTransparency=1, Text=cfg.Title or "NAEI HUB", TextColor3=NAEI.Theme.Text, TextSize=18, Font=Enum.Font.GothamBold, Parent=Card})
    New("TextLabel",{Size=UDim2.new(1,0,0,14), Position=UDim2.fromOffset(0,155), BackgroundTransparency=1, Text=cfg.SubTitle or "v5.0 • ULTRA COMPACT", TextColor3=NAEI.Theme.Sub, TextSize=10, Font=Enum.Font.Gotham, Parent=Card})

    local BarBG=New("Frame",{Size=UDim2.new(1,-40,0,5), Position=UDim2.fromOffset(20,190), BackgroundColor3=Color3.fromRGB(55,55,60), Parent=Card}) Corner(BarBG,100)
    local Bar=New("Frame",{Size=UDim2.new(0,0,1,0), BackgroundColor3=NAEI.Theme.Primary, Parent=BarBG}) Corner(Bar,100) New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2), Parent=Bar})
    local Status=New("TextLabel",{Size=UDim2.new(1,-40,0,16), Position=UDim2.fromOffset(20,202), BackgroundTransparency=1, Text="Loading...", TextColor3=NAEI.Theme.Muted, TextSize=10, Font=Enum.Font.Gotham, TextXAlignment=Center, Parent=Card})
    local Percent=New("TextLabel",{Size=UDim2.new(1,-40,0,16), Position=UDim2.fromOffset(20,220), BackgroundTransparency=1, Text="0%", TextColor3=NAEI.Theme.Primary, TextSize=11, Font=Enum.Font.GothamBold, TextXAlignment=Center, Parent=Card})

    local steps={{"Loading Assets",25},{"Connecting",50},{"Verifying",75},{"Welcome "..LocalPlayer.DisplayName,100}}
    task.spawn(function()
        local last=0 for _,s in ipairs(steps) do Status.Text=s[1] Tween(Bar,0.5,{Size=UDim2.new(s[2]/100,0,1,0)}) for i=last,s[2] do Percent.Text=i.."%" task.wait(0.012) end last=s[2] task.wait(0.2) end
        task.wait(0.3) Tween(Blur,0.3,{Size=0}) Tween(Card,0.35,{Size=UDim2.fromOffset(0,0)},TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.In)) task.wait(0.35) Gui:Destroy() Blur:Destroy() onFinish()
    end)
end

-- ================= HUB หลัก เล็ก ลากได้ มีลูกเล่น =================
function NAEI:CreateWindow(cfg)
    cfg=cfg or {}
    local Window={Tabs={}, Size=cfg.Size or Vector2.new(520,340)}
    local Gui=New("ScreenGui",{Name="NAEI_HUB", ResetOnSpawn=false, IgnoreGuiInset=true}) Gui.Parent=GetParent()
    local Main=New("Frame",{Size=UDim2.fromOffset(Window.Size.X, Window.Size.Y), Position=UDim2.new(0.5,-Window.Size.X/2,0.5,-Window.Size.Y/2), BackgroundColor3=NAEI.Theme.Bg, BackgroundTransparency=0.06, Parent=Gui}) Corner(Main,14) Stroke(Main, NAEI.Theme.Border,0.3,1)
    local out=Stroke(Main, NAEI.Theme.Primary,0.5,1.2) New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2), Rotation=90, Parent=out})

    -- Header ลากได้ 100%
    local Header=New("Frame",{Size=UDim2.new(1,0,0,44), BackgroundTransparency=1, Parent=Main})
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(28,28), Position=UDim2.fromOffset(10,8), BackgroundTransparency=1, Image=GetAsset(NAEI.LogoUrl, NAEI.LogoFile), ScaleType=Enum.ScaleType.Crop, Parent=Header}) Corner(Logo,7)
    New("TextLabel",{Size=UDim2.new(1,-140,0,16), Position=UDim2.fromOffset(46,6), BackgroundTransparency=1, Text=cfg.Title or "Naei Hub", TextColor3=NAEI.Theme.Text, TextSize=13, Font=Enum.Font.GothamBold, TextXAlignment=Left, Parent=Header})
    New("TextLabel",{Size=UDim2.new(1,-140,0,14), Position=UDim2.fromOffset(46,24), BackgroundTransparency=1, Text=cfg.Subtitle or "Compact • Draggable", TextColor3=NAEI.Theme.Sub, TextSize=9, Font=Enum.Font.Gotham, TextXAlignment=Left, Parent=Header})

    local function TopBtn(txt,pos,col)
        local b=New("TextButton",{Size=UDim2.fromOffset(28,28), Position=UDim2.new(1,pos,0,8), BackgroundColor3=NAEI.Theme.Card, Text=txt, TextColor3=NAEI.Theme.Sub, TextSize=14, Font=Enum.Font.GothamBold, AutoButtonColor=false, Parent=Header}) Corner(b,8)
        b.MouseEnter:Connect(function() Tween(b,0.15,{BackgroundColor3=col or NAEI.Theme.Hover, TextColor3=NAEI.Theme.Text}) end)
        b.MouseLeave:Connect(function() Tween(b,0.15,{BackgroundColor3=NAEI.Theme.Card, TextColor3=NAEI.Theme.Sub}) end)
        Ripple(b) return b
    end
    local Close=TopBtn("×",-36, NAEI.Theme.Danger)
    local Min=TopBtn("−",-70)

    local Sidebar=New("Frame",{Size=UDim2.new(0,140,1,-52), Position=UDim2.fromOffset(6,46), BackgroundColor3=Color3.fromRGB(14,14,16), BackgroundTransparency=0.15, Parent=Main}) Corner(Sidebar,10)
    local Profile=New("Frame",{Size=UDim2.new(1,-12,0,48), Position=UDim2.fromOffset(6,6), BackgroundColor3=NAEI.Theme.Card, BackgroundTransparency=0.2, Parent=Sidebar}) Corner(Profile,8)
    New("ImageLabel",{Size=UDim2.fromOffset(32,32), Position=UDim2.fromOffset(6,8), BackgroundTransparency=1, Image="rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=100&h=100", Parent=Profile})
    New("TextLabel",{Size=UDim2.new(1,-44,0,14), Position=UDim2.fromOffset(42,6), BackgroundTransparency=1, Text=LocalPlayer.DisplayName, TextColor3=NAEI.Theme.Text, TextSize=11, Font=Enum.Font.GothamBold, TextXAlignment=Left, TextTruncate=AtEnd, Parent=Profile})
    New("TextLabel",{Size=UDim2.new(1,-44,0,12), Position=UDim2.fromOffset(42,22), BackgroundTransparency=1, Text="@"..LocalPlayer.Name, TextColor3=NAEI.Theme.Muted, TextSize=9, Font=Enum.Font.Gotham, TextXAlignment=Left, Parent=Profile})

    local TabHolder=New("ScrollingFrame",{Size=UDim2.new(1,-8,1,-64), Position=UDim2.fromOffset(4,58), BackgroundTransparency=1, ScrollBarThickness=0, CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y, Parent=Sidebar}) New("UIListLayout",{Padding=UDim.new(0,4), Parent=TabHolder})
    local Content=New("Frame",{Size=UDim2.new(1,-156,1,-52), Position=UDim2.new(0,156,0,46), BackgroundTransparency=1, ClipsDescendants=true, Parent=Main})

    -- DRAG 100% ใช้ได้จริง
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true dragStart=input.Position startPos=Main.Position input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end) end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then local delta=input.Position-dragStart Main.Position=UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y) end end)

    Main.Size=UDim2.fromOffset(0,0) Main.BackgroundTransparency=1 Tween(Main,0.45,{Size=UDim2.fromOffset(Window.Size.X, Window.Size.Y), BackgroundTransparency=0.06}, TweenInfo.new(0.45, Enum.EasingStyle.Back))

    function Window:CreateTab(name)
        local Tab={} local Btn=New("TextButton",{Size=UDim2.new(1,-8,0,34), BackgroundColor3=NAEI.Theme.Card, BackgroundTransparency=1, Text="", AutoButtonColor=false, Parent=TabHolder}) Corner(Btn,8)
        New("TextLabel",{Size=UDim2.new(1,-20,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text=name, TextColor3=NAEI.Theme.Sub, TextSize=11, Font=Enum.Font.GothamMedium, TextXAlignment=Left, Parent=Btn})
        local Page=New("ScrollingFrame",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, ScrollBarThickness=2, ScrollBarImageColor3=NAEI.Theme.Primary, CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=false, Parent=Content}) New("UIListLayout",{Padding=UDim.new(0,6), Parent=Page}) New("UIPadding",{PaddingTop=UDim.new(0,6), PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,8), Parent=Page})
        Tab.Button=Btn Tab.Page=Page
        function Tab:Select() for _,t in ipairs(Window.Tabs) do t.Button.BackgroundTransparency=1 t.Button:FindFirstChildOfClass("TextLabel").TextColor3=NAEI.Theme.Sub t.Page.Visible=false end Btn.BackgroundTransparency=0.15 Btn.BackgroundColor3=NAEI.Theme.Primary Btn:FindFirstChildOfClass("TextLabel").TextColor3=NAEI.Theme.Text Page.Visible=true Page.CanvasPosition=Vector2.new(0,0) end
        Btn.MouseEnter:Connect(function() if Page.Visible==false then Tween(Btn,0.15,{BackgroundTransparency=0.7, BackgroundColor3=NAEI.Theme.Card}) end end)
        Btn.MouseLeave:Connect(function() if Page.Visible==false then Tween(Btn,0.15,{BackgroundTransparency=1}) end end)
        Btn.Activated:Connect(function() Tab:Select() Tween(Btn,0.08,{Size=UDim2.new(1,-8,0,32)}) task.wait(0.08) Tween(Btn,0.1,{Size=UDim2.new(1,-8,0,34)}) end)
        Ripple(Btn)
        function Tab:AddSection(txt) local f=New("Frame",{Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Parent=Page}) New("TextLabel",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text=string.upper(txt), TextColor3=NAEI.Theme.Primary, TextSize=10, Font=Enum.Font.GothamBold, TextXAlignment=Left, Parent=f}) end
        function Tab:AddButton(c) c=c or {} local f=New("Frame",{Size=UDim2.new(1,0,0,38), BackgroundColor3=NAEI.Theme.Card, Parent=Page}) Corner(f,8) Stroke(f, NAEI.Theme.Border,0.6,1) local b=New("TextButton",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", AutoButtonColor=false, Parent=f}) New("TextLabel",{Size=UDim2.new(1,-24,1,0), Position=UDim2.fromOffset(12,0), BackgroundTransparency=1, Text=c.Name or "Button", TextColor3=NAEI.Theme.Text, TextSize=12, Font=Enum.Font.GothamMedium, TextXAlignment=Left, Parent=b}) b.MouseEnter:Connect(function() Tween(f,0.15,{BackgroundColor3=NAEI.Theme.Hover}) end) b.MouseLeave:Connect(function() Tween(f,0.15,{BackgroundColor3=NAEI.Theme.Card}) end) b.Activated:Connect(function() if c.Callback then c.Callback() end Tween(f,0.08,{Size=UDim2.new(1,0,0,36)}) task.wait(0.08) Tween(f,0.1,{Size=UDim2.new(1,0,0,38)}) end) Ripple(b) return f end
        function Tab:AddToggle(c) c=c or {} local state=c.Default==true local f=New("Frame",{Size=UDim2.new(1,0,0,42), BackgroundColor3=NAEI.Theme.Card, Parent=Page}) Corner(f,8) New("TextLabel",{Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(12,0), BackgroundTransparency=1, Text=c.Name, TextColor3=NAEI.Theme.Text, TextSize=12, Font=Enum.Font.GothamMedium, TextXAlignment=Left, Parent=f}) local tr=New("Frame",{Size=UDim2.fromOffset(40,22), Position=UDim2.new(1,-52,0.5,-11), BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off, Parent=f}) Corner(tr,11) local th=New("Frame",{Size=UDim2.fromOffset(16,16), Position=state and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8), BackgroundColor3=Color3.new(1,1,1), Parent=tr}) Corner(th,100) local btn=New("TextButton",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", Parent=f}) btn.Activated:Connect(function() state=not state Tween(tr,0.2,{BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off}) Tween(th,0.2,{Position=state and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)},TweenInfo.new(0.2,Enum.EasingStyle.Back)) if c.Callback then c.Callback(state) end end) end
        table.insert(Window.Tabs, Tab) if #Window.Tabs==1 then Tab:Select() end return Tab
    end
    function Window:Destroy() Tween(Main,0.25,{Size=UDim2.fromOffset(0,0), BackgroundTransparency=1}) task.wait(0.25) Gui:Destroy() end
    Close.Activated:Connect(function() Window:Destroy() end)
    Min.Activated:Connect(function() Main.Visible=false task.wait(0.5) Main.Visible=true end)
    return Window
end
return NAEI