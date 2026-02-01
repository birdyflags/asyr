--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                    CENTRIXITY UI LIBRARY                      ║
    ║                         Version 1.0                           ║
    ╠═══════════════════════════════════════════════════════════════╣
    ║  A modern, animated UI library for Roblox                     ║
    ║  Features: Tabs, SubPages, Components, Notifications          ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

-- ============================================
-- LIBRARY SETUP
-- ============================================
local Centrixity = {}
Centrixity.__index = Centrixity

-- Theme Configuration
Centrixity.Theme = {
	-- Main Colors
	Primary = Color3.fromRGB(255, 127, 0),
	PrimaryDark = Color3.fromRGB(200, 100, 0),
	Secondary = Color3.fromRGB(255, 200, 87),
	
	-- Background Colors
	Background = Color3.fromRGB(19, 20, 25),
	BackgroundDark = Color3.fromRGB(16, 17, 21),
	BackgroundLight = Color3.fromRGB(24, 25, 32),
	
	-- Text Colors
	TextPrimary = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(130, 132, 150),
	TextMuted = Color3.fromRGB(69, 71, 90),
	
	-- Accent Colors
	Success = Color3.fromRGB(87, 242, 135),
	Error = Color3.fromRGB(255, 85, 85),
	Warning = Color3.fromRGB(255, 200, 87),
	
	-- Border/Stroke
	Border = Color3.fromRGB(31, 31, 45),
	BorderLight = Color3.fromRGB(35, 36, 45),
	
	-- Font
	Font = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
	FontMedium = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
	FontSemiBold = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
	FontBold = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
}

-- Utility Functions
local Utilities = {}

function Utilities.Create(className, properties, children)
	local instance = Instance.new(className)
	for prop, value in pairs(properties or {}) do
		instance[prop] = value
	end
	for _, child in ipairs(children or {}) do
		child.Parent = instance
	end
	return instance
end

function Utilities.Tween(instance, properties, duration, easingStyle, easingDirection)
	local tween = TweenService:Create(
		instance,
		TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out),
		properties
	)
	tween:Play()
	return tween
end

function Utilities.AddCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = parent
	return corner
end

function Utilities.AddStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Centrixity.Theme.Border
	stroke.Thickness = thickness or 1
	stroke.Parent = parent
	return stroke
end

function Utilities.AddPadding(parent, top, right, bottom, left)
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, top or 0)
	padding.PaddingRight = UDim.new(0, right or top or 0)
	padding.PaddingBottom = UDim.new(0, bottom or top or 0)
	padding.PaddingLeft = UDim.new(0, left or right or top or 0)
	padding.Parent = parent
	return padding
end

function Utilities.AddListLayout(parent, padding, direction, alignment)
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, padding or 5)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.FillDirection = direction or Enum.FillDirection.Vertical
	layout.HorizontalAlignment = alignment or Enum.HorizontalAlignment.Left
	layout.Parent = parent
	return layout
end

function Utilities.CreateGradient(parent, rotation, color1, color2)
	local gradient = Instance.new("UIGradient")
	gradient.Rotation = rotation or 90
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, color1 or Centrixity.Theme.Primary),
		ColorSequenceKeypoint.new(1, color2 or Centrixity.Theme.Secondary)
	}
	gradient.Parent = parent
	return gradient
end

-- ============================================
-- WINDOW CLASS
-- ============================================
local Window = {}
Window.__index = Window

function Window.new(library, config)
	local self = setmetatable({}, Window)
	
	self.Library = library
	self.Title = config.Title or "Centrixity"
	self.SubTitle = config.SubTitle or "UI Library"
	self.Size = config.Size or UDim2.new(0, 700, 0, 500)
	self.Tabs = {}
	self.ActiveTab = nil
	self.Visible = true
	self.Dragging = false
	
	-- Get game name
	local gameName = "Unknown Game"
	pcall(function()
		gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
	end)
	self.GameName = config.GameName or gameName
	
	-- Create UI
	self:_CreateUI()
	self:_SetupDragging()
	self:_SetupToggle(config.ToggleKey or Enum.KeyCode.RightControl)
	
	return self
end

