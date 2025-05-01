--// Chaos Hub GUI Full Structure
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Lib/main/Module.lua"))()
local Window = Library:CreateWindow({
    Name = "Chaos Hub | One Fruit Simulator",
    Themeable = {
        Info = "discord.gg/chaoshub",
    }
})

--// Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("Credits")
MainTab:CreateLabel("Script by Chaos")
MainTab:CreateLabel("UI Inspired by NexusHub")

--// Farm Options
local FarmOptionTab = Window:CreateTab("Farm Option", 4483362458)
local FarmOptSec = FarmOptionTab:CreateSection("Farm Settings")

FarmOptSec:CreateDropdown("Select Weapon Type", {"Melee", "Sword", "Gun", "Fruit"}, function(val)
    print("Weapon Type:", val)
end)

FarmOptSec:CreateDropdown("Character Position", {"Behind", "Above", "Front"}, function(val)
    print("Character Pos:", val)
end)

FarmOptSec:CreateSlider("Attack Distance", 1, 50, 10, function(val)
    print("Attack Distance:", val)
end)

FarmOptSec:CreateSlider("Skill Delay", 0, 10, 1, function(val)
    print("Skill Delay:", val)
end)

FarmOptSec:CreateToggle("Use Armament Haki", nil, function(state)
    print("Armament:", state)
end)

FarmOptSec:CreateToggle("Use Observation Haki", nil, function(state)
    print("Observation:", state)
end)

FarmOptSec:CreateToggle("Use Conqueror Haki", nil, function(state)
    print("Conqueror:", state)
end)

--// Farm Tab
local FarmTab = Window:CreateTab("Farm", 4483362458)
local FarmSection = FarmTab:CreateSection("Auto Farm")
FarmSection:CreateToggle("Enable Auto Farm", nil, function(v) end)

local RaidSection = FarmTab:CreateSection("Raid")
RaidSection:CreateToggle("Enable Raid", nil, function(v) end)

local LevelSection = FarmTab:CreateSection("Farm Level")
LevelSection:CreateToggle("Auto Farm by Level", nil, function(v) end)

--// Misc Tab
local MiscTab = Window:CreateTab("Misc", 4483362458)
local MiscSection = MiscTab:CreateSection("Misc Features")
MiscSection:CreateButton("Gacha Random Fruit", function() end)
MiscSection:CreateButton("Check Fruit Stock", function() end)
MiscSection:CreateButton("Anti AFK", function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

--// Teleport Tab
local TeleTab = MiscTab:CreateSection("Teleport")
TeleTab:CreateButton("Starter Island", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3387, 138, 1716)
end)
-- (Tambahkan tombol teleport lainnya sesuai daftarmu)

--// ESP Section (
