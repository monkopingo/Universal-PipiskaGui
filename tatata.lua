local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- Удаление дубликатов GUI
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "AdminGui" then
        gui:Destroy()
    end
end

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local userList = Instance.new("ScrollingFrame")
local teleportButton = Instance.new("TextButton")
local espButton = Instance.new("TextButton")
local giveButton = Instance.new("TextButton")
local trollTpButton = Instance.new("TextButton") -- Новая кнопка Troll TP

screenGui.Name = "AdminGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 450)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Parent = screenGui

userList.Name = "UserList"
userList.Size = UDim2.new(1, -20, 1, -190)
userList.Position = UDim2.new(0, 10, 0, 10)
userList.CanvasSize = UDim2.new(0, 0, 10, 0)
userList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
userList.Parent = mainFrame

teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(1, -20, 0, 40)
teleportButton.Position = UDim2.new(0, 10, 1, -140)
teleportButton.Text = "TELEPORT"
teleportButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Parent = mainFrame

espButton.Name = "ESPButton"
espButton.Size = UDim2.new(1, -20, 0, 40)
espButton.Position = UDim2.new(0, 10, 1, -190)
espButton.Text = "ESP ON"
espButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Parent = mainFrame

giveButton.Name = "GiveButton"
giveButton.Size = UDim2.new(1, -20, 0, 40)
giveButton.Position = UDim2.new(0, 10, 1, -240)
giveButton.Text = "GIVE TOOL"
giveButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
giveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
giveButton.Parent = mainFrame

trollTpButton.Name = "TrollTpButton"
trollTpButton.Size = UDim2.new(1, -20, 0, 40)
trollTpButton.Position = UDim2.new(0, 10, 1, -90)
trollTpButton.Text = "TROLL TP"
trollTpButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
trollTpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
trollTpButton.Parent = mainFrame

-- Хранение текущего подключения к событию нажатия кнопки телепорта
local teleportConnection
local trollTpConnection

-- Функция для обновления списка пользователей
local function updateUserList()
    for _, child in pairs(userList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    local yPos = 10
    for _, player in pairs(Players:GetPlayers()) do
        local userButton = Instance.new("TextButton")
        userButton.Size = UDim2.new(1, -20, 0, 30)
        userButton.Position = UDim2.new(0, 10, 0, yPos)
        userButton.Text = player.Name
        userButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        userButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        userButton.Parent = userList

        userButton.MouseButton1Click:Connect(function()
            teleportButton.Text = "TELEPORT TO " .. player.Name
            trollTpButton.Text = "TROLL TP " .. player.Name -- Обновление текста кнопки Troll TP
            if teleportConnection then
                teleportConnection:Disconnect()
            end
            if trollTpConnection then
                trollTpConnection:Disconnect()
            end

            teleportConnection = teleportButton.MouseButton1Click:Connect(function()
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local hrp = character.HumanoidRootPart
                    Players.LocalPlayer.Character:SetPrimaryPartCFrame(hrp.CFrame)
                end
            end)

            trollTpConnection = trollTpButton.MouseButton1Click:Connect(function()
                local character = player.Character
                local localPlayerCharacter = Players.LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") and localPlayerCharacter and localPlayerCharacter:FindFirstChild("HumanoidRootPart") then
                    local hrp = character.HumanoidRootPart
                    local localHrp = localPlayerCharacter.HumanoidRootPart
                    local originalPosition = localHrp.CFrame

                    -- Телепортировать выбранного игрока и себя в нижнюю точку карты
                    local newPosition = CFrame.new(0, -5000, 0) -- Нижняя точка карты
                    localHrp.CFrame = newPosition
                    wait(0.1) -- Небольшая задержка для синхронизации
                    hrp.CFrame = newPosition

                    -- Установить здоровье игрока в ноль
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Health = 0
                    end

                    wait(1) -- Задержка перед возвращением

                    -- Вернуть игрока на исходную позицию
                    localHrp.CFrame = originalPosition
                end
            end)
        end)

        yPos = yPos + 40
    end
end

-- Функция для создания ESP
local function createESP(player)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
        local billboard = hrp:FindFirstChild("ESP")
        if not billboard then
            billboard = Instance.new("BillboardGui", hrp)
            billboard.Name = "ESP"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.Adornee = hrp
            billboard.AlwaysOnTop = true
            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый цвет для текста
            label.Text = player.Name .. " | HP: " .. math.floor(character:FindFirstChildOfClass("Humanoid") and character:FindFirstChildOfClass("Humanoid").Health or 0)
            label.TextScaled = true
            
            -- Glow effect (Outline)
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "Glow"
                    highlight.Adornee = part
                    highlight.FillTransparency = 1
                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0) -- Красный цвет для врагов
                    highlight.Parent = part
                end
            end
        else
            billboard.Enabled = true
        end
    end
end

-- Функция для включения ESP
local espEnabled = false
local espUpdateInterval = 10
local function toggleESP()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "ESP OFF" or "ESP ON"
    if espEnabled then
        RunService:BindToRenderStep("ESP", Enum.RenderPriority.Camera.Value + 1, function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer then
                    createESP(player)
                end
            end
        end)

        -- Обновление ESP каждые 10 секунд
        spawn(function()
            while espEnabled do
                wait(espUpdateInterval)
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= Players.LocalPlayer then
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = player.Character.HumanoidRootPart
                            local billboard = hrp:FindFirstChild("ESP")
                            if billboard then
                                billboard:Destroy()
                            end
                            for _, part in pairs(player.Character:GetChildren()) do
                                if part:IsA("BasePart") then
                                    local highlight = part:FindFirstChild("Glow")
                                    if highlight then
                                        highlight:Destroy()
                                    end
                                end
                            end
                            createESP(player)
                        end
                    end
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("ESP")
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    local billboard = hrp:FindFirstChild("ESP")
                    if billboard then
                        billboard:Destroy()
                    end
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            local highlight = part:FindFirstChild("Glow")
                            if highlight then
                                highlight:Destroy()
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Подключение функции к кнопке ESP
espButton.MouseButton1Click:Connect(toggleESP)

-- Функция для выдачи инструмента
local function giveTool()
    -- Выполняем загрузку и выполнение скрипта
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/monkopingo/Universal-PipiskaGui/main/ieqt.lua"))()
    end)
    if not success then
        warn("Failed to execute the script: " .. tostring(err))
    end
end

-- Подключение функции к кнопке GIVE
giveButton.MouseButton1Click:Connect(giveTool)

-- Обновление списка пользователей при присоединении/отсоединении
Players.PlayerAdded:Connect(updateUserList)
Players.PlayerRemoving:Connect(updateUserList)
updateUserList()

-- Функция для перетаскивания GUI
local dragging = false
local dragInput, mousePos, framePos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - mousePos
        mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- Функция для открытия/закрытия GUI при нажатии клавиши INSERT
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        screenGui.Enabled = not screenGui.Enabled
    end
end)
