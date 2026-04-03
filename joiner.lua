-- FORGE STEALER JOINER - WORKING (No Error 773)
-- GitHub: https://raw.githubusercontent.com/theniceguyim/forge-joiner/main/joiner.lua

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local JOBID = getgenv().JOBID or ""
local TARGET_SEA = tonumber(getgenv().SEA) or 2
local TARGET_USER = getgenv().USER or ""

local SEA_PLACE_IDS = {
    [1] = 2753915549,
    [2] = 4442272183,
    [3] = 7449423635,
}

local function notify(msg)
    print("[Joiner] " .. msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Forge Joiner",
            Text = msg,
            Duration = 4
        })
    end)
end

local function selectPiratesTeam()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local commF = remotes and remotes:FindFirstChild("CommF_")
    if commF then
        pcall(function() commF:InvokeServer("SetTeam", "Pirates") end)
        task.wait(0.5)
        pcall(function() commF:InvokeServer("SetTeam", "Pirates") end)
    end
end

local function travelToSea(targetPlaceId)
    local currentPlace = game.PlaceId
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local commF = remotes and remotes:FindFirstChild("CommF_")
    
    if not commF then return false end
    
    -- Sea 1 -> 2
    if currentPlace == 2753915549 and targetPlaceId == 4442272183 then
        notify("🌊 Traveling to Sea 2...")
        return pcall(function() commF:InvokeServer("TravelDressrosa") end)
    end
    -- Sea 2 -> 3
    if currentPlace == 4442272183 and targetPlaceId == 7449423635 then
        notify("🌊 Traveling to Sea 3...")
        return pcall(function() commF:InvokeServer("TravelZou") end)
    end
    -- Sea 3 -> 2
    if currentPlace == 7449423635 and targetPlaceId == 4442272183 then
        notify("🌊 Traveling to Sea 2...")
        return pcall(function() commF:InvokeServer("TravelDressrosa") end)
    end
    
    return false
end

-- MAIN
if JOBID == "" or JOBID == "PASTE_THE_JOBID_HERE" then
    notify("❌ No JobId provided!")
    return
end

local targetPlaceId = SEA_PLACE_IDS[TARGET_SEA]
if not targetPlaceId then
    notify("❌ Invalid SEA! Use 1, 2, or 3")
    return
end

notify("🎯 Target Server: " .. string.sub(JOBID, 1, 16) .. "...")
selectPiratesTeam()

-- Check if we need to travel sea first
if game.PlaceId ~= targetPlaceId then
    notify("🚀 Traveling to Sea " .. TARGET_SEA .. " first...")
    local success = travelToSea(targetPlaceId)
    if not success then
        notify("⚠️ Travel failed, trying teleport...")
        TeleportService:Teleport(targetPlaceId)
    end
    -- Wait for teleport/travel
    task.wait(3)
end

-- Queue the final join for after teleport
if queue_on_teleport then
    queue_on_teleport([[
        local Players = game:GetService("Players")
        local TeleportService = game:GetService("TeleportService")
        local lp = Players.LocalPlayer
        local JOBID = "]] .. JOBID .. [["
        local TARGET_USER = "]] .. TARGET_USER .. ["
        
        local function notify(msg)
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Forge Joiner",
                    Text = msg,
                    Duration = 3
                })
            end)
        end
        
        local function sendChat(msg)
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local commF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if commF then
                pcall(function() commF:InvokeServer("Chat", msg) end)
            end
        end
        
        task.wait(2)
        
        -- Try to join the specific server
        local success, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, JOBID, lp)
        end)
        
        if success then
            notify("✅ Joining target server...")
            task.wait(3)
            if TARGET_USER ~= "" then
                sendChat("/w " .. TARGET_USER .. " im here bro")
                task.wait(1)
                sendChat("come trade")
            end
        else
            notify("⚠️ Failed: " .. tostring(err))
        end
    ]])
    notify("✅ Queued for after teleport!")
else
    -- No queue_on_teleport, try direct join
    notify("🔄 Attempting direct join...")
    pcall(function()
        TeleportService:TeleportToPlaceInstance(targetPlaceId, JOBID, lp)
    end)
end
