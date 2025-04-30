-- Chaos Hub - Full Version with Complete Tabs (Main, Auto, Teleport, Misc)
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualInput = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- Anti AFK
for _, c in pairs(getconnections(player.Idled)) do c:Disable() end
player.Idled:Connect(function()
	VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- GUI Base
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ChaosHub"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.Active = true
mainFrame.Draggable = true

-- Menu Toggle
local menuBtn = Instance.new("TextButton", gui)
menuBtn.Size = UDim2.new(0, 100, 0, 30)
menuBtn.Position = UDim2.new(0, 20, 0, 20)
menuBtn.Text = "Chaos Menu"
menuBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
menuBtn.TextColor3 = Color3.new(1, 1, 1)

menuBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Tabs
local tabNames = {"Main", "Auto", "Teleport", "Misc"}
local contentFrames = {}

local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)

local line = Instance.new("Frame", mainFrame)
line.Size = UDim2.new(1, 0, 0, 2)
line.Position = UDim2.new(0, 0, 0, 30)
line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

for i, name in ipairs(tabNames) do
	local tabBtn = Instance.new("TextButton", tabBar)
	tabBtn.Size = UDim2.new(0, 150, 0, 30)
	tabBtn.Position = UDim2.new(0, (i - 1) * 150, 0, 0)
	tabBtn.Text = name
	tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

	local content = Instance.new("Frame", mainFrame)
	content.Size = UDim2.new(1, 0, 1, -32)
	content.Position = UDim2.new(0, 0, 0, 32)
	content.BackgroundTransparency = 1
	content.Visible = (i == 1)
	contentFrames[name] = content

	tabBtn.MouseButton1Click:Connect(function()
		for _, f in pairs(contentFrames) do f.Visible = false end
		content.Visible = true
	end)
end

-- Main Tab
do
	local mainTab = contentFrames["Main"]
	local title = Instance.new("TextLabel", mainTab)
	title.Size = UDim2.new(1, 0, 0, 30)
	title.Text = "Auto Farm - Select Target"
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.new(1, 1, 1)

	local mobList = {}
	local selMob, selWeapon = nil, nil

	local mobBtn = Instance.new("TextButton", mainTab)
	mobBtn.Size = UDim2.new(0, 200, 0, 30)
	mobBtn.Position = UDim2.new(0, 10, 0, 40)
	mobBtn.Text = "Refresh NPC"
	mobBtn.MouseButton1Click:Connect(function()
		mobList = {}
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Model") and v:FindFirstChild("Humanoid") and not table.find(mobList, v.Name) then
				table.insert(mobList, v.Name)
			end
		end
	end)

	local dropMob = Instance.new("TextButton", mainTab)
	dropMob.Size = UDim2.new(0, 200, 0, 30)
	dropMob.Position = UDim2.new(0, 10, 0, 80)
	dropMob.Text = "Select Mob"
	dropMob.MouseButton1Click:Connect(function()
		if #mobList > 0 then
			selMob = mobList[1]
			dropMob.Text = selMob
		end
	end)

	local dropWeapon = Instance.new("TextButton", mainTab)
	dropWeapon.Size = UDim2.new(0, 200, 0, 30)
	dropWeapon.Position = UDim2.new(0, 10, 0, 120)
	dropWeapon.Text = "Select Weapon"
	dropWeapon.MouseButton1Click:Connect(function()
		for _, tool in pairs(player.Backpack:GetChildren()) do
			if tool:IsA("Tool") then
				selWeapon = tool.Name
				dropWeapon.Text = selWeapon
				break
			end
		end
	end)

	local autoFarm = false
	local toggleAF = Instance.new("TextButton", mainTab)
	toggleAF.Size = UDim2.new(0, 150, 0, 30)
	toggleAF.Position = UDim2.new(0, 10, 0, 160)
	toggleAF.Text = "Auto Farm: OFF"
	toggleAF.MouseButton1Click:Connect(function()
		autoFarm = not autoFarm
		toggleAF.Text = "Auto Farm: " .. (autoFarm and "ON" or "OFF")
		task.spawn(function()
			while autoFarm do
				if selMob and selWeapon then
					local mob = workspace:FindFirstChild(selMob)
					local char = player.Character
					if mob and mob:FindFirstChild("HumanoidRootPart") and char then
						local tool = player.Backpack:FindFirstChild(selWeapon)
						if tool then tool.Parent = char end
						char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
						VirtualInput:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
						wait(0.1)
						VirtualInput:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
					end
				end
				wait(0.3)
			end
		end)
	end)
