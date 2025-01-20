RegisterNetEvent('ssv:RecievePlayerPos')
AddEventHandler('ssv:RecievePlayerPos', function(px, py, pz)
  local PlayerID = tonumber(source)

  if not ssv_PlayerList[PlayerID] then
    return
  end

  ssv_PlayerList[PlayerID].x = px
  ssv_PlayerList[PlayerID].y = py
  ssv_PlayerList[PlayerID].z = pz
end)

AddEventHandler('ssv:MainServerPedLoop', function()
  CreateThread(function()
    while true do
      for pedid, peddata in pairs(ssv_PedList) do
        if (not peddata.IsSpawnedBool) and (not peddata.IsInVeh) then

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
            TriggerEvent('ssv:SpawnPed', pedid, ClosestPlId)
          else
            TriggerEvent('ssv:MainTaskHandler', pedid)
          end

        end
      end
      Wait(500)
    end
  end)
end)

RegisterNetEvent('ssv:MainTaskHandler')
AddEventHandler('ssv:MainTaskHandler', function(pedid)
  if not ssv_PedList[pedid] then
    return
  end

  if not ssv_PedList[pedid].IsDead then
    local isOverride = false
    local Objective = nil
    local ObjectiveCustom = nil
    local ObjectiveData = nil
    local PathfindingData = nil
    if ssv_PedList[pedid].OverrideObjective ~= 'none' then
      isOverride = true
      Objective = ssv_PedList[pedid].OverrideObjective
      if Objective == 'Custom' then
        ObjectiveCustom = ssv_PedList[pedid].OverrideObjectiveCustom
      end
      ObjectiveData = ssv_PedList[pedid].OverrideObjectiveData
      PathfindingData = ssv_PedList[pedid].OverridePathfindingData
      if ObjectiveData.task == 'Init' then
        if ssv_PedList[pedid].CurrObjectiveData then
          TriggerEvent('ssv:SyncPedData', pedid, 'CurrObjectiveData', 'task', 'Init')
        end
      end
    else
      Objective = ssv_PedList[pedid].CurrObjective
      if Objective == 'Custom' then
        ObjectiveCustom = ssv_PedList[pedid].CurrObjectiveCustom
      end
      ObjectiveData = ssv_PedList[pedid].CurrObjectiveData
      PathfindingData = ssv_PedList[pedid].CurrPathfindingData
      if Objective == 'idle' and ssv_PedList[pedid].NextObjective ~= 'idle' then
        TriggerEvent('ssv:FinishTask', pedid, isOverride)
      end
    end

    if Objective ~= 'idle' and ObjectiveData.task ~= 'Ignore' then
      if Objective == 'Custom' then
        if ObjectiveData.task == 'Init' then
          TriggerEvent('ssv:ev:SerpentPedTaskStarted', pedid, ObjectiveCustom.name, isOverride)
        end
        local resource = ObjectiveCustom.resource
        local name = ObjectiveCustom.name
        exports[resource]:sev_TriggerSerpentCustomTask(pedid, name, ObjectiveData, PathfindingData, isOverride)
      else
        if ObjectiveData.task == 'Init' then
          TriggerEvent('ssv:ev:SerpentPedTaskStarted', pedid, Objective, isOverride)
        end
        TriggerEvent('ssv:nat:' .. Objective, pedid, ObjectiveData, PathfindingData, isOverride)
      end
    end
  end
end)

AddEventHandler('ssv:SpawnPed', function (pedid, plid)
  local prevOwner = ssv_PedList[pedid].OwnerClientNetID

  ssv_PedList[pedid].JustSpawnedBool = true
  ssv_PedList[pedid].IsSpawnedBool = true
  ssv_PedList[pedid].OwnerClientNetID = plid

  if ssv_PedList[pedid].OverrideObjective ~= 'none' then
    if ssv_PedList[pedid].OverrideObjectiveData.task ~= 'Ignore' then
      ssv_PedList[pedid].OverrideObjectiveData.task = 'Init'
    end
  elseif ssv_PedList[pedid].CurrObjectiveData.task ~= 'Ignore' then
    ssv_PedList[pedid].CurrObjectiveData.task = 'Init'
  end

  local newpeddata = ssv_PedList[pedid]
  TriggerClientEvent('scl:SpawnPed', plid, pedid, newpeddata)
  if prevOwner ~= 0 and prevOwner ~= plid then
    TriggerClientEvent('scl:RemovePed', prevOwner, pedid)
  end
end)

