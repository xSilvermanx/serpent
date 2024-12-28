RegisterNetEvent('ssv:ev:RandomPedIsInSerpentVehicle')
AddEventHandler('ssv:ev:RandomPedIsInSerpentVehicle', function(VehSID, PedNetID, seat)
    if GetSerpentPedId(PedNetID) or GetPedSpecificTaskType(NetToPed(PedNetID)) == 152 then -- this use of GetPedSpecificTaskType is necessary. Prevents the event from firing after you deleted a serpent ped inside a vehicle.
        return
    end

    local resource = ssv_VehList[VehSID].OwningRes

    local decision = exports[resource]:sev_RandomPedIsInSerpentVehicle(VehSID, seat)
    
    if decision == 1 then -- kick ped out of the seat.
        TriggerClientEvent('scl:ev:result:RandomPedIsInSerpentVehicle', ssv_VehList[VehSID].OwnerClientNetID, VehSID, seat)
    else
        -- decision == 0 is implied. Does nothing if this decision is set.
    end
end)

RegisterNetEvent('ssv:ev:SerpentPedIsInRandomVehicle')
AddEventHandler('ssv:ev:SerpentPedIsInRandomVehicle', function(PedSID, VehNetID)
    if GetSerpentVehId(VehNetID) then
        return
    end

    local resource = ssv_PedList[PedSID].OwningRes
    
    local decision = exports[resource]:sev_SerpentPedIsInRandomVehicle(PedSID)

    if decision == 1 then -- kick ped out of the seat.
        TriggerClientEvent('scl:ev:result:SerpentPedIsInRandomVehicle', ssv_PedList[PedSID].OwnerClientNetID, PedSID)
    else
        -- decision == 0 is implied. Does nothing if this decision is set.
    end
end)

AddEventHandler('ssv:ev:SerpentPedTaskSet', function(PedSID, Task, ObjType)
    local resource = ssv_PedList[PedSID].OwningRes

    exports[resource]:sev_SerpentPedTaskSet(PedSID, Task, ObjType)
end)

AddEventHandler('ssv:ev:SerpentPedTaskStarted', function(PedSID, Task, isOverride)
    local resource = ssv_PedList[PedSID].OwningRes

    exports[resource]:sev_SerpentPedTaskStarted(PedSID, Task, isOverride)
end)

AddEventHandler('ssv:ev:SerpentPedTaskFinished', function(PedSID, Task, isOverride, hasNewTask)
    local resource = ssv_PedList[PedSID].OwningRes

    exports[resource]:sev_SerpentPedTaskFinished(PedSID, Task, isOverride, hasNewTask)
end)

RegisterNetEvent('ssv:ev:SerpentPedSpawned')
AddEventHandler('ssv:ev:SerpentPedSpawned', function(PedSID)
    local resource = ssv_PedList[PedSID].OwningRes
    local owner = ssv_PedList[PedSID].OwnerClientNetID

    exports[resource]:sev_SerpentPedSpawned(PedSID, owner)
end)

AddEventHandler('ssv:ev:SerpentPedOwnershipSwitched', function(PedSID, newOwner)
    local resource = ssv_PedList[PedSID].OwningRes
    
    exports[resource]:sev_SerpentPedOwnershipSwitched(PedSID, newOwner)
end)

AddEventHandler('ssv:ev:SerpentPedDespawned', function(PedSID)
    local resource = ssv_PedList[PedSID].OwningRes

    exports[resource]:sev_SerpentPedDespawned(PedSID)
end)

RegisterNetEvent('ssv:ev:SerpentVehSpawned')
AddEventHandler('ssv:ev:SerpentVehSpawned', function(VehSID)
    local resource = ssv_VehList[VehSID].OwningRes
    local owner = ssv_VehList[VehSID].OwnerClientNetID

    exports[resource]:sev_SerpentVehSpawned(VehSID, owner)
end)

