-- FORGE STEALER JOINER - Part 1
-- GitHub Raw: https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/joiner.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer

-- CONFIGURATION (set these before running)
local JOBID = getgenv().JOBID or ""
local TARGET_SEA = tonumber(getgenv().SEA) or 2
local TARGET_USER = getgenv().USER or ""
local PART2_URL = getgenv().PART2_URL or "https://raw.githubusercontent.com/theniceguyim/forge-joiner/main/joiner_part2.lua"

local SEA_PLACE_IDS = {
    [1] = 2753915549,
    [2] = 4442272183,
    [3] = 7449423635,
}

-- Notifier UI
local function createNotifier()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ForgeJoiner"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui
    
    local holder = Instance.new("Frame")
    holder.Name = "Holder"
    holder.AnchorPoint = Vector2.new(1, 1)
    holder.Position = UDim2.new(1, -20, 1, -20)
    holder.Size = UDim2.new(0, 340, 0, 0)
    holder.BackgroundTransparency = 1
    holder.Parent = screenGui
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.Padding = UDim.new(0, 8)
    layout.Parent = holder
    
    return holder
end

local notifierHolder = createNotifier()

local function notify(title, text, duration, isError)
    duration = duration or 4
    isError = isError or false
    
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = isError and Color3.fromRGB(40, 20, 25) or Color3.fromRGB(16, 18, 28)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Size = UDim2.new(0, 320, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.Parent = notifierHolder
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = isError and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(80, 180, 255)
    stroke.Thickness = 1.5
    stroke.Parent = frame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = frame
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamSemibold
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextColor3 = isError and Color3.fromRGB(255, 120, 120) or Color3.fromRGB(210, 230, 255)
    titleLbl.Text = title
    titleLbl.Size = UDim2.new(1, 0, 0, 18)
    titleLbl.Parent = frame
    
    local msgLbl = Instance.new("TextLabel")
    msgLbl.BackgroundTransparency = 1
    msgLbl.Font = Enum.Font.Gotham
    msgLbl.TextSize = 12
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.TextYAlignment = Enum.TextYAlignment.Top
    msgLbl.TextWrapped = true
    msgLbl.TextColor3 = Color3.fromRGB(190, 200, 220)
    msgLbl.Text = text
    msgLbl.Size = UDim2.new(1, 0, 0, 0)
    msgLbl.AutomaticSize = Enum.AutomaticSize.Y
    msgLbl.Parent = frame
    
    frame.Size = UDim2.new(0, 320, 0, titleLbl.TextBounds.Y + msgLbl.TextBounds.Y + 30)
    
    task.delay(duration, function()
        if frame and frame.Parent then
            local tween = TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 320, 0, 0)
            })
            tween:Play()
            tween.Completed:Wait()
            frame:Destroy()
        end
    end)
end

local function selectPiratesTeam()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local commF = remotes and remotes:FindFirstChild("CommF_")
    
    if commF then
        notify("⚔️ Forge Joiner", "Selecting Pirates team...", 2)
        for i = 1, 2 do
            pcall(function() commF:InvokeServer("SetTeam", "Pirates") end)
            task.wait(0.3)
        end
        task.wait(1)
    end
end

local function travelToSea(targetPlaceId)
    local currentPlace = game.PlaceId
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local commF = remotes and remotes:FindFirstChild("CommF_")
    
    if commF then
        if currentPlace == 2753915549 and targetPlaceId == 4442272183 then
            notify("🌊 Forge Joiner", "Traveling: First Sea → Second Sea", 3)
            return pcall(function() commF:InvokeServer("TravelDressrosa") end)
        end
        if currentPlace == 4442272183 and targetPlaceId == 7449423635 then
            notify("🌊 Forge Joiner", "Traveling: Second Sea → Third Sea", 3)
            return pcall(function() commF:InvokeServer("TravelZou") end)
        end
        if currentPlace == 7449423635 and targetPlaceId == 4442272183 then
            notify("🌊 Forge Joiner", "Traveling: Third Sea → Second Sea", 3)
            return pcall(function() commF:InvokeServer("TravelDressrosa") end)
        end
    end
    
    notify("⚠️ Forge Joiner", "Using fallback teleport method...", 2)
    return pcall(function() TeleportService:Teleport(targetPlaceId) end)
end

local function sendArrivalMessage()
    task.wait(3)
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local commF = remotes and remotes:FindFirstChild("CommF_")
    
    if commF and TARGET_USER and TARGET_USER ~= "" then
        pcall(function() commF:InvokeServer("Chat", "/w " .. TARGET_USER .. " im here bro") end)
        task.wait(1)
        pcall(function() commF:InvokeServer("Chat", "im here bro, come trade") end)
    end
    notify("✅ Forge Joiner", "Arrived and ready to trade!", 3)
end

-- MAIN EXECUTION
if JOBID == "" or JOBID == "PASTE_THE_JOBID_HERE" then
    notify("❌ Forge Joiner", "Invalid JobId! Set getgenv().JOBID", 5, true)
    return
end

local targetPlaceId = SEA_PLACE_IDS[TARGET_SEA]
if not targetPlaceId then
    notify("❌ Forge Joiner", "Invalid SEA! Use 1, 2, or 3", 5, true)
    return
end

notify("⚔️ Forge Stealer Joiner", "Target: Sea " .. TARGET_SEA .. "\nJobId: " .. string.sub(JOBID, 1, 16) .. "...", 4)

selectPiratesTeam()

if game.PlaceId == targetPlaceId then
    notify("📍 Forge Joiner", "Already in target sea!\nJoining specific server...", 3)
    
    if queue_on_teleport then
        queue_on_teleport('getgenv().JOBID = "' .. JOBID .. '"; getgenv().SEA = "' .. TARGET_SEA .. '"; getgenv().USER = "' .. TARGET_USER .. '"; loadstring(game:HttpGet("' .. PART2_URL .. '"))()')
    end
    
    TeleportService:TeleportToPlaceInstance(targetPlaceId, JOBID, lp)
else
    notify("🚀 Forge Joiner", "Traveling to Sea " .. TARGET_SEA .. "...", 3)
    
    if queue_on_teleport then
        queue_on_teleport('getgenv().JOBID = "' .. JOBID .. '"; getgenv().SEA = "' .. TARGET_SEA .. '"; getgenv().USER = "' .. TARGET_USER .. '"; loadstring(game:HttpGet("' .. PART2_URL .. '"))()')
    end
    
    local success, err = travelToSea(targetPlaceId)
    if not success then
        notify("⚠️ Forge Joiner", "Travel failed, retrying with teleport...", 3)
        task.wait(2)
        TeleportService:Teleport(targetPlaceId)
    end
end

if game.PlaceId == targetPlaceId then
    task.wait(2)
    loadstring(game:HttpGet(PART2_URL))()
end
