RegisterNetEvent('scl:nat:res:TaskEnterVehicle')
AddEventHandler('scl:nat:res:TaskEnterVehicle', function(SID, PedNetID, VehSID, VehNetID, timeout, seatIndex, speed, flag, isOverride)
  local ped = NetToPed(PedNetID)
  local veh = NetToVeh(VehNetID)

  TaskEnterVehicle(ped, veh, timeout, seatIndex, speed, flag, 0)

  if isOverride then
    scl_PedList[SID].OverrideObjectiveData.task = 'Continue'
  else
    scl_PedList[SID].CurrObjectiveData.task = 'Continue'
  end

  local seat = seatIndex
  if IsPedInVehicle(ped, veh, false) then
    TriggerServerEvent('ssv:SyncPedData', SID, '', 'IsInVeh', true)
    TriggerServerEvent('ssv:SyncPedData', SID, '', 'VehSID', VehSID)
    if seat == -1 then
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'DriverIsSerpentPed', true)
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'Passenger', -1, SID)
    else
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'Passenger', seat, SID)
    end
  end
end)

RegisterNetEvent('scl:nat:res:TaskEnterVehicle:Continue')
AddEventHandler('scl:nat:res:TaskEnterVehicle:Continue', function(SID, PedNetID, VehSID, VehNetID, timeout, seatIndex, speed, flag, isOverride)
  local ped = NetToPed(PedNetID)
  local veh = NetToVeh(VehNetID)
  local seat = seatIndex
  if IsPedInVehicle(ped, veh, false) then
    TriggerServerEvent('ssv:SyncPedData', SID, '', 'IsInVeh', true)
    TriggerServerEvent('ssv:SyncPedData', SID, '', 'VehSID', VehSID)
    if seat == -1 then
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'DriverIsSerpentPed', true)
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'Passenger', -1, SID)
    else
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'Passenger', seat, SID)
    end
  end
end)

RegisterNetEvent('scl:nat:res:TaskEnterVehicle:PedExists')
AddEventHandler('scl:nat:res:TaskEnterVehicle:PedExists', function(SID, PedNetID, VehSID, vehdata, timeout, seatIndex, speed, flag, isOverride)
  local ped = NetToPed(PedNetID)
  local x = vehdata.x
  local y = vehdata.y
  local z = vehdata.z

  TaskGoStraightToCoord(ped, x, y, z, speed, timeout, vehdata.heading, 2.0)
  if isOverride then
    scl_PedList[SID].OverrideObjectiveData.task = 'Continue'
  else
    scl_PedList[SID].CurrObjectiveData.task = 'Continue'
  end

  local pedx, pedy, pedz = table.unpack(GetEntityCoords(ped))
  local distance = ssh_VectorDistance(vehdata.x, vehdata.y, vehdata.z, pedx, pedy, pedz)
  if distance < 2.0 then
    TriggerServerEvent('ssv:SyncPedData', SID, '', 'IsInVeh', true)
    TriggerServerEvent('ssv:SyncPedData', SID, '', 'VehSID', VehSID)
    if seatIndex == -1 then
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'DriverIsSerpentPed', true)
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'Passenger', -1, SID)
    else
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'Passenger', seatIndex, SID)
    end
    TriggerServerEvent('ssv:SpawnVeh', VehSID, scl_PedList[SID].OwnerClientNetID)
  end
end)

RegisterNetEvent('scl:nat:res:TaskEnterVehicle:PedExists:Continue')
AddEventHandler('scl:nat:res:TaskEnterVehicle:PedExists:Continue', function(SID, PedNetID, VehSID, vehdata, timeout, seatIndex, speed, flag, isOverride)
  local ped = NetToPed(PedNetID)
  local x = vehdata.x
  local y = vehdata.y
  local z = vehdata.z
  local pedx, pedy, pedz = table.unpack(GetEntityCoords(ped))
  local distance = ssh_VectorDistance(vehdata.x, vehdata.y, vehdata.z, pedx, pedy, pedz)
  if distance < 2.0 then
    TriggerServerEvent('ssv:SyncPedData', SID, '', 'IsInVeh', true)
    TriggerServerEvent('ssv:SyncPedData', SID, '', 'VehSID', VehSID)
    if seatIndex == -1 then
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'DriverIsSerpentPed', true)
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'Passenger', -1, SID)
    else
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'Passenger', seatIndex, SID)
    end
    TriggerServerEvent('ssv:SpawnVeh', VehSID, scl_PedList[SID].OwnerClientNetID)
  end
end)