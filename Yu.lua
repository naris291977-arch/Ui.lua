--[[
    NAEI HUB v11.0 - NEON BREAK
    White Flash -> Neon Yellow -> Shake -> Crack -> UI Pop
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local NAEI = {}
NAEI.Version = "11.0-BREAK"
NAEI.Theme = {
    Bg = Color3.fromRGB(6,6,10), BgSub = Color3.fromRGB(12,12,18),
    Card = Color3.fromRGB(18,18,26), Card2 = Color3.fromRGB(26,26,38),
    Hover = Color3.fromRGB(34,34,52), Primary = Color3.fromRGB(140,90,255),
    Primary2 = Color3.fromRGB(90,160,255), Primary3 = Color3.fromRGB(255,90,160),
    NeonYellow = Color3.fromRGB(255, 255, 0),
    Text = Color3.fromRGB(255,255,255), Sub = Color3.fromRGB(170,170,195),
    Muted = Color3.fromRGB(90,90,115), Border = Color3.fromRGB(55,55,80),
    Off = Color3.fromRGB(40,40,60), Danger = Color3.fromRGB(255,60,90),
}
NAEI.LogoUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg"
NAEI.LogoFile = "naei_v11.jpg"

local function New(c,p) local o=Instance.new(c) for k,v in pairs(p or {}) do pcall(function() o[k]=v end) end return o end
local function Corner(o,r) New("UICorner",{CornerRadius=UDim.new(0,r or 14),Parent=o}) end
local function Stroke(o,c,t,tk) return New("UIStroke",{Color=c or NAEI.Theme.Border,Transparency=t or 0.5,Thickness=tk or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=o}) end
local function Tween(o,t,pr,s,d) local tw=TweenService:Create(o,TweenInfo.new(t,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),pr) tw:Play() return tw end
local function GetParent() local ok,g=pcall(gethui) if ok and g then return g end return LocalPlayer:WaitForChild("PlayerGui") end
local function GetAsset(u,f) local fn=getcustomasset or getsynasset if not (fn and writefile and isfile) then return u end local ok,a=pcall(function() if not isfile(f) then writefile(f,game:HttpGet(u)) end return fn(f) end) return ok and a or u end
local function AddGlow(o,c,s,tr) return New("ImageLabel",{Size=UDim2.new(1,s or 60,1,s or 60),Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Image="rbxassetid://5028857084",ImageColor3=c or NAEI.Theme.Primary,ImageTransparency=tr or 0.5,ZIndex=0,Parent=o}) end
local function EnableDrag(g,h) h=h or g; local d,s,sp,io=false; h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true s=i.Position sp=g.Position end end); h.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then io=i end end); UserInputService.InputChanged:Connect(function(i) if i==io and d then local dd=i.Position-s g.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dd.X,sp.Y.Scale,sp.Y.Offset+dd.Y) end end); UserInputService.InputEnded:Connect(function() d=false end) end

-- SHAKE EFFECT
local function ShakeUI(gui, intensity)
    local orig = gui.Position
    for i=1,12 do
        local offset = UDim2.fromOffset(math.random(-intensity,intensity), math.random(-intensity,intensity))
        Tween(gui, 0.04, {Position = orig + offset}, Enum.EasingStyle.Linear)
        task.wait(0.04)
    end
    Tween(gui, 0.2, {Position = orig}, Enum.EasingStyle.Back)
end

