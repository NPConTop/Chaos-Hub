-- Chaos Hub v2.1 - Classic UI Style with Full Features
local Players = game:GetService("Players")
local VirtualInput = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- Anti-AFK
for _, v in pairs(getconnections(player.Idled)) do
    v:Disable()
end
player.Idled:Connect(function()
    VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Create GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ChaosHubClassic"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.5, -250, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

local tabs = {"Main", "Auto", "Teleport", "Misc"}
local tabButtons = {}
local contentFrames = {}

local tabBar = Instance.new("Frame", frame)
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.Position = UDim2.new(0, (i - 1) * 120, 0, 0)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabButtons[name] = btn

    local content = Instance.new("Frame", frame)
    content.Size = UDim2.new(1, 0, 1, -30)
    content.Position = UDim2.new(0, 0, 0, 30)
    content.Visible = (i == 1)
    content.BackgroundTransparency = 1
    contentFrames[name] = content

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(contentFrames) do f.Visible = false end
        content.Visible = true
    end)
end

-- MAIN: Auto Farm NPC by Island
do
    local frame = contentFrames["Main"]
    local label = Instance.new("TextLabel", frame)
    label.Text = "Auto Farm NPC by Island"
    label.Size = UDim2.new(1, 0, 0, 30)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1

    local npcDropdown = Instance.new("TextButton", frame)
    npcDropdown.Text = "Select NPC"
    npcDropdown.Position = UDim2.new(0, 20, 0, 40)
    npcDropdown.Size = UDim2.new(0, 200, 0, 30)
    npcDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    npcDropdown.TextColor3 = Color3.new(1, 1, 1)

    local refreshBtn = Instance.new("TextButton", frame)
    refreshBtn.Text = "Refresh"
    refreshBtn.Position = UDim2.new(0, 230, 0, 40)
    refreshBtn.Size = UDim2.new(0, 100, 0, 30)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    refreshBtn.TextColor3 = Color3.new(1, 1, 1)
end

-- AUTO: Auto Skill
do
    local frame = contentFrames["Auto"]
    local autoBtn = Instance.new("TextButton", frame)
    autoBtn.Text = "Auto Skill Z"
    autoBtn.Position = UDim2.new(0, 20, 0, 20)
    autoBtn.Size = UDim2.new(0, 150, 0, 30)
    autoBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    autoBtn.TextColor3 = Color3.new(1, 1, 1)

    local auto = false
    autoBtn.MouseButton1Click:Connect(function()
        auto = not auto
        autoBtn.Text = "Auto Skill Z: " .. (auto and "ON" or "OFF")
        if auto then
            spawn(function()
                while auto do
                    VirtualInput:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                    wait(0.1)
                    VirtualInput:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                    wait(1)
                end
            end)
        end
    end)
end

-- TELEPORT
do
    local frame = contentFrames["Teleport"]
    local islands = {
        ["Starter Island"] = Vector3.new(3387, 138, 1716),
        ["Clown Island"] = Vector3.new(3002, 144, -585),
        ["Marine Island"] = Vector3.new(4930, 140, 35),
        ["Lier Village"] = Vector3.new(5795, 177, 2330),
        ["Baratee"] = Vector3.new(1422, 124, 2525),
        ["Ar Longo Park"] = Vector3.new(466, 144, 526),
        ["Lulue Town"] = Vector3.new(5786, 125, -3228),
        ["Arena"] = Vector3.new(1319, 130, -808)
    }

    local y = 10
    for name, pos in pairs(islands) do
        local btn = Instance.new("TextButton", frame)
        btn.Text = name
        btn.Position = UDim2.new(0, 20, 0, y)
        btn.Size = UDim2.new(0, 200, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        btn.TextColor3 = Color3.new(1, 1, 1)
        y = y + 35

        btn.MouseButton1Click:Connect(function()
            player.Character:MoveTo(pos)
        end)
    end
end

-- MISC
do
    local frame = contentFrames["Misc"]

    local function createBtn(text, posY, callback)
        local b = Instance.new("TextButton", frame)
        b.Text = text
        b.Position = UDim2.new(0, 20, 0, posY)
        b.Size = UDim2.new(0, 200, 0, 30)
        b.BackgroundColor3 = Color3.fromRGB(50, 70, 50)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.MouseButton1Click:Connect(callback)
    end

    createBtn("Gacha Fruit", 20, function()
        local g = workspace:FindFirstChild("Gacha")
        if g and g:FindFirstChild("ProximityPrompt") then
            fireproximityprompt(g.ProximityPrompt)
        else
            warn("Gacha not found")
        end
    end)

    createBtn("Check Stock Fruit", 60, function()
        local gui = player:WaitForChild("PlayerGui")
        local stk = gui:FindFirstChild("Main") and gui.Main:FindFirstChild("Topbar") and gui.Main.Topbar:FindFirstChild("Stock")
        if stk then
            stk:Click()
        else
            warn("Stock UI not found")
        end
    end)

    createBtn("Rejoin Server", 100, function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end)
end

print("Chaos Hub Classic v2.1 Loaded")
