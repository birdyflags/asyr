local Centrixity = {}
Centrixity.__index = Centrixity

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Config
local Config = {
	TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	FastTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Colors = {
		Background = Color3.fromRGB(19, 20, 25),
		DarkBackground = Color3.fromRGB(16, 17, 21),
		Section = Color3.fromRGB(17, 18, 22),
		Header = Color3.fromRGB(19, 20, 25),
		Accent = Color3.fromRGB(255, 127, 0),
		AccentLight = Color3.fromRGB(255, 200, 87),
		Text = Color3.fromRGB(255, 255, 255),
		TextDark = Color3.fromRGB(69, 71, 90),
		ToggleOff = Color3.fromRGB(24, 25, 32),
		Stroke = Color3.fromRGB(28, 30, 38),
		Liner = Color3.fromRGB(31, 31, 45)
	}
}

-- Utility Functions
local function Create(className, properties)
	local instance = Instance.new(className)
	for prop, value in pairs(properties) do
		instance[prop] = value
	end
	return instance
end

local function Tween(instance, properties, tweenInfo)
	tweenInfo = tweenInfo or Config.TweenInfo
	local tween = TweenService:Create(instance, tweenInfo, properties)
	tween:Play()
	return tween
end

local function CreateGradient(parent, rotation)
	local gradient = Create("UIGradient", {
		Rotation = rotation or 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Config.Colors.Accent),
			ColorSequenceKeypoint.new(1, Config.Colors.AccentLight)
		}),
		Parent = parent
	})
	return gradient
end

local function CreateCorner(parent, radius)
	return Create("UICorner", {
		CornerRadius = radius or UDim.new(0, 6),
		Parent = parent
	})
end

local function CreateStroke(parent, color, transparency)
	return Create("UIStroke", {
		Color = color or Config.Colors.Stroke,
		Transparency = transparency or 0,
		Parent = parent
	})
end

-- Main Library Creation
function Centrixity:Init(options)
	options = options or {}
	
	local self = setmetatable({}, Centrixity)
	
	self.Tabs = {}
	self.ActiveTab = nil
	self.ScreenGui = nil
	self.MainFrame = nil
	self.TabHolder = nil
	self.PageHolder = nil
	self.SubHeader = nil
	
	self:BuildUI(options)
	
	return self
end

function Centrixity:BuildUI(options)
	-- ScreenGui
	self.ScreenGui = Create("ScreenGui", {
		Name = options.Name or "Centrixity",
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = PlayerGui
	})
	
	-- Main Frame
	self.MainFrame = Create("Frame", {
		Name = "MainFrame",
		Size = options.Size or UDim2.new(0, 689, 0, 489),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Config.Colors.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = self.ScreenGui
	})
	
	CreateCorner(self.MainFrame, UDim.new(0, 11))
	
	-- Header
	self:BuildHeader(options)
	
	-- Sidebar
	self:BuildSidebar()
	
	-- Sub Header (for subpages)
	self:BuildSubHeader()
	
	-- Page Container
	self.PageHolder = Create("Frame", {
		Name = "PageHolder",
		Size = UDim2.new(0, 620, 0, 401),
		Position = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = Config.Colors.DarkBackground,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = self.MainFrame
	})
	
	CreateCorner(self.PageHolder, UDim.new(0, 11))
end

