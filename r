local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {}
Library.__index = Library

local ACCENT = Color3.fromRGB(255, 140, 50)
local ACCENT_DARK = Color3.fromRGB(220, 100, 30)

local COLORS = {
	Background = Color3.fromRGB(15, 17, 22),
	Sidebar = Color3.fromRGB(20, 22, 28),
	Card = Color3.fromRGB(25, 28, 36),
	CardInner = Color3.fromRGB(32, 36, 46),
	Element = Color3.fromRGB(38, 42, 54),
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(140, 145, 160),
	DimText = Color3.fromRGB(90, 95, 110),
	Border = Color3.fromRGB(50, 54, 66),
	Accent = ACCENT,
	AccentDark = ACCENT_DARK,
	Checkbox = Color3.fromRGB(45, 50, 62),
	CheckboxActive = ACCENT
}

local function Tween(obj, props, duration, style, direction)
	local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out), props)
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

function Library.new()
	local self = setmetatable({}, Library)
	self.ScreenGui = nil
	return self
end

function Library:Init()
	if self.ScreenGui then return end
	local player = Players.LocalPlayer
	local gui = player:WaitForChild("PlayerGui")
	self.ScreenGui = Create("ScreenGui", {
		Name = "UILib",
		Parent = gui,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true
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
	
	local Main = Create("Frame", {
		Name = "Main",
		Parent = self.ScreenGui,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = COLORS.Background
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 8)})
	})
	
	local Shadow = Create("ImageLabel", {
		Name = "Shadow",
		Parent = Main,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 40, 1, 40),
		BackgroundTransparency = 1,
		Image = "rbxassetid://6014261993",
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = 0.5,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		ZIndex = 0
	})
	
	local Sidebar = Create("Frame", {
		Name = "Sidebar",
		Parent = Main,
		Size = UDim2.new(0, 90, 1, 0),
		BackgroundColor3 = COLORS.Sidebar
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 8)})
	})
	
	Create("Frame", {
		Name = "Fix",
		Parent = Sidebar,
		Position = UDim2.new(1, -8, 0, 0),
		Size = UDim2.new(0, 8, 1, 0),
		BackgroundColor3 = COLORS.Sidebar,
		BorderSizePixel = 0
	})
	
	local LogoHolder = Create("Frame", {
		Name = "LogoHolder",
		Parent = Sidebar,
		Size = UDim2.new(1, 0, 0, 90),
		BackgroundTransparency = 1
	})
	
	Create("ImageLabel", {
		Name = "Logo",
		Parent = LogoHolder,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 45, 0, 45),
		BackgroundTransparency = 1,
		Image = logoId ~= 0 and "rbxassetid://" .. logoId or ""
	})
	
	local TabList = Create("ScrollingFrame", {
		Name = "TabList",
		Parent = Sidebar,
		Position = UDim2.new(0, 0, 0, 90),
		Size = UDim2.new(1, 0, 1, -90),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y
	}, {
		Create("UIListLayout", {
			Padding = UDim.new(0, 4),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Create("UIPadding", {
			PaddingTop = UDim.new(0, 5),
			PaddingBottom = UDim.new(0, 10)
		})
	})
	
	local Content = Create("Frame", {
		Name = "Content",
		Parent = Main,
		Position = UDim2.new(0, 90, 0, 0),
		Size = UDim2.new(1, -90, 1, 0),
		BackgroundTransparency = 1
	})
	
	local Header = Create("Frame", {
		Name = "Header",
		Parent = Content,
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundTransparency = 1
	}, {
		Create("UIPadding", {
			PaddingLeft = UDim.new(0, 15),
			PaddingRight = UDim.new(0, 15),
			PaddingTop = UDim.new(0, 12)
		})
	})
	
	local TabTitleLabel = Create("TextLabel", {
		Name = "TabTitle",
		Parent = Header,
		Size = UDim2.new(0, 200, 0, 26),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = COLORS.Text,
		TextSize = 15,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local TabIcon = Create("ImageLabel", {
		Name = "TabIcon",
		Parent = TabTitleLabel,
		Size = UDim2.new(0, 16, 0, 16),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Image = "",
		ImageColor3 = COLORS.SubText
	})
	
	local SearchBox = Create("Frame", {
		Name = "SearchBox",
		Parent = Header,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, 180, 0, 28),
		BackgroundColor3 = COLORS.Card,
		BackgroundTransparency = 0.3
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
		Create("UIStroke", {Color = COLORS.Border, Thickness = 1, Transparency = 0.7})
	})
	
	local SearchInput = Create("TextBox", {
		Name = "Input",
		Parent = SearchBox,
		Position = UDim2.new(0, 30, 0, 0),
		Size = UDim2.new(1, -35, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		PlaceholderText = "Search Items...",
		PlaceholderColor3 = COLORS.DimText,
		TextColor3 = COLORS.Text,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false
	})
	
	Create("ImageLabel", {
		Name = "SearchIcon",
		Parent = SearchBox,
		Position = UDim2.new(0, 8, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(0, 14, 0, 14),
		BackgroundTransparency = 1,
		Image = "rbxassetid://6031154871",
		ImageColor3 = COLORS.DimText
	})
	
	local Pages = Create("Frame", {
		Name = "Pages",
		Parent = Content,
		Position = UDim2.new(0, 0, 0, 50),
		Size = UDim2.new(1, 0, 1, -50),
		BackgroundTransparency = 1,
		ClipsDescendants = true
	})
	
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
			Tween(Main, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.08)
		end
	end)
	
	Tween(Main, {Size = UDim2.new(0, 720, 0, 480)}, 0.35, Enum.EasingStyle.Back)
	
	function Window:CreateTab(tabConfig)
		local tabTitle = tabConfig.Title or "Tab"
		local tabIcon = tabConfig.Icon or "rbxassetid://6031071053"
		
		local Tab = {
			Sections = {},
			AllElements = {}
		}
		
		local TabBtn = Create("TextButton", {
			Name = tabTitle,
			Parent = TabList,
			Size = UDim2.new(0, 70, 0, 65),
			BackgroundColor3 = COLORS.Card,
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
			Position = UDim2.new(0.5, 0, 0, 12),
			Size = UDim2.new(0, 20, 0, 20),
			BackgroundTransparency = 1,
			Image = tabIcon,
			ImageColor3 = COLORS.SubText
		})
		
		local Title = Create("TextLabel", {
			Name = "Title",
			Parent = TabBtn,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 36),
			Size = UDim2.new(1, -8, 0, 22),
			BackgroundTransparency = 1,
			Text = tabTitle,
			TextColor3 = COLORS.SubText,
			TextSize = 10,
			Font = Enum.Font.GothamMedium,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
		
		local Page = Create("ScrollingFrame", {
			Name = tabTitle .. "Page",
			Parent = Pages,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = COLORS.Border,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false
		}, {
			Create("UIPadding", {
				PaddingTop = UDim.new(0, 5),
				PaddingBottom = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 15),
				PaddingRight = UDim.new(0, 15)
			})
		})
		
		local ColumnHolder = Create("Frame", {
			Name = "Columns",
			Parent = Page,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		}, {
			Create("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 10),
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			})
		})
		
		local LeftColumn = Create("Frame", {
			Name = "Left",
			Parent = ColumnHolder,
			Size = UDim2.new(0.5, -5, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		}, {
			Create("UIListLayout", {
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		})
		
		local RightColumn = Create("Frame", {
			Name = "Right",
			Parent = ColumnHolder,
			Size = UDim2.new(0.5, -5, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		}, {
			Create("UIListLayout", {
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		})
		
		local sectionCount = 0
		
		local function SelectTab()
			for _, t in Window.Tabs do
				if t ~= Tab then t:Deselect() end
			end
			Window.ActiveTab = Tab
			Page.Visible = true
			TabTitleLabel.Text = "    " .. tabTitle
			TabIcon.Image = tabIcon
			Tween(TabBtn, {BackgroundTransparency = 0.5}, 0.15)
			Tween(Icon, {ImageColor3 = ACCENT}, 0.15)
			Tween(Title, {TextColor3 = COLORS.Text}, 0.15)
		end
		
		function Tab:Deselect()
			Page.Visible = false
			Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
			Tween(Icon, {ImageColor3 = COLORS.SubText}, 0.15)
			Tween(Title, {TextColor3 = COLORS.SubText}, 0.15)
		end
		
		function Tab:Select()
			SelectTab()
		end
		
		TabBtn.MouseButton1Click:Connect(SelectTab)
		TabBtn.MouseEnter:Connect(function()
			if Window.ActiveTab ~= Tab then
				Tween(TabBtn, {BackgroundTransparency = 0.7}, 0.1)
			end
		end)
		TabBtn.MouseLeave:Connect(function()
			if Window.ActiveTab ~= Tab then
				Tween(TabBtn, {BackgroundTransparency = 1}, 0.1)
			end
		end)
		
		function Tab:CreateSection(secConfig)
			local secTitle = secConfig.Title or "Section"
			local secDesc = secConfig.Description or ""
			
			sectionCount = sectionCount + 1
			local parent = sectionCount % 2 == 1 and LeftColumn or RightColumn
			
			local Section = {}
			
			local SecFrame = Create("Frame", {
				Name = secTitle,
				Parent = parent,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = COLORS.Card,
				LayoutOrder = sectionCount
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
				Create("UIPadding", {
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12),
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12)
				}),
				Create("UIListLayout", {
					Padding = UDim.new(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			})
			
			local HeaderFrame = Create("Frame", {
				Name = "Header",
				Parent = SecFrame,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = -1
			})
			
			local IconBg = Create("Frame", {
				Name = "IconBg",
				Parent = HeaderFrame,
				Size = UDim2.new(0, 32, 0, 32),
				BackgroundColor3 = ACCENT,
				BackgroundTransparency = 0.85
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 6)})
			})
			
			Create("ImageLabel", {
				Name = "Icon",
				Parent = IconBg,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 16, 0, 16),
				BackgroundTransparency = 1,
				Image = "rbxassetid://6031154871",
				ImageColor3 = ACCENT
			})
			
			Create("TextLabel", {
				Name = "Title",
				Parent = HeaderFrame,
				Position = UDim2.new(0, 42, 0, 0),
				Size = UDim2.new(1, -42, 0, 16),
				BackgroundTransparency = 1,
				Text = secTitle,
				TextColor3 = COLORS.Text,
				TextSize = 13,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			Create("TextLabel", {
				Name = "Desc",
				Parent = HeaderFrame,
				Position = UDim2.new(0, 42, 0, 16),
				Size = UDim2.new(1, -42, 0, 14),
				BackgroundTransparency = 1,
				Text = secDesc,
				TextColor3 = COLORS.DimText,
				TextSize = 10,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd
			})
			
			function Section:CreateToggle(togConfig)
				local togTitle = togConfig.Title or "Toggle"
				local default = togConfig.Default or false
				local keybind = togConfig.Keybind
				local settings = togConfig.Settings
				local callback = togConfig.Callback or function() end
				local enabled = default
				
				local TogFrame = Create("Frame", {
					Name = togTitle,
					Parent = SecFrame,
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundColor3 = COLORS.Element,
					BackgroundTransparency = 0.5
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 6)})
				})
				
				table.insert(Tab.AllElements, {Frame = TogFrame, Title = togTitle})
				
				local Checkbox = Create("Frame", {
					Name = "Checkbox",
					Parent = TogFrame,
					Position = UDim2.new(0, 8, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0, 18, 0, 18),
					BackgroundColor3 = COLORS.Checkbox
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
					Create("UIStroke", {Color = COLORS.Border, Thickness = 1, Transparency = 0.5})
				})
				
				local Check = Create("ImageLabel", {
					Name = "Check",
					Parent = Checkbox,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 12, 0, 12),
					BackgroundTransparency = 1,
					Image = "rbxassetid://6031094678",
					ImageColor3 = COLORS.Text,
					ImageTransparency = 1
				})
				
				Create("TextLabel", {
					Name = "Title",
					Parent = TogFrame,
					Position = UDim2.new(0, 34, 0, 0),
					Size = UDim2.new(1, -90, 1, 0),
					BackgroundTransparency = 1,
					Text = togTitle,
					TextColor3 = COLORS.Text,
					TextSize = 12,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left
				})
				
				local rightOffset = 8
				
				if keybind then
					local KeyBtn = Create("TextButton", {
						Name = "Keybind",
						Parent = TogFrame,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -rightOffset, 0.5, 0),
						Size = UDim2.new(0, 45, 0, 20),
						BackgroundColor3 = COLORS.CardInner,
						Text = keybind.Name or "None",
						TextColor3 = COLORS.SubText,
						TextSize = 10,
						Font = Enum.Font.GothamMedium,
						AutoButtonColor = false
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 4)})
					})
					
					rightOffset = rightOffset + 53
					
					local listening = false
					local key = keybind
					
					KeyBtn.MouseButton1Click:Connect(function()
						listening = true
						KeyBtn.Text = "..."
					end)
					
					UserInputService.InputBegan:Connect(function(input, gpe)
						if listening and input.UserInputType == Enum.UserInputType.Keyboard then
							listening = false
							key = input.KeyCode
							KeyBtn.Text = key.Name
						elseif not gpe and input.KeyCode == key then
							enabled = not enabled
							UpdateToggle()
						end
					end)
				end
				
				if settings then
					local SettingsBtn = Create("ImageButton", {
						Name = "Settings",
						Parent = TogFrame,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -rightOffset, 0.5, 0),
						Size = UDim2.new(0, 20, 0, 20),
						BackgroundColor3 = COLORS.CardInner,
						Image = "rbxassetid://6031280882",
						ImageColor3 = COLORS.SubText,
						AutoButtonColor = false
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 4)})
					})
					
					SettingsBtn.MouseEnter:Connect(function()
						Tween(SettingsBtn, {ImageColor3 = ACCENT}, 0.1)
					end)
					SettingsBtn.MouseLeave:Connect(function()
						Tween(SettingsBtn, {ImageColor3 = COLORS.SubText}, 0.1)
					end)
					SettingsBtn.MouseButton1Click:Connect(settings)
				end
				
				local function UpdateToggle()
					if enabled then
						Tween(Checkbox, {BackgroundColor3 = ACCENT}, 0.15)
						Tween(Check, {ImageTransparency = 0}, 0.15)
					else
						Tween(Checkbox, {BackgroundColor3 = COLORS.Checkbox}, 0.15)
						Tween(Check, {ImageTransparency = 1}, 0.15)
					end
					callback(enabled)
				end
				
				local btn = Create("TextButton", {
					Name = "Btn",
					Parent = TogFrame,
					Size = UDim2.new(0, 100, 1, 0),
					BackgroundTransparency = 1,
					Text = "",
					AutoButtonColor = false
				})
				
				btn.MouseButton1Click:Connect(function()
					enabled = not enabled
					UpdateToggle()
				end)
				
				if default then UpdateToggle() end
				
				return {
					Set = function(_, val)
						enabled = val
						UpdateToggle()
					end,
					Get = function()
						return enabled
					end
				}
			end
			
			function Section:CreateInput(inpConfig)
				local inpTitle = inpConfig.Title or "Input"
				local placeholder = inpConfig.Placeholder or "TextBox"
				local callback = inpConfig.Callback or function() end
				
				local InpFrame = Create("Frame", {
					Name = inpTitle,
					Parent = SecFrame,
					Size = UDim2.new(1, 0, 0, 50),
					BackgroundColor3 = COLORS.Element,
					BackgroundTransparency = 0.5
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 6)})
				})
				
				table.insert(Tab.AllElements, {Frame = InpFrame, Title = inpTitle})
				
				Create("TextLabel", {
					Name = "Title",
					Parent = InpFrame,
					Position = UDim2.new(0, 10, 0, 6),
					Size = UDim2.new(1, -20, 0, 14),
					BackgroundTransparency = 1,
					Text = inpTitle,
					TextColor3 = COLORS.SubText,
					TextSize = 10,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left
				})
				
				local InputBox = Create("Frame", {
					Name = "InputBox",
					Parent = InpFrame,
					Position = UDim2.new(0, 8, 0, 22),
					Size = UDim2.new(1, -16, 0, 22),
					BackgroundColor3 = COLORS.CardInner
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 4)})
				})
				
				local Input = Create("TextBox", {
					Name = "Input",
					Parent = InputBox,
					Position = UDim2.new(0, 8, 0, 0),
					Size = UDim2.new(1, -32, 1, 0),
					BackgroundTransparency = 1,
					Text = "",
					PlaceholderText = placeholder,
					PlaceholderColor3 = COLORS.DimText,
					TextColor3 = COLORS.Text,
					TextSize = 11,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					ClearTextOnFocus = false
				})
				
				Create("ImageLabel", {
					Name = "Edit",
					Parent = InputBox,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -6, 0.5, 0),
					Size = UDim2.new(0, 12, 0, 12),
					BackgroundTransparency = 1,
					Image = "rbxassetid://6031280882",
					ImageColor3 = COLORS.DimText
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
					BackgroundColor3 = COLORS.Element,
					BackgroundTransparency = 0.5
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 6)})
				})
				
				table.insert(Tab.AllElements, {Frame = SldFrame, Title = sldTitle})
				
				Create("TextLabel", {
					Name = "Title",
					Parent = SldFrame,
					Position = UDim2.new(0, 10, 0, 6),
					Size = UDim2.new(0.7, 0, 0, 14),
					BackgroundTransparency = 1,
					Text = sldTitle,
					TextColor3 = COLORS.SubText,
					TextSize = 10,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left
				})
				
				local ValLabel = Create("TextLabel", {
					Name = "Value",
					Parent = SldFrame,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -10, 0, 6),
					Size = UDim2.new(0.25, 0, 0, 14),
					BackgroundTransparency = 1,
					Text = tostring(value),
					TextColor3 = ACCENT,
					TextSize = 11,
					Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Right
				})
				
				local SliderBg = Create("Frame", {
					Name = "SliderBg",
					Parent = SldFrame,
					Position = UDim2.new(0, 10, 0, 28),
					Size = UDim2.new(1, -20, 0, 8),
					BackgroundColor3 = COLORS.CardInner
				}, {
					Create("UICorner", {CornerRadius = UDim.new(1, 0)})
				})
				
				local Fill = Create("Frame", {
					Name = "Fill",
					Parent = SliderBg,
					Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
					BackgroundColor3 = ACCENT
				}, {
					Create("UICorner", {CornerRadius = UDim.new(1, 0)})
				})
				
				local sliding = false
				
				local function UpdateSlider(input)
					local pos = (input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X
					pos = math.clamp(pos, 0, 1)
					value = math.floor(min + (max - min) * pos)
					ValLabel.Text = tostring(value)
					Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.06)
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
					end,
					Get = function()
						return value
					end
				}
			end
			
			function Section:CreateDropdown(drpConfig)
				local drpTitle = drpConfig.Title or "Dropdown"
				local options = drpConfig.Options or {}
				local default = drpConfig.Default
				local multi = drpConfig.Multi or false
				local callback = drpConfig.Callback or function() end
				local selected = multi and {} or default
				
				if multi and default then
					for _, v in default do
						selected[v] = true
					end
				end
				
				local DrpFrame = Create("Frame", {
					Name = drpTitle,
					Parent = SecFrame,
					Size = UDim2.new(1, 0, 0, 50),
					BackgroundColor3 = COLORS.Element,
					BackgroundTransparency = 0.5,
					ClipsDescendants = true
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 6)})
				})
				
				table.insert(Tab.AllElements, {Frame = DrpFrame, Title = drpTitle})
				
				Create("TextLabel", {
					Name = "Title",
					Parent = DrpFrame,
					Position = UDim2.new(0, 10, 0, 6),
					Size = UDim2.new(1, -20, 0, 14),
					BackgroundTransparency = 1,
					Text = drpTitle,
					TextColor3 = COLORS.SubText,
					TextSize = 10,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left
				})
				
				local function GetDisplayText()
					if multi then
						local arr = {}
						for k, v in selected do
							if v then table.insert(arr, k) end
						end
						return #arr > 0 and table.concat(arr, " , ") or "Select..."
					else
						return selected or "Select..."
					end
				end
				
				local SelBtn = Create("TextButton", {
					Name = "Selected",
					Parent = DrpFrame,
					Position = UDim2.new(0, 8, 0, 22),
					Size = UDim2.new(1, -16, 0, 22),
					BackgroundColor3 = COLORS.CardInner,
					Text = "  " .. GetDisplayText(),
					TextColor3 = COLORS.Text,
					TextSize = 11,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutoButtonColor = false
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 4)})
				})
				
				Create("ImageLabel", {
					Name = "Arrow",
					Parent = SelBtn,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -6, 0.5, 0),
					Size = UDim2.new(0, 12, 0, 12),
					BackgroundTransparency = 1,
					Image = "rbxassetid://6034818372",
					ImageColor3 = COLORS.SubText
				})
				
				local OptList = Create("Frame", {
					Name = "Options",
					Parent = DrpFrame,
					Position = UDim2.new(0, 8, 0, 48),
					Size = UDim2.new(1, -16, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				}, {
					Create("UIListLayout", {
						Padding = UDim.new(0, 4),
						SortOrder = Enum.SortOrder.LayoutOrder
					})
				})
				
				local open = false
				
				local function Toggle()
					open = not open
					if open then
						local height = 52 + (#options * 26) + 8
						Tween(DrpFrame, {Size = UDim2.new(1, 0, 0, height)}, 0.2)
					else
						Tween(DrpFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.2)
					end
				end
				
				SelBtn.MouseButton1Click:Connect(Toggle)
				
				for _, opt in options do
					local OptBtn = Create("TextButton", {
						Name = opt,
						Parent = OptList,
						Size = UDim2.new(1, 0, 0, 22),
						BackgroundColor3 = COLORS.CardInner,
						BackgroundTransparency = 0.5,
						Text = "  " .. opt,
						TextColor3 = COLORS.Text,
						TextSize = 11,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutoButtonColor = false
					}, {
						Create("UICorner", {CornerRadius = UDim.new(0, 4)})
					})
					
					OptBtn.MouseEnter:Connect(function() Tween(OptBtn, {BackgroundTransparency = 0.3}, 0.08) end)
					OptBtn.MouseLeave:Connect(function() Tween(OptBtn, {BackgroundTransparency = 0.5}, 0.08) end)
					OptBtn.MouseButton1Click:Connect(function()
						if multi then
							selected[opt] = not selected[opt]
							SelBtn.Text = "  " .. GetDisplayText()
							callback(selected)
						else
							selected = opt
							SelBtn.Text = "  " .. opt
							Toggle()
							callback(opt)
						end
					end)
				end
				
				return {
					Set = function(_, val)
						if multi then
							selected = {}
							for _, v in val do
								selected[v] = true
							end
						else
							selected = val
						end
						SelBtn.Text = "  " .. GetDisplayText()
						callback(multi and selected or val)
					end,
					Get = function()
						return selected
					end
				}
			end
			
			function Section:CreateButton(btnConfig)
				local btnTitle = btnConfig.Title or "Button"
				local callback = btnConfig.Callback or function() end
				
				local Btn = Create("TextButton", {
					Name = btnTitle,
					Parent = SecFrame,
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundColor3 = COLORS.Element,
					BackgroundTransparency = 0.5,
					Text = btnTitle,
					TextColor3 = COLORS.SubText,
					TextSize = 12,
					Font = Enum.Font.GothamMedium,
					AutoButtonColor = false
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 6)})
				})
				
				table.insert(Tab.AllElements, {Frame = Btn, Title = btnTitle})
				
				Btn.MouseEnter:Connect(function()
					Tween(Btn, {BackgroundTransparency = 0.3, TextColor3 = COLORS.Text}, 0.1)
				end)
				Btn.MouseLeave:Connect(function()
					Tween(Btn, {BackgroundTransparency = 0.5, TextColor3 = COLORS.SubText}, 0.1)
				end)
				Btn.MouseButton1Click:Connect(function()
					Tween(Btn, {BackgroundTransparency = 0.1}, 0.05)
					task.delay(0.1, function() Tween(Btn, {BackgroundTransparency = 0.5}, 0.1) end)
					callback()
				end)
				
				return Btn
			end
			
			table.insert(Tab.Sections, Section)
			return Section
		end
		
		SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
			local query = SearchInput.Text:lower()
			for _, elem in Tab.AllElements do
				if query == "" then
					elem.Frame.Visible = true
				else
					elem.Frame.Visible = elem.Title:lower():find(query, 1, true) ~= nil
				end
			end
		end)
		
		table.insert(Window.Tabs, Tab)
		
		if #Window.Tabs == 1 then
			Tab:Select()
		end
		
		return Tab
	end
	
	function Window:Destroy()
		Tween(Main, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.25).Completed:Wait()
		Main:Destroy()
	end
	
	return Window
end

return Library
