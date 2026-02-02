local UILibrary = {}
UILibrary.__index = UILibrary

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local function create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function tween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function UILibrary:CreateWindow(config)
    local window = {}
    window.Tabs = {}
    window.ActiveTab = nil
    window.AccentColor = config.AccentColor or Color3.fromRGB(255, 140, 50)
    
    local screenGui = create("ScreenGui", {
        Name = "UILibrary",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    local mainFrame = create("Frame", {
        Name = "MainFrame",
        Parent = screenGui,
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -350, 0.5, -250),
        Size = UDim2.new(0, 700, 0, 500)
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = mainFrame
    })
    
    local topBar = create("Frame", {
        Name = "TopBar",
        Parent = mainFrame,
        BackgroundColor3 = Color3.fromRGB(15, 15, 20),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = topBar
    })
    
    local titleLabel = create("TextLabel", {
        Name = "Title",
        Parent = topBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = config.Title or "UI Library",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local tabContainer = create("Frame", {
        Name = "TabContainer",
        Parent = mainFrame,
        BackgroundColor3 = Color3.fromRGB(15, 15, 20),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 160, 1, -40)
    })
    
    local tabList = create("Frame", {
        Name = "TabList",
        Parent = tabContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -10)
    })
    
    create("UIListLayout", {
        Parent = tabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })
    
    local contentContainer = create("Frame", {
        Name = "ContentContainer",
        Parent = mainFrame,
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 160, 0, 40),
        Size = UDim2.new(1, -160, 1, -40)
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = contentContainer
    })
    
    local dragToggle = nil
    local dragSpeed = 0.25
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        tween(mainFrame, {Position = position}, dragSpeed)
    end
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
            updateInput(input)
        end
    end)
    
    function window:CreateTab(config)
        local tab = {}
        tab.SubPages = {}
        tab.ActiveSubPage = nil
        tab.Name = config.Name or "Tab"
        tab.Icon = config.Icon or ""
        
        local tabButton = create("Frame", {
            Name = "TabButton",
            Parent = tabList,
            BackgroundColor3 = Color3.fromRGB(20, 20, 25),
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 40),
            LayoutOrder = #window.Tabs + 1
        })
        
        create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = tabButton
        })
        
        local tabButton_btn = create("TextButton", {
            Name = "Button",
            Parent = tabButton,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = "",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14
        })
        
        local iconLabel = create("ImageLabel", {
            Name = "Icon",
            Parent = tabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0.5, -10),
            Size = UDim2.new(0, 20, 0, 20),
            Image = tab.Icon,
            ImageColor3 = Color3.fromRGB(150, 150, 150)
        })
        
        local tabLabel = create("TextLabel", {
            Name = "Label",
            Parent = tabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 40, 0, 0),
            Size = UDim2.new(1, -40, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = tab.Name,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local accentLine = create("Frame", {
            Name = "AccentLine",
            Parent = tabButton,
            BackgroundColor3 = window.AccentColor,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(0, 0, 0, 2),
            Visible = false
        })
        
        create("UIGradient", {
            Parent = accentLine,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, window.AccentColor),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(
                    math.clamp(window.AccentColor.R * 255 * 0.7, 0, 255),
                    math.clamp(window.AccentColor.G * 255 * 0.7, 0, 255),
                    math.clamp(window.AccentColor.B * 255 * 0.7, 0, 255)
                ))
            }),
            Rotation = 90
        })
        
        local tabContent = create("Frame", {
            Name = "TabContent_" .. tab.Name,
            Parent = contentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        })
        
        local subPageContainer = create("Frame", {
            Name = "SubPageContainer",
            Parent = tabContent,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 10),
            Size = UDim2.new(1, -20, 0, 35)
        })
        
        create("UIListLayout", {
            Parent = subPageContainer,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })
        
        local contentFrame = create("Frame", {
            Name = "ContentFrame",
            Parent = tabContent,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 55),
            Size = UDim2.new(1, -20, 1, -65)
        })
        
        local function switchToTab()
            if window.ActiveTab and window.ActiveTab ~= tab then
                local oldTabButton = window.ActiveTab.TabButton
                local oldAccentLine = oldTabButton:FindFirstChild("AccentLine")
                local oldIcon = oldTabButton:FindFirstChild("Icon")
                local oldLabel = oldTabButton:FindFirstChild("Label")
                
                tween(oldAccentLine, {Size = UDim2.new(0, 0, 0, 2)}, 0.3)
                task.wait(0.1)
                oldAccentLine.Visible = false
                
                tween(oldIcon, {ImageColor3 = Color3.fromRGB(150, 150, 150)}, 0.2)
                tween(oldLabel, {TextColor3 = Color3.fromRGB(150, 150, 150)}, 0.2)
                
                window.ActiveTab.Content.Visible = false
            end
            
            window.ActiveTab = tab
            
            accentLine.Visible = true
            tween(accentLine, {Size = UDim2.new(1, 0, 0, 2)}, 0.3)
            tween(iconLabel, {ImageColor3 = window.AccentColor}, 0.2)
            tween(tabLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
            
            tabContent.Visible = true
            
            if tab.ActiveSubPage then
                tab.ActiveSubPage.Content.Visible = true
            end
        end
        
        tabButton_btn.MouseButton1Click:Connect(switchToTab)
        
        tab.TabButton = tabButton
        tab.Content = tabContent
        tab.SubPageContainer = subPageContainer
        tab.ContentFrame = contentFrame
        tab.SwitchToTab = switchToTab
        
        function tab:CreateSubPage(config)
            local subPage = {}
            subPage.Name = config.Name or "SubPage"
            subPage.Icon = config.Icon or ""
            
            local subPageButton = create("TextButton", {
                Name = "SubPageButton",
                Parent = subPageContainer,
                BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                BorderSizePixel = 0,
                Size = UDim2.new(0, 100, 0, 30),
                Font = Enum.Font.Gotham,
                Text = "",
                TextColor3 = Color3.fromRGB(150, 150, 150),
                TextSize = 12,
                AutoButtonColor = false,
                LayoutOrder = #tab.SubPages + 1
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(0, 5),
                Parent = subPageButton
            })
            
            local subIcon = create("ImageLabel", {
                Name = "Icon",
                Parent = subPageButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Image = subPage.Icon,
                ImageColor3 = Color3.fromRGB(150, 150, 150)
            })
            
            local subLabel = create("TextLabel", {
                Name = "Label",
                Parent = subPageButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 30, 0, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = subPage.Name,
                TextColor3 = Color3.fromRGB(150, 150, 150),
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local subPageContent = create("ScrollingFrame", {
                Name = "SubPageContent_" .. subPage.Name,
                Parent = contentFrame,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0),
                ScrollBarThickness = 4,
                ScrollBarImageColor3 = window.AccentColor,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                Visible = false
            })
            
            create("UIListLayout", {
                Parent = subPageContent,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            })
            
            local function switchToSubPage()
                if tab.ActiveSubPage and tab.ActiveSubPage ~= subPage then
                    local oldButton = tab.ActiveSubPage.Button
                    local oldIcon = oldButton:FindFirstChild("Icon")
                    local oldLabel = oldButton:FindFirstChild("Label")
                    local oldContent = tab.ActiveSubPage.Content
                    
                    tween(oldButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
                    tween(oldIcon, {ImageColor3 = Color3.fromRGB(150, 150, 150)}, 0.2)
                    tween(oldLabel, {TextColor3 = Color3.fromRGB(150, 150, 150)}, 0.2)
                    
                    tween(oldContent, {BackgroundTransparency = 1}, 0.15)
                    task.wait(0.15)
                    oldContent.Visible = false
                end
                
                tab.ActiveSubPage = subPage
                
                subPageContent.Visible = true
                subPageContent.BackgroundTransparency = 1
                tween(subPageContent, {BackgroundTransparency = 1}, 0.15)
                
                tween(subPageButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, 0.2)
                tween(subIcon, {ImageColor3 = window.AccentColor}, 0.2)
                tween(subLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
            end
            
            subPageButton.MouseButton1Click:Connect(switchToSubPage)
            
            subPage.Button = subPageButton
            subPage.Content = subPageContent
            subPage.SwitchToSubPage = switchToSubPage
            
            function subPage:CreateSection(sectionName)
                local section = {}
                
                local sectionFrame = create("Frame", {
                    Name = "Section",
                    Parent = subPageContent,
                    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, -10, 0, 40),
                    LayoutOrder = subPageContent:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = sectionFrame
                })
                
                local sectionLabel = create("TextLabel", {
                    Name = "SectionLabel",
                    Parent = sectionFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 8),
                    Size = UDim2.new(1, -24, 0, 20),
                    Font = Enum.Font.GothamBold,
                    Text = sectionName or "Section",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local sectionContent = create("Frame", {
                    Name = "SectionContent",
                    Parent = sectionFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 32),
                    Size = UDim2.new(1, -16, 1, -36)
                })
                
                create("UIListLayout", {
                    Parent = sectionContent,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 6)
                })
                
                local function updateSectionSize()
                    local contentSize = sectionContent:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y
                    sectionFrame.Size = UDim2.new(1, -10, 0, contentSize + 40)
                    
                    local totalSize = 0
                    for _, child in ipairs(subPageContent:GetChildren()) do
                        if child:IsA("Frame") then
                            totalSize = totalSize + child.AbsoluteSize.Y + 8
                        end
                    end
                    subPageContent.CanvasSize = UDim2.new(0, 0, 0, totalSize + 10)
                end
                
                sectionContent:FindFirstChildOfClass("UIListLayout"):GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSize)
                
                section.Frame = sectionFrame
                section.Content = sectionContent
                section.UpdateSize = updateSectionSize
                
                function section:AddButton(config)
                    local buttonFrame = create("Frame", {
                        Name = "Button",
                        Parent = sectionContent,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 32)
                    })
                    
                    create("UICorner", {
                        CornerRadius = UDim.new(0, 5),
                        Parent = buttonFrame
                    })
                    
                    local button = create("TextButton", {
                        Name = "Btn",
                        Parent = buttonFrame,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Font = Enum.Font.GothamMedium,
                        Text = config.Name or "Button",
                        TextColor3 = Color3.fromRGB(200, 200, 200),
                        TextSize = 12
                    })
                    
                    button.MouseButton1Click:Connect(function()
                        tween(buttonFrame, {BackgroundColor3 = window.AccentColor}, 0.1)
                        task.wait(0.1)
                        tween(buttonFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.1)
                        
                        if config.Callback then
                            config.Callback()
                        end
                    end)
                    
                    updateSectionSize()
                end
                
                function section:AddToggle(config)
                    local toggleState = config.Default or false
                    
                    local toggleFrame = create("Frame", {
                        Name = "Toggle",
                        Parent = sectionContent,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 32)
                    })
                    
                    create("UICorner", {
                        CornerRadius = UDim.new(0, 5),
                        Parent = toggleFrame
                    })
                    
                    local toggleLabel = create("TextLabel", {
                        Name = "Label",
                        Parent = toggleFrame,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(1, -50, 1, 0),
                        Font = Enum.Font.GothamMedium,
                        Text = config.Name or "Toggle",
                        TextColor3 = Color3.fromRGB(200, 200, 200),
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                    
                    local toggleButton = create("TextButton", {
                        Name = "ToggleButton",
                        Parent = toggleFrame,
                        BackgroundColor3 = toggleState and window.AccentColor or Color3.fromRGB(45, 45, 50),
                        BorderSizePixel = 0,
                        Position = UDim2.new(1, -38, 0.5, -10),
                        Size = UDim2.new(0, 32, 0, 18),
                        Text = "",
                        AutoButtonColor = false
                    })
                    
                    create("UICorner", {
                        CornerRadius = UDim.new(1, 0),
                        Parent = toggleButton
                    })
                    
                    local toggleCircle = create("Frame", {
                        Name = "Circle",
                        Parent = toggleButton,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel = 0,
                        Position = toggleState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
                        Size = UDim2.new(0, 14, 0, 14)
                    })
                    
                    create("UICorner", {
                        CornerRadius = UDim.new(1, 0),
                        Parent = toggleCircle
                    })
                    
                    toggleButton.MouseButton1Click:Connect(function()
                        toggleState = not toggleState
                        
                        if toggleState then
                            tween(toggleButton, {BackgroundColor3 = window.AccentColor}, 0.2)
                            tween(toggleCircle, {Position = UDim2.new(1, -16, 0.5, -7)}, 0.2)
                        else
                            tween(toggleButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2)
                            tween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -7)}, 0.2)
                        end
                        
                        if config.Callback then
                            config.Callback(toggleState)
                        end
                    end)
                    
                    updateSectionSize()
                    
                    return {
                        SetValue = function(self, value)
                            toggleState = value
                            if toggleState then
                                tween(toggleButton, {BackgroundColor3 = window.AccentColor}, 0.2)
                                tween(toggleCircle, {Position = UDim2.new(1, -16, 0.5, -7)}, 0.2)
                            else
                                tween(toggleButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2)
                                tween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -7)}, 0.2)
                            end
                        end
                    }
                end
                
                function section:AddSlider(config)
                    local sliderValue = config.Default or config.Min or 0
                    
                    local sliderFrame = create("Frame", {
                        Name = "Slider",
                        Parent = sectionContent,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 48)
                    })
                    
                    create("UICorner", {
                        CornerRadius = UDim.new(0, 5),
                        Parent = sliderFrame
                    })
                    
                    local sliderLabel = create("TextLabel", {
                        Name = "Label",
                        Parent = sliderFrame,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 6),
                        Size = UDim2.new(1, -80, 0, 16),
                        Font = Enum.Font.GothamMedium,
                        Text = config.Name or "Slider",
                        TextColor3 = Color3.fromRGB(200, 200, 200),
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                    
                    local valueLabel = create("TextLabel", {
                        Name = "Value",
                        Parent = sliderFrame,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -70, 0, 6),
                        Size = UDim2.new(0, 60, 0, 16),
                        Font = Enum.Font.GothamBold,
                        Text = tostring(sliderValue),
                        TextColor3 = window.AccentColor,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Right
                    })
                    
                    local sliderBack = create("Frame", {
                        Name = "SliderBack",
                        Parent = sliderFrame,
                        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 10, 1, -18),
                        Size = UDim2.new(1, -20, 0, 6)
                    })
                    
                    create("UICorner", {
                        CornerRadius = UDim.new(1, 0),
                        Parent = sliderBack
                    })
                    
                    local sliderFill = create("Frame", {
                        Name = "Fill",
                        Parent = sliderBack,
                        BackgroundColor3 = window.AccentColor,
                        BorderSizePixel = 0,
                        Size = UDim2.new(0, 0, 1, 0)
                    })
                    
                    create("UICorner", {
                        CornerRadius = UDim.new(1, 0),
                        Parent = sliderFill
                    })
                    
                    local dragging = false
                    
                    local function updateSlider(input)
                        local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
                        sliderValue = math.floor(config.Min + (config.Max - config.Min) * pos)
                        
                        valueLabel.Text = tostring(sliderValue)
                        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                        
                        if config.Callback then
                            config.Callback(sliderValue)
                        end
                    end
                    
                    sliderBack.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            updateSlider(input)
                        end
                    end)
                    
                    sliderBack.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            updateSlider(input)
                        end
                    end)
                    
                    local initialPos = (sliderValue - config.Min) / (config.Max - config.Min)
                    sliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
                    
                    updateSectionSize()
                    
                    return {
                        SetValue = function(self, value)
                            sliderValue = math.clamp(value, config.Min, config.Max)
                            valueLabel.Text = tostring(sliderValue)
                            local pos = (sliderValue - config.Min) / (config.Max - config.Min)
                            tween(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.2)
                        end
                    }
                end
                
                function section:AddTextbox(config)
                    local textboxFrame = create("Frame", {
                        Name = "Textbox",
                        Parent = sectionContent,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 32)
                    })
                    
                    create("UICorner", {
                        CornerRadius = UDim.new(0, 5),
                        Parent = textboxFrame
                    })
                    
                    local textbox = create("TextBox", {
                        Name = "Input",
                        Parent = textboxFrame,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(1, -20, 1, 0),
                        Font = Enum.Font.GothamMedium,
                        PlaceholderText = config.Placeholder or "Enter text...",
                        PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
                        Text = config.Default or "",
                        TextColor3 = Color3.fromRGB(200, 200, 200),
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ClearTextOnFocus = false
                    })
                    
                    textbox.FocusLost:Connect(function()
                        if config.Callback then
                            config.Callback(textbox.Text)
                        end
                    end)
                    
                    updateSectionSize()
                end
                
                function section:AddDropdown(config)
                    local dropdownOpen = false
                    local selectedValue = config.Default or config.Options[1] or ""
                    
                    local dropdownFrame = create("Frame", {
                        Name = "Dropdown",
                        Parent = sectionContent,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 32)
                    })
                    
                    create("UICorner", {
                        CornerRadius = UDim.new(0, 5),
                        Parent = dropdownFrame
                    })
                    
                    local dropdownButton = create("TextButton", {
                        Name = "Button",
                        Parent = dropdownFrame,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 32),
                        Font = Enum.Font.GothamMedium,
                        Text = "",
                        TextColor3 = Color3.fromRGB(200, 200, 200),
                        TextSize = 12
                    })
                    
                    local dropdownLabel = create("TextLabel", {
                        Name = "Label",
                        Parent = dropdownFrame,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(1, -30, 0, 32),
                        Font = Enum.Font.GothamMedium,
                        Text = selectedValue,
                        TextColor3 = Color3.fromRGB(200, 200, 200),
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                    
                    local dropdownIcon = create("TextLabel", {
                        Name = "Icon",
                        Parent = dropdownFrame,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -24, 0, 0),
                        Size = UDim2.new(0, 20, 0, 32),
                        Font = Enum.Font.GothamBold,
                        Text = "v",
                        TextColor3 = Color3.fromRGB(150, 150, 150),
                        TextSize = 14
                    })
                    
                    local optionsList = create("Frame", {
                        Name = "OptionsList",
                        Parent = dropdownFrame,
                        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 0, 34),
                        Size = UDim2.new(1, 0, 0, 0),
                        ClipsDescendants = true,
                        Visible = false
                    })
                    
                    create("UICorner", {
                        CornerRadius = UDim.new(0, 5),
                        Parent = optionsList
                    })
                    
                    create("UIListLayout", {
                        Parent = optionsList,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 2)
                    })
                    
                    for i, option in ipairs(config.Options) do
                        local optionButton = create("TextButton", {
                            Name = "Option_" .. option,
                            Parent = optionsList,
                            BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 0, 28),
                            Font = Enum.Font.Gotham,
                            Text = option,
                            TextColor3 = Color3.fromRGB(180, 180, 180),
                            TextSize = 11,
                            AutoButtonColor = false
                        })
                        
                        create("UICorner", {
                            CornerRadius = UDim.new(0, 4),
                            Parent = optionButton
                        })
                        
                        optionButton.MouseEnter:Connect(function()
                            tween(optionButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.1)
                        end)
                        
                        optionButton.MouseLeave:Connect(function()
                            tween(optionButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.1)
                        end)
                        
                        optionButton.MouseButton1Click:Connect(function()
                            selectedValue = option
                            dropdownLabel.Text = option
                            
                            dropdownOpen = false
                            tween(optionsList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                            task.wait(0.2)
                            optionsList.Visible = false
                            tween(dropdownIcon, {Rotation = 0}, 0.2)
                            
                            if config.Callback then
                                config.Callback(option)
                            end
                        end)
                    end
                    
                    dropdownButton.MouseButton1Click:Connect(function()
                        dropdownOpen = not dropdownOpen
                        
                        if dropdownOpen then
                            optionsList.Visible = true
                            local optionsHeight = #config.Options * 30
                            tween(optionsList, {Size = UDim2.new(1, 0, 0, optionsHeight)}, 0.2)
                            tween(dropdownIcon, {Rotation = 180}, 0.2)
                        else
                            tween(optionsList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                            tween(dropdownIcon, {Rotation = 0}, 0.2)
                            task.wait(0.2)
                            optionsList.Visible = false
                        end
                    end)
                    
                    updateSectionSize()
                end
                
                return section
            end
            
            table.insert(tab.SubPages, subPage)
            
            if #tab.SubPages == 1 then
                switchToSubPage()
            end
            
            return subPage
        end
        
        table.insert(window.Tabs, tab)
        
        if #window.Tabs == 1 then
            switchToTab()
        end
        
        return tab
    end
    
    return window
end

return UILibrary
