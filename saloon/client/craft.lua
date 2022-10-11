local sharedItems = exports['qbr-core']:GetItems()
local saloonkit = 0
local cuisinekit = 0
isLoggedIn = false
PlayerJob = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = exports['qbr-core']:GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(9)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

-- setup saloonkit
RegisterNetEvent('saloon:client:saloonkit')
AddEventHandler('saloon:client:saloonkit', function(itemName) 
    if saloonkit ~= 0 then
        SetEntityAsMissionEntity(saloonkit)
        DeleteObject(saloonkit)
        saloonkit = 0
    else
		local playerPed = PlayerPedId()
		TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 10000, true, false, false, false)
		Wait(10000)
		ClearPedTasks(playerPed)
		SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.75, -1.55))
		--local modelHash = `p_still03x`
		local modelHash = GetHashKey(Config.Prop)
		if not HasModelLoaded(modelHash) then
			-- If the model isnt loaded we request the loading of the model and wait that the model is loaded
			RequestModel(modelHash)
			while not HasModelLoaded(modelHash) do
				Wait(1)
			end
		end
		local prop = CreateObject(modelHash, x, y, z, true)
		SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
		PlaceObjectOnGroundProperly(prop)
		PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
		saloonkit = prop
	end
end, false)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
		local saloonObject = GetClosestObjectOfType(pos, 5.0, GetHashKey(Config.Prop), false, false, false)
		if saloonObject ~= 0 and PlayerJob.name ~= Config.LawJobName then
			local objectPos = GetEntityCoords(saloonObject)
			if #(pos - objectPos) < 3.0 then
				awayFromObject = false
				DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "~g~J~w~ Utiliser ~g~E~w~ Démonter")
				if IsControlJustReleased(0, 0xF3830D8E) then -- [J]
					TriggerEvent('saloon:client:alcool')
				end
				if IsControlJustReleased(0, 0x018C47CF) then -- [E]
					local player = PlayerPedId()
					TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 5000, true, false, false, false)
					Wait(5000)
					TriggerServerEvent('QBCore:Server:AddItem', "saloonkit", 1)
					ClearPedTasks(player)
					SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
					DeleteObject(saloonObject)
					PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
					exports['qbr-core']:Notify(9, 'Distilerie démonté!', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
					saloonkit = 0					
				end
			end
		else
			local objectPos = GetEntityCoords(saloonObject)
			if #(pos - objectPos) < 3.0 then
				awayFromObject = false
				DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "~g~J~w~ - Detruire")
				if IsControlJustReleased(0, 0xF3830D8E) then -- [J]
					local player = PlayerPedId()
					TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 5000, true, false, false, false)
					Wait(5000)
					ClearPedTasks(player)
					SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
					DeleteObject(saloonObject)
					PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
					exports['qbr-core']:Notify(9, 'moonshine destroyed!', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
				end
			end
		end
		if awayFromObject then
			Citizen.Wait(1000)
		end
	end
end)


-- alcool menu
RegisterNetEvent('saloon:client:alcool', function(data)
    exports['qbr-menu']:openMenu({
        {
            header = "| Saloon Alcool|",
            isMenuHeader = true,
        },
        {
            header = "Whisky",
            txt = "5 x Sugar 5 x Water and 5 x Corn",
            params = {
                event = 'saloon:client:Whisky',
				isServer = false,
            }
        },
        {
            header = "Bière",
            txt = "5 x Sugar 5 x Water and 5 x Corn",
            params = {
                event = 'saloon:client:Beer',
				isServer = false,
            }
        },
		{
            header = "Vodka",
            txt = "5 x Sugar 5 x Water and 5 x Corn",
            params = {
                event = 'saloon:client:vodka',
				isServer = false,
            }
        },
        {
            header = "Close Menu",
            txt = '',
            params = {
                event = 'qbr-menu:closeMenu',
            }
        },
    })
end)


-- make moonshine
RegisterNetEvent("saloon:client:Whisky")
AddEventHandler("saloon:client:Whisky", function()
	exports['qbr-core']:TriggerCallback('QBCore:HasItem', function(hasItem) 
		if hasItem then
			local player = PlayerPedId()
			TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), Config.BrewTime, true, false, false, false)
			Wait(Config.BrewTime)
			ClearPedTasks(player)
			SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
			TriggerServerEvent('QBCore:Server:RemoveItem', "sugar", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "corn", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "water", 5)
			TriggerServerEvent('QBCore:Server:AddItem', "whiskey", 5)
			TriggerEvent("inventory:client:ItemBox", sharedItems["whiskey"], "add")
			PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
			exports['qbr-core']:Notify(9, 'Vous avez fait 5 whiskey', 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			exports['qbr-core']:Notify(9, 'Vous n\'avez pas les ingrédients', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	end, { ['sugar'] = 5, ['corn'] = 5, ['water'] = 5 })
end)

