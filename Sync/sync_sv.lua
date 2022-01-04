RegisterNetEvent('ssv:RecievePedData')
AddEventHandler('ssv:RecievePedData', function(pedid, type, key, value)
  if type == 'Component' then

  elseif type == 'Prop' then

  elseif type == 'Inheritance' then

  elseif type == 'FaceFeature' then

  elseif type == 'Appearance' then

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
  elseif type == 'Prop' then

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
