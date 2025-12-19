local CentrixUI = {}
CentrixUI.__index = CentrixUI

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Configuration
local Config = {
    Colors = {
        Primary = Color3.fromRGB(25, 25, 40),
        Secondary = Color3.fromRGB(35, 35, 55),
        Accent = Color3.fromRGB(100, 80, 180),
        AccentDark = Color3.fromRGB(60, 50, 120),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 180, 190),
        Success = Color3.fromRGB(80, 200, 120),
        Error = Color3.fromRGB(220, 80, 80),
        Warning = Color3.fromRGB(240, 180, 60),
        Glow = Color3.fromRGB(120, 100, 200),
    },
    Fonts = {
        Title = Enum.Font.GothamBold,
        Regular = Enum.Font.Gotham,
        Light = Enum.Font.GothamMedium,
    },
    Animation = {
        Fast = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        Normal = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        Slow = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    },
SupportedGames = {
    [2753915549] = "Blox Fruits",       -- ✅ Correct
    [2850353602] = "Da Hood",            -- ✅ Fixed (was 6284583030)
    [907085734] = "Murder Mystery 2",    -- ✅ Fixed (was 142823291)
    [286090429] = "Arsenal",             -- ✅ Correct
    [4924922222] = "Brookhaven RP",      -- ✅ Correct
}
}

-- Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(instance, tweenInfo, properties)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function GetGameName(gameId)
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(gameId, Enum.InfoType.Asset)
    end)
    if success and info then
        return info.Name
    end
    return "Unknown Game"
end

local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Config.Colors.Accent,
        Thickness = thickness or 1,
        Transparency = transparency or 0.5,
        Parent = parent
    })
end

local function AddPadding(parent, padding)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, padding),
        PaddingBottom = UDim.new(0, padding),
        PaddingLeft = UDim.new(0, padding),
        PaddingRight = UDim.new(0, padding),
        Parent = parent
    })
end

local function AddGradient(parent, colors, rotation)
    return Create("UIGradient", {
        Color = ColorSequence.new(colors or {
            ColorSequenceKeypoint.new(0, Config.Colors.Accent),
            ColorSequenceKeypoint.new(1, Config.Colors.AccentDark)
        }),
        Rotation = rotation or 45,
        Parent = parent
    })
end

-- Blur Effect Handler
local BlurEffect = nil
local function CreateBlur()
    if not BlurEffect then
        BlurEffect = Create("BlurEffect", {
            Size = 0,
            Parent = game:GetService("Lighting")
        })
    end
    return BlurEffect
end

local function SetBlur(size, instant)
    local blur = CreateBlur()
    if instant then
        blur.Size = size
    else
        Tween(blur, Config.Animation.Normal, {Size = size})
    end
end

-- Main Library Class
function CentrixUI.new(config)
    local self = setmetatable({}, CentrixUI)
    
    self.Config = config or {}
    self.ScreenGui = nil
    self.MainFrame = nil
    self.Tabs = {}
    self.CurrentTab = nil
    self.Keybinds = {}
    self.Notifications = {}
    self.Visible = true
    self.ToggleKey = Enum.KeyCode.Insert
    
    return self
end

