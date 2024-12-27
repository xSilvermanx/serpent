function ssv_nat_TaskGoStraightToCoord(SID, tx, ty, tz, tspeed, ttimeout, ttargetHeading, tdistanceToSlide, ObjType)
  if ObjType == "Next" then
    local NextObjective = 'TaskGoStraightToCoord'
    local NextObjectiveData = {
      task = 'Init', --Continue, Ignore
      x = tx,
      y = ty,
      z = tz,
      speed = tspeed,
      timeout = ttimeout,
      targetHeading = ttargetHeading,
      distanceToSlide = tdistanceToSlide,
    }
    TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjective', NextObjective)
    TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjectiveData', NextObjectiveData)
    TriggerEvent('ssv:SyncPedData', SID, '', 'NextPathfindingData', {})
  elseif ObjType == "Override" then
    local OverrideObjective = 'TaskGoStraightToCoord'
    local OverrideObjectiveData = {
      task = 'Init', --Continue, Ignore
      x = tx,
      y = ty,
      z = tz,
      speed = tspeed,
      timeout = ttimeout,
      targetHeading = ttargetHeading,
      distanceToSlide = tdistanceToSlide,
    }
    TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjective', OverrideObjective)
    TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjectiveData', OverrideObjectiveData)
    TriggerEvent('ssv:SyncPedData', SID, '', 'OverridePathfindingData', {})
  else
    local CurrObjective = 'TaskGoStraightToCoord'
    local CurrObjectiveData =  {
      task = 'Init', --Continue, Ignore
      x = tx,
      y = ty,
      z = tz,
      speed = tspeed,
      timeout = ttimeout,
      targetHeading = ttargetHeading,
      distanceToSlide = tdistanceToSlide,
    }
    TriggerEvent('ssv:SyncPedData', SID, '', 'CurrObjective', CurrObjective)
    TriggerEvent('ssv:SyncPedData', SID, '', 'CurrObjectiveData', CurrObjectiveData)
    TriggerEvent('ssv:SyncPedData', SID, '', 'CurrPathfindingData', {})
  end
end

RegisterNetEvent('ssv:nat:TaskGoStraightToCoord') -- implement timeout
AddEventHandler('ssv:nat:TaskGoStraightToCoord', function(SID, ObjectiveData, PathfindingData, isOverride)

  local x = ssv_PedList[SID].x
  local y = ssv_PedList[SID].y
  local z = ssv_PedList[SID].z

  local task = ObjectiveData.task

  ssv_nat_PedUseExactSpawnCoordinates(SID, false)

  TriggerEvent('ssv:nat:TaskGoStraightToCoord:' .. task, SID, ObjectiveData.x, ObjectiveData.y, ObjectiveData.z, ObjectiveData.speed, ObjectiveData.timeout, ObjectiveData.targetHeading, ObjectiveData.distancetoSlide, isOverride)


  if task == 'Init' then
    if isOverride then
      TriggerEvent('ssv:SyncPedData', SID, 'OverrideObjectiveData', 'task', 'Continue')
    else
      TriggerEvent('ssv:SyncPedData', SID, 'CurrObjectiveData', 'task', 'Continue')
    end
  end

  local tarx = ObjectiveData.x
  local tary = ObjectiveData.y
  local tarz = ObjectiveData.z
  local distance = ssh_VectorDistance(x, y, z, tarx, tary, tarz)

  if distance - (ObjectiveData.speed/2) <= ObjectiveData.distanceToSlide then
    TriggerEvent('ssv:FinishTask', SID, isOverride, true)
  end
end)

AddEventHandler('ssv:nat:TaskGoStraightToCoord:Init', function(SID, x, y, z, speed, timeout, targetHeading, distanceToSlide, isOverride)
  if ssv_PedList[SID].IsSpawnedBool then
    local PedNetID = ssv_PedList[SID].PedNetID
    local ped = NetworkGetEntityFromNetworkId(PedNetID)
    local OwnerID = NetworkGetEntityOwner(ped)
    ssv_PedList[SID].ScriptOwnerNetID = OwnerID
    TriggerClientEvent('scl:nat:res:TaskGoStraightToCoord', OwnerID, SID, PedNetID, x, y, z, speed, timeout, targetHeading, distanceToSlide, isOverride)
  else
    TriggerEvent('ssv:nat:res:TaskGoStraightToCoord:Init', SID, x, y, z, speed, timeout, targetHeading, distanceToSlide, isOverride)
  end
end)

AddEventHandler('ssv:nat:TaskGoStraightToCoord:Continue', function(SID, x, y, z, speed, timeout, targetHeading, distanceToSlide, isOverride)
  if ssv_PedList[SID].IsSpawnedBool then
    local PedNetID = ssv_PedList[SID].PedNetID
    local ped = NetworkGetEntityFromNetworkId(PedNetID)
    local OwnerID = NetworkGetEntityOwner(ped)
    if ssv_PedList[SID].ScriptOwnerNetID ~= OwnerID then
      ssv_PedList[SID].ScriptOwnerNetID = OwnerID
      TriggerClientEvent('scl:nat:res:TaskGoStraightToCoord', OwnerID, SID, PedNetID, x, y, z, speed, timeout, targetHeading, distanceToSlide, isOverride)
    end
  else
    TriggerEvent('ssv:nat:res:TaskGoStraightToCoord:Continue', SID, x, y, z, speed, timeout, targetHeading, distanceToSlide, isOverride)
  end
end)