function Window:_CreateUI()
	local theme = Centrixity.Theme
	
	-- ScreenGui
	self.ScreenGui = Utilities.Create("ScreenGui", {
		Name = "CentrixityUI",
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
	})
	
	-- Try to parent to CoreGui, fallback to PlayerGui
	local success = pcall(function()
		self.ScreenGui.Parent = game:GetService("CoreGui")
	end)
	if not success then
		self.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end
	
	-- Main Frame
	self.MainFrame = Utilities.Create("Frame", {
		Name = "MainFrame",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = self.Size,
		BackgroundColor3 = theme.Background,
		ClipsDescendants = true,
		Parent = self.ScreenGui
	})
	Utilities.AddCorner(self.MainFrame, 12)
	Utilities.AddStroke(self.MainFrame, theme.Border, 1)
	
	-- Header
	self.Header = Utilities.Create("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundTransparency = 1,
		Parent = self.MainFrame
	})
	
	-- Header Content
	local headerPadding = Utilities.AddPadding(self.Header, 0, 15, 0, 15)
	
	-- Logo/Title Area
	self.TitleLabel = Utilities.Create("TextLabel", {
		Name = "Title",
		Text = self.Title .. " <font color=\"#45475a\">" .. self.SubTitle .. "</font>",
		RichText = true,
		FontFace = theme.FontSemiBold,
		TextColor3 = theme.TextPrimary,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 40, 0, 0),
		Size = UDim2.new(0.5, 0, 1, 0),
		Parent = self.Header
	})
	
	-- Library Icon
	self.LibraryIcon = Utilities.Create("ImageLabel", {
		Name = "LibraryIcon",
		Image = "rbxassetid://137946959393180",
		Size = UDim2.new(0, 28, 0, 28),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Fit,
		Parent = self.Header
	})
	
	-- Game Name (Right side)
	self.GameLabel = Utilities.Create("TextLabel", {
		Name = "GameName",
		Text = self.GameName,
		FontFace = theme.Font,
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0.4, 0, 1, 0),
		Parent = self.Header
	})
	
	-- Header Divider Line
	self.HeaderDivider = Utilities.Create("Frame", {
		Name = "HeaderDivider",
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = theme.Border,
		BorderSizePixel = 0,
		Parent = self.Header
	})
	
	-- Sidebar
	self.Sidebar = Utilities.Create("Frame", {
		Name = "Sidebar",
		Position = UDim2.new(0, 0, 0, 40),
		Size = UDim2.new(0, 75, 1, -40),
		BackgroundTransparency = 1,
		Parent = self.MainFrame
	})
	
	-- Sidebar Divider
	self.SidebarDivider = Utilities.Create("Frame", {
		Name = "SidebarDivider",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = theme.Border,
		BorderSizePixel = 0,
		Parent = self.Sidebar
	})
	
	-- Tab Container in Sidebar
	self.TabContainer = Utilities.Create("Frame", {
		Name = "TabContainer",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = self.Sidebar
	})
	Utilities.AddPadding(self.TabContainer, 10, 10, 10, 10)
	Utilities.AddListLayout(self.TabContainer, 8)
	
	-- Content Area
	self.ContentArea = Utilities.Create("Frame", {
		Name = "ContentArea",
		Position = UDim2.new(0, 75, 0, 40),
		Size = UDim2.new(1, -75, 1, -40),
		BackgroundColor3 = theme.BackgroundDark,
		ClipsDescendants = true,
		Parent = self.MainFrame
	})
	Utilities.AddCorner(self.ContentArea, 10)
	
	-- SubPage Header (inside content area)
	self.SubPageHeader = Utilities.Create("Frame", {
		Name = "SubPageHeader",
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundTransparency = 1,
		Parent = self.ContentArea
	})
	Utilities.AddPadding(self.SubPageHeader, 10, 20, 5, 20)
	
	-- SubPage Tab Container
	self.SubPageTabContainer = Utilities.Create("Frame", {
		Name = "SubPageTabContainer",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = self.SubPageHeader
	})
	Utilities.AddListLayout(self.SubPageTabContainer, 10, Enum.FillDirection.Horizontal)
	
	-- Page Container (where components go)
	self.PageContainer = Utilities.Create("Frame", {
		Name = "PageContainer",
		Position = UDim2.new(0, 0, 0, 50),
		Size = UDim2.new(1, 0, 1, -50),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = self.ContentArea
	})
end

function Window:_SetupDragging()
	local dragStart, startPos
	
	self.Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.Dragging = true
			dragStart = input.Position
			startPos = self.MainFrame.Position
		end
	end)
	
	self.Header.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.Dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if self.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			self.MainFrame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

