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
      if args[13] == 93 then --tyres

      elseif args[13] == 116 then -- body

      elseif args[13] == 120 then -- side windows

      elseif args[13] == 121 then -- rear window

      elseif args[13] == 122 then -- front window

      end
    end
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