-- Phase 1: Initial Loading Animation
function CentrixUI:CreateLoader(logoId, callback)
    local screenGui = Create("ScreenGui", {
        Name = "CentrixLoader",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = Player:WaitForChild("PlayerGui")
    })
    
    -- Background overlay
    local overlay = Create("Frame", {
        Name = "Overlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 10, 15),
        BackgroundTransparency = 0,
        Parent = screenGui
    })
    
    -- Loading container
    local container = Create("Frame", {
        Name = "LoadingContainer",
        Size = UDim2.new(0, 300, 0, 300),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Parent = overlay
    })
    container.Size = UDim2.new(0, 0, 0, 0)
    
    -- Logo
    local logo = Create("ImageLabel", {
        Name = "Logo",
        Size = UDim2.new(0, 120, 0, 120),
        Position = UDim2.new(0.5, 0, 0.4, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = logoId or "rbxassetid://0",
        ImageTransparency = 1,
        Parent = container
    })
    
    -- Subtitle
    local subtitle = Create("TextLabel", {
        Name = "Subtitle",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0.5, 0, 0.65, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Text = "B E S T  S C R I P T",
        TextColor3 = Color3.fromRGB(150, 150, 160),
        TextSize = 14,
        Font = Config.Fonts.Light,
        TextTransparency = 1,
        Parent = container
    })
    
    -- Glow effect behind logo
    local glow = Create("ImageLabel", {
        Name = "Glow",
        Size = UDim2.new(0, 200, 0, 200),
        Position = UDim2.new(0.5, 0, 0.4, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Config.Colors.Glow,
        ImageTransparency = 1,
        ZIndex = 0,
        Parent = container
    })
    
    -- Animate in
    Tween(container, Config.Animation.Bounce, {
        Size = UDim2.new(0, 300, 0, 300)
    })
    
    task.delay(0.2, function()
        Tween(logo, Config.Animation.Normal, {ImageTransparency = 0})
        Tween(glow, Config.Animation.Slow, {ImageTransparency = 0.5})
    end)
    
    task.delay(0.4, function()
        Tween(subtitle, Config.Animation.Normal, {TextTransparency = 0})
    end)
    
    -- Wait 3 seconds then fade out
    task.delay(3, function()
        Tween(logo, Config.Animation.Normal, {ImageTransparency = 1})
        Tween(subtitle, Config.Animation.Normal, {TextTransparency = 1})
        Tween(glow, Config.Animation.Normal, {ImageTransparency = 1})
        
        task.wait(0.5)
        
        if callback then
            callback(screenGui, overlay, container)
        end
    end)
    
    return screenGui, overlay, container
end

-- Phase 2: Responsive Scaling & Centrix Display
function CentrixUI:ShowCentrixTitle(overlay, container, callback)
    local isMobile = IsMobile()
    local scaleFactor = isMobile and 0.8 or 1
    
    -- Clear container
    for _, child in pairs(container:GetChildren()) do
        child:Destroy()
    end
    
    -- Centrix logo/title
    local centrixLogo = Create("ImageLabel", {
        Name = "CentrixLogo",
        Size = UDim2.new(0, 60 * scaleFactor, 0, 60 * scaleFactor),
        Position = UDim2.new(0.5, 0, 0.35, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://0", -- Placeholder logo
        ImageTransparency = 1,
        Parent = container
    })
    
    local centrixTitle = Create("TextLabel", {
        Name = "CentrixTitle",
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0.5, 0, 0.55, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Text = "CENTRIX",
        TextColor3 = Config.Colors.Text,
        TextSize = 36 * scaleFactor,
        Font = Config.Fonts.Title,
        TextTransparency = 1,
        Parent = container
    })
    
    local versionLabel = Create("TextLabel", {
        Name = "Version",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0.5, 0, 0.68, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Text = "v1.0",
        TextColor3 = Config.Colors.TextDim,
        TextSize = 14 * scaleFactor,
        Font = Config.Fonts.Light,
        TextTransparency = 1,
        Parent = container
    })
    
    -- Animate in
    Tween(centrixLogo, Config.Animation.Normal, {ImageTransparency = 0})
    Tween(centrixTitle, Config.Animation.Normal, {TextTransparency = 0})
    task.delay(0.2, function()
        Tween(versionLabel, Config.Animation.Normal, {TextTransparency = 0})
    end)
    
    -- Check game support
    task.delay(1.5, function()
        local gameId = game.PlaceId
        local isSupported = Config.SupportedGames[gameId] ~= nil
        
        if callback then
            callback(isSupported, gameId, centrixLogo, centrixTitle, versionLabel)
        end
    end)
end

-- Phase 3: Game Detection & Confirmation
function CentrixUI:ShowGameConfirmation(overlay, container, gameId, onConfirm, onCancel)
    local gameName = Config.SupportedGames[gameId] or GetGameName(gameId)
    local isMobile = IsMobile()
    local scaleFactor = isMobile and 0.85 or 1
    
    -- Get game thumbnail
    local thumbnailUrl = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. gameId .. "&width=768&height=432&format=png"
    
    -- Create background with game thumbnail
    local bgImage = Create("ImageLabel", {
        Name = "GameBackground",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxthumb://type=GameIcon&id=" .. gameId .. "&w=512&h=512",
        ImageTransparency = 0.85,
        ScaleType = Enum.ScaleType.Crop,
        Parent = overlay
    })
    bgImage.ZIndex = 0
    overlay.ZIndex = 1
    
    -- Confirmation card
    local card = Create("Frame", {
        Name = "ConfirmationCard",
        Size = UDim2.new(0, 350 * scaleFactor, 0, 200 * scaleFactor),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Config.Colors.Primary,
        BackgroundTransparency = 0.1,
        Parent = container
    })
    AddCorner(card, 12)
    AddStroke(card, Config.Colors.Accent, 1, 0.7)
    
    -- Card gradient
    AddGradient(card, {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 35, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 40))
    }, 180)
    
    -- Question text
    local question = Create("TextLabel", {
        Name = "Question",
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.new(0.5, 0, 0, 25),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Text = "Would you like to load",
        TextColor3 = Config.Colors.TextDim,
        TextSize = 16 * scaleFactor,
        Font = Config.Fonts.Regular,
        Parent = card
    })
    
    -- Game name
    local gameNameLabel = Create("TextLabel", {
        Name = "GameName",
        Size = UDim2.new(1, -40, 0, 35),
        Position = UDim2.new(0.5, 0, 0, 55),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Text = gameName .. "?",
        TextColor3 = Config.Colors.Text,
        TextSize = 22 * scaleFactor,
        Font = Config.Fonts.Title,
        TextWrapped = true,
        Parent = card
    })
    
    -- Button container
    local buttonContainer = Create("Frame", {
        Name = "Buttons",
        Size = UDim2.new(1, -40, 0, 45),
        Position = UDim2.new(0.5, 0, 1, -65),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Parent = card
    })
    
    -- Yes button
    local yesBtn = Create("TextButton", {
        Name = "YesButton",
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Config.Colors.Success,
        Text = "Yes",
        TextColor3 = Config.Colors.Text,
        TextSize = 16 * scaleFactor,
        Font = Config.Fonts.Title,
        AutoButtonColor = false,
        Parent = buttonContainer
    })
    AddCorner(yesBtn, 8)
    
    -- No button
    local noBtn = Create("TextButton", {
        Name = "NoButton",
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0.52, 0, 0, 0),
        BackgroundColor3 = Config.Colors.Error,
        Text = "Don't Load",
        TextColor3 = Config.Colors.Text,
        TextSize = 16 * scaleFactor,
        Font = Config.Fonts.Title,
        AutoButtonColor = false,
        Parent = buttonContainer
    })
    AddCorner(noBtn, 8)
    
    -- Button hover effects
    local function HoverEffect(button, originalColor)
        button.MouseEnter:Connect(function()
            Tween(button, Config.Animation.Fast, {
                BackgroundColor3 = Color3.new(
                    math.min(originalColor.R + 0.1, 1),
                    math.min(originalColor.G + 0.1, 1),
                    math.min(originalColor.B + 0.1, 1)
                )
            })
        end)
        button.MouseLeave:Connect(function()
            Tween(button, Config.Animation.Fast, {BackgroundColor3 = originalColor})
        end)
    end
    
    HoverEffect(yesBtn, Config.Colors.Success)
    HoverEffect(noBtn, Config.Colors.Error)
    
    -- Scale in animation
    card.Size = UDim2.new(0, 0, 0, 0)
    Tween(card, Config.Animation.Bounce, {
        Size = UDim2.new(0, 350 * scaleFactor, 0, 200 * scaleFactor)
    })
    
    -- Button clicks
    yesBtn.MouseButton1Click:Connect(function()
        Tween(card, Config.Animation.Fast, {Size = UDim2.new(0, 0, 0, 0)})
        Tween(overlay, Config.Animation.Normal, {BackgroundTransparency = 1})
        
        task.wait(0.4)
        if onConfirm then onConfirm() end
    end)
    
    noBtn.MouseButton1Click:Connect(function()
        Tween(card, Config.Animation.Fast, {Size = UDim2.new(0, 0, 0, 0)})
        Tween(overlay, Config.Animation.Normal, {BackgroundTransparency = 1})
        
        task.wait(0.4)
        container.Parent:Destroy()
        if onCancel then onCancel() end
    end)
