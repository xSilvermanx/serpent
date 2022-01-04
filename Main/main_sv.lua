RegisterNetEvent('ssv:RecievePlayerPos')
AddEventHandler('ssv:RecievePlayerPos', function(px, py, pz)
  local PlayerID = tonumber(source)

  ssv_PlayerList[PlayerID].x = px
  ssv_PlayerList[PlayerID].y = py
  ssv_PlayerList[PlayerID].z = pz
end)

AddEventHandler('ssv:MainServerPedLoop', function()
  CreateThread(function()
    while true do
      for pedid, peddata in pairs(ssv_PedList) do
        if (not peddata.IsSpawnedBool) then

          local pedx = peddata.x
          local pedy = peddata.y
          local pedz = peddata.z
          local BoolCloseToPl = false
          local ClosestPlId = 0
          local ClosestPlDist = 999999.9

          for plid, pldata in pairs(ssv_PlayerList) do
            local plx = pldata.x
            local ply = pldata.y
            local plz = pldata.z
            local pldist = ssh_VectorDistance(pedx, pedy, pedz, plx, ply, plz)
            if pldist < SpawnRange then
              BoolCloseToPl = true
              if pldist < ClosestPlDist then
                ClosestPlId = plid
                ClosestPlDist = pldist
              end
            end
          end

          if BoolCloseToPl == true then
            if peddata.IsInVeh then
              TriggerEvent('ssv:SpawnPedInVeh', pedid, ClosestPlId)
            else
              TriggerEvent('ssv:SpawnPed', pedid, ClosestPlId)
            end
          end

          if peddata.OwnerClientNetID == 0 then
            TriggerEvent('ssv:SetTaskOwnershipNotSpawned', pedid)
          end

        end
      end
      Wait(500)
    end
  end)
end)

AddEventHandler('ssv:SetTaskOwnershipNotSpawned', function(pedid)
  local prevOwner = ssv_PedList[pedid].OwnerClientNetID

  local pedx = ssv_PedList[pedid].x
  local pedy = ssv_PedList[pedid].y
  local pedz = ssv_PedList[pedid].z
  local ClosestPlId = 0
  local ClosestPlDist = 999999.9

  for plid, pldata in pairs(ssv_PlayerList) do
    local plx = pldata.x
    local ply = pldata.y
    local plz = pldata.z
    local pldist = ssh_VectorDistance(pedx, pedy, pedz, plx, ply, plz)
    if pldist < ClosestPlDist then
      ClosestPlId = plid
      ClosestPlDist = pldist
    end
  end

  if prevOwner ~= ClosestPlId then
    ssv_PedList[pedid].OwnerClientNetID = ClosestPlId

    local peddata = ssv_PedList[pedid]
    TriggerClientEvent('scl:RecievePed', ClosestPlId, pedid, peddata)

    if prevOwner ~= 0 then
      TriggerClientEvent('scl:RemovePed', prevOwner, pedid)
    end
  end
end)

AddEventHandler('ssv:SpawnPed', function (pedid, plid)
  local prevOwner = ssv_PedList[pedid].OwnerClientNetID

  ssv_PedList[pedid].IsSpawnedBool = true
  ssv_PedList[pedid].OwnerClientNetID = plid

  if ssv_PedList[pedid].OverrideObjective ~= 'none' and ssv_PedList[pedid].OverrideObjectiveData.task ~= 'Ignore' then
    ssv_PedList[pedid].OverrideObjectiveData.task = 'Init'
  elseif ssv_PedList[pedid].CurrObjectiveData.task ~= 'Ignore' then
    ssv_PedList[pedid].CurrObjectiveData.task = 'Init'
  end

  local newpeddata = ssv_PedList[pedid]
  TriggerClientEvent('scl:SpawnPed', plid, pedid, newpeddata)
  if prevOwner ~= plid and prevOwner ~= 0 then
    TriggerClientEvent('scl:RemovePed', prevOwner, pedid)
  end
end)

