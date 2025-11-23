-- ASYR UI Library - Crimson Void Ultimate (Maximalist Edition)
-- Author: Antigravity
-- Version: 3.0.0 "Crimson Void"

--[[
    ASYR UI Library
    ===============
    A high-performance, feature-rich UI library for Roblox.
    Focus: "Crimson Void" Aesthetic, Advanced Animations, Robust Architecture.
]]

-- [ Services ] ----------------------------------------------------------------------------------
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")

-- [ Constants & Config ] ------------------------------------------------------------------------
local VIEWPORT_SIZE = workspace.CurrentCamera.ViewportSize
local MOUSE = Players.LocalPlayer:GetMouse()

-- [ Internal Library State ] --------------------------------------------------------------------
local Library = {
    Version = "3.0.0",
    ActiveWindow = nil,
    Open = true,
    Keybinds = {},
    Connections = {},
    Flags = {},
    Theme = {
        Main        = Color3.fromRGB(10, 10, 10),
        Secondary   = Color3.fromRGB(15, 15, 15),
        Stroke      = Color3.fromRGB(30, 30, 30),
        Divider     = Color3.fromRGB(25, 25, 25),
        Text        = Color3.fromRGB(240, 240, 240),
        TextDark    = Color3.fromRGB(140, 140, 140),
        Accent      = Color3.fromRGB(220, 20, 20), -- Crimson
        AccentDark  = Color3.fromRGB(160, 10, 10),
        Hover       = Color3.fromRGB(25, 25, 25),
        Success     = Color3.fromRGB(40, 200, 40),
        Warning     = Color3.fromRGB(220, 180, 40),
        Error       = Color3.fromRGB(220, 40, 40),
    }
}

-- [ Utility: Signal Class ] ---------------------------------------------------------------------
local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({_listeners = {}}, Signal)
end

function Signal:Connect(callback)
    local listener = {Callback = callback, Connected = true}
    table.insert(self._listeners, listener)
    return {
        Disconnect = function()
            listener.Connected = false
            listener.Callback = nil
        end
    }
end

function Signal:Fire(...)
    for _, listener in ipairs(self._listeners) do
        if listener.Connected and listener.Callback then
            task.spawn(listener.Callback, ...)
        end
    end
    -- Cleanup disconnected listeners periodically could go here
end

function Signal:Destroy()
    for _, listener in ipairs(self._listeners) do
        listener.Connected = false
        listener.Callback = nil
    end
    self._listeners = nil
end

-- [ Utility: Animator ] -------------------------------------------------------------------------
local Animator = {}
function Animator.Tween(obj, props, time, style, dir)
    time = time or 0.2
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local info = TweenInfo.new(time, style, dir)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

