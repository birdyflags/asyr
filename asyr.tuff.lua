--[[
    CentrixUI - Modern Roblox UI Library
    Features: Game Loader, Acrylic Blur, Smooth Animations
]]

-- Cleanup existing instances
if game.CoreGui:FindFirstChild("CentrixUI") then game.CoreGui:FindFirstChild("CentrixUI"):Destroy() end
if game.CoreGui:FindFirstChild("CentrixNotifs") then game.CoreGui:FindFirstChild("CentrixNotifs"):Destroy() end

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer

-- Theme
local Theme = {
    Primary = Color3.fromRGB(90, 120, 220),
    PrimaryDark = Color3.fromRGB(70, 95, 180),
    PrimaryLight = Color3.fromRGB(120, 150, 255),
    Accent = Color3.fromRGB(130, 160, 255),
    Background = Color3.fromRGB(18, 18, 22),
    BackgroundLight = Color3.fromRGB(25, 25, 32),
    Surface = Color3.fromRGB(32, 32, 40),
    SurfaceLight = Color3.fromRGB(45, 45, 55),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(140, 140, 160),
    Border = Color3.fromRGB(60, 60, 80),
    Success = Color3.fromRGB(80, 200, 120),
    Warning = Color3.fromRGB(240, 180, 60),
    Error = Color3.fromRGB(240, 80, 80),
    Glow = Color3.fromRGB(90, 120, 220),
}

-- Library
local CentrixUI = {
    Flags = {},
    Theme = Theme,
}

-- Utilities
local function Tween(obj, props, duration, style, direction)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function MakeDraggable(dragObj, targetObj)
    local dragging, dragInput, dragStart, startPos
    dragObj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetObj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragObj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(targetObj, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.08)
        end
    end)
end

-- Create Acrylic Blur
local function CreateAcrylicBlur()
    local blur = Lighting:FindFirstChild("CentrixBlur")
    if not blur then
        blur = Instance.new("BlurEffect")
        blur.Name = "CentrixBlur"
        blur.Size = 0
        blur.Parent = Lighting
    end
    return blur
end

-- Main ScreenGui
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "CentrixUI"
MainGui.Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
MainGui.ResetOnSpawn = false

-- Notification GUI
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "CentrixNotifs"
NotifGui.Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui
NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
NotifGui.ResetOnSpawn = false

local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "NotifHolder"
NotifHolder.Parent = NotifGui
NotifHolder.AnchorPoint = Vector2.new(1, 1)
NotifHolder.BackgroundTransparency = 1
NotifHolder.Position = UDim2.new(1, -20, 1, -20)
NotifHolder.Size = UDim2.new(0, 320, 0.8, 0)

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = NotifHolder
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 10)

-- Notification Function with Acrylic
function CentrixUI:Notify(title, message, duration, notifType)
    duration = duration or 4
    notifType = notifType or "info"
    
    local notifColor = Theme.Primary
    if notifType == "success" then notifColor = Theme.Success
    elseif notifType == "warning" then notifColor = Theme.Warning
    elseif notifType == "error" then notifColor = Theme.Error end
    
    local Notif = Instance.new("Frame")
    Notif.Parent = NotifHolder
    Notif.BackgroundColor3 = Theme.Background
    Notif.BackgroundTransparency = 0.15
    Notif.Size = UDim2.new(1, 0, 0, 75)
    Notif.Position = UDim2.new(1.2, 0, 0, 0)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Notif
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Notif
    Stroke.Color = notifColor
    Stroke.Thickness = 1
    Stroke.Transparency = 0.5
    
    local AccentBar = Instance.new("Frame")
    AccentBar.Parent = Notif
    AccentBar.BackgroundColor3 = notifColor
    AccentBar.Size = UDim2.new(0, 4, 1, -16)
    AccentBar.Position = UDim2.new(0, 8, 0, 8)
    Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(0, 2)
    
    local Title = Instance.new("TextLabel")
    Title.Parent = Notif
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 10)
    Title.Size = UDim2.new(1, -30, 0, 18)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = Theme.Text
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Message = Instance.new("TextLabel")
    Message.Parent = Notif
    Message.BackgroundTransparency = 1
    Message.Position = UDim2.new(0, 20, 0, 30)
    Message.Size = UDim2.new(1, -30, 0, 35)
    Message.Font = Enum.Font.Gotham
    Message.Text = message
    Message.TextColor3 = Theme.TextDim
    Message.TextSize = 12
    Message.TextWrapped = true
    Message.TextXAlignment = Enum.TextXAlignment.Left
    Message.TextYAlignment = Enum.TextYAlignment.Top
    
    local Progress = Instance.new("Frame")
    Progress.Parent = Notif
    Progress.BackgroundColor3 = notifColor
    Progress.Position = UDim2.new(0, 0, 1, -3)
    Progress.Size = UDim2.new(1, 0, 0, 3)
    Instance.new("UICorner", Progress).CornerRadius = UDim.new(0, 2)
    
    Tween(Notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.35, Enum.EasingStyle.Back)
    Tween(Progress, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear)
    
    task.delay(duration, function()
        Tween(Notif, {Position = UDim2.new(1.2, 0, 0, 0), BackgroundTransparency = 1}, 0.35)
        task.wait(0.4)
        Notif:Destroy()
    end)
