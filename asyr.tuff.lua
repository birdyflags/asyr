--[[
    Antigravity UI Library
    A premium, animated, and high-performance UI library for Roblox.
    Features: Draggable/Resizable windows, Blue-Black Gradient, Lazy Loading, and more.
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {
    Connections = {},
    Enabled = true,
    Themes = {
        Default = {
            Accent = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(116, 138, 210)),
                ColorSequenceKeypoint.new(0.324, Color3.fromRGB(104, 123, 188)),
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(88, 105, 159)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(49, 57, 84))
            },
            Background = Color3.fromRGB(15, 15, 15),
            Text = Color3.fromRGB(255, 255, 255),
            DarkText = Color3.fromRGB(150, 150, 150),
            Border = Color3.fromRGB(40, 40, 40),
            Rounding = UDim.new(0, 8)
        }
    },
    Components = {},
    State = {},
    Flags = {},
    Tooltips = {}
}

-- [[ Internal Utilities ]]
local function Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    if children then
        for _, child in pairs(children) do
            child.Parent = inst
        end
    end
    return inst
end

local function Tween(object, info, goals)
    local tween = TweenService:Create(object, info, goals)
    tween:Play()
    return tween
end

-- [[ Theme Manager ]]
function Library:ApplyTheme(object)
    -- Logic to update colors dynamically across all registered components
end

