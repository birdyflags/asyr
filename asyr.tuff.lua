-- Uilibraryrework.lua
-- Reworked UI Library - Acrylic/Glassmorphism style
-- Compatible with Roblox Studio StarterGui and exploits

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local library = {}
library.flags = {}
library.colors = {
	accent      = Color3.fromRGB(99, 102, 241),   -- indigo/blue
	background  = Color3.fromRGB(15, 15, 20),      -- near black
	surface     = Color3.fromRGB(22, 22, 30),      -- slightly lighter
	surface2    = Color3.fromRGB(28, 28, 38),      -- cards
	border      = Color3.fromRGB(45, 45, 65),      -- subtle border
	text        = Color3.fromRGB(235, 235, 245),   -- white-ish
	subtext     = Color3.fromRGB(110, 110, 140),   -- muted
	toggleOff   = Color3.fromRGB(40, 40, 55),      -- toggle bg off
	sectionline = Color3.fromRGB(60, 60, 90),      -- section divider
}

-- ── helpers ──────────────────────────────────────────────────────────────────
local function tween(obj, props, t, style)
	TweenService:Create(obj, TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props) do
		if k ~= "Parent" then obj[k] = v end
	end
	if props.Parent then obj.Parent = props.Parent end
	return obj
end

local function saferun(cb, ...)
	local ok, err = pcall(cb, ...)
	if not ok then warn("[UIRework] " .. tostring(err)) end
end

