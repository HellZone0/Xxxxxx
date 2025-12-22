-- Vertex Premium: Ultimate Lag Bomb UI
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Config
local SpamObjects = {}
local IsSpamming = false
local SpamThread = nil
local UIDragging = false
local UIDragStartPos = nil
local UIMinimized = false

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local TitleText = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")
local DragHitbox = Instance.new("TextButton")

-- Content Frame
local ContentFrame = Instance.new("Frame")
local ScrollFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- Controls
local StartBtn = Instance.new("TextButton")
local StopBtn = Instance.new("TextButton")
local ClearBtn = Instance.new("TextButton")

-- Settings
local ObjectType = Instance.new("TextLabel")
local PartBtn = Instance.new("TextButton")
local MeshBtn = Instance.new("TextButton")
local UnionBtn = Instance.new("TextButton")
local ScriptBtn = Instance.new("TextButton")

local SpawnRate = Instance.new("TextLabel")
local RateSlider = Instance.new("TextButton")
local RateValue = Instance.new("TextLabel")

local SpawnAmount = Instance.new("TextLabel")
local AmountSlider = Instance.new("TextButton")
local AmountValue = Instance.new("TextLabel")

local SpawnLocation = Instance.new("TextLabel")
local PlayerLocationBtn = Instance.new("TextButton")
local RandomLocationBtn = Instance.new("TextButton")
local MapCenterBtn = Instance.new("TextButton")

local AdvancedLabel = Instance.new("TextLabel")
local AddPhysicsBtn = Instance.new("TextButton")
local AddScriptsBtn = Instance.new("TextButton")
local CollisionEnabledBtn = Instance.new("TextButton")
local CanQueryBtn = Instance.new("TextButton")

-- Stats
local StatsLabel = Instance.new("TextLabel")
local ObjectsCount = Instance.new("TextLabel")
local FPSDisplay = Instance.new("TextLabel")
local PingDisplay = Instance.new("TextLabel")

-- Setup ScreenGui
ScreenGui.Name = "VertexLagBomb"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
MainFrame.Active = true
MainFrame.Selectable = true
MainFrame.Draggable = false
MainFrame.Parent = ScreenGui

-- Title Bar
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "VERTEX LAG BOMB v3.0"
TitleText.TextColor3 = Color3.fromRGB(255, 50, 50)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar
TitleText.Position = UDim2.new(0.02, 0, 0, 0)

-- Drag Hitbox (invisible draggable area)
DragHitbox.Name = "DragHitbox"
DragHitbox.Size = UDim2.new(0.7, 0, 1, 0)
DragHitbox.BackgroundTransparency = 1
DragHitbox.Text = ""
DragHitbox.Parent = TitleBar

