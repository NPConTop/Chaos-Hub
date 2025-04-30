-- Chaos Hub Loader GUI

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ChaosHubLoader"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", Frame)
title.Text = "Chaos Hub Loader"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local loadBtn = Instance.new("TextButton", Frame)
loadBtn.Size = UDim2.new(1, -40, 0, 35)
loadBtn.Position = UDim2.new(0, 20, 0, 50)
loadBtn.Text = "Launch Chaos Hub"
loadBtn.Font = Enum.Font.Gotham
loadBtn.TextSize = 16
loadBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local credits = Instance.new("TextLabel", Frame)
credits.Size = UDim2.new(1, 0, 0, 20)
credits.Position = UDim2.new(0, 0, 1, -25)
credits.Text = "Created by NPConTop"
credits.Font = Enum.Font.Gotham
credits.TextSize = 14
credits.TextColor3 = Color3.fromRGB(180, 180, 180)
credits.BackgroundTransparency = 1

loadBtn.MouseButton1Click:Connect(function()
    loadBtn.Text = "Loading..."
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NPConTop/Chaos-Hub/main/Chaos.lua"))()
    end)
    loadBtn.Text = "Loaded!"
    wait(1)
    ScreenGui:Destroy()
end)
