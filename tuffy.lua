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

-- Library Configuration
Centrixity.Notifications = {
	Enabled = true,
	Duration = 6,
}
Centrixity.ThreadFix = true

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

function Window:AddTab(config)
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
	Utilities.AddPadding(self.SubPageContainer, 10, 12, 10, 12)
	Utilities.AddListLayout(self.SubPageContainer, 12, Enum.FillDirection.Vertical)
	
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

function Tab:AddSubPage(config)
	local subPage = SubPage.new(self, config)
	table.insert(self.SubPages, subPage)
	
	-- If this is the active tab, update header
	if self.Selected then
		self:_UpdateSubPageTabs()
		
		-- Ensure only the first subpage is visible if it's currently selected
		if #self.SubPages == 1 then
			subPage:Select()
		else
			subPage.SectionFrame.Visible = false
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
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.BackgroundLight,
		BackgroundTransparency = 0.4, -- Subtle background for sections
		ClipsDescendants = true,
		LayoutOrder = self.LayoutOrder,
		Visible = false,
		Parent = self.Tab.SubPageContainer
	})
	Utilities.AddCorner(self.SectionFrame, 8)
	Utilities.AddStroke(self.SectionFrame, theme.Border, 1)
	
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
	Utilities.AddPadding(self.ComponentHolder, 4, 10, 8, 10)
	Utilities.AddListLayout(self.ComponentHolder, 4)
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
	
	-- Hide section frame
	self.SectionFrame.Visible = false
	
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
		Size = UDim2.new(1, 0, 0, 28),
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
		if self.Value == value then return end -- Strict check to prevent double-firing
		self.Value = value
		
		-- Animate UI
		local targetColor = value and theme.Primary or theme.BackgroundLight
		local targetStroke = value and theme.Primary or theme.Border
		local targetIconTrans = value and 0 or 1
		local targetText = value and theme.TextPrimary or theme.TextMuted
		
		if value then self.Gradient.Enabled = true end
		
		Utilities.Tween(self.Checkbox, {BackgroundColor3 = targetColor}, 0.2)
		Utilities.Tween(self.CheckboxStroke, {Color = targetStroke}, 0.2)
		Utilities.Tween(self.Checkmark, {ImageTransparency = targetIconTrans}, 0.2)
		Utilities.Tween(self.Label, {TextColor3 = targetText}, 0.2)
		
		if not value then
			task.delay(0.2, function()
				if not self.Value then self.Gradient.Enabled = false end
			end)
		end
		
		-- Callback logic
		if not skipCallback then
			task.spawn(function()
				local success, err = pcall(self.Callback, value)
				if not success then
					Centrixity:Notify({Type = "Error", Title = "Toggle Error", Message = tostring(err)})
				end
			end)
		end
	end
	
	-- Click event with simple debounce
	local lastClick = 0
	toggle.Button.MouseButton1Down:Connect(function()
		if tick() - lastClick < 0.2 then return end -- Debounce
		lastClick = tick()
		toggle:Set(not toggle.Value)
	end)
	
	-- Hover effects (Color/Transparency highlight)
	toggle.Button.MouseEnter:Connect(function()
		Utilities.Tween(toggle.Frame, {BackgroundTransparency = 0.95}, 0.2)
		Utilities.Tween(toggle.CheckboxStroke, {Thickness = 1.5}, 0.2)
	end)
	
	toggle.Button.MouseLeave:Connect(function()
		Utilities.Tween(toggle.Frame, {BackgroundTransparency = 1}, 0.2)
		Utilities.Tween(toggle.CheckboxStroke, {Thickness = 1}, 0.2)
	end)
	
	table.insert(self.Components, toggle)
	return toggle
end

