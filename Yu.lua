--[[
    NAEI HUB v14.0 - ULTRA NEON OBSIDIAN
    UPGRADED 10000x - Glass / Acrylic / Particle / Dock / Spring Engine
    By NAEI x GPT
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local NAEI = {}
NAEI.Version = "14.0-ULTRA-NEON"
NAEI.Theme = {
    Bg = Color3.fromRGB(8,8,10),
    BgSub = Color3.fromRGB(14,14,18),
    Card = Color3.fromRGB(22,22,28),
    Card2 = Color3.fromRGB(30,30,38),
    Hover = Color3.fromRGB(42,42,56),
    Primary = Color3.fromRGB(255, 235, 0),
    Primary2 = Color3.fromRGB(0, 255, 190),
    Primary3 = Color3.fromRGB(140, 100, 255),
    Text = Color3.fromRGB(255,255,255),
    Sub = Color3.fromRGB(160,160,175),
    Muted = Color3.fromRGB(90,90,105),
    Border = Color3.fromRGB(50,50,65),
    Off = Color3.fromRGB(45,45,58),
    Danger = Color3.fromRGB(255,60,90),
}
NAEI.LogoUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg"
NAEI.LogoFile = "naei_v14_ultra.jpg"

-- UTILS
local function New(c,p) local o=Instance.new(c) for k,v in pairs(p or {}) do pcall(function() o[k]=v end) end return o end
local function Corner(o,r) return New("UICorner",{CornerRadius=UDim.new(0,r or 14),Parent=o}) end
local function Stroke(o,c,t,tk) return New("UIStroke",{Color=c or NAEI.Theme.Border,Transparency=t or 0.5,Thickness=tk or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=o}) end
local function Tween(o,t,pr,s,d) local tw=TweenService:Create(o,TweenInfo.new(t,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),pr) tw:Play() return tw end
local function GetParent() local ok,g=pcall(gethui) if ok and g then return g end return LocalPlayer:WaitForChild("PlayerGui") end
local function GetAsset(u,f) local fn=getcustomasset or getsynasset if not (fn and writefile and isfile) then return u end local ok,a=pcall(function() if not isfile(f) then writefile(f,game:HttpGet(u)) end return fn(f) end) return ok and a or u end

local function EnableDrag(g,h)
    h=h or g; local d,s,sp,io=false
    h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true s=i.Position sp=g.Position end end)
    h.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then io=i end end)
    UserInputService.InputChanged:Connect(function(i) if i==io and d then local dd=i.Position-s g.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dd.X,sp.Y.Scale,sp.Y.Offset+dd.Y) end end)
    UserInputService.InputEnded:Connect(function() d=false end)
end

-- PARTICLE ENGINE FOR LOADER
local function AddParticles(parent, count)
    count = count or 12
    for i=1,count do
        local p = New("Frame",{Size=UDim2.fromOffset(math.random(2,4), math.random(2,4)), Position=UDim2.fromScale(math.random(), math.random()), BackgroundColor3= i%2==0 and NAEI.Theme.Primary or NAEI.Theme.Primary2, BackgroundTransparency=0.2, Parent=parent})
        Corner(p,100)
        task.spawn(function()
            while p.Parent do
                local np = UDim2.fromScale(math.random(), math.random())
                Tween(p, math.random(2,5), {Position=np, BackgroundTransparency=math.random()},{Enum.EasingStyle.Sine})
                task.wait(math.random(2,5))
            end
        end)
    end
end

