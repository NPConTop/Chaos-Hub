-- Chaos Hub - Full Blox Fruits Script -- Supports: Sea 1, Sea 2, Sea 3 -- Compatible: KRNL, Fluxus, Delta

local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local TeleportService = game:GetService("TeleportService") local RunService = game:GetService("RunService") local VirtualInput = game:GetService("VirtualInputManager") local VirtualUser = game:GetService("VirtualUser")

-- Anti AFK for _, v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end LocalPlayer.Idled:Connect(function() VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame) end)

-- Sea Detection local SeaName = "Unknown" local PlaceId = game.PlaceId if PlaceId == 2753915549 then SeaName = "Sea 1" elif PlaceId == 4442272183 then SeaName = "Sea 2" elif PlaceId == 7449423635 then SeaName = "Sea 3" end

-- GUI Setup local ScreenGui = Instance.new("ScreenGui", game.CoreGui) ScreenGui.Name = "ChaosHub_BloxFruit"

local ToggleButton = Instance.new("TextButton", ScreenGui) ToggleButton.Size = UDim2.new(0, 120, 0, 30) ToggleButton.Position = UDim2.new(0, 10, 0, 10) ToggleButton.Text = "Chaos Menu" ToggleButton.BackgroundColor3 = Color3.fromRGB(25,25,25) ToggleButton.TextColor3 = Color3.new(1,1,1)

local MainFrame = Instance.new("Frame", ScreenGui) MainFrame.Size = UDim2.new(0, 600, 0, 400) MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200) MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,40) MainFrame.Visible = true MainFrame.Active = true MainFrame.Draggable = true

ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Tabs & Navigation local Tabs = {"Main", "Auto", "Teleport", "Misc"} local Content = {}

local TabBar = Instance.new("Frame", MainFrame) TabBar.Size = UDim2.new(1, 0, 0, 30) TabBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)

for i, name in ipairs(Tabs) do local Btn = Instance.new("TextButton", TabBar) Btn.Size = UDim2.new(0, 150, 0, 30) Btn.Position = UDim2.new(0, (i - 1) * 150, 0, 0) Btn.Text = name Btn.BackgroundColor3 = Color3.fromRGB(55, 55, 80) Btn.TextColor3 = Color3.new(1,1,1)

local Frame = Instance.new("Frame", MainFrame)
Frame.Size = UDim2.new(1, 0, 1, -32)
Frame.Position = UDim2.new(0, 0, 0, 32)
Frame.BackgroundTransparency = 1
Frame.Visible = (i == 1)
Content[name] = Frame

Btn.MouseButton1Click:Connect(function()
    for _, f in pairs(Content) do f.Visible = false end
    Frame.Visible = true
end)

end

-- TODO: Fill in Main tab with Auto Farm level logic (next step) -- TODO: Auto tab: Auto click, auto skill Z/X/C/V -- TODO: Teleport tab: All islands by sea -- TODO: Misc tab: Rejoin, Fruit ESP, Gacha, Check stock

print("Chaos Hub Blox Fruit - GUI Initialized in "..SeaName)

