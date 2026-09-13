if _G.MM2Loader then return end

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player and Player:WaitForChild("PlayerGui")
if not PlayerGui then return end

local function New(ClassName, Parent, Props)
	local Inst = Instance.new(ClassName)
	if Props then
		for Key, Val in pairs(Props) do
			Inst[Key] = Val
		end
	end
	Inst.Parent = Parent
	return Inst
end

local Ok, ExecutorName = pcall(identifyexecutor)
if not Ok then ExecutorName = nil end

local Minimized = false

local GUI = New("ScreenGui", PlayerGui, {
	Name = "MM2Loader",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 2147483647,
})

local Overlay = New("Frame", GUI, {
	Name = "Overlay",
	BackgroundColor3 = Color3.fromRGB(12, 12, 15),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromScale(0, 0),
	Size = UDim2.fromScale(1, 1),
})

local Card = New("Frame", Overlay, {
	Name = "Card",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.fromOffset(240, 72),
	BackgroundColor3 = Color3.fromRGB(22, 22, 28),
	BackgroundTransparency = 0.05,
	BorderSizePixel = 0,
})
New("UICorner", Card, { CornerRadius = UDim.new(0, 10) })

local Label = New("TextLabel", Card, {
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	Text = "Loading...",
	TextColor3 = Color3.fromRGB(200, 200, 215),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Center,
	Position = UDim2.new(0, 0, 0, 8),
	Size = UDim2.new(1, 0, 0, 20),
})

local SubLabel = New("TextLabel", Card, {
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	Text = ExecutorName and ("Estimated time: ~1 min on " .. ExecutorName) or "Estimated time: ~1 min",
	TextColor3 = Color3.fromRGB(100, 100, 115),
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Center,
	Position = UDim2.new(0, 0, 0, 28),
	Size = UDim2.new(1, 0, 0, 14),
})

local ClickHint = New("TextLabel", Card, {
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	Text = "click to minimize",
	TextColor3 = Color3.fromRGB(65, 65, 80),
	TextSize = 9,
	TextXAlignment = Enum.TextXAlignment.Center,
	Position = UDim2.new(0, 0, 0, 52),
	Size = UDim2.new(1, 0, 0, 12),
})

local BarBG = New("Frame", Card, {
	Name = "BarBG",
	AnchorPoint = Vector2.new(0.5, 0),
	BackgroundColor3 = Color3.fromRGB(35, 35, 45),
	BorderSizePixel = 0,
	Position = UDim2.new(0.5, 0, 0, 48),
	Size = UDim2.new(0.82, 0, 0, 3),
})
New("UICorner", BarBG, { CornerRadius = UDim.new(1, 0) })

local Fill = New("Frame", BarBG, {
	Name = "Fill",
	BackgroundColor3 = Color3.fromRGB(120, 120, 160),
	BackgroundTransparency = 0,
	BorderSizePixel = 0,
	Size = UDim2.new(0, 0, 1, 0),
})
New("UICorner", Fill, { CornerRadius = UDim.new(1, 0) })

local Tab = New("TextButton", GUI, {
	Name = "Tab",
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -12, 1, -12),
	Size = UDim2.fromOffset(40, 100),
	BackgroundColor3 = Color3.fromRGB(22, 22, 28),
	BackgroundTransparency = 0.1,
	BorderSizePixel = 0,
	Font = Enum.Font.Gotham,
	Text = "···",
	TextColor3 = Color3.fromRGB(120, 120, 140),
	TextSize = 20,
	Visible = false,
})
New("UICorner", Tab, { CornerRadius = UDim.new(0, 10) })

local Alive = true
local function IsAlive()
	return GUI and GUI.Parent ~= nil
end

local CardElements = {Label, SubLabel, ClickHint, BarBG}

local function Minimize()
	if Minimized then return end
	Minimized = true
	for _, El in ipairs(CardElements) do
		El.Visible = false
	end
	TweenService:Create(Overlay, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(Card, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -12, 1, -12),
		Size = UDim2.fromOffset(40, 100),
	}):Play()
	Tab.Visible = true
	Tab.BackgroundTransparency = 1
	TweenService:Create(Tab, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.1 }):Play()
end

local function Expand()
	if not Minimized then return end
	Minimized = false
	Tab.Visible = false
	for _, El in ipairs(CardElements) do
		El.Visible = true
	end
	TweenService:Create(Card, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.fromOffset(240, 72),
	}):Play()
	TweenService:Create(Overlay, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.45 }):Play()
end

Card.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		Minimize()
	end
end)
Tab.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		Expand()
	end
end)

task.spawn(function()
	Overlay.BackgroundTransparency = 1
	Card.BackgroundTransparency = 0.6
	TweenService:Create(Overlay, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.45 }):Play()
	TweenService:Create(Card, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.05 }):Play()
end)

local function SetProgress(Progress)
	Progress = math.clamp(Progress or 0, 0, 0.99)
	TweenService:Create(Fill, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(Progress, 0, 1, 0) }):Play()
end

task.spawn(function()
	local StartTime = os.clock()
	local Duration = 60.0
	while IsAlive() do
		local Elapsed = os.clock() - StartTime
		if Elapsed >= Duration then break end
		SetProgress(math.clamp(Elapsed / Duration, 0, 1))
		task.wait(0.12)
	end
	if not IsAlive() then return end
	TweenService:Create(Fill, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0.99, 0, 1, 0) }):Play()
	while IsAlive() do
		TweenService:Create(Fill, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Size = UDim2.new(0.955, 0, 1, 0) }):Play()
		task.wait(1.8)
		if not IsAlive() then break end
		TweenService:Create(Fill, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Size = UDim2.new(0.99, 0, 1, 0) }):Play()
		task.wait(1.8)
	end
end)

_G.MM2Loader = {
	SetProgress = SetProgress,
	SetStatus = function(Text)
		Label.Text = tostring(Text)
	end,
	Hide = function()
		Alive = false
		TweenService:Create(Overlay, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(Card, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(Tab, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()
		task.wait(0.55)
		if GUI and GUI.Parent then
			GUI:Destroy()
		end
		_G.MM2Loader = nil
	end,
}
