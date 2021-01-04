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

        if ssh_VectorDistance(pedx, pedy, pedz, plx, ply, plz) > DespawnRange then
          TriggerEvent('scl:DespawnRangeCheck', pedid)
        else
          -- Trigger main client task handler
        end
      end
      Wait(500)
    end
  end)

end)

AddEventHandler('scl:MainTaskHandler', function(pedid)
  --print('Executing Task')
end)

RegisterNetEvent('scl:SpawnPed')
AddEventHandler('scl:SpawnPed', function(pedid, peddata)

  local x = peddata.x
  local y = peddata.y
  local z = peddata.z

  if IsActualPath then -- recode to check the serpent-pathlink depending on current task

  else
    local retval, r = GetSafeCoordForPed(peddata.x, peddata.y, peddata.z, true, 16)
    local rx, ry, rz = table.unpack(r)
    if retval == true and ssh_VectorDistance(x, y, z, rx, ry, rz) < 22.0 then
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

  local ped = CreatePed(peddata.PedType, peddata.ModelHash, x, y, z, peddata.heading, true, true)
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
AddEventHandler('scl:SpawnPedInVeh', function(pedid)

end)

AddEventHandler('scl:DespawnRangeCheck', function(pedid)
  --print('Despawn Range Check')
  -- GetNearestPlayerToEntity()

  local distance = 99999.9

  if distance > DespawnRange then
    TriggerEvent('scl:DespawnPed', pedid)
  else
    -- Get info on the client taking over

    TriggerEvent('scl:SwitchPedOwnership', pedid)
  end
end)

AddEventHandler('scl:SwitchPedOwnership', function(pedid)
  -- send all info to the server
end)

RegisterNetEvent('scl:RecievePedOwnership')
AddEventHandler('scl:RecievePedOwnership', function(pedid, peddata)

  scl_PedList[pedid] = peddata

  SetBlockingOfNonTemporaryEvents(ped, peddata.BlockNonTemporaryEvents)
  SetPedRelationshipGroupHash(ped, GetHashKey(peddata.PedRelationshipGroup))
end)

AddEventHandler('scl:DespawnPed', function(pedid)
  local peddata = scl_PedList[pedid]

  local PedNetID = peddata.PedNetID
  local ped = NetToPed(PedNetID)

  TriggerServerEvent('ssv:DespawnPed', pedid, peddata)

  scl_PedList[pedid] = nil
end)
