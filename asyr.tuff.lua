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

local function safecall(window, name, callback, ...)
	local args = {...}
	local success, err = pcall(function()
		callback(unpack(args))
	end)
	if not success and window and window.notify then
		window:notify({
			type = "error",
			title = "Error in " .. (name or "callback"),
			description = tostring(err) .. " - Please report this to our devs!",
			duration = 8
		})
		warn("[UI Library Error] " .. (name or "callback") .. ": " .. tostring(err))
	end
	return success
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
							task.spawn(function()
								safecall(tab.window, "Toggle: " .. tname, tcallback, state)
							end)
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
						task.spawn(function()
							safecall(tab.window, "Toggle: " .. tname, tcallback, true)
						end)
					end

					table.insert(section.elements, toggle)
					return toggle
				end

				function section:addbutton(cfg)
					cfg = cfg or {}
					local bname = cfg.name or "Button"
					local bcallback = cfg.callback or function() end

					local button = {
						name = bname,
						callback = bcallback
					}

					local bframe = create("Frame", {
						Name = bname,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 32),
						Parent = secholder
					})

					local bbtn = create("Frame", {
						Name = "btn",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Color3.fromRGB(24, 25, 32),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 14, 0.5, 0),
						Size = UDim2.new(1, -28, 0, 26),
						ClipsDescendants = true,
						Parent = bframe
					})
					create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = bbtn})
					create("UIStroke", {
						Color = Color3.fromRGB(35, 36, 45),
						Thickness = 1,
						Parent = bbtn
					})

					local blbl = create("TextLabel", {
						Name = "label",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(1, -16, 1, 0),
						Font = Enum.Font.GothamMedium,
						Text = bname,
						TextColor3 = library.colors.subtext,
						TextSize = 12,
						Parent = bbtn
					})

					local rippleholder = create("Frame", {
						Name = "ripples",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						ClipsDescendants = true,
						Parent = bbtn
					})

					local bclick = create("TextButton", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						Text = "",
						ZIndex = 2,
						Parent = bbtn
					})

					local function createripple(x, y)
						local ripple = create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = library.colors.accent,
							BackgroundTransparency = 0.7,
							Position = UDim2.new(0, x - bbtn.AbsolutePosition.X, 0, y - bbtn.AbsolutePosition.Y),
							Size = UDim2.new(0, 0, 0, 0),
							Parent = rippleholder
						})
						create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ripple})

						local size = math.max(bbtn.AbsoluteSize.X, bbtn.AbsoluteSize.Y) * 2
						tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.4)
						task.delay(0.4, function()
							ripple:Destroy()
						end)
					end

					bclick.MouseButton1Click:Connect(function()
						tween(bbtn, {BackgroundColor3 = library.colors.accent}, 0.1)
						tween(blbl, {TextColor3 = library.colors.text}, 0.1)
						task.delay(0.15, function()
							tween(bbtn, {BackgroundColor3 = Color3.fromRGB(30, 32, 42)}, 0.2)
							tween(blbl, {TextColor3 = library.colors.subtext}, 0.2)
						end)

						local mouse = player:GetMouse()
						createripple(mouse.X, mouse.Y)

						task.spawn(function()
							safecall(tab.window, "Button: " .. bname, bcallback)
						end)
					end)

					bclick.MouseEnter:Connect(function()
						tween(bbtn, {BackgroundColor3 = Color3.fromRGB(30, 32, 42)}, 0.15)
						tween(blbl, {TextColor3 = library.colors.text}, 0.15)
						tween(bbtn.UIStroke, {Color = library.colors.accent}, 0.15)
					end)

					bclick.MouseLeave:Connect(function()
						tween(bbtn, {BackgroundColor3 = Color3.fromRGB(24, 25, 32)}, 0.15)
						tween(blbl, {TextColor3 = library.colors.subtext}, 0.15)
						tween(bbtn.UIStroke, {Color = Color3.fromRGB(35, 36, 45)}, 0.15)
					end)

					button.frame = bframe
					button.btn = bbtn
					button.label = blbl

					table.insert(section.elements, button)
					return button
				end

				-- Slider component matching hi.txt design exactly
				function section:addslider(cfg)
					cfg = cfg or {}
					local sname = cfg.name or "Slider"
					local smin = cfg.min or 0
					local smax = cfg.max or 100
					local sdefault = cfg.default or smin
					local sincrement = cfg.increment or 1
					local scallback = cfg.callback or function() end
					local sflag = cfg.flag
					local ssuffix = cfg.suffix or ""

					sdefault = math.clamp(sdefault, smin, smax)

					local slider = {
						name = sname,
						value = sdefault,
						min = smin,
						max = smax,
						callback = scallback
					}

					if sflag then
						library.flags[sflag] = sdefault
					end

					-- Main frame - 40px height like hi.txt
					local sframe = create("Frame", {
						Name = sname,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 40),
						Parent = secholder
					})

					-- Label on left - Position 23, 0.5, -8 like hi.txt
					local slbl = create("TextLabel", {
						Name = "label",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 23, 0.5, -8),
						Size = UDim2.new(0, 1, 0, 1),
						Font = Enum.Font.Gotham,
						Text = sname,
						TextColor3 = library.colors.subtext,
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = sframe
					})

					-- Value on right - Position 1, -22, 0.5, -8 like hi.txt
					local svalue = create("TextLabel", {
						Name = "value",
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, -22, 0.5, -8),
						Size = UDim2.new(0, 1, 0, 1),
						Font = Enum.Font.GothamMedium,
						Text = tostring(sdefault) .. ssuffix,
						TextColor3 = library.colors.text,
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Right,
						Parent = sframe
					})

					-- Progress background - 4px height, position at 0.5, 13 like hi.txt
					local progressbg = create("Frame", {
						Name = "progressbg",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Color3.fromRGB(24, 25, 32),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 23, 0.5, 13),
						Size = UDim2.new(1, -46, 0, 4),
						Parent = sframe
					})
					create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = progressbg})
					create("UIStroke", {
						Color = Color3.fromRGB(28, 30, 38),
						Thickness = 1,
						Parent = progressbg
					})

					local initialpercent = (sdefault - smin) / (smax - smin)

					-- Progress fill - 7px height like hi.txt
					local progress = create("Frame", {
						Name = "progress",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = library.colors.accent,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(initialpercent, 0, 0, 7),
						Parent = progressbg
					})
					create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = progress})
					create("UIGradient", {
						Color = ColorSequence.new{
							ColorSequenceKeypoint.new(0, Color3.fromRGB(254, 254, 254)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 147, 147))
						},
						Parent = progress
					})

					-- Pointer - 6x6 like hi.txt
					local pointer = create("Frame", {
						Name = "pointer",
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderSizePixel = 0,
						Position = UDim2.new(1, 0, 0.5, 0),
						Size = UDim2.new(0, 6, 0, 6),
						Parent = progress
					})
					create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = pointer})

					-- Design glow - 14x14 with 0.5 transparency like hi.txt
					local design = create("Frame", {
						Name = "design",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 0.5,
						BorderSizePixel = 0,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 14, 0, 14),
						Parent = pointer
					})
					create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = design})

					-- Clickable area covering the whole slider area for easier clicking
					local sclick = create("TextButton", {
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(1, 0, 1, 0),
						Text = "",
						ZIndex = 2,
						Parent = progressbg
					})

					local dragging = false

					local function roundtoincrement(value)
						return math.floor(value / sincrement + 0.5) * sincrement
					end

					local function updateslider(percent, nocallback)
						percent = math.clamp(percent, 0, 1)
						local rawvalue = smin + (smax - smin) * percent
						local newvalue = roundtoincrement(rawvalue)
						newvalue = math.clamp(newvalue, smin, smax)

						slider.value = newvalue
						if sflag then
							library.flags[sflag] = newvalue
						end

						local actualpercent = (newvalue - smin) / (smax - smin)
						-- Smooth tween animation
						tween(progress, {Size = UDim2.new(actualpercent, 0, 0, 7)}, 0.1, Enum.EasingStyle.Quad)
						svalue.Text = tostring(newvalue) .. ssuffix

						if not nocallback then
							task.spawn(function()
								safecall(tab.window, "Slider: " .. sname, scallback, newvalue)
							end)
						end
					end

					local function setvalue(value, nocallback)
						value = math.clamp(value, smin, smax)
						local percent = (value - smin) / (smax - smin)
						updateslider(percent, nocallback)
					end

					local function handleinput(input)
						local sliderpos = progressbg.AbsolutePosition.X
						local slidersize = progressbg.AbsoluteSize.X
						local mousepos = input.Position.X
						local percent = (mousepos - sliderpos) / slidersize
						updateslider(percent)
					end

					sclick.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = true
							handleinput(input)
						end
					end)

					userinput.InputChanged:Connect(function(input)
						if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
							handleinput(input)
						end
					end)

					userinput.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = false
						end
					end)

					slider.frame = sframe
					slider.label = slbl
					slider.valuelabel = svalue
					slider.progressbg = progressbg
					slider.progress = progress
					slider.pointer = pointer
					slider.set = setvalue

					if sdefault ~= smin then
						task.spawn(function()
							safecall(tab.window, "Slider: " .. sname, scallback, sdefault)
						end)
					end

					table.insert(section.elements, slider)
					return slider
				end

				-- Dropdown component (single/multi select) - Mentality style + hi.txt design
				function section:adddropdown(cfg)
					cfg = cfg or {}
					local dname = cfg.name or "Dropdown"
					local doptions = cfg.options or {"Option 1", "Option 2", "Option 3"}
					local ddefault = cfg.default
					local dcallback = cfg.callback or function() end
					local dflag = cfg.flag
					local dmulti = cfg.multi or false

					local dropdown = {
						name = dname,
						options = doptions,
						multi = dmulti,
						value = dmulti and {} or nil,
						isopen = false,
						optionframes = {},
						callback = dcallback
					}

					if dflag then
						library.flags[dflag] = dropdown.value
					end

					-- Main dropdown frame - 55px height like hi.txt
					local dframe = create("Frame", {
						Name = dname,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 55),
						ClipsDescendants = false,
						Parent = secholder
					})

					-- Label at top
					local dlbl = create("TextLabel", {
						Name = "label",
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 25, 0, 12),
						Size = UDim2.new(0, 1, 0, 1),
						Font = Enum.Font.Gotham,
						Text = dname,
						TextColor3 = Color3.fromRGB(204, 204, 209),
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = dframe
					})

					-- Holder box - the clickable dropdown area
					local holder = create("Frame", {
						Name = "holder",
						AnchorPoint = Vector2.new(0.5, 1),
						BackgroundColor3 = Color3.fromRGB(24, 25, 32),
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Position = UDim2.new(0.5, 0, 1, 0),
						Size = UDim2.new(1, -46, 0, 22),
						Parent = dframe
					})
					create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = holder})
					create("UIStroke", {
						Color = Color3.fromRGB(28, 30, 38),
						Thickness = 1,
						Parent = holder
					})

					-- Selected value text with gradient
					local valuetext = create("TextLabel", {
						Name = "value",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.025, 0, 0.5, 0),
						Size = UDim2.new(1, -50, 1, 0),
						Font = Enum.Font.GothamMedium,
						Text = "...",
						TextColor3 = library.colors.accent,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = holder
					})
					create("UIGradient", {
						Color = ColorSequence.new{
							ColorSequenceKeypoint.new(0, Color3.fromRGB(254, 254, 254)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 147, 147))
						},
						Parent = valuetext
					})

					-- Left accent line
					local lineLeft = create("Frame", {
						Name = "lineLeft",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = library.colors.accent,
						BorderSizePixel = 0,
						Position = UDim2.new(0, -4, 0.5, 0),
						Size = UDim2.new(0, 6, 0, 13),
						Parent = holder
					})
					create("UICorner", {CornerRadius = UDim.new(0, 30), Parent = lineLeft})
					create("UIGradient", {
						Color = ColorSequence.new{
							ColorSequenceKeypoint.new(0, Color3.fromRGB(254, 254, 254)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 147, 147))
						},
						Parent = lineLeft
					})

					-- Right accent line
					local lineRight = create("Frame", {
						Name = "lineRight",
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundColor3 = library.colors.accent,
						BorderSizePixel = 0,
						Position = UDim2.new(1, 4, 0.5, 0),
						Size = UDim2.new(0, 6, 0, 13),
						Parent = holder
					})
					create("UICorner", {CornerRadius = UDim.new(0, 30), Parent = lineRight})
					create("UIGradient", {
						Color = ColorSequence.new{
							ColorSequenceKeypoint.new(0, Color3.fromRGB(254, 254, 254)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 147, 147))
						},
						Parent = lineRight
					})

					-- Arrow icon
					local arrow = create("ImageLabel", {
						Name = "arrow",
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, -6, 0.5, 0),
						Size = UDim2.new(0, 12, 0, 12),
						Image = "rbxassetid://6031091004",
						ImageColor3 = Color3.fromRGB(141, 141, 150),
						Rotation = 0,
						Parent = holder
					})

					-- Click button
					local holderBtn = create("TextButton", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						Text = "",
						ZIndex = 2,
						Parent = holder
					})

					-- Option holder (dropdown list) - appears in the GUI root for proper layering
					local optionholder = create("Frame", {
						Name = "optionholder",
						BackgroundColor3 = Color3.fromRGB(20, 21, 26),
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(0, 0, 0, 0),
						Visible = false,
						ZIndex = 50,
						Parent = tab.window.gui
					})
					create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = optionholder})
					create("UIStroke", {
						Color = Color3.fromRGB(35, 36, 45),
						Thickness = 1,
						Parent = optionholder
					})

					local optionscroll = create("ScrollingFrame", {
						Name = "scroll",
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 6, 0, 6),
						Size = UDim2.new(1, -12, 1, -12),
						ScrollBarImageColor3 = library.colors.accent,
						ScrollBarThickness = 2,
						CanvasSize = UDim2.new(0, 0, 0, 0),
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						ZIndex = 51,
						Parent = optionholder
					})
					create("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 2),
						Parent = optionscroll
					})

					local function updateposition()
						if not dropdown.isopen then return end
						local abspos = holder.AbsolutePosition
						local abssize = holder.AbsoluteSize
						optionholder.Position = UDim2.new(0, abspos.X, 0, abspos.Y + abssize.Y + 4)
						optionholder.Size = UDim2.new(0, abssize.X, 0, math.min(#doptions * 24 + 12, 150))
					end

					local function updatetext()
						if dmulti then
							if #dropdown.value > 0 then
								valuetext.Text = table.concat(dropdown.value, ", ")
							else
								valuetext.Text = "..."
							end
						else
							valuetext.Text = dropdown.value or "..."
						end
					end

					-- Create option buttons
					local function createoption(optname)
						local optbtn = create("Frame", {
							Name = optname,
							BackgroundColor3 = Color3.fromRGB(30, 31, 40),
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 22),
							ZIndex = 52,
							Parent = optionscroll
						})
						create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = optbtn})

						-- Accent dot (like Mentality)
						local optaccent = create("Frame", {
							Name = "accent",
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundColor3 = library.colors.accent,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 8, 0.5, 0),
							Size = UDim2.new(0, 4, 0, 4),
							ZIndex = 53,
							Parent = optbtn
						})
						create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = optaccent})
						create("UIGradient", {
							Color = ColorSequence.new{
								ColorSequenceKeypoint.new(0, Color3.fromRGB(254, 254, 254)),
								ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 147, 147))
							},
							Parent = optaccent
						})

						local optlbl = create("TextLabel", {
							Name = "label",
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 8, 0.5, 0),
							Size = UDim2.new(1, -16, 1, 0),
							Font = Enum.Font.Gotham,
							Text = optname,
							TextColor3 = library.colors.subtext,
							TextSize = 12,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTransparency = 0.3,
							ZIndex = 53,
							Parent = optbtn
						})

						local optclick = create("TextButton", {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							Text = "",
							ZIndex = 54,
							Parent = optbtn
						})

						local optdata = {
							name = optname,
							frame = optbtn,
							label = optlbl,
							accent = optaccent,
							selected = false
						}

						local function setactive(active)
							optdata.selected = active
							if active then
								tween(optlbl, {TextTransparency = 0, Position = UDim2.new(0, 20, 0.5, 0)}, 0.2)
								tween(optaccent, {BackgroundTransparency = 0}, 0.2)
							else
								tween(optlbl, {TextTransparency = 0.3, Position = UDim2.new(0, 8, 0.5, 0)}, 0.2)
								tween(optaccent, {BackgroundTransparency = 1}, 0.2)
							end
						end

						optclick.MouseEnter:Connect(function()
							if not optdata.selected then
								tween(optbtn, {BackgroundTransparency = 0}, 0.15)
								tween(optlbl, {TextColor3 = library.colors.text}, 0.15)
							end
						end)

						optclick.MouseLeave:Connect(function()
							if not optdata.selected then
								tween(optbtn, {BackgroundTransparency = 1}, 0.15)
								tween(optlbl, {TextColor3 = library.colors.subtext}, 0.15)
							end
						end)

						optclick.MouseButton1Click:Connect(function()
							if dmulti then
								local idx = table.find(dropdown.value, optname)
								if idx then
									table.remove(dropdown.value, idx)
									setactive(false)
								else
									table.insert(dropdown.value, optname)
									setactive(true)
								end
								if dflag then
									library.flags[dflag] = dropdown.value
								end
							else
								-- Single select
								for _, opt in pairs(dropdown.optionframes) do
									if opt.name == optname then
										opt.selected = true
										setactive(true)
									else
										opt.selected = false
										tween(opt.label, {TextTransparency = 0.3, Position = UDim2.new(0, 8, 0.5, 0)}, 0.2)
										tween(opt.accent, {BackgroundTransparency = 1}, 0.2)
										tween(opt.frame, {BackgroundTransparency = 1}, 0.15)
									end
								end
								dropdown.value = optname
								if dflag then
									library.flags[dflag] = dropdown.value
								end
								-- Close after selection for single select
								task.delay(0.1, function()
									dropdown:close()
								end)
							end
							updatetext()
							task.spawn(function()
								safecall(tab.window, "Dropdown: " .. dname, dcallback, dropdown.value)
							end)
						end)

						dropdown.optionframes[optname] = optdata
						return optdata
					end

					-- Create all options
					for i, opt in ipairs(doptions) do
						createoption(opt)
					end

					local function openDropdown()
						dropdown.isopen = true
						optionholder.Visible = true
						updateposition()

						-- Animate open
						local targetHeight = math.min(#doptions * 24 + 12, 150)
						optionholder.Size = UDim2.new(0, holder.AbsoluteSize.X, 0, 0)
						tween(optionholder, {Size = UDim2.new(0, holder.AbsoluteSize.X, 0, targetHeight)}, 0.25, Enum.EasingStyle.Back)
						tween(arrow, {Rotation = 180}, 0.2)

						-- Staggered animation for options (Mentality style)
						for i, opt in ipairs(doptions) do
							local optdata = dropdown.optionframes[opt]
							if optdata then
								optdata.label.Position = UDim2.new(0, 30, 0.5, 0)
								if optdata.selected then
									optdata.accent.Position = UDim2.new(0, 30, 0.5, 0)
								end
								task.delay(i * 0.03, function()
									if optdata.selected then
										tween(optdata.accent, {Position = UDim2.new(0, 8, 0.5, 0)}, 0.3, Enum.EasingStyle.Quint)
										tween(optdata.label, {Position = UDim2.new(0, 20, 0.5, 0)}, 0.3, Enum.EasingStyle.Quint)
									else
										tween(optdata.label, {Position = UDim2.new(0, 8, 0.5, 0)}, 0.3, Enum.EasingStyle.Quint)
									end
								end)
							end
						end
					end

					local function closeDropdown()
						dropdown.isopen = false
						tween(optionholder, {Size = UDim2.new(0, holder.AbsoluteSize.X, 0, 0)}, 0.2)
						tween(arrow, {Rotation = 0}, 0.2)
						task.delay(0.2, function()
							if not dropdown.isopen then
								optionholder.Visible = false
							end
						end)
					end

					function dropdown:open()
						openDropdown()
					end

					function dropdown:close()
						closeDropdown()
					end

					function dropdown:toggle()
						if dropdown.isopen then
							closeDropdown()
						else
							openDropdown()
						end
					end

					function dropdown:set(value, nocallback)
						if dmulti then
							if type(value) == "table" then
								dropdown.value = value
								for _, opt in pairs(dropdown.optionframes) do
									local isSelected = table.find(value, opt.name) ~= nil
									opt.selected = isSelected
									if isSelected then
										opt.label.Position = UDim2.new(0, 20, 0.5, 0)
										opt.label.TextTransparency = 0
										opt.accent.BackgroundTransparency = 0
									else
										opt.label.Position = UDim2.new(0, 8, 0.5, 0)
										opt.label.TextTransparency = 0.3
										opt.accent.BackgroundTransparency = 1
									end
								end
							end
						else
							dropdown.value = value
							for _, opt in pairs(dropdown.optionframes) do
								local isSelected = opt.name == value
								opt.selected = isSelected
								if isSelected then
									opt.label.Position = UDim2.new(0, 20, 0.5, 0)
									opt.label.TextTransparency = 0
									opt.accent.BackgroundTransparency = 0
								else
									opt.label.Position = UDim2.new(0, 8, 0.5, 0)
									opt.label.TextTransparency = 0.3
									opt.accent.BackgroundTransparency = 1
								end
							end
						end
						if dflag then
							library.flags[dflag] = dropdown.value
						end
						updatetext()
						if not nocallback then
							task.spawn(function()
								safecall(tab.window, "Dropdown: " .. dname, dcallback, dropdown.value)
							end)
						end
					end

					function dropdown:refresh(newoptions)
						-- Clear old options
						for _, opt in pairs(dropdown.optionframes) do
							opt.frame:Destroy()
						end
						dropdown.optionframes = {}
						doptions = newoptions
						dropdown.options = newoptions

						-- Reset value
						if dmulti then
							dropdown.value = {}
						else
							dropdown.value = nil
						end

						-- Create new options
						for i, opt in ipairs(newoptions) do
							createoption(opt)
						end
						updatetext()
					end

					holderBtn.MouseButton1Click:Connect(function()
						dropdown:toggle()
					end)

					-- Close when clicking outside
					userinput.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							if dropdown.isopen then
								local mousePos = userinput:GetMouseLocation()
								local holderPos = holder.AbsolutePosition
								local holderSize = holder.AbsoluteSize
								local listPos = optionholder.AbsolutePosition
								local listSize = optionholder.AbsoluteSize

								local inHolder = mousePos.X >= holderPos.X and mousePos.X <= holderPos.X + holderSize.X and
									mousePos.Y >= holderPos.Y and mousePos.Y <= holderPos.Y + holderSize.Y
								local inList = mousePos.X >= listPos.X and mousePos.X <= listPos.X + listSize.X and
									mousePos.Y >= listPos.Y and mousePos.Y <= listPos.Y + listSize.Y

								if not inHolder and not inList then
									dropdown:close()
								end
							end
						end
					end)

					-- Update position on scroll
					page:GetPropertyChangedSignal("CanvasPosition"):Connect(updateposition)

					dropdown.frame = dframe
					dropdown.holder = holder
					dropdown.valuetext = valuetext
					dropdown.optionholder = optionholder

					-- Set default value
					if ddefault then
						dropdown:set(ddefault, true)
					end

					table.insert(section.elements, dropdown)
					return dropdown
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

			if window.activetab == tab then
				subbtn.Visible = true
			end

			if #tab.subpages == 1 and window.activetab == tab then
				tab.activesubpage = subpage
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
			icon = "rbxassetid://70479764730792"
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
