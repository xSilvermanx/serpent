AddEventHandler('scl:MainClientPedLoop', function()
  CreateThread(function()
    while true do
      local playerped = GetPlayerPed(-1)
      local plx, ply, plz = table.unpack(GetEntityCoords(playerped))
      TriggerServerEvent('ssv:RecievePlayerPos', plx, ply, plz)

      for pedid, peddata in pairs(scl_PedList) do
        if scl_PedList[pedid].JustSpawnedBool then
          scl_PedList[pedid].JustSpawnedBool = false
          TriggerServerEvent('ssv:RecievePedData', pedid, "", "JustSpawnedBool", false)
        else
          if not scl_PedList[pedid].IsInVeh then
            local PedNetID = scl_PedList[pedid].PedNetID
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
              TriggerServerEvent('ssv:MainTaskHandler', pedid)
            end
          end
        end
      end
      Wait(500)
    end
  end)
end)

RegisterNetEvent('scl:SpawnPed')
AddEventHandler('scl:SpawnPed', function(pedid, peddata)

  local PedSpawned = false

  PedSpawned = scl_SpawnPed(pedid, peddata, -2)

  while not PedSpawned do
    Wait(20)
  end
  
  scl_ApplyAllPedProperties(pedid, peddata)

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
        if scl_VehList[vehid].JustSpawnedBool then
          scl_VehList[vehid].JustSpawnedBool = false
          TriggerServerEvent('ssv:RecieveVehData', vehid, "", "JustSpawnedBool", false)
        else
          local VehNetID = scl_VehList[vehid].VehNetID
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
          else
            for i, passenger in pairs(vehdata.Passengers) do
              if passenger ~= 0 then
                TriggerServerEvent('ssv:SyncPedData', passenger, 'Position', 'x', vehx)
                TriggerServerEvent('ssv:SyncPedData', passenger, 'Position', 'y', vehy)
                TriggerServerEvent('ssv:SyncPedData', passenger, 'Position', 'z', vehz)
                TriggerServerEvent('ssv:SyncPedData', passenger, 'Heading', 'heading', vehh)
                TriggerServerEvent('ssv:MainTaskHandler', passenger)
              end
            end
          end
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
    
    while not VehicleSpawned do
      Wait(20)
    end
    scl_ApplyAllVehProperties(vehid, vehdata)
    for i, passenger in pairs(scl_VehList[vehid].Passengers) do
      if passenger ~= 0 then
        if PassengerData[passenger].PedNetID == 0 then
          local PedSpawned = false
          PedSpawned = scl_SpawnPed(passenger, PassengerData[passenger], i)
          while not PedSpawned do
            Wait(20)
          end
          scl_ApplyAllPedProperties(passenger, PassengerData[passenger])
        else
          local PedNetID = scl_PedList[passenger].PedNetID
          local VehNetID = scl_VehList[vehid].VehNetID
          TriggerEvent('scl:nat:res:SetPedIntoVehicle', PedNetID, VehNetID, i)
        end
      end
    end
end)

AddEventHandler('scl:DespawnVeh', function(vehid)
  local vehdata = scl_VehList[vehid]
  local PedInVeh = false
  local PassengerData = {}
  for i, passenger in pairs(vehdata.Passengers) do
    if passenger ~= 0 then
      PedInVeh = true
      PassengerData[passenger] = scl_PedList[passenger]
      if scl_PedList[passenger] then
        scl_PedList[passenger] = nil
      end
    end
  end

  TriggerServerEvent('ssv:RecieveVehicleControlFromClient', vehid, vehdata, PedInVeh, PassengerData)

  scl_VehList[vehid] = nil
end)

RegisterNetEvent('scl:RecieveVehOwnership')
AddEventHandler('scl:RecieveVehOwnership', function(vehid, vehdata)
  scl_VehList[vehid] = vehdata
end)