end
-- Phase 4: Main UI Window
function CentrixUI:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Centrix"
    local subtitle = options.Subtitle or ""
    local isMobile = IsMobile()
    local scaleFactor = isMobile and 0.85 or 1
    
    -- Main ScreenGui
    self.ScreenGui = Create("ScreenGui", {
        Name = "CentrixUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = Player:WaitForChild("PlayerGui")
    })
    
    -- Main container
    self.MainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 550 * scaleFactor, 0, 380 * scaleFactor),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Config.Colors.Primary,
        BackgroundTransparency = 0.05,
        Parent = self.ScreenGui
    })
    AddCorner(self.MainFrame, 12)
    AddStroke(self.MainFrame, Config.Colors.Accent, 1, 0.6)
    
    -- Acrylic blur background
    local blur = Create("ImageLabel", {
        Name = "AcrylicBlur",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://8992230677",
        ImageColor3 = Config.Colors.Primary,
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(99, 99, 99, 99),
        Parent = self.MainFrame
    })
    AddCorner(blur, 12)
    blur.ZIndex = 0
    
    -- Top bar
    local topBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Config.Colors.Secondary,
        BackgroundTransparency = 0.3,
        Parent = self.MainFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = topBar})
    
    -- Fix bottom corners of topbar
    local topBarFix = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = Config.Colors.Secondary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = topBar
    })
    
    -- Title
    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Config.Colors.Text,
        TextSize = 18,
        Font = Config.Fonts.Title,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    -- Subtitle
    if subtitle ~= "" then
        local subtitleLabel = Create("TextLabel", {
            Name = "Subtitle",
            Size = UDim2.new(0, 200, 0, 16),
            Position = UDim2.new(0, 15, 0.5, 6),
            BackgroundTransparency = 1,
            Text = subtitle,
            TextColor3 = Config.Colors.TextDim,
            TextSize = 12,
            Font = Config.Fonts.Light,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = topBar
        })
        titleLabel.Position = UDim2.new(0, 15, 0.5, -10)
        titleLabel.Size = UDim2.new(0, 200, 0, 20)
    end
    
    -- Close button
    local closeBtn = Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Config.Colors.Error,
        BackgroundTransparency = 0.5,
        Text = "×",
        TextColor3 = Config.Colors.Text,
        TextSize = 20,
        Font = Config.Fonts.Title,
        AutoButtonColor = false,
        Parent = topBar
    })
    AddCorner(closeBtn, 6)
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Toggle(false)
    end)
    
    -- Sidebar
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 140, 1, -55),
        Position = UDim2.new(0, 5, 0, 50),
        BackgroundColor3 = Config.Colors.Secondary,
        BackgroundTransparency = 0.5,
        Parent = self.MainFrame
    })
    AddCorner(sidebar, 8)
    
    local tabList = Create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Config.Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = tabList
    })
    
    -- Content area
    local content = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -160, 1, -55),
        Position = UDim2.new(0, 150, 0, 50),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = self.MainFrame
    })
    
    self.Sidebar = sidebar
    self.TabList = tabList
    self.Content = content
    
    -- Dragging functionality
    local dragging, dragStart, startPos
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Tween(self.MainFrame, Config.Animation.Fast, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            })
        end
    end)
    
    -- Toggle with keybind
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == self.ToggleKey then
            self:Toggle()
        end
    end)
    
    -- Mobile toggle button
    if isMobile then
        local mobileToggle = Create("TextButton", {
            Name = "MobileToggle",
            Size = UDim2.new(0, 50, 0, 50),
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Config.Colors.Accent,
            Text = "☰",
            TextColor3 = Config.Colors.Text,
            TextSize = 24,
            Font = Config.Fonts.Title,
            Parent = self.ScreenGui
        })
        AddCorner(mobileToggle, 25)
        
        mobileToggle.MouseButton1Click:Connect(function()
            self:Toggle()
        end)
    end
    
    -- Pop-in animation
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Tween(self.MainFrame, Config.Animation.Bounce, {
        Size = UDim2.new(0, 550 * scaleFactor, 0, 380 * scaleFactor)
    })
    
    return self
