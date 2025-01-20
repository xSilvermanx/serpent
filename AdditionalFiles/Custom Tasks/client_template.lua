--[[ 
This file is the template for a client file for a custom task.
Please start by reading the handler_template.lua file which explains the basics of the system.
--]]

--[[
--- Layout of the -client- file ---
The -client- file normally consists of two events:
The $task$:cl:Init event gets triggered on first execution.
The $task$:cl:Continue event gets triggered from after the first execution to the termination of the task.
--]]

AddEventHandler('$yourTaskEventName$:cl:Init', function(SID, peddata, vehdata, ObjectiveData, PathfindingData, isOverride)
    local ped = NetToPed(peddata.PedNetID)
    local veh = NetToVeh(vehdata.VehNetID)

    %(yourTaskLogicHere)% -- this is most likely just triggering a FiveM-native.
end)
    
AddEventHandler('$yourTaskEventName$:cl:Continue', function(SID, peddata, vehdata, ObjectiveData, PathfindingData, isOverride)
    -- most likely empty as GTA V and FiveM handle everything here.
    -- optional:
    %(yourTaskLogicHere)%
end)

--[[
--- Important notice ---
DO NOT SYNC DATA WITH SERPENT DIRECTLY FROM HERE!
Data like the new position of the ped does not need to be synced with serpent.
Serpent handles this automatically.
Certain data needs to be synced, e.g. a ped having entered a vehicle (check Natives/Client/TaskEnterVehicle_cl.lua).
To do this first send the data to the server on your client (via TriggerServerEvent), only then trigger the serpent native ssv_nat_SetSerpentPedData().
--]]