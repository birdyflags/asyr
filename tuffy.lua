local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local Centrixity = {}

local Theme = {
    Background = Color3.fromRGB(19, 20, 25),
    Secondary = Color3.fromRGB(16, 17, 21),
    Tertiary = Color3.fromRGB(24, 25, 32),
    Accent = Color3.fromRGB(255, 127, 0),
    AccentSecondary = Color3.fromRGB(255, 200, 87),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(69, 71, 90),
    Stroke = Color3.fromRGB(28, 30, 38),
    Divider = Color3.fromRGB(31, 31, 45),
    Success = Color3.fromRGB(47, 255, 0),
    Warning = Color3.fromRGB(255, 214, 10),
    Error = Color3.fromRGB(255, 75, 75)
}

local Fonts = {
    Regular = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    Medium = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
    Bold = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
}

local function Tween(obj, props, dur)
    local t = TweenService:Create(obj, TweenInfo.new(dur or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function Corner(p, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r or 6) c.Parent = p return c end
local function Stroke(p, col) local s = Instance.new("UIStroke") s.Color = col or Theme.Stroke s.Parent = p return s end
local function Gradient(p) local g = Instance.new("UIGradient") g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Theme.Accent), ColorSequenceKeypoint.new(1, Theme.AccentSecondary)}) g.Parent = p return g end

local function MakeDraggable(frame, handle)
    local drag, start, sPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            start = i.Position
            sPos = frame.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - start
            frame.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
        end
    end)
end

