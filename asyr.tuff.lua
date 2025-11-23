-- ASYR UI Library
-- Combined and Optimized for Performance and Aesthetics

local ASYR = {}
ASYR.__version = "1.0.0"

-- Services
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

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

local function ApplyRoundedCorner(instance, radius)
    local rc = Create("UICorner", {CornerRadius = radius or UDim.new(0, 8), Parent = instance})
    return rc
end

local function ApplyStroke(instance, color, thickness)
    local stroke = Create("UIStroke", {Color = color or Color3.fromRGB(50, 50, 50), Thickness = thickness or 1, Parent = instance})
    return stroke
end

-- Blur/Acrylic Module (Adapted from source.lua)
local BlurModule = {}
do
    local Camera = workspace.CurrentCamera
    local BlurFolder = Instance.new("Folder", Camera)
    BlurFolder.Name = "ASYR_Blur"

    local function rayPlaneIntersect(planePos, planeNormal, rayOrigin, rayDirection)
        local n = planeNormal
        local d = rayDirection
        local v = rayOrigin - planePos
        local num = n.x*v.x + n.y*v.y + n.z*v.z
        local den = n.x*d.x + n.y*d.y + n.z*d.z
        local a = -num / den
        return rayOrigin + a * rayDirection, a
    end

    function BlurModule.New(frame)
        local blurPart = Instance.new("Part")
        blurPart.Size = Vector3.new(1, 1, 1) * 0.01
        blurPart.Anchored = true
        blurPart.CanCollide = false
        blurPart.Transparency = 0.6 -- Acrylic effect intensity
        blurPart.Material = Enum.Material.Glass
        blurPart.Color = Color3.fromRGB(0, 0, 0)
        blurPart.Parent = BlurFolder

        local mesh = Instance.new("BlockMesh")
        mesh.Parent = blurPart

        local function update()
            if not frame.Visible then
                blurPart.Transparency = 1
                return
            end
            blurPart.Transparency = 0.6
            
            local corner0 = frame.AbsolutePosition
            local corner1 = corner0 + frame.AbsoluteSize
            local ray0 = Camera:ScreenPointToRay(corner0.X, corner0.Y, 1)
            local ray1 = Camera:ScreenPointToRay(corner1.X, corner1.Y, 1)
            
            local planeOrigin = Camera.CFrame.Position + Camera.CFrame.LookVector * (0.05 - Camera.NearPlaneZ)
            local planeNormal = Camera.CFrame.LookVector
            
            local pos0 = rayPlaneIntersect(planeOrigin, planeNormal, ray0.Origin, ray0.Direction)
            local pos1 = rayPlaneIntersect(planeOrigin, planeNormal, ray1.Origin, ray1.Direction)
            
            pos0 = Camera.CFrame:PointToObjectSpace(pos0)
            pos1 = Camera.CFrame:PointToObjectSpace(pos1)
            
            local size = pos1 - pos0
            local center = (pos0 + pos1)/2
            
            mesh.Offset = center
            mesh.Scale = size / 0.01
            blurPart.CFrame = Camera.CFrame
        end

        RunService.RenderStepped:Connect(update)
        return blurPart
    end
end

-- Library State
local Library = {
    Windows = {},
    Flags = {},
    Theme = {
        Background = Color3.fromRGB(22, 24, 29), -- BGDBColor
        Header = Color3.fromRGB(28, 29, 34), -- BlockColor
        Sidebar = Color3.fromRGB(28, 29, 34), -- BlockColor
        Element = Color3.fromRGB(39, 40, 47), -- BlockBackground
        Text = Color3.fromRGB(255, 255, 255), -- SwitchColor
        Accent = Color3.fromRGB(17, 238, 253), -- Highlight
        Stroke = Color3.fromRGB(55, 56, 63), -- HighStrokeColor
        Toggle = Color3.fromRGB(14, 203, 213), -- Toggle
        Risky = Color3.fromRGB(251, 255, 39), -- Risky
        SecondaryText = Color3.fromRGB(150, 150, 150) -- Custom for subtitles
    }
}

