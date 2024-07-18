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
    -- Убедитесь, что инструмент создан правильно и без ошибок
    local function a(b, c)
        local d = getfenv(c)
        local e =
            setmetatable(
            {},
            {__index = function(self, f)
                    if f == "script" then
                        return b
                    else
                        return d[f]
                    end
                end}
        )
        setfenv(c, e)
        return c
    end
    local g = {}
    local h = Instance.new("Model", game:GetService("Lighting"))
    local i = Instance.new("Tool")
    local j = Instance.new("Part")
    local k = Instance.new("Script")
    local l = Instance.new("LocalScript")
    local m = sethiddenproperty or set_hidden_property
    i.Name = "Telekinesis"
    i.Parent = h
    i.Grip = CFrame.new(0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0)
    i.GripForward = Vector3.new(-0, -1, -0)
    i.GripRight = Vector3.new(0, 0, 1)
    i.GripUp = Vector3.new(1, 0, 0)
    j.Name = "Handle"
    j.Parent = i
    j.CFrame = CFrame.new(-17.2635937, 15.4915619, 46, 0, 1, 0, 1, 0, 0, 0, 0, -1)
    j.Orientation = Vector3.new(0, 180, 90)
    j.Position = Vector3.new(-17.2635937, 15.4915619, 46)
    j.Rotation = Vector3.new(-180, 0, -90)
    j.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
    j.Transparency = 1
    j.Size = Vector3.new(1, 1.20000005, 1)
    j.BottomSurface = Enum.SurfaceType.Weld
    j.BrickColor = BrickColor.new("Really black")
    j.Material = Enum.Material.Metal
    j.TopSurface = Enum.SurfaceType.Smooth
    j.brickColor = BrickColor.new("Really black")
    k.Name = "LineConnect"
    k.Parent = i
    table.insert(
        g,
        a(
            k,
            function()
                wait()
                local n = script.Part2
                local o = script.Part1.Value
                local p = script.Part2.Value
                local q = script.Par.Value
                local color = script.Color
                local r = Instance.new("Part")
                r.TopSurface = 0
                r.BottomSurface = 0
                r.Reflectance = .5
                r.Name = "Laser"
                r.Locked = true
                r.CanCollide = false
                r.Anchored = true
                r.formFactor = 0
                r.Size = Vector3.new(1, 1, 1)
                local s = Instance.new("BlockMesh")
                s.Parent = r
                while true do
                    if n.Value == nil then
                        break
                    end
                    if o == nil or p == nil or q == nil then
                        break
                    end
                    if o.Parent == nil or p.Parent == nil then
                        break
                    end
                    if q.Parent == nil then
                        break
                    end
                    local t = CFrame.new(o.Position, p.Position)
                    local dist = (o.Position - p.Position).magnitude
                    r.Parent = q
                    r.BrickColor = color.Value.BrickColor
                    r.Reflectance = color.Value.Reflectance
                    r.Transparency = color.Value.Transparency
                    r.CFrame = CFrame.new(o.Position + t.lookVector * dist / 2)
                    r.CFrame = CFrame.new(r.Position, p.Position)
                    s.Scale = Vector3.new(.25, .25, dist)
                    wait()
                end
                r:Destroy()
                script:Destroy()
            end
        )
    )
    k.Disabled = true
    l.Name = "MainScript"
    l.Parent = i
    table.insert(
        g,
        a(
            l,
            function()
                wait()
                tool = script.Parent
                lineconnect = tool.LineConnect
                object = nil
                mousedown = false
                found = false
                BP = Instance.new("BodyPosition")
                BP.maxForce = Vector3.new(math.huge * math.huge, math.huge * math.huge, math.huge * math.huge)
                BP.P = BP.P * 1.1
                dist = nil
                point = Instance.new("Part")
                point.Locked = true
                point.Anchored = true
                point.formFactor = 0
                point.Shape = 0
                point.BrickColor = BrickColor.Black()
                point.Size = Vector3.new(1, 1, 1)
                point.CanCollide = false
                local s = Instance.new("SpecialMesh")
                s.MeshType = "Sphere"
                s.Scale = Vector3.new(.7, .7, .7)
                s.Parent = point
                handle = tool.Handle
                front = tool.Handle
                color = tool.Handle
                objval = nil
                local u = false
                local v = BP:clone()
                v.maxForce = Vector3.new(30000, 30000, 30000)
                function LineConnect(o, p, q)
                    local w = Instance.new("ObjectValue")
                    w.Value = o
                    w.Name = "Part1"
                    local x = Instance.new("ObjectValue")
                    x.Value = p
                    x.Name = "Part2"
                    local y = Instance.new("ObjectValue")
                    y.Value = q
                    y.Name = "Par"
                    local z = Instance.new("ObjectValue")
                    z.Value = color
                    z.Name = "Color"
                    local A = lineconnect:clone()
                    A.Disabled = false
                    w.Parent = A
                    x.Parent = A
                    y.Parent = A
                    z.Parent = A
                    A.Parent = workspace
                    if p == object then
                        objval = x
                    end
                end
                function onButton1Down(B)
                    if mousedown == true then
                        return
                    end
                    mousedown = true
                    coroutine.resume(
                        coroutine.create(
                            function()
                                local C = point:clone()
                                C.Parent = tool
                                LineConnect(front, C, workspace)
                                while mousedown == true do
                                    C.Parent = tool
                                    if object == nil then
                                        if B.Target == nil then
                                            local t = CFrame.new(front.Position, B.Hit.p)
                                            C.CFrame = CFrame.new(front.Position + t.lookVector * 1000)
                                        else
                                            C.CFrame = CFrame.new(B.Hit.p)
                                        end
                                    else
                                        LineConnect(front, object, workspace)
                                        break
                                    end
                                    wait()
                                end
                                C:Destroy()
                            end
                        )
                    )
                    while mousedown == true do
                        if B.Target ~= nil then
                            local D = B.Target
                            if D.Anchored == false then
                                object = D
                                dist = (object.Position - front.Position).magnitude
                                break
                            end
                        end
                        wait()
                    end
                    while mousedown == true do
                        if object.Parent == nil then
                            break
                        end
                        local t = CFrame.new(front.Position, B.Hit.p)
                        BP.Parent = object
                        BP.position = front.Position + t.lookVector * dist
                        wait()
                    end
                    BP:Destroy()
                    object = nil
                    objval.Value = nil
                end
                function onKeyDown(E, B)
                    local E = E:lower()
                    local F = false
                    if E == "q" then
                        if dist >= 5 then
                            dist = dist - 10
                        end
                    end
                    if E == "r" then
                        if object == nil then
                            return
                        end
                        for G, H in pairs(object:children()) do
                            if H.className == "BodyGyro" then
                                return nil
                            end
                        end
                        BG = Instance.new("BodyGyro")
                        BG.maxTorque = Vector3.new(math.huge, math.huge, math.huge)
                        BG.cframe = CFrame.new(object.CFrame.p)
                        BG.Parent = object
                        repeat
                            wait()
                        until object.CFrame == CFrame.new(object.CFrame.p)
                        BG.Parent = nil
                        if object == nil then
                            return
                        end
                        for G, H in pairs(object:children()) do
                            if H.className == "BodyGyro" then
                                H.Parent = nil
                            end
                        end
                        object.Velocity = Vector3.new(0, 0, 0)
                        object.RotVelocity = Vector3.new(0, 0, 0)
                        object.Orientation = Vector3.new(0, 0, 0)
                    end
                    if E == "e" then
                        dist = dist + 10
                    end
                    if E == "t" then
                        if dist ~= 10 then
                            dist = 10
                        end
                    end
                    if E == "y" then
                        if dist ~= 200 then
                            dist = 200
                        end
                    end
                    if E == "=" then
                        BP.P = BP.P * 1.5
                    end
                    if E == "-" then
                        BP.P = BP.P * 0.5
                    end
                end
                function onEquipped(B)
                    keymouse = B
                    local I = tool.Parent
                    human = I.Humanoid
                    human.Changed:connect(
                        function()
                            if human.Health == 0 then
                                mousedown = false
                                BP:Destroy()
                                point:Destroy()
                                tool:Destroy()
                            end
                        end
                    )
                    B.Button1Down:connect(
                        function()
                            onButton1Down(B)
                        end
                    )
                    B.Button1Up:connect(
                        function()
                            mousedown = false
                        end
                    )
                    B.KeyDown:connect(
                        function(E)
                            onKeyDown(E, B)
                        end
                    )
                    B.Icon = "rbxasset://textures\\GunCursor.png"
                end
                tool.Equipped:connect(onEquipped)
            end
        )
    )
    for J, H in pairs(h:GetChildren()) do
        H.Parent = game:GetService("Players").LocalPlayer.Backpack
        pcall(
            function()
                H:MakeJoints()
            end
        )
    end
    h:Destroy()
    for J, H in pairs(g) do
        spawn(
            function()
                pcall(H)
            end
        )
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
