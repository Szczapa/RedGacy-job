local PlayerJob = {}

-- HOTEL STANDART
for k, v in pairs(Config.Locations["stash"]) do
    exports['qbr-core']:createPrompt("hotel:stash:"..k, vector3(v.x, v.y, v.z), Config.PromptKey, 'Hotel Stash', {
        type = 'client',
        event = 'hotel:promptStash',
    })
end

RegisterNetEvent('hotel:promptStash', function(k)
    exports['qbr-core']:GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job       
        if PlayerJob.name == "hotel"  then
            TriggerServerEvent("inventory:server:OpenInventory", "stash", "hotelstash_"..exports['qbr-core']:GetPlayerData().citizenid)
            TriggerEvent("inventory:client:SetCurrentStash", "hotelstash_"..exports['qbr-core']:GetPlayerData().citizenid)
        else
            exports['qbr-core']:Notify(9, Lang:t('error.not_hotel'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
        end
    end)
end)



