-- Chaos Hub Loader GUI (Fixed Destroy)

-- buat ScreenGui di CoreGui
local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "ChaosHubLoader"
loaderGui.Parent = game:GetService("CoreGui")

-- frame utama
local frame = Instance.new("Frame", loaderGui)
frame.Size = UDim2.new(0,250,0,150)
frame.Position = UDim2.new(0.5,-125,0.5,-75)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local uic = Instance.new("UICorner", frame)
uic.CornerRadius = UDim.new(0,8)

-- judul
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Chaos Hub Loader"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)

-- tombol Load
local loadBtn = Instance.new("TextButton", frame)
loadBtn.Size = UDim2.new(1,-40,0,35)
loadBtn.Position = UDim2.new(0,20,0,50)
loadBtn.Text = "Launch Chaos Hub"
loadBtn.Font = Enum.Font.Gotham
loadBtn.TextSize = 16
loadBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
loadBtn.TextColor3 = Color3.new(1,1,1)

-- credits
local credits = Instance.new("TextLabel", frame)
credits.Size = UDim2.new(1,0,0,20)
credits.Position = UDim2.new(0,0,1,-25)
credits.BackgroundTransparency = 1
credits.Text = "Created by NPConTop"
credits.Font = Enum.Font.Gotham
credits.TextSize = 14
credits.TextColor3 = Color3.fromRGB(180,180,180)

loadBtn.MouseButton1Click:Connect(function()
    loadBtn.Text = "Loading..."
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NPConTop/Chaos-Hub/main/Chaos.lua"))()
    end)
    loadBtn.Text = "Loaded!"
    wait(0.8)
    -- gunakan loaderGui, bukan ScreenGui
    if loaderGui then
        loaderGui:Destroy()
    end
end)