end

-- Add Tab
function CentrixUI:AddTab(options)
    options = options or {}
    local name = options.Name or "Tab"
    local icon = options.Icon or ""
    
    local tabButton = Create("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Config.Colors.Primary,
        BackgroundTransparency = 0.8,
        Text = "",
        AutoButtonColor = false,
        Parent = self.TabList
    })
    AddCorner(tabButton, 6)
    
    if icon ~= "" then
        local iconLabel = Create("ImageLabel", {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image = icon,
            ImageColor3 = Config.Colors.TextDim,
            Parent = tabButton
        })
    end
    
    local tabLabel = Create("TextLabel", {
        Size = UDim2.new(1, icon ~= "" and -40 or -20, 1, 0),
        Position = UDim2.new(0, icon ~= "" and 35 or 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Config.Colors.TextDim,
        TextSize = 14,
        Font = Config.Fonts.Regular,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tabButton
    })
    
    -- Tab content
    local tabContent = Create("ScrollingFrame", {
        Name = name .. "Content",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Config.Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.Content
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = tabContent
    })
    AddPadding(tabContent, 5)
    
    local tabData = {
        Button = tabButton,
        Content = tabContent,
        Name = name,
        Library = self
    }
    
    table.insert(self.Tabs, tabData)
    
    -- First tab is active
    if #self.Tabs == 1 then
        self:SelectTab(tabData)
    end
    
    -- Tab click
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tabData)
    end)
    
    -- Hover effect
    tabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= tabData then
            Tween(tabButton, Config.Animation.Fast, {BackgroundTransparency = 0.5})
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= tabData then
            Tween(tabButton, Config.Animation.Fast, {BackgroundTransparency = 0.8})
        end
    end)
    
    return tabData
end

-- Select Tab
function CentrixUI:SelectTab(tabData)
    if self.CurrentTab then
        self.CurrentTab.Content.Visible = false
        Tween(self.CurrentTab.Button, Config.Animation.Fast, {BackgroundTransparency = 0.8})
        self.CurrentTab.Button:FindFirstChild("TextLabel").TextColor3 = Config.Colors.TextDim
    end
    
    self.CurrentTab = tabData
    tabData.Content.Visible = true
    Tween(tabData.Button, Config.Animation.Fast, {
        BackgroundTransparency = 0.3,
        BackgroundColor3 = Config.Colors.Accent
    })
    tabData.Button:FindFirstChild("TextLabel").TextColor3 = Config.Colors.Text
