AddEventHandler('scl:MainClientPedLoop', function()
  CreateThread(function()
    while true do
      local playerped = GetPlayerPed(-1)
      local plx, ply, plz = table.unpack(GetEntityCoords(playerped))
      TriggerServerEvent('ssv:RecievePlayerPos', plx, ply, plz)

      for pedid, peddata in pairs(scl_PedList) do
        if scl_PedList[pedid].JustSpawnedBool then
          TriggerServerEvent('ssv:SyncPedData', pedid, "", "JustSpawnedBool", false)
        else
          if not scl_PedList[pedid].IsInVeh then
            local PedNetID = scl_PedList[pedid].PedNetID
            local ped = NetToPed(PedNetID)
            local pedx, pedy, pedz = table.unpack(GetEntityCoords(ped))
            local pedh = GetEntityHeading(ped)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Position', 'x', pedx)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Position', 'y', pedy)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Position', 'z', pedz)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Heading', 'heading', pedh)
            if scl_PedList[pedid].IsDead then
              TriggerServerEvent('ssv:SyncPedData', pedid, '', 'DeadPitch', GetEntityPitch(ped))
              TriggerServerEvent('ssv:SyncPedData', pedid, '', 'DeadRoll', GetEntityRoll(ped))
            end
            if IsPedInAnyVehicle(ped, false) then
              local veh = GetVehiclePedIsIn(ped, false)
              local VehNetID = VehToNet(veh)
              TriggerServerEvent('ssv:ev:SerpentPedIsInRandomVehicle', pedid, VehNetID)
            end

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

  scl_ApplyAllPedProperties(pedid, scl_PedList[pedid])

end)

RegisterNetEvent('scl:RecievePedOwnership')
AddEventHandler('scl:RecievePedOwnership', function(pedid, peddata)

  scl_PedList[pedid] = peddata

  local PedNetID = peddata.PedNetID
  local ped = NetToPed(PedNetID)
  scl_PedEventList[ped] = pedid
  TriggerServerEvent('ssv:SyncPedData', pedid, '', 'PedID', ped)

  scl_ApplyPedBehaviorFlags(pedid, peddata)
end)

AddEventHandler('scl:DespawnPed', function(pedid)
  local peddata = scl_PedList[pedid]
  scl_PedEventList[peddata.PedID] = false

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
          TriggerServerEvent('ssv:SyncVehData', vehid, "", "JustSpawnedBool", false)
        else
          local VehNetID = scl_VehList[vehid].VehNetID
          local veh = NetToVeh(VehNetID)
          for i=-1,6 do
            local driver = GetPedInVehicleSeat(veh, i)
            if driver ~= 0 then
              local DriverNetID = PedToNet(driver)
              local serpentDriver = vehdata.Passengers[i]
              if not scl_PedList[serpentDriver] or (scl_PedList[serpentDriver].PedNetID ~= DriverNetID) then
                TriggerServerEvent('ssv:ev:RandomPedIsInSerpentVehicle', vehid, DriverNetID, i)
              end
            end
          end

          local vehx, vehy, vehz = table.unpack(GetEntityCoords(veh))
          local vehh = GetEntityHeading(veh)

          TriggerServerEvent('ssv:SyncVehData', vehid, 'Position', 'x', vehx)
          TriggerServerEvent('ssv:SyncVehData', vehid, 'Position', 'y', vehy)
          TriggerServerEvent('ssv:SyncVehData', vehid, 'Position', 'z', vehz)
          TriggerServerEvent('ssv:SyncVehData', vehid, 'Heading', 'heading', vehh)

          for i, passenger in pairs(vehdata.Passengers) do
            if passenger ~= 0 then
              TriggerServerEvent('ssv:SyncPedData', passenger, 'Position', 'x', vehx)
              TriggerServerEvent('ssv:SyncPedData', passenger, 'Position', 'y', vehy)
              TriggerServerEvent('ssv:SyncPedData', passenger, 'Position', 'z', vehz)
              TriggerServerEvent('ssv:SyncPedData', passenger, 'Heading', 'heading', vehh)
            end
          end

          local VehicleFuelLevel = GetVehicleFuelLevel(veh)
          TriggerServerEvent('ssv:SyncVehData', vehid, '', 'VehicleFuelLevel', VehicleFuelLevel)

          if VehicleFuelLevel < 0.1 then
            TriggerServerEvent('ssv:ev:SerpentVehicleOutOfFuel', VehSID)
          end

          if ssh_VectorDistance(vehx, vehy, vehz, plx, ply, plz) > DespawnRange then
            TriggerEvent('scl:DespawnVeh', vehid)
          else
            for i, passenger in pairs(vehdata.Passengers) do
              if passenger ~= 0 then
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
          local ped = NetToPed(PedNetID)
          scl_PedEventList[ped] = pedid
          TriggerServerEvent('ssv:SyncPedData', passenger, '', 'PedID', ped)
          local VehNetID = scl_VehList[vehid].VehNetID
          TriggerEvent('scl:nat:res:SetPedIntoVehicle', PedNetID, VehNetID, i)
        end
      end
    end
end)

AddEventHandler('scl:DespawnVeh', function(vehid)
  local vehdata = scl_VehList[vehid]
  local VehNetID = vehdata.VehNetID
  local veh = NetToVeh(VehNetID)
  TriggerServerEvent('ssv:SyncVehData', vehid, '', 'VehicleFuelLevel', GetVehicleFuelLevel(veh))
  TriggerServerEvent('ssv:SyncVehData', vehid, '', 'VehicleDirtLevel', GetVehicleDirtLevel(veh))
  TriggerServerEvent('ssv:SyncVehData', vehid, 'Lights', 'Siren', GetVehicleFuelLevel(veh))
  if vehdata.ConvertibleRoof == 'Open' or vehdata.ConvertibleRoof == 'Closed' then
    local RoofState = GetConvertibleRoofState(veh)
    if RoofState == 0 or RoofState == 3 or RoofState == 5 then
      TriggerServerEvent('ssv:SyncVehData', vehid, '', 'ConvertibleRoof', 'Closed')
    elseif RoofState == 1 or RoofState == 2 or RoofState == 6 then
      TriggerServerEvent('ssv:SyncVehData', vehid, '', 'ConvertibleRoof', 'Open')
    end
  end
  local PedInVeh = false
  local PassengerData = {}
  for i, passenger in pairs(vehdata.Passengers) do
    if passenger ~= 0 then
      PedInVeh = true
      PassengerData[passenger] = scl_PedList[passenger]
      if scl_PedList[passenger] then
        scl_PedEventList[scl_PedList[passenger].PedID] = false
        scl_PedList[passenger] = nil
      end
    end
  end
  scl_VehEventList[vehdata.VehID] = false
  TriggerServerEvent('ssv:RecieveVehicleControlFromClient', vehid, vehdata, PedInVeh, PassengerData)

  scl_VehList[vehid] = nil
end)

RegisterNetEvent('scl:RecieveVehOwnership')
AddEventHandler('scl:RecieveVehOwnership', function(vehid, vehdata)
  scl_VehList[vehid] = vehdata
  local VehNetID = vehdata.VehNetID
  local veh = NetToVeh(VehNetID)
  scl_VehEventList[veh] = vehid
  TriggerServerEvent('ssv:SyncVehData', vehid, '', 'VehID', veh)
end)

