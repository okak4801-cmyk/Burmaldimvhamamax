 -- MM2 Mobile Script v3 - Fixed GUI + Chat Toggle
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

local Settings = {
    ESP = true,
    RoleESP = true,
    FlingEnabled = false,
    FlingPower = 5000,
    SelectedPlayer = nil
}

-- Создаём GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Menu_Fixed"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 480)
Frame.Position = UDim2.new(0.5, -150, 0.15, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 55)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Title.Text = "MM2 Mobile Menu"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 16)

-- Drag
local dragging, dragStart, startPos
Title.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = inp.Position
        startPos = Frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = inp.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function() dragging = false end)

-- Toggle
local function createToggle(parent, name, def, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -30, 0, 50)
    b.BackgroundColor3 = def and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    b.Text = name .. ": " .. (def and "ВКЛ" or "ВЫКЛ")
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Font = Enum.Font.GothamSemibold
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
    
    b.MouseButton1Click:Connect(function()
        def = not def
        b.BackgroundColor3 = def and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        b.Text = name .. ": " .. (def and "ВКЛ" or "ВЫКЛ")
        cb(def)
    end)
end

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -140)
Scroll.Position = UDim2.new(0, 10, 0, 65)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.Parent = Frame

local layout = Instance.new("UIListLayout", Scroll)
layout.Padding = UDim.new(0, 12)

createToggle(Scroll, "ESP", Settings.ESP, function(v) Settings.ESP = v end)
createToggle(Scroll, "Role Reveal", Settings.RoleESP, function(v) Settings.RoleESP = v end)
createToggle(Scroll, "Fling Mode", Settings.FlingEnabled, function(v) Settings.FlingEnabled = v end)

-- Fling Power
local powerLbl = Instance.new("TextLabel", Scroll)
powerLbl.Size = UDim2.new(1, -30, 0, 45)
powerLbl.BackgroundTransparency = 1
powerLbl.TextColor3 = Color3.new(1,1,1)
powerLbl.TextScaled = true
powerLbl.Text = "Сила: " .. Settings.FlingPower

local plus = Instance.new("TextButton", Scroll)
plus.Size = UDim2.new(1, -30, 0, 45)
plus.BackgroundColor3 = Color3.fromRGB(60,60,60)
plus.Text = "+1000"
plus.TextColor3 = Color3.new(1,1,1)
plus.TextScaled = true
Instance.new("UICorner", plus).CornerRadius = UDim.new(0,12)

plus.MouseButton1Click:Connect(function()
    Settings.FlingPower += 1000
    powerLbl.Text = "Сила: " .. Settings.FlingPower
end)

-- Player List
local plrScroll = Instance.new("ScrollingFrame", Scroll)
plrScroll.Size = UDim2.new(1, -30, 0, 160)
plrScroll.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", plrScroll).CornerRadius = UDim.new(0,10)

local function refreshPlayers()
    -- очистка и обновление списка...
    for _,c in ipairs(plrScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _,p in ipairs(Players:GetPlayers()) do
        if p \~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,0,40)
            btn.Text = p.Name
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Parent = plrScroll
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
            btn.MouseButton1Click:Connect(function()
                Settings.SelectedPlayer = p
            end)
        end
    end
end
refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

-- Fling Button
local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(1, -20, 0, 60)
flingBtn.Position = UDim2.new(0,10,1,-70)
flingBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
flingBtn.Text = "🚀 FLING"
flingBtn.TextScaled = true
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextColor3 = Color3.new(1,1,1)
flingBtn.Parent = Frame
Instance.new("UICorner", flingBtn).CornerRadius = UDim.new(0,14)

flingBtn.MouseButton1Click:Connect(function()
    if Settings.SelectedPlayer and Settings.SelectedPlayer.Character then
        local hrp = Settings.SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bv.Velocity = Vector3.new(math.random(-Settings.FlingPower,Settings.FlingPower), Settings.FlingPower*0.8, math.random(-Settings.FlingPower,Settings.FlingPower))
            bv.Parent = hrp
            game:GetService("Debris"):AddItem(bv, 0.6)
        end
    end
end)

-- ESP (оставил как было)
local ESPFolder = Instance.new("Folder", ScreenGui)
ESPFolder.Name = "ESP"

RunService.RenderStepped:Connect(function()
    if not Settings.ESP then ESPFolder:ClearAllChildren() return end
    -- ... (ESP код без изменений)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("Head") and not ESPFolder:FindFirstChild(plr.Name) then
            local bill = Instance.new("BillboardGui", ESPFolder)
            bill.Name = plr.Name
            bill.Adornee = plr.Character.Head
            bill.AlwaysOnTop = true
            bill.Size = UDim2.new(0,200,0,50)
            bill.StudsOffset = Vector3.new(0,3,0)
            
            local label = Instance.new("TextLabel", bill)
            label.Size = UDim2.new(1,0,1,0)
            label.BackgroundTransparency = 1
            label.TextStrokeTransparency = 0
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            
            spawn(function()
                while bill.Parent do
                    local role = "Innocent"
                    if plr.Character:FindFirstChild("Knife") then role = "🔪 MURDER" 
                    elseif plr.Character:FindFirstChild("Gun") then role = "🔫 SHERIFF" end
                    label.Text = plr.Name .. "\n" .. role
                    wait(0.5)
                end
            end)
        end
    end
end)

print("✅ v3 Загружено! Если меню не видно — напиши в чат: /menu")

-- Команда в чат для показа/скрытия
LocalPlayer.Chatted:Connect(function(msg)
    if msg:lower() == "/menu" then
        Frame.Visible = not Frame.Visible
        print("Меню " .. (Frame.Visible and "показано" or "скрыто"))
    end
end)
