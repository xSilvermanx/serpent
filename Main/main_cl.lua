AddEventHandler('scl:MainClientPedLoop', function()
  CreateThread(function()
    while true do
      local playerped = GetPlayerPed(-1)
      local plx, ply, plz = table.unpack(GetEntityCoords(playerped))
      TriggerServerEvent('ssv:RecievePlayerPos', plx, ply, plz)

      for pedid, peddata in pairs(scl_PedList) do
        if not scl_PedList[pedid].IsInVeh then
          local PedNetID = peddata.PedNetID
          local ped = NetToPed(PedNetID)

          local pedx, pedy, pedz = table.unpack(GetEntityCoords(ped))
          local pedh = GetEntityHeading(ped)

          scl_PedList[pedid].x = pedx
          scl_PedList[pedid].y = pedy
          scl_PedList[pedid].z = pedz
          scl_PedList[pedid].heading = pedh
          TriggerServerEvent('ssv:RecievePedData', pedid, 'Position', 'x', pedx)
          TriggerServerEvent('ssv:RecievePedData', pedid, 'Position', 'y', pedy)
          TriggerServerEvent('ssv:RecievePedData', pedid, 'Position', 'z', pedz)
          TriggerServerEvent('ssv:RecievePedData', pedid, 'Heading', 'heading', pedh)

          if ssh_VectorDistance(pedx, pedy, pedz, plx, ply, plz) > DespawnRange then
            TriggerEvent('scl:DespawnPed', pedid)
          else
            TriggerEvent('scl:MainTaskHandler', pedid)
          end
        end
      end
      Wait(500)
    end
  end)
end)

AddEventHandler('scl:MainTaskHandler', function(pedid)
  local isOverride = false
  local Objective = nil
  local ObjectiveData = nil
  local PathfindingData = nil
  if scl_PedList[pedid].OverrideObjective ~= 'none' then
    isOverride = true
    Objective = scl_PedList[pedid].OverrideObjective
    ObjectiveData = scl_PedList[pedid].OverrideObjectiveData
    PathfindingData = scl_PedList[pedid].OverridePathfindingData
  else
    Objective = scl_PedList[pedid].CurrObjective
    ObjectiveData = scl_PedList[pedid].CurrObjectiveData
    PathfindingData = scl_PedList[pedid].CurrPathfindingData
  end

  if Objective ~= 'idle' and ObjectiveData.task ~= 'Ignore' then
    TriggerServerEvent('ssv:nat:' .. Objective, pedid, ObjectiveData, PathfindingData, isOverride)
  end
end)

RegisterNetEvent('scl:SpawnPed')
AddEventHandler('scl:SpawnPed', function(pedid, peddata)

  local PedSpawned = false
  PedSpawned = scl_SpawnPed(pedid, peddata, 0)
  while not PedSpawned do
    Wait(20)
  end

  scl_ApplyAllPedProperties(pedid, peddata)
  -- code common function for these natives
  
end)

RegisterNetEvent('scl:RecievePedOwnership')
AddEventHandler('scl:RecievePedOwnership', function(pedid, peddata)

  scl_PedList[pedid] = peddata

  local PedNetID = peddata.PedNetID
  local ped = NetToPed(PedNetID)

  scl_ApplyPedBehaviorFlags(pedid, peddata)
end)

AddEventHandler('scl:DespawnPed', function(pedid)
  local peddata = scl_PedList[pedid]

  TriggerServerEvent('ssv:RecieveEntityControlFromClient', pedid, peddata)

  scl_PedList[pedid] = nil
end)

-- Vehicle Part

AddEventHandler('scl:MainClientVehLoop', function()

  CreateThread(function()
    while true do
      local playerped = GetPlayerPed(-1)
      local plx, ply, plz = table.unpack(GetEntityCoords(playerped))
      TriggerServerEvent('ssv:RecievePlayerPos', plx, ply, plz)

      for vehid, vehdata in pairs(scl_VehList) do
        local VehNetID = vehdata.VehNetID
        local veh = NetToVeh(VehNetID)

        local vehx, vehy, vehz = table.unpack(GetEntityCoords(veh))
        local vehh = GetEntityHeading(veh)

        scl_VehList[vehid].x = vehx
        scl_VehList[vehid].y = vehy
        scl_VehList[vehid].z = vehz
        scl_VehList[vehid].heading = vehh
        TriggerServerEvent('ssv:RecieveVehData', vehid, 'Position', 'x', vehx)
        TriggerServerEvent('ssv:RecieveVehData', vehid, 'Position', 'y', vehy)
        TriggerServerEvent('ssv:RecieveVehData', vehid, 'Position', 'z', vehz)
        TriggerServerEvent('ssv:RecieveVehData', vehid, 'Heading', 'heading', vehh)

        if ssh_VectorDistance(vehx, vehy, vehz, plx, ply, plz) > DespawnRange then
          TriggerEvent('scl:DespawnVeh', vehid)
        end
      end
      Wait(500)
    end
  end)

end)

RegisterNetEvent('scl:SpawnVeh')
AddEventHandler('scl:SpawnVeh', function(vehid, vehdata, PedInVeh, PassengerData)

    local VehicleSpawned = false
    VehicleSpawned = scl_SpawnVeh(vehid, vehdata)

    if PedInVeh then
      while not VehicleSpawned do
        Wait(20)
      end
      scl_ApplyAllVehProperties(vehid, vehdata)
      for i, passenger in pairs(scl_VehList[vehid].Passengers) do
        if passenger ~= 0 then
          if not PassengerData[passenger].IsSpawnedBool then
            local PedSpawned = false
            PedSpawned = scl_SpawnPed(passenger, PassengerData[passenger], i)
            while not PedSpawned do
              Wait(20)
            end
            scl_ApplyAllPedProperties(passenger, PassengerData[passenger])
          else
            TriggerEvent('scl:SetPedInVeh', passenger, vehid, vehdata)
          end
        end
      end
    end
end)

AddEventHandler('scl:DespawnVeh', function(vehid)
  local vehdata = scl_VehList[vehid]
  local PedInVeh = false
  local PassengerData = {}
  for i, passenger in pairs(vehdata.Passengers) do
    if passenger ~= 0 and scl_PedList[passenger] and not scl_PedList[passenger].IsSpawnedBool then
      PedInVeh = true
      PassengerData[passenger] = scl_PedList[pedid]
      scl_PedList[passenger] = nil
    end
  end

  TriggerServerEvent('ssv:RecieveVehicleControlFromClient', vehid, vehdata, PedInVeh, PassengerData)

  scl_VehList[vehid] = nil
end)

RegisterNetEvent('scl:RecieveVehOwnership')
AddEventHandler('scl:RecieveVehOwnership', function(vehid, vehdata)
  scl_VehList[vehid] = vehdata
end)

