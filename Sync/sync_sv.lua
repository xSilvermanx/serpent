RegisterNetEvent('ssv:RecievePedData')
AddEventHandler('ssv:RecievePedData', function(pedid, type, key, value)
  print(pedid, type, key, value)
  if type == 'Component' then
    ssv_PedList[pedid].PedVisualData.Components[key] = value
  elseif type == 'Prop' then
    ssv_PedList[pedid].PedVisualData.Props[key] = value
  elseif type == 'Inheritance' then
    ssv_PedList[pedid].PedVisualData[type][key] = value
  elseif type == 'FaceFeature' then
    ssv_PedList[pedid].PedVisualData[type][key] = value
  elseif type == 'Appearance' then
    ssv_PedList[pedid].PedVisualData[type][key] = value
  elseif type == 'CurrPathfindingData' or type == 'OverridePathfindingData' or type == 'NextPathfindingData' or type == 'CurrObjectiveData' or type == 'OverrideObjectiveData' or type == 'NextObjectiveData' then
    ssv_PedList[pedid][type][key] = value
  else
    ssv_PedList[pedid][key] = value
  end
end)

RegisterNetEvent('ssv:SyncPedData')
AddEventHandler('ssv:SyncPedData', function(pedid, type, key, value)
  TriggerEvent('ssv:RecievePedData', pedid, type, key, value)
  if ssv_PedList[pedid].OwnerClientNetID ~= 0 then
      TriggerClientEvent('scl:RecievePedData', ssv_PedList[pedid].OwnerClientNetID, pedid, type, key, value)
  end
end)

-- Vehicle Part

RegisterNetEvent('ssv:RecieveVehData')
AddEventHandler('ssv:RecieveVehData', function(vehid, type, key, value)
  if type == 'Passenger' then
    ssv_VehList[vehid].Passengers[key] = value
  elseif type == 'TuningInit' or type == 'Wheel' then
    ssv_VehList[vehid].VehicleMods[key] = value
  elseif type == 'Tuning' then
    ssv_VehList[vehid].VehicleMods.Tuning[key] = value
  elseif type == 'VehicleExtra' then
    ssv_VehList[vehid].VehicleMods.Extras[key] = value
  elseif type == 'ExistingTyres' or type == 'ExistingDoors' then
    ssv_VehList[vehid][type] = value
  elseif type == 'NeonLightsEnabled' then
    ssv_VehList[vehid].Color[type][key] = value
  elseif type == 'TyreHealth' or type == 'TyreDamage' or type == 'Color' or type == 'Lights' or type == 'WindowStatus' or type == 'DoorCanBreak' or type == 'DoorsStatus' or type == 'WheelDamage' or type == 'WheelHealth' then
    ssv_VehList[vehid][type][key] = value
  else
    ssv_VehList[vehid][key] = value
  end
end)

RegisterNetEvent('ssv:SyncVehData')
AddEventHandler('ssv:SyncVehData', function(vehid, type, key, value)
  TriggerEvent('ssv:RecieveVehData', vehid, type, key, value)
  if ssv_VehList[vehid].OwnerClientNetID ~= 0 then
      TriggerClientEvent('scl:RecieveVehData', ssv_VehList[vehid].OwnerClientNetID, vehid, type, key, value)
  end
end)
