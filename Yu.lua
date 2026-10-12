--[[
    NAEI HUB v3.0 - ULTIMATE EDITION
    Loader + Hub in one - Logo: https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local NAEI = {}
NAEI.Version = "3.0-Ultimate"
NAEI.Theme = {
    Background = Color3.fromRGB(18,18,20), Background2 = Color3.fromRGB(24,24,27),
    Card = Color3.fromRGB(32,32,36), CardHover = Color3.fromRGB(42,42,48),
    Primary = Color3.fromRGB(168,85,255), PrimaryAccent = Color3.fromRGB(120,119,255),
    Text = Color3.fromRGB(250,250,252), SubText = Color3.fromRGB(161,161,170),
    Muted = Color3.fromRGB(113,113,122), Border = Color3.fromRGB(39,39,42),
    ToggleOff = Color3.fromRGB(63,63,70), Success = Color3.fromRGB(34,197,94), Danger=Color3.fromRGB(239,68,68)
}
NAEI.LogoUrl = "https://i.postimg.cc/kGgy2Qv7/1791534181749.jpg"
NAEI.LogoFile = "naei_v3_logo.jpg"

local function Create(c,p) local o=Instance.new(c) for k,v in pairs(p or {}) do pcall(function() o[k]=v end) end return o end
local function Corner(o,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 10) c.Parent=o return c end
local function Stroke(o,c,t,th) local s=Instance.new("UIStroke") s.Color=c or NAEI.Theme.Border s.Transparency=t or 0.5 s.Thickness=th or 1 s.Parent=o return s end
local function Tween(o,tm,prop,info) TweenService:Create(o, info or TweenInfo.new(tm, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), prop):Play() end
local function GetParent() return typeof(gethui)=="function" and select(2,pcall(gethui)) or LocalPlayer:WaitForChild("PlayerGui") end

local function LoadImageFromUrl(url, fileName)
    local getAsset = getcustomasset or getsynasset
    if not (getAsset and writefile and isfile) then return url end
    local ok, asset = pcall(function()
        if not isfile(fileName) then writefile(fileName, game:HttpGet(url)) end
        return getAsset(fileName)
    end)
    return ok and asset or url
end

--=========================================================
-- UPGRADED LOADER - v3.0
--=========================================================
function NAEI:ShowLoader(config)
    config=config or {}
    local title=config.Title or "NAEI HUB"
    local sub=config.SubTitle or "ULTIMATE EDITION"
    local onFinish=config.OnFinish or function() end
    local logoUrl = config.LogoUrl or NAEI.LogoUrl

    local ScreenGui = Create("ScreenGui", {Name="NAEI_V3_"..math.random(10000,99999), ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    ScreenGui.Parent=GetParent()

    local Blur = Create("BlurEffect", {Size=0, Parent=game:GetService("Lighting")})
    Tween(Blur, 0.6, {Size=18})

    local BG = Create("Frame", {Size=UDim2.fromScale(1,1), BackgroundColor3=NAEI.Theme.Background, Parent=ScreenGui})
    local BgImage = Create("ImageLabel", {Size=UDim2.fromScale(1.3,1.3), Position=UDim2.fromScale(-0.15,-0.15), BackgroundTransparency=1, Image=LoadImageFromUrl(logoUrl, NAEI.LogoFile), ImageTransparency=0.90, ScaleType=Enum.ScaleType.Crop, Parent=BG})
    Corner(BgImage,0)

    -- Animated gradient overlay
    local Overlay = Create("Frame", {Size=UDim2.fromScale(1,1), BackgroundColor3=NAEI.Theme.Background, BackgroundTransparency=0.2, Parent=BG})
    local Grad = Instance.new("UIGradient", Overlay)
    Grad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(18,18,20)), ColorSequenceKeypoint.new(0.5,Color3.fromRGB(120,85,255)), ColorSequenceKeypoint.new(1,Color3.fromRGB(18,18,20))}
    Grad.Rotation=45 Grad.Transparency=NumberSequence.new(0.3)
    task.spawn(function() while Overlay.Parent do for i=0,360 do Grad.Rotation=i task.wait(0.02) end end end)

    -- Center Card Glass
    local Card = Create("Frame", {Size=UDim2.fromOffset(360, 420), AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5), BackgroundColor3=NAEI.Theme.Card, BackgroundTransparency=0.1, Parent=ScreenGui})
    Corner(Card, 28) Stroke(Card, Color3.new(1,1,1), 0.92, 1)
    local OuterStroke = Stroke(Card, NAEI.Theme.Primary, 0.5, 2)
    local G2 = Instance.new("UIGradient", OuterStroke) G2.Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.PrimaryAccent) G2.Rotation=0
    task.spawn(function() while Card.Parent do G2.Rotation=(G2.Rotation+2)%360 task.wait() end end)
    Card.Size=UDim2.fromOffset(0,0)
    Tween(Card, 0.7, {Size=UDim2.fromOffset(360,420)}, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out))

    -- Logo with double ring + glow
    local Ring1 = Create("Frame", {Size=UDim2.fromOffset(160,160), Position=UDim2.new(0.5,-80,0,35), BackgroundTransparency=1, Parent=Card}) Corner(Ring1,100) Stroke(Ring1, NAEI.Theme.Primary, 0.75, 1.5)
    local Ring2 = Create("Frame", {Size=UDim2.fromOffset(136,136), Position=UDim2.new(0.5,-68,0,47), BackgroundColor3=NAEI.Theme.Background2, Parent=Card}) Corner(Ring2,100) Stroke(Ring2, NAEI.Theme.Primary, 0.3, 2)
    local LogoGlow = Create("ImageLabel", {Size=UDim2.fromOffset(180,180), Position=UDim2.new(0.5,-90,0,25), BackgroundTransparency=1, Image=LoadImageFromUrl(logoUrl, NAEI.LogoFile), ImageTransparency=0.85, ImageColor3=NAEI.Theme.Primary, ScaleType=Enum.ScaleType.Crop, Parent=Card}) Corner(LogoGlow,100)
    local Logo = Create("ImageLabel", {Size=UDim2.fromOffset(116,116), Position=UDim2.fromOffset(10,10), BackgroundTransparency=1, Image=LoadImageFromUrl(logoUrl, NAEI.LogoFile), ScaleType=Enum.ScaleType.Crop, Parent=Ring2}) Corner(Logo,100)

    task.spawn(function() while Ring1.Parent do Ring1.Rotation+=1 task.wait(0.015) Ring2.Rotation-=1.5 task.wait(0.01) end end)
    local sc=Instance.new("UIScale", Ring2) task.spawn(function() while Ring2.Parent do Tween(sc,1,{Scale=1.07},TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)) task.wait(1) Tween(sc,1,{Scale=1},TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)) task.wait(1) end end)

    Create("TextLabel", {Size=UDim2.new(1,0,0,30), Position=UDim2.fromOffset(0,210), BackgroundTransparency=1, Text=title, TextColor3=NAEI.Theme.Text, TextSize=24, Font=Enum.Font.GothamBold, Parent=Card})
    Create("TextLabel", {Size=UDim2.new(1,0,0,18), Position=UDim2.fromOffset(0,240), BackgroundTransparency=1, Text=sub, TextColor3=NAEI.Theme.SubText, TextSize=12, Font=Enum.Font.GothamMedium, Parent=Card})

    -- Loading Bar Ultra
    local BarBG = Create("Frame", {Size=UDim2.new(1,-48,0,6), Position=UDim2.fromOffset(24,285), BackgroundColor3=Color3.fromRGB(55,55,60), Parent=Card}) Corner(BarBG,100)
    local BarFill = Create("Frame", {Size=UDim2.new(0,0,1,0), BackgroundColor3=NAEI.Theme.Primary, Parent=BarBG}) Corner(BarFill,100)
    Instance.new("UIGradient", BarFill).Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.PrimaryAccent)
    local Shine = Create("Frame", {Size=UDim2.new(0.2,0,1,0), BackgroundColor3=Color3.new(1,1,1), BackgroundTransparency=0.6, Parent=BarFill}) Corner(Shine,100)
    task.spawn(function() while Shine.Parent do Shine.Position=UDim2.new(-0.2,0,0,0) Tween(Shine,1,{Position=UDim2.new(1,0,0,0)}) task.wait(1) end end)

    local Status = Create("TextLabel", {Size=UDim2.new(1,-48,0,20), Position=UDim2.fromOffset(24,300), BackgroundTransparency=1, Text="Initializing system...", TextColor3=NAEI.Theme.Muted, TextSize=11, Font=Enum.Font.Gotham, TextXAlignment=Center, Parent=Card})
    local Percent = Create("TextLabel", {Size=UDim2.new(1,-48,0,20), Position=UDim2.fromOffset(24,322), BackgroundTransparency=1, Text="0%", TextColor3=NAEI.Theme.Primary, TextSize=13, Font=Enum.Font.GothamBold, TextXAlignment=Center, Parent=Card})
    local Dots = Create("TextLabel", {Size=UDim2.new(1,-48,0,16), Position=UDim2.fromOffset(24,345), BackgroundTransparency=1, Text="", TextColor3=NAEI.Theme.Muted, TextSize=18, Font=Enum.Font.GothamBold, TextXAlignment=Center, Parent=Card})

    local steps = {{"Loading assets",22},{"Connecting to NAEI Network",48},{"Decrypting logo",72},{"Syncing data",88},{"Welcome back, "..LocalPlayer.DisplayName,100}}
    task.spawn(function()
        local last=0
        for _,s in ipairs(steps) do
            Status.Text=s[1].."...";
            Tween(BarFill,0.6,{Size=UDim2.new(s[2]/100,0,1,0)})
            for p=last,s[2] do Percent.Text=p.."%" Dots.Text=string.rep("•", math.floor((p%30)/10)+1) task.wait(0.018) end
            last=s[2] task.wait(0.25)
        end
        task.wait(0.5)
        Tween(Blur,0.3,{Size=0}) Tween(Card,0.45,{Size=UDim2.fromOffset(0,0), BackgroundTransparency=1}, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.In))
        Tween(BG,0.4,{BackgroundTransparency=1}) task.wait(0.45) ScreenGui:Destroy() Blur:Destroy() onFinish()
    end)
    return ScreenGui
