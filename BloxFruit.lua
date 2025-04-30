-- Blox Fruits Full GUI Hub - by ChatGPT
local Players = game:GetService("Players")
local VirtualInput = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- Anti AFK
for _,v in pairs(getconnections(player.Idled)) do v:Disable() end
player.Idled:Connect(function()
	VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Screen GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BloxFruitsHub"
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 600, 0, 400)
main.Position = UDim2.new(0.5, -300, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
main.Active = true
main.Draggable = true

-- Toggle Button
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 100, 0, 30)
toggle.Position = UDim2.new(0, 20, 0, 20)
toggle.Text = "Menu"
toggle.BackgroundColor3 = Color3.fromRGB(15,15,25)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- Tabs
local tabs = {"Main", "Auto", "Teleport", "Misc"}
local contentFrames = {}
for i, name in ipairs(tabs) do
	local btn = Instance.new("TextButton", main)
	btn.Size = UDim2.new(0, 120, 0, 30)
	btn.Position = UDim2.new(0, (i-1)*125, 0, 0)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
	btn.TextColor3 = Color3.new(1,1,1)

	local frame = Instance.new("Frame", main)
	frame.Size = UDim2.new(1,0,1,-30)
	frame.Position = UDim2.new(0,0,0,30)
	frame.BackgroundTransparency = 1
	frame.Visible = (i == 1)
	contentFrames[name] = frame

	btn.MouseButton1Click:Connect(function()
		for _, f in pairs(contentFrames) do f.Visible = false end
		frame.Visible = true
	end)
end

-- Auto Farm Main Tab
do
	local tab = contentFrames["Main"]
	local mobList, selMob, selWeapon = {}, nil, nil

	local mobBtn = Instance.new("TextButton", tab)
	mobBtn.Position = UDim2.new(0, 10, 0, 10)
	mobBtn.Size = UDim2.new(0, 200, 0, 30)
	mobBtn.Text = "Refresh NPC"
	mobBtn.MouseButton1Click:Connect(function()
		mobList = {}
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Model") and v:FindFirstChild("Humanoid") then
				if not table.find(mobList, v.Name) then
					table.insert(mobList, v.Name)
				end
			end
		end
	end)

	local mobDrop = Instance.new("TextButton", tab)
	mobDrop.Position = UDim2.new(0, 10, 0, 50)
	mobDrop.Size = UDim2.new(0, 200, 0, 30)
	mobDrop.Text = "Select Mob"
	mobDrop.MouseButton1Click:Connect(function()
		if #mobList > 0 then
			selMob = mobList[1]
			mobDrop.Text = selMob
		end
	end)

	local weapDrop = Instance.new("TextButton", tab)
	weapDrop.Position = UDim2.new(0, 10, 0, 90)
	weapDrop.Size = UDim2.new(0, 200, 0, 30)
	weapDrop.Text = "Select Weapon"
	weapDrop.MouseButton1Click:Connect(function()
		for _, tool in pairs(player.Backpack:GetChildren()) do
			if tool:IsA("Tool") then
				selWeapon = tool.Name
				weapDrop.Text = selWeapon
				break
			end
		end
	end)

	local farming = false
	local afBtn = Instance.new("TextButton", tab)
	afBtn.Position = UDim2.new(0, 10, 0, 130)
	afBtn.Size = UDim2.new(0, 200, 0, 30)
	afBtn.Text = "Auto Farm: OFF"
	afBtn.MouseButton1Click:Connect(function()
		farming = not farming
		afBtn.Text = "Auto Farm: "..(farming and "ON" or "OFF")
		task.spawn(function()
			while farming do
				if selMob and selWeapon then
					local mob = workspace:FindFirstChild(selMob)
					local char = player.Character
					if mob and char and mob:FindFirstChild("HumanoidRootPart") then
						local tool = player.Backpack:FindFirstChild(selWeapon)
						if tool then tool.Parent = char end
						char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,-5)
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
	local tab = contentFrames["Auto"]

	local delayBox = Instance.new("TextBox", tab)
	delayBox.Position = UDim2.new(0, 10, 0, 10)
	delayBox.Size = UDim2.new(0, 50, 0, 30)
	delayBox.Text = "0.1"

	local acBtn = Instance.new("TextButton", tab)
	acBtn.Position = UDim2.new(0, 70, 0, 10)
	acBtn.Size = UDim2.new(0, 120, 0, 30)
	acBtn.Text = "Auto Click: OFF"
	local active = false
	acBtn.MouseButton1Click:Connect(function()
		active = not active
		acBtn.Text = "Auto Click: " .. (active and "ON" or "OFF")
		task.spawn(function()
			while active do
				VirtualInput:SendMouseButtonEvent(0,0,0,true,game,0)
				VirtualInput:SendMouseButtonEvent(0,0,0,false,game,0)
				wait(tonumber(delayBox.Text) or 0.1)
			end
		end)
	end)

	local keys = {"Z", "X", "C", "V"}
	for i, key in ipairs(keys) do
		local b = Instance.new("TextButton", tab)
		b.Position = UDim2.new(0, 10 + (i-1)*110, 0, 60)
		b.Size = UDim2.new(0, 100, 0, 30)
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
	local islands = {
		["Starter Island"] = Vector3.new(1056, 20, 1193),
		["Jungle"] = Vector3.new(-1290, 12, 434),
		["Desert"] = Vector3.new(1148, 12, -4328),
		["Sky Island"] = Vector3.new(-4921, 700, -2626)
	}
	local row = 0
	for name, pos in pairs(islands) do
		local b = Instance.new("TextButton", tab)
		b.Size = UDim2.new(0, 200, 0, 30)
		b.Position = UDim2.new(0, 10, 0, 10 + row * 35)
		b.Text = name
		b.MouseButton1Click:Connect(function()
			player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
		end)
		row += 1
	end
end

-- Misc Tab
do
	local tab = contentFrames["Misc"]
	local function btn(text, y, callback)
		local b = Instance.new("TextButton", tab)
		b.Text = text
		b.Position = UDim2.new(0, 10, 0, y)
		b.Size = UDim2.new(0, 200, 0, 30)
		b.MouseButton1Click:Connect(callback)
	end

	btn("Rejoin Server", 10, function()
		TeleportService:Teleport(game.PlaceId, player)
	end)

	btn("Reset Character", 50, function()
		player.Character:BreakJoints()
	end)

	btn("Check Stock Fruit", 90, function()
		local gui = player:WaitForChild("PlayerGui")
		local stock = gui:FindFirstChild("Main") and gui.Main:FindFirstChild("Topbar") and gui.Main.Topbar:FindFirstChild("Stock")
		if stock then stock:Click() end
	end)
end

print("Blox Fruits Hub Loaded!")