function Window:_SetupToggle(key)
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode == key then
			self:Toggle()
		end
	end)
end

function Window:Toggle()
	self.Visible = not self.Visible
	
	if self.Visible then
		self.MainFrame.Visible = true
		Utilities.Tween(self.MainFrame, {
			Size = self.Size,
			BackgroundTransparency = 0
		}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	else
		local tween = Utilities.Tween(self.MainFrame, {
			Size = UDim2.new(0, self.Size.X.Offset, 0, 0),
			BackgroundTransparency = 1
		}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		tween.Completed:Connect(function()
			if not self.Visible then
				self.MainFrame.Visible = false
			end
		end)
	end
end

function Window:Show()
	self.Visible = true
	self.MainFrame.Visible = true
	Utilities.Tween(self.MainFrame, {
		Size = self.Size,
		BackgroundTransparency = 0
	}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function Window:Hide()
	self.Visible = false
	local tween = Utilities.Tween(self.MainFrame, {
		Size = UDim2.new(0, self.Size.X.Offset, 0, 0),
		BackgroundTransparency = 1
	}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	tween.Completed:Connect(function()
		self.MainFrame.Visible = false
	end)
end

function Window:CreateTab(config)
	local tab = Tab.new(self, config)
	table.insert(self.Tabs, tab)
	
	-- If first tab, select it
	if #self.Tabs == 1 then
		tab:Select()
	end
	
	return tab
end

function Window:Notify(config)
	self.Library:Notify(config)
end

function Window:Destroy()
	self.ScreenGui:Destroy()
end

-- ============================================
-- TAB CLASS
-- ============================================
Tab = {}
Tab.__index = Tab

function Tab.new(window, config)
	local self = setmetatable({}, Tab)
	
	self.Window = window
	self.Name = config.Name or "Tab"
	self.Icon = config.Icon or "rbxassetid://7733960981"
	self.SubPages = {}
	self.ActiveSubPage = nil
	self.Selected = false
	self.LayoutOrder = #window.Tabs + 1
	
	self:_CreateUI()
	
	return self
end

function Tab:_CreateUI()
	local theme = Centrixity.Theme
	
	-- Tab Button in Sidebar
	self.TabButton = Utilities.Create("Frame", {
		Name = "Tab_" .. self.Name,
		Size = UDim2.new(1, 0, 0, 55),
		BackgroundColor3 = theme.Background,
		BackgroundTransparency = 1,
		LayoutOrder = self.LayoutOrder,
		Parent = self.Window.TabContainer
	})
	Utilities.AddCorner(self.TabButton, 8)
	
	-- Tab Icon
	self.IconLabel = Utilities.Create("ImageLabel", {
		Name = "Icon",
		Image = self.Icon,
		ImageColor3 = theme.TextMuted,
		Size = UDim2.new(0, 22, 0, 22),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, -10),
		BackgroundTransparency = 1,
		Parent = self.TabButton
	})
	
	-- Tab Name
	self.NameLabel = Utilities.Create("TextLabel", {
		Name = "Name",
		Text = self.Name,
		FontFace = theme.FontMedium,
		TextColor3 = theme.TextMuted,
		TextSize = 11,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 15),
		Size = UDim2.new(1, 0, 0, 15),
		BackgroundTransparency = 1,
		Parent = self.TabButton
	})
	
	-- Selection Indicator (bottom line)
	self.SelectionIndicator = Utilities.Create("Frame", {
		Name = "Indicator",
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, 2),
		Size = UDim2.new(0, 0, 0, 4),
		BackgroundColor3 = theme.Primary,
		BorderSizePixel = 0,
		Parent = self.TabButton
	})
	Utilities.AddCorner(self.SelectionIndicator, 10)
	Utilities.CreateGradient(self.SelectionIndicator, 0)
	
	-- Page Frame (holds SubPages)
	self.PageFrame = Utilities.Create("Frame", {
		Name = "Page_" .. self.Name,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = self.Window.PageContainer
	})
	
	-- SubPage Container in this tab
	self.SubPageContainer = Utilities.Create("ScrollingFrame", {
		Name = "SubPageContainer",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = theme.Primary,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = self.PageFrame
	})
	Utilities.AddPadding(self.SubPageContainer, 15, 15, 15, 15)
	Utilities.AddListLayout(self.SubPageContainer, 15, Enum.FillDirection.Horizontal)
	
	-- Click handler
	local clickButton = Utilities.Create("TextButton", {
		Name = "ClickHandler",
		Text = "",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = self.TabButton
	})
	
	clickButton.MouseButton1Click:Connect(function()
		self:Select()
	end)
	
	-- Hover effects
	clickButton.MouseEnter:Connect(function()
		if not self.Selected then
			Utilities.Tween(self.TabButton, {BackgroundTransparency = 0.9}, 0.2)
		end
	end)
	
	clickButton.MouseLeave:Connect(function()
		if not self.Selected then
			Utilities.Tween(self.TabButton, {BackgroundTransparency = 1}, 0.2)
		end
	end)
end

function Tab:Select()
	-- Deselect current tab
	if self.Window.ActiveTab and self.Window.ActiveTab ~= self then
		self.Window.ActiveTab:Deselect()
	end
	
	self.Selected = true
	self.Window.ActiveTab = self
	
	local theme = Centrixity.Theme
	
	-- Animate selection
	Utilities.Tween(self.TabButton, {BackgroundTransparency = 0.85}, 0.3)
	Utilities.Tween(self.IconLabel, {ImageColor3 = theme.Primary}, 0.3)
	Utilities.Tween(self.NameLabel, {TextColor3 = theme.TextPrimary}, 0.3)
	Utilities.Tween(self.SelectionIndicator, {Size = UDim2.new(0, 25, 0, 4)}, 0.3, Enum.EasingStyle.Back)
	
	-- Show page
	self.PageFrame.Visible = true
	
	-- Update SubPage header tabs
	self:_UpdateSubPageTabs()
	
	-- Select first subpage if exists
	if #self.SubPages > 0 and not self.ActiveSubPage then
		self.SubPages[1]:Select()
	end
end

function Tab:Deselect()
	self.Selected = false
	
	local theme = Centrixity.Theme
	
	-- Animate deselection
	Utilities.Tween(self.TabButton, {BackgroundTransparency = 1}, 0.3)
	Utilities.Tween(self.IconLabel, {ImageColor3 = theme.TextMuted}, 0.3)
	Utilities.Tween(self.NameLabel, {TextColor3 = theme.TextMuted}, 0.3)
	Utilities.Tween(self.SelectionIndicator, {Size = UDim2.new(0, 0, 0, 4)}, 0.3)
	
	-- Hide page
	self.PageFrame.Visible = false
end

function Tab:_UpdateSubPageTabs()
	-- Clear existing subpage tabs in header
	for _, child in ipairs(self.Window.SubPageTabContainer:GetChildren()) do
		if child:IsA("Frame") or child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	-- Create subpage tabs
	for _, subPage in ipairs(self.SubPages) do
		subPage:_CreateHeaderTab()
	end
end

function Tab:CreateSubPage(config)
	local subPage = SubPage.new(self, config)
	table.insert(self.SubPages, subPage)
	
	-- If this is the active tab, update header
	if self.Selected then
		self:_UpdateSubPageTabs()
		
		-- Select first subpage
		if #self.SubPages == 1 then
			subPage:Select()
		end
	end
	
	return subPage
end

-- ============================================
-- SUBPAGE CLASS
-- ============================================
SubPage = {}
SubPage.__index = SubPage

function SubPage.new(tab, config)
	local self = setmetatable({}, SubPage)
	
	self.Tab = tab
	self.Window = tab.Window
	self.Name = config.Name or "SubPage"
	self.Selected = false
	self.LayoutOrder = #tab.SubPages + 1
	self.Components = {}
	
	self:_CreateUI()
	
	return self
end

function SubPage:_CreateUI()
	local theme = Centrixity.Theme
	
	-- Section Container (left or right column)
	self.SectionFrame = Utilities.Create("Frame", {
		Name = "Section_" .. self.Name,
		Size = UDim2.new(0, 290, 0, 50),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.Background,
		ClipsDescendants = true,
		LayoutOrder = self.LayoutOrder,
		Parent = self.Tab.SubPageContainer
	})
	Utilities.AddCorner(self.SectionFrame, 8)
	
	-- Section Header
	self.SectionHeader = Utilities.Create("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = theme.BackgroundLight,
		Parent = self.SectionFrame
	})
	Utilities.AddCorner(self.SectionHeader, 8)
	
	-- Header accent line
	self.HeaderAccent = Utilities.Create("Frame", {
		Name = "Accent",
		Size = UDim2.new(0, 4, 0, 18),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 10, 0.5, 0),
		BackgroundColor3 = theme.Primary,
		BorderSizePixel = 0,
		Parent = self.SectionHeader
	})
	Utilities.AddCorner(self.HeaderAccent, 10)
	Utilities.CreateGradient(self.HeaderAccent, 90)
	
	-- Section Name
	self.SectionName = Utilities.Create("TextLabel", {
		Name = "SectionName",
		Text = self.Name,
		FontFace = theme.FontMedium,
		TextColor3 = theme.TextPrimary,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 22, 0.5, 0),
		Size = UDim2.new(1, -40, 1, 0),
		BackgroundTransparency = 1,
		Parent = self.SectionHeader
	})
	
	-- Component Holder
	self.ComponentHolder = Utilities.Create("Frame", {
		Name = "ComponentHolder",
		Position = UDim2.new(0, 0, 0, 32),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = self.SectionFrame
	})
	Utilities.AddPadding(self.ComponentHolder, 8, 10, 15, 10)
	Utilities.AddListLayout(self.ComponentHolder, 5)