-- CRACK EFFECT
local function CreateCrack(parent)
    local crackHolder = New("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Parent=parent,ZIndex=20})
    for i=1,6 do
        local line = New("Frame",{
            Size=UDim2.new(0,2,0,0),
            Position=UDim2.new(0.5,0,0.5,0),
            Rotation=math.random(0,360),
            BackgroundColor3=NAEI.Theme.NeonYellow,
            BorderSizePixel=0,
            Parent=crackHolder
        })
        AddGlow(line, NAEI.Theme.NeonYellow, 20, 0.3)
        Tween(line, 0.15, {Size=UDim2.new(0,2,0, math.random(200,600))}, Enum.EasingStyle.Expo)
        task.wait(0.03)
    end
    task.wait(0.3)
    Tween(crackHolder, 0.3, {BackgroundTransparency=1})
    task.delay(0.3, function() crackHolder:Destroy() end)
end

--// LOADER WITH NEON BREAK TRANSITION
function NAEI:ShowLoader(cfg)
    cfg=cfg or {}; local onFinish=cfg.OnFinish or function() end
    local Gui=New("ScreenGui",{Name="NAEI_LOADER_V11",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})
    local Blur=New("BlurEffect",{Size=0,Parent=game:GetService("Lighting")}); Tween(Blur,1,{Size=32})
    local BG=New("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(2,2,5),Parent=Gui})

    local Card=New("Frame",{Size=UDim2.fromOffset(340,420),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),BackgroundColor3=NAEI.Theme.Bg,BackgroundTransparency=0.1,Parent=Gui})
    Corner(Card,28); local st=Stroke(Card, NAEI.Theme.Primary, 0.1, 2.5); local grad=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2, NAEI.Theme.Primary3),Rotation=0,Parent=st})
    AddGlow(Card, NAEI.Theme.Primary, 140, 0.35); Card.Size=UDim2.fromOffset(0,0); Tween(Card,0.9,{Size=UDim2.fromOffset(340,420)},Enum.EasingStyle.Back)
    task.spawn(function() while Card.Parent do grad.Rotation=(grad.Rotation+0.8)%360 task.wait(0.02) end end)

    local LogoWrap=New("Frame",{Size=UDim2.fromOffset(110,110),Position=UDim2.new(0.5,-55,0,35),BackgroundTransparency=1,Parent=Card})
    local LogoBox=New("Frame",{Size=UDim2.fromOffset(84,84),Position=UDim2.fromOffset(13,13),BackgroundColor3=NAEI.Theme.Card,Parent=LogoWrap}); Corner(LogoBox,100)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(72,72),Position=UDim2.fromOffset(6,6),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=LogoBox}); Corner(Logo,100)
    New("TextLabel",{Size=UDim2.new(1,0,0,26),Position=UDim2.fromOffset(0,165),BackgroundTransparency=1,Text=cfg.Title or "NAEI HUB",TextColor3=NAEI.Theme.Text,TextSize=24,Font=Enum.Font.GothamBold,Parent=Card})
    local BarBG=New("Frame",{Size=UDim2.new(1,-50,0,10),Position=UDim2.fromOffset(25,220),BackgroundColor3=NAEI.Theme.Off,ClipsDescendants=true,Parent=Card}); Corner(BarBG,100)
    local Bar=New("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=NAEI.Theme.Primary,Parent=BarBG}); Corner(Bar,100); New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2),Parent=Bar})
    local Stat=New("TextLabel",{Size=UDim2.new(1,-90,0,16),Position=UDim2.fromOffset(25,245),BackgroundTransparency=1,Text="> Loading...",TextColor3=NAEI.Theme.Muted,TextSize=11,Font=Enum.Font.Code,TextXAlignment=Left,Parent=Card})
    local Perc=New("TextLabel",{Size=UDim2.new(0,60,0,16),Position=UDim2.new(1,-55,0,245),BackgroundTransparency=1,Text="0%",TextColor3=NAEI.Theme.Primary,TextSize=14,Font=Enum.Font.GothamBold,TextXAlignment=Right,Parent=Card})

    task.spawn(function()
        local steps={{Text="> Compiling Neon Engine...", Target=35},{Text="> Charging Yellow Neon...", Target=70},{Text="> Ready to BREAK! "..LocalPlayer.DisplayName, Target=100}}
        local cur=0
        for _,step in ipairs(steps) do
            Stat.Text=step.Text
            for i=cur,step.Target do cur=i; Perc.Text=i.."%"; Bar.Size=UDim2.new(i/100,0,1,0); task.wait(0.012) end
            task.wait(0.15)
        end

        -- ===== NEON BREAK SEQUENCE =====
        task.wait(0.2)
        -- 1. แฟลชขาว
        local FlashWhite = New("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0,Parent=Gui,ZIndex=100})
        Tween(FlashWhite, 0.15, {BackgroundTransparency=1}, Enum.EasingStyle.Quad)

        -- 2. เปลี่ยนเป็นเหลืองนีออน
        task.wait(0.1)
        local FlashYellow = New("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=NAEI.Theme.NeonYellow,BackgroundTransparency=0.2,Parent=Gui,ZIndex=99})
        AddGlow(FlashYellow, NAEI.Theme.NeonYellow, 100, 0.2)
        Tween(FlashYellow, 0.1, {BackgroundTransparency=0}, Enum.EasingStyle.Linear)
        task.wait(0.1)

        -- 3. จอสั้น + 4. แตก
        ShakeUI(Card, 15)
        ShakeUI(BG, 20)
        CreateCrack(Gui)

        -- เปลี่ยนธีมการ์ดเป็นเหลืองนีออนแปปนึง
        Tween(st, 0.1, {Color=NAEI.Theme.NeonYellow})
        Tween(Bar, 0.1, {BackgroundColor3=NAEI.Theme.NeonYellow})

        task.wait(0.4)
        Tween(FlashYellow, 0.3, {BackgroundTransparency=1}, Enum.EasingStyle.Quad)
        Tween(FlashWhite, 0.3, {BackgroundTransparency=1})
        Tween(Card, 0.3, {Size=UDim2.fromOffset(0,0), Rotation=15}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(Blur,0.4,{Size=0})
        task.wait(0.35)
        Gui:Destroy(); Blur:Destroy(); onFinish()
    end)
end

function NAEI:CreateWindow(cfg)
    cfg=cfg or {}; local WSize=cfg.Size or Vector2.new(600,400); local Window={Tabs={}}; local Gui=New("ScreenGui",{Name="NAEI_HUB_V11",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})
    local Main=New("Frame",{Size=UDim2.fromOffset(WSize.X,WSize.Y),Position=UDim2.new(0.5,-WSize.X/2,0.5,-WSize.Y/2),BackgroundColor3=NAEI.Theme.Bg,BackgroundTransparency=0.06,Parent=Gui})
    Corner(Main,22); local ms=Stroke(Main, NAEI.Theme.NeonYellow, 0.15, 2.5); local mg=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.NeonYellow, NAEI.Theme.Primary),Rotation=30,Parent=ms}); AddGlow(Main, NAEI.Theme.NeonYellow, 160, 0.35)
    -- เอฟเฟคแตกค้างนิดๆที่ขอบ
    local crackDeco=New("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,0,0),BackgroundColor3=NAEI.Theme.NeonYellow,BackgroundTransparency=0.5,Parent=Main})
    local Header=New("Frame",{Size=UDim2.new(1,0,0,52),BackgroundTransparency=1,Parent=Main,ZIndex=10}); EnableDrag(Main,Header)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(32,32),Position=UDim2.fromOffset(16,10),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Header}); Corner(Logo,10)
    New("TextLabel",{Size=UDim2.new(1,-160,0,16),Position=UDim2.fromOffset(56,12),BackgroundTransparency=1,Text=cfg.Title or "Naei Hub",TextColor3=NAEI.Theme.Text,TextSize=15,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Header})
    New("TextLabel",{Size=UDim2.new(1,-160,0,12),Position=UDim2.fromOffset(56,30),BackgroundTransparency=1,Text=cfg.Subtitle or "v11.0 • NEON BREAK",TextColor3=NAEI.Theme.NeonYellow,TextSize=9,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Header})
    local Orb=New("ImageButton",{Size=UDim2.fromOffset(60,60),Position=UDim2.new(0,20,0.5,-30),BackgroundColor3=NAEI.Theme.Card2,Visible=false,Parent=Gui,ZIndex=50}); Corner(Orb,100); Stroke(Orb, NAEI.Theme.NeonYellow, 0, 2.5); AddGlow(Orb, NAEI.Theme.NeonYellow, 35, 0.4)
    local OrbLogo=New("ImageLabel",{Size=UDim2.fromOffset(44,44),Position=UDim2.fromOffset(8,8),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Orb}); Corner(OrbLogo,100); EnableDrag(Orb,Orb)
    local function TopBtn(txt,pos) local b=New("TextButton",{Size=UDim2.fromOffset(34,34),Position=UDim2.new(1,pos,0,9),BackgroundColor3=NAEI.Theme.Card,Text=txt,TextColor3=NAEI.Theme.Sub,TextSize=16,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=Header}); Corner(b,11); return b end
    local CloseBtn=TopBtn("✕",-42); local MinBtn=TopBtn("—",-82)
    local Sidebar=New("Frame",{Size=UDim2.new(0,165,1,-66),Position=UDim2.fromOffset(12,56),BackgroundColor3=NAEI.Theme.BgSub,BackgroundTransparency=0.2,Parent=Main}); Corner(Sidebar,16)
    local TabHolder=New("ScrollingFrame",{Size=UDim2.new(1,-10,1,-14),Position=UDim2.fromOffset(5,7),BackgroundTransparency=1,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=Sidebar}); New("UIListLayout",{Padding=UDim.new(0,7),Parent=TabHolder})
    local Content=New("Frame",{Size=UDim2.new(1,-197,1,-66),Position=UDim2.new(0,187,0,56),BackgroundTransparency=1,ClipsDescendants=true,Parent=Main})
    -- POP แบบแตกออกมา
    Main.Size=UDim2.fromOffset(0,0); Main.Rotation=-15; Tween(Main,0.8,{Size=UDim2.fromOffset(WSize.X,WSize.Y),BackgroundTransparency=0.06,Rotation=0},Enum.EasingStyle.Back)
    ShakeUI(Main, 8)
    local minimized=false; local function SetMin(s) minimized=s; if s then Tween(Main,0.4,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In) task.wait(0.35) Main.Visible=false Orb.Visible=true Orb.Size=UDim2.fromOffset(0,0) Tween(Orb,0.5,{Size=UDim2.fromOffset(60,60)},Enum.EasingStyle.Back) else Tween(Orb,0.3,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In) task.wait(0.3) Orb.Visible=false Main.Visible=true Main.Size=UDim2.fromOffset(0,0) Tween(Main,0.6,{Size=UDim2.fromOffset(WSize.X,WSize.Y),BackgroundTransparency=0.06},Enum.EasingStyle.Back) end end
    function Window:CreateTab(name, icon) local Tab={}; local Btn=New("TextButton",{Size=UDim2.new(1,-10,0,42),BackgroundColor3=NAEI.Theme.Card,BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=TabHolder}); Corner(Btn,12); local Icon=New("TextLabel",{Size=UDim2.fromOffset(30,30),Position=UDim2.fromOffset(6,6),BackgroundTransparency=1,Text=icon or "✦",TextColor3=NAEI.Theme.Sub,TextSize=15,Parent=Btn}); local Label=New("TextLabel",{Size=UDim2.new(1,-46,1,0),Position=UDim2.fromOffset(40,0),BackgroundTransparency=1,Text=name,TextColor3=NAEI.Theme.Sub,TextSize=13,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=Btn}); local Ind=New("Frame",{Size=UDim2.fromOffset(4,22),Position=UDim2.fromOffset(-5,10),BackgroundColor3=NAEI.Theme.NeonYellow,BackgroundTransparency=1,Parent=Btn}); Corner(Ind,10); local Page=New("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScrollBarThickness=2,ScrollBarImageColor3=NAEI.Theme.NeonYellow,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=Content}); New("UIListLayout",{Padding=UDim.new(0,9),Parent=Page}); function Tab:Select() for _,t in ipairs(Window.Tabs) do Tween(t.Button,0.2,{BackgroundTransparency=1}); t.Label.TextColor3=NAEI.Theme.Sub; t.Icon.TextColor3=NAEI.Theme.Sub; Tween(t.Ind,0.2,{BackgroundTransparency=1}); t.Page.Visible=false end Tween(Btn,0.3,{BackgroundTransparency=0,BackgroundColor3=NAEI.Theme.Card2}); Tween(Ind,0.3,{BackgroundTransparency=0}); Label.TextColor3=NAEI.Theme.Text; Icon.TextColor3=NAEI.Theme.NeonYellow; Page.Visible=true end Tab.Button=Btn; Tab.Label=Label; Tab.Icon=Icon; Tab.Ind=Ind; Tab.Page=Page; Btn.Activated:Connect(function() Tab:Select() end); function Tab:AddButton(c) c=c or {}; local f=New("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,14); local s=Stroke(f,NAEI.Theme.Border,0.6,1); local b=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=f}); New("TextLabel",{Size=UDim2.new(1,-28,1,0),Position=UDim2.fromOffset(16,0),BackgroundTransparency=1,Text=c.Name or "Button",TextColor3=NAEI.Theme.Text,TextSize=13,Parent=b}); b.MouseEnter:Connect(function() Tween(f,0.2,{BackgroundColor3=NAEI.Theme.Hover}) Tween(s,0.2,{Color=NAEI.Theme.NeonYellow}) end); b.MouseLeave:Connect(function() Tween(f,0.2,{BackgroundColor3=NAEI.Theme.Card}) Tween(s,0.2,{Color=NAEI.Theme.Border}) end); b.Activated:Connect(function() if c.Callback then c.Callback() end ShakeUI(f,2) end); return f end; function Tab:AddToggle(c) c=c or {}; local state=c.Default==true; local f=New("Frame",{Size=UDim2.new(1,0,0,50),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,14); New("TextLabel",{Size=UDim2.new(1,-76,1,0),Position=UDim2.fromOffset(16,0),BackgroundTransparency=1,Text=c.Name or "Toggle",TextColor3=NAEI.Theme.Text,TextSize=13,Parent=f}); local Track=New("Frame",{Size=UDim2.fromOffset(54,30),Position=UDim2.new(1,-66,0.5,-15),BackgroundColor3=state and NAEI.Theme.NeonYellow or NAEI.Theme.Off,Parent=f}); Corner(Track,15); local Thumb=New("Frame",{Size=UDim2.fromOffset(24,24),Position=state and UDim2.new(1,-27,0.5,-12) or UDim2.new(0,3,0.5,-12),BackgroundColor3=Color3.new(1,1,1),Parent=Track}); Corner(Thumb,100); local btn=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Parent=f}); btn.Activated:Connect(function() state=not state; Tween(Track,0.35,{BackgroundColor3=state and NAEI.Theme.NeonYellow or NAEI.Theme.Off},Enum.EasingStyle.Back); Tween(Thumb,0.4,{Position=state and UDim2.new(1,-27,0.5,-12) or UDim2.new(0,3,0.5,-12)},Enum.EasingStyle.Back); if c.Callback then c.Callback(state) end end); return f end; table.insert(Window.Tabs,Tab); if #Window.Tabs==1 then Tab:Select() end; return Tab end
    function Window:Destroy() Tween(Main,0.4,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.4); Gui:Destroy() end
    CloseBtn.Activated:Connect(function() Window:Destroy() end); MinBtn.Activated:Connect(function() SetMin(true) end); Orb.Activated:Connect(function() SetMin(false) end)
    return Window
end
return NAEI