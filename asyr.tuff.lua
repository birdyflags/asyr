-- ASYR UI Library - Crimson Void Ultimate Overhaul
-- Author: Antigravity
-- Version: 2.1.0

-- Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- Utility Functions
local function Create(class, props)
    local obj = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            if k ~= "Parent" then
                pcall(function() obj[k] = v end)
            end
        end
        if props.Parent then obj.Parent = props.Parent end
    end
    return obj
end

local function DoTween(obj, props, duration, style, dir)
    local info = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

local function ApplyRoundedCorner(inst, radius)
    return Create("UICorner", {CornerRadius = radius or UDim.new(0, 6), Parent = inst})
end

local function ApplyStroke(inst, color, thickness)
    return Create("UIStroke", {Color = color or Color3.fromRGB(40,40,40), Thickness = thickness or 1, Parent = inst})
end

-- Theme (Crimson Void)
local Library = {
    Theme = {
        Background = Color3.fromRGB(10,10,10),   -- Deep Black
        Surface = Color3.fromRGB(18,18,18),      -- Soft Black
        Item = Color3.fromRGB(25,25,25),         -- Element BG
        Outline = Color3.fromRGB(40,40,40),      -- Borders
        Accent = Color3.fromRGB(220,40,40),      -- Crimson Red
        Text = Color3.fromRGB(240,240,240),      -- White
        SubText = Color3.fromRGB(160,160,160),   -- Gray
        Hover = Color3.fromRGB(35,35,35),        -- Hover State
    },
    ActiveWindow = nil,
    Keybinds = {}, -- {Name = "Toggle UI", Key = Enum.KeyCode.Insert}
}

-- Icon System (Nebula - Lucide)
local Icons = {}
do
    local function SafeLoad(url)
        local success, result = pcall(function() return loadstring(game:HttpGetAsync(url))() end)
        if success then return result else warn("Failed to load icons:", url) return {} end
    end
    Icons.Lucide = SafeLoad("https://raw.githubusercontent.com/Nebula-Softworks/Nebula-Icon-Library/master/LucideIcons.luau")
    function ASYR:GetIcon(name)
        if Icons.Lucide and Icons.Lucide[name] then
            return "rbxassetid://" .. Icons.Lucide[name]
        end
        return ""
    end
end

-- Platform Detection
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

-- Fullscreen Blur Utility
local function FullScreenBlur(enable)
    if enable then
        if not Lighting:FindFirstChild("ASYR_Blur") then
            local blur = Instance.new("BlurEffect")
            blur.Name = "ASYR_Blur"
            blur.Size = 24
            blur.Parent = Lighting
        end
    else
        local blur = Lighting:FindFirstChild("ASYR_Blur")
        if blur then blur:Destroy() end
    end
end