RegisterNetEvent("saloon:client:Beer")
AddEventHandler("saloon:client:Beer", function()
	exports['qbr-core']:TriggerCallback('QBCore:HasItem', function(hasItem) 
		if hasItem then
			local player = PlayerPedId()
			TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), Config.BrewTime, true, false, false, false)
			Wait(Config.BrewTime)
			ClearPedTasks(player)
			SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
			TriggerServerEvent('QBCore:Server:RemoveItem', "sugar", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "corn", 1)
			TriggerServerEvent('QBCore:Server:RemoveItem', "water", 5)
			TriggerServerEvent('QBCore:Server:AddItem', "beer", 5)
			TriggerEvent("inventory:client:ItemBox", sharedItems["beer"], "add")
			PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
			exports['qbr-core']:Notify(9, 'Vous avez fait 5 biere', 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			exports['qbr-core']:Notify(9, 'Vous n\'avez pas les ingrédients', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	end, { ['sugar'] = 5, ['corn'] = 5, ['water'] = 5 })
end)

RegisterNetEvent("saloon:client:Coffee")
AddEventHandler("saloon:client:Coffee", function()
	exports['qbr-core']:TriggerCallback('QBCore:HasItem', function(hasItem) 
		if hasItem then
			local player = PlayerPedId()
			TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), Config.BrewTime, true, false, false, false)
			Wait(Config.BrewTime)
			ClearPedTasks(player)
			SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
			TriggerServerEvent('QBCore:Server:RemoveItem', "sugar", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "corn", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "water", 5)
			TriggerServerEvent('QBCore:Server:AddItem', "cafe", 5)
			TriggerEvent("inventory:client:ItemBox", sharedItems["cafe"], "add")
			PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
			exports['qbr-core']:Notify(9, 'Vous avez fait 5 cafe', 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			exports['qbr-core']:Notify(9, 'Vous n\'avez pas les ingrédients', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	end, { ['sugar'] = 5, ['corn'] = 5, ['water'] = 5 })
end)
RegisterNetEvent("saloon:client:infusion")
AddEventHandler("saloon:client:infusion", function()
	exports['qbr-core']:TriggerCallback('QBCore:HasItem', function(hasItem) 
		if hasItem then
			local player = PlayerPedId()
			TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), Config.BrewTime, true, false, false, false)
			Wait(Config.BrewTime)
			ClearPedTasks(player)
			SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
			TriggerServerEvent('QBCore:Server:RemoveItem', "sugar", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "corn", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "water", 5)
			TriggerServerEvent('QBCore:Server:AddItem', "infusion", 5)
			TriggerEvent("inventory:client:ItemBox", sharedItems["infusion"], "add")
			PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
			exports['qbr-core']:Notify(9, 'Vous avez fait 5 infusion', 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			exports['qbr-core']:Notify(9, 'Vous n\'avez pas les ingrédients', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	end, { ['sugar'] = 5, ['corn'] = 5, ['water'] = 5 })
end)

RegisterNetEvent("saloon:client:Vodka")
AddEventHandler("saloon:client:Vodka", function()
	exports['qbr-core']:TriggerCallback('QBCore:HasItem', function(hasItem) 
		if hasItem then
			local player = PlayerPedId()
			TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), Config.BrewTime, true, false, false, false)
			Wait(Config.BrewTime)
			ClearPedTasks(player)
			SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
			TriggerServerEvent('QBCore:Server:RemoveItem', "sugar", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "corn", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "water", 5)
			TriggerServerEvent('QBCore:Server:AddItem', "vodka", 5)
			TriggerEvent("inventory:client:ItemBox", sharedItems["vodka"], "add")
			PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
			exports['qbr-core']:Notify(9, 'Vous avez fait 5 vodka', 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			exports['qbr-core']:Notify(9, 'Vous n\'avez pas les ingrédients', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	end, { ['sugar'] = 5, ['corn'] = 5, ['water'] = 5 })
end)









----------------------------------------------------------
------------------setup cuisinekit------------------------
----------------------------------------------------------

