-- Chaos Hub - Final Elegant Version
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
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

menuBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Tab Setup
local tabNames = {"Main", "Auto", "Teleport", "Misc"}
local tabs, contentFrames = {}, {}

-- Tab Bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
tabBar.Parent = mainFrame

-- Line Separator
local line = Instance.new("Frame")
line.Size = UDim2.new(1, 0, 0, 2)
line.Position = UDim2.new(0, 0, 0, 30)
line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
line.BorderSizePixel = 0
line.Parent = mainFrame

for i, name in ipairs(tabNames) do
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(0, 150, 0, 30)
	tabBtn.Position = UDim2.new(0, (i - 1) * 150, 0, 0)
	tabBtn.Text = name
	tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabBtn.Font = Enum.Font.SourceSansBold
	tabBtn.TextSize = 14
	tabBtn.Parent = tabBar

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 1, -32)
	content.Position = UDim2.new(0, 0, 0, 32)
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

-- === MAIN TAB: Auto Farm ===
local mainTab = contentFrames["Main"]

local farmLabel = Instance.new("TextLabel")
farmLabel.Size = UDim2.new(0, 300, 0, 30)
farmLabel.Position = UDim2.new(0, 10, 0, 10)
farmLabel.Text = "Auto Farm NPC by Island"
farmLabel.BackgroundTransparency = 1
farmLabel.TextColor3 = Color3.new(1, 1, 1)
farmLabel.TextXAlignment = Enum.TextXAlignment.Left
farmLabel.Parent = mainTab

local npcDropdown = Instance.new("TextButton")
npcDropdown.Size = UDim2.new(0, 200, 0, 30)
npcDropdown.Position = UDim2.new(0, 10, 0, 50)
npcDropdown.Text = "Select NPC"
npcDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
npcDropdown.TextColor3 = Color3.new(1, 1, 1)
npcDropdown.Parent = mainTab

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 100, 0, 30)
refreshBtn.Position = UDim2.new(0, 220, 0, 50)
refreshBtn.Text = "Refresh"
refreshBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.Parent = mainTab

-- === AUTO TAB ===
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
			vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
			vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
			wait(tonumber(delayBox.Text) or 0.1)
		end
	end)
end)

local skillKeys = {"Z", "X", "C", "V"}
for i, key in ipairs(skillKeys) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 100, 0, 30)
	btn.Position = UDim2.new(0, 10 + (i - 1) * 110, 0, 60)
	btn.Text = "Auto " .. key .. ": OFF"
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Parent = autoTab

	local active = false
	btn.MouseButton1Click:Connect(function()
		active = not active
		btn.Text = "Auto " .. key .. ": " .. (active and "ON" or "OFF")
		task.spawn(function()
			while active do
				vim:SendKeyEvent(true, key, false, game)
				vim:SendKeyEvent(false, key, false, game)
				wait(tonumber(delayBox.Text) or 1)
			end
		end)
	end)
end

-- === TELEPORT TAB ===
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

-- === MISC TAB ===
local miscTab = contentFrames["Misc"]

local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(0, 150, 0, 30)
rejoinBtn.Position = UDim2.new(0, 10, 0, 10)
rejoinBtn.Text = "Rejoin Server"
rejoinBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
rejoinBtn.TextColor3 = Color3.new(1, 1, 1)
rejoinBtn.Parent = miscTab

