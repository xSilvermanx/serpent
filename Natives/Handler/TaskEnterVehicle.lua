function ssv_nat_TaskEnterVehicle(SID, tVehSID, ttimeout, tseatIndex, tspeed, tflag, p6, ObjType)
  local Objective = 'TaskEnterVehicle'
  local ObjectiveCustom = {}
  local ObjectiveData = {
    task = 'Init', --Continue, Ignore
    VehSID = tVehSID,
    timeout = ttimeout,
    seatIndex = tseatIndex,
    speed = tspeed,
    flag = tflag,
  }
  local PathfindingData = {}
  ssv_nat_SetSerpentPedTask(SID, Objective, ObjectiveCustom, ObjectiveData, PathfindingData, ObjType)
end  

RegisterNetEvent('ssv:nat:TaskEnterVehicle') -- implement timeout
AddEventHandler('ssv:nat:TaskEnterVehicle', function(SID, ObjectiveData, PathfindingData, isOverride)
  ssv_nat_PedUseExactSpawnCoordinates(SID, false)

  if ssv_nat_IsPedInSerpentVehicle(SID, ObjectiveData.VehSID) then
    TriggerEvent('ssv:FinishTask', SID, isOverride, true)
  else
    
    local task = ObjectiveData.task

    TriggerEvent('ssv:nat:TaskEnterVehicle:' .. task, SID, ObjectiveData.VehSID, ObjectiveData.timeout, ObjectiveData.seatIndex, ObjectiveData.speed, ObjectiveData.flag, isOverride)

    if task == 'Init' then
      if isOverride then
        TriggerEvent('ssv:SyncPedData', SID, 'OverrideObjectiveData', 'task', 'Continue')
      else
        TriggerEvent('ssv:SyncPedData', SID, 'CurrObjectiveData', 'task', 'Continue')
      end
    end
  end
end)

AddEventHandler('ssv:nat:TaskEnterVehicle:Init', function(SID, VehSID, timeout, seatIndex, speed, flag, isOverride)
  if ssv_PedList[SID].IsSpawnedBool and ssv_VehList[VehSID].IsSpawnedBool then
    local PedNetID = ssv_PedList[SID].PedNetID
    local ped = NetworkGetEntityFromNetworkId(PedNetID)
    local OwnerID = NetworkGetEntityOwner(ped)
    ssv_PedList[SID].ScriptOwnerNetID = OwnerID
    local VehNetID = ssv_VehList[VehSID].VehNetID
    TriggerClientEvent('scl:nat:res:TaskEnterVehicle', OwnerID, SID, PedNetID, VehSID, VehNetID, timeout, seatIndex, speed, flag, isOverride)
  elseif ssv_PedList[SID].IsSpawnedBool and not ssv_VehList[VehSID].IsSpawnedBool then
    local PedNetID = ssv_PedList[SID].PedNetID
    local ped = NetworkGetEntityFromNetworkId(PedNetID)
    local OwnerID = NetworkGetEntityOwner(ped)
    ssv_PedList[SID].ScriptOwnerNetID = OwnerID
    local vehdata = ssv_VehList[VehSID]
    TriggerClientEvent('scl:nat:res:TaskEnterVehicle:PedExists', OwnerID, SID, PedNetID, VehSID, vehdata, timeout, seatIndex, speed, flag, isOverride)
  elseif not ssv_PedList[SID].IsSpawnedBool and ssv_VehList[VehSID].IsSpawnedBool then
    TriggerEvent('ssv:nat:res:TaskEnterVehicle:Init', SID, VehSID, timeout, seatIndex, speed, flag, isOverride)
  else
    TriggerEvent('ssv:nat:res:TaskEnterVehicle:Init', SID, VehSID, timeout, seatIndex, speed, flag, isOverride)
  end
end)

AddEventHandler('ssv:nat:TaskEnterVehicle:Continue', function(SID, VehSID, timeout, seatIndex, speed, flag, isOverride)
  if ssv_PedList[SID].IsSpawnedBool and ssv_VehList[VehSID].IsSpawnedBool then
    local PedNetID = ssv_PedList[SID].PedNetID
    local ped = NetworkGetEntityFromNetworkId(PedNetID)
    local OwnerID = NetworkGetEntityOwner(ped)
    local VehNetID = ssv_VehList[VehSID].VehNetID
    if ssv_PedList[SID].ScriptOwnerNetID ~= OwnerID then
      ssv_PedList[SID].ScriptOwnerNetID = OwnerID
      TriggerClientEvent('scl:nat:res:TaskEnterVehicle', OwnerID, SID, PedNetID, VehSID, VehNetID, timeout, seatIndex, speed, flag, isOverride)
    else
      TriggerClientEvent('scl:nat:res:TaskEnterVehicle:Continue', OwnerID, SID, PedNetID, VehSID, VehNetID, timeout, seatIndex, speed, flag, isOverride)
    end
  elseif ssv_PedList[SID].IsSpawnedBool and not ssv_VehList[VehSID].IsSpawnedBool then
    local PedNetID = ssv_PedList[SID].PedNetID
    local ped = NetworkGetEntityFromNetworkId(PedNetID)
    local OwnerID = NetworkGetEntityOwner(ped)
    local vehdata = ssv_VehList[VehSID]
    if ssv_PedList[SID].ScriptOwnerNetID ~= OwnerID then
      ssv_PedList[SID].ScriptOwnerNetID = OwnerID
      TriggerClientEvent('scl:nat:res:TaskEnterVehicle:PedExists', OwnerID, SID, PedNetID, VehSID, vehdata, timeout, seatIndex, speed, flag, isOverride)
    else
      TriggerClientEvent('scl:nat:res:TaskEnterVehicle:PedExists:Continue', OwnerID, SID, PedNetID, VehSID, vehdata, timeout, seatIndex, speed, flag, isOverride)
    end
  elseif not ssv_PedList[SID].IsSpawnedBool and ssv_VehList[VehSID].IsSpawnedBool then
    TriggerEvent('ssv:nat:res:TaskEnterVehicle:Continue', SID, VehSID, timeout, seatIndex, speed, flag, isOverride)
  else
    TriggerEvent('ssv:nat:res:TaskEnterVehicle:Continue', SID, VehSID, timeout, seatIndex, speed, flag, isOverride)
  end
end)