-- ================= LOADER V14 ULTRA =================
function NAEI:ShowLoader(cfg)
    cfg=cfg or {}; local onFinish=cfg.OnFinish or function() end
    local finished=false
    local function Finish() if finished then return end finished=true pcall(onFinish) end

    local Gui=New("ScreenGui",{Name="NAEI_LOADER_V14",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})
    local Blur=New("BlurEffect",{Size=0,Parent=game:GetService("Lighting")}); Tween(Blur,0.6,{Size=24})

    local BG=New("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(2,2,4),BackgroundTransparency=0.15,Parent=Gui})
    AddParticles(BG, 20)

    local Card=New("Frame",{Size=UDim2.fromOffset(320,380),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),BackgroundColor3=NAEI.Theme.Bg,ClipsDescendants=true,Parent=Gui})
    Corner(Card,28); local st=Stroke(Card, NAEI.Theme.Primary, 0.15, 1.8)
    local g1=New("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,NAEI.Theme.Primary), ColorSequenceKeypoint.new(0.5,NAEI.Theme.Primary2), ColorSequenceKeypoint.new(1,NAEI.Theme.Primary3)},Rotation=0,Parent=st})

    -- Glow behind
    New("ImageLabel",{Size=UDim2.new(1.5,0,1.5,0),Position=UDim2.fromScale(-0.25,-0.25),BackgroundTransparency=1,Image="rbxassetid://5028857084",ImageColor3=NAEI.Theme.Primary,ImageTransparency=0.85,ZIndex=0,Parent=Card})

    Card.Size=UDim2.fromOffset(0,0); Tween(Card,0.8,{Size=UDim2.fromOffset(320,380)},Enum.EasingStyle.Back)

    task.spawn(function() while Card.Parent do g1.Rotation=(g1.Rotation+1)%360 task.wait(0.02) end end)

    local LogoBox=New("Frame",{Size=UDim2.fromOffset(88,88),Position=UDim2.new(0.5,-44,0,35),BackgroundColor3=NAEI.Theme.Card2,Parent=Card}); Corner(LogoBox,24); Stroke(LogoBox, NAEI.Theme.Primary, 0.1, 2)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(72,72),Position=UDim2.fromOffset(8,8),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=LogoBox}); Corner(Logo,18)

    -- Tilt Effect
    RunService.RenderStepped:Connect(function()
        if not LogoBox.Parent then return end
        local rot = math.sin(tick()*2)*2
        LogoBox.Rotation = rot
    end)

    New("TextLabel",{Size=UDim2.new(1,0,0,22),Position=UDim2.fromOffset(0,145),BackgroundTransparency=1,Text=cfg.Title or "NAEI HUB",TextColor3=NAEI.Theme.Text,TextSize=22,Font=Enum.Font.GothamBold,Parent=Card})
    New("TextLabel",{Size=UDim2.new(1,0,0,12),Position=UDim2.fromOffset(0,170),BackgroundTransparency=1,Text=cfg.SubTitle or "v14.0 • ULTRA NEON • 10000X",TextColor3=NAEI.Theme.Primary,TextSize=10,Font=Enum.Font.Code,Parent=Card})

    local BarBG=New("Frame",{Size=UDim2.new(1,-40,0,8),Position=UDim2.fromOffset(20,225),BackgroundColor3=NAEI.Theme.Off,ClipsDescendants=true,Parent=Card}); Corner(BarBG,100)
    local Bar=New("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=NAEI.Theme.Primary,Parent=BarBG}); Corner(Bar,100); New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2),Parent=Bar})

    local Status=New("TextLabel",{Size=UDim2.new(1,-40,0,14),Position=UDim2.fromOffset(20,245),BackgroundTransparency=1,Text="INITIALIZING...",TextColor3=NAEI.Theme.Muted,TextSize=10,Font=Enum.Font.Code,TextXAlignment=Left,Parent=Card})
    local Percent=New("TextLabel",{Size=UDim2.new(0,60,0,20),Position=UDim2.new(1,-70,0,240),BackgroundTransparency=1,Text="0%",TextColor3=NAEI.Theme.Text,TextSize=18,Font=Enum.Font.GothamBold,TextXAlignment=Right,Parent=Card})

    local Dots=New("Frame",{Size=UDim2.new(1,-40,0,10),Position=UDim2.fromOffset(20,270),BackgroundTransparency=1,Parent=Card})
    local dl=New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6),HorizontalAlignment=Enum.HorizontalAlignment.Center,Parent=Dots})
    local dotFrames={}
    for i=1,3 do local d=New("Frame",{Size=UDim2.fromOffset(8,8),BackgroundColor3=NAEI.Theme.Primary,BackgroundTransparency=0.7,Parent=Dots}); Corner(d,100); table.insert(dotFrames,d) end

    task.delay(6, function() -- Anti Stuck
        if not finished then
            Tween(Blur,0.3,{Size=0}); Tween(Card,0.3,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.3); pcall(function() Gui:Destroy() Blur:Destroy() end); Finish()
        end
    end)

    task.spawn(function()
        local steps={
            {Text=">> BOOTING NEON CORE", P=25},
            {Text=">> INJECTING OBSIDIAN SHADERS", P=55},
            {Text=">> SYNCING ULTRA UI", P=85},
            {Text=">> WELCOME "..string.upper(LocalPlayer.DisplayName), P=100}
        }
        for idx,s in ipairs(steps) do
            if finished then break end
            Status.Text=s.Text
            Tween(Bar, 0.6, {Size=UDim2.new(s.P/100,0,1,0)}, Enum.EasingStyle.Expo)
            for i=(idx==1 and 0 or steps[idx-1].P), s.P do
                if finished then break end
                Percent.Text=i.."%"
                for _,d in ipairs(dotFrames) do Tween(d,0.2,{BackgroundTransparency=math.random()}) end
                task.wait(0.015)
            end
            task.wait(0.25)
        end
        if finished then return end
        task.wait(0.4)
        Tween(Blur,0.4,{Size=0})
        Tween(Card,0.4,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In)
        task.wait(0.42)
        pcall(function() Gui:Destroy() Blur:Destroy() end)
        Finish()
    end)
