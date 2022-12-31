RegisterNetEvent('scl:RecievePedData')
AddEventHandler('scl:RecievePedData', function(pedid, type, key, value)
  if type == 'Component' then

  elseif type == 'Prop' then

  elseif type == 'Inheritance' then

  elseif type == 'FaceFeature' then

  elseif type == 'Appearance' then

  elseif type == 'CurrPathfindingData' or type == 'OverridePathfindingData' or type == 'NextPathfindingData' or type == 'CurrObjectiveData' or type == 'OverrideObjectiveData' or type == 'NextObjectiveData' then
    scl_PedList[pedid][type][key] = value
  else
    scl_PedList[pedid][key] = value
  end
end)

RegisterNetEvent('scl:RecievePed')
AddEventHandler('scl:RecievePed', function(pedid, peddata)
  scl_PedList[pedid] = peddata
end)

RegisterNetEvent('scl:RemovePed')
AddEventHandler('scl:RemovePed', function(pedid)
  if scl_PedList[pedid].IsSpawnedBool then
    local ped = NetToPed(scl_PedList[pedid].PedNetID)
    SetEntityAsNoLongerNeeded(ped)
    TaskWanderStandard(ped, 10.0, 10)
  end
  scl_PedList[pedid] = nil
end)

RegisterNetEvent('scl:RemovePedOwnership')
AddEventHandler('scl:RemovePedOwnership', function(pedid)
  scl_pedList[pedid] = nil
end)

-- Vehicle Part

RegisterNetEvent('scl:RecieveVehData')
AddEventHandler('scl:RecieveVehData', function(vehid, type, key, value)
  if type == 'Passenger' then
    scl_VehList[vehid].Passengers[key] = value
  elseif type == 'Prop' then

  else
    scl_VehList[vehid][key] = value
  end
end)

RegisterNetEvent('scl:RecieveVeh')
AddEventHandler('scl:RecieveVeh', function(vehid, vehdata)
  scl_VehList[vehid] = vehdata
end)

RegisterNetEvent('scl:RemoveVeh')
AddEventHandler('scl:RemoveVeh', function(vehid)
  if scl_VehList[vehid].IsSpawnedBool then
    local veh = NetToVeh(scl_VehList[vehid].VehNetID)
    SetEntityAsNoLongerNeeded(veh)
  end
  scl_VehList[vehid] = nil
end)

RegisterNetEvent('scl:RemoveVehOwnership')
AddEventHandler('scl:RemoveVehOwnership', function(vehid)
  scl_vehList[vehid] = nil
end)
