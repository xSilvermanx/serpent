-- ToDo
--Event: 'ssv:ev:SerpentPedMightBeStuck', function(PedSID)

-- Implemented Events --
-- to use create a net event in your resource --
--Event: 'ssv:ev:RandomPedIsInSerpentVehicle', function(VehSID, PedNetID, seat)
--Event: 'ssv:ev:SerpentPedIsInRandomVehicle', function(PedSID, VehNetID, seat)
--Event: 'ssv:ev:SerpentPedTaskSet', function(PedSID, Task, ObjType)
--Event: 'ssv:ev:SerpentPedTaskStarted', function(PedSID, Task, isOverride)
--Event: 'ssv:ev:SerpentPedTaskFinished', function(PedSID, Task, isOverride, hasNewTask)
--Event: 'ssv:ev:SerpentPedSpawned', function(PedSID)
--Event: 'ssv:ev:SerpentPedDamaged', function(PedSID, AttackerType, AttackerSID, AttackerNetID, isDead, weaponHash)
--Event: 'ssv:ev:SerpentPedOwnershipSwitched', function(PedSID, newOwner)
--Event: 'ssv:ev:SerpentPedDespawned', function(PedSID)
--Event: 'ssv:ev:SerpentVehSpawned', function(VehSID)
--Event: 'ssv:ev:SerpentVehOwnershipSwitched', function(VehSID, newOwner)
--Event: 'ssv:ev:SerpentVehDespawned', function(VehSID)
--Event: 'ssv:ev:SerpentVehicleOutOfFuel', function(VehSID)
--Event: 'ssv:ev:SerpentVehicleUndrivable', function(VehSID)
--Event: 'ssv:ev:SerpentVehDamaged', function(VehSID, AttackerType, AttackerSID, AttackerNetID, isExploded, weaponHash, damageFlag, isTyreAffected, TyreDamageList, isWheelAffected, WheelDamageList, isDoorAffected, DoorDamageList, isWindowAffected, WindowDamageList, isBumperAffected, BumperDamageList, areLightsAffected, LightsDamageList)

RegisterNetEvent('ssv:ev:SerpentPedDamaged:Internal')
AddEventHandler('ssv:ev:SerpentPedDamaged:Internal', function(PedSID, AttackerNetID, isDead, weaponHash)
    local AttackerIsSerpentPed = false
    local AttackerSID = nil
    local AttackerType = 'unknown'
    if AttackerNetID ~= -1 then
        for pedid, peddata in pairs(ssv_PedList) do
            if AttackerNetID == peddata.PedNetID then
                AttackerIsSerpentPed = true
                AttackerSID = pedid
                AttackerType = 'ped'
                break
            end
        end

        if AttackerIsSerpentPed == false then
            for vehid, vehdata in pairs(ssv_VehList) do
                if AttackerNetID == vehdata.VehNetID then
                    AttackerSID = vehid
                    AttackerType = 'vehicle'
                    break
                end
            end
        end
    end
    TriggerEvent('ssv:ev:SerpentPedDamaged', PedSID, AttackerType, AttackerSID, AttackerNetID, isDead, weaponHash)
end)


RegisterNetEvent('ssv:ev:SerpentVehDamaged:Internal')
AddEventHandler('ssv:ev:SerpentVehDamaged:Internal', function(VehSID, AttackerNetID, isExploded, weaponHash, damageFlag, isTyreAffected, TyreDamageList, isWheelAffected, WheelDamageList, isDoorAffected, DoorDamageList, isWindowAffected, WindowDamageList, isBumperAffected, BumperDamageList, areLightsAffected, LightsDamageList)
    local AttackerIsSerpentPed = false
    local AttackerSID = nil
    local AttackerType = 'unknown'
    if AttackerNetID ~= -1 then
        for pedid, peddata in pairs(ssv_PedList) do
            if AttackerNetID == peddata.PedNetID then
                AttackerIsSerpentPed = true
                AttackerSID = pedid
                AttackerType = 'ped'
                break
            end
        end

        if AttackerIsSerpentPed == false then
            for vehid, vehdata in pairs(ssv_VehList) do
                if AttackerNetID == vehdata.VehNetID then
                    AttackerID = vehid
                    AttackerType = 'vehicle'
                    break
                end
            end
        end
    end

    TriggerEvent('ssv:ev:SerpentVehDamaged', VehSID, AttackerType, AttackerSID, AttackerNetID, isExploded, weaponHash, damageFlag, isTyreAffected, TyreDamageList, isWheelAffected, WheelDamageList, isDoorAffected, DoorDamageList, isWindowAffected, WindowDamageList, isBumperAffected, BumperDamageList, areLightsAffected, LightsDamageList)
end)