end

-- NOTIFY SYSTEM
function NAEI:Notify(title, msg, duration)
    local Gui = GetParent():FindFirstChild("NAEI_HUB_V14") and GetParent().NAEI_HUB_V14 or New("ScreenGui",{Name="NAEI_NOTIFY",Parent=GetParent()})
    local Notif = New("Frame",{Size=UDim2.fromOffset(280,70),Position=UDim2.new(1,-300,1,100),BackgroundColor3=NAEI.Theme.Card2,Parent=Gui}); Corner(Notif,16); Stroke(Notif,NAEI.Theme.Primary,0.3,1)
    New("TextLabel",{Size=UDim2.new(1,-16,0,18),Position=UDim2.fromOffset(14,10),BackgroundTransparency=1,Text=title,TextColor3=NAEI.Theme.Primary,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Notif})
    New("TextLabel",{Size=UDim2.new(1,-16,0,30),Position=UDim2.fromOffset(14,30),BackgroundTransparency=1,Text=msg,TextColor3=NAEI.Theme.Sub,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Left,TextWrapped=true,Parent=Notif})
    Tween(Notif,0.6,{Position=UDim2.new(1,-300,1,-90)},Enum.EasingStyle.Back)
    task.delay(duration or 3, function() Tween(Notif,0.4,{Position=UDim2.new(1,-300,1,100)},Enum.EasingStyle.Back,Enum.EasingDirection.In) task.wait(0.4) Notif:Destroy() end)
end

