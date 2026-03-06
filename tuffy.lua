local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local DEFAULT_COLORS = {
	Background = Color3.fromRGB(18, 18, 18),
	Sidebar = Color3.fromRGB(22, 22, 22),
	Panel = Color3.fromRGB(28, 28, 28),
	Stroke = Color3.fromRGB(50, 50, 50),
	Text = Color3.fromRGB(240, 240, 240),
	SubText = Color3.fromRGB(160, 160, 160),
	Accent = Color3.fromRGB(14, 144, 210),
	Hover = Color3.fromRGB(40, 40, 40),
	Danger = Color3.fromRGB(220, 70, 70),
	SwitchOff = Color3.fromRGB(70, 70, 70),
	SwitchOn = Color3.fromRGB(14, 144, 210),
	SectionHeader = Color3.fromRGB(38, 38, 38),
}

local DEFAULT_UI = {
	CornerRadius = UDim.new(0, 10),
	AnimationSpeed = 0.2,
	FrameSize = UDim2.new(0, 580, 0, 380),
	SidebarWidth = 140,
	MinimizedSize = UDim2.new(0, 580, 0, 88),
	SettingsFrameSize = UDim2.new(0, 400, 0, 300),
	TextSize = 14,
	TitleTextSize = 18,
	HeaderTextSize = 15,
	ButtonTextSize = 14,
	IsMinimized = false,
	SettingsOpen = false,
	CurrentTab = "Home",
	InputTextSize = 14,
	Font = Enum.Font.Gotham,
	TitleFont = Enum.Font.GothamBold,
	HeaderFont = Enum.Font.GothamBold,
	ButtonFont = Enum.Font.GothamMedium,
	InputFont = Enum.Font.Gotham,
	Transparency = 0,
	BackgroundTransparency = 0,
	StrokeTransparency = 0.4,
	HoverTransparency = 0.1,
	ActiveTransparency = 0.2,
}

local PROFILE_BAR_HEIGHT = 48

local function getSafeUIParent()
	local ok, cg = pcall(function() return game:GetService("CoreGui") end)
	if ok and cg then return cg end
	if type(gethui) == "function" then
		local h = gethui()
		if h then return h end
	end
	if type(get_hidden_ui) == "function" then
		local h = get_hidden_ui()
		if h then return h end
	end
	return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function protectGuiElement(element)
	pcall(function()
		if syn and syn.protect_gui then syn.protect_gui(element) end
		if element.SetAttribute then element:SetAttribute("Protected", true) end
	end)
end

local function createProtectedScreenGui(name, parent, displayOrder)
	parent = parent or getSafeUIParent()
	displayOrder = displayOrder or 2^31 - 1
	local gui = Instance.new("ScreenGui")
	gui.Name = name
	gui.DisplayOrder = displayOrder
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = parent
	pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
	return gui
end

local function mergeConfig(overrides)
	local Colors = {}
	local UI = {}
	for k, v in pairs(DEFAULT_COLORS) do Colors[k] = v end
	for k, v in pairs(DEFAULT_UI) do UI[k] = v end
	if overrides and overrides.Colors then
		for k, v in pairs(overrides.Colors) do Colors[k] = v end
	end
	if overrides and overrides.UI then
		for k, v in pairs(overrides.UI) do UI[k] = v end
	end
	return { Colors = Colors, UI = UI }
end

