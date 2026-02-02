local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Enabled = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.StarterGui

local MainFrame = Instance.new("Frame")
MainFrame.ClipsDescendants = true
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Name = "MainFrame"
MainFrame.Position = UDim2.new(0.49953705072402954, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 689, 0, 489)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundColor3 = Color3.fromRGB(19, 20, 25)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 11)
UICorner.Parent = MainFrame

local Header = Instance.new("Frame")
Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
Header.AnchorPoint = Vector2.new(0.5, 0)
Header.BackgroundTransparency = 1
Header.Position = UDim2.new(0.5, 0, 0, 0)
Header.Name = "Header"
Header.Size = UDim2.new(0, 695, 0, 37)
Header.BorderSizePixel = 0
Header.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Header.Parent = MainFrame

local Liner = Instance.new("Frame")
Liner.AnchorPoint = Vector2.new(0, 1)
Liner.Name = "Liner"
Liner.Position = UDim2.new(0, 0, 1, 0)
Liner.BorderColor3 = Color3.fromRGB(0, 0, 0)
Liner.Size = UDim2.new(1, 1, 0, 2)
Liner.BorderSizePixel = 0
Liner.BackgroundColor3 = Color3.fromRGB(31, 31, 45)
Liner.Parent = Header

local LibaryIcon = Instance.new("ImageLabel")
LibaryIcon.ScaleType = Enum.ScaleType.Fit
LibaryIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
LibaryIcon.Name = "LibaryIcon"
LibaryIcon.AnchorPoint = Vector2.new(0, 0.5)
LibaryIcon.Image = "rbxassetid://137946959393180"
LibaryIcon.BackgroundTransparency = 1
LibaryIcon.Position = UDim2.new(0, 12, 0.4425675570964813, 0)
LibaryIcon.ImageContent = Content
LibaryIcon.Size = UDim2.new(0, 34, 0, 34)
LibaryIcon.BorderSizePixel = 0
LibaryIcon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
LibaryIcon.Parent = Header

local Libary_Name = Instance.new("TextLabel")
Libary_Name.RichText = true
Libary_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
Libary_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Libary_Name.Text = "Centrixity <font color="#45475a">aaaaaaaaaaaaaaaaaaa</font>"
Libary_Name.Name = "Libary_Name"
Libary_Name.Size = UDim2.new(0, 1, 0, 1)
Libary_Name.AnchorPoint = Vector2.new(0, 0.5)
Libary_Name.BorderSizePixel = 0
Libary_Name.BackgroundTransparency = 1
Libary_Name.Position = UDim2.new(0.05882352963089943, 32, 0.5, 0)
Libary_Name.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Libary_Name.AutomaticSize = Enum.AutomaticSize.XY
Libary_Name.TextSize = 14
Libary_Name.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Libary_Name.Parent = LibaryIcon

local Last_Updated = Instance.new("TextLabel")
Last_Updated.RichText = true
Last_Updated.TextColor3 = Color3.fromRGB(255, 255, 255)
Last_Updated.BorderColor3 = Color3.fromRGB(0, 0, 0)
Last_Updated.Text = "Updated Last <font color="#45475a">3/10/2021</font> <font color="#ffffff">October</font>"
Last_Updated.Name = "Last_Updated"
Last_Updated.Size = UDim2.new(0, 1, 0, 1)
Last_Updated.AnchorPoint = Vector2.new(1, 0.5)
Last_Updated.BorderSizePixel = 0
Last_Updated.BackgroundTransparency = 1
Last_Updated.Position = UDim2.new(1, -12, 0.5, 0)
Last_Updated.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Last_Updated.AutomaticSize = Enum.AutomaticSize.XY
Last_Updated.TextSize = 12
Last_Updated.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Last_Updated.Parent = Header

local Icon = Instance.new("ImageLabel")
Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon.Name = "Icon"
Icon.AnchorPoint = Vector2.new(0, 0.5)
Icon.Image = "rbxassetid://84304363968016"
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0, -22, 0.5, 0)
Icon.ImageContent = Content
Icon.Size = UDim2.new(0, 15, 0, 15)
Icon.BorderSizePixel = 0
Icon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Icon.Parent = Last_Updated

local Sidebar = Instance.new("Frame")
Sidebar.BorderColor3 = Color3.fromRGB(0, 0, 0)
Sidebar.AnchorPoint = Vector2.new(0, 1)
Sidebar.BackgroundTransparency = 1
Sidebar.Position = UDim2.new(0, 0, 1, 0)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 75, 0, 453)
Sidebar.BorderSizePixel = 0
Sidebar.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Sidebar.Parent = MainFrame

local Liner = Instance.new("Frame")
Liner.AnchorPoint = Vector2.new(1, 0.5)
Liner.Name = "Liner"
Liner.Position = UDim2.new(1, 0, 0.5, 0)
Liner.BorderColor3 = Color3.fromRGB(0, 0, 0)
Liner.Size = UDim2.new(0, 2, 1, 0)
Liner.BorderSizePixel = 0
Liner.BackgroundColor3 = Color3.fromRGB(31, 31, 45)
Liner.Parent = Sidebar

local Holder = Instance.new("Frame")
Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Holder.AnchorPoint = Vector2.new(0.5, 0.5)
Holder.BackgroundTransparency = 1
Holder.Position = UDim2.new(0.5, 0, 0.5, 0)
Holder.Name = "Holder"
Holder.Size = UDim2.new(0, 75, 0, 453)
Holder.BorderSizePixel = 0
Holder.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Holder.Parent = Sidebar

local Tab = Instance.new("Frame")
Tab.Name = "Tab"
Tab.BackgroundTransparency = 0.8999999761581421
Tab.ClipsDescendants = true
Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
Tab.Size = UDim2.new(0, 55, 0, 60)
Tab.BorderSizePixel = 0
Tab.BackgroundColor3 = Color3.fromRGB(247, 247, 247)
Tab.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Tab

local Frame = Instance.new("Frame")
Frame.AnchorPoint = Vector2.new(0.5, 1)
Frame.Position = UDim2.new(0.5, 0, 1, 3)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.Size = UDim2.new(0, 25, 0, 6)
Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.fromRGB(254, 254, 254)
Frame.Parent = Tab

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Frame

local Icon = Instance.new("ImageLabel")
Icon.ImageColor3 = Color3.fromRGB(255, 127, 0)
Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon.Name = "Icon"
Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Icon.Image = "rbxassetid://80869096876893"
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0.5, 0, 0.5, -8)
Icon.ImageContent = Content
Icon.Size = UDim2.new(0, 24, 0, 22)
Icon.BorderSizePixel = 0
Icon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Icon.Parent = Tab

local TextLabel = Instance.new("TextLabel")
TextLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.Text = "Main"
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Size = UDim2.new(1, 1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 20)
TextLabel.BorderSizePixel = 0
TextLabel.AutomaticSize = Enum.AutomaticSize.XY
TextLabel.TextSize = 12
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
TextLabel.Parent = Icon

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Tab

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Holder

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 9)
UIPadding.Parent = Holder

local Divider = Instance.new("Frame")
Divider.ClipsDescendants = true
Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
Divider.BackgroundTransparency = 1
Divider.Position = UDim2.new(0, 0, 0.9887133240699768, 0)
Divider.Name = "Divider"
Divider.Size = UDim2.new(0, 55, 0, 5)
Divider.BorderSizePixel = 0
Divider.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Divider.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Divider

local Tab = Instance.new("Frame")
Tab.Name = "Tab"
Tab.BackgroundTransparency = 1
Tab.ClipsDescendants = true
Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
Tab.Size = UDim2.new(0, 55, 0, 60)
Tab.BorderSizePixel = 0
Tab.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Tab.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Tab

local Icon = Instance.new("ImageLabel")
Icon.ImageColor3 = Color3.fromRGB(69, 71, 90)
Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon.Name = "Icon"
Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Icon.Image = "rbxassetid://88848642017283"
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0.5, 0, 0.5, -8)
Icon.ImageContent = Content
Icon.Size = UDim2.new(0, 24, 0, 22)
Icon.BorderSizePixel = 0
Icon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Icon.Parent = Tab

local TextLabel = Instance.new("TextLabel")
TextLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel.TextColor3 = Color3.fromRGB(69, 71, 90)
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.Text = "Visuals"
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Size = UDim2.new(1, 1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 20)
TextLabel.BorderSizePixel = 0
TextLabel.AutomaticSize = Enum.AutomaticSize.XY
TextLabel.TextSize = 12
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
TextLabel.Parent = Icon

local Divider = Instance.new("Frame")
Divider.ClipsDescendants = true
Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
Divider.BackgroundTransparency = 1
Divider.Position = UDim2.new(0, 0, 0.9887133240699768, 0)
Divider.Name = "Divider"
Divider.Size = UDim2.new(0, 55, 0, 5)
Divider.BorderSizePixel = 0
Divider.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Divider.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Divider

local Frame = Instance.new("Frame")
Frame.AnchorPoint = Vector2.new(0.5, 1)
Frame.Position = UDim2.new(0.5, 0, 1, 3)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.Size = UDim2.new(0, 25, 0, 6)
Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.fromRGB(31, 31, 45)
Frame.Parent = Divider

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Tab = Instance.new("Frame")
Tab.Name = "Tab"
Tab.BackgroundTransparency = 1
Tab.ClipsDescendants = true
Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
Tab.Size = UDim2.new(0, 55, 0, 60)
Tab.BorderSizePixel = 0
Tab.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Tab.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Tab

local Icon = Instance.new("ImageLabel")
Icon.ImageColor3 = Color3.fromRGB(69, 71, 90)
Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon.Name = "Icon"
Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Icon.Image = "rbxassetid://83371760923777"
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0.5, 0, 0.5, -8)
Icon.ImageContent = Content
Icon.Size = UDim2.new(0, 24, 0, 22)
Icon.BorderSizePixel = 0
Icon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Icon.Parent = Tab

local TextLabel = Instance.new("TextLabel")
TextLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel.TextColor3 = Color3.fromRGB(69, 71, 90)
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.Text = "Rage"
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Size = UDim2.new(1, 1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 20)
TextLabel.BorderSizePixel = 0
TextLabel.AutomaticSize = Enum.AutomaticSize.XY
TextLabel.TextSize = 12
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
TextLabel.Parent = Icon