function Centrixity:BuildHeader(options)
	local header = Create("Frame", {
		Name = "Header",
		Size = UDim2.new(0, 695, 0, 37),
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = self.MainFrame
	})
	
	-- Liner
	local liner = Create("Frame", {
		Name = "Liner",
		Size = UDim2.new(1, 1, 0, 2),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = Config.Colors.Liner,
		BorderSizePixel = 0,
		Parent = header
	})
	
	-- Icon
	if options.Icon then
		local icon = Create("ImageLabel", {
			Name = "LibaryIcon",
			Size = UDim2.new(0, 34, 0, 34),
			Position = UDim2.new(0, 12, 0.44, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Image = options.Icon,
			ScaleType = Enum.ScaleType.Fit,
			BorderSizePixel = 0,
			Parent = header
		})
	end
	
	-- Title
	local titleText = options.Title or "Centrixity"
	local title = Create("TextLabel", {
		Name = "Libary_Name",
		Text = titleText,
		TextColor3 = Config.Colors.Text,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
		TextSize = 14,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.059, 32, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BorderSizePixel = 0,
		Parent = header
	})
	
	-- Last Updated
	if options.LastUpdated then
		local updateLabel = Create("TextLabel", {
			Name = "Last_Updated",
			Text = "Updated Last <font color=\\"#45475a\\">" .. options.LastUpdated .. "</font>",
			RichText = true,
			TextColor3 = Config.Colors.Text,
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular),
			TextSize = 12,
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -12, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BorderSizePixel = 0,
			Parent = header
		})
	end
end

function Centrixity:BuildSidebar()
	local sidebar = Create("Frame", {
		Name = "Sidebar",
		Size = UDim2.new(0, 75, 0, 453),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = self.MainFrame
	})
	
	-- Liner
	local liner = Create("Frame", {
		Name = "Liner",
		Size = UDim2.new(0, 2, 1, 0),
		Position = UDim2.new(1, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Config.Colors.Liner,
		BorderSizePixel = 0,
		Parent = sidebar
	})
	
	-- Tab Holder
	self.TabHolder = Create("Frame", {
		Name = "Holder",
		Size = UDim2.new(0, 75, 0, 453),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = sidebar
	})
	
	Create("UIListLayout", {
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = self.TabHolder
	})
	
	Create("UIPadding", {
		PaddingTop = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, 9),
		Parent = self.TabHolder
	})
end

function Centrixity:BuildSubHeader()
	self.SubHeader = Create("Frame", {
		Name = "SubHeader",
		Size = UDim2.new(0, 621, 0, 51),
		Position = UDim2.new(0.555, 0, 0.128, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = self.MainFrame
	})
	
	Create("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		Parent = self.SubHeader
	})
	
	Create("UIPadding", {
		PaddingTop = UDim.new(0, 4),
		PaddingLeft = UDim.new(0, 25),
		Parent = self.SubHeader
	})
end

