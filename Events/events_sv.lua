RegisterNetEvent('ssv:nat:GetPedSpecificTaskType')
AddEventHandler('ssv:nat:GetPedSpecificTaskType', function(PedSID)
    local PedNetID = ssv_PedList[PedSID].PedNetID
    local ped = NetworkGetEntityFromNetworkId(PedNetID)
    TriggerEvent('ssv:SyncPedData', PedSID, '', 'TaskType', GetPedSpecificTaskType(ped, 0))
end)

AddEventHandler('ssv:ev:SerpentPedGameTaskTriggered', function(PedSID)
    -- TODO: Trigger event on other resource and propose fixes
end)

AddEventHandler('ssv:ev:RandomDriverIsInSerpentVehicle', function(VehSID)
    -- TODO: Trigger event on other resource and propose fixes
end)

AddEventHandler('ssv:ev:SerpentPedIsInRandomVehicle', function(PedSID)

end)

AddEventHandler('ssv:ev:SerpentPedTaskSet', function(PedSID, Task, TaskType)
    -- Task Type: 'Curr', 'Next', 'Override'
end)

AddEventHandler('ssv:ev:SerpentPedTaskStarted', function(PedSID, Task, isOverride)

end)

AddEventHandler('ssv:ev:SerpentPedTaskFinished', function(PedSID, Task, isOverride)
    -- Trigger this event for other resources with information on whether a new task is executed
    -- isOverride: yes -> Override, no -> Current
    -- 'Next' task is never executed, only promoted to 'Curr'
end)

RegisterNetEvent('ssv:ev:SerpentPedSpawned')
AddEventHandler('ssv:ev:SerpentPedSpawned', function(PedSID)
    local resource = ssv_PedList[PedSID].OwningRes
    local owner = ssv_PedList[PedSID].OwnerClientNetID
    exports[resource]:sev_SerpentPedSpawned(PedSID, owner)
end)

AddEventHandler('ssv:ev:SerpentPedOwnershipSwitched', function(PedSID, newOwner)

end)

AddEventHandler('ssv:ev:SerpentPedDespawned', function(PedSID)
    local resource = ssv_PedList[PedSID].OwningRes
    exports[resource]:sev_SerpentPedDespawned(PedSID)
end)

AddEventHandler('ssv:ev:SerpentVehSpawned', function(VehSID, Owner)

end)

AddEventHandler('ssv:ev:SerpentVehOwnershipSwitched', function(VehSID, newOwner)

end)

AddEventHandler('ssv:ev:SerpentVehDespawned', function(VehSID)

end)

AddEventHandler('ssv:ev:PedDamaged', function(PedSID, isLethal) --check gameEvent for vars

end)

AddEventHandler('ssv:ev:VehDamaged', function(VehSID, isLethal) --check gameEvent for vars

end)

AddEventHandler('ssv:ev:VehicleOutOfFuel', function(VehSID)

end)

AddEventHandler('ssv:ev:VehicleUndrivable', function(VehSID)

end)

AddEventHandler('ssv:ev:SerpentPedMightBeStuck', function(PedSID)

end)