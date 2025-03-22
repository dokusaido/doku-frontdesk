local QBCore = exports['qb-core']:GetCoreObject()
local requiredGradeForHighCommand = 3 -- Adjust as needed
local cooldownTime = 60 -- Cooldown in seconds
local reportCooldown = {}

local frontDeskCoords = vector3(-584.1972, -415.3718, 35.0)
local doorbellVolume = 1.5
local doorbellDistance = 20.0
local function isOnCooldown(src)
    if reportCooldown[src] then
        if os.time() - reportCooldown[src] < cooldownTime then
            return true
        end
    end
    return false
end
local function playDoorbellSound()
    for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(playerId)
        if xPlayer then
            local targetSrc = xPlayer.PlayerData.source
            -- Get the player's ped coordinates
            local ped = GetPlayerPed(targetSrc)
            if DoesEntityExist(ped) then
                local playerCoords = GetEntityCoords(ped)
                if #(playerCoords - frontDeskCoords) < doorbellDistance then
                    TriggerClientEvent('InteractSound_CL:PlayOnOne', targetSrc, 'doorbell', doorbellVolume)
                end
            end
        end
    end
end
RegisterNetEvent('FrontDesk:notifyPD', function(playerName)
    local src = source
    print("[DEBUG] notifyPD triggered by source:", src, "for", playerName)
    if isOnCooldown(src) then
        TriggerClientEvent('FrontDesk:clientNotify', src, "Please wait before sending another report.", "error")
        return
    end
    reportCooldown[src] = os.time()
    for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(playerId)
        if xPlayer and xPlayer.PlayerData.job and xPlayer.PlayerData.job.name == "police" then
            TriggerClientEvent('FrontDesk:clientNotify', xPlayer.PlayerData.source, 
                "Assistance Requested: " .. playerName .. " is requesting assistance at the PD Front Desk.", 
                "success")
        end
    end
    playDoorbellSound()
    TriggerClientEvent('FrontDesk:reportAcknowledged', src, "Police have been notified.", frontDeskCoords)
end)
RegisterNetEvent('FrontDesk:notifyHighCommand', function(playerName, jobGrade)
    local src = source
    print("[DEBUG] notifyHighCommand triggered by source:", src, "for", playerName)
    if isOnCooldown(src) then
        TriggerClientEvent('FrontDesk:clientNotify', src, "Please wait before sending another report.", "error")
        return
    end
    reportCooldown[src] = os.time()
    for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(playerId)
        if xPlayer and xPlayer.PlayerData.job and xPlayer.PlayerData.job.name == "police" then
            local playerJobGrade = xPlayer.PlayerData.job.grade
            if type(playerJobGrade) == "table" then
                playerJobGrade = playerJobGrade.level  -- Adjust key if needed.
            end
            if playerJobGrade >= requiredGradeForHighCommand then
                TriggerClientEvent('FrontDesk:clientNotify', xPlayer.PlayerData.source, 
                    "High Command Alert: " .. playerName .. " is requesting assistance at the PD Front Desk.", 
                    "success")
            end
        end
    end
    playDoorbellSound()
    TriggerClientEvent('FrontDesk:reportAcknowledged', src, "High Command has been notified.", frontDeskCoords)
end)
