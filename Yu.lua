--[[
    UI Library Halloween Mini - iOS 26 Spooky Glass
    Base: Your Fluent UI (MIT)
    Upgrade: Small + Beautiful 1000x + Float + Glow
]]

local UIS, TS = game:GetService("UserInputService"), game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- ธีมฮาโลวีน เล็กลง สวยขึ้น
local C = {
    bg=Color3.fromRGB(18,12,26), -- ม่วงดำ
    sec=Color3.fromRGB(255,255,255), -- การ์ดขาวใส
    el=Color3.fromRGB(245,245,247),
    st=Color3.fromRGB(255,255,255),
    tx=Color3.fromRGB(28,28,32),
    sub=Color3.fromRGB(130,125,145),
    ac=Color3.fromRGB(255,135,20), -- ส้มฟักทอง
    ac2=Color3.fromRGB(175,85,255), -- ม่วงผี
    green=Color3.fromRGB(46,204,113),
    gray=Color3.fromRGB(210,210,215),
    red=Color3.fromRGB(235,87,87),
    orange=Color3.fromRGB(255,180,90),
    yellow=Color3.fromRGB(255,230,130)
}

local ICON = {
    home = "rbxthumb://type=Asset&id=279461711&w=150&h=150",
    key = "rbxthumb://type=Asset&id=10871266127&w=150&h=150",
    tick = "rbxthumb://type=Asset&id=14203226683&w=150&h=150",
    close = "rbxthumb://type=Asset&id=10152135074&w=150&h=150",
}

local function N(c,p,ch)
    local i=Instance.new(c)
    for k,v in pairs(p or {}) do if k~="Parent" then i[k]=v end end
    for _,x in ipairs(ch or {}) do x.Parent=i end
    i.Parent=p and p.Parent
    return i
end
local function R(r) return N("UICorner",{CornerRadius=UDim.new(0,r)}) end
local function S(col, t) return N("UIStroke",{Color=col or C.st, Transparency=t or 0.6, Thickness=1.2, ApplyStrokeMode=Enum.ApplyStrokeMode.Border}) end
local function T(i,p, tm) TS:Create(i, TweenInfo.new(tm or 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), p):Play() end
local function L(p) p.BackgroundTransparency=1 p.TextColor3=p.TextColor3 or C.tx p.Font=p.Font or Enum.Font.GothamMedium p.TextSize=p.TextSize or 12 p.TextXAlignment=p.TextXAlignment or Enum.TextXAlignment.Left return N("TextLabel",p) end
local function Ic(p) p.BackgroundTransparency=1 p.ScaleType=Enum.ScaleType.Fit return N("ImageLabel",p) end
local function pad(l,t,r,b) return N("UIPadding",{PaddingLeft=UDim.new(0,l), PaddingTop=UDim.new(0,t), PaddingRight=UDim.new(0,r), PaddingBottom=UDim.new(0,b)}) end
local function list(p) return N("UIListLayout",{Padding=UDim.new(0,p or 6), SortOrder=Enum.SortOrder.LayoutOrder}) end

