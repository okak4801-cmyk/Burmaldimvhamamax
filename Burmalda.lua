-- MM2 Mobile Optimized Script с Draggable Menu
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Настройки
local Settings = {
    ESP = true,
    RoleESP = true,
    FlingEnabled = false,
    FlingPower = 5000,
    SelectedPlayer = nil
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Mobile_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 420)  -- чуть меньше для мобилы
Frame.Position = UDim2.new(0.5, -140, 0.3, 0)  -- выше на экране
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Закругления
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "MM2 Mobile Script"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 12)
UICornerTitle.Parent = Title

-- Drag функция (очень важна для мобилы)
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

-- Toggle функция
local function createToggle(parent, text, default, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -20, 0, 45)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    toggle.Text = text .. ": " .. (default and "ON" or "OFF")
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamSemibold
    toggle.Parent = parent
    
    local corner = Instance.new("UICorner", toggle)
    corner.CornerRadius = UDim.new(0, 8)
    
    toggle.MouseButton1Click:Connect(function()
        default = not default
        toggle.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        toggle.Text = text .. ": " .. (default and "ON" or "OFF")
        callback(default)
    end)
end

-- Контент
local Scrolling = Instance.new("ScrollingFrame")
Scrolling.Size = UDim2.new(1, -20, 1, -100)
Scrolling.Position = UDim2.new(0, 10, 0, 55)
Scrolling.BackgroundTransparency = 1
Scrolling.ScrollBarThickness = 6
Scrolling.Parent = Frame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Scrolling

createToggle(Scrolling, "ESP", Settings.ESP, function(v) Settings.ESP = v end)
createToggle(Scrolling, "Role Reveal", Settings.RoleESP, function(v) Settings.RoleESP = v end)
createToggle(Scrolling, "Fling Mode", Settings.FlingEnabled, function(v) Settings.FlingEnabled = v end)

-- Fling Power
local powerLabel = Instance.new("TextLabel")
powerLabel.Size = UDim2.new(1, -20, 0, 40)
powerLabel.BackgroundTransparency = 1
powerLabel.Text = "Fling Power: " .. Settings.FlingPower
powerLabel.TextColor3 = Color3.new(1,1,1)
powerLabel.TextScaled = true
powerLabel.Parent = Scrolling

-- Кнопка увеличения силы
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(1, -20, 0, 40)
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
plusBtn.Text = "Увеличить силу (+1000)"
plusBtn.TextColor3 = Color3.new(1,1,1)
plusBtn.TextScaled = true
plusBtn.Parent = Scrolling
plusBtn.MouseButton1Click:Connect(function()
    Settings.FlingPower = Settings.FlingPower + 1000
    powerLabel.Text = "Fling Power: " .. Settings.FlingPower
end)

-- Список игроков
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, -20, 0, 140)
playerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerList.Parent = Scrolling

local listLayout = Instance.new("UIListLayout", playerList)
listLayout.Padding = UDim.new(0, 4)

local function updatePlayerList()
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.Text = plr.Name
            btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Parent = playerList
            btn.MouseButton1Click:Connect(function()
                Settings.SelectedPlayer = plr
                print("Выбран: " .. plr.Name)
            end)
        end
    end
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- Fling кнопка
local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(1, -20, 0, 50)
flingBtn.Position = UDim2.new(0, 10, 1, -60)
flingBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
flingBtn.Text = "🚀 FLING SELECTED"
flingBtn.TextColor3 = Color3.new(1,1,1)
flingBtn.TextScaled = true
flingBtn.Font = Enum.Font.GothamBold
flingBtn.Parent = Frame

local cornerFling = Instance.new("UICorner", flingBtn)
cornerFling.CornerRadius = UDim.new(0, 10)

flingBtn.MouseButton1Click:Connect(function()
    if Settings.SelectedPlayer and Settings.SelectedPlayer.Character then
        local root = Settings.SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.new(math.random(-Settings.FlingPower, Settings.FlingPower), Settings.FlingPower*0.6, math.random(-Settings.FlingPower, Settings.FlingPower))
            bv.Parent = root
            game:GetService("Debris"):AddItem(bv, 0.6)
        end
    end
end)

-- ESP (упрощённый и стабильный)
local ESPFolder = Instance.new("Folder", CoreGui)
ESPFolder.Name = "MM2_ESP"

RunService.RenderStepped:Connect(function()
    if Settings.ESP then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head
                if not ESPFolder:FindFirstChild(plr.Name) then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = plr.Name
                    bill.Adornee = head
                    bill.AlwaysOnTop = true
                    bill.Size = UDim2.new(0, 180, 0, 50)
                    bill.StudsOffset = Vector3.new(0, 3, 0)
                    bill.Parent = ESPFolder
                    
                    local txt = Instance.new("TextLabel", bill)
                    txt.Size = UDim2.new(1,0,1,0)
                    txt.BackgroundTransparency = 1
                    txt.TextStrokeTransparency = 0
                    txt.TextScaled = true
                    txt.Font = Enum.Font.GothamBold
                    txt.TextColor3 = Color3.new(1,1,1)
                    
                    spawn(function()
                        while bill.Parent do
                            local role = "Innocent"
                            if plr.Character:FindFirstChild("Knife") then role = "🔪 MURDER" 
                            elseif plr.Character:FindFirstChild("Gun") then role = "🔫 SHERIFF" end
                            txt.Text = plr.Name .. "\n" .. role
                            wait(0.5)
                        end
                    end)
                end
            end
        end
    else
        ESPFolder:ClearAllChildren()
    end
end)

print("✅ MM2 Mobile Menu загружен! Тащи за заголовок.")