RegisterNetEvent('ssv:RecieveEntityControlFromClient')
AddEventHandler('ssv:RecieveEntityControlFromClient', function(pedid, peddata)
  local PID = tonumber(source)
  ssv_PedList[pedid] = peddata

  if ssv_PedList[pedid].OverrideObjective ~= 'none' then
    if ssv_PedList[pedid].OverrideObjectiveData.task ~= 'Ignore' then
      ssv_PedList[pedid].OverrideObjectiveData.task = 'Init'
    end
  elseif ssv_PedList[pedid].CurrObjectiveData.task ~= 'Ignore' then
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

  if ClosestPlId == PID then
    BoolCloseToPl = false
  end
  if BoolCloseToPl == true then
    ssv_PedList[pedid].OwnerClientNetID = ClosestPlId
    local newpeddata = ssv_PedList[pedid]
    TriggerClientEvent('scl:RecievePedOwnership', ClosestPlId, pedid, newpeddata)
    TriggerEvent('ssv:ev:SerpentPedOwnershipSwitched', pedid, ClosestPlId)
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
  ssv_PedList[pedid].PedID = 0

  TriggerEvent('ssv:ev:SerpentPedDespawned', pedid)
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
            TriggerEvent('ssv:SpawnVeh', vehid, ClosestPlId)
          else
            for i, passenger in pairs(vehdata.Passengers) do
              if passenger ~= 0 and not ssv_PedList[passenger].IsSpawnedBool then
                ssv_PedList[passenger].x = vehx
                ssv_PedList[passenger].y = vehy
                ssv_PedList[passenger].z = vehz
                ssv_PedList[passenger].heading = vehh
                TriggerEvent('ssv:MainTaskHandler', passenger)
              end
            end
          end

        end
      end
      Wait(500)
    end
  end)
end)

RegisterNetEvent('ssv:SpawnVeh')
AddEventHandler('ssv:SpawnVeh', function (vehid, plid)
  ssv_VehList[vehid].JustSpawnedBool = true
  ssv_VehList[vehid].IsSpawnedBool = true
  ssv_VehList[vehid].OwnerClientNetID = plid

  local PedInVeh = false
  local PassengerData = {}
  for i, passenger in pairs(ssv_VehList[vehid].Passengers) do
    if passenger ~= 0 then
      PedInVeh = true
      if not ssv_PedList[passenger].IsSpawnedBool then

        local prevOwner = ssv_PedList[passenger].OwnerClientNetID

        ssv_PedList[passenger].JustSpawnedBool = true
        ssv_PedList[passenger].IsSpawnedBool = true
        ssv_PedList[passenger].OwnerClientNetID = plid
      
        if ssv_PedList[passenger].OverrideObjective ~= 'none' then
          if ssv_PedList[passenger].OverrideObjectiveData.task ~= 'Ignore' then
            ssv_PedList[passenger].OverrideObjectiveData.task = 'Init'
          end
        elseif ssv_PedList[passenger].CurrObjectiveData.task ~= 'Ignore' then
          ssv_PedList[passenger].CurrObjectiveData.task = 'Init'
        end
      
        if prevOwner ~= 0 and prevOwner ~= plid then
          TriggerClientEvent('scl:RemovePed', prevOwner, plid)
        end
      end
      PassengerData[passenger] = ssv_PedList[passenger]
    end
  end
  TriggerClientEvent('scl:SpawnVeh', plid, vehid, ssv_VehList[vehid], PedInVeh, PassengerData)
end)

RegisterNetEvent('ssv:RecieveVehicleControlFromClient')
AddEventHandler('ssv:RecieveVehicleControlFromClient', function(vehid, vehdata, PedInVeh, PassengerData)
  local PID = tonumber(source)
  ssv_VehList[vehid] = vehdata

  if PedInVeh then
    for i, passenger in pairs(vehdata.Passengers) do
      if passenger ~= 0 and vehdata.OwnerClientNetID == PassengerData[passenger].OwnerClientNetID then
        ssv_PedList[passenger] = PassengerData[passenger]
        if ssv_PedList[passenger].OverrideObjective ~= 'none' then
          if ssv_PedList[passenger].OverrideObjectiveData.task ~= 'Ignore' then
            ssv_PedList[passenger].OverrideObjectiveData.task = 'Init'
          end
        elseif ssv_PedList[passenger].CurrObjectiveData.task ~= 'Ignore' then
          ssv_PedList[passenger].CurrObjectiveData.task = 'Init'
        end
      end
    end
  end

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

  if ClosestPlId == PID then
    BoolCloseToPl = false
  end

  if BoolCloseToPl == true then
    ssv_VehList[vehid].OwnerClientNetID = ClosestPlId
    local newvehdata = ssv_VehList[vehid]
    TriggerClientEvent('scl:RecieveVehOwnership', ClosestPlId, vehid, newvehdata)
    TriggerEvent('ssv:ev:SerpentVehOwnershipSwitched', vehid, ClosestPlId)
    if PedInVeh then
      for i, passenger in pairs(vehdata.Passengers) do
        if passenger ~= 0 then
          local OldOwner = ssv_PedList[passenger].OwnerClientNetID
          if ClosestPlId ~= OldOwner then
            if PID ~= OldOwner then
              TriggerClientEvent('scl:RemovePedOwnership', ssv_PedList[passenger].OwnerClientNetID, passenger)
            end  
            ssv_PedList[passenger].OwnerClientNetID = ClosestPlId
            local newpeddata = ssv_PedList[passenger]
            TriggerClientEvent('scl:RecievePedOwnership', ClosestPlId, passenger, newpeddata)
            TriggerEvent('ssv:ev:SerpentPedOwnershipSwitched', passenger, ClosestPlId)
          end
        end
      end
    end
  else
    TriggerEvent('ssv:DespawnVeh', vehid, data)
    if PedInVeh then
      for i, passenger in pairs(vehdata.Passengers) do
        if passenger ~= 0 then
          TriggerEvent('ssv:DespawnPed', passenger, PassengerData[passenger])
        end
      end
    end
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
  ssv_VehList[vehid].VehID = 0

  TriggerEvent('ssv:ev:SerpentVehDespawned', vehid)
end)
