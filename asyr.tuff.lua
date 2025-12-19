--[[
    ╔═══════════════════════════════════════════════════════════════════════════╗
    ║                         PREMIUM UI LIBRARY v2.0                            ║
    ║                    Modern • Smooth • Beautiful                             ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
]]

local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Config
local Config = {
    -- Colors (Deep Purple/Lavender Theme)
    Primary = Color3.fromRGB(20, 15, 30),
    Secondary = Color3.fromRGB(30, 25, 45),
    Accent = Color3.fromRGB(150, 100, 255),
    AccentDark = Color3.fromRGB(100, 60, 200),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 200),
    Success = Color3.fromRGB(100, 255, 150),
    Warning = Color3.fromRGB(255, 200, 100),
    Error = Color3.fromRGB(255, 100, 100),
    
    -- Animation
    FastTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    NormalTween = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    SlowTween = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
}

-- Utility Functions
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    obj.Parent = props.Parent
    return obj
end

local function Tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

local function AddCorner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Config.Accent,
        Thickness = thickness or 1,
        Transparency = 0.5,
        Parent = parent
    })
end

local function AddGradient(parent, rotation)
    return Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Config.Accent),
            ColorSequenceKeypoint.new(1, Config.AccentDark)
        }),
        Rotation = rotation or 45,
        Parent = parent
    })
end

-- Main Library Constructor
function Library.new()
    local self = setmetatable({}, Library)
    self.Tabs = {}
    self.CurrentTab = nil
    self.Notifications = {}
    return self
end

-- Create Window
function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Premium UI"
    local subtitle = options.Subtitle or "v1.0"
    
    -- ScreenGui
    self.ScreenGui = Create("ScreenGui", {
        Name = "PremiumUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Main Window
    self.Main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 550, 0, 400),
        Position = UDim2.new(0.5, -275, 0.5, -200),
        BackgroundColor3 = Config.Primary,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    AddCorner(self.Main, 12)
    AddStroke(self.Main, Config.Accent, 1)
    
    -- Blur Effect
    Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageTransparency = 0.95,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0, 100, 0, 100),
        Parent = self.Main
    })
    
    -- Header
    local header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Config.Secondary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = self.Main
    })
    AddCorner(header, 12)
    AddGradient(header, 90)
    
    -- Title
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Config.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    -- Subtitle
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 15),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = Config.TextDim,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    -- Tab Container (Left Side)
    self.TabContainer = Create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 150, 1, -60),
        Position = UDim2.new(0, 10, 0, 55),
        BackgroundTransparency = 1,
        Parent = self.Main
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.TabContainer
    })
    
    -- Content Container (Right Side)
    self.ContentContainer = Create("ScrollingFrame", {
        Name = "Content",
        Size = UDim2.new(1, -170, 1, -60),
        Position = UDim2.new(0, 165, 0, 55),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Config.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.Main
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.ContentContainer
    })
    
    -- Auto-resize canvas
    self.ContentContainer:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
        self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, self.ContentContainer.UIListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Make draggable
    self:MakeDraggable(self.Main, header)
    
    -- Toggle keybind
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.Insert then
            self:Toggle()
        end
    end)
    
    return self
end

-- Make Draggable
function Library:MakeDraggable(frame, dragFrame)
    local dragging, dragInput, dragStart, startPos
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(frame, Config.FastTween, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            })
        end
    end)
end

-- Toggle UI
function Library:Toggle(state)
    local visible = state ~= nil and state or not self.Main.Visible
    self.Main.Visible = visible
end

-- Add Tab
function Library:AddTab(options)
    options = options or {}
    local name = options.Name or "Tab"
    local icon = options.Icon
    
    local tab = {
        Name = name,
        Elements = {}
    }
    
    -- Tab Button
    local button = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Config.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = self.TabContainer
    })
    AddCorner(button, 8)
    
    -- Tab Label
    Create("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Config.TextDim,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = button
    })
    
    -- Tab Content Frame
    tab.Frame = Create("Frame", {
        Name = name .. "Content",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.ContentContainer
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tab.Frame
    })
    
    -- Click handler
    button.MouseButton1Click:Connect(function()
        self:SelectTab(tab, button)
    end)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            Tween(button, Config.FastTween, {BackgroundTransparency = 0.3})
        end
    end)
    
    button.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            Tween(button, Config.FastTween, {BackgroundTransparency = 0.5})
        end
    end)
    
    table.insert(self.Tabs, {Tab = tab, Button = button})
    
    -- Select first tab
    if #self.Tabs == 1 then
        self:SelectTab(tab, button)
    end
    
    return tab
end

-- Select Tab
function Library:SelectTab(tab, button)
    -- Hide all tabs
    for _, t in pairs(self.Tabs) do
        t.Tab.Frame.Visible = false
        Tween(t.Button, Config.FastTween, {BackgroundTransparency = 0.5})
        t.Button.TextLabel.TextColor3 = Config.TextDim
    end
    
    -- Show selected
    tab.Frame.Visible = true
    self.CurrentTab = tab
    Tween(button, Config.FastTween, {BackgroundTransparency = 0.1})
    AddGradient(button, 90)
    button.TextLabel.TextColor3 = Config.Text