-- Minimize Button
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(0.85, 0, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.Parent = TitleBar

-- Close Button
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.925, 0, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar

-- Content Frame
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -10, 1, -40)
ContentFrame.Position = UDim2.new(0, 5, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Scrolling Frame
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
ScrollFrame.Parent = ContentFrame

UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Function to create control section
local function createSection(title)
    local section = Instance.new("Frame")
    local label = Instance.new("TextLabel")
    
    section.Name = title .. "Section"
    section.Size = UDim2.new(1, 0, 0, 40)
    section.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    section.BorderSizePixel = 1
    section.BorderColor3 = Color3.fromRGB(50, 50, 60)
    
    label.Name = title .. "Label"
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
    
    section.Parent = ScrollFrame
    return section
end

-- Function to create button
local function createButton(parent, text, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.48, 0, 0, 30)
    btn.Position = UDim2.new(0.01, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 80)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = parent
    return btn
end

-- Create control sections
local controlSection = createSection("CONTROL")
StartBtn = createButton(controlSection, "START SPAM", 25, Color3.fromRGB(200, 60, 60))
StartBtn.Position = UDim2.new(0.01, 0, 0, 25)
StopBtn = createButton(controlSection, "STOP SPAM", 25, Color3.fromRGB(60, 120, 200))
StopBtn.Position = UDim2.new(0.51, 0, 0, 25)
ClearBtn = createButton(controlSection, "CLEAR OBJECTS", 60, Color3.fromRGB(200, 120, 60))
ClearBtn.Size = UDim2.new(0.98, 0, 0, 30)

local objectSection = createSection("OBJECT TYPE")
objectSection.Size = UDim2.new(1, 0, 0, 70)
PartBtn = createButton(objectSection, "PARTS", 25, Color3.fromRGB(80, 80, 100))
MeshBtn = createButton(objectSection, "MESH PARTS", 25, Color3.fromRGB(80, 80, 100))
MeshBtn.Position = UDim2.new(0.51, 0, 0, 25)
UnionBtn = createButton(objectSection, "UNIONS", 60, Color3.fromRGB(80, 80, 100))
ScriptBtn = createButton(objectSection, "SCRIPTED", 60, Color3.fromRGB(80, 80, 100))
ScriptBtn.Position = UDim2.new(0.51, 0, 0, 60)

local rateSection = createSection("SPAWN RATE")
rateSection.Size = UDim2.new(1, 0, 0, 60)
RateSlider = createButton(rateSection, "ADJUST RATE", 25, Color3.fromRGB(70, 70, 90))
RateSlider.Size = UDim2.new(0.7, 0, 0, 30)
RateValue = Instance.new("TextLabel")
RateValue.Size = UDim2.new(0.25, 0, 0, 30)
RateValue.Position = UDim2.new(0.72, 0, 0, 25)
RateValue.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
RateValue.Text = "50/ms"
RateValue.TextColor3 = Color3.fromRGB(255, 100, 100)
RateValue.Font = Enum.Font.GothamBold
RateValue.TextSize = 12
RateValue.Parent = rateSection

local amountSection = createSection("SPAWN AMOUNT")
amountSection.Size = UDim2.new(1, 0, 0, 60)
AmountSlider = createButton(amountSection, "ADJUST AMOUNT", 25, Color3.fromRGB(70, 70, 90))
AmountSlider.Size = UDim2.new(0.7, 0, 0, 30)
AmountValue = Instance.new("TextLabel")
AmountValue.Size = UDim2.new(0.25, 0, 0, 30)
AmountValue.Position = UDim2.new(0.72, 0, 0, 25)
AmountValue.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AmountValue.Text = "1000"
AmountValue.TextColor3 = Color3.fromRGB(255, 100, 100)
AmountValue.Font = Enum.Font.GothamBold
AmountValue.TextSize = 12
AmountValue.Parent = amountSection

local locationSection = createSection("SPAWN LOCATION")
locationSection.Size = UDim2.new(1, 0, 0, 100)
PlayerLocationBtn = createButton(locationSection, "PLAYER POS", 25, Color3.fromRGB(90, 90, 110))
RandomLocationBtn = createButton(locationSection, "RANDOM MAP", 25, Color3.fromRGB(90, 90, 110))
RandomLocationBtn.Position = UDim2.new(0.51, 0, 0, 25)
MapCenterBtn = createButton(locationSection, "MAP CENTER", 60, Color3.fromRGB(90, 90, 110))

local advancedSection = createSection("ADVANCED OPTIONS")
advancedSection.Size = UDim2.new(1, 0, 0, 100)
AddPhysicsBtn = createButton(advancedSection, "PHYSICS: ON", 25, Color3.fromRGB(100, 60, 100))
AddScriptsBtn = createButton(advancedSection, "SCRIPTS: OFF", 25, Color3.fromRGB(100, 60, 100))
AddScriptsBtn.Position = UDim2.new(0.51, 0, 0, 25)
CollisionEnabledBtn = createButton(advancedSection, "COLLISION: ON", 60, Color3.fromRGB(100, 60, 100))
CanQueryBtn = createButton(advancedSection, "CANQUERY: ON", 60, Color3.fromRGB(100, 60, 100))
CanQueryBtn.Position = UDim2.new(0.51, 0, 0, 60)

local statsSection = createSection("SERVER STATS")
statsSection.Size = UDim2.new(1, 0, 0, 90)
ObjectsCount = Instance.new("TextLabel")
ObjectsCount.Size = UDim2.new(1, -10, 0, 25)
ObjectsCount.Position = UDim2.new(0, 5, 0, 25)
ObjectsCount.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ObjectsCount.Text = "OBJECTS SPAWNED: 0"
ObjectsCount.TextColor3 = Color3.fromRGB(255, 150, 150)
ObjectsCount.Font = Enum.Font.Gotham
ObjectsCount.TextSize = 13
ObjectsCount.Parent = statsSection

FPSDisplay = Instance.new("TextLabel")
FPSDisplay.Size = UDim2.new(1, -10, 0, 25)
FPSDisplay.Position = UDim2.new(0, 5, 0, 55)
FPSDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
FPSDisplay.Text = "SERVER FPS: --"
FPSDisplay.TextColor3 = Color3.fromRGB(150, 255, 150)
FPSDisplay.Font = Enum.Font.Gotham
FPSDisplay.TextSize = 13
FPSDisplay.Parent = statsSection

-- Variables
local CurrentObjectType = "Part"
local SpawnRateValue = 50
local MaxObjects = 1000
local SpawnAtPlayer = true
local AddPhysics = true
local AddScripts = false
local CollisionOn = true
local CanQueryOn = true

-- UI Interaction Functions
local function updateStats()
    ObjectsCount.Text = "OBJECTS SPAWNED: " .. #SpamObjects
end

local function toggleButton(button, enabled)
    if enabled then
        button.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
    else
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end

-- Initialize buttons
toggleButton(PartBtn, true)
toggleButton(PlayerLocationBtn, true)
toggleButton(AddPhysicsBtn, AddPhysics)
toggleButton(AddScriptsBtn, AddScripts)
toggleButton(CollisionEnabledBtn, CollisionOn)
toggleButton(CanQueryBtn, CanQueryOn)

-- Object Type Selection
PartBtn.MouseButton1Click:Connect(function()
    CurrentObjectType = "Part"
    toggleButton(PartBtn, true)
    toggleButton(MeshBtn, false)
    toggleButton(UnionBtn, false)
    toggleButton(ScriptBtn, false)
end)

MeshBtn.MouseButton1Click:Connect(function()
    CurrentObjectType = "MeshPart"
    toggleButton(PartBtn, false)
    toggleButton(MeshBtn, true)
    toggleButton(UnionBtn, false)
    toggleButton(ScriptBtn, false)
end)

UnionBtn.MouseButton1Click:Connect(function()
    CurrentObjectType = "UnionOperation"
    toggleButton(PartBtn, false)
    toggleButton(MeshBtn, false)
    toggleButton(UnionBtn, true)
    toggleButton(ScriptBtn, false)
end)

ScriptBtn.MouseButton1Click:Connect(function()
    CurrentObjectType = "Script"
    toggleButton(PartBtn, false)
    toggleButton(MeshBtn, false)
    toggleButton(UnionBtn, false)
    toggleButton(ScriptBtn, true)
end)

-- Location Selection
PlayerLocationBtn.MouseButton1Click:Connect(function()
    SpawnAtPlayer = true
    toggleButton(PlayerLocationBtn, true)
    toggleButton(RandomLocationBtn, false)
    toggleButton(MapCenterBtn, false)
end)

RandomLocationBtn.MouseButton1Click:Connect(function()
    SpawnAtPlayer = false
    toggleButton(PlayerLocationBtn, false)
    toggleButton(RandomLocationBtn, true)
    toggleButton(MapCenterBtn, false)
end)

MapCenterBtn.MouseButton1Click:Connect(function()
    SpawnAtPlayer = false
    toggleButton(PlayerLocationBtn, false)
    toggleButton(RandomLocationBtn, false)
    toggleButton(MapCenterBtn, true)
end)

-- Advanced Options
AddPhysicsBtn.MouseButton1Click:Connect(function()
    AddPhysics = not AddPhysics
    AddPhysicsBtn.Text = "PHYSICS: " .. (AddPhysics and "ON" or "OFF")
    toggleButton(AddPhysicsBtn, AddPhysics)
end)

AddScriptsBtn.MouseButton1Click:Connect(function()
    AddScripts = not AddScripts
    AddScriptsBtn.Text = "SCRIPTS: " .. (AddScripts and "ON" or "OFF")
    toggleButton(AddScriptsBtn, AddScripts)
end)

CollisionEnabledBtn.MouseButton1Click:Connect(function()
    CollisionOn = not CollisionOn
    CollisionEnabledBtn.Text = "COLLISION: " .. (CollisionOn and "ON" or "OFF")
    toggleButton(CollisionEnabledBtn, CollisionOn)
end)

CanQueryBtn.MouseButton1Click:Connect(function()
    CanQueryOn = not CanQueryOn
    CanQueryBtn.Text = "CANQUERY: " .. (CanQueryOn and "ON" or "OFF")
    toggleButton(CanQueryBtn, CanQueryOn)
end)

-- Rate Slider
RateSlider.MouseButton1Down:Connect(function()
    local startX = RateSlider.AbsolutePosition.X
    local endX = startX + RateSlider.AbsoluteSize.X
    
    local connection
    connection = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local percentage = math.clamp((mouseX - startX) / (endX - startX), 0, 1)
            SpawnRateValue = math.floor(1 + percentage * 199) -- 1 to 200 objects per ms
            RateValue.Text = SpawnRateValue .. "/ms"
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            connection:Disconnect()
        end
    end)
end)