-- Intro Prompt UI
local function ShowIntroPrompt()
    local promptGui = Create("ScreenGui", {Name = "ASYR_IntroPrompt", Parent = CoreGui})
    local frame = Create("Frame", {
        Parent = promptGui,
        Size = UDim2.new(0, 300, 0, 150),
        Position = UDim2.new(0.5, -150, 0.5, -75),
        BackgroundColor3 = Library.Theme.Surface,
        BackgroundTransparency = 0.2,
        AnchorPoint = Vector2.new(0.5,0.5)
    })
    ApplyRoundedCorner(frame, UDim.new(0,12))
    ApplyStroke(frame, Library.Theme.Accent, 2)
    local label = Create("TextLabel", {
        Parent = frame,
        Text = IsMobile() and "Tap the icon below to open UI" or "Press Insert to toggle UI",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Library.Theme.Text,
        Size = UDim2.new(1,0,0.6,0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        Position = UDim2.new(0,0,0,0)
    })
    if IsMobile() then
        local toggleBtn = Create("ImageButton", {
            Parent = frame,
            Image = ASYR:GetIcon("menu"),
            Size = UDim2.new(0,48,0,48),
            Position = UDim2.new(0.5,-24,0.7,0),
            BackgroundTransparency = 1,
            ImageColor3 = Library.Theme.Accent,
        })
        ApplyRoundedCorner(toggleBtn, UDim.new(0,8))
        toggleBtn.MouseButton1Click:Connect(function()
            FullScreenBlur(true)
            promptGui:Destroy()
            ASYR:CreateWindow({Name = "ASYR", IntroText = "Welcome"})
        end)
    else
        local function onKeyPress(input)
            if input.KeyCode == Enum.KeyCode.Insert then
                FullScreenBlur(true)
                promptGui:Destroy()
                ASYR:CreateWindow({Name = "ASYR", IntroText = "Welcome"})
                UserInputService.InputBegan:Disconnect()
            end
        end
        UserInputService.InputBegan:Connect(onKeyPress)
    end
    -- Fade-in animation
    frame.BackgroundTransparency = 1
    DoTween(frame, {BackgroundTransparency = 0.2}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
end

-- Notification System
function ASYR:Notify(options)
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 3
    local screen = CoreGui:FindFirstChild("ASYR_Notifications")
    if not screen then
        screen = Create("ScreenGui", {Name = "ASYR_Notifications", Parent = CoreGui})
    end
    local container = Create("Frame", {
        Parent = screen,
        Size = UDim2.new(0,280,0,70),
        Position = UDim2.new(1,20,1,-100 - (#screen:GetChildren()*80)),
        BackgroundColor3 = Library.Theme.Surface,
        BorderSizePixel = 0,
        BackgroundTransparency = 0.2
    })
    ApplyRoundedCorner(container, UDim.new(0,6))
    ApplyStroke(container, Library.Theme.Accent, 1)
    Create("TextLabel", {
        Parent = container,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Library.Theme.Accent,
        Size = UDim2.new(1,-20,0,20),
        Position = UDim2.new(0,10,0,8),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Create("TextLabel", {
        Parent = container,
        Text = content,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Library.Theme.Text,
        Size = UDim2.new(1,-20,0,35),
        Position = UDim2.new(0,10,0,28),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })
    DoTween(container, {Position = UDim2.new(1,-300,1,-100 - (#screen:GetChildren()*80))}, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    task.delay(duration, function()
        DoTween(container, {Position = UDim2.new(1,20,1,container.Position.Y.Offset)}, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(0.5)
        container:Destroy()
    end)
end

-- Keybind List Component
function ASYR:CreateKeybindList()
    local listGui = Create("ScreenGui", {Name = "ASYR_KeybindList", Parent = CoreGui})
    local frame = Create("Frame", {
        Parent = listGui,
        Size = UDim2.new(0,200,0,200),
        Position = UDim2.new(1,-210,0,10),
        BackgroundColor3 = Library.Theme.Surface,
        BackgroundTransparency = 0.2,
    })
    ApplyRoundedCorner(frame, UDim.new(0,8))
    ApplyStroke(frame, Library.Theme.Accent, 1)
    local layout = Create("UIListLayout", {Parent = frame, Padding = UDim.new(0,5), SortOrder = Enum.SortOrder.LayoutOrder})
    for _,kb in ipairs(Library.Keybinds) do
        Create("TextLabel", {
            Parent = frame,
            Text = kb.Name .. ": " .. kb.Key.Name,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextColor3 = Library.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1,-10,0,20),
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0,5,0,0)
        })
    end
    return listGui
end

-- Advanced ColorPicker Component
function ASYR:CreateAdvancedColorPicker(options)
    local name = options.Name or "ColorPicker"
    local default = options.Color or Color3.fromRGB(255,255,255)
    local callback = options.Callback or function() end
    local container = Create("Frame", {
        Name = name,
        Parent = options.Parent,
        Size = UDim2.new(0,250,0,300),
        BackgroundColor3 = Library.Theme.Surface,
        BackgroundTransparency = 0.2,
    })
    ApplyRoundedCorner(container, UDim.new(0,8))
    ApplyStroke(container, Library.Theme.Accent, 1)
    -- SV Square (placeholder gradient)
    local sv = Create("ImageLabel", {
        Parent = container,
        Size = UDim2.new(0,200,0,200),
        Position = UDim2.new(0,20,0,20),
        Image = "rbxassetid://11223344",
        BackgroundTransparency = 1,
    })
    -- Hue Slider (placeholder)
    local hue = Create("ImageButton", {
        Parent = container,
        Size = UDim2.new(0,20,0,200),
        Position = UDim2.new(0,230,0,20),
        Image = "rbxassetid://55667788",
        BackgroundTransparency = 1,
    })
    local indicator = Create("Frame", {
        Parent = sv,
        Size = UDim2.new(0,10,0,10),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BorderSizePixel = 0,
    })
    ApplyRoundedCorner(indicator, UDim.new(0,5))
    local function updateColor(x,y)
        local hueVal = hue.AbsolutePosition.Y + y
        local sat = math.clamp(x/200,0,1)
        local val = 1 - math.clamp(y/200,0,1)
        local hsv = Color3.fromHSV(hueVal/360, sat, val)
        callback(hsv)
    end
    sv.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local conn
            conn = UserInputService.InputChanged:Connect(function(move)
                if move.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = sv.AbsolutePosition
                    local x = move.Position.X - rel.X
                    local y = move.Position.Y - rel.Y
                    updateColor(x,y)
                end
            end)
            sv.InputEnded:Connect(function()
                conn:Disconnect()
            end)
        end
    end)
    return container
end

-- Core Window Creation
function ASYR:CreateWindow(options)
    options = options or {}
    local Name = options.Name or "ASYR"
    local IntroText = options.IntroText or "Welcome"
    if Library.ActiveWindow then Library.ActiveWindow:Destroy() end
    local screen = Create("ScreenGui", {Name = "ASYR_UI", Parent = CoreGui})
    Library.ActiveWindow = screen
    local Main = Create("Frame", {
        Name = "Main",
        Parent = screen,
        Size = UDim2.new(0,600,0,500),
        Position = UDim2.new(0.5,-300,0.5,-250),
        BackgroundColor3 = Library.Theme.Background,
        ClipsDescendants = true,
    })
    ApplyRoundedCorner(Main, UDim.new(0,12))
    ApplyStroke(Main, Library.Theme.Outline, 1)
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = Main,
        Size = UDim2.new(1,0,0,45),
        BackgroundColor3 = Library.Theme.Surface,
        BorderSizePixel = 0,
    })
    ApplyRoundedCorner(TopBar, UDim.new(0,12))
    Create("TextLabel", {
        Parent = TopBar,
        Text = Name,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Library.Theme.Text,
        Size = UDim2.new(0,200,1,0),
        Position = UDim2.new(0,15,0,0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local closeBtn = Create("TextButton", {
        Parent = TopBar,
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Library.Theme.SubText,
        Size = UDim2.new(0,30,0,30),
        Position = UDim2.new(1,-35,0,7),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
    })
    closeBtn.MouseEnter:Connect(function() DoTween(closeBtn, {TextColor3 = Library.Theme.Accent}, 0.2) end)
    closeBtn.MouseLeave:Connect(function() DoTween(closeBtn, {TextColor3 = Library.Theme.SubText}, 0.2) end)
    closeBtn.MouseButton1Click:Connect(function() FullScreenBlur(false) screen:Destroy() end)
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = Main,
        Size = UDim2.new(0,180,1,-45),
        Position = UDim2.new(0,0,0,45),
        BackgroundColor3 = Library.Theme.Surface,
        BorderSizePixel = 0,
    })
    ApplyRoundedCorner(Sidebar, UDim.new(0,8))
    local Content = Create("Frame", {
        Name = "Content",
        Parent = Main,
        Size = UDim2.new(1,-180,1,-45),
        Position = UDim2.new(0,180,0,45),
        BackgroundTransparency = 1,
    })
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar,
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
    })
    local TabLayout = Create("UIListLayout", {Parent = TabContainer, Padding = UDim.new(0,5), SortOrder = Enum.SortOrder.LayoutOrder})
    local Window = {Tabs = {}, ActiveTab = nil}
    function Window:CreateTab(name, icon)
        local Tab = {Name = name, Sections = {}}
        local TabButton = Create("TextButton", {
            Parent = TabContainer,
            Size = UDim2.new(1,-20,0,35),
            Position = UDim2.new(0,10,0,0),
            BackgroundColor3 = Library.Theme.Surface,
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
        })
        ApplyRoundedCorner(TabButton, UDim.new(0,6))
        local TabIcon = Create("ImageLabel", {
            Parent = TabButton,
            Size = UDim2.new(0,20,0,20),
            Position = UDim2.new(0,5,0.5,-10),
            BackgroundTransparency = 1,
            Image = ASYR:GetIcon(icon or "box"),
            ImageColor3 = Library.Theme.SubText,
        })
        local TabLabel = Create("TextLabel", {
            Parent = TabButton,
            Text = name,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextColor3 = Library.Theme.SubText,
            Size = UDim2.new(1,-30,1,0),
            Position = UDim2.new(0,30,0,0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        local TabFrame = Create("ScrollingFrame", {
            Name = name.."_Content",
            Parent = Content,
            Size = UDim2.new(1,-20,1,-20),
            Position = UDim2.new(0,10,0,10),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent,
            Visible = false,
        })
        Create("UIListLayout", {Parent = TabFrame, Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})
        TabButton.MouseButton1Click:Connect(function()
            if Window.ActiveTab then
                DoTween(Window.ActiveTab.Button, {BackgroundTransparency = 1}, 0.2)
                DoTween(Window.ActiveTab.Label, {TextColor3 = Library.Theme.SubText}, 0.2)
                DoTween(Window.ActiveTab.Icon, {ImageColor3 = Library.Theme.SubText}, 0.2)
                Window.ActiveTab.Frame.Visible = false
            end
            Window.ActiveTab = {Button = TabButton, Label = TabLabel, Icon = TabIcon, Frame = TabFrame}
            DoTween(TabButton, {BackgroundTransparency = 0}, 0.2)
            DoTween(TabLabel, {TextColor3 = Library.Theme.Text}, 0.2)
            DoTween(TabIcon, {ImageColor3 = Library.Theme.Accent}, 0.2)
            TabFrame.Visible = true
        end)
        if #Window.Tabs == 0 then
            Window.ActiveTab = {Button = TabButton, Label = TabLabel, Icon = TabIcon, Frame = TabFrame}
            TabButton.BackgroundTransparency = 0
            TabLabel.TextColor3 = Library.Theme.Text
            TabIcon.ImageColor3 = Library.Theme.Accent
            TabFrame.Visible = true
        end
        table.insert(Window.Tabs, Tab)
        function Tab:CreateSection(sectionName)
            local Section = {}
            local SectionLabel = Create("TextLabel", {
                Parent = TabFrame,
                Text = sectionName,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextColor3 = Library.Theme.SubText,
                Size = UDim2.new(1,0,0,20),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            local Container = Create("Frame", {
                Parent = TabFrame,
                Size = UDim2.new(1,0,0,0),
                BackgroundTransparency = 1,
            })
            local List = Create("UIListLayout", {Parent = Container, Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder})
            List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Container.Size = UDim2.new(1,0,0,List.AbsoluteContentSize.Y)
                TabFrame.CanvasSize = UDim2.new(0,0,0,List.AbsoluteContentSize.Y+50)
            end)
            function Section:CreateButton(opts)
                local btn = Create("TextButton", {
                    Parent = Container,
                    Size = UDim2.new(1,0,0,36),
                    BackgroundColor3 = Library.Theme.Item,
                    Text = "",
                    AutoButtonColor = false,
                })
                ApplyRoundedCorner(btn, UDim.new(0,6))
                ApplyStroke(btn, Library.Theme.Outline, 1)
                local lbl = Create("TextLabel", {
                    Parent = btn,
                    Text = opts.Name or "Button",
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 13,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(1,0,1,0),
                    BackgroundTransparency = 1,
                })
                btn.MouseEnter:Connect(function() DoTween(btn, {BackgroundColor3 = Library.Theme.Hover}, 0.2) end)
                btn.MouseLeave:Connect(function() DoTween(btn, {BackgroundColor3 = Library.Theme.Item}, 0.2) end)
                btn.MouseButton1Click:Connect(function()
                    DoTween(btn, {BackgroundColor3 = Library.Theme.Accent}, 0.1)
                    task.wait(0.1)
                    DoTween(btn, {BackgroundColor3 = Library.Theme.Hover}, 0.1)
                    if opts.Callback then opts.Callback() end
                end)
            end
            function Section:CreateToggle(opts)
                local toggle = Create("Frame", {
                    Parent = Container,
                    Size = UDim2.new(1,0,0,30),
                    BackgroundTransparency = 1,
                })
                local label = Create("TextLabel", {
                    Parent = toggle,
                    Text = opts.Name or "Toggle",
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(0.7,0,1,0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                local btn = Create("TextButton", {
                    Parent = toggle,
                    Size = UDim2.new(0,40,0,20),
                    Position = UDim2.new(0.75,0,0.5,-10),
                    BackgroundColor3 = Library.Theme.Item,
                    Text = "",
                    AutoButtonColor = false,
                })
                ApplyRoundedCorner(btn, UDim.new(0,6))
                ApplyStroke(btn, Library.Theme.Outline, 1)
                local knob = Create("Frame", {
                    Parent = btn,
                    Size = UDim2.new(0.5,0,1,0),
                    BackgroundColor3 = Library.Theme.Accent,
                })
                ApplyRoundedCorner(knob, UDim.new(0,6))
                local state = opts.CurrentValue or false
                local function setState(val)
                    state = val
                    if val then
                        DoTween(btn, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                        DoTween(knob, {Position = UDim2.new(0.5,0,0,0)}, 0.2)
                    else
                        DoTween(btn, {BackgroundColor3 = Library.Theme.Item}, 0.2)
                        DoTween(knob, {Position = UDim2.new(0,0,0,0)}, 0.2)
                    end
                    if opts.Callback then opts.Callback(state) end
                end
                setState(state)
                btn.MouseButton1Click:Connect(function() setState(not state) end)
            end
            function Section:CreateSlider(opts)
                local slider = Create("Frame", {
                    Parent = Container,
                    Size = UDim2.new(1,0,0,30),
                    BackgroundTransparency = 1,
                })
                local label = Create("TextLabel", {
                    Parent = slider,
                    Text = opts.Name or "Slider",
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(0.2,0,1,0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                local track = Create("Frame", {
                    Parent = slider,
                    Size = UDim2.new(0.7,0,0,6),
                    Position = UDim2.new(0.25,0,0.5,-3),
                    BackgroundColor3 = Library.Theme.Surface,
                })
                ApplyRoundedCorner(track, UDim.new(0,3))
                local thumb = Create("Frame", {
                    Parent = track,
                    Size = UDim2.new(0,12,0,12),
                    Position = UDim2.new(0,0,0.5,-6),
                    BackgroundColor3 = Library.Theme.Accent,
                })
                ApplyRoundedCorner(thumb, UDim.new(0,6))
                local min = opts.Range and opts.Range[1] or 0
                local max = opts.Range and opts.Range[2] or 100
                local value = opts.CurrentValue or min
                local function updatePos(val)
                    local percent = (val - min)/(max - min)
                    thumb.Position = UDim2.new(percent, -6, 0.5, -6)
                    if opts.Callback then opts.Callback(val) end
                end
                updatePos(value)
                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local conn
                        conn = UserInputService.InputChanged:Connect(function(move)
                            if move.UserInputType == Enum.UserInputType.MouseMovement then
                                local rel = move.Position.X - track.AbsolutePosition.X
                                local percent = math.clamp(rel/track.AbsoluteSize.X,0,1)
                                value = min + percent*(max-min)
                                updatePos(value)
                            end
                        end)
                        track.InputEnded:Connect(function() conn:Disconnect() end)
                    end
                end)
            end
            function Section:CreateDropdown(opts)
                local dropdown = Create("Frame", {
                    Parent = Container,
                    Size = UDim2.new(1,0,0,30),
                    BackgroundTransparency = 1,
                })
                local label = Create("TextLabel", {
                    Parent = dropdown,
                    Text = opts.Name or "Dropdown",
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(0.3,0,1,0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                local btn = Create("TextButton", {
                    Parent = dropdown,
                    Size = UDim2.new(0.6,0,1,0),
                    Position = UDim2.new(0.35,0,0,0),
                    BackgroundColor3 = Library.Theme.Item,
                    Text = opts.CurrentOption or "Select",
                    AutoButtonColor = false,
                })
                ApplyRoundedCorner(btn, UDim.new(0,6))
                ApplyStroke(btn, Library.Theme.Outline, 1)
                local list = Create("Frame", {
                    Parent = btn,
                    Size = UDim2.new(1,0,0,0),
                    Position = UDim2.new(0,0,1,0),
                    BackgroundColor3 = Library.Theme.Surface,
                    Visible = false,
                    Clipping = true,
                })
                ApplyRoundedCorner(list, UDim.new(0,6))
                local layout = Create("UIListLayout", {Parent = list, Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder})
                for _,opt in ipairs(opts.Options or {}) do
                    local optBtn = Create("TextButton", {
                        Parent = list,
                        Size = UDim2.new(1,0,0,24),
                        BackgroundTransparency = 1,
                        Text = opt,
                        Font = Enum.Font.Gotham,
                        TextSize = 13,
                        TextColor3 = Library.Theme.Text,
                        AutoButtonColor = false,
                    })
                    optBtn.MouseButton1Click:Connect(function()
                        btn.Text = opt
                        if opts.Callback then opts.Callback(opt) end
                        list.Visible = false
                    end)
                end
                btn.MouseButton1Click:Connect(function() list.Visible = not list.Visible end)
            end
            function Section:CreateInput(opts)
                local input = Create("Frame", {
                    Parent = Container,
                    Size = UDim2.new(1,0,0,30),
                    BackgroundTransparency = 1,
                })
                local label = Create("TextLabel", {
                    Parent = input,
                    Text = opts.Name or "Input",
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(0.3,0,1,0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                local box = Create("TextBox", {
                    Parent = input,
                    Size = UDim2.new(0.6,0,1,0),
                    Position = UDim2.new(0.35,0,0,0),
                    BackgroundColor3 = Library.Theme.Item,
                    Text = "",
                    PlaceholderText = opts.PlaceholderText or "",
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Library.Theme.Text,
                })
                ApplyRoundedCorner(box, UDim.new(0,6))
                box.FocusLost:Connect(function(enterPressed)
                    if enterPressed and opts.Callback then opts.Callback(box.Text) end
                end)
            end
            function Section:CreateKeybind(opts)
                local keybind = Create("Frame", {
                    Parent = Container,
                    Size = UDim2.new(1,0,0,30),
                    BackgroundTransparency = 1,
                })
                local label = Create("TextLabel", {
                    Parent = keybind,
                    Text = opts.Name or "Keybind",
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(0.4,0,1,0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                local btn = Create("TextButton", {
                    Parent = keybind,
                    Size = UDim2.new(0.5,0,1,0),
                    Position = UDim2.new(0.45,0,0,0),
                    BackgroundColor3 = Library.Theme.Item,
                    Text = opts.CurrentKeybind and opts.CurrentKeybind.Name or "Set",
                    AutoButtonColor = false,
                })
                ApplyRoundedCorner(btn, UDim.new(0,6))
                btn.MouseButton1Click:Connect(function()
                    local listening = true
                    btn.Text = "..."
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(input)
                        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                            listening = false
                            btn.Text = input.KeyCode.Name
                            if opts.Callback then opts.Callback(input.KeyCode) end
                            conn:Disconnect()
                        end
                    end)
                end)
                table.insert(Library.Keybinds, {Name = opts.Name or "Keybind", Key = opts.CurrentKeybind or Enum.KeyCode.Unknown})
            end
            function Section:CreateColorPicker(opts)
                ASYR:CreateAdvancedColorPicker({Parent = Container, Name = opts.Name or "ColorPicker", Color = opts.Color, Callback = opts.Callback})
            end
            function Section:CreateLabel(text)
                Create("TextLabel", {
                    Parent = Container,
                    Text = text or "Label",
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(1,0,0,20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
            end
            function Section:CreateParagraph(opts)
                Create("TextLabel", {
                    Parent = Container,
                    Text = opts.Title or "",
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    TextColor3 = Library.Theme.SubText,
                    Size = UDim2.new(1,0,0,20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                Create("TextLabel", {
                    Parent = Container,
                    Text = opts.Content or "",
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(1,0,0,40),
                    BackgroundTransparency = 1,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
            end
            return Section
        end
        return Tab
    end
    return Window
end

-- Initialize UI on script load
ShowIntroPrompt()

return ASYR
