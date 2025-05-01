-- Chaos Hub - Final Version (Real Working)
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- Anti AFK
for _, c in pairs(getconnections(player.Idled)) do c:Disable() end
player.Idled:Connect(function()
	VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
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

-- Menu Toggle
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
local tabs = {"Main", "Auto", "Teleport", "Misc"}
local tabFrames = {}

local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.BackgroundColor3 = Color3.fromRGB(35,35,45)

for i, name in ipairs(tabs) do
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

-- MAIN TAB (Auto Farm)
do
	local frame = tabFrames["Main"]
	local mob, weapon = nil, nil

	local mobBtn = Instance.new("TextButton", frame)
	mobBtn.Size = UDim2.new(0, 200, 0, 30)
	mobBtn.Position = UDim2.new(0, 10, 0, 10)
	mobBtn.Text = "Select Mob"
	mobBtn.MouseButton1Click:Connect(function()
		for _, m in pairs(workspace:GetDescendants()) do
			if m:IsA("Model") and m:FindFirstChild("Humanoid") then
				mob = m.Name
				mobBtn.Text = "Mob: "..mob
				break
			end
		end
	end)

	local weaponBtn = Instance.new("TextButton", frame)
	weaponBtn.Size = UDim2.new(0, 200, 0, 30)
	weaponBtn.Position = UDim2.new(0, 10, 0, 50)
	weaponBtn.Text = "Select Weapon"
	weaponBtn.MouseButton1Click:Connect(function()
		for _, tool in pairs(player.Backpack:GetChildren()) do
			if tool:IsA("Tool") then
				weapon = tool.Name
				weaponBtn.Text = "Weapon: "..weapon
				break
			end
		end
	end)

	local afToggle = Instance.new("TextButton", frame)
	afToggle.Size = UDim2.new(0, 200, 0, 30)
	afToggle.Position = UDim2.new(0, 10, 0, 90)
	afToggle.Text = "Auto Farm: OFF"
	local afState = false
	afToggle.MouseButton1Click:Connect(function()
		afState = not afState
		afToggle.Text = "Auto Farm: " .. (afState and "ON" or "OFF")
		while afState do
			pcall(function()
				local m = workspace:FindFirstChild(mob)
				local c = player.Character
				if m and m:FindFirstChild("HumanoidRootPart") and c and c:FindFirstChild("HumanoidRootPart") then
					c.HumanoidRootPart.CFrame = m.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
					local t = player.Backpack:FindFirstChild(weapon)
					if t then t.Parent = c end
					VirtualUser:Button1Down(Vector2.new(), workspace.CurrentCamera.CFrame)
					wait(0.1)
					VirtualUser:Button1Up(Vector2.new(), workspace.CurrentCamera.CFrame)
				end
			end)
			wait(0.3)
		end
	end)
end

-- AUTO TAB (Auto Click, Auto Skill)
do
	local frame = tabFrames["Auto"]
	local delay = 0.1

	local delayBox = Instance.new("TextBox", frame)
	delayBox.Size = UDim2.new(0, 50, 0, 30)
	delayBox.Position = UDim2.new(0, 10, 0, 10)
	delayBox.Text = tostring(delay)

	local keys = {"Z", "X", "C", "V"}
	for i, key in ipairs(keys) do
		local btn = Instance.new("TextButton", frame)
		btn.Size = UDim2.new(0, 100, 0, 30)
		btn.Position = UDim2.new(0, 10 + (i-1)*110, 0, 50)
		btn.Text = "Auto "..key..": OFF"
		local state = false
		btn.MouseButton1Click:Connect(function()
			state = not state
			btn.Text = "Auto "..key..": "..(state and "ON" or "OFF")
			while state do
				VirtualUser:SendKeyEvent(true, Enum.KeyCode[key], false, game)
				wait(0.05)
				VirtualUser:SendKeyEvent(false, Enum.KeyCode[key], false, game)
				wait(tonumber(delayBox.Text) or 1)
			end
		end)
	end
end

-- TELEPORT TAB
do
	local frame = tabFrames["Teleport"]
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
		local btn = Instance.new("TextButton", frame)
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
	local frame = tabFrames["Misc"]
	local function btn(text, y, callback)
		local b = Instance.new("TextButton", frame)
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

print("Chaos Hub Final Loaded (Working Version)")