-- Tab Creation
function Centrixity:AddTab(options)
	options = options or {}
	local tabName = options.Name or "Tab"
	local iconId = options.Icon
	
	local tabIndex = #self.Tabs + 1
	local isFirstTab = tabIndex == 1
	
	-- Tab Button
	local tabBtn = Create("Frame", {
		Name = "Tab",
		Size = UDim2.new(0, 55, 0, 60),
		BackgroundTransparency = isFirstTab and 0.9 or 1,
		BackgroundColor3 = isFirstTab and Config.Colors.Text or Config.Colors.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = self.TabHolder
	})
	
	CreateCorner(tabBtn, UDim.new(0, 5))
	
	-- Gradient line under tab (only for active)
	local gradientLine = Create("Frame", {
		Name = "GradientLine",
		Size = UDim2.new(0, 25, 0, 6),
		Position = UDim2.new(0.5, 0, 1, 3),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundColor3 = Config.Colors.Text,
		BorderSizePixel = 0,
		Visible = isFirstTab,
		Parent = tabBtn
	})
	
	CreateCorner(gradientLine, UDim.new(0, 12))
	CreateGradient(gradientLine)
	
	-- Icon
	local iconColor = isFirstTab and Config.Colors.Accent or Config.Colors.TextDark
	local icon = Create("ImageLabel", {
		Name = "Icon",
		Size = UDim2.new(0, 24, 0, 22),
		Position = UDim2.new(0.5, 0, 0.5, -8),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = iconId or "",
		ImageColor3 = iconColor,
		BorderSizePixel = 0,
		Parent = tabBtn
	})
	
	-- Label
	local textColor = isFirstTab and Config.Colors.Text or Config.Colors.TextDark
	local label = Create("TextLabel", {
		Text = tabName,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold),
		TextColor3 = textColor,
		TextSize = 12,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 20),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		Parent = icon
	})
	
	-- Gradient for active tab
	if isFirstTab then
		CreateGradient(tabBtn)
	end
	
	-- Page Container
	local page = Create("ScrollingFrame", {
		Name = tabName .. "_Page",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 1,
		ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
		Visible = isFirstTab,
		Parent = self.PageHolder
	})
	
	Create("UIListLayout", {
		Padding = UDim.new(0, 20),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		Parent = page
	})
	
	Create("UIPadding", {
		PaddingTop = UDim.new(0, 12),
		PaddingLeft = UDim.new(0, 12),
		Parent = page
	})
	
	-- Tab Data
	local tabData = {
		Name = tabName,
		Button = tabBtn,
		Page = page,
		Icon = icon,
		Label = label,
		GradientLine = gradientLine,
		Sections = {},
		SubPages = {},
		ActiveSubPage = nil
	}
	
	table.insert(self.Tabs, tabData)
	
	-- Click Handler
	local clickBtn = Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		Parent = tabBtn
	})
	
	clickBtn.MouseButton1Click:Connect(function()
		self:SwitchTab(tabIndex)
	end)
	
	-- Set as active if first
	if isFirstTab then
		self.ActiveTab = tabData
	end
	
	-- Tab Methods
	local TabAPI = {}
	
	function TabAPI:AddSection(options)
		return self:AddSectionToPage(page, options)
	end
	
	function TabAPI:AddSubPage(options)
		return self:AddSubPageToTab(tabData, options)
	end
	
	return TabAPI
end

function Centrixity:SwitchTab(index)
	local newTab = self.Tabs[index]
	if not newTab or self.ActiveTab == newTab then return end
	
	local oldTab = self.ActiveTab
	
	-- Animate old tab out
	if oldTab then
		Tween(oldTab.Button, {BackgroundTransparency = 1})
		Tween(oldTab.Icon, {ImageColor3 = Config.Colors.TextDark})
		Tween(oldTab.Label, {TextColor3 = Config.Colors.TextDark})
		
		-- Hide gradient line
		oldTab.GradientLine.Visible = false
		
		-- Remove gradient from button
		local oldGradient = oldTab.Button:FindFirstChildOfClass("UIGradient")
		if oldGradient then oldGradient:Destroy() end
		
		-- Fade out old page
		Tween(oldTab.Page, {BackgroundTransparency = 1}, Config.FastTween)
		task.delay(0.2, function()
			oldTab.Page.Visible = false
		end)
	end
	
	-- Animate new tab in
	Tween(newTab.Button, {BackgroundTransparency = 0.9})
	Tween(newTab.Icon, {ImageColor3 = Config.Colors.Accent})
	Tween(newTab.Label, {TextColor3 = Config.Colors.Text})
	
	-- Show and animate gradient line
	newTab.GradientLine.Visible = true
	newTab.GradientLine.Size = UDim2.new(0, 0, 0, 6)
	Tween(newTab.GradientLine, {Size = UDim2.new(0, 25, 0, 6)})
	
	-- Add gradient to button
	CreateGradient(newTab.Button)
	
	-- Show and fade in new page
	newTab.Page.Visible = true
	newTab.Page.BackgroundTransparency = 1
	Tween(newTab.Page, {BackgroundTransparency = 0}, Config.FastTween)
	
	self.ActiveTab = newTab
end

