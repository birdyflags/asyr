local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================
-- ASYR UI LIBRARY
-- ============================================

local ASYR = {}
ASYR.__index = ASYR

local Themes = {
    Primary = Color3.fromRGB(135, 67, 202),
    Secondary = Color3.fromRGB(238, 238, 238),
    Dark = Color3.fromRGB(17, 17, 17),
    Black = Color3.fromRGB(0, 0, 0),
    DarkGray = Color3.fromRGB(44, 44, 44),
    LightGray = Color3.fromRGB(47, 47, 47)
}

local function CreateTween(instance, properties, duration, style, direction)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- ============================================
-- NOTIFICATION SYSTEM
-- ============================================

function ASYR:CreateNotification(title, text, duration)
    duration = duration or 3
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification_frame"
    notifFrame.BackgroundTransparency = 0.1
    notifFrame.Position = UDim2.new(0.7, 0, 0.5, -45)
    notifFrame.Size = UDim2.new(0, 0, 0, 90)
    notifFrame.BorderSizePixel = 0
    notifFrame.BackgroundColor3 = Themes.DarkGray
    notifFrame.Parent = self.ScreenGui
    notifFrame.ZIndex = 999
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notifFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    titleLabel.TextColor3 = Themes.Secondary
    titleLabel.Text = title
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notifFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    textLabel.Text = text
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, -20, 0, 45)
    textLabel.Position = UDim2.new(0, 10, 0, 35)
    textLabel.TextSize = 12
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    textLabel.Parent = notifFrame
    
    -- Animate in
    CreateTween(notifFrame, {Size = UDim2.new(0, 290, 0, 90)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Animate out
    task.delay(duration, function()
        CreateTween(notifFrame, {Size = UDim2.new(0, 0, 0, 90)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        notifFrame:Destroy()
    end)
end

-- ============================================
-- MAIN WINDOW CREATION
-- ============================================

function ASYR:New(config)
    local window = setmetatable({}, ASYR)
    
    window.ScreenGui = Instance.new("ScreenGui")
    window.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    window.ScreenGui.ResetOnSpawn = false
    window.ScreenGui.Parent = playerGui
    
    window.Tabs = {}
    window.CurrentTab = nil
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Position = UDim2.new(0.5, -293, 0.5, -192)
    mainFrame.Size = UDim2.new(0, 587, 0, 385)
    mainFrame.BorderSizePixel = 0
    mainFrame.BackgroundColor3 = Themes.Black
    mainFrame.Parent = window.ScreenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    titleLabel.TextColor3 = Themes.Secondary
    titleLabel.Text = config.GameName or "ASYR"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0.5, -100, 0, 5)
    titleLabel.Size = UDim2.new(0, 200, 0, 50)
    titleLabel.TextSize = 40
    titleLabel.Parent = mainFrame
    
    -- Divider
    local divider = Instance.new("Frame")
    divider.Name = "divider_"
    divider.Position = UDim2.new(0, 0, 0, 60)
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.BorderSizePixel = 0
    divider.BackgroundColor3 = Themes.LightGray
    divider.Parent = mainFrame
    
    -- Left Tab Panel (Vertical)
    local tabPanel = Instance.new("Frame")
    tabPanel.Name = "TabPanel"
    tabPanel.Position = UDim2.new(0.08, 0, 0.08, 0)
    tabPanel.Size = UDim2.new(0.25, 0, 0.85, 0)
    tabPanel.BackgroundColor3 = Themes.Black
    tabPanel.BorderSizePixel = 0
    tabPanel.Parent = mainFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Vertical
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabPanel
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 5)
    tabPadding.PaddingBottom = UDim.new(0, 5)
    tabPadding.PaddingLeft = UDim.new(0, 5)
    tabPadding.PaddingRight = UDim.new(0, 5)
    tabPadding.Parent = tabPanel
    
    -- Content Container (Right side)
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Position = UDim2.new(0.35, 0, 0.08, 0)
    contentContainer.Size = UDim2.new(0.57, 0, 0.85, 0)
    contentContainer.BackgroundColor3 = Themes.Black
    contentContainer.BorderSizePixel = 0
    contentContainer.ScrollBarThickness = 0
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentContainer.Parent = mainFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = contentContainer
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.Parent = contentContainer
    
    window.MainFrame = mainFrame
    window.TabPanel = tabPanel
    window.ContentContainer = contentContainer
    
    return window
end

-- ============================================
-- TAB SYSTEM
-- ============================================

function ASYR:CreateTab(name)
    local tab = {}
    tab.Name = name
    tab.Active = false
    
    -- Tab Button with side bar
    local tabBtn = Instance.new("Frame")
    tabBtn.Name = name .. "_Tab"
    tabBtn.BackgroundColor3 = Themes.Dark
    tabBtn.Size = UDim2.new(1, 0, 0, 45)
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = self.TabPanel
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn
    
    -- Purple side bar
    local sideBar = Instance.new("Frame")
    sideBar.Name = "SideBar"
    sideBar.BackgroundColor3 = Themes.Dark
    sideBar.Size = UDim2.new(0, 4, 1, 0)
    sideBar.BorderSizePixel = 0
    sideBar.Parent = tabBtn
    
    local sideBarCorner = Instance.new("UICorner")
    sideBarCorner.CornerRadius = UDim.new(0, 2)
    sideBarCorner.Parent = sideBar
    
    -- Tab label
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Text = name
    tabLabel.BackgroundTransparency = 1
    tabLabel.TextColor3 = Themes.Secondary
    tabLabel.Size = UDim2.new(1, -10, 1, 0)
    tabLabel.Position = UDim2.new(0, 10, 0, 0)
    tabLabel.Font = Enum.Font.Michroma
    tabLabel.TextSize = 14
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Parent = tabBtn
    
    -- Content Panel
    local contentPanel = Instance.new("Frame")
    contentPanel.Name = name .. "_Content"
    contentPanel.BackgroundTransparency = 1
    contentPanel.BorderSizePixel = 0
    contentPanel.Size = UDim2.new(1, 0, 0, 0)
    contentPanel.AutomaticSize = Enum.AutomaticSize.Y
    contentPanel.Visible = false
    contentPanel.Parent = self.ContentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = contentPanel
    
    tab.Button = tabBtn
    tab.Panel = contentPanel
    tab.SideBar = sideBar
    
    -- Tab Button Click Handler
    local function SelectTab()
        -- Hide all tabs and reset colors
        for _, t in pairs(self.Tabs) do
            t.Panel.Visible = false
            CreateTween(t.Button, {BackgroundColor3 = Themes.Dark}, 0.2)
            CreateTween(t.SideBar, {BackgroundColor3 = Themes.Dark}, 0.2)
        end
        
        -- Show current tab and highlight
        contentPanel.Visible = true
        CreateTween(tabBtn, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2)
        CreateTween(sideBar, {BackgroundColor3 = Themes.Primary}, 0.2)
        self.CurrentTab = tab
    end
    
    local clickDetector = Instance.new("TextButton")
    clickDetector.Text = ""
    clickDetector.BackgroundTransparency = 1
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.Parent = tabBtn
    clickDetector.AutoButtonColor = false
    
    clickDetector.MouseButton1Click:Connect(SelectTab)
    
    -- Hover effects
    clickDetector.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            CreateTween(tabBtn, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
        end
    end)
    
    clickDetector.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            CreateTween(tabBtn, {BackgroundColor3 = Themes.Dark}, 0.2)
        end
    end)
    
    table.insert(self.Tabs, tab)
    
    -- Auto-select first tab
    if #self.Tabs == 1 then
        SelectTab()
    end
    
    return contentPanel
end

-- ============================================
-- WATERMARK WITH FPS & PING
-- ============================================

function ASYR:CreateWatermark()
    local watermarkFrame = Instance.new("Frame")
    watermarkFrame.Name = "watermark_frame"
    watermarkFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
    watermarkFrame.Size = UDim2.new(0, 380, 0, 70)
    watermarkFrame.BorderSizePixel = 0
    watermarkFrame.BackgroundColor3 = Themes.DarkGray
    watermarkFrame.Parent = self.ScreenGui
    
    local wmCorner = Instance.new("UICorner")
    wmCorner.CornerRadius = UDim.new(0, 10)
    wmCorner.Parent = watermarkFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    titleLabel.TextColor3 = Themes.Secondary
    titleLabel.Text = "ASYR"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.Size = UDim2.new(0, 150, 0, 30)
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = watermarkFrame
    
    -- Divider
    local divider = Instance.new("Frame")
    divider.Position = UDim2.new(0.4, 0, 0, 0)
    divider.Size = UDim2.new(0, 1, 1, 0)
    divider.BorderSizePixel = 0
    divider.BackgroundColor3 = Themes.Primary
    divider.Parent = watermarkFrame
    
    -- FPS Label
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    fpsLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    fpsLabel.Text = "FPS: 60"
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Position = UDim2.new(0.42, 0, 0, 5)
    fpsLabel.Size = UDim2.new(0, 180, 0, 30)
    fpsLabel.TextSize = 14
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.Parent = watermarkFrame
    
    -- Ping Label
    local pingLabel = Instance.new("TextLabel")
    pingLabel.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    pingLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    pingLabel.Text = "PING: 0ms"
    pingLabel.BackgroundTransparency = 1
    pingLabel.Position = UDim2.new(0.42, 0, 0, 35)
    pingLabel.Size = UDim2.new(0, 180, 0, 30)
    pingLabel.TextSize = 14
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left
    pingLabel.Parent = watermarkFrame
    
    -- FPS & Ping Update Loop
    local lastTime = tick()
    local fps = 60
    
    RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        local delta = currentTime - lastTime
        lastTime = currentTime
        if delta > 0 then
            fps = math.floor(1 / delta)
            fpsLabel.Text = "FPS: " .. fps
        end
        
        -- Ping calculation
        local stats = game:FindService("Stats")
        if stats then
            pcall(function()
                local ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                pingLabel.Text = "PING: " .. math.floor(ping) .. "ms"
            end)
        end
    end)
end

return ASYR