local Divider = Instance.new("Frame")
Divider.ClipsDescendants = true
Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
Divider.BackgroundTransparency = 1
Divider.Position = UDim2.new(0, 0, 0.9887133240699768, 0)
Divider.Name = "Divider"
Divider.Size = UDim2.new(0, 55, 0, 5)
Divider.BorderSizePixel = 0
Divider.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Divider.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Divider

local Frame = Instance.new("Frame")
Frame.AnchorPoint = Vector2.new(0.5, 1)
Frame.Position = UDim2.new(0.5, 0, 1, 3)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.Size = UDim2.new(0, 25, 0, 6)
Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.fromRGB(31, 31, 45)
Frame.Parent = Divider

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Tab = Instance.new("Frame")
Tab.Name = "Tab"
Tab.BackgroundTransparency = 1
Tab.ClipsDescendants = true
Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
Tab.Size = UDim2.new(0, 55, 0, 60)
Tab.BorderSizePixel = 0
Tab.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Tab.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Tab

local Icon = Instance.new("ImageLabel")
Icon.ImageColor3 = Color3.fromRGB(69, 71, 90)
Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon.Name = "Icon"
Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Icon.Image = "rbxassetid://107815780127396"
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0.5, 0, 0.5, -8)
Icon.ImageContent = Content
Icon.Size = UDim2.new(0, 24, 0, 22)
Icon.BorderSizePixel = 0
Icon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Icon.Parent = Tab

local TextLabel = Instance.new("TextLabel")
TextLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel.TextColor3 = Color3.fromRGB(69, 71, 90)
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.Text = "World"
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Size = UDim2.new(1, 1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 20)
TextLabel.BorderSizePixel = 0
TextLabel.AutomaticSize = Enum.AutomaticSize.XY
TextLabel.TextSize = 12
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
TextLabel.Parent = Icon

local Divider = Instance.new("Frame")
Divider.ClipsDescendants = true
Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
Divider.BackgroundTransparency = 1
Divider.Position = UDim2.new(0, 0, 0.9887133240699768, 0)
Divider.Name = "Divider"
Divider.Size = UDim2.new(0, 55, 0, 5)
Divider.BorderSizePixel = 0
Divider.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Divider.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Divider

local Frame = Instance.new("Frame")
Frame.AnchorPoint = Vector2.new(0.5, 1)
Frame.Position = UDim2.new(0.5, 0, 1, 3)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.Size = UDim2.new(0, 25, 0, 6)
Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.fromRGB(31, 31, 45)
Frame.Parent = Divider

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Tab = Instance.new("Frame")
Tab.Name = "Tab"
Tab.BackgroundTransparency = 1
Tab.ClipsDescendants = true
Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
Tab.Size = UDim2.new(0, 55, 0, 60)
Tab.BorderSizePixel = 0
Tab.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Tab.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Tab

local Icon = Instance.new("ImageLabel")
Icon.ImageColor3 = Color3.fromRGB(69, 71, 90)
Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon.Name = "Icon"
Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Icon.Image = "rbxassetid://93827853548653"
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0.5, 0, 0.5, -8)
Icon.ImageContent = Content
Icon.Size = UDim2.new(0, 24, 0, 22)
Icon.BorderSizePixel = 0
Icon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Icon.Parent = Tab

local TextLabel = Instance.new("TextLabel")
TextLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel.TextColor3 = Color3.fromRGB(69, 71, 90)
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.Text = "Exploits"
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Size = UDim2.new(1, 1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 20)
TextLabel.BorderSizePixel = 0
TextLabel.AutomaticSize = Enum.AutomaticSize.XY
TextLabel.TextSize = 12
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
TextLabel.Parent = Icon

local Divider = Instance.new("Frame")
Divider.ClipsDescendants = true
Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
Divider.BackgroundTransparency = 1
Divider.Position = UDim2.new(0, 0, 0.9887133240699768, 0)
Divider.Name = "Divider"
Divider.Size = UDim2.new(0, 55, 0, 5)
Divider.BorderSizePixel = 0
Divider.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Divider.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Divider

local Frame = Instance.new("Frame")
Frame.AnchorPoint = Vector2.new(0.5, 1)
Frame.Position = UDim2.new(0.5, 0, 1, 3)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.Size = UDim2.new(0, 25, 0, 6)
Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.fromRGB(31, 31, 45)
Frame.Parent = Divider

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Tab = Instance.new("Frame")
Tab.Name = "Tab"
Tab.BackgroundTransparency = 1
Tab.ClipsDescendants = true
Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
Tab.Size = UDim2.new(0, 55, 0, 60)
Tab.BorderSizePixel = 0
Tab.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Tab.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Tab

local Icon = Instance.new("ImageLabel")
Icon.ImageColor3 = Color3.fromRGB(69, 71, 90)
Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon.Name = "Icon"
Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Icon.Image = "rbxassetid://128822529527725"
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0.5, 0, 0.5, -8)
Icon.ImageContent = Content
Icon.Size = UDim2.new(0, 24, 0, 22)
Icon.BorderSizePixel = 0
Icon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Icon.Parent = Tab

local TextLabel = Instance.new("TextLabel")
TextLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel.TextColor3 = Color3.fromRGB(69, 71, 90)
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.Text = "Settings"
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Size = UDim2.new(1, 1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 20)
TextLabel.BorderSizePixel = 0
TextLabel.AutomaticSize = Enum.AutomaticSize.XY
TextLabel.TextSize = 12
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
TextLabel.Parent = Icon

local Sub-Header = Instance.new("Frame")
Sub-Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
Sub-Header.AnchorPoint = Vector2.new(0.5, 0.5)
Sub-Header.BackgroundTransparency = 1
Sub-Header.Position = UDim2.new(0.5546762347221375, 0, 0.12781186401844025, 0)
Sub-Header.Name = "Sub-Header"
Sub-Header.Size = UDim2.new(0, 621, 0, 51)
Sub-Header.BorderSizePixel = 0
Sub-Header.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Sub-Header.Parent = MainFrame

local SubTab = Instance.new("Frame")
SubTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
SubTab.Name = "SubTab"
SubTab.BackgroundTransparency = 1
SubTab.Position = UDim2.new(0, 0, 0.03921568766236305, 0)
SubTab.Size = UDim2.new(0, 80, 0, 49)
SubTab.BorderSizePixel = 0
SubTab.AutomaticSize = Enum.AutomaticSize.X
SubTab.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
SubTab.Parent = Sub-Header

local TabName = Instance.new("TextLabel")
TabName.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TabName.TextColor3 = Color3.fromRGB(254, 254, 254)
TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabName.Text = "ActiveSubTab1"
TabName.Name = "TabName"
TabName.AnchorPoint = Vector2.new(0.5, 0.5)
TabName.Size = UDim2.new(0, 1, 0, 1)
TabName.BackgroundTransparency = 0.800000011920929
TabName.Position = UDim2.new(0.5, 0, 0.5, -3)
TabName.BorderSizePixel = 0
TabName.AutomaticSize = Enum.AutomaticSize.XY
TabName.TextSize = 13
TabName.BackgroundColor3 = Color3.fromRGB(254, 254, 254)
TabName.Parent = SubTab

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.Parent = TabName

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = TabName

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = TabName

local Holder = Instance.new("Frame")
Holder.AnchorPoint = Vector2.new(0.5, 1)
Holder.Name = "Holder"
Holder.Position = UDim2.new(0.5, 0, 1, 2)
Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Holder.Size = UDim2.new(0, 34, 0, 6)
Holder.BorderSizePixel = 0
Holder.BackgroundColor3 = Color3.fromRGB(254, 254, 254)
Holder.Parent = SubTab

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Holder

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Holder

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Parent = Sub-Header

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 4)
UIPadding.PaddingLeft = UDim.new(0, 25)
UIPadding.Parent = Sub-Header

local SubTab = Instance.new("Frame")
SubTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
SubTab.Name = "SubTab"
SubTab.BackgroundTransparency = 1
SubTab.Position = UDim2.new(0, 0, 0.03921568766236305, 0)
SubTab.Size = UDim2.new(0, 80, 0, 49)
SubTab.BorderSizePixel = 0
SubTab.AutomaticSize = Enum.AutomaticSize.X
SubTab.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
SubTab.Parent = Sub-Header

local TabName = Instance.new("TextLabel")
TabName.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TabName.TextColor3 = Color3.fromRGB(69, 71, 90)
TabName.TextTransparency = 0.15000000596046448
TabName.Text = "SubTab2"
TabName.Name = "TabName"
TabName.Size = UDim2.new(0, 1, 0, 1)
TabName.AnchorPoint = Vector2.new(0.5, 0.5)
TabName.BorderSizePixel = 0
TabName.BackgroundTransparency = 1
TabName.Position = UDim2.new(0.5, 0, 0.5, -3)
TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabName.AutomaticSize = Enum.AutomaticSize.XY
TabName.TextSize = 13
TabName.BackgroundColor3 = Color3.fromRGB(69, 71, 90)
TabName.Parent = SubTab

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = TabName

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.Parent = TabName

local SubTab = Instance.new("Frame")
SubTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
SubTab.Name = "SubTab"
SubTab.BackgroundTransparency = 1
SubTab.Position = UDim2.new(0, 0, 0.03921568766236305, 0)
SubTab.Size = UDim2.new(0, 80, 0, 49)
SubTab.BorderSizePixel = 0
SubTab.AutomaticSize = Enum.AutomaticSize.X
SubTab.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
SubTab.Parent = Sub-Header

local TabName = Instance.new("TextLabel")
TabName.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TabName.TextColor3 = Color3.fromRGB(69, 71, 90)
TabName.TextTransparency = 0.15000000596046448
TabName.Text = "SubTab2"
TabName.Name = "TabName"
TabName.Size = UDim2.new(0, 1, 0, 1)
TabName.AnchorPoint = Vector2.new(0.5, 0.5)
TabName.BorderSizePixel = 0
TabName.BackgroundTransparency = 1
TabName.Position = UDim2.new(0.5, 0, 0.5, -3)
TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabName.AutomaticSize = Enum.AutomaticSize.XY
TabName.TextSize = 13
TabName.BackgroundColor3 = Color3.fromRGB(69, 71, 90)
TabName.Parent = SubTab

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = TabName

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.Parent = TabName

