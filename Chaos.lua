-- Chaos Hub v3 - Final Version
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

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ChaosHub"
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

local menuBtn = Instance.new("TextButton", gui)
menuBtn.Size = UDim2.new(0, 100, 0, 30)
menuBtn.Position = UDim2.new(0, 20, 0, 20)
menuBtn.Text = "Menu"
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

-- Main Tab (Auto Farm Level)
do
	local mainTab = contentFrames["Main"]
	local label = Instance.new("TextLabel", mainTab)
	label.Size = UDim2.new(1, 0, 0, 30)
	label.Text = "Auto Farm Leveling System"
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)

	local function getIslandByLevel(level)
		local islands = {
			{0,35,"Starter Island"},{35,75,"Jungle Island"},{75,120,"Clown Island"},{120,170,"Marine Island"},
			{170,215,"Lier Village"},{215,275,"Baratee"},{275,400,"Ar Longo Park"},{400,600,"Lulue Town"},
			{600,680,"Bounty Island"},{680,800,"Brum Island"},{800,950,"Little Island"},{950,1350,"Desert Island"},
			{1350,1575,"Paya Island"},{1575,2050,"Sky Island"},{2050,2300,"G88 Base"},{2300,2800,"Long Island"},
			{2800,3800,"Water 77"},{3800,5000,"Denies Lobby"},{5000,6500,"Night Castle"},{6500,8000,"Bubble Island"},
			{8000,9250,"Abazon Lily"},{9250,10500,"World Prison"},{10500,12500,"Marine Base"},
			{12500,14000,"Fishman Island"},{14000,18000,"Hazard Island"},{18000,30000,"Rose Kingdom"},
			{30000,36000,"Turtle Island"},{36000,46000,"Cake Island"},{46000,52000,"Tea Island"},
			{52000,58000,"Flower Country"},{58000,62000,"Oni Island"},{62000,70000,"Pirate Island"},
			{70000,82000,"Egghead Island"},{82000,87500,"Desert Island (Sea 3)"}
		}
		for _, i in ipairs(islands) do
			if level >= i[1] and level < i[2] then return i[3] end
		end
		return nil
	end

	local autoLevel = false
	local button = Instance.new("TextButton", mainTab)
	button.Size = UDim2.new(0, 200, 0, 30)
	button.Position = UDim2.new(0, 10, 0, 40)
	button.Text = "Auto Farm Level: OFF"
	button.BackgroundColor3 = Color3.fromRGB(50, 70, 50)
	button.TextColor3 = Color3.new(1, 1, 1)

	button.MouseButton1Click:Connect(function()
		autoLevel = not autoLevel
		button.Text = "Auto Farm Level: " .. (autoLevel and "ON" or "OFF")
		task.spawn(function()
			while autoLevel do
				pcall(function()
					local lv = player:WaitForChild("DataFolder"):WaitForChild("Level").Value
					local island = getIslandByLevel(lv)
					if island then
						for _, v in pairs(workspace:GetDescendants()) do
							if v:IsA("Model") and v.Name == island and v:FindFirstChild("HumanoidRootPart") then
								player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
								break
							end
						end
					end
				end)
				wait(3)
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

	for i, key in ipairs({"Z","X","C","V"}) do
		local b = Instance.new("TextButton", autoTab)
		b.Size = UDim2.new(0, 100, 0, 30)
		b.Position = UDim2.new(0, 10 + (i-1)*110, 0, 60)
		b.Text = "Auto "..key..": OFF"
		local state = false
		b.MouseButton1Click:Connect(function()
			state = not state
			b.Text = "Auto "..key..": "..(state and "ON" or "OFF")
			task.spawn(function()
				while state do
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
	local tab = contentFrames["Teleport"]
	local sea2Id = 13155198714
	local sea3Id = 14862674911
	local pid = game.PlaceId

	local tpList = {
		["Starter Island"] = Vector3.new(3387, 138, 1716),
		["Clown Island"] = Vector3.new(3002, 144, -585),
		["Marine Island"] = Vector3.new(4930, 140, 35),
		["Lier Village"] = Vector3.new(5795, 177, 2330),
		["Baratee"] = Vector3.new(1422, 124, 2525),
		["Ar Longo Park"] = Vector3.new(466, 144, 526),
		["Lulue Town"] = Vector3.new(5786, 125, -3228),
		["Arena"] = Vector3.new(1319, 130, -808),
		["Bounty Island"] = Vector3.new(100, 50, 200),
		["Brum Island"] = Vector3.new(200, 50, 200)
	}
	local row = 0
	for name, pos in pairs(tpList) do
		if (pid == sea2Id and string.find(name, "Island")) or (pid ~= sea2Id and not string.find(name, "Bounty")) then
			local btn = Instance.new("TextButton", tab)
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
	local misc = contentFrames["Misc"]
	local function makeBtn(text, y, callback)
		local b = Instance.new("TextButton", misc)
		b.Size = UDim2.new(0, 200, 0, 30)
		b.Position = UDim2.new(0, 10, 0, y)
		b.Text = text
		b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		b.TextColor3 = Color3.new(1, 1, 1)
		b.MouseButton1Click:Connect(callback)
	end

	makeBtn("Rejoin Server", 10, function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
	end)

	makeBtn("Gacha Fruit", 50, function()
		local g = workspace:FindFirstChild("Gacha")
		if g and g:FindFirstChild("ProximityPrompt") then
			fireproximityprompt(g.ProximityPrompt)
		end
	end)

	makeBtn("Check Fruit Stock", 90, function()
		local gui = player:WaitForChild("PlayerGui")
		local s = gui:FindFirstChild("Main")
		if s and s:FindFirstChild("Topbar") and s.Topbar:FindFirstChild("Stock") then
			s.Topbar.Stock:Click()
		end
	end)
end

print("Chaos Hub v3 Loaded!")