AddEventHandler('ssv:ev:SerpentVehOwnershipSwitched', function(VehSID, newOwner)
    local resource = ssv_VehList[VehSID].OwningRes

    exports[resource]:sev_SerpentVehOwnershipSwitched(VehSID, newOwner)
end)

AddEventHandler('ssv:ev:SerpentVehDespawned', function(VehSID)
    local resource = ssv_VehList[VehSID].OwningRes

    exports[resource]:sev_SerpentVehDespawned(VehSID)
end)

RegisterNetEvent('ssv:ev:SerpentPedDamaged')
AddEventHandler('ssv:ev:SerpentPedDamaged', function(PedSID, AttackerNetID, isDead, weaponHash)
    local resource = ssv_PedList[PedSID].OwningRes
    local AttackerIsSerpentEntity = false
    local AttackerID = AttackerNetID
    if AttackerID ~= -1 then
        for pedid, peddata in pairs(ssv_PedList) do
            if AttackerNetID == peddata.PedNetID then
                AttackerIsSerpentEntity = 'Ped'
                AttackerID = pedid
                break
            end
        end

        if AttackerIsSerpentEntity == false then
            for vehid, vehdata in pairs(ssv_VehList) do
                if AttackerNetID == vehdata.VehNetID then
                    AttackerIsSerpentEntity = 'Veh'
                    AttackerID = vehid
                    break
                end
            end
        end
    end
    exports[resource]:sev_SerpentPedDamaged(PedSID, AttackerIsSerpentEntity, AttackerID, isDead, weaponHash)
end)

RegisterNetEvent('ssv:ev:SerpentVehDamaged')
AddEventHandler('ssv:ev:SerpentVehDamaged', function(VehSID, AttackerNetID, isExploded, weaponHash, damageFlag, isTyreAffected, TyreDamageList, isWheelAffected, WheelDamageList, isDoorAffected, DoorDamageList, isWindowAffected, WindowDamageList, isBumperAffected, BumperDamageList, areLightsAffected, LightsDamageList)
    local resource = ssv_VehList[VehSID].OwningRes
    local AttackerIsSerpentEntity = false
    local AttackerID = AttackerNetID
    if AttackerID ~= -1 then
        for pedid, peddata in pairs(ssv_PedList) do
            if AttackerNetID == peddata.PedNetID then
                AttackerIsSerpentEntity = 'Ped'
                AttackerID = pedid
                break
            end
        end

        if AttackerIsSerpentEntity == false then
            for vehid, vehdata in pairs(ssv_VehList) do
                if AttackerNetID == vehdata.VehNetID then
                    AttackerIsSerpentEntity = 'Veh'
                    AttackerID = vehid
                    break
                end
            end
        end
    end

    exports[resource]:sev_SerpentVehDamaged(VehSID, AttackerIsSerpentEntity, AttackerID, isExploded, weaponHash, damageFlag, isTyreAffected, TyreDamageList, isWheelAffected, WheelDamageList, isDoorAffected, DoorDamageList, isWindowAffected, WindowDamageList, isBumperAffected, BumperDamageList, areLightsAffected, LightsDamageList)
end)

RegisterNetEvent('ssv:ev:SerpentVehicleOutOfFuel')
AddEventHandler('ssv:ev:SerpentVehicleOutOfFuel', function(VehSID)
    local resource = ssv_VehList[VehSID].OwningRes

    exports[resource]:sev_SerpentVehicleOutOfFuel(VehSID)
end)

RegisterNetEvent('ssv:ev:SerpentVehicleUndrivable')
AddEventHandler('ssv:ev:SerpentVehicleUndrivable', function(VehSID)
    local resource = ssv_VehList[VehSID].OwningRes

    exports[resource]:sev_SerpentVehicleUndrivable(VehSID)
end)

AddEventHandler('ssv:ev:SerpentPedMightBeStuck', function(PedSID)
    local resource = ssv_PedList[PedSID].OwningRes

    exports[resource]:sev_SerpentPedMightBeStuck(PedSID)
end)