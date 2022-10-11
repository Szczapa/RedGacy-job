-- exports['qbr-core']:AddCommand("random", "random action test", {}, false, function(source)
-- 	src = source
-- 	TriggerClientEvent('Random', src)
-- end)
RegisterNetEvent('removeblip', function(blip)
    RemoveBlip(blip)
    print('server',blip)
end)