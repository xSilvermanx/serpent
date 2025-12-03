function ssv_nat_TaskVehicleDriveToCoord(SID, tVehSID, tx, ty, tz, tspeed, tdrivingMode, tstopRange, ObjType)
    if ObjType == "Next" then
        local NextObjective = 'TaskVehicleDriveToCoord'
        local NextObjectiveData = {
            task = 'Init', --Continue, Ignore
            VehSID = tVehSID,
            x = tx,
            y = ty,
            z = tz,
            speed = tspeed,
            drivingMode = tdrivingMode,
            stopRange = tstopRange,
        }
        TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjective', NextObjective)
        TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjectiveData', NextObjectiveData)
        TriggerEvent('ssv:SyncPedData', SID, '', 'NextPathfindingData', {})
    elseif ObjType == "Override" then
        local OverrideObjective = 'TaskVehicleDriveToCoord'
        local OverrideObjectiveData = {
            task = 'Init', --Continue, Ignore
            VehSID = tVehSID,
            x = tx,
            y = ty,
            z = tz,
            speed = tspeed,
            drivingMode = tdrivingMode,
            stopRange = tstopRange,
        }
        TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjective', OverrideObjective)
        TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjectiveData', OverrideObjectiveData)
        TriggerEvent('ssv:SyncPedData', SID, '', 'OverridePathfindingData', {})

    else
        local CurrObjective = 'TaskVehicleDriveToCoord'
        local CurrObjectiveData = {
            task = 'Init', --Continue, Ignore
            VehSID = tVehSID,
            x = tx,
            y = ty,
            z = tz,
            speed = tspeed,
            drivingMode = tdrivingMode,
            stopRange = tstopRange,
        }
        TriggerClientEvent('ssv:SyncPedData', SID, '', 'CurrObjective', CurrObjective)
        TriggerClientEvent('ssv:SyncPedData', SID, '', 'CurrObjectiveData', CurrObjectiveData)
        TriggerClientEvent('ssv:SyncPedData', SID, '', 'CurrPathfindingData', {})
    end
    TriggerEvent('ssv:ev:SerpentPedTaskSet', SID, 'TaskVehicleDriveToCoord', ObjType)
end

RegisterNetEvent('ssv:nat:TaskVehicleDriveToCoord')
AddEventHandler('ssv:nat:TaskVehicleDriveToCoord', function(SID, ObjectiveData, PathfindingData, isOverride)
    local x = ssv_PedList[SID].x
    local y = ssv_PedList[SID].y
    local z = ssv_PedList[SID].z

    local tarx = ObjectiveData.x
    local tary = ObjectiveData.y
    local tarz = ObjectiveData.z
    local distance = ssh_VectorDistance(x, y, z, tarx, tary, tarz)

    ssv_nat_PedUseExactSpawnCoordinates(SID, false)
    ssv_nat_VehUseExactSpawnCoordinates(ssv_PedList[SID].VehSID, false)
    ssv_VehList[ssv_PedList[SID].VehSID].currspeed = 5.0

    if (distance <= 3*ObjectiveData.stopRange and ssv_PedList[SID].IsSpawnedBool) or (distance <= 10*ObjectiveData.stopRange and not ssv_PedList[SID].IsSpawnedBool) then
        ssv_VehList[ssv_PedList[SID].VehSID].currspeed = 0.0
        position = target
        TriggerEvent('ssv:FinishTask', SID, isOverride, true)
    else
        local task = ObjectiveData.task
        TriggerEvent('ssv:nat:TaskVehicleDriveToCoord:' .. task, SID, ObjectiveData, PathfindingData, isOverride)
        if task == 'Init' then
            if isOverride then
                TriggerEvent('ssv:SyncPedData', SID, 'OverrideObjectiveData', 'task', 'Continue')
            else
                TriggerEvent('ssv:SyncPedData', SID, 'CurrObjectiveData', 'task', 'Continue')
            end
        end
    end
end)

AddEventHandler('ssv:nat:TaskVehicleDriveToCoord:Init', function(SID, ObjectiveData, PathfindingData, isOverride)
    if ssv_PedList[SID].IsSpawnedBool and ssv_VehList[ObjectiveData.VehSID].IsSpawnedBool then
        local PedNetID = ssv_PedList[SID].PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)
        local PedData = ssv_PedList[SID]
        local VehData = ssv_VehList[ObjectiveData.VehSID]
        ssv_PedList[SID].ScriptOwnerNetID = OwnerID
        TriggerClientEvent('scl:nat:res:TaskVehicleDriveToCoord:Init', OwnerID, SID, PedData, VehData, ObjectiveData, PathfindingData, isOverride)
    elseif not (ssv_PedList[SID].IsSpawnedBool or ssv_VehList[ObjectiveData.VehSID].IsSpawnedBool) then
        TriggerEvent('ssv:nat:res:TaskVehicleDriveToCoord:Init', SID, ObjectiveData, PathfindingData, isOverride)
    end
end)

AddEventHandler('ssv:nat:TaskVehicleDriveToCoord:Continue', function(SID, ObjectiveData, PathfindingData, isOverride)
    if ssv_PedList[SID].IsSpawnedBool and ssv_VehList[ObjectiveData.VehSID].IsSpawnedBool then
        local PedNetID = ssv_PedList[SID].PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)
        local PedData = ssv_PedList[SID]
        local VehData = ssv_VehList[ObjectiveData.VehSID]
        if ssv_PedList[SID].ScriptOwnerNetID ~= OwnerID then
            ssv_PedList[SID].ScriptOwnerNetID = OwnerID
            TriggerClientEvent('scl:nat:res:TaskVehicleDriveToCoord:Init', OwnerID, SID, PedData, VehData, ObjectiveData, PathfindingData, isOverride)
        else
            TriggerClientEvent('scl:nat:res:TaskVehicleDriveToCoord:Continue', OwnerID, SID, PedData, VehData, ObjectiveData, PathfindingData, isOverride)
        end
    elseif not (ssv_PedList[SID].IsSpawnedBool or ssv_VehList[ObjectiveData.VehSID].IsSpawnedBool) then
        TriggerEvent('ssv:nat:res:TaskVehicleDriveToCoord:Continue', SID, ObjectiveData, PathfindingData, isOverride)
    end
end)