
-- Chaos Hub - Optimized Combo Version by NPC
print("Chaos Hub Loaded")

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local vim = game:GetService("VirtualInputManager")
local vu = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

menuBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Tabs
local tabList = {"Main", "Auto", "Teleport", "Misc"}
local tabs, contentFrames = {}, {}

for i, name in ipairs(tabList) do
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(0, 100, 0, 30)
	tabBtn.Position = UDim2.new(0, (i - 1) * 100, 0, 0)
	tabBtn.Text = name
	tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
	tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabBtn.Parent = mainFrame

	local line = Instance.new("Frame")
	line.Size = UDim2.new(0, 100, 0, 2)
	line.Position = UDim2.new(0, (i - 1) * 100, 0, 30)
	line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	line.Visible = (i == 1)
	line.Name = "ActiveLine"
	line.Parent = mainFrame

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 1, -32)
	content.Position = UDim2.new(0, 0, 0, 32)
	content.BackgroundTransparency = 1
	content.Visible = (i == 1)
	content.Parent = mainFrame

	contentFrames[name] = content
	tabs[name] = tabBtn

	tabBtn.MouseButton1Click:Connect(function()
		for j, f in pairs(contentFrames) do f.Visible = false end
		for _, l in pairs(mainFrame:GetChildren()) do
			if l:IsA("Frame") and l.Name == "ActiveLine" then
				l.Visible = false
			end
		end
		content.Visible = true
		line.Visible = true
	end)
end

-- Auto Tab
local autoTab = contentFrames["Auto"]
local autoClick = false

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(0, 50, 0, 30)
delayBox.Position = UDim2.new(0, 10, 0, 10)
delayBox.Text = "0.1"
delayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayBox.TextColor3 = Color3.new(1, 1, 1)
delayBox.PlaceholderText = "Delay"
delayBox.Parent = autoTab

-- Auto Click
local autoClickBtn = Instance.new("TextButton")
autoClickBtn.Size = UDim2.new(0, 150, 0, 30)
autoClickBtn.Position = UDim2.new(0, 70, 0, 10)
autoClickBtn.Text = "Auto Click"
autoClickBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 50)
autoClickBtn.TextColor3 = Color3.new(1, 1, 1)
autoClickBtn.Parent = autoTab

autoClickBtn.MouseButton1Click:Connect(function()
	autoClick = not autoClick
	task.spawn(function()
		while autoClick do
			vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
			vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
			wait(tonumber(delayBox.Text) or 0.1)
		end
	end)
end)

-- Auto Skill
local skillKeys = {"Z", "X", "C", "V"}
for i, key in ipairs(skillKeys) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 100, 0, 30)
	btn.Position = UDim2.new(0, 10 + (i - 1) * 110, 0, 60)
	btn.Text = key
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Parent = autoTab

	btn.MouseButton1Click:Connect(function()
		task.spawn(function()
			vim:SendKeyEvent(true, key, false, game)
			vim:SendKeyEvent(false, key, false, game)
		end)
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
	["Jungle Island"] = Vector3.new(0, 0, 0)
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

-- Misc Tab
local miscTab = contentFrames["Misc"]

local function createMiscButton(text, yPos, onClick)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(50, 70, 90)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Parent = miscTab
	btn.MouseButton1Click:Connect(onClick)
end

createMiscButton("Rejoin Server", 10, function()
	TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
end)

createMiscButton("Check Stock Fruit", 50, function()
	for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
		if obj:IsA("RemoteEvent") and obj.Name:lower():find("stock") then
			obj:FireServer()
			break
		end
	end
end)

createMiscButton("Gacha Random Fruit", 90, function()
	for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
		if obj:IsA("RemoteEvent") and obj.Name:lower():find("buy") then
			obj:FireServer()
			break
		end
	end
end)

createMiscButton("List All RemoteEvent", 130, function()
	print("==== RemoteEvent di Workspace ====")
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("RemoteEvent") then
			print("workspace:", obj:GetFullName())
		end
	end
	print("==== RemoteEvent di ReplicatedStorage ====")
	for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
		if obj:IsA("RemoteEvent") then
			print("replicated:", obj:GetFullName())
		end
	end
end)

-- Anti AFK
for _, conn in pairs(getconnections(player.Idled)) do
	conn:Disable()
end

player.Idled:Connect(function()
	vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("Chaos Hub GUI Loaded Successfully")
