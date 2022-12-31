function ssv_native_SetPedIntoVehicle(SID, VehSID, seat)
    TriggerEvent('ssv:SyncPedData', SID, '', 'IsInVeh', true)
    TriggerEvent('ssv:SyncPedData', SID, '', 'VehSID', VehSID)
    if seat == -1 then
        TriggerEvent('ssv:SyncVehData', VehSID, '', 'DriverIsSerpentPed', true)
        TriggerEvent('ssv:SyncVehData', VehSID, 'Passenger', -1, SID)
    else
        TriggerEvent('ssv:SyncVehData', VehSID, 'Passenger', seat, SID)
    end

    local PedSpawned = ssv_PedList[SID].IsSpawnedBool
    local VehSpawned = ssv_VehList[VehSID].IsSpawnedBool

    if PedSpawned and VehSpawned then
        TriggerClientEvent('scl:nat:res:SetPedIntoVehicle', ssv_PedList[SID].ScriptOwnerNetID, ssv_PedList[SID].PedNetID, ssv_VehList[VehSID].VehNetID, seat)
    elseif PedSpawned then
        TriggerEvent('ssv:SpawnVeh', VehSID, ssv_PedList[SID].OwnerClientNetID)
    elseif VehSpawned then
        TriggerEvent('ssv:SpawnPed', SID, ssv_VehList[VehSID].OwnerClientNetID)
    end
end

--[[RegisterNetEvent('ssv:nat:res:SetPedIntoVehicle:Helper')
AddEventHandler('ssv:nat:res:SetPedIntoVehicle:Helper', function(SID, VehSID, seat)
    ssv_native_SetPedIntoVehicle(SID, VehSID, seat)
end)]]