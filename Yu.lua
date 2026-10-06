--[[
=========================================================
                    NAEI HUB UI LIBRARY
                       v1.3.0 — COMPACT EDITION
=========================================================
-- ปรับลดขนาด UI ให้เล็กลงกะทัดรัดขึ้น
]]
--=========================================================
-- SERVICES
--=========================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
--=========================================================
-- NAEI
--=========================================================
local NAEI = {}
NAEI.Name = "Naei Hub"
NAEI.Version = "1.3.0-Compact"
--=========================================================
-- THEME
--=========================================================
NAEI.Theme = {
    Background = Color3.fromRGB(46, 47, 52),
    Sidebar = Color3.fromRGB(38, 39, 44),
    Card = Color3.fromRGB(62, 63, 69),
    CardHover = Color3.fromRGB(77, 78, 85),
    Primary = Color3.fromRGB(178, 183, 192),
    PrimaryDark = Color3.fromRGB(102, 106, 115),
    Text = Color3.fromRGB(240, 245, 250),
    SubText = Color3.fromRGB(155, 170, 188),
    ToggleOff = Color3.fromRGB(88, 90, 97),
    Danger = Color3.fromRGB(190, 65, 75),
    Success = Color3.fromRGB(75, 210, 125),
    Warning = Color3.fromRGB(255, 190, 70),
}
--=========================================================
-- GLASS
--=========================================================
NAEI.Glass = {
    Main = 0.2,
    Sidebar = 0.3,
    Card = 0.4,
    Inner = 0.45,
}
--=========================================================
-- BACKGROUND
--=========================================================
NAEI.LogoImage = "rbxassetid://72018461815575"
NAEI.Background = {
    Enabled = true,
    Image = "rbxassetid://114611759742732",
    File = "Naei_bg.jpg",
    Url = "",
    Transparency = 0.5,
}
local function ResolveBackground()
    local cfg = NAEI.Background
    if not cfg.Enabled then return nil end
    if cfg.Image and cfg.Image ~= "" then return cfg.Image end
    local getAsset = getcustomasset or getsynasset
    if not (getAsset and isfile and writefile) then return nil end
    pcall(function()
        if cfg.Url ~= "" and not isfile(cfg.File) then
            writefile(cfg.File, game:HttpGet(cfg.Url))
        end
    end)
    local ok, asset = pcall(function() if isfile(cfg.File) then return getAsset(cfg.File) end end)
    if ok and asset then return asset end
    return nil
end
--=========================================================
-- ASSET FIX
--=========================================================
local function FixImage(imageObject, label)
    task.spawn(function()
        local original = imageObject.Image
        if original == "" then return end
        local ok, result = pcall(function() return game:GetObjects(original) end)
        if ok and type(result) == "table" and result[1] then
            local asset = result[1]
            local texture
            if asset:IsA("Decal") or asset:IsA("Texture") then
                texture = asset.Texture
            else
                local found = asset:FindFirstChildWhichIsA("Decal", true)
                if found then texture = found.Texture end
            end
            if texture and texture ~= "" then imageObject.Image = texture end
        end
        task.wait(5)
        if imageObject.Parent and not imageObject.IsLoaded then
            warn("[Naei Hub] " .. tostring(label) .. " โหลดไม่ทัน")
        end
    end)
end
--=========================================================
-- ICONS
--=========================================================
NAEI.Icons = {}
NAEI.IconGlyphs = {
    settings = "⚙", home = "⌂", star = "★", info = "ℹ", user = "☻",
    sword = "⚔", zap = "⚡", eye = "◉", search = "🔕", list = "☰",
}
function NAEI:AddIcons(iconTable)
    for name, value in pairs(iconTable or {}) do
        NAEI.Icons[string.lower(tostring(name))] = value
    end
end
--=========================================================
-- LUCIDE
--=========================================================
NAEI.UseLucide = true
NAEI.LucideUrl = "https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua"
NAEI.IconAliases = { home = "house", setting = "settings", player = "user" }
local LucideModule, LucideTried = nil, false
local function GetLucide()
    if LucideTried then return LucideModule end
    LucideTried = true
    if not NAEI.UseLucide then return nil end
    local ok, result = pcall(function() return loadstring(game:HttpGet(NAEI.LucideUrl))() end)
    if ok and type(result) == "table" and result.GetAsset then
        LucideModule = result
    end
    return LucideModule