end

-- LOADER UI
function CentrixUI.Start(config)
    config = config or {}
    local games = config.Games or {}
    local loaderTitle = config.Title or "What would you like to load?"
    
    local currentGameId = game.PlaceId
    local selectedGame = nil
    
    -- Create loader container
    local LoaderFrame = Instance.new("Frame")
    LoaderFrame.Name = "Loader"
    LoaderFrame.Parent = MainGui
    LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    LoaderFrame.BackgroundColor3 = Theme.Background
    LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoaderFrame.Size = UDim2.new(0, 0, 0, 0)
    LoaderFrame.BackgroundTransparency = 0.05
    
    local LoaderCorner = Instance.new("UICorner")
    LoaderCorner.CornerRadius = UDim.new(0, 12)
    LoaderCorner.Parent = LoaderFrame
    
    local LoaderStroke = Instance.new("UIStroke")
    LoaderStroke.Parent = LoaderFrame
    LoaderStroke.Color = Theme.Border
    LoaderStroke.Thickness = 1
    LoaderStroke.Transparency = 0.5
    
    -- Title
    local LoaderTitle = Instance.new("TextLabel")
    LoaderTitle.Parent = LoaderFrame
    LoaderTitle.BackgroundTransparency = 1
    LoaderTitle.Position = UDim2.new(0, 0, 0, 25)
    LoaderTitle.Size = UDim2.new(1, 0, 0, 30)
    LoaderTitle.Font = Enum.Font.GothamBold
    LoaderTitle.Text = loaderTitle
    LoaderTitle.TextColor3 = Theme.Text
    LoaderTitle.TextSize = 18
    LoaderTitle.TextTransparency = 1
    
    -- Games container
    local GamesContainer = Instance.new("Frame")
    GamesContainer.Parent = LoaderFrame
    GamesContainer.BackgroundTransparency = 1
    GamesContainer.Position = UDim2.new(0, 20, 0, 70)
    GamesContainer.Size = UDim2.new(1, -40, 1, -90)
    
    local GamesLayout = Instance.new("UIListLayout")
    GamesLayout.Parent = GamesContainer
    GamesLayout.SortOrder = Enum.SortOrder.LayoutOrder
    GamesLayout.Padding = UDim.new(0, 8)
    
    -- Animate loader in
    local targetHeight = math.min(80 + (#games * 48), 400)
    Tween(LoaderFrame, {Size = UDim2.new(0, 350, 0, targetHeight)}, 0.4, Enum.EasingStyle.Back)
    task.wait(0.2)
    Tween(LoaderTitle, {TextTransparency = 0}, 0.3)
    
    -- Create game buttons
    local function loadGame(gameData)
        if currentGameId == gameData.GameId then
            -- Correct game - load UI
            Tween(LoaderFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
            task.wait(0.35)
            LoaderFrame:Destroy()
            CentrixUI:Notify("CentrixUI", "Loaded successfully!", 3, "success")
            return CentrixUI:CreateWindow({Title = gameData.Name})
        else
            -- Wrong game
            CentrixUI:Notify("Wrong Game", "You need to be in " .. gameData.Name .. " to load this!", 4, "error")
            return nil
        end
    end
    
    for i, gameData in ipairs(games) do
        local GameBtn = Instance.new("TextButton")
        GameBtn.Parent = GamesContainer
        GameBtn.BackgroundColor3 = Theme.Surface
        GameBtn.Size = UDim2.new(1, 0, 0, 40)
        GameBtn.Font = Enum.Font.GothamMedium
        GameBtn.Text = gameData.Name
        GameBtn.TextColor3 = Theme.Text
        GameBtn.TextSize = 14
        GameBtn.AutoButtonColor = false
        GameBtn.BackgroundTransparency = 1
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 8)
        BtnCorner.Parent = GameBtn
        
        -- Animate in
        task.delay(0.1 * i, function()
            Tween(GameBtn, {BackgroundTransparency = 0}, 0.25)
        end)
        
        GameBtn.MouseEnter:Connect(function()
            Tween(GameBtn, {BackgroundColor3 = Theme.SurfaceLight}, 0.15)
        end)
        
        GameBtn.MouseLeave:Connect(function()
            Tween(GameBtn, {BackgroundColor3 = Theme.Surface}, 0.15)
        end)
        
        GameBtn.MouseButton1Click:Connect(function()
            Tween(GameBtn, {BackgroundColor3 = Theme.Primary}, 0.1)
            task.wait(0.15)
            local window = loadGame(gameData)
            if window then
                return window
            end
            Tween(GameBtn, {BackgroundColor3 = Theme.Surface}, 0.2)
        end)
    end
    
    -- Return awaitable
    return {
        LoadGame = function(self, gameName)
            for _, g in ipairs(games) do
                if g.Name == gameName then
                    return loadGame(g)
                end
            end
        end
    }
end

-- CREATE WINDOW
function CentrixUI:CreateWindow(options)
    options = options or {}
    local title = options.Title or "CentrixUI"
    local size = options.Size or UDim2.new(0, 650, 0, 450)
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    
    local Window = {Tabs = {}, Visible = true}
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Parent = MainGui
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = size
    MainFrame.BackgroundTransparency = 0.02
    MainFrame.ClipsDescendants = true
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = MainFrame
    Stroke.Color = Theme.Border
    Stroke.Thickness = 1
    Stroke.Transparency = 0.6
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.BackgroundLight
    Sidebar.Size = UDim2.new(0, 55, 1, 0)
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)
    
    local SidebarFix = Instance.new("Frame")
    SidebarFix.Parent = Sidebar
    SidebarFix.BackgroundColor3 = Theme.BackgroundLight
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Position = UDim2.new(1, -10, 0, 0)
    SidebarFix.Size = UDim2.new(0, 10, 1, 0)
    
    -- Logo
    local Logo = Instance.new("TextLabel")
    Logo.Parent = Sidebar
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 0, 0, 12)
    Logo.Size = UDim2.new(1, 0, 0, 25)
    Logo.Font = Enum.Font.GothamBold
    Logo.Text = "C"
    Logo.TextColor3 = Theme.Primary
    Logo.TextSize = 22
    
    -- Tab Buttons
    local TabButtons = Instance.new("Frame")
    TabButtons.Parent = Sidebar
    TabButtons.BackgroundTransparency = 1
    TabButtons.Position = UDim2.new(0, 0, 0, 50)
    TabButtons.Size = UDim2.new(1, 0, 1, -50)
    
    local TabButtonsLayout = Instance.new("UIListLayout")
    TabButtonsLayout.Parent = TabButtons
    TabButtonsLayout.Padding = UDim.new(0, 6)
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Theme.Surface
    TopBar.Position = UDim2.new(0, 55, 0, 0)
    TopBar.Size = UDim2.new(1, -55, 0, 45)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    MakeDraggable(TopBar, MainFrame)
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 55, 0, 45)
    ContentArea.Size = UDim2.new(1, -55, 1, -45)
    
    local TabPages = Instance.new("Folder")
    TabPages.Name = "TabPages"
    TabPages.Parent = ContentArea
    
    -- Toggle visibility
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == toggleKey then
            Window.Visible = not Window.Visible
            MainFrame.Visible = Window.Visible
        end
    end)
    
    -- Tab Function
    function Window:Tab(name, icon)
        local Tab = {Sections = {}}
        local tabIndex = #self.Tabs + 1
        table.insert(self.Tabs, Tab)
        
        -- Tab Button
        local TabBtn = Instance.new("Frame")
        TabBtn.Parent = TabButtons
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 40)
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = TabBtn
        TabIcon.AnchorPoint = Vector2.new(0.5, 0)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0.5, 0, 0, 6)
        TabIcon.Size = UDim2.new(0, 18, 0, 18)
        TabIcon.Image = "rbxassetid://" .. (icon or "10734950309")
        TabIcon.ImageColor3 = Theme.TextDim
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Parent = TabBtn
        TabLabel.BackgroundTransparency = 1
        TabLabel.Position = UDim2.new(0, 0, 0, 25)
        TabLabel.Size = UDim2.new(1, 0, 0, 12)
        TabLabel.Font = Enum.Font.Gotham
        TabLabel.Text = name
        TabLabel.TextColor3 = Theme.TextDim
        TabLabel.TextSize = 9
        
        local Highlight = Instance.new("Frame")
        Highlight.Parent = TabBtn
        Highlight.BackgroundColor3 = Theme.Primary
        Highlight.Position = UDim2.new(0, 0, 0.5, -10)
        Highlight.Size = UDim2.new(0, 3, 0, 0)
        Instance.new("UICorner", Highlight).CornerRadius = UDim.new(0, 2)
        
        -- Tab Page
        local TabPage = Instance.new("Frame")
        TabPage.Parent = TabPages
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.Visible = false
        
        local LeftSection = Instance.new("ScrollingFrame")
        LeftSection.Parent = TabPage
        LeftSection.BackgroundTransparency = 1
        LeftSection.Position = UDim2.new(0, 10, 0, 10)
        LeftSection.Size = UDim2.new(0.5, -15, 1, -20)
        LeftSection.ScrollBarThickness = 2
        LeftSection.ScrollBarImageColor3 = Theme.Primary
        LeftSection.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.Parent = LeftSection
        LeftLayout.Padding = UDim.new(0, 6)
        LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            LeftSection.CanvasSize = UDim2.new(0, 0, 0, LeftLayout.AbsoluteContentSize.Y + 10)
        end)
        
        local RightSection = Instance.new("ScrollingFrame")
        RightSection.Parent = TabPage
        RightSection.BackgroundTransparency = 1
        RightSection.Position = UDim2.new(0.5, 5, 0, 10)
        RightSection.Size = UDim2.new(0.5, -15, 1, -20)
        RightSection.ScrollBarThickness = 2
        RightSection.ScrollBarImageColor3 = Theme.Primary
        RightSection.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.Parent = RightSection
        RightLayout.Padding = UDim.new(0, 6)
        RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            RightSection.CanvasSize = UDim2.new(0, 0, 0, RightLayout.AbsoluteContentSize.Y + 10)
        end)
        
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabBtn
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.Text = ""
        
        local function SelectTab()
            for _, page in pairs(TabPages:GetChildren()) do page.Visible = false end
            for _, btn in pairs(TabButtons:GetChildren()) do
                if btn:IsA("Frame") then
                    local ic = btn:FindFirstChild("ImageLabel")
                    local lb = btn:FindFirstChild("TextLabel")
                    local hl = btn:FindFirstChild("Frame")
                    if ic then Tween(ic, {ImageColor3 = Theme.TextDim}, 0.2) end
                    if lb then Tween(lb, {TextColor3 = Theme.TextDim}, 0.2) end
                    if hl then Tween(hl, {Size = UDim2.new(0, 3, 0, 0)}, 0.2) end
                end
            end
            TabPage.Visible = true
            Tween(TabIcon, {ImageColor3 = Theme.Text}, 0.2)
            Tween(TabLabel, {TextColor3 = Theme.Text}, 0.2)
            Tween(Highlight, {Size = UDim2.new(0, 3, 0, 20)}, 0.2)
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        if tabIndex == 1 then task.defer(SelectTab) end
        
        -- TOGGLE
        function Tab:Toggle(side, text, default, callback)
            local parent = side == "Left" and LeftSection or RightSection
            local toggled = default or false
            callback = callback or function() end
            
            local Toggle = Instance.new("Frame")
            Toggle.Parent = parent
            Toggle.BackgroundColor3 = Theme.Surface
            Toggle.Size = UDim2.new(1, 0, 0, 36)
            Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)
            
            local Title = Instance.new("TextLabel")
            Title.Parent = Toggle
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.Size = UDim2.new(1, -60, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = text
            Title.TextColor3 = toggled and Theme.Text or Theme.TextDim
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local Back = Instance.new("Frame")
            Back.Parent = Toggle
            Back.AnchorPoint = Vector2.new(1, 0.5)
            Back.BackgroundColor3 = toggled and Theme.Primary or Theme.SurfaceLight
            Back.Position = UDim2.new(1, -10, 0.5, 0)
            Back.Size = UDim2.new(0, 38, 0, 20)
            Instance.new("UICorner", Back).CornerRadius = UDim.new(1, 0)
            
            local Circle = Instance.new("Frame")
            Circle.Parent = Back
            Circle.AnchorPoint = Vector2.new(0, 0.5)
            Circle.BackgroundColor3 = Theme.Text
            Circle.Position = toggled and UDim2.new(0, 20, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
            
            local Btn = Instance.new("TextButton")
            Btn.Parent = Toggle
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.Text = ""
            
            local function Update()
                Tween(Circle, {Position = toggled and UDim2.new(0, 20, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)}, 0.15)
                Tween(Back, {BackgroundColor3 = toggled and Theme.Primary or Theme.SurfaceLight}, 0.15)
                Tween(Title, {TextColor3 = toggled and Theme.Text or Theme.TextDim}, 0.15)
            end
            
            Btn.MouseButton1Click:Connect(function()
                toggled = not toggled
                Update()
                callback(toggled)
            end)
            
            if default then callback(true) end
            
            local obj = {}
            function obj:Set(v) toggled = v Update() callback(toggled) end
            function obj:Get() return toggled end
            return obj
        end
        
        -- BUTTON
        function Tab:Button(side, text, callback)
            local parent = side == "Left" and LeftSection or RightSection
            callback = callback or function() end
            
            local Btn = Instance.new("Frame")
            Btn.Parent = parent
            Btn.BackgroundColor3 = Theme.Surface
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            
            local Inner = Instance.new("TextButton")
            Inner.Parent = Btn
            Inner.AnchorPoint = Vector2.new(0.5, 0.5)
            Inner.BackgroundColor3 = Theme.Primary
            Inner.Position = UDim2.new(0.5, 0, 0.5, 0)
            Inner.Size = UDim2.new(1, -16, 0, 26)
            Inner.Font = Enum.Font.GothamMedium
            Inner.Text = text
            Inner.TextColor3 = Theme.Text
            Inner.TextSize = 13
            Inner.AutoButtonColor = false
            Instance.new("UICorner", Inner).CornerRadius = UDim.new(0, 4)
            
            Inner.MouseEnter:Connect(function() Tween(Inner, {BackgroundColor3 = Theme.PrimaryDark}, 0.15) end)
            Inner.MouseLeave:Connect(function() Tween(Inner, {BackgroundColor3 = Theme.Primary}, 0.15) end)
            Inner.MouseButton1Click:Connect(callback)
        end
        
        -- SLIDER
        function Tab:Slider(side, text, min, max, default, callback)
            local parent = side == "Left" and LeftSection or RightSection
            local value = default or min
            callback = callback or function() end
            
            local Slider = Instance.new("Frame")
            Slider.Parent = parent
            Slider.BackgroundColor3 = Theme.Surface
            Slider.Size = UDim2.new(1, 0, 0, 50)
            Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 6)
            
            local Title = Instance.new("TextLabel")
            Title.Parent = Slider
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 12, 0, 6)
            Title.Size = UDim2.new(1, -60, 0, 16)
            Title.Font = Enum.Font.Gotham
            Title.Text = text
            Title.TextColor3 = Theme.Text
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local Value = Instance.new("TextLabel")
            Value.Parent = Slider
            Value.AnchorPoint = Vector2.new(1, 0)
            Value.BackgroundTransparency = 1
            Value.Position = UDim2.new(1, -12, 0, 6)
            Value.Size = UDim2.new(0, 40, 0, 16)
            Value.Font = Enum.Font.GothamMedium
            Value.Text = tostring(value)
            Value.TextColor3 = Theme.Primary
            Value.TextSize = 12
            Value.TextXAlignment = Enum.TextXAlignment.Right
            
            local Back = Instance.new("Frame")
            Back.Parent = Slider
            Back.BackgroundColor3 = Theme.SurfaceLight
            Back.Position = UDim2.new(0, 12, 0, 30)
            Back.Size = UDim2.new(1, -24, 0, 6)
            Instance.new("UICorner", Back).CornerRadius = UDim.new(1, 0)
            
            local Fill = Instance.new("Frame")
            Fill.Parent = Back
            Fill.BackgroundColor3 = Theme.Primary
            Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
            
            local Circle = Instance.new("Frame")
            Circle.Parent = Back
            Circle.AnchorPoint = Vector2.new(0.5, 0.5)
            Circle.BackgroundColor3 = Theme.Text
            Circle.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.ZIndex = 2
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
            
            local dragging = false
            
            local function Update(input)
                local pos = math.clamp((input.Position.X - Back.AbsolutePosition.X) / Back.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * pos + 0.5)
                Value.Text = tostring(value)
                Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
                Tween(Circle, {Position = UDim2.new(pos, 0, 0.5, 0)}, 0.05)
                callback(value)
            end
            
            Back.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    Update(input)
                end
            end)
            Back.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
            end)
            
            callback(value)
            
            local obj = {}
            function obj:Set(v)
                value = math.clamp(v, min, max)
                local pos = (value - min) / (max - min)
                Value.Text = tostring(value)
                Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                Tween(Circle, {Position = UDim2.new(pos, 0, 0.5, 0)}, 0.1)
                callback(value)
            end
            return obj
        end
        
        -- DROPDOWN
        function Tab:Dropdown(side, text, options, default, callback, multi)
            local parent = side == "Left" and LeftSection or RightSection
            callback = callback or function() end
            options = options or {}
            multi = multi or false
            
            local selected = {}
            local opened = false
            
            if multi then
                if type(default) == "table" then
                    for _, v in pairs(default) do selected[v] = true end
                end
            else
                selected = default
            end
            
            local function getDisplay()
                if multi then
                    local items = {}
                    for _, opt in ipairs(options) do
                        if selected[opt] then table.insert(items, opt) end
                    end
                    if #items == 0 then return "None"
                    elseif #items > 2 then return items[1] .. ", " .. items[2] .. " (+" .. (#items - 2) .. ")"
                    else return table.concat(items, ", ") end
                else
                    return selected or "Select..."
                end
            end
            
            local function getSelectedTable()
                local items = {}
                for _, opt in ipairs(options) do
                    if selected[opt] then table.insert(items, opt) end
                end
                return items
            end
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Parent = parent
            Dropdown.BackgroundColor3 = Theme.Surface
            Dropdown.Size = UDim2.new(1, 0, 0, 36)
            Dropdown.ClipsDescendants = false
            Dropdown.ZIndex = 5
            Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)
            
            local Title = Instance.new("TextLabel")
            Title.Parent = Dropdown
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.Size = UDim2.new(0.4, 0, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = text
            Title.TextColor3 = Theme.Text
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.ZIndex = 5
            
            local Box = Instance.new("Frame")
            Box.Parent = Dropdown
            Box.AnchorPoint = Vector2.new(1, 0.5)
            Box.BackgroundColor3 = Theme.SurfaceLight
            Box.Position = UDim2.new(1, -10, 0.5, 0)
            Box.Size = UDim2.new(0.5, -10, 0, 24)
            Box.ZIndex = 5
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
            
            local Selected = Instance.new("TextLabel")
            Selected.Parent = Box
            Selected.BackgroundTransparency = 1
            Selected.Position = UDim2.new(0, 8, 0, 0)
            Selected.Size = UDim2.new(1, -30, 1, 0)
            Selected.Font = Enum.Font.Gotham
            Selected.Text = getDisplay()
            Selected.TextColor3 = Theme.TextDim
            Selected.TextSize = 11
            Selected.TextXAlignment = Enum.TextXAlignment.Left
            Selected.TextTruncate = Enum.TextTruncate.AtEnd
            Selected.ZIndex = 6
            
            local Arrow = Instance.new("ImageLabel")
            Arrow.Parent = Box
            Arrow.AnchorPoint = Vector2.new(1, 0.5)
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -5, 0.5, 0)
            Arrow.Size = UDim2.new(0, 14, 0, 14)
            Arrow.Image = "rbxassetid://10709790948"
            Arrow.ImageColor3 = Theme.TextDim
            Arrow.ZIndex = 6
            
            local List = Instance.new("Frame")
            List.Parent = Dropdown
            List.AnchorPoint = Vector2.new(1, 0)
            List.BackgroundColor3 = Theme.Surface
            List.Position = UDim2.new(1, -10, 0, 38)
            List.Size = UDim2.new(0.5, -10, 0, 0)
            List.ClipsDescendants = true
            List.Visible = false
            List.ZIndex = 100
            Instance.new("UICorner", List).CornerRadius = UDim.new(0, 4)
            
            local ListStroke = Instance.new("UIStroke")
            ListStroke.Parent = List
            ListStroke.Color = Theme.Border
            ListStroke.Thickness = 1
            
            local Scroll = Instance.new("ScrollingFrame")
            Scroll.Parent = List
            Scroll.BackgroundTransparency = 1
            Scroll.Size = UDim2.new(1, 0, 1, 0)
            Scroll.ScrollBarThickness = 2
            Scroll.ScrollBarImageColor3 = Theme.Primary
            Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            Scroll.ZIndex = 101
            
            local Layout = Instance.new("UIListLayout")
            Layout.Parent = Scroll
            Layout.Padding = UDim.new(0, 2)
            
            local function CreateOptions()
                for _, child in pairs(Scroll:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                
                for _, opt in ipairs(options) do
                    local Option = Instance.new("TextButton")
                    Option.Parent = Scroll
                    Option.BackgroundColor3 = Theme.SurfaceLight
                    Option.BackgroundTransparency = 1
                    Option.Size = UDim2.new(1, -4, 0, 24)
                    Option.Font = Enum.Font.Gotham
                    Option.Text = "  " .. opt
                    Option.TextColor3 = (multi and selected[opt]) and Theme.Primary or Theme.TextDim
                    Option.TextSize = 11
                    Option.TextXAlignment = Enum.TextXAlignment.Left
                    Option.AutoButtonColor = false
                    Option.ZIndex = 102
                    Instance.new("UICorner", Option).CornerRadius = UDim.new(0, 3)
                    
                    Option.MouseEnter:Connect(function() Tween(Option, {BackgroundTransparency = 0}, 0.1) end)
                    Option.MouseLeave:Connect(function() Tween(Option, {BackgroundTransparency = 1}, 0.1) end)
                    
                    Option.MouseButton1Click:Connect(function()
                        if multi then
                            selected[opt] = not selected[opt]
                            Option.TextColor3 = selected[opt] and Theme.Primary or Theme.TextDim
                            Selected.Text = getDisplay()
                            callback(getSelectedTable())
                        else
                            selected = opt
                            Selected.Text = opt
                            opened = false
                            List.Visible = false
                            Tween(List, {Size = UDim2.new(0.5, -10, 0, 0)}, 0.15)
                            Tween(Arrow, {Rotation = 0}, 0.15)
                            callback(opt)
                        end
                    end)
                end
                
                Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
            end
            
            CreateOptions()
            
            local Btn = Instance.new("TextButton")
            Btn.Parent = Box
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.Text = ""
            Btn.ZIndex = 7
            
            Btn.MouseButton1Click:Connect(function()
                opened = not opened
                List.Visible = true
                local height = math.min(#options * 26 + 4, 150)
                Tween(List, {Size = UDim2.new(0.5, -10, 0, opened and height or 0)}, 0.2)
                Tween(Arrow, {Rotation = opened and 180 or 0}, 0.2)
                if not opened then
                    task.delay(0.2, function() List.Visible = false end)
                end
            end)
            
            local obj = {}
            function obj:Refresh(newOpts) options = newOpts CreateOptions() end
            function obj:Set(v)
                if multi then
                    selected = {}
                    for _, val in pairs(v) do selected[val] = true end
                    Selected.Text = getDisplay()
                    CreateOptions()
                else
                    selected = v
                    Selected.Text = v
                end
            end
            return obj
        end
        
        -- TEXTBOX
        function Tab:Textbox(side, text, placeholder, callback)
            local parent = side == "Left" and LeftSection or RightSection
            callback = callback or function() end
            
            local Textbox = Instance.new("Frame")
            Textbox.Parent = parent
            Textbox.BackgroundColor3 = Theme.Surface
            Textbox.Size = UDim2.new(1, 0, 0, 36)
            Instance.new("UICorner", Textbox).CornerRadius = UDim.new(0, 6)
            
            local Title = Instance.new("TextLabel")
            Title.Parent = Textbox
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.Size = UDim2.new(0.4, 0, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = text
            Title.TextColor3 = Theme.Text
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local Input = Instance.new("TextBox")
            Input.Parent = Textbox
            Input.AnchorPoint = Vector2.new(1, 0.5)
            Input.BackgroundColor3 = Theme.SurfaceLight
            Input.Position = UDim2.new(1, -10, 0.5, 0)
            Input.Size = UDim2.new(0.5, -10, 0, 24)
            Input.Font = Enum.Font.Gotham
            Input.PlaceholderText = placeholder or "Enter..."
            Input.Text = ""
            Input.TextColor3 = Theme.Text
            Input.PlaceholderColor3 = Theme.TextDim
            Input.TextSize = 11
            Input.ClearTextOnFocus = false
            Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 4)
            
            Input.FocusLost:Connect(function(enter)
                if enter and Input.Text ~= "" then callback(Input.Text) end
            end)
        end
        
        -- LABEL
        function Tab:Label(side, text)
            local parent = side == "Left" and LeftSection or RightSection
            
            local Label = Instance.new("Frame")
            Label.Parent = parent
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 0, 24)
            
            local LabelText = Instance.new("TextLabel")
            LabelText.Parent = Label
            LabelText.BackgroundTransparency = 1
            LabelText.Position = UDim2.new(0, 10, 0, 0)
            LabelText.Size = UDim2.new(1, -10, 1, 0)
            LabelText.Font = Enum.Font.GothamBold
            LabelText.Text = text
            LabelText.TextColor3 = Theme.Primary
            LabelText.TextSize = 13
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            
            local obj = {}
            function obj:SetText(t) LabelText.Text = t end
            return obj
        end
        
        -- KEYBIND
        function Tab:Keybind(side, text, default, callback)
            local parent = side == "Left" and LeftSection or RightSection
            local key = default or Enum.KeyCode.Unknown
            callback = callback or function() end
            
            local Keybind = Instance.new("Frame")
            Keybind.Parent = parent
            Keybind.BackgroundColor3 = Theme.Surface
            Keybind.Size = UDim2.new(1, 0, 0, 36)
            Instance.new("UICorner", Keybind).CornerRadius = UDim.new(0, 6)
            
            local Title = Instance.new("TextLabel")
            Title.Parent = Keybind
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.Size = UDim2.new(1, -80, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = text
            Title.TextColor3 = Theme.Text
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local KeyBtn = Instance.new("TextButton")
            KeyBtn.Parent = Keybind
            KeyBtn.AnchorPoint = Vector2.new(1, 0.5)
            KeyBtn.BackgroundColor3 = Theme.SurfaceLight
            KeyBtn.Position = UDim2.new(1, -10, 0.5, 0)
            KeyBtn.Size = UDim2.new(0, 60, 0, 24)
            KeyBtn.Font = Enum.Font.GothamMedium
            KeyBtn.Text = key.Name
            KeyBtn.TextColor3 = Theme.TextDim
            KeyBtn.TextSize = 11
            KeyBtn.AutoButtonColor = false
            Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 4)
            
            local listening = false
            
            KeyBtn.MouseButton1Click:Connect(function()
                listening = true
                KeyBtn.Text = "..."
                Tween(KeyBtn, {BackgroundColor3 = Theme.Primary}, 0.15)
            end)
            
            UserInputService.InputBegan:Connect(function(input, gpe)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    key = input.KeyCode
                    KeyBtn.Text = key.Name
                    listening = false
                    Tween(KeyBtn, {BackgroundColor3 = Theme.SurfaceLight}, 0.15)
                    callback(key)
                elseif not gpe and input.KeyCode == key then
                    callback(key)
                end
            end)
            
            local obj = {}
            function obj:Set(k) key = k KeyBtn.Text = k.Name end
            function obj:Get() return key end
            return obj
        end
        
        return Tab
    end
    
    function Window:Destroy()
        MainFrame:Destroy()
    end
    
    return Window
end

return CentrixUI