local SubTab = Instance.new("Frame")
SubTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
SubTab.Name = "SubTab"
SubTab.BackgroundTransparency = 1
SubTab.Position = UDim2.new(0, 0, 0.03921568766236305, 0)
SubTab.Size = UDim2.new(0, 80, 0, 49)
SubTab.BorderSizePixel = 0
SubTab.AutomaticSize = Enum.AutomaticSize.X
SubTab.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
SubTab.Parent = Sub-Header

local TabName = Instance.new("TextLabel")
TabName.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TabName.TextColor3 = Color3.fromRGB(69, 71, 90)
TabName.TextTransparency = 0.15000000596046448
TabName.Text = "SubTab2"
TabName.Name = "TabName"
TabName.Size = UDim2.new(0, 1, 0, 1)
TabName.AnchorPoint = Vector2.new(0.5, 0.5)
TabName.BorderSizePixel = 0
TabName.BackgroundTransparency = 1
TabName.Position = UDim2.new(0.5, 0, 0.5, -3)
TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabName.AutomaticSize = Enum.AutomaticSize.XY
TabName.TextSize = 13
TabName.BackgroundColor3 = Color3.fromRGB(69, 71, 90)
TabName.Parent = SubTab

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = TabName

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.Parent = TabName

local SubTab = Instance.new("Frame")
SubTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
SubTab.Name = "SubTab"
SubTab.BackgroundTransparency = 1
SubTab.Position = UDim2.new(0, 0, 0.03921568766236305, 0)
SubTab.Size = UDim2.new(0, 80, 0, 49)
SubTab.BorderSizePixel = 0
SubTab.AutomaticSize = Enum.AutomaticSize.X
SubTab.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
SubTab.Parent = Sub-Header

local TabName = Instance.new("TextLabel")
TabName.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TabName.TextColor3 = Color3.fromRGB(69, 71, 90)
TabName.TextTransparency = 0.15000000596046448
TabName.Text = "SubTab2"
TabName.Name = "TabName"
TabName.Size = UDim2.new(0, 1, 0, 1)
TabName.AnchorPoint = Vector2.new(0.5, 0.5)
TabName.BorderSizePixel = 0
TabName.BackgroundTransparency = 1
TabName.Position = UDim2.new(0.5, 0, 0.5, -3)
TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabName.AutomaticSize = Enum.AutomaticSize.XY
TabName.TextSize = 13
TabName.BackgroundColor3 = Color3.fromRGB(69, 71, 90)
TabName.Parent = SubTab

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = TabName

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.Parent = TabName

local SubTab = Instance.new("Frame")
SubTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
SubTab.Name = "SubTab"
SubTab.BackgroundTransparency = 1
SubTab.Position = UDim2.new(0, 0, 0.03921568766236305, 0)
SubTab.Size = UDim2.new(0, 80, 0, 49)
SubTab.BorderSizePixel = 0
SubTab.AutomaticSize = Enum.AutomaticSize.X
SubTab.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
SubTab.Parent = Sub-Header

local TabName = Instance.new("TextLabel")
TabName.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TabName.TextColor3 = Color3.fromRGB(69, 71, 90)
TabName.TextTransparency = 0.15000000596046448
TabName.Text = "SubTab2"
TabName.Name = "TabName"
TabName.Size = UDim2.new(0, 1, 0, 1)
TabName.AnchorPoint = Vector2.new(0.5, 0.5)
TabName.BorderSizePixel = 0
TabName.BackgroundTransparency = 1
TabName.Position = UDim2.new(0.5, 0, 0.5, -3)
TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabName.AutomaticSize = Enum.AutomaticSize.XY
TabName.TextSize = 13
TabName.BackgroundColor3 = Color3.fromRGB(69, 71, 90)
TabName.Parent = SubTab

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = TabName

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.Parent = TabName

local Page = Instance.new("Frame")
Page.ClipsDescendants = true
Page.BorderColor3 = Color3.fromRGB(0, 0, 0)
Page.AnchorPoint = Vector2.new(1, 1)
Page.Name = "Page"
Page.Position = UDim2.new(1, 0, 1, 0)
Page.Size = UDim2.new(0, 620, 0, 401)
Page.BorderSizePixel = 0
Page.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
Page.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 11)
UICorner.Parent = Page

local Container = Instance.new("ScrollingFrame")
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
Container.Active = true
Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
Container.ScrollBarThickness = 1
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0.5, 0, 0.5, 0)
Container.Name = "Container"
Container.Size = UDim2.new(0, 620, 0, 401)
Container.BorderSizePixel = 0
Container.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
Container.Parent = Page

local Section_Left = Instance.new("Frame")
Section_Left.Size = UDim2.new(0, 281, 0, 60)
Section_Left.Name = "Section_Left"
Section_Left.ClipsDescendants = true
Section_Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
Section_Left.BorderSizePixel = 0
Section_Left.AutomaticSize = Enum.AutomaticSize.Y
Section_Left.BackgroundColor3 = Color3.fromRGB(17, 18, 22)
Section_Left.Parent = Container

local Header = Instance.new("Frame")
Header.AnchorPoint = Vector2.new(0.5, 0)
Header.Name = "Header"
Header.Position = UDim2.new(0.5017856955528259, 0, 0, 0)
Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
Header.Size = UDim2.new(0, 281, 0, 30)
Header.BorderSizePixel = 0
Header.BackgroundColor3 = Color3.fromRGB(19, 20, 25)
Header.Parent = Section_Left

local Holder = Instance.new("Frame")
Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Holder.AnchorPoint = Vector2.new(0.5, 0)
Holder.Name = "Holder"
Holder.BackgroundTransparency = 1
Holder.Position = UDim2.new(0.5, 0, 1, 0)
Holder.Size = UDim2.new(0, 1, 0, 1)
Holder.BorderSizePixel = 0
Holder.AutomaticSize = Enum.AutomaticSize.XY
Holder.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
Holder.Parent = Header

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Holder

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingBottom = UDim.new(0, 45)
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.Parent = Holder

local Toggle_Component = Instance.new("Frame")
Toggle_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Component.AnchorPoint = Vector2.new(0.5, 0)
Toggle_Component.BackgroundTransparency = 1
Toggle_Component.Position = UDim2.new(0.5, 0, 0, 0)
Toggle_Component.Name = "Toggle_Component"
Toggle_Component.Size = UDim2.new(0, 312, 0, 30)
Toggle_Component.BorderSizePixel = 0
Toggle_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Toggle_Component.Parent = Holder

local Toggle_Name = Instance.new("TextLabel")
Toggle_Name.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Toggle_Name.TextColor3 = Color3.fromRGB(69, 71, 90)
Toggle_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Name.Text = "Example Toggle"
Toggle_Name.Name = "Toggle_Name"
Toggle_Name.AnchorPoint = Vector2.new(0, 0.5)
Toggle_Name.Size = UDim2.new(0, 1, 0, 1)
Toggle_Name.BackgroundTransparency = 1
Toggle_Name.Position = UDim2.new(0, 48, 0.5, 0)
Toggle_Name.BorderSizePixel = 0
Toggle_Name.AutomaticSize = Enum.AutomaticSize.XY
Toggle_Name.TextSize = 12
Toggle_Name.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Toggle_Name.Parent = Toggle_Component

local Toggle = Instance.new("Frame")
Toggle.AnchorPoint = Vector2.new(0, 0.5)
Toggle.Name = "Toggle"
Toggle.Position = UDim2.new(0, 25, 0.5, 0)
Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle.Size = UDim2.new(0, 14, 0, 14)
Toggle.BorderSizePixel = 0
Toggle.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Toggle.Parent = Toggle_Component

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(28, 30, 38)
UIStroke.Parent = Toggle

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Toggle

local Toggle_Component = Instance.new("Frame")
Toggle_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Component.AnchorPoint = Vector2.new(0.5, 0)
Toggle_Component.BackgroundTransparency = 1
Toggle_Component.Position = UDim2.new(0.5, 0, 0, 0)
Toggle_Component.Name = "Toggle_Component"
Toggle_Component.Size = UDim2.new(0, 312, 0, 30)
Toggle_Component.BorderSizePixel = 0
Toggle_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Toggle_Component.Parent = Holder

local Toggle_Name = Instance.new("TextLabel")
Toggle_Name.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Toggle_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Name.Text = "Example Toggle"
Toggle_Name.Name = "Toggle_Name"
Toggle_Name.AnchorPoint = Vector2.new(0, 0.5)
Toggle_Name.Size = UDim2.new(0, 1, 0, 1)
Toggle_Name.BackgroundTransparency = 1
Toggle_Name.Position = UDim2.new(0, 48, 0.5, 0)
Toggle_Name.BorderSizePixel = 0
Toggle_Name.AutomaticSize = Enum.AutomaticSize.XY
Toggle_Name.TextSize = 12
Toggle_Name.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Toggle_Name.Parent = Toggle_Component

local Toggle = Instance.new("Frame")
Toggle.AnchorPoint = Vector2.new(0, 0.5)
Toggle.Name = "Toggle"
Toggle.Position = UDim2.new(0, 25, 0.5, 0)
Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle.Size = UDim2.new(0, 14, 0, 14)
Toggle.BorderSizePixel = 0
Toggle.BackgroundColor3 = Color3.fromRGB(231, 231, 231)
Toggle.Parent = Toggle_Component

local Check_Icon = Instance.new("ImageLabel")
Check_Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Check_Icon.Name = "Check_Icon"
Check_Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Check_Icon.Image = "rbxassetid://83899464799881"
Check_Icon.BackgroundTransparency = 1
Check_Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
Check_Icon.ImageContent = Content
Check_Icon.Size = UDim2.new(0, 8, 0, 7)
Check_Icon.BorderSizePixel = 0
Check_Icon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Check_Icon.Parent = Toggle

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Toggle

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Toggle

