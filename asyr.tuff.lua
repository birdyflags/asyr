--[[
    APEX UI LIBRARY
    Premium Dark Theme | Engineered Texture | Modern Animations
    
    Usage:
    local Library = loadstring(game:HttpGet("..."))() -- or require(module)
    local Window = Library.new({ Title = "PROJECT APEX", Logo = "rbxassetid://..." })
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Library = {}
local Utility = {}

-- [[ CONFIGURATION ]]
local Config = {
    Colors = {
        Background = Color3.fromRGB(12, 12, 12),
        Sidebar = Color3.fromRGB(8, 8, 8),
        SectionBorder = Color3.fromRGB(30, 30, 30),
        
        AccentStart = Color3.fromRGB(255, 170, 60), -- Amber
        AccentEnd = Color3.fromRGB(235, 100, 0),   -- Deep Orange
        
        TextMain = Color3.fromRGB(240, 240, 240),
        TextDim = Color3.fromRGB(140, 140, 140),
        
        ElementBg = Color3.fromRGB(18, 18, 18),
        ElementHover = Color3.fromRGB(25, 25, 25),
    },
    Sizes = {
        Window = UDim2.new(0, 700, 0, 480),
        Corner = UDim.new(0, 8),
    },
    Fonts = {
        Main = Enum.Font.GothamMedium,
        Bold = Enum.Font.GothamBold,
        Regular = Enum.Font.Gotham,
    }
}

-- [[ UTILITY FUNCTIONS ]]

function Utility:Tween(instance, info, properties)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

function Utility:Create(className, properties, children)
    local obj = Instance.new(className)
    for k, v in pairs(properties or {}) do
        obj[k] = v
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = obj
        end
    end
    return obj
end

function Utility:Gradient(parent)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Config.Colors.AccentStart),
        ColorSequenceKeypoint.new(1, Config.Colors.AccentEnd)
    }
    g.Parent = parent
    return g
end

function Utility:Ripple(instance)
    -- Simple click effect can be added here
end

function Utility:Draggable(frame, interact)
    local dragging, dragInput, dragStart, startPos
    
    interact.InputBegan:Connect(function(input)
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
    
    interact.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local smooth = 0.2
            Utility:Tween(frame, TweenInfo.new(smooth, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            })
        end
    end)
end

-- [[ LIBRARY LOGIC ]]

