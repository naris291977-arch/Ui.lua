--[[
    NAEI HUB v7.0 - GOD TIER ULTRA
    Rebuilt by Meta AI • Glass + Aurora + Particles + Neon
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local NAEI = {}
NAEI.Version = "7.0-GOD"
NAEI.Theme = {
    Bg = Color3.fromRGB(10, 10, 14),
    BgSub = Color3.fromRGB(16, 16, 22),
    Card = Color3.fromRGB(22, 22, 30),
    Card2 = Color3.fromRGB(28, 28, 38),
    Hover = Color3.fromRGB(38, 38, 52),
    Primary = Color3.fromRGB(155, 80, 255),
    Primary2 = Color3.fromRGB(80, 140, 255),
    Primary3 = Color3.fromRGB(255, 80, 180),
    Text = Color3.fromRGB(255, 255, 255),
    Sub = Color3.fromRGB(160, 160, 180),
    Muted = Color3.fromRGB(90, 90, 110),
    Border = Color3.fromRGB(50, 50, 65),
    Off = Color3.fromRGB(45, 45, 55),
    Danger = Color3.fromRGB(255, 65, 90),
}
NAEI.LogoUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg"
NAEI.LogoFile = "naei_v7.jpg"

-- UTILS
local function New(c,p) local o=Instance.new(c) for k,v in pairs(p or {}) do pcall(function() o[k]=v end) end return o end
local function Corner(o,r) New("UICorner",{CornerRadius=UDim.new(0,r or 10),Parent=o}) end
local function Stroke(o,c,t,tk) return New("UIStroke",{Color=c or NAEI.Theme.Border,Transparency=t or 0.4,Thickness=tk or 1.2,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=o}) end
local function Tween(o,t,pr,s,d) local tw=TweenService:Create(o,TweenInfo.new(t,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),pr) tw:Play() return tw end
local function GetParent() local ok,g=pcall(gethui) if ok and g then return g end return LocalPlayer:WaitForChild("PlayerGui") end
local function GetAsset(u,f) local fn=getcustomasset or getsynasset if not (fn and writefile and isfile) then return u end local ok,a=pcall(function() if not isfile(f) then writefile(f,game:HttpGet(u)) end return fn(f) end) return ok and a or u end

-- GLOW
local function AddGlow(obj, color, size)
    local glow = New("ImageLabel",{
        Size=UDim2.new(1, size or 40, 1, size or 40),
        Position=UDim2.new(0.5,0,0.5,0), AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundTransparency=1, Image="rbxassetid://5028857084", ImageColor3=color or NAEI.Theme.Primary,
        ImageTransparency=0.6, ZIndex=0, Parent=obj
    })
    return glow
end

-- PARTICLE BG
local function CreateParticles(parent)
    local pHolder = New("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ClipsDescendants=true,Parent=parent,ZIndex=1})
    for i=1,15 do
        local dot = New("Frame",{
            Size=UDim2.fromOffset(math.random(1,3), math.random(1,3)),
            Position=UDim2.fromScale(math.random(), math.random()),
            BackgroundColor3=Color3.fromHSV(math.random(60,90)/360, 0.8, 1),
            BackgroundTransparency=0.3, Parent=pHolder
        })
        Corner(dot,100)
        task.spawn(function()
            while dot.Parent do
                Tween(dot, math.random(5,12), {Position=UDim2.fromScale(math.random(), math.random()), BackgroundTransparency=math.random(2,7)/10}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(math.random(5,12))
            end
        end)
    end
end

-- ULTRA DRAG WITH INERTIA
local function EnableDrag(gui, handle)
    handle=handle or gui
    local dragging, dragStart, startPos, dragInput, velocity = false, nil, nil, nil, Vector2.new(0,0)
    local lastPos, lastTime = nil, tick()

    handle.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=gui.Position; lastPos=input.Position
            Tween(gui,0.15,{Size=UDim2.fromOffset(gui.AbsoluteSize.X*1.02, gui.AbsoluteSize.Y*1.02)},Enum.EasingStyle.Back)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input==dragInput and dragging then
            local delta=input.Position-dragStart
            local now=tick()
            velocity=(input.Position-lastPos)/(now-lastTime)
            lastPos=input.Position; lastTime=now
            gui.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then
            dragging=false
            Tween(gui,0.3,{Size=UDim2.fromOffset(gui.AbsoluteSize.X/1.02, gui.AbsoluteSize.Y/1.02)},Enum.EasingStyle.Back)
            -- inertia
            local inertia = velocity*0.15
            local target = gui.Position + UDim2.fromOffset(inertia.X, inertia.Y)
            Tween(gui,0.5,{Position=target},Enum.EasingStyle.Quad)
        end
    end)
end

-- LOADER GOD TIER
function NAEI:ShowLoader(cfg)
    cfg=cfg or {}
    local onFinish=cfg.OnFinish or function() end
    local Gui=New("ScreenGui",{Name="NAEI_LOADER_V7",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})
    local Blur=New("BlurEffect",{Size=0,Parent=game:GetService("Lighting")})
    Tween(Blur,0.6,{Size=24},Enum.EasingStyle.Quint)

    local BG=New("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(5,5,8),BackgroundTransparency=0.15,Parent=Gui})
    CreateParticles(BG)

    local Card=New("Frame",{
        Size=UDim2.fromOffset(300,340), AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
        BackgroundColor3=NAEI.Theme.Bg, BackgroundTransparency=0.1, Parent=Gui
    })
    Corner(Card,22)
    local stroke=Stroke(Card, NAEI.Theme.Primary, 0.1, 2)
    local grad=New("UIGradient",{Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, NAEI.Theme.Primary),
        ColorSequenceKeypoint.new(0.5, NAEI.Theme.Primary2),
        ColorSequenceKeypoint.new(1, NAEI.Theme.Primary3)
    }, Rotation=0, Parent=stroke})
    AddGlow(Card, NAEI.Theme.Primary, 80)

    Card.Size=UDim2.fromOffset(0,0)
    Tween(Card,0.7,{Size=UDim2.fromOffset(300,340)},Enum.EasingStyle.Back)

    task.spawn(function() while Card.Parent do grad.Rotation=(grad.Rotation+2)%360 task.wait(0.02) end end)

    -- Logo with rotating ring
    local LogoWrap=New("Frame",{Size=UDim2.fromOffset(90,90),Position=UDim2.new(0.5,-45,0,30),BackgroundTransparency=1,Parent=Card})
    local Ring=New("Frame",{Size=UDim2.fromOffset(90,90),BackgroundTransparency=1,Parent=LogoWrap})
    Corner(Ring,100)
    local RingStroke=Stroke(Ring, NAEI.Theme.Primary, 0, 2)
    New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2),Rotation=0,Parent=RingStroke})
    local LogoBox=New("Frame",{Size=UDim2.fromOffset(72,72),Position=UDim2.fromOffset(9,9),BackgroundColor3=NAEI.Theme.Card,Parent=Ring})
    Corner(LogoBox,100)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(62,62),Position=UDim2.fromOffset(5,5),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=LogoBox})
    Corner(Logo,100)

    task.spawn(function() while Ring.Parent do Ring.Rotation=(Ring.Rotation+1.5)%360 task.wait(0.01) Logo.Rotation=Logo.Rotation-0.5 end end)

    New("TextLabel",{Size=UDim2.new(1,0,0,22),Position=UDim2.fromOffset(0,135),BackgroundTransparency=1,Text=cfg.Title or "NAEI HUB",TextColor3=NAEI.Theme.Text,TextSize=20,Font=Enum.Font.GothamBold,Parent=Card})
    New("TextLabel",{Size=UDim2.new(1,0,0,14),Position=UDim2.fromOffset(0,157),BackgroundTransparency=1,Text=cfg.SubTitle or "v7.0 • GOD TIER • 1B× BEAUTY",TextColor3=NAEI.Theme.Sub,TextSize=10,Font=Enum.Font.Gotham,Parent=Card})

    local BarBG=New("Frame",{Size=UDim2.new(1,-50,0,6),Position=UDim2.fromOffset(25,210),BackgroundColor3=NAEI.Theme.Off,Parent=Card})
    Corner(BarBG,100)
    local Bar=New("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=NAEI.Theme.Primary,Parent=BarBG})
    Corner(Bar,100)
    New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2),Parent=Bar})

    local Status=New("TextLabel",{Size=UDim2.new(1,-50,0,14),Position=UDim2.fromOffset(25,225),BackgroundTransparency=1,Text="Initializing God Mode...",TextColor3=NAEI.Theme.Muted,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=Card})
    local Percent=New("TextLabel",{Size=UDim2.new(0,40,0,14),Position=UDim2.new(1,-50,0,225),BackgroundTransparency=1,Text="0%",TextColor3=NAEI.Theme.Primary,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Right,Parent=Card})

    local dots=New("TextLabel",{Size=UDim2.new(1,0,0,20),Position=UDim2.fromOffset(0,260),BackgroundTransparency=1,Text="● ● ●",TextColor3=NAEI.Theme.Muted,TextSize=12,Font=Enum.Font.GothamBold,Parent=Card})

    local steps={{"Injecting Aurora Engine",35},{"Loading Glassmorphism",70},{"Welcome, "..LocalPlayer.DisplayName.." ✨",100}}
    task.spawn(function()
        local last=0
        for _,s in ipairs(steps) do
            Status.Text=s[1]
            Tween(Bar,0.6,{Size=UDim2.new(s[2]/100,0,1,0)},Enum.EasingStyle.Expo)
            for i=last,s[2] do Percent.Text=i.."%" dots.TextTransparency=math.sin(i/10)*0.5+0.5 task.wait(0.015) end
            last=s[2] task.wait(0.2)
        end
        task.wait(0.4)
        Tween(Blur,0.4,{Size=0})
        Tween(Card,0.4,{Size=UDim2.fromOffset(0,0),Rotation=10},Enum.EasingStyle.Back,Enum.EasingDirection.In)
        task.wait(0.4) Gui:Destroy() Blur:Destroy() onFinish()
    end)