function SubPage:AddSlider(config)
	config = config or {}
	local theme = Centrixity.Theme
	
	local slider = {
		Name = config.Name or "Slider",
		Min = config.Min or 0,
		Max = config.Max or 100,
		Value = config.Default or config.Min or 0,
		Callback = config.Callback or function() end,
		Precision = config.Precision or 0,
		Dragging = false
	}
	
	-- Container
	slider.Frame = Utilities.Create("Frame", {
		Name = "Slider_" .. slider.Name,
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundTransparency = 1,
		LayoutOrder = #self.Components + 1,
		Parent = self.ComponentHolder
	})
	
	slider.Label = Utilities.Create("TextLabel", {
		Text = slider.Name,
		FontFace = theme.Font,
		TextColor3 = theme.TextSecondary,
		TextSize = 13,
		Position = UDim2.new(0, 5, 0, 0),
		Size = UDim2.new(0.6, 0, 0, 20),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Parent = slider.Frame
	})
	
	slider.ValueDisplay = Utilities.Create("TextLabel", {
		Text = tostring(slider.Value),
		FontFace = theme.FontMedium,
		TextColor3 = theme.Primary,
		TextSize = 12,
		Position = UDim2.new(0.6, 0, 0, 0),
		Size = UDim2.new(0.4, -5, 0, 20),
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundTransparency = 1,
		Parent = slider.Frame
	})
	
	-- Track
	slider.Track = Utilities.Create("Frame", {
		Name = "Track",
		Position = UDim2.new(0, 5, 0, 26),
		Size = UDim2.new(1, -10, 0, 4),
		BackgroundColor3 = theme.BackgroundLight,
		BorderSizePixel = 0,
		Parent = slider.Frame
	})
	Utilities.AddCorner(slider.Track, 4)
	Utilities.AddStroke(slider.Track, theme.Border, 1)
	
	-- Fill
	slider.Fill = Utilities.Create("Frame", {
		Name = "Fill",
		Size = UDim2.fromScale((slider.Value - slider.Min) / (slider.Max - slider.Min), 1),
		BackgroundColor3 = theme.Primary,
		BorderSizePixel = 0,
		Parent = slider.Track
	})
	Utilities.AddCorner(slider.Fill, 4)
	Utilities.CreateGradient(slider.Fill, 0)
	
	-- Knob
	slider.Knob = Utilities.Create("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale((slider.Value - slider.Min) / (slider.Max - slider.Min), 0.5),
		Size = UDim2.fromOffset(12, 12),
		BackgroundColor3 = theme.TextPrimary,
		BorderSizePixel = 0,
		Parent = slider.Track
	})
	Utilities.AddCorner(slider.Knob, 12)
	Utilities.AddStroke(slider.Knob, theme.Primary, 2)

	-- Logic
	local function update(input)
		local pos = math.clamp((input.Position.X - slider.Track.AbsolutePosition.X) / slider.Track.AbsoluteSize.X, 0, 1)
		local rawValue = pos * (slider.Max - slider.Min) + slider.Min
		local value = math.floor(rawValue * (10 ^ slider.Precision) + 0.5) / (10 ^ slider.Precision)
		
		slider.Value = value
		slider.ValueDisplay.Text = tostring(value)
		Utilities.Tween(slider.Fill, {Size = UDim2.fromScale(pos, 1)}, 0.1)
		Utilities.Tween(slider.Knob, {Position = UDim2.fromScale(pos, 0.5)}, 0.1)
		
		task.spawn(slider.Callback, value)
	end
	
	slider.Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			slider.Dragging = true
			update(input)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			slider.Dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if slider.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)
	
	table.insert(self.Components, slider)
	return slider
end

