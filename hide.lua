local Players = game:GetService("Players")

local function WaitForLocalPlayer()
	local deadline = os.clock() + 15
	repeat
		local Player = Players.LocalPlayer
		if Player then
			return Player
		end
		task.wait(0.1)
	until os.clock() > deadline
	return nil
end

local Player = WaitForLocalPlayer()
if not Player then
	return
end

local PlayerGui = Player:WaitForChild("PlayerGui")

local function IsTradeGui(Gui)
	if typeof(Gui) ~= "Instance" then
		return false
	end
	if not Gui:IsA("ScreenGui") then
		return false
	end
	local Name = tostring(Gui.Name)
	return string.lower(Name) == "tradegui" or string.find(string.lower(Name), "trade") ~= nil
end

local function Hide(Gui)
	pcall(function()
		Gui.Enabled = false
	end)
end

local function Bind(Gui)
	Hide(Gui)
	local ok, Signal = pcall(function()
		return Gui:GetPropertyChangedSignal("Enabled")
	end)
	if ok and Signal then
		pcall(function()
			Signal:Connect(function()
				Hide(Gui)
			end)
		end)
	end
end

local function Scan()
	for _, Gui in ipairs(PlayerGui:GetDescendants()) do
		if IsTradeGui(Gui) then
			Bind(Gui)
		end
	end
end

Scan()

pcall(function()
	PlayerGui.DescendantAdded:Connect(function(Gui)
		if IsTradeGui(Gui) then
			Bind(Gui)
		end
	end)
end)
pcall(function()
	PlayerGui.ChildAdded:Connect(function(Gui)
		if IsTradeGui(Gui) then
			Bind(Gui)
		end
	end)
end)

task.spawn(function()
	while true do
		task.wait(0.5)
		Scan()
	end
end)
