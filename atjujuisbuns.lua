-- i made this for this random dawg called atjuju on discord and juju =/ he was pretty strange and i still made this esp script for him anyway tho since he was asking so much
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP"
ESPFolder.Parent = game.CoreGui

local function createESP(player)
    if player == LocalPlayer then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = player.Name .. "_ESP"
    esp.Adornee = nil
    esp.AlwaysOnTop = true
    esp.LightInfluence = 0
    esp.Size = UDim2.new(0, 240, 0, 85)
    esp.StudsOffset = Vector3.new(0, 3.5, 0)
    esp.Parent = ESPFolder
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.78, 0, 0.4, 0)
    nameLabel.Position = UDim2.new(0.13, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 16
    nameLabel.Parent = esp
    
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(0.018, 0, 0.96, 0)
    healthBg.Position = UDim2.new(0, 0, 0.02, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    healthBg.BorderSizePixel = 1
    healthBg.BorderColor3 = Color3.fromRGB(0, 0, 0)
    healthBg.Parent = esp
    
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.AnchorPoint = Vector2.new(0, 1)
    healthBar.Position = UDim2.new(0, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.Parent = healthBg
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not player.Character or not player.Character:FindFirstChild("Head") or not player.Character:FindFirstChild("Humanoid") then
            esp.Adornee = nil
            return
        end
        
        local head = player.Character.Head
        local humanoid = player.Character.Humanoid
        
        esp.Adornee = head
        
        local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
        healthBar.Size = UDim2.new(1, 0, healthPercent, 0)
        
        if healthPercent > 0.6 then
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        elseif healthPercent > 0.3 then
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        else
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)
    
    local function cleanup()
        if connection then
            connection:Disconnect()
        end
        if esp then
            esp:Destroy()
        end
    end
    
    player.CharacterRemoving:Connect(cleanup)
    player.AncestryChanged:Connect(function(_, parent)
        if not parent then
            cleanup()
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)

Players.PlayerRemoving:Connect(function(player)
    local existing = ESPFolder:FindFirstChild(player.Name .. "_ESP")
    if existing then
        existing:Destroy()
    end
end)