local ColorFrame = Instance.new("Frame")
ColorFrame.AnchorPoint = Vector2.new(1, 0.5)
ColorFrame.Name = "ColorFrame"
ColorFrame.Position = UDim2.new(0.9150000214576721, 0, 0.5, 0)
ColorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ColorFrame.Size = UDim2.new(0, 15, 0, 15)
ColorFrame.BorderSizePixel = 0
ColorFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ColorFrame.Parent = Toggle_Component

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ColorFrame

local Slider_Component = Instance.new("Frame")
Slider_Component.Active = true
Slider_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Slider_Component.AnchorPoint = Vector2.new(0.5, 0)
Slider_Component.BackgroundTransparency = 1
Slider_Component.Position = UDim2.new(0.5, 0, 0.7621951103210449, 0)
Slider_Component.Name = "Slider_Component"
Slider_Component.Size = UDim2.new(0, 312, 0, 40)
Slider_Component.BorderSizePixel = 0
Slider_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Slider_Component.Parent = Holder

local Value = Instance.new("TextLabel")
Value.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Value.TextColor3 = Color3.fromRGB(255, 255, 255)
Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
Value.Text = "100"
Value.Name = "Value"
Value.AnchorPoint = Vector2.new(1, 0.5)
Value.Size = UDim2.new(0, 1, 0, 1)
Value.BackgroundTransparency = 1
Value.Position = UDim2.new(1, -22, 0.5, -8)
Value.BorderSizePixel = 0
Value.AutomaticSize = Enum.AutomaticSize.XY
Value.TextSize = 14
Value.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Value.Parent = Slider_Component

local Slider_Text = Instance.new("TextLabel")
Slider_Text.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Slider_Text.TextColor3 = Color3.fromRGB(69, 71, 90)
Slider_Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
Slider_Text.Text = "Example Slider"
Slider_Text.Name = "Slider_Text"
Slider_Text.AnchorPoint = Vector2.new(0, 0.5)
Slider_Text.Size = UDim2.new(0, 1, 0, 1)
Slider_Text.BackgroundTransparency = 1
Slider_Text.Position = UDim2.new(0, 23, 0.5, -8)
Slider_Text.BorderSizePixel = 0
Slider_Text.AutomaticSize = Enum.AutomaticSize.XY
Slider_Text.TextSize = 14
Slider_Text.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Slider_Text.Parent = Slider_Component

local Progress_BG = Instance.new("Frame")
Progress_BG.AnchorPoint = Vector2.new(0, 0.5)
Progress_BG.Name = "Progress_BG"
Progress_BG.Position = UDim2.new(0.012820512987673283, 19, 0.53125, 13)
Progress_BG.BorderColor3 = Color3.fromRGB(0, 0, 0)
Progress_BG.Size = UDim2.new(0, 266, 0, 4)
Progress_BG.BorderSizePixel = 0
Progress_BG.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Progress_BG.Parent = Slider_Component

local Progress = Instance.new("Frame")
Progress.AnchorPoint = Vector2.new(0, 0.5)
Progress.Name = "Progress"
Progress.Position = UDim2.new(0, 0, 0.5, 0)
Progress.BorderColor3 = Color3.fromRGB(0, 0, 0)
Progress.Size = UDim2.new(0, 171, 0, 7)
Progress.BorderSizePixel = 0
Progress.BackgroundColor3 = Color3.fromRGB(232, 232, 232)
Progress.Parent = Progress_BG

local Pointer = Instance.new("Frame")
Pointer.AnchorPoint = Vector2.new(1, 0.5)
Pointer.Name = "Pointer"
Pointer.Position = UDim2.new(1, 0, 0.5, 0)
Pointer.BorderColor3 = Color3.fromRGB(0, 0, 0)
Pointer.Size = UDim2.new(0, 6, 0, 6)
Pointer.BorderSizePixel = 0
Pointer.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Pointer.Parent = Progress

local UICorner = Instance.new("UICorner")
UICorner.Parent = Pointer

local Design = Instance.new("Frame")
Design.BorderColor3 = Color3.fromRGB(0, 0, 0)
Design.AnchorPoint = Vector2.new(0.5, 0.5)
Design.BackgroundTransparency = 0.5
Design.Position = UDim2.new(0.5, 0, 0.5, 0)
Design.Name = "Design"
Design.Size = UDim2.new(0, 14, 0, 14)
Design.BorderSizePixel = 0
Design.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Design.Parent = Pointer

local UICorner = Instance.new("UICorner")
UICorner.Parent = Design

local UICorner = Instance.new("UICorner")
UICorner.Parent = Progress

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Progress

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(28, 30, 38)
UIStroke.Parent = Progress_BG

local UICorner = Instance.new("UICorner")
UICorner.Parent = Progress_BG

local Keybind_Component = Instance.new("Frame")
Keybind_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Keybind_Component.AnchorPoint = Vector2.new(0.5, 0)
Keybind_Component.BackgroundTransparency = 1
Keybind_Component.Position = UDim2.new(0.5, 0, 0.7188498377799988, 0)
Keybind_Component.Name = "Keybind_Component"
Keybind_Component.Size = UDim2.new(0, 312, 0, 50)
Keybind_Component.BorderSizePixel = 0
Keybind_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Keybind_Component.Parent = Holder

local Toggle_Name = Instance.new("TextLabel")
Toggle_Name.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Toggle_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Name.Text = "Example Keybind"
Toggle_Name.Name = "Toggle_Name"
Toggle_Name.AnchorPoint = Vector2.new(0, 0.5)
Toggle_Name.Size = UDim2.new(0, 1, 0, 1)
Toggle_Name.BackgroundTransparency = 1
Toggle_Name.Position = UDim2.new(0, 25, 0.5, 0)
Toggle_Name.BorderSizePixel = 0
Toggle_Name.AutomaticSize = Enum.AutomaticSize.XY
Toggle_Name.TextSize = 12
Toggle_Name.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Toggle_Name.Parent = Keybind_Component

local Holder = Instance.new("Frame")
Holder.ClipsDescendants = true
Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Holder.AnchorPoint = Vector2.new(1, 0.5)
Holder.Name = "Holder"
Holder.Position = UDim2.new(1, -23, 0.5, 0)
Holder.Size = UDim2.new(0, 16, 0, 16)
Holder.BorderSizePixel = 0
Holder.AutomaticSize = Enum.AutomaticSize.XY
Holder.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Holder.Parent = Keybind_Component

local Value = Instance.new("TextLabel")
Value.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
Value.TextColor3 = Color3.fromRGB(255, 255, 255)
Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
Value.Text = "NONE"
Value.Name = "Value"
Value.AnchorPoint = Vector2.new(0, 0.5)
Value.Size = UDim2.new(0, 1, 0, 1)
Value.BackgroundTransparency = 1
Value.Position = UDim2.new(0, 19, 0.5, 0)
Value.BorderSizePixel = 0
Value.AutomaticSize = Enum.AutomaticSize.XY
Value.TextSize = 10
Value.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Value.Parent = Holder

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 6)
UIPadding.PaddingBottom = UDim.new(0, 4)
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 4)
UIPadding.Parent = Value

local Line = Instance.new("Frame")
Line.AnchorPoint = Vector2.new(1, 0.5)
Line.Name = "Line"
Line.Position = UDim2.new(1, 13, 0.5, 0)
Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
Line.Size = UDim2.new(0, 6, 0, 13)
Line.BorderSizePixel = 0
Line.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Line.Parent = Value

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 30)
UICorner.Parent = Line

local Line = Instance.new("Frame")
Line.AnchorPoint = Vector2.new(1, 0.5)
Line.Name = "Line"
Line.Position = UDim2.new(1, 13, 0.5, 0)
Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
Line.Size = UDim2.new(0, 6, 0, 13)
Line.BorderSizePixel = 0
Line.BackgroundColor3 = Color3.fromRGB(254, 254, 254)
Line.Parent = Line

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 30)
UICorner.Parent = Line

local Icon_Holder = Instance.new("Frame")
Icon_Holder.Name = "Icon_Holder"
Icon_Holder.BackgroundTransparency = 1
Icon_Holder.Position = UDim2.new(0.03999999910593033, 0, -0.32786884903907776, 0)
Icon_Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon_Holder.Size = UDim2.new(0, 22, 0, 22)
Icon_Holder.BorderSizePixel = 0
Icon_Holder.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Icon_Holder.Parent = Holder

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.ImageColor3 = Color3.fromRGB(254, 254, 254)
ImageLabel.ScaleType = Enum.ScaleType.Fit
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.Image = "rbxassetid://127406982390736"
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageLabel.ImageContent = Content
ImageLabel.Size = UDim2.new(0, 15, 0, 15)
ImageLabel.BorderSizePixel = 0
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
ImageLabel.Parent = Icon_Holder

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = ImageLabel

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(28, 30, 38)
UIStroke.Parent = Holder

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Holder

local Toggle_Component = Instance.new("Frame")
Toggle_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Component.AnchorPoint = Vector2.new(0.5, 0)
Toggle_Component.BackgroundTransparency = 1
Toggle_Component.Position = UDim2.new(0.5, 0, 0, 0)
Toggle_Component.Name = "Toggle_Component"
Toggle_Component.Size = UDim2.new(0, 312, 0, 30)
Toggle_Component.BorderSizePixel = 0
Toggle_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Toggle_Component.Parent = Holder

local Toggle_Name = Instance.new("TextLabel")
Toggle_Name.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Toggle_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Name.Text = "Example Toggle"
Toggle_Name.Name = "Toggle_Name"
Toggle_Name.AnchorPoint = Vector2.new(0, 0.5)
Toggle_Name.Size = UDim2.new(0, 1, 0, 1)
Toggle_Name.BackgroundTransparency = 1
Toggle_Name.Position = UDim2.new(0, 48, 0.5, 0)
Toggle_Name.BorderSizePixel = 0
Toggle_Name.AutomaticSize = Enum.AutomaticSize.XY
Toggle_Name.TextSize = 12
Toggle_Name.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Toggle_Name.Parent = Toggle_Component

local Toggle = Instance.new("Frame")
Toggle.AnchorPoint = Vector2.new(0, 0.5)
Toggle.Name = "Toggle"
Toggle.Position = UDim2.new(0, 25, 0.5, 0)
Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle.Size = UDim2.new(0, 14, 0, 14)
Toggle.BorderSizePixel = 0
Toggle.BackgroundColor3 = Color3.fromRGB(231, 231, 231)
Toggle.Parent = Toggle_Component