function SubPage:AddButton(config)
	config = config or {}
	local theme = Centrixity.Theme
	
	local button = {
		Name = config.Name or "Button",
		Callback = config.Callback or function() end,
	}
	
	-- Button Frame
	button.Frame = Utilities.Create("Frame", {
		Name = "Button_" .. button.Name,
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = theme.BackgroundLight,
		BackgroundTransparency = 0,
		LayoutOrder = #self.Components + 1,
		Parent = self.ComponentHolder
	})
	Utilities.AddCorner(button.Frame, 6)
	button.Stroke = Utilities.AddStroke(button.Frame, theme.Border, 1)
	
	-- Highlight/Fill for hover
	button.Highlight = Utilities.Create("Frame", {
		Name = "Highlight",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = theme.Primary,
		BackgroundTransparency = 1,
		Parent = button.Frame
	})
	Utilities.AddCorner(button.Highlight, 6)
	
	-- Label
	button.Label = Utilities.Create("TextLabel", {
		Name = "Label",
		Text = button.Name,
		FontFace = theme.FontMedium,
		TextColor3 = theme.TextPrimary,
		TextSize = 13,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = button.Frame
	})
	
	-- Icon (Optional)
	if config.Icon then
		button.Label.Position = UDim2.new(0, 30, 0, 0)
		button.Label.Size = UDim2.new(1, -30, 1, 0)
		button.Label.TextXAlignment = Enum.TextXAlignment.Left
		
		button.Icon = Utilities.Create("ImageLabel", {
			Name = "Icon",
			Image = config.Icon,
			Size = UDim2.fromOffset(18, 18),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 8, 0.5, 0),
			BackgroundTransparency = 1,
			ImageColor3 = theme.TextPrimary,
			Parent = button.Frame
		})
	end
	
	-- Click Handler
	button.Trigger = Utilities.Create("TextButton", {
		Name = "Trigger",
		Text = "",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = button.Frame
	})
	
	-- Events
	button.Trigger.MouseEnter:Connect(function()
		Utilities.Tween(button.Frame, {BackgroundColor3 = theme.BackgroundLight:Lerp(Color3.new(1,1,1), 0.05)}, 0.2)
		Utilities.Tween(button.Stroke, {Color = theme.Primary, Transparency = 0.5}, 0.2)
		Utilities.Tween(button.Highlight, {BackgroundTransparency = 0.95}, 0.2)
	end)
	
	button.Trigger.MouseLeave:Connect(function()
		Utilities.Tween(button.Frame, {BackgroundColor3 = theme.BackgroundLight}, 0.2)
		Utilities.Tween(button.Stroke, {Color = theme.Border, Transparency = 0}, 0.2)
		Utilities.Tween(button.Highlight, {BackgroundTransparency = 1}, 0.2)
	end)
	
	button.Trigger.MouseButton1Down:Connect(function()
		Utilities.Tween(button.Highlight, {BackgroundTransparency = 0.85}, 0.1)
		Utilities.Tween(button.Frame, {Size = UDim2.new(1, -4, 0, 32), Position = UDim2.new(0, 2, 0, 1)}, 0.1)
	end)
	
	button.Trigger.MouseButton1Up:Connect(function()
		Utilities.Tween(button.Highlight, {BackgroundTransparency = 0.95}, 0.1)
		Utilities.Tween(button.Frame, {Size = UDim2.new(1, 0, 0, 34), Position = UDim2.new(0, 0, 0, 0)}, 0.1)
		
		-- Callback
		task.spawn(function()
			local success, err = pcall(button.Callback)
			if not success then
				Centrixity:Notify({
					Type = "Error",
					Title = "Button Callback Error",
					Message = tostring(err),
					Duration = 6
				})
			end
		end)
	end)
	
	table.insert(self.Components, button)
	return button
end