-- Amount Slider
AmountSlider.MouseButton1Down:Connect(function()
    local startX = AmountSlider.AbsolutePosition.X
    local endX = startX + AmountSlider.AbsoluteSize.X
    
    local connection
    connection = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local percentage = math.clamp((mouseX - startX) / (endX - startX), 0, 1)
            MaxObjects = math.floor(100 + percentage * 9900) -- 100 to 10000 objects
            AmountValue.Text = MaxObjects
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            connection:Disconnect()
        end
    end)
end)

-- Object Spawning Function
local function createLagObject()
    local obj
    
    if CurrentObjectType == "Part" then
        obj = Instance.new("Part")
        obj.Shape = Enum.PartType.Ball
        obj.Material = Enum.Material.Neon
        obj.Color = Color3.fromRGB(math.random(50, 255), math.random(50, 255), math.random(50, 255))
        obj.Size = Vector3.new(math.random(5, 20), math.random(5, 20), math.random(5, 20))
        
    elseif CurrentObjectType == "MeshPart" then
        obj = Instance.new("MeshPart")
        obj.MeshId = "rbxassetid://" .. tostring(math.random(1000000, 9999999))
        obj.TextureID = "rbxassetid://" .. tostring(math.random(1000000, 9999999))
        obj.Size = Vector3.new(math.random(10, 30), math.random(10, 30), math.random(10, 30))
        
    elseif CurrentObjectType == "UnionOperation" then
        obj = Instance.new("UnionOperation")
        local part1 = Instance.new("Part")
        part1.Size = Vector3.new(10, 10, 10)
        part1.Parent = obj
        obj.UsePartColor = true
        obj.Color = Color3.fromRGB(math.random(50, 255), math.random(50, 255), math.random(50, 255))
        
    elseif CurrentObjectType == "Script" then
        obj = Instance.new("Script")
        local source = "-- Lag Script\n"
        for i = 1, 1000 do
            source = source .. "local x" .. i .. " = " .. i .. "\n"
        end
        source = source .. "while true do\n"
        source = source .. "    for i = 1, 1000 do\n"
        source = source .. "        _G['lag'..i] = math.random()\n"
        source = source .. "    end\n"
        source = source .. "    wait(0.01)\n"
        source = source .. "end\n"
        obj.Source = source
    end
    
    if obj then
        if obj:IsA("BasePart") then
            -- Set position
            local position
            if SpawnAtPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                position = LocalPlayer.Character.HumanoidRootPart.Position + 
                          Vector3.new(math.random(-50, 50), math.random(0, 50), math.random(-50, 50))
            elseif MapCenterBtn.BackgroundColor3 == Color3.fromRGB(60, 180, 80) then
                position = Vector3.new(0, 50, 0)
            else
                position = Vector3.new(
                    math.random(-500, 500),
                    math.random(0, 100),
                    math.random(-500, 500)
                )
            end
            
            obj.Position = position
            obj.Anchored = not AddPhysics
            obj.CanCollide = CollisionOn
            obj.CanQuery = CanQueryOn
            
            if AddPhysics and not obj.Anchored then
                obj.Velocity = Vector3.new(
                    math.random(-100, 100),
                    math.random(-50, 100),
                    math.random(-100, 100)
                )
            end
            
            -- Add random rotation
            obj.Orientation = Vector3.new(
                math.random(0, 360),
                math.random(0, 360),
                math.random(0, 360)
            )
            
            -- Add to workspace
            obj.Parent = Workspace
        else
            -- For scripts, parent to workspace
            obj.Parent = Workspace
        end
        
        table.insert(SpamObjects, obj)
        
        -- Add deletion script if enabled
        if AddScripts and obj:IsA("BasePart") then
            local script = Instance.new("Script")
            script.Source = [[
                local part = script.Parent
                while true do
                    part.CFrame = part.CFrame * CFrame.Angles(
                        math.rad(1),
                        math.rad(1),
                        math.rad(1)
                    )
                    part.Transparency = math.sin(tick()) / 2 + 0.5
                    wait()
                end
            ]]
            script.Parent = obj
        end
    end
    
    updateStats()