end
local function GetLucideIcon(name)
    local lucide = GetLucide()
    if not lucide then return nil end
    local candidates = {name, NAEI.IconAliases[name]}
    for _, c in ipairs(candidates) do
        local ok, a = pcall(lucide.GetAsset, c)
        if ok and a and a.Url then return {Image=a.Url, ImageRectOffset=a.ImageRectOffset, ImageRectSize=a.ImageRectSize} end
    end
    return nil
end
local function ResolveIcon(icon)
    if not icon or icon == "" then return nil end
    if type(icon)=="number" then return "image", {Image="rbxassetid://"..icon} end
    if type(icon)=="table" then return "image", icon end
    icon = tostring(icon)
    if icon:find("rbxassetid://",1,true) or icon:match("^https?://") then return "image", {Image=icon} end
    if icon:match("^%d+$") then return "image", {Image="rbxassetid://"..icon} end
    local key = string.lower(icon):gsub("^lucide:","")
    local reg = NAEI.Icons[key]
    if reg then return type(reg)=="table" and "image", reg or "image", {Image=tostring(reg)} end
    local li = GetLucideIcon(key)
    if li then return "image", li end
    return "glyph", NAEI.IconGlyphs[key] or "◈"
end
--=========================================================
-- UTILITY
--=========================================================
local function Create(className, props)
    local obj = Instance.new(className)
    for k,v in pairs(props or {}) do pcall(function() obj[k]=v end) end
    if props and props.BackgroundTransparency==nil and props.Name~="Main" and obj:IsA("GuiObject") then
        if props.BackgroundColor3==NAEI.Theme.Card then obj.BackgroundTransparency=NAEI.Glass.Card
        elseif props.BackgroundColor3==NAEI.Theme.Background then obj.BackgroundTransparency=NAEI.Glass.Inner end
    end
    return obj