-- Section Creation
function Centrixity:AddSectionToPage(page, options)
	options = options or {}
	local sectionName = options.Name or "Section"
	local side = options.Side or "Left"
	
	local section = Create("Frame", {
		Name = "Section_" .. side,
		Size = UDim2.new(0, 281, 0, 60),
		BackgroundColor3 = Config.Colors.Section,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = page
	})
	
	CreateCorner(section, UDim.new(0, 6))
	
	-- Header
	local header = Create("Frame", {
		Name = "Header",
		Size = UDim2.new(0, 281, 0, 30),
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Config.Colors.Header,
		BorderSizePixel = 0,
		Parent = section
	})
	
	-- Liner
	local liner = Create("Frame", {
		Name = "Liner",
		Size = UDim2.new(1, 1, 0, 1),
		Position = UDim2.new(0.5, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundColor3 = Color3.fromRGB(26, 26, 37),
		BorderSizePixel = 0,
		Parent = header
	})
	CreateGradient(liner, 90)
	
	-- Header Holder
	local headerHolder = Create("Frame", {
		Name = "Header_Holder",
		Size = UDim2.new(0, 281, 0, 30),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = header
	})
	
	-- Line indicator
	local line = Create("Frame", {
		Name = "Line",
		Size = UDim2.new(0, 6, 0, 20),
		Position = UDim2.new(0, -3, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Config.Colors.Accent,
		BorderSizePixel = 0,
		Parent = headerHolder
	})
	CreateCorner(line, UDim.new(0, 30))
	
	-- Icon
	if options.Icon then
		local icon = Create("ImageLabel", {
			Size = UDim2.new(0, 15, 0, 15),
			Position = UDim2.new(0, 12, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Image = options.Icon,
			ImageColor3 = Config.Colors.Accent,
			ScaleType = Enum.ScaleType.Fit,
			BorderSizePixel = 0,
			Parent = headerHolder
		})
	end
	
	-- Title
	local title = Create("TextLabel", {
		Name = "Section_Name",
		Text = sectionName,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular),
		TextColor3 = Config.Colors.Text,
		TextSize = 12,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 35, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BorderSizePixel = 0,
		Parent = headerHolder
	})
	
	-- Content Holder
	local holder = Create("Frame", {
		Name = "Holder",
		Size = UDim2.new(0, 1, 0, 1),
		Position = UDim2.new(0.5, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.XY,
		Parent = header
	})
	
	Create("UIListLayout", {
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = holder
	})
	
	Create("UIPadding", {
		PaddingTop = UDim.new(0, 5),
		PaddingBottom = UDim.new(0, 45),
		Parent = holder
	})
	
	-- Section API
	local SectionAPI = {}
	
	function SectionAPI:AddToggle(options)
		return self:CreateToggle(holder, options)
	end
	
	function SectionAPI:AddSlider(options)
		return self:CreateSlider(holder, options)
	end
	
	function SectionAPI:AddButton(options)
		return self:CreateButton(holder, options)
	end
	
	function SectionAPI:AddDropdown(options)
		return self:CreateDropdown(holder, options)
	end
	
	function SectionAPI:AddKeybind(options)
		return self:CreateKeybind(holder, options)
	end
	
	return SectionAPI
end

-- SubPage Creation
function Centrixity:AddSubPageToTab(tabData, options)
	options = options or {}
	local subPageName = options.Name or "SubPage"
	local isFirstSub = #tabData.SubPages == 0
	
	local subTabBtn = Create("Frame", {
		Name = "SubTab",
		Size = UDim2.new(0, 80, 0, 49),
		Position = UDim2.new(0, 0, 0.039, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.X,
		Parent = self.SubHeader
	})
	
	local tabName = Create("TextLabel", {
		Name = "TabName",
		Text = subPageName,
		FontFace = Font.new("rbxassetid://12187365364", isFirstSub and Enum.FontWeight.Medium or Enum.FontWeight.Regular),
		TextColor3 = isFirstSub and Config.Colors.Text or Config.Colors.TextDark,
		TextTransparency = isFirstSub and 0 or 0.15,
		TextSize = 13,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = isFirstSub and 0.8 or 1,
		BackgroundColor3 = Config.Colors.Text,
		Position = UDim2.new(0.5, 0, 0.5, -3),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		Parent = subTabBtn
	})
	
	CreateCorner(tabName, UDim.new(0, 4))
	Create("UIPadding", {
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		Parent = tabName
	})
	
	if isFirstSub then
		local gradient = CreateGradient(tabName)
		
		local holder = Create("Frame", {
			Name = "Holder",
			Size = UDim2.new(0, 34, 0, 6),
			Position = UDim2.new(0.5, 0, 1, 2),
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Config.Colors.Text,
			BorderSizePixel = 0,
			Parent = subTabBtn
		})
		CreateCorner(holder, UDim.new(0, 12))
		CreateGradient(holder)
	end
	
	-- SubPage Content
	local subPage = Create("Frame", {
		Name = subPageName .. "_SubPage",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = isFirstSub,
		Parent = tabData.Page
	})
	
	Create("UIListLayout", {
		Padding = UDim.new(0, 20),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		Parent = subPage
	})
	
	Create("UIPadding", {
		PaddingTop = UDim.new(0, 12),
		PaddingLeft = UDim.new(0, 12),
		Parent = subPage
	})
	
	local subPageData = {
		Name = subPageName,
		Button = subTabBtn,
		TabNameLabel = tabName,
		Page = subPage
	}
	
	table.insert(tabData.SubPages, subPageData)
	
	if isFirstSub then
		tabData.ActiveSubPage = subPageData
	end
	
	-- Click Handler
	local clickBtn = Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		Parent = subTabBtn
	})
	
	clickBtn.MouseButton1Click:Connect(function()
		self:SwitchSubPage(tabData, subPageData)
	end)
	
	-- SubPage API
	local SubPageAPI = {}
	
	function SubPageAPI:AddSection(options)
		return self:AddSectionToPage(subPage, options)
	end
	
	return SubPageAPI
end

function Centrixity:SwitchSubPage(tabData, newSubPage)
	if tabData.ActiveSubPage == newSubPage then return end
	
	local oldSub = tabData.ActiveSubPage
	
	-- Fade out old
	if oldSub then
		Tween(oldSub.Page, {BackgroundTransparency = 1}, Config.FastTween)
		task.delay(0.2, function()
			oldSub.Page.Visible = false
		end)
		
		-- Reset button style
		Tween(oldSub.TabNameLabel, {
			TextColor3 = Config.Colors.TextDark,
			BackgroundTransparency = 1
		})
		oldSub.TabNameLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
		
		-- Remove gradient and holder
		local oldGradient = oldSub.TabNameLabel:FindFirstChildOfClass("UIGradient")
		if oldGradient then oldGradient:Destroy() end
		
		local oldHolder = oldSub.Button:FindFirstChild("Holder")
		if oldHolder then oldHolder:Destroy() end
	end
	
	-- Fade in new
	newSubPage.Page.Visible = true
	newSubPage.Page.BackgroundTransparency = 1
	Tween(newSubPage.Page, {BackgroundTransparency = 0}, Config.FastTween)
	
	-- Style new button
	Tween(newSubPage.TabNameLabel, {
		TextColor3 = Config.Colors.Text,
		BackgroundTransparency = 0.8
	})
	newSubPage.TabNameLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
	
	-- Add gradient
	CreateGradient(newSubPage.TabNameLabel)
	
	-- Add holder line
	local holder = Create("Frame", {
		Name = "Holder",
		Size = UDim2.new(0, 34, 0, 6),
		Position = UDim2.new(0.5, 0, 1, 2),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundColor3 = Config.Colors.Text,
		BorderSizePixel = 0,
		Parent = newSubPage.Button
	})
	CreateCorner(holder, UDim.new(0, 12))
	CreateGradient(holder)
	
	tabData.ActiveSubPage = newSubPage
end

-- Component Creation Methods
function Centrixity:CreateToggle(parent, options)
	options = options or {}
	local toggleName = options.Name or "Toggle"
	local defaultState = options.Default or false
	local callback = options.Callback or function() end
	
	local component = Create("Frame", {
		Name = "Toggle_Component",
		Size = UDim2.new(0, 312, 0, 30),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = parent
	})
	
	local label = Create("TextLabel", {
		Name = "Toggle_Name",
		Text = toggleName,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular),
		TextColor3 = defaultState and Config.Colors.Text or Config.Colors.TextDark,
		TextSize = 12,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 48, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BorderSizePixel = 0,
		Parent = component
	})
	
	local toggleBtn = Create("Frame", {
		Name = "Toggle",
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(0, 25, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = defaultState and Config.Colors.Text or Config.Colors.ToggleOff,
		BorderSizePixel = 0,
		Parent = component
	})
	
	CreateCorner(toggleBtn, UDim.new(0, 3))
	
	if not defaultState then
		CreateStroke(toggleBtn)
	else
		CreateGradient(toggleBtn, 90)
		
		local check = Create("ImageLabel", {
			Name = "Check_Icon",
			Size = UDim2.new(0, 8, 0, 7),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = "rbxassetid://83899464799881",
			BorderSizePixel = 0,
			Parent = toggleBtn
		})
	end
	
	local clickArea = Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		Parent = component
	})
	
	local state = defaultState
	clickArea.MouseButton1Click:Connect(function()
		state = not state
		
		if state then
			Tween(toggleBtn, {BackgroundColor3 = Config.Colors.Text})
			Tween(label, {TextColor3 = Config.Colors.Text})
			CreateGradient(toggleBtn, 90)
			
			local check = toggleBtn:FindFirstChild("Check_Icon")
			if not check then
				check = Create("ImageLabel", {
					Name = "Check_Icon",
					Size = UDim2.new(0, 8, 0, 7),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = "rbxassetid://83899464799881",
					BorderSizePixel = 0,
					Parent = toggleBtn
				})
			end
			
			local stroke = toggleBtn:FindFirstChildOfClass("UIStroke")
			if stroke then stroke:Destroy() end
		else
			Tween(toggleBtn, {BackgroundColor3 = Config.Colors.ToggleOff})
			Tween(label, {TextColor3 = Config.Colors.TextDark})
			
			local gradient = toggleBtn:FindFirstChildOfClass("UIGradient")
			if gradient then gradient:Destroy() end
			
			local check = toggleBtn:FindFirstChild("Check_Icon")
			if check then check:Destroy() end
			
			CreateStroke(toggleBtn)
		end
		
		callback(state)
	end)
	
	return {
		Set = function(newState)
			if state ~= newState then
				clickArea.MouseButton1Click:Fire()
			end
		end,
		Get = function() return state end
	}
