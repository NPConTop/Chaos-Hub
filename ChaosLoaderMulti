if not game:IsLoaded() then game.Loaded:Wait() end

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Blur
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 12

-- GUI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "ChaosLoader"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

gui.Destroying:Connect(function()
	if blur then blur:Destroy() end
end)

-- Frame
local frame = Instance.new("Frame", gui)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.Size = UDim2.new(0, 460, 0, 360)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.LineJoinMode = Enum.LineJoinMode.Round
task.spawn(function()
	local h = 0
	while stroke and stroke.Parent do
		h = (h + 0.01) % 1
		stroke.Color = ColorSequence.new(Color3.fromHSV(h, 1, 1))
		task.wait(0.03)
	end
end)

-- Title
local title = Instance.new("TextLabel", frame)
title.Text = "CHAOS MULTI LOADER"
title.Size = UDim2.new(1, -60, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 70, 70)
title.Font = Enum.Font.FredokaOne
title.TextSize = 26
title.TextXAlignment = Enum.TextXAlignment.Left

-- Description (Rainbow)
local desc = Instance.new("TextLabel", frame)
desc.Size = UDim2.new(1, -20, 0, 22)
desc.Position = UDim2.new(0, 10, 0, 42)
desc.BackgroundTransparency = 1
desc.Text = "Choose your script below"
desc.Font = Enum.Font.GothamBold
desc.TextSize = 14
task.spawn(function()
	local h = 0
	while desc and desc.Parent do
		h = (h + 0.01) % 1
		desc.TextColor3 = Color3.fromHSV(h, 1, 1)
		task.wait(0.03)
	end
end)

-- Close button
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 40, 0, 40)
close.Position = UDim2.new(1, -45, 0, 5)
close.BackgroundTransparency = 1
close.Text = "X"
close.Font = Enum.Font.FredokaOne
close.TextSize = 24
close.TextColor3 = Color3.fromRGB(255, 70, 70)
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Search Box
local searchBox = Instance.new("TextBox", frame)
searchBox.Size = UDim2.new(1, -20, 0, 26)
searchBox.Position = UDim2.new(0, 10, 0, 68)
searchBox.PlaceholderText = "Search..."
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)

-- Scroll Area
local scrolling = Instance.new("ScrollingFrame", frame)
scrolling.Size = UDim2.new(1, -20, 1, -100)
scrolling.Position = UDim2.new(0, 10, 0, 100)
scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
scrolling.ScrollBarThickness = 4
scrolling.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scrolling)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrolling.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- Divider Rainbow
local function createRainbowDivider()
	local line = Instance.new("Frame", scrolling)
	line.Size = UDim2.new(1, 0, 0, 2)
	line.BackgroundColor3 = Color3.fromHSV(0, 1, 1)
	line.BorderSizePixel = 0
	task.spawn(function()
		local h = 0
		while line and line.Parent do
			h = (h + 0.01) % 1
			line.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			task.wait(0.03)
		end
	end)
end

-- Button Function
local allButtons = {}
local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(callback)
	btn.Parent = scrolling
	table.insert(allButtons, btn)
end

