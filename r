local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local Library = {}
Library.__index = Library

local ACCENT_START = Color3.fromRGB(255, 150, 50)
local ACCENT_END = Color3.fromRGB(255, 100, 30)
local ACCENT_GRADIENT = ColorSequence.new({
	ColorSequenceKeypoint.new(0, ACCENT_START),
	ColorSequenceKeypoint.new(1, ACCENT_END)
})

local COLORS = {
	Background = Color3.fromRGB(18, 18, 22),
	Secondary = Color3.fromRGB(28, 28, 35),
	Tertiary = Color3.fromRGB(38, 38, 48),
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(160, 160, 175),
	Border = Color3.fromRGB(55, 55, 68),
	Accent = ACCENT_START
}

local function Tween(obj, props, duration, style, direction)
	local tween = TweenService:Create(
		obj,
		TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out),
		props
	)
	tween:Play()
	return tween
end

local function Create(class, props, children)
	local inst = Instance.new(class)
	for k, v in props do
		inst[k] = v
	end
	for _, child in children or {} do
		child.Parent = inst
	end
	return inst
end

local function GetGameName()
	local ok, info = pcall(function()
		return MarketplaceService:GetProductInfo(game.PlaceId)
	end)
	return ok and info and info.Name or "Game"
end

local function AddGradient(parent)
	return Create("UIGradient", {
		Parent = parent,
		Color = ACCENT_GRADIENT,
		Rotation = 45
	})
end

function Library.new()
	local self = setmetatable({}, Library)
	self.ScreenGui = nil
	self.Blur = nil
	return self
end

function Library:Init()
	if self.ScreenGui then return end
	
	local player = Players.LocalPlayer
	local gui = player:WaitForChild("PlayerGui")
	
	self.ScreenGui = Create("ScreenGui", {
		Name = "UILibrary",
		Parent = gui,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true
	})
	
	self.Blur = Create("BlurEffect", {
		Name = "UILibraryBlur",
		Parent = Lighting,
		Size = 0,
		Enabled = true
	})
end