AddEventHandler('ssv:SpawnPedInVeh', function(pedid, plid)
  local VehSID = ssv_PedList[pedid].VehSID

  if ssv_PedList[pedid].IsSpawnedBool and ssv_VehList[VehSID].IsSpawnedBool then
    TriggerEvent('ssv:SetPedInVeh', pedid, VehSID, plid)
  elseif ssv_PedList[pedid].IsSpawnedBool and not ssv_VehList[VehSID].IsSpawnedBool then
    TriggerEvent('ssv:SetExistingPedInVeh', pedid, VehSID, plid)
  elseif ssv_VehList[VehSID].IsSpawnedBool and not ssv_PedList[pedid].IsSpawnedBool then
    TriggerEvent('ssv:SpawnPedInExistingVeh', pedid, VehSID, plid)
  else
    TriggerEvent('ssv:SpawnPedAndVeh', pedid, VehSID, plid)
  end
end)

AddEventHandler('ssv:SetPedInVeh', function(pedid, VehSID, plid)
  local PedOwner = ssv_PedList[pedid].OwnerClientNetID
  local VehOwner = ssv_VehList[VehSID].OwnerClientNetID
  if VehOwner ~= PedOwner then
    TriggerClientEvent('scl:RemoveVehOwnership', VehOwner, VehSID)
    ssv_VehList[VehSID].OwnerClientNetID = PedOwner
  end

  local vehdata = ssv_VehList[VehSID]
  TriggerClientEvent('scl:SetPedInVeh', PedOwner, pedid, vehid, vehdata)
end)

AddEventHandler('ssv:SetExistingPedInVeh', function(pedid, VehSID, plid)
  ssv_VehList[VehSID].IsSpawnedBool = true
  ssv_VehList[VehSID].OwnerClientNetID = plid

  local newvehdata = ssv_VehList[VehSID]
  TriggerClientEvent('scl:SetExistingPedInVeh', plid, pedid, VehSID, newvehdata)
end)

AddEventHandler('ssv:SpawnPedInExistingVeh', function(pedid, VehSID, plid)
  local prevOwner = ssv_PedList[pedid].OwnerClientNetID
  ssv_PedList[pedid].IsSpawnedBool = true
  ssv_PedList[pedid].OwnerClientNetID = plid
  local VehOwner = ssv_VehList[VehSID].OwnerClientNetID
  if VehOwner ~= plid then
    TriggerClientEvent('scl:RemoveVehOwnership', VehOwner, VehSID)
    ssv_VehList[VehSID].OwnerClientNetID = plid
  end

  local newpeddata = ssv_PedList[pedid]
  local vehdata = ssv_VehList[VehSID]
  TriggerClientEvent('scl:SpawnPedInExistingVeh', plid, pedid, newpeddata, VehSID, vehdata)
  if prevOwner ~= plid then
    TriggerClientEvent('scl:RemovePed', prevOwner, pedid)
  end
end)

AddEventHandler('ssv:SpawnPedAndVeh', function(pedid, VehSID, plid)
  local prevOwner = ssv_PedList[pedid].OwnerClientNetID
  ssv_PedList[pedid].IsSpawnedBool = true
  ssv_PedList[pedid].OwnerClientNetID = plid

  local newpeddata = ssv_PedList[pedid]
  local vehid = newpeddata.VehSID
  local vehdata = ssv_VehList[vehid]

  TriggerClientEvent('scl:SpawnPedAndVeh', plid, pedid, newpeddata, vehid, vehdata)
  if prevOwner ~= plid then
    TriggerClientEvent('scl:RemovePed', prevOwner, pedid)
  end
end)


RegisterNetEvent('ssv:RecieveEntityControlFromClient')
AddEventHandler('ssv:RecieveEntityControlFromClient', function(pedid, peddata)
  ssv_PedList[pedid] = peddata

  if ssv_PedList[pedid].OverrideObjective ~= 'none' then
    ssv_PedList[pedid].OverrideObjectiveData.task = 'Init'
  else
    ssv_PedList[pedid].CurrObjectiveData.task = 'Init'
  end

  local data = ssv_PedList[pedid]

  local pedx = data.x
  local pedy = data.y
  local pedz = data.z
  local BoolCloseToPl = false
  local ClosestPlId = 0
  local ClosestPlDist = 999999.9

  for plid, pldata in pairs(ssv_PlayerList) do
    local plx = pldata.x
    local ply = pldata.y
    local plz = pldata.z
    local pldist = ssh_VectorDistance(pedx, pedy, pedz, plx, ply, plz)
    if pldist < DespawnRange then
      BoolCloseToPl = true
      if pldist < ClosestPlDist then
        ClosestPlId = plid
        ClosestPlDist = pldist
      end
    end
  end

  if BoolCloseToPl == true then
    ssv_PedList[pedid].OwnerClientNetID = ClosestPlId
    local newpeddata = ssv_PedList[pedid]
    TriggerClientEvent('scl:RecievePedOwnership', ClosestPlId, pedid, newpeddata)
  else
    TriggerEvent('ssv:DespawnPed', pedid, data)
  end
end)