-- [[ Window Management ]]
function Library:CreateWindow(options)
    local Window = {
        Visible = true,
        Tabs = {},
        ActiveTab = nil,
        Dragging = false,
        Resizing = false
    }

    local ScreenGui = Create("ScreenGui", {
        Name = "AntigravityUI",
        Parent = CoreGui,
        ResetOnSpawn = false,
        DisplayOrder = 100
    })

    local MainFrame = Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Library.Themes.Default.Background,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = true
    }, {
        Create("UICorner", { CornerRadius = Library.Themes.Default.Rounding }),
        Create("UIStroke", { Color = Library.Themes.Default.Border, Thickness = 1 }),
        -- Title Bar
        Create("Frame", {
            Name = "TitleBar",
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
        }, {
            Create("TextLabel", {
                Name = "Title",
                Text = options.Name or "Antigravity UI",
                Size = UDim2.new(1, -100, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                Font = Enum.Font.GothamBold,
                TextColor3 = Library.Themes.Default.Text,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1
            })
        })
    })

    -- Blue-Black Gradient Accent
    local AccentGradient = Create("UIGradient", {
        Name = "MainGradient",
        Rotation = 90,
        Color = Library.Themes.Default.Accent,
        Parent = MainFrame
    })

    -- Main Content Area
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        Position = UDim2.new(0, 5, 0, 45),
        Size = UDim2.new(0, 150, 1, -50),
        BackgroundTransparency = 1
    }, {
        Create("UIListLayout", { Padding = UDim.new(0, 5) })
    })

    local PageContainer = Create("Frame", {
        Name = "PageContainer",
        Parent = MainFrame,
        Position = UDim2.new(0, 160, 0, 45),
        Size = UDim2.new(1, -165, 1, -50),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })

    -- Resizing Logic
    local ResizeHandle = Create("ImageButton", {
        Name = "ResizeHandle",
        Parent = MainFrame,
        Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3944595964", -- Arrow icon or similar
        ImageColor3 = Library.Themes.Default.DarkText
    })

    local resizing = false
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            local startSize = MainFrame.Size
            local startPos = input.Position
            
            local connection
            connection = UserInputService.InputChanged:Connect(function(move)
                if move.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = move.Position - startPos
                    MainFrame.Size = UDim2.new(0, math.max(400, startSize.X.Offset + delta.X), 0, math.max(300, startSize.Y.Offset + delta.Y))
                end
            end)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                    connection:Disconnect()
                end
            end)
        end
    end)

    function Window:CreateTab(name, icon)
        local Tab = { Active = false, Sections = {} }
        
        local TabButton = Create("TextButton", {
            Name = name,
            Parent = TabContainer,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1,
            Text = name,
            Font = Enum.Font.Gotham,
            TextColor3 = Library.Themes.Default.DarkText,
            TextSize = 14
        })

        local Page = Create("ScrollingFrame", {
            Name = name .. "Page",
            Parent = PageContainer,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Themes.Default.Accent.Keypoints[1].Value
        }, {
            Create("UIListLayout", { Padding = UDim.new(0, 10), HorizontalAlignment = Enum.HorizontalAlignment.Center })
        })

        function Tab:Show()
            for _, t in pairs(Window.Tabs) do t:Hide() end
            Tab.Active = true
            Page.Visible = true
            Tween(TabButton, TweenInfo.new(0.3), { TextColor3 = Library.Themes.Default.Text })
        end

        function Tab:Hide()
            Tab.Active = false
            Page.Visible = false
            Tween(TabButton, TweenInfo.new(0.3), { TextColor3 = Library.Themes.Default.DarkText })
        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Show()
        end)

        function Tab:CreateSection(title)
            local Section = { Expanded = true }
            local SectionFrame = Create("Frame", {
                Name = title,
                Parent = Page,
                Size = UDim2.new(0.95, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                ClipsDescendants = true
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Create("TextLabel", {
                    Text = title,
                    Size = UDim2.new(1, -10, 0, 30),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Library.Themes.Default.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            })

            local Container = Create("Frame", {
                Name = "Container",
                Parent = SectionFrame,
                Position = UDim2.new(0, 0, 0, 40),
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1
            }, {
                Create("UIListLayout", { Padding = UDim.new(0, 5), HorizontalAlignment = Enum.HorizontalAlignment.Center })
            })

            function Section:AddControl(controlType, options)
                local Control = { Value = options.Default }
                
                local ControlFrame = Create("Frame", {
                    Name = options.Name,
                    Parent = Container,
                    Size = UDim2.new(1, -10, 0, 35),
                    BackgroundTransparency = 1
                })

                -- Tooltip Logic
                if options.Tooltip then
                    local TooltipLabel = Create("TextLabel", {
                        Text = options.Tooltip,
                        Visible = false,
                        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                        TextColor3 = Library.Themes.Default.Text,
                        Size = UDim2.new(0, 150, 0, 30),
                        Font = Enum.Font.Gotham,
                        TextSize = 12,
                        Parent = ScreenGui,
                        ZIndex = 1000
                    }, { Create("UICorner", { CornerRadius = UDim.new(0, 4) }) })

                    ControlFrame.MouseEnter:Connect(function()
                        TooltipLabel.Visible = true
                        local connection
                        connection = RunService.RenderStepped:Connect(function()
                            if not TooltipLabel.Visible then connection:Disconnect() return end
                            TooltipLabel.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
                        end)
                    end)
                    ControlFrame.MouseLeave:Connect(function() TooltipLabel.Visible = false end)
                end

                if controlType == "Button" then
                    local Button = Create("TextButton", {
                        Text = options.Name,
                        Parent = ControlFrame,
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        TextColor3 = Library.Themes.Default.Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 14
                    }, { Create("UICorner", { CornerRadius = UDim.new(0, 4) }) })

                    Button.MouseButton1Click:Connect(function()
                        options.Callback()
                    end)
                elseif controlType == "Toggle" then
                    local ToggleBase = Create("Frame", {
                        Size = UDim2.new(0, 40, 0, 20),
                        Position = UDim2.new(1, -45, 0.5, -10),
                        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                        Parent = ControlFrame
                    }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                    local Dot = Create("Frame", {
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new(0, 2, 0.5, -8),
                        BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                        Parent = ToggleBase
                    }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                    local function Set(val)
                        Control.Value = val
                        local color = val and Library.Themes.Default.Accent.Keypoints[1].Value or Color3.fromRGB(45, 45, 45)
                        local pos = val and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2)
                        Tween(ToggleBase, TweenInfo.new(0.3), { BackgroundColor3 = color })
                        Tween(Dot, TweenInfo.new(0.3), { Position = pos })
                        options.Callback(val)
                    end

                    ControlFrame.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Set(not Control.Value)
                        end
                    end)
                    Set(options.Default or false)
                elseif controlType == "Slider" then
                    local SliderBg = Create("Frame", {
                        Size = UDim2.new(0.6, 0, 0, 6),
                        Position = UDim2.new(0.3, 0, 0.5, -3),
                        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                        Parent = ControlFrame
                    }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                    local Fill = Create("Frame", {
                        Size = UDim2.new(0, 0, 1, 0),
                        BackgroundColor3 = Library.Themes.Default.Accent.Keypoints[1].Value,
                        Parent = SliderBg
                    }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

                    local function Update(input)
                        local percentage = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                        local value = math.floor((options.Min + (options.Max - options.Min) * percentage) / options.Step) * options.Step
                        Control.Value = value
                        Fill.Size = UDim2.new(percentage, 0, 1, 0)
                        options.Callback(value)
                    end

                    local sliding = false
                    SliderBg.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = true
                            Update(input)
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                            Update(input)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
                    end)
                elseif controlType == "Dropdown" then
                    local DropdownBase = Create("Frame", {
                        Size = UDim2.new(0.6, 0, 1, 0),
                        Position = UDim2.new(0.4, 0, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = ControlFrame
                    }, { Create("UICorner", { CornerRadius = UDim.new(0, 4) }) })

                    local SelectedText = Create("TextLabel", {
                        Text = options.Multi and "Select Multiple..." or (options.Default or "Select..."),
                        Size = UDim2.new(1, -10, 1, 0),
                        Position = UDim2.new(0, 5, 0, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = Library.Themes.Default.Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 13,
                        Parent = DropdownBase
                    })

                    local List = Create("Frame", {
                        Size = UDim2.new(1, 0, 0, 0),
                        Position = UDim2.new(0, 0, 1, 5),
                        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                        Visible = false,
                        ZIndex = 10,
                        Parent = DropdownBase
                    }, {
                        Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                        Create("UIListLayout", { Padding = UDim.new(0, 2) })
                    })

                    local function ToggleList()
                        List.Visible = not List.Visible
                        List.Size = List.Visible and UDim2.new(1, 0, 0, #options.Options * 25) or UDim2.new(1, 0, 0, 0)
                    end

                    DropdownBase.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then ToggleList() end
                    end)

                    local SelectedValues = options.Multi and {} or { options.Default }
                    for _, opt in pairs(options.Options) do
                        local OptBtn = Create("TextButton", {
                            Text = opt,
                            Size = UDim2.new(1, 0, 0, 25),
                            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                            TextColor3 = Library.Themes.Default.DarkText,
                            Font = Enum.Font.Gotham,
                            TextSize = 12,
                            Parent = List
                        })

                        OptBtn.MouseButton1Click:Connect(function()
                            if options.Multi then
                                if table.find(SelectedValues, opt) then
                                    table.remove(SelectedValues, table.find(SelectedValues, opt))
                                    OptBtn.TextColor3 = Library.Themes.Default.DarkText
                                else
                                    table.insert(SelectedValues, opt)
                                    OptBtn.TextColor3 = Library.Themes.Default.Text
                                end
                                options.Callback(SelectedValues)
                            else
                                SelectedValues = { opt }
                                SelectedText.Text = opt
                                ToggleList()
                                options.Callback(opt)
                            end
                        end)
                    end
                elseif controlType == "Input" then
                    local InputBase = Create("TextBox", {
                        Size = UDim2.new(0.6, 0, 1, 0),
                        Position = UDim2.new(0.4, 0, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Text = options.Default or "",
                        PlaceholderText = options.Placeholder or "Type here...",
                        TextColor3 = Library.Themes.Default.Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 13,
                        ClearTextOnFocus = false,
                        Parent = ControlFrame
                    }, { Create("UICorner", { CornerRadius = UDim.new(0, 4) }) })

                    InputBase.FocusLost:Connect(function(enter)
                        local text = InputBase.Text
                        if options.Validate then
                            if options.Validate(text) then
                                Control.Value = text
                                options.Callback(text)
                            else
                                InputBase.Text = Control.Value or ""
                            end
                        else
                            Control.Value = text
                            options.Callback(text)
                        end
                    end)
                end

                elseif controlType == "ColorPicker" then
                    local ColorBase = Create("Frame", {
                        Size = UDim2.new(0, 40, 0, 20),
                        Position = UDim2.new(1, -45, 0.5, -10),
                        BackgroundColor3 = options.Default or Color3.fromRGB(255, 255, 255),
                        Parent = ControlFrame
                    }, { Create("UICorner", { CornerRadius = UDim.new(0, 4) }) })

                    ColorBase.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            -- Simple color rotation as a placeholder for a full picker
                            local colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 0)}
                            local currentIdx = table.find(colors, ColorBase.BackgroundColor3) or 0
                            local nextColor = colors[(currentIdx % #colors) + 1]
                            ColorBase.BackgroundColor3 = nextColor
                            options.Callback(nextColor)
                        end
                    end)
                end

                SectionFrame.Size = UDim2.new(0.95, 0, 0, Container.UIListLayout.AbsoluteContentSize.Y + 50)
                return Control
            end

            return Section
        end

        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then Tab:Show() end
        return Tab
    end

    -- Notification System
    function Window:Notify(title, text, duration)
        local Notification = Create("Frame", {
            Name = "Notification",
            Parent = ScreenGui,
            Size = UDim2.new(0, 250, 0, 60),
            Position = UDim2.new(1, 10, 1, -70),
            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
            Create("UIStroke", { Color = Library.Themes.Default.Accent.Keypoints[1].Value, Thickness = 1 }),
            Create("TextLabel", {
                Text = title,
                Size = UDim2.new(1, -10, 0, 25),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                TextColor3 = Library.Themes.Default.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Create("TextLabel", {
                Text = text,
                Size = UDim2.new(1, -10, 1, -30),
                Position = UDim2.new(0, 10, 0, 25),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                TextColor3 = Library.Themes.Default.DarkText,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true
            })
        })

        Tween(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(1, -260, 1, -70) })
        task.delay(duration or 3, function()
            Tween(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Position = UDim2.new(1, 10, 1, -70) })
            task.delay(0.5, function() Notification:Destroy() end)
        end)
    end

    -- Dragging Logic
    local dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not resizing then
            Window.Dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Window.Dragging = false
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and Window.Dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return Window
end

return Library