function Centrixity:CreateWindow(config)
    config = config or {}
    local Window = {Tabs = {}, ActiveTab = nil}
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CentrixityUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = (RunService:IsStudio() and Player:WaitForChild("PlayerGui")) or game:GetService("CoreGui")
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = config.Size or UDim2.new(0, 689, 0, 489)
    Main.BackgroundColor3 = Theme.Background
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    Corner(Main, 11)
    
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 37)
    Header.BackgroundTransparency = 1
    Header.Parent = Main
    
    local HLine = Instance.new("Frame")
    HLine.AnchorPoint = Vector2.new(0, 1)
    HLine.Position = UDim2.new(0, 0, 1, 0)
    HLine.Size = UDim2.new(1, 0, 0, 2)
    HLine.BackgroundColor3 = Theme.Divider
    HLine.BorderSizePixel = 0
    HLine.Parent = Header
    
    local Icon = Instance.new("ImageLabel")
    Icon.Position = UDim2.new(0, 12, 0, 2)
    Icon.Size = UDim2.new(0, 34, 0, 34)
    Icon.BackgroundTransparency = 1
    Icon.Image = config.Icon or "rbxassetid://137946959393180"
    Icon.ScaleType = Enum.ScaleType.Fit
    Icon.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Position = UDim2.new(0, 52, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = (config.Title or "Centrixity") .. ' <font color="#45475a">' .. (config.Subtitle or "") .. '</font>'
    Title.RichText = true
    Title.TextColor3 = Theme.Text
    Title.FontFace = Fonts.Medium
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    MakeDraggable(Main, Header)
    
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Position = UDim2.new(0, 0, 0, 37)
    Sidebar.Size = UDim2.new(0, 75, 1, -37)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = Main
    
    local SLine = Instance.new("Frame")
    SLine.AnchorPoint = Vector2.new(1, 0)
    SLine.Position = UDim2.new(1, 0, 0, 0)
    SLine.Size = UDim2.new(0, 2, 1, 0)
    SLine.BackgroundColor3 = Theme.Divider
    SLine.BorderSizePixel = 0
    SLine.Parent = Sidebar
    
    local TabList = Instance.new("Frame")
    TabList.Size = UDim2.new(1, 0, 1, 0)
    TabList.BackgroundTransparency = 1
    TabList.Parent = Sidebar
    
    local TLayout = Instance.new("UIListLayout")
    TLayout.Padding = UDim.new(0, 5)
    TLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TLayout.Parent = TabList
    
    local TPad = Instance.new("UIPadding")
    TPad.PaddingTop = UDim.new(0, 10)
    TPad.Parent = TabList
    
    local SubHeader = Instance.new("Frame")
    SubHeader.Name = "SubHeader"
    SubHeader.Position = UDim2.new(0, 77, 0, 37)
    SubHeader.Size = UDim2.new(1, -77, 0, 51)
    SubHeader.BackgroundTransparency = 1
    SubHeader.Parent = Main
    
    local SHLayout = Instance.new("UIListLayout")
    SHLayout.Padding = UDim.new(0, 8)
    SHLayout.FillDirection = Enum.FillDirection.Horizontal
    SHLayout.Parent = SubHeader
    
    local SHPad = Instance.new("UIPadding")
    SHPad.PaddingTop = UDim.new(0, 4)
    SHPad.PaddingLeft = UDim.new(0, 20)
    SHPad.Parent = SubHeader
    
    local PageHolder = Instance.new("Frame")
    PageHolder.Name = "PageHolder"
    PageHolder.Position = UDim2.new(0, 77, 0, 88)
    PageHolder.Size = UDim2.new(1, -77, 1, -88)
    PageHolder.BackgroundColor3 = Theme.Secondary
    PageHolder.ClipsDescendants = true
    PageHolder.Parent = Main
    Corner(PageHolder, 11)
    
    local NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "Notifs"
    NotifHolder.Position = UDim2.new(0, 12, 0, 12)
    NotifHolder.Size = UDim2.new(0, 280, 1, -24)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Parent = ScreenGui
    
    local NLayout = Instance.new("UIListLayout")
    NLayout.Padding = UDim.new(0, 8)
    NLayout.Parent = NotifHolder
    
    function Window:Notify(cfg)
        cfg = cfg or {}
        local nType = cfg.Type or "Success"
        local nTitle = cfg.Title or "Notification"
        local nContent = cfg.Content or ""
        local nDuration = cfg.Duration or 5
        local nButtons = cfg.Buttons or {}
        
        local colors = {
            Success = {c = Theme.Success, i = "rbxassetid://92431556586885"},
            Warning = {c = Theme.Warning, i = "rbxassetid://70479764730792"},
            Error = {c = Theme.Error, i = "rbxassetid://138617501067622"}
        }
        local st = colors[nType] or colors.Success
        
        local Notif = Instance.new("Frame")
        Notif.Name = "Notif"
        Notif.Size = UDim2.new(1, 0, 0, 38)
        Notif.AutomaticSize = Enum.AutomaticSize.Y
        Notif.BackgroundColor3 = Theme.Secondary
        Notif.ClipsDescendants = true
        Notif.Parent = NotifHolder
        Corner(Notif, 8)
        
        local NHeader = Instance.new("Frame")
        NHeader.Size = UDim2.new(1, 0, 0, 38)
        NHeader.BackgroundTransparency = 1
        NHeader.Parent = Notif
        
        local NIcon = Instance.new("ImageLabel")
        NIcon.Position = UDim2.new(0, 10, 0, 9)
        NIcon.Size = UDim2.new(0, 20, 0, 20)
        NIcon.BackgroundTransparency = 1
        NIcon.Image = st.i
        NIcon.ImageColor3 = st.c
        NIcon.Parent = NHeader
        
        local NTitle = Instance.new("TextLabel")
        NTitle.Position = UDim2.new(0, 38, 0, 0)
        NTitle.Size = UDim2.new(1, -100, 0, 38)
        NTitle.BackgroundTransparency = 1
        NTitle.Text = nTitle
        NTitle.TextColor3 = Theme.Text
        NTitle.FontFace = Fonts.Medium
        NTitle.TextSize = 14
        NTitle.TextXAlignment = Enum.TextXAlignment.Left
        NTitle.TextTruncate = Enum.TextTruncate.AtEnd
        NTitle.Parent = NHeader
        
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
        CloseBtn.Position = UDim2.new(1, -8, 0.5, 0)
        CloseBtn.Size = UDim2.new(0, 20, 0, 20)
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.Text = "×"
        CloseBtn.TextColor3 = Theme.TextDark
        CloseBtn.FontFace = Fonts.Bold
        CloseBtn.TextSize = 20
        CloseBtn.Parent = NHeader
        
        local ContentHolder = Instance.new("Frame")
        ContentHolder.Name = "Content"
        ContentHolder.Position = UDim2.new(0, 0, 0, 38)
        ContentHolder.Size = UDim2.new(1, 0, 0, 0)
        ContentHolder.AutomaticSize = Enum.AutomaticSize.Y
        ContentHolder.BackgroundTransparency = 1
        ContentHolder.Parent = Notif
        
        if nContent ~= "" then
            local NText = Instance.new("TextLabel")
            NText.Position = UDim2.new(0, 12, 0, 0)
            NText.Size = UDim2.new(1, -24, 0, 0)
            NText.AutomaticSize = Enum.AutomaticSize.Y
            NText.BackgroundTransparency = 1
            NText.Text = nContent
            NText.TextColor3 = Theme.TextDark
            NText.FontFace = Fonts.Regular
            NText.TextSize = 13
            NText.TextXAlignment = Enum.TextXAlignment.Left
            NText.TextWrapped = true
            NText.Parent = ContentHolder
        end
        
        if #nButtons > 0 then
            local BtnHolder = Instance.new("Frame")
            BtnHolder.Position = UDim2.new(0, 12, 0, nContent ~= "" and 30 or 4)
            BtnHolder.Size = UDim2.new(1, -24, 0, 28)
            BtnHolder.BackgroundTransparency = 1
            BtnHolder.Parent = ContentHolder
            
            local BLayout = Instance.new("UIListLayout")
            BLayout.Padding = UDim.new(0, 8)
            BLayout.FillDirection = Enum.FillDirection.Horizontal
            BLayout.Parent = BtnHolder
            
            for idx, btn in ipairs(nButtons) do
                local B = Instance.new("TextButton")
                B.Size = UDim2.new(0, 70, 0, 26)
                B.AutomaticSize = Enum.AutomaticSize.X
                B.BackgroundColor3 = idx == 1 and st.c or Theme.Tertiary
                B.BackgroundTransparency = idx == 1 and 0.9 or 0
                B.Text = ""
                B.Parent = BtnHolder
                Corner(B, 4)
                if idx > 1 then Stroke(B, Theme.TextDark) end
                
                local BT = Instance.new("TextLabel")
                BT.Size = UDim2.new(1, 0, 1, 0)
                BT.BackgroundTransparency = 1
                BT.Text = btn.Name or "Button"
                BT.TextColor3 = idx == 1 and st.c or Theme.TextDark
                BT.FontFace = Fonts.Regular
                BT.TextSize = 12
                BT.Parent = B
                
                local BPad = Instance.new("UIPadding")
                BPad.PaddingLeft = UDim.new(0, 12)
                BPad.PaddingRight = UDim.new(0, 12)
                BPad.Parent = B
                
                B.MouseButton1Click:Connect(function()
                    if btn.Callback then btn.Callback() end
                    Notif:Destroy()
                end)
            end
        end
        
        local ProgressBG = Instance.new("Frame")
        ProgressBG.Name = "ProgressBG"
        ProgressBG.AnchorPoint = Vector2.new(0, 1)
        ProgressBG.Position = UDim2.new(0, 0, 1, 0)
        ProgressBG.Size = UDim2.new(1, 0, 0, 3)
        ProgressBG.BackgroundColor3 = Theme.Tertiary
        ProgressBG.BorderSizePixel = 0
        ProgressBG.Parent = Notif
        
        local Progress = Instance.new("Frame")
        Progress.Size = UDim2.new(1, 0, 1, 0)
        Progress.BackgroundColor3 = st.c
        Progress.BorderSizePixel = 0
        Progress.Parent = ProgressBG
        Corner(Progress, 2)
        
        local BottomPad = Instance.new("Frame")
        BottomPad.Position = UDim2.new(0, 0, 0, nContent ~= "" and 34 or 8)
        BottomPad.Size = UDim2.new(1, 0, 0, #nButtons > 0 and 40 or 8)
        BottomPad.BackgroundTransparency = 1
        BottomPad.Parent = ContentHolder
        
        Notif.Position = UDim2.new(-1, 0, 0, 0)
        Tween(Notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.35)
        
        local startTime = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            local remaining = math.max(0, nDuration - elapsed)
            Progress.Size = UDim2.new(remaining / nDuration, 0, 1, 0)
            if remaining <= 0 then
                conn:Disconnect()
                Tween(Notif, {Position = UDim2.new(-1.5, 0, 0, 0)}, 0.3)
                task.delay(0.35, function() Notif:Destroy() end)
            end
        end)
        
        CloseBtn.MouseButton1Click:Connect(function()
            conn:Disconnect()
            Tween(Notif, {Position = UDim2.new(-1.5, 0, 0, 0)}, 0.25)
            task.delay(0.3, function() Notif:Destroy() end)
        end)
        
        CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {TextColor3 = Theme.Error}, 0.1) end)
        CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {TextColor3 = Theme.TextDark}, 0.1) end)
    end
    
    function Window:CreateTab(cfg)
        cfg = cfg or {}
        local tabName = cfg.Name or "Tab"
        local tabIcon = cfg.Icon or "rbxassetid://80869096876893"
        
        local Tab = {SubPages = {}, ActiveSubPage = nil, Name = tabName}
        local isFirst = #Window.Tabs == 0
        table.insert(Window.Tabs, Tab)
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName
        TabBtn.Size = UDim2.new(0, 55, 0, 60)
        TabBtn.BackgroundColor3 = Theme.Text
        TabBtn.BackgroundTransparency = isFirst and 0.9 or 1
        TabBtn.Text = ""
        TabBtn.ClipsDescendants = true
        TabBtn.Parent = TabList
        Corner(TabBtn, 5)
        
        local TGrad = Gradient(TabBtn)
        TGrad.Enabled = isFirst
        
        local TIcon = Instance.new("ImageLabel")
        TIcon.AnchorPoint = Vector2.new(0.5, 0)
        TIcon.Position = UDim2.new(0.5, 0, 0, 10)
        TIcon.Size = UDim2.new(0, 22, 0, 22)
        TIcon.BackgroundTransparency = 1
        TIcon.Image = tabIcon
        TIcon.ImageColor3 = isFirst and Theme.Accent or Theme.TextDark
        TIcon.Parent = TabBtn
        
        local TLabel = Instance.new("TextLabel")
        TLabel.AnchorPoint = Vector2.new(0.5, 0)
        TLabel.Position = UDim2.new(0.5, 0, 0, 34)
        TLabel.Size = UDim2.new(1, 0, 0, 14)
        TLabel.BackgroundTransparency = 1
        TLabel.Text = tabName
        TLabel.TextColor3 = isFirst and Theme.Text or Theme.TextDark
        TLabel.FontFace = Fonts.Bold
        TLabel.TextSize = 11
        TLabel.Parent = TabBtn
        
        local Indicator = Instance.new("Frame")
        Indicator.AnchorPoint = Vector2.new(0.5, 1)
        Indicator.Position = UDim2.new(0.5, 0, 1, 3)
        Indicator.Size = isFirst and UDim2.new(0, 25, 0, 5) or UDim2.new(0, 0, 0, 5)
        Indicator.BackgroundColor3 = Theme.Text
        Indicator.Parent = TabBtn
        Corner(Indicator, 10)
        Gradient(Indicator)
        
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabName
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = Theme.Accent
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.Visible = isFirst
        TabPage.Parent = PageHolder
        
        if isFirst then Window.ActiveTab = Tab end
        
        local function Select()
            if Window.ActiveTab == Tab then return end
            
            for _, t in pairs(Window.Tabs) do
                local btn = TabList:FindFirstChild(t.Name)
                if btn then
                    Tween(btn, {BackgroundTransparency = 1}, 0.2)
                    local g = btn:FindFirstChildOfClass("UIGradient")
                    if g then g.Enabled = false end
                    local ic = btn:FindFirstChild("ImageLabel")
                    if ic then Tween(ic, {ImageColor3 = Theme.TextDark}, 0.2) end
                    local lb = btn:FindFirstChild("TextLabel")
                    if lb then Tween(lb, {TextColor3 = Theme.TextDark}, 0.2) end
                    for _, ch in pairs(btn:GetChildren()) do
                        if ch.Name == "Frame" then Tween(ch, {Size = UDim2.new(0, 0, 0, 5)}, 0.2) end
                    end
                end
                local pg = PageHolder:FindFirstChild(t.Name)
                if pg then pg.Visible = false end
            end
            
            for _, ch in pairs(SubHeader:GetChildren()) do
                if ch:IsA("TextButton") then ch:Destroy() end
            end
            
            Window.ActiveTab = Tab
            TGrad.Enabled = true
            Tween(TabBtn, {BackgroundTransparency = 0.9}, 0.2)
            Tween(TIcon, {ImageColor3 = Theme.Accent}, 0.2)
            Tween(TLabel, {TextColor3 = Theme.Text}, 0.2)
            Tween(Indicator, {Size = UDim2.new(0, 25, 0, 5)}, 0.25, Enum.EasingStyle.Back)
            TabPage.Visible = true
            
            Tab.ActiveSubPage = nil
            for i, sp in ipairs(Tab.SubPages) do
                sp:BuildButton(i == 1)
            end
            if Tab.SubPages[1] then Tab.SubPages[1]:Select() end
        end
        
        TabBtn.MouseButton1Click:Connect(Select)
        
        function Tab:CreateSubPage(cfg)
            cfg = cfg or {}
            local spName = cfg.Name or "SubPage"
            
            local SubPage = {Name = spName, Sections = {}}
            local isFirstSP = #Tab.SubPages == 0
            table.insert(Tab.SubPages, SubPage)
            
            local SPContent = Instance.new("Frame")
            SPContent.Name = spName
            SPContent.Size = UDim2.new(1, 0, 0, 0)
            SPContent.AutomaticSize = Enum.AutomaticSize.Y
            SPContent.BackgroundTransparency = 1
            SPContent.Visible = isFirstSP and isFirst
            SPContent.Parent = TabPage
            
            local SPLayout = Instance.new("UIListLayout")
            SPLayout.Padding = UDim.new(0, 12)
            SPLayout.FillDirection = Enum.FillDirection.Horizontal
            SPLayout.Parent = SPContent
            
            local SPPad = Instance.new("UIPadding")
            SPPad.PaddingTop = UDim.new(0, 12)
            SPPad.PaddingLeft = UDim.new(0, 12)
            SPPad.PaddingRight = UDim.new(0, 12)
            SPPad.PaddingBottom = UDim.new(0, 12)
            SPPad.Parent = SPContent
            
            if isFirstSP then Tab.ActiveSubPage = SubPage end
            
            function SubPage:BuildButton(active)
                local SPBtn = Instance.new("TextButton")
                SPBtn.Name = spName
                SPBtn.Size = UDim2.new(0, 0, 0, 32)
                SPBtn.AutomaticSize = Enum.AutomaticSize.X
                SPBtn.BackgroundColor3 = Theme.Text
                SPBtn.BackgroundTransparency = active and 0.85 or 1
                SPBtn.Text = spName
                SPBtn.TextColor3 = active and Theme.Text or Theme.TextDark
                SPBtn.FontFace = Fonts.Medium
                SPBtn.TextSize = 13
                SPBtn.Parent = SubHeader
                Corner(SPBtn, 4)
                
                if active then Gradient(SPBtn) end
                
                local BPad = Instance.new("UIPadding")
                BPad.PaddingLeft = UDim.new(0, 14)
                BPad.PaddingRight = UDim.new(0, 14)
                BPad.Parent = SPBtn
                
                SPBtn.MouseButton1Click:Connect(function() SubPage:Select() end)
            end
            
            function SubPage:Select()
                if Tab.ActiveSubPage == SubPage then return end
                
                for _, sp in pairs(Tab.SubPages) do
                    local content = TabPage:FindFirstChild(sp.Name)
                    if content then content.Visible = false end
                    local btn = SubHeader:FindFirstChild(sp.Name)
                    if btn then
                        Tween(btn, {BackgroundTransparency = 1, TextColor3 = Theme.TextDark}, 0.2)
                        local g = btn:FindFirstChildOfClass("UIGradient")
                        if g then g:Destroy() end
                    end
                end
                
                Tab.ActiveSubPage = SubPage
                SPContent.Visible = true
                
                local btn = SubHeader:FindFirstChild(spName)
                if btn then
                    Tween(btn, {BackgroundTransparency = 0.85, TextColor3 = Theme.Text}, 0.2)
                    if not btn:FindFirstChildOfClass("UIGradient") then Gradient(btn) end
                end
            end
            
            function SubPage:CreateSection(cfg)
                cfg = cfg or {}
                local secName = cfg.Name or "Section"
                local secIcon = cfg.Icon or "rbxassetid://83273732891006"
                local secSide = cfg.Side or "Left"
                
                local Section = {}
                
                local SecFrame = Instance.new("Frame")
                SecFrame.Name = secName
                SecFrame.Size = UDim2.new(0, 280, 0, 40)
                SecFrame.AutomaticSize = Enum.AutomaticSize.Y
                SecFrame.BackgroundColor3 = Color3.fromRGB(17, 18, 22)
                SecFrame.LayoutOrder = secSide == "Left" and 0 or 1
                SecFrame.Parent = SPContent
                Corner(SecFrame, 6)
                
                local SecHeader = Instance.new("Frame")
                SecHeader.Size = UDim2.new(1, 0, 0, 30)
                SecHeader.BackgroundColor3 = Theme.Background
                SecHeader.Parent = SecFrame
                Corner(SecHeader, 6)
                
                local SecLine = Instance.new("Frame")
                SecLine.AnchorPoint = Vector2.new(0, 1)
                SecLine.Position = UDim2.new(0, 0, 1, 0)
                SecLine.Size = UDim2.new(1, 0, 0, 2)
                SecLine.BorderSizePixel = 0
                SecLine.Parent = SecHeader
                Gradient(SecLine)
                
                local AccLine = Instance.new("Frame")
                AccLine.Position = UDim2.new(0, -3, 0, 5)
                AccLine.Size = UDim2.new(0, 6, 0, 20)
                AccLine.BackgroundColor3 = Theme.Accent
                AccLine.Parent = SecHeader
                Corner(AccLine, 30)
                
                local SecIcon = Instance.new("ImageLabel")
                SecIcon.Position = UDim2.new(0, 12, 0, 7)
                SecIcon.Size = UDim2.new(0, 16, 0, 16)
                SecIcon.BackgroundTransparency = 1
                SecIcon.Image = secIcon
                SecIcon.ImageColor3 = Theme.Accent
                SecIcon.Parent = SecHeader
                
                local SecTitle = Instance.new("TextLabel")
                SecTitle.Position = UDim2.new(0, 34, 0, 0)
                SecTitle.Size = UDim2.new(1, -40, 1, 0)
                SecTitle.BackgroundTransparency = 1
                SecTitle.Text = secName
                SecTitle.TextColor3 = Theme.Text
                SecTitle.FontFace = Fonts.Regular
                SecTitle.TextSize = 12
                SecTitle.TextXAlignment = Enum.TextXAlignment.Left
                SecTitle.Parent = SecHeader
                
                local Elements = Instance.new("Frame")
                Elements.Name = "Elements"
                Elements.Position = UDim2.new(0, 0, 0, 30)
                Elements.Size = UDim2.new(1, 0, 0, 0)
                Elements.AutomaticSize = Enum.AutomaticSize.Y
                Elements.BackgroundTransparency = 1
                Elements.Parent = SecFrame
                
                local ELayout = Instance.new("UIListLayout")
                ELayout.Padding = UDim.new(0, 2)
                ELayout.Parent = Elements
                
                local EPad = Instance.new("UIPadding")
                EPad.PaddingTop = UDim.new(0, 6)
                EPad.PaddingBottom = UDim.new(0, 12)
                EPad.Parent = Elements
                
                function Section:CreateToggle(cfg)
                    cfg = cfg or {}
                    local tName = cfg.Name or "Toggle"
                    local default = cfg.Default or false
                    local callback = cfg.Callback or function() end
                    local state = default
                    
                    local TFrame = Instance.new("TextButton")
                    TFrame.Size = UDim2.new(1, 0, 0, 28)
                    TFrame.BackgroundTransparency = 1
                    TFrame.Text = ""
                    TFrame.Parent = Elements
                    
                    local TBox = Instance.new("Frame")
                    TBox.Position = UDim2.new(0, 12, 0, 7)
                    TBox.Size = UDim2.new(0, 14, 0, 14)
                    TBox.BackgroundColor3 = state and Theme.Text or Theme.Tertiary
                    TBox.Parent = TFrame
                    Corner(TBox, 3)
                    if not state then Stroke(TBox) end
                    if state then Gradient(TBox) end
                    
                    local Check = Instance.new("ImageLabel")
                    Check.AnchorPoint = Vector2.new(0.5, 0.5)
                    Check.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Check.Size = UDim2.new(0, 8, 0, 8)
                    Check.BackgroundTransparency = 1
                    Check.Image = "rbxassetid://83899464799881"
                    Check.ImageTransparency = state and 0 or 1
                    Check.Parent = TBox
                    
                    local TLabel = Instance.new("TextLabel")
                    TLabel.Position = UDim2.new(0, 34, 0, 0)
                    TLabel.Size = UDim2.new(1, -40, 1, 0)
                    TLabel.BackgroundTransparency = 1
                    TLabel.Text = tName
                    TLabel.TextColor3 = state and Theme.Text or Theme.TextDark
                    TLabel.FontFace = Fonts.Regular
                    TLabel.TextSize = 12
                    TLabel.TextXAlignment = Enum.TextXAlignment.Left
                    TLabel.Parent = TFrame
                    
                    TFrame.MouseButton1Click:Connect(function()
                        state = not state
                        if state then
                            Tween(TBox, {BackgroundColor3 = Theme.Text}, 0.15)
                            Tween(Check, {ImageTransparency = 0}, 0.15)
                            Tween(TLabel, {TextColor3 = Theme.Text}, 0.15)
                            local s = TBox:FindFirstChildOfClass("UIStroke") if s then s:Destroy() end
                            if not TBox:FindFirstChildOfClass("UIGradient") then Gradient(TBox) end
                        else
                            Tween(TBox, {BackgroundColor3 = Theme.Tertiary}, 0.15)
                            Tween(Check, {ImageTransparency = 1}, 0.15)
                            Tween(TLabel, {TextColor3 = Theme.TextDark}, 0.15)
                            local g = TBox:FindFirstChildOfClass("UIGradient") if g then g:Destroy() end
                            if not TBox:FindFirstChildOfClass("UIStroke") then Stroke(TBox) end
                        end
                        callback(state)
                    end)
                    
                    if default then callback(true) end
                    return {Set = function(_, v) if v ~= state then TFrame.MouseButton1Click:Fire() end end, Get = function() return state end}
                end
                
                function Section:CreateButton(cfg)
                    cfg = cfg or {}
                    local bName = cfg.Name or "Button"
                    local callback = cfg.Callback or function() end
                    
                    local BFrame = Instance.new("Frame")
                    BFrame.Size = UDim2.new(1, 0, 0, 36)
                    BFrame.BackgroundTransparency = 1
                    BFrame.Parent = Elements
                    
                    local Btn = Instance.new("TextButton")
                    Btn.AnchorPoint = Vector2.new(0.5, 0.5)
                    Btn.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Btn.Size = UDim2.new(1, -24, 0, 28)
                    Btn.BackgroundColor3 = Theme.Tertiary
                    Btn.Text = bName
                    Btn.TextColor3 = Theme.TextDark
                    Btn.FontFace = Fonts.Medium
                    Btn.TextSize = 12
                    Btn.Parent = BFrame
                    Corner(Btn, 4)
                    Stroke(Btn)
                    
                    Btn.MouseButton1Click:Connect(function()
                        Tween(Btn, {BackgroundColor3 = Theme.Accent}, 0.08)
                        Tween(Btn, {TextColor3 = Theme.Text}, 0.08)
                        task.wait(0.12)
                        Tween(Btn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
                        Tween(Btn, {TextColor3 = Theme.TextDark}, 0.15)
                        callback()
                    end)
                    
                    Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Color3.fromRGB(32, 34, 44)}, 0.1) end)
                    Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.Tertiary}, 0.1) end)
                end
                
                function Section:CreateSlider(cfg)
                    cfg = cfg or {}
                    local sName = cfg.Name or "Slider"
                    local min, max = cfg.Min or 0, cfg.Max or 100
                    local default = cfg.Default or min
                    local callback = cfg.Callback or function() end
                    local value = default
                    
                    local SFrame = Instance.new("Frame")
                    SFrame.Size = UDim2.new(1, 0, 0, 40)
                    SFrame.BackgroundTransparency = 1
                    SFrame.Parent = Elements
                    
                    local SLabel = Instance.new("TextLabel")
                    SLabel.Position = UDim2.new(0, 12, 0, 4)
                    SLabel.Size = UDim2.new(0.6, 0, 0, 16)
                    SLabel.BackgroundTransparency = 1
                    SLabel.Text = sName
                    SLabel.TextColor3 = Theme.TextDark
                    SLabel.FontFace = Fonts.Regular
                    SLabel.TextSize = 12
                    SLabel.TextXAlignment = Enum.TextXAlignment.Left
                    SLabel.Parent = SFrame
                    
                    local VLabel = Instance.new("TextLabel")
                    VLabel.Position = UDim2.new(0.6, 0, 0, 4)
                    VLabel.Size = UDim2.new(0.4, -12, 0, 16)
                    VLabel.BackgroundTransparency = 1
                    VLabel.Text = tostring(value)
                    VLabel.TextColor3 = Theme.Text
                    VLabel.FontFace = Fonts.Regular
                    VLabel.TextSize = 12
                    VLabel.TextXAlignment = Enum.TextXAlignment.Right
                    VLabel.Parent = SFrame
                    
                    local SBG = Instance.new("Frame")
                    SBG.Position = UDim2.new(0, 12, 0, 26)
                    SBG.Size = UDim2.new(1, -24, 0, 6)
                    SBG.BackgroundColor3 = Theme.Tertiary
                    SBG.Parent = SFrame
                    Corner(SBG, 3)
                    
                    local SFill = Instance.new("Frame")
                    SFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    SFill.BackgroundColor3 = Theme.Text
                    SFill.Parent = SBG
                    Corner(SFill, 3)
                    Gradient(SFill)
                    
                    local dragging = false
                    
                    SBG.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            local p = math.clamp((i.Position.X - SBG.AbsolutePosition.X) / SBG.AbsoluteSize.X, 0, 1)
                            value = math.floor(min + (max - min) * p)
                            VLabel.Text = tostring(value)
                            Tween(SFill, {Size = UDim2.new(p, 0, 1, 0)}, 0.05)
                            callback(value)
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(i)
                        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                            local p = math.clamp((i.Position.X - SBG.AbsolutePosition.X) / SBG.AbsoluteSize.X, 0, 1)
                            value = math.floor(min + (max - min) * p)
                            VLabel.Text = tostring(value)
                            SFill.Size = UDim2.new(p, 0, 1, 0)
                            callback(value)
                        end
                    end)
                    
                    UserInputService.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                    end)
                    
                    callback(default)
                    return {Set = function(_, v) value = math.clamp(v, min, max) VLabel.Text = tostring(value) SFill.Size = UDim2.new((value-min)/(max-min), 0, 1, 0) callback(value) end, Get = function() return value end}
                end
                
                return Section
            end
            
            if isFirstSP and isFirst then SubPage:BuildButton(true) end
            
            return SubPage
        end
        
        return Tab
    end
    
    return Window
end

return Centrixity
