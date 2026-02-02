local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local Centrixity = {}
Centrixity.__index = Centrixity

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
    SemiBold = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
    Bold = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
}

local function Tween(inst, props, dur, style, dir)
    local t = TweenService:Create(inst, TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function AddCorner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = p
    return c
end

local function AddStroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color = col or Theme.Stroke
    s.Thickness = th or 1
    s.Parent = p
    return s
end

local function AddGradient(p, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Theme.Accent), ColorSequenceKeypoint.new(1, Theme.AccentSecondary)})
    g.Rotation = rot or 0
    g.Parent = p
    return g
end

local function AddPadding(p, t, b, l, r)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, t or 0)
    pad.PaddingBottom = UDim.new(0, b or 0)
    pad.PaddingLeft = UDim.new(0, l or 0)
    pad.PaddingRight = UDim.new(0, r or 0)
    pad.Parent = p
    return pad
end

local function AddLayout(p, dir, pad, sort)
    local lay = Instance.new("UIListLayout")
    lay.FillDirection = dir or Enum.FillDirection.Vertical
    lay.Padding = UDim.new(0, pad or 0)
    lay.SortOrder = sort or Enum.SortOrder.LayoutOrder
    lay.Parent = p
    return lay
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or frame
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.04)
        end
    end)
end

