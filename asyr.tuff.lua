local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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
    
    local notifFolder = self.ScreenGui:FindFirstChild("notification") or Instance.new("Folder")
    if not self.ScreenGui:FindFirstChild("notification") then
        notifFolder.Name = "notification"
        notifFolder.Parent = self.ScreenGui
    end
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification_frame"
    notifFrame.BackgroundTransparency = 0.1
    notifFrame.Position = UDim2.new(0.7, 0, 0.5, -45)
    notifFrame.BorderColor3 = Themes.Black
    notifFrame.Size = UDim2.new(0, 0, 0, 90)
    notifFrame.BorderSizePixel = 0
    notifFrame.BackgroundColor3 = Themes.DarkGray
    notifFrame.Parent = notifFolder
    
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
    
    -- Tab Buttons Container
    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Name = "TabButtons"
    tabButtonsFrame.Position = UDim2.new(0.08, 0, 0.08, 0)
    tabButtonsFrame.Size = UDim2.new(0.84, 0, 0, 50)
    tabButtonsFrame.BackgroundColor3 = Themes.Dark
    tabButtonsFrame.BorderSizePixel = 0
    tabButtonsFrame.Parent = mainFrame
    
    local tabButtonCorner = Instance.new("UICorner")
    tabButtonCorner.CornerRadius = UDim.new(0, 8)
    tabButtonCorner.Parent = tabButtonsFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabButtonsFrame
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 5)
    tabPadding.PaddingBottom = UDim.new(0, 5)
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingRight = UDim.new(0, 10)
    tabPadding.Parent = tabButtonsFrame
    
    -- Content Container
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Position = UDim2.new(0.08, 0, 0.2, 0)
    contentContainer.Size = UDim2.new(0.84, 0, 0.75, 0)
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
    window.TabButtonsFrame = tabButtonsFrame
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
    
    -- Tab Button
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "_Tab"
    tabBtn.Text = name
    tabBtn.BackgroundColor3 = Themes.Dark
    tabBtn.TextColor3 = Themes.Secondary
    tabBtn.Size = UDim2.new(0, 90, 0, 40)
    tabBtn.BorderSizePixel = 0
    tabBtn.Font = Enum.Font.Michroma
    tabBtn.TextSize = 14
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = self.TabButtonsFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn
    
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
    
    -- Tab Button Click Handler
    local function SelectTab()
        -- Hide all tabs
        for _, t in pairs(self.Tabs) do
            t.Panel.Visible = false
            CreateTween(t.Button, {BackgroundColor3 = Themes.Dark}, 0.2)
        end
        
        -- Show current tab
        contentPanel.Visible = true
        CreateTween(tabBtn, {BackgroundColor3 = Themes.Primary}, 0.2)
        self.CurrentTab = tab
    end
    
    tabBtn.MouseButton1Click:Connect(SelectTab)
    
    -- Hover effects
    tabBtn.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            CreateTween(tabBtn, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
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
    local watermarkFolder = Instance.new("Folder")
    watermarkFolder.Name = "watermark"
    watermarkFolder.Parent = self.ScreenGui
    
    local watermarkFrame = Instance.new("Frame")
    watermarkFrame.Name = "watermark_frame"
    watermarkFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
    watermarkFrame.Size = UDim2.new(0, 380, 0, 70)
    watermarkFrame.BorderSizePixel = 0
    watermarkFrame.BackgroundColor3 = Themes.DarkGray
    watermarkFrame.Parent = watermarkFolder
    
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
