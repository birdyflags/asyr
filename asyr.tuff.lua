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
    Dark = Color3.fromRGB(20, 20, 25),
    Darker = Color3.fromRGB(15, 15, 18),
    Black = Color3.fromRGB(10, 10, 12),
    TextDim = Color3.fromRGB(120, 120, 130),
    Accent = Color3.fromRGB(80, 200, 230)
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
    notifFrame.BackgroundTransparency = 0.15
    notifFrame.Position = UDim2.new(0.68, 0, 0.5, -50)
    notifFrame.Size = UDim2.new(0, 0, 0, 100)
    notifFrame.BorderSizePixel = 0
    notifFrame.BackgroundColor3 = Themes.Dark
    notifFrame.Parent = self.ScreenGui
    notifFrame.ZIndex = 999
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notifFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    titleLabel.TextColor3 = Themes.Primary
    titleLabel.Text = title
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 15, 0, 8)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notifFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
    textLabel.TextColor3 = Themes.TextDim
    textLabel.Text = text
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, -20, 0, 50)
    textLabel.Position = UDim2.new(0, 15, 0, 38)
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    textLabel.Parent = notifFrame
    
    -- Animate in
    CreateTween(notifFrame, {Size = UDim2.new(0, 300, 0, 100)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Animate out
    task.delay(duration, function()
        CreateTween(notifFrame, {Size = UDim2.new(0, 0, 0, 100)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.25)
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
    
    -- Main Container
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Position = UDim2.new(0.05, 0, 0.1, 0)
    mainContainer.Size = UDim2.new(0, 1050, 0, 600)
    mainContainer.BorderSizePixel = 0
    mainContainer.BackgroundColor3 = Themes.Black
    mainContainer.Parent = window.ScreenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainContainer
    
    -- LEFT SIDEBAR
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    sidebar.Size = UDim2.new(0, 240, 1, 0)
    sidebar.BorderSizePixel = 0
    sidebar.BackgroundColor3 = Themes.Darker
    sidebar.Parent = mainContainer
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 12)
    sidebarCorner.Parent = sidebar
    
    -- ASYR Title in Sidebar
    local titleLabel = Instance.new("TextLabel")
    titleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    titleLabel.TextColor3 = Themes.Primary
    titleLabel.Text = "ASYR"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 20)
    titleLabel.Size = UDim2.new(0, 200, 0, 40)
    titleLabel.TextSize = 32
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = sidebar
    
    -- Divider
    local divider = Instance.new("Frame")
    divider.Position = UDim2.new(0, 15, 0, 70)
    divider.Size = UDim2.new(0.8, 0, 0, 1)
    divider.BorderSizePixel = 0
    divider.BackgroundColor3 = Themes.Dark
    divider.Parent = sidebar
    
    -- Tab Container in Sidebar
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Position = UDim2.new(0, 0, 0, 80)
    tabContainer.Size = UDim2.new(1, 0, 0.85, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = sidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Vertical
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabContainer
    
    local tabContainerPadding = Instance.new("UIPadding")
    tabContainerPadding.PaddingTop = UDim.new(0, 10)
    tabContainerPadding.PaddingLeft = UDim.new(0, 15)
    tabContainerPadding.PaddingRight = UDim.new(0, 15)
    tabContainerPadding.PaddingBottom = UDim.new(0, 10)
    tabContainerPadding.Parent = tabContainer
    
    -- RIGHT CONTENT AREA
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Position = UDim2.new(0, 240, 0, 0)
    contentArea.Size = UDim2.new(1, -240, 1, 0)
    contentArea.BorderSizePixel = 0
    contentArea.BackgroundColor3 = Themes.Dark
    contentArea.Parent = mainContainer
    
    -- Content Container (Scrollable)
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Position = UDim2.new(0, 30, 0, 30)
    contentContainer.Size = UDim2.new(1, -60, 1, -60)
    contentContainer.BackgroundTransparency = 1
    contentContainer.BorderSizePixel = 0
    contentContainer.ScrollBarThickness = 6
    contentContainer.ScrollBarImageColor3 = Themes.Primary
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentContainer.Parent = contentArea
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 15)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = contentContainer
    
    window.MainContainer = mainContainer
    window.Sidebar = sidebar
    window.TabContainer = tabContainer
    window.ContentContainer = contentContainer
    window.ContentArea = contentArea
    
    return window
end

-- ============================================
-- TAB SYSTEM
-- ============================================

function ASYR:CreateTab(name, icon)
    local tab = {}
    tab.Name = name
    tab.Active = false
    
    -- Tab Button
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "_Tab"
    tabBtn.Text = ""
    tabBtn.BackgroundColor3 = Themes.Darker
    tabBtn.Size = UDim2.new(1, 0, 0, 50)
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = self.TabContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = tabBtn
    
    -- Icon (if provided)
    if icon then
        local iconLabel = Instance.new("ImageLabel")
        iconLabel.Image = icon
        iconLabel.BackgroundTransparency = 1
        iconLabel.Size = UDim2.new(0, 24, 0, 24)
        iconLabel.Position = UDim2.new(0, 12, 0.5, -12)
        iconLabel.ImageColor3 = Themes.TextDim
        iconLabel.Parent = tabBtn
    end
    
    -- Tab Label
    local tabLabel = Instance.new("TextLabel")
    tabLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    tabLabel.Text = name
    tabLabel.BackgroundTransparency = 1
    tabLabel.TextColor3 = Themes.TextDim
    tabLabel.Size = UDim2.new(1, icon and -50 or -20, 1, 0)
    tabLabel.Position = UDim2.new(0, icon and 45 or 12, 0, 0)
    tabLabel.Font = Enum.Font.GothamMedium
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
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = contentPanel
    
    tab.Button = tabBtn
    tab.Panel = contentPanel
    tab.Label = tabLabel
    
    -- Tab Click Handler
    local function SelectTab()
        for _, t in pairs(self.Tabs) do
            t.Panel.Visible = false
            CreateTween(t.Button, {BackgroundColor3 = Themes.Darker}, 0.2)
            CreateTween(t.Label, {TextColor3 = Themes.TextDim}, 0.2)
        end
        
        contentPanel.Visible = true
        CreateTween(tabBtn, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.2)
        CreateTween(tabLabel, {TextColor3 = Themes.Primary}, 0.2)
        self.CurrentTab = tab
    end
    
    tabBtn.MouseButton1Click:Connect(SelectTab)
    
    -- Hover effects
    tabBtn.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            CreateTween(tabBtn, {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}, 0.2)
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            CreateTween(tabBtn, {BackgroundColor3 = Themes.Darker}, 0.2)
        end
    end)
    
    table.insert(self.Tabs, tab)
    
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
    watermarkFrame.Size = UDim2.new(0, 350, 0, 60)
    watermarkFrame.BorderSizePixel = 0
    watermarkFrame.BackgroundColor3 = Themes.Darker
    watermarkFrame.Parent = self.ScreenGui
    
    local wmCorner = Instance.new("UICorner")
    wmCorner.CornerRadius = UDim.new(0, 12)
    wmCorner.Parent = watermarkFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    titleLabel.TextColor3 = Themes.Primary
    titleLabel.Text = "ASYR"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 5)
    titleLabel.Size = UDim2.new(0, 100, 0, 25)
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = watermarkFrame
    
    -- Divider
    local divider = Instance.new("Frame")
    divider.Position = UDim2.new(0.35, 0, 0, 5)
    divider.Size = UDim2.new(0, 1, 0, 50)
    divider.BorderSizePixel = 0
    divider.BackgroundColor3 = Themes.Primary
    divider.Parent = watermarkFrame
    
    -- FPS Label
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    fpsLabel.TextColor3 = Themes.Accent
    fpsLabel.Text = "FPS: 60"
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Position = UDim2.new(0, 125, 0, 5)
    fpsLabel.Size = UDim2.new(0, 100, 0, 25)
    fpsLabel.TextSize = 13
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.Parent = watermarkFrame
    
    -- Ping Label
    local pingLabel = Instance.new("TextLabel")
    pingLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    pingLabel.TextColor3 = Themes.Accent
    pingLabel.Text = "PING: 0ms"
    pingLabel.BackgroundTransparency = 1
    pingLabel.Position = UDim2.new(0, 125, 0, 30)
    pingLabel.Size = UDim2.new(0, 100, 0, 25)
    pingLabel.TextSize = 13
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left
    pingLabel.Parent = watermarkFrame
    
    -- FPS & Ping Update
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
