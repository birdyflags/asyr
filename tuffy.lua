local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Centrixity = {}

local Theme = {
    Background = Color3.fromRGB(19, 20, 25),
    Secondary = Color3.fromRGB(16, 17, 21),
    Tertiary = Color3.fromRGB(24, 25, 32),
    Accent = Color3.fromRGB(255, 127, 0),
    AccentSecondary = Color3.fromRGB(255, 200, 87),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(69, 71, 90),
    Stroke = Color3.fromRGB(28, 30, 38),
    Divider = Color3.fromRGB(31, 31, 45),
    Success = Color3.fromRGB(47, 255, 0),
    Warning = Color3.fromRGB(255, 214, 10),
    Error = Color3.fromRGB(255, 75, 75)
}

local Fonts = {
    Regular = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    Medium = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
    Bold = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
}

local function Tween(obj, props, dur, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function TweenSmooth(obj, props, dur)
    return Tween(obj, props, dur or 0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
end

local function TweenBounce(obj, props, dur)
    return Tween(obj, props, dur or 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

local function TweenSpring(obj, props, dur)
    return Tween(obj, props, dur or 0.35, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
end

local function Corner(p, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r or 6) c.Parent = p return c end
local function Stroke(p, col, th) local s = Instance.new("UIStroke") s.Color = col or Theme.Stroke s.Thickness = th or 1 s.Parent = p return s end
local function Gradient(p, rot) local g = Instance.new("UIGradient") g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Theme.Accent), ColorSequenceKeypoint.new(1, Theme.AccentSecondary)}) g.Rotation = rot or 0 g.Parent = p return g end

local function Ripple(parent, x, y, color)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(0, x, 0, y)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.BackgroundColor3 = color or Theme.Text
    ripple.BackgroundTransparency = 0.7
    ripple.ZIndex = 10
    ripple.Parent = parent
    Corner(ripple, 100)
    
    local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.5
    Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.6, Enum.EasingStyle.Quint)
    task.delay(0.6, function() ripple:Destroy() end)
end

local function MakeDraggable(frame, handle)
    local drag, start, sPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            start = i.Position
            sPos = frame.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - start
            TweenSmooth(frame, {Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)}, 0.08)
        end
    end)
end

