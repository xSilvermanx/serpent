RegisterNetEvent('scl:RecievePedData')
AddEventHandler('scl:RecievePedData', function(pedid, type, key, value)
  if not scl_PedList[pedid] then
    return
  end

  if type == 'Component' then
    scl_PedList[pedid].PedVisualData.Components[key] = value
  elseif type == 'Prop' then
    scl_PedList[pedid].PedVisualData.Props[key] = value
  elseif type == 'Inheritance' then
    scl_PedList[pedid].PedVisualData[type][key] = value
  elseif type == 'FaceFeature' then
    scl_PedList[pedid].PedVisualData[type][key] = value
  elseif type == 'Appearance' then
    scl_PedList[pedid].PedVisualData[type][key] = value
  elseif type == 'CurrPathfindingData' or type == 'OverridePathfindingData' or type == 'NextPathfindingData' or type == 'CurrObjectiveData' or type == 'OverrideObjectiveData' or type == 'NextObjectiveData' then
    scl_PedList[pedid][type][key] = value
  else
    scl_PedList[pedid][key] = value
  end
end)

RegisterNetEvent('scl:RemovePed')
AddEventHandler('scl:RemovePed', function(pedid)
  if scl_PedList[pedid].IsSpawnedBool then
    local ped = NetToPed(scl_PedList[pedid].PedNetID)
    scl_PedEventList[ped] = false
    SetEntityAsNoLongerNeeded(ped)
    TaskWanderStandard(ped, 10.0, 10) -- Task Type Syncing is most likely not necessary here.
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
  if not scl_VehList[vehid] then
    return
  end

  if type == 'Passenger' then
    scl_VehList[vehid].Passengers[key] = value
  elseif type == 'TuningInit' or type == 'Wheel' then
    scl_VehList[vehid].VehicleMods[key] = value
  elseif type == 'Tuning' then
    scl_VehList[vehid].VehicleMods.Tuning[key] = value
  elseif type == 'VehicleExtra' then
    scl_VehList[vehid].VehicleMods.Extras[key] = value
  elseif type == 'ExistingTyres' or type == 'ExistingDoors' then
    scl_VehList[vehid][type] = value
  elseif type == 'NeonLightsEnabled' then
    ssv_VehList[vehid].Color[type][key] = value
  elseif type == 'TyreHealth' or type == 'TyreDamage' or type == 'Color' or type == 'Lights' or type == 'WindowStatus' or type == 'DoorCanBreak' or type == 'DoorsStatus' or type == 'WheelDamage' or type == 'WheelHealth' then
    scl_VehList[vehid][type][key] = value
  else
    scl_VehList[vehid][key] = value
  end
end)

RegisterNetEvent('scl:RemoveVeh')
AddEventHandler('scl:RemoveVeh', function(vehid)
  if scl_VehList[vehid].IsSpawnedBool then
    local veh = NetToVeh(scl_VehList[vehid].VehNetID)
    scl_VehEventList[veh] = false
    SetEntityAsNoLongerNeeded(veh)
  end
  scl_VehList[vehid] = nil
end)

RegisterNetEvent('scl:RemoveVehOwnership')
AddEventHandler('scl:RemoveVehOwnership', function(vehid)
  scl_vehList[vehid] = nil
end)
