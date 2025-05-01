-- Chaos Hub - Real Working Version (Final)
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- Anti AFK
for _, c in pairs(getconnections(player.Idled)) do c:Disable() end
player.Idled:Connect(function()
	VirtualUser:Button1Down(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ChaosHub"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,35)
mainFrame.Active = true
mainFrame.Draggable = true

-- Toggle Button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,100,0,30)
toggleBtn.Position = UDim2.new(0,20,0,20)
toggleBtn.Text = "Chaos Menu"
toggleBtn.BackgroundColor3 = Color3.fromRGB(15,15,25)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Tabs
local tabNames = {"Main", "Auto", "Teleport", "Misc"}
local tabFrames = {}
local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.BackgroundColor3 = Color3.fromRGB(35,35,45)

for i, name in ipairs(tabNames) do
	local tabBtn = Instance.new("TextButton", tabBar)
	tabBtn.Size = UDim2.new(0, 150, 0, 30)
	tabBtn.Position = UDim2.new(0, (i-1)*150, 0, 0)
	tabBtn.Text = name
	tabBtn.BackgroundColor3 = Color3.fromRGB(45,45,60)
	tabBtn.TextColor3 = Color3.fromRGB(255,255,255)

	local content = Instance.new("Frame", mainFrame)
	content.Size = UDim2.new(1, 0, 1, -30)
	content.Position = UDim2.new(0, 0, 0, 30)
	content.BackgroundTransparency = 1
	content.Visible = i == 1
	tabFrames[name] = content

	tabBtn.MouseButton1Click:Connect(function()
		for _, f in pairs(tabFrames) do f.Visible = false end
		content.Visible = true
	end)
end

-- MAIN TAB
do
	local f = tabFrames["Main"]
	local selectedMob, selectedWeapon = nil, nil

	local refreshBtn = Instance.new("TextButton", f)
	refreshBtn.Size = UDim2.new(0, 200, 0, 30)
	refreshBtn.Position = UDim2.new(0, 10, 0, 10)
	refreshBtn.Text = "Refresh Mob List"
	local mobList = {}

	refreshBtn.MouseButton1Click:Connect(function()
		mobList = {}
		for _, folder in pairs(workspace:GetChildren()) do
			if folder:IsA("Folder") then
				for _, mob in pairs(folder:GetChildren()) do
					if mob:IsA("Model") and mob:FindFirstChild("Humanoid") then
						table.insert(mobList, mob.Name)
					end
				end
			end
		end
	end)

	local mobBtn = Instance.new("TextButton", f)
	mobBtn.Size = UDim2.new(0, 200, 0, 30)
	mobBtn.Position = UDim2.new(0, 10, 0, 50)
	mobBtn.Text = "Select Mob"
	mobBtn.MouseButton1Click:Connect(function()
		if #mobList > 0 then
			selectedMob = mobList[1]
			mobBtn.Text = "Mob: "..selectedMob
		end
	end)

	local weaponBtn = Instance.new("TextButton", f)
	weaponBtn.Size = UDim2.new(0, 200, 0, 30)
	weaponBtn.Position = UDim2.new(0, 10, 0, 90)
	weaponBtn.Text = "Select Weapon"
	weaponBtn.MouseButton1Click:Connect(function()
		for _, tool in pairs(player.Backpack:GetChildren()) do
			if tool:IsA("Tool") then
				selectedWeapon = tool.Name
				weaponBtn.Text = "Weapon: "..selectedWeapon
				break
			end
		end
	end)

	local farming = false
	local startBtn = Instance.new("TextButton", f)
	startBtn.Size = UDim2.new(0, 200, 0, 30)
	startBtn.Position = UDim2.new(0, 10, 0, 130)
	startBtn.Text = "Auto Farm: OFF"
	startBtn.MouseButton1Click:Connect(function()
		farming = not farming
		startBtn.Text = "Auto Farm: "..(farming and "ON" or "OFF")
		task.spawn(function()
			while farming do
				pcall(function()
					local mob = workspace:FindFirstChild(selectedMob) or workspace.Common:FindFirstChild(selectedMob)
					local char = player.Character
					if mob and mob:FindFirstChild("HumanoidRootPart") and char and char:FindFirstChild("HumanoidRootPart") then
						local tool = player.Backpack:FindFirstChild(selectedWeapon)
						if tool then tool.Parent = char end
						char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
						VirtualUser:Button1Down(Vector2.new(), workspace.CurrentCamera.CFrame)
						wait(0.1)
						VirtualUser:Button1Up(Vector2.new(), workspace.CurrentCamera.CFrame)
					end
				end)
				wait(0.3)
			end
		end)
	end)
end

-- AUTO TAB
do
	local f = tabFrames["Auto"]
	local delay = 0.1

	local delayBox = Instance.new("TextBox", f)
	delayBox.Size = UDim2.new(0, 50, 0, 30)
	delayBox.Position = UDim2.new(0, 10, 0, 10)
	delayBox.Text = tostring(delay)

	local keys = {"Z", "X", "C", "V"}
	for i, key in ipairs(keys) do
		local btn = Instance.new("TextButton", f)
		btn.Size = UDim2.new(0, 100, 0, 30)
		btn.Position = UDim2.new(0, 10 + (i-1)*110, 0, 50)
		btn.Text = "Auto "..key..": OFF"
		local state = false
		btn.MouseButton1Click:Connect(function()
			state = not state
			btn.Text = "Auto "..key..": "..(state and "ON" or "OFF")
			task.spawn(function()
				while state do
					VirtualUser:SendKeyEvent(true, Enum.KeyCode[key], false, game)
					wait(0.05)
					VirtualUser:SendKeyEvent(false, Enum.KeyCode[key], false, game)
					wait(tonumber(delayBox.Text) or 1)
				end
			end)
		end)
	end
end

-- TELEPORT TAB
do
	local f = tabFrames["Teleport"]
	local locations = {
		["Starter Island"] = Vector3.new(3387, 138, 1716),
		["Clown Island"] = Vector3.new(3002, 144, -585),
		["Marine Island"] = Vector3.new(4930, 140, 35),
		["Lier Village"] = Vector3.new(5795, 177, 2330),
		["Baratee"] = Vector3.new(1422, 124, 2525),
		["Ar Longo Park"] = Vector3.new(466, 144, 526),
		["Lulue Town"] = Vector3.new(5786, 125, -3228),
		["Arena"] = Vector3.new(1319, 130, -808)
	}
	local i = 0
	for name, pos in pairs(locations) do
		local btn = Instance.new("TextButton", f)
		btn.Size = UDim2.new(0, 200, 0, 30)
		btn.Position = UDim2.new(0, 10, 0, 10 + i*35)
		btn.Text = name
		btn.MouseButton1Click:Connect(function()
			player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(pos)
		end)
		i += 1
	end
end

-- MISC TAB
do
	local f = tabFrames["Misc"]
	local function btn(text, y, callback)
		local b = Instance.new("TextButton", f)
		b.Size = UDim2.new(0, 200, 0, 30)
		b.Position = UDim2.new(0, 10, 0, y)
		b.Text = text
		b.MouseButton1Click:Connect(callback)
	end

	btn("Rejoin", 10, function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
	end)

	btn("Gacha Fruit", 50, function()
		local g = workspace:FindFirstChild("Gacha")
		if g and g:FindFirstChild("ProximityPrompt") then
			fireproximityprompt(g.ProximityPrompt)
		end
	end)

	btn("Check Stock Fruit", 90, function()
		local gui = player:WaitForChild("PlayerGui")
		local stock = gui:FindFirstChild("Main") and gui.Main:FindFirstChild("Topbar") and gui.Main.Topbar:FindFirstChild("Stock")
		if stock then stock:Click() end
	end)
end

print("Chaos Hub Real Working Version Loaded.")