function Library:CreateWindow(config)
	self:Init()
	
	local logoId = config.Logo or 0
	local title = config.Title or "UI Library"
	local gameName = GetGameName()
	
	local Window = {
		Tabs = {},
		ActiveTab = nil
	}
	
	Tween(self.Blur, {Size = 12}, 0.5)
	
	local Main = Create("Frame", {
		Name = "Main",
		Parent = self.ScreenGui,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = COLORS.Background,
		BackgroundTransparency = 0.08
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
		Create("UIStroke", {Color = COLORS.Border, Thickness = 1, Transparency = 0.6})
	})
	
	local Glass = Create("Frame", {
		Name = "Glass",
		Parent = Main,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.97,
		ZIndex = 0
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 10)})
	})
	
	local Sidebar = Create("Frame", {
		Name = "Sidebar",
		Parent = Main,
		Size = UDim2.new(0, 75, 1, 0),
		BackgroundColor3 = COLORS.Secondary,
		BackgroundTransparency = 0.15
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 10)})
	})
	
	Create("Frame", {
		Name = "Fix",
		Parent = Sidebar,
		Position = UDim2.new(1, -10, 0, 0),
		Size = UDim2.new(0, 10, 1, 0),
		BackgroundColor3 = COLORS.Secondary,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0
	})
	
	local LogoHolder = Create("Frame", {
		Name = "LogoHolder",
		Parent = Sidebar,
		Size = UDim2.new(1, 0, 0, 75),
		BackgroundTransparency = 1
	})
	
	local Logo = Create("ImageLabel", {
		Name = "Logo",
		Parent = LogoHolder,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 38, 0, 38),
		BackgroundTransparency = 1,
		Image = logoId ~= 0 and "rbxassetid://" .. logoId or ""
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 8)})
	})
	AddGradient(Logo)
	
	Create("Frame", {
		Name = "Divider",
		Parent = Sidebar,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 75),
		Size = UDim2.new(0.65, 0, 0, 1),
		BackgroundColor3 = COLORS.Border,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0
	})
	
	local TabList = Create("ScrollingFrame", {
		Name = "TabList",
		Parent = Sidebar,
		Position = UDim2.new(0, 0, 0, 85),
		Size = UDim2.new(1, 0, 1, -85),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y
	}, {
		Create("UIListLayout", {
			Padding = UDim.new(0, 6),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Create("UIPadding", {
			PaddingTop = UDim.new(0, 8),
			PaddingBottom = UDim.new(0, 8)
		})
	})
	
	local Content = Create("Frame", {
		Name = "Content",
		Parent = Main,
		Position = UDim2.new(0, 75, 0, 0),
		Size = UDim2.new(1, -75, 1, 0),
		BackgroundTransparency = 1
	})
	
	local Header = Create("Frame", {
		Name = "Header",
		Parent = Content,
		Size = UDim2.new(1, 0, 0, 55),
		BackgroundTransparency = 1
	}, {
		Create("UIPadding", {
			PaddingLeft = UDim.new(0, 18),
			PaddingRight = UDim.new(0, 18),
			PaddingTop = UDim.new(0, 12)
		})
	})
	
	Create("TextLabel", {
		Name = "Title",
		Parent = Header,
		Size = UDim2.new(1, -80, 0, 22),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = COLORS.Text,
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	Create("TextLabel", {
		Name = "Subtitle",
		Parent = Header,
		Position = UDim2.new(0, 0, 0, 24),
		Size = UDim2.new(1, -80, 0, 14),
		BackgroundTransparency = 1,
		Text = gameName,
		TextColor3 = COLORS.SubText,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local Controls = Create("Frame", {
		Name = "Controls",
		Parent = Header,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, 70, 0, 28),
		BackgroundTransparency = 1
	}, {
		Create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = UDim.new(0, 6)
		})
	})
	
	local MinBtn = Create("TextButton", {
		Name = "Min",
		Parent = Controls,
		Size = UDim2.new(0, 28, 0, 28),
		BackgroundColor3 = COLORS.Tertiary,
		BackgroundTransparency = 0.5,
		Text = "-",
		TextColor3 = COLORS.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 6)})
	})
	
	local CloseBtn = Create("TextButton", {
		Name = "Close",
		Parent = Controls,
		Size = UDim2.new(0, 28, 0, 28),
		BackgroundColor3 = Color3.fromRGB(190, 55, 55),
		BackgroundTransparency = 0.4,
		Text = "x",
		TextColor3 = COLORS.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 6)})
	})
	
	local TabContent = Create("Frame", {
		Name = "TabContent",
		Parent = Content,
		Position = UDim2.new(0, 0, 0, 55),
		Size = UDim2.new(1, 0, 1, -55),
		BackgroundTransparency = 1,
		ClipsDescendants = true
	})
	
	local minimized = false
	local fullSize = UDim2.new(0, 650, 0, 420)
	
	local dragging, dragStart, startPos
	
	Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
		end
	end)
	
	Header.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			Tween(Main, {
				Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			}, 0.08)
		end
	end)
	
	MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundTransparency = 0.3}, 0.12) end)
	MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundTransparency = 0.5}, 0.12) end)
	CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {BackgroundTransparency = 0.2}, 0.12) end)
	CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {BackgroundTransparency = 0.4}, 0.12) end)
	
	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			Tween(Main, {Size = UDim2.new(0, 650, 0, 55)}, 0.25)
		else
			Tween(Main, {Size = fullSize}, 0.25)
		end
	end)
	
	CloseBtn.MouseButton1Click:Connect(function()
		Tween(self.Blur, {Size = 0}, 0.3)
		Tween(Main, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.25).Completed:Wait()
		Main:Destroy()
	end)
	
	Tween(Main, {Size = fullSize}, 0.35, Enum.EasingStyle.Back)
	
	function Window:CreateTab(tabConfig)
		local tabTitle = tabConfig.Title or "Tab"
		local tabIcon = tabConfig.Icon or "rbxassetid://6031071053"
		
		local Tab = {
			SubPages = {},
			ActiveSubPage = nil
		}
		
		local TabBtn = Create("TextButton", {
			Name = tabTitle,
			Parent = TabList,
			Size = UDim2.new(0, 58, 0, 60),
			BackgroundColor3 = COLORS.Tertiary,
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false
		}, {
			Create("UICorner", {CornerRadius = UDim.new(0, 8)})
		})
		
		local Icon = Create("ImageLabel", {
			Name = "Icon",
			Parent = TabBtn,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 8),
			Size = UDim2.new(0, 22, 0, 22),
			BackgroundTransparency = 1,
			Image = tabIcon,
			ImageColor3 = COLORS.SubText
		})
		
		local Title = Create("TextLabel", {
			Name = "Title",
			Parent = TabBtn,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 34),
			Size = UDim2.new(1, -6, 0, 18),
			BackgroundTransparency = 1,
			Text = tabTitle,
			TextColor3 = COLORS.SubText,
			TextSize = 10,
			Font = Enum.Font.GothamMedium,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
		
		local Indicator = Create("Frame", {
			Name = "Indicator",
			Parent = TabBtn,
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -3),
			Size = UDim2.new(0, 0, 0, 2),
			BackgroundColor3 = ACCENT_START,
			BorderSizePixel = 0
		}, {
			Create("UICorner", {CornerRadius = UDim.new(1, 0)})
		})
		AddGradient(Indicator)
		
		local Page = Create("ScrollingFrame", {
			Name = tabTitle .. "Page",
			Parent = TabContent,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = COLORS.Border,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false
		}, {
			Create("UIListLayout", {
				Padding = UDim.new(0, 8),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Create("UIPadding", {
				PaddingTop = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16)
			})
		})
		
		local SubNav = Create("Frame", {
			Name = "SubNav",
			Parent = Page,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = -1,
			Visible = false
		}, {
			Create("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 6),
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			})
		})
		
		local SubContainer = Create("Frame", {
			Name = "SubContainer",
			Parent = Page,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 0
		})
		
		local function SelectTab()
			for _, t in Window.Tabs do
				if t ~= Tab then t:Deselect() end
			end
			Window.ActiveTab = Tab
			Page.Visible = true
			Tween(TabBtn, {BackgroundTransparency = 0.6}, 0.15)
			Tween(Icon, {ImageColor3 = ACCENT_START}, 0.15)
			Tween(Title, {TextColor3 = COLORS.Text}, 0.15)
			Tween(Indicator, {Size = UDim2.new(0, 26, 0, 2)}, 0.2, Enum.EasingStyle.Back)
		end
		
		function Tab:Deselect()
			Page.Visible = false
			Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
			Tween(Icon, {ImageColor3 = COLORS.SubText}, 0.15)
			Tween(Title, {TextColor3 = COLORS.SubText}, 0.15)
			Tween(Indicator, {Size = UDim2.new(0, 0, 0, 2)}, 0.15)
		end
		
		function Tab:Select()
			SelectTab()
		end
		
		TabBtn.MouseButton1Click:Connect(SelectTab)
		TabBtn.MouseEnter:Connect(function()
			if Window.ActiveTab ~= Tab then
				Tween(TabBtn, {BackgroundTransparency = 0.8}, 0.1)
			end
		end)
		TabBtn.MouseLeave:Connect(function()
			if Window.ActiveTab ~= Tab then
				Tween(TabBtn, {BackgroundTransparency = 1}, 0.1)
			end
		end)
		
		function Tab:CreateSubPage(subConfig)
			local subTitle = subConfig.Title or "SubPage"
			
			SubNav.Visible = true
			
			local SubPage = {}
			
			local SubBtn = Create("TextButton", {
				Name = subTitle,
				Parent = SubNav,
				Size = UDim2.new(0, 0, 0, 28),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = COLORS.Tertiary,
				BackgroundTransparency = 0.6,
				Text = subTitle,
				TextColor3 = COLORS.SubText,
				TextSize = 12,
				Font = Enum.Font.GothamMedium,
				AutoButtonColor = false
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
				Create("UIPadding", {
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10)
				})
			})
			
			local SubContent = Create("Frame", {
				Name = subTitle .. "Content",
				Parent = SubContainer,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Visible = false
			}, {
				Create("UIListLayout", {
					Padding = UDim.new(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			})
			
			local function SelectSub()
				for _, s in Tab.SubPages do
					if s ~= SubPage then s:Deselect() end
				end
				Tab.ActiveSubPage = SubPage
				SubContent.Visible = true
				Tween(SubBtn, {BackgroundTransparency = 0.35}, 0.12)
				Tween(SubBtn, {TextColor3 = ACCENT_START}, 0.12)
			end
			
			function SubPage:Deselect()
				SubContent.Visible = false
				Tween(SubBtn, {BackgroundTransparency = 0.6}, 0.12)
				Tween(SubBtn, {TextColor3 = COLORS.SubText}, 0.12)
			end
			
			function SubPage:Select()
				SelectSub()
			end
			
			SubBtn.MouseButton1Click:Connect(SelectSub)
			SubBtn.MouseEnter:Connect(function()
				if Tab.ActiveSubPage ~= SubPage then
					Tween(SubBtn, {BackgroundTransparency = 0.45}, 0.08)
				end
			end)
			SubBtn.MouseLeave:Connect(function()
				if Tab.ActiveSubPage ~= SubPage then
					Tween(SubBtn, {BackgroundTransparency = 0.6}, 0.08)
				end
			end)
			
			function SubPage:CreateSection(secConfig)
				local secTitle = secConfig.Title or "Section"
				
				local Section = {}
				
				local SecFrame = Create("Frame", {
					Name = secTitle,
					Parent = SubContent,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = COLORS.Secondary,
					BackgroundTransparency = 0.4
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
					Create("UIPadding", {
						PaddingTop = UDim.new(0, 10),
						PaddingBottom = UDim.new(0, 10),
						PaddingLeft = UDim.new(0, 12),
						PaddingRight = UDim.new(0, 12)
					}),
					Create("UIListLayout", {
						Padding = UDim.new(0, 8),
						SortOrder = Enum.SortOrder.LayoutOrder
					})
				})
				
				Create("TextLabel", {
					Name = "Title",
					Parent = SecFrame,
					Size = UDim2.new(1, 0, 0, 16),
					BackgroundTransparency = 1,
					Text = secTitle,
					TextColor3 = COLORS.SubText,
					TextSize = 11,
					Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = -1
				})
				
				function Section:CreateButton(btnConfig)
					local btnTitle = btnConfig.Title or "Button"
					local callback = btnConfig.Callback or function() end
					
					local Btn = Create("TextButton", {
						Name = btnTitle,
						Parent = SecFrame,
						Size = UDim2.new(1, 0, 0, 36),
						BackgroundColor3 = COLORS.Tertiary,
						BackgroundTransparency = 0.45,
						Text = btnTitle,
						TextColor3 = COLORS.Text,
						TextSize = 13,
						Font = Enum.Font.GothamMedium,
						AutoButtonColor = false
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
						Create("UIStroke", {Color = COLORS.Border, Thickness = 1, Transparency = 0.7})
					})
					
					Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundTransparency = 0.3}, 0.1) end)
					Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundTransparency = 0.45}, 0.1) end)
					Btn.MouseButton1Click:Connect(function()
						Tween(Btn, {BackgroundTransparency = 0.15}, 0.05)
						task.delay(0.1, function() Tween(Btn, {BackgroundTransparency = 0.45}, 0.1) end)
						callback()
					end)
					
					return Btn
				end
				
				function Section:CreateToggle(togConfig)
					local togTitle = togConfig.Title or "Toggle"
					local default = togConfig.Default or false
					local callback = togConfig.Callback or function() end
					local enabled = default
					
					local TogFrame = Create("Frame", {
						Name = togTitle,
						Parent = SecFrame,
						Size = UDim2.new(1, 0, 0, 36),
						BackgroundColor3 = COLORS.Tertiary,
						BackgroundTransparency = 0.45
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 6)})
					})
					
					Create("TextLabel", {
						Name = "Title",
						Parent = TogFrame,
						Position = UDim2.new(0, 12, 0, 0),
						Size = UDim2.new(1, -60, 1, 0),
						BackgroundTransparency = 1,
						Text = togTitle,
						TextColor3 = COLORS.Text,
						TextSize = 13,
						Font = Enum.Font.GothamMedium,
						TextXAlignment = Enum.TextXAlignment.Left
					})
					
					local TogBtn = Create("Frame", {
						Name = "Toggle",
						Parent = TogFrame,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -10, 0.5, 0),
						Size = UDim2.new(0, 38, 0, 20),
						BackgroundColor3 = COLORS.Secondary,
						BackgroundTransparency = 0.2
					}, {
						Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
						Create("UIStroke", {Color = COLORS.Border, Thickness = 1, Transparency = 0.6})
					})
					
					local Circle = Create("Frame", {
						Name = "Circle",
						Parent = TogBtn,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 3, 0.5, 0),
						Size = UDim2.new(0, 14, 0, 14),
						BackgroundColor3 = COLORS.SubText
					}, {
						Create("UICorner", {CornerRadius = UDim.new(1, 0)})
					})
					
					local function Update()
						if enabled then
							Tween(Circle, {Position = UDim2.new(1, -17, 0.5, 0), BackgroundColor3 = ACCENT_START}, 0.2)
							Tween(TogBtn, {BackgroundColor3 = ACCENT_END, BackgroundTransparency = 0.5}, 0.2)
						else
							Tween(Circle, {Position = UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = COLORS.SubText}, 0.2)
							Tween(TogBtn, {BackgroundColor3 = COLORS.Secondary, BackgroundTransparency = 0.2}, 0.2)
						end
						callback(enabled)
					end
					
					local btn = Create("TextButton", {
						Name = "Btn",
						Parent = TogFrame,
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Text = "",
						AutoButtonColor = false
					})
					
					btn.MouseButton1Click:Connect(function()
						enabled = not enabled
						Update()
					end)
					
					if default then Update() end
					
					return {
						Set = function(_, val)
							enabled = val
							Update()
						end
					}
				end
				
				function Section:CreateSlider(sldConfig)
					local sldTitle = sldConfig.Title or "Slider"
					local min = sldConfig.Min or 0
					local max = sldConfig.Max or 100
					local default = sldConfig.Default or min
					local callback = sldConfig.Callback or function() end
					local value = default
					
					local SldFrame = Create("Frame", {
						Name = sldTitle,
						Parent = SecFrame,
						Size = UDim2.new(1, 0, 0, 50),
						BackgroundColor3 = COLORS.Tertiary,
						BackgroundTransparency = 0.45
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 6)})
					})
					
					Create("TextLabel", {
						Name = "Title",
						Parent = SldFrame,
						Position = UDim2.new(0, 12, 0, 8),
						Size = UDim2.new(0.6, 0, 0, 16),
						BackgroundTransparency = 1,
						Text = sldTitle,
						TextColor3 = COLORS.Text,
						TextSize = 13,
						Font = Enum.Font.GothamMedium,
						TextXAlignment = Enum.TextXAlignment.Left
					})
					
					local ValLabel = Create("TextLabel", {
						Name = "Value",
						Parent = SldFrame,
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(1, -12, 0, 8),
						Size = UDim2.new(0.3, 0, 0, 16),
						BackgroundTransparency = 1,
						Text = tostring(value),
						TextColor3 = ACCENT_START,
						TextSize = 13,
						Font = Enum.Font.GothamBold,
						TextXAlignment = Enum.TextXAlignment.Right
					})
					
					local SliderBg = Create("Frame", {
						Name = "SliderBg",
						Parent = SldFrame,
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.new(0.5, 0, 0, 30),
						Size = UDim2.new(1, -24, 0, 6),
						BackgroundColor3 = COLORS.Secondary,
						BackgroundTransparency = 0.3
					}, {
						Create("UICorner", {CornerRadius = UDim.new(1, 0)})
					})
					
					local Fill = Create("Frame", {
						Name = "Fill",
						Parent = SliderBg,
						Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
						BackgroundColor3 = ACCENT_START
					}, {
						Create("UICorner", {CornerRadius = UDim.new(1, 0)})
					})
					AddGradient(Fill)
					
					local Knob = Create("Frame", {
						Name = "Knob",
						Parent = Fill,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(1, 0, 0.5, 0),
						Size = UDim2.new(0, 14, 0, 14),
						BackgroundColor3 = COLORS.Text
					}, {
						Create("UICorner", {CornerRadius = UDim.new(1, 0)})
					})
					
					local sliding = false
					
					local function Update(input)
						local pos = (input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X
						pos = math.clamp(pos, 0, 1)
						value = math.floor(min + (max - min) * pos)
						ValLabel.Text = tostring(value)
						Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.08)
						callback(value)
					end
					
					SliderBg.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							sliding = true
							Update(input)
						end
					end)
					
					SliderBg.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							sliding = false
						end
					end)
					
					UserInputService.InputChanged:Connect(function(input)
						if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
							Update(input)
						end
					end)
					
					return {
						Set = function(_, val)
							value = math.clamp(val, min, max)
							local pos = (value - min) / (max - min)
							ValLabel.Text = tostring(value)
							Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.15)
							callback(value)
						end
					}
				end
				
				function Section:CreateInput(inpConfig)
					local inpTitle = inpConfig.Title or "Input"
					local placeholder = inpConfig.Placeholder or "Enter text..."
					local callback = inpConfig.Callback or function() end
					
					local InpFrame = Create("Frame", {
						Name = inpTitle,
						Parent = SecFrame,
						Size = UDim2.new(1, 0, 0, 36),
						BackgroundColor3 = COLORS.Tertiary,
						BackgroundTransparency = 0.45
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 6)})
					})
					
					Create("TextLabel", {
						Name = "Title",
						Parent = InpFrame,
						Position = UDim2.new(0, 12, 0, 0),
						Size = UDim2.new(0.4, 0, 1, 0),
						BackgroundTransparency = 1,
						Text = inpTitle,
						TextColor3 = COLORS.Text,
						TextSize = 13,
						Font = Enum.Font.GothamMedium,
						TextXAlignment = Enum.TextXAlignment.Left
					})
					
					local Input = Create("TextBox", {
						Name = "Input",
						Parent = InpFrame,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -8, 0.5, 0),
						Size = UDim2.new(0.5, 0, 0, 26),
						BackgroundColor3 = COLORS.Secondary,
						BackgroundTransparency = 0.4,
						Text = "",
						PlaceholderText = placeholder,
						PlaceholderColor3 = COLORS.SubText,
						TextColor3 = COLORS.Text,
						TextSize = 12,
						Font = Enum.Font.Gotham,
						ClearTextOnFocus = false
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
						Create("UIPadding", {
							PaddingLeft = UDim.new(0, 8),
							PaddingRight = UDim.new(0, 8)
						})
					})
					
					Input.FocusLost:Connect(function(enter)
						if enter then
							callback(Input.Text)
						end
					end)
					
					return {
						Set = function(_, val)
							Input.Text = val
						end,
						Get = function()
							return Input.Text
						end
					}
				end
				
				function Section:CreateDropdown(drpConfig)
					local drpTitle = drpConfig.Title or "Dropdown"
					local options = drpConfig.Options or {}
					local default = drpConfig.Default
					local callback = drpConfig.Callback or function() end
					local selected = default
					
					local DrpFrame = Create("Frame", {
						Name = drpTitle,
						Parent = SecFrame,
						Size = UDim2.new(1, 0, 0, 36),
						BackgroundColor3 = COLORS.Tertiary,
						BackgroundTransparency = 0.45,
						ClipsDescendants = true
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 6)})
					})
					
					Create("TextLabel", {
						Name = "Title",
						Parent = DrpFrame,
						Position = UDim2.new(0, 12, 0, 0),
						Size = UDim2.new(0.5, 0, 0, 36),
						BackgroundTransparency = 1,
						Text = drpTitle,
						TextColor3 = COLORS.Text,
						TextSize = 13,
						Font = Enum.Font.GothamMedium,
						TextXAlignment = Enum.TextXAlignment.Left
					})
					
					local SelBtn = Create("TextButton", {
						Name = "Selected",
						Parent = DrpFrame,
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(1, -8, 0, 5),
						Size = UDim2.new(0.4, 0, 0, 26),
						BackgroundColor3 = COLORS.Secondary,
						BackgroundTransparency = 0.4,
						Text = selected or "Select...",
						TextColor3 = selected and COLORS.Text or COLORS.SubText,
						TextSize = 12,
						Font = Enum.Font.Gotham,
						AutoButtonColor = false
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 4)})
					})
					
					local OptList = Create("Frame", {
						Name = "Options",
						Parent = DrpFrame,
						Position = UDim2.new(0, 0, 0, 40),
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						Create("UIListLayout", {
							Padding = UDim.new(0, 4),
							HorizontalAlignment = Enum.HorizontalAlignment.Center
						}),
						Create("UIPadding", {
							PaddingLeft = UDim.new(0, 8),
							PaddingRight = UDim.new(0, 8),
							PaddingBottom = UDim.new(0, 8)
						})
					})
					
					local open = false
					
					local function Toggle()
						open = not open
						if open then
							local height = 40 + (#options * 30) + 12
							Tween(DrpFrame, {Size = UDim2.new(1, 0, 0, height)}, 0.2)
						else
							Tween(DrpFrame, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
						end
					end
					
					SelBtn.MouseButton1Click:Connect(Toggle)
					
					for _, opt in options do
						local OptBtn = Create("TextButton", {
							Name = opt,
							Parent = OptList,
							Size = UDim2.new(1, 0, 0, 26),
							BackgroundColor3 = COLORS.Tertiary,
							BackgroundTransparency = 0.5,
							Text = opt,
							TextColor3 = COLORS.Text,
							TextSize = 12,
							Font = Enum.Font.Gotham,
							AutoButtonColor = false
						}, {
							Create("UICorner", {CornerRadius = UDim.new(0, 4)})
						})
						
						OptBtn.MouseEnter:Connect(function() Tween(OptBtn, {BackgroundTransparency = 0.3}, 0.08) end)
						OptBtn.MouseLeave:Connect(function() Tween(OptBtn, {BackgroundTransparency = 0.5}, 0.08) end)
						OptBtn.MouseButton1Click:Connect(function()
							selected = opt
							SelBtn.Text = opt
							SelBtn.TextColor3 = COLORS.Text
							Toggle()
							callback(opt)
						end)
					end
					
					return {
						Set = function(_, val)
							selected = val
							SelBtn.Text = val
							SelBtn.TextColor3 = COLORS.Text
							callback(val)
						end
					}
				end
				
				function Section:CreateKeybind(kbConfig)
					local kbTitle = kbConfig.Title or "Keybind"
					local default = kbConfig.Default or Enum.KeyCode.Unknown
					local callback = kbConfig.Callback or function() end
					local key = default
					
					local KbFrame = Create("Frame", {
						Name = kbTitle,
						Parent = SecFrame,
						Size = UDim2.new(1, 0, 0, 36),
						BackgroundColor3 = COLORS.Tertiary,
						BackgroundTransparency = 0.45
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 6)})
					})
					
					Create("TextLabel", {
						Name = "Title",
						Parent = KbFrame,
						Position = UDim2.new(0, 12, 0, 0),
						Size = UDim2.new(0.6, 0, 1, 0),
						BackgroundTransparency = 1,
						Text = kbTitle,
						TextColor3 = COLORS.Text,
						TextSize = 13,
						Font = Enum.Font.GothamMedium,
						TextXAlignment = Enum.TextXAlignment.Left
					})
					
					local KeyBtn = Create("TextButton", {
						Name = "Key",
						Parent = KbFrame,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -10, 0.5, 0),
						Size = UDim2.new(0, 60, 0, 26),
						BackgroundColor3 = COLORS.Secondary,
						BackgroundTransparency = 0.4,
						Text = key ~= Enum.KeyCode.Unknown and key.Name or "None",
						TextColor3 = ACCENT_START,
						TextSize = 12,
						Font = Enum.Font.GothamBold,
						AutoButtonColor = false
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 4)})
					})
					
					local listening = false
					
					KeyBtn.MouseButton1Click:Connect(function()
						listening = true
						KeyBtn.Text = "..."
					end)
					
					UserInputService.InputBegan:Connect(function(input, gpe)
						if listening and input.UserInputType == Enum.UserInputType.Keyboard then
							listening = false
							key = input.KeyCode
							KeyBtn.Text = key.Name
							callback(key)
						elseif not gpe and input.KeyCode == key then
							callback(key)
						end
					end)
					
					return {
						Set = function(_, val)
							key = val
							KeyBtn.Text = key.Name
						end
					}
				end
				
				return Section
			end
			
			table.insert(Tab.SubPages, SubPage)
			
			if #Tab.SubPages == 1 then
				SubPage:Select()
			end
			
			return SubPage
		end
		
		function Tab:CreateSection(secConfig)
			local secTitle = secConfig.Title or "Section"
			
			local Section = {}
			
			local SecFrame = Create("Frame", {
				Name = secTitle,
				Parent = Page,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = COLORS.Secondary,
				BackgroundTransparency = 0.4
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
				Create("UIPadding", {
					PaddingTop = UDim.new(0, 10),
					PaddingBottom = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12)
				}),
				Create("UIListLayout", {
					Padding = UDim.new(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			})
			
			Create("TextLabel", {
				Name = "Title",
				Parent = SecFrame,
				Size = UDim2.new(1, 0, 0, 16),
				BackgroundTransparency = 1,
				Text = secTitle,
				TextColor3 = COLORS.SubText,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = -1
			})
			
			Section.CreateButton = function(_, btnConfig)
				local btnTitle = btnConfig.Title or "Button"
				local callback = btnConfig.Callback or function() end
				
				local Btn = Create("TextButton", {
					Name = btnTitle,
					Parent = SecFrame,
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = COLORS.Tertiary,
					BackgroundTransparency = 0.45,
					Text = btnTitle,
					TextColor3 = COLORS.Text,
					TextSize = 13,
					Font = Enum.Font.GothamMedium,
					AutoButtonColor = false
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
					Create("UIStroke", {Color = COLORS.Border, Thickness = 1, Transparency = 0.7})
				})
				
				Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundTransparency = 0.3}, 0.1) end)
				Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundTransparency = 0.45}, 0.1) end)
				Btn.MouseButton1Click:Connect(function()
					Tween(Btn, {BackgroundTransparency = 0.15}, 0.05)
					task.delay(0.1, function() Tween(Btn, {BackgroundTransparency = 0.45}, 0.1) end)
					callback()
				end)
				
				return Btn
			end
			
			Section.CreateToggle = function(_, togConfig)
				local togTitle = togConfig.Title or "Toggle"
				local default = togConfig.Default or false
				local callback = togConfig.Callback or function() end
				local enabled = default
				
				local TogFrame = Create("Frame", {
					Name = togTitle,
					Parent = SecFrame,
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = COLORS.Tertiary,
					BackgroundTransparency = 0.45
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 6)})
				})
				
				Create("TextLabel", {
					Name = "Title",
					Parent = TogFrame,
					Position = UDim2.new(0, 12, 0, 0),
					Size = UDim2.new(1, -60, 1, 0),
					BackgroundTransparency = 1,
					Text = togTitle,
					TextColor3 = COLORS.Text,
					TextSize = 13,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left
				})
				
				local TogBtn = Create("Frame", {
					Name = "Toggle",
					Parent = TogFrame,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -10, 0.5, 0),
					Size = UDim2.new(0, 38, 0, 20),
					BackgroundColor3 = COLORS.Secondary,
					BackgroundTransparency = 0.2
				}, {
					Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
					Create("UIStroke", {Color = COLORS.Border, Thickness = 1, Transparency = 0.6})
				})
				
				local Circle = Create("Frame", {
					Name = "Circle",
					Parent = TogBtn,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 3, 0.5, 0),
					Size = UDim2.new(0, 14, 0, 14),
					BackgroundColor3 = COLORS.SubText
				}, {
					Create("UICorner", {CornerRadius = UDim.new(1, 0)})
				})
				
				local function Update()
					if enabled then
						Tween(Circle, {Position = UDim2.new(1, -17, 0.5, 0), BackgroundColor3 = ACCENT_START}, 0.2)
						Tween(TogBtn, {BackgroundColor3 = ACCENT_END, BackgroundTransparency = 0.5}, 0.2)
					else
						Tween(Circle, {Position = UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = COLORS.SubText}, 0.2)
						Tween(TogBtn, {BackgroundColor3 = COLORS.Secondary, BackgroundTransparency = 0.2}, 0.2)
					end
					callback(enabled)
				end
				
				local btn = Create("TextButton", {
					Name = "Btn",
					Parent = TogFrame,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = "",
					AutoButtonColor = false
				})
				
				btn.MouseButton1Click:Connect(function()
					enabled = not enabled
					Update()
				end)
				
				if default then Update() end
				
				return {
					Set = function(_, val)
						enabled = val
						Update()
					end
				}
			end
			
			Section.CreateSlider = function(_, sldConfig)
				local sldTitle = sldConfig.Title or "Slider"
				local min = sldConfig.Min or 0
				local max = sldConfig.Max or 100
				local default = sldConfig.Default or min
				local callback = sldConfig.Callback or function() end
				local value = default
				
				local SldFrame = Create("Frame", {
					Name = sldTitle,
					Parent = SecFrame,
					Size = UDim2.new(1, 0, 0, 50),
					BackgroundColor3 = COLORS.Tertiary,
					BackgroundTransparency = 0.45
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 6)})
				})
				
				Create("TextLabel", {
					Name = "Title",
					Parent = SldFrame,
					Position = UDim2.new(0, 12, 0, 8),
					Size = UDim2.new(0.6, 0, 0, 16),
					BackgroundTransparency = 1,
					Text = sldTitle,
					TextColor3 = COLORS.Text,
					TextSize = 13,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left
				})
				
				local ValLabel = Create("TextLabel", {
					Name = "Value",
					Parent = SldFrame,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -12, 0, 8),
					Size = UDim2.new(0.3, 0, 0, 16),
					BackgroundTransparency = 1,
					Text = tostring(value),
					TextColor3 = ACCENT_START,
					TextSize = 13,
					Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Right
				})
				
				local SliderBg = Create("Frame", {
					Name = "SliderBg",
					Parent = SldFrame,
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.new(0.5, 0, 0, 30),
					Size = UDim2.new(1, -24, 0, 6),
					BackgroundColor3 = COLORS.Secondary,
					BackgroundTransparency = 0.3
				}, {
					Create("UICorner", {CornerRadius = UDim.new(1, 0)})
				})
				
				local Fill = Create("Frame", {
					Name = "Fill",
					Parent = SliderBg,
					Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
					BackgroundColor3 = ACCENT_START
				}, {
					Create("UICorner", {CornerRadius = UDim.new(1, 0)})
				})
				AddGradient(Fill)
				
				Create("Frame", {
					Name = "Knob",
					Parent = Fill,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.new(0, 14, 0, 14),
					BackgroundColor3 = COLORS.Text
				}, {
					Create("UICorner", {CornerRadius = UDim.new(1, 0)})
				})
				
				local sliding = false
				
				local function UpdateSlider(input)
					local pos = (input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X
					pos = math.clamp(pos, 0, 1)
					value = math.floor(min + (max - min) * pos)
					ValLabel.Text = tostring(value)
					Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.08)
					callback(value)
				end
				
				SliderBg.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						sliding = true
						UpdateSlider(input)
					end
				end)
				
				SliderBg.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						sliding = false
					end
				end)
				
				UserInputService.InputChanged:Connect(function(input)
					if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						UpdateSlider(input)
					end
				end)
				
				return {
					Set = function(_, val)
						value = math.clamp(val, min, max)
						local pos = (value - min) / (max - min)
						ValLabel.Text = tostring(value)
						Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.15)
						callback(value)
					end
				}
			end
			
			Section.CreateInput = function(_, inpConfig)
				local inpTitle = inpConfig.Title or "Input"
				local placeholder = inpConfig.Placeholder or "Enter text..."
				local callback = inpConfig.Callback or function() end
				
				local InpFrame = Create("Frame", {
					Name = inpTitle,
					Parent = SecFrame,
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = COLORS.Tertiary,
					BackgroundTransparency = 0.45
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 6)})
				})
				
				Create("TextLabel", {
					Name = "Title",
					Parent = InpFrame,
					Position = UDim2.new(0, 12, 0, 0),
					Size = UDim2.new(0.4, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = inpTitle,
					TextColor3 = COLORS.Text,
					TextSize = 13,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left
				})
				
				local Input = Create("TextBox", {
					Name = "Input",
					Parent = InpFrame,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -8, 0.5, 0),
					Size = UDim2.new(0.5, 0, 0, 26),
					BackgroundColor3 = COLORS.Secondary,
					BackgroundTransparency = 0.4,
					Text = "",
					PlaceholderText = placeholder,
					PlaceholderColor3 = COLORS.SubText,
					TextColor3 = COLORS.Text,
					TextSize = 12,
					Font = Enum.Font.Gotham,
					ClearTextOnFocus = false
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
					Create("UIPadding", {
						PaddingLeft = UDim.new(0, 8),
						PaddingRight = UDim.new(0, 8)
					})
				})
				
				Input.FocusLost:Connect(function(enter)
					if enter then
						callback(Input.Text)
					end
				end)
				
				return {
					Set = function(_, val)
						Input.Text = val
					end,
					Get = function()
						return Input.Text
					end
				}
			end
			
			Section.CreateDropdown = function(_, drpConfig)
				local drpTitle = drpConfig.Title or "Dropdown"
				local options = drpConfig.Options or {}
				local default = drpConfig.Default
				local callback = drpConfig.Callback or function() end
				local selected = default
				
				local DrpFrame = Create("Frame", {
					Name = drpTitle,
					Parent = SecFrame,
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = COLORS.Tertiary,
					BackgroundTransparency = 0.45,
					ClipsDescendants = true
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 6)})
				})
				
				Create("TextLabel", {
					Name = "Title",
					Parent = DrpFrame,
					Position = UDim2.new(0, 12, 0, 0),
					Size = UDim2.new(0.5, 0, 0, 36),
					BackgroundTransparency = 1,
					Text = drpTitle,
					TextColor3 = COLORS.Text,
					TextSize = 13,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left
				})
				
				local SelBtn = Create("TextButton", {
					Name = "Selected",
					Parent = DrpFrame,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -8, 0, 5),
					Size = UDim2.new(0.4, 0, 0, 26),
					BackgroundColor3 = COLORS.Secondary,
					BackgroundTransparency = 0.4,
					Text = selected or "Select...",
					TextColor3 = selected and COLORS.Text or COLORS.SubText,
					TextSize = 12,
					Font = Enum.Font.Gotham,
					AutoButtonColor = false
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 4)})
				})
				
				local OptList = Create("Frame", {
					Name = "Options",
					Parent = DrpFrame,
					Position = UDim2.new(0, 0, 0, 40),
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Create("UIListLayout", {
						Padding = UDim.new(0, 4),
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					Create("UIPadding", {
						PaddingLeft = UDim.new(0, 8),
						PaddingRight = UDim.new(0, 8),
						PaddingBottom = UDim.new(0, 8)
					})
				})
				
				local open = false
				
				local function Toggle()
					open = not open
					if open then
						local height = 40 + (#options * 30) + 12
						Tween(DrpFrame, {Size = UDim2.new(1, 0, 0, height)}, 0.2)
					else
						Tween(DrpFrame, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
					end
				end
				
				SelBtn.MouseButton1Click:Connect(Toggle)
				
				for _, opt in options do
					local OptBtn = Create("TextButton", {
						Name = opt,
						Parent = OptList,
						Size = UDim2.new(1, 0, 0, 26),
						BackgroundColor3 = COLORS.Tertiary,
						BackgroundTransparency = 0.5,
						Text = opt,
						TextColor3 = COLORS.Text,
						TextSize = 12,
						Font = Enum.Font.Gotham,
						AutoButtonColor = false
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 4)})
					})
					
					OptBtn.MouseEnter:Connect(function() Tween(OptBtn, {BackgroundTransparency = 0.3}, 0.08) end)
					OptBtn.MouseLeave:Connect(function() Tween(OptBtn, {BackgroundTransparency = 0.5}, 0.08) end)
					OptBtn.MouseButton1Click:Connect(function()
						selected = opt
						SelBtn.Text = opt
						SelBtn.TextColor3 = COLORS.Text
						Toggle()
						callback(opt)
					end)
				end
				
				return {
					Set = function(_, val)
						selected = val
						SelBtn.Text = val
						SelBtn.TextColor3 = COLORS.Text
						callback(val)
					end
				}
			end
			
			Section.CreateKeybind = function(_, kbConfig)
				local kbTitle = kbConfig.Title or "Keybind"
				local default = kbConfig.Default or Enum.KeyCode.Unknown
				local callback = kbConfig.Callback or function() end
				local key = default
				
				local KbFrame = Create("Frame", {
					Name = kbTitle,
					Parent = SecFrame,
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = COLORS.Tertiary,
					BackgroundTransparency = 0.45
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 6)})
				})
				
				Create("TextLabel", {
					Name = "Title",
					Parent = KbFrame,
					Position = UDim2.new(0, 12, 0, 0),
					Size = UDim2.new(0.6, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = kbTitle,
					TextColor3 = COLORS.Text,
					TextSize = 13,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left
				})
				
				local KeyBtn = Create("TextButton", {
					Name = "Key",
					Parent = KbFrame,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -10, 0.5, 0),
					Size = UDim2.new(0, 60, 0, 26),
					BackgroundColor3 = COLORS.Secondary,
					BackgroundTransparency = 0.4,
					Text = key ~= Enum.KeyCode.Unknown and key.Name or "None",
					TextColor3 = ACCENT_START,
					TextSize = 12,
					Font = Enum.Font.GothamBold,
					AutoButtonColor = false
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 4)})
				})
				
				local listening = false
				
				KeyBtn.MouseButton1Click:Connect(function()
					listening = true
					KeyBtn.Text = "..."
				end)
				
				UserInputService.InputBegan:Connect(function(input, gpe)
					if listening and input.UserInputType == Enum.UserInputType.Keyboard then
						listening = false
						key = input.KeyCode
						KeyBtn.Text = key.Name
						callback(key)
					elseif not gpe and input.KeyCode == key then
						callback(key)
					end
				end)
				
				return {
					Set = function(_, val)
						key = val
						KeyBtn.Text = key.Name
					end
				}
			end
			
			return Section
		end
		
		table.insert(Window.Tabs, Tab)
		
		if #Window.Tabs == 1 then
			Tab:Select()
		end
		
		return Tab
	end
	
	function Window:Destroy()
		Tween(self.Blur, {Size = 0}, 0.3)
		Tween(Main, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.25).Completed:Wait()
		Main:Destroy()
	end
	
	return Window
end

return Library
