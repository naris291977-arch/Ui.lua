--[[
    NAEI HUB v13.0 - NEON OBSIDIAN
    FIXED LOADER THAT NEVER STUCK + FULL NEW THEME
    New Theme: Black + Neon Yellow + Mint
    New Layout: Top Dock + Floating Cards
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local NAEI = {}
NAEI.Version = "13.0-NEON-OBSIDIAN"
NAEI.Theme = {
    Bg = Color3.fromRGB(5,5,7),
    BgSub = Color3.fromRGB(12,12,15),
    Card = Color3.fromRGB(18,18,22),
    Card2 = Color3.fromRGB(26,26,32),
    Hover = Color3.fromRGB(38,38,48),
    -- ธีมใหม่หมด เหลืองนีออน + มิ้นท์
    Primary = Color3.fromRGB(255, 235, 0), -- Neon Yellow
    Primary2 = Color3.fromRGB(0, 255, 190), -- Mint
    Primary3 = Color3.fromRGB(255,255,255),
    Text = Color3.fromRGB(255,255,255),
    Sub = Color3.fromRGB(150,150,165),
    Muted = Color3.fromRGB(80,80,95),
    Border = Color3.fromRGB(45,45,55),
    Off = Color3.fromRGB(40,40,50),
    Danger = Color3.fromRGB(255,60,90),
}
NAEI.LogoUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg"
NAEI.LogoFile = "naei_v13.jpg"

local function New(c,p) local o=Instance.new(c) for k,v in pairs(p or {}) do pcall(function() o[k]=v end) end return o end
local function Corner(o,r) New("UICorner",{CornerRadius=UDim.new(0,r or 14),Parent=o}) end
local function Stroke(o,c,t,tk) return New("UIStroke",{Color=c or NAEI.Theme.Border,Transparency=t or 0.5,Thickness=tk or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=o}) end
local function Tween(o,t,pr,s,d) local tw=TweenService:Create(o,TweenInfo.new(t,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),pr) tw:Play() return tw end
local function GetParent() local ok,g=pcall(gethui) if ok and g then return g end return LocalPlayer:WaitForChild("PlayerGui") end
local function GetAsset(u,f) local fn=getcustomasset or getsynasset if not (fn and writefile and isfile) then return u end local ok,a=pcall(function() if not isfile(f) then writefile(f,game:HttpGet(u)) end return fn(f) end) return ok and a or u end
local function AddGlow(o,c,s,tr) return New("ImageLabel",{Size=UDim2.new(1,s or 60,1,s or 60),Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Image="rbxassetid://5028857084",ImageColor3=c or NAEI.Theme.Primary,ImageTransparency=tr or 0.5,ZIndex=0,Parent=o}) end
local function EnableDrag(g,h) h=h or g; local d,s,sp,io=false; h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true s=i.Position sp=g.Position end end); h.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then io=i end end); UserInputService.InputChanged:Connect(function(i) if i==io and d then local dd=i.Position-s g.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dd.X,sp.Y.Scale,sp.Y.Offset+dd.Y) end end); UserInputService.InputEnded:Connect(function() d=false end) end

