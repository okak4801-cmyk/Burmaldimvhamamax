-- MM2 Advanced Script с GUI и Fling (для Delta Executor)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "MM2_ESP"
ESPFolder.Parent = CoreGui

-- Настройки
local Settings = {
    ESP = true,
    RoleESP = true,
    FlingEnabled = false,
    FlingPower = 5000,
    SelectedPlayer = nil
}

-- Создаём GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "MM2 Script by Grok"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

-- Функция для создания Toggle
local function createToggle(parent, text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 40)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.3, 0, 0.8, 0)
    button.Position = UDim2.new(0.7, 0, 0.1, 0)
    button.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    button.Text = default and "ON" or "OFF"
    button.TextColor3 = Color3.new(1,1,1)
    button.Parent = toggleFrame
    
    button.MouseButton1Click:Connect(function()
        default = not default
        button.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        button.Text = default and "ON" or "OFF"
        callback(default)
    end)
    return button
end

-- Добавляем toggles
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -70)
content.Position = UDim2.new(0, 10, 0, 60)
content.BackgroundTransparency = 1
content.Parent = Frame

createToggle(content, "ESP", Settings.ESP, function(v) Settings.ESP = v end)
createToggle(content, "Role Reveal", Settings.RoleESP, function(v) Settings.RoleESP = v end)
createToggle(content, "Fling Mode", Settings.FlingEnabled, function(v) Settings.FlingEnabled = v end)

-- Fling Power Slider (простой)
local powerLabel = Instance.new("TextLabel")
powerLabel.Text = "Fling Power: " .. Settings.FlingPower
powerLabel.Size = UDim2.new(1, 0, 0, 30)
powerLabel.BackgroundTransparency = 1
powerLabel.TextColor3 = Color3.new(1,1,1)
powerLabel.Parent = content

local powerButton = Instance.new("TextButton")
powerButton.Text = "+1000"
powerButton.Size = UDim2.new(0.5, 0, 0, 30)
powerButton.Position = UDim2.new(0, 0, 0, 40)
powerButton.Parent = content
powerButton.MouseButton1Click:Connect(function()
    Settings.FlingPower = Settings.FlingPower + 1000
    powerLabel.Text = "Fling Power: " .. Settings.FlingPower
end)

-- Список игроков
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, 0, 0, 150)
playerList.Position = UDim2.new(0, 0, 0, 100)
playerList.BackgroundTransparency = 0.5
playerList.ScrollBarThickness = 5
playerList.Parent = content

local uiList = Instance.new("UIListLayout")
uiList.Parent = playerList

local function updatePlayerList()
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Text = plr.Name
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Parent = playerList
            btn.MouseButton1Click:Connect(function()
                Settings.SelectedPlayer = plr
                print("Выбран для fling: " .. plr.Name)
            end)
        end
    end
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- Кнопка Fling
local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(1, -20, 0, 40)
flingBtn.Position = UDim2.new(0, 10, 1, -50)
flingBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
flingBtn.Text = "FLING SELECTED"
flingBtn.TextColor3 = Color3.new(1,1,1)
flingBtn.TextScaled = true
flingBtn.Parent = Frame

flingBtn.MouseButton1Click:Connect(function()
    if Settings.SelectedPlayer and Settings.SelectedPlayer.Character then
        local root = Settings.SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(math.random(-Settings.FlingPower, Settings.FlingPower), Settings.FlingPower / 2, math.random(-Settings.FlingPower, Settings.FlingPower))
            bv.Parent = root
            game:GetService("Debris"):AddItem(bv, 0.5)
            print("Flinged " .. Settings.SelectedPlayer.Name)
        end
    else
        print("Сначала выбери игрока из списка!")
    end
end)

-- ESP функция (улучшенная)
local function createESP(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character
    if not char or not char:FindFirstChild("Head") then return end
    
    local bill = Instance.new("BillboardGui")
    bill.Adornee = char.Head
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 200, 0, 60)
    bill.StudsOffset = Vector3.new(0, 4, 0)
    bill.Parent = ESPFolder
    
    local txt = Instance.new("TextLabel", bill)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.TextStrokeTransparency = 0
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    
    local function update()
        if not char:FindFirstChild("Humanoid") then return end
        local role = "Innocent"
        local color = Color3.new(1,1,1)
        if char:FindFirstChild("Knife") then
            role = "🔪 MURDERER"
            color = Color3.new(1,0,0)
        elseif char:FindFirstChild("Gun") then
            role = "🔫 SHERIFF"
            color = Color3.new(0,1,0)
        end
        txt.Text = plr.Name .. "\n" .. role
        txt.TextColor3 = color
    end
    update()
    RunService.Heartbeat:Connect(update)
end

RunService.RenderStepped:Connect(function()
    if Settings.ESP then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and not ESPFolder:FindFirstChild(plr.Name .. "_ESP") then
                local esp = createESP(plr)
            end
        end
    else
        ESPFolder:ClearAllChildren()
    end
end)

print("✅ MM2 Menu + Fling загружен!")
print("Используй GUI для управления. Выбирай игроков и fling'и их!")