-- ── main create ──────────────────────────────────────────────────────────────
function library:create(cfg)
	cfg = cfg or {}
	local title  = cfg.title  or "HUB"
	local accent = cfg.accent or library.colors.accent
	library.colors.accent = accent

	local player = Players.LocalPlayer

	-- root gui
	local gui = create("ScreenGui", {
		Name            = "UIRework",
		ResetOnSpawn    = false,
		ZIndexBehavior  = Enum.ZIndexBehavior.Global,
		IgnoreGuiInset  = true,
	})

	-- parent safely
	local ok = pcall(function() gui.Parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui") end)
	if not ok then
		pcall(function() gui.Parent = game:GetService("CoreGui") end)
	end

	-- ── main frame (acrylic dark) ─────────────────────────────────────────────
	local main = create("Frame", {
		Name             = "Main",
		AnchorPoint      = Vector2.new(0.5, 0.5),
		BackgroundColor3 = library.colors.background,
		BackgroundTransparency = 0.08,
		BorderSizePixel  = 0,
		Position         = UDim2.new(0.5, 0, 0.5, 0),
		Size             = UDim2.new(0, 680, 0, 460),
		Parent           = gui,
	})
	create("UICorner",  {CornerRadius = UDim.new(0, 12), Parent = main})
	create("UIStroke",  {Color = library.colors.border, Thickness = 1.2, Parent = main})

	-- subtle inner glow overlay
	local glowOverlay = create("Frame", {
		Name = "GlowOverlay",
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		BackgroundTransparency = 0.97,
		BorderSizePixel = 0,
		Size = UDim2.new(1,0,1,0),
		Parent = main,
	})
	create("UICorner", {CornerRadius = UDim.new(0,12), Parent = glowOverlay})

	-- ── LEFT SIDEBAR ─────────────────────────────────────────────────────────
	local sidebar = create("Frame", {
		Name             = "Sidebar",
		BackgroundColor3 = library.colors.surface,
		BackgroundTransparency = 0.1,
		BorderSizePixel  = 0,
		Size             = UDim2.new(0, 58, 1, 0),
		Parent           = main,
	})
	create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = sidebar})
	-- clip right corners
	local sidebarSquare = create("Frame", {
		BackgroundColor3 = library.colors.surface,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -12, 0, 0),
		Size = UDim2.new(0, 12, 1, 0),
		Parent = sidebar,
	})

	-- logo at top
	local logoFrame = create("Frame", {
		Name = "LogoFrame",
		BackgroundColor3 = library.colors.accent,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 14),
		Size = UDim2.new(0, 36, 0, 36),
		Parent = sidebar,
	})
	create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = logoFrame})

	local logoLabel = create("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Text = string.sub(title, 1, 1):upper(),
		TextColor3 = Color3.fromRGB(255,255,255),
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		Parent = logoFrame,
	})

	-- tab icon list
	local tabList = create("Frame", {
		Name = "TabList",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 62),
		Size = UDim2.new(1, -10, 1, -70),
		Parent = sidebar,
	})
	create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Parent = tabList,
	})
	create("UIPadding", {PaddingTop = UDim.new(0, 4), Parent = tabList})

	-- ── TOP BAR ──────────────────────────────────────────────────────────────
	local topbar = create("Frame", {
		Name = "Topbar",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 58, 0, 0),
		Size = UDim2.new(1, -58, 0, 44),
		Parent = main,
	})

	-- sub-tab scroll frame
	local subTabScroll = create("ScrollingFrame", {
		Name = "SubTabScroll",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 16, 0, 0),
		Size = UDim2.new(1, -60, 1, 0),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.X,
		Parent = topbar,
	})
	create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4),
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Parent = subTabScroll,
	})

	-- search button (top right)
	local searchBtn = create("Frame", {
		Name = "SearchBtn",
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = library.colors.surface2,
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.new(0, 28, 0, 28),
		Parent = topbar,
	})
	create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = searchBtn})
	create("UIStroke", {Color = library.colors.border, Thickness = 1, Parent = searchBtn})
	create("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 14, 0, 14),
		Image = "rbxassetid://6031091004",
		ImageColor3 = library.colors.subtext,
		Rotation = 45,
		Parent = searchBtn,
	})

	-- divider under topbar
	create("Frame", {
		Name = "TopDivider",
		BackgroundColor3 = library.colors.border,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 58, 0, 44),
		Size = UDim2.new(1, -58, 0, 1),
		Parent = main,
	})

	-- ── PAGE CONTAINER ────────────────────────────────────────────────────────
	local pageContainer = create("Frame", {
		Name = "PageContainer",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 58, 0, 45),
		Size = UDim2.new(1, -64, 1, -51),
		ClipsDescendants = true,
		Parent = main,
	})

	-- ── DRAGGING ─────────────────────────────────────────────────────────────
	local dragging, dragStart, startPos
	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	-- open animation
	main.Size = UDim2.new(0, 0, 0, 0)
	main.BackgroundTransparency = 1
	tween(main, {Size = UDim2.new(0, 680, 0, 460), BackgroundTransparency = 0.08}, 0.45, Enum.EasingStyle.Back)

	-- ── WINDOW OBJECT ─────────────────────────────────────────────────────────
	local window = {
		gui           = gui,
		main          = main,
		tabList       = tabList,
		subTabScroll  = subTabScroll,
		pageContainer = pageContainer,
		tabs          = {},
		activetab     = nil,
	}

	-- ── switchtab ─────────────────────────────────────────────────────────────
	function window:switchtab(tab)
		if self.activetab == tab then return end
		if self.activetab then
			local old = self.activetab
			tween(old.iconBg, {BackgroundTransparency = 1}, 0.2)
			tween(old.iconImg, {ImageColor3 = library.colors.subtext}, 0.2)
			for _, sub in ipairs(old.subpages) do sub.btn.Visible = false end
			if old.activesubpage then old.activesubpage.page.Visible = false end
		end
		self.activetab = tab
		tween(tab.iconBg,  {BackgroundTransparency = 0.75}, 0.2)
		tween(tab.iconImg, {ImageColor3 = library.colors.accent}, 0.2)
		for _, sub in ipairs(tab.subpages) do sub.btn.Visible = true end
		if tab.activesubpage then
			tab.activesubpage.page.Visible = true
		elseif #tab.subpages > 0 then
			self:switchsubpage(tab, tab.subpages[1])
		end
	end

	-- ── switchsubpage ─────────────────────────────────────────────────────────
	function window:switchsubpage(tab, subpage)
		if tab.activesubpage == subpage then
			subpage.page.Visible = true
			return
		end
		if tab.activesubpage then
			local old = tab.activesubpage
			old.page.Visible = false
			tween(old.label, {TextColor3 = library.colors.subtext, TextTransparency = 0.15}, 0.18)
			tween(old.indicator, {BackgroundTransparency = 1}, 0.18)
		end
		tab.activesubpage = subpage
		subpage.page.Visible = true
		tween(subpage.label, {TextColor3 = library.colors.accent, TextTransparency = 0}, 0.18)
		tween(subpage.indicator, {BackgroundTransparency = 0}, 0.18)
		subpage.page.CanvasPosition = Vector2.new(0, 0)
	end

	-- ── destroy ───────────────────────────────────────────────────────────────
	function window:destroy()
		tween(main, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
		task.delay(0.35, function() gui:Destroy() end)
	end

	-- ── addtab ────────────────────────────────────────────────────────────────
	function window:addtab(cfg)
		cfg = cfg or {}
		local name    = cfg.name or "Tab"
		local icon    = cfg.icon or "rbxassetid://80869096876893"

		local tab = { name = name, subpages = {}, activesubpage = nil }

		-- icon button
		local iconBg = create("Frame", {
			Name = name,
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = library.colors.accent,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 40, 0, 40),
			Parent = tabList,
		})
		create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = iconBg})

		local iconImg = create("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 22, 0, 22),
			Image = icon,
			ImageColor3 = library.colors.subtext,
			Parent = iconBg,
		})

		local iconBtn = create("TextButton", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = "",
			Parent = iconBg,
		})
		iconBtn.MouseButton1Click:Connect(function() window:switchtab(tab) end)
		iconBtn.MouseEnter:Connect(function()
			if window.activetab ~= tab then
				tween(iconImg, {ImageColor3 = library.colors.text}, 0.15)
			end
		end)
		iconBtn.MouseLeave:Connect(function()
			if window.activetab ~= tab then
				tween(iconImg, {ImageColor3 = library.colors.subtext}, 0.15)
			end
		end)

		tab.iconBg  = iconBg
		tab.iconImg = iconImg

		table.insert(self.tabs, tab)
		if #self.tabs == 1 then
			task.defer(function() window:switchtab(tab) end)
		end

		-- ── addsubpage ────────────────────────────────────────────────────────
		function tab:addsubpage(scfg)
			scfg = scfg or {}
			local sname = scfg.name or "Page"

			-- pill button in topbar
			local btn = create("Frame", {
				Name = sname,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Visible = false,
				Parent = subTabScroll,
			})
			local label = create("TextLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(0, 0, 0, 44),
				AutomaticSize = Enum.AutomaticSize.X,
				Font = Enum.Font.GothamMedium,
				Text = sname,
				TextColor3 = library.colors.subtext,
				TextSize = 13,
				TextTransparency = 0.15,
				Parent = btn,
			})
			create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = label})

			-- bottom accent indicator
			local indicator = create("Frame", {
				Name = "indicator",
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = library.colors.accent,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0.5, 0, 1, 0),
				Size = UDim2.new(0.7, 0, 0, 2),
				Parent = btn,
			})
			create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = indicator})

			-- scroll page
			local page = create("ScrollingFrame", {
				Name = sname,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, -10, 1, -10),
				ScrollBarImageColor3 = library.colors.border,
				ScrollBarThickness = 3,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				Visible = false,
				Parent = pageContainer,
			})
			create("UIListLayout",  {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8),  Parent = page})
			create("UIPadding",     {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = page})

			local subpage = {name = sname, btn = btn, label = label, indicator = indicator, page = page, tab = tab}

			local sbtn = create("TextButton", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Text = "",
				Parent = btn,
			})
			sbtn.MouseButton1Click:Connect(function() window:switchsubpage(tab, subpage) end)

			table.insert(tab.subpages, subpage)

			if window.activetab == tab then
				btn.Visible = true
				if #tab.subpages == 1 then
					window:switchsubpage(tab, subpage)
				end
			end

			-- ── addsection ────────────────────────────────────────────────────
			function subpage:addsection(secCfg)
				secCfg = secCfg or {}
				local secname = secCfg.name or "Section"

				local section = {name = secname, elements = {}}

				local secFrame = create("Frame", {
					Name = secname,
					BackgroundColor3 = library.colors.surface,
					BackgroundTransparency = 0.15,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					ClipsDescendants = false,
					Parent = page,
				})
				create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = secFrame})
				create("UIStroke", {Color = library.colors.border, Thickness = 1, Parent = secFrame})

				-- section title
				local titleLbl = create("TextLabel", {
					Name = "SectionTitle",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 14, 0, 0),
					Size = UDim2.new(1, -28, 0, 34),
					Font = Enum.Font.GothamMedium,
					Text = secname,
					TextColor3 = library.colors.text,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = secFrame,
				})

				-- thin accent line below title
				local titleLine = create("Frame", {
					Name = "TitleLine",
					BackgroundColor3 = library.colors.accent,
					BackgroundTransparency = 0.2,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 14, 0, 33),
					Size = UDim2.new(1, -28, 0, 1),
					Parent = secFrame,
				})
				create("UIGradient", {
					Color = ColorSequence.new{
						ColorSequenceKeypoint.new(0, library.colors.accent),
						ColorSequenceKeypoint.new(0.6, library.colors.accent),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,20)),
					},
					Parent = titleLine,
				})

				-- content holder
				local holder = create("Frame", {
					Name = "Holder",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 34),
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Parent = secFrame,
				})
				create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 0), Parent = holder})
				create("UIPadding",   {PaddingBottom = UDim.new(0, 8), Parent = holder})

				section.secFrame = secFrame
				section.holder   = holder

				-- ── addtoggle (pill/switch style) ─────────────────────────────
				function section:addtoggle(tcfg)
					tcfg = tcfg or {}
					local tname     = tcfg.name     or "Toggle"
					local tdefault  = tcfg.default  or false
					local tcallback = tcfg.callback or function() end
					local tflag     = tcfg.flag

					local toggle = {name = tname, value = tdefault, callback = tcallback}
					if tflag then library.flags[tflag] = tdefault end

					local row = create("Frame", {
						Name = tname,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 36),
						Parent = holder,
					})

					local lbl = create("TextLabel", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 14, 0.5, 0),
						Size = UDim2.new(1, -70, 0, 20),
						Font = Enum.Font.Gotham,
						Text = tname,
						TextColor3 = tdefault and library.colors.text or library.colors.subtext,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = row,
					})

					-- pill background
					local pillBg = create("Frame", {
						Name = "PillBg",
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundColor3 = tdefault and library.colors.accent or library.colors.toggleOff,
						BorderSizePixel = 0,
						Position = UDim2.new(1, -14, 0.5, 0),
						Size = UDim2.new(0, 36, 0, 20),
						ClipsDescendants = true,
						Parent = row,
					})
					create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = pillBg})

					-- knob
					local knob = create("Frame", {
						Name = "Knob",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Color3.fromRGB(255,255,255),
						BorderSizePixel = 0,
						Position = tdefault and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
						Size = UDim2.new(0, 16, 0, 16),
						Parent = pillBg,
					})
					create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = knob})

					local rowBtn = create("TextButton", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						Text = "",
						Parent = row,
					})

					local function setstate(state, nocallback)
						toggle.value = state
						if tflag then library.flags[tflag] = state end
						tween(pillBg, {BackgroundColor3 = state and library.colors.accent or library.colors.toggleOff}, 0.2)
						tween(knob,   {Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.2)
						tween(lbl,    {TextColor3 = state and library.colors.text or library.colors.subtext}, 0.2)
						if not nocallback then task.spawn(saferun, tcallback, state) end
					end

					rowBtn.MouseButton1Click:Connect(function() setstate(not toggle.value) end)
					toggle.set   = setstate
					toggle.frame = row

					if tdefault then task.defer(function() saferun(tcallback, true) end) end
					table.insert(section.elements, toggle)
					return toggle
				end

				-- ── addbutton ─────────────────────────────────────────────────
				function section:addbutton(bcfg)
					bcfg = bcfg or {}
					local bname     = bcfg.name     or "Button"
					local bcallback = bcfg.callback or function() end

					local button = {name = bname, callback = bcallback}

					local row = create("Frame", {
						Name = bname,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 40),
						Parent = holder,
					})

					local btn = create("Frame", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = library.colors.surface2,
						BackgroundTransparency = 0.2,
						BorderSizePixel = 0,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(1, -28, 0, 28),
						ClipsDescendants = true,
						Parent = row,
					})
					create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})
					create("UIStroke", {Color = library.colors.border, Thickness = 1, Parent = btn})

					local blbl = create("TextLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(1, -10, 1, 0),
						Font = Enum.Font.GothamMedium,
						Text = bname,
						TextColor3 = library.colors.subtext,
						TextSize = 13,
						Parent = btn,
					})

					local bclick = create("TextButton", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						Text = "",
						ZIndex = 2,
						Parent = btn,
					})

					bclick.MouseButton1Click:Connect(function()
						tween(btn, {BackgroundColor3 = library.colors.accent}, 0.1)
						tween(blbl, {TextColor3 = library.colors.text}, 0.1)
						task.delay(0.18, function()
							tween(btn, {BackgroundColor3 = library.colors.surface2}, 0.2)
							tween(blbl, {TextColor3 = library.colors.subtext}, 0.2)
						end)
						task.spawn(saferun, bcallback)
					end)
					bclick.MouseEnter:Connect(function()
						tween(btn,  {BackgroundColor3 = Color3.fromRGB(38,38,55)}, 0.15)
						tween(blbl, {TextColor3 = library.colors.text}, 0.15)
						tween(btn.UIStroke, {Color = library.colors.accent}, 0.15)
					end)
					bclick.MouseLeave:Connect(function()
						tween(btn,  {BackgroundColor3 = library.colors.surface2}, 0.15)
						tween(blbl, {TextColor3 = library.colors.subtext}, 0.15)
						tween(btn.UIStroke, {Color = library.colors.border}, 0.15)
					end)

					button.frame = row
					button.btn   = btn
					button.label = blbl
					table.insert(section.elements, button)
					return button
				end

				-- ── addslider ─────────────────────────────────────────────────
				function section:addslider(slcfg)
					slcfg = slcfg or {}
					local sname     = slcfg.name      or "Slider"
					local smin      = slcfg.min       or 0
					local smax      = slcfg.max       or 100
					local sdefault  = math.clamp(slcfg.default or smin, smin, smax)
					local sinc      = slcfg.increment or 1
					local ssuffix   = slcfg.suffix    or ""
					local scallback = slcfg.callback  or function() end
					local sflag     = slcfg.flag

					local slider = {name = sname, value = sdefault, min = smin, max = smax}
					if sflag then library.flags[sflag] = sdefault end

					local row = create("Frame", {
						Name = sname,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 48),
						Parent = holder,
					})

					local slbl = create("TextLabel", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0, 0),
						Position = UDim2.new(0, 14, 0, 8),
						Size = UDim2.new(0.5, 0, 0, 16),
						Font = Enum.Font.Gotham,
						Text = sname,
						TextColor3 = library.colors.subtext,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = row,
					})

					local sval = create("TextLabel", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(1, -14, 0, 8),
						Size = UDim2.new(0, 60, 0, 16),
						Font = Enum.Font.GothamMedium,
						Text = tostring(sdefault) .. ssuffix,
						TextColor3 = library.colors.text,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Right,
						Parent = row,
					})

					local trackBg = create("Frame", {
						Name = "TrackBg",
						AnchorPoint = Vector2.new(0, 0),
						BackgroundColor3 = library.colors.toggleOff,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 14, 0, 30),
						Size = UDim2.new(1, -28, 0, 5),
						Parent = row,
					})
					create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = trackBg})

					local initPct = (sdefault - smin) / math.max(smax - smin, 0.001)
					local trackFill = create("Frame", {
						Name = "Fill",
						BackgroundColor3 = library.colors.accent,
						BorderSizePixel = 0,
						Size = UDim2.new(initPct, 0, 1, 0),
						Parent = trackBg,
					})
					create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = trackFill})

					-- glow on fill
					local fillGlow = create("UIGradient", {
						Color = ColorSequence.new{
							ColorSequenceKeypoint.new(0, library.colors.accent),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 90, 255)),
						},
						Parent = trackFill,
					})

					-- knob circle at end of fill
					local sknob = create("Frame", {
						Name = "Knob",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255,255,255),
						BorderSizePixel = 0,
						Position = UDim2.new(initPct, 0, 0.5, 0),
						Size = UDim2.new(0, 13, 0, 13),
						Parent = trackBg,
					})
					create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sknob})
					create("UIStroke", {Color = library.colors.accent, Thickness = 2, Parent = sknob})

					local sclick = create("TextButton", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 0, 20),
						Text = "",
						ZIndex = 2,
						Parent = trackBg,
					})

					local draggingSlider = false
					local function roundinc(v) return math.floor(v / sinc + 0.5) * sinc end
					local function updateSlider(pct, nocallback)
						pct = math.clamp(pct, 0, 1)
						local raw = smin + (smax - smin) * pct
						local val = math.clamp(roundinc(raw), smin, smax)
						slider.value = val
						if sflag then library.flags[sflag] = val end
						local ap = (val - smin) / math.max(smax - smin, 0.001)
						tween(trackFill, {Size = UDim2.new(ap, 0, 1, 0)}, 0.08, Enum.EasingStyle.Quad)
						sknob.Position = UDim2.new(ap, 0, 0.5, 0)
						sval.Text = tostring(val) .. ssuffix
						if not nocallback then task.spawn(saferun, scallback, val) end
					end

					local function handleInput(input)
						local pos  = trackBg.AbsolutePosition.X
						local size = trackBg.AbsoluteSize.X
						updateSlider((input.Position.X - pos) / size)
					end

					sclick.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							draggingSlider = true
							handleInput(input)
						end
					end)
					UserInputService.InputChanged:Connect(function(input)
						if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
							handleInput(input)
						end
					end)
					UserInputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							draggingSlider = false
						end
					end)

					slider.set   = function(v, nc) updateSlider((v - smin) / math.max(smax - smin, 0.001), nc) end
					slider.frame = row
					table.insert(section.elements, slider)
					if sdefault ~= smin then task.defer(function() saferun(scallback, sdefault) end) end
					return slider
				end

				-- ── adddropdown ───────────────────────────────────────────────
				function section:adddropdown(dcfg)
					dcfg = dcfg or {}
					local dname     = dcfg.name     or "Dropdown"
					local doptions  = dcfg.options  or {}
					local ddefault  = dcfg.default
					local dcallback = dcfg.callback or function() end
					local dflag     = dcfg.flag
					local dmulti    = dcfg.multi    or false

					local dropdown = {name = dname, options = doptions, multi = dmulti, value = dmulti and {} or nil, isopen = false, optionframes = {}}
					if dflag then library.flags[dflag] = dropdown.value end

					local row = create("Frame", {
						Name = dname,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 52),
						ClipsDescendants = false,
						Parent = holder,
					})

					create("TextLabel", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0, 0),
						Position = UDim2.new(0, 14, 0, 6),
						Size = UDim2.new(1, -28, 0, 16),
						Font = Enum.Font.Gotham,
						Text = dname,
						TextColor3 = library.colors.subtext,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = row,
					})

					local ddHolder = create("Frame", {
						Name = "DDHolder",
						BackgroundColor3 = library.colors.surface2,
						BackgroundTransparency = 0.2,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 14, 0, 26),
						Size = UDim2.new(1, -28, 0, 22),
						ClipsDescendants = true,
						Parent = row,
					})
					create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = ddHolder})
					create("UIStroke", {Color = library.colors.border, Thickness = 1, Parent = ddHolder})

					local valTxt = create("TextLabel", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 8, 0.5, 0),
						Size = UDim2.new(1, -30, 1, 0),
						Font = Enum.Font.GothamMedium,
						Text = "...",
						TextColor3 = library.colors.text,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = ddHolder,
					})

					local arrow = create("ImageLabel", {
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, -6, 0.5, 0),
						Size = UDim2.new(0, 12, 0, 12),
						Image = "rbxassetid://6031091004",
						ImageColor3 = library.colors.subtext,
						Parent = ddHolder,
					})

					local ddBtn = create("TextButton", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						Text = "",
						ZIndex = 2,
						Parent = ddHolder,
					})

					local popup = create("ScrollingFrame", {
						Name = dname .. "_popup",
						BackgroundColor3 = library.colors.surface2,
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Size = UDim2.new(0, 200, 0, 0),
						Visible = false,
						ZIndex = 999,
						ScrollBarThickness = 3,
						ScrollBarImageColor3 = library.colors.border,
						CanvasSize = UDim2.new(0, 0, 0, 0),
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						Parent = gui,
					})
					create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = popup})
					create("UIStroke", {Color = library.colors.border, Thickness = 1, Parent = popup})
					create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Parent = popup})

					local function updateText()
						if dmulti then
							valTxt.Text = #dropdown.value > 0 and table.concat(dropdown.value, ", ") or "..."
						else
							valTxt.Text = dropdown.value or "..."
						end
					end

					local function reposPopup()
						local ap = ddHolder.AbsolutePosition
						local as = ddHolder.AbsoluteSize
						popup.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 2)
						popup.Size     = UDim2.new(0, as.X, 0, popup.Size.Y.Offset)
					end

					local function createOption(oname)
						local oh = create("Frame", {
							BackgroundColor3 = library.colors.surface2,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 22),
							ZIndex = 1000,
							Parent = popup,
						})
						local ol = create("TextLabel", {
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 10, 0.5, 0),
							Size = UDim2.new(1, -20, 1, 0),
							Font = Enum.Font.Gotham,
							Text = oname,
							TextColor3 = library.colors.text,
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Left,
							ZIndex = 1001,
							Parent = oh,
						})
						local ob = create("TextButton", {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							Text = "",
							ZIndex = 1002,
							Parent = oh,
						})

						local optdata = {name = oname, holder = oh, label = ol, selected = false}

						local function setsel(sel)
							optdata.selected = sel
							if sel then
								tween(oh, {BackgroundColor3 = Color3.fromRGB(35,35,55)}, 0.15)
								tween(ol, {TextColor3 = library.colors.accent}, 0.15)
							else
								tween(oh, {BackgroundColor3 = library.colors.surface2}, 0.15)
								tween(ol, {TextColor3 = library.colors.text}, 0.15)
							end
						end

						ob.MouseEnter:Connect(function() if not optdata.selected then tween(oh, {BackgroundColor3 = Color3.fromRGB(32,32,48)}, 0.12) end end)
						ob.MouseLeave:Connect(function() if not optdata.selected then tween(oh, {BackgroundColor3 = library.colors.surface2}, 0.12) end end)
						ob.MouseButton1Click:Connect(function()
							if dmulti then
								local idx = table.find(dropdown.value, oname)
								if idx then table.remove(dropdown.value, idx); setsel(false)
								else table.insert(dropdown.value, oname); setsel(true) end
							else
								dropdown.value = oname
								for _, od in pairs(dropdown.optionframes) do od.setselected(false) end
								setsel(true)
								dropdown:toggle()
							end
							if dflag then library.flags[dflag] = dropdown.value end
							updateText()
							task.spawn(saferun, dcallback, dropdown.value)
						end)

						optdata.setselected = setsel
						dropdown.optionframes[oname] = optdata
					end

					for _, o in ipairs(doptions) do createOption(o) end

					function dropdown:toggle()
						self.isopen = not self.isopen
						if self.isopen then
							reposPopup()
							local cnt = 0
							for _ in pairs(self.optionframes) do cnt = cnt + 1 end
							local h = math.min(cnt, 6) * 22
							popup.Size = UDim2.new(0, ddHolder.AbsoluteSize.X, 0, h)
							popup.Visible = true
							tween(arrow, {Rotation = 180}, 0.2)
						else
							tween(popup, {Size = UDim2.new(0, ddHolder.AbsoluteSize.X, 0, 0)}, 0.18)
							tween(arrow, {Rotation = 0}, 0.2)
							task.delay(0.2, function() if not dropdown.isopen then popup.Visible = false end end)
						end
					end

					ddBtn.MouseButton1Click:Connect(function() dropdown:toggle() end)

					UserInputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 and dropdown.isopen then
							task.defer(function()
								if not dropdown.isopen then return end
								local m = input.Position
								local hp, hs = ddHolder.AbsolutePosition, ddHolder.AbsoluteSize
								local pp, ps = popup.AbsolutePosition,   popup.AbsoluteSize
								local inH = m.X >= hp.X and m.X <= hp.X+hs.X and m.Y >= hp.Y and m.Y <= hp.Y+hs.Y
								local inP = m.X >= pp.X and m.X <= pp.X+ps.X and m.Y >= pp.Y and m.Y <= pp.Y+ps.Y
								if not inH and not inP then dropdown:toggle() end
							end)
						end
					end)

					function dropdown:set(val, nocallback)
						if dmulti and type(val) == "table" then
							self.value = val
							for _, od in pairs(self.optionframes) do od.setselected(false) end
							for _, v in ipairs(val) do if self.optionframes[v] then self.optionframes[v].setselected(true) end end
						else
							self.value = val
							for _, od in pairs(self.optionframes) do od.setselected(false) end
							if self.optionframes[val] then self.optionframes[val].setselected(true) end
						end
						updateText()
						if dflag then library.flags[dflag] = self.value end
						if not nocallback then task.spawn(saferun, dcallback, self.value) end
					end

					function dropdown:refresh(newopts)
						for _, v in pairs(self.optionframes) do v.holder:Destroy() end
						self.optionframes = {}
						self.options = newopts
						self.value   = dmulti and {} or nil
						for _, o in ipairs(newopts) do createOption(o) end
						updateText()
					end

					row.AncestryChanged:Connect(function(_, parent) if not parent then popup:Destroy() end end)
					if ddefault then dropdown:set(ddefault, true) end

					dropdown.frame = row
					table.insert(section.elements, dropdown)
					return dropdown
				end

				return section
			end -- addsection

			return subpage
		end -- addsubpage

		return tab
	end -- addtab

	-- ── notify ────────────────────────────────────────────────────────────────
	local notifHolder = create("Frame", {
		Name = "Notifications",
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -16, 0, 16),
		Size = UDim2.new(0, 290, 1, -32),
		Parent = gui,
	})
	create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Bottom, Parent = notifHolder})

	local ntypes = {
		success = {color = Color3.fromRGB(52, 211, 153), icon = "rbxassetid://92431556586885"},
		warning = {color = Color3.fromRGB(251, 191, 36),  icon = "rbxassetid://70479764730792"},
		error   = {color = Color3.fromRGB(248, 113, 113), icon = "rbxassetid://70479764730792"},
	}

	function window:notify(ncfg)
		ncfg = ncfg or {}
		local ntype  = ntypes[ncfg.type or "success"] or ntypes.success
		local ntitle = ncfg.title or "Notification"
		local ndesc  = ncfg.description or ""
		local ndur   = ncfg.duration or 4

		local notif = create("Frame", {
			BackgroundColor3 = library.colors.surface,
			BackgroundTransparency = 0.05,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 0, 0),
			Parent = notifHolder,
		})
		create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = notif})
		create("UIStroke", {Color = library.colors.border, Thickness = 1, Parent = notif})

		local accentBar = create("Frame", {
			BackgroundColor3 = ntype.color,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 3, 1, 0),
			Parent = notif,
		})
		create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = accentBar})

		local nt = create("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 14, 0, 10),
			Size = UDim2.new(1, -26, 0, 16),
			Font = Enum.Font.GothamBold,
			Text = ntitle,
			TextColor3 = library.colors.text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = notif,
		})

		local nd = create("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 14, 0, 28),
			Size = UDim2.new(1, -26, 0, 28),
			Font = Enum.Font.Gotham,
			Text = ndesc,
			TextColor3 = library.colors.subtext,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Parent = notif,
		})

		local pbar = create("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = ntype.color,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, 2),
			Parent = notif,
		})

		local closed = false
		local function closeN()
			if closed then return end; closed = true
			tween(notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
			task.delay(0.3, function() notif:Destroy() end)
		end

		tween(notif, {Size = UDim2.new(1, 0, 0, 62)}, 0.35, Enum.EasingStyle.Back)
		tween(pbar, {Size = UDim2.new(0, 0, 0, 2)}, ndur, Enum.EasingStyle.Linear)
		task.delay(ndur, closeN)

		return {close = closeN}
	end

	return window
end

return library