function Centrixity:CreateWindow(config)
    config = config or {}
    local Window = {Tabs = {}, ActiveTab = nil}
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CentrixityUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = (RunService:IsStudio() and Player:WaitForChild("PlayerGui")) or game:GetService("CoreGui")
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.BackgroundColor3 = Theme.Background
    Main.BackgroundTransparency = 1
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    Corner(Main, 12)
    
    TweenBounce(Main, {Size = config.Size or UDim2.new(0, 689, 0, 489), BackgroundTransparency = 0}, 0.6)
    
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 37)
    Header.BackgroundTransparency = 1
    Header.Parent = Main
    
    local HLine = Instance.new("Frame")
    HLine.AnchorPoint = Vector2.new(0, 1)
    HLine.Position = UDim2.new(0, 0, 1, 0)
    HLine.Size = UDim2.new(0, 0, 0, 2)
    HLine.BackgroundColor3 = Theme.Divider
    HLine.BorderSizePixel = 0
    HLine.Parent = Header
    task.delay(0.3, function() TweenSmooth(HLine, {Size = UDim2.new(1, 0, 0, 2)}, 0.5) end)
    
    local Icon = Instance.new("ImageLabel")
    Icon.Position = UDim2.new(0, 12, 0, 2)
    Icon.Size = UDim2.new(0, 34, 0, 34)
    Icon.BackgroundTransparency = 1
    Icon.Image = config.Icon or "rbxassetid://137946959393180"
    Icon.ScaleType = Enum.ScaleType.Fit
    Icon.ImageTransparency = 1
    Icon.Parent = Header
    task.delay(0.2, function() TweenSmooth(Icon, {ImageTransparency = 0, Rotation = 360}, 0.6) end)
    
    local Title = Instance.new("TextLabel")
    Title.Position = UDim2.new(0, 52, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = (config.Title or "Centrixity") .. ' <font color="#45475a">' .. (config.Subtitle or "") .. '</font>'
    Title.RichText = true
    Title.TextColor3 = Theme.Text
    Title.TextTransparency = 1
    Title.FontFace = Fonts.Medium
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    task.delay(0.35, function() TweenSmooth(Title, {TextTransparency = 0}, 0.4) end)
    
    MakeDraggable(Main, Header)
    
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Position = UDim2.new(0, 0, 0, 37)
    Sidebar.Size = UDim2.new(0, 75, 1, -37)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = Main
    
    local SLine = Instance.new("Frame")
    SLine.AnchorPoint = Vector2.new(1, 0)
    SLine.Position = UDim2.new(1, 0, 0, 0)
    SLine.Size = UDim2.new(0, 2, 0, 0)
    SLine.BackgroundColor3 = Theme.Divider
    SLine.BorderSizePixel = 0
    SLine.Parent = Sidebar
    task.delay(0.4, function() TweenSmooth(SLine, {Size = UDim2.new(0, 2, 1, 0)}, 0.5) end)
    
    local TabList = Instance.new("Frame")
    TabList.Size = UDim2.new(1, 0, 1, 0)
    TabList.BackgroundTransparency = 1
    TabList.Parent = Sidebar
    
    local TLayout = Instance.new("UIListLayout")
    TLayout.Padding = UDim.new(0, 5)
    TLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TLayout.Parent = TabList
    
    local TPad = Instance.new("UIPadding")
    TPad.PaddingTop = UDim.new(0, 10)
    TPad.Parent = TabList
    
    local SubHeader = Instance.new("Frame")
    SubHeader.Name = "SubHeader"
    SubHeader.Position = UDim2.new(0, 77, 0, 37)
    SubHeader.Size = UDim2.new(1, -77, 0, 51)
    SubHeader.BackgroundTransparency = 1
    SubHeader.Parent = Main
    
    local SHLayout = Instance.new("UIListLayout")
    SHLayout.Padding = UDim.new(0, 8)
    SHLayout.FillDirection = Enum.FillDirection.Horizontal
    SHLayout.Parent = SubHeader
    
    local SHPad = Instance.new("UIPadding")
    SHPad.PaddingTop = UDim.new(0, 4)
    SHPad.PaddingLeft = UDim.new(0, 20)
    SHPad.Parent = SubHeader
    
    local PageHolder = Instance.new("Frame")
    PageHolder.Name = "PageHolder"
    PageHolder.Position = UDim2.new(0, 77, 0, 88)
    PageHolder.Size = UDim2.new(1, -77, 1, -88)
    PageHolder.BackgroundColor3 = Theme.Secondary
    PageHolder.BackgroundTransparency = 1
    PageHolder.ClipsDescendants = true
    PageHolder.Parent = Main
    Corner(PageHolder, 12)
    task.delay(0.5, function() TweenSmooth(PageHolder, {BackgroundTransparency = 0}, 0.4) end)
    
    local NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "Notifs"
    NotifHolder.Position = UDim2.new(0, 12, 0, 12)
    NotifHolder.Size = UDim2.new(0, 280, 1, -24)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Parent = ScreenGui
    
    local NLayout = Instance.new("UIListLayout")
    NLayout.Padding = UDim.new(0, 10)
    NLayout.Parent = NotifHolder
    
    function Window:Notify(cfg)
        cfg = cfg or {}
        local nType = cfg.Type or "Success"
        local nTitle = cfg.Title or "Notification"
        local nContent = cfg.Content or ""
        local nDuration = cfg.Duration or 5
        local nButtons = cfg.Buttons or {}
        
        local colors = {
            Success = {c = Theme.Success, i = "rbxassetid://92431556586885"},
            Warning = {c = Theme.Warning, i = "rbxassetid://70479764730792"},
            Error = {c = Theme.Error, i = "rbxassetid://138617501067622"}
        }
        local st = colors[nType] or colors.Success
        
        local Notif = Instance.new("Frame")
        Notif.Name = "Notif"
        Notif.Size = UDim2.new(1, 0, 0, 38)
        Notif.AutomaticSize = Enum.AutomaticSize.Y
        Notif.BackgroundColor3 = Theme.Secondary
        Notif.BackgroundTransparency = 1
        Notif.ClipsDescendants = true
        Notif.Parent = NotifHolder
        Corner(Notif, 10)
        
        local NGlow = Instance.new("ImageLabel")
        NGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        NGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
        NGlow.Size = UDim2.new(1, 40, 1, 40)
        NGlow.BackgroundTransparency = 1
        NGlow.Image = "rbxassetid://5028857084"
        NGlow.ImageColor3 = st.c
        NGlow.ImageTransparency = 0.95
        NGlow.ScaleType = Enum.ScaleType.Slice
        NGlow.SliceCenter = Rect.new(24, 24, 276, 276)
        NGlow.ZIndex = 0
        NGlow.Parent = Notif
        
        local NHeader = Instance.new("Frame")
        NHeader.Size = UDim2.new(1, 0, 0, 38)
        NHeader.BackgroundTransparency = 1
        NHeader.Parent = Notif
        
        local NIcon = Instance.new("ImageLabel")
        NIcon.Position = UDim2.new(0, 12, 0, 9)
        NIcon.Size = UDim2.new(0, 20, 0, 20)
        NIcon.BackgroundTransparency = 1
        NIcon.Image = st.i
        NIcon.ImageColor3 = st.c
        NIcon.ImageTransparency = 1
        NIcon.Parent = NHeader
        
        local NTitle = Instance.new("TextLabel")
        NTitle.Position = UDim2.new(0, 40, 0, 0)
        NTitle.Size = UDim2.new(1, -80, 0, 38)
        NTitle.BackgroundTransparency = 1
        NTitle.Text = nTitle
        NTitle.TextColor3 = Theme.Text
        NTitle.TextTransparency = 1
        NTitle.FontFace = Fonts.Medium
        NTitle.TextSize = 14
        NTitle.TextXAlignment = Enum.TextXAlignment.Left
        NTitle.TextTruncate = Enum.TextTruncate.AtEnd
        NTitle.Parent = NHeader
        
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
        CloseBtn.Position = UDim2.new(1, -10, 0.5, 0)
        CloseBtn.Size = UDim2.new(0, 20, 0, 20)
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.Text = "×"
        CloseBtn.TextColor3 = Theme.TextDark
        CloseBtn.TextTransparency = 1
        CloseBtn.FontFace = Fonts.Bold
        CloseBtn.TextSize = 18
        CloseBtn.Parent = NHeader
        
        local ContentHolder = Instance.new("Frame")
        ContentHolder.Name = "Content"
        ContentHolder.Position = UDim2.new(0, 0, 0, 38)
        ContentHolder.Size = UDim2.new(1, 0, 0, 0)
        ContentHolder.AutomaticSize = Enum.AutomaticSize.Y
        ContentHolder.BackgroundTransparency = 1
        ContentHolder.Parent = Notif
        
        if nContent ~= "" then
            local NText = Instance.new("TextLabel")
            NText.Position = UDim2.new(0, 14, 0, 0)
            NText.Size = UDim2.new(1, -28, 0, 0)
            NText.AutomaticSize = Enum.AutomaticSize.Y
            NText.BackgroundTransparency = 1
            NText.Text = nContent
            NText.TextColor3 = Theme.TextDark
            NText.TextTransparency = 1
            NText.FontFace = Fonts.Regular
            NText.TextSize = 13
            NText.TextXAlignment = Enum.TextXAlignment.Left
            NText.TextWrapped = true
            NText.Parent = ContentHolder
            task.delay(0.2, function() TweenSmooth(NText, {TextTransparency = 0}, 0.3) end)
        end
        
        if #nButtons > 0 then
            local BtnHolder = Instance.new("Frame")
            BtnHolder.Position = UDim2.new(0, 14, 0, nContent ~= "" and 28 or 4)
            BtnHolder.Size = UDim2.new(1, -28, 0, 30)
            BtnHolder.BackgroundTransparency = 1
            BtnHolder.Parent = ContentHolder
            
            local BLayout = Instance.new("UIListLayout")
            BLayout.Padding = UDim.new(0, 8)
            BLayout.FillDirection = Enum.FillDirection.Horizontal
            BLayout.Parent = BtnHolder
            
            for idx, btn in ipairs(nButtons) do
                local B = Instance.new("TextButton")
                B.Size = UDim2.new(0, 70, 0, 28)
                B.AutomaticSize = Enum.AutomaticSize.X
                B.BackgroundColor3 = idx == 1 and st.c or Theme.Tertiary
                B.BackgroundTransparency = idx == 1 and 0.85 or 0
                B.Text = ""
                B.Parent = BtnHolder
                Corner(B, 6)
                if idx > 1 then Stroke(B, Theme.TextDark) end
                
                local BT = Instance.new("TextLabel")
                BT.Size = UDim2.new(1, 0, 1, 0)
                BT.BackgroundTransparency = 1
                BT.Text = btn.Name or "Button"
                BT.TextColor3 = idx == 1 and st.c or Theme.TextDark
                BT.FontFace = Fonts.Medium
                BT.TextSize = 12
                BT.Parent = B
                
                local BPad = Instance.new("UIPadding")
                BPad.PaddingLeft = UDim.new(0, 14)
                BPad.PaddingRight = UDim.new(0, 14)
                BPad.Parent = B
                
                B.MouseButton1Click:Connect(function()
                    local pos = UserInputService:GetMouseLocation()
                    Ripple(B, pos.X - B.AbsolutePosition.X, pos.Y - B.AbsolutePosition.Y - 36, st.c)
                    TweenSmooth(B, {Size = UDim2.new(0, 65, 0, 26)}, 0.1)
                    task.wait(0.1)
                    TweenBounce(B, {Size = UDim2.new(0, 70, 0, 28)}, 0.2)
                    if btn.Callback then btn.Callback() end
                    TweenSmooth(Notif, {Position = UDim2.new(-1.2, 0, 0, 0), BackgroundTransparency = 1}, 0.35)
                    task.delay(0.4, function() Notif:Destroy() end)
                end)
                
                B.MouseEnter:Connect(function()
                    TweenSmooth(B, {BackgroundTransparency = idx == 1 and 0.7 or 0.1}, 0.2)
                    TweenSmooth(BT, {TextColor3 = Theme.Text}, 0.2)
                end)
                B.MouseLeave:Connect(function()
                    TweenSmooth(B, {BackgroundTransparency = idx == 1 and 0.85 or 0}, 0.2)
                    TweenSmooth(BT, {TextColor3 = idx == 1 and st.c or Theme.TextDark}, 0.2)
                end)
            end
        end
        
        local ProgressBG = Instance.new("Frame")
        ProgressBG.AnchorPoint = Vector2.new(0, 1)
        ProgressBG.Position = UDim2.new(0, 0, 1, 0)
        ProgressBG.Size = UDim2.new(1, 0, 0, 3)
        ProgressBG.BackgroundColor3 = Theme.Tertiary
        ProgressBG.BackgroundTransparency = 0.5
        ProgressBG.BorderSizePixel = 0
        ProgressBG.Parent = Notif
        
        local Progress = Instance.new("Frame")
        Progress.Size = UDim2.new(1, 0, 1, 0)
        Progress.BackgroundColor3 = st.c
        Progress.BorderSizePixel = 0
        Progress.Parent = ProgressBG
        Corner(Progress, 2)
        
        local BottomPad = Instance.new("Frame")
        BottomPad.Position = UDim2.new(0, 0, 0, nContent ~= "" and 32 or 8)
        BottomPad.Size = UDim2.new(1, 0, 0, #nButtons > 0 and 42 or 10)
        BottomPad.BackgroundTransparency = 1
        BottomPad.Parent = ContentHolder
        
        Notif.Position = UDim2.new(-1.2, 0, 0, 0)
        TweenBounce(Notif, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0}, 0.5)
        task.delay(0.1, function() TweenSmooth(NIcon, {ImageTransparency = 0, Rotation = 360}, 0.5) end)
        task.delay(0.15, function() TweenSmooth(NTitle, {TextTransparency = 0}, 0.3) end)
        task.delay(0.2, function() TweenSmooth(CloseBtn, {TextTransparency = 0}, 0.3) end)
        
        local startTime = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            local remaining = math.max(0, nDuration - elapsed)
            Progress.Size = UDim2.new(remaining / nDuration, 0, 1, 0)
            if remaining <= 0 then
                conn:Disconnect()
                TweenSmooth(Notif, {Position = UDim2.new(-1.2, 0, 0, 0), BackgroundTransparency = 1}, 0.4)
                task.delay(0.45, function() Notif:Destroy() end)
            end
        end)
        
        CloseBtn.MouseButton1Click:Connect(function()
            conn:Disconnect()
            TweenSmooth(CloseBtn, {Rotation = 90}, 0.15)
            TweenSmooth(Notif, {Position = UDim2.new(-1.2, 0, 0, 0), BackgroundTransparency = 1}, 0.35)
            task.delay(0.4, function() Notif:Destroy() end)
        end)
        
        CloseBtn.MouseEnter:Connect(function() TweenSmooth(CloseBtn, {TextColor3 = Theme.Error, Rotation = 90}, 0.2) end)
        CloseBtn.MouseLeave:Connect(function() TweenSmooth(CloseBtn, {TextColor3 = Theme.TextDark, Rotation = 0}, 0.2) end)
    end
    
    function Window:CreateTab(cfg)
        cfg = cfg or {}
        local tabName = cfg.Name or "Tab"
        local tabIcon = cfg.Icon or "rbxassetid://80869096876893"
        
        local Tab = {SubPages = {}, ActiveSubPage = nil, Name = tabName}
        local isFirst = #Window.Tabs == 0
        local tabIndex = #Window.Tabs + 1
        table.insert(Window.Tabs, Tab)
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName
        TabBtn.Size = UDim2.new(0, 55, 0, 60)
        TabBtn.BackgroundColor3 = Theme.Text
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.ClipsDescendants = true
        TabBtn.Parent = TabList
        Corner(TabBtn, 8)
        
        local TGrad = Gradient(TabBtn)
        TGrad.Enabled = false
        
        local TIcon = Instance.new("ImageLabel")
        TIcon.AnchorPoint = Vector2.new(0.5, 0)
        TIcon.Position = UDim2.new(0.5, 0, 0, 10)
        TIcon.Size = UDim2.new(0, 22, 0, 22)
        TIcon.BackgroundTransparency = 1
        TIcon.Image = tabIcon
        TIcon.ImageColor3 = Theme.TextDark
        TIcon.ImageTransparency = 1
        TIcon.Parent = TabBtn
        
        local TLabel = Instance.new("TextLabel")
        TLabel.AnchorPoint = Vector2.new(0.5, 0)
        TLabel.Position = UDim2.new(0.5, 0, 0, 34)
        TLabel.Size = UDim2.new(1, 0, 0, 14)
        TLabel.BackgroundTransparency = 1
        TLabel.Text = tabName
        TLabel.TextColor3 = Theme.TextDark
        TLabel.TextTransparency = 1
        TLabel.FontFace = Fonts.Bold
        TLabel.TextSize = 11
        TLabel.Parent = TabBtn
        
        local Indicator = Instance.new("Frame")
        Indicator.AnchorPoint = Vector2.new(0.5, 1)
        Indicator.Position = UDim2.new(0.5, 0, 1, 3)
        Indicator.Size = UDim2.new(0, 0, 0, 5)
        Indicator.BackgroundColor3 = Theme.Text
        Indicator.Parent = TabBtn
        Corner(Indicator, 10)
        Gradient(Indicator)
        
        task.delay(0.4 + tabIndex * 0.1, function()
            TweenSmooth(TIcon, {ImageTransparency = 0}, 0.3)
            TweenSmooth(TLabel, {TextTransparency = 0}, 0.3)
            if isFirst then
                TGrad.Enabled = true
                TweenSmooth(TabBtn, {BackgroundTransparency = 0.88}, 0.3)
                TweenSmooth(TIcon, {ImageColor3 = Theme.Accent}, 0.3)
                TweenSmooth(TLabel, {TextColor3 = Theme.Text}, 0.3)
                TweenBounce(Indicator, {Size = UDim2.new(0, 25, 0, 5)}, 0.4)
            end
        end)
        
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabName
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Theme.Accent
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.Visible = isFirst
        TabPage.Parent = PageHolder
        
        if isFirst then Window.ActiveTab = Tab end
        
        local function Select()
            if Window.ActiveTab == Tab then return end
            
            for _, t in pairs(Window.Tabs) do
                local btn = TabList:FindFirstChild(t.Name)
                if btn then
                    TweenSmooth(btn, {BackgroundTransparency = 1}, 0.25)
                    local g = btn:FindFirstChildOfClass("UIGradient")
                    if g then g.Enabled = false end
                    local ic = btn:FindFirstChild("ImageLabel")
                    if ic then TweenSmooth(ic, {ImageColor3 = Theme.TextDark}, 0.25) end
                    local lb = btn:FindFirstChild("TextLabel")
                    if lb then TweenSmooth(lb, {TextColor3 = Theme.TextDark}, 0.25) end
                    for _, ch in pairs(btn:GetChildren()) do
                        if ch:IsA("Frame") and ch.Name ~= "Ripple" then TweenSmooth(ch, {Size = UDim2.new(0, 0, 0, 5)}, 0.25) end
                    end
                end
                local pg = PageHolder:FindFirstChild(t.Name)
                if pg then
                    TweenSmooth(pg, {Position = UDim2.new(0, 0, 0.05, 0)}, 0.2)
                    task.delay(0.15, function() pg.Visible = false pg.Position = UDim2.new(0, 0, 0, 0) end)
                end
            end
            
            for _, ch in pairs(SubHeader:GetChildren()) do
                if ch:IsA("TextButton") then ch:Destroy() end
            end
            
            Window.ActiveTab = Tab
            TGrad.Enabled = true
            TweenSmooth(TabBtn, {BackgroundTransparency = 0.88}, 0.25)
            TweenSmooth(TIcon, {ImageColor3 = Theme.Accent}, 0.25)
            TweenSmooth(TLabel, {TextColor3 = Theme.Text}, 0.25)
            TweenBounce(Indicator, {Size = UDim2.new(0, 25, 0, 5)}, 0.35)
            
            TabPage.Position = UDim2.new(0, 0, -0.03, 0)
            TabPage.Visible = true
            TweenSmooth(TabPage, {Position = UDim2.new(0, 0, 0, 0)}, 0.35)
            
            Tab.ActiveSubPage = nil
            for i, sp in ipairs(Tab.SubPages) do
                sp:BuildButton(i == 1)
                local content = TabPage:FindFirstChild(sp.Name)
                if content then content.Visible = (i == 1) end
            end
            if Tab.SubPages[1] then Tab.ActiveSubPage = Tab.SubPages[1] end
        end
        
        TabBtn.MouseButton1Click:Connect(function()
            local pos = UserInputService:GetMouseLocation()
            Ripple(TabBtn, pos.X - TabBtn.AbsolutePosition.X, pos.Y - TabBtn.AbsolutePosition.Y - 36, Theme.Accent)
            Select()
        end)
        
        TabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                TweenSmooth(TabBtn, {BackgroundTransparency = 0.95}, 0.2)
                TweenSmooth(TIcon, {ImageColor3 = Theme.Text}, 0.2)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                TweenSmooth(TabBtn, {BackgroundTransparency = 1}, 0.2)
                TweenSmooth(TIcon, {ImageColor3 = Theme.TextDark}, 0.2)
            end
        end)
        
        function Tab:CreateSubPage(cfg)
            cfg = cfg or {}
            local spName = cfg.Name or "SubPage"
            
            local SubPage = {Name = spName, Sections = {}}
            local isFirstSP = #Tab.SubPages == 0
            table.insert(Tab.SubPages, SubPage)
            
            local SPContent = Instance.new("Frame")
            SPContent.Name = spName
            SPContent.Size = UDim2.new(1, 0, 0, 0)
            SPContent.AutomaticSize = Enum.AutomaticSize.Y
            SPContent.BackgroundTransparency = 1
            SPContent.Visible = isFirstSP and isFirst
            SPContent.Parent = TabPage
            
            local SPLayout = Instance.new("UIListLayout")
            SPLayout.Padding = UDim.new(0, 12)
            SPLayout.FillDirection = Enum.FillDirection.Horizontal
            SPLayout.Parent = SPContent
            
            local SPPad = Instance.new("UIPadding")
            SPPad.PaddingTop = UDim.new(0, 12)
            SPPad.PaddingLeft = UDim.new(0, 12)
            SPPad.PaddingRight = UDim.new(0, 12)
            SPPad.PaddingBottom = UDim.new(0, 12)
            SPPad.Parent = SPContent
            
            if isFirstSP then Tab.ActiveSubPage = SubPage end
            
            function SubPage:BuildButton(active)
                local SPBtn = Instance.new("TextButton")
                SPBtn.Name = spName
                SPBtn.Size = UDim2.new(0, 0, 0, 34)
                SPBtn.AutomaticSize = Enum.AutomaticSize.X
                SPBtn.BackgroundColor3 = Theme.Text
                SPBtn.BackgroundTransparency = 1
                SPBtn.Text = spName
                SPBtn.TextColor3 = Theme.TextDark
                SPBtn.TextTransparency = 1
                SPBtn.FontFace = Fonts.Medium
                SPBtn.TextSize = 13
                SPBtn.ClipsDescendants = true
                SPBtn.Parent = SubHeader
                Corner(SPBtn, 6)
                
                local BPad = Instance.new("UIPadding")
                BPad.PaddingLeft = UDim.new(0, 16)
                BPad.PaddingRight = UDim.new(0, 16)
                BPad.Parent = SPBtn
                
                task.delay(0.1, function()
                    TweenSmooth(SPBtn, {TextTransparency = 0}, 0.3)
                    if active then
                        Gradient(SPBtn)
                        TweenSmooth(SPBtn, {BackgroundTransparency = 0.82, TextColor3 = Theme.Text}, 0.3)
                    end
                end)
                
                SPBtn.MouseButton1Click:Connect(function()
                    Ripple(SPBtn, SPBtn.AbsoluteSize.X / 2, SPBtn.AbsoluteSize.Y / 2, Theme.Accent)
                    SubPage:Select()
                end)
                
                SPBtn.MouseEnter:Connect(function()
                    if Tab.ActiveSubPage ~= SubPage then
                        TweenSmooth(SPBtn, {BackgroundTransparency = 0.92, TextColor3 = Theme.Text}, 0.2)
                    end
                end)
                SPBtn.MouseLeave:Connect(function()
                    if Tab.ActiveSubPage ~= SubPage then
                        TweenSmooth(SPBtn, {BackgroundTransparency = 1, TextColor3 = Theme.TextDark}, 0.2)
                    end
                end)
            end
            
            function SubPage:Select()
                if Tab.ActiveSubPage == SubPage then return end
                
                for _, sp in pairs(Tab.SubPages) do
                    if sp ~= SubPage then
                        local content = TabPage:FindFirstChild(sp.Name)
                        if content and content.Visible then
                            content.Visible = false
                        end
                        local btn = SubHeader:FindFirstChild(sp.Name)
                        if btn then
                            TweenSmooth(btn, {BackgroundTransparency = 1, TextColor3 = Theme.TextDark}, 0.2)
                            local g = btn:FindFirstChildOfClass("UIGradient")
                            if g then g:Destroy() end
                        end
                    end
                end
                
                Tab.ActiveSubPage = SubPage
                SPContent.Visible = true
                
                local btn = SubHeader:FindFirstChild(spName)
                if btn then
                    TweenSmooth(btn, {BackgroundTransparency = 0.82, TextColor3 = Theme.Text}, 0.2)
                    if not btn:FindFirstChildOfClass("UIGradient") then Gradient(btn) end
                end
            end
            
            function SubPage:CreateSection(cfg)
                cfg = cfg or {}
                local secName = cfg.Name or "Section"
                local secIcon = cfg.Icon or "rbxassetid://83273732891006"
                local secSide = cfg.Side or "Left"
                
                local Section = {}
                
                local SecFrame = Instance.new("Frame")
                SecFrame.Name = secName
                SecFrame.Size = UDim2.new(0, 280, 0, 40)
                SecFrame.AutomaticSize = Enum.AutomaticSize.Y
                SecFrame.BackgroundColor3 = Color3.fromRGB(17, 18, 22)
                SecFrame.BackgroundTransparency = 1
                SecFrame.LayoutOrder = secSide == "Left" and 0 or 1
                SecFrame.Parent = SPContent
                Corner(SecFrame, 8)
                
                task.delay(0.2, function() TweenSmooth(SecFrame, {BackgroundTransparency = 0}, 0.4) end)
                
                local SecHeader = Instance.new("Frame")
                SecHeader.Size = UDim2.new(1, 0, 0, 32)
                SecHeader.BackgroundColor3 = Theme.Background
                SecHeader.BackgroundTransparency = 1
                SecHeader.Parent = SecFrame
                Corner(SecHeader, 8)
                task.delay(0.25, function() TweenSmooth(SecHeader, {BackgroundTransparency = 0}, 0.35) end)
                
                local SecLine = Instance.new("Frame")
                SecLine.AnchorPoint = Vector2.new(0, 1)
                SecLine.Position = UDim2.new(0, 0, 1, 0)
                SecLine.Size = UDim2.new(0, 0, 0, 2)
                SecLine.BorderSizePixel = 0
                SecLine.Parent = SecHeader
                Gradient(SecLine)
                task.delay(0.4, function() TweenSmooth(SecLine, {Size = UDim2.new(1, 0, 0, 2)}, 0.5) end)
                
                local AccLine = Instance.new("Frame")
                AccLine.Position = UDim2.new(0, -3, 0, 6)
                AccLine.Size = UDim2.new(0, 0, 0, 0)
                AccLine.BackgroundColor3 = Theme.Accent
                AccLine.Parent = SecHeader
                Corner(AccLine, 30)
                task.delay(0.3, function() TweenBounce(AccLine, {Size = UDim2.new(0, 6, 0, 20)}, 0.4) end)
                
                local SecIcon = Instance.new("ImageLabel")
                SecIcon.Position = UDim2.new(0, 14, 0, 8)
                SecIcon.Size = UDim2.new(0, 16, 0, 16)
                SecIcon.BackgroundTransparency = 1
                SecIcon.Image = secIcon
                SecIcon.ImageColor3 = Theme.Accent
                SecIcon.ImageTransparency = 1
                SecIcon.Parent = SecHeader
                task.delay(0.35, function() TweenSmooth(SecIcon, {ImageTransparency = 0, Rotation = 360}, 0.5) end)
                
                local SecTitle = Instance.new("TextLabel")
                SecTitle.Position = UDim2.new(0, 38, 0, 0)
                SecTitle.Size = UDim2.new(1, -44, 1, 0)
                SecTitle.BackgroundTransparency = 1
                SecTitle.Text = secName
                SecTitle.TextColor3 = Theme.Text
                SecTitle.TextTransparency = 1
                SecTitle.FontFace = Fonts.Medium
                SecTitle.TextSize = 12
                SecTitle.TextXAlignment = Enum.TextXAlignment.Left
                SecTitle.Parent = SecHeader
                task.delay(0.4, function() TweenSmooth(SecTitle, {TextTransparency = 0}, 0.3) end)
                
                local Elements = Instance.new("Frame")
                Elements.Name = "Elements"
                Elements.Position = UDim2.new(0, 0, 0, 32)
                Elements.Size = UDim2.new(1, 0, 0, 0)
                Elements.AutomaticSize = Enum.AutomaticSize.Y
                Elements.BackgroundTransparency = 1
                Elements.Parent = SecFrame
                
                local ELayout = Instance.new("UIListLayout")
                ELayout.Padding = UDim.new(0, 2)
                ELayout.Parent = Elements
                
                local EPad = Instance.new("UIPadding")
                EPad.PaddingTop = UDim.new(0, 8)
                EPad.PaddingBottom = UDim.new(0, 14)
                EPad.Parent = Elements
                
                function Section:CreateToggle(cfg)
                    cfg = cfg or {}
                    local tName = cfg.Name or "Toggle"
                    local default = cfg.Default or false
                    local callback = cfg.Callback or function() end
                    local state = default
                    
                    local TFrame = Instance.new("TextButton")
                    TFrame.Size = UDim2.new(1, 0, 0, 30)
                    TFrame.BackgroundColor3 = Theme.Tertiary
                    TFrame.BackgroundTransparency = 1
                    TFrame.Text = ""
                    TFrame.ClipsDescendants = true
                    TFrame.Parent = Elements
                    Corner(TFrame, 4)
                    
                    local TBox = Instance.new("Frame")
                    TBox.Position = UDim2.new(0, 14, 0, 8)
                    TBox.Size = UDim2.new(0, 14, 0, 14)
                    TBox.BackgroundColor3 = state and Theme.Text or Theme.Tertiary
                    TBox.Parent = TFrame
                    Corner(TBox, 4)
                    if not state then Stroke(TBox, Theme.Stroke) end
                    if state then Gradient(TBox) end
                    
                    local Check = Instance.new("ImageLabel")
                    Check.AnchorPoint = Vector2.new(0.5, 0.5)
                    Check.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Check.Size = UDim2.new(0, 10, 0, 10)
                    Check.BackgroundTransparency = 1
                    Check.Image = "rbxassetid://83899464799881"
                    Check.ImageTransparency = state and 0 or 1
                    Check.Parent = TBox
                    
                    local TLabel = Instance.new("TextLabel")
                    TLabel.Position = UDim2.new(0, 38, 0, 0)
                    TLabel.Size = UDim2.new(1, -44, 1, 0)
                    TLabel.BackgroundTransparency = 1
                    TLabel.Text = tName
                    TLabel.TextColor3 = state and Theme.Text or Theme.TextDark
                    TLabel.FontFace = Fonts.Regular
                    TLabel.TextSize = 12
                    TLabel.TextXAlignment = Enum.TextXAlignment.Left
                    TLabel.Parent = TFrame
                    
                    TFrame.MouseButton1Click:Connect(function()
                        state = not state
                        Ripple(TFrame, 21, 15, Theme.Accent)
                        if state then
                            TweenSmooth(TBox, {BackgroundColor3 = Theme.Text, Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 13, 0, 7)}, 0.2)
                            TweenSmooth(Check, {ImageTransparency = 0, Rotation = 360}, 0.35)
                            TweenSmooth(TLabel, {TextColor3 = Theme.Text}, 0.2)
                            local s = TBox:FindFirstChildOfClass("UIStroke") if s then s:Destroy() end
                            if not TBox:FindFirstChildOfClass("UIGradient") then Gradient(TBox) end
                            task.delay(0.15, function() TweenBounce(TBox, {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 14, 0, 8)}, 0.25) end)
                        else
                            TweenSmooth(TBox, {BackgroundColor3 = Theme.Tertiary, Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 15, 0, 9)}, 0.15)
                            TweenSmooth(Check, {ImageTransparency = 1, Rotation = 0}, 0.15)
                            TweenSmooth(TLabel, {TextColor3 = Theme.TextDark}, 0.2)
                            local g = TBox:FindFirstChildOfClass("UIGradient") if g then g:Destroy() end
                            if not TBox:FindFirstChildOfClass("UIStroke") then Stroke(TBox, Theme.Stroke) end
                            task.delay(0.1, function() TweenBounce(TBox, {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 14, 0, 8)}, 0.2) end)
                        end
                        callback(state)
                    end)
                    
                    TFrame.MouseEnter:Connect(function() TweenSmooth(TFrame, {BackgroundTransparency = 0.9}, 0.15) end)
                    TFrame.MouseLeave:Connect(function() TweenSmooth(TFrame, {BackgroundTransparency = 1}, 0.15) end)
                    
                    if default then callback(true) end
                    return {Set = function(_, v) if v ~= state then TFrame.MouseButton1Click:Fire() end end, Get = function() return state end}
                end
                
                function Section:CreateButton(cfg)
                    cfg = cfg or {}
                    local bName = cfg.Name or "Button"
                    local callback = cfg.Callback or function() end
                    
                    local BFrame = Instance.new("Frame")
                    BFrame.Size = UDim2.new(1, 0, 0, 40)
                    BFrame.BackgroundTransparency = 1
                    BFrame.Parent = Elements
                    
                    local Btn = Instance.new("TextButton")
                    Btn.AnchorPoint = Vector2.new(0.5, 0.5)
                    Btn.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Btn.Size = UDim2.new(1, -28, 0, 30)
                    Btn.BackgroundColor3 = Theme.Tertiary
                    Btn.Text = bName
                    Btn.TextColor3 = Theme.TextDark
                    Btn.FontFace = Fonts.Medium
                    Btn.TextSize = 12
                    Btn.ClipsDescendants = true
                    Btn.Parent = BFrame
                    Corner(Btn, 6)
                    Stroke(Btn, Theme.Stroke)
                    
                    Btn.MouseButton1Click:Connect(function()
                        local pos = UserInputService:GetMouseLocation()
                        Ripple(Btn, pos.X - Btn.AbsolutePosition.X, pos.Y - Btn.AbsolutePosition.Y - 36, Theme.Accent)
                        TweenSmooth(Btn, {BackgroundColor3 = Theme.Accent, Size = UDim2.new(1, -32, 0, 28)}, 0.1)
                        TweenSmooth(Btn, {TextColor3 = Theme.Text}, 0.1)
                        task.wait(0.12)
                        TweenBounce(Btn, {BackgroundColor3 = Theme.Tertiary, Size = UDim2.new(1, -28, 0, 30)}, 0.25)
                        TweenSmooth(Btn, {TextColor3 = Theme.TextDark}, 0.2)
                        callback()
                    end)
                    
                    Btn.MouseEnter:Connect(function()
                        TweenSmooth(Btn, {BackgroundColor3 = Color3.fromRGB(34, 36, 46)}, 0.15)
                        TweenSmooth(Btn, {TextColor3 = Theme.Text}, 0.15)
                    end)
                    Btn.MouseLeave:Connect(function()
                        TweenSmooth(Btn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
                        TweenSmooth(Btn, {TextColor3 = Theme.TextDark}, 0.15)
                    end)
                end
                
                function Section:CreateSlider(cfg)
                    cfg = cfg or {}
                    local sName = cfg.Name or "Slider"
                    local min, max = cfg.Min or 0, cfg.Max or 100
                    local default = cfg.Default or min
                    local callback = cfg.Callback or function() end
                    local value = default
                    
                    local SFrame = Instance.new("TextButton")
                    SFrame.Size = UDim2.new(1, 0, 0, 44)
                    SFrame.BackgroundColor3 = Theme.Tertiary
                    SFrame.BackgroundTransparency = 1
                    SFrame.Text = ""
                    SFrame.Parent = Elements
                    Corner(SFrame, 4)
                    
                    local SLabel = Instance.new("TextLabel")
                    SLabel.Position = UDim2.new(0, 14, 0, 6)
                    SLabel.Size = UDim2.new(0.6, 0, 0, 16)
                    SLabel.BackgroundTransparency = 1
                    SLabel.Text = sName
                    SLabel.TextColor3 = Theme.TextDark
                    SLabel.FontFace = Fonts.Regular
                    SLabel.TextSize = 12
                    SLabel.TextXAlignment = Enum.TextXAlignment.Left
                    SLabel.Parent = SFrame
                    
                    local VLabel = Instance.new("TextLabel")
                    VLabel.Position = UDim2.new(0.6, 0, 0, 6)
                    VLabel.Size = UDim2.new(0.4, -14, 0, 16)
                    VLabel.BackgroundTransparency = 1
                    VLabel.Text = tostring(value)
                    VLabel.TextColor3 = Theme.Text
                    VLabel.FontFace = Fonts.Medium
                    VLabel.TextSize = 12
                    VLabel.TextXAlignment = Enum.TextXAlignment.Right
                    VLabel.Parent = SFrame
                    
                    local SBG = Instance.new("Frame")
                    SBG.Position = UDim2.new(0, 14, 0, 28)
                    SBG.Size = UDim2.new(1, -28, 0, 6)
                    SBG.BackgroundColor3 = Theme.Tertiary
                    SBG.Parent = SFrame
                    Corner(SBG, 4)
                    Stroke(SBG, Theme.Stroke)
                    
                    local SFill = Instance.new("Frame")
                    SFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    SFill.BackgroundColor3 = Theme.Text
                    SFill.Parent = SBG
                    Corner(SFill, 4)
                    Gradient(SFill)
                    
                    local SDot = Instance.new("Frame")
                    SDot.AnchorPoint = Vector2.new(0.5, 0.5)
                    SDot.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
                    SDot.Size = UDim2.new(0, 14, 0, 14)
                    SDot.BackgroundColor3 = Theme.Text
                    SDot.BackgroundTransparency = 0.15
                    SDot.ZIndex = 2
                    SDot.Parent = SBG
                    Corner(SDot, 20)
                    
                    local SDotInner = Instance.new("Frame")
                    SDotInner.AnchorPoint = Vector2.new(0.5, 0.5)
                    SDotInner.Position = UDim2.new(0.5, 0, 0.5, 0)
                    SDotInner.Size = UDim2.new(0, 6, 0, 6)
                    SDotInner.BackgroundColor3 = Theme.Text
                    SDotInner.Parent = SDot
                    Corner(SDotInner, 10)
                    Gradient(SDotInner)
                    
                    local dragging = false
                    
                    local function UpdateSlider(p)
                        p = math.clamp(p, 0, 1)
                        value = math.floor(min + (max - min) * p)
                        VLabel.Text = tostring(value)
                        TweenSmooth(SFill, {Size = UDim2.new(p, 0, 1, 0)}, 0.08)
                        TweenSmooth(SDot, {Position = UDim2.new(p, 0, 0.5, 0)}, 0.08)
                        callback(value)
                    end
                    
                    SBG.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            TweenBounce(SDot, {Size = UDim2.new(0, 18, 0, 18)}, 0.2)
                            TweenSmooth(SDot, {BackgroundTransparency = 0}, 0.15)
                            local p = (i.Position.X - SBG.AbsolutePosition.X) / SBG.AbsoluteSize.X
                            UpdateSlider(p)
                        end
                    end)
                    
                    SFrame.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            TweenBounce(SDot, {Size = UDim2.new(0, 18, 0, 18)}, 0.2)
                            TweenSmooth(SDot, {BackgroundTransparency = 0}, 0.15)
                            local p = (i.Position.X - SBG.AbsolutePosition.X) / SBG.AbsoluteSize.X
                            UpdateSlider(p)
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(i)
                        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                            local p = (i.Position.X - SBG.AbsolutePosition.X) / SBG.AbsoluteSize.X
                            UpdateSlider(p)
                        end
                    end)
                    
                    UserInputService.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                            TweenBounce(SDot, {Size = UDim2.new(0, 14, 0, 14)}, 0.25)
                            TweenSmooth(SDot, {BackgroundTransparency = 0.15}, 0.2)
                        end
                    end)
                    
                    SFrame.MouseEnter:Connect(function()
                        TweenSmooth(SFrame, {BackgroundTransparency = 0.9}, 0.15)
                        TweenSmooth(SLabel, {TextColor3 = Theme.Text}, 0.15)
                    end)
                    SFrame.MouseLeave:Connect(function()
                        TweenSmooth(SFrame, {BackgroundTransparency = 1}, 0.15)
                        TweenSmooth(SLabel, {TextColor3 = Theme.TextDark}, 0.15)
                    end)
                    
                    callback(default)
                    return {Set = function(_, v) UpdateSlider((math.clamp(v, min, max) - min) / (max - min)) end, Get = function() return value end}
                end
                
                return Section
            end
            
            if isFirst and isFirstSP then
                task.defer(function()
                    SubPage:BuildButton(true)
                    Tab.ActiveSubPage = SubPage
                end)
            end
            
            return SubPage
        end
        
        return Tab
    end
    
    return Window
end

return Centrixity