-- Notification System
function ASYR:Notify(options)
    -- options: {Title, Content, Image, Duration}
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 3
    
    local screen = CoreGui:FindFirstChild("ASYR_Notifications")
    if not screen then
        screen = Create("ScreenGui", {Name = "ASYR_Notifications", Parent = CoreGui})
    end
    
    local container = Create("Frame", {
        Parent = screen,
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, 20, 1, -100 - (#screen:GetChildren() * 90)),
        BackgroundColor3 = Library.Theme.Element,
        BorderSizePixel = 0
    })
    ApplyRoundedCorner(container, UDim.new(0, 8))
    ApplyStroke(container, Library.Theme.Stroke, 1)
    
    Create("TextLabel", {
        Parent = container,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Library.Theme.Text,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    Create("TextLabel", {
        Parent = container,
        Text = content,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(180, 180, 180),
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })
    
    -- Animation
    DoTween(container, {Position = UDim2.new(1, -320, 1, -100 - (#screen:GetChildren() * 90))}, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    task.delay(duration, function()
        DoTween(container, {Position = UDim2.new(1, 20, 1, container.Position.Y.Offset)}, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(0.5)
        container:Destroy()
    end)
end

-- Main Window Creation
function ASYR:CreateWindow(options)
    options = options or {}
    local Name = options.Name or "ASYR"
    -- Intro Elements
    local IntroText = options.IntroText or options.LoadingTitle or "ASYR Interface"
    local IntroIcon = options.IntroIcon or "rbxassetid://12345678" -- Default icon if not provided

    local ScreenGui = Create("ScreenGui", {
        Name = "ASYR",
        Parent = CoreGui
    })
    
    -- Protect against multiple instances if needed, but for now just create new
    
    local Main = Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        Size = UDim2.new(0, 485, 0, 565), -- CompKiller Size
        Position = UDim2.new(0.5, -242, 0.5, -282),
        BackgroundColor3 = Library.Theme.Background,
        BackgroundTransparency = 0.1,
        ClipsDescendants = true
    })
    ApplyRoundedCorner(Main, UDim.new(0, 10))
    ApplyStroke(Main, Library.Theme.Stroke, 1)

    local IntroLabel = Create("TextLabel", {
        Name = "IntroText",
        Parent = Main,
        BackgroundColor3 = Library.Theme.Background,
        BackgroundTransparency = 1,
        TextTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, -40),
        Size = UDim2.new(0, 200, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = IntroText,
        TextColor3 = Library.Theme.Text,
        TextSize = 18,
        ZIndex = 10,
        TextXAlignment = Enum.TextXAlignment.Center
    })

    local IntroImage = Create("ImageLabel", {
        Name = "IntroImage",
        Parent = Main,
        BackgroundColor3 = Library.Theme.Element,
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 20),
        ZIndex = 10,
        Size = UDim2.new(0, 100, 0, 100),
        Image = IntroIcon,
        ScaleType = Enum.ScaleType.Fit
    })

    -- Intro Animation
    task.spawn(function()
        -- Expand Main Frame
        DoTween(Main, {BackgroundTransparency = 0.1}, 0.5)
        DoTween(Main, {Size = UDim2.new(0, 485, 0, 565)}, 0.5) -- CompKiller Size
        
        task.wait(0.5)
        
        -- Fade In Intro
        DoTween(IntroLabel, {TextTransparency = 0}, 0.5)
        DoTween(IntroImage, {ImageTransparency = 0}, 0.5)
        
        task.wait(3)
        
        -- Fade Out Intro
        DoTween(IntroLabel, {TextTransparency = 1}, 0.5)
        DoTween(IntroImage, {ImageTransparency = 1}, 0.5)
        
        task.wait(0.5)
        IntroLabel:Destroy()
        IntroImage:Destroy()
        
        -- Reveal UI Elements (if we hid them)
        -- For now, we assume they are created below and will be visible
        -- But to match Visual, we might want to hide them initially?
        -- The Visual library creates them AFTER. 
        -- Since we create them below, they will be visible during intro if we don't hide them.
        -- We will handle visibility in the section below.
        if Main:FindFirstChild("Header") then Main.Header.Visible = true end
        if Main:FindFirstChild("Sidebar") then Main.Sidebar.Visible = true end
        if Main:FindFirstChild("Content") then Main.Content.Visible = true end
    end)
    
    -- Acrylic Effect
    BlurModule.New(Main)
    
    -- Header
    local Header = Create("Frame", {
        Name = "Header",
        Parent = Main,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Library.Theme.Header,
        BackgroundTransparency = 0.5,
        Visible = false -- Hidden for Intro
    })
    ApplyRoundedCorner(Header, UDim.new(0, 10))
    
    Create("TextLabel", {
        Parent = Header,
        Text = Name,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Library.Theme.Text,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = Main,
        Size = UDim2.new(0, 180, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = Library.Theme.Sidebar,
        BackgroundTransparency = 0.8,
        Visible = false -- Hidden for Intro
    })
    
    local TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        Parent = Sidebar,
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    local TabListLayout = Create("UIListLayout", {
        Parent = TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    -- Content Area
    local Content = Create("Frame", {
        Name = "Content",
        Parent = Main,
        Size = UDim2.new(1, -180, 1, -50),
        Position = UDim2.new(0, 180, 0, 50),
        BackgroundTransparency = 1,
        Visible = false -- Hidden for Intro
    })
    
    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    
    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            DoTween(Main, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
    end)
    
    local Window = {
        Tabs = {},
        ActiveTab = nil
    }
    
    function Window:CreateTab(name, image)
        local Tab = {
            Name = name,
            Sections = {}
        }
        
        -- Tab Button
        local TabButton = Create("TextButton", {
            Parent = TabContainer,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false
        })
        ApplyRoundedCorner(TabButton, UDim.new(0, 6))
        
        local TabLabel = Create("TextLabel", {
            Parent = TabButton,
            Text = name,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextColor3 = Library.Theme.SecondaryText,
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.new(0, 15, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- Tab Content Frame
        local TabFrame = Create("ScrollingFrame", {
            Name = name .. "_Content",
            Parent = Content,
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        Create("UIListLayout", {
            Parent = TabFrame,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
        
        -- Activation Logic
        TabButton.MouseButton1Click:Connect(function()
            -- Deactivate old
            if Window.ActiveTab then
                DoTween(Window.ActiveTab.Button, {BackgroundTransparency = 1}, 0.2)
                DoTween(Window.ActiveTab.Label, {TextColor3 = Library.Theme.SecondaryText}, 0.2)
                Window.ActiveTab.Frame.Visible = false
            end
            
            -- Activate new
            Window.ActiveTab = {Button = TabButton, Label = TabLabel, Frame = TabFrame}
            DoTween(TabButton, {BackgroundTransparency = 0.9, BackgroundColor3 = Library.Theme.Accent}, 0.2)
            DoTween(TabLabel, {TextColor3 = Library.Theme.Accent}, 0.2)
            TabFrame.Visible = true
        end)
        
        -- Select first tab by default
        if #Window.Tabs == 0 then
            Window.ActiveTab = {Button = TabButton, Label = TabLabel, Frame = TabFrame}
            TabButton.BackgroundTransparency = 0.9
            TabLabel.TextColor3 = Library.Theme.Text
            TabFrame.Visible = true
        end
        
        table.insert(Window.Tabs, Tab)
        
        function Tab:CreateSection(name)
            local Section = {}
            
            local SectionFrame = Create("Frame", {
                Parent = TabFrame,
                Size = UDim2.new(1, 0, 0, 30), -- Auto-resizing
                BackgroundTransparency = 1
            })
            
            local SectionLabel = Create("TextLabel", {
                Parent = SectionFrame,
                Text = name,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = Library.Theme.Accent,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Container = Create("Frame", {
                Parent = SectionFrame,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 25),
                BackgroundTransparency = 1
            })
            local ContainerLayout = Create("UIListLayout", {
                Parent = Container,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            })
            
            -- Auto-resize logic
            ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Container.Size = UDim2.new(1, 0, 0, ContainerLayout.AbsoluteContentSize.Y)
                SectionFrame.Size = UDim2.new(1, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 30)
                TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabFrame.UIListLayout.AbsoluteContentSize.Y + 20)
            end)
            
            function Section:CreateButton(options)
                local ButtonName = options.Name or "Button"
                local Callback = options.Callback or function() end
                
                local Button = Create("TextButton", {
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundColor3 = Library.Theme.Element,
                    Text = "",
                    AutoButtonColor = false
                })
                ApplyRoundedCorner(Button, UDim.new(0, 6))
                ApplyStroke(Button, Library.Theme.Stroke, 1)
                
                local ButtonLabel = Create("TextLabel", {
                    Parent = Button,
                    Text = ButtonName,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 14,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1
                })
                
                Button.MouseEnter:Connect(function()
                    DoTween(Button, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                end)
                Button.MouseLeave:Connect(function()
                    DoTween(Button, {BackgroundColor3 = Library.Theme.Element}, 0.2)
                end)
                Button.MouseButton1Click:Connect(Callback)
            end
            
            function Section:CreateToggle(options)
                local ToggleName = options.Name or "Toggle"
                local Default = options.CurrentValue or false
                local Callback = options.Callback or function() end
                
                local State = Default
                
                local ToggleFrame = Create("TextButton", {
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundColor3 = Library.Theme.Element,
                    Text = "",
                    AutoButtonColor = false
                })
                ApplyRoundedCorner(ToggleFrame, UDim.new(0, 6))
                ApplyStroke(ToggleFrame, Library.Theme.Stroke, 1)
                
                local Label = Create("TextLabel", {
                    Parent = ToggleFrame,
                    Text = ToggleName,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 14,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Switch = Create("Frame", {
                    Parent = ToggleFrame,
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -50, 0.5, -10),
                    BackgroundColor3 = State and Library.Theme.Toggle or Library.Theme.Stroke
                })
                ApplyRoundedCorner(Switch, UDim.new(0, 10))
                
                local Knob = Create("Frame", {
                    Parent = Switch,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, State and 22 or 2, 0.5, -8),
                    BackgroundColor3 = Library.Theme.Text
                })
                ApplyRoundedCorner(Knob, UDim.new(1, 0))
                
                local function Update()
                    DoTween(Switch, {BackgroundColor3 = State and Library.Theme.Toggle or Library.Theme.Stroke}, 0.2)
                    DoTween(Knob, {Position = UDim2.new(0, State and 22 or 2, 0.5, -8)}, 0.2)
                    Callback(State)
                end
                
                ToggleFrame.MouseButton1Click:Connect(function()
                    State = not State
                    Update()
                end)
            end
            
            function Section:CreateSlider(options)
                local SliderName = options.Name or "Slider"
                local Min = options.Range and options.Range[1] or 0
                local Max = options.Range and options.Range[2] or 100
                local Default = options.CurrentValue or Min
                local Callback = options.Callback or function() end
                
                local Value = Default
                
                local SliderFrame = Create("Frame", {
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = Library.Theme.Element
                })
                ApplyRoundedCorner(SliderFrame, UDim.new(0, 6))
                ApplyStroke(SliderFrame, Library.Theme.Stroke, 1)
                
                local Label = Create("TextLabel", {
                    Parent = SliderFrame,
                    Text = SliderName,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 14,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local ValueLabel = Create("TextLabel", {
                    Parent = SliderFrame,
                    Text = tostring(Value),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = Library.Theme.SecondaryText,
                    Size = UDim2.new(0, 50, 0, 20),
                    Position = UDim2.new(1, -60, 0, 5),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local Track = Create("Frame", {
                    Parent = SliderFrame,
                    Size = UDim2.new(1, -20, 0, 6),
                    Position = UDim2.new(0, 10, 0, 35),
                    BackgroundColor3 = Library.Theme.Stroke
                })
                ApplyRoundedCorner(Track, UDim.new(1, 0))
                
                local Fill = Create("Frame", {
                    Parent = Track,
                    Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0),
                    BackgroundColor3 = Library.Theme.Accent
                })
                ApplyRoundedCorner(Fill, UDim.new(1, 0))
                
                local dragging = false
                
                local function Update(input)
                    local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    Value = math.floor(Min + (Max - Min) * pos)
                    ValueLabel.Text = tostring(Value)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    Callback(Value)
                end
                
                Track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        Update(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        Update(input)
                    end
                end)
            end
            
            function Section:CreateDropdown(options)
                local DropdownName = options.Name or "Dropdown"
                local Options = options.Options or {}
                local Multi = options.Multi or false
                local Default = options.CurrentOption or (Multi and {} or Options[1])
                local Callback = options.Callback or function() end
                
                local CurrentOption = Default
                local Open = false
                
                local DropdownFrame = Create("Frame", {
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundColor3 = Library.Theme.Element,
                    ClipsDescendants = true
                })
                ApplyRoundedCorner(DropdownFrame, UDim.new(0, 6))
                ApplyStroke(DropdownFrame, Library.Theme.Stroke, 1)
                
                local Label = Create("TextLabel", {
                    Parent = DropdownFrame,
                    Text = DropdownName,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 14,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(1, -40, 0, 36),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local function GetText()
                    if Multi then
                        local selected = {}
                        for k, v in pairs(CurrentOption) do
                            if v then table.insert(selected, k) end
                        end
                        if #selected == 0 then return "None" end
                        if #selected == 1 then return selected[1] end
                        return #selected .. " Selected"
                    else
                        return tostring(CurrentOption)
                    end
                end
                
                local SelectedLabel = Create("TextLabel", {
                    Parent = DropdownFrame,
                    Text = GetText(),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = Library.Theme.SecondaryText,
                    Size = UDim2.new(0, 100, 0, 36),
                    Position = UDim2.new(1, -130, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local Arrow = Create("ImageLabel", {
                    Parent = DropdownFrame,
                    Image = "rbxassetid://6031091004",
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(1, -25, 0, 8),
                    BackgroundTransparency = 1,
                    ImageColor3 = Library.Theme.SecondaryText
                })
                
                local OptionContainer = Create("Frame", {
                    Parent = DropdownFrame,
                    Size = UDim2.new(1, -10, 0, 0),
                    Position = UDim2.new(0, 5, 0, 40),
                    BackgroundTransparency = 1
                })
                local OptionLayout = Create("UIListLayout", {
                    Parent = OptionContainer,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2)
                })
                
                local function Toggle()
                    Open = not Open
                    local count = #Options
                    local height = Open and (count * 32) + 45 or 36
                    
                    DoTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, height)}, 0.3)
                    DoTween(Arrow, {Rotation = Open and 180 or 0}, 0.3)
                end
                
                local function Select(option, button)
                    if Multi then
                        if CurrentOption[option] then
                            CurrentOption[option] = nil
                            DoTween(button, {BackgroundColor3 = Library.Theme.Header}, 0.2)
                        else
                            CurrentOption[option] = true
                            DoTween(button, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                        end
                        SelectedLabel.Text = GetText()
                        Callback(CurrentOption)
                    else
                        CurrentOption = option
                        SelectedLabel.Text = tostring(option)
                        Toggle()
                        Callback(option)
                    end
                end
                
                for _, opt in ipairs(Options) do
                    local OptBtn = Create("TextButton", {
                        Parent = OptionContainer,
                        Size = UDim2.new(1, 0, 0, 30),
                        BackgroundColor3 = Library.Theme.Header,
                        Text = tostring(opt),
                        Font = Enum.Font.Gotham,
                        TextColor3 = Library.Theme.Text,
                        TextSize = 13,
                        AutoButtonColor = false
                    })
                    ApplyRoundedCorner(OptBtn, UDim.new(0, 4))
                    
                    if Multi and CurrentOption[opt] then
                        OptBtn.BackgroundColor3 = Library.Theme.Accent
                    end
                    
                    OptBtn.MouseButton1Click:Connect(function() Select(opt, OptBtn) end)
                end
                
                local Trigger = Create("TextButton", {
                    Parent = DropdownFrame,
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundTransparency = 1,
                    Text = ""
                })
                Trigger.MouseButton1Click:Connect(Toggle)
            end
            
            function Section:CreateInput(options)
                local InputName = options.Name or "Input"
                local Placeholder = options.PlaceholderText or "Type here..."
                local Callback = options.Callback or function() end
                
                local InputFrame = Create("Frame", {
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = Library.Theme.Element
                })
                ApplyRoundedCorner(InputFrame, UDim.new(0, 6))
                ApplyStroke(InputFrame, Library.Theme.Stroke, 1)
                
                local Label = Create("TextLabel", {
                    Parent = InputFrame,
                    Text = InputName,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 14,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(0, 100, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local TextBox = Create("TextBox", {
                    Parent = InputFrame,
                    PlaceholderText = Placeholder,
                    Text = "",
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Library.Theme.Text,
                    PlaceholderColor3 = Library.Theme.SecondaryText,
                    Size = UDim2.new(1, -120, 1, -10),
                    Position = UDim2.new(0, 110, 0, 5),
                    BackgroundColor3 = Library.Theme.Header,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ApplyRoundedCorner(TextBox, UDim.new(0, 4))
                
                TextBox.FocusLost:Connect(function(enter)
                    if enter then Callback(TextBox.Text) end
                end)
            end

            function Section:CreateKeybind(options)
                local KeybindName = options.Name or "Keybind"
                local Default = options.CurrentKeybind or Enum.KeyCode.RightControl
                local HoldToInteract = options.HoldToInteract or false
                local Callback = options.Callback or function() end
                
                local CurrentKey = Default
                local Binding = false
                
                local KeybindFrame = Create("Frame", {
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundColor3 = Library.Theme.Element
                })
                ApplyRoundedCorner(KeybindFrame, UDim.new(0, 6))
                ApplyStroke(KeybindFrame, Library.Theme.Stroke, 1)
                
                local Label = Create("TextLabel", {
                    Parent = KeybindFrame,
                    Text = KeybindName,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 14,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(1, -100, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local BindButton = Create("TextButton", {
                    Parent = KeybindFrame,
                    Size = UDim2.new(0, 80, 0, 24),
                    Position = UDim2.new(1, -90, 0, 6),
                    BackgroundColor3 = Library.Theme.Header,
                    Text = CurrentKey.Name,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = Library.Theme.SecondaryText,
                    AutoButtonColor = false
                })
                ApplyRoundedCorner(BindButton, UDim.new(0, 4))
                
                BindButton.MouseButton1Click:Connect(function()
                    Binding = true
                    BindButton.Text = "..."
                end)
                
                UserInputService.InputBegan:Connect(function(input)
                    if Binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        CurrentKey = input.KeyCode
                        BindButton.Text = CurrentKey.Name
                        Binding = false
                        Callback(CurrentKey)
                    elseif input.KeyCode == CurrentKey and not Binding then
                        Callback(true)
                    end
                end)
                
                if HoldToInteract then
                    UserInputService.InputEnded:Connect(function(input)
                        if input.KeyCode == CurrentKey and not Binding then
                            Callback(false)
                        end
                    end)
                end
            end

            function Section:CreateColorPicker(options)
                local PickerName = options.Name or "Color Picker"
                local Default = options.Color or Color3.fromRGB(255, 255, 255)
                local Callback = options.Callback or function() end
                
                local Color = Default
                local Open = false
                
                local PickerFrame = Create("Frame", {
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundColor3 = Library.Theme.Element,
                    ClipsDescendants = true
                })
                ApplyRoundedCorner(PickerFrame, UDim.new(0, 6))
                ApplyStroke(PickerFrame, Library.Theme.Stroke, 1)
                
                local Label = Create("TextLabel", {
                    Parent = PickerFrame,
                    Text = PickerName,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 14,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(1, -50, 0, 36),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local ColorDisplay = Create("TextButton", {
                    Parent = PickerFrame,
                    Size = UDim2.new(0, 30, 0, 20),
                    Position = UDim2.new(1, -40, 0, 8),
                    BackgroundColor3 = Color,
                    Text = "",
                    AutoButtonColor = false
                })
                ApplyRoundedCorner(ColorDisplay, UDim.new(0, 4))
                
                -- Simple RGB Sliders (Hidden by default)
                local Sliders = Create("Frame", {
                    Parent = PickerFrame,
                    Size = UDim2.new(1, -20, 0, 100),
                    Position = UDim2.new(0, 10, 0, 40),
                    BackgroundTransparency = 1
                })
                
                local function UpdateColor()
                    ColorDisplay.BackgroundColor3 = Color
                    Callback(Color)
                end
                
                local function CreateRGBSlider(name, y, component)
                    local Slider = Create("Frame", {
                        Parent = Sliders,
                        Size = UDim2.new(1, 0, 0, 20),
                        Position = UDim2.new(0, 0, 0, y),
                        BackgroundTransparency = 1
                    })
                    
                    local SLabel = Create("TextLabel", {
                        Parent = Slider,
                        Text = name,
                        Size = UDim2.new(0, 20, 1, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = Library.Theme.Text,
                        Font = Enum.Font.Gotham
                    })
                    
                    local Track = Create("Frame", {
                        Parent = Slider,
                        Size = UDim2.new(1, -30, 0, 4),
                        Position = UDim2.new(0, 30, 0.5, -2),
                        BackgroundColor3 = Library.Theme.Stroke
                    })
                    
                    local Fill = Create("Frame", {
                        Parent = Track,
                        Size = UDim2.new(select(component, Color.R, Color.G, Color.B), 0, 1, 0),
                        BackgroundColor3 = name == "R" and Color3.fromRGB(255, 0, 0) or name == "G" and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 255)
                    })
                    
                    local dragging = false
                    Track.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                            Fill.Size = UDim2.new(pos, 0, 1, 0)
                            local r, g, b = Color.R, Color.G, Color.B
                            if name == "R" then r = pos elseif name == "G" then g = pos else b = pos end
                            Color = Color3.new(r, g, b)
                            UpdateColor()
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                            Fill.Size = UDim2.new(pos, 0, 1, 0)
                            local r, g, b = Color.R, Color.G, Color.B
                            if name == "R" then r = pos elseif name == "G" then g = pos else b = pos end
                            Color = Color3.new(r, g, b)
                            UpdateColor()
                        end
                    end)
                end
                
                CreateRGBSlider("R", 0, 1)
                CreateRGBSlider("G", 30, 2)
                CreateRGBSlider("B", 60, 3)
                
                ColorDisplay.MouseButton1Click:Connect(function()
                    Open = not Open
                    DoTween(PickerFrame, {Size = UDim2.new(1, 0, 0, Open and 140 or 36)}, 0.3)
                end)
            end

            function Section:CreateLabel(text)
                local LabelFrame = Create("Frame", {
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 26),
                    BackgroundTransparency = 1
                })
                
                local Label = Create("TextLabel", {
                    Parent = LabelFrame,
                    Text = text,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextColor3 = Library.Theme.Text,
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true
                })
                
                -- Auto resize for wrapped text
                Label:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    LabelFrame.Size = UDim2.new(1, 0, 0, Label.TextBounds.Y + 10)
                end)
            end
            
            function Section:CreateParagraph(options)
                Section:CreateLabel(options.Title .. "\n" .. options.Content)
            end
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

return ASYR