function Centrixity:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Centrixity"
    local subtitle = config.Subtitle or ""
    local size = config.Size or UDim2.new(0, 689, 0, 489)
    
    local Window = {Tabs = {}, ActiveTab = nil}
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CentrixityUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = (RunService:IsStudio() and Player:WaitForChild("PlayerGui")) or game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BackgroundTransparency = 1
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    AddCorner(MainFrame, 11)
    
    Tween(MainFrame, {Size = size, BackgroundTransparency = 0}, 0.5, Enum.EasingStyle.Back)
    
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.AnchorPoint = Vector2.new(0.5, 0)
    Header.Position = UDim2.new(0.5, 0, 0, 0)
    Header.Size = UDim2.new(1, 0, 0, 37)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame
    
    local HeaderLine = Instance.new("Frame")
    HeaderLine.AnchorPoint = Vector2.new(0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, 0)
    HeaderLine.Size = UDim2.new(1, 0, 0, 2)
    HeaderLine.BackgroundColor3 = Theme.Divider
    HeaderLine.BorderSizePixel = 0
    HeaderLine.Parent = Header
    
    local LibIcon = Instance.new("ImageLabel")
    LibIcon.AnchorPoint = Vector2.new(0, 0.5)
    LibIcon.Position = UDim2.new(0, 12, 0.5, 0)
    LibIcon.Size = UDim2.new(0, 34, 0, 34)
    LibIcon.BackgroundTransparency = 1
    LibIcon.Image = config.Icon or "rbxassetid://137946959393180"
    LibIcon.ScaleType = Enum.ScaleType.Fit
    LibIcon.Parent = Header
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
    TitleLabel.Position = UDim2.new(0, 52, 0.5, 0)
    TitleLabel.Size = UDim2.new(0, 1, 0, 1)
    TitleLabel.AutomaticSize = Enum.AutomaticSize.XY
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title .. ' <font color="#45475a">' .. subtitle .. '</font>'
    TitleLabel.RichText = true
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.FontFace = Fonts.Medium
    TitleLabel.TextSize = 14
    TitleLabel.Parent = Header
    
    MakeDraggable(MainFrame, Header)
    
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.AnchorPoint = Vector2.new(0, 1)
    Sidebar.Position = UDim2.new(0, 0, 1, 0)
    Sidebar.Size = UDim2.new(0, 75, 1, -37)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame
    
    local SidebarLine = Instance.new("Frame")
    SidebarLine.AnchorPoint = Vector2.new(1, 0.5)
    SidebarLine.Position = UDim2.new(1, 0, 0.5, 0)
    SidebarLine.Size = UDim2.new(0, 2, 1, 0)
    SidebarLine.BackgroundColor3 = Theme.Divider
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Parent = Sidebar
    
    local TabHolder = Instance.new("Frame")
    TabHolder.Name = "TabHolder"
    TabHolder.AnchorPoint = Vector2.new(0.5, 0)
    TabHolder.Position = UDim2.new(0.5, 0, 0, 0)
    TabHolder.Size = UDim2.new(1, 0, 1, 0)
    TabHolder.BackgroundTransparency = 1
    TabHolder.Parent = Sidebar
    
    local TabLayout = AddLayout(TabHolder, Enum.FillDirection.Vertical, 5)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    AddPadding(TabHolder, 10, 0, 0, 0)
    
    local SubHeader = Instance.new("Frame")
    SubHeader.Name = "SubHeader"
    SubHeader.Position = UDim2.new(0, 77, 0, 37)
    SubHeader.Size = UDim2.new(1, -77, 0, 51)
    SubHeader.BackgroundTransparency = 1
    SubHeader.Parent = MainFrame
    
    AddLayout(SubHeader, Enum.FillDirection.Horizontal, 8)
    AddPadding(SubHeader, 4, 0, 25, 0)
    
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.AnchorPoint = Vector2.new(1, 1)
    PageContainer.Position = UDim2.new(1, 0, 1, 0)
    PageContainer.Size = UDim2.new(0, 612, 0, 401)
    PageContainer.BackgroundColor3 = Theme.Secondary
    PageContainer.ClipsDescendants = true
    PageContainer.Parent = MainFrame
    AddCorner(PageContainer, 11)
    
    local NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "NotifHolder"
    NotifHolder.Position = UDim2.new(0, 0, 0, 0)
    NotifHolder.Size = UDim2.new(0, 1, 0, 1)
    NotifHolder.AutomaticSize = Enum.AutomaticSize.XY
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Parent = ScreenGui
    
    AddLayout(NotifHolder, Enum.FillDirection.Vertical, 12)
    AddPadding(NotifHolder, 12, 0, 12, 0)
    
    function Window:Notify(cfg)
        cfg = cfg or {}
        local nType = cfg.Type or "Success"
        local nTitle = cfg.Title or "Notification"
        local nContent = cfg.Content or ""
        local nDuration = cfg.Duration or 5
        local nButtons = cfg.Buttons or {}
        
        local colors = {
            Success = {color = Theme.Success, icon = "rbxassetid://92431556586885"},
            Warning = {color = Theme.Warning, icon = "rbxassetid://70479764730792"},
            Error = {color = Theme.Error, icon = "rbxassetid://138617501067622"}
        }
        local style = colors[nType] or colors.Success
        
        local Notif = Instance.new("Frame")
        Notif.Name = "Notification"
        Notif.Size = UDim2.new(0, 1, 0, 30)
        Notif.AutomaticSize = Enum.AutomaticSize.XY
        Notif.BackgroundColor3 = Theme.Secondary
        Notif.ClipsDescendants = true
        Notif.BackgroundTransparency = 1
        Notif.Parent = NotifHolder
        AddCorner(Notif, 8)
        
        local NotifLayout = AddLayout(Notif, Enum.FillDirection.Vertical, 0)
        
        local NHeader = Instance.new("Frame")
        NHeader.Name = "Header"
        NHeader.Size = UDim2.new(0, 1, 0, 30)
        NHeader.AutomaticSize = Enum.AutomaticSize.XY
        NHeader.BackgroundColor3 = Theme.Secondary
        NHeader.Parent = Notif
        AddCorner(NHeader, 8)
        AddPadding(NHeader, 4, 0, 6, 4)
        AddLayout(NHeader, Enum.FillDirection.Horizontal, 24)
        
        local HHolder = Instance.new("Frame")
        HHolder.Size = UDim2.new(0, 64, 0, 30)
        HHolder.AutomaticSize = Enum.AutomaticSize.XY
        HHolder.BackgroundTransparency = 1
        HHolder.Parent = NHeader
        AddLayout(HHolder, Enum.FillDirection.Horizontal, 2)
        
        local IconHolder = Instance.new("Frame")
        IconHolder.Size = UDim2.new(0, 30, 0, 30)
        IconHolder.BackgroundTransparency = 1
        IconHolder.Parent = HHolder
        
        local Icon = Instance.new("ImageLabel")
        Icon.AnchorPoint = Vector2.new(0.5, 0.5)
        Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.BackgroundTransparency = 1
        Icon.Image = style.icon
        Icon.ImageColor3 = style.color
        Icon.Parent = IconHolder
        
        local TitleHolder = Instance.new("Frame")
        TitleHolder.Size = UDim2.new(0, 1, 0, 30)
        TitleHolder.AutomaticSize = Enum.AutomaticSize.XY
        TitleHolder.BackgroundTransparency = 1
        TitleHolder.Parent = HHolder
        
        local TitleLay = AddLayout(TitleHolder, Enum.FillDirection.Horizontal, 0)
        TitleLay.VerticalAlignment = Enum.VerticalAlignment.Center
        TitleLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        local NTitle = Instance.new("TextLabel")
        NTitle.Size = UDim2.new(0, 1, 0, 1)
        NTitle.AutomaticSize = Enum.AutomaticSize.XY
        NTitle.BackgroundTransparency = 1
        NTitle.Text = nTitle
        NTitle.TextColor3 = Theme.Text
        NTitle.FontFace = Fonts.Regular
        NTitle.TextSize = 14
        NTitle.RichText = true
        NTitle.Parent = TitleHolder
        
        local ControlHolder = Instance.new("Frame")
        ControlHolder.Size = UDim2.new(0, 1, 0, 30)
        ControlHolder.AutomaticSize = Enum.AutomaticSize.XY
        ControlHolder.BackgroundTransparency = 1
        ControlHolder.Parent = NHeader
        AddLayout(ControlHolder, Enum.FillDirection.Horizontal, 2)
        
        local collapsed = false
        local CollapseBtn = Instance.new("Frame")
        CollapseBtn.Size = UDim2.new(0, 30, 0, 30)
        CollapseBtn.BackgroundTransparency = 1
        CollapseBtn.Parent = ControlHolder
        
        local CollapseIcon = Instance.new("ImageLabel")
        CollapseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        CollapseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        CollapseIcon.Size = UDim2.new(0, 20, 0, 20)
        CollapseIcon.BackgroundTransparency = 1
        CollapseIcon.Image = "rbxassetid://118645616697622"
        CollapseIcon.ImageColor3 = Theme.TextDark
        CollapseIcon.Parent = CollapseBtn
        
        local CloseBtn = Instance.new("Frame")
        CloseBtn.Size = UDim2.new(0, 30, 0, 30)
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.Parent = ControlHolder
        
        local CloseIcon = Instance.new("ImageLabel")
        CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        CloseIcon.Size = UDim2.new(0, 18, 0, 18)
        CloseIcon.BackgroundTransparency = 1
        CloseIcon.Image = "rbxassetid://124971904960139"
        CloseIcon.ImageColor3 = Theme.TextDark
        CloseIcon.Parent = CloseBtn
        
        local DescHolder = Instance.new("Frame")
        DescHolder.Name = "DescHolder"
        DescHolder.Size = UDim2.new(0, 1, 0, 10)
        DescHolder.AutomaticSize = Enum.AutomaticSize.XY
        DescHolder.BackgroundTransparency = 1
        DescHolder.Parent = Notif
        AddLayout(DescHolder, Enum.FillDirection.Vertical, 8)
        AddPadding(DescHolder, 0, 12, 12, 0)
        
        if nContent ~= "" then
            local TextHolder = Instance.new("Frame")
            TextHolder.Size = UDim2.new(1, 0, 0, 10)
            TextHolder.AutomaticSize = Enum.AutomaticSize.XY
            TextHolder.BackgroundTransparency = 1
            TextHolder.Parent = DescHolder
            AddLayout(TextHolder, Enum.FillDirection.Vertical, 0)
            AddPadding(TextHolder, 0, 0, 26, 0)
            
            local ContentLabel = Instance.new("TextLabel")
            ContentLabel.Size = UDim2.new(0, 1, 0, 1)
            ContentLabel.AutomaticSize = Enum.AutomaticSize.XY
            ContentLabel.BackgroundTransparency = 1
            ContentLabel.Text = nContent
            ContentLabel.TextColor3 = Theme.TextDark
            ContentLabel.FontFace = Fonts.Regular
            ContentLabel.TextSize = 14
            ContentLabel.RichText = true
            ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
            ContentLabel.TextWrapped = true
            ContentLabel.Parent = TextHolder
        end
        
        if #nButtons > 0 then
            local BtnHolder = Instance.new("Frame")
            BtnHolder.Size = UDim2.new(0, 1, 0, 10)
            BtnHolder.AutomaticSize = Enum.AutomaticSize.XY
            BtnHolder.BackgroundTransparency = 1
            BtnHolder.Parent = DescHolder
            local bLay = AddLayout(BtnHolder, Enum.FillDirection.Horizontal, 8)
            bLay.Wraps = true
            AddPadding(BtnHolder, 0, 0, 26, 0)
            
            for i, btn in ipairs(nButtons) do
                local isPrimary = i == 1
                local BtnFrame = Instance.new("Frame")
                BtnFrame.Size = UDim2.new(0, 1, 0, 1)
                BtnFrame.AutomaticSize = Enum.AutomaticSize.XY
                BtnFrame.BackgroundTransparency = isPrimary and 0.95 or 1
                BtnFrame.BackgroundColor3 = isPrimary and style.color or Theme.Text
                BtnFrame.Parent = BtnHolder
                AddCorner(BtnFrame, 6)
                if not isPrimary then AddStroke(BtnFrame, Theme.TextDark) end
                
                local BtnLay = AddLayout(BtnFrame, Enum.FillDirection.Horizontal, 0)
                BtnLay.VerticalAlignment = Enum.VerticalAlignment.Center
                BtnLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
                
                local BtnText = Instance.new("TextLabel")
                BtnText.Size = UDim2.new(0, 1, 0, 1)
                BtnText.AutomaticSize = Enum.AutomaticSize.XY
                BtnText.BackgroundTransparency = 1
                BtnText.Text = btn.Name or "Button"
                BtnText.TextColor3 = isPrimary and style.color or Theme.TextDark
                BtnText.FontFace = Fonts.Regular
                BtnText.TextSize = 14
                BtnText.Parent = BtnFrame
                AddPadding(BtnText, 6, 6, 8, 8)
                
                BtnFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Tween(BtnFrame, {BackgroundTransparency = 0.7}, 0.1)
                        task.wait(0.1)
                        Tween(BtnFrame, {BackgroundTransparency = isPrimary and 0.95 or 1}, 0.2)
                        if btn.Callback then btn.Callback() end
                        Tween(Notif, {Size = UDim2.new(0, Notif.AbsoluteSize.X, 0, 0), BackgroundTransparency = 1}, 0.3)
                        task.wait(0.35)
                        Notif:Destroy()
                    end
                end)
            end
        end
        
        local ProgressHolder = Instance.new("Frame")
        ProgressHolder.Name = "Progress"
        ProgressHolder.Size = UDim2.new(1, 0, 0, 20)
        ProgressHolder.AutomaticSize = Enum.AutomaticSize.XY
        ProgressHolder.BackgroundColor3 = Theme.Background
        ProgressHolder.Parent = Notif
        AddCorner(ProgressHolder, 8)
        AddPadding(ProgressHolder, 0, 0, 0, 12)
        AddLayout(ProgressHolder, Enum.FillDirection.Horizontal, 0)
        
        local PHHolder = Instance.new("Frame")
        PHHolder.Size = UDim2.new(0, 1, 0, 1)
        PHHolder.AutomaticSize = Enum.AutomaticSize.XY
        PHHolder.BackgroundTransparency = 1
        PHHolder.Parent = ProgressHolder
        AddLayout(PHHolder, Enum.FillDirection.Vertical, 6)
        
        local TimeTextHolder = Instance.new("Frame")
        TimeTextHolder.Size = UDim2.new(0, 1, 0, 10)
        TimeTextHolder.AutomaticSize = Enum.AutomaticSize.XY
        TimeTextHolder.BackgroundTransparency = 1
        TimeTextHolder.Parent = PHHolder
        AddLayout(TimeTextHolder, Enum.FillDirection.Horizontal, 12)
        AddPadding(TimeTextHolder, 6, 0, 12, 0)
        
        local TimeLabel = Instance.new("TextLabel")
        TimeLabel.Size = UDim2.new(0, 1, 0, 1)
        TimeLabel.AutomaticSize = Enum.AutomaticSize.XY
        TimeLabel.BackgroundTransparency = 1
        TimeLabel.Text = "This notification will end in <b>" .. nDuration .. "</b> seconds"
        TimeLabel.TextColor3 = Theme.TextDark
        TimeLabel.FontFace = Fonts.Regular
        TimeLabel.TextSize = 14
        TimeLabel.RichText = true
        TimeLabel.Parent = TimeTextHolder
        
        local ProgressBar = Instance.new("Frame")
        ProgressBar.Size = UDim2.new(1, 0, 0, 5)
        ProgressBar.BackgroundTransparency = 1
        ProgressBar.Parent = PHHolder
        
        local ProgressFill = Instance.new("Frame")
        ProgressFill.Size = UDim2.new(1, 0, 0, 5)
        ProgressFill.BackgroundColor3 = style.color
        ProgressFill.Parent = ProgressBar
        AddCorner(ProgressFill, 4)
        
        Notif.Position = UDim2.new(-1, 0, 0, 0)
        Tween(Notif, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0}, 0.4, Enum.EasingStyle.Back)
        Tween(Icon, {Rotation = 360}, 0.5)
        
        local startTime = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            local remaining = math.max(0, nDuration - elapsed)
            local progress = remaining / nDuration
            
            TimeLabel.Text = "This notification will end in <b>" .. math.ceil(remaining) .. "</b> seconds"
            ProgressFill.Size = UDim2.new(progress, 0, 0, 5)
            
            if remaining <= 0 then
                conn:Disconnect()
                Tween(Notif, {Position = UDim2.new(-1, 0, 0, 0), BackgroundTransparency = 1}, 0.35)
                task.wait(0.4)
                Notif:Destroy()
            end
        end)
        
        CollapseBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                collapsed = not collapsed
                Tween(CollapseIcon, {Rotation = collapsed and 180 or 0}, 0.2)
                DescHolder.Visible = not collapsed
                ProgressHolder.Visible = not collapsed
            end
        end)
        
        CloseBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                conn:Disconnect()
                Tween(Notif, {Position = UDim2.new(-1, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
                task.wait(0.35)
                Notif:Destroy()
            end
        end)
        
        CloseBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                Tween(CloseIcon, {ImageColor3 = Theme.Error}, 0.15)
            end
        end)
        CloseBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                Tween(CloseIcon, {ImageColor3 = Theme.TextDark}, 0.15)
            end
        end)
    end
    
    function Window:CreateTab(cfg)
        cfg = cfg or {}
        local tabName = cfg.Name or "Tab"
        local tabIcon = cfg.Icon or "rbxassetid://80869096876893"
        
        local Tab = {SubPages = {}, ActiveSubPage = nil, Name = tabName}
        local isFirst = #Window.Tabs == 0
        table.insert(Window.Tabs, Tab)
        
        local TabBtn = Instance.new("Frame")
        TabBtn.Name = tabName
        TabBtn.Size = UDim2.new(0, 55, 0, 60)
        TabBtn.BackgroundColor3 = Theme.Text
        TabBtn.BackgroundTransparency = isFirst and 0.9 or 1
        TabBtn.ClipsDescendants = true
        TabBtn.Parent = TabHolder
        AddCorner(TabBtn, 5)
        
        local TabGrad = AddGradient(TabBtn, 0)
        TabGrad.Enabled = isFirst
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        TabIcon.Position = UDim2.new(0.5, 0, 0.5, -8)
        TabIcon.Size = UDim2.new(0, 24, 0, 22)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = tabIcon
        TabIcon.ImageColor3 = isFirst and Theme.Accent or Theme.TextDark
        TabIcon.Parent = TabBtn
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        TabLabel.Position = UDim2.new(0.5, 0, 0.5, 20)
        TabLabel.Size = UDim2.new(0, 1, 0, 1)
        TabLabel.AutomaticSize = Enum.AutomaticSize.XY
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = isFirst and Theme.Text or Theme.TextDark
        TabLabel.FontFace = Fonts.Bold
        TabLabel.TextSize = 12
        TabLabel.Parent = TabIcon
        
        local Indicator = Instance.new("Frame")
        Indicator.Name = "Indicator"
        Indicator.AnchorPoint = Vector2.new(0.5, 1)
        Indicator.Position = UDim2.new(0.5, 0, 1, 3)
        Indicator.Size = isFirst and UDim2.new(0, 25, 0, 6) or UDim2.new(0, 0, 0, 6)
        Indicator.BackgroundColor3 = Theme.Text
        Indicator.Parent = TabBtn
        AddCorner(Indicator, 12)
        AddGradient(Indicator, 0)
        
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabName .. "_Page"
        TabPage.AnchorPoint = Vector2.new(0.5, 0.5)
        TabPage.Position = UDim2.new(0.5, 0, 0.5, 0)
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = Theme.Accent
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.Visible = isFirst
        TabPage.Parent = PageContainer
        
        if isFirst then Window.ActiveTab = Tab end
        
        local function SelectTab()
            if Window.ActiveTab == Tab then return end
            
            for _, t in pairs(Window.Tabs) do
                local btn = TabHolder:FindFirstChild(t.Name)
                if btn then
                    local icon = btn:FindFirstChild("Icon")
                    local ind = btn:FindFirstChild("Indicator")
                    local grad = btn:FindFirstChildOfClass("UIGradient")
                    
                    Tween(btn, {BackgroundTransparency = 1}, 0.25)
                    if grad then grad.Enabled = false end
                    if icon then Tween(icon, {ImageColor3 = Theme.TextDark}, 0.25) end
                    if icon and icon:FindFirstChildOfClass("TextLabel") then
                        Tween(icon:FindFirstChildOfClass("TextLabel"), {TextColor3 = Theme.TextDark}, 0.25)
                    end
                    if ind then Tween(ind, {Size = UDim2.new(0, 0, 0, 6)}, 0.25) end
                    
                    local pg = PageContainer:FindFirstChild(t.Name .. "_Page")
                    if pg then
                        Tween(pg, {Position = UDim2.new(0.5, 0, 0.6, 0)}, 0.2)
                        task.delay(0.2, function() pg.Visible = false end)
                    end
                end
            end
            
            for _, child in pairs(SubHeader:GetChildren()) do
                if child:IsA("Frame") then child:Destroy() end
            end
            
            Window.ActiveTab = Tab
            TabGrad.Enabled = true
            Tween(TabBtn, {BackgroundTransparency = 0.9}, 0.25)
            Tween(TabIcon, {ImageColor3 = Theme.Accent}, 0.25)
            Tween(TabLabel, {TextColor3 = Theme.Text}, 0.25)
            Tween(Indicator, {Size = UDim2.new(0, 25, 0, 6)}, 0.3, Enum.EasingStyle.Back)
            
            TabPage.Position = UDim2.new(0.5, 0, 0.4, 0)
            TabPage.Visible = true
            Tween(TabPage, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
            
            if #Tab.SubPages > 0 then
                for i, sp in ipairs(Tab.SubPages) do
                    sp:CreateButton(i == 1)
                end
                if Tab.SubPages[1] then Tab.SubPages[1]:Select() end
            end
        end
        
        TabBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                SelectTab()
            end
        end)
        
        TabBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                if Window.ActiveTab ~= Tab then
                    Tween(TabBtn, {BackgroundTransparency = 0.95}, 0.15)
                end
            end
        end)
        TabBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                if Window.ActiveTab ~= Tab then
                    Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
                end
            end
        end)
        
        function Tab:CreateSubPage(cfg)
            cfg = cfg or {}
            local subName = cfg.Name or "SubPage"
            
            local SubPage = {Name = subName, Sections = {}}
            local isFirstSub = #Tab.SubPages == 0
            table.insert(Tab.SubPages, SubPage)
            
            local SubContent = Instance.new("Frame")
            SubContent.Name = subName .. "_Content"
            SubContent.Size = UDim2.new(1, 0, 1, 0)
            SubContent.BackgroundTransparency = 1
            SubContent.Visible = isFirstSub and isFirst
            SubContent.Parent = TabPage
            
            AddLayout(SubContent, Enum.FillDirection.Horizontal, 20)
            AddPadding(SubContent, 12, 12, 12, 12)
            
            if isFirstSub then Tab.ActiveSubPage = SubPage end
            
            function SubPage:CreateButton(active)
                local SubBtn = Instance.new("Frame")
                SubBtn.Name = subName
                SubBtn.Size = UDim2.new(0, 80, 0, 49)
                SubBtn.AutomaticSize = Enum.AutomaticSize.X
                SubBtn.BackgroundTransparency = 1
                SubBtn.Parent = SubHeader
                
                local SubLabel = Instance.new("TextLabel")
                SubLabel.Name = "Label"
                SubLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                SubLabel.Position = UDim2.new(0.5, 0, 0.5, -3)
                SubLabel.Size = UDim2.new(0, 1, 0, 1)
                SubLabel.AutomaticSize = Enum.AutomaticSize.XY
                SubLabel.BackgroundTransparency = active and 0.8 or 1
                SubLabel.BackgroundColor3 = Theme.Text
                SubLabel.Text = subName
                SubLabel.TextColor3 = active and Theme.Text or Theme.TextDark
                SubLabel.TextTransparency = active and 0 or 0.15
                SubLabel.FontFace = active and Fonts.Medium or Fonts.Regular
                SubLabel.TextSize = 13
                SubLabel.Parent = SubBtn
                AddCorner(SubLabel, 4)
                AddPadding(SubLabel, 10, 10, 8, 8)
                
                if active then AddGradient(SubLabel, 0) end
                
                SubBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        SubPage:Select()
                    end
                end)
                
                SubBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and Tab.ActiveSubPage ~= SubPage then
                        Tween(SubLabel, {TextTransparency = 0, TextColor3 = Theme.Text}, 0.15)
                    end
                end)
                SubBtn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and Tab.ActiveSubPage ~= SubPage then
                        Tween(SubLabel, {TextTransparency = 0.15, TextColor3 = Theme.TextDark}, 0.15)
                    end
                end)
            end
            
            function SubPage:Select()
                if Tab.ActiveSubPage == SubPage then return end
                
                for _, sp in pairs(Tab.SubPages) do
                    local content = TabPage:FindFirstChild(sp.Name .. "_Content")
                    if content then
                        Tween(content, {BackgroundTransparency = 1}, 0.2)
                        task.delay(0.15, function() content.Visible = false end)
                    end
                    local btn = SubHeader:FindFirstChild(sp.Name)
                    if btn then
                        local lbl = btn:FindFirstChild("Label")
                        if lbl then
                            Tween(lbl, {BackgroundTransparency = 1, TextTransparency = 0.15, TextColor3 = Theme.TextDark}, 0.2)
                            local grad = lbl:FindFirstChildOfClass("UIGradient")
                            if grad then grad:Destroy() end
                        end
                    end
                end
                
                Tab.ActiveSubPage = SubPage
                SubContent.Visible = true
                SubContent.BackgroundTransparency = 1
                Tween(SubContent, {BackgroundTransparency = 1}, 0.25)
                
                local btn = SubHeader:FindFirstChild(subName)
                if btn then
                    local lbl = btn:FindFirstChild("Label")
                    if lbl then
                        Tween(lbl, {BackgroundTransparency = 0.8, TextTransparency = 0, TextColor3 = Theme.Text}, 0.2)
                        lbl.FontFace = Fonts.Medium
                        if not lbl:FindFirstChildOfClass("UIGradient") then AddGradient(lbl, 0) end
                    end
                end
            end
            
            function SubPage:CreateSection(cfg)
                cfg = cfg or {}
                local secName = cfg.Name or "Section"
                local secIcon = cfg.Icon or "rbxassetid://83273732891006"
                local secSide = cfg.Side or "Left"
                
                local Section = {}
                table.insert(SubPage.Sections, Section)
                
                local SectionFrame = Instance.new("Frame")
                SectionFrame.Name = secName
                SectionFrame.Size = UDim2.new(0, 281, 0, 60)
                SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
                SectionFrame.BackgroundColor3 = Color3.fromRGB(17, 18, 22)
                SectionFrame.ClipsDescendants = true
                SectionFrame.LayoutOrder = secSide == "Left" and 0 or 1
                SectionFrame.Parent = SubContent
                AddCorner(SectionFrame, 6)
                
                local SectionHeader = Instance.new("Frame")
                SectionHeader.Name = "Header"
                SectionHeader.AnchorPoint = Vector2.new(0.5, 0)
                SectionHeader.Position = UDim2.new(0.5, 0, 0, 0)
                SectionHeader.Size = UDim2.new(1, 0, 0, 30)
                SectionHeader.BackgroundColor3 = Theme.Background
                SectionHeader.Parent = SectionFrame
                AddCorner(SectionHeader, 6)
                
                local SectionLine = Instance.new("Frame")
                SectionLine.AnchorPoint = Vector2.new(0.5, 1)
                SectionLine.Position = UDim2.new(0.5, 0, 1, 0)
                SectionLine.Size = UDim2.new(1, 0, 0, 2)
                SectionLine.BorderSizePixel = 0
                SectionLine.Parent = SectionHeader
                AddGradient(SectionLine, 90)
                
                local AccentLine = Instance.new("Frame")
                AccentLine.AnchorPoint = Vector2.new(0, 0.5)
                AccentLine.Position = UDim2.new(0, -3, 0.5, 0)
                AccentLine.Size = UDim2.new(0, 6, 0, 20)
                AccentLine.BackgroundColor3 = Theme.Accent
                AccentLine.Parent = SectionHeader
                AddCorner(AccentLine, 30)
                
                local SectionIcon = Instance.new("ImageLabel")
                SectionIcon.AnchorPoint = Vector2.new(0, 0.5)
                SectionIcon.Position = UDim2.new(0, 12, 0.5, 0)
                SectionIcon.Size = UDim2.new(0, 15, 0, 15)
                SectionIcon.BackgroundTransparency = 1
                SectionIcon.Image = secIcon
                SectionIcon.ImageColor3 = Theme.Accent
                SectionIcon.Parent = SectionHeader
                
                local SectionTitle = Instance.new("TextLabel")
                SectionTitle.AnchorPoint = Vector2.new(0, 0.5)
                SectionTitle.Position = UDim2.new(0, 35, 0.5, 0)
                SectionTitle.Size = UDim2.new(0, 1, 0, 1)
                SectionTitle.AutomaticSize = Enum.AutomaticSize.XY
                SectionTitle.BackgroundTransparency = 1
                SectionTitle.Text = secName
                SectionTitle.TextColor3 = Theme.Text
                SectionTitle.FontFace = Fonts.Regular
                SectionTitle.TextSize = 12
                SectionTitle.Parent = SectionHeader
                
                local ElementHolder = Instance.new("Frame")
                ElementHolder.Name = "Elements"
                ElementHolder.AnchorPoint = Vector2.new(0.5, 0)
                ElementHolder.Position = UDim2.new(0.5, 0, 0, 30)
                ElementHolder.Size = UDim2.new(0, 1, 0, 1)
                ElementHolder.AutomaticSize = Enum.AutomaticSize.XY
                ElementHolder.BackgroundTransparency = 1
                ElementHolder.Parent = SectionFrame
                
                AddLayout(ElementHolder, Enum.FillDirection.Vertical, 4)
                AddPadding(ElementHolder, 5, 45, 0, 0)
                
                function Section:CreateToggle(cfg)
                    cfg = cfg or {}
                    local tName = cfg.Name or "Toggle"
                    local default = cfg.Default or false
                    local callback = cfg.Callback or function() end
                    
                    local state = default
                    
                    local TFrame = Instance.new("Frame")
                    TFrame.Size = UDim2.new(0, 260, 0, 30)
                    TFrame.BackgroundTransparency = 1
                    TFrame.Parent = ElementHolder
                    
                    local TBox = Instance.new("Frame")
                    TBox.AnchorPoint = Vector2.new(0, 0.5)
                    TBox.Position = UDim2.new(0, 25, 0.5, 0)
                    TBox.Size = UDim2.new(0, 14, 0, 14)
                    TBox.BackgroundColor3 = state and Theme.Text or Theme.Tertiary
                    TBox.Parent = TFrame
                    AddCorner(TBox, 3)
                    if not state then AddStroke(TBox) end
                    if state then AddGradient(TBox, 90) end
                    
                    local CheckIcon = Instance.new("ImageLabel")
                    CheckIcon.AnchorPoint = Vector2.new(0.5, 0.5)
                    CheckIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
                    CheckIcon.Size = UDim2.new(0, 8, 0, 7)
                    CheckIcon.BackgroundTransparency = 1
                    CheckIcon.Image = "rbxassetid://83899464799881"
                    CheckIcon.ImageTransparency = state and 0 or 1
                    CheckIcon.Parent = TBox
                    
                    local TLabel = Instance.new("TextLabel")
                    TLabel.AnchorPoint = Vector2.new(0, 0.5)
                    TLabel.Position = UDim2.new(0, 48, 0.5, 0)
                    TLabel.Size = UDim2.new(0, 1, 0, 1)
                    TLabel.AutomaticSize = Enum.AutomaticSize.XY
                    TLabel.BackgroundTransparency = 1
                    TLabel.Text = tName
                    TLabel.TextColor3 = state and Theme.Text or Theme.TextDark
                    TLabel.FontFace = Fonts.Regular
                    TLabel.TextSize = 12
                    TLabel.Parent = TFrame
                    
                    local function Update()
                        state = not state
                        if state then
                            Tween(TBox, {BackgroundColor3 = Theme.Text}, 0.2)
                            Tween(CheckIcon, {ImageTransparency = 0, Rotation = 360}, 0.3)
                            Tween(TLabel, {TextColor3 = Theme.Text}, 0.2)
                            local stroke = TBox:FindFirstChildOfClass("UIStroke")
                            if stroke then stroke:Destroy() end
                            if not TBox:FindFirstChildOfClass("UIGradient") then AddGradient(TBox, 90) end
                        else
                            Tween(TBox, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                            Tween(CheckIcon, {ImageTransparency = 1, Rotation = 0}, 0.2)
                            Tween(TLabel, {TextColor3 = Theme.TextDark}, 0.2)
                            local grad = TBox:FindFirstChildOfClass("UIGradient")
                            if grad then grad:Destroy() end
                            if not TBox:FindFirstChildOfClass("UIStroke") then AddStroke(TBox) end
                        end
                        callback(state)
                    end
                    
                    TFrame.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then Update() end
                    end)
                    
                    if default then callback(true) end
                    
                    return {Set = function(_, v) if v ~= state then Update() end end, Get = function() return state end}
                end
                
                function Section:CreateButton(cfg)
                    cfg = cfg or {}
                    local bName = cfg.Name or "Button"
                    local callback = cfg.Callback or function() end
                    
                    local BFrame = Instance.new("Frame")
                    BFrame.Size = UDim2.new(0, 260, 0, 40)
                    BFrame.BackgroundTransparency = 1
                    BFrame.Parent = ElementHolder
                    
                    local Btn = Instance.new("Frame")
                    Btn.AnchorPoint = Vector2.new(0.5, 0.5)
                    Btn.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Btn.Size = UDim2.new(0, 220, 0, 30)
                    Btn.BackgroundColor3 = Theme.Tertiary
                    Btn.Parent = BFrame
                    AddCorner(Btn, 3)
                    AddStroke(Btn)
                    
                    local BText = Instance.new("TextLabel")
                    BText.AnchorPoint = Vector2.new(0.5, 0.5)
                    BText.Position = UDim2.new(0.5, 0, 0.5, 0)
                    BText.Size = UDim2.new(0, 1, 0, 1)
                    BText.AutomaticSize = Enum.AutomaticSize.XY
                    BText.BackgroundTransparency = 1
                    BText.Text = bName
                    BText.TextColor3 = Theme.TextDark
                    BText.FontFace = Fonts.Medium
                    BText.TextSize = 13
                    BText.Parent = Btn
                    
                    Btn.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Tween(Btn, {BackgroundColor3 = Theme.Accent, Size = UDim2.new(0, 215, 0, 28)}, 0.1)
                            Tween(BText, {TextColor3 = Theme.Text}, 0.1)
                            task.wait(0.15)
                            Tween(Btn, {BackgroundColor3 = Theme.Tertiary, Size = UDim2.new(0, 220, 0, 30)}, 0.2)
                            Tween(BText, {TextColor3 = Theme.TextDark}, 0.2)
                            callback()
                        end
                    end)
                    
                    Btn.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            Tween(Btn, {BackgroundColor3 = Color3.fromRGB(30, 32, 42)}, 0.15)
                            Tween(BText, {TextColor3 = Theme.Text}, 0.15)
                        end
                    end)
                    Btn.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            Tween(Btn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
                            Tween(BText, {TextColor3 = Theme.TextDark}, 0.15)
                        end
                    end)
                end
                
                function Section:CreateSlider(cfg)
                    cfg = cfg or {}
                    local sName = cfg.Name or "Slider"
                    local min = cfg.Min or 0
                    local max = cfg.Max or 100
                    local default = cfg.Default or min
                    local callback = cfg.Callback or function() end
                    
                    local value = default
                    
                    local SFrame = Instance.new("Frame")
                    SFrame.Size = UDim2.new(0, 260, 0, 40)
                    SFrame.BackgroundTransparency = 1
                    SFrame.Parent = ElementHolder
                    
                    local SLabel = Instance.new("TextLabel")
                    SLabel.AnchorPoint = Vector2.new(0, 0.5)
                    SLabel.Position = UDim2.new(0, 23, 0.5, -8)
                    SLabel.Size = UDim2.new(0, 1, 0, 1)
                    SLabel.AutomaticSize = Enum.AutomaticSize.XY
                    SLabel.BackgroundTransparency = 1
                    SLabel.Text = sName
                    SLabel.TextColor3 = Theme.TextDark
                    SLabel.FontFace = Fonts.Regular
                    SLabel.TextSize = 14
                    SLabel.Parent = SFrame
                    
                    local VLabel = Instance.new("TextLabel")
                    VLabel.AnchorPoint = Vector2.new(1, 0.5)
                    VLabel.Position = UDim2.new(1, -22, 0.5, -8)
                    VLabel.Size = UDim2.new(0, 1, 0, 1)
                    VLabel.AutomaticSize = Enum.AutomaticSize.XY
                    VLabel.BackgroundTransparency = 1
                    VLabel.Text = tostring(value)
                    VLabel.TextColor3 = Theme.Text
                    VLabel.FontFace = Fonts.Regular
                    VLabel.TextSize = 14
                    VLabel.Parent = SFrame
                    
                    local SBG = Instance.new("Frame")
                    SBG.AnchorPoint = Vector2.new(0, 0.5)
                    SBG.Position = UDim2.new(0, 23, 0.5, 13)
                    SBG.Size = UDim2.new(0, 220, 0, 4)
                    SBG.BackgroundColor3 = Theme.Tertiary
                    SBG.Parent = SFrame
                    AddCorner(SBG, 4)
                    AddStroke(SBG)
                    
                    local SFill = Instance.new("Frame")
                    SFill.AnchorPoint = Vector2.new(0, 0.5)
                    SFill.Position = UDim2.new(0, 0, 0.5, 0)
                    SFill.Size = UDim2.new((value - min) / (max - min), 0, 0, 7)
                    SFill.BackgroundColor3 = Theme.Text
                    SFill.Parent = SBG
                    AddCorner(SFill, 4)
                    AddGradient(SFill, 0)
                    
                    local dragging = false
                    
                    local function Upd(input)
                        local pos = math.clamp((input.Position.X - SBG.AbsolutePosition.X) / SBG.AbsoluteSize.X, 0, 1)
                        value = math.floor(min + (max - min) * pos)
                        VLabel.Text = tostring(value)
                        Tween(SFill, {Size = UDim2.new(pos, 0, 0, 7)}, 0.1)
                        callback(value)
                    end
                    
                    SBG.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            Upd(input)
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Upd(input) end
                    end)
                    
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                    end)
                    
                    callback(default)
                    
                    return {Set = function(_, v) value = math.clamp(v, min, max) VLabel.Text = tostring(value) SFill.Size = UDim2.new((value - min) / (max - min), 0, 0, 7) callback(value) end, Get = function() return value end}
                end
                
                return Section
            end
            
            if isFirstSub and isFirst then SubPage:CreateButton(true) end
            
            return SubPage
        end
        
        return Tab
    end
    
    return Window
end

return Centrixity
