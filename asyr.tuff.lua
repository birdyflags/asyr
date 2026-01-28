local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local Theme = {
    DarkBgTop = Color3.fromRGB(15, 15, 18),
    DarkBgBot = Color3.fromRGB(8, 8, 10),
    AccentStart = Color3.fromRGB(255, 165, 0),
    AccentEnd = Color3.fromRGB(255, 69, 0),
    TextPrimary = Color3.fromRGB(240, 240, 245),
    TextSecondary = Color3.fromRGB(160, 160, 170),
    SidebarBg = Color3.fromRGB(10, 10, 13),
    MutedGray = Color3.fromRGB(90, 90, 100),
}

local PremiumUI = {}

function PremiumUI:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Premium UI"

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PremiumUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 850, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -425, 1.2, 0)
    mainFrame.BackgroundColor3 = Theme.DarkBgBot
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame

    local bgGrad = Instance.new("UIGradient")
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.DarkBgTop),
        ColorSequenceKeypoint.new(1, Theme.DarkBgBot)
    })
    bgGrad.Rotation = 90
    bgGrad.Parent = mainFrame

    local shadowStroke = Instance.new("UIStroke")
    shadowStroke.Thickness = 12
    shadowStroke.Color = Color3.new(0, 0, 0)
    shadowStroke.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.3, 0.6),
        NumberSequenceKeypoint.new(0.7, 0.3),
        NumberSequenceKeypoint.new(1, 0.1)
    })
    shadowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    shadowStroke.Parent = mainFrame

    local topHighlight = Instance.new("UIStroke")
    topHighlight.Thickness = 1
    topHighlight.Color = Color3.fromRGB(50, 50, 60)
    topHighlight.Transparency = NumberSequence.new(0.5)
    topHighlight.Parent = mainFrame

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 212, 1, 0)
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    sidebar.BackgroundColor3 = Theme.SidebarBg
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 12)
    sidebarCorner.Parent = sidebar

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 8)
    sidebarLayout.Parent = sidebar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 50)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.TextPrimary
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.LayoutOrder = 1
    titleLabel.Parent = sidebar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -38, 0, 16)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.LayoutOrder = 1
    closeBtn.Parent = sidebar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0.5, 0)
    closeCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, -212, 0, 1)
    separator.Position = UDim2.new(0, 212, 0.5, -0.5)
    separator.BackgroundColor3 = Theme.MutedGray
    separator.BackgroundTransparency = 0.6
    separator.BorderSizePixel = 0
    separator.Parent = mainFrame

    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(1, -213, 1, 0)
    mainPanel.Position = UDim2.new(0, 213, 0, 0)
    mainPanel.BackgroundTransparency = 1
    mainPanel.Parent = mainFrame

    local tabsContainer = Instance.new("Frame")
    tabsContainer.Name = "TabsContainer"
    tabsContainer.Size = UDim2.new(1, 0, 1, 0)
    tabsContainer.Position = UDim2.new(0, 10, 0, 10)
    tabsContainer.BackgroundTransparency = 1
    tabsContainer.Parent = mainPanel

    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.Padding = UDim.new(0, 0)
    tabsLayout.Parent = tabsContainer

    local window = {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        Sidebar = sidebar,
        MainPanel = mainPanel,
        TabsContainer = tabsContainer,
        CurrentTab = nil,
        Tabs = {},
        Title = titleLabel
    }

    local dragInfo = {}
    local dragging = false
    local dragStart = nil
    local startPos = nil

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            dragInfo.Connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if dragInfo.Connection then dragInfo.Connection:Disconnect() end
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local openInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(mainFrame, openInfo, {Position = UDim2.new(0.5, -425, 0.5, -250)}):Play()

    function window:AddTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Size = UDim2.new(1, -20, 0, 42)
        tabButton.Position = UDim2.new(0, 10, 0, 0)
        tabButton.BackgroundColor3 = Color3.new(1,1,1)
        tabButton.BackgroundTransparency = 1
        tabButton.Text = name
        tabButton.TextColor3 = Theme.TextSecondary
        tabButton.TextScaled = true
        tabButton.Font = Enum.Font.GothamMedium
        tabButton.BorderSizePixel = 0
        tabButton.LayoutOrder = #window.Tabs + 2
        tabButton.Parent = sidebar

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton

        local activeBar = Instance.new("Frame")
        activeBar.Size = UDim2.new(0, 4, 0.6, 0)
        activeBar.Position = UDim2.new(1, -8, 0.2, 0)
        activeBar.BackgroundColor3 = Theme.AccentStart
        activeBar.BorderSizePixel = 0
        activeBar.LayoutOrder = 100
        activeBar.Parent = tabButton
        activeBar.Visible = false

        local barGrad = Instance.new("UIGradient")
        barGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.AccentStart),
            ColorSequenceKeypoint.new(1, Theme.AccentEnd)
        })
        barGrad.Rotation = 90
        barGrad.Parent = activeBar

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, -20, 1, -20)
        tabContent.Position = UDim2.new(0, 10, 0, 10)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Theme.MutedGray
        tabContent.ScrollBarImageTransparency = 0.5
        tabContent.Visible = false
        tabContent.ScrollBarImageTransparency = 0.8
        tabContent.Parent = tabsContainer

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 10)
        contentPadding.PaddingBottom = UDim.new(0, 10)
        contentPadding.PaddingLeft = UDim.new(0, 10)
        contentPadding.PaddingRight = UDim.new(0, 10)
        contentPadding.Parent = tabContent

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 12)
        contentLayout.Parent = tabContent

        local tab = {
            Button = tabButton,
            Content = tabContent,
            ActiveBar = activeBar,
            Sections = {}
        }

        table.insert(window.Tabs, tab)

        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        tabButton.MouseEnter:Connect(function()
            if window.CurrentTab ~= tab then
                TweenService:Create(tabButton, tweenInfo, {TextColor3 = Theme.TextPrimary}):Play()
            end
        end)

        tabButton.MouseLeave:Connect(function()
            if window.CurrentTab ~= tab then
                TweenService:Create(tabButton, tweenInfo, {TextColor3 = Theme.TextSecondary}):Play()
            end
        end)

        tabButton.MouseButton1Click:Connect(function()
            if window.CurrentTab then
                window.CurrentTab.Content.Visible = false
                window.CurrentTab.ActiveBar.Visible = false
                TweenService:Create(window.CurrentTab.Button, tweenInfo, {TextColor3 = Theme.TextSecondary}):Play()
            end
            window.CurrentTab = tab
            tabContent.Visible = true
            activeBar.Visible = true
            TweenService:Create(tabButton, tweenInfo, {TextColor3 = Theme.TextPrimary}):Play()
        end)

        if #window.Tabs == 1 then
            window.CurrentTab = tab
            tabContent.Visible = true
            activeBar.Visible = true
            tabButton.TextColor3 = Theme.TextPrimary
        end

        function tab:AddSection(name)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = name .. "Section"
            sectionFrame.Size = UDim2.new(1, 0, 0, 60)
            sectionFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Parent = tabContent

            local secCorner = Instance.new("UICorner")
            secCorner.CornerRadius = UDim.new(0, 10)
            secCorner.Parent = sectionFrame

            local secStroke = Instance.new("UIStroke")
            secStroke.Thickness = 1
            secStroke.Color = Theme.MutedGray
            secStroke.Transparency = 0.6
            secStroke.Parent = sectionFrame

            local secTitle = Instance.new("TextLabel")
            secTitle.Name = "Title"
            secTitle.Size = UDim2.new(1, 0, 0, 32)
            secTitle.Position = UDim2.new(0, 15, 0, 8)
            secTitle.BackgroundTransparency = 1
            secTitle.Text = name
            secTitle.TextColor3 = Theme.TextPrimary
            secTitle.TextXAlignment = Enum.TextXAlignment.Left
            secTitle.Font = Enum.Font.GothamBold
            secTitle.TextSize = 14
            secTitle.Parent = sectionFrame

            local secContent = Instance.new("Frame")
            secContent.Name = "Content"
            secContent.Size = UDim2.new(1, -30, 1, -40)
            secContent.Position = UDim2.new(0, 15, 0, 40)
            secContent.BackgroundTransparency = 1
            secContent.Parent = sectionFrame

            local contentList = Instance.new("UIListLayout")
            contentList.Padding = UDim.new(0, 6)
            contentList.Parent = secContent

            local sectionObj = {
                Frame = sectionFrame,
                Content = secContent,
                Components = {}
            }

            function sectionObj:AddToggle(config)
                config = config or {}
                local name = config.Name or "Toggle"
                local default = config.Default or false
                local callback = config.Callback

                local togFrame = Instance.new("Frame")
                togFrame.Size = UDim2.new(1, 0, 0, 32)
                togFrame.BackgroundTransparency = 1
                togFrame.Parent = secContent

                local togLabel = Instance.new("TextLabel")
                togLabel.Size = UDim2.new(1, -70, 1, 0)
                togLabel.Position = UDim2.new(0, 10, 0, 0)
                togLabel.BackgroundTransparency = 1
                togLabel.Text = name
                togLabel.TextColor3 = Theme.TextSecondary
                togLabel.TextXAlignment = Enum.TextXAlignment.Left
                togLabel.Font = Enum.Font.GothamMedium
                togLabel.TextSize = 13
                togLabel.Parent = togFrame

                local pillFrame = Instance.new("Frame")
                pillFrame.Size = UDim2.new(0, 50, 0, 24)
                pillFrame.Position = UDim2.new(1, -60, 0.5, -12)
                pillFrame.BackgroundColor3 = Theme.MutedGray
                pillFrame.BorderSizePixel = 0
                pillFrame.Parent = togFrame

                local pillCorner = Instance.new("UICorner")
                pillCorner.CornerRadius = UDim.new(0, 12)
                pillCorner.Parent = pillFrame

                local pillStroke = Instance.new("UIStroke")
                pillStroke.Thickness = 1.5
                pillStroke.Color = Theme.MutedGray
                pillStroke.Parent = pillFrame

                local handle = Instance.new("Frame")
                handle.Size = UDim2.new(0, 20, 0, 20)
                handle.Position = UDim2.new(0, 2, 0, 2)
                handle.BackgroundColor3 = Theme.DarkBgTop
                handle.BorderSizePixel = 0
                handle.Parent = pillFrame

                local handleCorner = Instance.new("UICorner")
                handleCorner.CornerRadius = UDim.new(0.5, 0)
                handleCorner.Parent = handle

                local value = default
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

                local toggleObj = {
                    Label = togLabel,
                    Pill = pillFrame,
                    Handle = handle,
                    Value = value,
                    Set = function(newValue)
                        value = newValue
                        TweenService:Create(handle, tweenInfo, {Position = UDim2.new(0, newValue and 28 or 2, 0, 2)}):Play()
                        TweenService:Create(pillStroke, tweenInfo, {Color = newValue and Theme.AccentStart or Theme.MutedGray}):Play()
                        togLabel.TextColor3 = newValue and Theme.TextPrimary or Theme.TextSecondary
                        handle.BackgroundColor3 = newValue and Theme.AccentStart or Theme.DarkBgTop
                        if callback then callback(value) end
                    end
                }

                pillFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        toggleObj:Set(not value)
                    end
                end)

                if default then toggleObj:Set(true) end
                table.insert(sectionObj.Components, toggleObj)
                return toggleObj
            end

            function sectionObj:AddButton(config)
                config = config or {}
                local name = config.Name or "Button"
                local callback = config.Callback

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 38)
                btn.BackgroundColor3 = Theme.MutedGray
                btn.BorderSizePixel = 0
                btn.Text = name
                btn.TextColor3 = Theme.TextPrimary
                btn.Font = Enum.Font.GothamMedium
                btn.TextSize = 14
                btn.Parent = secContent

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 10)
                btnCorner.Parent = btn

                local btnStroke = Instance.new("UIStroke")
                btnStroke.Thickness = 1.5
                btnStroke.Color = Theme.MutedGray
                btnStroke.Parent = btn

                local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

                btn.MouseButton1Click:Connect(callback)

                btn.MouseEnter:Connect(function()
                    TweenService:Create(btn, tweenInfo, {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    TweenService:Create(btnStroke, tweenInfo, {Color = Theme.AccentStart}):Play()
                end)

                btn.MouseLeave:Connect(function()
                    TweenService:Create(btn, tweenInfo, {Size = UDim2.new(1, 0, 0, 38)}):Play()
                    TweenService:Create(btnStroke, tweenInfo, {Color = Theme.MutedGray}):Play()
                end)

                table.insert(sectionObj.Components, btn)
                return btn
            end

            function sectionObj:AddSlider(config)
                config = config or {}
                local name = config.Name or "Slider"
                local min = config.Min or 0
                local max = config.Max or 100
                local default = config.Default or min
                local callback = config.Callback

                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, 0, 0, 50)
                sliderFrame.BackgroundTransparency = 1
                sliderFrame.Parent = secContent

                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Size = UDim2.new(1, -80, 0, 22)
                sliderLabel.Position = UDim2.new(0, 10, 0, 2)
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Text = name .. ": " .. default
                sliderLabel.TextColor3 = Theme.TextSecondary
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.Font = Enum.Font.GothamMedium
                sliderLabel.TextSize = 13
                sliderLabel.Parent = sliderFrame

                local track = Instance.new("Frame")
                track.Size = UDim2.new(1, -20, 0, 8)
                track.Position = UDim2.new(0, 10, 0, 32)
                track.BackgroundColor3 = Theme.MutedGray
                track.BorderSizePixel = 0
                track.Parent = sliderFrame

                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(1, 0)
                trackCorner.Parent = track

                local fill = Instance.new("Frame")
                local percent = (default - min) / (max - min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                fill.BackgroundColor3 = Theme.AccentStart
                fill.BorderSizePixel = 0
                fill.Parent = track

                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(1, 0)
                fillCorner.Parent = fill

                local fillGrad = Instance.new("UIGradient")
                fillGrad.Rotation = 90
                fillGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Theme.AccentStart),
                    ColorSequenceKeypoint.new(1, Theme.AccentEnd)
                })
                fillGrad.Parent = fill

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 18, 0, 18)
                knob.Position = UDim2.new(percent, -9, -0.5, -9)
                knob.BackgroundColor3 = Theme.TextPrimary
                knob.BorderSizePixel = 0
                knob.Parent = track

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(0.5, 0)
                knobCorner.Parent = knob

                local value = default
                local sliderDragging = false
                local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quart)

                local sliderObj = {
                    Label = sliderLabel,
                    Fill = fill,
                    Knob = knob,
                    Value = value,
                    Set = function(newVal)
                        newVal = math.clamp(newVal, min, max)
                        value = newVal
                        local p = (value - min) / (max - min)
                        TweenService:Create(fill, tweenInfo, {Size = UDim2.new(p, 0, 1, 0)}):Play()
                        TweenService:Create(knob, tweenInfo, {Position = UDim2.new(p, -9, -0.5, -9)}):Play()
                        sliderLabel.Text = name .. ": " .. math.floor(value * 100) / 100
                        if callback then callback(value) end
                    end
                }

                knob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDragging = true
                    end
                end)

                knob.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local absPos = track.AbsolutePosition.X
                        local absSize = track.AbsoluteSize.X
                        local relPos = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
                        sliderObj:Set(min + (max - min) * relPos)
                    end
                end)

                sliderObj:Set(default)
                table.insert(sectionObj.Components, sliderObj)
                return sliderObj
            end

            function sectionObj:AddDropdown(config)
                config = config or {}
                local name = config.Name or "Dropdown"
                local items = config.Items or {}
                local default = config.Default or items[1] or ""
                local callback = config.Callback

                local dropFrame = Instance.new("Frame")
                dropFrame.Size = UDim2.new(1, 0, 0, 38)
                dropFrame.BackgroundTransparency = 1
                dropFrame.Parent = secContent

                local dropLabel = Instance.new("TextLabel")
                dropLabel.Size = UDim2.new(1, -100, 1, 0)
                dropLabel.Position = UDim2.new(0, 10, 0, 0)
                dropLabel.BackgroundTransparency = 1
                dropLabel.Text = name .. ": " .. default
                dropLabel.TextColor3 = Theme.TextSecondary
                dropLabel.TextXAlignment = Enum.TextXAlignment.Left
                dropLabel.Font = Enum.Font.GothamMedium
                dropLabel.TextSize = 13
                dropLabel.Parent = dropFrame

                local dropArrow = Instance.new("TextButton")
                dropArrow.Size = UDim2.new(0, 90, 0, 28)
                dropArrow.Position = UDim2.new(1, -100, 0.5, -14)
                dropArrow.BackgroundColor3 = Theme.MutedGray
                dropArrow.BorderSizePixel = 0
                dropArrow.Text = "▼"
                dropArrow.TextColor3 = Theme.TextPrimary
                dropArrow.Font = Enum.Font.GothamBold
                dropArrow.TextSize = 14
                dropArrow.Parent = dropFrame

                local arrowCorner = Instance.new("UICorner")
                arrowCorner.CornerRadius = UDim.new(0, 6)
                arrowCorner.Parent = dropArrow

                local listFrame = Instance.new("ScrollingFrame")
                listFrame.Size = UDim2.new(1, 0, 0, 0)
                listFrame.Position = UDim2.new(0, 0, 1, 2)
                listFrame.BackgroundColor3 = Theme.SidebarBg
                listFrame.BorderSizePixel = 0
                listFrame.Visible = false
                listFrame.ScrollBarThickness = 3
                listFrame.ScrollBarImageColor3 = Theme.MutedGray
                listFrame.Parent = dropFrame

                local listCorner = Instance.new("UICorner")
                listCorner.CornerRadius = UDim.new(0, 8)
                listCorner.Parent = listFrame

                local listStroke = Instance.new("UIStroke")
                listStroke.Thickness = 1
                listStroke.Color = Theme.MutedGray
                listStroke.Parent = listFrame

                local listLayout = Instance.new("UIListLayout")
                listLayout.Padding = UDim.new(0, 3)
                listLayout.Parent = listFrame

                listFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 32)

                local currentValue = default
                local listVisible = false
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart)

                local dropObj = {
                    Label = dropLabel,
                    List = listFrame,
                    Value = currentValue,
                    Set = function(newVal)
                        currentValue = newVal
                        dropLabel.Text = name .. ": " .. newVal
                        listFrame.Visible = false
                        listVisible = false
                        TweenService:Create(dropArrow, tweenInfo, {Rotation = 0}):Play()
                        if callback then callback(newVal) end
                    end
                }

                for i, item in ipairs(items) do
                    local itemBtn = Instance.new("TextButton")
                    itemBtn.Size = UDim2.new(1, -10, 0, 28)
                    itemBtn.Position = UDim2.new(0, 5, 0, 0)
                    itemBtn.BackgroundTransparency = 1
                    itemBtn.Text = item
                    itemBtn.TextColor3 = Theme.TextSecondary
                    itemBtn.Font = Enum.Font.GothamMedium
                    itemBtn.TextSize = 13
                    itemBtn.Parent = listFrame

                    itemBtn.MouseButton1Click:Connect(function()
                        dropObj:Set(item)
                    end)

                    itemBtn.MouseEnter:Connect(function()
                        itemBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                    end)

                    itemBtn.MouseLeave:Connect(function()
                        itemBtn.BackgroundTransparency = 1
                    end)
                end

                dropArrow.MouseButton1Click:Connect(function()
                    listVisible = not listVisible
                    listFrame.Visible = listVisible
                    TweenService:Create(dropArrow, tweenInfo, {Rotation = listVisible and 180 or 0}):Play()
                    TweenService:Create(listFrame, tweenInfo, {Size = listVisible and UDim2.new(1, 0, 0, #items * 32) or UDim2.new(1, 0, 0, 0)}):Play()
                end)

                table.insert(sectionObj.Components, dropObj)
                return dropObj
            end

            function sectionObj:AddInput(config)
                config = config or {}
                local name = config.Name or "Input"
                local default = config.Default or ""
                local callback = config.Callback

                local inputFrame = Instance.new("Frame")
                inputFrame.Size = UDim2.new(1, 0, 0, 42)
                inputFrame.BackgroundTransparency = 1
                inputFrame.Parent = secContent

                local inputLabel = Instance.new("TextLabel")
                inputLabel.Size = UDim2.new(1, 0, 0, 20)
                inputLabel.Position = UDim2.new(0, 10, 0, 0)
                inputLabel.BackgroundTransparency = 1
                inputLabel.Text = name
                inputLabel.TextColor3 = Theme.TextSecondary
                inputLabel.TextXAlignment = Enum.TextXAlignment.Left
                inputLabel.Font = Enum.Font.GothamMedium
                inputLabel.TextSize = 13
                inputLabel.Parent = inputFrame

                local textBox = Instance.new("TextBox")
                textBox.Size = UDim2.new(1, -20, 0, 26)
                textBox.Position = UDim2.new(0, 10, 0, 24)
                textBox.BackgroundColor3 = Theme.DarkBgTop
                textBox.BorderSizePixel = 0
                textBox.Text = default
                textBox.TextColor3 = Theme.TextPrimary
                textBox.PlaceholderText = "Enter text..."
                textBox.PlaceholderColor3 = Theme.TextSecondary
                textBox.Font = Enum.Font.GothamMedium
                textBox.TextSize = 13
                textBox.TextXAlignment = Enum.TextXAlignment.Left
                textBox.Parent = inputFrame

                local tbCorner = Instance.new("UICorner")
                tbCorner.CornerRadius = UDim.new(0, 6)
                tbCorner.Parent = textBox

                local tbStroke = Instance.new("UIStroke")
                tbStroke.Thickness = 1.5
                tbStroke.Color = Theme.MutedGray
                tbStroke.Parent = textBox

                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart)

                textBox.Focused:Connect(function()
                    TweenService:Create(tbStroke, tweenInfo, {Color = Theme.AccentStart}):Play()
                end)

                textBox.FocusLost:Connect(function()
                    TweenService:Create(tbStroke, tweenInfo, {Color = Theme.MutedGray}):Play()
                    if callback then callback(textBox.Text) end
                end)

                table.insert(sectionObj.Components, textBox)
                return textBox
            end

            function sectionObj:AddColorPicker(config)
                config = config or {}
                local name = config.Name or "Color Picker"
                local defaultColor = config.Color or Color3.fromRGB(255, 165, 0)
                local callback = config.Callback

                local cpFrame = Instance.new("Frame")
                cpFrame.Size = UDim2.new(1, 0, 0, 38)
                cpFrame.BackgroundTransparency = 1
                cpFrame.Parent = secContent

                local cpLabel = Instance.new("TextLabel")
                cpLabel.Size = UDim2.new(1, -70, 1, 0)
                cpLabel.Position = UDim2.new(0, 10, 0, 0)
                cpLabel.BackgroundTransparency = 1
                cpLabel.Text = name
                cpLabel.TextColor3 = Theme.TextSecondary
                cpLabel.TextXAlignment = Enum.TextXAlignment.Left
                cpLabel.Font = Enum.Font.GothamMedium
                cpLabel.TextSize = 13
                cpLabel.Parent = cpFrame

                local preview = Instance.new("Frame")
                preview.Size = UDim2.new(0, 34, 0, 28)
                preview.Position = UDim2.new(1, -44, 0.5, -14)
                preview.BackgroundColor3 = defaultColor
                preview.BorderSizePixel = 0
                preview.Parent = cpFrame

                local pCorner = Instance.new("UICorner")
                pCorner.CornerRadius = UDim.new(0, 6)
                pCorner.Parent = preview

                local pStroke = Instance.new("UIStroke")
                pStroke.Thickness = 2
                pStroke.Color = Color3.new(1, 1, 1)
                pStroke.Transparency = 0.2
                pStroke.Parent = preview

                local popup = Instance.new("Frame")
                popup.Size = UDim2.new(0, 220, 0, 140)
                popup.Position = UDim2.new(0, preview.AbsolutePosition.X - 10, 0, preview.AbsolutePosition.Y + 40)
                popup.BackgroundColor3 = Theme.SidebarBg
                popup.BorderSizePixel = 0
                popup.Visible = false
                popup.Parent = screenGui

                local popCorner = Instance.new("UICorner")
                popCorner.CornerRadius = UDim.new(0, 10)
                popCorner.Parent = popup

                local popStroke = Instance.new("UIStroke")
                popStroke.Thickness = 1.5
                popStroke.Color = Theme.MutedGray
                popStroke.Parent = popup

                local popPadding = Instance.new("UIPadding")
                popPadding.PaddingTop = UDim.new(0, 15)
                popPadding.PaddingLeft = UDim.new(0, 15)
                popPadding.PaddingRight = UDim.new(0, 15)
                popPadding.PaddingBottom = UDim.new(0, 15)
                popPadding.Parent = popup

                local rLabel = Instance.new("TextLabel")
                rLabel.Size = UDim2.new(0, 15, 0, 20)
                rLabel.BackgroundTransparency = 1
                rLabel.Text = "R"
                rLabel.TextColor3 = Theme.TextPrimary
                rLabel.Font = Enum.Font.GothamBold
                rLabel.TextSize = 12
                rLabel.Parent = popup

                local rBox = Instance.new("TextBox")
                rBox.Size = UDim2.new(0.28, 0, 0, 24)
                rBox.Position = UDim2.new(0, 20, 0, 0)
                rBox.BackgroundColor3 = Theme.DarkBgTop
                rBox.BorderSizePixel = 0
                rBox.Text = tostring(math.floor(defaultColor.R * 255))
                rBox.TextColor3 = Theme.TextPrimary
                rBox.Font = Enum.Font.Gotham
                rBox.TextSize = 13
                rBox.Parent = popup

                local rcCorner = Instance.new("UICorner")
                rcCorner.CornerRadius = UDim.new(0, 5)
                rcCorner.Parent = rBox

                local gLabel = Instance.new("TextLabel")
                gLabel.Size = UDim2.new(0, 15, 0, 20)
                gLabel.Position = UDim2.new(0, 20, 0, 32)
                gLabel.BackgroundTransparency = 1
                gLabel.Text = "G"
                gLabel.TextColor3 = Theme.TextPrimary
                gLabel.Font = Enum.Font.GothamBold
                gLabel.TextSize = 12
                gLabel.Parent = popup

                local gBox = Instance.new("TextBox")
                gBox.Size = UDim2.new(0.28, 0, 0, 24)
                gBox.Position = UDim2.new(0, 20, 0, 28)
                gBox.BackgroundColor3 = Theme.DarkBgTop
                gBox.BorderSizePixel = 0
                gBox.Text = tostring(math.floor(defaultColor.G * 255))
                gBox.TextColor3 = Theme.TextPrimary
                gBox.Font = Enum.Font.Gotham
                gBox.TextSize = 13
                gBox.Parent = popup

                local gcCorner = Instance.new("UICorner")
                gcCorner.CornerRadius = UDim.new(0, 5)
                gcCorner.Parent = gBox

                local bLabel = Instance.new("TextLabel")
                bLabel.Size = UDim2.new(0, 15, 0, 20)
                bLabel.Position = UDim2.new(0, 20, 0, 64)
                bLabel.BackgroundTransparency = 1
                bLabel.Text = "B"
                bLabel.TextColor3 = Theme.TextPrimary
                bLabel.Font = Enum.Font.GothamBold
                bLabel.TextSize = 12
                bLabel.Parent = popup

                local bBox = Instance.new("TextBox")
                bBox.Size = UDim2.new(0.28, 0, 0, 24)
                bBox.Position = UDim2.new(0, 20, 0, 60)
                bBox.BackgroundColor3 = Theme.DarkBgTop
                bBox.BorderSizePixel = 0
                bBox.Text = tostring(math.floor(defaultColor.B * 255))
                bBox.TextColor3 = Theme.TextPrimary
                bBox.Font = Enum.Font.Gotham
                bBox.TextSize = 13
                bBox.Parent = popup

                local bcCorner = Instance.new("UICorner")
                bcCorner.CornerRadius = UDim.new(0, 5)
                bcCorner.Parent = bBox

                local function updatePreview()
                    local r = math.clamp(tonumber(rBox.Text) or 0, 0, 255)
                    local g = math.clamp(tonumber(gBox.Text) or 0, 0, 255)
                    local b = math.clamp(tonumber(bBox.Text) or 0, 0, 255)
                    local color = Color3.fromRGB(r, g, b)
                    preview.BackgroundColor3 = color
                    if callback then callback(color) end
                    rBox.Text = tostring(r)
                    gBox.Text = tostring(g)
                    bBox.Text = tostring(b)
                end

                rBox.FocusLost:Connect(updatePreview)
                gBox.FocusLost:Connect(updatePreview)
                bBox.FocusLost:Connect(updatePreview)

                preview.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        popup.Visible = not popup.Visible
                    end
                end)

                popup.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and not rBox:IsAncestorOf(input.Target) and not gBox:IsAncestorOf(input.Target) and not bBox:IsAncestorOf(input.Target) then
                        popup.Visible = false
                    end
                end)

                updatePreview()
                table.insert(sectionObj.Components, preview)
                return preview
            end

            table.insert(tab.Sections, sectionObj)
            return sectionObj
        end

        return tab
    end

    function window:AddNotification(title, message, duration)
        duration = duration or 4
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 320, 0, 90)
        notif.Position = UDim2.new(1, 20, 0, 20)
        notif.BackgroundColor3 = Theme.DarkBgTop
        notif.BorderSizePixel = 0
        notif.Parent = screenGui

        local nCorner = Instance.new("UICorner")
        nCorner.CornerRadius = UDim.new(0, 10)
        nCorner.Parent = notif

        local nGrad = Instance.new("UIGradient")
        nGrad.Rotation = 90
        nGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.AccentStart),
            ColorSequenceKeypoint.new(1, Theme.AccentEnd)
        })
        nGrad.Parent = notif

        local nTitle = Instance.new("TextLabel")
        nTitle.Size = UDim2.new(1, -20, 0, 28)
        nTitle.Position = UDim2.new(0, 15, 0, 8)
        nTitle.BackgroundTransparency = 1
        nTitle.Text = title
        nTitle.TextColor3 = Theme.TextPrimary
        nTitle.Font = Enum.Font.GothamBold
        nTitle.TextSize = 14
        nTitle.TextXAlignment = Enum.TextXAlignment.Left
        nTitle.Parent = notif

        local nMsg = Instance.new("TextLabel")
        nMsg.Size = UDim2.new(1, -20, 0, 40)
        nMsg.Position = UDim2.new(0, 15, 0, 38)
        nMsg.BackgroundTransparency = 1
        nMsg.Text = message
        nMsg.TextColor3 = Theme.TextSecondary
        nMsg.Font = Enum.Font.Gotham
        nMsg.TextSize = 13
        nMsg.TextXAlignment = Enum.TextXAlignment.Left
        nMsg.TextWrapped = true
        nMsg.Parent = notif

        local tweenIn = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local tweenOut = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

        TweenService:Create(notif, tweenIn, {Position = UDim2.new(1, -340, 0, 20)}):Play()

        spawn(function()
            wait(duration)
            TweenService:Create(notif, tweenOut, {Position = UDim2.new(1, 20, 0, 20)}):Play()
            Debris:AddItem(notif, 0.5)
        end)
    end

    getgenv().PremiumUI = PremiumUI
    return window
end

return PremiumUI
