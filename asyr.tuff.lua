--[[
    Centrix UI Library v3.12
    A high-performance, responsive Roblox UI library
    Designed for high-end executors
--]]

local Centrix = {}
Centrix.__index = Centrix
Centrix.Version = "3.12"
Centrix.Windows = {}
Centrix.Theme = {}
Centrix.Connections = {}
Centrix.Flags = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Design System (Centrix Dark/Midnight)
Centrix.Theme = {
    Primary = Color3.fromRGB(18, 18, 20),
    Secondary = Color3.fromRGB(24, 24, 28),
    Tertiary = Color3.fromRGB(32, 32, 38),
    Accent = Color3.fromRGB(124, 58, 237),
    AccentDark = Color3.fromRGB(94, 38, 197),
    AccentLight = Color3.fromRGB(154, 88, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 185),
    TextMuted = Color3.fromRGB(120, 120, 130),
    Success = Color3.fromRGB(34, 197, 94),
    Warning = Color3.fromRGB(234, 179, 8),
    Error = Color3.fromRGB(239, 68, 68),
    Outline = Color3.fromRGB(60, 60, 70),
    Shadow = Color3.fromRGB(0, 0, 0),
    CornerRadius = UDim.new(0, 8),
    CornerRadiusLarge = UDim.new(0, 12),
    OutlineThickness = 1.2,
    FontHeader = Enum.Font.GothamBold,
    FontBody = Enum.Font.GothamMedium,
    FontMono = Enum.Font.Code
}

-- Utility: Get GUI Parent
local function GetGuiParent()
    local success, result = pcall(function()
        local test = Instance.new("ScreenGui")
        test.Parent = CoreGui
        test:Destroy()
        return CoreGui
    end)
    if success then
        return result
    end
    return Player:WaitForChild("PlayerGui")
end

-- Utility: Tween Engine with callback support
local function CreateTween(instance, properties, duration, easingStyle, easingDirection, callback)
    duration = duration or 0.25
    easingStyle = easingStyle or Enum.EasingStyle.Quart
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    tween:Play()
    return tween
end

-- Utility: Create Instance with properties
local function Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

-- Utility: Add Corner
local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = radius or Centrix.Theme.CornerRadius,
        Parent = parent
    })
end

-- Utility: Add Stroke
local function AddStroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Centrix.Theme.Outline,
        Thickness = thickness or Centrix.Theme.OutlineThickness,
        Transparency = transparency or 0.5,
        Parent = parent
    })
end

-- Utility: Add Padding
local function AddPadding(parent, padding)
    padding = padding or 8
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, padding),
        PaddingBottom = UDim.new(0, padding),
        PaddingLeft = UDim.new(0, padding),
        PaddingRight = UDim.new(0, padding),
        Parent = parent
    })
end

-- Utility: Ripple Effect
local function CreateRipple(button, x, y)
    local ripple = Create("Frame", {
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        Position = UDim2.new(0, x, 0, y),
        Size = UDim2.new(0, 0, 0, 0),
        Parent = button
    })
    AddCorner(ripple, UDim.new(1, 0))
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    CreateTween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, function()
        ripple:Destroy()
    end)
end

-- Utility: Is Mobile
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Config System
local ConfigSystem = {}
ConfigSystem.Folder = "CentrixConfigs"

function ConfigSystem:EnsureFolder()
    if isfolder and not isfolder(self.Folder) then
        makefolder(self.Folder)
    end
end

function ConfigSystem:Save(name, data)
    self:EnsureFolder()
    if writefile then
        local success, encoded = pcall(function()
            return HttpService:JSONEncode(data)
        end)
        if success then
            writefile(self.Folder .. "/" .. name .. ".json", encoded)
            return true
        end
    end
    return false
end

function ConfigSystem:Load(name)
    self:EnsureFolder()
    if readfile and isfile and isfile(self.Folder .. "/" .. name .. ".json") then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(self.Folder .. "/" .. name .. ".json"))
        end)
        if success then
            return data
        end
    end
    return nil
end

function ConfigSystem:GetConfigs()
    self:EnsureFolder()
    local configs = {}
    if listfiles then
        for _, file in pairs(listfiles(self.Folder)) do
            if string.sub(file, -5) == ".json" then
                local name = string.match(file, "([^/\\]+)%.json$")
                if name then
                    table.insert(configs, name)
                end
            end
        end
    end
    return configs