local function mount()
    local g=N("ScreenGui",{Name="UI", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    pcall(function() g.Parent=(gethui and gethui()) or game:GetService("CoreGui") end)
    if not g.Parent then g.Parent=Players.LocalPlayer:WaitForChild("PlayerGui") end
    return g
end

local function drag(h,f)
    local d,ds,sp
    h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d,ds,sp=true,i.Position,f.Position end end)
    UIS.InputChanged:Connect(function(i) if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local v=i.Position-ds f.Position=UDim2.new(sp.X.Scale, sp.X.Offset+v.X, sp.Y.Scale, sp.Y.Offset+v.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end end)
end

-- แสงเรือง
local function AddGlow(parent, color)
    local gl = N("ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5), Size=UDim2.fromScale(1.8,1.8), BackgroundTransparency=1, Image="rbxassetid://5028857084", ImageColor3=color or C.ac, ImageTransparency=0.7, ZIndex=-1, Parent=parent})
    task.spawn(function()
        while gl.Parent do
            local t=math.random(7,12)/10
            TS:Create(gl, TweenInfo.new(t, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency=math.random(50,80)/100}):Play()
            task.wait(t)
        end
    end)
    return gl
end

local Lib = {Colors=C}

-- NOTIFY เล็กลง สวยขึ้น
function Lib.Notify(o)
    if type(o)=="string" then o={Content=o} end
    local col = o.Type=="success" and C.green or (o.Type=="error" and C.red or C.ac)
    local gui=mount() gui.Name="UINotify" gui.DisplayOrder=1000
    local holder=gui:FindFirstChild("Holder") or N("Frame",{Name="Holder", AnchorPoint=Vector2.new(1,1), Position=UDim2.new(1,-14,1,-14), Size=UDim2.new(0,260,1,-28), BackgroundTransparency=1, Parent=gui}, {N("UIListLayout",{Padding=UDim.new(0,6), VerticalAlignment=Enum.VerticalAlignment.Bottom})})

    local slot=N("Frame",{Size=UDim2.new(1,0,0,56), BackgroundTransparency=1, Parent=holder})
    local card=N("Frame",{Position=UDim2.new(1.3,0,0,0), Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.new(1,1,1), BackgroundTransparency=0.08, Parent=slot}, {R(14), S(Color3.new(1,1,1),0.5)})
    AddGlow(card, col, 0.6)
    L({Position=UDim2.fromOffset(14,8), Size=UDim2.new(1,-28,0,14), Text=o.Title or "🎃 Spooky", Font=Enum.Font.GothamBold, TextSize=12, Parent=card})
    L({Position=UDim2.fromOffset(14,24), Size=UDim2.new(1,-28,0,24), Text=o.Content or "", TextColor3=C.sub, TextSize=11, TextWrapped=true, Parent=card})
    TS:Create(card, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position=UDim2.new(0,0,0,0)}):Play()
    task.delay(o.Duration or 3, function() TS:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position=UDim2.new(1.3,0,0,0)}):Play() task.wait(0.3) slot:Destroy() end)
end

