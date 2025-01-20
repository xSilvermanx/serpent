--[[
This file is the example for a client file for a custom task.
Please start by reading the handler_template.lua file which explains the basics of the system.
--]]

RegisterNetEvent('testres:cl:TaskVehicleTempAction:Init')
AddEventHandler('testres:cl:TaskVehicleTempAction:Init', function(SID, peddata, vehdata, ObjectiveData, PathfindingData, isOverride)
    local ped = NetToPed(peddata.PedNetID)
    local veh = NetToVeh(vehdata.VehNetID)
    TaskVehicleTempAction(ped, veh, ObjectiveData.action, ObjectiveData.time)
end)

RegisterNetEvent('testres:cl:TaskVehicleTempAction:Continue')
AddEventHandler('testres:cl:TaskVehicleTempAction:Continue', function(SID, peddata, vehdata, ObjectiveData, PathfindingData, isOverride)
end)

-- As explained in handler_example.lua TaskVehicleTempAction doesn't terminate after the allotted time ran out.
-- To combat this the tasks get cleared immediately and the ped is set into the vehicle again.
-- Only afterwards the server gets prompted again to continue the process to terminate the task.
RegisterNetEvent('testres:cl:TaskVehicleTempAction:Finish')
AddEventHandler('testres:cl:TaskVehicleTempAction:Finish', function(SID, peddata, vehdata, isOverride)
    local ped = NetToPed(peddata.PedNetID)
    local veh = NetToVeh(vehdata.VehNetID)
    ClearPedTasksImmediately(ped)
    SetPedIntoVehicle(ped, veh, -1)
    TriggerServerEvent('testres:sv:TaskVehicleTempAction:Finish', SID, isOverride)
end)