--[[
    NAEI HUB v8.0 - ETERNITY
    The Final Form • Liquid Glass • Mesh Aurora • Magnetic • God Level
    Optimized for Delta / Codex / Arceus
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local NAEI = {}
NAEI.Version = "8.0-ETERNITY"
NAEI.Theme = {
    Bg = Color3.fromRGB(8, 8, 12),
    BgSub = Color3.fromRGB(14, 14, 20),
    Card = Color3.fromRGB(20, 20, 28),
    Card2 = Color3.fromRGB(28, 28, 40),
    Hover = Color3.fromRGB(35, 35, 50),
    Primary = Color3.fromRGB(138, 92, 255),
    Primary2 = Color3.fromRGB(92, 168, 255),
    Primary3 = Color3.fromRGB(255, 92, 168),
    Text = Color3.fromRGB(255,255,255),
    Sub = Color3.fromRGB(165,165,190),
    Muted = Color3.fromRGB(85,85,105),
    Border = Color3.fromRGB(55,55,75),
    Off = Color3.fromRGB(40,40,55),
    Danger = Color3.fromRGB(255,60,90),
}
NAEI.LogoUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg"
NAEI.LogoFile = "naei_v8.jpg"

--// BASE UTILS
local function New(c,p) local o=Instance.new(c) for k,v in pairs(p or {}) do pcall(function() o[k]=v end) end return o end
local function Corner(o,r) New("UICorner",{CornerRadius=UDim.new(0,r or 12),Parent=o}) return o end
local function Stroke(o,c,t,tk) return New("UIStroke",{Color=c or NAEI.Theme.Border,Transparency=t or 0.5,Thickness=tk or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=o}) end
local function Tween(o,t,props,s,d) local tw=TweenService:Create(o,TweenInfo.new(t,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),props) tw:Play() return tw end
local function GetParent() local ok,g=pcall(gethui) if ok and g then return g end return LocalPlayer:WaitForChild("PlayerGui") end
local function GetAsset(u,f)
    local fn=getcustomasset or getsynasset
    if not (fn and writefile and isfile) then return u end
    local ok,a=pcall(function() if not isfile(f) then writefile(f,game:HttpGet(u)) end return fn(f) end)
    return ok and a or u
end

--// GLOW & EFFECTS
local function AddGlow(obj, color, size, trans)
    return New("ImageLabel",{
        Name="Glow", Size=UDim2.new(1,size or 60,1,size or 60), Position=UDim2.new(0.5,0,0.5,0), AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundTransparency=1, Image="rbxassetid://5028857084", ImageColor3=color or NAEI.Theme.Primary,
        ImageTransparency=trans or 0.5, ZIndex=0, Parent=obj
    })
end

local function CreateAurora(parent)
    local aurora = New("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ClipsDescendants=true,Parent=parent})
    local g1 = New("Frame",{Size=UDim2.fromOffset(400,400),Position=UDim2.new(0,-100,0,-150),BackgroundColor3=NAEI.Theme.Primary,BackgroundTransparency=0.7,Parent=aurora})
    Corner(g1,200) AddGlow(g1, NAEI.Theme.Primary, 100, 0.3)
    local g2 = New("Frame",{Size=UDim2.fromOffset(350,350),Position=UDim2.new(1,-200,1,-200),BackgroundColor3=NAEI.Theme.Primary2,BackgroundTransparency=0.7,Parent=aurora})
    Corner(g2,200) AddGlow(g2, NAEI.Theme.Primary2, 100, 0.3)
    task.spawn(function()
        while aurora.Parent do
            Tween(g1, 8, {Position=UDim2.new(0,math.random(-120,-50),0,math.random(-180,-50))}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            Tween(g2, 9, {Position=UDim2.new(1,math.random(-250,-150),1,math.random(-250,-150))}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(8)
        end
    end)
end

local function CreateStars(parent, count)
    local holder=New("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Parent=parent})
    for i=1,count or 20 do
        local s=New("Frame",{Size=UDim2.fromOffset(math.random(1,2),math.random(1,2)),Position=UDim2.fromScale(math.random(),math.random()),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=math.random(20,60)/100,Parent=holder})
        Corner(s,100)
        task.spawn(function() while s.Parent do Tween(s, math.random(2,5), {BackgroundTransparency=math.random(10,80)/100}) task.wait(math.random(2,5)) end end)
    end
end

local function EnableMagnetic(btn)
    btn.MouseMoved:Connect(function(x,y)
        local center = btn.AbsolutePosition + btn.AbsoluteSize/2
        local dist = (Vector2.new(x,y) - center).Magnitude
        if dist < 80 then
            local offset = (Vector2.new(x,y) - center) * 0.15
            Tween(btn, 0.3, {Position=UDim2.fromOffset(offset.X, offset.Y)}, Enum.EasingStyle.Quad)
        end
    end)
    btn.MouseLeave:Connect(function() Tween(btn, 0.4, {Position=UDim2.fromOffset(0,0)}, Enum.EasingStyle.Back) end)
end

local function EnableDrag(gui, handle)
    handle=handle or gui
    local dragging, start, startPos, inputObj = false
    handle.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true start=i.Position startPos=gui.Position Tween(gui,0.15,{Size=UDim2.fromOffset(gui.AbsoluteSize.X*1.03,gui.AbsoluteSize.Y*1.03)}) end end)
    handle.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then inputObj=i end end)
    UserInputService.InputChanged:Connect(function(i) if i==inputObj and dragging then local d=i.Position-start gui.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if dragging then dragging=false Tween(gui,0.3,{Size=UDim2.fromOffset(WindowSize and WindowSize.X or 560, WindowSize and WindowSize.Y or 360)},Enum.EasingStyle.Back) end end)
end

--// LOADER ETERNITY
function NAEI:ShowLoader(cfg)
    cfg=cfg or {}; local onFinish=cfg.OnFinish or function() end
    local Gui=New("ScreenGui",{Name="NAEI_LOADER_V8",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})
    local Blur=New("BlurEffect",{Size=0,Parent=game:GetService("Lighting")}); Tween(Blur,0.8,{Size=28})
    local BG=New("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(3,3,6),Parent=Gui})
    CreateAurora(BG); CreateStars(BG,25)

    local Card=New("Frame",{Size=UDim2.fromOffset(320,380),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),BackgroundColor3=NAEI.Theme.Bg,BackgroundTransparency=0.15,Parent=Gui})
    Corner(Card,24); local st=Stroke(Card, NAEI.Theme.Primary, 0.15, 2)
    local grad=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2),Rotation=0,Parent=st})
    AddGlow(Card, NAEI.Theme.Primary, 120, 0.4)
    Card.Size=UDim2.fromOffset(0,0); Tween(Card,0.8,{Size=UDim2.fromOffset(320,380)},Enum.EasingStyle.Back)

    task.spawn(function() while Card.Parent do grad.Rotation=(grad.Rotation+1)%360 task.wait(0.02) end end)

    local Ring=New("Frame",{Size=UDim2.fromOffset(100,100),Position=UDim2.new(0.5,-50,0,35),BackgroundTransparency=1,Parent=Card})
    Corner(Ring,100); Stroke(Ring, NAEI.Theme.Primary, 0, 2.5)
    local LogoBox=New("Frame",{Size=UDim2.fromOffset(80,80),Position=UDim2.fromOffset(10,10),BackgroundColor3=NAEI.Theme.Card,Parent=Ring})
    Corner(LogoBox,100); local Logo=New("ImageLabel",{Size=UDim2.fromOffset(70,70),Position=UDim2.fromOffset(5,5),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=LogoBox})
    Corner(Logo,100); AddGlow(LogoBox, NAEI.Theme.Primary, 40, 0.6)
    task.spawn(function() while Ring.Parent do Ring.Rotation+=1 task.wait(0.015) end end)

    New("TextLabel",{Size=UDim2.new(1,0,0,24),Position=UDim2.fromOffset(0,150),BackgroundTransparency=1,Text=cfg.Title or "NAEI HUB",TextColor3=NAEI.Theme.Text,TextSize=22,Font=Enum.Font.GothamBold,Parent=Card})
    New("TextLabel",{Size=UDim2.new(1,0,0,14),Position=UDim2.fromOffset(0,174),BackgroundTransparency=1,Text="v8.0 • ETERNITY • 1B×",TextColor3=NAEI.Theme.Sub,TextSize=10,Font=Enum.Font.Gotham,Parent=Card})

    local BarBG=New("Frame",{Size=UDim2.new(1,-50,0,6),Position=UDim2.fromOffset(25,220),BackgroundColor3=NAEI.Theme.Off,Parent=Card}); Corner(BarBG,100)
    local Bar=New("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=NAEI.Theme.Primary,Parent=BarBG}); Corner(Bar,100); New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary,NAEI.Theme.Primary2),Parent=Bar})
    local Stat=New("TextLabel",{Size=UDim2.new(1,-50,0,14),Position=UDim2.fromOffset(25,235),BackgroundTransparency=1,Text="Brewing Liquid Glass...",TextColor3=NAEI.Theme.Muted,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=Card})
    local Perc=New("TextLabel",{Size=UDim2.new(0,50,0,14),Position=UDim2.new(1,-55,0,235),BackgroundTransparency=1,Text="0%",TextColor3=NAEI.Theme.Primary,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Right,Parent=Card})

    local steps={{"Crafting Aurora Engine",40},{"Injecting Eternity Particles",75},{"Welcome "..LocalPlayer.DisplayName,100}}
    task.spawn(function()
        local last=0
        for _,s in ipairs(steps) do
            Stat.Text=s[1]; Tween(Bar,0.7,{Size=UDim2.new(s[2]/100,0,1,0)},Enum.EasingStyle.Expo)
            for i=last,s[2] do Perc.Text=i.."%" task.wait(0.012) end; last=s[2]; task.wait(0.25)
        end
        task.wait(0.3); Tween(Blur,0.5,{Size=0}); Tween(Card,0.4,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In)
        task.wait(0.4); Gui:Destroy(); Blur:Destroy(); onFinish()
    end)
end

--// MAIN WINDOW
function NAEI:CreateWindow(cfg)
    cfg=cfg or {}; local WSize=cfg.Size or Vector2.new(560,360); WindowSize=WSize
    local Window={Tabs={}}; local Gui=New("ScreenGui",{Name="NAEI_HUB_V8",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})
    local Main=New("Frame",{Size=UDim2.fromOffset(WSize.X,WSize.Y),Position=UDim2.new(0.5,-WSize.X/2,0.5,-WSize.Y/2),BackgroundColor3=NAEI.Theme.Bg,BackgroundTransparency=0.08,Parent=Gui})
    Corner(Main,20); local ms=Stroke(Main, NAEI.Theme.Primary, 0.2, 2)
    local mg=New("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,NAEI.Theme.Primary),ColorSequenceKeypoint.new(0.5,NAEI.Theme.Primary2),ColorSequenceKeypoint.new(1,NAEI.Theme.Primary3)},Rotation=30,Parent=ms})
    AddGlow(Main, NAEI.Theme.Primary, 150, 0.5); CreateAurora(Main); CreateStars(Main,15)
    task.spawn(function() while Main.Parent do mg.Rotation=(mg.Rotation+0.4)%360 task.wait(0.04) end end)

    local Header=New("Frame",{Size=UDim2.new(1,0,0,48),BackgroundTransparency=1,Parent=Main,ZIndex=10}); EnableDrag(Main,Header)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(30,30),Position=UDim2.fromOffset(14,9),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Header}); Corner(Logo,9)
    New("TextLabel",{Size=UDim2.new(1,-160,0,15),Position=UDim2.fromOffset(52,10),BackgroundTransparency=1,Text=cfg.Title or "Naei Hub",TextColor3=NAEI.Theme.Text,TextSize=14,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Header})
    New("TextLabel",{Size=UDim2.new(1,-160,0,12),Position=UDim2.fromOffset(52,26),BackgroundTransparency=1,Text=cfg.Subtitle or "v8.0 • ETERNITY",TextColor3=NAEI.Theme.Sub,TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=Header})

    local function TopBtn(txt,pos,col) local b=New("TextButton",{Size=UDim2.fromOffset(32,32),Position=UDim2.new(1,pos,0,8),BackgroundColor3=NAEI.Theme.Card,Text=txt,TextColor3=NAEI.Theme.Sub,TextSize=15,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=Header}); Corner(b,10); Stroke(b,NAEI.Theme.Border,0.6,1); b.MouseEnter:Connect(function() Tween(b,0.2,{BackgroundColor3=col or NAEI.Theme.Hover,TextColor3=NAEI.Theme.Text}) end); b.MouseLeave:Connect(function() Tween(b,0.2,{BackgroundColor3=NAEI.Theme.Card,TextColor3=NAEI.Theme.Sub}) end); return b end
    local CloseBtn=TopBtn("✕",-40,NAEI.Theme.Danger); local MinBtn=TopBtn("—",-78)

    local Sidebar=New("Frame",{Size=UDim2.new(0,155,1,-62),Position=UDim2.fromOffset(10,52),BackgroundColor3=NAEI.Theme.BgSub,BackgroundTransparency=0.25,Parent=Main}); Corner(Sidebar,14); Stroke(Sidebar,NAEI.Theme.Border,0.6,1)
    local Profile=New("Frame",{Size=UDim2.new(1,-12,0,48),Position=UDim2.fromOffset(6,6),BackgroundColor3=NAEI.Theme.Card,Parent=Sidebar}); Corner(Profile,11); Stroke(Profile,NAEI.Theme.Primary,0.6,1)
    New("ImageLabel",{Size=UDim2.fromOffset(32,32),Position=UDim2.fromOffset(8,8),BackgroundTransparency=1,Image="rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150",Parent=Profile})
    New("TextLabel",{Size=UDim2.new(1,-52,0,14),Position=UDim2.fromOffset(46,8),BackgroundTransparency=1,Text=LocalPlayer.DisplayName,TextColor3=NAEI.Theme.Text,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Left,TextTruncate=AtEnd,Parent=Profile})
    New("TextLabel",{Size=UDim2.new(1,-52,0,10),Position=UDim2.fromOffset(46,24),BackgroundTransparency=1,Text="@"..LocalPlayer.Name,TextColor3=NAEI.Theme.Muted,TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=Profile})

    local TabHolder=New("ScrollingFrame",{Size=UDim2.new(1,-8,1,-68),Position=UDim2.fromOffset(4,62),BackgroundTransparency=1,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=Sidebar}); New("UIListLayout",{Padding=UDim.new(0,6),Parent=TabHolder})
    local Content=New("Frame",{Size=UDim2.new(1,-185,1,-62),Position=UDim2.new(0,175,0,52),BackgroundTransparency=1,ClipsDescendants=true,Parent=Main})

    Main.Size=UDim2.fromOffset(0,0); Main.BackgroundTransparency=1; Tween(Main,0.7,{Size=UDim2.fromOffset(WSize.X,WSize.Y),BackgroundTransparency=0.08},Enum.EasingStyle.Back)

    function Window:CreateTab(name, icon)
        local Tab={}; local Btn=New("TextButton",{Size=UDim2.new(1,-8,0,38),BackgroundColor3=NAEI.Theme.Card,BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=TabHolder}); Corner(Btn,11)
        local Icon=New("TextLabel",{Size=UDim2.fromOffset(28,28),Position=UDim2.fromOffset(6,5),BackgroundTransparency=1,Text=icon or "✦",TextColor3=NAEI.Theme.Sub,TextSize=14,Font=Enum.Font.GothamBold,Parent=Btn})
        local Label=New("TextLabel",{Size=UDim2.new(1,-42,1,0),Position=UDim2.fromOffset(36,0),BackgroundTransparency=1,Text=name,TextColor3=NAEI.Theme.Sub,TextSize=12,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=Btn})
        local Ind=New("Frame",{Size=UDim2.fromOffset(4,20),Position=UDim2.fromOffset(-4,9),BackgroundColor3=NAEI.Theme.Primary,BackgroundTransparency=1,Parent=Btn}); Corner(Ind,10)
        local Page=New("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScrollBarThickness=2,ScrollBarImageColor3=NAEI.Theme.Primary,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=Content}); New("UIListLayout",{Padding=UDim.new(0,8),Parent=Page}); New("UIPadding",{PaddingTop=UDim.new(0,4),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,12),Parent=Page})
        function Tab:Select() for _,t in ipairs(Window.Tabs) do Tween(t.Button,0.2,{BackgroundTransparency=1}); t.Label.TextColor3=NAEI.Theme.Sub; t.Icon.TextColor3=NAEI.Theme.Sub; Tween(t.Ind,0.2,{BackgroundTransparency=1}); t.Page.Visible=false end Tween(Btn,0.25,{BackgroundTransparency=0,BackgroundColor3=NAEI.Theme.Card2}); Tween(Ind,0.25,{BackgroundTransparency=0}); Label.TextColor3=NAEI.Theme.Text; Icon.TextColor3=NAEI.Theme.Primary; Page.Visible=true end
        Tab.Button=Btn; Tab.Label=Label; Tab.Icon=Icon; Tab.Ind=Ind; Tab.Page=Page
        Btn.MouseEnter:Connect(function() if not Page.Visible then Tween(Btn,0.15,{BackgroundTransparency=0.5,BackgroundColor3=NAEI.Theme.Card}) end end)
        Btn.MouseLeave:Connect(function() if not Page.Visible then Tween(Btn,0.15,{BackgroundTransparency=1}) end end)
        Btn.Activated:Connect(function() Tab:Select() end)

        function Tab:AddSection(txt) local f=New("Frame",{Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,Parent=Page}); New("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="— "..string.upper(txt),TextColor3=NAEI.Theme.Primary,TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=f}) end
        function Tab:AddButton(c) c=c or {}; local f=New("Frame",{Size=UDim2.new(1,0,0,42),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,12); local s=Stroke(f,NAEI.Theme.Border,0.6,1); local b=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=f}); New("TextLabel",{Size=UDim2.new(1,-24,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,Text=c.Name or "Button",TextColor3=NAEI.Theme.Text,TextSize=12,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=b}); local ar=New("TextLabel",{Size=UDim2.fromOffset(20,20),Position=UDim2.new(1,-30,0.5,-10),BackgroundTransparency=1,Text="›",TextColor3=NAEI.Theme.Muted,TextSize=18,Parent=b}); EnableMagnetic(f); b.MouseEnter:Connect(function() Tween(f,0.2,{BackgroundColor3=NAEI.Theme.Hover}); Tween(s,0.2,{Color=NAEI.Theme.Primary}); Tween(ar,0.2,{TextColor3=NAEI.Theme.Text}) end); b.MouseLeave:Connect(function() Tween(f,0.2,{BackgroundColor3=NAEI.Theme.Card}); Tween(s,0.2,{Color=NAEI.Theme.Border}); Tween(ar,0.2,{TextColor3=NAEI.Theme.Muted}) end); b.Activated:Connect(function() if c.Callback then c.Callback() end Tween(f,0.08,{Size=UDim2.new(1,0,0,38)}) task.wait(0.08) Tween(f,0.12,{Size=UDim2.new(1,0,0,42)}) end); return f end
        function Tab:AddToggle(c) c=c or {}; local state=c.Default==true; local f=New("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,12); Stroke(f,NAEI.Theme.Border,0.6,1); New("TextLabel",{Size=UDim2.new(1,-70,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,Text=c.Name or "Toggle",TextColor3=NAEI.Theme.Text,TextSize=12,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=f}); local Track=New("Frame",{Size=UDim2.fromOffset(48,26),Position=UDim2.new(1,-60,0.5,-13),BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off,Parent=f}); Corner(Track,13); if state then New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary,NAEI.Theme.Primary2),Parent=Track}) end; local Thumb=New("Frame",{Size=UDim2.fromOffset(20,20),Position=state and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,3,0.5,-10),BackgroundColor3=Color3.new(1,1,1),Parent=Track}); Corner(Thumb,100); AddGlow(Thumb,NAEI.Theme.Primary,20,0.4); local btn=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Parent=f}); btn.Activated:Connect(function() state=not state; Tween(Track,0.3,{BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off},Enum.EasingStyle.Back); Tween(Thumb,0.35,{Position=state and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,3,0.5,-10)},Enum.EasingStyle.Back); if c.Callback then c.Callback(state) end end); return f end
        function Tab:AddSlider(c) c=c or {}; local min,max,def=c.Min or 0,c.Max or 100,c.Default or 50; local val=def; local f=New("Frame",{Size=UDim2.new(1,0,0,58),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,12); Stroke(f,NAEI.Theme.Border,0.6,1); New("TextLabel",{Size=UDim2.new(1,-60,0,18),Position=UDim2.fromOffset(14,8),BackgroundTransparency=1,Text=c.Name or "Slider",TextColor3=NAEI.Theme.Text,TextSize=12,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=f}); local vLbl=New("TextLabel",{Size=UDim2.fromOffset(50,18),Position=UDim2.new(1,-60,0,8),BackgroundTransparency=1,Text=tostring(val),TextColor3=NAEI.Theme.Primary,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Right,Parent=f}); local track=New("Frame",{Size=UDim2.new(1,-28,0,8),Position=UDim2.fromOffset(14,36),BackgroundColor3=NAEI.Theme.Off,Parent=f}); Corner(track,100); local fill=New("Frame",{Size=UDim2.new((val-min)/(max-min),0,1,0),BackgroundColor3=NAEI.Theme.Primary,Parent=track}); Corner(fill,100); New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary,NAEI.Theme.Primary2),Parent=fill}); return f end
        function Tab:AddDropdown(c) c=c or {}; local f=New("Frame",{Size=UDim2.new(1,0,0,42),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,12); Stroke(f,NAEI.Theme.Border,0.6,1); New("TextLabel",{Size=UDim2.new(1,-50,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,Text=c.Name or "Dropdown",TextColor3=NAEI.Theme.Text,TextSize=12,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=f}); New("TextLabel",{Size=UDim2.fromOffset(30,20),Position=UDim2.new(1,-40,0.5,-10),BackgroundTransparency=1,Text="▼",TextColor3=NAEI.Theme.Muted,TextSize=10,Parent=f}); return f end

        table.insert(Window.Tabs,Tab); if #Window.Tabs==1 then Tab:Select() end; return Tab
    end
    function Window:Destroy() Tween(Main,0.35,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1,Rotation=8},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.35); Gui:Destroy() end
    function Window:Notify(title,text) local n=New("Frame",{Size=UDim2.fromOffset(260,70),Position=UDim2.new(1,-270,1,-80),BackgroundColor3=NAEI.Theme.Card2,Parent=Gui}); Corner(n,14); Stroke(n,NAEI.Theme.Primary,0.3,1.2); AddGlow(n,NAEI.Theme.Primary,60); New("TextLabel",{Size=UDim2.new(1,-20,0,18),Position=UDim2.fromOffset(14,10),BackgroundTransparency=1,Text=title,TextColor3=NAEI.Theme.Text,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=n}); New("TextLabel",{Size=UDim2.new(1,-20,0,30),Position=UDim2.fromOffset(14,28),BackgroundTransparency=1,Text=text,TextColor3=NAEI.Theme.Sub,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Left,TextYAlignment=Top,Parent=n}); n.Position=UDim2.new(1,-270,1,20); Tween(n,0.5,{Position=UDim2.new(1,-270,1,-80)},Enum.EasingStyle.Back); task.delay(3,function() Tween(n,0.4,{Position=UDim2.new(1,-270,1,20)},Enum.EasingStyle.Back,Enum.EasingDirection.In) task.wait(0.4) n:Destroy() end) end

    CloseBtn.Activated:Connect(function() Window:Destroy() end); MinBtn.Activated:Connect(function() Main.Visible=not Main.Visible end)
    return Window
end

return NAEI