rejoinBtn.MouseButton1Click:Connect(function()
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

local gachaBtn = Instance.new("TextButton")
gachaBtn.Size = UDim2.new(0, 150, 0, 30)
gachaBtn.Position = UDim2.new(0, 10, 0, 50)
gachaBtn.Text = "Gacha Fruit"
gachaBtn.BackgroundColor3 = Color3.fromRGB(50, 80, 50)
gachaBtn.TextColor3 = Color3.new(1, 1, 1)
gachaBtn.Parent = miscTab

gachaBtn.MouseButton1Click:Connect(function()
	local gacha = workspace:FindFirstChild("Gacha")
	if gacha and gacha:FindFirstChild("ProximityPrompt") then
		fireproximityprompt(gacha.ProximityPrompt)
	end
end)

local stockBtn = Instance.new("TextButton")
stockBtn.Size = UDim2.new(0, 150, 0, 30)
stockBtn.Position = UDim2.new(0, 10, 0, 90)
stockBtn.Text = "Check Fruit Stock"
stockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
stockBtn.TextColor3 = Color3.new(1, 1, 1)
stockBtn.Parent = miscTab

stockBtn.MouseButton1Click:Connect(function()
	local stockUI = player.PlayerGui:FindFirstChild("Stock")
	if stockUI then
		stockUI.Enabled = not stockUI.Enabled
	end
end)

-- === Anti Kick / Ban ===
local function hookRemoteEvents()
	for _, v in pairs(getgc(true)) do
		if typeof(v) == "function" and islclosure(v) and getfenv(v).script then
			local name = debug.getinfo(v).name or ""
			if name:lower():match("kick") or name:lower():match("ban") then
				hookfunction(v, function() return nil end)
			end
		end
	end
end
pcall(hookRemoteEvents)

-- Anti AFK
for _, conn in pairs(getconnections(player.Idled)) do conn:Disable() end
player.Idled:Connect(function()
	vu:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- ESP Functions
local function createESP(part, text, color)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ChaosESP"
	billboard.Adornee = part
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.AlwaysOnTop = true

	local label = Instance.new("TextLabel", billboard)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color
	label.TextScaled = true
	label.Font = Enum.Font.SourceSansBold

	billboard.Parent = part
end

local function toggleFruitESP(state)
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
			if state then
				if not obj.Handle:FindFirstChild("ChaosESP") then
					createESP(obj.Handle, obj.Name, Color3.fromRGB(255, 85, 0))
				end
			else
				local esp = obj.Handle:FindFirstChild("ChaosESP")
				if esp then esp:Destroy() end
			end
		end
	end
end

local function toggleIslandESP(state)
	for _, island in pairs(workspace:GetChildren()) do
		if island:IsA("Model") and island:FindFirstChildWhichIsA("BasePart") and island.Name:match("Island") then
			local part = island:FindFirstChildWhichIsA("BasePart")
			if state then
				if not part:FindFirstChild("ChaosESP") then
					createESP(part, island.Name, Color3.fromRGB(0, 255, 170))
				end
			else
				local esp = part:FindFirstChild("ChaosESP")
				if esp then esp:Destroy() end
			end
		end
	end
end

local function togglePlayerESP(state)
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = plr.Character.HumanoidRootPart
			if state then
				if not hrp:FindFirstChild("ChaosESP") then
					createESP(hrp, plr.Name, Color3.fromRGB(85, 170, 255))
				end
			else
				local esp = hrp:FindFirstChild("ChaosESP")
				if esp then esp:Destroy() end
			end
		end
	end
end

local function toggleHealthESP(state)
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
			local hum = plr.Character.Humanoid
			local hrp = plr.Character.HumanoidRootPart
			if state then
				if not hrp:FindFirstChild("ChaosESP") then
					createESP(hrp, "HP: " .. math.floor(hum.Health), Color3.fromRGB(255, 0, 127))
				end
			else
				local esp = hrp:FindFirstChild("ChaosESP")
				if esp then esp:Destroy() end
			end
		end
	end
end

-- === Add to MISC TAB ===
local fruitESP = false
local fruitBtn = Instance.new("TextButton")
fruitBtn.Size = UDim2.new(0, 150, 0, 30)
fruitBtn.Position = UDim2.new(0, 10, 0, 130)
fruitBtn.Text = "Fruit ESP: OFF"
fruitBtn.BackgroundColor3 = Color3.fromRGB(85, 0, 0)
fruitBtn.TextColor3 = Color3.new(1, 1, 1)
fruitBtn.Parent = miscTab

fruitBtn.MouseButton1Click:Connect(function()
	fruitESP = not fruitESP
	fruitBtn.Text = "Fruit ESP: " .. (fruitESP and "ON" or "OFF")
	toggleFruitESP(fruitESP)
end)

local islandESP = false
local islandBtn = fruitBtn:Clone()
islandBtn.Position = UDim2.new(0, 10, 0, 170)
islandBtn.Text = "Island ESP: OFF"
islandBtn.BackgroundColor3 = Color3.fromRGB(0, 85, 85)
islandBtn.Parent = miscTab

islandBtn.MouseButton1Click:Connect(function()
	islandESP = not islandESP
	islandBtn.Text = "Island ESP: " .. (islandESP and "ON" or "OFF")
	toggleIslandESP(islandESP)
end)

local playerESP = false
local playerBtn = fruitBtn:Clone()
playerBtn.Position = UDim2.new(0, 10, 0, 210)
playerBtn.Text = "Player ESP: OFF"
playerBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 85)
playerBtn.Parent = miscTab

playerBtn.MouseButton1Click:Connect(function()
	playerESP = not playerESP
	playerBtn.Text = "Player ESP: " .. (playerESP and "ON" or "OFF")
	togglePlayerESP(playerESP)
end)

local healthESP = false
local healthBtn = fruitBtn:Clone()
healthBtn.Position = UDim2.new(0, 10, 0, 250)
healthBtn.Text = "Health ESP: OFF"
healthBtn.BackgroundColor3 = Color3.fromRGB(85, 0, 85)
healthBtn.Parent = miscTab

healthBtn.MouseButton1Click:Connect(function()
	healthESP = not healthESP
	healthBtn.Text = "Health ESP: " .. (healthESP and "ON" or "OFF")
	toggleHealthESP(healthESP)
end)

print("Chaos Hub GUI Loaded Successfully")
