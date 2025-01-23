--[[
This file is the example for a functioning handler file for a custom task.
It showcases the implementation of the native 'TaskVehicleTempAction'.
The explanations for how and why this is set up are found in the template file.
The file is mostly commented in places where the implementation differs from the standard shown in the template.
As such this file expects you to have read and understood the template file.
Or you can place the two files next to each other and compare.

The native TaskVehicleTempAction can be used to force vehicles to behave in a specific way.
The implementation for this example is not done with a special use in mind.
This example does not include a server side implementation of the native because of this.
--]]

-- notice how the first four of the five function parameters are the same as in the native TaskVehicleTempAction() (check FiveM-docs).
-- the only difference is that serpent uses SIDs instead of the GTA V IDs.
function testres_TaskVehicleTempAction(PedSID, tVehSID, taction, ttime, ObjType)
    local source = 'testres'
    local Objective = 'Custom'
    local ObjectiveCustom = {
        resource = source,
        name = 'TaskVehicleTempAction',
    }
    local ObjectiveData = {
        task = 'Init',
        VehSID = tVehSID,
        action = taction,
        time = ttime,
        ticks = 0,
    }
    local PathfindingData = {}
    exports.serpent:ssv_nat_SetSerpentPedTask(PedSID, Objective, ObjectiveCustom, ObjectiveData, PathfindingData, ObjType)
end

RegisterNetEvent('ssv:custom:testres:TaskVehicleTempAction')
AddEventHandler('ssv:custom:testres:TaskVehicleTempAction', function(SID, ObjectiveData, PathfindingData, isOverride)
    local task = ObjectiveData.task
    if task == 'Init' then
        -- as this is a movement task the peds and vehicles are not using exact spawn coordinates.
        exports.serpent:ssv_nat_PedUseExactSpawnCoordinates(SID, false)
        exports.serpent:ssv_nat_VehUseExactSpawnCoordinates(ObjectiveData.VehSID, false)
    end

    -- the success condition for TaskVehicleTempAction is the lapse of a certain time.
    -- this is implemented by the variable "ticks". 1 tick = 500 ms.
    -- ticks is a counter and gets upped by one each run.
    local ticks = ObjectiveData.ticks
    if (ObjectiveData.time ~= -1) and (ticks*500 >= ObjectiveData.time) then

        -- In practice TaskVehicleTempAction doesn't seem to terminate after the alloted time.
        -- As such the implementation of the native has to manually stop the task from running further than wanted.
        -- Because of this it is checked whether the ped is currently spawned.
        local peddata = exports.serpent:ssv_nat_GetSerpentPedData(SID)
        if peddata.IsSpawnedBool then
            -- check $task$:Continue-event for the explanation of this codeblock.
            local vehdata = exports.serpent:ssv_nat_GetSerpentVehData(ObjectiveData.VehSID)
            local PedNetID = peddata.PedNetID
            local ped = NetworkGetEntityFromNetworkId(PedNetID)
            local OwnerID = NetworkGetEntityOwner(ped)
            if peddata.ScriptOwnerNetID ~= OwnerID then
                exports.serpent:ssv_nat_SetSerpentPedData(SID, '', 'ScriptOwnerNetID', OwnerID)
            end

            -- The trigger of the success function gets delayed after the client has stopped the task from running.
            -- This is to ensure that serpent hasn't already triggered a new task when this function stops it.
            TriggerClientEvent('testres:cl:TaskVehicleTempAction:Finish', OwnerID, SID, peddata, vehdata, isOverride)
        else
            -- If the ped isn't spawned, the standard success function is triggered.
            exports.serpent:ssv_nat_FinishSerpentPedTask(SID, isOverride)
        end
    else

        TriggerEvent('testres:TaskVehicleTempAction:' .. task, SID, ObjectiveData, PathfindingData, isOverride)

        -- after ticks gets upped by one the data needs to be synced to serpent. This happens here.
        ticks = ticks + 1
        if isOverride then
            exports.serpent:ssv_nat_SetSerpentPedData(SID, 'OverrideObjectiveData', 'ticks', ticks)
        else
            exports.serpent:ssv_nat_SetSerpentPedData(SID, 'CurrObjectiveData', 'ticks', ticks)
        end

        if task == 'Init' then
            exports.serpent:ssv_nat_UpdateSerpentPedTaskStatus(SID, 'Continue', isOverride)
        end
    end
end)

AddEventHandler('testres:TaskVehicleTempAction:Init', function(SID, ObjectiveData, PathfindingData, isOverride)
    local peddata = exports.serpent:ssv_nat_GetSerpentPedData(SID)
    local vehdata = exports.serpent:ssv_nat_GetSerpentVehData(ObjectiveData.VehSID)
    if peddata.IsSpawnedBool and vehdata.IsSpawnedBool then
        local PedNetID = peddata.PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)
        exports.serpent:ssv_nat_SetSerpentPedData(SID, '', 'ScriptOwnerNetID', OwnerID)
        TriggerClientEvent('testres:cl:TaskVehicleTempAction:Init', OwnerID, SID, peddata, vehdata, ObjectiveData, PathfindingData, isOverride)
    else
        TriggerEvent('testres:sv:TaskVehicleTempAction:Init', SID, ObjectiveData, PathfindingData, isOverride)
    end
end)

AddEventHandler('testres:TaskVehicleTempAction:Continue', function(SID, ObjectiveData, PathfindingData, isOverride)
    local peddata = exports.serpent:ssv_nat_GetSerpentPedData(SID)
    local vehdata = exports.serpent:ssv_nat_GetSerpentVehData(ObjectiveData.VehSID)
    if peddata.IsSpawnedBool and vehdata.IsSpawnedBool then
        local PedNetID = peddata.PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)
        if peddata.ScriptOwnerNetID ~= OwnerID then
            exports.serpent:ssv_nat_SetSerpentPedData(SID, '', 'ScriptOwnerNetID', OwnerID)
            TriggerClientEvent('testres:cl:TaskVehicleTempAction:Init', OwnerID, SID, peddata, vehdata, ObjectiveData, PathfindingData, isOverride)
        else
            TriggerClientEvent('testres:cl:TaskVehicleTempAction:Continue', OwnerID, SID, peddata, vehdata, ObjectiveData, PathfindingData, isOverride)
        end
    else
        TriggerEvent('testres:sv:TaskVehicleTempAction:Continue', SID, ObjectiveData, PathfindingData, isOverride)
    end
end)

-- After the client stopped TaskVehicleTempAction, this event gets called from the client.
-- This resumes the normal procedure to finish a task in serpent.
RegisterNetEvent('testres:sv:TaskVehicleTempAction:Finish')
AddEventHandler('testres:sv:TaskVehicleTempAction:Finish', function(SID, isOverride)
    exports.serpent:ssv_nat_FinishSerpentPedTask(SID, isOverride)
end)