-- ================= LOADER FIXED ไม่มีวันค้าง =================
function NAEI:ShowLoader(cfg)
    cfg=cfg or {}; local onFinish=cfg.OnFinish or function() end
    local finished=false
    local function Finish()
        if finished then return end
        finished=true
        pcall(onFinish)
    end

    local Gui=New("ScreenGui",{Name="NAEI_LOADER_V13",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})
    local Blur=New("BlurEffect",{Size=0,Parent=game:GetService("Lighting")}); Tween(Blur,0.5,{Size=18})

    local BG=New("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(3,3,5),BackgroundTransparency=0.2,Parent=Gui})

    local Card=New("Frame",{Size=UDim2.fromOffset(280,300),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),BackgroundColor3=NAEI.Theme.Bg,BackgroundTransparency=0.05,Parent=Gui})
    Corner(Card,20); local st=Stroke(Card, NAEI.Theme.Primary, 0.2, 1.5); local grad=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2),Rotation=0,Parent=st})
    AddGlow(Card, NAEI.Theme.Primary, 100, 0.5)
    Card.Size=UDim2.fromOffset(0,0); Tween(Card,0.6,{Size=UDim2.fromOffset(280,300)},Enum.EasingStyle.Back)

    task.spawn(function() while Card.Parent do grad.Rotation=(grad.Rotation+2)%360 task.wait(0.02) end end)

    local LogoBox=New("Frame",{Size=UDim2.fromOffset(72,72),Position=UDim2.new(0.5,-36,0,30),BackgroundColor3=NAEI.Theme.Card2,Parent=Card}); Corner(LogoBox,100); Stroke(LogoBox, NAEI.Theme.Primary, 0.2, 2)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(60,60),Position=UDim2.fromOffset(6,6),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=LogoBox}); Corner(Logo,100)

    New("TextLabel",{Size=UDim2.new(1,0,0,18),Position=UDim2.fromOffset(0,118),BackgroundTransparency=1,Text=cfg.Title or "NAEI HUB",TextColor3=NAEI.Theme.Text,TextSize=17,Font=Enum.Font.GothamBold,Parent=Card})
    New("TextLabel",{Size=UDim2.new(1,0,0,12),Position=UDim2.fromOffset(0,138),BackgroundTransparency=1,Text=cfg.SubTitle or "v13.0 • NEON OBSIDIAN • NEW THEME",TextColor3=NAEI.Theme.Primary,TextSize=9,Font=Enum.Font.GothamBold,Parent=Card})

    local BarBG=New("Frame",{Size=UDim2.new(1,-40,0,6),Position=UDim2.fromOffset(20,175),BackgroundColor3=NAEI.Theme.Off,ClipsDescendants=true,Parent=Card}); Corner(BarBG,100)
    local Bar=New("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=NAEI.Theme.Primary,Parent=BarBG}); Corner(Bar,100); New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2),Parent=Bar})

    local Status=New("TextLabel",{Size=UDim2.new(1,-40,0,14),Position=UDim2.fromOffset(20,190),BackgroundTransparency=1,Text="LOADING...",TextColor3=NAEI.Theme.Muted,TextSize=9,Font=Enum.Font.Code,TextXAlignment=Left,Parent=Card})
    local Percent=New("TextLabel",{Size=UDim2.new(0,50,0,14),Position=UDim2.new(1,-40,0,190),BackgroundTransparency=1,Text="0%",TextColor3=NAEI.Theme.Primary,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Right,Parent=Card})

    -- ระบบกันค้าง
    task.delay(5, function()
        if not finished then
            warn("[NAEI] Loader force finish - anti stuck")
            Tween(Blur,0.3,{Size=0}); Tween(Card,0.3,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.3); pcall(function() Gui:Destroy() Blur:Destroy() end); Finish()
        end
    end)

    task.spawn(function()
        local steps={
            {Text="BOOTING NEON ENGINE", P=30},
            {Text="LOADING OBSIDIAN UI", P=70},
            {Text="WELCOME "..string.upper(LocalPlayer.DisplayName), P=100}
        }
        for _,s in ipairs(steps) do
            if finished then break end
            Status.Text=s.Text
            Tween(Bar, 0.5, {Size=UDim2.new(s.P/100,0,1,0)}, Enum.EasingStyle.Expo)
            Tween(Percent, 0.2, {TextTransparency=0.5})
            for i=0, s.P do
                if finished then break end
                Percent.Text=i.."%"
                if i%2==0 then task.wait(0.01) end
            end
            task.wait(0.2)
        end
        if finished then return end
        task.wait(0.3)
        Tween(Blur,0.3,{Size=0})
        Tween(Card,0.3,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In)
        task.wait(0.32)
        pcall(function() Gui:Destroy() Blur:Destroy() end)
        Finish()
    end)
end

-- ================= UI หลัก ดีไซน์ใหม่หมด =================
function NAEI:CreateWindow(cfg)
    cfg=cfg or {}; local WSize=cfg.Size or Vector2.new(640,420); local Window={Tabs={}}; local Gui=New("ScreenGui",{Name="NAEI_HUB_V13",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=GetParent()})

    local Main=New("Frame",{Size=UDim2.fromOffset(WSize.X,WSize.Y),Position=UDim2.new(0.5,-WSize.X/2,0.5,-WSize.Y/2),BackgroundColor3=NAEI.Theme.Bg,BackgroundTransparency=0.04,Parent=Gui})
    Corner(Main,24); local ms=Stroke(Main, NAEI.Theme.Primary, 0.15, 2); local mg=New("UIGradient",{Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.Primary2),Rotation=45,Parent=ms}); AddGlow(Main, NAEI.Theme.Primary, 180, 0.35)
    task.spawn(function() while Main.Parent do mg.Rotation=(mg.Rotation+0.3)%360 task.wait(0.05) end end)

    -- Top Dock แบบใหม่ ไม่ใช่ Sidebar แล้ว
    local Header=New("Frame",{Size=UDim2.new(1,0,0,54),BackgroundTransparency=1,Parent=Main,ZIndex=10}); EnableDrag(Main,Header)
    local Logo=New("ImageLabel",{Size=UDim2.fromOffset(32,32),Position=UDim2.fromOffset(16,11),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Header}); Corner(Logo,10)
    New("TextLabel",{Size=UDim2.new(1,-180,0,16),Position=UDim2.fromOffset(56,14),BackgroundTransparency=1,Text=cfg.Title or "NAEI HUB",TextColor3=NAEI.Theme.Text,TextSize=15,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Header})
    New("TextLabel",{Size=UDim2.new(1,-180,0,10),Position=UDim2.fromOffset(56,32),BackgroundTransparency=1,Text=cfg.Subtitle or "v13.0 • NEON OBSIDIAN • NEW DESIGN",TextColor3=NAEI.Theme.Primary,TextSize=9,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Header})

    local TopDock=New("Frame",{Size=UDim2.new(1,-24,0,42),Position=UDim2.fromOffset(12,58),BackgroundColor3=NAEI.Theme.BgSub,BackgroundTransparency=0.2,Parent=Main}); Corner(TopDock,14); Stroke(TopDock, NAEI.Theme.Border, 0.4, 1)
    local DockList=New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,8), HorizontalAlignment=Enum.HorizontalAlignment.Center, VerticalAlignment=Enum.VerticalAlignment.Center, Parent=TopDock}); New("UIPadding",{PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8), Parent=TopDock})

    local Content=New("Frame",{Size=UDim2.new(1,-24,1,-112),Position=UDim2.new(0,12,0,110),BackgroundTransparency=1,Parent=Main})

    local Orb=New("ImageButton",{Size=UDim2.fromOffset(60,60),Position=UDim2.new(0,24,0.5,-30),BackgroundColor3=NAEI.Theme.Card2,Visible=false,Parent=Gui,ZIndex=50}); Corner(Orb,100); Stroke(Orb, NAEI.Theme.Primary, 0, 2.5); AddGlow(Orb, NAEI.Theme.Primary, 35, 0.4)
    local OrbLogo=New("ImageLabel",{Size=UDim2.fromOffset(44,44),Position=UDim2.fromOffset(8,8),BackgroundTransparency=1,Image=GetAsset(NAEI.LogoUrl,NAEI.LogoFile),ScaleType=Enum.ScaleType.Crop,Parent=Orb}); Corner(OrbLogo,100); EnableDrag(Orb,Orb)

    local function TopBtn(txt,pos,col) local b=New("TextButton",{Size=UDim2.fromOffset(34,34),Position=UDim2.new(1,pos,0,10),BackgroundColor3=NAEI.Theme.Card,Text=txt,TextColor3=NAEI.Theme.Sub,TextSize=16,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=Header}); Corner(b,12); Stroke(b,NAEI.Theme.Border,0.5,1); return b end
    local CloseBtn=TopBtn("✕",-44,NAEI.Theme.Danger); local MinBtn=TopBtn("—",-86)

    Main.Size=UDim2.fromOffset(0,0); Main.BackgroundTransparency=1; Tween(Main,0.8,{Size=UDim2.fromOffset(WSize.X,WSize.Y),BackgroundTransparency=0.04},Enum.EasingStyle.Back)
    local minimized=false; local function SetMin(s) minimized=s; if s then Tween(Main,0.35,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In) task.wait(0.35) Main.Visible=false Orb.Visible=true Orb.Size=UDim2.fromOffset(0,0) Tween(Orb,0.5,{Size=UDim2.fromOffset(60,60)},Enum.EasingStyle.Back) else Tween(Orb,0.25,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In) task.wait(0.25) Orb.Visible=false Main.Visible=true Main.Size=UDim2.fromOffset(0,0) Tween(Main,0.6,{Size=UDim2.fromOffset(WSize.X,WSize.Y),BackgroundTransparency=0.04},Enum.EasingStyle.Back) end end

    function Window:CreateTab(name, icon)
        local Tab={}
        local Btn=New("TextButton",{Size=UDim2.new(0,110,0,30),BackgroundColor3=NAEI.Theme.Card,BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=TopDock}); Corner(Btn,10)
        local Icon=New("TextLabel",{Size=UDim2.fromOffset(20,20),Position=UDim2.fromOffset(8,5),BackgroundTransparency=1,Text=icon or "●",TextColor3=NAEI.Theme.Sub,TextSize=12,Parent=Btn})
        local Label=New("TextLabel",{Size=UDim2.new(1,-34,1,0),Position=UDim2.fromOffset(30,0),BackgroundTransparency=1,Text=name,TextColor3=NAEI.Theme.Sub,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=Btn})
        local Page=New("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScrollBarThickness=2,ScrollBarImageColor3=NAEI.Theme.Primary,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=Content}); New("UIListLayout",{Padding=UDim.new(0,12),Parent=Page}); New("UIPadding",{PaddingTop=UDim.new(0,6),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,14),Parent=Page})

        function Tab:Select()
            for _,t in ipairs(Window.Tabs) do Tween(t.Button,0.2,{BackgroundTransparency=1, BackgroundColor3=NAEI.Theme.Card}); t.Label.TextColor3=NAEI.Theme.Sub; t.Icon.TextColor3=NAEI.Theme.Sub; t.Page.Visible=false end
            Tween(Btn,0.3,{BackgroundTransparency=0,BackgroundColor3=NAEI.Theme.Card2}); Label.TextColor3=NAEI.Theme.Primary; Icon.TextColor3=NAEI.Theme.Primary; Page.Visible=true
            Tween(Btn,0.1,{Size=UDim2.new(0,105,0,28)}) task.wait(0.1) Tween(Btn,0.2,{Size=UDim2.new(0,110,0,30)},Enum.EasingStyle.Back)
        end
        Tab.Button=Btn; Tab.Label=Label; Tab.Icon=Icon; Tab.Page=Page; Btn.MouseButton1Click:Connect(function() Tab:Select() end)

        function Tab:AddSection(txt)
            local f=New("Frame",{Size=UDim2.new(1,0,0,28),BackgroundTransparency=1,Parent=Page})
            local line=New("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=NAEI.Theme.Border,BackgroundTransparency=0.5,Parent=f})
            New("TextLabel",{Size=UDim2.fromOffset(120,28),Position=UDim2.fromOffset(0,0),BackgroundColor3=NAEI.Theme.Bg,Text=" "..string.upper(txt).." ",TextColor3=NAEI.Theme.Primary,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Left,Parent=f})
        end

        function Tab:AddButton(c)
            c=c or {}; local f=New("Frame",{Size=UDim2.new(1,0,0,54),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,16); local s=Stroke(f,NAEI.Theme.Border,0.4,1)
            local b=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,Parent=f})
            New("TextLabel",{Size=UDim2.new(1,-40,1,0),Position=UDim2.fromOffset(18,0),BackgroundTransparency=1,Text=c.Name or "Button",TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=b})
            local arrow=New("Frame",{Size=UDim2.fromOffset(28,28),Position=UDim2.new(1,-38,0.5,-14),BackgroundColor3=NAEI.Theme.Primary,BackgroundTransparency=0.85,Parent=b}); Corner(arrow,100)
            New("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="→",TextColor3=NAEI.Theme.Primary,TextSize=14,Font=Enum.Font.GothamBold,Parent=arrow})
            b.MouseEnter:Connect(function() Tween(f,0.25,{BackgroundColor3=NAEI.Theme.Hover,Size=UDim2.new(1,0,0,56)}) Tween(s,0.25,{Color=NAEI.Theme.Primary}) Tween(arrow,0.25,{BackgroundTransparency=0, Rotation=45}) end)
            b.MouseLeave:Connect(function() Tween(f,0.25,{BackgroundColor3=NAEI.Theme.Card,Size=UDim2.new(1,0,0,54)}) Tween(s,0.25,{Color=NAEI.Theme.Border}) Tween(arrow,0.25,{BackgroundTransparency=0.85, Rotation=0}) end)
            b.Activated:Connect(function() if c.Callback then c.Callback() end end)
            return f
        end

        function Tab:AddToggle(c)
            c=c or {}; local state=c.Default==true; local f=New("Frame",{Size=UDim2.new(1,0,0,56),BackgroundColor3=NAEI.Theme.Card,Parent=Page}); Corner(f,16); Stroke(f,NAEI.Theme.Border,0.4,1)
            New("TextLabel",{Size=UDim2.new(1,-80,1,0),Position=UDim2.fromOffset(18,0),BackgroundTransparency=1,Text=c.Name or "Toggle",TextColor3=NAEI.Theme.Text,TextSize=13,Font=Enum.Font.GothamMedium,TextXAlignment=Left,Parent=f})
            local Track=New("Frame",{Size=UDim2.fromOffset(56,32),Position=UDim2.new(1,-70,0.5,-16),BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off,Parent=f}); Corner(Track,16)
            local Thumb=New("Frame",{Size=UDim2.fromOffset(26,26),Position=state and UDim2.new(1,-29,0.5,-13) or UDim2.new(0,3,0.5,-13),BackgroundColor3=Color3.new(1,1,1),Parent=Track}); Corner(Thumb,100); AddGlow(Thumb,NAEI.Theme.Primary,20,0.3)
            local btn=New("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Parent=f})
            btn.Activated:Connect(function() state=not state; Tween(Track,0.4,{BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.Off},Enum.EasingStyle.Back); Tween(Thumb,0.45,{Position=state and UDim2.new(1,-29,0.5,-13) or UDim2.new(0,3,0.5,-13)},Enum.EasingStyle.Back); if c.Callback then c.Callback(state) end end)
            return f
        end

        table.insert(Window.Tabs,Tab); if #Window.Tabs==1 then Tab:Select() end; return Tab
    end

    function Window:Destroy() Tween(Main,0.35,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In); task.wait(0.35); Gui:Destroy() end
    CloseBtn.MouseButton1Click:Connect(function() Window:Destroy() end); MinBtn.MouseButton1Click:Connect(function() SetMin(true) end); Orb.MouseButton1Click:Connect(function() SetMin(false) end)
    return Window
end
return NAEI