-- Expandable Tabs
local function loadScripts(category, scriptList)
	local tabOpen = false
	local label = Instance.new("TextButton", scrolling)
	label.Size = UDim2.new(1, 0, 0, 24)
	label.BackgroundTransparency = 1
	label.Text = "+ " .. category
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.TextColor3 = Color3.new(1, 1, 1)

	local children = {}
	label.MouseButton1Click:Connect(function()
		tabOpen = not tabOpen
		label.Text = (tabOpen and "- " or "+ ") .. category
		for _, child in ipairs(children) do
			child.Visible = tabOpen
		end
	end)

	createRainbowDivider()

	for _, data in ipairs(scriptList) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 36)
		btn.Text = data[1]
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 16
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
		btn.Visible = false
		btn.MouseButton1Click:Connect(function()
			local status = Instance.new("TextLabel", gui)
			status.Text = "SCRIPT IS RUN..."
			status.Size = UDim2.new(0, 220, 0, 30)
			status.AnchorPoint = Vector2.new(0, 1)
			status.Position = UDim2.new(1, -230, 1, -40)
			status.BackgroundTransparency = 1
			status.Font = Enum.Font.GothamBold
			status.TextSize = 14
			status.TextColor3 = Color3.new(1, 1, 1)
			TweenService:Create(status, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
			task.wait(1)
			TweenService:Create(status, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
			task.delay(0.5, function() status:Destroy() end)

			local success, err = pcall(function() loadstring(data[2])() end)
			if not success then warn("Error: "..tostring(err)) end
			gui:Destroy()
		end)
		btn.Parent = scrolling
		table.insert(children, btn)
		table.insert(allButtons, btn)
	end
end

-- DATA
local oneFruit = {
	{"🍉 Nexus Hub", 'loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/86de6d175e585ef6c1c7f4bdebfc57cc.lua"))()'},
	{"🍍 OMG Hub", 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))()'},
}
local universal = {
	{"⚙️ Infinite Yield", 'loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()'},
	{"💻 CMD-X", 'loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source"))()'},
}
local bloxFruit = {
	{"THG Hub", 'loadstring(game:HttpGet("https://pastefy.app/fEXb91kF/raw"))()'},
}
local beaks = {
	{"Mukuro Hub", 'loadstring(game:HttpGet("https://pastebin.com/raw/f1jU2QZg"))()'},
}

-- LOAD
loadScripts("🍎 One Fruit Simulator", oneFruit)
loadScripts("🌐 Universal Menu", universal)
loadScripts("🍊 Blox Fruit", bloxFruit)
loadScripts("🐤 Beaks", beaks)

-- Extra label (rainbow dividers per section)
local extra = {
	"⚡️ LEGEND OF SPEED", "🥷 NINJA LEGENDS", "🔪 SURVIVE THE KILLER", "🚃 DEAD RAILS", "🏡 BROOKHAVEN",
	"🕵️‍♂️ MURDER MYSTERY 2", "🥊 THE STRONGEST BATTLEGROUNDS", "💪 MUSCLE LEGENDS", "🚪 Doors", "⚔️ Blade Ball",
	"👥 Rivals", "🚗 A Dusty Trip", "🐾 Pets Go", "🔫 Arsenal", "🏬 3008", "☠️ Dead Sails", "🏗️ CDID",
	"🚤 Build a Boat for Treasure", "🌞 Sols RNG", "🌪️ Natural Disaster", "🦴 Broken Bone IV",
	"🥇 Ultimate Battlegrounds", "🚕 Taxi Boss", "👻 Hide or Die", "💪 Arm Wrestle Simulator",
	"🗡️ Combat Warrior", "🍔 Eat the World", "🧟‍♂️ Zombie Attack", "👑 King Legacy",
	"🥭 Fruit Battlegrounds", "🏃 Evade"
}
for _, name in ipairs(extra) do
	local l = Instance.new("TextLabel", scrolling)
	l.Size = UDim2.new(1, 0, 0, 24)
	l.BackgroundTransparency = 1
	l.Text = name
	l.Font = Enum.Font.GothamBold
	l.TextSize = 14
	l.TextColor3 = Color3.new(1, 1, 1)
	createRainbowDivider()
end

-- Search
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local text = searchBox.Text:lower()
	for _, btn in ipairs(allButtons) do
		btn.Visible = btn.Text:lower():find(text or "") and true or false
	end
end)

-- Credit
local credit = Instance.new("TextLabel", gui)
credit.Text = "Credits: NPC"
credit.Size = UDim2.new(0, 150, 0, 20)
credit.Position = UDim2.new(1, -160, 1, -20)
credit.BackgroundTransparency = 1
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextColor3 = Color3.fromRGB(255, 255, 255)