end

function Centrixity:CreateSlider(parent, options)
	options = options or {}
	local sliderName = options.Name or "Slider"
	local min = options.Min or 0
	local max = options.Max or 100
	local default = options.Default or min
	local callback = options.Callback or function() end
	
	local component = Create("Frame", {
		Name = "Slider_Component",
		Size = UDim2.new(0, 312, 0, 40),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = parent
	})
	
	local valueLabel = Create("TextLabel", {
		Name = "Value",
		Text = tostring(default),
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular),
		TextColor3 = Config.Colors.Text,
		TextSize = 14,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -22, 0.5, -8),
		AnchorPoint = Vector2.new(1, 0.5),
		BorderSizePixel = 0,
		Parent = component
	})
	
	local textLabel = Create("TextLabel", {
		Name = "Slider_Text",
		Text = sliderName,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular),
		TextColor3 = Config.Colors.TextDark,
		TextSize = 14,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 23, 0.5, -8),
		AnchorPoint = Vector2.new(0, 0.5),
		BorderSizePixel = 0,
		Parent = component
	})
	
	local progressBG = Create("Frame", {
		Name = "Progress_BG",
		Size = UDim2.new(0, 266, 0, 4),
		Position = UDim2.new(0.013, 19, 0.53, 13),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Config.Colors.ToggleOff,
		BorderSizePixel = 0,
		Parent = component
	})
	
	CreateCorner(progressBG)
	CreateStroke(progressBG)
	
	local percent = (default - min) / (max - min)
	local progress = Create("Frame", {
		Name = "Progress",
		Size = UDim2.new(percent, 0, 0, 7),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Config.Colors.Text,
		BorderSizePixel = 0,
		Parent = progressBG
	})
	
	CreateCorner(progress)
	CreateGradient(progress)
	
	local pointer = Create("Frame", {
		Name = "Pointer",
		Size = UDim2.new(0, 6, 0, 6),
		Position = UDim2.new(1, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Config.Colors.Accent,
		BorderSizePixel = 0,
		Parent = progress
	})
	
	CreateCorner(pointer)
	
	local design = Create("Frame", {
		Name = "Design",
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 0.5,
		BackgroundColor3 = Config.Colors.Accent,
		BorderSizePixel = 0,
		Parent = pointer
	})
	
	CreateCorner(design)
	
	-- Slider Logic
	local dragging = false
	
	local function updateSlider(input)
		local pos = math.clamp((input.Position.X - progressBG.AbsolutePosition.X) / progressBG.AbsoluteSize.X, 0, 1)
		local value = math.floor(min + (max - min) * pos)
		
		progress.Size = UDim2.new(pos, 0, 0, 7)
		valueLabel.Text = tostring(value)
		
		callback(value)
	end
	
	pointer.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)
	
	progressBG.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateSlider(input)
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input)
		end
	end)
	
	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	return {
		Set = function(value)
			value = math.clamp(value, min, max)
			local pos = (value - min) / (max - min)
			progress.Size = UDim2.new(pos, 0, 0, 7)
			valueLabel.Text = tostring(value)
			callback(value)
		end,
		Get = function() return tonumber(valueLabel.Text) end
	}