RegisterNetEvent('saloon:client:cuisinekit')
AddEventHandler('saloon:client:cuisinekit', function(itemName) 
    if cuisinekit ~= 0 then
        SetEntityAsMissionEntity(cuisinekit)
        DeleteObject(cuisinekit)
        cuisinekit = 0
    else
		local playerPed = PlayerPedId()
		TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 10000, true, false, false, false)
		Wait(10000)
		ClearPedTasks(playerPed)
		SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.75, -1.55))
		--local modelHash = `p_still03x`
		local modelHash2 = GetHashKey(Config.Prop2)
		if not HasModelLoaded(modelHash2) then
			-- If the model isnt loaded we request the loading of the model and wait that the model is loaded
			RequestModel(modelHash2)
			while not HasModelLoaded(modelHash2) do
				Wait(1)
			end
		end
		local prop2 = CreateObject(modelHash2, x, y, z, true)
		SetEntityHeading(prop2, GetEntityHeading(PlayerPedId()))
		PlaceObjectOnGroundProperly(prop2)
		PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
		cuisinekit = prop2
	end
end, false)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos2, awayFromObject = GetEntityCoords(PlayerPedId()), true
		local cuisineObject = GetClosestObjectOfType(pos2, 5.0, GetHashKey(Config.Prop2), false, false, false)
		if cuisineObject ~= 0 then
			local objectPos2 = GetEntityCoords(cuisineObject)
			if #(pos2 - objectPos2) < 3.0 then
				awayFromObject = false
				DrawText3Ds(objectPos2.x, objectPos2.y, objectPos2.z + 1.0, "~g~J~w~ Utiliser ~g~E~w~ Démonter")
				if IsControlJustReleased(0, 0xF3830D8E) then -- [J]
					TriggerEvent('saloon:client:cuisine')
				end
				if IsControlJustReleased(0, 0x018C47CF) then -- [E]
					local player = PlayerPedId()
					TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 5000, true, false, false, false)
					Wait(5000)
					ClearPedTasks(player)
					SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
					DeleteObject(cuisineObject)
					PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
					exports['qbr-core']:Notify(9, 'Distilerie démonté!', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
					TriggerServerEvent('QBCore:Server:AddItem', "cuisinekit", 1)
					cuisinekit = 0
				end
			end		
		end
		if awayFromObject then
			Citizen.Wait(1000)
		end
	end
end)


RegisterNetEvent('saloon:client:cuisine', function(data)
    exports['qbr-menu']:openMenu({
        {
            header = "| Saloon Cuisine |",
            isMenuHeader = true,
        },
        {
            header = "volaille en sauce",
            txt = "5 x volaille 5 x Water and 5 x crows_garlic",
            params = {
                event = 'saloon:client:volaille',
				isServer = false,
            }
        },
        {
            header = "gibier au champignon",
            txt = "5 x gamey meat 5 x Water and 5 x parasol mushroom",
            params = {
                event = 'saloon:client:plat_viande',
				isServer = false,
            }
        },
        {
            header = "petiti gibier champignon",
            txt = "5 x little gamey 5 x Water and 5 x parasol mushroom",
            params = {
                event = 'saloon:client:plat_viande2',
				isServer = false,
            }
        },
        {
            header = "poisson au thym",
            txt = "5 x fishmeat 5 x Creeking Thyme and 5 x water",
            params = {
                event = 'saloon:client:plat_poisson',
				isServer = false,
            }
        },
        {
            header = "infusion",
            txt = "5 x Sugar 5 x Water 5 x red_raspberry",
            params = {
                event = 'saloon:client:infusion',
				isServer = false,
            }
        },
        {
            header = "cafe",
            txt = "5 x Sugar 5 x Water 5 x corn ",
            params = {
                event = 'saloon:client:coffee',
				isServer = false,
            }
        },
        {
            header = "Soupe champignon",
            txt = "5 x Water and 5 x Bay Bolete",
            params = {
                event = 'saloon:client:soupe_champi',
				isServer = false,
            }
        },
        {
            header = "Close Menu",
            txt = '',
            params = {
                event = 'qbr-menu:closeMenu',
            }
        },
    })
end)


RegisterNetEvent("saloon:client:soupe_champi")
AddEventHandler("saloon:client:soupe_champi", function()
	exports['qbr-core']:TriggerCallback('QBCore:HasItem', function(hasItem) 
		if hasItem then
			local player = PlayerPedId()
			TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), Config.BrewTime, true, false, false, false)
			Wait(Config.BrewTime)
			ClearPedTasks(player)
			SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
			TriggerServerEvent('QBCore:Server:RemoveItem', "Bay_Bolete", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "water", 5)
			TriggerServerEvent('QBCore:Server:AddItem', "soupe_champignon", 5)
			TriggerEvent("inventory:client:ItemBox", sharedItems["soupe_champignon"], "add")
			PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
			exports['qbr-core']:Notify(9, 'Vous avez fait 5 soupes aux champignons', 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			exports['qbr-core']:Notify(9, 'Vous n\'avez pas les ingrédients', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	end, { ['sugar'] = 5,['water'] = 5 })
end)