end

Centrix.Config = ConfigSystem

-- Notification System
local NotificationContainer = nil

local function EnsureNotificationContainer(parent)
    if NotificationContainer and NotificationContainer.Parent then
        return NotificationContainer
    end
    
    NotificationContainer = Create("Frame", {
        Name = "CentrixNotifications",
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.new(0, 300, 0, 400),
        Parent = parent
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = NotificationContainer
    })
    
    return NotificationContainer
end

function Centrix:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 5
    local notifType = options.Type or "Info"
    
    local typeColors = {
        Info = Centrix.Theme.Accent,
        Success = Centrix.Theme.Success,
        Warning = Centrix.Theme.Warning,
        Error = Centrix.Theme.Error
    }
    
    local container = EnsureNotificationContainer(self.ScreenGui)
    
    local notification = Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = Centrix.Theme.Secondary,
        BackgroundTransparency = 0.05,
        Size = UDim2.new(1, 0, 0, 70),
        Position = UDim2.new(1, 50, 0, 0),
        ClipsDescendants = true,
        Parent = container
    })
    AddCorner(notification, Centrix.Theme.CornerRadius)
    AddStroke(notification, typeColors[notifType] or Centrix.Theme.Accent, 1.5, 0.3)
    
    local accentBar = Create("Frame", {
        Name = "AccentBar",
        BackgroundColor3 = typeColors[notifType] or Centrix.Theme.Accent,
        Size = UDim2.new(0, 4, 1, 0),
        Parent = notification
    })
    
    local titleLabel = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 10),
        Size = UDim2.new(1, -24, 0, 20),
        Font = Centrix.Theme.FontHeader,
        Text = title,
        TextColor3 = Centrix.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })
    
    local contentLabel = Create("TextLabel", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 32),
        Size = UDim2.new(1, -24, 0, 30),
        Font = Centrix.Theme.FontBody,
        Text = content,
        TextColor3 = Centrix.Theme.TextDark,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = notification
    })
    
    local progressBar = Create("Frame", {
        Name = "Progress",
        BackgroundColor3 = typeColors[notifType] or Centrix.Theme.Accent,
        BackgroundTransparency = 0.5,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 0, 3),
        Parent = notification
    })
    
    -- Animate in
    CreateTween(notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
    
    -- Progress bar animation
    CreateTween(progressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear)
    
    -- Auto dismiss
    task.delay(duration, function()
        CreateTween(notification, {
            Position = UDim2.new(1, 50, 0, 0),
            BackgroundTransparency = 1
        }, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In, function()
            notification:Destroy()
        end)
    end)
    
    return notification
end

-- Window Creation
function Centrix:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Centrix"
    local subtitle = options.Subtitle or ""
    local size = options.Size or UDim2.new(0, 600, 0, 400)
    local minSize = options.MinSize or Vector2.new(500, 350)
    
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Visible = true
    Window.Minimized = false
    
    -- Screen GUI
    self.ScreenGui = Create("ScreenGui", {
        Name = "CentrixUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        Parent = GetGuiParent()
    })
    
    -- Main Frame
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Centrix.Theme.Primary,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = size,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })
    AddCorner(MainFrame, Centrix.Theme.CornerRadiusLarge)
    AddStroke(MainFrame, Centrix.Theme.Outline, 1.2, 0.6)
    
    Window.MainFrame = MainFrame
    
    -- Shadow
    local Shadow = Create("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 4),
        Size = UDim2.new(1, 40, 1, 40),
        ZIndex = -1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Centrix.Theme.Shadow,
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Parent = MainFrame
    })
    
    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Centrix.Theme.Secondary,
        Size = UDim2.new(0, 180, 1, 0),
        Parent = MainFrame
    })
    
    local SidebarCorner = Create("Frame", {
        Name = "CornerMask",
        BackgroundColor3 = Centrix.Theme.Secondary,
        Position = UDim2.new(1, -12, 0, 0),
        Size = UDim2.new(0, 12, 1, 0),
        Parent = Sidebar
    })
    AddCorner(Sidebar, Centrix.Theme.CornerRadiusLarge)
    
    -- Logo Section
    local LogoSection = Create("Frame", {
        Name = "LogoSection",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 70),
        Parent = Sidebar
    })
    
    local LogoText = Create("TextLabel", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 15),
        Size = UDim2.new(1, -32, 0, 25),
        Font = Centrix.Theme.FontHeader,
        Text = title,
        TextColor3 = Centrix.Theme.Text,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = LogoSection
    })
    
    local SubtitleText = Create("TextLabel", {
        Name = "Subtitle",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 42),
        Size = UDim2.new(1, -32, 0, 16),
        Font = Centrix.Theme.FontBody,
        Text = subtitle,
        TextColor3 = Centrix.Theme.TextMuted,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = LogoSection
    })
    
    -- Divider
    local Divider = Create("Frame", {
        Name = "Divider",
        BackgroundColor3 = Centrix.Theme.Outline,
        BackgroundTransparency = 0.5,
        Position = UDim2.new(0, 16, 0, 70),
        Size = UDim2.new(1, -32, 0, 1),
        Parent = Sidebar
    })
    
    -- Tab Container
    local TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 80),
        Size = UDim2.new(1, 0, 1, -80),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Centrix.Theme.Accent,
        Parent = Sidebar
    })
    AddPadding(TabContainer, 8)
    
    local TabLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabContainer
    })
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 16)
    end)
    
    -- Content Container
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 180, 0, 0),
        Size = UDim2.new(1, -180, 1, 0),
        ClipsDescendants = true,
        Parent = MainFrame
    })
    
    -- Drag Logic (Mouse and Touch compatible)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function UpdateDrag(input)
        if dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    LogoSection.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    LogoSection.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            UpdateDrag(input)
        end
    end)
    
    -- Toggle Visibility (Right Ctrl)
    local function ToggleWindow()
        Window.Visible = not Window.Visible
        if Window.Visible then
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            CreateTween(MainFrame, {Size = size}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In, function()
                MainFrame.Visible = false
            end)
        end
    end
    
    -- Global Toggle (Right Ctrl)
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            ToggleWindow()
        end
    end)
    
    -- Mobile Toggle Button
    if IsMobile() then
        local MobileToggle = Create("TextButton", {
            Name = "MobileToggle",
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Centrix.Theme.Accent,
            Position = UDim2.new(0, 10, 0.5, 0),
            Size = UDim2.new(0, 50, 0, 50),
            Font = Centrix.Theme.FontHeader,
            Text = "CX",
            TextColor3 = Centrix.Theme.Text,
            TextSize = 16,
            Parent = self.ScreenGui
        })
        AddCorner(MobileToggle, UDim.new(1, 0))
        AddStroke(MobileToggle, Centrix.Theme.AccentLight, 2, 0.3)
        
        MobileToggle.MouseButton1Click:Connect(ToggleWindow)
        MobileToggle.TouchTap:Connect(ToggleWindow)
    end
    
    Window.ContentContainer = ContentContainer
    Window.TabContainer = TabContainer
    
    -- Tab Creation Method
    function Window:CreateTab(options)
        options = options or {}
        local tabName = options.Name or "Tab"
        local tabIcon = options.Icon or ""
        
        local Tab = {}
        Tab.Sections = {}
        Tab.Name = tabName
        
        -- Tab Button
        local TabButton = Create("TextButton", {
            Name = tabName .. "Tab",
            BackgroundColor3 = Centrix.Theme.Tertiary,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -16, 0, 36),
            Font = Centrix.Theme.FontBody,
            Text = "",
            AutoButtonColor = false,
            Parent = TabContainer
        })
        AddCorner(TabButton, Centrix.Theme.CornerRadius)
        
        local TabIcon = Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16),
            Image = tabIcon,
            ImageColor3 = Centrix.Theme.TextMuted,
            Parent = TabButton
        })
        
        local TabLabel = Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, tabIcon ~= "" and 36 or 12, 0, 0),
            Size = UDim2.new(1, tabIcon ~= "" and -48 or -24, 1, 0),
            Font = Centrix.Theme.FontBody,
            Text = tabName,
            TextColor3 = Centrix.Theme.TextMuted,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        })
        
        local Indicator = Create("Frame", {
            Name = "Indicator",
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Centrix.Theme.Accent,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 3, 0.6, 0),
            Visible = false,
            Parent = TabButton
        })
        AddCorner(Indicator, UDim.new(1, 0))
        
        -- Tab Content Page
        local TabPage = Create("ScrollingFrame", {
            Name = tabName .. "Page",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Centrix.Theme.Accent,
            Visible = false,
            Parent = ContentContainer
        })
        AddPadding(TabPage, 16)
        
        local PageLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 12),
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabPage
        })
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 32)
        end)
        
        Tab.Button = TabButton
        Tab.Page = TabPage
        Tab.Indicator = Indicator
        Tab.Label = TabLabel
        Tab.Icon = TabIcon
        
        -- Tab Switch Logic
        local function ActivateTab()
            if Window.ActiveTab then
                -- Deactivate previous tab
                local prevTab = Window.ActiveTab
                CreateTween(prevTab.Button, {BackgroundTransparency = 1}, 0.2)
                CreateTween(prevTab.Label, {TextColor3 = Centrix.Theme.TextMuted}, 0.2)
                CreateTween(prevTab.Icon, {ImageColor3 = Centrix.Theme.TextMuted}, 0.2)
                prevTab.Indicator.Visible = false
                prevTab.Page.Visible = false
            end
            
            -- Activate new tab
            Window.ActiveTab = Tab
            CreateTween(TabButton, {BackgroundTransparency = 0.8}, 0.2)
            CreateTween(TabLabel, {TextColor3 = Centrix.Theme.Text}, 0.2)
            CreateTween(TabIcon, {ImageColor3 = Centrix.Theme.Accent}, 0.2)
            Indicator.Visible = true
            TabPage.Visible = true
            TabPage.CanvasPosition = Vector2.new(0, 0)
        end
        
        TabButton.MouseButton1Click:Connect(ActivateTab)
        
        -- Hover Effects
        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                CreateTween(TabButton, {BackgroundTransparency = 0.9}, 0.15)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                CreateTween(TabButton, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        
        -- Auto-select first tab
        if #Window.Tabs == 0 then
            task.defer(ActivateTab)
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- Section Creation
        function Tab:CreateSection(options)
            options = options or {}
            local sectionName = options.Name or "Section"
            
            local Section = {}
            Section.Elements = {}
            
            local SectionFrame = Create("Frame", {
                Name = sectionName .. "Section",
                BackgroundColor3 = Centrix.Theme.Secondary,
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.new(1, -32, 0, 0),
                Parent = TabPage
            })
            AddCorner(SectionFrame, Centrix.Theme.CornerRadius)
            AddStroke(SectionFrame, Centrix.Theme.Outline, 1, 0.7)
            
            local SectionHeader = Create("TextLabel", {
                Name = "Header",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 8),
                Size = UDim2.new(1, -24, 0, 20),
                Font = Centrix.Theme.FontHeader,
                Text = sectionName,
                TextColor3 = Centrix.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionFrame
            })
            
            local ElementContainer = Create("Frame", {
                Name = "Elements",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 32),
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.new(1, 0, 0, 0),
                Parent = SectionFrame
            })
            AddPadding(ElementContainer, 12)
            
            local ElementLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = ElementContainer
            })
            
            Section.Frame = SectionFrame
            Section.Container = ElementContainer
            
            -- Button Component
            function Section:CreateButton(options)
                options = options or {}
                local buttonName = options.Name or "Button"
                local callback = options.Callback or function() end
                
                local Button = Create("TextButton", {
                    Name = buttonName,
                    BackgroundColor3 = Centrix.Theme.Accent,
                    Size = UDim2.new(1, -24, 0, 32),
                    Font = Centrix.Theme.FontBody,
                    Text = buttonName,
                    TextColor3 = Centrix.Theme.Text,
                    TextSize = 13,
                    AutoButtonColor = false,
                    ClipsDescendants = true,
                    Parent = ElementContainer
                })
                AddCorner(Button, Centrix.Theme.CornerRadius)
                
                Button.MouseButton1Click:Connect(function()
                    local x = Mouse.X - Button.AbsolutePosition.X
                    local y = Mouse.Y - Button.AbsolutePosition.Y
                    CreateRipple(Button, x, y)
                    callback()
                end)
                
                Button.MouseEnter:Connect(function()
                    CreateTween(Button, {BackgroundColor3 = Centrix.Theme.AccentLight}, 0.15)
                end)
                
                Button.MouseLeave:Connect(function()
                    CreateTween(Button, {BackgroundColor3 = Centrix.Theme.Accent}, 0.15)
                end)
                
                return Button
            end
            
            -- Toggle Component
            function Section:CreateToggle(options)
                options = options or {}
                local toggleName = options.Name or "Toggle"
                local default = options.Default or false
                local flag = options.Flag
                local callback = options.Callback or function() end
                
                local state = default
                
                local ToggleFrame = Create("Frame", {
                    Name = toggleName,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -24, 0, 28),
                    Parent = ElementContainer
                })
                
                local ToggleLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -56, 1, 0),
                    Font = Centrix.Theme.FontBody,
                    Text = toggleName,
                    TextColor3 = Centrix.Theme.TextDark,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ToggleFrame
                })
                
                local ToggleButton = Create("TextButton", {
                    Name = "Button",
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = state and Centrix.Theme.Accent or Centrix.Theme.Tertiary,
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 44, 0, 22),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ToggleFrame
                })
                AddCorner(ToggleButton, UDim.new(1, 0))
                AddStroke(ToggleButton, Centrix.Theme.Outline, 1, 0.5)
                
                local ToggleDot = Create("Frame", {
                    Name = "Dot",
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Centrix.Theme.Text,
                    Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    Parent = ToggleButton
                })
                AddCorner(ToggleDot, UDim.new(1, 0))
                
                local function UpdateToggle()
                    state = not state
                    if flag then
                        Centrix.Flags[flag] = state
                    end
                    
                    CreateTween(ToggleButton, {
                        BackgroundColor3 = state and Centrix.Theme.Accent or Centrix.Theme.Tertiary
                    }, 0.2)
                    CreateTween(ToggleDot, {
                        Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
                    }, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    
                    callback(state)
                end
                
                ToggleButton.MouseButton1Click:Connect(UpdateToggle)
                
                if flag then
                    Centrix.Flags[flag] = state
                end
                
                local ToggleObject = {}
                function ToggleObject:Set(value)
                    if value ~= state then
                        UpdateToggle()
                    end
                end
                
                return ToggleObject
            end
            
            -- Slider Component
            function Section:CreateSlider(options)
                options = options or {}
                local sliderName = options.Name or "Slider"
                local min = options.Min or 0
                local max = options.Max or 100
                local default = options.Default or min
                local increment = options.Increment or 1
                local suffix = options.Suffix or ""
                local flag = options.Flag
                local callback = options.Callback or function() end
                
                local value = math.clamp(default, min, max)
                
                local SliderFrame = Create("Frame", {
                    Name = sliderName,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -24, 0, 42),
                    Parent = ElementContainer
                })
                
                local SliderLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -60, 0, 20),
                    Font = Centrix.Theme.FontBody,
                    Text = sliderName,
                    TextColor3 = Centrix.Theme.TextDark,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SliderFrame
                })
                
                local ValueLabel = Create("TextLabel", {
                    Name = "Value",
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 60, 0, 20),
                    Font = Centrix.Theme.FontBody,
                    Text = tostring(value) .. suffix,
                    TextColor3 = Centrix.Theme.Accent,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = SliderFrame
                })
                
                local SliderBar = Create("Frame", {
                    Name = "Bar",
                    BackgroundColor3 = Centrix.Theme.Tertiary,
                    Position = UDim2.new(0, 0, 0, 26),
                    Size = UDim2.new(1, 0, 0, 8),
                    Parent = SliderFrame
                })
                AddCorner(SliderBar, UDim.new(1, 0))
                
                local SliderFill = Create("Frame", {
                    Name = "Fill",
                    BackgroundColor3 = Centrix.Theme.Accent,
                    Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                    Parent = SliderBar
                })
                AddCorner(SliderFill, UDim.new(1, 0))
                
                local SliderKnob = Create("Frame", {
                    Name = "Knob",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Centrix.Theme.Text,
                    Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    Parent = SliderBar
                })
                AddCorner(SliderKnob, UDim.new(1, 0))
                
                local SliderInput = Create("TextButton", {
                    Name = "Input",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 22),
                    Size = UDim2.new(1, 0, 0, 16),
                    Text = "",
                    Parent = SliderFrame
                })
                
                local sliding = false
                
                local function UpdateSlider(input)
                    local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local rawValue = min + (max - min) * percent
                    value = math.floor(rawValue / increment + 0.5) * increment
                    value = math.clamp(value, min, max)
                    
                    local displayPercent = (value - min) / (max - min)
                    CreateTween(SliderFill, {Size = UDim2.new(displayPercent, 0, 1, 0)}, 0.1)
                    CreateTween(SliderKnob, {Position = UDim2.new(displayPercent, 0, 0.5, 0)}, 0.1)
                    ValueLabel.Text = tostring(value) .. suffix
                    
                    if flag then
                        Centrix.Flags[flag] = value
                    end
                    callback(value)
                end
                
                SliderInput.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or
                       input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        UpdateSlider(input)
                    end
                end)
                
                SliderInput.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or
                       input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or
                       input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)
                
                if flag then
                    Centrix.Flags[flag] = value
                end
                
                local SliderObject = {}
                function SliderObject:Set(val)
                    value = math.clamp(val, min, max)
                    local displayPercent = (value - min) / (max - min)
                    CreateTween(SliderFill, {Size = UDim2.new(displayPercent, 0, 1, 0)}, 0.1)
                    CreateTween(SliderKnob, {Position = UDim2.new(displayPercent, 0, 0.5, 0)}, 0.1)
                    ValueLabel.Text = tostring(value) .. suffix
                    if flag then Centrix.Flags[flag] = value end
                    callback(value)
                end
                
                return SliderObject
            end
            
            -- Dropdown Component
            function Section:CreateDropdown(options)
                options = options or {}
                local dropdownName = options.Name or "Dropdown"
                local items = options.Items or {}
                local default = options.Default
                local multi = options.Multi or false
                local flag = options.Flag
                local callback = options.Callback or function() end
                
                local selected = multi and {} or default
                local open = false
                
                if multi and default then
                    for _, item in pairs(default) do
                        selected[item] = true
                    end
                end
                
                local DropdownFrame = Create("Frame", {
                    Name = dropdownName,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -24, 0, 50),
                    ClipsDescendants = false,
                    Parent = ElementContainer
                })
                
                local DropdownLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Centrix.Theme.FontBody,
                    Text = dropdownName,
                    TextColor3 = Centrix.Theme.TextDark,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropdownFrame
                })
                
                local DropdownButton = Create("TextButton", {
                    Name = "Button",
                    BackgroundColor3 = Centrix.Theme.Tertiary,
                    Position = UDim2.new(0, 0, 0, 24),
                    Size = UDim2.new(1, 0, 0, 28),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = DropdownFrame
                })
                AddCorner(DropdownButton, Centrix.Theme.CornerRadius)
                AddStroke(DropdownButton, Centrix.Theme.Outline, 1, 0.6)
                
                local function GetDisplayText()
                    if multi then
                        local selectedItems = {}
                        for item, isSelected in pairs(selected) do
                            if isSelected then
                                table.insert(selectedItems, item)
                            end
                        end
                        return #selectedItems > 0 and table.concat(selectedItems, ", ") or "None"
                    else
                        return selected or "Select..."
                    end
                end
                
                local SelectedLabel = Create("TextLabel", {
                    Name = "Selected",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -36, 1, 0),
                    Font = Centrix.Theme.FontBody,
                    Text = GetDisplayText(),
                    TextColor3 = Centrix.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Parent = DropdownButton
                })
                
                local Arrow = Create("TextLabel", {
                    Name = "Arrow",
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    Font = Centrix.Theme.FontBody,
                    Text = "▼",
                    TextColor3 = Centrix.Theme.TextMuted,
                    TextSize = 10,
                    Rotation = 0,
                    Parent = DropdownButton
                })
                
                local DropdownList = Create("Frame", {
                    Name = "List",
                    BackgroundColor3 = Centrix.Theme.Secondary,
                    Position = UDim2.new(0, 0, 0, 56),
                    Size = UDim2.new(1, 0, 0, 0),
                    ClipsDescendants = true,
                    Visible = false,
                    ZIndex = 100,
                    Parent = DropdownFrame
                })
                AddCorner(DropdownList, Centrix.Theme.CornerRadius)
                AddStroke(DropdownList, Centrix.Theme.Accent, 1, 0.5)
                
                local ListScroller = Create("ScrollingFrame", {
                    Name = "Scroller",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Centrix.Theme.Accent,
                    ZIndex = 101,
                    Parent = DropdownList
                })
                AddPadding(ListScroller, 4)
                
                local ListLayout = Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    FillDirection = Enum.FillDirection.Vertical,
                    SortOrder = Enum.SortOrder.Name,
                    Parent = ListScroller
                })
                
                local function UpdateItems()
                    for _, child in pairs(ListScroller:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for _, item in ipairs(items) do
                        local isSelected = multi and selected[item] or selected == item
                        
                        local ItemButton = Create("TextButton", {
                            Name = item,
                            BackgroundColor3 = isSelected and Centrix.Theme.Accent or Centrix.Theme.Tertiary,
                            BackgroundTransparency = isSelected and 0.7 or 0.5,
                            Size = UDim2.new(1, -8, 0, 26),
                            Font = Centrix.Theme.FontBody,
                            Text = item,
                            TextColor3 = Centrix.Theme.Text,
                            TextSize = 12,
                            AutoButtonColor = false,
                            ZIndex = 102,
                            Parent = ListScroller
                        })
                        AddCorner(ItemButton, UDim.new(0, 6))
                        
                        ItemButton.MouseButton1Click:Connect(function()
                            if multi then
                                selected[item] = not selected[item]
                                ItemButton.BackgroundColor3 = selected[item] and Centrix.Theme.Accent or Centrix.Theme.Tertiary
                                ItemButton.BackgroundTransparency = selected[item] and 0.7 or 0.5
                            else
                                selected = item
                                for _, btn in pairs(ListScroller:GetChildren()) do
                                    if btn:IsA("TextButton") then
                                        btn.BackgroundColor3 = btn.Name == item and Centrix.Theme.Accent or Centrix.Theme.Tertiary
                                        btn.BackgroundTransparency = btn.Name == item and 0.7 or 0.5
                                    end
                                end
                            end
                            
                            SelectedLabel.Text = GetDisplayText()
                            if flag then
                                Centrix.Flags[flag] = multi and selected or selected
                            end
                            callback(multi and selected or selected)
                        end)
                        
                        ItemButton.MouseEnter:Connect(function()
                            if not (multi and selected[item] or selected == item) then
                                CreateTween(ItemButton, {BackgroundTransparency = 0.3}, 0.1)
                            end
                        end)
                        
                        ItemButton.MouseLeave:Connect(function()
                            local isCurrentlySelected = multi and selected[item] or selected == item
                            CreateTween(ItemButton, {BackgroundTransparency = isCurrentlySelected and 0.7 or 0.5}, 0.1)
                        end)
                    end
                    
                    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        ListScroller.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 8)
                    end)
                end
                
                UpdateItems()
                
                local function ToggleDropdown()
                    open = not open
                    
                    if open then
                        DropdownList.Visible = true
                        local height = math.min(#items * 28 + 8, 150)
                        CreateTween(DropdownList, {Size = UDim2.new(1, 0, 0, height)}, 0.2)
                        CreateTween(Arrow, {Rotation = 180}, 0.2)
                        CreateTween(DropdownFrame, {Size = UDim2.new(1, -24, 0, 56 + height)}, 0.2)
                    else
                        CreateTween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2, nil, nil, function()
                            DropdownList.Visible = false
                        end)
                        CreateTween(Arrow, {Rotation = 0}, 0.2)
                        CreateTween(DropdownFrame, {Size = UDim2.new(1, -24, 0, 50)}, 0.2)
                    end
                end
                
                DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
                
                if flag then
                    Centrix.Flags[flag] = multi and selected or selected
                end
                
                local DropdownObject = {}
                function DropdownObject:Set(val)
                    if multi then
                        selected = {}
                        for _, item in pairs(val) do
                            selected[item] = true
                        end
                    else
                        selected = val
                    end
                    SelectedLabel.Text = GetDisplayText()
                    UpdateItems()
                    if flag then Centrix.Flags[flag] = selected end
                    callback(selected)
                end
                
                function DropdownObject:Refresh(newItems)
                    items = newItems
                    UpdateItems()
                end
                
                return DropdownObject
            end
            
            -- Keybind Component
            function Section:CreateKeybind(options)
                options = options or {}
                local keybindName = options.Name or "Keybind"
                local default = options.Default or Enum.KeyCode.Unknown
                local flag = options.Flag
                local callback = options.Callback or function() end
                
                local currentKey = default
                local listening = false
                
                local KeybindFrame = Create("Frame", {
                    Name = keybindName,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -24, 0, 28),
                    Parent = ElementContainer
                })
                
                local KeybindLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -90, 1, 0),
                    Font = Centrix.Theme.FontBody,
                    Text = keybindName,
                    TextColor3 = Centrix.Theme.TextDark,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = KeybindFrame
                })
                
                local KeybindButton = Create("TextButton", {
                    Name = "Button",
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Centrix.Theme.Tertiary,
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 80, 0, 24),
                    Font = Centrix.Theme.FontMono,
                    Text = currentKey.Name,
                    TextColor3 = Centrix.Theme.Text,
                    TextSize = 11,
                    AutoButtonColor = false,
                    Parent = KeybindFrame
                })
                AddCorner(KeybindButton, UDim.new(0, 6))
                AddStroke(KeybindButton, Centrix.Theme.Outline, 1, 0.6)
                
                KeybindButton.MouseButton1Click:Connect(function()
                    listening = true
                    KeybindButton.Text = "..."
                    CreateTween(KeybindButton, {BackgroundColor3 = Centrix.Theme.Accent}, 0.15)
                end)
                
                local inputConnection
                inputConnection = UserInputService.InputBegan:Connect(function(input, processed)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        currentKey = input.KeyCode
                        KeybindButton.Text = currentKey.Name
                        CreateTween(KeybindButton, {BackgroundColor3 = Centrix.Theme.Tertiary}, 0.15)
                        if flag then
                            Centrix.Flags[flag] = currentKey
                        end
                    elseif not listening and input.KeyCode == currentKey then
                        callback(currentKey)
                    end
                end)
                
                table.insert(Centrix.Connections, inputConnection)
                
                if flag then
                    Centrix.Flags[flag] = currentKey
                end
                
                local KeybindObject = {}
                function KeybindObject:Set(key)
                    currentKey = key
                    KeybindButton.Text = currentKey.Name
                    if flag then Centrix.Flags[flag] = currentKey end
                end
                
                return KeybindObject
            end
            
            table.insert(Tab.Sections, Section)
            return Section
        end
        
        return Tab
    end
    
    -- Window Methods
    function Window:SetVisible(visible)
        Window.Visible = visible
        if visible then
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            CreateTween(MainFrame, {Size = size}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In, function()
                MainFrame.Visible = false
            end)
        end
    end
    
    function Window:Destroy()
        for _, connection in pairs(Centrix.Connections) do
            if connection then
                connection:Disconnect()
            end
        end
        Centrix.Connections = {}
        
        if self.ScreenGui then
            self.ScreenGui:Destroy()
        end
    end
    
    table.insert(Centrix.Windows, Window)
    
    -- Intro Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    CreateTween(MainFrame, {Size = size}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    return Window
end

-- Theme Engine
function Centrix:SetTheme(themeName)
    local themes = {
        Dark = {
            Primary = Color3.fromRGB(18, 18, 20),
            Secondary = Color3.fromRGB(24, 24, 28),
            Tertiary = Color3.fromRGB(32, 32, 38),
            Accent = Color3.fromRGB(124, 58, 237)
        },
        Midnight = {
            Primary = Color3.fromRGB(12, 12, 18),
            Secondary = Color3.fromRGB(18, 18, 26),
            Tertiary = Color3.fromRGB(26, 26, 36),
            Accent = Color3.fromRGB(99, 102, 241)
        },
        Ocean = {
            Primary = Color3.fromRGB(15, 23, 42),
            Secondary = Color3.fromRGB(30, 41, 59),
            Tertiary = Color3.fromRGB(51, 65, 85),
            Accent = Color3.fromRGB(56, 189, 248)
        }
    }
    
    if themes[themeName] then
        for key, value in pairs(themes[themeName]) do
            Centrix.Theme[key] = value
        end
    end
end

-- Save/Load Flags
function Centrix:SaveConfig(name)
    return self.Config:Save(name, self.Flags)
end

function Centrix:LoadConfig(name)
    local data = self.Config:Load(name)
    if data then
        for flag, value in pairs(data) do
            self.Flags[flag] = value
        end
        return true
    end
    return false
end

function Centrix:GetConfigs()
    return self.Config:GetConfigs()
end

-- Cleanup
function Centrix:Destroy()
    for _, window in pairs(self.Windows) do
        if window.Destroy then
            window:Destroy()
        end
    end
    self.Windows = {}
    self.Flags = {}
end


return Centrix