end

-- Add Toggle
function Library.AddToggle(tab, options)
    options = options or {}
    local name = options.Name or "Toggle"
    local default = options.Default or false
    local callback = options.Callback or function() end
    
    local toggled = default
    
    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Config.Secondary,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Parent = tab.Frame
    })
    AddCorner(container, 8)
    
    -- Label
    Create("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Config.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    
    -- Toggle Button
    local toggleBtn = Create("TextButton", {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -45, 0.5, -10),
        BackgroundColor3 = toggled and Config.Accent or Config.Primary,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = container
    })
    AddCorner(toggleBtn, 10)
    
    -- Toggle Circle
    local circle = Create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Config.Text,
        BorderSizePixel = 0,
        Parent = toggleBtn
    })
    AddCorner(circle, 8)
    
    -- Click handler
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        Tween(toggleBtn, Config.NormalTween, {BackgroundColor3 = toggled and Config.Accent or Config.Primary})
        Tween(circle, Config.NormalTween, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
        callback(toggled)
    end)
    
    return {
        Set = function(value)
            toggled = value
            Tween(toggleBtn, Config.NormalTween, {BackgroundColor3 = toggled and Config.Accent or Config.Primary})
            Tween(circle, Config.NormalTween, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
        end,
        Get = function() return toggled end
    }
end

-- Add Slider
function Library.AddSlider(tab, options)
    options = options or {}
    local name = options.Name or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or min
    local callback = options.Callback or function() end
    
    local value = default
    
    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Config.Secondary,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Parent = tab.Frame
    })
    AddCorner(container, 8)
    
    -- Label
    local label = Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Config.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    
    -- Value Label
    local valueLabel = Create("TextLabel", {
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -55, 0, 5),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = Config.Accent,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = container
    })
    
    -- Slider Background
    local sliderBg = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 4),
        Position = UDim2.new(0, 10, 1, -12),
        BackgroundColor3 = Config.Primary,
        BorderSizePixel = 0,
        Parent = container
    })
    AddCorner(sliderBg, 2)
    
    -- Slider Fill
    local sliderFill = Create("Frame", {
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Config.Accent,
        BorderSizePixel = 0,
        Parent = sliderBg
    })
    AddCorner(sliderFill, 2)
    AddGradient(sliderFill, 90)
    
    -- Slider Button
    local sliderBtn = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = sliderBg
    })
    
    local dragging = false
    
    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * pos)
            valueLabel.Text = tostring(value)
            Tween(sliderFill, Config.FastTween, {Size = UDim2.new(pos, 0, 1, 0)})
            callback(value)
        end
    end)
    
    return {
        Set = function(val)
            value = math.clamp(val, min, max)
            valueLabel.Text = tostring(value)
            Tween(sliderFill, Config.FastTween, {Size = UDim2.new((value - min) / (max - min), 0, 1, 0)})
        end,
        Get = function() return value end
    }
end

-- Add Button
function Library.AddButton(tab, options)
    options = options or {}
    local name = options.Name or "Button"
    local callback = options.Callback or function() end
    
    local button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Config.Accent,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = Config.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = tab.Frame
    })
    AddCorner(button, 8)
    AddGradient(button, 90)
    
    button.MouseButton1Click:Connect(function()
        Tween(button, Config.FastTween, {BackgroundTransparency = 0})
        task.wait(0.1)
        Tween(button, Config.FastTween, {BackgroundTransparency = 0.3})
        callback()
    end)
    
    button.MouseEnter:Connect(function()
        Tween(button, Config.FastTween, {BackgroundTransparency = 0.1})
    end)
    
    button.MouseLeave:Connect(function()
        Tween(button, Config.FastTween, {BackgroundTransparency = 0.3})
    end)
end

-- Add Label
function Library.AddLabel(tab, text)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Config.TextDim,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Frame
    })
end

-- Notification System
function Library:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 3
    local type = options.Type or "Info"
    
    local color = Config.Accent
    if type == "Success" then color = Config.Success
    elseif type == "Warning" then color = Config.Warning
    elseif type == "Error" then color = Config.Error
    end
    
    local notif = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 0),
        Position = UDim2.new(1, -310, 1, 10),
        BackgroundColor3 = Config.Secondary,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    AddCorner(notif, 10)
    AddStroke(notif, color, 2)
    
    -- Title
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = color,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })
    
    -- Message
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 28),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Config.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notif
    })
    
    -- Animate in
    Tween(notif, Config.NormalTween, {Size = UDim2.new(0, 300, 0, 70), Position = UDim2.new(1, -310, 1, -80)})
    
    -- Auto dismiss
    task.delay(duration, function()
        Tween(notif, Config.NormalTween, {Position = UDim2.new(1, -310, 1, 10), Size = UDim2.new(0, 300, 0, 0)})
        task.wait(0.3)
        notif:Destroy()
    end)
end

return Library
