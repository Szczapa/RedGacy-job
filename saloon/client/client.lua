local PlayerJob = {}

-- saloon STANDART
for k, v in pairs(Config.Locations["stash"]) do
    exports['qbr-core']:createPrompt("saloon:stash:"..k, vector3(v.x, v.y, v.z), Config.PromptKey, 'Saloon Stash', {
        type = 'client',
        event = 'saloon:promptStash',
    })
end

RegisterNetEvent('saloon:promptStash', function(k)
    exports['qbr-core']:GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job       
        if PlayerJob.name == "saloon"  then
            TriggerServerEvent("inventory:server:OpenInventory", "stash", "saloonstash_"..exports['qbr-core']:GetPlayerData().citizenid)
            TriggerEvent("inventory:client:SetCurrentStash", "saloonstash_"..exports['qbr-core']:GetPlayerData().citizenid)
        else
            exports['qbr-core']:Notify(3, Lang:t('error.not_saloon'), 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
        end
    end)
end)

-------------------------------------------------------------------------
