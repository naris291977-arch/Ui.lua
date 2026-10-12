
--[[
    NAEI HUB v12.0 - FINAL DIVINE
    Classic Loader Upgraded + UI 100x More Beautiful
    Loader: Dual Bar + Ring + Typing + Burst
    UI: Liquid Glass + Blob + Cursor Glow + Jelly + Orb Fix
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local NAEI = {}
NAEI.Version = "12.0-FINAL"
NAEI.Theme = {
    Bg = Color3.fromRGB(8,8,12), BgSub = Color3.fromRGB(14,14,20),
    Card = Color3.fromRGB(20,20,28), Card2 = Color3.fromRGB(28,28,42),
    Hover = Color3.fromRGB(36,36,56), Primary = Color3.fromRGB(150,85,255),
    Primary2 = Color3.fromRGB(85,145,255), Primary3 = Color3.fromRGB(255,85,165),
    Neon = Color3.fromRGB(255,240,0), Text = Color3.new(1,1,1),
    Sub = Color3.fromRGB(170,170,195), Muted = Color3.fromRGB(90,90,115),
    Border = Color3.fromRGB(55,55,80), Off = Color3.fromRGB(42,42,62),
    Danger = Color3.fromRGB(255,65,90),
}
NAEI.LogoUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg"
NAEI.LogoFile = "naei_v12.jpg"

local function New(c,p) local o=Instance.new(c) for k,v in pairs(p or {}) do pcall(function() o[k]=v end) end return o end
local function Corner(o,r) New("UICorner",{CornerRadius=UDim.new(0,r or 14),Parent=o}) end
local function Stroke(o,c,t,tk) return New("UIStroke",{Color=c or NAEI.Theme.Border,Transparency=t or 0.5,Thickness=tk or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=o}) end
local function Tween(o,t,pr,s,d) local tw=TweenService:Create(o,TweenInfo.new(t,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),pr) tw:Play() return tw end
local function GetParent() local ok,g=pcall(gethui) if ok and g then return g end return LocalPlayer:WaitForChild("PlayerGui") end
local function GetAsset(u,f) local fn=getcustomasset or getsynasset if not (fn and writefile and isfile) then return u end local ok,a=pcall(function() if not isfile(f) then writefile(f,game:HttpGet(u)) end return fn(f) end) return ok and a or u end
local function AddGlow(o,c,s,tr) return New("ImageLabel",{Size=UDim2.new(1,s or 60,1,s or 60),Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Image="rbxassetid://5028857084",ImageColor3=c or NAEI.Theme.Primary,ImageTransparency=tr or 0.5,ZIndex=0,Parent=o}) end
local function EnableDrag(g,h) h=h or g; local d,s,sp,io=false; h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true s=i.Position sp=g.Position end end); h.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then io=i end end); UserInputService.InputChanged:Connect(function(i) if i==io and d then local dd=i.Position-s g.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dd.X,sp.Y.Scale,sp.Y.Offset+dd.Y) end end); UserInputService.InputEnded:Connect(function() d=false end) end

local function CreateBlob(parent, color, size, pos)
    local b=New("Frame",{Size=UDim2.fromOffset(size,size),Position=pos,BackgroundColor3=color,BackgroundTransparency=0.6,Parent=parent}); Corner(b,size); AddGlow(b,color,80,0.6)
    task.spawn(function() while b.Parent do Tween(b, math.random(5,8), {Position=pos+UDim2.fromOffset(math.random(-50,50),math.random(-50,50)), Size=UDim2.fromOffset(size+math.random(-20,20), size+math.random(-20,20))}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut) task.wait(math.random(5,8)) end end)
end