end

-- Toggle visibility
function CentrixUI:Toggle(state)
    if state == nil then
        state = not self.Visible
    end
    self.Visible = state
    
    if state then
        self.MainFrame.Visible = true
        Tween(self.MainFrame, Config.Animation.Bounce, {
            Size = UDim2.new(0, 550 * (IsMobile() and 0.85 or 1), 0, 380 * (IsMobile() and 0.85 or 1))
        })
        SetBlur(8)
    else
        Tween(self.MainFrame, Config.Animation.Fast, {Size = UDim2.new(0, 0, 0, 0)})
        SetBlur(0)
        task.delay(0.3, function()
            if not self.Visible then
                self.MainFrame.Visible = false
            end
        end)
    end
end

-- Toggle component
function CentrixUI.AddToggle(tab, options)
    options = options or {}
    local name = options.Name or "Toggle"
    local default = options.Default or false
    local callback = options.Callback or function() end
    
    local toggleFrame = Create("Frame", {
        Name = name .. "Toggle",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Config.Colors.Secondary,
        BackgroundTransparency = 0.5,
        Parent = tab.Content
    })
    AddCorner(toggleFrame, 6)
    
    local label = Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Config.Colors.Text,
        TextSize = 14,
        Font = Config.Fonts.Regular,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toggleFrame
    })
    
    local toggleBtn = Create("Frame", {
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -54, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Config.Colors.Primary,
        Parent = toggleFrame
    })
    AddCorner(toggleBtn, 11)
    AddStroke(toggleBtn, Config.Colors.Accent, 1, 0.7)
    
    local toggleCircle = Create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 3, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Config.Colors.TextDim,
        Parent = toggleBtn
    })
    AddCorner(toggleCircle, 8)
    
    local state = default
    
    local function UpdateToggle()
        if state then
            Tween(toggleCircle, Config.Animation.Fast, {
                Position = UDim2.new(1, -19, 0.5, 0),
                BackgroundColor3 = Config.Colors.Accent
            })
            Tween(toggleBtn, Config.Animation.Fast, {
                BackgroundColor3 = Config.Colors.AccentDark
            })
        else
            Tween(toggleCircle, Config.Animation.Fast, {
                Position = UDim2.new(0, 3, 0.5, 0),
                BackgroundColor3 = Config.Colors.TextDim
            })
            Tween(toggleBtn, Config.Animation.Fast, {
                BackgroundColor3 = Config.Colors.Primary
            })
        end
        callback(state)
    end
    
    if default then UpdateToggle() end
    
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            state = not state
            UpdateToggle()
        end
    end)
    
    return {
        Set = function(value)
            state = value
            UpdateToggle()
        end,
        Get = function()
            return state
        end
    }
end

-- Slider component
function CentrixUI.AddSlider(tab, options)
    options = options or {}
    local name = options.Name or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or min
    local callback = options.Callback or function() end
    
    local sliderFrame = Create("Frame", {
        Name = name .. "Slider",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Config.Colors.Secondary,
        BackgroundTransparency = 0.5,
        Parent = tab.Content
    })
    AddCorner(sliderFrame, 6)
    
    local label = Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 20),
        Position = UDim2.new(0, 12, 0, 5),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Config.Colors.Text,
        TextSize = 14,
        Font = Config.Fonts.Regular,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sliderFrame
    })
    
    local valueLabel = Create("TextLabel", {
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -55, 0, 5),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = Config.Colors.Accent,
        TextSize = 14,
        Font = Config.Fonts.Title,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = sliderFrame
    })
    
    local sliderBar = Create("Frame", {
        Size = UDim2.new(1, -24, 0, 6),
        Position = UDim2.new(0, 12, 0, 32),
        BackgroundColor3 = Config.Colors.Primary,
        Parent = sliderFrame
    })
    AddCorner(sliderBar, 3)
    
    local sliderFill = Create("Frame", {
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Config.Colors.Accent,
        Parent = sliderBar
    })
    AddCorner(sliderFill, 3)
    AddGradient(sliderFill)
    
    local sliderKnob = Create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Config.Colors.Text,
        Parent = sliderBar
    })
    AddCorner(sliderKnob, 7)
    
    local value = default
    local dragging = false
    
    local function UpdateSlider(input)
        local percent = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * percent)
        valueLabel.Text = tostring(value)
        
        Tween(sliderFill, Config.Animation.Fast, {Size = UDim2.new(percent, 0, 1, 0)})
        Tween(sliderKnob, Config.Animation.Fast, {Position = UDim2.new(percent, 0, 0.5, 0)})
        
        callback(value)
    end
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end)
    
    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    
    return {
        Set = function(val)
            value = math.clamp(val, min, max)
            local percent = (value - min) / (max - min)
            valueLabel.Text = tostring(value)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderKnob.Position = UDim2.new(percent, 0, 0.5, 0)
            callback(value)
        end,
        Get = function()
            return value
        end
    }