function Animator.Ripple(frame, x, y)
    task.spawn(function()
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.Parent = frame
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.8
        ripple.BorderSizePixel = 0
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Position = UDim2.new(0, x, 0, y)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ripple
        
        local targetSize = math.max(frame.AbsoluteSize.X, frame.AbsoluteSize.Y) * 1.5
        
        local t1 = Animator.Tween(ripple, {Size = UDim2.new(0, targetSize, 0, targetSize), BackgroundTransparency = 1}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        t1.Completed:Wait()
        ripple:Destroy()
    end)
end

-- [ Utility: Helper Functions ] -----------------------------------------------------------------
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" and k ~= "Children" then
            obj[k] = v
        end
    end
    if props and props.Children then
        for _, child in ipairs(props.Children) do
            child.Parent = obj
        end
    end
    if props and props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function Round(obj, radius)
    return Create("UICorner", {CornerRadius = radius or UDim.new(0, 6), Parent = obj})
end

local function Stroke(obj, color, thickness)
    return Create("UIStroke", {Color = color or Library.Theme.Stroke, Thickness = thickness or 1, Parent = obj})
end

local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

-- [ Icon System ] -------------------------------------------------------------------------------
local Icons = {}
do
    local function SafeLoad(url)
        local success, result = pcall(function() return loadstring(game:HttpGetAsync(url))() end)
        if success then return result else return {} end
    end
    Icons.Lucide = SafeLoad("https://raw.githubusercontent.com/Nebula-Softworks/Nebula-Icon-Library/master/LucideIcons.luau")
    function Library:GetIcon(name)
        if Icons.Lucide and Icons.Lucide[name] then
            return "rbxassetid://" .. Icons.Lucide[name]
        end
        return ""
    end
end

-- [ Component: Window ] -------------------------------------------------------------------------
local Window = {}
Window.__index = Window

function Window.new(options)
    local self = setmetatable({}, Window)
    self.Name = options.Name or "ASYR"
    self.IntroText = options.IntroText or "Welcome"
    self.Tabs = {}
    self.ActiveTab = nil
    
    -- Cleanup old
    if Library.ActiveWindow then Library.ActiveWindow:Destroy() end
    
    -- ScreenGui
    self.Gui = Create("ScreenGui", {
        Name = "ASYR_Interface",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    Library.ActiveWindow = self.Gui
    
    -- Main Frame
    self.Main = Create("Frame", {
        Name = "Main",
        Parent = self.Gui,
        Size = UDim2.new(0, 0, 0, 0), -- Starts small for animation
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Library.Theme.Main,
        BackgroundTransparency = 0.1,
        ClipsDescendants = true
    })
    Round(self.Main, UDim.new(0, 10))
    Stroke(self.Main, Library.Theme.Stroke, 1)
    
    -- Shadow
    Create("ImageLabel", {
        Name = "Shadow",
        Parent = self.Main,
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.new(0,0,0),
        ImageTransparency = 0.5,
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        ZIndex = -1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })

    -- Layout
    self.TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = self.Main,
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Library.Theme.Secondary,
        BackgroundTransparency = 0.5
    })
    Round(self.TopBar, UDim.new(0, 10))
    
    -- Title
    self.TitleLabel = Create("TextLabel", {
        Parent = self.TopBar,
        Text = self.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Library.Theme.Text,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Close Button
    self.CloseBtn = Create("TextButton", {
        Parent = self.TopBar,
        Text = "",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        BackgroundTransparency = 1,
    })
    local closeIcon = Create("ImageLabel", {
        Parent = self.CloseBtn,
        Image = Library:GetIcon("x"),
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0.5, -9, 0.5, -9),
        BackgroundTransparency = 1,
        ImageColor3 = Library.Theme.TextDark
    })
    self.CloseBtn.MouseEnter:Connect(function() Animator.Tween(closeIcon, {ImageColor3 = Library.Theme.Error}, 0.2) end)
    self.CloseBtn.MouseLeave:Connect(function() Animator.Tween(closeIcon, {ImageColor3 = Library.Theme.TextDark}, 0.2) end)
    self.CloseBtn.MouseButton1Click:Connect(function() Library:Toggle() end)

    -- Sidebar
    self.Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = self.Main,
        Size = UDim2.new(0, 180, 1, -45),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundColor3 = Library.Theme.Secondary,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0
    })
    Round(self.Sidebar, UDim.new(0, 10))
    
    self.TabContainer = Create("ScrollingFrame", {
        Parent = self.Sidebar,
        Size = UDim2.new(1, -10, 1, -20),
        Position = UDim2.new(0, 5, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    self.TabLayout = Create("UIListLayout", {
        Parent = self.TabContainer,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- Content Area
    self.Content = Create("Frame", {
        Name = "Content",
        Parent = self.Main,
        Size = UDim2.new(1, -190, 1, -55),
        Position = UDim2.new(0, 185, 0, 50),
        BackgroundTransparency = 1
    })

    -- Dragging
    local dragging, dragInput, dragStart, startPos
    self.TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    self.TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Animator.Tween(self.Main, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
    end)

    return self
end

function Window:CreateTab(name, icon)
    local Tab = {
        Name = name,
        Icon = icon,
        Window = self,
        Sections = {}
    }
    
    -- Tab Button
    local TabBtn = Create("TextButton", {
        Parent = self.TabContainer,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Library.Theme.Main,
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false
    })
    Round(TabBtn, UDim.new(0, 6))
    
    local TabIcon = Create("ImageLabel", {
        Parent = TabBtn,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 10, 0.5, -10),
        BackgroundTransparency = 1,
        Image = Library:GetIcon(icon or "box"),
        ImageColor3 = Library.Theme.TextDark
    })
    
    local TabLabel = Create("TextLabel", {
        Parent = TabBtn,
        Text = name,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = Library.Theme.TextDark,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 40, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Tab Content Frame
    local TabFrame = Create("ScrollingFrame", {
        Name = name .. "_Content",
        Parent = self.Content,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Library.Theme.Accent,
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    Create("UIListLayout", {
        Parent = TabFrame,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    Create("UIPadding", {
        Parent = TabFrame,
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 2),
        PaddingLeft = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 10)
    })
    
    -- Activation Logic
    TabBtn.MouseButton1Click:Connect(function()
        -- Deactivate current
        if self.ActiveTab then
            Animator.Tween(self.ActiveTab.Btn, {BackgroundTransparency = 1}, 0.2)
            Animator.Tween(self.ActiveTab.Label, {TextColor3 = Library.Theme.TextDark}, 0.2)
            Animator.Tween(self.ActiveTab.Icon, {ImageColor3 = Library.Theme.TextDark}, 0.2)
            self.ActiveTab.Frame.Visible = false
        end
        
        -- Activate new
        self.ActiveTab = {Btn = TabBtn, Label = TabLabel, Icon = TabIcon, Frame = TabFrame}
        Animator.Tween(TabBtn, {BackgroundTransparency = 0}, 0.2)
        Animator.Tween(TabLabel, {TextColor3 = Library.Theme.Text}, 0.2)
        Animator.Tween(TabIcon, {ImageColor3 = Library.Theme.Accent}, 0.2)
        TabFrame.Visible = true
        
        -- Ripple
        local x, y = MOUSE.X - TabBtn.AbsolutePosition.X, MOUSE.Y - TabBtn.AbsolutePosition.Y
        Animator.Ripple(TabBtn, x, y)
    end)
    
    -- Auto-select first
    if not self.ActiveTab then
        self.ActiveTab = {Btn = TabBtn, Label = TabLabel, Icon = TabIcon, Frame = TabFrame}
        TabBtn.BackgroundTransparency = 0
        TabLabel.TextColor3 = Library.Theme.Text
        TabIcon.ImageColor3 = Library.Theme.Accent
        TabFrame.Visible = true
    end
    
    -- Section Creator
    function Tab:CreateSection(title)
        local Section = {}
        
        -- Section Header
        local Header = Create("Frame", {
            Parent = TabFrame,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1
        })
        Create("TextLabel", {
            Parent = Header,
            Text = title,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = Library.Theme.Accent,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0
        })
        
        local Container = Create("Frame", {
            Parent = TabFrame,
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = Library.Theme.Secondary,
            BackgroundTransparency = 0.5
        })
        Round(Container, UDim.new(0, 6))
        Stroke(Container, Library.Theme.Stroke, 1)
        
        local List = Create("UIListLayout", {
            Parent = Container,
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        })
        Create("UIPadding", {
            Parent = Container,
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10)
        })
        
        -- Auto Resize
        List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.Size = UDim2.new(1, 0, 0, List.AbsoluteContentSize.Y + 20)
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabFrame.UIListLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- [ Component: Button ]
        function Section:CreateButton(opts)
            local btn = Create("TextButton", {
                Parent = Container,
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = Library.Theme.Main,
                Text = "",
                AutoButtonColor = false
            })
            Round(btn, UDim.new(0, 4))
            Stroke(btn, Library.Theme.Stroke, 1)
            
            local lbl = Create("TextLabel", {
                Parent = btn,
                Text = opts.Name or "Button",
                Font = Enum.Font.GothamSemibold,
                TextSize = 13,
                TextColor3 = Library.Theme.Text,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1
            })
            
            btn.MouseEnter:Connect(function() 
                Animator.Tween(btn, {BackgroundColor3 = Library.Theme.Hover}, 0.2) 
            end)
            btn.MouseLeave:Connect(function() 
                Animator.Tween(btn, {BackgroundColor3 = Library.Theme.Main}, 0.2) 
            end)
            btn.MouseButton1Click:Connect(function()
                local x, y = MOUSE.X - btn.AbsolutePosition.X, MOUSE.Y - btn.AbsolutePosition.Y
                Animator.Ripple(btn, x, y)
                if opts.Callback then opts.Callback() end
            end)
        end
        
        -- [ Component: Toggle ]
        function Section:CreateToggle(opts)
            local toggleFrame = Create("Frame", {
                Parent = Container,
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1
            })
            
            local lbl = Create("TextLabel", {
                Parent = toggleFrame,
                Text = opts.Name or "Toggle",
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = Library.Theme.Text,
                Size = UDim2.new(0.7, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local btn = Create("TextButton", {
                Parent = toggleFrame,
                Size = UDim2.new(0, 44, 0, 22),
                Position = UDim2.new(1, -44, 0.5, -11),
                BackgroundColor3 = Library.Theme.Main,
                Text = "",
                AutoButtonColor = false
            })
            Round(btn, UDim.new(1, 0))
            Stroke(btn, Library.Theme.Stroke, 1)
            
            local knob = Create("Frame", {
                Parent = btn,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 2, 0.5, -9),
                BackgroundColor3 = Library.Theme.TextDark
            })
            Round(knob, UDim.new(1, 0))
            
            local state = opts.CurrentValue or false
            local function update()
                if state then
                    Animator.Tween(btn, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                    Animator.Tween(knob, {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = Library.Theme.Text}, 0.2)
                else
                    Animator.Tween(btn, {BackgroundColor3 = Library.Theme.Main}, 0.2)
                    Animator.Tween(knob, {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = Library.Theme.TextDark}, 0.2)
                end
                if opts.Callback then opts.Callback(state) end
            end
            update()
            
            btn.MouseButton1Click:Connect(function()
                state = not state
                update()
            end)
        end
        
        -- [ Component: Slider ]
        function Section:CreateSlider(opts)
            local sliderFrame = Create("Frame", {
                Parent = Container,
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundTransparency = 1
            })
            
            local lbl = Create("TextLabel", {
                Parent = sliderFrame,
                Text = opts.Name or "Slider",
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = Library.Theme.Text,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local valLbl = Create("TextLabel", {
                Parent = sliderFrame,
                Text = tostring(opts.CurrentValue or 0),
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextColor3 = Library.Theme.Text,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local track = Create("Frame", {
                Parent = sliderFrame,
                Size = UDim2.new(1, 0, 0, 6),
                Position = UDim2.new(0, 0, 0, 28),
                BackgroundColor3 = Library.Theme.Main
            })
            Round(track, UDim.new(1, 0))
            
            local fill = Create("Frame", {
                Parent = track,
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Library.Theme.Accent
            })
            Round(fill, UDim.new(1, 0))
            
            local min = opts.Range and opts.Range[1] or 0
            local max = opts.Range and opts.Range[2] or 100
            local value = opts.CurrentValue or min
            
            local function update(input)
                local sizeX = track.AbsoluteSize.X
                local relX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, sizeX)
                local percent = relX / sizeX
                value = math.floor(min + (max - min) * percent)
                
                Animator.Tween(fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                valLbl.Text = tostring(value)
                if opts.Callback then opts.Callback(value) end
            end
            
            -- Init
            local percent = (value - min) / (max - min)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local conn
                    conn = UserInputService.InputChanged:Connect(function(move)
                        if move.UserInputType == Enum.UserInputType.MouseMovement or move.UserInputType == Enum.UserInputType.Touch then
                            update(move)
                        end
                    end)
                    local endConn
                    endConn = UserInputService.InputEnded:Connect(function(endInput)
                        if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                            conn:Disconnect()
                            endConn:Disconnect()
                        end
                    end)
                    update(input)
                end
            end)
        end
        


        -- [ Component: Dropdown ]
        function Section:CreateDropdown(opts)
            local dropdownFrame = Create("Frame", {
                Parent = Container,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                ClipsDescendants = true
            })
            
            local lbl = Create("TextLabel", {
                Parent = dropdownFrame,
                Text = opts.Name or "Dropdown",
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = Library.Theme.Text,
                Size = UDim2.new(0.4, 0, 0, 36),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local btn = Create("TextButton", {
                Parent = dropdownFrame,
                Size = UDim2.new(0.6, 0, 0, 32),
                Position = UDim2.new(0.4, 0, 0, 2),
                BackgroundColor3 = Library.Theme.Main,
                Text = opts.CurrentOption or "Select...",
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = Library.Theme.Text,
                AutoButtonColor = false
            })
            Round(btn, UDim.new(0, 4))
            Stroke(btn, Library.Theme.Stroke, 1)
            
            local arrow = Create("ImageLabel", {
                Parent = btn,
                Image = Library:GetIcon("chevron-down"),
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -20, 0.5, -8),
                BackgroundTransparency = 1,
                ImageColor3 = Library.Theme.TextDark
            })
            
            local list = Create("ScrollingFrame", {
                Parent = btn,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 5),
                BackgroundColor3 = Library.Theme.Secondary,
                BorderSizePixel = 0,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Library.Theme.Accent,
                Visible = false,
                ZIndex = 10
            })
            Round(list, UDim.new(0, 4))
            Stroke(list, Library.Theme.Stroke, 1)
            
            local layout = Create("UIListLayout", {
                Parent = list,
                Padding = UDim.new(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            local open = false
            
            local function toggle()
                open = not open
                if open then
                    list.Visible = true
                    Animator.Tween(arrow, {Rotation = 180}, 0.2)
                    Animator.Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 36 + math.min(#opts.Options * 26, 150) + 10)}, 0.2)
                    Animator.Tween(list, {Size = UDim2.new(1, 0, 0, math.min(#opts.Options * 26, 150))}, 0.2)
                else
                    Animator.Tween(arrow, {Rotation = 0}, 0.2)
                    Animator.Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                    local t = Animator.Tween(list, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    t.Completed:Connect(function() list.Visible = false end)
                end
            end
            
            btn.MouseButton1Click:Connect(toggle)
            
            for _, opt in ipairs(opts.Options or {}) do
                local optBtn = Create("TextButton", {
                    Parent = list,
                    Size = UDim2.new(1, -4, 0, 24),
                    BackgroundColor3 = Library.Theme.Secondary,
                    BackgroundTransparency = 1,
                    Text = opt,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Library.Theme.TextDark,
                    AutoButtonColor = false
                })
                Round(optBtn, UDim.new(0, 4))
                
                optBtn.MouseEnter:Connect(function() Animator.Tween(optBtn, {BackgroundTransparency = 0.8, TextColor3 = Library.Theme.Text}, 0.1) end)
                optBtn.MouseLeave:Connect(function() Animator.Tween(optBtn, {BackgroundTransparency = 1, TextColor3 = Library.Theme.TextDark}, 0.1) end)
                
                optBtn.MouseButton1Click:Connect(function()
                    btn.Text = opt
                    toggle()
                    if opts.Callback then opts.Callback(opt) end
                end)
            end
            
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
            end)
        end
        
        -- [ Component: ColorPicker ]
        function Section:CreateColorPicker(opts)
            local pickerFrame = Create("Frame", {
                Parent = Container,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                ClipsDescendants = true
            })
            
            local lbl = Create("TextLabel", {
                Parent = pickerFrame,
                Text = opts.Name or "Color Picker",
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = Library.Theme.Text,
                Size = UDim2.new(0.6, 0, 0, 36),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local preview = Create("TextButton", {
                Parent = pickerFrame,
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -40, 0.5, -10),
                BackgroundColor3 = opts.Color or Color3.new(1,1,1),
                Text = "",
                AutoButtonColor = false
            })
            Round(preview, UDim.new(0, 4))
            Stroke(preview, Library.Theme.Stroke, 1)
            
            -- Expanded Area
            local expanded = Create("Frame", {
                Parent = pickerFrame,
                Size = UDim2.new(1, 0, 0, 150),
                Position = UDim2.new(0, 0, 0, 36),
                BackgroundTransparency = 1,
                Visible = false
            })
            
            -- SV Square
            local sv = Create("ImageLabel", {
                Parent = expanded,
                Size = UDim2.new(0, 120, 0, 120),
                Position = UDim2.new(0, 10, 0, 10),
                Image = "rbxassetid://4155801252", -- Color Wheel/Square
                BackgroundColor3 = Color3.new(1,0,0)
            })
            Round(sv, UDim.new(0, 4))
            
            local svCursor = Create("Frame", {
                Parent = sv,
                Size = UDim2.new(0, 6, 0, 6),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.new(1,1,1),
                BorderSizePixel = 0
            })
            Round(svCursor, UDim.new(1, 0))
            
            -- Hue Strip
            local hue = Create("ImageButton", {
                Parent = expanded,
                Size = UDim2.new(0, 20, 0, 120),
                Position = UDim2.new(0, 140, 0, 10),
                Image = "rbxassetid://3641079629", -- Hue Gradient
                BackgroundColor3 = Color3.new(1,1,1)
            })
            Round(hue, UDim.new(0, 4))
            
            local hueCursor = Create("Frame", {
                Parent = hue,
                Size = UDim2.new(1, 0, 0, 2),
                BackgroundColor3 = Color3.new(1,1,1),
                BorderSizePixel = 0
            })
            
            local h, s, v = Color3.toHSV(opts.Color or Color3.new(1,1,1))
            
            local function update()
                local color = Color3.fromHSV(h, s, v)
                preview.BackgroundColor3 = color
                sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                if opts.Callback then opts.Callback(color) end
            end
            
            local open = false
            preview.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    expanded.Visible = true
                    Animator.Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 190)}, 0.2)
                else
                    Animator.Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 36)}, 0.2).Completed:Connect(function() expanded.Visible = false end)
                end
            end)
            
            -- Input Handling
            local draggingSV, draggingHue
            
            sv.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = true end
            end)
            hue.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = true end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = false draggingHue = false end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if draggingSV then
                        local relX = math.clamp(input.Position.X - sv.AbsolutePosition.X, 0, sv.AbsoluteSize.X)
                        local relY = math.clamp(input.Position.Y - sv.AbsolutePosition.Y, 0, sv.AbsoluteSize.Y)
                        s = relX / sv.AbsoluteSize.X
                        v = 1 - (relY / sv.AbsoluteSize.Y)
                        svCursor.Position = UDim2.new(s, 0, 1-v, 0)
                        update()
                    elseif draggingHue then
                        local relY = math.clamp(input.Position.Y - hue.AbsolutePosition.Y, 0, hue.AbsoluteSize.Y)
                        h = 1 - (relY / hue.AbsoluteSize.Y)
                        hueCursor.Position = UDim2.new(0, 0, 1-h, 0)
                        update()
                    end
                end
            end)
        end
        
        -- [ Component: Keybind ]
        function Section:CreateKeybind(opts)
            local keybindFrame = Create("Frame", {
                Parent = Container,
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1
            })
            
            local lbl = Create("TextLabel", {
                Parent = keybindFrame,
                Text = opts.Name or "Keybind",
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = Library.Theme.Text,
                Size = UDim2.new(0.6, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local btn = Create("TextButton", {
                Parent = keybindFrame,
                Size = UDim2.new(0, 80, 0, 22),
                Position = UDim2.new(1, -80, 0.5, -11),
                BackgroundColor3 = Library.Theme.Main,
                Text = opts.Default and opts.Default.Name or "None",
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = Library.Theme.TextDark,
                AutoButtonColor = false
            })
            Round(btn, UDim.new(0, 4))
            Stroke(btn, Library.Theme.Stroke, 1)
            
            local listening = false
            btn.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                btn.Text = "..."
                btn.TextColor3 = Library.Theme.Accent
                
                local conn
                conn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        conn:Disconnect()
                        listening = false
                        btn.Text = input.KeyCode.Name
                        btn.TextColor3 = Library.Theme.TextDark
                        if opts.Callback then opts.Callback(input.KeyCode) end
                    end
                end)
            end)
        end
        
        -- [ Component: Textbox ]
        function Section:CreateTextbox(opts)
            local boxFrame = Create("Frame", {
                Parent = Container,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1
            })
            
            local lbl = Create("TextLabel", {
                Parent = boxFrame,
                Text = opts.Name or "Textbox",
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = Library.Theme.Text,
                Size = UDim2.new(0.4, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local box = Create("TextBox", {
                Parent = boxFrame,
                Size = UDim2.new(0.6, 0, 0, 30),
                Position = UDim2.new(0.4, 0, 0.5, -15),
                BackgroundColor3 = Library.Theme.Main,
                Text = "",
                PlaceholderText = opts.Placeholder or "Type here...",
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = Library.Theme.Text,
                PlaceholderColor3 = Library.Theme.TextDark,
                ClearTextOnFocus = false
                BackgroundTransparency = 1
            })
            
            local line = Create("Frame", {
                Parent = div,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 0.5, 0),
                BackgroundColor3 = Library.Theme.Divider,
                BorderSizePixel = 0
            })
            
            if text then
                local lbl = Create("TextLabel", {
                    Parent = div,
                    Text = text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 11,
                    TextColor3 = Library.Theme.TextDark,
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundTransparency = 0,
                    BackgroundColor3 = Library.Theme.Secondary, -- Match container bg
                    AutomaticSize = Enum.AutomaticSize.X
                })
            end
        end

        return Section
    end
    
    return Tab
end

-- [ Notification System ] -----------------------------------------------------------------------
function Library:Notify(opts)
    local screen = CoreGui:FindFirstChild("ASYR_Notifications")
    if not screen then
        screen = Create("ScreenGui", {Name = "ASYR_Notifications", Parent = CoreGui})
    end
    
    local notif = Create("Frame", {
        Parent = screen,
        Size = UDim2.new(0, 260, 0, 70),
        Position = UDim2.new(1, 20, 1, -100), -- Start off screen
        BackgroundColor3 = Library.Theme.Secondary,
        BackgroundTransparency = 0.1
    })
    Round(notif, UDim.new(0, 6))
    Stroke(notif, Library.Theme.Stroke, 1)
    
    -- Accent Bar
    local bar = Create("Frame", {
        Parent = notif,
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = Library.Theme.Accent
    })
    Round(bar, UDim.new(0, 6))
    
    local title = Create("TextLabel", {
        Parent = notif,
        Text = opts.Title or "Notification",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Library.Theme.Text,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 15, 0, 8),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local content = Create("TextLabel", {
        Parent = notif,
        Text = opts.Content or "Message",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Library.Theme.TextDark,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 15, 0, 28),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })
    
    -- Stack Logic
    local yOffset = -100
    for _, child in ipairs(screen:GetChildren()) do
        if child ~= notif then
            Animator.Tween(child, {Position = UDim2.new(1, -280, 1, child.Position.Y.Offset - 80)}, 0.3)
            yOffset = yOffset - 80
        end
    end
    
    -- Animate In
    Animator.Tween(notif, {Position = UDim2.new(1, -280, 1, -100)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Animate Out
    task.delay(opts.Duration or 3, function()
        Animator.Tween(notif, {Position = UDim2.new(1, 20, 1, notif.Position.Y.Offset)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In).Completed:Connect(function()
            notif:Destroy()
        end)
    end)
end

-- [ Library Control & Intro ] -------------------------------------------------------------------
Library.IntroComplete = false
Library.ActiveWindow = nil

function Library:Toggle(forceState)
    if not self.ActiveWindow or not self.ActiveWindow.Main then return end
    
    if forceState ~= nil then
        self.Open = forceState
    else
        self.Open = not self.Open
    end
    
    if self.Open then
        Library:FullScreenBlur(true)
        self.ActiveWindow.Main.Visible = true
        Animator.Tween(self.ActiveWindow.Main, {Size = UDim2.new(0, 600, 0, 500), BackgroundTransparency = 0.1}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        Library:FullScreenBlur(false)
        Animator.Tween(self.ActiveWindow.Main, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.wait(0.3)
        self.ActiveWindow.Main.Visible = false
    end
end

function Library:FullScreenBlur(enable)
    if enable then
        if not Lighting:FindFirstChild("ASYR_Blur") then
            local blur = Instance.new("BlurEffect")
            blur.Name = "ASYR_Blur"
            blur.Size = 0
            blur.Parent = Lighting
            Animator.Tween(blur, {Size = 24}, 0.5)
        end
    else
        local blur = Lighting:FindFirstChild("ASYR_Blur")
        if blur then
            local t = Animator.Tween(blur, {Size = 0}, 0.3)
            t.Completed:Connect(function() blur:Destroy() end)
        end
    end
end

function Library:InitIntro()
    local IntroGui = Create("ScreenGui", {Parent = CoreGui, Name = "ASYR_Intro"})
    local ToggleBtn -- For mobile persistence
    
    if IsMobile() then
        -- Mobile Orb
        local Orb = Create("ImageButton", {
            Parent = IntroGui,
            Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(0.5, -30, 0.8, 0),
            BackgroundColor3 = Library.Theme.Accent,
            BackgroundTransparency = 0.2,
            AutoButtonColor = false
        })
        Round(Orb, UDim.new(1, 0))
        Stroke(Orb, Library.Theme.Text, 2)
        
        local Icon = Create("ImageLabel", {
            Parent = Orb,
            Image = Library:GetIcon("menu"),
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0.5, -15, 0.5, -15),
            BackgroundTransparency = 1,
            ImageColor3 = Library.Theme.Text
        })
        
        -- Float Animation
        task.spawn(function()
            while Orb.Parent do
                Animator.Tween(Orb, {Position = UDim2.new(0.5, -30, 0.8, -10)}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
                Animator.Tween(Orb, {Position = UDim2.new(0.5, -30, 0.8, 10)}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
            end
        end)
        
        Orb.MouseButton1Click:Connect(function()
            if not Library.IntroComplete then
                Library.IntroComplete = true
                -- Morph to toggle button
                Animator.Tween(Orb, {
                    Size = UDim2.new(0, 40, 0, 40),
                    Position = UDim2.new(0.5, -20, 0, 10),
                    BackgroundTransparency = 0.5
                }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                
                Library:Toggle(true)
            else
                Library:Toggle()
            end
        end)
        
        ToggleBtn = Orb -- Keep reference
        
    else
        -- PC Prompt
        local Frame = Create("Frame", {
            Parent = IntroGui,
            Size = UDim2.new(0, 300, 0, 100),
            Position = UDim2.new(0.5, -150, 0.5, -50),
            BackgroundColor3 = Library.Theme.Main,
            BackgroundTransparency = 1
        })
        
        local Label = Create("TextLabel", {
            Parent = Frame,
            Text = "Press [INSERT] to Open",
            Font = Enum.Font.GothamBold,
            TextSize = 24,
            TextColor3 = Library.Theme.Text,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            TextTransparency = 1
        })
        
        Animator.Tween(Label, {TextTransparency = 0}, 1)
        
        -- Global Input Handler
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.KeyCode == Enum.KeyCode.Insert then
                if not Library.IntroComplete then
                    Library.IntroComplete = true
                    Animator.Tween(Label, {TextTransparency = 1}, 0.5).Completed:Wait()
                    IntroGui:Destroy()
                    Library:Toggle(true)
                else
                    Library:Toggle()
                end
            end
        end)
    end
end

function Library:CreateWindow(options)
    local win = Window.new(options)
    Library.ActiveWindow = win
    
    -- Hide initially, wait for intro
    win.Main.Visible = false
    win.Main.Size = UDim2.new(0, 0, 0, 0)
    
    -- Start Intro Sequence
    Library:InitIntro()
    
    return win
end

return Library
