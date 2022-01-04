AddEventHandler('scl:MainClientPedLoop', function()
  CreateThread(function()
    while true do
      local playerped = GetPlayerPed(-1)
      local plx, ply, plz = table.unpack(GetEntityCoords(playerped))
      TriggerServerEvent('ssv:RecievePlayerPos', plx, ply, plz)

      for pedid, peddata in pairs(scl_PedList) do
        if peddata.IsSpawnedBool then
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
        else
          TriggerEvent('scl:MainTaskHandler', pedid)
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
    if ObjectiveData.IsClientTask then
      TriggerEvent('scl:nat:' .. Objective, pedid, ObjectiveData, PathfindingData, isOverride)
    else
      TriggerServerEvent('ssv:nat:' .. Objective, pedid, ObjectiveData, PathfindingData, isOverride)
    end
  end
end)

RegisterNetEvent('scl:SpawnPed')
AddEventHandler('scl:SpawnPed', function(pedid, peddata)

  local x = peddata.x
  local y = peddata.y
  local z = peddata.z

  if peddata.OverrideObjective ~= 'none' then
    isOverride = true
  end

  local retval, r = GetSafeCoordForPed(peddata.x, peddata.y, peddata.z, false, 16)
  local rx, ry, rz = table.unpack(r)
  if retval and ssh_VectorDistance(x, y, z, rx, ry, rz) < 22.0 then
    x = rx
    y = ry
    z = rz
  else
    retval, r = GetPointOnRoadSide(peddata.x, peddata.y, peddata.z, 0)
    if retval and ssh_VectorDistance(x, y, z, rx, ry, rz) < 22.0 then
      x = rx
      y = ry
      z = rz
    end
  end

  --make sure that selected coordinates are free for entity to spawn

  RequestModel(peddata.ModelHash)

  while not HasModelLoaded(peddata.ModelHash) do
    RequestModel(peddata.ModelHash)
    Wait(50)
  end

  local ped = CreatePed(peddata.PedType, peddata.ModelHash, x, y, z-1.0, peddata.heading, true, true)
  local PedNetID = PedToNet(ped)

  scl_PedList[pedid] = peddata

  scl_PedList[pedid].PedNetID = PedNetID
  TriggerServerEvent('ssv:RecievePedData', pedid, '', 'PedNetID', PedNetID)

  SetBlockingOfNonTemporaryEvents(ped, peddata.BlockNonTemporaryEvents)
  SetPedRelationshipGroupHash(ped, GetHashKey(peddata.PedRelationshipGroup))

  if peddata.ModelHash == FreemodeHashM or peddata.ModelHash == FreemodeHashF then
    -- code inheritance, facefeatures and appearance. Copy most from 'Charspawner' script
  end

  -- code components and props. Copy most from 'Charspawner' script

  SetEntityHealth(ped, peddata.PedHealth)
  SetPedArmour(ped, peddata.PedArmor)

end)

RegisterNetEvent('scl:SetPedInVeh')
AddEventHandler('scl:SetPedInVeh', function(pedid, vehid, vehdata)
  scl_VehList[vehid] = vehdata
  local PedNetID = scl_PedList[pedid].PedNetID
  local VehNetID = scl_VehList[vehid].VehNetID
  local ped = NetToPed(PedNetID)
  local veh = NetToVeh(VehNetID)
  local seat = -1
  if scl_VehList[vehid].DriverPedSID ~= pedid then
    for seatIndex, SID in scl_VehList[vehid].Passengers do
      if SID == pedid then
        seat = seatIndex
        break
      end
    end
  end
  SetPedIntoVehicle(ped, veh, seat)
end)

RegisterNetEvent('scl:SetExistingPedInVeh')
AddEventHandler('scl:SetExistingPedInVeh', function(pedid, VehSID, vehdata)
  local x = vehdata.x
  local y = vehdata.y
  local z = vehdata.z

  local _, Pos = GetClosestVehicleNode(x, y, z, 1, 3.0, 0) -- include heading when spawning the vehicle so that it always faced the right direction

  --make sure that selected coordinates are free for entity to spawn

  RequestModel(vehdata.ModelHash)

  while not HasModelLoaded(vehdata.ModelHash) do
    RequestModel(vehdata.ModelHash)
    Wait(50)
  end

  local veh = CreateVehicle(vehdata.ModelHash, Pos.x, Pos.y, Pos.z, vehdata.heading, true, true)
  local VehNetID = PedToNet(veh)

  scl_VehList[VehSID] = vehdata

  scl_VehList[VehSID].VehNetID = VehNetID
  TriggerServerEvent('ssv:RecieveVehData', vehid, '', 'VehNetID', VehNetID)

  -- Code Sync for Design, Damage, etc.

  local PedNetID = scl_PedList[pedid].PedNetID
  local ped = NetToPed(PedNetID)
  local seat = -1
  if scl_VehList[VehSID].DriverPedSID ~= pedid then
    for seatIndex, SID in scl_VehList[vehSID].Passengers do
      if SID == pedid then
        seat = seatIndex
        break
      end
    end
  end
  SetPedIntoVehicle(ped, veh, seat)
end)

RegisterNetEvent('scl:SpawnPedInExistingVeh')
AddEventHandler('scl:SpawnPedInExistingVeh', function(pedid, peddata, VehSID, vehdata)
  scl_PedList[pedid] = peddata
  scl_VehList[VehSID] = vehdata

  local seat = -1
  if scl_VehList[VehSID].DriverPedSID ~= pedid then
    for seatIndex, SID in scl_VehList[vehSID].Passengers do
      if SID == pedid then
        seat = seatIndex
        break
      end
    end
  end

  local VehNetID = scl_VehList[VehSID].VehNetID
  local veh = NetToVeh(VehNetID)

  RequestModel(scl_PedList[pedid].ModelHash)

  while not HasModelLoaded(scl_PedList[pedid].ModelHash) do
    RequestModel(scl_PedList[pedid].ModelHash)
    Wait(50)
  end

  local ped = CreatePedInsideVehicle(veh, scl_PedList[pedid].PedType, scl_PedList[pedid].ModelHash, seat, true, true)

  print('Created Ped', ped)

  local PedNetID = PedToNet(ped)

  print('Created Net ID', PedNetID)

  scl_PedList[pedid].PedNetID = PedNetID
  TriggerServerEvent('ssv:RecievePedData', pedid, '', 'PedNetID', PedNetID)

  SetBlockingOfNonTemporaryEvents(ped, peddata.BlockNonTemporaryEvents)
  SetPedRelationshipGroupHash(ped, GetHashKey(peddata.PedRelationshipGroup))

  if peddata.ModelHash == FreemodeHashM or peddata.ModelHash == FreemodeHashF then
    -- code inheritance, facefeatures and appearance. Copy most from 'Charspawner' script
  end

  -- code components and props. Copy most from 'Charspawner' script

  SetEntityHealth(ped, peddata.PedHealth)
  SetPedArmour(ped, peddata.PedArmor)

end)

RegisterNetEvent('scl:SpawnPedAndVeh')
AddEventHandler('scl:SpawnPedAndVeh', function(pedid, peddata, VehSID, vehdata)
  scl_PedList[pedid] = peddata
  scl_VehList[VehSID] = vehdata

  local x = scl_VehList[VehSID].x
  local y = scl_VehList[VehSID].y
  local z = scl_VehList[VehSID].z

  local _, Pos = GetClosestVehicleNode(x, y, z, 1, 3.0, 0) -- include heading when spawning the vehicle so that it always faced the right direction

  --make sure that selected coordinates are free for entity to spawn

  RequestModel(scl_VehList[VehSID].ModelHash)

  while not HasModelLoaded(scl_VehList[VehSID].ModelHash) do
    RequestModel(scl_VehList[VehSID].ModelHash)
    Wait(50)
  end

  local veh = CreateVehicle(scl_VehList[VehSID].ModelHash, Pos.x, Pos.y, Pos.z, scl_VehList[VehSID].heading, true, true)
  local VehNetID = PedToNet(veh)
  scl_VehList[VehSID].VehNetID = VehNetID
  TriggerServerEvent('ssv:RecieveVehData', vehid, '', 'VehNetID', VehNetID)

  local seat = -1
  if scl_VehList[VehSID].DriverPedSID ~= pedid then
    for seatIndex, SID in scl_VehList[VehSID].Passengers do
      if SID == pedid then
        seat = seatIndex
        break
      end
    end
  end

  RequestModel(scl_PedList[pedid].ModelHash)

  while not HasModelLoaded(scl_PedList[pedid].ModelHash) do
    RequestModel(scl_PedList[pedid].ModelHash)
    Wait(50)
  end

  local ped = CreatePedInsideVehicle(veh, scl_PedList[pedid].PedType, scl_PedList[pedid].ModelHash, seat, true, true)

  local PedNetID = PedToNet(ped)

  scl_PedList[pedid].PedNetID = PedNetID
  TriggerServerEvent('ssv:RecievePedData', pedid, '', 'PedNetID', PedNetID)

  SetBlockingOfNonTemporaryEvents(ped, peddata.BlockNonTemporaryEvents)
  SetPedRelationshipGroupHash(ped, GetHashKey(peddata.PedRelationshipGroup))

  if peddata.ModelHash == FreemodeHashM or peddata.ModelHash == FreemodeHashF then
    -- code inheritance, facefeatures and appearance. Copy most from 'Charspawner' script
  end

  -- code components and props. Copy most from 'Charspawner' script

  SetEntityHealth(ped, peddata.PedHealth)
  SetPedArmour(ped, peddata.PedArmor)

end)

RegisterNetEvent('scl:RecievePedOwnership')
AddEventHandler('scl:RecievePedOwnership', function(pedid, peddata)

  scl_PedList[pedid] = peddata

  local PedNetID = peddata.PedNetID
  local ped = NetToPed(PedNetID)

  SetBlockingOfNonTemporaryEvents(ped, peddata.BlockNonTemporaryEvents)
  SetPedRelationshipGroupHash(ped, GetHashKey(peddata.PedRelationshipGroup))
end)

AddEventHandler('scl:DespawnPed', function(pedid)
  local peddata = scl_PedList[pedid]

  local PedNetID = peddata.PedNetID
  local ped = NetToPed(PedNetID)

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
        if vehdata.IsSpawnedBool then
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

          local PedInVehicle = false

          for seat, PedSID in pairs(vehdata.Passengers) do
            if PedSID ~= 0 then
              PedInVehicle = true
              break
            end
          end

          if not vehdata.DriverIsSerpentPed and not PedInVehicle and ssh_VectorDistance(vehx, vehy, vehz, plx, ply, plz) > DespawnRange then
            TriggerEvent('scl:DespawnVeh', vehid)
          end

        end

      end
      Wait(500)
    end
  end)

end)


