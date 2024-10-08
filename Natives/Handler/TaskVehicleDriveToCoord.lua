function ssv_nat_TaskVehicleDriveToCoord(SID, tVehSID, tx, ty, tz, tspeed, tdrivingMode, tstopRange, ObjType)
    if ObjType == "Next" then
        ssv_PedList[SID].NextObjective = 'TaskVehicleDriveToCoord'
        ssv_PedList[SID].NextObjectiveData = {
            task = 'Init', --Continue, Ignore
            VehSID = tVehSID,
            x = tx,
            y = ty,
            z = tz,
            speed = tspeed,
            drivingMode = tdrivingMode,
            stopRange = tstopRange,
        }
        if ssv_PedList[SID].IsSpawnedBool then
            local OwnerID = ssv_PedList[SID].OwnerClientNetID
            local NextObjective = 'TaskVehicleDriveToCoord'
            local NextObjectiveData = ssv_PedList[SID].NextObjectiveData
            TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'NextObjective', 'NextObjective', NextObjective)
            TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'NextObjective', 'NextObjectiveData', NextObjectiveData)
            TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'NextObjective', 'NextPathfindingData', {})
        end
        elseif ObjType == "Override" then
        ssv_PedList[SID].OverrideObjective = 'TaskVehicleDriveToCoord'
        ssv_PedList[SID].OverrideObjectiveData = {
            task = 'Init', --Continue, Ignore
            VehSID = tVehSID,
            x = tx,
            y = ty,
            z = tz,
            speed = tspeed,
            drivingMode = tdrivingMode,
            stopRange = tstopRange,
        }
        if ssv_PedList[SID].IsSpawnedBool then
            local OwnerID = ssv_PedList[SID].OwnerClientNetID
            local OverrideObjective = 'TaskVehicleDriveToCoord'
            local OverrideObjectiveData = ssv_PedList[SID].OverrideObjectiveData
            TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'OverrideObjective', 'OverrideObjective', OverrideObjective)
            TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'OverrideObjective', 'OverrideObjectiveData', OverrideObjectiveData)
            TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'OverrideObjective', 'OverridePathfindingData', {})
        end
        else
        ssv_PedList[SID].CurrObjective = 'TaskVehicleDriveToCoord'
        ssv_PedList[SID].CurrObjectiveData = {
            task = 'Init', --Continue, Ignore
            VehSID = tVehSID,
            x = tx,
            y = ty,
            z = tz,
            speed = tspeed,
            drivingMode = tdrivingMode,
            stopRange = tstopRange,
        }
        if ssv_PedList[SID].IsSpawnedBool then
            local OwnerID = ssv_PedList[SID].OwnerClientNetID
            local CurrObjective = 'TaskVehicleDriveToCoord'
            local CurrObjectiveData = ssv_PedList[SID].CurrObjectiveData
            TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'CurrObjective', 'CurrObjective', CurrObjective)
            TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'CurrObjective', 'CurrObjectiveData', CurrObjectiveData)
            TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'CurrObjective', 'CurrPathfindingData', {})
        end
    end
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
    ssv_VehList[ssv_PedList[SID].VehSID].currspeed = 20.0

    if (distance <= 3*ObjectiveData.stopRange and ssv_PedList[SID].IsSpawnedBool) or (distance <= 10*ObjectiveData.stopRange and not ssv_PedList[SID].IsSpawnedBool) then
        ssv_VehList[ssv_PedList[SID].VehSID].currspeed = 0.0
        TriggerEvent('ssv:FinishTask', SID, isOverride, true)
    else
        local task = ObjectiveData.task
        TriggerEvent('ssv:nat:TaskVehicleDriveToCoord:' .. task, SID, ObjectiveData, PathfindingData, isOverride)
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