end

--=========================================================
-- MAIN HUB (จาก v2.0 Compact + Obsidian)
--=========================================================
function NAEI:CreateWindow(config)
    config=config or {}
    local Window={Size=config.Size or Vector2.new(580,380), Title=config.Title or "Naei Hub", Subtitle=config.Subtitle or "Ultimate", Tabs={}}
    local ScreenGui=Create("ScreenGui",{Name="NAEI_HUB_"..math.random(10000,99999), ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling}) ScreenGui.Parent=GetParent()
    local Main=Create("Frame",{Size=UDim2.fromOffset(Window.Size.X, Window.Size.Y), Position=UDim2.new(0.5,-Window.Size.X/2,0.5,-Window.Size.Y/2), BackgroundColor3=NAEI.Theme.Background, BackgroundTransparency=0.08, Parent=ScreenGui}) Corner(Main,16) Stroke(Main, NAEI.Theme.Border, 0.2, 1)
    local Outline=Create("Frame",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Parent=Main}) Corner(Outline,16) local gs=Stroke(Outline, Color3.new(1,1,1), 0.85, 1.2) local Gr=Instance.new("UIGradient",gs) Gr.Color=ColorSequence.new(NAEI.Theme.Primary, NAEI.Theme.PrimaryAccent) task.spawn(function() while Main.Parent do Gr.Rotation=(Gr.Rotation+2)%360 task.wait(0.02) end end)
    local Header=Create("Frame",{Size=UDim2.new(1,0,0,52), BackgroundTransparency=1, Parent=Main})
    local Logo=Create("ImageLabel",{Size=UDim2.fromOffset(32,32), Position=UDim2.fromOffset(16,10), BackgroundTransparency=1, Image=LoadImageFromUrl(NAEI.LogoUrl, NAEI.LogoFile), ScaleType=Enum.ScaleType.Crop, Parent=Header}) Corner(Logo,9)
    Create("TextLabel",{Size=UDim2.new(1,-180,0,20), Position=UDim2.fromOffset(58,8), BackgroundTransparency=1, Text=Window.Title, TextColor3=NAEI.Theme.Text, TextSize=15, Font=Enum.Font.GothamBold, TextXAlignment=Left, Parent=Header})
    Create("TextLabel",{Size=UDim2.new(1,-180,0,14), Position=UDim2.fromOffset(58,28), BackgroundTransparency=1, Text=Window.Subtitle.." • v"..NAEI.Version, TextColor3=NAEI.Theme.SubText, TextSize=11, Font=Enum.Font.Gotham, TextXAlignment=Left, Parent=Header})
    local function TopBtn(icon,pos,color) local b=Create("TextButton",{Size=UDim2.fromOffset(32,32), Position=UDim2.new(1,pos,0,10), BackgroundColor3=NAEI.Theme.Card, Text=icon, TextColor3=NAEI.Theme.SubText, TextSize=16, Font=Enum.Font.GothamBold, AutoButtonColor=false, Parent=Header}) Corner(b,9) Stroke(b, NAEI.Theme.Border,0.5,1) b.MouseEnter:Connect(function() Tween(b,0.2,{BackgroundColor3=color or NAEI.Theme.CardHover, TextColor3=NAEI.Theme.Text}) end) b.MouseLeave:Connect(function() Tween(b,0.2,{BackgroundColor3=NAEI.Theme.Card, TextColor3=NAEI.Theme.SubText}) end) return b end
    local CloseBtn=TopBtn("✕",-44, NAEI.Theme.Danger) local MinBtn=TopBtn("—",-82)
    local Sidebar=Create("Frame",{Size=UDim2.new(0,168,1,-64), Position=UDim2.fromOffset(8,52), BackgroundColor3=Color3.fromRGB(14,14,16), BackgroundTransparency=0.2, Parent=Main}) Corner(Sidebar,12) Stroke(Sidebar, NAEI.Theme.Border,0.6,1)
    local Profile=Create("Frame",{Size=UDim2.new(1,-16,0,56), Position=UDim2.fromOffset(8,8), BackgroundColor3=NAEI.Theme.Card, BackgroundTransparency=0.3, Parent=Sidebar}) Corner(Profile,10)
    local Avatar=Create("ImageLabel",{Size=UDim2.fromOffset(36,36), Position=UDim2.fromOffset(8,10), BackgroundTransparency=1, Image="rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150", Parent=Profile}) Corner(Avatar,10)
    Create("TextLabel",{Size=UDim2.new(1,-56,0,16), Position=UDim2.fromOffset(52,8), BackgroundTransparency=1, Text=LocalPlayer.DisplayName, TextColor3=NAEI.Theme.Text, TextSize=12, Font=Enum.Font.GothamBold, TextXAlignment=Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=Profile})
    Create("TextLabel",{Size=UDim2.new(1,-56,0,14), Position=UDim2.fromOffset(52,26), BackgroundTransparency=1, Text="@"..LocalPlayer.Name, TextColor3=NAEI.Theme.Muted, TextSize=10, Font=Enum.Font.Gotham, TextXAlignment=Left, Parent=Profile})
    local TabHolder=Create("ScrollingFrame",{Size=UDim2.new(1,-8,1,-76), Position=UDim2.fromOffset(4,68), BackgroundTransparency=1, ScrollBarThickness=0, CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y, Parent=Sidebar}) local L=Instance.new("UIListLayout",TabHolder) L.Padding=UDim.new(0,6)
    local Content=Create("Frame",{Size=UDim2.new(1,-184,1,-64), Position=UDim2.new(0,184,0,52), BackgroundTransparency=1, ClipsDescendants=true, Parent=Main}) Window.Content=Content
    Main.Size=UDim2.fromOffset(0,0) Tween(Main,0.5,{Size=UDim2.fromOffset(Window.Size.X, Window.Size.Y)}, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
    local drag,sPos,dPos Header.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true sPos=i.Position dPos=Main.Position end end) UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-sPos Main.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y) end end) UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
    function Window:CreateTab(name,icon)
        local Tab={} local Btn=Create("TextButton",{Size=UDim2.new(1,-8,0,40), BackgroundColor3=NAEI.Theme.Card, BackgroundTransparency=1, Text="", AutoButtonColor=false, Parent=TabHolder}) Corner(Btn,10)
        local IconLbl=Create("TextLabel",{Size=UDim2.fromOffset(20,20), Position=UDim2.fromOffset(12,10), BackgroundTransparency=1, Text=icon and tostring(icon):sub(1,2) or "◈", TextColor3=NAEI.Theme.Muted, TextSize=14, Font=Enum.Font.GothamBold, Parent=Btn})
        Create("TextLabel",{Size=UDim2.new(1,-44,1,0), Position=UDim2.fromOffset(38,0), BackgroundTransparency=1, Text=name, TextColor3=NAEI.Theme.SubText, TextSize=12, Font=Enum.Font.GothamMedium, TextXAlignment=Left, Parent=Btn})
        local Page=Create("ScrollingFrame",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, ScrollBarThickness=2, ScrollBarImageColor3=NAEI.Theme.Primary, CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=false, Parent=Content}) Instance.new("UIListLayout",Page).Padding=UDim.new(0,8) Instance.new("UIPadding",Page).PaddingTop=UDim.new(0,4)
        Tab.Button=Btn Tab.Page=Page Tab.Icon=IconLbl
        function Tab:Select() for _,t in ipairs(Window.Tabs) do Tween(t.Button,0.2,{BackgroundTransparency=1}) t.Page.Visible=false end Tween(Btn,0.25,{BackgroundColor3=NAEI.Theme.Primary, BackgroundTransparency=0.85}) Page.Visible=true end
        Btn.Activated:Connect(function() Tab:Select() end)
        function Tab:AddSection(txt) local f=Create("Frame",{Size=UDim2.new(1,0,0,28), BackgroundTransparency=1, Parent=Page}) Create("TextLabel",{Size=UDim2.new(1,0,1,0), Position=UDim2.fromOffset(4,0), BackgroundTransparency=1, Text=string.upper(txt), TextColor3=NAEI.Theme.Primary, TextSize=11, Font=Enum.Font.GothamBold, TextXAlignment=Left, Parent=f}) return f end
        function Tab:AddButton(cfg) cfg=cfg or {} local f=Create("Frame",{Size=UDim2.new(1,0,0,44), BackgroundColor3=NAEI.Theme.Card, BackgroundTransparency=0.15, Parent=Page}) Corner(f,10) Stroke(f, NAEI.Theme.Border,0.6,1) local b=Create("TextButton",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", AutoButtonColor=false, Parent=f}) Create("TextLabel",{Size=UDim2.new(1,-24,1,0), Position=UDim2.fromOffset(14,0), BackgroundTransparency=1, Text=cfg.Name or "Button", TextColor3=NAEI.Theme.Text, TextSize=13, Font=Enum.Font.GothamMedium, TextXAlignment=Left, Parent=b}) b.Activated:Connect(function() if cfg.Callback then cfg.Callback() end end) return f end
        function Tab:AddToggle(cfg) cfg=cfg or {} local state=cfg.Default==true local f=Create("Frame",{Size=UDim2.new(1,0,0,48), BackgroundColor3=NAEI.Theme.Card, BackgroundTransparency=0.15, Parent=Page}) Corner(f,10) Create("TextLabel",{Size=UDim2.new(1,-70,1,0), Position=UDim2.fromOffset(14,0), BackgroundTransparency=1, Text=cfg.Name, TextColor3=NAEI.Theme.Text, TextSize=13, Font=Enum.Font.GothamMedium, TextXAlignment=Left, Parent=f}) local track=Create("Frame",{Size=UDim2.fromOffset(44,24), Position=UDim2.new(1,-56,0.5,-12), BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.ToggleOff, Parent=f}) Corner(track,12) local thumb=Create("Frame",{Size=UDim2.fromOffset(18,18), Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9), BackgroundColor3=Color3.new(1,1,1), Parent=track}) Corner(thumb,100) local btn=Create("TextButton",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", Parent=f}) local function upd() Tween(track,0.25,{BackgroundColor3=state and NAEI.Theme.Primary or NAEI.Theme.ToggleOff}) Tween(thumb,0.25,{Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}, TweenInfo.new(0.25, Enum.EasingStyle.Back)) if cfg.Callback then cfg.Callback(state) end end btn.Activated:Connect(function() state=not state upd() end) return f end
        table.insert(Window.Tabs, Tab) if #Window.Tabs==1 then Tab:Select() end return Tab
    end
    function Window:Destroy() Tween(Main,0.25,{Size=UDim2.fromOffset(0,0)}) task.wait(0.25) ScreenGui:Destroy() end
    CloseBtn.Activated:Connect(function() Window:Destroy() end) MinBtn.Activated:Connect(function() Main.Visible=not Main.Visible end)
    return Window
end

return NAEI