end

function Centrixity:CreateButton(parent, options)
	options = options or {}
	local buttonName = options.Name or "Button"
	local callback = options.Callback or function() end
	local customColor = options.Color
	
	local component = Create("Frame", {
		Name = "Button_Component",
		Size = UDim2.new(0, 312, 0, 40),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = parent
	})
	
	local bgColor = customColor or Config.Colors.ToggleOff
	local textColor = customColor or Config.Colors.TextDark
	
	local button = Create("Frame", {
		Name = "Button",
		Size = UDim2.new(0, 251, 0, 30),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = bgColor,
		BorderSizePixel = 0,
		Parent = component
	})
	
	CreateCorner(button, UDim.new(0, 3))
	
	if not customColor then
		CreateStroke(button)
	else
		CreateStroke(button, customColor, 0.5)
	end
	
	local label = Create("TextLabel", {
		Name = "Button_Text",
		Text = buttonName,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
		TextColor3 = textColor,
		TextSize = 13,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		Parent = button
	})
	
	local clickBtn = Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		Parent = button
	})
	
	clickBtn.MouseButton1Click:Connect(callback)
	
	return {
		Fire = function() callback() end
	}
end

function Centrixity:CreateDropdown(parent, options)
	options = options or {}
	local dropdownName = options.Name or "Dropdown"
	local items = options.Items or {}
	local default = options.Default or "Select..."
	local callback = options.Callback or function() end
	
	local component = Create("Frame", {
		Name = "Dropdown_Component",
		Size = UDim2.new(0, 312, 0, 55),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = parent
	})
	
	local label = Create("TextLabel", {
		Name = "Dropdown_Name",
		Text = dropdownName,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular),
		TextColor3 = Color3.fromRGB(204, 204, 209),
		TextSize = 12,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 25, 0, 12),
		BorderSizePixel = 0,
		Parent = component
	})
	
	local holder = Create("Frame", {
		Name = "Holder",
		Size = UDim2.new(0, 264, 0, 22),
		Position = UDim2.new(0.503, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundColor3 = Config.Colors.ToggleOff,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = component
	})
	
	CreateCorner(holder, UDim.new(0, 2))
	CreateStroke(holder)
	
	local optionsText = table.concat(items, ", ")
	local value = Create("TextLabel", {
		Name = "Options",
		Text = optionsText,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
		TextColor3 = Config.Colors.Text,
		TextSize = 13,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.025, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BorderSizePixel = 0,
		Parent = holder
	})
	
	CreateGradient(value, 90)
	
	-- Lines
	local line1 = Create("Frame", {
		Name = "Line",
		Size = UDim2.new(0, 6, 0, 13),
		Position = UDim2.new(1, 4, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Config.Colors.Text,
		BorderSizePixel = 0,
		Parent = holder
	})
	CreateCorner(line1, UDim.new(0, 30))
	CreateGradient(line1)
	
	local line2 = Create("Frame", {
		Name = "Line",
		Size = UDim2.new(0, 6, 0, 13),
		Position = UDim2.new(0, -4, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Config.Colors.Text,
		BorderSizePixel = 0,
		Parent = holder
	})
	CreateCorner(line2, UDim.new(0, 30))
	CreateGradient(line2)
	
	return {
		Set = function(item)
			value.Text = item
			callback(item)
		end,
		Get = function() return value.Text end
	}
end

function Centrixity:CreateKeybind(parent, options)
	options = options or {}
	local bindName = options.Name or "Keybind"
	local default = options.Default or "NONE"
	local callback = options.Callback or function() end
	
	local component = Create("Frame", {
		Name = "Keybind_Component",
		Size = UDim2.new(0, 312, 0, 50),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = parent
	})
	
	local label = Create("TextLabel", {
		Name = "Toggle_Name",
		Text = bindName,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular),
		TextColor3 = Config.Colors.Text,
		TextSize = 12,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 25, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BorderSizePixel = 0,
		Parent = component
	})
	
	local holder = Create("Frame", {
		Name = "Holder",
		Size = UDim2.new(0, 16, 0, 16),
		Position = UDim2.new(1, -23, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Config.Colors.ToggleOff,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.XY,
		Parent = component
	})
	
	CreateCorner(holder, UDim.new(0, 3))
	CreateStroke(holder)
	
	Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Parent = holder
	})
	
	local iconHolder = Create("Frame", {
		Name = "Icon_Holder",
		Size = UDim2.new(0, 22, 0, 22),
		Position = UDim2.new(0.04, 0, -0.33, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = holder
	})
	
	local icon = Create("ImageLabel", {
		Size = UDim2.new(0, 15, 0, 15),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = "rbxassetid://127406982390736",
		ImageColor3 = Config.Colors.Text,
		ScaleType = Enum.ScaleType.Fit,
		BorderSizePixel = 0,
		Parent = iconHolder
	})
	
	CreateGradient(icon)
	
	local value = Create("TextLabel", {
		Name = "Value",
		Text = default,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold),
		TextColor3 = Config.Colors.Text,
		TextSize = 10,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 19, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BorderSizePixel = 0,
		Parent = holder
	})
	
	Create("UIPadding", {
		PaddingTop = UDim.new(0, 6),
		PaddingBottom = UDim.new(0, 4),
		PaddingLeft = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 10),
		Parent = value
	})
	
	-- Lines
	local line1 = Create("Frame", {
		Name = "Line",
		Size = UDim2.new(0, 6, 0, 13),
		Position = UDim2.new(1, 13, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Config.Colors.Accent,
		BorderSizePixel = 0,
		Parent = value
	})
	CreateCorner(line1, UDim.new(0, 30))
	
	local line2 = Create("Frame", {
		Name = "Line",
		Size = UDim2.new(0, 6, 0, 13),
		Position = UDim2.new(1, 13, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Config.Colors.Text,
		BorderSizePixel = 0,
		Parent = line1
	})
	CreateCorner(line2, UDim.new(0, 30))
	
	return {
		Set = function(key) value.Text = key end,
		Get = function() return value.Text end
	}
end

-- Return Library
return Centrixity