RegisterNetEvent('ssv:DespawnPed')
AddEventHandler('ssv:DespawnPed', function(pedid, peddata)
  local PedNetID = peddata.PedNetID
  local ped = NetworkGetEntityFromNetworkId(PedNetID)
  DeleteEntity(ped)

  ssv_PedList[pedid] = peddata

  ssv_PedList[pedid].IsSpawnedBool = false
  ssv_PedList[pedid].OwnerClientNetID = 0
  ssv_PedList[pedid].PedNetID = 0

  TriggerEvent('ssv:SetTaskOwnershipNotSpawned', pedid)

end)

-- Vehicle Part

AddEventHandler('ssv:MainServerVehLoop', function()
  CreateThread(function()
    while true do
      for vehid, vehdata in pairs(ssv_VehList) do
        if (not vehdata.IsSpawnedBool) then

          local vehx = vehdata.x
          local vehy = vehdata.y
          local vehz = vehdata.z
          local BoolCloseToPl = false
          local ClosestPlId = 0
          local ClosestPlDist = 999999.9

          for plid, pldata in pairs(ssv_PlayerList) do
            local plx = pldata.x
            local ply = pldata.y
            local plz = pldata.z
            local pldist = ssh_VectorDistance(vehx, vehy, vehz, plx, ply, plz)
            if pldist < SpawnRange then
              BoolCloseToPl = true
              if pldist < ClosestPlDist then
                ClosestPlId = plid
                ClosestPlDist = pldist
              end
            end
          end

          if BoolCloseToPl == true then
            local PedInVeh = false
            for seat, PedSID in pairs(vehdata.Passengers) do
              if PedSID ~= 0 then
                PedInVeh = true
                break
              end
            end
            if not vehdata.DriverIsSerpentPed and not PedInVeh then
              TriggerEvent('ssv:SpawnVeh', vehid, ClosestPlId)
            end
          end

        end
      end
      Wait(500)
    end
  end)
end)

AddEventHandler('ssv:SpawnVeh', function (vehid, plid)
  ssv_VehList[vehid].IsSpawnedBool = true
  ssv_VehList[vehid].OwnerClientNetID = plid

  local newvehdata = ssv_VehList[vehid]
  TriggerClientEvent('scl:SpawnVeh', plid, vehid, newvehdata)
end)

RegisterNetEvent('ssv:RecieveVehicleControlFromClient')
AddEventHandler('ssv:RecieveVehicleControlFromClient', function(vehid, vehdata)

  ssv_VehList[vehid] = vehdata

  local data = ssv_VehList[vehid]

  local vehx = data.x
  local vehy = data.y
  local vehz = data.z
  local BoolCloseToPl = false
  local ClosestPlId = 0
  local ClosestPlDist = 999999.9

  for plid, pldata in pairs(ssv_PlayerList) do
    local plx = pldata.x
    local ply = pldata.y
    local plz = pldata.z
    local pldist = ssh_VectorDistance(vehx, vehy, vehz, plx, ply, plz)
    if pldist < DespawnRange then
      BoolCloseToPl = true
      if pldist < ClosestPlDist then
        ClosestPlId = plid
        ClosestPlDist = pldist
      end
    end
  end

  if BoolCloseToPl == true then
    ssv_VehList[vehid].OwnerClientNetID = ClosestPlId
    local newvehdata = ssv_VehList[vehid]
    TriggerClientEvent('scl:RecieveVehOwnership', ClosestPlId, vehid, newvehdata)
  else
    TriggerEvent('ssv:DespawnVeh', vehid, data)
  end
end)

RegisterNetEvent('ssv:DespawnVeh')
AddEventHandler('ssv:DespawnVeh', function(vehid, vehdata)

  local VehNetID = vehdata.VehNetID
  local veh = NetworkGetEntityFromNetworkId(VehNetID)
  DeleteEntity(veh)

  ssv_VehList[vehid] = vehdata

  ssv_VehList[vehid].IsSpawnedBool = false
  ssv_VehList[vehid].OwnerClientNetID = 0
  ssv_VehList[vehid].VehNetID = 0
end)