end

function SubPage:_CreateHeaderTab()
	local theme = Centrixity.Theme
	
	-- SubPage Tab Button in header
	self.HeaderTab = Utilities.Create("Frame", {
		Name = "SubTab_" .. self.Name,
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		LayoutOrder = self.LayoutOrder,
		Parent = self.Window.SubPageTabContainer
	})
	
	-- Tab Name Button
	self.HeaderTabButton = Utilities.Create("TextButton", {
		Name = "TabButton",
		Text = self.Name,
		FontFace = self.Selected and theme.FontMedium or theme.Font,
		TextColor3 = self.Selected and theme.TextPrimary or theme.TextMuted,
		TextSize = 13,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, -8),
		BackgroundColor3 = theme.Primary,
		BackgroundTransparency = self.Selected and 0.85 or 1,
		Parent = self.HeaderTab
	})
	Utilities.AddCorner(self.HeaderTabButton, 5)
	Utilities.AddPadding(self.HeaderTabButton, 8, 12, 8, 12)
	
	-- Selection Indicator
	self.HeaderIndicator = Utilities.Create("Frame", {
		Name = "Indicator",
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, 2),
		Size = self.Selected and UDim2.new(0, 30, 0, 4) or UDim2.new(0, 0, 0, 4),
		BackgroundColor3 = theme.Primary,
		BorderSizePixel = 0,
		Parent = self.HeaderTab
	})
	Utilities.AddCorner(self.HeaderIndicator, 10)
	Utilities.CreateGradient(self.HeaderIndicator, 0)
	
	-- Click handler
	self.HeaderTabButton.MouseButton1Click:Connect(function()
		self:Select()
	end)
	
	-- Hover effects
	self.HeaderTabButton.MouseEnter:Connect(function()
		if not self.Selected then
			Utilities.Tween(self.HeaderTabButton, {BackgroundTransparency = 0.9}, 0.2)
		end
	end)
	
	self.HeaderTabButton.MouseLeave:Connect(function()
		if not self.Selected then
			Utilities.Tween(self.HeaderTabButton, {BackgroundTransparency = 1}, 0.2)
		end
	end)