RegisterNetEvent("saloon:client:plat_viande")
AddEventHandler("saloon:client:plat_viande", function()
	exports['qbr-core']:TriggerCallback('QBCore:HasItem', function(hasItem) 
		if hasItem then
			local player = PlayerPedId()
			TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), Config.BrewTime, true, false, false, false)
			Wait(Config.BrewTime)
			ClearPedTasks(player)
			SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
			TriggerServerEvent('QBCore:Server:RemoveItem', "gamey_meat", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "parasol_mushroom", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "water", 5)
			TriggerServerEvent('QBCore:Server:AddItem', "gibier_champignon", 5)
			TriggerEvent("inventory:client:ItemBox", sharedItems["gibier_champignon"], "add")
			PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
			exports['qbr-core']:Notify(9, 'Vous avez fait 5 gibier aux champignons', 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			exports['qbr-core']:Notify(9, 'Vous n\'avez pas les ingrédients', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	end, { ['gamey_meat'] = 5, ['parasol_mushroom'] = 5, ['water'] = 5 })
end)

RegisterNetEvent("saloon:client:plat_viande2")
AddEventHandler("saloon:client:plat_viande2", function()
	exports['qbr-core']:TriggerCallback('QBCore:HasItem', function(hasItem) 
		if hasItem then
			local player = PlayerPedId()
			TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), Config.BrewTime, true, false, false, false)
			Wait(Config.BrewTime)
			ClearPedTasks(player)
			SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
			TriggerServerEvent('QBCore:Server:RemoveItem', "little_gamey", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "parasol_mushroom", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "water", 5)
			TriggerServerEvent('QBCore:Server:AddItem', "petit_gibier_champignon", 5)
			TriggerEvent("inventory:client:ItemBox", sharedItems["petit_gibier_champignon"], "add")
			PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
			exports['qbr-core']:Notify(9, 'Vous avez fait 5 petit gibier aux champignons', 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			exports['qbr-core']:Notify(9, 'Vous n\'avez pas les ingrédients', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	end, { ['little_gamey'] = 5, ['parasol_mushroom'] = 5, ['water'] = 5 })
end)

RegisterNetEvent("saloon:client:plat_poisson")
AddEventHandler("saloon:client:plat_poisson", function()
	exports['qbr-core']:TriggerCallback('QBCore:HasItem', function(hasItem) 
		if hasItem then
			local player = PlayerPedId()
			TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), Config.BrewTime, true, false, false, false)
			Wait(Config.BrewTime)
			ClearPedTasks(player)
			SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
			TriggerServerEvent('QBCore:Server:RemoveItem', "fishmeat", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "creeking_thyme", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "water", 5)
			TriggerServerEvent('QBCore:Server:AddItem', "petit_gibier_champignon", 5)
			TriggerEvent("inventory:client:ItemBox", sharedItems["petit_gibier_champignon"], "add")
			PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
			exports['qbr-core']:Notify(9, 'Vous avez fait 5 poisson au thym', 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			exports['qbr-core']:Notify(9, 'Vous n\'avez pas les ingrédients', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	end, { ['fishmeat'] = 5, ['creeking_thyme'] = 5, ['water'] = 5 })
end)

RegisterNetEvent("saloon:client:volaille")
AddEventHandler("saloon:client:volaille", function()
	exports['qbr-core']:TriggerCallback('QBCore:HasItem', function(hasItem) 
		if hasItem then
			local player = PlayerPedId()
			TaskStartScenarioInPlace(player, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), Config.BrewTime, true, false, false, false)
			Wait(Config.BrewTime)
			ClearPedTasks(player)
			SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
			TriggerServerEvent('QBCore:Server:RemoveItem', "volaille", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "crows_garlic", 5)
			TriggerServerEvent('QBCore:Server:RemoveItem', "water", 5)
			TriggerServerEvent('QBCore:Server:AddItem', "petit_gibier_champignon", 5)
			TriggerEvent("inventory:client:ItemBox", sharedItems["petit_gibier_champignon"], "add")
			PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
			exports['qbr-core']:Notify(9, 'Vous avez fait 5 petit gibier aux champignons', 5000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
		else
			exports['qbr-core']:Notify(9, 'Vous n\'avez pas les ingrédients', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
		end
	end, { ['volaille'] = 5, ['crows_garlic'] = 5, ['water'] = 5 })
end)