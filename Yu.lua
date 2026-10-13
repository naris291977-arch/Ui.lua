--!strict
-- iOS 26 Halloween - Spooky Glass UI Kit v1.0 [CLEAN]
-- ธีม: ฮาโลวีน + Liquid Glass + ปุ่มลอย

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Kit = {}
Kit.Flags = {}

local T = {
    Bg = Color3.fromRGB(18, 10, 26),
    Glass = Color3.fromRGB(255, 255, 255),
    Card = Color3.fromRGB(38, 22, 48),
    Card2 = Color3.fromRGB(52, 30, 68),
    Primary = Color3.fromRGB(255, 135, 20), -- ส้มฟักทอง
    Primary2 = Color3.fromRGB(175, 80, 255), -- ม่วงฮาโลวีน
    Primary3 = Color3.fromRGB(255, 225, 120), -- เหลืองเทียน
    Text = Color3.fromRGB(255, 245, 235),
    Sub = Color3.fromRGB(200, 170, 150),
    Muted = Color3.fromRGB(120, 90, 110),
    Border = Color3.fromRGB(255, 180, 90),
}

-- UTILS
local function New(class, props)
    local o = Instance.new(class)
    for k,v in pairs(props or {}) do if k~="Parent" then pcall(function() o[k]=v end) end end
    if props and props.Parent then o.Parent = props.Parent end
    return o
end
local function Corner(o,r) return New("UICorner",{CornerRadius=UDim.new(0,r or 18), Parent=o}) end
local function Stroke(o,c,t,tk) return New("UIStroke",{Color=c or T.Border, Transparency=t or 0.5, Thickness=tk or 1, ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Parent=o}) end
local function Tween(o, info, prop) TweenService:Create(o, info, prop):Play() end
local function GetParent()
    local ok,g = pcall(function() return gethui() end)
    if ok and g then return g end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function AddGlow(parent, color, trans)
    local g = New("ImageLabel",{
        AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5), Size=UDim2.fromScale(1.9,1.9),
        BackgroundTransparency=1, Image="rbxassetid://5028857084", ImageColor3=color or T.Primary, ImageTransparency=trans or 0.7, ZIndex=-1, Parent=parent
    })
    task.spawn(function()
        while g.Parent do
            local t = math.random(7,13)/10
            Tween(g, TweenInfo.new(t, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = math.random(55,85)/100,
                Size = UDim2.fromScale(math.random(17,21)/10, math.random(17,21)/10)
            })
            task.wait(t)
        end
    end)
    return g
end

local function AddParticles(parent, count)
    for i=1, count or 16 do
        local p = New("Frame",{
            Size=UDim2.fromOffset(math.random(2,5), math.random(2,5)),
            Position=UDim2.fromScale(math.random(), math.random()),
            BackgroundColor3 = (i%3==0 and T.Primary2 or (i%2==0 and T.Primary or T.Primary3)),
            BorderSizePixel=0, Parent=parent
        })
        Corner(p,100)
        task.spawn(function()
            while p.Parent do
                local t = math.random(4,8)
                Tween(p, TweenInfo.new(t, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Position = UDim2.fromScale(math.random(), math.random())
                })
                task.wait(t)
            end
        end)
    end
end

