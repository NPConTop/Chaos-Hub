-- Chaos Hub - Stable Cast Version
print("Chaos Hub Loaded")

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local vim = game:GetService("VirtualInputManager")
local vu = game:GetService("VirtualUser")

-- GUI Base
local gui = Instance.new("ScreenGui")
gui.Name = "ChaosHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Menu Toggle Button
local menuBtn = Instance.new("TextButton")
menuBtn.Size = UDim2.new(0, 100, 0, 30)
menuBtn.Position = UDim2.new(0, 20, 0, 20)
menuBtn.Text = "Menu"
menuBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
menuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
menuBtn.Parent = gui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

menuBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Tabs
local tabList = {"Main", "Auto", "Teleport"}
local tabs, contentFrames = {}, {}

for i, name in ipairs(tabList) do
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(0, 100, 0, 30)
	tabBtn.Position = UDim2.new(0, (i - 1) * 100, 0, 0)
	tabBtn.Text = name
	tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
	tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabBtn.Parent = mainFrame

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 1, -30)
	content.Position = UDim2.new(0, 0, 0, 30)
	content.BackgroundTransparency = 1
	content.Visible = (i == 1)
	content.Parent = mainFrame

	contentFrames[name] = content
	tabs[name] = tabBtn

	tabBtn.MouseButton1Click:Connect(function()
		for _, f in pairs(contentFrames) do f.Visible = false end
		content.Visible = true
	end)
end

-- Auto Tab
local autoTab = contentFrames["Auto"]
local autoClick = false

-- Delay Input
local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(0, 50, 0, 30)
delayBox.Position = UDim2.new(0, 10, 0, 10)
delayBox.Text = "0.1"
delayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayBox.TextColor3 = Color3.new(1, 1, 1)
delayBox.PlaceholderText = "Delay"
delayBox.Parent = autoTab

-- Auto Click Button
local autoClickBtn = Instance.new("TextButton")
autoClickBtn.Size = UDim2.new(0, 150, 0, 30)
autoClickBtn.Position = UDim2.new(0, 70, 0, 10)
autoClickBtn.Text = "Auto Click: OFF"
autoClickBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 50)
autoClickBtn.TextColor3 = Color3.new(1, 1, 1)
autoClickBtn.Parent = autoTab

autoClickBtn.MouseButton1Click:Connect(function()
	autoClick = not autoClick
	autoClickBtn.Text = "Auto Click: " .. (autoClick and "ON" or "OFF")
	task.spawn(function()
		while autoClick do
			vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			wait(tonumber(delayBox.Text) or 0.1)
		end
	end)
end)

-- Skill Cast Buttons (Z/X/C/V)
local skillKeys = {
	{Key = Enum.KeyCode.Z, Label = "Cast Z"},
	{Key = Enum.KeyCode.X, Label = "Cast X"},
	{Key = Enum.KeyCode.C, Label = "Cast C"},
	{Key = Enum.KeyCode.V, Label = "Cast V"}
}

for i, skill in ipairs(skillKeys) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 100, 0, 30)
	btn.Position = UDim2.new(0, 10 + (i - 1) * 110, 0, 60)
	btn.Text = skill.Label
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Parent = autoTab

	btn.MouseButton1Click:Connect(function()
		vim:SendKeyEvent(true, skill.Key, false, game)
		vim:SendKeyEvent(false, skill.Key, false, game)
	end)
end

-- Teleport Tab
local tpTab = contentFrames["Teleport"]
local teleportPoints = {
	["Starter Island"] = Vector3.new(3387, 138, 1716),
	["Clown Island"] = Vector3.new(3002, 144, -585),
	["Marine Island"] = Vector3.new(4930, 140, 35),
	["Lier Village"] = Vector3.new(5795, 177, 2330),
	["Baratee"] = Vector3.new(1422, 124, 2525),
	["Ar Longo Park"] = Vector3.new(466, 144, 526),
	["Lulue Town"] = Vector3.new(5786, 125, -3228),
	["Arena"] = Vector3.new(1319, 130, -808),
	["Jungle Island"] = Vector3.new(0, 0, 0) -- placeholder
}

local row = 0
for name, pos in pairs(teleportPoints) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 180, 0, 25)
	btn.Position = UDim2.new(0, 10 + (row % 2) * 190, 0, 10 + math.floor(row / 2) * 30)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Parent = tpTab
	btn.MouseButton1Click:Connect(function()
		character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(pos)
	end)
	row += 1
end

-- Anti AFK
for _, conn in pairs(getconnections(player.Idled)) do
	conn:Disable()
end

player.Idled:Connect(function()
	vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("Chaos Hub GUI Loaded Successfully")
