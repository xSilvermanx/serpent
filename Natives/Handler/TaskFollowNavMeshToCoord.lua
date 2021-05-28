function ssv_nat_TaskFollowNavMeshToCoord(SID, tx, ty, tz, tspeed, ttimeout, tstoppingRange, tpersistFollowing, ObjType, IgnoreNoPed)
  if ObjType == "Next" then
    ssv_PedList[SID].NextObjective = 'TaskFollowNavMeshToCoord'
    ssv_PedList[SID].NextObjectiveData = {
      task = 'Init',
      x = tx,
      y = ty,
      z = tz,
      speed = tspeed,
      timeout = ttimeout,
      stoppingRange = tstoppingRange,
      persistFollowing = tpersistFollowing,
      IgnoreNoPed = tIgnoreNoPed,
    }
    if ssv_PedList[SID].IsSpawnedBool then
      local OwnerID = ssv_PedList[SID].OwnerClientNetID
      local NextObjective = 'TaskFollowNavMeshToCoord'
      local NextObjectiveData = ssv_PedList[SID].NextObjectiveData
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'NextObjective', 'NextObjective', NextObjective)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'NextObjective', 'NextObjectiveData', NextObjectiveData)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'NextObjective', 'NextPathfindingData', {})
    end
  elseif ObjType == "Override" then
    ssv_PedList[SID].OverrideObjective = 'TaskFollowNavMeshToCoord'
    ssv_PedList[SID].OverrideObjectiveData = {
      task = 'Init',
      x = tx,
      y = ty,
      z = tz,
      speed = tspeed,
      timeout = ttimeout,
      stoppingRange = tstoppingRange,
      persistFollowing = tpersistFollowing,
      IgnoreNoPed = tIgnoreNoPed,
    }
    if ssv_PedList[SID].IsSpawnedBool then
      local OwnerID = ssv_PedList[SID].OwnerClientNetID
      local OverrideObjective = 'TaskFollowNavMeshToCoord'
      local OverrideObjectiveData = ssv_PedList[SID].OverrideObjectiveData
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'OverrideObjective', 'OverrideObjective', OverrideObjective)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'OverrideObjective', 'OverrideObjectiveData', OverrideObjectiveData)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'OverrideObjective', 'OverridePathfindingData', {})
    end
  else
    ssv_PedList[SID].CurrObjective = 'TaskFollowNavMeshToCoord'
    ssv_PedList[SID].CurrObjectiveData = {
      task = 'Init',
      x = tx,
      y = ty,
      z = tz,
      speed = tspeed,
      timeout = ttimeout,
      stoppingRange = tstoppingRange,
      persistFollowing = tpersistFollowing,
      IgnoreNoPed = tIgnoreNoPed,
    }
    if ssv_PedList[SID].IsSpawnedBool then
      local OwnerID = ssv_PedList[SID].OwnerClientNetID
      local CurrObjective = 'TaskFollowNavMeshToCoord'
      local CurrObjectiveData = ssv_PedList[SID].CurrObjectiveData
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'CurrObjective', 'CurrObjective', CurrObjective)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'CurrObjective', 'CurrObjectiveData', CurrObjectiveData)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'CurrObjective', 'CurrPathfindingData', {})
    end
  end
end

RegisterNetEvent('ssv:nat:TaskFollowNavMeshToCoord')
AddEventHandler('ssv:nat:TaskFollowNavMeshToCoord', function(SID, ObjectiveData, PathfindingData, isOverride)
  local x = ssv_PedList[SID].x
  local y = ssv_PedList[SID].y
  local z = ssv_PedList[SID].z

  local task = ObjectiveData.task
  TriggerEvent('ssv:nat:TaskFollowNavMeshToCoord:' .. task, SID, ObjectiveData.x, ObjectiveData.y, ObjectiveData.z, ObjectiveData.speed, ObjectiveData.timeout, ObjectiveData.stoppingRange, ObjectiveData.persistFollowing, PathfindingData, isOverride, ObjectiveData.IgnoreNoPed)

  if task == 'Init' then
    if isOverride then
      ssv_PedList[SID].OverrideObjectiveData.task = 'Continue'
    else
      ssv_PedList[SID].CurrObjectiveData.task = 'Continue'
    end
  end

  local tarx = ObjectiveData.x
  local tary = ObjectiveData.y
  local tarz = ObjectiveData.z

  local distance = ssh_VectorDistance(x,y,z,tarx,tary,tarz)

  if distance - (ObjectiveData.speed/2) <= ObjectiveData.stoppingRange then
    TriggerEvent('ssv:FinishTask', SID, isOverride, true)
  end

end)