end

-- Continue with dropdown, notifications, keybinds in next file...

-- Dropdown (Single & Multi-select)
function CentrixUI.AddDropdown(tab, options)
    options = options or {}
    local name = options.Name or "Dropdown"
    local items = options.Items or {}
    local default = options.Default or (options.Multi and {} or nil)
    local multi = options.Multi or false
    local callback = options.Callback or function() end
    
    local dropdownFrame = Create("Frame", {
        Name = name .. "Dropdown",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Config.Colors.Secondary,
        BackgroundTransparency = 0.5,
        ClipsDescendants = false,
        Parent = tab.Content
    })
    AddCorner(dropdownFrame, 6)
    
    local label = Create("TextLabel", {
        Size = UDim2.new(0.5, -10, 0, 35),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Config.Colors.Text,
        TextSize = 14,
        Font = Config.Fonts.Regular,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dropdownFrame
    })
    
    local dropButton = Create("TextButton", {
        Size = UDim2.new(0.5, -10, 0, 28),
        Position = UDim2.new(0.5, 5, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Config.Colors.Primary,
        Text = "",
        AutoButtonColor = false,
        Parent = dropdownFrame
    })
    AddCorner(dropButton, 6)
    AddStroke(dropButton, Config.Colors.Accent, 1, 0.7)
    
    local selectedText = Create("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = multi and "Select..." or (default or "Select..."),
        TextColor3 = Config.Colors.TextDim,
        TextSize = 13,
        Font = Config.Fonts.Regular,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = dropButton
    })
    
    local arrow = Create("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = Config.Colors.Accent,
        TextSize = 10,
        Font = Config.Fonts.Title,
        Parent = dropButton
    })
    
    local dropdownList = Create("Frame", {
        Name = "List",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = Config.Colors.Primary,
        BackgroundTransparency = 0.1,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 100,
        Parent = dropButton
    })
    AddCorner(dropdownList, 6)
    AddStroke(dropdownList, Config.Colors.Accent, 1, 0.5)
    
    local listContent = Create("ScrollingFrame", {
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.new(0, 3, 0, 3),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Config.Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 101,
        Parent = dropdownList
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        Parent = listContent
    })
    
    local isOpen = false
    local selected = multi and (default or {}) or default
    
    local function UpdateText()
        if multi then
            if #selected == 0 then
                selectedText.Text = "Select..."
                selectedText.TextColor3 = Config.Colors.TextDim
            else
                selectedText.Text = table.concat(selected, ", ")
                selectedText.TextColor3 = Config.Colors.Text
            end
        else
            selectedText.Text = selected or "Select..."
            selectedText.TextColor3 = selected and Config.Colors.Text or Config.Colors.TextDim
        end
    end
    
    local function PopulateList()
        for _, child in pairs(listContent:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        for _, item in ipairs(items) do
            local itemBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = Config.Colors.Secondary,
                BackgroundTransparency = 0.7,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 102,
                Parent = listContent
            })
            AddCorner(itemBtn, 4)
            
            local itemLabel = Create("TextLabel", {
                Size = UDim2.new(1, multi and -30 or -10, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text = item,
                TextColor3 = Config.Colors.Text,
                TextSize = 13,
                Font = Config.Fonts.Regular,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 103,
                Parent = itemBtn
            })
            
            if multi then
                local checkmark = Create("TextLabel", {
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -25, 0, 0),
                    BackgroundTransparency = 1,
                    Text = table.find(selected, item) and "✓" or "",
                    TextColor3 = Config.Colors.Accent,
                    TextSize = 14,
                    Font = Config.Fonts.Title,
                    ZIndex = 103,
                    Parent = itemBtn
                })
                
                itemBtn.MouseButton1Click:Connect(function()
                    local index = table.find(selected, item)
                    if index then
                        table.remove(selected, index)
                        checkmark.Text = ""
                    else
                        table.insert(selected, item)
                        checkmark.Text = "✓"
                    end
                    UpdateText()
                    callback(selected)
                end)
            else
                itemBtn.MouseButton1Click:Connect(function()
                    selected = item
                    UpdateText()
                    callback(selected)
                    isOpen = false
                    Tween(dropdownList, Config.Animation.Fast, {Size = UDim2.new(1, 0, 0, 0)})
                    Tween(arrow, Config.Animation.Fast, {Rotation = 0})
                    task.delay(0.2, function() dropdownList.Visible = false end)
                end)
            end
            
            itemBtn.MouseEnter:Connect(function()
                Tween(itemBtn, Config.Animation.Fast, {BackgroundTransparency = 0.3})
            end)
            itemBtn.MouseLeave:Connect(function()
                Tween(itemBtn, Config.Animation.Fast, {BackgroundTransparency = 0.7})
            end)
        end
    end
    
    PopulateList()
    UpdateText()
    
    dropButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            dropdownList.Visible = true
            local height = math.min(#items * 30 + 6, 150)
            Tween(dropdownList, Config.Animation.Fast, {Size = UDim2.new(1, 0, 0, height)})
            Tween(arrow, Config.Animation.Fast, {Rotation = 180})
        else
            Tween(dropdownList, Config.Animation.Fast, {Size = UDim2.new(1, 0, 0, 0)})
            Tween(arrow, Config.Animation.Fast, {Rotation = 0})
            task.delay(0.2, function() dropdownList.Visible = false end)
        end
    end)
    
    return {
        Set = function(val)
            selected = val
            UpdateText()
            PopulateList()
            callback(selected)
        end,
        Get = function() return selected end,
        Refresh = function(newItems)
            items = newItems
            PopulateList()
        end
    }