end
local function AddCorner(obj, r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 6) c.Parent=obj return c end
local function AddStroke(obj,col,t,th) local s=Instance.new("UIStroke") s.Color=col or NAEI.Theme.Primary s.Transparency=t or 0 s.Thickness=th or 1 s.Parent=obj return s end
local function Tween(obj,t,props,style,dir) return TweenService:Create(obj,TweenInfo.new(t or 0.2,style or Enum.EasingStyle.Quad,dir or Enum.EasingDirection.Out),props):Play() end
local function GetParent() return typeof(gethui)=="function" and select(2,pcall(gethui)) or LocalPlayer:WaitForChild("PlayerGui") end
--=========================================================
-- EFFECTS
--=========================================================
NAEI.Effects = {}
function NAEI.Effects:Glow(o,c) if not o then return end c=c or NAEI.Theme.Primary local s=o:FindFirstChild("NAEI_Glow") or Instance.new("UIStroke",o) s.Name="NAEI_Glow" s.Thickness=1 s.Transparency=0.8 s.Color=c Tween(s,0.25,{Transparency=0.12,Thickness=2}) return s end
function NAEI.Effects:Pulse(o) if not o then return end local s=o:FindFirstChild("NAEI_Pulse") or Instance.new("UIScale",o) s.Name="NAEI_Pulse" s.Scale=1 task.spawn(function() while o.Parent do Tween(s,0.6,{Scale=1.03},Enum.EasingStyle.Sine).Completed:Wait() if not o.Parent then break end Tween(s,0.6,{Scale=1},Enum.EasingStyle.Sine).Completed:Wait() end end) end
--=========================================================
-- CREATE WINDOW — COMPACT SIZES
--=========================================================
function NAEI:CreateWindow(config)
    config = config or {}
    local Window = {}
    -- ✅ ปรับขนาดหน้าต่างให้เล็กลง
    Window.Title = config.Title or "Naei Hub"
    Window.Subtitle = config.Subtitle or "Menu"
    Window.Size = config.Size or Vector2.new(520, 340)        -- เดิม 700×440
    Window.MinSize = config.MinSize or Vector2.new(420, 280)   -- เดิม 560×360
    Window.MaxSize = config.MaxSize or Vector2.new(720, 480)  -- เดิม 1000×650
    Window.LastSize = Window.Size
    Window.Tabs = {}
    Window.IsMinimized = Window.IsHidden = Window.Destroyed = false

    local ScreenGui = Create("ScreenGui", {Name="NAEI_UI_"..math.random(10000,99999),ResetOnSpawn=false,IgnoreGuiInset=true})
    ScreenGui.Parent = GetParent()
    Window.ScreenGui = ScreenGui

    local Main = Create("Frame", {
        Name="Main",
        Size=UDim2.fromOffset(Window.Size.X, Window.Size.Y),
        Position=UDim2.new(0.5,-Window.Size.X/2,0.5,-Window.Size.Y/2),
        BackgroundColor3=NAEI.Theme.Background,
        ClipsDescendants=true,
    })
    Main.Parent = ScreenGui
    AddCorner(Main, 14)

    local BgImage = Create("ImageLabel", {
        Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
        Image=ResolveBackground() or "",ImageTransparency=NAEI.Background.Transparency,
        ScaleType=Enum.ScaleType.Crop,ZIndex=0,Visible=ResolveBackground()~=nil,
    })
    BgImage.Parent = Main
    AddCorner(BgImage, 14)
    FixImage(BgImage, "พื้นหลัง")

    local HideScale = Instance.new("UIScale",Main) HideScale.Scale=1

    local MainStroke = AddStroke(Main,Color3.new(1,1,1),0.95,1.5)
    local Grad = Instance.new("UIGradient",MainStroke)
    Grad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(92,96,104)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(190,195,203)),ColorSequenceKeypoint.new(1,Color3.fromRGB(112,117,125))}
    Grad.Offset=Vector2.new(-1,0)
    task.spawn(function() while Main.Parent and not Window.Destroyed do Grad.Offset=Vector2.new(-1,0) local a=TweenService:Create(Grad,TweenInfo.new(3.5),{Offset=Vector2.new(1,0)}) a:Play() a.Completed:Wait() end end)

    -- ✅ ปรับความสูง Header ลงจาก 58 → 44
    local Header = Create("Frame", {Name="Header",Size=UDim2.new(1,0,0,44),BackgroundTransparency=1,Active=true})
    Header.Parent = Main

    -- ✅ ปรับโลโก้เล็กลง
    local Logo = Create("Frame", {Size=UDim2.fromOffset(28,28),Position=UDim2.fromOffset(10,8),BackgroundTransparency=1})
    Logo.Parent = Header
    AddCorner(Logo, 8)
    local LogoImg = Create("ImageLabel", {Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=NAEI.LogoImage,ScaleType=Enum.ScaleType.Fit})
    LogoImg.Parent = Logo
    FixImage(LogoImg, "โลโก้")

    local Title = Create("TextLabel", {
        Size=UDim2.new(1,-140,0,18),Position=UDim2.fromOffset(46,5),BackgroundTransparency=1,
        Text=Window.Title,TextColor3=NAEI.Theme.Text,TextSize=14,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,
    })
    Title.Parent = Header
    local Subtitle = Create("TextLabel", {
        Size=UDim2.new(1,-140,0,16),Position=UDim2.fromOffset(46,24),BackgroundTransparency=1,
        Text=Window.Subtitle,TextColor3=NAEI.Theme.SubText,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,
    })
    Subtitle.Parent = Header

    -- ✅ ปรับปุ่มลดขนาด
    local MinBtn = Create("TextButton", {
        Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,-72,0,7),BackgroundColor3=NAEI.Theme.Card,
        Text="-",TextColor3=NAEI.Theme.Text,TextSize=18,Font=Enum.Font.GothamBold,AutoButtonColor=false,
    })
    MinBtn.Parent = Header
    AddCorner(MinBtn, 8)
    local CloseBtn = Create("TextButton", {
        Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,-38,0,7),BackgroundColor3=NAEI.Theme.Card,
        Text="×",TextColor3=NAEI.Theme.Text,TextSize=20,Font=Enum.Font.GothamBold,AutoButtonColor=false,
    })
    CloseBtn.Parent = Header
    AddCorner(CloseBtn, 8)

    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn,0.15,{BackgroundColor3=NAEI.Theme.Danger}) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn,0.15,{BackgroundColor3=NAEI.Theme.Card}) end)
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn,0.15,{BackgroundColor3=NAEI.Theme.CardHover}) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn,0.15,{BackgroundColor3=NAEI.Theme.Card}) end)

    -- ✅ ปรับ Sidebar ลดความกว้างจาก 190 → 150
    local Sidebar = Create("Frame", {
        Name="Sidebar",Size=UDim2.new(0,150,1,-44),Position=UDim2.fromOffset(0,44),
        BackgroundColor3=NAEI.Theme.Sidebar,BackgroundTransparency=NAEI.Glass.Sidebar,
    })
    Sidebar.Parent = Main

    -- ✅ ปรับ Profile Card เล็กลง
    local Profile = Create("Frame", {Size=UDim2.new(1,-16,0,62),Position=UDim2.fromOffset(8,8),BackgroundColor3=NAEI.Theme.Card})
    Profile.Parent = Sidebar
    AddCorner(Profile, 8)
    local Avatar = Create("ImageLabel", {
        Size=UDim2.fromOffset(36,36),Position=UDim2.fromOffset(8,13),BackgroundTransparency=1,
        Image="rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=100&h=100",
    })
    Avatar.Parent = Profile
    AddCorner(Avatar, 8)
    local DName = Create("TextLabel", {
        Size=UDim2.new(1,-56,0,18),Position=UDim2.fromOffset(50,10),BackgroundTransparency=1,
        Text=LocalPlayer.DisplayName,TextColor3=NAEI.Theme.Text,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,
    })
    DName.Parent = Profile
    local Uname = Create("TextLabel", {
        Size=UDim2.new(1,-56,0,16),Position=UDim2.fromOffset(50,30),BackgroundTransparency=1,
        Text="@"..LocalPlayer.Name,TextColor3=NAEI.Theme.SubText,TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,
    })
    Uname.Parent = Profile

    local TabHolder = Create("ScrollingFrame", {
        Size=UDim2.new(1,-16,1,-80),Position=UDim2.fromOffset(8,74),BackgroundTransparency=1,
        ScrollBarThickness=2,ScrollBarImageColor3=NAEI.Theme.Primary,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,
    })
    TabHolder.Parent = Sidebar
    Instance.new("UIListLayout",TabHolder).Padding=UDim.new(0,4)

    -- ✅ ปรับ Content ให้เลื่อนตาม Sidebar ใหม่
    local Content = Create("Frame", {
        Name="Content",Size=UDim2.new(1,-150,1,-44),Position=UDim2.new(0,150,0,44),BackgroundTransparency=1,
    })
    Content.Parent = Main
    Window.Content = Content

    -- Drag
    local drag, dStart, sPos
    Header.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=true dStart=i.Position sPos=Main.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-dStart
            Main.Position=UDim2.new(sPos.X.Scale,sPos.X.Offset+d.X,sPos.Y.Scale,sPos.Y.Offset+d.Y)
        end
    end)

    -- Window Methods
    function Window:Minimize(s)
        if Window.Destroyed or Window.IsHidden then return end
        s=s==nil and not Window.IsMinimized or s
        Window.IsMinimized=s
        if s then Window.LastSize=Window.Size Tween(Main,0.25,{Size=UDim2.new(0,Window.LastSize.X,0,44)}) MinBtn.Text="+"
        else Tween(Main,0.3,{Size=UDim2.new(0,Window.LastSize.X,0,Window.LastSize.Y)}) MinBtn.Text="-" end
    end
    function Window:Destroy() Window.Destroyed=true Tween(BgImage,0.2,{ImageTransparency=1}) local t=Tween(Main,0.25,{Size=UDim2.fromOffset(Main.AbsoluteSize.X*0.85,Main.AbsoluteSize.Y*0.85),BackgroundTransparency=1}) t.Completed:Connect(function() ScreenGui:Destroy() end) end
    MinBtn.Activated:Connect(function() Window:Minimize() end)
    CloseBtn.Activated:Connect(function() Window:Destroy() end)

    -- CreateTab
    function Window:CreateTab(name,icon)
        local Tab = {Name=name,Icon=icon,Elements={}}
        table.insert(Window.Tabs,Tab)
        local Btn = Create("TextButton", {
            Size=UDim2.new(1,0,0,32),BackgroundColor3=NAEI.Theme.Sidebar,BackgroundTransparency=1,
            Text=name,TextColor3=NAEI.Theme.SubText,TextSize=11,Font=Enum.Font.GothamMedium,TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=false,
        })
        Btn.Parent = TabHolder
        AddCorner(Btn,6)
        local Pad=Instance.new("UIPadding",Btn) Pad.PaddingLeft=UDim.new(0,10)

        local ik, id = ResolveIcon(icon)
        if ik then
            Pad.PaddingLeft=UDim.new(0,32)
            local I
            if ik=="image" then I=Create("ImageLabel",{Size=UDim2.fromOffset(16,16),Position=UDim2.new(0,-22,0.5,-8),BackgroundTransparency=1,Image=id.Image,ImageColor3=NAEI.Theme.SubText,ScaleType=Enum.ScaleType.Fit})
            else I=Create("TextLabel",{Size=UDim2.fromOffset(16,16),Position=UDim2.new(0,-22,0.5,-8),BackgroundTransparency=1,Text=id,TextColor3=NAEI.Theme.SubText,TextSize=14}) end
            I.Parent=Btn
            Tab.IconObject=I
        end

        local Page = Create("ScrollingFrame", {
            Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScrollBarThickness=2,ScrollBarImageColor3=NAEI.Theme.Primary,
            CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,
        })
        Page.Parent = Content
        local PPad=Instance.new("UIPadding",Page) PPad.PaddingTop=UDim.new(0,8) PPad.PaddingBottom=UDim.new(0,8) PPad.PaddingLeft=UDim.new(0,8) PPad.PaddingRight=UDim.new(0,8)
        Instance.new("UIListLayout",Page).Padding=UDim.new(0,6)

        Tab.Button=Btn Tab.Page=Page

        function Tab:Select()
            for _,t in ipairs(Window.Tabs) do
                if t.Button then Tween(t.Button,0.12,{BackgroundTransparency=1,TextColor3=NAEI.Theme.SubText}) end
                if t.IconObject then Tween(t.IconObject,0.12,{ImageColor3=NAEI.Theme.SubText,TextColor3=NAEI.Theme.SubText}) end
                if t.Page then t.Page.Visible=false end
            end
            Tween(Btn,0.12,{BackgroundColor3=NAEI.Theme.PrimaryDark,BackgroundTransparency=0.15,TextColor3=NAEI.Theme.Text})
            if Tab.IconObject then Tween(Tab.IconObject,0.12,{ImageColor3=NAEI.Theme.Text,TextColor3=NAEI.Theme.Text}) end
            Page.Visible=true
        end
        Btn.Activated:Connect(function() Tab:Select() end)

        function Tab:AddSection(t) local s=Create("TextLabel",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,Text=t,TextColor3=NAEI.Theme.Primary,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left}) s.Parent=Page return s end
        function Tab:AddButton(cfg) cfg=cfg or {} local f=Create("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=NAEI.Theme.Card}) f.Parent=Page AddCorner(f,6) local b=Create("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=cfg.Name,TextColor3=NAEI.Theme.Text,TextSize=12,AutoButtonColor=false}) b.Parent=f b.Activated:Connect(function() if cfg.Callback then cfg.Callback() end) b.MouseEnter:Connect(function() Tween(f,0.12,{BackgroundColor3=NAEI.Theme.CardHover}) end) b.MouseLeave:Connect(function() Tween(f,0.12,{BackgroundColor3=NAEI.Theme.Card}) end) return f end
        function Tab:AddToggle(cfg) cfg=cfg or {} local s=cfg.Default==true local f=Create("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=NAEI.Theme.Card}) f.Parent=Page AddCorner(f,6) Create("TextLabel",{Size=UDim2.new(1,-65,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,Text=cfg.Name,TextColor3=NAEI.Theme.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left}).Parent=f local tg=Create("TextButton",{Size=UDim2.fromOffset(38,20),Position=UDim2.new(1,-50,0.5,-10),BackgroundColor3=s and NAEI.Theme.Primary or NAEI.Theme.ToggleOff,Text="",AutoButtonColor=false}) tg.Parent=f AddCorner(tg,10) local dot=Create("Frame",{Size=UDim2.fromOffset(14,14),Position=s and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),BackgroundColor3=Color3.new(1,1,1)}) dot.Parent=tg AddCorner(dot,10) local function U() Tween(tg,0.15,{BackgroundColor3=s and NAEI.Theme.Primary or NAEI.Theme.ToggleOff}) Tween(dot,0.15,{Position=s and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)}) if cfg.Callback then cfg.Callback(s) end end tg.Activated:Connect(function() s=not s U() end) return {Set=function(_,v)s=v==true U()end,Get=function()return s end} end
        return Tab
    end

    return Window
end

return NAEI
