local sharedItems = exports['qbr-core']:GetItems()
local spawner = Config.spawn 
local time = 0

RegisterNetEvent('Random', function()
    local lenght = #spawner   
    local randomV = math.random(1,lenght)    
    local i = randomV    
    TriggerEvent('spawn', i)
    
end)

function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end

-- function de spawn de la  cible
RegisterNetEvent('spawn', function(i)
    print("je spawn")
    while not HasModelLoaded( GetHashKey(Config.spawn[i]["Model"]) ) do                      
        Wait(500)
        modelrequest( GetHashKey(Config.spawn[i]["Model"]) )
    end
    local npc = CreatePed(GetHashKey(Config.spawn[i]["Model"]), Config.spawn[i]["Pos"].x, Config.spawn[i]["Pos"].y, Config.spawn[i]["Pos"].z, true, false, 0, 0)
    while not DoesEntityExist(npc) do
        Wait(300)
    end    
    TaskCombatPed(npc, PlayerPedId())
    coord = GetEntityCoords(npc)
    TriggerEvent("AddBlip",coord)
    --spawn de la zone de chasse 
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
    TaskCombatPed(npc, PlayerPedId())
    modeltodelete = npc
    timer()
end)

   

RegisterNetEvent('AddBlip', function(coord)
    blip = Citizen.InvokeNative(0x45f13b7e0a15c880, -1282792512, coord.x, coord.y, coord.z, 150.0)    
    timer()
end)

function timer()
    local time = (Config.timer*60) -- 10 seconds
    while (time ~= 0) do -- Whist we have time to wait
        Wait( 1000 ) -- Wait a second
        time = time - 1       
        -- 1 Second should have past by now
    end
    print('client', blip)
    RemoveBlip(blip)
    print('client2', blip)
    TriggerServerEvent('removeblip', blip)
    deleteped()
end

function deleteped()
	local entity = modeltodelete
    NetworkRequestControlOfEntity(entity)
    local timeout = 2000
    while timeout > 0 and not NetworkHasControlOfEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end
    SetEntityAsMissionEntity(entity, true, true)
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
    
    if (DoesEntityExist(entity)) then 
		DeleteEntity(entity)
		modeltodelete = nil
	end
	modeltodelete = nil
end