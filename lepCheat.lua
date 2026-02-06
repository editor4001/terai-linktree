local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local me = Players.LocalPlayer
local char = me.Character or me.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- Flags
local flying = false
local forward = false
local noclip = false
local invisible = false
local AntiDeath = false

local bodyVelocity
local bodyGyro

-- Rayfield UI
local Window = Rayfield:CreateWindow({
   Name = "Lep cheat Client",
   LoadingTitle = "Lep cheating entertainment",
   LoadingSubtitle = "by lep_549",
   ShowText = "Lep cheat client",
   Theme = "Default",
   ToggleUIKeybind = Enum.KeyCode.LeftControl,
   ConfigurationSaving = { Enabled = true, FileName = "Big Hub" },
   Discord = { Enabled = false },
   KeySystem = false
})

local Tab = Window:CreateTab("Main")
local Fight = Window:CreateTab("Fight or Other")

-- GUI Elements
local FlyToggle = Tab:CreateToggle({
    Name = "Fly(f)",
    CurrentValue = flying,
    Flag = "FlyToggle",
    Callback = function(value)
        flying = value
        if flying then startFly() else stopFly() end
    end
})

local NoclipToggle = Tab:CreateToggle({
    Name = "Noclip(n)",
    CurrentValue = noclip,
    Flag = "NoclipToggle",
    Callback = function(value)
        noclip = value
        updateNoclip()
    end
})

local healthConn

function updateAntiDeath()
    if AntiDeath then
        if healthConn then healthConn:Disconnect() end
        healthConn = hum.HealthChanged:Connect(function(h)
            if h <= 0 then
                hum.Health = hum.MaxHealth
            end
        end)
    else
        if healthConn then
            healthConn:Disconnect()
            healthConn = nil
        end
    end
end


local AntiDeathToggle = Fight:CreateToggle({
    Name = "Anti death(k)",
    CurrentValue = AntiDeath,
    Flag = "AntiDeathToggle",
    Callback = function(value)
        AntiDeath = value
        updateAntiDeath()
    end
})


local InvisibleToggle = Tab:CreateToggle({
    Name = "Invisible(p)",
    CurrentValue = invisible,
    Flag = "InvisibleToggle",
    Callback = function(value)
        invisible = value
        updateVisibility()
    end
})

-- Destroy Window
Tab:CreateButton({
    Name = "Destroy window",
    Callback = function() Rayfield:Destroy() end
})

-- Fonctions Fly
function startFly()
    stopFly() -- toujours arrêter avant de recréer
    humanoid.PlatformStand = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.Parent = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bodyGyro.P = 1e5
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root
end

function stopFly()
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
    humanoid.PlatformStand = false
end

-- Noclip
function updateNoclip()
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclip
        end
    end
end

-- Invisibilité
function updateVisibility()
    for _, obj in ipairs(character:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Transparency = invisible and 1 or 0
        elseif obj:IsA("Accessory") and obj:FindFirstChild("Handle") then
            obj.Handle.Transparency = invisible and 1 or 0
        elseif obj:IsA("MeshPart") or obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = invisible and 1 or 0
        end
    end
    humanoid.LocalTransparencyModifier = invisible and 1 or 0
end

-- Tick Noclip
RunService.Stepped:Connect(function()
    if noclip then updateNoclip() end
end)

-- Tick Fly
RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity then
        local dir = camera.CFrame.LookVector
        local speed = forward and 100 or 0
        bodyVelocity.Velocity = dir * speed
        bodyGyro.CFrame = camera.CFrame
    end
end)

-- Keyboard input
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then startFly() else stopFly() end
        FlyToggle:Set(flying)
    elseif input.KeyCode == Enum.KeyCode.W then
        forward = true
    elseif input.KeyCode == Enum.KeyCode.N then
        noclip = not noclip
        updateNoclip()
        NoclipToggle:Set(noclip)
    elseif input.KeyCode == Enum.KeyCode.K then
        AntiDeath = not AntiDeath
        updateAntiDeath()
        AntiDeathToggle:Set(AntiDeath)
    elseif input.KeyCode == Enum.KeyCode.P then
        invisible = not invisible
        updateVisibility()
        InvisibleToggle:Set(invisible)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        forward = false
    end
end)
