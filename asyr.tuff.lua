local tweenservice = game:GetService("TweenService")
local userinput = game:GetService("UserInputService")
local marketplace = game:GetService("MarketplaceService")
local players = game:GetService("Players")

local library = {}
library.colors = {
	accent = Color3.fromRGB(13, 155, 255),
	background = Color3.fromRGB(19, 20, 25),
	secondary = Color3.fromRGB(16, 17, 21),
	text = Color3.fromRGB(255, 255, 255),
	subtext = Color3.fromRGB(69, 71, 90),
	border = Color3.fromRGB(31, 31, 45),
	stroke = Color3.fromRGB(28, 30, 38)
}
library.flags = {}
library.tabs = {}
library.activetab = nil

local player = players.LocalPlayer

local function tween(obj, props, time, style)
	local t = tweenservice:Create(obj, TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
	t:Play()
	return t
end

local function create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props) do
		if k ~= "Parent" then obj[k] = v end
	end
	if props.Parent then obj.Parent = props.Parent end
	return obj
end

local function getgamename()
	local ok, info = pcall(function()
		return marketplace:GetProductInfo(game.PlaceId)
	end)
	return ok and info and info.Name or "Unknown"
end

function library:create(cfg)
	cfg = cfg or {}
	local title = cfg.title or "ZZZ"
	local accent = cfg.accent or library.colors.accent
	local gamename = getgamename()
	
	library.colors.accent = accent
	
	local gui = create("ScreenGui", {
		Name = "zzzlib",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})
	
	if syn and syn.protect_gui then
		syn.protect_gui(gui)
		gui.Parent = player.PlayerGui
	elseif gethui then
		gui.Parent = gethui()
	else
		gui.Parent = game:GetService("CoreGui")
	end
	
	local main = create("Frame", {
		Name = "main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = library.colors.background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, 0),
		Parent = gui
	})
	create("UICorner", {CornerRadius = UDim.new(0, 11), Parent = main})
	
	local header = create("Frame", {
		Name = "header",
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, 37),
		Parent = main
	})
	
	create("Frame", {
		Name = "line",
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = library.colors.border,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 2),
		Parent = header
	})
	
	local icon = create("ImageLabel", {
		Name = "icon",
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0.5, 0),
		Size = UDim2.new(0, 28, 0, 28),
		Image = cfg.icon or "rbxassetid://72138752430505",
		ScaleType = Enum.ScaleType.Fit,
		Parent = header
	})
	
	local titlelbl = create("TextLabel", {
		Name = "title",
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 46, 0.5, 0),
		Size = UDim2.new(0, 250, 0, 20),
		Font = Enum.Font.GothamBold,
		Text = title .. '  <font color="#45475a">' .. gamename .. '</font>',
		RichText = true,
		TextColor3 = library.colors.text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = header
	})
	
	local sidebar = create("Frame", {
		Name = "sidebar",
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(0, 75, 1, -37),
		Parent = main
	})
	
	create("Frame", {
		Name = "line",
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = library.colors.border,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, 2, 1, 0),
		Parent = sidebar
	})
	
	local tabholder = create("Frame", {
		Name = "tabs",
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Parent = sidebar
	})
	create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), Parent = tabholder})
	create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), Parent = tabholder})
	
	local subheader = create("Frame", {
		Name = "subheader",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 75, 0, 37),
		Size = UDim2.new(1, -75, 0, 45),
		ClipsDescendants = true,
		Parent = main
	})
	
	local subtabholder = create("Frame", {
		Name = "subtabs",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = subheader
	})
	create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Parent = subtabholder
	})
	create("UIPadding", {PaddingLeft = UDim.new(0, 20), Parent = subtabholder})
	
	local pagecontainer = create("Frame", {
		Name = "pages",
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = library.colors.secondary,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.new(1, -2, 1, -2),
		Size = UDim2.new(1, -79, 1, -86),
		Parent = main
	})
	create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = pagecontainer})
	
	local window = {
		gui = gui,
		main = main,
		header = header,
		tabholder = tabholder,
		subtabholder = subtabholder,
		pagecontainer = pagecontainer,
		tabs = {},
		activetab = nil
	}
	
	local dragging, dragstart, startpos
	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragstart = input.Position
			startpos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	userinput.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragstart
			tween(main, {Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)}, 0.06)
		end
	end)
	
	main.Size = UDim2.new(0, 0, 0, 0)
	main.BackgroundTransparency = 1
	tween(main, {Size = UDim2.new(0, 695, 0, 489), BackgroundTransparency = 0}, 0.45, Enum.EasingStyle.Back)
	
	function window:addtab(cfg)
		cfg = cfg or {}
		local name = cfg.name or "Tab"
		local tabicon = cfg.icon or "rbxassetid://80869096876893"
		
		local tab = {
			name = name,
			subpages = {},
			activesubpage = nil
		}
		
		local btn = create("Frame", {
			Name = name,
			BackgroundColor3 = library.colors.text,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = UDim2.new(0, 55, 0, 60),
			Parent = tabholder
		})
		create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = btn})
		
		local icn = create("ImageLabel", {
			Name = "icon",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, -8),
			Size = UDim2.new(0, 24, 0, 22),
			Image = tabicon,
			ImageColor3 = library.colors.subtext,
			Parent = btn
		})
		
		local lbl = create("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 20),
			Size = UDim2.new(1, 0, 0, 20),
			Font = Enum.Font.GothamMedium,
			Text = name,
			TextColor3 = library.colors.subtext,
			TextSize = 11,
			Parent = btn
		})
		
		local indicator = create("Frame", {
			Name = "indicator",
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = library.colors.accent,
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 0, 1, 3),
			Size = UDim2.new(0, 0, 0, 5),
			Parent = btn
		})
		create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = indicator})
		create("UIGradient", {
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))},
			Parent = indicator
		})
		
		tab.btn = btn
		tab.icon = icn
		tab.label = lbl
		tab.indicator = indicator
		tab.window = window
		
		local click = create("TextButton", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "", Parent = btn})
		
		click.MouseButton1Click:Connect(function()
			window:switchtab(tab)
		end)
		
		click.MouseEnter:Connect(function()
			if window.activetab ~= tab then
				tween(btn, {BackgroundTransparency = 0.85}, 0.2)
			end
		end)
		
		click.MouseLeave:Connect(function()
			if window.activetab ~= tab then
				tween(btn, {BackgroundTransparency = 1}, 0.2)
			end
		end)
		
		table.insert(window.tabs, tab)
		
		if #window.tabs == 1 then
			window:switchtab(tab)
		end
		
		function tab:addsubpage(cfg)
			cfg = cfg or {}
			local subname = cfg.name or "Page"
			
			local subpage = {name = subname}
			
			local subbtn = create("Frame", {
				Name = subname,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 80, 0, 35),
				Visible = false,
				Parent = subtabholder
			})
			
			local sublbl = create("TextLabel", {
				Name = "name",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = library.colors.accent,
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 0, 0, 0),
				Font = Enum.Font.GothamMedium,
				Text = subname,
				TextColor3 = library.colors.subtext,
				TextSize = 13,
				TextTransparency = 0.15,
				AutomaticSize = Enum.AutomaticSize.XY,
				Parent = subbtn
			})
			create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = sublbl})
			create("UIPadding", {PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 8), Parent = sublbl})
			
			local subindicator = create("Frame", {
				Name = "indicator",
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = library.colors.accent,
				BorderSizePixel = 0,
				Position = UDim2.new(0.5, 0, 1, 2),
				Size = UDim2.new(0, 0, 0, 3),
				Parent = subbtn
			})
			create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = subindicator})
			create("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))},
				Parent = subindicator
			})
			
			local page = create("ScrollingFrame", {
				Name = subname,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, -20, 1, -20),
				ScrollBarImageColor3 = Color3.fromRGB(50, 50, 60),
				ScrollBarThickness = 3,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				Visible = false,
				Parent = pagecontainer
			})
			create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), Parent = page})
			create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), Parent = page})
			
			function subpage:addsection(cfg)
				cfg = cfg or {}
				local secname = cfg.name or "Section"
				local secicon = cfg.icon or "rbxassetid://83273732891006"
				
				local section = {name = secname, elements = {}}
				
				local secframe = create("Frame", {
					Name = secname,
					BackgroundColor3 = Color3.fromRGB(17, 18, 22),
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Size = UDim2.new(1, 0, 0, 32),
					AutomaticSize = Enum.AutomaticSize.Y,
					Parent = page
				})
				create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = secframe})
				
				local secheader = create("Frame", {
					Name = "header",
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundColor3 = library.colors.background,
					BorderSizePixel = 0,
					Position = UDim2.new(0.5, 0, 0, 0),
					Size = UDim2.new(1, 0, 0, 32),
					Parent = secframe
				})
				
				local headerinner = create("Frame", {
					Name = "inner",
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 1, 0),
					ClipsDescendants = true,
					Parent = secheader
				})
				
				local accentline = create("Frame", {
					Name = "line",
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundColor3 = library.colors.accent,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(0, 3, 0, 18),
					Parent = headerinner
				})
				create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = accentline})
				
				local secicn = create("ImageLabel", {
					Name = "icon",
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 14, 0.5, 0),
					Size = UDim2.new(0, 14, 0, 14),
					Image = secicon,
					ImageColor3 = library.colors.accent,
					Parent = headerinner
				})
				
				local seclbl = create("TextLabel", {
					Name = "name",
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 36, 0.5, 0),
					Size = UDim2.new(1, -48, 0, 20),
					Font = Enum.Font.GothamMedium,
					Text = secname,
					TextColor3 = library.colors.text,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = headerinner
				})
				
				local secholder = create("Frame", {
					Name = "holder",
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0, 32),
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Parent = secframe
				})
				create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = secholder})
				create("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 8), Parent = secholder})
				
				section.frame = secframe
				section.holder = secholder
				section.subpage = subpage
				
				function section:addtoggle(cfg)
					cfg = cfg or {}
					local tname = cfg.name or "Toggle"
					local tdefault = cfg.default or false
					local tcallback = cfg.callback or function() end
					local tflag = cfg.flag
					
					local toggle = {
						name = tname,
						value = tdefault,
						callback = tcallback
					}
					
					if tflag then
						library.flags[tflag] = tdefault
					end
					
					local tframe = create("Frame", {
						Name = tname,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 28),
						Parent = secholder
					})
					
					local tbox = create("Frame", {
						Name = "box",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = tdefault and library.colors.accent or Color3.fromRGB(24, 25, 32),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 14, 0.5, 0),
						Size = UDim2.new(0, 14, 0, 14),
						Parent = tframe
					})
					create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = tbox})
					
					local tcheck = create("ImageLabel", {
						Name = "check",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 8, 0, 7),
						Image = "rbxassetid://83899464799881",
						ImageTransparency = tdefault and 0 or 1,
						Parent = tbox
					})
					
					local tlbl = create("TextLabel", {
						Name = "name",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 36, 0.5, 0),
						Size = UDim2.new(1, -48, 0, 20),
						Font = Enum.Font.Gotham,
						Text = tname,
						TextColor3 = tdefault and library.colors.text or library.colors.subtext,
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = tframe
					})
					
					local tbtn = create("TextButton", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						Text = "",
						Parent = tframe
					})
					
					local function setstate(state, nocallback)
						toggle.value = state
						if tflag then
							library.flags[tflag] = state
						end
						
						if state then
							tween(tbox, {BackgroundColor3 = library.colors.accent}, 0.2)
							tween(tcheck, {ImageTransparency = 0}, 0.15)
							tween(tlbl, {TextColor3 = library.colors.text}, 0.2)
						else
							tween(tbox, {BackgroundColor3 = Color3.fromRGB(24, 25, 32)}, 0.2)
							tween(tcheck, {ImageTransparency = 1}, 0.15)
							tween(tlbl, {TextColor3 = library.colors.subtext}, 0.2)
						end
						
						if not nocallback then
							task.spawn(tcallback, state)
						end
					end
					
					tbtn.MouseButton1Click:Connect(function()
						setstate(not toggle.value)
					end)
					
					tbtn.MouseEnter:Connect(function()
						if not toggle.value then
							tween(tbox, {BackgroundColor3 = Color3.fromRGB(30, 32, 42)}, 0.15)
						end
					end)
					
					tbtn.MouseLeave:Connect(function()
						if not toggle.value then
							tween(tbox, {BackgroundColor3 = Color3.fromRGB(24, 25, 32)}, 0.15)
						end
					end)
					
					toggle.set = setstate
					toggle.frame = tframe
					
					if tdefault then
						task.spawn(tcallback, true)
					end
					
					table.insert(section.elements, toggle)
					return toggle
				end
				
				return section
			end
			
			subpage.btn = subbtn
			subpage.label = sublbl
			subpage.indicator = subindicator
			subpage.container = page
			subpage.tab = tab
			
			local subclick = create("TextButton", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "", Parent = subbtn})
			
			subclick.MouseButton1Click:Connect(function()
				window:switchsubpage(tab, subpage)
			end)
			
			table.insert(tab.subpages, subpage)
			
			-- Make subpage button visible if this is the active tab
			if window.activetab == tab then
				subbtn.Visible = true
			end
			
			-- Activate first subpage of the active tab
			if #tab.subpages == 1 and window.activetab == tab then
				tab.activesubpage = subpage
				-- Set initial state without animation for first subpage
				subpage.container.Visible = true
				subpage.label.BackgroundTransparency = 0.8
				subpage.label.TextColor3 = library.colors.text
				subpage.indicator.Size = UDim2.new(0, 34, 0, 3)
			end
			
			return subpage
		end
		
		return tab
	end
	
	function window:switchtab(tab)
		if window.activetab == tab then return end
		
		if window.activetab then
			local old = window.activetab
			tween(old.btn, {BackgroundTransparency = 1}, 0.25)
			tween(old.icon, {ImageColor3 = library.colors.subtext}, 0.25)
			tween(old.label, {TextColor3 = library.colors.subtext}, 0.25)
			tween(old.indicator, {Size = UDim2.new(0, 0, 0, 5)}, 0.25)
			
			for _, sub in ipairs(old.subpages) do
				sub.btn.Visible = false
			end
			
			if old.activesubpage then
				old.activesubpage.container.Visible = false
			end
		end
		
		window.activetab = tab
		
		tween(tab.btn, {BackgroundTransparency = 0.9}, 0.25)
		tween(tab.icon, {ImageColor3 = library.colors.accent}, 0.25)
		tween(tab.label, {TextColor3 = library.colors.text}, 0.25)
		tween(tab.indicator, {Size = UDim2.new(0, 25, 0, 5)}, 0.3, Enum.EasingStyle.Back)
		
		for _, sub in ipairs(tab.subpages) do
			sub.btn.Visible = true
		end
		
		if tab.activesubpage then
			tab.activesubpage.container.Visible = true
			
			tween(tab.activesubpage.label, {BackgroundTransparency = 0.8, TextColor3 = library.colors.text}, 0.2)
			tween(tab.activesubpage.indicator, {Size = UDim2.new(0, 34, 0, 3)}, 0.25, Enum.EasingStyle.Back)
		elseif #tab.subpages > 0 then
			window:switchsubpage(tab, tab.subpages[1])
		end
	end
	
	function window:switchsubpage(tab, subpage)
		if tab.activesubpage == subpage then
			subpage.container.Visible = true
			return
		end
		
		if tab.activesubpage then
			local old = tab.activesubpage
			tween(old.label, {BackgroundTransparency = 1, TextColor3 = library.colors.subtext}, 0.2)
			tween(old.indicator, {Size = UDim2.new(0, 0, 0, 3)}, 0.2)
			old.container.Visible = false
		end
		
		tab.activesubpage = subpage
		
		tween(subpage.label, {BackgroundTransparency = 0.8, TextColor3 = library.colors.text}, 0.2)
		tween(subpage.indicator, {Size = UDim2.new(0, 34, 0, 3)}, 0.25, Enum.EasingStyle.Back)
		
		subpage.container.Visible = true
		subpage.container.CanvasPosition = Vector2.new(0, 0)
	end
	
	function window:destroy()
		tween(main, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
		task.delay(0.35, function()
			gui:Destroy()
		end)
	end
	
	local notifholder = create("Frame", {
		Name = "notifications",
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -20, 0, 20),
		Size = UDim2.new(0, 280, 1, -40),
		Parent = gui
	})
	create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		Parent = notifholder
	})
	
	local notiftypes = {
		success = {
			color = Color3.fromRGB(47, 255, 0),
			icon = "rbxassetid://92431556586885"
		},
		warning = {
			color = Color3.fromRGB(255, 214, 10),
			icon = "rbxassetid://70479764730792"
		},
		error = {
			color = Color3.fromRGB(255, 75, 75),
			icon = "rbxassetid://124971904960139"
		}
	}
	
	function window:notify(cfg)
		cfg = cfg or {}
		local ntype = cfg.type or "success"
		local ntitle = cfg.title or "Notification"
		local ndesc = cfg.description or ""
		local nduration = cfg.duration or 4
		
		local typedata = notiftypes[ntype] or notiftypes.success
		
		local notif = create("Frame", {
			Name = "notif",
			BackgroundColor3 = library.colors.background,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 0, 0),
			Parent = notifholder
		})
		create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = notif})
		
		local content = create("Frame", {
			Name = "content",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Parent = notif
		})
		
		local iconholder = create("Frame", {
			Name = "iconholder",
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0.5, -8),
			Size = UDim2.new(0, 24, 0, 24),
			Parent = content
		})
		
		local icn = create("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 18, 0, 18),
			Image = typedata.icon,
			ImageColor3 = typedata.color,
			Parent = iconholder
		})
		
		local titlelbl = create("TextLabel", {
			Name = "title",
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 44, 0, 10),
			Size = UDim2.new(1, -56, 0, 16),
			Font = Enum.Font.GothamMedium,
			Text = ntitle,
			TextColor3 = library.colors.text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = content
		})
		
		local desclbl = create("TextLabel", {
			Name = "desc",
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 44, 0, 28),
			Size = UDim2.new(1, -56, 0, 28),
			Font = Enum.Font.Gotham,
			Text = ndesc,
			TextColor3 = library.colors.subtext,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = content
		})
		
		local progressbg = create("Frame", {
			Name = "progressbg",
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.fromRGB(30, 31, 38),
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, 3),
			Parent = notif
		})
		
		local progress = create("Frame", {
			Name = "progress",
			BackgroundColor3 = typedata.color,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Parent = progressbg
		})
		create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = progress})
		
		local closebtn = create("TextButton", {
			Name = "close",
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -8, 0, 8),
			Size = UDim2.new(0, 20, 0, 20),
			Text = "",
			Parent = content
		})
		
		local closeicon = create("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 12, 0, 12),
			Image = "rbxassetid://124971904960139",
			ImageColor3 = library.colors.subtext,
			Parent = closebtn
		})
		
		local closed = false
		local function closenotif()
			if closed then return end
			closed = true
			tween(notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
			task.delay(0.3, function()
				notif:Destroy()
			end)
		end
		
		closebtn.MouseButton1Click:Connect(closenotif)
		closebtn.MouseEnter:Connect(function()
			tween(closeicon, {ImageColor3 = library.colors.text}, 0.15)
		end)
		closebtn.MouseLeave:Connect(function()
			tween(closeicon, {ImageColor3 = library.colors.subtext}, 0.15)
		end)
		
		tween(notif, {Size = UDim2.new(1, 0, 0, 68)}, 0.35, Enum.EasingStyle.Back)
		tween(progress, {Size = UDim2.new(0, 0, 1, 0)}, nduration, Enum.EasingStyle.Linear)
		
		task.delay(nduration, closenotif)
		
		return {
			close = closenotif
		}
	end
	
	return window
end

return library
