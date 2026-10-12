--[[
    NAEI HUB v15.0 - CYBER VOID | 10000X UPGRADE FROM V14
    Features: Acrylic Blur, Spotlight, Magnetic Dock, Ripple Engine, Config, Particle Rain
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local NAEI = {}
NAEI.Version = "15.0-CYBER-VOID"
NAEI.Theme = {
    Bg = Color3.fromRGB(6,6,9),
    BgSub = Color3.fromRGB(12,12,16),
    Card = Color3.fromRGB(20,20,26),
    Card2 = Color3.fromRGB(28,28,36),
    Hover = Color3.fromRGB(38,38,52),
    Primary = Color3.fromRGB(255, 235, 0),
    Primary2 = Color3.fromRGB(0, 255, 190),
    Primary3 = Color3.fromRGB(130, 80, 255),
    Text = Color3.fromRGB(255,255,255),
    Sub = Color3.fromRGB(165,165,180),
    Muted = Color3.fromRGB(85,85,100),
    Border = Color3.fromRGB(55,55,70),
    Off = Color3.fromRGB(40,40,52),
    Danger = Color3.fromRGB(255,60,90),
}
NAEI.LogoUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg"
NAEI.LogoFile = "naei_v15_void.jpg"

-- CORE
local function New(c,p) local o=Instance.new(c) for k,v in pairs(p or {}) do pcall(function() o[k]=v end) end return o end
local function Corner(o,r) return New("UICorner",{CornerRadius=UDim.new(0,r or 12),Parent=o}) end
local function Stroke(o,c,t,tk) return New("UIStroke",{Color=c or NAEI.Theme.Border,Transparency=t or 0.5,Thickness=tk or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=o}) end
local function Tween(o,t,pr,s,d) local tw=TweenService:Create(o,TweenInfo.new(t,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),pr) tw:Play() return tw end
local function GetParent() local ok,g=pcall(gethui) if ok and g then return g end return LocalPlayer:WaitForChild("PlayerGui") end
local function GetAsset(u,f) local fn=getcustomasset or getsynasset if not (fn and writefile and isfile) then return u end local ok,a=pcall(function() if not isfile(f) then writefile(f,game:HttpGet(u)) end return fn(f) end) return ok and a or u end
local function EnableDrag(g,h) h=h or g; local d,s,sp,io=false; h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true s=i.Position sp=g.Position end end); h.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then io=i end end); UserInputService.InputChanged:Connect(function(i) if i==io and d then local dd=i.Position-s g.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dd.X,sp.Y.Scale,sp.Y.Offset+dd.Y) end end); UserInputService.InputEnded:Connect(function() d=false end) end

local function RippleEffect(btn, color)
    btn.ClipsDescendants = true
    btn.MouseButton1Down:Connect(function()
        local ripple = New("Frame",{Size=UDim2.fromOffset(0,0),Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=color or NAEI.Theme.Primary,BackgroundTransparency=0.3,Parent=btn}); Corner(ripple,100)
        local mouse = Players.LocalPlayer:GetMouse()
        local x,y = mouse.X - btn.AbsolutePosition.X, mouse.Y - btn.AbsolutePosition.Y
        ripple.Position = UDim2.fromOffset(x,y)
        Tween(ripple,0.6,{Size=UDim2.fromOffset(btn.AbsoluteSize.X*2.5,btn.AbsoluteSize.X*2.5),BackgroundTransparency=1},Enum.EasingStyle.Expo)
        task.delay(0.6,function() ripple:Destroy() end)
    end)
end