end

function SubPage:Select()
	-- Deselect current subpage
	if self.Tab.ActiveSubPage and self.Tab.ActiveSubPage ~= self then
		self.Tab.ActiveSubPage:Deselect()
	end
	
	self.Selected = true
	self.Tab.ActiveSubPage = self
	
	local theme = Centrixity.Theme
	
	-- Animate header tab
	if self.HeaderTabButton then
		Utilities.Tween(self.HeaderTabButton, {BackgroundTransparency = 0.85, TextColor3 = theme.TextPrimary}, 0.3)
		self.HeaderTabButton.FontFace = theme.FontMedium
	end
	if self.HeaderIndicator then
		Utilities.Tween(self.HeaderIndicator, {Size = UDim2.new(0, 30, 0, 4)}, 0.3, Enum.EasingStyle.Back)
	end
	
	-- Show section
	self.SectionFrame.Visible = true
end

function SubPage:Deselect()
	self.Selected = false
	
	local theme = Centrixity.Theme
	
	-- Animate header tab
	if self.HeaderTabButton then
		Utilities.Tween(self.HeaderTabButton, {BackgroundTransparency = 1, TextColor3 = theme.TextMuted}, 0.3)
		self.HeaderTabButton.FontFace = theme.Font
	end
	if self.HeaderIndicator then
		Utilities.Tween(self.HeaderIndicator, {Size = UDim2.new(0, 0, 0, 4)}, 0.3)
	end
