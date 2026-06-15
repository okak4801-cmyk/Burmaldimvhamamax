-- MM2 Mobile Script v2 (Fixed GUI)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Ждём PlayerGui
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Settings = {
    ESP = true,
    RoleESP = true,
    FlingEnabled = false,
    FlingPower = 5000,
    SelectedPlayer = nil,
    MenuVisible = true
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Mobile_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 290, 0, 460)
Frame.Position = UDim2.new(0.5, -145, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.Text = "MM2 Mobile Script"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner", Title)
TitleCorner.CornerRadius = UDim.new(0, 14)

-- Drag (для пальца)
local dragging = false
local dragStart = nil
local startPos = nil

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Toggle creator
local function createToggle(parent, name, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 48)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
    btn.Text = name .. ": " .. (default and "ВКЛ" or "ВЫКЛ")
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = parent
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    btn.MouseButton1Click:Connect(function()
        default = not default
        btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        btn.Text = name .. ": " .. (default and "ВКЛ" or "ВЫКЛ")
        callback(default)
    end)
end

-- Scrolling
local Scrolling = Instance.new("ScrollingFrame")
Scrolling.Size = UDim2.new(1, -20, 1, -110)
Scrolling.Position = UDim2.new(0, 10, 0, 60)
Scrolling.BackgroundTransparency = 1
Scrolling.ScrollBarThickness = 8
Scrolling.Parent = Frame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 10)
ListLayout.Parent = Scrolling

createToggle(Scrolling, "ESP", Settings.ESP, function(v) Settings.ESP = v end)
createToggle(Scrolling, "Role Reveal", Settings.RoleESP, function(v) Settings.RoleESP = v end)
createToggle(Scrolling, "Fling Mode", Settings.FlingEnabled, function(v) Settings.FlingEnabled = v end)

-- Fling Power
local powerLabel = Instance.new("TextLabel")
powerLabel.Size = UDim2.new(1, -24, 0, 40)
powerLabel.BackgroundTransparency = 1
powerLabel.Text = "Сила подброса: " .. Settings.FlingPower
powerLabel.TextColor3 = Color3.new(1,1,1)
powerLabel.TextScaled = true
powerLabel.Parent = Scrolling

local powerBtn = Instance.new("TextButton")
powerBtn.Size = UDim2.new(1, -24, 0, 45)
powerBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
powerBtn.Text = "+1000 к силе"
powerBtn.TextColor3 = Color3.new(1,1,1)
powerBtn.TextScaled = true
powerBtn.Parent = Scrolling
Instance.new("UICorner", powerBtn).CornerRadius = UDim.new(0, 10)

powerBtn.MouseButton1Click:Connect(function()
    Settings.FlingPower += 1000
    powerLabel.Text = "Сила подброса: " .. Settings.FlingPower
end)

-- Player List + Fling
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, -24, 0, 160)
playerList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playerList.Parent = Scrolling
Instance.new("UICorner", playerList).CornerRadius = UDim.new(0, 8)

local plListLayout = Instance.new("UIListLayout", playerList)
plListLayout.Padding = UDim.new(0, 5)

local function updatePlayers()
    for _, v in ipairs(playerList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 38)
            b.Text = plr.Name
            b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            b.TextColor3 = Color3.new(1,1,1)
            b.Parent = playerList
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
            
            b.MouseButton1Click:Connect(function()
                Settings.SelectedPlayer = plr
                print("Выбран для fling: " .. plr.Name)
            end)
        end
    end
end

Players.PlayerAdded:Connect(updatePlayers)
Players.PlayerRemoving:Connect(updatePlayers)
updatePlayers()

-- Fling Button
local flingButton = Instance.new("TextButton")
flingButton.Size = UDim2.new(1, -20, 0, 55)
flingButton.Position = UDim2.new(0, 10, 1, -65)
flingButton.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
flingButton.Text = "🚀 FLING ВЫБРАННОГО"
flingButton.TextColor3 = Color3.new(1,1,1)
flingButton.TextScaled = true
flingButton.Font = Enum.Font.GothamBold
flingButton.Parent = Frame
Instance.new("UICorner", flingButton).CornerRadius = UDim.new(0, 12)

flingButton.MouseButton1Click:Connect(function()
    if not Settings.SelectedPlayer or not Settings.SelectedPlayer.Character then
        print("Игрок не выбран или мёртв")
        return
    end
    local root = Settings.SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(40000, 40000, 40000)
        bv.Velocity = Vector3.new(math.random(-Settings.FlingPower, Settings.FlingPower), Settings.FlingPower * 0.7, math.random(-Settings.FlingPower, Settings.FlingPower))
        bv.Parent = root
        game:GetService("Debris"):AddItem(bv, 0.7)
    end
end)

-- ESP
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "MM2ESP"
ESPFolder.Parent = ScreenGui

RunService.RenderStepped:Connect(function()
    if not Settings.ESP then 
        ESPFolder:ClearAllChildren()
        return 
    end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("Head") then
            if not ESPFolder:FindFirstChild(plr.Name) then
                local bill = Instance.new("BillboardGui")
                bill.Name = plr.Name
                bill.Adornee = plr.Character.Head
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 200, 0, 60)
                bill.StudsOffset = Vector3.new(0, 3, 0)
                bill.Parent = ESPFolder
                
                local txt = Instance.new("TextLabel", bill)
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.TextStrokeTransparency = 0
                txt.TextScaled = true
                txt.Font = Enum.Font.GothamBold
                
                spawn(function()
                    while bill and bill.Parent do
                        local role = "Innocent"
                        if plr.Character:FindFirstChild("Knife") then 
                            role = "🔪 MURDERER" 
                        elseif plr.Character:FindFirstChild("Gun") then 
                            role = "🔫 SHERIFF" 
                        end
                        txt.Text = plr.Name .. "\n" .. role
                        txt.TextColor3 = role:find("MURDER") and Color3.new(1,0,0) or Color3.new(0,1,0)
                        wait(0.4)
                    end
                end)
            end
        end
    end
end)

print("✅ MM2 Mobile Script загружен!")
print("Если меню не видно — попробуй перезайти в игру или перезапустить executor")
