-- Chaos Hub v2.0 (OMG-Style UI + Fully Fixed Features)

local Players     = game:GetService("Players")
local TeleportSvc = game:GetService("TeleportService")
local VirtualInput = game:GetService("VirtualInputManager")
local VirtualUser  = game:GetService("VirtualUser")
local player       = Players.LocalPlayer

-- Anti AFK
for _, c in pairs(getconnections(player.Idled)) do c:Disable() end
player.Idled:Connect(function() VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end)

--=== GUI Boilerplate ===
local screenGui    = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name     = "ChaosHub"
local mainFrame    = Instance.new("Frame", screenGui)
mainFrame.Size     = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,40)
mainFrame.BorderSizePixel  = 0
mainFrame.Active   = true
mainFrame.Draggable = true

local topBar = Instance.new("Frame", mainFrame)
topBar.Size  = UDim2.new(1,0,0,30)
topBar.BackgroundColor3 = Color3.fromRGB(25,25,35)
local tabs = {"Main","Auto","Teleport","Misc"}
local contentFrames = {}

for i,name in ipairs(tabs) do
  local btn = Instance.new("TextButton", topBar)
  btn.Size     = UDim2.new(1/#tabs, -2,1, -2)
  btn.Position = UDim2.new((i-1)/#tabs,2,0,2)
  btn.Text     = name
  btn.Font     = Enum.Font.Gotham
  btn.TextSize = 14
  btn.BackgroundColor3 = Color3.fromRGB(35,35,50)
  btn.TextColor3 = Color3.fromRGB(200,200,200)
  -- Content Frame
  local frame = Instance.new("Frame", mainFrame)
  frame.Size   = UDim2.new(1,0,1,-32)
  frame.Position = UDim2.new(0,0,0,32)
  frame.BackgroundTransparency = 1
  frame.Visible = (i==1)
  contentFrames[name] = frame

  btn.MouseButton1Click:Connect(function()
    for _,f in pairs(contentFrames) do f.Visible = false end
    frame.Visible = true
  end)
end

-- divider line
local line = Instance.new("Frame", mainFrame)
line.Size = UDim2.new(1,0,0,2)
line.Position = UDim2.new(0,0,0,30)
line.BackgroundColor3 = Color3.fromRGB(200,200,200)

--=== MAIN TAB: AUTO FARM OMG-STYLE ===
do
  local tab = contentFrames["Main"]
  local section = Instance.new("Frame", tab)
  section.Size   = UDim2.new(1, -20, 1, -20)
  section.Position = UDim2.new(0,10,0,10)
  -- Title
  local title = Instance.new("TextLabel", section)
  title.Text  = "Auto Farm by Island"
  title.Font  = Enum.Font.GothamBold
  title.TextSize = 16
  title.TextColor3 = Color3.fromRGB(255,255,255)
  title.BackgroundTransparency = 1
  title.Position = UDim2.new(0,0,0,0)
  title.Size     = UDim2.new(1,0, 0, 24)

  -- Dropdown & Buttons container
  local container = Instance.new("Frame", section)
  container.Size = UDim2.new(1,0,0,100)
  container.Position = UDim2.new(0,0,0,30)
  container.BackgroundTransparency = 1

  -- Utility to create dropdowns
  local function makeDropdown(labelText, items, callback, x)
    local lbl = Instance.new("TextLabel", container)
    lbl.Text = labelText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(200,200,200)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new((x-1)/2,0,0,0)
    lbl.Size = UDim2.new(0.5, -5,0,20)
    local dd = Instance.new("TextButton", container)
    dd.Text = "Select "..labelText
    dd.Font = Enum.Font.Gotham
    dd.TextSize = 14
    dd.BackgroundColor3 = Color3.fromRGB(50,50,70)
    dd.TextColor3 = Color3.fromRGB(255,255,255)
    dd.Position = UDim2.new((x-1)/2,0,0,25)
    dd.Size = UDim2.new(0.5, -5,0,30)
    dd.MouseButton1Click:Connect(function()
      local list = items()
      dd.Text = list[1] or "None"
      callback(dd.Text)
    end)
    return dd
  end

  local selMob, selWeapon, selType, selMethod
  makeDropdown("Mob", function()
    local t={}
    for _,v in pairs(workspace:GetDescendants()) do
      if v:IsA("Model") and v:FindFirstChild("Humanoid") then t[#t+1]=v.Name end
    end
    return t
  end, function(v) selMob=v end, 1)

  makeDropdown("Weapon", function()
    local t={}
    for _,v in pairs(player.Backpack:GetChildren()) do
      if v:IsA("Tool") then t[#t+1]=v.Name end
    end
    return t
  end, function(v) selWeapon=v end, 2)

  makeDropdown("Type", function() return {"Melee","Fruit","Gun"} end, function(v) selType=v end, 1)
  makeDropdown("Method", function() return {"Behind","In Front","Above"} end, function(v) selMethod=v end, 2)

  local function makeToggle(text,y,cb)
    local tk = Instance.new("TextButton", section)
    tk.Text = text..": OFF"
    tk.Font = Enum.Font.Gotham
    tk.TextSize = 14
    tk.Position = UDim2.new(0,0,0,150+y)
    tk.Size = UDim2.new(0,200,0,30)
    tk.BackgroundColor3 = Color3.fromRGB(70,50,50)
    tk.TextColor3 = Color3.fromRGB(255,255,255)
    local state=false
    tk.MouseButton1Click:Connect(function()
      state = not state
      tk.Text = text..": "..(state and "ON" or "OFF")
      cb(state)
    end)
  end

  -- Auto Farm
  makeToggle("Auto Farm", 0, function(on)
    getgenv().AutoFarm=on
    spawn(function()
      while getgenv().AutoFarm do
        if selMob and selWeapon then
          pcall(function()
            local mob = workspace:FindFirstChild(selMob)
            local char = player.Character
            if mob and char and mob:FindFirstChild("HumanoidRootPart") then
              local ofs = CFrame.new(0,0,-5)
              if selMethod=="In Front" then ofs=CFrame.new(0,0,5)
              elseif selMethod=="Above" then ofs=CFrame.new(0,5,0) end
              char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * ofs
              local tool = player.Backpack:FindFirstChild(selWeapon)
              if tool then tool.Parent=char end
              VirtualInput:SendKeyEvent(true,Enum.KeyCode.Z,false,game)
              wait(0.1)
              VirtualInput:SendKeyEvent(false,Enum.KeyCode.Z,false,game)
            end
          end)
        end
        wait(0.3)
      end
    end)
  end)

  -- Auto Quest
  makeToggle("Auto Quest", 40, function(on)
    getgenv().AutoQuest=on
    spawn(function()
      while getgenv().AutoQuest do
        pcall(function()
          local npc=workspace:FindFirstChild("QuestGiver")
          if npc and npc:FindFirstChild("Head") then
            player.Character.HumanoidRootPart.CFrame = npc.Head.CFrame + Vector3.new(0,1,0)
            fireproximityprompt(npc.Head:FindFirstChildWhichIsA("ProximityPrompt"))
          end
        end)
        wait(5)
      end
    end)
  end)
end

--=== MISC TAB: FRUIT & UTILITY ===
do
  local tab = contentFrames["Misc"]
  local sec = Instance.new("Frame", tab)
  sec.Size   = UDim2.new(1,-20,1,-20)
  sec.Position = UDim2.new(0,10,0,10)

  local function makeBtn(text,y,action)
    local b=Instance.new("TextButton",sec)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Position = UDim2.new(0,0,0,y)
    b.Size = UDim2.new(0,200,0,30)
    b.BackgroundColor3 = Color3.fromRGB(50,70,50)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.MouseButton1Click:Connect(action)
  end

  -- Gacha
  makeBtn("Random Fruit (Gacha)", 0, function()
    local g = workspace:FindFirstChild("Gacha")
    if g and g:FindFirstChild("ProximityPrompt") then
      fireproximityprompt(g.ProximityPrompt)
    else warn("Gacha NPC not found.") end
  end)

  -- Check Stock Fruit
  makeBtn("Check Fruit Stock", 40, function()
    local gui = player:WaitForChild("PlayerGui")
    local stkBtn = gui:FindFirstChild("Main")
                   and gui.Main:FindFirstChild("Topbar")
                   and gui.Main.Topbar:FindFirstChild("Stock")
    if stkBtn then
      stkBtn:Click()
      wait(2)
      local frame = gui.Main:FindFirstChild("StockFrame")
      if frame and frame:FindFirstChild("ScrollingFrame") then
        for _,f in pairs(frame.ScrollingFrame:GetChildren()) do
          if f:IsA("Frame") and f:FindFirstChild("Name") then
            print("[Stock] "..f.Name.Text)
          end
        end
      else warn("Stock UI not found.") end
    else warn("Stock button not found.") end
  end)
end

print("Chaos Hub v2.0 Loaded!")```