-- ================= LOADER v12 UPGRADED =================
function NAEI:ShowLoader(cfg)
    cfg=cfg or {}; local onFinish=cfg.OnFinish or function() end
    local Gui=New("ScreenGui",{Name="NAEI_LOADER_V12",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})
    local Blur=New("BlurEffect",{Size=0,Parent=game:GetService("Lighting")}); Tween(Blur,0.8,{Size=24})
    local BG=New("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(4,4,8),Parent=Gui})
    CreateBlob(BG, NAEI.Theme.Primary, 320, UDim2.new(0,-100,0,-100))
    CreateBlob(BG, NAEI.Theme.Primary2, 300, UDim2.new(1,-180,1,-180))
    CreateBlob(BG, NAEI.Theme.Primary3, 260, UDim2.new(0.5,-100,0.5,-80))

    local Card=New("Frame",{Size=UDim2.fromOffset(300,360),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),BackgroundColor3=NAEI.Theme.Bg,BackgroundTransparency=0.08,Parent=Gui})
    Corner(Card,22); local st=Stroke(Card, NAEI.Theme.Primary, 0.15, 2); local grad=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2, NAEI.Theme.Primary3),Rotation=0,Parent=st}); AddGlow(Card, NAEI.Theme.Primary, 120, 0.4)
    Card.Size=UDim2.fromOffset(0,0); Tween(Card,0.8,{Size=UDim2.fromOffset(300,360)},Enum.EasingStyle.Back)
    task.spawn(function() while Card.Parent do grad.Rotation=(grad.Rotation+1)%360 task.wait(0.02) end end)

    -- โลโก้ + วงแหวนคู่
    local LogoWrap=New("Frame",{Size=UDim2.fromOffset(90,90),Position=UDim2.new(0.5,-45,0,28),BackgroundTransparency=1,Parent=Card})
    local Ring1=New("Frame",{Size=UDim2.fromOffset(90,90),BackgroundTransparency=1,Parent=LogoWrap}); Corner(Ring1,100); Stroke(Ring1, NAEI.Theme.Off, 0, 3)
    local Ring2=New("Frame",{Size=UDim2.fromOffset(90,90),BackgroundTransparency=1,Parent=LogoWrap}); Corner(Ring2,100); local ringStroke=Stroke(Ring2, NAEI.Theme.Primary, 0, 3); New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2),Parent=ringStroke})
    local LogoBox=New("Frame",{Size=UDim2.fromOffset(68,68),Position=UDim2.fromOffset(11,11),BackgroundColor3=NAEI.Theme.Card,Parent=LogoWrap}); Corner(LogoBox,100)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(58,58),Position=UDim2.fromOffset(5,5),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=LogoBox}); Corner(Logo,100)
    task.spawn(function() while Ring2.Parent do Ring2.Rotation+=2 task.wait(0.02) end end)

    New("TextLabel",{Size=UDim2.new(1,0,0,20),Position=UDim2.fromOffset(0,132),BackgroundTransparency=1,Text=cfg.Title or "NAEI HUB",TextColor3=NAEI.Theme.Text,TextSize=18,Font=Enum.Font.GothamBold,Parent=Card})
    New("TextLabel",{Size=UDim2.new(1,0,0,12),Position=UDim2.fromOffset(0,152),BackgroundTransparency=1,Text=cfg.SubTitle or "v12.0 • FINAL DIVINE",TextColor3=NAEI.Theme.Sub,TextSize=9,Font=Enum.Font.Gotham,Parent=Card})

    local BarBG=New("Frame",{Size=UDim2.new(1,-40,0,6),Position=UDim2.fromOffset(20,185),BackgroundColor3=NAEI.Theme.Off,ClipsDescendants=true,Parent=Card}); Corner(BarBG,100)
    local Bar=New("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=NAEI.Theme.Primary,Parent=BarBG}); Corner(Bar,100); local barGrad=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2, NAEI.Theme.Primary3),Rotation=0,Parent=Bar})
    local Shimmer=New("Frame",{Size=UDim2.new(0,70,1,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.65,Parent=Bar}); Corner(Shimmer,100)
    task.spawn(function() while Bar.Parent do Shimmer.Position=UDim2.new(0,-70,0,0) Tween(Shimmer,1.1,{Position=UDim2.new(1,0,0,0)},Enum.EasingStyle.Linear) barGrad.Rotation=(barGrad.Rotation+6)%360 task.wait(1.1) end end)

    local Status=New("TextLabel",{Size=UDim2.new(1,-50,0,14),Position=UDim2.fromOffset(20,200),BackgroundTransparency=1,Text="> Loading...",TextColor3=NAEI.Theme.Muted,TextSize=9,Font=Enum.Font.Code,TextXAlignment=Left,Parent=Card})
    local Percent=New("TextLabel",{Size=UDim2.new(0,50,0,14),Position=UDim2.new(1,-45,0,200),BackgroundTransparency=1,Text="0%",TextColor3=NAEI.Theme.Primary,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Right,Parent=Card})
    local Dots=New("Frame",{Size=UDim2.new(1,0,0,10),Position=UDim2.fromOffset(0,225),BackgroundTransparency=1,Parent=Card}); New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal, HorizontalAlignment=Enum.HorizontalAlignment.Center, Padding=UDim.new(0,6),Parent=Dots})
    local dotObjs={}; for i=1,3 do local d=New("Frame",{Size=UDim2.fromOffset(6,6),BackgroundColor3=NAEI.Theme.Muted,BackgroundTransparency=0.4,Parent=Dots}); Corner(d,100); table.insert(dotObjs,d) end

    task.spawn(function()
        local steps={
            {Text="> Initializing Glass Engine...", Target=28},
            {Text="> Injecting Blob Morph...", Target=60},
            {Text="> Compiling Divine UI...", Target=85},
            {Text="> Welcome "..LocalPlayer.DisplayName.." ✨", Target=100}
        }
        local cur=0
        for _,step in ipairs(steps) do
            for j=1,#step.Text do Status.Text=string.sub(step.Text,1,j) task.wait(0.015) end
            for i=cur,step.Target do
                cur=i; Percent.Text=i.."%"; Bar.Size=UDim2.new(i/100,0,1,0); Ring2.Rotation=i*3.6
                for idx,dot in ipairs(dotObjs) do Tween(dot,0.2,{BackgroundTransparency= math.sin(tick()*4+idx)*0.3+0.4, BackgroundColor3= i>80 and NAEI.Theme.Primary or NAEI.Theme.Muted}) end
                task.wait(0.011)
            end
            task.wait(0.12)
        end
        -- Burst ตอนจบ
        for i=1,12 do local p=New("Frame",{Size=UDim2.fromOffset(4,4),Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=Color3.fromHSV(math.random(),1,1),Parent=Card}); Corner(p,100); Tween(p,0.5,{Position=UDim2.new(0.5,math.random(-130,130)/300,0.5,math.random(-130,130)/300), BackgroundTransparency=1}, Enum.EasingStyle.Expo) end
        task.wait(0.4); Tween(Blur,0.4,{Size=0}); Tween(Card,0.35,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.35); Gui:Destroy(); Blur:Destroy(); onFinish()
    end)
