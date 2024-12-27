local gameEvents = {}

gameEvents.CEventNetworkEntityDamage = function(args)
  if scl_PedEventList[args[1]] then
    local PedSID = scl_PedEventList[args[1]]
    if args[6] == 1 then
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'IsDead', true)
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'PedHealth', 0)
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'UseExactSpawnCoordinates', true)
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'DeadPitch', GetEntityPitch(ped))
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'DeadRoll', GetEntityRoll(ped))
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'DeadHeading', GetEntityHeading(ped))
    else
      local PedNetID = scl_PedList[PedSID].PedNetID
      local ped = NetToPed(PedNetID)
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'PedHealth', GetEntityHealth(ped))
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'PedArmor', GetPedArmour(ped))
    end
  elseif scl_VehEventList[args[1]] then
    local VehSID = scl_VehEventList[args[1]]
    if args[6] == 1 then
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'IsExploded', true)
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'UseExactSpawnCoordinates', true)
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'VehicleEngineHealth', -4000.0)
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'VehicleBodyHealth', 0.0)
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'VehiclePetrolTankHealth', 0.0)
    else
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'VehicleEngineHealth', GetVehicleEngineHealth(args[1]))
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'VehicleBodyHealth', GetVehicleBodyHealth(args[1]))
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'VehiclePetrolTankHealth', GetVehiclePetrolTankHealth(args[1]))
    end

    for i, tyre in ipairs(scl_VehList[VehSID].ExistingTyres) do
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'TyreHealth', tyre, GetTyreHealth(args[1], tyre))
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'WheelHealth', tyre, GetWheelHealth(args[1], tyre))
      
      if IsVehicleTyreBurst(args[1], tyre, true) then
        TriggerServerEvent('ssv:SyncVehData', VehSID, 'TyreDamage', tyre, 'Destroyed')
      elseif IsVehicleTyreBurst(args[1], tyre, false) then
        TriggerServerEvent('ssv:SyncVehData', VehSID, 'TyreDamage', tyre, 'Flat')
      end

      -- code to check for broken off wheels is missing
      
    end

    for i, door in ipairs(scl_VehList[VehSID].ExistingDoors) do
      -- doors
    end

    for window, status in pairs(scl_VehList[VehSID].WindowStatus) do
      if not IsVehicleWindowIntact(args[1], window) then
        TriggerServerEvent('ssv:SyncVehData', VehSID, 'WindowStatus', window, 'Smashed')
      end
    end
    
    if IsVehicleBumperBrokenOff(args[1], true) then
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'FrontBumper', 'BrokenOff')
    elseif IsVehicleBumperBouncing(args[1], true) then
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'FrontBumper', 'Bouncing')
    end
    if IsVehicleBumperBrokenOff(args[1], false) then
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'RearBumper', 'BrokenOff')
    elseif IsVehicleBumperBouncing(args[1], false) then
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'RearBumper', 'Bouncing')
    end

    -- lights



  end
end

gameEvents.CEventNetworkVehicleUndrivable = function(args)
  if scl_VehEventList[args[1]] then
    local VehSID = scl_VehEventList[args[1]]
    TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'IsUndrivable', true)
  end
end



AddEventHandler('gameEventTriggered', function(name, args)
 if not gameEvents[name] then return end
  gameEvents[name](args)
end)