AddEventHandler('ssv:nat:TaskFollowNavMeshToCoord:Init', function(SID, x, y, z, speed, timeout, stoppingRange, persistFollowing, emptyPathfindingData, isOverride, IgnoreNoPed)

  local createPathfindingData = true
  local PathfindingData = {}
  local posx = ssv_PedList[SID].x
  local posy = ssv_PedList[SID].y
  local posz = ssv_PedList[SID].z

  if (persistFollowing and emptyPathfindingData.Path ~= nil) or (ssv_PedList[SID].IsSpawnedBool and emptyPathfindingData.Path ~= nil) then
    PathfindingData = emptyPathfindingData
    createPathfindingData = false
  end

  if createPathfindingData then
    local _, StartNode = ssv_nat_GetClosestNodeId(posx, posy, posz)
    local _, EndNode = ssv_nat_GetClosestNodeId(x, y, z)

    PathfindingData = {
      Start = StartNode,
      End = EndNode,
      Path = nil,

      CurrStart = 'none',
      CurrEnd = StartNode,
      CurrStartData = nil,
      CurrEndData = ListNodes[StartNode],

      orx = nil,
      ory = nil,
      orz = nil,

      nx = nil,
      ny = nil,
      nz = nil,
    }

    if isOverride then
      ssv_PedList[SID].OverridePathfindingData = PathfindingData
    else
      ssv_PedList[SID].CurrPathfindingData = PathfindingData
    end

    CreateThread(function()
      if isOverride then
        ssv_PedList[SID].OverridePathfindingData.Path = 'Creating'
      else
        ssv_PedList[SID].CurrPathfindingData.Path = 'Creating'
      end
      local NodeList = AStar(StartNode, EndNode, 'Ped', {IgnoreNoPed})

      if isOverride then
        ssv_PedList[SID].OverridePathfindingData.Path = NodeList
      else
        ssv_PedList[SID].CurrPathfindingData.Path = NodeList
      end
      if ssv_PedList[SID].IsSpawnedBool then
        local OwnerId = ssv_PedList[SID].OwnerClientNetID
        if isOverride then
          TriggerClientEvent('scl:RecievePedData', OwnerId, SID, 'OverridePathfindingData', "Path", NodeList)
        else
          TriggerClientEvent('scl:RecievePedData', OwnerId, SID, 'CurrPathfindingData', "Path", NodeList)
        end
      end
    end)

  end

  local UseNextPoint = false
  if not (PathfindingData.Path == nil or PathfindingData.Path == 'Creating') then
    if PathfindingData.orx ~= nil then
      local distance = ssh_VectorDistance(PathfindingData.orx, PathfindingData.ory, PathfindingData.orz, posx, posy, posz)
      if distance - (speed/2) <= stoppingRange then
        UseNextPoint = true
      end
    else
      local distance = ssh_VectorDistance(posx, posy, posz, ListNodes[PathfindingData.CurrEnd].x, ListNodes[PathfindingData.CurrEnd].y, ListNodes[PathfindingData.CurrEnd].z)
      if distance - (speed/2) <= stoppingRange then
        UseNextPoint = true
      end
    end
  end

  if UseNextPoint and PathfindingData.CurrEnd ~= 'EndPos' then
    PathfindingData.nx = nil
    PathfindingData.ny = nil
    PathfindingData.nz = nil
    if PathfindingData.CurrEnd == PathfindingData.End then
      PathfindingData.CurrStart = PathfindingData.End
      PathfindingData.CurrEnd = 'EndPos'
      PathfindingData.CurrStartData = ListNodes[PathfindingData.CurrStart]
      PathfindingData.CurrEndData = nil
      PathfindingData.orx = x
      PathfindingData.ory = y
      PathfindingData.orz = z
    else
      if not ssv_PedList[SID].IsSpawnedBool then
        ssv_PedList[SID].x = ListNodes[PathfindingData.CurrEnd].x
        ssv_PedList[SID].y = ListNodes[PathfindingData.CurrEnd].y
        ssv_PedList[SID].z = ListNodes[PathfindingData.CurrEnd].z
      end
      PathfindingData.CurrStart = PathfindingData.CurrEnd
      PathfindingData.CurrStartData = ListNodes[PathfindingData.CurrStart]
      if PathfindingData.Path ~= nil then
        for i, Node in ipairs(PathfindingData.Path) do
          if Node == PathfindingData.CurrEnd then
            PathfindingData.CurrEnd = PathfindingData.Path[i-1]
            PathfindingData.CurrEndData = ListNodes[PathfindingData.CurrEnd]
            break
          end
        end
      end
    end

    if isOverride then
      ssv_PedList[SID].OverridePathfindingData = PathfindingData
    else
      ssv_PedList[SID].CurrPathfindingData = PathfindingData
    end
  end

  print('CurrTarget', PathfindingData.CurrEnd)

  if ssv_PedList[SID].IsSpawnedBool then
    local PedNetID = ssv_PedList[SID].PedNetID
    local ped = NetworkGetEntityFromNetworkId(PedNetID)
    local OwnerID = NetworkGetEntityOwner(ped)
    ssv_PedList[SID].ScriptOwnerNetID = OwnerID
    TriggerClientEvent('scl:nat:res:TaskFollowNavMeshToCoord:Init', OwnerID, SID, PedNetID, x, y, z, speed, timeout, stoppingRange, persistFollowing, PathfindingData, isOverride)
  else
    TriggerEvent('ssv:nat:res:TaskFollowNavMeshToCoord:Init', SID, x, y, z, speed, timeout, stoppingRange, persistFollowing, PathfindingData, isOverride)
  end

end)