-- MAIN UI เล็กลง 480x340
function Lib.new(title, logo)
    local gui=mount()
    local FULL, MINI = UDim2.fromOffset(480,340), UDim2.fromOffset(480,48) -- เล็กลงจาก 560,390
    local main=N("Frame",{AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5), Size=UDim2.fromOffset(0,0), BackgroundColor3=Color3.fromRGB(250,250,252), BackgroundTransparency=0.08, Active=true, ClipsDescendants=true, Parent=gui}, {R(22), S(Color3.new(1,1,1),0.6)})
    local gradStroke = N("UIGradient",{Color=ColorSequence.new(C.ac, C.ac2), Rotation=45, Parent=main:FindFirstChildOfClass("UIStroke")})
    RunService.Heartbeat:Connect(function(dt) gradStroke.Rotation=(gradStroke.Rotation+18*dt)%360 end)
    AddGlow(main, C.ac)

    Tween(main, {Size=FULL}, 0.6, Enum.EasingStyle.Back)

    local top=N("Frame",{Size=UDim2.new(1,0,0,44), BackgroundTransparency=1, Parent=main})
    drag(top, main)
    local lg=N("Frame",{Position=UDim2.fromOffset(12,8), Size=UDim2.fromOffset(28,28), BackgroundColor3=C.ac, Parent=top}, {R(10)})
    if logo and logo~="" then Ic({Size=UDim2.fromScale(1,1), Image=logo, Parent=lg}) else Ic({AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5), Size=UDim2.fromOffset(16,16), Image=ICON.home, ImageColor3=Color3.new(1,1,1), Parent=lg}) end
    L({Position=UDim2.fromOffset(48,0), Size=UDim2.fromOffset(140,44), Text=title or "🎃 Mini", Font=Enum.Font.GothamBold, TextSize=14, Parent=top})

    local bar=N("Frame",{Position=UDim2.fromOffset(180,8), Size=UDim2.new(1,-260,0,28), BackgroundTransparency=1, Parent=top}, {N("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,6)})})
    local pages=N("Frame",{Position=UDim2.fromOffset(10,50), Size=UDim2.new(1,-20,1,-94), BackgroundTransparency=1, Parent=main})

    -- Footer เล็ก
    local lp=Players.LocalPlayer
    local foot=N("Frame",{AnchorPoint=Vector2.new(0,1), Position=UDim2.new(0,10,1,-8), Size=UDim2.new(1,-20,0,32), BackgroundColor3=Color3.new(1,1,1), BackgroundTransparency=0.4, Parent=main}, {R(12), S(Color3.new(1,1,1),0.5)})
    N("ImageLabel",{Position=UDim2.fromOffset(6,4), Size=UDim2.fromOffset(24,24), BackgroundColor3=C.el, Image="rbxthumb://type=AvatarHeadShot&id="..lp.UserId.."&w=150&h=150", Parent=foot}, {R(100)})
    L({Position=UDim2.fromOffset(36,2), Size=UDim2.new(0.6,-36,0,14), Text=lp.DisplayName, Font=Enum.Font.GothamBold, TextSize=11, Parent=foot})
    L({Position=UDim2.fromOffset(36,16), Size=UDim2.new(0.6,-36,0,10), Text="🎃 Halloween Mini", TextColor3=C.sub, TextSize=10, Parent=foot})

    local closeB=N("TextButton",{AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0), Size=UDim2.fromOffset(26,26), BackgroundColor3=Color3.fromRGB(235,235,240), Text="", AutoButtonColor=false, Parent=top}, {R(13)})
    Ic({AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5), Size=UDim2.fromOffset(12,12), Image=ICON.close, ImageColor3=C.tx, Parent=closeB})
    closeB.MouseButton1Click:Connect(function() Tween(main, {Size=UDim2.fromOffset(0,0)}, 0.3, Enum.EasingStyle.Back) task.wait(0.3) gui:Destroy() end)

    local W, tabs={}={}
    function W:Tab(name, icon)
        local b=N("TextButton",{Size=UDim2.new(0,0,1,0), AutomaticSize=Enum.AutomaticSize.X, Text=name, Font=Enum.Font.GothamMedium, TextSize=11, AutoButtonColor=false, BackgroundColor3=Color3.new(1,1,1), BackgroundTransparency=0.6, TextColor3=C.sub, Parent=bar}, {R(10), pad(12,0,12,0), S(Color3.new(1,1,1),0.5)})
        local pg=N("Frame",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Visible=false, Parent=pages})
        local col=N("ScrollingFrame",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, ScrollBarThickness=0, AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(), Parent=pg}, {list(6)})
        local t={b=b, pg=pg}
        table.insert(tabs,t)
        local function sel()
            for _,x in ipairs(tabs) do
                local on=(x==t)
                x.pg.Visible=on
                T(x.b, {BackgroundColor3=on and C.ac or Color3.new(1,1,1), BackgroundTransparency=on and 0.1 or 0.6, TextColor3=on and Color3.new(1,1,1) or C.sub})
            end
        end
        b.MouseButton1Click:Connect(sel)
        if #tabs==1 then sel() end

        local Tb={}
        function Tb:Section(name)
            L({Size=UDim2.new(1,0,0,16), Text=string.upper(name), TextColor3=C.ac, TextSize=10, Font=Enum.Font.Code, Parent=col})
            local s={}
            local function row(h) return N("Frame",{Size=UDim2.new(1,0,0,h), BackgroundColor3=Color3.new(1,1,1), BackgroundTransparency=0.25, Parent=col}, {R(12), S(Color3.new(1,1,1),0.5)}) end
            function s:Toggle(name, on, cb)
                local r=row(38)
                L({Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(12,0), Text=name, TextSize=12, Parent=r})
                local tr=N("Frame",{AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-12,0.5,0), Size=UDim2.fromOffset(36,22), BackgroundColor3=on and C.ac or Color3.fromRGB(200,200,210), Parent=r}, {R(11)})
                local th=N("Frame",{Size=UDim2.fromOffset(16,16), Position=on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8), BackgroundColor3=Color3.new(1,1,1), Parent=tr}, {R(100)})
                N("TextButton",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", Parent=r}).MouseButton1Click:Connect(function()
                    on=not on T(tr, {BackgroundColor3=on and C.ac or Color3.fromRGB(200,200,210)}) TS:Create(th, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Position=on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)}):Play() if cb then cb(on) end
                end)
            end
            function s:Button(name, cb)
                local b=row(38)
                local btn=N("TextButton",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", Parent=b})
                L({Size=UDim2.new(1,-20,1,0), Position=UDim2.fromOffset(12,0), Text=name, TextSize=12, Parent=btn})
                L({AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-12,0.5,0), Size=UDim2.fromOffset(16,16), Text="›", TextSize=16, TextColor3=C.sub, TextXAlignment=Right, Parent=btn})
                btn.MouseEnter:Connect(function() T(b, {BackgroundTransparency=0.05}) end)
                btn.MouseLeave:Connect(function() T(b, {BackgroundTransparency=0.25}) end)
                btn.MouseButton1Click:Connect(function() if cb then cb() end end)
            end
            function s:Slider(name, min, max, def, cb)
                local r=row(48)
                L({Size=UDim2.new(1,-20,0,16), Position=UDim2.fromOffset(12,6), Text=name, TextSize=11, Parent=r})
                local sb=N("Frame",{Position=UDim2.fromOffset(12,30), Size=UDim2.new(1,-24,0,4), BackgroundColor3=Color3.fromRGB(220,220,225), Parent=r}, {R(2)})
                local fl=N("Frame",{Size=UDim2.fromScale((def-min)/(max-min),1), BackgroundColor3=C.ac, Parent=sb}, {R(2)})
            end
            function s:Dropdown(name, opts, def, cb) s:Button(name.." ▾ "..tostring(def or opts[1]), function() if cb then cb(def or opts[1]) end end) end
            function s:MultiDropdown(name, opts, def, cb) s:Button(name.." (Multi)", function() if cb then cb(def) end end) end
            return s
        end
        return Tb
    end

    -- ระบบปุ่มลอยใหม่ เล็ก 54px
    function W:CreateFloatButton(opt)
        opt=opt or {}
        local fg=mount() fg.Name="Float_"..(opt.Name or "Btn") fg.DisplayOrder=20
        local size=54
        local b=N("TextButton",{Size=UDim2.fromOffset(size,size), Position=opt.Position or UDim2.new(1,-70,0.5,0), AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.new(1,1,1), BackgroundTransparency=0.08, Text="", AutoButtonColor=false, Parent=fg}, {R(size/2), S(Th and Th.Yellow or C.yellow, 0.2)})
        local st=b:FindFirstChildOfClass("UIStroke")
        local grad=N("UIGradient",{Color=ColorSequence.new(C.ac, C.ac2), Rotation=45, Parent=st})
        AddGlow(b, opt.Color or C.ac)
        L({Size=UDim2.fromScale(1,1), Text=opt.Icon or "🎃", TextSize=24, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Center, TextYAlignment=Enum.TextYAlignment.Center, Parent=b})
        RunService.Heartbeat:Connect(function(dt) grad.Rotation=(grad.Rotation+35*dt)%360 end)
        local dragging,start,sPos
        b.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true start=i.Position sPos=b.Position end end)
        UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-start b.Position=UDim2.new(sPos.X.Scale, sPos.X.Offset+d.X, sPos.Y.Scale, sPos.Y.Offset+d.Y) end end)
        UIS.InputEnded:Connect(function() dragging=false end)
        b.MouseButton1Click:Connect(function() if opt.Callback then pcall(opt.Callback) end end)
        TS:Create(b, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size=UDim2.fromOffset(size,size)}):Play()
        return b
    end

    function W:Destroy() gui:Destroy() end
    function W:Notify(o) return Lib.Notify(o) end

    return W
end

return Lib