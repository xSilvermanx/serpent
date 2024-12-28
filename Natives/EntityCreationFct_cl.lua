RegisterNetEvent('scl:nat:LoadPedIntoSerpent')
AddEventHandler('scl:nat:LoadPedIntoSerpent', function(PedSID, PedNetID)
    local ped = NetToPed(PedNetID)
    local peddata = {
        PedHealth = GetEntityHealth(ped),
        PedArmor = GetPedArmour(ped),
        IsDead = IsEntityDead(ped),
        DeadPitch = GetEntityPitch(ped),
        DeadRoll = GetEntityRoll(ped),
    }

    TriggerServerEvent('ssv:nat:LoadPedIntoSerpent:Helper', PedSID, peddata)
end)

RegisterNetEvent('scl:LoadPedIntoSerpent:RecievePedOwnership')
AddEventHandler('scl:LoadPedIntoSerpent:RecievePedOwnership', function(PedSID, peddata)
    scl_PedList[PedSID] = peddata

    local PedNetID = peddata.PedNetID
    local ped = NetToPed(PedNetID)
    scl_PedEventList[ped] = PedSID
    TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'PedID', ped)
  
    scl_ApplyAllPedProperties(PedSID, peddata)
end)

RegisterNetEvent('scl:nat:LoadVehIntoSerpent')
AddEventHandler('scl:nat:LoadVehIntoSerpent', function(VehSID, VehNetID)
    local veh = NetToVeh(VehNetID)
    local EngineHealth = GetVehicleEngineHealth(veh)
    local BodyHealth = GetVehicleBodyHealth(veh)
    local UndrivableBool = (EngineHealth < -3900)
    local ExplodedBool = ((EngineHealth < -3900) and BodyHealth < 10)
    local vehdata = {
        VehicleEngineHealth = EngineHealth,
        VehicleBodyHealth = GetVehicleBodyHealth(veh),
        VehiclePetrolTankHealth = GetVehiclePetrolTankHealth(veh),
        VehicleFuelLevel = GetVehicleFuelLevel(veh),
        IsUndrivable = UndrivableBool,
        IsExploded = ExplodedBool,
        passengers = {}
    }
    for i=-1,6 do
        local ped = GetPedInVehicleSeat(veh, i)
        if ped ~= 0 then
            local PedNetID = PedToNet(ped)
            vehdata.passengers[i] = PedNetID
        end
    end

    TriggerServerEvent('ssv:nat:LoadVehIntoSerpent:Helper', VehSID, vehdata)
end)

RegisterNetEvent('scl:LoadVehIntoSerpent:RecieveVehOwnership')
AddEventHandler('scl:LoadVehIntoSerpent:RecieveVehOwnership', function(VehSID, vehdata)
    scl_VehList[VehSID] = vehdata

    local VehNetID = vehdata.VehNetID
    local veh = NetToVeh(VehNetID)
    scl_VehEventList[veh] = VehSID
    TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'VehID', veh)

    scl_ApplyAllVehProperties(VehSID, vehdata)
end)