end

-- Spam Control
StartBtn.MouseButton1Click:Connect(function()
    if IsSpamming then return end
    
    IsSpamming = true
    StartBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    StopBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    
    SpamThread = task.spawn(function()
        local count = 0
        while IsSpamming and count < MaxObjects do
            local batchSize = math.min(SpawnRateValue, MaxObjects - count)
            for i = 1, batchSize do
                pcall(createLagObject)
                count = count + 1
                if not IsSpamming then break end
            end
            task.wait(0.001) -- Small delay to prevent freezing client completely
        end
        IsSpamming = false
        StartBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    end)
end)

StopBtn.MouseButton1Click:Connect(function()
    IsSpamming = false
    if SpamThread then
        task.cancel(SpamThread)
        SpamThread = nil
    end
    StartBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
end)

ClearBtn.MouseButton1Click:Connect(function()
    StopBtn.MouseButton1Click:Fire()
    
    task.wait(0.1)
    
    for _, obj in ipairs(SpamObjects) do
        pcall(function()
            obj:Destroy()
        end)
    end
    
    SpamObjects = {}
    updateStats()
end)

-- UI Dragging
DragHitbox.MouseButton1Down:Connect(function()
    UIDragging = true
    UIDragStartPos = UserInputService:GetMouseLocation() - Vector2.new(MainFrame.AbsolutePosition.X, MainFrame.AbsolutePosition.Y)
end)

