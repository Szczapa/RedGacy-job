local sharedItems = exports['qbr-core']:GetItems()
local lockpicked4 = false

for k, v in pairs(Config.Locations["loc_stash4"]) do
    exports['qbr-core']:createPrompt("hotel:loc_stash4:"..k, vector3(v.x, v.y, v.z), Config.PromptKey, 'Chambre 4', {
        type = 'client',
        event = 'hotel:client:promptStash4',
    })
end


RegisterNetEvent('hotel:client:promptStash4', function(k)
    exports['qbr-core']:GetPlayerData(function(PlayerData)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "stachname 4"..exports['qbr-core']:GetPlayerData().citizenid)
    TriggerEvent("inventory:client:SetCurrentStash", "stachname 4"..exports['qbr-core']:GetPlayerData().citizenid)
    end)
end)

-- lockpick door
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
-- 		local object = Citizen.InvokeNative(0xF7424890E4A094C0, 3765902977, 0)
-- 		if object ~= 0 and lockpicked4 == false then
-- 			local objectPos = GetEntityCoords(object)
-- 			if #(pos - objectPos) < 2.0 then
-- 				awayFromObject = false
-- 				DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "~g~J~w~ - ouvrir la chambre 4")
-- 				if IsControlJustReleased(0, 0xF3830D8E) then -- [J]
-- 					TriggerServerEvent('check_Key4')
-- 				end
-- 			end
-- 		end
-- 		if object ~= 0 and lockpicked4 == true then
-- 			local objectPos = GetEntityCoords(object)
-- 			if #(pos - objectPos) < 2.0 then
-- 				awayFromObject = false
-- 				DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "~g~J~w~ - fermer la clé chambre 4")
-- 				if IsControlJustReleased(0, 0xF3830D8E) then -- [J]
-- 					TriggerServerEvent('close_Key4')
-- 				end
-- 			end
-- 		end
-- 		if awayFromObject then
-- 			Citizen.Wait(1000)
-- 		end
-- 	end
-- end)

-- RegisterNetEvent('open_chambre4',function()
-- 	exports['qbr-core']:Notify(9, 'Porte ouverte', 1000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
-- 	Citizen.InvokeNative(0x6BAB9442830C7F53, 3765902977, 0)
-- 	lockpicked4 = true
-- end)

-- RegisterNetEvent('close_chambre4',function()
-- 	exports['qbr-core']:Notify(9, 'Porte fermée', 1000, 0, 'hud_textures', 'check', 'COLOR_WHITE')
-- 	Citizen.InvokeNative(0x6BAB9442830C7F53, 3765902977, 1)
-- 	lockpicked4 = false
-- end)

-- ------------------------------------------------------------------------------------------------------------------------
-- function modelrequest( model )
--     Citizen.CreateThread(function()
--         RequestModel( model )
--     end)
-- end
-- ------------------------------------------------------------------------------------------------------------------------

-- function DrawText3Ds(x, y, z, text)
--     local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
--     SetTextScale(0.35, 0.35)
--     SetTextFontForCurrentCommand(9)
--     SetTextColor(255, 255, 255, 215)
--     local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
--     SetTextCentre(1)
--     DisplayText(str,_x,_y)
-- end
