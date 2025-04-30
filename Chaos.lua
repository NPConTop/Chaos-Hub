-- Chaos Hub v2.0 - Full GUI with Features (English)

local Players = game:GetService("Players") local TeleportService = game:GetService("TeleportService") local VirtualUser = game:GetService("VirtualUser") local VirtualInput = game:GetService("VirtualInputManager") local player = Players.LocalPlayer

-- Anti AFK for _, v in pairs(getconnections(player.Idled)) do v:Disable() end player.Idled:Connect(function() VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame) end)

-- GUI Setup local gui = Instance.new("ScreenGui", game:FindFirstChildOfClass("CoreGui")) gui.Name = "ChaosHub"

local mainFrame = Instance.new("Frame", gui) mainFrame.Size = UDim2.new(0, 700, 0, 450) mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225) mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40) mainFrame.Active = true mainFrame.Draggable = true

local topBar = Instance.new("Frame", mainFrame) topBar.Size = UDim2.new(1, 0, 0, 30) topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)

local line = Instance.new("Frame", mainFrame) line.Size = UDim2.new(1, 0, 0, 2) line.Position = UDim2.new(0, 0, 0, 30) line.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

local tabs = {"Main", "Auto", "Teleport", "Misc"} local contentFrames = {}

for i, name in ipairs(tabs) do local btn = Instance.new("TextButton", topBar) btn.Size = UDim2.new(1 / #tabs, -2, 1, -2) btn.Position = UDim2.new((i - 1) / #tabs, 2, 0, 2) btn.Text = name btn.Font = Enum.Font.Gotham btn.TextSize = 14 btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50) btn.TextColor3 = Color3.fromRGB(200, 200, 200)

local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1, 0, 1, -32)
content.Position = UDim2.new(0, 0, 0, 32)
content.BackgroundTransparency = 1
content.Visible = (i == 1)
contentFrames[name] = content

btn.MouseButton1Click:Connect(function()
	for _, frame in pairs(contentFrames) do frame.Visible = false end
	content.Visible = true
end)

end

-- Main Tab (Auto Farm) do local tab = contentFrames["Main"] local label = Instance.new("TextLabel", tab) label.Text = "Auto Farm by Island" label.Size = UDim2.new(0, 300, 0, 30) label.Position = UDim2.new(0, 10, 0, 10) label.BackgroundTransparency = 1 label.TextColor3 = Color3.new(1, 1, 1) label.TextXAlignment = Enum.TextXAlignment.Left

local mob, weapon, farmOn = nil, nil, false

local mobBtn = Instance.new("TextButton", tab)
mobBtn.Size = UDim2.new(0, 150, 0, 30)
mobBtn.Position = UDim2.new(0, 10, 0, 50)
mobBtn.Text = "Select Mob"
mobBtn.MouseButton1Click:Connect(function()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") then
			mob = v.Name
			mobBtn.Text = "Mob: " .. mob
			break
		end
	end
end)

local weaponBtn = Instance.new("TextButton", tab)
weaponBtn.Size = UDim2.new(0, 150, 0, 30)
weaponBtn.Position = UDim2.new(0, 170, 0, 50)
weaponBtn.Text = "Select Weapon"
weaponBtn.MouseButton1Click:Connect(function()
	for _, v in pairs(player.Backpack:GetChildren()) do
		if v:IsA("Tool") then
			weapon = v.Name
			weaponBtn.Text = "Weapon: " .. weapon
			break
		end
	end
end)

local toggleBtn = Instance.new("TextButton", tab)
toggleBtn.Size = UDim2.new(0, 150, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 90)
toggleBtn.Text = "Auto Farm: OFF"
toggleBtn.MouseButton1Click:Connect(function()
	farmOn = not farmOn
	toggleBtn.Text = "Auto Farm: " .. (farmOn and "ON" or "OFF")
	spawn(function()
		while farmOn do
			if mob and weapon then
				local target = workspace:FindFirstChild(mob)
				local tool = player.Backpack:FindFirstChild(weapon)
				if target and tool then
					tool.Parent = player.Character
					player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
					VirtualInput:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
					VirtualInput:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
				end
			end
			wait(0.3)
		end
	end)
end)