function SubPage:AddDropdown(config)
	config = config or {}
	local theme = Centrixity.Theme
	local window = self.Window
	
	local dropdown = {
		Name = config.Name or "Dropdown",
		Options = config.Options or {},
		Selected = config.Default or (config.Multi and {} or ""),
		Multi = config.Multi or false,
		Callback = config.Callback or function() end,
		Open = false,
		OptionFrames = {},
	}
	
	-- Main Button Container
	dropdown.Frame = Utilities.Create("Frame", {
		Name = "Dropdown_" .. dropdown.Name,
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = theme.BackgroundDark,
		BorderSizePixel = 0,
		LayoutOrder = #self.Components + 1,
		Parent = self.ComponentHolder
	})
	Utilities.AddCorner(dropdown.Frame, 6)
	dropdown.Stroke = Utilities.AddStroke(dropdown.Frame, theme.Border, 1)
	
	-- Dropdown Label
	dropdown.Label = Utilities.Create("TextLabel", {
		Text = dropdown.Name,
		FontFace = theme.Font,
		TextColor3 = theme.TextPrimary,
		TextSize = 13,
		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(0.5, 0, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Parent = dropdown.Frame
	})
	
	-- Current Value Label
	dropdown.ValueLabel = Utilities.Create("TextLabel", {
		Text = "None",
		FontFace = theme.Font,
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(0.5, -30, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundTransparency = 1,
		Parent = dropdown.Frame
	})
	
	-- Arrow Icon
	dropdown.Icon = Utilities.Create("ImageLabel", {
		Image = "rbxassetid://130510528659103", -- Modern Chevron
		ImageColor3 = theme.TextMuted,
		Size = UDim2.fromOffset(14, 14),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		BackgroundTransparency = 1,
		Parent = dropdown.Frame
	})
	
	-- Trigger Button
	dropdown.Trigger = Utilities.Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		Parent = dropdown.Frame
	})
	
	-- List Overlay (Global Layer for absolute positioning)
	if not window._DropdownLayer then
		window._DropdownLayer = Utilities.Create("Frame", {
			Name = "DropdownOverlay",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ZIndex = 110,
			Parent = window.ScreenGui
		})
	end

	dropdown.List = Utilities.Create("Frame", {
		Name = "List_" .. dropdown.Name,
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(20, 21, 26),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Visible = false,
		ZIndex = 110,
		Parent = window._DropdownLayer
	})
	Utilities.AddCorner(dropdown.List, 6)
	Utilities.AddStroke(dropdown.List, theme.Border, 1)
	
	-- Search Container
	dropdown.SearchFrame = Utilities.Create("Frame", {
		Name = "SearchField",
		Size = UDim2.new(1, -12, 0, 28),
		Position = UDim2.new(0, 6, 0, 6),
		BackgroundColor3 = Color3.fromRGB(25, 26, 31),
		BorderSizePixel = 0,
		Parent = dropdown.List
	})
	Utilities.AddCorner(dropdown.SearchFrame, 4)
	Utilities.AddStroke(dropdown.SearchFrame, theme.Border, 1)
	
	dropdown.Search = Utilities.Create("TextBox", {
		PlaceholderText = "Search...",
		PlaceholderColor3 = theme.TextMuted,
		Text = "",
		FontFace = theme.Font,
		TextSize = 12,
		TextColor3 = theme.TextPrimary,
		Size = UDim2.new(1, -20, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = dropdown.SearchFrame
	})
	
	-- Scrolling Area
	dropdown.Scroll = Utilities.Create("ScrollingFrame", {
		Name = "Scroll",
		Size = UDim2.new(1, 0, 1, -40),
		Position = UDim2.new(0, 0, 0, 40),
		BackgroundTransparency = 1,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = theme.Primary,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = dropdown.List
	})
	local listLayout = Utilities.AddListLayout(dropdown.Scroll, 4)
	Utilities.AddPadding(dropdown.Scroll, 6, 6, 6, 6)
	
	local function updateValueLabel()
		if dropdown.Multi then
			local count = 0
			for _, v in pairs(dropdown.Selected) do if v then count = count + 1 end end
			dropdown.ValueLabel.Text = count > 0 and (count .. " Selected") or "None"
			dropdown.ValueLabel.TextColor3 = count > 0 and theme.Primary or theme.TextMuted
		else
			dropdown.ValueLabel.Text = (tostring(dropdown.Selected) ~= "") and tostring(dropdown.Selected) or "None"
			dropdown.ValueLabel.TextColor3 = (tostring(dropdown.Selected) ~= "") and theme.Primary or theme.TextMuted
		end
	end
	
	function dropdown:AddOption(name)
		local option = {}
		option.Frame = Utilities.Create("TextButton", {
			Text = "",
			Size = UDim2.new(1, 0, 0, 28),
			BackgroundColor3 = theme.Background,
			BackgroundTransparency = 1,
			Parent = dropdown.Scroll
		})
		Utilities.AddCorner(option.Frame, 4)
		
		option.Label = Utilities.Create("TextLabel", {
			Text = name,
			FontFace = theme.Font,
			TextColor3 = theme.TextSecondary,
			TextSize = 12,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(1, -35, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Parent = option.Frame
		})
		
		option.Check = Utilities.Create("ImageLabel", {
			Image = "rbxassetid://130510503527263", -- Check icon
			ImageColor3 = theme.Primary,
			Size = UDim2.fromOffset(12, 12),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0),
			BackgroundTransparency = 1,
			ImageTransparency = 1,
			Parent = option.Frame
		})
		
		local function refresh()
			local isSelected = dropdown.Multi and dropdown.Selected[name] or (dropdown.Selected == name)
			Utilities.Tween(option.Label, {TextColor3 = isSelected and theme.TextPrimary or theme.TextSecondary}, 0.2)
			Utilities.Tween(option.Check, {ImageTransparency = isSelected and 0 or 1}, 0.2)
			Utilities.Tween(option.Frame, {BackgroundTransparency = isSelected and 0.9 or 1, BackgroundColor3 = isSelected and theme.Primary or theme.Background}, 0.2)
		end
		
		option.Frame.MouseButton1Click:Connect(function()
			if dropdown.Multi then
				dropdown.Selected[name] = not dropdown.Selected[name]
			else
				dropdown.Selected = name
				dropdown:Toggle(false)
			end
			for _, o in pairs(dropdown.OptionFrames) do o.Refresh() end
			updateValueLabel()
			task.spawn(dropdown.Callback, dropdown.Selected)
		end)
		
		option.Refresh = refresh
		dropdown.OptionFrames[name] = option
		refresh()
	end
	
	local positionLoop
	function dropdown:Toggle(state)
		self.Open = (state ~= nil) and state or not self.Open
		
		if self.Open then
			if window._ActiveDropdown and window._ActiveDropdown ~= self then
				window._ActiveDropdown:Toggle(false)
			end
			window._ActiveDropdown = self
			
			dropdown.List.Visible = true
			local function updatePos()
				local absPos = dropdown.Frame.AbsolutePosition
				dropdown.List.Position = UDim2.new(0, absPos.X, 0, absPos.Y + 38)
				dropdown.List.Size = UDim2.new(0, dropdown.Frame.AbsoluteSize.X, 0, dropdown.List.Size.Y.Offset)
			end
			updatePos()
			positionLoop = RunService.RenderStepped:Connect(updatePos)
			
			Utilities.Tween(dropdown.List, {Size = UDim2.new(0, dropdown.Frame.AbsoluteSize.X, 0, 160)}, 0.4, Enum.EasingStyle.Quart)
			Utilities.Tween(dropdown.Icon, {Rotation = 180, ImageColor3 = theme.Primary}, 0.3)
		else
			if window._ActiveDropdown == self then window._ActiveDropdown = nil end
			if positionLoop then positionLoop:Disconnect() positionLoop = nil end
			
			Utilities.Tween(dropdown.List, {Size = UDim2.new(0, dropdown.Frame.AbsoluteSize.X, 0, 0)}, 0.3, Enum.EasingStyle.Quart).Completed:Connect(function()
				if not self.Open then dropdown.List.Visible = false end
			end)
			Utilities.Tween(dropdown.Icon, {Rotation = 0, ImageColor3 = theme.TextMuted}, 0.3)
		end
	end
	
	dropdown.Trigger.MouseButton1Click:Connect(function() dropdown:Toggle() end)
	
	dropdown.Search:GetPropertyChangedSignal("Text"):Connect(function()
		local q = dropdown.Search.Text:lower()
		for n, f in pairs(dropdown.OptionFrames) do f.Frame.Visible = n:lower():find(q) ~= nil end
	end)
	
	for _, v in ipairs(dropdown.Options) do dropdown:AddOption(v) end
	updateValueLabel()
	
	table.insert(self.Components, dropdown)
	return dropdown
end

function SubPage:AddKeybind(config)
	-- TODO: Implement keybind
	return {}
end

-- ============================================
-- NOTIFICATION SYSTEM
-- ============================================
-- NOTIFICATION SYSTEM (REFINED)
-- ============================================
-- ============================================
-- NOTIFICATION SYSTEM (REWRITTEN & POLISHED)
-- ============================================
function Centrixity:Notify(title, text, duration, notifType)
	-- Support for config table or positional arguments
	if type(title) == "table" then
		local config = title
		title = config.Title or "Notification"
		text = config.Message or config.Text or "No message provided."
		duration = config.Duration or 6
		notifType = config.Type or "Info"
	end
	
	duration = duration or 6
	notifType = notifType or "Info"
	local theme = self.Theme

	-- Type Data
	local typeData = {
		Success = {
			Color = Color3.fromRGB(47, 255, 0),
			Icon = "rbxassetid://92431556586885"
		},
		Warning = {
			Color = Color3.fromRGB(255, 214, 10),
			Icon = "rbxassetid://70479764730792"
		},
		Error = {
			Color = Color3.fromRGB(255, 50, 56),
			Icon = "rbxassetid://70479764730792"
		}
	}
	local data = typeData[notifType] or typeData.Success
	
	-- Manager GUI
	if not self._NotifGui then
		self._NotifGui = Utilities.Create("ScreenGui", {
			Name = "Notifcations",
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ResetOnSpawn = false,
		})
		
		pcall(function() self._NotifGui.Parent = game:GetService("CoreGui") end)
		if not self._NotifGui.Parent then
			self._NotifGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
		end
		
		self._NotifHolder = Utilities.Create("Frame", {
			Name = "NotificationHolder",
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, 0, 1, 0),
			Size = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Parent = self._NotifGui
		})
		
		Utilities.AddListLayout(self._NotifHolder, 12, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Right)
		self._NotifHolder.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		Utilities.AddPadding(self._NotifHolder, 12, 12, 12, 12)
	end

	-- Notification Main Frame
	local notification = Utilities.Create("Frame", {
		Name = "Notification",
		ClipsDescendants = true,
		Size = UDim2.new(0, 1, 0, 30),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(16, 17, 21),
		BorderSizePixel = 0,
		Parent = self._NotifHolder
	})
	Utilities.AddCorner(notification, 8)
	Utilities.AddListLayout(notification, 0)
	
	-- Position for entry animation
	notification.Position = UDim2.new(1.5, 0, 0, 0)

	-- 1. Header Section
	local header = Utilities.Create("Frame", {
		Name = "Header",
		Size = UDim2.new(0, 1, 0, 30),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(16, 17, 21),
		BorderSizePixel = 0,
		Parent = notification
	})
	Utilities.AddCorner(header, 8)
	Utilities.AddPadding(header, 4, 4, 4, 6)
	Utilities.AddListLayout(header, 24, Enum.FillDirection.Horizontal).VerticalAlignment = Enum.VerticalAlignment.Center

	-- Left Side: Icon & Title
	local holder = Utilities.Create("Frame", {
		Name = "Holder",
		Size = UDim2.new(0, 64, 0, 30),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Parent = header
	})
	Utilities.AddListLayout(holder, 2, Enum.FillDirection.Horizontal)

	local iconHolder = Utilities.Create("Frame", {
		Name = "IconHolder",
		Size = UDim2.fromOffset(30, 30),
		BackgroundTransparency = 1,
		Parent = holder
	})
	Utilities.Create("ImageLabel", {
		Image = data.Icon,
		ImageColor3 = data.Color,
		Size = UDim2.fromOffset(20, 20),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1,
		Parent = iconHolder
	})

	local titleHolder = Utilities.Create("Frame", {
		Name = "TitleHolder",
		Size = UDim2.new(0, 1, 0, 30),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Parent = holder
	})
	Utilities.AddListLayout(titleHolder, 0, Enum.FillDirection.Horizontal).VerticalAlignment = Enum.VerticalAlignment.Center
	Utilities.Create("TextLabel", {
		Name = "Title",
		Text = title,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular),
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 14,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		RichText = true,
		Parent = titleHolder
	})

	-- Right Side: Control Buttons
	local controlHolder = Utilities.Create("Frame", {
		Name = "ControlHolder",
		Size = UDim2.new(0, 1, 0, 30),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Parent = header
	})
	Utilities.AddListLayout(controlHolder, 2, Enum.FillDirection.Horizontal)

	Utilities.Create("Frame", { -- Collapse placeholder
		Name = "CallopseButton",
		Size = UDim2.fromOffset(30, 30),
		BackgroundTransparency = 1,
		Parent = controlHolder
	})

	local closeButton = Utilities.Create("Frame", {
		Name = "CloseButton",
		Size = UDim2.fromOffset(30, 30),
		BackgroundTransparency = 1,
		Parent = controlHolder
	})
	Utilities.Create("ImageLabel", {
		Name = "CloseIcon",
		Image = "rbxassetid://124971904960139",
		ImageColor3 = Color3.fromRGB(66, 68, 86),
		Size = UDim2.fromOffset(18, 18),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1,
		Parent = closeButton
	})
	local closeTrigger = Utilities.Create("TextButton", {
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		Text = "",
		Parent = closeButton
	})

	-- 2. Description Content
	local descriptionHolder = Utilities.Create("Frame", {
		Name = "DescriptionHolder",
		Size = UDim2.new(0, 1, 0, 10),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Parent = notification
	})
	Utilities.AddPadding(descriptionHolder, 0, 12, 0, 12)
	Utilities.AddListLayout(descriptionHolder, 8)

	local textHolder = Utilities.Create("Frame", {
		Name = "TextHolder",
		Size = UDim2.new(1, 1, 0, 10),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Parent = descriptionHolder
	})
	Utilities.AddPadding(textHolder, 0, 0, 0, 26)
	Utilities.AddListLayout(textHolder, 0).Wraps = true

	Utilities.Create("TextLabel", {
		Text = text,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular),
		TextColor3 = Color3.fromRGB(66, 68, 86),
		TextSize = 14,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		RichText = true,
		Parent = textHolder
	})

	-- Buttons inside description
	local buttonHolder = Utilities.Create("Frame", {
		Name = "ButtonHolder",
		Size = UDim2.new(0, 1, 0, 10),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Parent = descriptionHolder
	})
	Utilities.AddPadding(buttonHolder, 0, 0, 0, 26)
	Utilities.AddListLayout(buttonHolder, 8, Enum.FillDirection.Horizontal).Wraps = true

	local primaryBtn = Utilities.Create("Frame", {
		Name = "Button",
		BackgroundColor3 = data.Color,
		BackgroundTransparency = 0.95,
		AutomaticSize = Enum.AutomaticSize.XY,
		Parent = buttonHolder
	})
	Utilities.AddCorner(primaryBtn, 6)
	Utilities.AddListLayout(primaryBtn, 0, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center).VerticalAlignment = Enum.VerticalAlignment.Center
	
	local btnLabel = Utilities.Create("TextLabel", {
		Text = "Continue",
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular),
		TextColor3 = data.Color,
		TextSize = 14,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Parent = primaryBtn
	})
	Utilities.AddPadding(btnLabel, 6, 8, 6, 8)
	
	local btnTrigger = Utilities.Create("TextButton", {
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		Text = "",
		Parent = primaryBtn
	})

	-- 3. Progress Bar Section
	local progressContainer = Utilities.Create("Frame", {
		Name = "ProgressHolder",
		Size = UDim2.new(1, 1, 0, 20),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(19, 20, 25),
		BorderSizePixel = 0,
		Parent = notification
	})
	Utilities.AddCorner(progressContainer, 8)
	Utilities.AddPadding(progressContainer, 0, 12, 0, 0)
	Utilities.AddListLayout(progressContainer, 0, Enum.FillDirection.Horizontal)

	local progHolderInner = Utilities.Create("Frame", {
		Name = "Holder",
		Size = UDim2.new(0, 1, 0, 1),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Parent = progressContainer
	})
	Utilities.AddListLayout(progHolderInner, 6)

	local progressbarWrap = Utilities.Create("Frame", {
		Name = "Progressbar",
		Size = UDim2.new(1, 1, 0, 5),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Parent = progHolderInner
	})
	Utilities.AddListLayout(progressbarWrap, 12, Enum.FillDirection.Horizontal)

	local progressFill = Utilities.Create("Frame", {
		Name = "Fill",
		Size = UDim2.new(1, 0, 0, 5),
		BackgroundColor3 = data.Color,
		BorderSizePixel = 0,
		Parent = progressbarWrap
	})
	Utilities.AddCorner(progressFill, 8)

	-- Animation Logic
	local function dismiss()
		Utilities.Tween(notification, {Position = UDim2.new(1.5, 0, 0, 0)}, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In).Completed:Connect(function()
			notification:Destroy()
		end)
	end

	closeTrigger.MouseButton1Click:Connect(dismiss)
	btnTrigger.MouseButton1Click:Connect(dismiss)

	-- Entry Tween
	Utilities.Tween(notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	
	-- Progress Bar Animation
	task.delay(0.5, function()
		Utilities.Tween(progressFill, {Size = UDim2.fromScale(0, 1)}, duration, Enum.EasingStyle.Linear).Completed:Connect(dismiss)
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
