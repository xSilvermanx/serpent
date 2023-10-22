function ssv_nat_TaskGoStraightToCoord(SID, tx, ty, tz, tspeed, ttimeout, ttargetHeading, tdistanceToSlide, ObjType)
  if ObjType == "Next" then
    ssv_PedList[SID].NextObjective = 'TaskGoStraightToCoord'
    ssv_PedList[SID].NextObjectiveData = {
      task = 'Init', --Continue, Ignore
      x = tx,
      y = ty,
      z = tz,
      speed = tspeed,
      timeout = ttimeout,
      targetHeading = ttargetHeading,
      distanceToSlide = tdistanceToSlide,
    }
    if ssv_PedList[SID].IsSpawnedBool then
      local OwnerID = ssv_PedList[SID].OwnerClientNetID
      local NextObjective = 'TaskGoStraightToCoord'
      local NextObjectiveData = ssv_PedList[SID].NextObjectiveData
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'NextObjective', 'NextObjective', NextObjective)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'NextObjective', 'NextObjectiveData', NextObjectiveData)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'NextObjective', 'NextPathfindingData', {})
    end
  elseif ObjType == "Override" then
    ssv_PedList[SID].OverrideObjective = 'TaskGoStraightToCoord'
    ssv_PedList[SID].OverrideObjectiveData = {
      task = 'Init', --Continue, Ignore
      x = tx,
      y = ty,
      z = tz,
      speed = tspeed,
      timeout = ttimeout,
      targetHeading = ttargetHeading,
      distanceToSlide = tdistanceToSlide,
    }
    if ssv_PedList[SID].IsSpawnedBool then
      local OwnerID = ssv_PedList[SID].OwnerClientNetID
      local OverrideObjective = 'TaskGoStraightToCoord'
      local OverrideObjectiveData = ssv_PedList[SID].OverrideObjectiveData
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'OverrideObjective', 'OverrideObjective', OverrideObjective)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'OverrideObjective', 'OverrideObjectiveData', OverrideObjectiveData)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'OverrideObjective', 'OverridePathfindingData', {})
    end
  else
    ssv_PedList[SID].CurrObjective = 'TaskGoStraightToCoord'
    ssv_PedList[SID].CurrObjectiveData = {
      task = 'Init', --Continue, Ignore
      x = tx,
      y = ty,
      z = tz,
      speed = tspeed,
      timeout = ttimeout,
      targetHeading = ttargetHeading,
      distanceToSlide = tdistanceToSlide,
    }
    if ssv_PedList[SID].IsSpawnedBool then
      local OwnerID = ssv_PedList[SID].OwnerClientNetID
      local CurrObjective = 'TaskGoStraightToCoord'
      local CurrObjectiveData = ssv_PedList[SID].CurrObjectiveData
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'CurrObjective', 'CurrObjective', CurrObjective)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'CurrObjective', 'CurrObjectiveData', CurrObjectiveData)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'CurrObjective', 'CurrPathfindingData', {})
    end
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
      ssv_PedList[SID].OverrideObjectiveData.task = 'Continue'
      if ssv_PedList[SID].IsSpawnedBool then
        TriggerClientEvent('scl:RecievePedData', ssv_PedList[SID].OwnerClientNetID, SID, 'OverrideObjectiveData', 'task', 'Continue')
      end
    else
      ssv_PedList[SID].CurrObjectiveData.task = 'Continue'
      if ssv_PedList[SID].IsSpawnedBool then
        TriggerClientEvent('scl:RecievePedData', ssv_PedList[SID].OwnerClientNetID, SID, 'CurrObjectiveData', 'task', 'Continue')
      end
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