end

-- ============================================
-- TOGGLE COMPONENT
-- ============================================
function SubPage:AddToggle(config)
	config = config or {}
	local theme = Centrixity.Theme
	
	local toggle = {
		Name = config.Name or "Toggle",
		Value = config.Default or false,
		Callback = config.Callback or function() end,
		Flag = config.Flag,
	}
	
	-- Toggle Container
	toggle.Frame = Utilities.Create("Frame", {
		Name = "Toggle_" .. toggle.Name,
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundTransparency = 1,
		LayoutOrder = #self.Components + 1,
		Parent = self.ComponentHolder
	})
	
	-- Toggle Checkbox
	toggle.Checkbox = Utilities.Create("Frame", {
		Name = "Checkbox",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, 18, 0, 18),
		BackgroundColor3 = toggle.Value and theme.Primary or theme.BackgroundLight,
		BorderSizePixel = 0,
		Parent = toggle.Frame
	})
	Utilities.AddCorner(toggle.Checkbox, 4)
	
	toggle.CheckboxStroke = Utilities.AddStroke(toggle.Checkbox, toggle.Value and theme.Primary or theme.Border, 1)
	
	-- Checkmark Icon
	toggle.Checkmark = Utilities.Create("ImageLabel", {
		Name = "Checkmark",
		Image = "rbxassetid://7733715400",
		ImageColor3 = theme.Background,
		ImageTransparency = toggle.Value and 0 or 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 12, 0, 12),
		BackgroundTransparency = 1,
		Parent = toggle.Checkbox
	})
	
	-- Gradient for active state
	toggle.Gradient = Utilities.CreateGradient(toggle.Checkbox, 90, theme.Primary, theme.Secondary)
	toggle.Gradient.Enabled = toggle.Value
	
	-- Toggle Label
	toggle.Label = Utilities.Create("TextLabel", {
		Name = "Label",
		Text = toggle.Name,
		FontFace = theme.Font,
		TextColor3 = toggle.Value and theme.TextPrimary or theme.TextMuted,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 28, 0.5, 0),
		Size = UDim2.new(1, -28, 1, 0),
		BackgroundTransparency = 1,
		Parent = toggle.Frame
	})
	
	-- Click Handler
	toggle.Button = Utilities.Create("TextButton", {
		Name = "ClickHandler",
		Text = "",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = toggle.Frame
	})
	
	-- Toggle Function
	function toggle:Set(value, skipCallback)
		self.Value = value
		
		-- Animate checkbox
		if value then
			self.Gradient.Enabled = true
			Utilities.Tween(self.Checkbox, {BackgroundColor3 = theme.Primary}, 0.2)
			Utilities.Tween(self.CheckboxStroke, {Color = theme.Primary}, 0.2)
			Utilities.Tween(self.Checkmark, {ImageTransparency = 0}, 0.2)
			Utilities.Tween(self.Label, {TextColor3 = theme.TextPrimary}, 0.2)
		else
			Utilities.Tween(self.Checkbox, {BackgroundColor3 = theme.BackgroundLight}, 0.2)
			Utilities.Tween(self.CheckboxStroke, {Color = theme.Border}, 0.2)
			Utilities.Tween(self.Checkmark, {ImageTransparency = 1}, 0.2)
			Utilities.Tween(self.Label, {TextColor3 = theme.TextMuted}, 0.2)
			task.delay(0.2, function()
				if not self.Value then
					self.Gradient.Enabled = false
				end
			end)
		end
		
		-- Execute callback with error handling
		if not skipCallback then
			local success, err = pcall(function()
				self.Callback(value)
			end)
			
			if not success then
				-- Show error notification
				Centrixity:Notify({
					Type = "Error",
					Title = "Error Caught",
					Message = tostring(err),
					Duration = 6
				})
			end
		end
	end
	
	-- Click event
	toggle.Button.MouseButton1Click:Connect(function()
		toggle:Set(not toggle.Value)
	end)
	
	-- Hover effects
	toggle.Button.MouseEnter:Connect(function()
		Utilities.Tween(toggle.Checkbox, {Size = UDim2.new(0, 20, 0, 20)}, 0.15)
	end)
	
	toggle.Button.MouseLeave:Connect(function()
		Utilities.Tween(toggle.Checkbox, {Size = UDim2.new(0, 18, 0, 18)}, 0.15)
	end)
	
	-- Store component
	table.insert(self.Components, toggle)
	
	return toggle
