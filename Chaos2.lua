-- Blade Ball Chaos Script (OMG-Style)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local vim = game:GetService("VirtualInputManager")

-- Anti Stun
if player.Character:FindFirstChild("Stunned") then
	player.Character.Stunned:Destroy()
end
player.Character.ChildAdded:Connect(function(child)
	if child.Name == "Stunned" then
		child:Destroy()
	end
end)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BladeBallHub"

local menuBtn = Instance.new("TextButton", gui)
menuBtn.Size = UDim2.new(0, 100, 0, 30)
menuBtn.Position = UDim2.new(0, 20, 0, 20)
menuBtn.Text = "Menu"
menuBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
menuBtn.TextColor3 = Color3.new(1,1,1)

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true

menuBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Tabs & Layout
local tabNames = {"Main", "ESP"}
local contentFrames = {}

local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)

for i, name in ipairs(tabNames) do
	local tabBtn = Instance.new("TextButton", tabBar)
	tabBtn.Size = UDim2.new(0, 100, 0, 30)
	tabBtn.Position = UDim2.new(0, (i - 1) * 100, 0, 0)
	tabBtn.Text = name
	tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	tabBtn.TextColor3 = Color3.new(1, 1, 1)

	local content = Instance.new("Frame", mainFrame)
	content.Size = UDim2.new(1, 0, 1, -30)
	content.Position = UDim2.new(0, 0, 0, 30)
	content.BackgroundTransparency = 1
	content.Visible = (i == 1)
	contentFrames[name] = content

	tabBtn.MouseButton1Click:Connect(function()
		for _, f in pairs(contentFrames) do f.Visible = false end
		content.Visible = true
	end)
end

-- Main Tab: Auto Parry & Auto Block
do
	local main = contentFrames["Main"]
	local autoParry = false
	local autoBlock = false
	local blockKey = Enum.KeyCode.E

	local function makeToggle(text, y, stateCallback)
		local btn = Instance.new("TextButton", main)
		btn.Size = UDim2.new(0, 200, 0, 30)
		btn.Position = UDim2.new(0, 20, 0, y)
		btn.Text = text .. ": OFF"
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
		btn.TextColor3 = Color3.new(1, 1, 1)
		local on = false
		btn.MouseButton1Click:Connect(function()
			on = not on
			btn.Text = text .. ": " .. (on and "ON" or "OFF")
			stateCallback(on)
		end)
	end

	makeToggle("Auto Parry", 10, function(state)
		autoParry = state
		while autoParry do
			pcall(function()
				local ball = workspace:FindFirstChild("Ball")
				local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if ball and hrp then
					local dist = (ball.Position - hrp.Position).Magnitude
					if dist < 30 then
						vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
						task.wait(0.1)
						vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
					end
				end
			end)
			task.wait(0.1)
		end
	end)

	makeToggle("Auto Block", 50, function(state)
		autoBlock = state
		while autoBlock do
			vim:SendKeyEvent(true, blockKey, false, game)
			task.wait(0.2)
			vim:SendKeyEvent(false, blockKey, false, game)
			task.wait(0.2)
		end
	end)

	local keyDropdown = Instance.new("TextButton", main)
	keyDropdown.Size = UDim2.new(0, 200, 0, 30)
	keyDropdown.Position = UDim2.new(0, 20, 0, 90)
	keyDropdown.Text = "Block Key: E"
	keyDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
	keyDropdown.TextColor3 = Color3.new(1, 1, 1)

	keyDropdown.MouseButton1Click:Connect(function()
		local options = {Enum.KeyCode.E, Enum.KeyCode.F, Enum.KeyCode.Q}
		local nextIndex = (table.find(options, blockKey) % #options) + 1
		blockKey = options[nextIndex]
		keyDropdown.Text = "Block Key: " .. blockKey.Name
	end)
end

-- ESP Tab
do
	local tab = contentFrames["ESP"]
	local playerESP = false
	local ballESP = false

	local function createESP(name, y, callback)
		local btn = Instance.new("TextButton", tab)
		btn.Size = UDim2.new(0, 200, 0, 30)
		btn.Position = UDim2.new(0, 20, 0, y)
		btn.Text = name .. ": OFF"
		btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
		btn.TextColor3 = Color3.new(1, 1, 1)
		local state = false
		btn.MouseButton1Click:Connect(function()
			state = not state
			btn.Text = name .. ": " .. (state and "ON" or "OFF")
			callback(state)
		end)
	end

	createESP("Ball ESP", 10, function(state)
		ballESP = state
		while ballESP do
			pcall(function()
				local ball = workspace:FindFirstChild("Ball")
				if ball and not ball:FindFirstChild("ESP") then
					local bill = Instance.new("BillboardGui", ball)
					bill.Name = "ESP"
					bill.Size = UDim2.new(0,100,0,40)
					bill.AlwaysOnTop = true
					local txt = Instance.new("TextLabel", bill)
					txt.Size = UDim2.new(1,0,1,0)
					txt.BackgroundTransparency = 1
					txt.Text = "BALL"
					txt.TextColor3 = Color3.new(1,0,0)
					txt.TextScaled = true
				end
			end)
			task.wait(1)
		end
	end)

	createESP("Player ESP", 50, function(state)
		playerESP = state
		while playerESP do
			for _,plr in pairs(Players:GetPlayers()) do
				if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") and not plr.Character.Head:FindFirstChild("ESP") then
					local bill = Instance.new("BillboardGui", plr.Character.Head)
					bill.Name = "ESP"
					bill.Size = UDim2.new(0,100,0,40)
					bill.AlwaysOnTop = true
					local txt = Instance.new("TextLabel", bill)
					txt.Size = UDim2.new(1,0,1,0)
					txt.BackgroundTransparency = 1
					txt.Text = plr.DisplayName
					txt.TextColor3 = Color3.new(0,1,0)
					txt.TextScaled = true
				end
			end
			task.wait(1)
		end
	end)
end

print("Blade Ball Chaos GUI Loaded")