-- ================= UI MAIN V14 =================
function NAEI:CreateWindow(cfg)
    cfg=cfg or {}; local WSize=cfg.Size or Vector2.new(720,480); local Window={Tabs={}};
    local Gui=New("ScreenGui",{Name="NAEI_HUB_V14",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})

    local Main=New("Frame",{Size=UDim2.fromOffset(WSize.X,WSize.Y),Position=UDim2.new(0.5,-WSize.X/2,0.5,-WSize.Y/2),BackgroundColor3=NAEI.Theme.Bg,BackgroundTransparency=0.02,Parent=Gui})
    Corner(Main,26); local ms=Stroke(Main, NAEI.Theme.Primary, 0.08, 2); local mg=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2),Rotation=45,Parent=ms})
    -- Inner Glow
    local InnerShadow = New("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Parent=Main}); Corner(InnerShadow,26); Stroke(InnerShadow, NAEI.Theme.Primary, 0.85, 12)

    task.spawn(function() while Main.Parent do mg.Rotation=(mg.Rotation+0.25)%360 task.wait(0.04) end end)

    local Header=New("Frame",{Size=UDim2.new(1,0,0,58),BackgroundTransparency=1,Parent=Main,ZIndex=10}); EnableDrag(Main,Header)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(36,36),Position=UDim2.fromOffset(18,11),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Header}); Corner(Logo,12)
    New("TextLabel",{Size=UDim2.new(1,-200,0,18),Position=UDim2.fromOffset(62,14),BackgroundTransparency=1,Text=cfg.Title or "NAEI HUB",TextColor3=NAEI.Theme.Text,TextSize=16,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Header})
    New("TextLabel",{Size=UDim2.new(1,-200,0,10),Position=UDim2.fromOffset(62,34),BackgroundTransparency=1,Text=cfg.Subtitle or "v14.0 • ULTRA NEON • 10000X UPGRADE",TextColor3=NAEI.Theme.Primary,TextSize=9,Font=Enum.Font.Code,TextXAlignment=Left,Parent=Header})

    local TopDock=New("Frame",{Size=UDim2.new(1,-24,0,48),Position=UDim2.fromOffset(12,60),BackgroundColor3=NAEI.Theme.BgSub,BackgroundTransparency=0.1,Parent=Main}); Corner(TopDock,16); Stroke(TopDock, NAEI.Theme.Border, 0.3, 1)
    New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,10), HorizontalAlignment=Enum.HorizontalAlignment.Center, VerticalAlignment=Enum.VerticalAlignment.Center, Parent=TopDock}); New("UIPadding",{PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10), Parent=TopDock})

    local Content=New("Frame",{Size=UDim2.new(1,-24,1,-122),Position=UDim2.new(0,12,0,118),BackgroundTransparency=1,Parent=Main,ClipsDescendants=true})

    local Orb=New("ImageButton",{Size=UDim2.fromOffset(64,64),Position=UDim2.new(0,24,0.5,-32),BackgroundColor3=NAEI.Theme.Card2,Visible=false,Parent=Gui,ZIndex=50}); Corner(Orb,100); Stroke(Orb, NAEI.Theme.Primary, 0, 2.5)
    local OrbLogo=New("ImageLabel",{Size=UDim2.fromOffset(48,48),Position=UDim2.fromOffset(8,8),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Orb}); Corner(OrbLogo,100); EnableDrag(Orb,Orb)

    local function TopBtn(txt,pos) local b=New("TextButton",{Size=UDim2.fromOffset(36,36),Position=UDim2.new(1,pos,0,11),BackgroundColor3=NAEI.Theme.Card,Text=txt,TextColor3=NAEI.Theme.Sub,TextSize=16,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=Header}); Corner(b,12); Stroke(b,NAEI.Theme.Border,0.5,1);
        b.MouseEnter:Connect(function() Tween(b,0.2,{BackgroundColor3=NAEI.Theme.Hover}) end)
        b.MouseLeave:Connect(function() Tween(b,0.2,{BackgroundColor3=NAEI.Theme.Card}) end)
        return b
    end
    local CloseBtn=TopBtn("✕",-48); local MinBtn=TopBtn("—",-92)

    Main.Size=UDim2.fromOffset(0,0); Main.BackgroundTransparency=1; Tween(Main,0.8,{Size=UDim2.fromOffset(WSize.X,WSize.Y),BackgroundTransparency=0.02},Enum.EasingStyle.Back)
    local minimized=false; local function SetMin(s) minimized=s; if s then Tween(Main,0.35,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In) task.wait(0.35) Main.Visible=false Orb.Visible=true Orb.Size=UDim2.fromOffset(0,0) Tween(Orb,0.5,{Size=UDim2.fromOffset(64,64)},Enum.EasingStyle.Back) else Tween(Orb,0.25,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In) task.wait(0.25) Orb.Visible=false Main.Visible=true Main.Size=UDim2.fromOffset(0,0) Tween(Main,0.6,{Size=UDim2.fromOffset(WSize.X,WSize.Y),BackgroundTransparency=0.02},Enum.EasingStyle.Back) end end

    function Window:CreateTab(name, icon)
        local Tab={}
        local Btn=New("TextButton",{Size=UDim2.new(0,124,0,34),BackgroundColor3=NAEI.Theme.Card,BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=TopDock}); Corner(Btn,12); Stroke(Btn, NAEI.Theme.Border, 1, 1)
        local Icon=New("TextLabel",{Size=UDim2.fromOffset(22,22),Position=UDim2.fromOffset(10,6),BackgroundTransparency=1,Text=icon or "●",TextColor3=NAEI.Theme.Sub,TextSize=13,Parent=Btn})
        local Label=New("TextLabel",{Size=UDim2.new(1,-40,1,0),Position=UDim2.fromOffset(34,0),BackgroundTransparency=1,Text=name,TextColor3=NAEI.Theme.Sub,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Btn})
        local Page=New("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScrollBarThickness=3,ScrollBarImageColor3=NAEI.Theme.Primary,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=Content}); New("UIListLayout",{Padding=UDim.new(0,14),Parent=Page}); New("UIPadding",{PaddingTop=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,18),PaddingBottom=UDim.new(0,20),Parent=Page})

        -- Dock Hover Magnify Effect
        Btn.MouseEnter:Connect(function() if not Page.Visible then Tween(Btn,0.2,{BackgroundTransparency=0.5,Size=UDim2.new(0,130,0,38)}) end end)
        Btn.MouseLeave:Connect(function() if not Page.Visible then Tween(Btn,0.2,{BackgroundTransparency=1,Size=UDim2.new(0,124,0,34)}) end end)

        function Tab:Select()
            for _,t in ipairs(Window.Tabs) do Tween(t.Button,0.25,{BackgroundTransparency=1, BackgroundColor3=NAEI.Theme.Card}); t.Button.UIStroke.Transparency=1; t.Label.TextColor3=NAEI.Theme.Sub; t.Icon.TextColor3=NAEI.Theme.Sub; t.Page.Visible=false end
            Tween(Btn,0.3,{BackgroundTransparency=0,BackgroundColor3=NAEI.Theme.Card2}); Btn.UIStroke.Transparency=0.2; Btn.UIStroke.Color=NAEI.Theme.Primary; Label.TextColor3=NAEI.Theme.Primary; Icon.TextColor3=NAEI.Theme.Primary; Page.Visible=true
        end
        Tab.Button=Btn; Tab.Label=Label; Tab.Icon=Icon; Tab.Page=Page; Btn.MouseButton1Click:Connect(function() Tab:Select() end)

        -- NEW COMPONENTS
        function Tab:AddSection(txt)
            local f=New("Frame",{Size=UDim2.new(1,0,0,32),BackgroundTransparency=1,Parent=Page})
            local line=New("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=NAEI.Theme.Border,BackgroundTransparency=0.3,Parent=f})
            local l=New("TextLabel",{Size=UDim2.fromOffset(160,32),Position=UDim2.fromOffset(8,0),BackgroundColor3=NAEI.Theme.Bg,Text=" "..string.upper(txt).." ",TextColor3=NAEI.Theme.Primary2,TextSize=11,Font=Enum.Font.Code,TextXAlignment=Left,Parent=f})
        end
        function Tab:AddParagraph(c)
            local f=New("Frame",{Size=UDim2.new(1,0,0,60),BackgroundColor3=NAEI.Theme.Card,BackgroundTransparency=0.3,Parent=Page}); Corner(f,14); Stroke(f,NAEI.Theme.Border,0.6,1)
            New("TextLabel",{Size=UDim2.new(1,-20,0,18),Position=UDim2.fromOffset(12,8),BackgroundTransparency=1,Text=c.Title or "Info",TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=f})
            New("TextLabel",{Size=UDim2.new(1,-20,0,30),Position=UDim2.fromOffset(12,26),BackgroundTransparency=1,Text=c.Content or "",TextColor3=NAEI.Theme.Sub,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Left,TextWrapped=true,Parent=f})
            return f
        end
        function Tab:AddButton(c)
            c=c or {}; local f=New("Frame",{Size=UDim2.new(1,0,0,58),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,16); local s=Stroke(f,NAEI.Theme.Border,0.4,1)
            local b=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=f})
            New("TextLabel",{Size=UDim2.new(1,-60,1,0),Position=UDim2.fromOffset(18,0),BackgroundTransparency=1,Text=c.Name or "Button",TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=b})
            local arrow=New("Frame",{Size=UDim2.fromOffset(32,32),Position=UDim2.new(1,-44,0.5,-16),BackgroundColor3=NAEI.Theme.Primary,BackgroundTransparency=0.9,Parent=b}); Corner(arrow,10)
            New("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="→",TextColor3=NAEI.Theme.Bg,TextSize=16,Font=Enum.Font.GothamBold,Parent=arrow})
            b.MouseEnter:Connect(function() Tween(f,0.2,{BackgroundColor3=NAEI.Theme.Hover}) Tween(s,0.2,{Color=NAEI.Theme.Primary}) Tween(arrow,0.2,{BackgroundTransparency=0,Rotation=0}) end)
            b.MouseLeave:Connect(function() Tween(f,0.2,{BackgroundColor3=NAEI.Theme.Card}) Tween(s,0.2,{Color=NAEI.Theme.Border}) Tween(arrow,0.2,{BackgroundTransparency=0.9}) end)
            b.MouseButton1Click:Connect(function() Tween(f,0.05,{Size=UDim2.new(1,0,0,54)}) task.wait(0.05) Tween(f,0.2,{Size=UDim2.new(1,0,0,58)},Enum.EasingStyle.Back) if c.Callback then c.Callback() end end)
            return f
        end
        function Tab:AddToggle(c)
            c=c or {}; local state=c.Default==true; local f=New("Frame",{Size=UDim2.new(1,0,0,60),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,16); Stroke(f,NAEI.Theme.Border,0.4,1)
            New("TextLabel",{Size=UDim2.new(1,-90,0,16),Position=UDim2.fromOffset(18,12),BackgroundTransparency=1,Text=c.Name or "Toggle",TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=f})
            if c.Desc then New("TextLabel",{Size=UDim2.new(1,-90,0,12),Position=UDim2.fromOffset(18,32),BackgroundTransparency=1,Text=c.Desc,TextColor3=NAEI.Theme.Muted,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=f}) end
            local Track=New("Frame",{Size=UDim2.fromOffset(56,30),Position=UDim2.new(1,-74,0.5,-15),BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off,Parent=f}); Corner(Track,15)
            local Thumb=New("Frame",{Size=UDim2.fromOffset(24,24),Position=state and UDim2.new(1,-27,0.5,-12) or UDim2.new(0,3,0.5,-12),BackgroundColor3=Color3.new(1,1,1),Parent=Track}); Corner(Thumb,100)
            local btn=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Parent=f})
            btn.MouseButton1Click:Connect(function() state=not state; Tween(Track,0.35,{BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off},Enum.EasingStyle.Back); Tween(Thumb,0.4,{Position=state and UDim2.new(1,-27,0.5,-12) or UDim2.new(0,3,0.5,-12)},Enum.EasingStyle.Back); if c.Callback then c.Callback(state) end end)
            return f
        end
        function Tab:AddSlider(c)
            c=c or {}; local val=c.Default or c.Min or 0; local f=New("Frame",{Size=UDim2.new(1,0,0,68),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,16); Stroke(f,NAEI.Theme.Border,0.4,1)
            New("TextLabel",{Size=UDim2.new(1,-20,0,16),Position=UDim2.fromOffset(18,10),BackgroundTransparency=1,Text=c.Name or "Slider",TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=f})
            local valLabel=New("TextLabel",{Size=UDim2.fromOffset(50,16),Position=UDim2.new(1,-60,0,10),BackgroundColor3=NAEI.Theme.BgSub,Text=tostring(val),TextColor3=NAEI.Theme.Primary,TextSize=11,Font=Enum.Font.Code,Parent=f}); Corner(valLabel,6)
            local track=New("Frame",{Size=UDim2.new(1,-36,0,6),Position=UDim2.fromOffset(18,44),BackgroundColor3=NAEI.Theme.Off,Parent=f}); Corner(track,100)
            local fill=New("Frame",{Size=UDim2.new((val/(c.Max or 100)),0,1,0),BackgroundColor3=NAEI.Theme.Primary,Parent=track}); Corner(fill,100); New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary,NAEI.Theme.Primary2),Parent=fill})
            local knob=New("Frame",{Size=UDim2.fromOffset(16,16),Position=UDim2.new((val/(c.Max or 100)),-8,0.5,-8),BackgroundColor3=Color3.new(1,1,1),Parent=track}); Corner(knob,100); Stroke(knob,NAEI.Theme.Primary,0,2)
            local drag=false
            local function update(input)
                local rel = math.clamp((input.Position.X - track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                local newVal = math.floor((c.Min or 0) + rel * ((c.Max or 100)-(c.Min or 0)))
                val=newVal; valLabel.Text=tostring(val); Tween(fill,0.1,{Size=UDim2.new(rel,0,1,0)}); Tween(knob,0.1,{Position=UDim2.new(rel,-8,0.5,-8)})
                if c.Callback then c.Callback(val) end
            end
            track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true update(i) end end)
            UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then update(i) end end)
            UserInputService.InputEnded:Connect(function() drag=false end)
            return f
        end

        table.insert(Window.Tabs,Tab); if #Window.Tabs==1 then Tab:Select() end; return Tab
    end

    function Window:Destroy() Tween(Main,0.35,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.35); Gui:Destroy() end
    CloseBtn.MouseButton1Click:Connect(function() Window:Destroy() end); MinBtn.MouseButton1Click:Connect(function() SetMin(true) end); Orb.MouseButton1Click:Connect(function() SetMin(false) end)
    return Window
end
return NAEI