end

-- ================= UI หลัก v12 สวยขึ้นอีก 100x =================
function NAEI:CreateWindow(cfg)
    cfg=cfg or {}; local WSize=cfg.Size or Vector2.new(620,420); local Window={Tabs={}}; local Gui=New("ScreenGui",{Name="NAEI_HUB_V12",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})
    local CursorGlow=New("Frame",{Size=UDim2.fromOffset(200,200),BackgroundColor3=NAEI.Theme.Primary,BackgroundTransparency=0.9,Parent=Gui,ZIndex=100}); Corner(CursorGlow,100); AddGlow(CursorGlow, NAEI.Theme.Primary, 70, 0.3)
    UserInputService.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then Tween(CursorGlow,0.15,{Position=UDim2.fromOffset(i.Position.X-100,i.Position.Y-100)},Enum.EasingStyle.Quad) end end)

    local Main=New("Frame",{Size=UDim2.fromOffset(WSize.X,WSize.Y),Position=UDim2.new(0.5,-WSize.X/2,0.5,-WSize.Y/2),BackgroundColor3=NAEI.Theme.Bg,BackgroundTransparency=0.05,Parent=Gui})
    Corner(Main,24); local ms=Stroke(Main, NAEI.Theme.Primary, 0.12, 2.5); local mg=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2, NAEI.Theme.Primary3),Rotation=20,Parent=ms}); AddGlow(Main, NAEI.Theme.Primary, 180, 0.4)
    CreateBlob(Main, NAEI.Theme.Primary, 240, UDim2.new(0,-80,0,-80)); CreateBlob(Main, NAEI.Theme.Primary2, 220, UDim2.new(1,-150,1,-150)); CreateBlob(Main, NAEI.Theme.Primary3, 200, UDim2.new(0.5,-80,0.5,-60))
    task.spawn(function() while Main.Parent do mg.Rotation=(mg.Rotation+0.35)%360 task.wait(0.05) end end)

    local Header=New("Frame",{Size=UDim2.new(1,0,0,56),BackgroundTransparency=1,Parent=Main,ZIndex=10}); EnableDrag(Main,Header)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(34,34),Position=UDim2.fromOffset(16,11),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Header}); Corner(Logo,11)
    New("TextLabel",{Size=UDim2.new(1,-170,0,16),Position=UDim2.fromOffset(58,14),BackgroundTransparency=1,Text=cfg.Title or "Naei Hub",TextColor3=NAEI.Theme.Text,TextSize=16,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Header})
    New("TextLabel",{Size=UDim2.new(1,-170,0,12),Position=UDim2.fromOffset(58,32),BackgroundTransparency=1,Text=cfg.Subtitle or "v12.0 • FINAL DIVINE • 100x",TextColor3=NAEI.Theme.Sub,TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=Header})

    local Orb=New("ImageButton",{Size=UDim2.fromOffset(62,62),Position=UDim2.new(0,24,0.5,-31),BackgroundColor3=NAEI.Theme.Card2,Visible=false,Parent=Gui,ZIndex=50}); Corner(Orb,100); Stroke(Orb, NAEI.Theme.Primary, 0, 2.5); AddGlow(Orb, NAEI.Theme.Primary, 40, 0.35)
    local OrbLogo=New("ImageLabel",{Size=UDim2.fromOffset(46,46),Position=UDim2.fromOffset(8,8),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Orb}); Corner(OrbLogo,100); EnableDrag(Orb,Orb)

    local function TopBtn(txt,pos,col) local b=New("TextButton",{Size=UDim2.fromOffset(36,36),Position=UDim2.new(1,pos,0,10),BackgroundColor3=NAEI.Theme.Card,Text=txt,TextColor3=NAEI.Theme.Sub,TextSize=16,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=Header}); Corner(b,12); Stroke(b,NAEI.Theme.Border,0.6,1); b.MouseEnter:Connect(function() Tween(b,0.2,{BackgroundColor3=col or NAEI.Theme.Hover, TextColor3=NAEI.Theme.Text, Size=UDim2.fromOffset(38,38)}) end); b.MouseLeave:Connect(function() Tween(b,0.2,{BackgroundColor3=NAEI.Theme.Card, TextColor3=NAEI.Theme.Sub, Size=UDim2.fromOffset(36,36)}) end); return b end
    local CloseBtn=TopBtn("✕",-44,NAEI.Theme.Danger); local MinBtn=TopBtn("—",-86)

    local Sidebar=New("Frame",{Size=UDim2.new(0,175,1,-70),Position=UDim2.fromOffset(12,58),BackgroundColor3=NAEI.Theme.BgSub,BackgroundTransparency=0.18,Parent=Main}); Corner(Sidebar,18); Stroke(Sidebar,NAEI.Theme.Border,0.4,1)
    local Profile=New("Frame",{Size=UDim2.new(1,-14,0,56),Position=UDim2.fromOffset(7,7),BackgroundColor3=NAEI.Theme.Card,Parent=Sidebar}); Corner(Profile,14); Stroke(Profile,NAEI.Theme.Primary,0.4,1)
    New("ImageLabel",{Size=UDim2.fromOffset(38,38),Position=UDim2.fromOffset(9,9),BackgroundTransparency=1,Image="rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150",Parent=Profile})
    New("TextLabel",{Size=UDim2.new(1,-60,0,14),Position=UDim2.fromOffset(54,12),BackgroundTransparency=1,Text=LocalPlayer.DisplayName,TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Left,TextTruncate=AtEnd,Parent=Profile})
    New("TextLabel",{Size=UDim2.new(1,-60,0,10),Position=UDim2.fromOffset(54,28),BackgroundTransparency=1,Text="@"..LocalPlayer.Name,TextColor3=NAEI.Theme.Muted,TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Left,Parent=Profile})

    local TabHolder=New("ScrollingFrame",{Size=UDim2.new(1,-10,1,-78),Position=UDim2.fromOffset(5,72),BackgroundTransparency=1,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=Sidebar}); New("UIListLayout",{Padding=UDim.new(0,8),Parent=TabHolder})
    local Content=New("Frame",{Size=UDim2.new(1,-207,1,-70),Position=UDim2.new(0,197,0,58),BackgroundTransparency=1,ClipsDescendants=true,Parent=Main})

    Main.Size=UDim2.fromOffset(0,0); Main.BackgroundTransparency=1; Tween(Main,0.9,{Size=UDim2.fromOffset(WSize.X,WSize.Y),BackgroundTransparency=0.05},Enum.EasingStyle.Back)
    local minimized=false; local function SetMin(s) minimized=s; if s then Tween(Main,0.4,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In) task.wait(0.35) Main.Visible=false Orb.Visible=true Orb.Size=UDim2.fromOffset(0,0) Tween(Orb,0.5,{Size=UDim2.fromOffset(62,62)},Enum.EasingStyle.Back) else Tween(Orb,0.3,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In) task.wait(0.3) Orb.Visible=false Main.Visible=true Main.Size=UDim2.fromOffset(0,0) Tween(Main,0.6,{Size=UDim2.fromOffset(WSize.X,WSize.Y),BackgroundTransparency=0.05},Enum.EasingStyle.Back) end end

    function Window:CreateTab(name, icon)
        local Tab={}; local Btn=New("TextButton",{Size=UDim2.new(1,-10,0,44),BackgroundColor3=NAEI.Theme.Card,BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=TabHolder}); Corner(Btn,13)
        local Icon=New("TextLabel",{Size=UDim2.fromOffset(32,32),Position=UDim2.fromOffset(6,6),BackgroundTransparency=1,Text=icon or "✦",TextColor3=NAEI.Theme.Sub,TextSize=16,Font=Enum.Font.GothamBold,Parent=Btn})
        local Label=New("TextLabel",{Size=UDim2.new(1,-48,1,0),Position=UDim2.fromOffset(42,0),BackgroundTransparency=1,Text=name,TextColor3=NAEI.Theme.Sub,TextSize=13,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=Btn})
        local Ind=New("Frame",{Size=UDim2.fromOffset(4,24),Position=UDim2.fromOffset(-6,10),BackgroundColor3=NAEI.Theme.Primary,BackgroundTransparency=1,Parent=Btn}); Corner(Ind,10)
        local Page=New("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScrollBarThickness=2,ScrollBarImageColor3=NAEI.Theme.Primary,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=Content}); New("UIListLayout",{Padding=UDim.new(0,10),Parent=Page}); New("UIPadding",{PaddingTop=UDim.new(0,6),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,14),Parent=Page})
        function Tab:Select() for _,t in ipairs(Window.Tabs) do Tween(t.Button,0.25,{BackgroundTransparency=1}); t.Label.TextColor3=NAEI.Theme.Sub; t.Icon.TextColor3=NAEI.Theme.Sub; Tween(t.Ind,0.25,{BackgroundTransparency=1}); t.Page.Visible=false end Tween(Btn,0.35,{BackgroundTransparency=0,BackgroundColor3=NAEI.Theme.Card2}); Tween(Ind,0.35,{BackgroundTransparency=0}); Label.TextColor3=NAEI.Theme.Text; Icon.TextColor3=NAEI.Theme.Primary; Page.Visible=true; Tween(Btn,0.1,{Size=UDim2.new(1,-10,0,40)}) task.wait(0.1) Tween(Btn,0.2,{Size=UDim2.new(1,-10,0,44)},Enum.EasingStyle.Back) end
        Tab.Button=Btn; Tab.Label=Label; Tab.Icon=Icon; Tab.Ind=Ind; Tab.Page=Page; Btn.Activated:Connect(function() Tab:Select() end)
        function Tab:AddSection(txt) local f=New("Frame",{Size=UDim2.new(1,0,0,28),BackgroundTransparency=1,Parent=Page}); New("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="— "..string.upper(txt),TextColor3=NAEI.Theme.Primary,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=f}) end
        function Tab:AddButton(c) c=c or {}; local f=New("Frame",{Size=UDim2.new(1,0,0,52),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,15); local s=Stroke(f,NAEI.Theme.Border,0.5,1); local b=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=f}); New("TextLabel",{Size=UDim2.new(1,-32,1,0),Position=UDim2.fromOffset(18,0),BackgroundTransparency=1,Text=c.Name or "Button",TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=b}); local ar=New("TextLabel",{Size=UDim2.fromOffset(20,20),Position=UDim2.new(1,-32,0.5,-10),BackgroundTransparency=1,Text="›",TextColor3=NAEI.Theme.Muted,TextSize=20,Parent=b}); b.MouseEnter:Connect(function() Tween(f,0.25,{BackgroundColor3=NAEI.Theme.Hover,Size=UDim2.new(1,0,0,54)}) Tween(s,0.25,{Color=NAEI.Theme.Primary,Thickness=1.5}) Tween(ar,0.2,{TextColor3=NAEI.Theme.Text,Position=UDim2.new(1,-28,0.5,-10)}) end); b.MouseLeave:Connect(function() Tween(f,0.25,{BackgroundColor3=NAEI.Theme.Card,Size=UDim2.new(1,0,0,52)}) Tween(s,0.25,{Color=NAEI.Theme.Border,Thickness=1}) Tween(ar,0.2,{TextColor3=NAEI.Theme.Muted,Position=UDim2.new(1,-32,0.5,-10)}) end); b.Activated:Connect(function() Tween(f,0.08,{Size=UDim2.new(1,0,0,48)}) task.wait(0.08) Tween(f,0.15,{Size=UDim2.new(1,0,0,52)},Enum.EasingStyle.Back) if c.Callback then c.Callback() end end); return f end
        function Tab:AddToggle(c) c=c or {}; local state=c.Default==true; local f=New("Frame",{Size=UDim2.new(1,0,0,54),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,15); Stroke(f,NAEI.Theme.Border,0.5,1); New("TextLabel",{Size=UDim2.new(1,-80,1,0),Position=UDim2.fromOffset(18,0),BackgroundTransparency=1,Text=c.Name or "Toggle",TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=f}); local Track=New("Frame",{Size=UDim2.fromOffset(56,32),Position=UDim2.new(1,-70,0.5,-16),BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off,Parent=f}); Corner(Track,16); local g=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary,NAEI.Theme.Primary2),Parent=Track}); g.Enabled=state; local Thumb=New("Frame",{Size=UDim2.fromOffset(26,26),Position=state and UDim2.new(1,-29,0.5,-13) or UDim2.new(0,3,0.5,-13),BackgroundColor3=Color3.new(1,1,1),Parent=Track}); Corner(Thumb,100); AddGlow(Thumb,NAEI.Theme.Primary,22,0.4); local btn=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Parent=f}); btn.Activated:Connect(function() state=not state; g.Enabled=state; Tween(Track,0.4,{BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off},Enum.EasingStyle.Back); Tween(Thumb,0.45,{Position=state and UDim2.new(1,-29,0.5,-13) or UDim2.new(0,3,0.5,-13)},Enum.EasingStyle.Back); if c.Callback then c.Callback(state) end end); return f end
        table.insert(Window.Tabs,Tab); if #Window.Tabs==1 then Tab:Select() end; return Tab
    end
    function Window:Destroy() Tween(Main,0.4,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.4); Gui:Destroy() end
    CloseBtn.Activated:Connect(function() Window:Destroy() end); MinBtn.Activated:Connect(function() SetMin(true) end); Orb.Activated:Connect(function() SetMin(false) end)
    return Window
end
return NAEI