UserInputService.InputChanged:Connect(function(input)
    if UIDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        MainFrame.Position = UDim2.new(
            0, mousePos.X - UIDragStartPos.X,
            0, mousePos.Y - UIDragStartPos.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        UIDragging = false
    end
end)

-- Minimize Function
MinimizeBtn.MouseButton1Click:Connect(function()
    UIMinimized = not UIMinimized
    if UIMinimized then
        ContentFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 400, 0, 30)
        MinimizeBtn.Text = "□"
    else
        ContentFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 400, 0, 500)
        MinimizeBtn.Text = "_"
    end
end)

-- Close Function (just hides UI)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
    -- Optional: Add keybind to re-enable
end)

-- FPS Monitoring
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            FPSDisplay.Text = "CLIENT FPS: " .. fps
            
            if fps < 30 then
                FPSDisplay.TextColor3 = Color3.fromRGB(255, 100, 100)
            elseif fps < 60 then
                FPSDisplay.TextColor3 = Color3.fromRGB(255, 200, 100)
            else
                FPSDisplay.TextColor3 = Color3.fromRGB(150, 255, 150)
            end
        end)
    end
end)

-- Keybind to show/hide UI (F9)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F9 then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("Vertex Lag Bomb UI Loaded!")
print("Press F9 to hide/show interface")
print("Features: Drag UI, Minimize, Object Spam, Physics, Scripts")