end

-- Label
function CentrixUI.AddLabel(tab, text)
    local labelFrame = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = text or "Label",
        TextColor3 = Config.Colors.TextDim,
        TextSize = 14,
        Font = Config.Fonts.Light,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Content
    })
    
    return {
        Set = function(newText)
            labelFrame.Text = newText
        end
    }
end

-- Paragraph
function CentrixUI.AddParagraph(tab, options)
    options = options or {}
    local title = options.Title or "Title"
    local content = options.Content or ""
    
    local paraFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Config.Colors.Secondary,
        BackgroundTransparency = 0.5,
        Parent = tab.Content
    })
    AddCorner(paraFrame, 6)
    
    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Config.Colors.Text,
        TextSize = 15,
        Font = Config.Fonts.Title,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = paraFrame
    })
    
    local contentLabel = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 27),
        BackgroundTransparency = 1,
        Text = content,
        TextColor3 = Config.Colors.TextDim,
        TextSize = 13,
        Font = Config.Fonts.Regular,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = paraFrame
    })
    
    return {
        SetTitle = function(t) titleLabel.Text = t end,
        SetContent = function(c) contentLabel.Text = c end
    }
end

-- Keybind
function CentrixUI.AddKeybind(tab, options)
    options = options or {}
    local name = options.Name or "Keybind"
    local default = options.Default or Enum.KeyCode.Unknown
    local callback = options.Callback or function() end
    
    local keybindFrame = Create("Frame", {
        Name = name .. "Keybind",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Config.Colors.Secondary,
        BackgroundTransparency = 0.5,
        Parent = tab.Content
    })
    AddCorner(keybindFrame, 6)
    
    local label = Create("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Config.Colors.Text,
        TextSize = 14,
        Font = Config.Fonts.Regular,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = keybindFrame
    })
    
    local keyBtn = Create("TextButton", {
        Size = UDim2.new(0, 80, 0, 26),
        Position = UDim2.new(1, -90, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Config.Colors.Primary,
        Text = default.Name or "None",
        TextColor3 = Config.Colors.Accent,
        TextSize = 12,
        Font = Config.Fonts.Title,
        AutoButtonColor = false,
        Parent = keybindFrame
    })
    AddCorner(keyBtn, 4)
    AddStroke(keyBtn, Config.Colors.Accent, 1, 0.7)
    
    local currentKey = default
    local listening = false
    
    tab.Library.Keybinds[name] = {Key = currentKey, Callback = callback}
    
    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = Config.Colors.Warning
    end)
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            currentKey = input.KeyCode
            keyBtn.Text = currentKey.Name
            keyBtn.TextColor3 = Config.Colors.Accent
            tab.Library.Keybinds[name].Key = currentKey
        elseif not processed and input.KeyCode == currentKey then
            callback()
        end
    end)
    
    return {
        Set = function(key)
            currentKey = key
            keyBtn.Text = key.Name
            tab.Library.Keybinds[name].Key = key
        end,
        Get = function() return currentKey end
    }
end

-- Button
function CentrixUI.AddButton(tab, options)
    options = options or {}
    local name = options.Name or "Button"
    local callback = options.Callback or function() end
    
    local button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Config.Colors.Accent,
        Text = name,
        TextColor3 = Config.Colors.Text,
        TextSize = 14,
        Font = Config.Fonts.Title,
        AutoButtonColor = false,
        Parent = tab.Content
    })
    AddCorner(button, 6)
    AddGradient(button)
    
    button.MouseEnter:Connect(function()
        Tween(button, Config.Animation.Fast, {BackgroundTransparency = 0.2})
    end)
    button.MouseLeave:Connect(function()
        Tween(button, Config.Animation.Fast, {BackgroundTransparency = 0})
    end)
    
    button.MouseButton1Click:Connect(function()
        Tween(button, TweenInfo.new(0.1), {Size = UDim2.new(0.98, 0, 0, 33)})
        task.wait(0.1)
        Tween(button, Config.Animation.Fast, {Size = UDim2.new(1, 0, 0, 35)})
        callback()
    end)
    
    return button