local function create(options)
	options = options or {}
	local isMobile = options.isMobile or (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)
	local config = options.config or mergeConfig()
	local CONFIG = config
	local parent = options.parent or getSafeUIParent()
	local getAsset = options.getAsset or function(id) return "rbxassetid://" .. tostring(id) end
	local player = options.player or Players.LocalPlayer
	local namePrefix = options.namePrefix or "ZZZZ_"

	local screenGui = createProtectedScreenGui(namePrefix .. "ESPVisuals", parent)
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "Main"
	mainFrame.Size = CONFIG.UI.FrameSize
	mainFrame.Position = isMobile and UDim2.new(0.5, -225, 0.5, -150) or UDim2.new(0.5, -290, 0.5, -190)
	mainFrame.BackgroundColor3 = CONFIG.Colors.Panel
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = screenGui
	protectGuiElement(mainFrame)
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
	local mainStroke = Instance.new("UIStroke", mainFrame)
	mainStroke.Thickness = 1
	mainStroke.Color = CONFIG.Colors.Stroke
	mainStroke.Transparency = 0.4

	-- TopBar
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Parent = mainFrame
	topBar.BackgroundColor3 = CONFIG.Colors.Background
	topBar.Size = UDim2.new(1, 0, 0, 40)
	topBar.BorderSizePixel = 0
	Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

	local logo = Instance.new("ImageLabel")
	logo.Name = "Logo"
	logo.Parent = topBar
	logo.BackgroundTransparency = 1
	logo.Size = UDim2.new(0, 32, 0, 32)
	logo.Position = UDim2.new(0, 8, 0.5, -16)
	logo.Image = getAsset("140286377960596")
	Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 8)

	local titleHolder = Instance.new("Frame")
	titleHolder.Parent = topBar
	titleHolder.BackgroundTransparency = 1
	titleHolder.Position = UDim2.new(0, 48, 0, 0)
	titleHolder.Size = UDim2.new(1, -200, 1, 0)

	local title = Instance.new("TextLabel")
	title.Parent = titleHolder
	title.BackgroundTransparency = 1
	title.Text = "ZZZZ HUB v2.4"
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextColor3 = CONFIG.Colors.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Size = UDim2.new(0, 120, 0.5, 0)
	title.Position = UDim2.new(0, 0, 0, 0)

	local fpsLabel = Instance.new("TextLabel")
	fpsLabel.Parent = titleHolder
	fpsLabel.BackgroundTransparency = 1
	fpsLabel.Text = "FPS: 0 - PING: 0ms"
	fpsLabel.Font = Enum.Font.Gotham
	fpsLabel.TextSize = 11
	fpsLabel.TextColor3 = CONFIG.Colors.SubText
	fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
	fpsLabel.Size = UDim2.new(0, 120, 0.5, 0)
	fpsLabel.Position = UDim2.new(0, 0, 0.5, 0)

	local searchBox = Instance.new("TextBox")
	searchBox.Parent = titleHolder
	searchBox.Position = UDim2.new(0, 135, 0, 5)
	searchBox.Size = UDim2.new(1, -135, 1, -10)
	searchBox.BackgroundColor3 = CONFIG.Colors.Background
	searchBox.BorderSizePixel = 0
	searchBox.Text = ""
	searchBox.PlaceholderText = "Search features..."
	searchBox.Font = Enum.Font.Gotham
	searchBox.TextSize = 12
	searchBox.TextColor3 = CONFIG.Colors.Text
	searchBox.PlaceholderColor3 = CONFIG.Colors.SubText
	searchBox.TextXAlignment = Enum.TextXAlignment.Left
	searchBox.ClearTextOnFocus = false
	Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)
	local searchStroke = Instance.new("UIStroke", searchBox)
	searchStroke.Color = CONFIG.Colors.Stroke
	searchStroke.Thickness = 1
	searchStroke.Transparency = 0.6
	Instance.new("UIPadding", searchBox).PaddingLeft = UDim.new(0, 8)

	local minimizeBtn = Instance.new("TextButton")
	minimizeBtn.Parent = topBar
	minimizeBtn.BackgroundColor3 = CONFIG.Colors.Background
	minimizeBtn.Text = "−"
	minimizeBtn.Font = Enum.Font.GothamBold
	minimizeBtn.TextSize = 20
	minimizeBtn.TextColor3 = CONFIG.Colors.Text
	minimizeBtn.AutoButtonColor = false
	minimizeBtn.Size = UDim2.new(0, 32, 0, 32)
	minimizeBtn.Position = UDim2.new(1, -70, 0.5, -16)
	Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 8)

	local closeBtn = Instance.new("TextButton")
	closeBtn.Parent = topBar
	closeBtn.BackgroundColor3 = CONFIG.Colors.Background
	closeBtn.Text = "×"
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 20
	closeBtn.TextColor3 = CONFIG.Colors.Text
	closeBtn.AutoButtonColor = false
	closeBtn.Size = UDim2.new(0, 32, 0, 32)
	closeBtn.Position = UDim2.new(1, -36, 0.5, -16)
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

	-- Sidebar
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Parent = mainFrame
	sidebar.BackgroundColor3 = CONFIG.Colors.Sidebar
	sidebar.Size = UDim2.new(0, CONFIG.UI.SidebarWidth, 1, -40 - PROFILE_BAR_HEIGHT)
	sidebar.Position = UDim2.new(0, 0, 0, 40)
	sidebar.BorderSizePixel = 0
	Instance.new("UIStroke", sidebar).Color = CONFIG.Colors.Stroke

	local sidebarLayout = Instance.new("UIListLayout")
	sidebarLayout.Parent = sidebar
	sidebarLayout.Padding = UDim.new(0, 6)
	sidebarLayout.FillDirection = Enum.FillDirection.Vertical
	sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	sidebarLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

	-- Content area
	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Parent = mainFrame
	contentArea.BackgroundTransparency = 1
	contentArea.Position = UDim2.new(0, CONFIG.UI.SidebarWidth, 0, 40)
	contentArea.Size = UDim2.new(1, -CONFIG.UI.SidebarWidth, 1, -40 - PROFILE_BAR_HEIGHT)

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.Parent = contentArea
	contentLayout.Padding = UDim.new(0, 10)
	contentLayout.FillDirection = Enum.FillDirection.Vertical
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

	-- Profile bar
	local profileBar = Instance.new("Frame")
	profileBar.Name = "ProfileBar"
	profileBar.Parent = mainFrame
	profileBar.Size = UDim2.new(1, 0, 0, PROFILE_BAR_HEIGHT)
	profileBar.Position = UDim2.new(0, 0, 1, -PROFILE_BAR_HEIGHT)
	profileBar.BackgroundColor3 = CONFIG.Colors.Sidebar
	profileBar.BorderSizePixel = 0
	Instance.new("UICorner", profileBar).CornerRadius = UDim.new(0, 8)
	local pad = Instance.new("UIPadding", profileBar)
	pad.PaddingLeft = UDim.new(0, 10)
	pad.PaddingRight = UDim.new(0, 10)
	pad.PaddingTop = UDim.new(0, 6)
	pad.PaddingBottom = UDim.new(0, 6)
	local list = Instance.new("UIListLayout", profileBar)
	list.FillDirection = Enum.FillDirection.Horizontal
	list.VerticalAlignment = Enum.VerticalAlignment.Center
	list.Padding = UDim.new(0, 10)
	local avatar = Instance.new("ImageLabel", profileBar)
	avatar.Name = "Avatar"
	avatar.Size = UDim2.new(0, 36, 0, 36)
	avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
	avatar.BorderSizePixel = 0
	avatar.ScaleType = Enum.ScaleType.Crop
	Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
	pcall(function()
		avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
	end)
	local textContainer = Instance.new("Frame", profileBar)
	textContainer.Name = "ProfileText"
	textContainer.Size = UDim2.new(1, -50, 1, 0)
	textContainer.BackgroundTransparency = 1
	local textList = Instance.new("UIListLayout", textContainer)
	textList.FillDirection = Enum.FillDirection.Vertical
	textList.VerticalAlignment = Enum.VerticalAlignment.Center
	textList.Padding = UDim.new(0, 2)
	textList.SortOrder = Enum.SortOrder.LayoutOrder
	local nameLabel = Instance.new("TextLabel", textContainer)
	nameLabel.Name = "Username"
	nameLabel.LayoutOrder = 1
	nameLabel.Size = UDim2.new(1, 0, 0, 18)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = player.Name
	nameLabel.Font = CONFIG.UI.TitleFont or Enum.Font.GothamBold
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = CONFIG.Colors.Text
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	local bestLabel = Instance.new("TextLabel", textContainer)
	bestLabel.Name = "BestBrainrotLabel"
	bestLabel.LayoutOrder = 2
	bestLabel.Size = UDim2.new(1, 0, 0, 16)
	bestLabel.BackgroundTransparency = 1
	bestLabel.Text = "—"
	bestLabel.Font = CONFIG.UI.Font or Enum.Font.Gotham
	bestLabel.TextSize = 11
	bestLabel.TextColor3 = CONFIG.Colors.SubText
	bestLabel.TextXAlignment = Enum.TextXAlignment.Left
	bestLabel.TextTruncate = Enum.TextTruncate.AtEnd

	-- Settings frame
	local settingsFrame = Instance.new("Frame")
	settingsFrame.Name = "SettingsFrame"
	settingsFrame.Size = CONFIG.UI.SettingsFrameSize
	settingsFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
	settingsFrame.BackgroundColor3 = CONFIG.Colors.Panel
	settingsFrame.Visible = false
	settingsFrame.Active = true
	settingsFrame.Draggable = true
	settingsFrame.Parent = screenGui
	Instance.new("UICorner", settingsFrame).CornerRadius = CONFIG.UI.CornerRadius
	local settingsStroke = Instance.new("UIStroke", settingsFrame)
	settingsStroke.Thickness = 1
	settingsStroke.Color = CONFIG.Colors.Stroke
	settingsStroke.Transparency = 0.4

	local settingsTopBar = Instance.new("Frame")
	settingsTopBar.Name = "SettingsTopBar"
	settingsTopBar.Parent = settingsFrame
	settingsTopBar.BackgroundColor3 = CONFIG.Colors.Background
	settingsTopBar.Size = UDim2.new(1, 0, 0, 40)
	settingsTopBar.BorderSizePixel = 0
	Instance.new("UICorner", settingsTopBar).CornerRadius = UDim.new(0, 10)

	local settingsTitle = Instance.new("TextLabel")
	settingsTitle.Parent = settingsTopBar
	settingsTitle.BackgroundTransparency = 1
	settingsTitle.Text = "Settings"
	settingsTitle.Font = Enum.Font.GothamBold
	settingsTitle.TextSize = 18
	settingsTitle.TextColor3 = CONFIG.Colors.Text
	settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
	settingsTitle.Position = UDim2.new(0, 10, 0, 0)
	settingsTitle.Size = UDim2.new(1, -40, 1, 0)

	local settingsCloseBtn = Instance.new("TextButton")
	settingsCloseBtn.Parent = settingsTopBar
	settingsCloseBtn.BackgroundColor3 = CONFIG.Colors.Background
	settingsCloseBtn.Text = "×"
	settingsCloseBtn.Font = Enum.Font.GothamBold
	settingsCloseBtn.TextSize = 20
	settingsCloseBtn.TextColor3 = CONFIG.Colors.Text
	settingsCloseBtn.AutoButtonColor = false
	settingsCloseBtn.Size = UDim2.new(0, 32, 0, 32)
	settingsCloseBtn.Position = UDim2.new(1, -36, 0.5, -16)
	Instance.new("UICorner", settingsCloseBtn).CornerRadius = UDim.new(0, 8)

	local settingsContent = Instance.new("ScrollingFrame")
	settingsContent.Name = "SettingsContent"
	settingsContent.Parent = settingsFrame
	settingsContent.BackgroundTransparency = 1
	settingsContent.Position = UDim2.new(0, 10, 0, 40)
	settingsContent.Size = UDim2.new(1, -20, 1, -40)
	settingsContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	settingsContent.ScrollBarThickness = 3
	settingsContent.ScrollBarImageColor3 = CONFIG.Colors.Stroke
	settingsContent.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

	local settingsLayout = Instance.new("UIListLayout")
	settingsLayout.Parent = settingsContent
	settingsLayout.Padding = UDim.new(0, 8)
	settingsLayout.FillDirection = Enum.FillDirection.Vertical
	settingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	settingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		pcall(function()
			settingsContent.CanvasSize = UDim2.new(0, 0, 0, settingsLayout.AbsoluteContentSize.Y + 10)
		end)
	end)

	-- State
	local sections = {}
	local allSwitchRows = {}
	local activeSection = nil
	local tween = TweenService or options.tweenService or game:GetService("TweenService")

	-- Helpers
	local function createSection(name)
		local sectionFrame = Instance.new("ScrollingFrame")
		sectionFrame.Name = name
		sectionFrame.BackgroundTransparency = 1
		sectionFrame.Size = UDim2.new(1, -20, 1, 0)
		sectionFrame.Position = UDim2.new(0, 10, 0, 0)
		sectionFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		sectionFrame.ScrollBarThickness = 3
		sectionFrame.ScrollBarImageColor3 = CONFIG.Colors.Stroke
		sectionFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
		sectionFrame.Visible = false
		sectionFrame.ZIndex = 1
		sectionFrame.Parent = contentArea
		local listLayout = Instance.new("UIListLayout", sectionFrame)
		listLayout.Padding = UDim.new(0, 8)
		listLayout.FillDirection = Enum.FillDirection.Vertical
		listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			pcall(function()
				sectionFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
			end)
		end)
		sections[name] = sectionFrame
		return sectionFrame
	end

	local function createTabButton(name, sectionName, iconId, layoutOrder)
		layoutOrder = layoutOrder or 0
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1, -12, 0, 36)
		button.BackgroundColor3 = CONFIG.Colors.Sidebar
		button.Text = ""
		button.Font = Enum.Font.GothamMedium
		button.TextSize = 14
		button.TextColor3 = CONFIG.Colors.Text
		button.AutoButtonColor = false
		button.LayoutOrder = layoutOrder
		button.Parent = sidebar
		button.Name = sectionName .. "Button"
		Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
		local icon = Instance.new("TextLabel")
		icon.Size = UDim2.new(0, 20, 0, 20)
		icon.Position = UDim2.new(0, 8, 0.5, -10)
		icon.BackgroundTransparency = 1
		icon.Text = ""
		icon.Font = Enum.Font.GothamBold
		icon.TextSize = 16
		icon.TextColor3 = Color3.fromRGB(0, 162, 255)
		icon.TextXAlignment = Enum.TextXAlignment.Center
		icon.TextYAlignment = Enum.TextYAlignment.Center
		icon.Parent = button
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -36, 1, 0)
		label.Position = UDim2.new(0, 32, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = name
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 14
		label.TextColor3 = CONFIG.Colors.Text
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = button
		button.MouseEnter:Connect(function()
			if activeSection ~= sectionName then
				tween:Create(button, TweenInfo.new(0.15), { BackgroundColor3 = CONFIG.Colors.Hover }):Play()
			end
		end)
		button.MouseLeave:Connect(function()
			if activeSection ~= sectionName then
				tween:Create(button, TweenInfo.new(0.15), { BackgroundColor3 = CONFIG.Colors.Sidebar }):Play()
			end
		end)
		button.MouseButton1Click:Connect(function()
			for n, section in pairs(sections) do
				if section and section.Parent then section.Visible = false end
			end
			for _, btn in pairs(sidebar:GetChildren()) do
				if btn:IsA("TextButton") and btn.Name:match("Button$") then
					tween:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = CONFIG.Colors.Sidebar }):Play()
				end
			end
			if sections[sectionName] then
				sections[sectionName].Visible = true
				tween:Create(button, TweenInfo.new(0.15), { BackgroundColor3 = CONFIG.Colors.Accent }):Play()
				activeSection = sectionName
				CONFIG.UI.CurrentTab = sectionName
			end
		end)
		return button
	end

	local function createSectionHeader(parent, titleText)
		local header = Instance.new("Frame")
		header.Size = UDim2.new(1, 0, 0, 28)
		header.BackgroundColor3 = CONFIG.Colors.SectionHeader
		header.Parent = parent
		Instance.new("UICorner", header).CornerRadius = UDim.new(0, 6)
		local stroke = Instance.new("UIStroke", header)
		stroke.Thickness = 0.8
		stroke.Color = CONFIG.Colors.Stroke
		stroke.Transparency = 0.6
		local label = Instance.new("TextLabel")
		label.Parent = header
		label.BackgroundTransparency = 1
		label.Text = titleText
		label.Font = Enum.Font.GothamBold
		label.TextSize = 15
		label.TextColor3 = CONFIG.Colors.Text
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Position = UDim2.new(0, 10, 0, 0)
		label.Size = UDim2.new(1, -20, 1, 0)
	end

	local function createSwitchRow(parent)
		local rowContainer = Instance.new("Frame")
		rowContainer.BackgroundTransparency = 1
		rowContainer.Size = UDim2.new(1, 0, 0, 35)
		rowContainer.Parent = parent
		local layout = Instance.new("UIListLayout")
		layout.FillDirection = Enum.FillDirection.Horizontal
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		layout.VerticalAlignment = Enum.VerticalAlignment.Top
		layout.Padding = UDim.new(0, 10)
		layout.Parent = rowContainer
		return rowContainer
	end

	local function createCompactSwitch(parent, labelText, defaultState, callback, widthScale)
		widthScale = widthScale or 0.48
		local switchData = { state = defaultState }
		local row = Instance.new("Frame")
		row.BackgroundColor3 = CONFIG.Colors.Background
		row.Size = UDim2.new(widthScale, -5, 0, isMobile and 44 or 35)
		row.Parent = parent
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", row).Thickness = 0.8
		allSwitchRows[labelText] = row
		local label = Instance.new("TextLabel")
		label.Parent = row
		label.BackgroundTransparency = 1
		label.Text = labelText
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 12
		label.TextColor3 = CONFIG.Colors.Text
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Position = UDim2.new(0, 8, 0, 0)
		label.Size = UDim2.new(1, -50, 1, 0)
		label.TextTruncate = Enum.TextTruncate.AtEnd
		local sw = Instance.new("Frame")
		sw.Parent = row
		sw.AnchorPoint = Vector2.new(1, 0.5)
		sw.Position = UDim2.new(1, -8, 0.5, 0)
		sw.Size = UDim2.new(0, 36, 0, 18)
		sw.BackgroundColor3 = defaultState and CONFIG.Colors.SwitchOn or CONFIG.Colors.SwitchOff
		Instance.new("UICorner", sw).CornerRadius = UDim.new(0, 9)
		local knob = Instance.new("Frame")
		knob.Parent = sw
		knob.Size = UDim2.new(0, 14, 0, 14)
		knob.Position = defaultState and UDim2.new(1, -16, 0, 2) or UDim2.new(0, 2, 0, 2)
		knob.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
		Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 7)
		local hit = Instance.new("TextButton")
		hit.Parent = sw
		hit.BackgroundTransparency = 1
		hit.Text = ""
		hit.Size = UDim2.new(1, 0, 1, 0)
		hit.AutoButtonColor = false
		switchData.setState = function(newState)
			switchData.state = newState
			tween:Create(sw, TweenInfo.new(CONFIG.UI.AnimationSpeed, Enum.EasingStyle.Quad), { BackgroundColor3 = newState and CONFIG.Colors.SwitchOn or CONFIG.Colors.SwitchOff }):Play()
			tween:Create(knob, TweenInfo.new(CONFIG.UI.AnimationSpeed, Enum.EasingStyle.Quad), { Position = newState and UDim2.new(1, -16, 0, 2) or UDim2.new(0, 2, 0, 2) }):Play()
			if callback then task.spawn(callback, newState) end
		end
		hit.MouseButton1Click:Connect(function() switchData.setState(not switchData.state) end)
		switchData.set = function(v) switchData.setState(v) end
		switchData.get = function() return switchData.state end
		return switchData
	end

	local function createSwitch(parent, labelText, defaultState, callback)
		local switchData = { state = defaultState }
		local row = Instance.new("Frame")
		row.BackgroundColor3 = CONFIG.Colors.Background
		row.Size = UDim2.new(1, 0, 0, isMobile and 44 or 35)
		row.Parent = parent
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", row).Thickness = 0.8
		allSwitchRows[labelText] = row
		local label = Instance.new("TextLabel")
		label.Parent = row
		label.BackgroundTransparency = 1
		label.Text = labelText
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 13
		label.TextColor3 = CONFIG.Colors.Text
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Position = UDim2.new(0, 10, 0, 0)
		label.Size = UDim2.new(1, -60, 1, 0)
		local sw = Instance.new("Frame")
		sw.Parent = row
		sw.AnchorPoint = Vector2.new(1, 0.5)
		sw.Position = UDim2.new(1, -10, 0.5, 0)
		sw.Size = UDim2.new(0, 40, 0, 20)
		sw.BackgroundColor3 = defaultState and CONFIG.Colors.SwitchOn or CONFIG.Colors.SwitchOff
		Instance.new("UICorner", sw).CornerRadius = UDim.new(0, 10)
		local knob = Instance.new("Frame")
		knob.Parent = sw
		knob.Size = UDim2.new(0, 16, 0, 16)
		knob.Position = defaultState and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
		knob.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
		Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 8)
		local hit = Instance.new("TextButton")
		hit.Parent = sw
		hit.BackgroundTransparency = 1
		hit.Text = ""
		hit.Size = UDim2.new(1, 0, 1, 0)
		hit.AutoButtonColor = false
		switchData.setState = function(newState)
			switchData.state = newState
			tween:Create(sw, TweenInfo.new(CONFIG.UI.AnimationSpeed, Enum.EasingStyle.Quad), { BackgroundColor3 = newState and CONFIG.Colors.SwitchOn or CONFIG.Colors.SwitchOff }):Play()
			tween:Create(knob, TweenInfo.new(CONFIG.UI.AnimationSpeed, Enum.EasingStyle.Quad), { Position = newState and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2) }):Play()
			if callback then task.spawn(callback, newState) end
		end
		hit.MouseButton1Click:Connect(function() switchData.setState(not switchData.state) end)
		return { row = row, set = switchData.setState, get = function() return switchData.state end }
	end

	local function createNumberInput(parent, labelText, defaultValue, callback)
		local row = Instance.new("Frame")
		row.BackgroundColor3 = CONFIG.Colors.Background
		row.Size = UDim2.new(1, 0, 0, 40)
		row.Parent = parent
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", row).Thickness = 0.8
		local label = Instance.new("TextLabel")
		label.Parent = row
		label.BackgroundTransparency = 1
		label.Text = labelText
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 14
		label.TextColor3 = CONFIG.Colors.Text
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Position = UDim2.new(0, 10, 0, 0)
		label.Size = UDim2.new(1, -80, 1, 0)
		local textBox = Instance.new("TextBox")
		textBox.Parent = row
		textBox.BackgroundColor3 = CONFIG.Colors.Background
		textBox.Size = UDim2.new(0, 60, 0, 24)
		textBox.Position = UDim2.new(1, -70, 0.5, -12)
		textBox.Text = tostring(defaultValue)
		textBox.Font = Enum.Font.Gotham
		textBox.TextSize = 14
		textBox.TextColor3 = CONFIG.Colors.Text
		textBox.TextXAlignment = Enum.TextXAlignment.Right
		Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)
		Instance.new("UIStroke", textBox).Thickness = 0.8
		textBox.FocusLost:Connect(function()
			local num = tonumber(textBox.Text)
			if num then
				textBox.Text = tostring(num)
				if callback then callback(num) end
			else
				textBox.Text = tostring(defaultValue)
			end
		end)
		return { row = row, set = function(v) textBox.Text = tostring(v) end, get = function() return tonumber(textBox.Text) or defaultValue end }
	end

	local function createSlider(parent, labelText, minVal, maxVal, defaultValue, callback)
		minVal = minVal or 0
		maxVal = maxVal or 100
		if maxVal <= minVal then maxVal = minVal + 1 end
		local current = math.clamp(defaultValue or minVal, minVal, maxVal)
		local row, track, fill, thumb, valueLabel
		local uis = UserInputService
		local function updateFromRatio(ratio)
			ratio = math.clamp(ratio, 0, 1)
			current = math.floor(minVal + (maxVal - minVal) * ratio + 0.5)
			if current < minVal then current = minVal elseif current > maxVal then current = maxVal end
			if valueLabel and valueLabel.Parent then valueLabel.Text = tostring(current) end
			if fill and fill.Parent then fill.Size = UDim2.new(ratio, 0, 1, 0) end
			if thumb and thumb.Parent then thumb.Position = UDim2.new(ratio, -8, 0.5, -8) end
			if callback then callback(current) end
		end
		local function updateFromX(x)
			if not track or not track.Parent then return end
			local abs, size = track.AbsolutePosition, track.AbsoluteSize
			updateFromRatio((x - abs.X) / math.max(1, size.X))
		end
		row = Instance.new("Frame")
		row.BackgroundTransparency = 1
		row.Size = UDim2.new(1, 0, 0, 36)
		row.Parent = parent
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.5, -8, 0, 18)
		label.Position = UDim2.new(0, 0, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = labelText
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 12
		label.TextColor3 = CONFIG.Colors.Text
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = row
		valueLabel = Instance.new("TextLabel")
		valueLabel.Size = UDim2.new(0, 44, 0, 18)
		valueLabel.Position = UDim2.new(1, -48, 0, 0)
		valueLabel.BackgroundTransparency = 1
		valueLabel.Text = tostring(current)
		valueLabel.Font = Enum.Font.GothamBold
		valueLabel.TextSize = 12
		valueLabel.TextColor3 = CONFIG.Colors.Text
		valueLabel.TextXAlignment = Enum.TextXAlignment.Right
		valueLabel.Parent = row
		track = Instance.new("TextButton")
		track.Size = UDim2.new(1, 0, 0, isMobile and 14 or 10)
		track.Position = UDim2.new(0, 0, 0, 20)
		track.BackgroundColor3 = CONFIG.Colors.Stroke
		track.BorderSizePixel = 0
		track.Text = ""
		track.Active = true
		track.Selectable = false
		track.Parent = row
		Instance.new("UICorner", track).CornerRadius = UDim.new(0, 5)
		fill = Instance.new("Frame")
		fill.Size = UDim2.new((current - minVal) / math.max(1, maxVal - minVal), 0, 1, 0)
		fill.Position = UDim2.new(0, 0, 0, 0)
		fill.BackgroundColor3 = CONFIG.Colors.Accent
		fill.BorderSizePixel = 0
		fill.Parent = track
		Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 5)
		thumb = Instance.new("TextButton")
		thumb.Size = UDim2.new(0, 16, 0, 16)
		thumb.Position = UDim2.new((current - minVal) / math.max(1, maxVal - minVal), -8, 0.5, -8)
		thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		thumb.Text = ""
		thumb.BorderSizePixel = 0
		thumb.Parent = track
		thumb.Active = true
		thumb.Selectable = false
		Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", thumb).Color = Color3.fromRGB(80, 80, 80)
		track.MouseButton1Click:Connect(function()
			local mouse = player:GetMouse()
			if mouse and mouse.X then updateFromX(mouse.X) end
		end)
		return { set = function(v) current = math.clamp(tonumber(v) or minVal, minVal, maxVal); updateFromRatio((current - minVal) / math.max(1, maxVal - minVal)) end, get = function() return current end }
	end

	local function createButton(parent, text, callback)
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1, -20, 0, 40)
		button.BackgroundColor3 = CONFIG.Colors.Background
		button.Text = text
		button.Font = Enum.Font.GothamMedium
		button.TextSize = 14
		button.TextColor3 = CONFIG.Colors.Text
		button.AutoButtonColor = false
		button.Parent = parent
		Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", button).Thickness = 0.8
		if callback then
			button.MouseButton1Click:Connect(callback)
			button.TouchTap:Connect(callback)
		end
		return button
	end

	local function createCompactButton(parent, text, callback, widthScale)
		widthScale = widthScale or 0.18
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(widthScale, -5, 0, 35)
		button.BackgroundColor3 = CONFIG.Colors.Accent
		button.Text = text
		button.Font = Enum.Font.GothamBold
		button.TextSize = 11
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.AutoButtonColor = false
		button.Parent = parent
		Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
		if callback then
			button.MouseButton1Click:Connect(callback)
			button.TouchTap:Connect(callback)
		end
		return button
	end

	-- Search filter: optional connection (no-op by default; main script can replace)
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local searchText = searchBox.Text:lower()
		for _, row in pairs(allSwitchRows) do
			if row and row.Parent then
				local label = row:FindFirstChild("TextLabel")
				if label then
					row.Visible = searchText == "" or label.Text:lower():find(searchText, 1, true)
				end
			end
		end
	end)

	return {
		screenGui = screenGui,
		mainFrame = mainFrame,
		topBar = topBar,
		logo = logo,
		titleHolder = titleHolder,
		title = title,
		fpsLabel = fpsLabel,
		searchBox = searchBox,
		minimizeBtn = minimizeBtn,
		closeBtn = closeBtn,
		sidebar = sidebar,
		contentArea = contentArea,
		profileBar = profileBar,
		profileBestLabel = bestLabel,
		settingsFrame = settingsFrame,
		settingsTopBar = settingsTopBar,
		settingsTitle = settingsTitle,
		settingsCloseBtn = settingsCloseBtn,
		settingsContent = settingsContent,
		settingsLayout = settingsLayout,
		sections = sections,
		allSwitchRows = allSwitchRows,
		config = config,
		createSection = createSection,
		createTabButton = createTabButton,
		createSectionHeader = createSectionHeader,
		createSwitchRow = createSwitchRow,
		createCompactSwitch = createCompactSwitch,
		createSwitch = createSwitch,
		createNumberInput = createNumberInput,
		createSlider = createSlider,
		createButton = createButton,
		createCompactButton = createCompactButton,
		getSafeUIParent = getSafeUIParent,
	}
end

return {
	create = create,
	getSafeUIParent = getSafeUIParent,
	mergeConfig = mergeConfig,
	DEFAULT_COLORS = DEFAULT_COLORS,
	DEFAULT_UI = DEFAULT_UI,
}
