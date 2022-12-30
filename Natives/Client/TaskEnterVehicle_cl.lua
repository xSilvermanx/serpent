RegisterNetEvent('scl:nat:res:TaskEnterVehicle')
AddEventHandler('scl:nat:res:TaskEnterVehicle', function(SID, PedNetID, VehSID, VehNetID, timeout, seatIndex, speed, flag, isOverride)
  print('Trigger Task Enter Vehicle')
  local ped = NetToPed(PedNetID)
  local veh = NetToVeh(VehNetID)

  TaskEnterVehicle(ped, veh, timeout, seatIndex, speed, flag, 0)

  if isOverride then
    scl_PedList[SID].OverrideObjectiveData.task = 'Continue'
  else
    scl_PedList[SID].CurrObjectiveData.task = 'Continue'
  end

  CreateThread(function()
    local ped = NetToPed(PedNetID)
    local veh = NetToVeh(VehNetID)
    local seat = seatIndex
    local PedSID = SID
    local VehicleSID = VehSID
    while not IsPedInVehicle(ped, veh, false) do
      Wait(100)
    end
    TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'IsInVeh', true)
    TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'VehSID', VehicleSID)
    if seat == -1 then
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'DriverIsSerpentPed', true)
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'Passenger', -1, PedSID)
    else
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'Passenger', seat, PedSID)
    end
  end)
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

  CreateThread(function()
    local ped = NetToPed(PedNetID)
    local seat = seatIndex
    local PedSID = SID
    local VehicleSID = VehSID
    local pedx, pedy, pedz = table.unpack(GetEntityCoords(ped))

    local distance = ssh_VectorDistance(vehdata.x, vehdata.y, vehdata.z, pedx, pedy, pedz)

    while distance > 2.0 do
      pedx, pedy, pedz = table.unpack(GetEntityCoords(ped))
      distance = ssh_VectorDistance(vehdata.x, vehdata.y, vehdata.z, pedx, pedy, pedz)
      Wait(100)
    end
    scl_PedList[PedSID].IsInVeh = true
    scl_PedList[PedSID].VehSID = VehSID
    TriggerServerEvent('ssv:RecievePedData', PedSID, '', 'IsInVeh', true)
    TriggerServerEvent('ssv:RecievePedData', PedSID, '', 'VehSID', VehSID)
    if seat == -1 then
      TriggerServerEvent('ssv:RecieveVehData', VehSID, '', 'DriverIsSerpentPed', true)
      TriggerServerEvent('ssv:RecieveVehData', VehSID, 'Passenger', -1, PedSID)
    else
      TriggerServerEvent('ssv:RecieveVehData', VehSID, 'Passenger', seat, PedSID)
    end
  end)
end)