local Check_Icon = Instance.new("ImageLabel")
Check_Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Check_Icon.Name = "Check_Icon"
Check_Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Check_Icon.Image = "rbxassetid://83899464799881"
Check_Icon.BackgroundTransparency = 1
Check_Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
Check_Icon.ImageContent = Content
Check_Icon.Size = UDim2.new(0, 8, 0, 7)
Check_Icon.BorderSizePixel = 0
Check_Icon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Check_Icon.Parent = Toggle

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Toggle

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Toggle

local Dropdown_Component = Instance.new("Frame")
Dropdown_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Dropdown_Component.AnchorPoint = Vector2.new(0.5, 0)
Dropdown_Component.BackgroundTransparency = 1
Dropdown_Component.Position = UDim2.new(0.5, 0, 0.7623318433761597, 0)
Dropdown_Component.Name = "Dropdown_Component"
Dropdown_Component.Size = UDim2.new(0, 312, 0, 55)
Dropdown_Component.BorderSizePixel = 0
Dropdown_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Dropdown_Component.Parent = Holder

local Dropdown_Name = Instance.new("TextLabel")
Dropdown_Name.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Dropdown_Name.TextColor3 = Color3.fromRGB(204, 204, 209)
Dropdown_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Dropdown_Name.Text = "Example Dropdown"
Dropdown_Name.Name = "Dropdown_Name"
Dropdown_Name.Size = UDim2.new(0, 1, 0, 1)
Dropdown_Name.BackgroundTransparency = 1
Dropdown_Name.Position = UDim2.new(0, 25, 0, 12)
Dropdown_Name.BorderSizePixel = 0
Dropdown_Name.AutomaticSize = Enum.AutomaticSize.XY
Dropdown_Name.TextSize = 12
Dropdown_Name.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Dropdown_Name.Parent = Dropdown_Component

local Holder = Instance.new("Frame")
Holder.ClipsDescendants = true
Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Holder.AnchorPoint = Vector2.new(0.5, 1)
Holder.Name = "Holder"
Holder.Position = UDim2.new(0.5032051205635071, 0, 1, 0)
Holder.Size = UDim2.new(0, 264, 0, 22)
Holder.BorderSizePixel = 0
Holder.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Holder.Parent = Dropdown_Component

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(28, 30, 38)
UIStroke.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 2)
UICorner.Parent = Holder

local Options = Instance.new("TextLabel")
Options.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Options.TextColor3 = Color3.fromRGB(254, 254, 254)
Options.BorderColor3 = Color3.fromRGB(0, 0, 0)
Options.Text = "Option 1, Option 2 , Option 3"
Options.Name = "Options"
Options.AnchorPoint = Vector2.new(0, 0.5)
Options.Size = UDim2.new(0, 1, 0, 1)
Options.BackgroundTransparency = 1
Options.Position = UDim2.new(0.02500000037252903, 0, 0.5, 0)
Options.BorderSizePixel = 0
Options.AutomaticSize = Enum.AutomaticSize.XY
Options.TextSize = 13
Options.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Options.Parent = Holder

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Options

local Line = Instance.new("Frame")
Line.AnchorPoint = Vector2.new(1, 0.5)
Line.Name = "Line"
Line.Position = UDim2.new(1, 4, 0.5, 0)
Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
Line.Size = UDim2.new(0, 6, 0, 13)
Line.BorderSizePixel = 0
Line.BackgroundColor3 = Color3.fromRGB(254, 254, 254)
Line.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 30)
UICorner.Parent = Line

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Line

local Line = Instance.new("Frame")
Line.AnchorPoint = Vector2.new(0, 0.5)
Line.Name = "Line"
Line.Position = UDim2.new(0, -4, 0.5, 0)
Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
Line.Size = UDim2.new(0, 6, 0, 13)
Line.BorderSizePixel = 0
Line.BackgroundColor3 = Color3.fromRGB(254, 254, 254)
Line.Parent = Holder

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Line

local UICorner = Instance.new("UICorner")
UICorner.Parent = Line

local Button_Component = Instance.new("Frame")
Button_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button_Component.AnchorPoint = Vector2.new(0.5, 0)
Button_Component.BackgroundTransparency = 1
Button_Component.Position = UDim2.new(0.5, 0, 0.8482142686843872, 0)
Button_Component.Name = "Button_Component"
Button_Component.Size = UDim2.new(0, 312, 0, 40)
Button_Component.BorderSizePixel = 0
Button_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Button_Component.Parent = Holder

local Button = Instance.new("Frame")
Button.AnchorPoint = Vector2.new(0.5, 0.5)
Button.Name = "Button"
Button.Position = UDim2.new(0.5, 0, 0.5, 0)
Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button.Size = UDim2.new(0, 251, 0, 30)
Button.BorderSizePixel = 0
Button.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Button.Parent = Button_Component

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Button

local Button_Text = Instance.new("TextLabel")
Button_Text.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Button_Text.TextColor3 = Color3.fromRGB(69, 71, 90)
Button_Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button_Text.Text = "Example Button"
Button_Text.Name = "Button_Text"
Button_Text.AnchorPoint = Vector2.new(0.5, 0.5)
Button_Text.Size = UDim2.new(0, 1, 0, 1)
Button_Text.BackgroundTransparency = 1
Button_Text.Position = UDim2.new(0.5, 0, 0.5, 0)
Button_Text.BorderSizePixel = 0
Button_Text.AutomaticSize = Enum.AutomaticSize.XY
Button_Text.TextSize = 13
Button_Text.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Button_Text.Parent = Button

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(28, 30, 38)
UIStroke.Parent = Button

local Button_Component = Instance.new("Frame")
Button_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button_Component.AnchorPoint = Vector2.new(0.5, 0)
Button_Component.BackgroundTransparency = 1
Button_Component.Position = UDim2.new(0.5, 0, 0.8482142686843872, 0)
Button_Component.Name = "Button_Component"
Button_Component.Size = UDim2.new(0, 312, 0, 43)
Button_Component.BorderSizePixel = 0
Button_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Button_Component.Parent = Holder

local Button = Instance.new("Frame")
Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button.AnchorPoint = Vector2.new(0.5, 0.5)
Button.BackgroundTransparency = 0.949999988079071
Button.Position = UDim2.new(0.5, 0, 0.5, 0)
Button.Name = "Button"
Button.Size = UDim2.new(0, 251, 0, 30)
Button.BorderSizePixel = 0
Button.BackgroundColor3 = Color3.fromRGB(230, 255, 2)
Button.Parent = Button_Component

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Button

local Button_Text = Instance.new("TextLabel")
Button_Text.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Button_Text.TextColor3 = Color3.fromRGB(230, 255, 2)
Button_Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button_Text.Text = "Custom Color Button"
Button_Text.Name = "Button_Text"
Button_Text.AnchorPoint = Vector2.new(0.5, 0.5)
Button_Text.Size = UDim2.new(0, 1, 0, 1)
Button_Text.BackgroundTransparency = 1
Button_Text.Position = UDim2.new(0.5, 0, 0.5, 0)
Button_Text.BorderSizePixel = 0
Button_Text.AutomaticSize = Enum.AutomaticSize.XY
Button_Text.TextSize = 13
Button_Text.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Button_Text.Parent = Button

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(230, 255, 2)
UIStroke.Transparency = 0.5
UIStroke.Parent = Button

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Header

local Liner = Instance.new("Frame")
Liner.AnchorPoint = Vector2.new(0.5, 1)
Liner.Name = "Liner"
Liner.Position = UDim2.new(0.5, 0, 1, 0)
Liner.BorderColor3 = Color3.fromRGB(0, 0, 0)
Liner.Size = UDim2.new(1, 1, 0, 2)
Liner.BorderSizePixel = 0
Liner.BackgroundColor3 = Color3.fromRGB(26, 26, 37)
Liner.Parent = Header

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Liner

local Header_Holder = Instance.new("Frame")
Header_Holder.ClipsDescendants = true
Header_Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Header_Holder.AnchorPoint = Vector2.new(0.5, 0.5)
Header_Holder.BackgroundTransparency = 1
Header_Holder.Position = UDim2.new(0.5, 0, 0.5, 0)
Header_Holder.Name = "Header_Holder"
Header_Holder.Size = UDim2.new(0, 281, 0, 30)
Header_Holder.BorderSizePixel = 0
Header_Holder.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Header_Holder.Parent = Header

local Section_Name = Instance.new("TextLabel")
Section_Name.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Section_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
Section_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Section_Name.Text = "Exploits Tab"
Section_Name.Name = "Section_Name"
Section_Name.AnchorPoint = Vector2.new(0, 0.5)
Section_Name.Size = UDim2.new(0, 1, 0, 1)
Section_Name.BackgroundTransparency = 1
Section_Name.Position = UDim2.new(0, 35, 0.5, 0)
Section_Name.BorderSizePixel = 0
Section_Name.AutomaticSize = Enum.AutomaticSize.XY
Section_Name.TextSize = 12
Section_Name.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Section_Name.Parent = Header_Holder

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.ImageColor3 = Color3.fromRGB(255, 127, 0)
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
ImageLabel.Image = "rbxassetid://83273732891006"
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(0, 12, 0.5, 0)
ImageLabel.ImageContent = Content
ImageLabel.Size = UDim2.new(0, 15, 0, 15)
ImageLabel.BorderSizePixel = 0
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
ImageLabel.Parent = Header_Holder

local Toggle = Instance.new("Frame")
Toggle.AnchorPoint = Vector2.new(1, 0.5)
Toggle.Name = "Toggle"
Toggle.Position = UDim2.new(1, -12, 0.5, 0)
Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle.Size = UDim2.new(0, 16, 0, 16)
Toggle.BorderSizePixel = 0
Toggle.BackgroundColor3 = Color3.fromRGB(231, 231, 231)
Toggle.Parent = Header_Holder

local Check_Icon = Instance.new("ImageLabel")
Check_Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Check_Icon.Name = "Check_Icon"
Check_Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Check_Icon.Image = "rbxassetid://83899464799881"
Check_Icon.BackgroundTransparency = 1
Check_Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
Check_Icon.ImageContent = Content
Check_Icon.Size = UDim2.new(0, 8, 0, 7)
Check_Icon.BorderSizePixel = 0
Check_Icon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Check_Icon.Parent = Toggle

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Toggle

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Toggle