AddEventHandler('ssv:nat:TaskFollowNavMeshToCoord:Continue', function(SID, x, y, z, speed, timeout, stoppingRange, persistFollowing, PathfindingData, isOverride)

  local posx = ssv_PedList[SID].x
  local posy = ssv_PedList[SID].y
  local posz = ssv_PedList[SID].z
  local UseNextPoint = false

  if not (PathfindingData.Path == nil or PathfindingData.Path == 'Creating') then
    if PathfindingData.orx ~= nil then
      local distance = ssh_VectorDistance(PathfindingData.orx, PathfindingData.ory, PathfindingData.orz, posx, posy, posz)
      if distance - (speed/2) <= stoppingRange then
        UseNextPoint = true
      end
    else
      local distance = ssh_VectorDistance(posx, posy, posz, ListNodes[PathfindingData.CurrEnd].x, ListNodes[PathfindingData.CurrEnd].y, ListNodes[PathfindingData.CurrEnd].z)
      if distance - (speed/2) <= stoppingRange then
        UseNextPoint = true
      end
    end
  end

  if UseNextPoint and PathfindingData.CurrEnd ~= 'EndPos' then
    PathfindingData.nx = nil
    PathfindingData.ny = nil
    PathfindingData.nz = nil
    if PathfindingData.CurrEnd == PathfindingData.End then
      PathfindingData.CurrStart = PathfindingData.End
      PathfindingData.CurrEnd = 'EndPos'
      PathfindingData.CurrStartData = ListNodes[PathfindingData.CurrStart]
      PathfindingData.CurrEndData = nil
      PathfindingData.orx = x
      PathfindingData.ory = y
      PathfindingData.orz = z
    else
      if not ssv_PedList[SID].IsSpawnedBool then
        ssv_PedList[SID].x = ListNodes[PathfindingData.CurrEnd].x
        ssv_PedList[SID].y = ListNodes[PathfindingData.CurrEnd].y
        ssv_PedList[SID].z = ListNodes[PathfindingData.CurrEnd].z
      end
      PathfindingData.CurrStart = PathfindingData.CurrEnd
      PathfindingData.CurrStartData = ListNodes[PathfindingData.CurrStart]
      if PathfindingData.Path ~= nil then
        for i, Node in ipairs(PathfindingData.Path) do
          if Node == PathfindingData.CurrEnd then
            PathfindingData.CurrEnd = PathfindingData.Path[i-1]
            PathfindingData.CurrEndData = ListNodes[PathfindingData.CurrEnd]
            break
          end
        end
      end
    end

    if isOverride then
      ssv_PedList[SID].OverridePathfindingData = PathfindingData
    else
      ssv_PedList[SID].CurrPathfindingData = PathfindingData
    end
  end

  print('CurrTarget', PathfindingData.CurrEnd)

  if ssv_PedList[SID].IsSpawnedBool then
    local PedNetID = ssv_PedList[SID].PedNetID
    local ped = NetworkGetEntityFromNetworkId(PedNetID)
    local OwnerID = NetworkGetEntityOwner(ped)
    if ssv_PedList[SID].ScriptOwnerNetID ~= OwnerID or (UseNextPoint and persistFollowing) then
      ssv_PedList[SID].ScriptOwnerNetID = OwnerID
      TriggerClientEvent('scl:nat:res:TaskFollowNavMeshToCoord:Continue', OwnerID, SID, PedNetID, x, y, z, speed, timeout,stoppingRange, persistFollowing, PathfindingData, isOverride)
    end
  else
    TriggerEvent('ssv:nat:res:TaskFollowNavMeshToCoord:Continue', SID, x, y, z, speed, timeout, stoppingRange, persistFollowing, PathfindingData, isOverride)
  end

end)