end

-- Auto Tab local auto = contentFrames["Auto"] local autoClick = false local delayBox = Instance.new("TextBox", auto) delayBox.Size = UDim2.new(0, 50, 0, 30) delayBox.Position = UDim2.new(0, 10, 0, 10) delayBox.Text = "0.1" delayBox.PlaceholderText = "Delay"

local clickBtn = Instance.new("TextButton", auto) clickBtn.Size = UDim2.new(0, 150, 0, 30) clickBtn.Position = UDim2.new(0, 70, 0, 10) clickBtn.Text = "Auto Click: OFF" clickBtn.MouseButton1Click:Connect(function() autoClick = not autoClick clickBtn.Text = "Auto Click: " .. (autoClick and "ON" or "OFF") spawn(function() while autoClick do VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0) VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0) wait(tonumber(delayBox.Text) or 0.1) end end) end)

local keys = {"Z", "X", "C", "V"} for i, key in ipairs(keys) do local btn = Instance.new("TextButton", auto) btn.Size = UDim2.new(0, 100, 0, 30) btn.Position = UDim2.new(0, 10 + (i - 1) * 110, 0, 50) btn.Text = "Auto " .. key .. ": OFF" local on = false btn.MouseButton1Click:Connect(function() on = not on btn.Text = "Auto " .. key .. ": " .. (on and "ON" or "OFF") spawn(function() while on do VirtualInput:SendKeyEvent(true, Enum.KeyCode[key], false, game) VirtualInput:SendKeyEvent(false, Enum.KeyCode[key], false, game) wait(tonumber(delayBox.Text) or 1) end end) end) end

-- Teleport Tab local tpTab = contentFrames["Teleport"] local positions = { ["Starter Island"] = Vector3.new(3387, 138, 1716), ["Clown Island"] = Vector3.new(3002, 144, -585), ["Marine Island"] = Vector3.new(4930, 140, 35), ["Lier Village"] = Vector3.new(5795, 177, 2330), ["Baratee"] = Vector3.new(1422, 124, 2525), ["Ar Longo Park"] = Vector3.new(466, 144, 526), ["Lulue Town"] = Vector3.new(5786, 125, -3228), ["Arena"] = Vector3.new(1319, 130, -808) }

local y = 10 for name, pos in pairs(positions) do local btn = Instance.new("TextButton", tpTab) btn.Size = UDim2.new(0, 180, 0, 25) btn.Position = UDim2.new(0, 10, 0, y) btn.Text = name btn.MouseButton1Click:Connect(function() if player.Character then player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(pos) end end) y += 30 end

-- Misc Tab local misc = contentFrames["Misc"] local function makeMiscBtn(text, y, func) local btn = Instance.new("TextButton", misc) btn.Size = UDim2.new(0, 200, 0, 30) btn.Position = UDim2.new(0, 10, 0, y) btn.Text = text btn.MouseButton1Click:Connect(func) end

makeMiscBtn("Rejoin Server", 10, function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end)

makeMiscBtn("Random Fruit (Gacha)", 50, function() local g = workspace:FindFirstChild("Gacha") if g and g:FindFirstChild("ProximityPrompt") then fireproximityprompt(g.ProximityPrompt) end end)

makeMiscBtn("Check Fruit Stock", 90, function() local gui = player:WaitForChild("PlayerGui") local btn = gui:FindFirstChild("Main") and gui.Main:FindFirstChild("Topbar") and gui.Main.Topbar:FindFirstChild("Stock") if btn then btn:Click() end end)

print("Chaos Hub v2.0 Fully Loaded!")