end

-- MAIN WINDOW GOD
function NAEI:CreateWindow(cfg)
    cfg=cfg or {}
    local Window={Tabs={}, Size=cfg.Size or Vector2.new(520,320)}
    local Gui=New("ScreenGui",{Name="NAEI_HUB_V7",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})

    local Main=New("Frame",{
        Size=UDim2.fromOffset(Window.Size.X,Window.Size.Y),
        Position=UDim2.new(0.5,-Window.Size.X/2,0.5,-Window.Size.Y/2),
        BackgroundColor3=NAEI.Theme.Bg, BackgroundTransparency=0.08, Parent=Gui
    })
    Corner(Main,18)
    local ms=Stroke(Main, NAEI.Theme.Primary, 0.2, 1.8)
    local mg=New("UIGradient",{Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0,NAEI.Theme.Primary),
        ColorSequenceKeypoint.new(0.5,NAEI.Theme.Primary2),
        ColorSequenceKeypoint.new(1,NAEI.Theme.Primary3)
    },Rotation=45,Parent=ms})
    AddGlow(Main, NAEI.Theme.Primary, 100)
    CreateParticles(Main)

    -- Aurora top light
    local Aurora=New("Frame",{Size=UDim2.new(1,0,0,100),BackgroundColor3=NAEI.Theme.Primary,BackgroundTransparency=0.9,Parent=Main,ZIndex=2})
    Corner(Aurora,18)
    New("UIGradient",{Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(170,80,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,14))
    },Rotation=90,Transparency=NumberSequence.new{
        NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)
    },Parent=Aurora})

    task.spawn(function() while Main.Parent do mg.Rotation=(mg.Rotation+0.7)%360 task.wait(0.03) end end)

    local Header=New("Frame",{Size=UDim2.new(1,0,0,42),BackgroundTransparency=1,Parent=Main,ZIndex=5})
    EnableDrag(Main,Header)

    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(28,28),Position=UDim2.fromOffset(12,8),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Header})
    Corner(Logo,8)
    New("TextLabel",{Size=UDim2.new(1,-140,0,14),Position=UDim2.fromOffset(48,8),BackgroundTransparency=1,Text=cfg.Title or "Naei Hub",TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Header})
    New("TextLabel",{Size=UDim2.new(1,-140,0,12),Position=UDim2.fromOffset(48,22),BackgroundTransparency=1,Text=cfg.Subtitle or "v7.0 • GOD TIER • 1,000,000,000×",TextColor3=NAEI.Theme.Sub,TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=Header})

    local function TopBtn(txt,pos,col)
        local b=New("TextButton",{Size=UDim2.fromOffset(28,28),Position=UDim2.new(1,pos,0,7),BackgroundColor3=NAEI.Theme.Card,Text=txt,TextColor3=NAEI.Theme.Sub,TextSize=14,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=Header})
        Corner(b,9) Stroke(b,NAEI.Theme.Border,0.6,1)
        b.MouseEnter:Connect(function() Tween(b,0.2,{BackgroundColor3=col or NAEI.Theme.Hover,TextColor3=NAEI.Theme.Text}) Tween(b,0.2,{Size=UDim2.fromOffset(30,30)}) end)
        b.MouseLeave:Connect(function() Tween(b,0.2,{BackgroundColor3=NAEI.Theme.Card,TextColor3=NAEI.Theme.Sub,Size=UDim2.fromOffset(28,28)}) end)
        return b
    end
    local CloseBtn=TopBtn("✕",-36,NAEI.Theme.Danger)
    local MinBtn=TopBtn("—",-70)

    -- Sidebar with glass
    local Sidebar=New("Frame",{Size=UDim2.new(0,140,1,-54),Position=UDim2.fromOffset(8,46),BackgroundColor3=NAEI.Theme.BgSub,BackgroundTransparency=0.3,Parent=Main})
    Corner(Sidebar,12) Stroke(Sidebar,NAEI.Theme.Border,0.7,1)

    local Profile=New("Frame",{Size=UDim2.new(1,-10,0,42),Position=UDim2.fromOffset(5,5),BackgroundColor3=NAEI.Theme.Card,Parent=Sidebar})
    Corner(Profile,10) Stroke(Profile,NAEI.Theme.Primary,0.7,1)
    New("ImageLabel",{Size=UDim2.fromOffset(30,30),Position=UDim2.fromOffset(6,6),BackgroundTransparency=1,Image="rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=100&h=100",Parent=Profile})
    New("TextLabel",{Size=UDim2.new(1,-44,0,13),Position=UDim2.fromOffset(40,6),BackgroundTransparency=1,Text=LocalPlayer.DisplayName,TextColor3=NAEI.Theme.Text,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Left,TextTruncate=AtEnd,Parent=Profile})
    New("TextLabel",{Size=UDim2.new(1,-44,0,10),Position=UDim2.fromOffset(40,20),BackgroundTransparency=1,Text="@"..LocalPlayer.Name,TextColor3=NAEI.Theme.Muted,TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=Profile})

    local TabHolder=New("ScrollingFrame",{Size=UDim2.new(1,-6,1,-58),Position=UDim2.fromOffset(3,52),BackgroundTransparency=1,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=Sidebar})
    New("UIListLayout",{Padding=UDim.new(0,6),Parent=TabHolder})

    local Content=New("Frame",{Size=UDim2.new(1,-162,1,-54),Position=UDim2.new(0,154,0,46),BackgroundTransparency=1,ClipsDescendants=true,Parent=Main})

    Main.Size=UDim2.fromOffset(0,0)
    Main.BackgroundTransparency=1
    Tween(Main,0.6,{Size=UDim2.fromOffset(Window.Size.X,Window.Size.Y),BackgroundTransparency=0.08},Enum.EasingStyle.Back)

    function Window:CreateTab(name, icon)
        local Tab={}
        local Btn=New("TextButton",{Size=UDim2.new(1,-6,0,34),BackgroundColor3=NAEI.Theme.Card,BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=TabHolder})
        Corner(Btn,10)
        local iconLbl=New("TextLabel",{Size=UDim2.fromOffset(22,22),Position=UDim2.fromOffset(6,6),BackgroundTransparency=1,Text=icon or "✦",TextColor3=NAEI.Theme.Sub,TextSize=12,Font=Enum.Font.GothamBold,Parent=Btn})
        local Label=New("TextLabel",{Size=UDim2.new(1,-36,1,0),Position=UDim2.fromOffset(30,0),BackgroundTransparency=1,Text=name,TextColor3=NAEI.Theme.Sub,TextSize=11,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=Btn})
        local Indicator=New("Frame",{Size=UDim2.fromOffset(3,18),Position=UDim2.fromOffset(-3,8),BackgroundColor3=NAEI.Theme.Primary,BackgroundTransparency=1,Parent=Btn})
        Corner(Indicator,100)

        local Page=New("ScrollingFrame",{
            Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScrollBarThickness=2,ScrollBarImageColor3=NAEI.Theme.Primary,
            CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=Content
        })
        New("UIListLayout",{Padding=UDim.new(0,8),Parent=Page})
        New("UIPadding",{PaddingTop=UDim.new(0,4),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,10),Parent=Page})

        function Tab:Select()
            for _,t in ipairs(Window.Tabs) do
                Tween(t.Button,0.2,{BackgroundTransparency=1})
                t.Button:FindFirstChildOfClass("TextLabel").TextColor3=NAEI.Theme.Sub
                t.Indicator.BackgroundTransparency=1
                t.Page.Visible=false
            end
            Tween(Btn,0.25,{BackgroundTransparency=0,BackgroundColor3=NAEI.Theme.Card2})
            Tween(Indicator,0.25,{BackgroundTransparency=0})
            Label.TextColor3=NAEI.Theme.Text
            iconLbl.TextColor3=NAEI.Theme.Primary
            Page.Visible=true
        end
        Tab.Button=Btn; Tab.Page=Page; Tab.Indicator=Indicator
        Btn.MouseEnter:Connect(function() if not Page.Visible then Tween(Btn,0.15,{BackgroundTransparency=0.5,BackgroundColor3=NAEI.Theme.Card}) end end)
        Btn.MouseLeave:Connect(function() if not Page.Visible then Tween(Btn,0.15,{BackgroundTransparency=1}) end end)
        Btn.Activated:Connect(function() Tab:Select() end)

        function Tab:AddSection(txt)
            local f=New("Frame",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,Parent=Page})
            New("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="— "..string.upper(txt),TextColor3=NAEI.Theme.Primary,TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=f})
        end
        function Tab:AddButton(c)
            c=c or {}
            local f=New("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=NAEI.Theme.Card,Parent=Page})
            Corner(f,10) local s=Stroke(f,NAEI.Theme.Border,0.6,1)
            local b=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=f})
            local l=New("TextLabel",{Size=UDim2.new(1,-20,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,Text=c.Name or "Button",TextColor3=NAEI.Theme.Text,TextSize=11,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=b})
            local arrow=New("TextLabel",{Size=UDim2.fromOffset(20,20),Position=UDim2.new(1,-28,0.5,-10),BackgroundTransparency=1,Text="›",TextColor3=NAEI.Theme.Muted,TextSize=16,Parent=b})
            b.MouseEnter:Connect(function() Tween(f,0.2,{BackgroundColor3=NAEI.Theme.Hover}) Tween(s,0.2,{Color=NAEI.Theme.Primary}) Tween(arrow,0.2,{TextColor3=NAEI.Theme.Text,Position=UDim2.new(1,-24,0.5,-10)}) end)
            b.MouseLeave:Connect(function() Tween(f,0.2,{BackgroundColor3=NAEI.Theme.Card}) Tween(s,0.2,{Color=NAEI.Theme.Border}) Tween(arrow,0.2,{TextColor3=NAEI.Theme.Muted,Position=UDim2.new(1,-28,0.5,-10)}) end)
            b.Activated:Connect(function() if c.Callback then c.Callback() end Tween(f,0.08,{Size=UDim2.new(1,0,0,35)}) task.wait(0.08) Tween(f,0.12,{Size=UDim2.new(1,0,0,38)}) end)
            return f
        end
        function Tab:AddToggle(c)
            c=c or {}; local state=c.Default==true
            local f=New("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=NAEI.Theme.Card,Parent=Page})
            Corner(f,10) Stroke(f,NAEI.Theme.Border,0.6,1)
            New("TextLabel",{Size=UDim2.new(1,-60,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,Text=c.Name or "Toggle",TextColor3=NAEI.Theme.Text,TextSize=11,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=f})
            local Track=New("Frame",{Size=UDim2.fromOffset(44,24),Position=UDim2.new(1,-54,0.5,-12),BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off,Parent=f})
            Corner(Track,12)
            if state then New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary,NAEI.Theme.Primary2),Parent=Track}) end
            local Thumb=New("Frame",{Size=UDim2.fromOffset(18,18),Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9),BackgroundColor3=Color3.new(1,1,1),Parent=Track})
            Corner(Thumb,100)
            AddGlow(Thumb, NAEI.Theme.Primary, 20)
            local btn=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Parent=f})
            btn.Activated:Connect(function()
                state=not state
                Tween(Track,0.3,{BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off},Enum.EasingStyle.Back)
                Tween(Thumb,0.35,{Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)},Enum.EasingStyle.Back)
                if c.Callback then c.Callback(state) end
            end)
            return f
        end
        -- เพิ่ม Slider / Dropdown / Label สวยๆได้อีก
        function Tab:AddSlider(c)
            c=c or {}; local val=c.Default or c.Min or 0
            local f=New("Frame",{Size=UDim2.new(1,0,0,52),BackgroundColor3=NAEI.Theme.Card,Parent=Page})
            Corner(f,10) Stroke(f,NAEI.Theme.Border,0.6,1)
            New("TextLabel",{Size=UDim2.new(1,-20,0,18),Position=UDim2.fromOffset(12,6),BackgroundTransparency=1,Text=c.Name or "Slider",TextColor3=NAEI.Theme.Text,TextSize=11,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=f})
            local valLbl=New("TextLabel",{Size=UDim2.fromOffset(40,18),Position=UDim2.new(1,-52,0,6),BackgroundTransparency=1,Text=tostring(val),TextColor3=NAEI.Theme.Primary,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Right,Parent=f})
            local track=New("Frame",{Size=UDim2.new(1,-24,0,6),Position=UDim2.fromOffset(12,32),BackgroundColor3=NAEI.Theme.Off,Parent=f}) Corner(track,100)
            local fill=New("Frame",{Size=UDim2.new((val-(c.Min or 0))/((c.Max or 100)-(c.Min or 0)),0,1,0),BackgroundColor3=NAEI.Theme.Primary,Parent=track}) Corner(fill,100) New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary,NAEI.Theme.Primary2),Parent=fill})
            return f
        end

        table.insert(Window.Tabs,Tab)
        if #Window.Tabs==1 then Tab:Select() end
        return Tab
    end

    function Window:Destroy()
        Tween(Main,0.3,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1,Rotation=5},Enum.EasingStyle.Back,Enum.EasingDirection.In)
        task.wait(0.3) Gui:Destroy()
    end

    CloseBtn.Activated:Connect(function() Window:Destroy() end)
    MinBtn.Activated:Connect(function() Main.Visible=not Main.Visible end)
    return Window
end

return NAEI