local Line = Instance.new("Frame")
Line.AnchorPoint = Vector2.new(0, 0.5)
Line.Name = "Line"
Line.Position = UDim2.new(0, -3, 0.5, 0)
Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
Line.Size = UDim2.new(0, 6, 0, 20)
Line.BorderSizePixel = 0
Line.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Line.Parent = Header_Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 30)
UICorner.Parent = Line

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Section_Left

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 20)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Parent = Container

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 12)
UIPadding.PaddingLeft = UDim.new(0, 12)
UIPadding.Parent = Container

local Section_Right = Instance.new("Frame")
Section_Right.Size = UDim2.new(0, 281, 0, 60)
Section_Right.Name = "Section_Right"
Section_Right.ClipsDescendants = true
Section_Right.BorderColor3 = Color3.fromRGB(0, 0, 0)
Section_Right.BorderSizePixel = 0
Section_Right.AutomaticSize = Enum.AutomaticSize.Y
Section_Right.BackgroundColor3 = Color3.fromRGB(17, 18, 22)
Section_Right.Parent = Container

local Header = Instance.new("Frame")
Header.AnchorPoint = Vector2.new(0.5, 0)
Header.Name = "Header"
Header.Position = UDim2.new(0.5017856955528259, 0, 0, 0)
Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
Header.Size = UDim2.new(0, 281, 0, 30)
Header.BorderSizePixel = 0
Header.BackgroundColor3 = Color3.fromRGB(19, 20, 25)
Header.Parent = Section_Right

local Holder = Instance.new("Frame")
Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Holder.AnchorPoint = Vector2.new(0.5, 0)
Holder.Name = "Holder"
Holder.BackgroundTransparency = 1
Holder.Position = UDim2.new(0.5, 0, 1, 0)
Holder.Size = UDim2.new(0, 1, 0, 1)
Holder.BorderSizePixel = 0
Holder.AutomaticSize = Enum.AutomaticSize.XY
Holder.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
Holder.Parent = Header

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Holder

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingBottom = UDim.new(0, 45)
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.Parent = Holder

local Toggle_Component = Instance.new("Frame")
Toggle_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Component.AnchorPoint = Vector2.new(0.5, 0)
Toggle_Component.BackgroundTransparency = 1
Toggle_Component.Position = UDim2.new(0.5, 0, 0, 0)
Toggle_Component.Name = "Toggle_Component"
Toggle_Component.Size = UDim2.new(0, 312, 0, 30)
Toggle_Component.BorderSizePixel = 0
Toggle_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Toggle_Component.Parent = Holder

local Toggle_Name = Instance.new("TextLabel")
Toggle_Name.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Toggle_Name.TextColor3 = Color3.fromRGB(69, 71, 90)
Toggle_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Name.Text = "Example Toggle"
Toggle_Name.Name = "Toggle_Name"
Toggle_Name.AnchorPoint = Vector2.new(0, 0.5)
Toggle_Name.Size = UDim2.new(0, 1, 0, 1)
Toggle_Name.BackgroundTransparency = 1
Toggle_Name.Position = UDim2.new(0, 48, 0.5, 0)
Toggle_Name.BorderSizePixel = 0
Toggle_Name.AutomaticSize = Enum.AutomaticSize.XY
Toggle_Name.TextSize = 12
Toggle_Name.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Toggle_Name.Parent = Toggle_Component

local Toggle = Instance.new("Frame")
Toggle.AnchorPoint = Vector2.new(0, 0.5)
Toggle.Name = "Toggle"
Toggle.Position = UDim2.new(0, 25, 0.5, 0)
Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle.Size = UDim2.new(0, 14, 0, 14)
Toggle.BorderSizePixel = 0
Toggle.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Toggle.Parent = Toggle_Component

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(28, 30, 38)
UIStroke.Parent = Toggle

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Toggle

local Toggle_Component = Instance.new("Frame")
Toggle_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Component.AnchorPoint = Vector2.new(0.5, 0)
Toggle_Component.BackgroundTransparency = 1
Toggle_Component.Position = UDim2.new(0.5, 0, 0, 0)
Toggle_Component.Name = "Toggle_Component"
Toggle_Component.Size = UDim2.new(0, 312, 0, 30)
Toggle_Component.BorderSizePixel = 0
Toggle_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Toggle_Component.Parent = Holder

local Toggle_Name = Instance.new("TextLabel")
Toggle_Name.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Toggle_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Name.Text = "Example Toggle"
Toggle_Name.Name = "Toggle_Name"
Toggle_Name.AnchorPoint = Vector2.new(0, 0.5)
Toggle_Name.Size = UDim2.new(0, 1, 0, 1)
Toggle_Name.BackgroundTransparency = 1
Toggle_Name.Position = UDim2.new(0, 48, 0.5, 0)
Toggle_Name.BorderSizePixel = 0
Toggle_Name.AutomaticSize = Enum.AutomaticSize.XY
Toggle_Name.TextSize = 12
Toggle_Name.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Toggle_Name.Parent = Toggle_Component

local Toggle = Instance.new("Frame")
Toggle.AnchorPoint = Vector2.new(0, 0.5)
Toggle.Name = "Toggle"
Toggle.Position = UDim2.new(0, 25, 0.5, 0)
Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle.Size = UDim2.new(0, 14, 0, 14)
Toggle.BorderSizePixel = 0
Toggle.BackgroundColor3 = Color3.fromRGB(231, 231, 231)
Toggle.Parent = Toggle_Component

local Check_Icon = Instance.new("ImageLabel")
Check_Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Check_Icon.Name = "Check_Icon"
Check_Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Check_Icon.Image = "rbxassetid://83899464799881"
Check_Icon.BackgroundTransparency = 1
Check_Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
Check_Icon.ImageContent = Content
Check_Icon.Size = UDim2.new(0, 8, 0, 7)
Check_Icon.BorderSizePixel = 0
Check_Icon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Check_Icon.Parent = Toggle

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Toggle

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Toggle

local ColorFrame = Instance.new("Frame")
ColorFrame.AnchorPoint = Vector2.new(1, 0.5)
ColorFrame.Name = "ColorFrame"
ColorFrame.Position = UDim2.new(1, -23, 0.5, 0)
ColorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ColorFrame.Size = UDim2.new(0, 24, 0, 13)
ColorFrame.BorderSizePixel = 0
ColorFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ColorFrame.Parent = Toggle_Component

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = ColorFrame

local Shadow = Instance.new("Frame")
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Name = "Shadow"
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
Shadow.Size = UDim2.new(0, 24, 0, 13)
Shadow.BorderSizePixel = 0
Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Shadow.Parent = ColorFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = Shadow

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.45, 0.75),
	NumberSequenceKeypoint.new(0.696, 1),
	NumberSequenceKeypoint.new(0.988, 0.9937499761581421),
	NumberSequenceKeypoint.new(1, 1)
}
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Shadow

local Toggle_Component = Instance.new("Frame")
Toggle_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Component.AnchorPoint = Vector2.new(0.5, 0)
Toggle_Component.BackgroundTransparency = 1
Toggle_Component.Position = UDim2.new(0.5, 0, 0, 0)
Toggle_Component.Name = "Toggle_Component"
Toggle_Component.Size = UDim2.new(0, 312, 0, 30)
Toggle_Component.BorderSizePixel = 0
Toggle_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Toggle_Component.Parent = Holder

local Toggle_Name = Instance.new("TextLabel")
Toggle_Name.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Toggle_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Name.Text = "Example Toggle"
Toggle_Name.Name = "Toggle_Name"
Toggle_Name.AnchorPoint = Vector2.new(0, 0.5)
Toggle_Name.Size = UDim2.new(0, 1, 0, 1)
Toggle_Name.BackgroundTransparency = 1
Toggle_Name.Position = UDim2.new(0, 48, 0.5, 0)
Toggle_Name.BorderSizePixel = 0
Toggle_Name.AutomaticSize = Enum.AutomaticSize.XY
Toggle_Name.TextSize = 12
Toggle_Name.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Toggle_Name.Parent = Toggle_Component

local Toggle = Instance.new("Frame")
Toggle.AnchorPoint = Vector2.new(0, 0.5)
Toggle.Name = "Toggle"
Toggle.Position = UDim2.new(0, 25, 0.5, 0)
Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle.Size = UDim2.new(0, 14, 0, 14)
Toggle.BorderSizePixel = 0
Toggle.BackgroundColor3 = Color3.fromRGB(231, 231, 231)
Toggle.Parent = Toggle_Component

local Check_Icon = Instance.new("ImageLabel")
Check_Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Check_Icon.Name = "Check_Icon"
Check_Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Check_Icon.Image = "rbxassetid://83899464799881"
Check_Icon.BackgroundTransparency = 1
Check_Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
Check_Icon.ImageContent = Content
Check_Icon.Size = UDim2.new(0, 8, 0, 7)
Check_Icon.BorderSizePixel = 0
Check_Icon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Check_Icon.Parent = Toggle

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Toggle

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Toggle

local Slider_Component = Instance.new("Frame")
Slider_Component.Active = true
Slider_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Slider_Component.AnchorPoint = Vector2.new(0.5, 0)
Slider_Component.BackgroundTransparency = 1
Slider_Component.Position = UDim2.new(0.5, 0, 0.7621951103210449, 0)
Slider_Component.Name = "Slider_Component"
Slider_Component.Size = UDim2.new(0, 312, 0, 40)
Slider_Component.BorderSizePixel = 0
Slider_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Slider_Component.Parent = Holder

local Value = Instance.new("TextLabel")
Value.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Value.TextColor3 = Color3.fromRGB(255, 255, 255)
Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
Value.Text = "100"
Value.Name = "Value"
Value.AnchorPoint = Vector2.new(1, 0.5)
Value.Size = UDim2.new(0, 1, 0, 1)
Value.BackgroundTransparency = 1
Value.Position = UDim2.new(1, -22, 0.5, -8)
Value.BorderSizePixel = 0
Value.AutomaticSize = Enum.AutomaticSize.XY
Value.TextSize = 14
Value.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Value.Parent = Slider_Component