end

function SubPage:AddSlider(config)
	-- TODO: Implement slider
	return {}
end

function SubPage:AddButton(config)
	-- TODO: Implement button
	return {}
end

function SubPage:AddDropdown(config)
	-- TODO: Implement dropdown
	return {}
end

function SubPage:AddKeybind(config)
	-- TODO: Implement keybind
	return {}
end

-- ============================================
-- NOTIFICATION SYSTEM
-- ============================================
-- ============================================
-- NOTIFICATION SYSTEM (PREMIUM VERSION)
-- ============================================
function Centrixity:Notify(config)
	config = config or {}
	local notifType = config.Type or "Info"
	local title = config.Title or "Notification"
	local message = config.Message or "No message provided."
	local duration = config.Duration or 6
	
	local theme = self.Theme
	
	-- Notification-specific configuration based on type
	local typeData = {
		Info = {
			AccentColor = theme.Primary,
			SecondaryColor = theme.Secondary,
			Icon = "rbxassetid://7733960981",
		},
		Success = {
			AccentColor = theme.Success,
			SecondaryColor = Color3.fromRGB(45, 200, 95),
			Icon = "rbxassetid://7733715400",
		},
		Error = {
			AccentColor = theme.Error,
			SecondaryColor = Color3.fromRGB(220, 50, 50),
			Icon = "rbxassetid://7733658504",
		},
		Warning = {
			AccentColor = theme.Warning,
			SecondaryColor = Color3.fromRGB(255, 160, 50),
			Icon = "rbxassetid://7733964719",
		}
	}
	
	local data = typeData[notifType] or typeData.Info
	
	-- Notification Manager GUI setup
	if not self._NotifGui then
		self._NotifGui = Utilities.Create("ScreenGui", {
			Name = "CentrixityNotifications",
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ResetOnSpawn = false,
		})
		
		-- Try to parent to CoreGui for executor compatibility
		local success = pcall(function()
			self._NotifGui.Parent = game:GetService("CoreGui")
		end)
		
		if not success then
			self._NotifGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
		end
		
		self._NotifHolder = Utilities.Create("Frame", {
			Name = "NotificationHolder",
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -30, 1, -30),
			Size = UDim2.new(0, 310, 0, 700),
			BackgroundTransparency = 1,
			Parent = self._NotifGui
		})
		
		Utilities.AddListLayout(self._NotifHolder, 12, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Right)
		self._NotifHolder.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	end
	
	-- Notification Wrapper (to maintain layout space)
	local wrapper = Utilities.Create("Frame", {
		Name = "Wrapper",
		Size = UDim2.new(0, 310, 0, 0), -- Animated height
		BackgroundTransparency = 1,
		Parent = self._NotifHolder
	})
	
	-- The Actual Notification Card
	local card = Utilities.Create("Frame", {
		Name = "Notification",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(1.2, 0, 0, 0), -- Start offscreen right
		BackgroundColor3 = theme.Background,
		BackgroundTransparency = 0.05, -- Slight transparency for "premium" look
		ClipsDescendants = false,
		Parent = wrapper
	})
	
	Utilities.AddCorner(card, 12)
	local stroke = Utilities.AddStroke(card, theme.Border, 1.2)
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	
	-- Accent Bar (The "Glow" indicator on the left)
	local accent = Utilities.Create("Frame", {
		Name = "Accent",
		Size = UDim2.new(0, 4, 1, -16),
		Position = UDim2.new(0, 4, 0, 8),
		BackgroundColor3 = data.AccentColor,
		BorderSizePixel = 0,
		Parent = card
	})
	
	Utilities.AddCorner(accent, 10)
	Utilities.CreateGradient(accent, 90, data.AccentColor, data.SecondaryColor)
	
	-- Content Area
	local content = Utilities.Create("Frame", {
		Name = "Content",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = card
	})
	
	Utilities.AddPadding(content, 18, 20, 22, 24) -- Generous spacing
	
	-- Header Area
	local header = Utilities.Create("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		Parent = content
	})
	
	local headerLayout = Utilities.AddListLayout(header, 10, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left)
	headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	
	-- Icon with Gradient
	local iconFrame = Utilities.Create("Frame", {
		Size = UDim2.new(0, 20, 0, 20),
		BackgroundTransparency = 1,
		Parent = header
	})
	
	local icon = Utilities.Create("ImageLabel", {
		Name = "Icon",
		Image = data.Icon,
		ImageColor3 = data.AccentColor,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = iconFrame
	})
	
	Utilities.CreateGradient(icon, 90, data.AccentColor, data.SecondaryColor)
	
	-- Title
	local titleLabel = Utilities.Create("TextLabel", {
		Name = "Title",
		Text = title,
		FontFace = theme.FontSemiBold,
		TextColor3 = theme.TextPrimary,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -30, 1, 0),
		BackgroundTransparency = 1,
		Parent = header
	})
	
	-- Message Content
	local messageLabel = Utilities.Create("TextLabel", {
		Name = "Message",
		Text = message,
		RichText = true,
		FontFace = theme.Font,
		TextColor3 = theme.TextSecondary,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Position = UDim2.new(0, 0, 0, 32),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = content
	})
	
	-- Progress Bar (at the very bottom)
	local progressContainer = Utilities.Create("Frame", {
		Name = "ProgressContainer",
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, 0),
		Size = UDim2.new(1, -24, 0, 3),
		BackgroundColor3 = theme.BackgroundDark,
		BorderSizePixel = 0,
		Parent = card
	})
	Utilities.AddPadding(progressContainer, 0, 0, 8, 0) -- Lift it up slightly
	
	local progressBG = Utilities.Create("Frame", {
		Name = "BG",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = theme.BackgroundLight,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Parent = progressContainer
	})
	Utilities.AddCorner(progressBG, 4)
	
	local progressFill = Utilities.Create("Frame", {
		Name = "Fill",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = data.AccentColor,
		BorderSizePixel = 0,
		Parent = progressBG
	})
	Utilities.AddCorner(progressFill, 4)
	Utilities.CreateGradient(progressFill, 0, data.AccentColor, data.SecondaryColor)
	
	-- Interactive Button (for manual dismissal)
	local btn = Utilities.Create("TextButton", {
		Name = "Dismiss",
		Text = "",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 10,
		Parent = card
	})
	
	-- Logic Variables
	local isDismissed = false
	local progressTween
	
	-- Function: Dismiss
	local function doDismiss()
		if isDismissed then return end
		isDismissed = true
		
		if progressTween then progressTween:Cancel() end
		
		-- Animate out
		Utilities.Tween(card, {Position = UDim2.new(1.3, 0, 0, 0)}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		
		task.delay(0.4, function()
			Utilities.Tween(wrapper, {Size = UDim2.new(0, 310, 0, 0)}, 0.3)
			task.delay(0.35, function()
				wrapper:Destroy()
			end)
		end)
	end
	
	-- Entrance Logic
	task.spawn(function()
		-- Measure height first after parenting
		task.wait(0.05)
		local targetHeight = card.AbsoluteSize.Y
		
		-- Animate wrapper height expansion
		Utilities.Tween(wrapper, {Size = UDim2.new(0, 310, 0, targetHeight)}, 0.4, Enum.EasingStyle.Quart)
		
		-- Animate card sliding in
		task.wait(0.1)
		local slideTween = Utilities.Tween(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		
		slideTween.Completed:Connect(function()
			-- Start progress depletion
			progressTween = Utilities.Tween(progressFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
			progressTween.Completed:Connect(function()
				if not isDismissed then doDismiss() end
			end)
		end)
	end)
	
	-- Event Listeners
	btn.MouseButton1Click:Connect(doDismiss)
	
	btn.MouseEnter:Connect(function()
		if not isDismissed then
			Utilities.Tween(stroke, {Color = theme.Primary, Thickness = 1.5}, 0.2)
		end
	end)
	
	btn.MouseLeave:Connect(function()
		if not isDismissed then
			Utilities.Tween(stroke, {Color = theme.Border, Thickness = 1.2}, 0.2)
		end
	end)
end

-- ============================================
-- MAIN ENTRY POINT
-- ============================================
function Centrixity:CreateWindow(config)
	config = config or {}
	local window = Window.new(self, config)
	
	-- Store reference for notifications
	self._ScreenGui = window.ScreenGui
	
	return window
end

-- Return the library
return Centrixity