RegisterNetEvent('scl:SpawnVeh')
AddEventHandler('scl:SpawnVeh', function(vehid, vehdata)

  local x = vehdata.x
  local y = vehdata.y
  local z = vehdata.z

  local _, Pos = GetClosestVehicleNode(x, y, z, 1, 3.0, 0) -- include heading when spawning the vehicle so that it always faced the right direction

  --make sure that selected coordinates are free for entity to spawn

  RequestModel(vehdata.ModelHash)

  while not HasModelLoaded(vehdata.ModelHash) do
    RequestModel(vehdata.ModelHash)
    Wait(50)
  end

  local veh = CreateVehicle(vehdata.ModelHash, Pos.x, Pos.y, Pos.z, vehdata.heading, true, true)
  local VehNetID = PedToNet(veh)

  scl_VehList[vehid] = vehdata

  scl_VehList[vehid].VehNetID = VehNetID
  TriggerServerEvent('ssv:RecieveVehData', vehid, '', 'VehNetID', VehNetID)

  -- Code Sync for Design, Damage, etc.

end)

RegisterNetEvent('scl:RecieveVehOwnership')
AddEventHandler('scl:RecieveVehOwnership', function(vehid, vehdata)

  scl_VehList[vehid] = vehdata

  local VehNetID = vehdata.VehNetID
  local veh = NetToVeh(VehNetID)

end)

AddEventHandler('scl:DespawnVeh', function(vehid)
  local vehdata = scl_VehList[vehid]

  local VehNetID = vehdata.VehNetID
  local veh = NetToVeh(VehNetID)

  TriggerServerEvent('ssv:RecieveVehicleControlFromClient', vehid, vehdata)

  scl_VehList[vehid] = nil
end)