function Kit:CreateWindow(cfg)
    cfg = cfg or {}
    local Gui = New("ScreenGui",{Name="iOS26_Halloween", ResetOnSpawn=false, IgnoreGuiInset=true, Parent=GetParent()})

    local Main = New("Frame",{
        AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
        Size=UDim2.fromOffset(0,0), BackgroundColor3=T.Bg, BackgroundTransparency=0.15, Parent=Gui
    })
    Corner(Main,32)
    local ms = Stroke(Main, T.Primary, 0.2, 2)
    local mg = New("UIGradient",{Color=ColorSequence.new(T.Primary, T.Primary2), Rotation=0, Parent=ms})
    AddParticles(Main, 18)

    Tween(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size=UDim2.fromOffset(620, 440)})
    RunService.Heartbeat:Connect(function(dt) mg.Rotation = (mg.Rotation + 25*dt) % 360 end)

    -- Header
    local Header = New("Frame",{Size=UDim2.new(1,0,0,64), BackgroundTransparency=1, Parent=Main})
    New("TextLabel",{
        Size=UDim2.new(1,-80,0,20), Position=UDim2.fromOffset(24,14),
        BackgroundTransparency=1, Text=cfg.Title or "🎃 Spooky Glass", TextColor3=T.Text, TextSize=20, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, Parent=Header
    })
    New("TextLabel",{
        Size=UDim2.new(1,-80,0,14), Position=UDim2.fromOffset(24,38),
        BackgroundTransparency=1, Text="iOS 26 • Halloween Edition", TextColor3=T.Primary3, TextSize=11, Font=Enum.Font.Code, TextXAlignment=Enum.TextXAlignment.Left, Parent=Header
    })
    local Close = New("TextButton",{Size=UDim2.fromOffset(32,32), Position=UDim2.new(1,-48,0,16), BackgroundColor3=T.Card2, Text="✕", TextColor3=T.Sub, TextSize=14, Font=Enum.Font.GothamBold, Parent=Header})
    Corner(Close,16); Stroke(Close, T.Border, 0.6,1)
    Close.MouseButton1Click:Connect(function()
        Tween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size=UDim2.fromOffset(0,0)})
        task.wait(0.3) Gui:Destroy()
    end)

    local Content = New("ScrollingFrame",{
        Size=UDim2.new(1,-20,1,-76), Position=UDim2.fromOffset(10,70),
        BackgroundTransparency=1, ScrollBarThickness=2, ScrollBarImageColor3=T.Primary, BorderSizePixel=0, CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y, Parent=Main
    })
    New("UIListLayout",{Padding=UDim.new(0,12), SortOrder=Enum.SortOrder.LayoutOrder, Parent=Content})
    New("UIPadding",{PaddingTop=UDim.new(0,6), PaddingLeft=UDim.new(0,4), PaddingRight=UDim.new(0,12), PaddingBottom=UDim.new(0,12), Parent=Content})

    local Window = {Gui=Gui, Main=Main}

    function Window:CreateFloatButton(fc)
        fc = fc or {}
        local size = fc.Size or 66
        local wrap = New("Frame",{Size=UDim2.fromOffset(size,size), Position=fc.Position or UDim2.new(1,-90,0.5,0), AnchorPoint=Vector2.new(0.5,0.5), BackgroundTransparency=1, Parent=Gui})

        local Btn = New("TextButton",{
            Size=UDim2.fromScale(1,1), BackgroundColor3=T.Glass, BackgroundTransparency=0.15,
            Text="", AutoButtonColor=false, ZIndex=50, Parent=wrap
        })
        Corner(Btn,size/2)
        local s = Stroke(Btn, T.Primary3, 0.3, 2)
        local g = New("UIGradient",{Color=ColorSequence.new(T.Primary, T.Primary2), Rotation=45, Parent=s})
        AddGlow(Btn, fc.GlowColor or T.Primary, 0.65)

        New("TextLabel",{
            Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text=fc.Icon or "🎃",
            TextSize=28, Font=Enum.Font.GothamBold, TextColor3=T.Text, ZIndex=51, Parent=Btn
        })

        -- ลากได้ + Snap ขอบ
        local dragging, start, startPos
        Btn.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dragging=true; start=i.Position; startPos=wrap.Position
                Tween(wrap, TweenInfo.new(0.15, Enum.EasingStyle.Back), {Size=UDim2.fromOffset(size*1.15,size*1.15)})
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local d = i.Position - start
                wrap.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if dragging then
                dragging=false
                Tween(wrap, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Size=UDim2.fromOffset(size,size)})
                local vp = workspace.CurrentCamera.ViewportSize
                local mid = wrap.AbsolutePosition.X
                local target = mid > vp.X/2 and 1 or 0
                local off = mid > vp.X/2 and -60 or 60
                Tween(wrap, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position=UDim2.new(target, off, wrap.Position.Y.Scale, wrap.Position.Y.Offset)})
            end
        end)
        Btn.MouseButton1Click:Connect(function()
            if not dragging and fc.Callback then
                Tween(wrap, TweenInfo.new(0.08), {Size=UDim2.fromOffset(size*0.9,size*0.9)})
                task.wait(0.08)
                Tween(wrap, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size=UDim2.fromOffset(size,size)})
                pcall(fc.Callback)
            end
        end)
        RunService.Heartbeat:Connect(function(dt) g.Rotation = (g.Rotation + 60*dt)%360 end)
        Tween(wrap, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size=UDim2.fromOffset(size,size)})
        return wrap
    end

    function Window:CreateTab(name, icon)
        local Section = New("Frame",{Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1, Parent=Content})
        New("UIListLayout",{Padding=UDim.new(0,10), Parent=Section})
        local Head = New("Frame",{Size=UDim2.new(1,0,0,24), BackgroundTransparency=1, Parent=Section})
        New("TextLabel",{Size=UDim2.new(1,0,1,0), Position=UDim2.fromOffset(6,0), BackgroundTransparency=1, Text=(icon or "🎃").." "..string.upper(name), TextColor3=T.Primary3, TextSize=12, Font=Enum.Font.Code, TextXAlignment=Enum.TextXAlignment.Left, Parent=Head})

        local Tab = {}
        local function Card(h)
            local f = New("Frame",{Size=UDim2.new(1,0,0,h), BackgroundColor3=T.Card, BackgroundTransparency=0.1, Parent=Section})
            Corner(f,18); Stroke(f, T.Border, 0.6,1)
            return f
        end
        function Tab:AddToggle(opt)
            opt=opt or {}
            local f = Card(56)
            New("TextLabel",{Size=UDim2.new(1,-90,0,18), Position=UDim2.fromOffset(16,10), BackgroundTransparency=1, Text=opt.Name or "Toggle", TextColor3=T.Text, TextSize=14, Font=Enum.Font.GothamMedium, TextXAlignment=Enum.TextXAlignment.Left, Parent=f})
            if opt.Desc then New("TextLabel",{Size=UDim2.new(1,-90,0,12), Position=UDim2.fromOffset(16,30), BackgroundTransparency=1, Text=opt.Desc, TextColor3=T.Muted, TextSize=11, Parent=f}) end
            local state = opt.Default or false
            local track = New("Frame",{Size=UDim2.fromOffset(52,30), Position=UDim2.new(1,-68,0.5,-15), BackgroundColor3=state and T.Primary or Color3.fromRGB(60,60,70), Parent=f})
            Corner(track,15)
            local thumb = New("Frame",{Size=UDim2.fromOffset(24,24), Position=state and UDim2.new(1,-27,0.5,-12) or UDim2.new(0,3,0.5,-12), BackgroundColor3=Color3.new(1,1,1), Parent=track})
            Corner(thumb,100)
            local btn = New("TextButton",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", Parent=f})
            btn.MouseButton1Click:Connect(function()
                state = not state
                Tween(track, TweenInfo.new(0.25), {BackgroundColor3=state and T.Primary or Color3.fromRGB(60,60,70)})
                Tween(thumb, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Position=state and UDim2.new(1,-27,0.5,-12) or UDim2.new(0,3,0.5,-12)})
                if opt.Callback then pcall(opt.Callback, state) end
            end)
            return f
        end
        function Tab:AddButton(opt)
            opt=opt or {}
            local f = Card(52)
            local b = New("TextButton",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", Parent=f})
            New("TextLabel",{Size=UDim2.new(1,-40,1,0), Position=UDim2.fromOffset(16,0), BackgroundTransparency=1, Text=opt.Name or "Button", TextColor3=T.Text, TextSize=14, Font=Enum.Font.GothamMedium, TextXAlignment=Enum.TextXAlignment.Left, Parent=b})
            b.MouseButton1Click:Connect(function() if opt.Callback then pcall(opt.Callback) end end)
            return f
        end
        function Tab:AddSlider(opt)
            opt=opt or {}
            local f = Card(70)
            New("TextLabel",{Size=UDim2.new(1,-20,0,18), Position=UDim2.fromOffset(16,10), BackgroundTransparency=1, Text=opt.Name or "Slider", TextColor3=T.Text, TextSize=13, Parent=f})
            return f
        end
        return Tab
    end
    return Window
end

return Kit