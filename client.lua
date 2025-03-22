local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('FrontDesk:handleAssistance', function()
    local playerData = QBCore.Functions.GetPlayerData()
    local charInfo = playerData.charinfo
    local playerName = charInfo.firstname .. " " .. charInfo.lastname

    if playerData.job and playerData.job.name == "police" then
        local menu = {
            {
                header = "Front Desk Options",
                isMenuHeader = true,
            },
            {
                header = "Contact High Command",
                txt = "Notify high command for assistance.",
                params = {
                    event = "FrontDesk:openHighCommand",
                    args = { playerName = playerName, jobGrade = playerData.job.grade }
                }
            },
            {
                header = "Close",
                txt = "",
                params = {
                    event = "qb-menu:closeMenu"
                }
            }
        }
        exports['qb-menu']:openMenu(menu)
    else
        TriggerServerEvent('FrontDesk:notifyPD', playerName)
    end
end)

RegisterNetEvent('FrontDesk:openHighCommand', function(data)
    local playerName = data.playerName
    local jobGrade = data.jobGrade
    TriggerServerEvent('FrontDesk:notifyHighCommand', playerName, jobGrade)
    TriggerEvent("qb-menu:closeMenu")
end)

RegisterNetEvent('FrontDesk:reportAcknowledged', function(message, blipCoords)
    QBCore.Functions.Notify(message, "success")
    local blip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z)
    SetBlipSprite(blip, 42)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Assistance Report")
    EndTextCommandSetBlipName(blip)
    Citizen.SetTimeout(30000, function()
        RemoveBlip(blip)
    end)
end)

RegisterNetEvent('FrontDesk:clientNotify', function(message, notifyType)
    QBCore.Functions.Notify(message, notifyType)
end)
