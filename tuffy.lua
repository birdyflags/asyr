local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

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
    Success = Color3.fromRGB(87, 242, 135),
    Warning = Color3.fromRGB(255, 200, 87),
    Error = Color3.fromRGB(255, 85, 85)
}

local Fonts = {
    Regular = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    Medium = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
    SemiBold = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
    Bold = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
}

local function CreateTween(instance, properties, duration, style, direction)
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    return TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties)
end

local function CreateGradient(parent, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(1, Theme.AccentSecondary)
    })
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Stroke
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
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
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
            CreateTween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.04):Play()
        end
    end)
end

function Centrixity:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Centrixity"
    local subtitle = config.Subtitle or ""
    local size = config.Size or UDim2.new(0, 689, 0, 489)
    
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CentrixityUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = (RunService:IsStudio() and Player:WaitForChild("PlayerGui")) or game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = size
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    CreateCorner(MainFrame, 11)
    
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    CreateTween(MainFrame, {Size = size, BackgroundTransparency = 0}, 0.5, Enum.EasingStyle.Back):Play()
    
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.AnchorPoint = Vector2.new(0.5, 0)
    Header.Position = UDim2.new(0.5, 0, 0, 0)
    Header.Size = UDim2.new(1, 0, 0, 37)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame
    
    local HeaderLine = Instance.new("Frame")
    HeaderLine.Name = "HeaderLine"
    HeaderLine.AnchorPoint = Vector2.new(0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, 0)
    HeaderLine.Size = UDim2.new(1, 0, 0, 2)
    HeaderLine.BackgroundColor3 = Theme.Divider
    HeaderLine.BorderSizePixel = 0
    HeaderLine.Parent = Header
    
    local LibIcon = Instance.new("ImageLabel")
    LibIcon.Name = "LibIcon"
    LibIcon.AnchorPoint = Vector2.new(0, 0.5)
    LibIcon.Position = UDim2.new(0, 12, 0.5, 0)
    LibIcon.Size = UDim2.new(0, 34, 0, 34)
    LibIcon.BackgroundTransparency = 1
    LibIcon.Image = config.Icon or "rbxassetid://137946959393180"
    LibIcon.ScaleType = Enum.ScaleType.Fit
    LibIcon.Parent = Header
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
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
    TabHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    TabHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    TabHolder.Size = UDim2.new(1, 0, 1, 0)
    TabHolder.BackgroundTransparency = 1
    TabHolder.Parent = Sidebar
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabLayout.Parent = TabHolder
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.Parent = TabHolder
    
    local SubHeader = Instance.new("Frame")
    SubHeader.Name = "SubHeader"
    SubHeader.AnchorPoint = Vector2.new(0.5, 0)
    SubHeader.Position = UDim2.new(0.555, 0, 0.076, 0)
    SubHeader.Size = UDim2.new(0, 621, 0, 51)
    SubHeader.BackgroundTransparency = 1
    SubHeader.Parent = MainFrame
    
    local SubTabLayout = Instance.new("UIListLayout")
    SubTabLayout.Padding = UDim.new(0, 8)
    SubTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SubTabLayout.FillDirection = Enum.FillDirection.Horizontal
    SubTabLayout.Parent = SubHeader
    
    local SubTabPadding = Instance.new("UIPadding")
    SubTabPadding.PaddingTop = UDim.new(0, 4)
    SubTabPadding.PaddingLeft = UDim.new(0, 25)
    SubTabPadding.Parent = SubHeader
    
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.AnchorPoint = Vector2.new(1, 1)
    PageContainer.Position = UDim2.new(1, 0, 1, 0)
    PageContainer.Size = UDim2.new(0, 620, 0, 401)
    PageContainer.BackgroundColor3 = Theme.Secondary
    PageContainer.ClipsDescendants = true
    PageContainer.Parent = MainFrame
    CreateCorner(PageContainer, 11)
    
    local NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "NotifHolder"
    NotifHolder.AnchorPoint = Vector2.new(1, 0)
    NotifHolder.Position = UDim2.new(1, -10, 0, 10)
    NotifHolder.Size = UDim2.new(0, 260, 1, -20)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Parent = ScreenGui
    
    local NotifLayout = Instance.new("UIListLayout")
    NotifLayout.Padding = UDim.new(0, 8)
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    NotifLayout.Parent = NotifHolder
    
    function Window:Notify(config)
        config = config or {}
        local notifType = config.Type or "Success"
        local notifTitle = config.Title or "Notification"
        local notifContent = config.Content or ""
        local duration = config.Duration or 4
        
        local colors = {
            Success = {bg = Color3.fromRGB(20, 35, 25), accent = Theme.Success, icon = "rbxassetid://89312000818980"},
            Warning = {bg = Color3.fromRGB(35, 30, 15), accent = Theme.Warning, icon = "rbxassetid://138617498807498"},
            Error = {bg = Color3.fromRGB(40, 20, 20), accent = Theme.Error, icon = "rbxassetid://138617501067622"}
        }
        local style = colors[notifType] or colors.Success
        
        local Notif = Instance.new("Frame")
        Notif.Name = "Notification"
        Notif.Size = UDim2.new(1, 0, 0, 72)
        Notif.BackgroundColor3 = style.bg
        Notif.BackgroundTransparency = 0.1
        Notif.ClipsDescendants = true
        Notif.Parent = NotifHolder
        CreateCorner(Notif, 8)
        CreateStroke(Notif, style.accent, 1)
        
        local AccentBar = Instance.new("Frame")
        AccentBar.Size = UDim2.new(0, 4, 1, -8)
        AccentBar.Position = UDim2.new(0, 4, 0, 4)
        AccentBar.BackgroundColor3 = style.accent
        AccentBar.Parent = Notif
        CreateCorner(AccentBar, 2)
        
        local Icon = Instance.new("ImageLabel")
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.Position = UDim2.new(0, 16, 0, 20)
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.BackgroundTransparency = 1
        Icon.Image = style.icon
        Icon.ImageColor3 = style.accent
        Icon.Parent = Notif
        
        local Title = Instance.new("TextLabel")
        Title.Position = UDim2.new(0, 44, 0, 10)
        Title.Size = UDim2.new(1, -54, 0, 18)
        Title.BackgroundTransparency = 1
        Title.Text = notifTitle
        Title.TextColor3 = Theme.Text
        Title.FontFace = Fonts.SemiBold
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Notif
        
        local Content = Instance.new("TextLabel")
        Content.Position = UDim2.new(0, 16, 0, 32)
        Content.Size = UDim2.new(1, -26, 0, 32)
        Content.BackgroundTransparency = 1
        Content.Text = notifContent
        Content.TextColor3 = Color3.fromRGB(180, 180, 185)
        Content.FontFace = Fonts.Regular
        Content.TextSize = 12
        Content.TextXAlignment = Enum.TextXAlignment.Left
        Content.TextWrapped = true
        Content.Parent = Notif
        
        local Progress = Instance.new("Frame")
        Progress.AnchorPoint = Vector2.new(0, 1)
        Progress.Position = UDim2.new(0, 0, 1, 0)
        Progress.Size = UDim2.new(1, 0, 0, 3)
        Progress.BackgroundColor3 = style.accent
        Progress.Parent = Notif
        CreateCorner(Progress, 2)
        
        Notif.Position = UDim2.new(1, 50, 0, 0)
        Notif.BackgroundTransparency = 1
        CreateTween(Notif, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.1}, 0.35, Enum.EasingStyle.Back):Play()
        CreateTween(Progress, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear):Play()
        
        task.delay(duration, function()
            CreateTween(Notif, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1}, 0.3):Play()
            task.wait(0.35)
            Notif:Destroy()
        end)
    end
    
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or "rbxassetid://80869096876893"
        
        local Tab = {}
        Tab.SubPages = {}
        Tab.ActiveSubPage = nil
        Tab.Name = tabName
        
        local isFirst = #Window.Tabs == 0
        table.insert(Window.Tabs, Tab)
        
        local TabBtn = Instance.new("Frame")
        TabBtn.Name = tabName
        TabBtn.Size = UDim2.new(0, 55, 0, 60)
        TabBtn.BackgroundColor3 = Theme.Text
        TabBtn.BackgroundTransparency = isFirst and 0.9 or 1
        TabBtn.ClipsDescendants = true
        TabBtn.Parent = TabHolder
        CreateCorner(TabBtn, 5)
        
        local TabGradient = CreateGradient(TabBtn, 0)
        TabGradient.Enabled = isFirst
        
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
        CreateCorner(Indicator, 12)
        CreateGradient(Indicator, 0)
        
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
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 20)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.FillDirection = Enum.FillDirection.Horizontal
        PageLayout.Parent = TabPage
        
        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 12)
        PagePadding.PaddingLeft = UDim.new(0, 12)
        PagePadding.Parent = TabPage
        
        if isFirst then Window.ActiveTab = Tab end
        
        local function SelectTab()
            if Window.ActiveTab == Tab then return end
            
            for _, t in pairs(Window.Tabs) do
                local btn = TabHolder:FindFirstChild(t.Name)
                if btn then
                    local icon = btn:FindFirstChild("Icon")
                    local indicator = btn:FindFirstChild("Indicator")
                    local gradient = btn:FindFirstChildOfClass("UIGradient")
                    
                    CreateTween(btn, {BackgroundTransparency = 1}, 0.25):Play()
                    if gradient then gradient.Enabled = false end
                    if icon then CreateTween(icon, {ImageColor3 = Theme.TextDark}, 0.25):Play() end
                    if icon and icon:FindFirstChildOfClass("TextLabel") then
                        CreateTween(icon:FindFirstChildOfClass("TextLabel"), {TextColor3 = Theme.TextDark}, 0.25):Play()
                    end
                    if indicator then CreateTween(indicator, {Size = UDim2.new(0, 0, 0, 6)}, 0.25):Play() end
                    
                    local page = PageContainer:FindFirstChild(t.Name .. "_Page")
                    if page then page.Visible = false end
                end
            end
            
            Window.ActiveTab = Tab
            TabGradient.Enabled = true
            CreateTween(TabBtn, {BackgroundTransparency = 0.9}, 0.25):Play()
            CreateTween(TabIcon, {ImageColor3 = Theme.Accent}, 0.25):Play()
            CreateTween(TabLabel, {TextColor3 = Theme.Text}, 0.25):Play()
            CreateTween(Indicator, {Size = UDim2.new(0, 25, 0, 6)}, 0.3, Enum.EasingStyle.Back):Play()
            TabPage.Visible = true
            
            for _, child in pairs(SubHeader:GetChildren()) do
                if child:IsA("Frame") then child:Destroy() end
            end
            
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
        
        function Tab:CreateSubPage(config)
            config = config or {}
            local subName = config.Name or "SubPage"
            
            local SubPage = {}
            SubPage.Name = subName
            SubPage.Sections = {}
            
            local isFirstSub = #Tab.SubPages == 0
            table.insert(Tab.SubPages, SubPage)
            
            local SubContent = Instance.new("Frame")
            SubContent.Name = subName .. "_Content"
            SubContent.Size = UDim2.new(1, -24, 1, 0)
            SubContent.BackgroundTransparency = 1
            SubContent.Visible = isFirstSub and isFirst
            SubContent.Parent = TabPage
            
            local ContentLayout = Instance.new("UIListLayout")
            ContentLayout.Padding = UDim.new(0, 20)
            ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContentLayout.FillDirection = Enum.FillDirection.Horizontal
            ContentLayout.Parent = SubContent
            
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
                CreateCorner(SubLabel, 4)
                
                if active then CreateGradient(SubLabel, 0) end
                
                local SubPad = Instance.new("UIPadding")
                SubPad.PaddingTop = UDim.new(0, 10)
                SubPad.PaddingBottom = UDim.new(0, 10)
                SubPad.PaddingLeft = UDim.new(0, 8)
                SubPad.PaddingRight = UDim.new(0, 8)
                SubPad.Parent = SubLabel
                
                SubBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        SubPage:Select()
                    end
                end)
            end
            
            function SubPage:Select()
                if Tab.ActiveSubPage == SubPage then return end
                
                for _, sp in pairs(Tab.SubPages) do
                    local content = TabPage:FindFirstChild(sp.Name .. "_Content")
                    if content then
                        CreateTween(content, {BackgroundTransparency = 1}, 0.2):Play()
                        task.delay(0.1, function() content.Visible = false end)
                    end
                    local btn = SubHeader:FindFirstChild(sp.Name)
                    if btn then
                        local lbl = btn:FindFirstChild("Label")
                        if lbl then
                            CreateTween(lbl, {BackgroundTransparency = 1, TextTransparency = 0.15, TextColor3 = Theme.TextDark}, 0.2):Play()
                            local grad = lbl:FindFirstChildOfClass("UIGradient")
                            if grad then grad:Destroy() end
                        end
                    end
                end
                
                Tab.ActiveSubPage = SubPage
                SubContent.Visible = true
                CreateTween(SubContent, {BackgroundTransparency = 1}, 0.25):Play()
                
                local btn = SubHeader:FindFirstChild(subName)
                if btn then
                    local lbl = btn:FindFirstChild("Label")
                    if lbl then
                        CreateTween(lbl, {BackgroundTransparency = 0.8, TextTransparency = 0, TextColor3 = Theme.Text}, 0.2):Play()
                        if not lbl:FindFirstChildOfClass("UIGradient") then CreateGradient(lbl, 0) end
                    end
                end
            end
            
            function SubPage:CreateSection(config)
                config = config or {}
                local secName = config.Name or "Section"
                local secIcon = config.Icon or "rbxassetid://83273732891006"
                local secSide = config.Side or "Left"
                
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
                CreateCorner(SectionFrame, 6)
                
                local SectionHeader = Instance.new("Frame")
                SectionHeader.Name = "Header"
                SectionHeader.AnchorPoint = Vector2.new(0.5, 0)
                SectionHeader.Position = UDim2.new(0.5, 0, 0, 0)
                SectionHeader.Size = UDim2.new(1, 0, 0, 30)
                SectionHeader.BackgroundColor3 = Theme.Background
                SectionHeader.Parent = SectionFrame
                CreateCorner(SectionHeader, 6)
                
                local SectionLine = Instance.new("Frame")
                SectionLine.AnchorPoint = Vector2.new(0.5, 1)
                SectionLine.Position = UDim2.new(0.5, 0, 1, 0)
                SectionLine.Size = UDim2.new(1, 0, 0, 2)
                SectionLine.BorderSizePixel = 0
                SectionLine.Parent = SectionHeader
                CreateGradient(SectionLine, 90)
                
                local AccentLine = Instance.new("Frame")
                AccentLine.AnchorPoint = Vector2.new(0, 0.5)
                AccentLine.Position = UDim2.new(0, -3, 0.5, 0)
                AccentLine.Size = UDim2.new(0, 6, 0, 20)
                AccentLine.BackgroundColor3 = Theme.Accent
                AccentLine.Parent = SectionHeader
                CreateCorner(AccentLine, 30)
                
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
                
                local ElementLayout = Instance.new("UIListLayout")
                ElementLayout.Padding = UDim.new(0, 4)
                ElementLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ElementLayout.Parent = ElementHolder
                
                local ElementPadding = Instance.new("UIPadding")
                ElementPadding.PaddingTop = UDim.new(0, 5)
                ElementPadding.PaddingBottom = UDim.new(0, 45)
                ElementPadding.Parent = ElementHolder
                
                function Section:CreateToggle(config)
                    config = config or {}
                    local toggleName = config.Name or "Toggle"
                    local default = config.Default or false
                    local callback = config.Callback or function() end
                    
                    local state = default
                    
                    local ToggleFrame = Instance.new("Frame")
                    ToggleFrame.Size = UDim2.new(0, 260, 0, 30)
                    ToggleFrame.BackgroundTransparency = 1
                    ToggleFrame.Parent = ElementHolder
                    
                    local ToggleBox = Instance.new("Frame")
                    ToggleBox.AnchorPoint = Vector2.new(0, 0.5)
                    ToggleBox.Position = UDim2.new(0, 25, 0.5, 0)
                    ToggleBox.Size = UDim2.new(0, 14, 0, 14)
                    ToggleBox.BackgroundColor3 = state and Theme.Text or Theme.Tertiary
                    ToggleBox.Parent = ToggleFrame
                    CreateCorner(ToggleBox, 3)
                    if not state then CreateStroke(ToggleBox) end
                    if state then CreateGradient(ToggleBox, 90) end
                    
                    local CheckIcon = Instance.new("ImageLabel")
                    CheckIcon.AnchorPoint = Vector2.new(0.5, 0.5)
                    CheckIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
                    CheckIcon.Size = UDim2.new(0, 8, 0, 7)
                    CheckIcon.BackgroundTransparency = 1
                    CheckIcon.Image = "rbxassetid://83899464799881"
                    CheckIcon.ImageTransparency = state and 0 or 1
                    CheckIcon.Parent = ToggleBox
                    
                    local ToggleLabel = Instance.new("TextLabel")
                    ToggleLabel.AnchorPoint = Vector2.new(0, 0.5)
                    ToggleLabel.Position = UDim2.new(0, 48, 0.5, 0)
                    ToggleLabel.Size = UDim2.new(0, 1, 0, 1)
                    ToggleLabel.AutomaticSize = Enum.AutomaticSize.XY
                    ToggleLabel.BackgroundTransparency = 1
                    ToggleLabel.Text = toggleName
                    ToggleLabel.TextColor3 = state and Theme.Text or Theme.TextDark
                    ToggleLabel.FontFace = Fonts.Regular
                    ToggleLabel.TextSize = 12
                    ToggleLabel.Parent = ToggleFrame
                    
                    local function UpdateToggle()
                        state = not state
                        
                        if state then
                            CreateTween(ToggleBox, {BackgroundColor3 = Theme.Text}, 0.2):Play()
                            CreateTween(CheckIcon, {ImageTransparency = 0}, 0.2):Play()
                            CreateTween(ToggleLabel, {TextColor3 = Theme.Text}, 0.2):Play()
                            local stroke = ToggleBox:FindFirstChildOfClass("UIStroke")
                            if stroke then stroke:Destroy() end
                            if not ToggleBox:FindFirstChildOfClass("UIGradient") then CreateGradient(ToggleBox, 90) end
                        else
                            CreateTween(ToggleBox, {BackgroundColor3 = Theme.Tertiary}, 0.2):Play()
                            CreateTween(CheckIcon, {ImageTransparency = 1}, 0.2):Play()
                            CreateTween(ToggleLabel, {TextColor3 = Theme.TextDark}, 0.2):Play()
                            local grad = ToggleBox:FindFirstChildOfClass("UIGradient")
                            if grad then grad:Destroy() end
                            if not ToggleBox:FindFirstChildOfClass("UIStroke") then CreateStroke(ToggleBox) end
                        end
                        
                        callback(state)
                    end
                    
                    ToggleFrame.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            UpdateToggle()
                        end
                    end)
                    
                    if default then callback(true) end
                    
                    return {
                        Set = function(_, val) if val ~= state then UpdateToggle() end end,
                        Get = function() return state end
                    }
                end
                
                function Section:CreateButton(config)
                    config = config or {}
                    local btnName = config.Name or "Button"
                    local callback = config.Callback or function() end
                    
                    local ButtonFrame = Instance.new("Frame")
                    ButtonFrame.Size = UDim2.new(0, 260, 0, 40)
                    ButtonFrame.BackgroundTransparency = 1
                    ButtonFrame.Parent = ElementHolder
                    
                    local Button = Instance.new("Frame")
                    Button.AnchorPoint = Vector2.new(0.5, 0.5)
                    Button.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Button.Size = UDim2.new(0, 220, 0, 30)
                    Button.BackgroundColor3 = Theme.Tertiary
                    Button.Parent = ButtonFrame
                    CreateCorner(Button, 3)
                    CreateStroke(Button)
                    
                    local ButtonText = Instance.new("TextLabel")
                    ButtonText.AnchorPoint = Vector2.new(0.5, 0.5)
                    ButtonText.Position = UDim2.new(0.5, 0, 0.5, 0)
                    ButtonText.Size = UDim2.new(0, 1, 0, 1)
                    ButtonText.AutomaticSize = Enum.AutomaticSize.XY
                    ButtonText.BackgroundTransparency = 1
                    ButtonText.Text = btnName
                    ButtonText.TextColor3 = Theme.TextDark
                    ButtonText.FontFace = Fonts.Medium
                    ButtonText.TextSize = 13
                    ButtonText.Parent = Button
                    
                    Button.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            CreateTween(Button, {BackgroundColor3 = Theme.Accent}, 0.1):Play()
                            CreateTween(ButtonText, {TextColor3 = Theme.Text}, 0.1):Play()
                            task.wait(0.15)
                            CreateTween(Button, {BackgroundColor3 = Theme.Tertiary}, 0.2):Play()
                            CreateTween(ButtonText, {TextColor3 = Theme.TextDark}, 0.2):Play()
                            callback()
                        end
                    end)
                end
                
                function Section:CreateSlider(config)
                    config = config or {}
                    local sliderName = config.Name or "Slider"
                    local min = config.Min or 0
                    local max = config.Max or 100
                    local default = config.Default or min
                    local callback = config.Callback or function() end
                    
                    local value = default
                    
                    local SliderFrame = Instance.new("Frame")
                    SliderFrame.Size = UDim2.new(0, 260, 0, 40)
                    SliderFrame.BackgroundTransparency = 1
                    SliderFrame.Parent = ElementHolder
                    
                    local SliderLabel = Instance.new("TextLabel")
                    SliderLabel.AnchorPoint = Vector2.new(0, 0.5)
                    SliderLabel.Position = UDim2.new(0, 23, 0.5, -8)
                    SliderLabel.Size = UDim2.new(0, 1, 0, 1)
                    SliderLabel.AutomaticSize = Enum.AutomaticSize.XY
                    SliderLabel.BackgroundTransparency = 1
                    SliderLabel.Text = sliderName
                    SliderLabel.TextColor3 = Theme.TextDark
                    SliderLabel.FontFace = Fonts.Regular
                    SliderLabel.TextSize = 14
                    SliderLabel.Parent = SliderFrame
                    
                    local ValueLabel = Instance.new("TextLabel")
                    ValueLabel.AnchorPoint = Vector2.new(1, 0.5)
                    ValueLabel.Position = UDim2.new(1, -22, 0.5, -8)
                    ValueLabel.Size = UDim2.new(0, 1, 0, 1)
                    ValueLabel.AutomaticSize = Enum.AutomaticSize.XY
                    ValueLabel.BackgroundTransparency = 1
                    ValueLabel.Text = tostring(value)
                    ValueLabel.TextColor3 = Theme.Text
                    ValueLabel.FontFace = Fonts.Regular
                    ValueLabel.TextSize = 14
                    ValueLabel.Parent = SliderFrame
                    
                    local SliderBG = Instance.new("Frame")
                    SliderBG.AnchorPoint = Vector2.new(0, 0.5)
                    SliderBG.Position = UDim2.new(0, 23, 0.5, 13)
                    SliderBG.Size = UDim2.new(0, 220, 0, 4)
                    SliderBG.BackgroundColor3 = Theme.Tertiary
                    SliderBG.Parent = SliderFrame
                    CreateCorner(SliderBG)
                    CreateStroke(SliderBG)
                    
                    local SliderFill = Instance.new("Frame")
                    SliderFill.AnchorPoint = Vector2.new(0, 0.5)
                    SliderFill.Position = UDim2.new(0, 0, 0.5, 0)
                    SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 0, 7)
                    SliderFill.BackgroundColor3 = Theme.Text
                    SliderFill.Parent = SliderBG
                    CreateCorner(SliderFill)
                    CreateGradient(SliderFill, 0)
                    
                    local dragging = false
                    
                    local function Update(input)
                        local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                        value = math.floor(min + (max - min) * pos)
                        ValueLabel.Text = tostring(value)
                        CreateTween(SliderFill, {Size = UDim2.new(pos, 0, 0, 7)}, 0.1):Play()
                        callback(value)
                    end
                    
                    SliderBG.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            Update(input)
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            Update(input)
                        end
                    end)
                    
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)
                    
                    callback(default)
                    
                    return {
                        Set = function(_, val)
                            value = math.clamp(val, min, max)
                            ValueLabel.Text = tostring(value)
                            SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 0, 7)
                            callback(value)
                        end,
                        Get = function() return value end
                    }
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