local Slider_Text = Instance.new("TextLabel")
Slider_Text.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Slider_Text.TextColor3 = Color3.fromRGB(69, 71, 90)
Slider_Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
Slider_Text.Text = "Example Slider"
Slider_Text.Name = "Slider_Text"
Slider_Text.AnchorPoint = Vector2.new(0, 0.5)
Slider_Text.Size = UDim2.new(0, 1, 0, 1)
Slider_Text.BackgroundTransparency = 1
Slider_Text.Position = UDim2.new(0, 23, 0.5, -8)
Slider_Text.BorderSizePixel = 0
Slider_Text.AutomaticSize = Enum.AutomaticSize.XY
Slider_Text.TextSize = 14
Slider_Text.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Slider_Text.Parent = Slider_Component

local Progress_BG = Instance.new("Frame")
Progress_BG.AnchorPoint = Vector2.new(0, 0.5)
Progress_BG.Name = "Progress_BG"
Progress_BG.Position = UDim2.new(0.012820512987673283, 19, 0.53125, 13)
Progress_BG.BorderColor3 = Color3.fromRGB(0, 0, 0)
Progress_BG.Size = UDim2.new(0, 266, 0, 4)
Progress_BG.BorderSizePixel = 0
Progress_BG.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Progress_BG.Parent = Slider_Component

local Progress = Instance.new("Frame")
Progress.AnchorPoint = Vector2.new(0, 0.5)
Progress.Name = "Progress"
Progress.Position = UDim2.new(0, 0, 0.5, 0)
Progress.BorderColor3 = Color3.fromRGB(0, 0, 0)
Progress.Size = UDim2.new(0, 171, 0, 7)
Progress.BorderSizePixel = 0
Progress.BackgroundColor3 = Color3.fromRGB(232, 232, 232)
Progress.Parent = Progress_BG

local UICorner = Instance.new("UICorner")
UICorner.Parent = Progress

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Progress

local Pointer = Instance.new("Frame")
Pointer.AnchorPoint = Vector2.new(1, 0.5)
Pointer.Name = "Pointer"
Pointer.Position = UDim2.new(1, 0, 0.5, 0)
Pointer.BorderColor3 = Color3.fromRGB(0, 0, 0)
Pointer.Size = UDim2.new(0, 6, 0, 6)
Pointer.BorderSizePixel = 0
Pointer.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Pointer.Parent = Progress

local UICorner = Instance.new("UICorner")
UICorner.Parent = Pointer

local Design = Instance.new("Frame")
Design.BorderColor3 = Color3.fromRGB(0, 0, 0)
Design.AnchorPoint = Vector2.new(0.5, 0.5)
Design.BackgroundTransparency = 0.5
Design.Position = UDim2.new(0.5, 0, 0.5, 0)
Design.Name = "Design"
Design.Size = UDim2.new(0, 14, 0, 14)
Design.BorderSizePixel = 0
Design.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Design.Parent = Pointer

local UICorner = Instance.new("UICorner")
UICorner.Parent = Design

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(28, 30, 38)
UIStroke.Parent = Progress_BG

local UICorner = Instance.new("UICorner")
UICorner.Parent = Progress_BG

local Keybind_Component = Instance.new("Frame")
Keybind_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Keybind_Component.AnchorPoint = Vector2.new(0.5, 0)
Keybind_Component.BackgroundTransparency = 1
Keybind_Component.Position = UDim2.new(0.5, 0, 0.7188498377799988, 0)
Keybind_Component.Name = "Keybind_Component"
Keybind_Component.Size = UDim2.new(0, 312, 0, 50)
Keybind_Component.BorderSizePixel = 0
Keybind_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Keybind_Component.Parent = Holder

local Toggle_Name = Instance.new("TextLabel")
Toggle_Name.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Toggle_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle_Name.Text = "Example Keybind"
Toggle_Name.Name = "Toggle_Name"
Toggle_Name.AnchorPoint = Vector2.new(0, 0.5)
Toggle_Name.Size = UDim2.new(0, 1, 0, 1)
Toggle_Name.BackgroundTransparency = 1
Toggle_Name.Position = UDim2.new(0, 25, 0.5, 0)
Toggle_Name.BorderSizePixel = 0
Toggle_Name.AutomaticSize = Enum.AutomaticSize.XY
Toggle_Name.TextSize = 12
Toggle_Name.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Toggle_Name.Parent = Keybind_Component

local Holder = Instance.new("Frame")
Holder.ClipsDescendants = true
Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Holder.AnchorPoint = Vector2.new(1, 0.5)
Holder.Name = "Holder"
Holder.Position = UDim2.new(1, -23, 0.5, 0)
Holder.Size = UDim2.new(0, 16, 0, 16)
Holder.BorderSizePixel = 0
Holder.AutomaticSize = Enum.AutomaticSize.XY
Holder.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Holder.Parent = Keybind_Component

local Value = Instance.new("TextLabel")
Value.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
Value.TextColor3 = Color3.fromRGB(255, 255, 255)
Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
Value.Text = "NONE"
Value.Name = "Value"
Value.AnchorPoint = Vector2.new(0, 0.5)
Value.Size = UDim2.new(0, 1, 0, 1)
Value.BackgroundTransparency = 1
Value.Position = UDim2.new(0, 19, 0.5, 0)
Value.BorderSizePixel = 0
Value.AutomaticSize = Enum.AutomaticSize.XY
Value.TextSize = 10
Value.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Value.Parent = Holder

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 6)
UIPadding.PaddingBottom = UDim.new(0, 4)
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 4)
UIPadding.Parent = Value

local Line = Instance.new("Frame")
Line.AnchorPoint = Vector2.new(1, 0.5)
Line.Name = "Line"
Line.Position = UDim2.new(1, 13, 0.5, 0)
Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
Line.Size = UDim2.new(0, 6, 0, 13)
Line.BorderSizePixel = 0
Line.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Line.Parent = Value

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 30)
UICorner.Parent = Line

local Line = Instance.new("Frame")
Line.AnchorPoint = Vector2.new(1, 0.5)
Line.Name = "Line"
Line.Position = UDim2.new(1, 13, 0.5, 0)
Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
Line.Size = UDim2.new(0, 6, 0, 13)
Line.BorderSizePixel = 0
Line.BackgroundColor3 = Color3.fromRGB(254, 254, 254)
Line.Parent = Line

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 30)
UICorner.Parent = Line

local Icon_Holder = Instance.new("Frame")
Icon_Holder.Name = "Icon_Holder"
Icon_Holder.BackgroundTransparency = 1
Icon_Holder.Position = UDim2.new(0.03999999910593033, 0, -0.32786884903907776, 0)
Icon_Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon_Holder.Size = UDim2.new(0, 22, 0, 22)
Icon_Holder.BorderSizePixel = 0
Icon_Holder.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Icon_Holder.Parent = Holder

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.ImageColor3 = Color3.fromRGB(254, 254, 254)
ImageLabel.ScaleType = Enum.ScaleType.Fit
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.Image = "rbxassetid://127406982390736"
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageLabel.ImageContent = Content
ImageLabel.Size = UDim2.new(0, 15, 0, 15)
ImageLabel.BorderSizePixel = 0
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
ImageLabel.Parent = Icon_Holder

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = ImageLabel

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(28, 30, 38)
UIStroke.Parent = Holder

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Holder

local Dropdown_Component = Instance.new("Frame")
Dropdown_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Dropdown_Component.AnchorPoint = Vector2.new(0.5, 0)
Dropdown_Component.BackgroundTransparency = 1
Dropdown_Component.Position = UDim2.new(0.5, 0, 0.7623318433761597, 0)
Dropdown_Component.Name = "Dropdown_Component"
Dropdown_Component.Size = UDim2.new(0, 312, 0, 55)
Dropdown_Component.BorderSizePixel = 0
Dropdown_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Dropdown_Component.Parent = Holder

local Dropdown_Name = Instance.new("TextLabel")
Dropdown_Name.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Dropdown_Name.TextColor3 = Color3.fromRGB(204, 204, 209)
Dropdown_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Dropdown_Name.Text = "Example Dropdown"
Dropdown_Name.Name = "Dropdown_Name"
Dropdown_Name.Size = UDim2.new(0, 1, 0, 1)
Dropdown_Name.BackgroundTransparency = 1
Dropdown_Name.Position = UDim2.new(0, 25, 0, 12)
Dropdown_Name.BorderSizePixel = 0
Dropdown_Name.AutomaticSize = Enum.AutomaticSize.XY
Dropdown_Name.TextSize = 12
Dropdown_Name.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Dropdown_Name.Parent = Dropdown_Component

local Holder = Instance.new("Frame")
Holder.ClipsDescendants = true
Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Holder.AnchorPoint = Vector2.new(0.5, 1)
Holder.Name = "Holder"
Holder.Position = UDim2.new(0.5032051205635071, 0, 1, 0)
Holder.Size = UDim2.new(0, 264, 0, 22)
Holder.BorderSizePixel = 0
Holder.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Holder.Parent = Dropdown_Component

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(28, 30, 38)
UIStroke.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 2)
UICorner.Parent = Holder

local Line = Instance.new("Frame")
Line.AnchorPoint = Vector2.new(1, 0.5)
Line.Name = "Line"
Line.Position = UDim2.new(1, 4, 0.5, 0)
Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
Line.Size = UDim2.new(0, 6, 0, 13)
Line.BorderSizePixel = 0
Line.BackgroundColor3 = Color3.fromRGB(254, 254, 254)
Line.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 30)
UICorner.Parent = Line

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Line

local Line = Instance.new("Frame")
Line.AnchorPoint = Vector2.new(0, 0.5)
Line.Name = "Line"
Line.Position = UDim2.new(0, -4, 0.5, 0)
Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
Line.Size = UDim2.new(0, 6, 0, 13)
Line.BorderSizePixel = 0
Line.BackgroundColor3 = Color3.fromRGB(254, 254, 254)
Line.Parent = Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 30)
UICorner.Parent = Line

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Line

