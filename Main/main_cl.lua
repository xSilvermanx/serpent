AddEventHandler('scl:MainClientPedLoop', function()

  CreateThread(function()
    while true do
      local playerped = GetPlayerPed(-1)
      local plx, ply, plz = table.unpack(GetEntityCoords(playerped))
      TriggerServerEvent('ssv:RecievePlayerPos', plx, ply, plz)

      for pedid, peddata in pairs(scl_PedList) do
        local PedNetID = peddata.PedNetID
        local ped = NetToPed(PedNetID)

        local pedx, pedy, pedz = table.unpack(GetEntityCoords(ped))

        scl_PedList[pedid].x = pedx
        scl_PedList[pedid].y = pedy
        scl_PedList[pedid].z = pedz
        TriggerServerEvent('ssv:RecievePedData', pedid, 'Position', 'x', pedx)
        TriggerServerEvent('ssv:RecievePedData', pedid, 'Position', 'y', pedy)
        TriggerServerEvent('ssv:RecievePedData', pedid, 'Position', 'z', pedz)

        if ssh_VectorDistance(pedx, pedy, pedz, plx, ply, plz) > DespawnRange then
          TriggerEvent('scl:DespawnPed', pedid)
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
    local ped = NetToPed(scl_PedList[pedid].PedNetID)
    TriggerServerEvent('ssv:nat:' .. Objective, pedid, ObjectiveData, PathfindingData, isOverride)
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

RegisterNetEvent('scl:SpawnPedInVeh')
AddEventHandler('scl:SpawnPedInVeh', function(pedid, peddata, vehdata)

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
