--[[
    NAEI HUB v9.0 - ULTRA GOD 1000x
    Fixed Minimize • Floating Orb • Cursor Glow • 3D Tilt • Liquid Morph
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local NAEI = {}
NAEI.Version = "9.0-1000x"
NAEI.Theme = {
    Bg = Color3.fromRGB(8,8,12), BgSub = Color3.fromRGB(14,14,20),
    Card = Color3.fromRGB(20,20,28), Card2 = Color3.fromRGB(28,28,40),
    Hover = Color3.fromRGB(35,35,50), Primary = Color3.fromRGB(138,92,255),
    Primary2 = Color3.fromRGB(92,168,255), Primary3 = Color3.fromRGB(255,92,168),
    Text = Color3.fromRGB(255,255,255), Sub = Color3.fromRGB(165,165,190),
    Muted = Color3.fromRGB(85,85,105), Border = Color3.fromRGB(55,55,75),
    Off = Color3.fromRGB(40,40,55), Danger = Color3.fromRGB(255,60,90),
}
NAEI.LogoUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg"
NAEI.LogoFile = "naei_v9.jpg"

local function New(c,p) local o=Instance.new(c) for k,v in pairs(p or {}) do pcall(function() o[k]=v end) end return o end
local function Corner(o,r) New("UICorner",{CornerRadius=UDim.new(0,r or 12),Parent=o}) end
local function Stroke(o,c,t,tk) return New("UIStroke",{Color=c or NAEI.Theme.Border,Transparency=t or 0.5,Thickness=tk or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=o}) end
local function Tween(o,t,props,s,d) local tw=TweenService:Create(o,TweenInfo.new(t,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),props) tw:Play() return tw end
local function GetParent() local ok,g=pcall(gethui) if ok and g then return g end return LocalPlayer:WaitForChild("PlayerGui") end
local function GetAsset(u,f) local fn=getcustomasset or getsynasset if not (fn and writefile and isfile) then return u end local ok,a=pcall(function() if not isfile(f) then writefile(f,game:HttpGet(u)) end return fn(f) end) return ok and a or u end
local function AddGlow(o,c,s,tr) return New("ImageLabel",{Size=UDim2.new(1,s or 60,1,s or 60),Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Image="rbxassetid://5028857084",ImageColor3=c or NAEI.Theme.Primary,ImageTransparency=tr or 0.5,ZIndex=0,Parent=o}) end

local function EnableDrag(gui, handle)
    handle=handle or gui; local dragging, start, startPos, inputObj=false
    handle.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true start=i.Position startPos=gui.Position end end)
    handle.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then inputObj=i end end)
    UserInputService.InputChanged:Connect(function(i) if i==inputObj and dragging then local d=i.Position-start gui.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
    UserInputService.InputEnded:Connect(function() dragging=false end)
end

--// LOADER v9 FIXED BAR
function NAEI:ShowLoader(cfg)
    cfg=cfg or {}; local onFinish=cfg.OnFinish or function() end
    local Gui=New("ScreenGui",{Name="NAEI_LOADER_V9",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})
    local Blur=New("BlurEffect",{Size=0,Parent=game:GetService("Lighting")}); Tween(Blur,0.8,{Size=28})
    local BG=New("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(3,3,6),Parent=Gui})
    local Card=New("Frame",{Size=UDim2.fromOffset(320,380),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),BackgroundColor3=NAEI.Theme.Bg,BackgroundTransparency=0.15,Parent=Gui})
    Corner(Card,24); local st=Stroke(Card, NAEI.Theme.Primary, 0.15, 2); local grad=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2),Rotation=0,Parent=st})
    AddGlow(Card, NAEI.Theme.Primary, 120, 0.4); Card.Size=UDim2.fromOffset(0,0); Tween(Card,0.8,{Size=UDim2.fromOffset(320,380)},Enum.EasingStyle.Back)
    task.spawn(function() while Card.Parent do grad.Rotation=(grad.Rotation+1)%360 task.wait(0.02) end end)
    local Ring=New("Frame",{Size=UDim2.fromOffset(100,100),Position=UDim2.new(0.5,-50,0,35),BackgroundTransparency=1,Parent=Card}); Corner(Ring,100); Stroke(Ring, NAEI.Theme.Primary, 0, 2.5)
    local LogoBox=New("Frame",{Size=UDim2.fromOffset(80,80),Position=UDim2.fromOffset(10,10),BackgroundColor3=NAEI.Theme.Card,Parent=Ring}); Corner(LogoBox,100)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(70,70),Position=UDim2.fromOffset(5,5),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=LogoBox}); Corner(Logo,100)
    task.spawn(function() while Ring.Parent do Ring.Rotation+=1 task.wait(0.015) end end)
    New("TextLabel",{Size=UDim2.new(1,0,0,24),Position=UDim2.fromOffset(0,150),BackgroundTransparency=1,Text=cfg.Title or "NAEI HUB",TextColor3=NAEI.Theme.Text,TextSize=22,Font=Enum.Font.GothamBold,Parent=Card})
    New("TextLabel",{Size=UDim2.new(1,0,0,14),Position=UDim2.fromOffset(0,174),BackgroundTransparency=1,Text="v9.0 • 1000x BEAUTY",TextColor3=NAEI.Theme.Sub,TextSize=10,Font=Enum.Font.Gotham,Parent=Card})
    local BarBG=New("Frame",{Size=UDim2.new(1,-50,0,8),Position=UDim2.fromOffset(25,220),BackgroundColor3=NAEI.Theme.Off,ClipsDescendants=true,Parent=Card}); Corner(BarBG,100)
    local Bar=New("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=NAEI.Theme.Primary,Parent=BarBG}); Corner(Bar,100); New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2),Rotation=90,Parent=Bar})
    local Shimmer=New("Frame",{Size=UDim2.new(0,60,1,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.7,Parent=Bar}); Corner(Shimmer,100)
    task.spawn(function() while Bar.Parent do Shimmer.Position=UDim2.new(0,-60,0,0) Tween(Shimmer,1.2,{Position=UDim2.new(1,0,0,0)},Enum.EasingStyle.Linear) task.wait(1.2) end end)
    local Stat=New("TextLabel",{Size=UDim2.new(1,-50,0,14),Position=UDim2.fromOffset(25,240),BackgroundTransparency=1,Text="Initializing...",TextColor3=NAEI.Theme.Muted,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=Card})
    local Perc=New("TextLabel",{Size=UDim2.new(0,60,0,14),Position=UDim2.new(1,-55,0,240),BackgroundTransparency=1,Text="0%",TextColor3=NAEI.Theme.Primary,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Right,Parent=Card})
    task.spawn(function()
        local steps={{Text="Crafting 1000x Glass...", Target=35},{Text="Injecting God Aura...", Target=75},{Text="Welcome "..LocalPlayer.DisplayName.." ✨", Target=100}}
        local cur=0; for _,step in ipairs(steps) do Stat.Text=step.Text; for i=cur,step.Target do cur=i; Perc.Text=i.."%"; Bar.Size=UDim2.new(i/100,0,1,0); task.wait(0.015) end task.wait(0.2) end
        task.wait(0.3); Tween(Blur,0.5,{Size=0}); Tween(Card,0.4,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.4); Gui:Destroy(); Blur:Destroy(); onFinish()
    end)
end

--// MAIN WINDOW v9
function NAEI:CreateWindow(cfg)
    cfg=cfg or {}; local WSize=cfg.Size or Vector2.new(580,380)
    local Window={Tabs={}}; local Gui=New("ScreenGui",{Name="NAEI_HUB_V9",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})

    -- CURSOR GLOW
    local CursorGlow=New("Frame",{Size=UDim2.fromOffset(150,150),BackgroundColor3=NAEI.Theme.Primary,BackgroundTransparency=0.85,Parent=Gui, ZIndex=100}); Corner(CursorGlow,100); AddGlow(CursorGlow, NAEI.Theme.Primary, 50, 0.3)
    UserInputService.InputChanged:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseMovement then CursorGlow.Position=UDim2.fromOffset(input.Position.X-75, input.Position.Y-75) end end)

    local Main=New("Frame",{Size=UDim2.fromOffset(WSize.X,WSize.Y),Position=UDim2.new(0.5,-WSize.X/2,0.5,-WSize.Y/2),BackgroundColor3=NAEI.Theme.Bg,BackgroundTransparency=0.08,Parent=Gui})
    Corner(Main,20); local ms=Stroke(Main, NAEI.Theme.Primary, 0.2, 2)
    local mg=New("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,NAEI.Theme.Primary),ColorSequenceKeypoint.new(0.5,NAEI.Theme.Primary2),ColorSequenceKeypoint.new(1,NAEI.Theme.Primary3)},Rotation=30,Parent=ms})
    AddGlow(Main, NAEI.Theme.Primary, 150, 0.5)
    task.spawn(function() while Main.Parent do mg.Rotation=(mg.Rotation+0.4)%360 task.wait(0.04) end end)

    -- 3D TILT EFFECT
    task.spawn(function()
        while Main.Parent do
            local mouse = UserInputService:GetMouseLocation()
            local center = Main.AbsolutePosition + Main.AbsoluteSize/2
            local diff = (Vector2.new(mouse.X, mouse.Y) - center) / 50
            Tween(Main, 0.8, {Rotation= -diff.X*0.05}, Enum.EasingStyle.Quad)
            RunService.RenderStepped:Wait()
        end
    end)

    local Header=New("Frame",{Size=UDim2.new(1,0,0,48),BackgroundTransparency=1,Parent=Main,ZIndex=10}); EnableDrag(Main,Header)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(30,30),Position=UDim2.fromOffset(14,9),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Header}); Corner(Logo,9)
    New("TextLabel",{Size=UDim2.new(1,-160,0,15),Position=UDim2.fromOffset(52,10),BackgroundTransparency=1,Text=cfg.Title or "Naei Hub",TextColor3=NAEI.Theme.Text,TextSize=14,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Header})
    New("TextLabel",{Size=UDim2.new(1,-160,0,12),Position=UDim2.fromOffset(52,26),BackgroundTransparency=1,Text=cfg.Subtitle or "v9.0 • 1000x",TextColor3=NAEI.Theme.Sub,TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=Header})

    -- FLOATING ORB FOR MINIMIZE (แก้บัคพับแล้วเปิดไม่ได้)
    local Orb=New("ImageButton",{Size=UDim2.fromOffset(56,56),Position=UDim2.new(0,20,0.5,-28),BackgroundColor3=NAEI.Theme.Card2,Visible=false,Parent=Gui, ZIndex=50}); Corner(Orb,100); Stroke(Orb, NAEI.Theme.Primary, 0, 2); AddGlow(Orb, NAEI.Theme.Primary, 30, 0.4)
    local OrbLogo=New("ImageLabel",{Size=UDim2.fromOffset(40,40),Position=UDim2.fromOffset(8,8),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Orb}); Corner(OrbLogo,100)
    EnableDrag(Orb, Orb)
    task.spawn(function() while Orb.Parent do Tween(OrbLogo, 2, {Rotation=360}, Enum.EasingStyle.Linear) task.wait(2) OrbLogo.Rotation=0 end end)

    local function TopBtn(txt,pos,col) local b=New("TextButton",{Size=UDim2.fromOffset(32,32),Position=UDim2.new(1,pos,0,8),BackgroundColor3=NAEI.Theme.Card,Text=txt,TextColor3=NAEI.Theme.Sub,TextSize=15,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=Header}); Corner(b,10); Stroke(b,NAEI.Theme.Border,0.6,1); return b end
    local CloseBtn=TopBtn("✕",-40,NAEI.Theme.Danger); local MinBtn=TopBtn("—",-78)

    local Sidebar=New("Frame",{Size=UDim2.new(0,155,1,-62),Position=UDim2.fromOffset(10,52),BackgroundColor3=NAEI.Theme.BgSub,BackgroundTransparency=0.25,Parent=Main}); Corner(Sidebar,14); Stroke(Sidebar,NAEI.Theme.Border,0.6,1)
    local Profile=New("Frame",{Size=UDim2.new(1,-12,0,48),Position=UDim2.fromOffset(6,6),BackgroundColor3=NAEI.Theme.Card,Parent=Sidebar}); Corner(Profile,11)
    New("ImageLabel",{Size=UDim2.fromOffset(32,32),Position=UDim2.fromOffset(8,8),BackgroundTransparency=1,Image="rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150",Parent=Profile})
    New("TextLabel",{Size=UDim2.new(1,-52,0,14),Position=UDim2.fromOffset(46,8),BackgroundTransparency=1,Text=LocalPlayer.DisplayName,TextColor3=NAEI.Theme.Text,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Left,TextTruncate=AtEnd,Parent=Profile})

    local TabHolder=New("ScrollingFrame",{Size=UDim2.new(1,-8,1,-68),Position=UDim2.fromOffset(4,62),BackgroundTransparency=1,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=Sidebar}); New("UIListLayout",{Padding=UDim.new(0,6),Parent=TabHolder})
    local Content=New("Frame",{Size=UDim2.new(1,-185,1,-62),Position=UDim2.new(0,175,0,52),BackgroundTransparency=1,ClipsDescendants=true,Parent=Main})
    Main.Size=UDim2.fromOffset(0,0); Main.BackgroundTransparency=1; Tween(Main,0.7,{Size=UDim2.fromOffset(WSize.X,WSize.Y),BackgroundTransparency=0.08},Enum.EasingStyle.Back)

    local minimized=false
    local function SetMinimized(state)
        minimized=state
        if state then
            Tween(Main,0.4,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In)
            task.wait(0.35); Main.Visible=false; Orb.Visible=true; Orb.Size=UDim2.fromOffset(0,0); Tween(Orb,0.5,{Size=UDim2.fromOffset(56,56)},Enum.EasingStyle.Back)
        else
            Tween(Orb,0.3,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.3); Orb.Visible=false; Main.Visible=true; Main.Size=UDim2.fromOffset(0,0); Tween(Main,0.6,{Size=UDim2.fromOffset(WSize.X,WSize.Y),BackgroundTransparency=0.08},Enum.EasingStyle.Back)
        end
    end

    function Window:CreateTab(name, icon)
        local Tab={}; local Btn=New("TextButton",{Size=UDim2.new(1,-8,0,38),BackgroundColor3=NAEI.Theme.Card,BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=TabHolder}); Corner(Btn,11)
        local Icon=New("TextLabel",{Size=UDim2.fromOffset(28,28),Position=UDim2.fromOffset(6,5),BackgroundTransparency=1,Text=icon or "✦",TextColor3=NAEI.Theme.Sub,TextSize=14,Font=Enum.Font.GothamBold,Parent=Btn})
        local Label=New("TextLabel",{Size=UDim2.new(1,-42,1,0),Position=UDim2.fromOffset(36,0),BackgroundTransparency=1,Text=name,TextColor3=NAEI.Theme.Sub,TextSize=12,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=Btn})
        local Ind=New("Frame",{Size=UDim2.fromOffset(4,20),Position=UDim2.fromOffset(-4,9),BackgroundColor3=NAEI.Theme.Primary,BackgroundTransparency=1,Parent=Btn}); Corner(Ind,10)
        local Page=New("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScrollBarThickness=2,ScrollBarImageColor3=NAEI.Theme.Primary,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=Content}); New("UIListLayout",{Padding=UDim.new(0,8),Parent=Page}); New("UIPadding",{PaddingTop=UDim.new(0,4),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,12),Parent=Page})
        function Tab:Select() for _,t in ipairs(Window.Tabs) do Tween(t.Button,0.2,{BackgroundTransparency=1}); t.Label.TextColor3=NAEI.Theme.Sub; t.Icon.TextColor3=NAEI.Theme.Sub; Tween(t.Ind,0.2,{BackgroundTransparency=1}); t.Page.Visible=false end Tween(Btn,0.25,{BackgroundTransparency=0,BackgroundColor3=NAEI.Theme.Card2}); Tween(Ind,0.25,{BackgroundTransparency=0}); Label.TextColor3=NAEI.Theme.Text; Icon.TextColor3=NAEI.Theme.Primary; Page.Visible=true; Tween(Btn,0.1,{Size=UDim2.new(1,-8,0,34)}) task.wait(0.1) Tween(Btn,0.15,{Size=UDim2.new(1,-8,0,38)},Enum.EasingStyle.Back) end
        Tab.Button=Btn; Tab.Label=Label; Tab.Icon=Icon; Tab.Ind=Ind; Tab.Page=Page; Btn.Activated:Connect(function() Tab:Select() end)
        function Tab:AddSection(txt) local f=New("Frame",{Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,Parent=Page}); New("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="— "..string.upper(txt),TextColor3=NAEI.Theme.Primary,TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=f}) end
        function Tab:AddButton(c) c=c or {}; local f=New("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,12); local s=Stroke(f,NAEI.Theme.Border,0.6,1); local b=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=f}); New("TextLabel",{Size=UDim2.new(1,-24,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,Text=c.Name or "Button",TextColor3=NAEI.Theme.Text,TextSize=12,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=b}); local dot=New("Frame",{Size=UDim2.fromOffset(6,6),Position=UDim2.new(1,-16,0.5,-3),BackgroundColor3=NAEI.Theme.Primary,BackgroundTransparency=0.5,Parent=b}); Corner(dot,100); b.MouseEnter:Connect(function() Tween(f,0.2,{BackgroundColor3=NAEI.Theme.Hover,Size=UDim2.new(1,0,0,46)}) Tween(s,0.2,{Color=NAEI.Theme.Primary}) Tween(dot,0.2,{BackgroundTransparency=0,Size=UDim2.fromOffset(8,8)}) end); b.MouseLeave:Connect(function() Tween(f,0.2,{BackgroundColor3=NAEI.Theme.Card,Size=UDim2.new(1,0,0,44)}) Tween(s,0.2,{Color=NAEI.Theme.Border}) Tween(dot,0.2,{BackgroundTransparency=0.5,Size=UDim2.fromOffset(6,6)}) end); b.Activated:Connect(function() Tween(f,0.08,{Size=UDim2.new(1,0,0,40)}) task.wait(0.08) Tween(f,0.12,{Size=UDim2.new(1,0,0,44)},Enum.EasingStyle.Back) if c.Callback then c.Callback() end end); return f end
        function Tab:AddToggle(c) c=c or {}; local state=c.Default==true; local f=New("Frame",{Size=UDim2.new(1,0,0,46),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,12); Stroke(f,NAEI.Theme.Border,0.6,1); New("TextLabel",{Size=UDim2.new(1,-70,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,Text=c.Name or "Toggle",TextColor3=NAEI.Theme.Text,TextSize=12,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=f}); local Track=New("Frame",{Size=UDim2.fromOffset(50,28),Position=UDim2.new(1,-62,0.5,-14),BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off,Parent=f}); Corner(Track,14); if state then New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary,NAEI.Theme.Primary2),Parent=Track}) end; local Thumb=New("Frame",{Size=UDim2.fromOffset(22,22),Position=state and UDim2.new(1,-25,0.5,-11) or UDim2.new(0,3,0.5,-11),BackgroundColor3=Color3.new(1,1,1),Parent=Track}); Corner(Thumb,100); AddGlow(Thumb,NAEI.Theme.Primary,20,0.4); local btn=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Parent=f}); btn.Activated:Connect(function() state=not state; Tween(Track,0.35,{BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off},Enum.EasingStyle.Back); Tween(Thumb,0.4,{Position=state and UDim2.new(1,-25,0.5,-11) or UDim2.new(0,3,0.5,-11)},Enum.EasingStyle.Back); if c.Callback then c.Callback(state) end end); return f end
        table.insert(Window.Tabs,Tab); if #Window.Tabs==1 then Tab:Select() end; return Tab
    end
    function Window:Destroy() Tween(Main,0.35,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.35); Gui:Destroy() end

    CloseBtn.Activated:Connect(function() Window:Destroy() end)
    MinBtn.Activated:Connect(function() SetMinimized(true) end)
    Orb.Activated:Connect(function() SetMinimized(false) end)

    return Window
end

return NAEI