function Library.new(options)
    options = options or {}
    local Title = options.Title or "UI Library"
    local LogoId = options.Logo -- Optional
    
    local Apex = {}
    
    -- Protect GUI
    local Parent = RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui") or CoreGui
    
    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "Apex",
        Parent = Parent,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })
    
    local MainFrame = Utility:Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 0, 0, 0), -- Animated opening
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Config.Colors.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    
    Utility:Create("UICorner", { CornerRadius = Config.Sizes.Corner, Parent = MainFrame })
    Utility:Create("UIStroke", { Color = Color3.fromRGB(40,40,40), Thickness = 1, Parent = MainFrame })
    
    -- Open Animation
    Utility:Tween(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = Config.Sizes.Window
    })
    
    Utility:Draggable(MainFrame, MainFrame) -- Make whole window draggable for now (or add topbar)
    
    -- Sidebar
    local Sidebar = Utility:Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 180, 1, 0),
        BackgroundColor3 = Config.Colors.SidebarBackground,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    Utility:Create("UICorner", { CornerRadius = Config.Sizes.Corner, Parent = Sidebar })
    
    local SidebarCover = Utility:Create("Frame", {
        Name = "Cover",
        BackgroundColor3 = Config.Colors.SidebarBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -10, 0, 0),
        Parent = Sidebar
    })
    
    local SidebarStroke = Utility:Create("UIStroke", {
        Color = Color3.fromRGB(35,35,35),
        Thickness = 1,
        Parent = Sidebar
    }) -- Sidebar border
    
    -- Logo & Title Area
    local LogoArea = Utility:Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 70),
        Parent = Sidebar
    })
    
    if LogoId then
        local LogoImg = Utility:Create("ImageLabel", {
            Image = "rbxassetid://" .. tostring(LogoId),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 28, 0, 28),
            Position = UDim2.new(0, 20, 0.5, -14),
            Parent = LogoArea
        })
        Utility:Gradient(LogoImg) -- Apply gradient to logo for premium effect
        
        local TitleLbl = Utility:Create("TextLabel", {
            Text = Title,
            Font = Config.Fonts.Bold,
            TextSize = 18,
            TextColor3 = Config.Colors.TextMain,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 60, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LogoArea
        })
    else
        local TitleLbl = Utility:Create("TextLabel", {
            Text = Title,
            Font = Config.Fonts.Bold,
            TextSize = 22,
            TextColor3 = Config.Colors.TextMain,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 20, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LogoArea
        })
    end
    
    local TabContainer = Utility:Create("Frame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -80),
        Position = UDim2.new(0, 0, 0, 80),
        Parent = Sidebar
    })
    
    local TabList = Utility:Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = TabContainer
    })
    
    -- Pages Container
    local PageContainer = Utility:Create("Frame", {
        Name = "Pages",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -200, 1, -20),
        Position = UDim2.new(0, 190, 0, 10),
        Parent = MainFrame
    })
    
    local Tabs = {}
    local FirstTab = true
    
    function Apex:Tab(name, iconId)
        local Tab = {}
        
        -- Tab Button
        local TabBtn = Utility:Create("TextButton", {
            Name = name,
            Text = "",
            Size = UDim2.new(1, -20, 0, 36),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundColor3 = Color3.TRANSPARENT,
            AutoButtonColor = false,
            Parent = TabContainer
        })
        
        local TabLbl = Utility:Create("TextLabel", {
            Text = name,
            Font = Config.Fonts.Main,
            TextSize = 14,
            TextColor3 = Config.Colors.TextDim,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 40, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabBtn
        })
        
        -- Active Indicator
        local Indicator = Utility:Create("Frame", {
            Size = UDim2.new(0, 4, 0, 0), -- Height 0 initially
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Config.Colors.AccentStart,
            BorderSizePixel = 0,
            Parent = TabBtn
        })
        Utility:Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = Indicator })
        Utility:Gradient(Indicator)
        
        -- Icon
        if iconId then
             local Icon = Utility:Create("ImageLabel", {
                Image = "rbxassetid://"..tostring(iconId),
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 10, 0.5, -9),
                BackgroundTransparency = 1,
                ImageColor3 = Config.Colors.TextDim,
                Parent = TabBtn
             })
        end

        
        -- Page Frame
        local Page = Utility:Create("ScrollingFrame", {
            Name = name .. "Page",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Config.Colors.AccentStart,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = PageContainer
        })
        
        local PageLayout = Utility:Create("UIGridLayout", {
            CellSize = UDim2.new(0.48, 0, 0, 0), -- Height automatic
            CellPadding = UDim2.new(0.04, 0, 0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = Page
        })
        
        -- Tab Selection Logic
        local function Activate()
            -- Reset all
            for _, t in pairs(Tabs) do
                Utility:Tween(t.Btn.Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quart), { Size = UDim2.new(0, 0, 0, 0) })
                Utility:Tween(t.Btn.Label, TweenInfo.new(0.3, Enum.EasingStyle.Quart), { TextColor3 = Config.Colors.TextDim, Position = UDim2.new(0, 40, 0, 0) })
                if t.Btn.Icon then
                    Utility:Tween(t.Btn.Icon, TweenInfo.new(0.3), { ImageColor3 = Config.Colors.TextDim })
                end
                t.Page.Visible = false
            end
            
            -- Activate Current
            Utility:Tween(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Back), { Size = UDim2.new(0, 4, 0.6, 0) })
            Utility:Tween(TabLbl, TweenInfo.new(0.3, Enum.EasingStyle.Quart), { TextColor3 = Config.Colors.TextMain, Position = UDim2.new(0, 46, 0, 0) })
             if TabBtn:FindFirstChild("ImageLabel") then
                 Utility:Tween(TabBtn.ImageLabel, TweenInfo.new(0.3), { ImageColor3 = Config.Colors.TextMain })
             end
            Page.Visible = true
        end
        
        TabBtn.MouseButton1Click:Connect(Activate)
        
        if FirstTab then
            FirstTab = false
            Activate()
        end
        
        -- Store
        table.insert(Tabs, { Btn = { Self = TabBtn, Label = TabLbl, Indicator = Indicator, Icon = TabBtn:FindFirstChild("ImageLabel") }, Page = Page })
        
        function Tab:Section(secName)
            local SectionFuncs = {}
            
            -- Groupbox
            local SectionFrame = Utility:Create("Frame", {
                BackgroundColor3 = Color3.TRANSPARENT,
                Size = UDim2.new(1, 0, 0, 0), -- Auto scaled
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = Page
            })
            Utility:Create("UICorner", { CornerRadius = UDim.new(0,4), Parent = SectionFrame })
            Utility:Create("UIStroke", { Color = Config.Colors.SectionBorder, Thickness = 1, Parent = SectionFrame })
            
            local SecTitleMask = Utility:Create("Frame", {
                BackgroundColor3 = Config.Colors.Background,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, -7),
                Size = UDim2.new(0, 0, 0, 14),
                AutomaticSize = Enum.AutomaticSize.X,
                ZIndex = 2,
                Parent = SectionFrame
            })
            
            Utility:Create("TextLabel", {
                Text = secName:upper(),
                Font = Config.Fonts.Bold,
                TextSize = 10,
                TextColor3 = Config.Colors.TextDim,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                Position = UDim2.new(0, 4, 0, 0),
                Parent = SecTitleMask
            })
            
            local Container = Utility:Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -16, 1, -16),
                Position = UDim2.new(0, 8, 0, 12),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = SectionFrame
            })
            
            local List = Utility:Create("UIListLayout", {
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Container
            })
            
            -- [[ ELEMENTS ]]
            
            function SectionFuncs:Toggle(text, callback)
                callback = callback or function() end
                local state = false
                
                local ToggleFrame = Utility:Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 26),
                    Parent = Container
                })
                
                local Label = Utility:Create("TextLabel", {
                    Text = text,
                    TextSize = 13,
                    Font = Config.Fonts.Main,
                    TextColor3 = Config.Colors.TextDim,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -40, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ToggleFrame
                })
                
                local Switch = Utility:Create("Frame", {
                    Size = UDim2.new(0, 36, 0, 18),
                    Position = UDim2.new(1, -36, 0.5, -9),
                    BackgroundColor3 = Config.Colors.ElementBg,
                    Parent = ToggleFrame
                })
                Utility:Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = Switch })
                
                local Knob = Utility:Create("Frame", {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0, 2, 0.5, -7),
                    BackgroundColor3 = Color3.fromRGB(100,100,100),
                    Parent = Switch
                })
                Utility:Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = Knob })
                
                local Button = Utility:Create("TextButton", {
                    Text = "",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Parent = ToggleFrame
                })
                
                local function Update()
                    local targetColor = state and Config.Colors.AccentStart or Config.Colors.ElementBg
                    local targetKnobPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                    local targetKnobColor = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(100,100,100)
                    local targetText = state and Config.Colors.TextMain or Config.Colors.TextDim
                    
                    if state then
                        if not Switch:FindFirstChild("UIGradient") then
                            Utility:Gradient(Switch)
                        end
                        Switch.UIGradient.Enabled = true
                    else
                         if Switch:FindFirstChild("UIGradient") then
                             Switch.UIGradient.Enabled = false
                         end
                         Utility:Tween(Switch, TweenInfo.new(0.2), { BackgroundColor3 = Config.Colors.ElementBg })
                    end
                    
                    Utility:Tween(Knob, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = targetKnobPos, BackgroundColor3 = targetKnobColor })
                    Utility:Tween(Label, TweenInfo.new(0.2), { TextColor3 = targetText })
                end
                
                Button.MouseButton1Click:Connect(function()
                    state = not state
                    Update()
                    callback(state)
                end)
            end
            
            function SectionFuncs:Slider(text, min, max, default, callback)
                local value = default or min
                callback = callback or function() end
                
                local SliderFrame = Utility:Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    Parent = Container
                })
                
                local Label = Utility:Create("TextLabel", {
                    Text = text,
                    TextSize = 13,
                    Font = Config.Fonts.Main,
                    TextColor3 = Config.Colors.TextDim,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SliderFrame
                })
                
                local ValLabel = Utility:Create("TextLabel", {
                    Text = tostring(value),
                    TextSize = 13,
                    Font = Config.Fonts.Main,
                    TextColor3 = Config.Colors.TextMain,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = SliderFrame
                })
                
                local Track = Utility:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 4),
                    Position = UDim2.new(0, 0, 1, -6),
                    BackgroundColor3 = Config.Colors.ElementBg,
                    Parent = SliderFrame
                })
                Utility:Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = Track })
                
                local Fill = Utility:Create("Frame", {
                    Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = Config.Colors.AccentStart,
                    Parent = Track
                })
                Utility:Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = Fill })
                Utility:Gradient(Fill)
                
                local Knob = Utility:Create("Frame", {
                     Size = UDim2.new(0, 10, 0, 10),
                     Position = UDim2.new(1, -5, 0.5, -5),
                     BackgroundColor3 = Color3.new(1,1,1),
                     Parent = Fill
                })
                Utility:Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = Knob })
                
                local Button = Utility:Create("TextButton", {
                    Text = "",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Parent = SliderFrame
                })
                
                local dragging = false
                
                local function Update(input)
                    local pos = UDim2.new(math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    local percent = pos.X.Scale
                    value = math.floor(min + (max - min) * percent)
                    
                    Utility:Tween(Fill, TweenInfo.new(0.05), { Size = pos })
                    ValLabel.Text = tostring(value)
                    callback(value)
                end
                
                Button.InputBegan:Connect(function(input)
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
            end
            
             function SectionFuncs:Dropdown(text, options, callback)
                local expanded = false
                local selected = options[1] or "..."
                callback = callback or function() end
                
                local DropFrame = Utility:Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 42),
                    Parent = Container
                })
                
                local Label = Utility:Create("TextLabel", {
                     Text = text,
                    TextSize = 13,
                    Font = Config.Fonts.Main,
                    TextColor3 = Config.Colors.TextDim,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropFrame
                })
                
                local MainBtn = Utility:Create("TextButton", {
                    Text = "",
                    BackgroundColor3 = Config.Colors.ElementBg,
                    Size = UDim2.new(1, 0, 0, 22),
                    Position = UDim2.new(0, 0, 0, 20),
                    AutoButtonColor = false,
                    Parent = DropFrame
                })
                Utility:Create("UICorner", { CornerRadius = UDim.new(0,4), Parent = MainBtn })
                Utility:Create("UIStroke", { Color = Config.Colors.SectionBorder, Thickness = 1, Parent = MainBtn })
                
                local DispText = Utility:Create("TextLabel", {
                    Text = selected,
                    Font = Config.Fonts.Regular,
                    TextSize = 12,
                    TextColor3 = Config.Colors.TextDim,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -10, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = MainBtn
                })
                
                local Arrow = Utility:Create("TextLabel", {
                    Text = "v",
                    Font = Config.Fonts.Bold,
                    TextSize = 10,
                    TextColor3 = Config.Colors.TextDim,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -20, 0, 0),
                    Parent = MainBtn
                })
                
                -- Dropdown List
                local ListFrame = Utility:Create("ScrollingFrame", {
                    BackgroundColor3 = Config.Colors.ElementBg,
                    Size = UDim2.new(1, 0, 0, 0), -- Opens up
                    Position = UDim2.new(0, 0, 1, 2),
                    Visible = false,
                    ScrollBarThickness = 2,
                    ZIndex = 10,
                    Parent = MainBtn
                })
                 Utility:Create("UICorner", { CornerRadius = UDim.new(0,4), Parent = ListFrame })
                 Utility:Create("UIStroke", { Color = Config.Colors.SectionBorder, Thickness = 1, Parent = ListFrame })
                 
                 local LL = Utility:Create("UIListLayout", { Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = ListFrame })
                 
                 for _, opt in ipairs(options) do
                     local OptBtn = Utility:Create("TextButton", {
                         Text = opt,
                         Font = Config.Fonts.Regular,
                         TextSize = 12,
                         TextColor3 = Config.Colors.TextDim,
                         BackgroundColor3 = Color3.TRANSPARENT,
                         Size = UDim2.new(1, -10, 0, 20),
                         ZIndex = 11,
                         Parent = ListFrame
                     })
                     
                     OptBtn.MouseButton1Click:Connect(function()
                         selected = opt
                         DispText.Text = selected
                         DispText.TextColor3 = Config.Colors.TextMain
                         callback(opt)
                         expanded = false
                         ListFrame.Visible = false
                         Utility:Tween(DropFrame, TweenInfo.new(0.2), { Size = UDim2.new(1,0,0,42) })
                     end)
                 end
                 
                 MainBtn.MouseButton1Click:Connect(function()
                     expanded = not expanded
                     ListFrame.Visible = expanded
                     
                     if expanded then
                         local count = #options
                         local height = math.min(count * 22, 100)
                         ListFrame.Size = UDim2.new(1, 0, 0, height)
                         DropFrame.Size = UDim2.new(1, 0, 0, 42 + height + 5) -- Expand container to push others
                     else
                         DropFrame.Size = UDim2.new(1, 0, 0, 42)
                     end
                 end)
            end
            
             function SectionFuncs:Button(text, callback)
                 callback = callback or function() end
                 local BtnFrame = Utility:Create("Frame", {
                     BackgroundTransparency = 1,
                     Size = UDim2.new(1, 0, 0, 30),
                     Parent = Container
                 })
                 
                 local RealBtn = Utility:Create("TextButton", {
                     Text = text,
                     Font = Config.Fonts.Main,
                     TextSize = 12,
                     TextColor3 = Config.Colors.TextMain,
                     BackgroundColor3 = Config.Colors.ElementBg,
                     Size = UDim2.new(1, 0, 1, 0),
                     AutoButtonColor = false,
                     Parent = BtnFrame
                 })
                 Utility:Create("UICorner", { CornerRadius = UDim.new(0,4), Parent = RealBtn })
                 Utility:Create("UIStroke", { Color = Config.Colors.SectionBorder, Thickness = 1, Parent = RealBtn })
                 
                 RealBtn.MouseEnter:Connect(function()
                     Utility:Tween(RealBtn, TweenInfo.new(0.2), { BackgroundColor3 = Config.Colors.ElementHover })
                 end)
                 RealBtn.MouseLeave:Connect(function()
                     Utility:Tween(RealBtn, TweenInfo.new(0.2), { BackgroundColor3 = Config.Colors.ElementBg })
                 end)
                 RealBtn.MouseButton1Click:Connect(callback)
             end

            return SectionFuncs
        end
        
        return Tab
    end
    
    return Apex
end

return Library