end

-- Notification System
function CentrixUI:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 3
    local notifType = options.Type or "Info"
    
    local colors = {
        Info = Config.Colors.Accent,
        Success = Config.Colors.Success,
        Warning = Config.Colors.Warning,
        Error = Config.Colors.Error
    }
    
    -- Create notification container if not exists
    if not self.NotifContainer then
        self.NotifContainer = Create("Frame", {
            Name = "Notifications",
            Size = UDim2.new(0, 280, 1, -20),
            Position = UDim2.new(1, -290, 0, 10),
            BackgroundTransparency = 1,
            Parent = self.ScreenGui
        })
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Parent = self.NotifContainer
        })
    end
    
    local notif = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = Config.Colors.Primary,
        BackgroundTransparency = 0.1,
        Parent = self.NotifContainer
    })
    AddCorner(notif, 8)
    AddStroke(notif, colors[notifType], 1, 0.5)
    
    local accent = Create("Frame", {
        Size = UDim2.new(0, 4, 1, -10),
        Position = UDim2.new(0, 5, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = colors[notifType],
        Parent = notif
    })
    AddCorner(accent, 2)
    
    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -25, 0, 22),
        Position = UDim2.new(0, 18, 0, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Config.Colors.Text,
        TextSize = 15,
        Font = Config.Fonts.Title,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })
    
    local msgLabel = Create("TextLabel", {
        Size = UDim2.new(1, -25, 0, 35),
        Position = UDim2.new(0, 18, 0, 30),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Config.Colors.TextDim,
        TextSize = 13,
        Font = Config.Fonts.Regular,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notif
    })
    
    -- Slide in
    notif.Position = UDim2.new(1, 0, 0, 0)
    Tween(notif, Config.Animation.Normal, {Position = UDim2.new(0, 0, 0, 0)})
    
    -- Auto dismiss
    task.delay(duration, function()
        Tween(notif, Config.Animation.Fast, {Position = UDim2.new(1, 0, 0, 0)})
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- Watermark
function CentrixUI:CreateWatermark(options)
    options = options or {}
    local text = options.Text or "Centrix"
    
    local watermark = Create("Frame", {
        Name = "Watermark",
        Size = UDim2.new(0, 120, 0, 28),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Config.Colors.Primary,
        BackgroundTransparency = 0.2,
        Parent = self.ScreenGui
    })
    AddCorner(watermark, 6)
    AddStroke(watermark, Config.Colors.Accent, 1, 0.7)
    
    local label = Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Config.Colors.Text,
        TextSize = 14,
        Font = Config.Fonts.Title,
        Parent = watermark
    })
    
    return {
        Set = function(newText)
            label.Text = newText
            watermark.Size = UDim2.new(0, math.max(label.TextBounds.X + 20, 80), 0, 28)
        end,
        Toggle = function(visible)
            watermark.Visible = visible
        end
    }
end

-- Keybind List Display
function CentrixUI:CreateKeybindList()
    local list = Create("Frame", {
        Name = "KeybindList",
        Size = UDim2.new(0, 150, 0, 100),
        Position = UDim2.new(1, -160, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Config.Colors.Primary,
        BackgroundTransparency = 0.2,
        Parent = self.ScreenGui
    })
    AddCorner(list, 8)
    AddStroke(list, Config.Colors.Accent, 1, 0.7)
    
    local title = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = "Keybinds",
        TextColor3 = Config.Colors.Text,
        TextSize = 14,
        Font = Config.Fonts.Title,
        Parent = list
    })
    
    local content = Create("Frame", {
        Size = UDim2.new(1, -10, 1, -30),
        Position = UDim2.new(0, 5, 0, 25),
        BackgroundTransparency = 1,
        Parent = list
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 3),
        Parent = content
    })
    
    local function UpdateList()
        for _, child in pairs(content:GetChildren()) do
            if child:IsA("TextLabel") then child:Destroy() end
        end
        
        for name, data in pairs(self.Keybinds) do
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = "[" .. data.Key.Name .. "] " .. name,
                TextColor3 = Config.Colors.TextDim,
                TextSize = 12,
                Font = Config.Fonts.Regular,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = content
            })
        end
        
        list.Size = UDim2.new(0, 150, 0, 30 + (18 * #self.Keybinds))
    end
    
    UpdateList()
    
    return {
        Refresh = UpdateList,
        Toggle = function(visible) list.Visible = visible end
    }
end

return CentrixUI