local Options = Instance.new("TextLabel")
Options.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Options.TextColor3 = Color3.fromRGB(254, 254, 254)
Options.BorderColor3 = Color3.fromRGB(0, 0, 0)
Options.Text = "Option 1, Option 2 , Option 3"
Options.Name = "Options"
Options.AnchorPoint = Vector2.new(0, 0.5)
Options.Size = UDim2.new(0, 1, 0, 1)
Options.BackgroundTransparency = 1
Options.Position = UDim2.new(0.02500000037252903, 0, 0.5, 0)
Options.BorderSizePixel = 0
Options.AutomaticSize = Enum.AutomaticSize.XY
Options.TextSize = 13
Options.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Options.Parent = Holder

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 87))
}
UIGradient.Parent = Options

local Button_Component = Instance.new("Frame")
Button_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button_Component.AnchorPoint = Vector2.new(0.5, 0)
Button_Component.BackgroundTransparency = 1
Button_Component.Position = UDim2.new(0.5, 0, 0.8482142686843872, 0)
Button_Component.Name = "Button_Component"
Button_Component.Size = UDim2.new(0, 312, 0, 40)
Button_Component.BorderSizePixel = 0
Button_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Button_Component.Parent = Holder

local Button = Instance.new("Frame")
Button.AnchorPoint = Vector2.new(0.5, 0.5)
Button.Name = "Button"
Button.Position = UDim2.new(0.5, 0, 0.5, 0)
Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button.Size = UDim2.new(0, 251, 0, 30)
Button.BorderSizePixel = 0
Button.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Button.Parent = Button_Component

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Button

local Button_Text = Instance.new("TextLabel")
Button_Text.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Button_Text.TextColor3 = Color3.fromRGB(69, 71, 90)
Button_Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button_Text.Text = "Example Button"
Button_Text.Name = "Button_Text"
Button_Text.AnchorPoint = Vector2.new(0.5, 0.5)
Button_Text.Size = UDim2.new(0, 1, 0, 1)
Button_Text.BackgroundTransparency = 1
Button_Text.Position = UDim2.new(0.5, 0, 0.5, 0)
Button_Text.BorderSizePixel = 0
Button_Text.AutomaticSize = Enum.AutomaticSize.XY
Button_Text.TextSize = 13
Button_Text.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Button_Text.Parent = Button

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(28, 30, 38)
UIStroke.Parent = Button

local Button_Component = Instance.new("Frame")
Button_Component.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button_Component.AnchorPoint = Vector2.new(0.5, 0)
Button_Component.BackgroundTransparency = 1
Button_Component.Position = UDim2.new(0.5, 0, 0.8482142686843872, 0)
Button_Component.Name = "Button_Component"
Button_Component.Size = UDim2.new(0, 312, 0, 43)
Button_Component.BorderSizePixel = 0
Button_Component.BackgroundColor3 = Color3.fromRGB(23, 25, 37)
Button_Component.Parent = Holder

local Button = Instance.new("Frame")
Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button.AnchorPoint = Vector2.new(0.5, 0.5)
Button.BackgroundTransparency = 0.949999988079071
Button.Position = UDim2.new(0.5, 0, 0.5, 0)
Button.Name = "Button"
Button.Size = UDim2.new(0, 251, 0, 30)
Button.BorderSizePixel = 0
Button.BackgroundColor3 = Color3.fromRGB(230, 255, 2)
Button.Parent = Button_Component

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Button

local Button_Text = Instance.new("TextLabel")
Button_Text.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Button_Text.TextColor3 = Color3.fromRGB(230, 255, 2)
Button_Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button_Text.Text = "Custom Color Button"
Button_Text.Name = "Button_Text"
Button_Text.AnchorPoint = Vector2.new(0.5, 0.5)
Button_Text.Size = UDim2.new(0, 1, 0, 1)
Button_Text.BackgroundTransparency = 1
Button_Text.Position = UDim2.new(0.5, 0, 0.5, 0)
Button_Text.BorderSizePixel = 0
Button_Text.AutomaticSize = Enum.AutomaticSize.XY
Button_Text.TextSize = 13
Button_Text.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Button_Text.Parent = Button

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(230, 255, 2)
UIStroke.Transparency = 0.5
UIStroke.Parent = Button

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Header

local Liner = Instance.new("Frame")
Liner.AnchorPoint = Vector2.new(0.5, 1)
Liner.Name = "Liner"
Liner.Position = UDim2.new(0.5, 0, 1, 0)
Liner.BorderColor3 = Color3.fromRGB(0, 0, 0)
Liner.Size = UDim2.new(1, 1, 0, 1)
Liner.BorderSizePixel = 0
Liner.BackgroundColor3 = Color3.fromRGB(26, 26, 37)
Liner.Parent = Header

local Header_Holder = Instance.new("Frame")
Header_Holder.ClipsDescendants = true
Header_Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Header_Holder.AnchorPoint = Vector2.new(0.5, 0.5)
Header_Holder.BackgroundTransparency = 1
Header_Holder.Position = UDim2.new(0.5, 0, 0.5, 0)
Header_Holder.Name = "Header_Holder"
Header_Holder.Size = UDim2.new(0, 281, 0, 30)
Header_Holder.BorderSizePixel = 0
Header_Holder.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Header_Holder.Parent = Header

local Section_Name = Instance.new("TextLabel")
Section_Name.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Section_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
Section_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
Section_Name.Text = "Rage Exploits"
Section_Name.Name = "Section_Name"
Section_Name.AnchorPoint = Vector2.new(0, 0.5)
Section_Name.Size = UDim2.new(0, 1, 0, 1)
Section_Name.BackgroundTransparency = 1
Section_Name.Position = UDim2.new(0, 35, 0.5, 0)
Section_Name.BorderSizePixel = 0
Section_Name.AutomaticSize = Enum.AutomaticSize.XY
Section_Name.TextSize = 12
Section_Name.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Section_Name.Parent = Header_Holder

local Line = Instance.new("Frame")
Line.AnchorPoint = Vector2.new(0, 0.5)
Line.Name = "Line"
Line.Position = UDim2.new(0, -3, 0.5, 0)
Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
Line.Size = UDim2.new(0, 6, 0, 20)
Line.BorderSizePixel = 0
Line.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Line.Parent = Header_Holder

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 30)
UICorner.Parent = Line

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.ImageColor3 = Color3.fromRGB(255, 127, 0)
ImageLabel.ScaleType = Enum.ScaleType.Fit
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
ImageLabel.Image = "rbxassetid://115620161683984"
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(0, 12, 0.5, 0)
ImageLabel.ImageContent = Content
ImageLabel.Size = UDim2.new(0, 15, 0, 15)
ImageLabel.BorderSizePixel = 0
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
ImageLabel.Parent = Header_Holder

local Toggle = Instance.new("Frame")
Toggle.AnchorPoint = Vector2.new(1, 0.5)
Toggle.Name = "Toggle"
Toggle.Position = UDim2.new(1, -12, 0.5, 0)
Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle.Size = UDim2.new(0, 16, 0, 16)
Toggle.BorderSizePixel = 0
Toggle.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
Toggle.Parent = Header_Holder

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(28, 30, 38)
UIStroke.Parent = Toggle

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Toggle

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Section_Right

local Notification = Instance.new("Folder")
Notification.Name = "Notification"
Notification.Parent = ScreenGui

local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "NotifContainer"
NotifContainer.BackgroundTransparency = 1
NotifContainer.Position = UDim2.new(0.8280960917472839, 0, 0.016229713335633278, 0)
NotifContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotifContainer.Size = UDim2.new(0, 186, 0, 754)
NotifContainer.BorderSizePixel = 0
NotifContainer.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
NotifContainer.Parent = Notification

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = NotifContainer

local Notification = Instance.new("Frame")
Notification.Name = "Notification"
Notification.Position = UDim2.new(0, 0, 0.00663129985332489, 0)
Notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
Notification.Size = UDim2.new(0, 185, 0, 79)
Notification.BorderSizePixel = 0
Notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Notification.Parent = NotifContainer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Notification

local Content = Instance.new("TextLabel")
Content.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Content.TextColor3 = Color3.fromRGB(255, 255, 255)
Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
Content.Text = "wATAShonp lora ypsjoal"
Content.Name = "Content"
Content.Size = UDim2.new(0, 170, 0, 32)
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0.07901941239833832, 0, 0.3670886158943176, 0)
Content.BorderSizePixel = 0
Content.TextWrapped = true
Content.TextSize = 12
Content.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
Content.Parent = Notification

local NotifContainerforiconandtitle = Instance.new("Frame")
NotifContainerforiconandtitle.Name = "NotifContainerforiconandtitle"
NotifContainerforiconandtitle.BackgroundTransparency = 1
NotifContainerforiconandtitle.Position = UDim2.new(-0.03073829412460327, 0, 0, 0)
NotifContainerforiconandtitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotifContainerforiconandtitle.Size = UDim2.new(0, 191, 0, 79)
NotifContainerforiconandtitle.BorderSizePixel = 0
NotifContainerforiconandtitle.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
NotifContainerforiconandtitle.Parent = Notification

local NotificationTitle = Instance.new("TextLabel")
NotificationTitle.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotificationTitle.Text = "Notification alert!"
NotificationTitle.Name = "NotificationTitle"
NotificationTitle.Size = UDim2.new(0, 171, 0, 50)
NotificationTitle.BackgroundTransparency = 1
NotificationTitle.Position = UDim2.new(0.10603979974985123, 0, -0.10126582533121109, 0)
NotificationTitle.BorderSizePixel = 0
NotificationTitle.TextWrapped = true
NotificationTitle.TextSize = 16
NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
NotificationTitle.Parent = NotifContainerforiconandtitle

local NotificationIcon = Instance.new("ImageLabel")
NotificationIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotificationIcon.Name = "NotificationIcon"
NotificationIcon.Image = "rbxassetid://89312000818980"
NotificationIcon.BackgroundTransparency = 1
NotificationIcon.Position = UDim2.new(0.12259119004011154, 0, 0.07594936341047287, 0)
NotificationIcon.ImageContent = Content
NotificationIcon.Size = UDim2.new(0, 23, 0, 23)
NotificationIcon.BorderSizePixel = 0
NotificationIcon.BackgroundColor3 = Color3.fromRGB(255, 127, 0)
NotificationIcon.Parent = NotifContainerforiconandtitle