-- ================= LOADER V15 - CYBER VOID =================
function NAEI:ShowLoader(cfg)
    cfg=cfg or {}; local onFinish=cfg.OnFinish or function() end
    local finished=false
    local function Finish() if finished then return end finished=true pcall(onFinish) end

    local Gui=New("ScreenGui",{Name="NAEI_LOADER_V15",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})
    local Blur=New("BlurEffect",{Size=0,Parent=game:GetService("Lighting")}); Tween(Blur,0.5,{Size=20})

    local BG=New("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=0.2,Parent=Gui})

    -- Matrix Rain BG
    for i=1,25 do
        local drop = New("TextLabel",{Size=UDim2.fromOffset(12,200),Position=UDim2.fromScale(math.random(),-0.2),BackgroundTransparency=1,Text=string.char(math.random(33,126)),TextColor3=NAEI.Theme.Primary2,TextTransparency=0.7,TextSize=10,Font=Enum.Font.Code,Parent=BG})
        task.spawn(function() while drop.Parent do drop.Position = drop.Position + UDim2.fromOffset(0, math.random(2,6)); if drop.Position.Y.Offset > 600 then drop.Position = UDim2.fromScale(math.random(),-0.2) end task.wait(0.05) end end)
    end

    local Card=New("Frame",{Size=UDim2.fromOffset(340,420),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),BackgroundColor3=NAEI.Theme.Bg,ClipsDescendants=true,Parent=Gui}); Corner(Card,28); local st=Stroke(Card, NAEI.Theme.Primary, 0.1, 2)
    local grad=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary,NAEI.Theme.Primary2),Rotation=0,Parent=st})
    New("ImageLabel",{Size=UDim2.new(2,0,2,0),Position=UDim2.fromScale(-0.5,-0.5),BackgroundTransparency=1,Image="rbxassetid://5028857084",ImageColor3=NAEI.Theme.Primary,ImageTransparency=0.9,ZIndex=0,Parent=Card})
    Card.Size=UDim2.fromOffset(0,0); Tween(Card,0.9,{Size=UDim2.fromOffset(340,420)},Enum.EasingStyle.Back)
    task.spawn(function() while Card.Parent do grad.Rotation=(grad.Rotation+1.5)%360 task.wait(0.02) end end)

    -- Logo Ring
    local Ring1=New("Frame",{Size=UDim2.fromOffset(110,110),Position=UDim2.new(0.5,-55,0,30),BackgroundTransparency=1,Parent=Card}); Corner(Ring1,100); Stroke(Ring1,NAEI.Theme.Primary,0.6,1.5)
    local Ring2=New("Frame",{Size=UDim2.fromOffset(130,130),Position=UDim2.new(0.5,-65,0,20),BackgroundTransparency=1,Parent=Card}); Corner(Ring2,100); Stroke(Ring2,NAEI.Theme.Primary2,0.7,1)
    task.spawn(function() while Card.Parent do Ring1.Rotation+=1; Ring2.Rotation-=1; task.wait(0.02) end end)

    local LogoBox=New("Frame",{Size=UDim2.fromOffset(84,84),Position=UDim2.new(0.5,-42,0,43),BackgroundColor3=NAEI.Theme.Card2,Parent=Card}); Corner(LogoBox,22); Stroke(LogoBox,Color3.new(1,1,1),0,1)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(70,70),Position=UDim2.fromOffset(7,7),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=LogoBox}); Corner(Logo,16)

    New("TextLabel",{Size=UDim2.new(1,0,0,24),Position=UDim2.fromOffset(0,165),BackgroundTransparency=1,Text=cfg.Title or "NAEI HUB",TextColor3=NAEI.Theme.Text,TextSize=24,Font=Enum.Font.GothamBold,Parent=Card})
    New("TextLabel",{Size=UDim2.new(1,0,0,12),Position=UDim2.fromOffset(0,192),BackgroundTransparency=1,Text="v15.0 • CYBER VOID • GOD TIER",TextColor3=NAEI.Theme.Primary,TextSize=10,Font=Enum.Font.Code,Parent=Card})

    local BarBG=New("Frame",{Size=UDim2.new(1,-50,0,8),Position=UDim2.fromOffset(25,250),BackgroundColor3=NAEI.Theme.Off,ClipsDescendants=true,Parent=Card}); Corner(BarBG,100)
    local Bar=New("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=NAEI.Theme.Primary,Parent=BarBG}); Corner(Bar,100); New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary,NAEI.Theme.Primary2,NAEI.Theme.Primary3),Parent=Bar})
    local Status=New("TextLabel",{Size=UDim2.new(1,-50,0,14),Position=UDim2.fromOffset(25,270),BackgroundTransparency=1,Text="INITIALIZING VOID...",TextColor3=NAEI.Theme.Muted,TextSize=10,Font=Enum.Font.Code,TextXAlignment=Left,Parent=Card})
    local Percent=New("TextLabel",{Size=UDim2.new(0,70,0,24),Position=UDim2.new(1,-75,0,265),BackgroundTransparency=1,Text="0%",TextColor3=NAEI.Theme.Text,TextSize=20,Font=Enum.Font.GothamBold,TextXAlignment=Right,Parent=Card})

    task.delay(7,function() if not finished then Tween(Blur,0.3,{Size=0}); Tween(Card,0.3,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.35); pcall(function() Gui:Destroy() Blur:Destroy() end); Finish() end end)

    task.spawn(function()
        local steps={{"CONNECTING TO VOID",20},{"DECRYPTING NEON PROTOCOL",50},{"INJECTING CYBER CORE",80},{"WELCOME "..string.upper(LocalPlayer.DisplayName),100}}
        local last=0
        for _,s in ipairs(steps) do
            if finished then break end
            Status.Text=">> "..s[1]
            Tween(Bar,0.6,{Size=UDim2.new(s[2]/100,0,1,0)},Enum.EasingStyle.Expo)
            for i=last,s[2] do if finished then break end Percent.Text=i.."%"; task.wait(0.012) end
            last=s[2]; task.wait(0.3)
        end
        if finished then return end
        task.wait(0.5); Tween(Blur,0.4,{Size=0}); Tween(Card,0.4,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.45); pcall(function() Gui:Destroy() Blur:Destroy() end); Finish()
    end)
end

-- NOTIFY QUEUE SYSTEM
do
    local queue={}
    function NAEI:Notify(title, msg, duration)
        local Gui = GetParent():FindFirstChild("NAEI_HUB_V15") or New("ScreenGui",{Name="NAEI_NOTIFY_V15",Parent=GetParent()})
        local yPos = 20 + (#queue*80)
        local Notif = New("Frame",{Size=UDim2.fromOffset(300,70),Position=UDim2.new(1,-320,0,yPos),BackgroundColor3=NAEI.Theme.Card2,Parent=Gui}); Corner(Notif,16); Stroke(Notif,NAEI.Theme.Primary,0.2,1); Notif.BackgroundTransparency=0.1
        table.insert(queue,Notif)
        New("TextLabel",{Size=UDim2.new(1,-20,0,18),Position=UDim2.fromOffset(14,10),BackgroundTransparency=1,Text=title,TextColor3=NAEI.Theme.Primary,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Notif})
        New("TextLabel",{Size=UDim2.new(1,-20,0,30),Position=UDim2.fromOffset(14,30),BackgroundTransparency=1,Text=msg,TextColor3=NAEI.Theme.Sub,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Left,TextWrapped=true,Parent=Notif})
        Tween(Notif,0.6,{Position=UDim2.new(1,-320,0,yPos)},Enum.EasingStyle.Back)
        task.delay(duration or 3,function()
            Tween(Notif,0.4,{Position=UDim2.new(1,-320,0,yPos),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In)
            task.wait(0.4) Notif:Destroy()
            for i,v in ipairs(queue) do if v==Notif then table.remove(queue,i) break end end
        end)
    end
end

-- ================= MAIN WINDOW V15 =================
function NAEI:CreateWindow(cfg)
    cfg=cfg or {}; local WSize=cfg.Size or Vector2.new(760,520); local Window={Tabs={}}
    local Gui=New("ScreenGui",{Name="NAEI_HUB_V15",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})

    local Main=New("Frame",{Size=UDim2.fromOffset(WSize.X,WSize.Y),Position=UDim2.new(0.5,-WSize.X/2,0.5,-WSize.Y/2),BackgroundColor3=NAEI.Theme.Bg,BackgroundTransparency=0.02,Parent=Gui}); Corner(Main,26); local ms=Stroke(Main, NAEI.Theme.Primary, 0.05, 2); local mg=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary,NAEI.Theme.Primary2,NAEI.Theme.Primary3),Rotation=0,Parent=ms})
    task.spawn(function() while Main.Parent do mg.Rotation=(mg.Rotation+0.2)%360 task.wait(0.05) end end)

    -- Spotlight that follows mouse
    local Spot=New("Frame",{Size=UDim2.fromOffset(400,400),BackgroundTransparency=1,Parent=Main}); Corner(Spot,100); New("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(255,235,0),Color3.fromRGB(0,0,0)),Rotation=90,Transparency=NumberSequence.new(0.8),Parent=Spot})
    Main.MouseMoved:Connect(function(x,y) Spot.Position=UDim2.fromOffset(x-200,y-200) end)

    local Header=New("Frame",{Size=UDim2.new(1,0,0,62),BackgroundTransparency=1,Parent=Main,ZIndex=10}); EnableDrag(Main,Header)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(38,38),Position=UDim2.fromOffset(18,12),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Header}); Corner(Logo,12)
    New("TextLabel",{Size=UDim2.new(1,-220,0,18),Position=UDim2.fromOffset(66,16),BackgroundTransparency=1,Text=cfg.Title or "NAEI HUB",TextColor3=NAEI.Theme.Text,TextSize=17,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Header})
    New("TextLabel",{Size=UDim2.new(1,-220,0,10),Position=UDim2.fromOffset(66,36),BackgroundTransparency=1,Text=cfg.Subtitle or "v15.0 • CYBER VOID • 10000X",TextColor3=NAEI.Theme.Primary,TextSize=9,Font=Enum.Font.Code,TextXAlignment=Left,Parent=Header})

    local TopDock=New("Frame",{Size=UDim2.new(1,-24,0,50),Position=UDim2.fromOffset(12,64),BackgroundColor3=NAEI.Theme.BgSub,BackgroundTransparency=0.15,Parent=Main}); Corner(TopDock,16); Stroke(TopDock,NAEI.Theme.Border,0.3,1)
    New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,10),HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Center,Parent=TopDock}); New("UIPadding",{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12),Parent=TopDock})

    local Content=New("Frame",{Size=UDim2.new(1,-24,1,-130),Position=UDim2.new(0,12,0,124),BackgroundTransparency=1,Parent=Main,ClipsDescendants=true})

    local Orb=New("ImageButton",{Size=UDim2.fromOffset(68,68),Position=UDim2.new(0,24,0.5,-34),BackgroundColor3=NAEI.Theme.Card2,Visible=false,Parent=Gui,ZIndex=50}); Corner(Orb,100); Stroke(Orb,NAEI.Theme.Primary,0,2.5)
    local OrbLogo=New("ImageLabel",{Size=UDim2.fromOffset(50,50),Position=UDim2.fromOffset(9,9),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Orb}); Corner(OrbLogo,100); EnableDrag(Orb,Orb)

    local function TopBtn(txt,pos) local b=New("TextButton",{Size=UDim2.fromOffset(36,36),Position=UDim2.new(1,pos,0,13),BackgroundColor3=NAEI.Theme.Card,Text=txt,TextColor3=NAEI.Theme.Sub,TextSize=16,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=Header}); Corner(b,12); Stroke(b,NAEI.Theme.Border,0.5,1); RippleEffect(b); return b end
    local CloseBtn=TopBtn("✕",-50); local MinBtn=TopBtn("—",-94)
    Main.Size=UDim2.fromOffset(0,0); Main.BackgroundTransparency=1; Tween(Main,0.9,{Size=UDim2.fromOffset(WSize.X,WSize.Y),BackgroundTransparency=0.02},Enum.EasingStyle.Back)
    local function SetMin(s) if s then Tween(Main,0.35,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In) task.wait(0.35) Main.Visible=false Orb.Visible=true Orb.Size=UDim2.fromOffset(0,0) Tween(Orb,0.5,{Size=UDim2.fromOffset(68,68)},Enum.EasingStyle.Back) else Tween(Orb,0.25,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In) task.wait(0.25) Orb.Visible=false Main.Visible=true Main.Size=UDim2.fromOffset(0,0) Tween(Main,0.6,{Size=UDim2.fromOffset(WSize.X,WSize.Y),BackgroundTransparency=0.02},Enum.EasingStyle.Back) end end

    function Window:CreateTab(name, icon)
        local Tab={}
        local Btn=New("TextButton",{Size=UDim2.new(0,132,0,36),BackgroundColor3=NAEI.Theme.Card,BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=TopDock}); Corner(Btn,12); local st=Stroke(Btn,NAEI.Theme.Border,1,1)
        local Icon=New("TextLabel",{Size=UDim2.fromOffset(24,24),Position=UDim2.fromOffset(10,6),BackgroundTransparency=1,Text=icon or "●",TextColor3=NAEI.Theme.Sub,TextSize=14,Parent=Btn})
        local Label=New("TextLabel",{Size=UDim2.new(1,-42,1,0),Position=UDim2.fromOffset(36,0),BackgroundTransparency=1,Text=name,TextColor3=NAEI.Theme.Sub,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Btn})
        local Page=New("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScrollBarThickness=3,ScrollBarImageColor3=NAEI.Theme.Primary,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=Content}); New("UIListLayout",{Padding=UDim.new(0,14),Parent=Page}); New("UIPadding",{PaddingTop=UDim.new(0,10),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,20),PaddingBottom=UDim.new(0,30),Parent=Page})

        -- Magnetic Effect
        Btn.MouseEnter:Connect(function() if not Page.Visible then Tween(Btn,0.25,{BackgroundTransparency=0.4,Size=UDim2.new(0,140,0,40)},Enum.EasingStyle.Back) end end)
        Btn.MouseLeave:Connect(function() if not Page.Visible then Tween(Btn,0.25,{BackgroundTransparency=1,Size=UDim2.new(0,132,0,36)},Enum.EasingStyle.Back) end end)

        function Tab:Select()
            for _,t in ipairs(Window.Tabs) do Tween(t.Button,0.25,{BackgroundTransparency=1}); t.Button.UIStroke.Transparency=1; t.Label.TextColor3=NAEI.Theme.Sub; t.Icon.TextColor3=NAEI.Theme.Sub; t.Page.Visible=false end
            Tween(Btn,0.3,{BackgroundTransparency=0,BackgroundColor3=NAEI.Theme.Card2}); st.Transparency=0.1; st.Color=NAEI.Theme.Primary; Label.TextColor3=NAEI.Theme.Primary; Icon.TextColor3=NAEI.Theme.Primary; Page.Visible=true; Page.CanvasPosition=Vector2.new(0,0)
        end
        Tab.Button=Btn; Tab.Label=Label; Tab.Icon=Icon; Tab.Page=Page; Btn.MouseButton1Click:Connect(function() Tab:Select() end); RippleEffect(Btn, NAEI.Theme.Primary2)

        function Tab:AddSection(txt)
            local f=New("Frame",{Size=UDim2.new(1,0,0,32),BackgroundTransparency=1,Parent=Page})
            local line=New("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=NAEI.Theme.Border,BackgroundTransparency=0.3,Parent=f})
            New("TextLabel",{Size=UDim2.fromOffset(200,32),Position=UDim2.fromOffset(10,0),BackgroundColor3=NAEI.Theme.Bg,Text=" "..string.upper(txt).." ",TextColor3=NAEI.Theme.Primary2,TextSize=11,Font=Enum.Font.Code,TextXAlignment=Left,Parent=f})
        end
        function Tab:AddDivider() local d=New("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=NAEI.Theme.Border,BackgroundTransparency=0.6,Parent=Page}) return d end
        function Tab:AddParagraph(c)
            local f=New("Frame",{Size=UDim2.new(1,0,0,70),BackgroundColor3=NAEI.Theme.Card,BackgroundTransparency=0.2,Parent=Page}); Corner(f,14); Stroke(f,NAEI.Theme.Border,0.5,1)
            New("TextLabel",{Size=UDim2.new(1,-24,0,18),Position=UDim2.fromOffset(14,10),BackgroundTransparency=1,Text=c.Title or "Info",TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=f})
            New("TextLabel",{Size=UDim2.new(1,-24,0,35),Position=UDim2.fromOffset(14,30),BackgroundTransparency=1,Text=c.Content or "",TextColor3=NAEI.Theme.Sub,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Left,TextWrapped=true,Parent=f}); return f
        end
        function Tab:AddButton(c)
            c=c or {}; local f=New("Frame",{Size=UDim2.new(1,0,0,60),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,16); local s=Stroke(f,NAEI.Theme.Border,0.4,1)
            local b=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=f})
            New("TextLabel",{Size=UDim2.new(1,-70,1,0),Position=UDim2.fromOffset(18,0),BackgroundTransparency=1,Text=c.Name or "Button",TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=b})
            local arrow=New("Frame",{Size=UDim2.fromOffset(36,36),Position=UDim2.new(1,-48,0.5,-18),BackgroundColor3=NAEI.Theme.Primary,BackgroundTransparency=0.85,Parent=b}); Corner(arrow,12)
            New("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="→",TextColor3=NAEI.Theme.Bg,TextSize=16,Font=Enum.Font.GothamBold,Parent=arrow})
            b.MouseEnter:Connect(function() Tween(f,0.2,{BackgroundColor3=NAEI.Theme.Hover}) Tween(s,0.2,{Color=NAEI.Theme.Primary}) end)
            b.MouseLeave:Connect(function() Tween(f,0.2,{BackgroundColor3=NAEI.Theme.Card}) Tween(s,0.2,{Color=NAEI.Theme.Border}) end)
            b.MouseButton1Click:Connect(function() Tween(f,0.08,{Size=UDim2.new(1,0,0,56)}) task.wait(0.08) Tween(f,0.2,{Size=UDim2.new(1,0,0,60)},Enum.EasingStyle.Back) if c.Callback then c.Callback() end end); RippleEffect(b)
            return f
        end
        function Tab:AddToggle(c)
            c=c or {}; local state=c.Default==true; local f=New("Frame",{Size=UDim2.new(1,0,0,62),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,16); Stroke(f,NAEI.Theme.Border,0.4,1)
            New("TextLabel",{Size=UDim2.new(1,-90,0,16),Position=UDim2.fromOffset(18,14),BackgroundTransparency=1,Text=c.Name or "Toggle",TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=f})
            if c.Desc then New("TextLabel",{Size=UDim2.new(1,-90,0,12),Position=UDim2.fromOffset(18,34),BackgroundTransparency=1,Text=c.Desc,TextColor3=NAEI.Theme.Muted,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=f}) end
            local Track=New("Frame",{Size=UDim2.fromOffset(58,30),Position=UDim2.new(1,-76,0.5,-15),BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off,Parent=f}); Corner(Track,15)
            local Thumb=New("Frame",{Size=UDim2.fromOffset(24,24),Position=state and UDim2.new(1,-27,0.5,-12) or UDim2.new(0,3,0.5,-12),BackgroundColor3=Color3.new(1,1,1),Parent=Track}); Corner(Thumb,100)
            local btn=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Parent=f})
            btn.MouseButton1Click:Connect(function() state=not state; Tween(Track,0.35,{BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off},Enum.EasingStyle.Back); Tween(Thumb,0.45,{Position=state and UDim2.new(1,-27,0.5,-12) or UDim2.new(0,3,0.5,-12)},Enum.EasingStyle.Back); if c.Callback then c.Callback(state) end end)
            return f
        end
        function Tab:AddSlider(c)
            c=c or {}; local val=c.Default or c.Min or 0; local f=New("Frame",{Size=UDim2.new(1,0,0,72),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,16); Stroke(f,NAEI.Theme.Border,0.4,1)
            New("TextLabel",{Size=UDim2.new(1,-80,0,16),Position=UDim2.fromOffset(18,12),BackgroundTransparency=1,Text=c.Name or "Slider",TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=f})
            local valLabel=New("TextLabel",{Size=UDim2.fromOffset(54,20),Position=UDim2.new(1,-70,0,10),BackgroundColor3=NAEI.Theme.BgSub,Text=tostring(val),TextColor3=NAEI.Theme.Primary,TextSize=11,Font=Enum.Font.Code,Parent=f}); Corner(valLabel,8)
            local track=New("Frame",{Size=UDim2.new(1,-36,0,8),Position=UDim2.fromOffset(18,46),BackgroundColor3=NAEI.Theme.Off,Parent=f}); Corner(track,100)
            local fill=New("Frame",{Size=UDim2.new((val/(c.Max or 100)),0,1,0),BackgroundColor3=NAEI.Theme.Primary,Parent=track}); Corner(fill,100); New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary,NAEI.Theme.Primary2),Parent=fill})
            local knob=New("Frame",{Size=UDim2.fromOffset(18,18),Position=UDim2.new((val/(c.Max or 100)),-9,0.5,-9),BackgroundColor3=Color3.new(1,1,1),Parent=track}); Corner(knob,100); Stroke(knob,NAEI.Theme.Primary,0,2)
            local drag=false; local function update(input) local rel=math.clamp((input.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1); local newVal=math.floor((c.Min or 0)+rel*((c.Max or 100)-(c.Min or 0))); val=newVal; valLabel.Text=tostring(val); Tween(fill,0.05,{Size=UDim2.new(rel,0,1,0)}); Tween(knob,0.05,{Position=UDim2.new(rel,-9,0.5,-9)}); if c.Callback then c.Callback(val) end end
            track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true update(i) end end); UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then update(i) end end); UserInputService.InputEnded:Connect(function() drag=false end); return f
        end
        function Tab:AddInput(c)
            c=c or {}; local f=New("Frame",{Size=UDim2.new(1,0,0,62),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,14); Stroke(f,NAEI.Theme.Border,0.4,1)
            New("TextLabel",{Size=UDim2.new(1,-20,0,14),Position=UDim2.fromOffset(16,8),BackgroundTransparency=1,Text=c.Name or "Input",TextColor3=NAEI.Theme.Sub,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=f})
            local box=New("TextBox",{Size=UDim2.new(1,-32,0,28),Position=UDim2.fromOffset(16,26),BackgroundColor3=NAEI.Theme.BgSub,Text=c.Default or "",PlaceholderText=c.Placeholder or "Type here...",TextColor3=NAEI.Theme.Text,PlaceholderColor3=NAEI.Theme.Muted,TextSize=12,Font=Enum.Font.Code,ClearTextOnFocus=false,Parent=f}); Corner(box,8)
            box.FocusLost:Connect(function() if c.Callback then c.Callback(box.Text) end end); return f
        end
        function Tab:AddDropdown(c)
            c=c or {}; local selected=c.Default or c.Options[1]; local f=New("Frame",{Size=UDim2.new(1,0,0,60),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,14); Stroke(f,NAEI.Theme.Border,0.4,1)
            New("TextLabel",{Size=UDim2.new(1,-20,0,14),Position=UDim2.fromOffset(16,8),BackgroundTransparency=1,Text=c.Name or "Dropdown",TextColor3=NAEI.Theme.Sub,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=f})
            local btn=New("TextButton",{Size=UDim2.new(1,-32,0,28),Position=UDim2.fromOffset(16,26),BackgroundColor3=NAEI.Theme.BgSub,Text=selected.." ▼",TextColor3=NAEI.Theme.Text,TextSize=12,Font=Enum.Font.GothamMedium,Parent=f}); Corner(btn,8)
            local opened=false; local list
            btn.MouseButton1Click:Connect(function()
                if opened then if list then list:Destroy() end opened=false return end
                opened=true; list=New("Frame",{Size=UDim2.new(1,-32,0,#c.Options*32),Position=UDim2.fromOffset(16,58),BackgroundColor3=NAEI.Theme.Card2,Parent=f,ZIndex=10}); Corner(list,10); Stroke(list,NAEI.Theme.Border,0.3,1)
                New("UIListLayout",{Padding=UDim.new(0,2),Parent=list}); New("UIPadding",{PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),Parent=list})
                for _,opt in ipairs(c.Options) do
                    local ob=New("TextButton",{Size=UDim2.new(1,-8,0,28),BackgroundColor3=NAEI.Theme.Card2,Text=opt,TextColor3=NAEI.Theme.Sub,TextSize=12,Font=Enum.Font.Gotham,Parent=list}); Corner(ob,8)
                    ob.MouseButton1Click:Connect(function() selected=opt; btn.Text=opt.." ▼"; opened=false; list:Destroy(); if c.Callback then c.Callback(opt) end end)
                end
            end)
            return f
        end

        table.insert(Window.Tabs,Tab); if #Window.Tabs==1 then Tab:Select() end; return Tab
    end
    function Window:Destroy() Tween(Main,0.35,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.35); Gui:Destroy() end
    CloseBtn.MouseButton1Click:Connect(function() Window:Destroy() end); MinBtn.MouseButton1Click:Connect(function() SetMin(true) end); Orb.MouseButton1Click:Connect(function() SetMin(false) end)
    return Window
end
return NAEI