end

-- Auto Tab
do
	local autoTab = contentFrames["Auto"]
	local delayBox = Instance.new("TextBox", autoTab)
	delayBox.Size = UDim2.new(0, 50, 0, 30)
	delayBox.Position = UDim2.new(0, 10, 0, 10)
	delayBox.Text = "0.1"
	delayBox.PlaceholderText = "Delay"

	local autoClick = false
	local btn = Instance.new("TextButton", autoTab)
	btn.Size = UDim2.new(0, 150, 0, 30)
	btn.Position = UDim2.new(0, 70, 0, 10)
	btn.Text = "Auto Click: OFF"
	btn.MouseButton1Click:Connect(function()
		autoClick = not autoClick
		btn.Text = "Auto Click: " .. (autoClick and "ON" or "OFF")
		task.spawn(function()
			while autoClick do
				VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
				VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
				wait(tonumber(delayBox.Text) or 0.1)
			end
		end)
	end)

	local keys = {"Z", "X", "C", "V"}
	for i, key in ipairs(keys) do
		local btn = Instance.new("TextButton", autoTab)
		btn.Size = UDim2.new(0, 100, 0, 30)
		btn.Position = UDim2.new(0, 10 + (i - 1) * 110, 0, 60)
		btn.Text = "Auto " .. key .. ": OFF"
		local active = false
		btn.MouseButton1Click:Connect(function()
			active = not active
			btn.Text = "Auto " .. key .. ": " .. (active and "ON" or "OFF")
			task.spawn(function()
				while active do
					VirtualInput:SendKeyEvent(true, Enum.KeyCode[key], false, game)
					VirtualInput:SendKeyEvent(false, Enum.KeyCode[key], false, game)
					wait(tonumber(delayBox.Text) or 1)
				end
			end)
		end)
	end
end

-- Teleport Tab
do
	local tpTab = contentFrames["Teleport"]
	local sea2Id = 13155198714
	local currentPlace = game.PlaceId
	local tpData = {
		["Starter Island"] = Vector3.new(3387, 138, 1716),
		["Clown Island"] = Vector3.new(3002, 144, -585),
		["Marine Island"] = Vector3.new(4930, 140, 35),
		["Lier Village"] = Vector3.new(5795, 177, 2330),
		["Baratee"] = Vector3.new(1422, 124, 2525),
		["Ar Longo Park"] = Vector3.new(466, 144, 526),
		["Lulue Town"] = Vector3.new(5786, 125, -3228),
		["Arena"] = Vector3.new(1319, 130, -808)
	}
	local row = 0
	if currentPlace ~= sea2Id then
		for name, pos in pairs(tpData) do
			local btn = Instance.new("TextButton", tpTab)
			btn.Size = UDim2.new(0, 180, 0, 25)
			btn.Position = UDim2.new(0, 10 + (row % 2) * 190, 0, 10 + math.floor(row / 2) * 30)
			btn.Text = name
			btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.MouseButton1Click:Connect(function()
				player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
			end)
			row += 1
		end
	end
end

-- Misc Tab
do
	local miscTab = contentFrames["Misc"]
	local function createBtn(text, y, callback)
		local btn = Instance.new("TextButton", miscTab)
		btn.Size = UDim2.new(0, 200, 0, 30)
		btn.Position = UDim2.new(0, 10, 0, y)
		btn.Text = text
		btn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.MouseButton1Click:Connect(callback)
	end

	createBtn("Rejoin Server", 10, function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
	end)

	createBtn("Gacha Fruit", 50, function()
		local g = workspace:FindFirstChild("Gacha")
		if g and g:FindFirstChild("ProximityPrompt") then
			fireproximityprompt(g.ProximityPrompt)
		end
	end)

	createBtn("Check Fruit Stock", 90, function()
		local gui = player:WaitForChild("PlayerGui")
		local stock = gui:FindFirstChild("Main") and gui.Main:FindFirstChild("Topbar") and gui.Main.Topbar:FindFirstChild("Stock")
		if stock then stock:Click() end
	end)
end

print("Chaos Hub Fully Loaded!")
