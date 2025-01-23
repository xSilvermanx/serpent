--[[
--- READ ME FIRST ---
These files explain you how to create custom tasks on your resources for use with serpent.
Please read this file first, it explains the process happening in serpent when triggering tasks and how the different events interact with each other.
The $name$_template.lua files showcase the basic principles and expectations when creating a custom task.
The $name$_example.lua files contain a heavily commented example for such a custom task.

I use the following symbols in these files:
-name- : two hyphens around a name serve as a mark.
$name$ : two dollarsigns around a name sign that you have to choose a certain name here. Any conditions for the choice will be mentioned in a comment.
%(name)% : %( shows the beginning of a part to be filled with data, )% the end of it. Between these markers you have to fill in the content for your task.
--]]

--[[
--- Basic Principle ---
A task consists of up to three files:
The -handler- contains all functions and events necessary to communicate with serpent, ensure proper execution of the functions and take into account whether the ped is currently spawned and other restrictions.
The -server- contains the serverside implementation of the task. This is going to be mostly mathematics.
The -client- contains the necessary code to execute the native on the client.

Serpent works with a so called -MainTaskHandler-. The -MainTaskHandler- reads which task the ped currently runs and triggers the appropriate event.
This event is in the -handler- file and will be described below.
The -MainTaskHandler- runs once every 500 ms. That means that these events will be triggered many times.
Because of this all tasks have a variable named "task" that can be either "Init", "Continue" or "Ignore".
After one execution of "Init" serpent expects that "Init" will be changed to "Continue".
-server- and -client- contain code for both "Init" and "Continue" states.
-handler- contains the logic to trigger the proper code on -server- or -client-.
--]]

--[[
--- A word on "Init" and "Continue" ---
On -client- "Init" will contain the task native, most of the time "Continue" will be empty as to not trigger the same task multiple times ingame.
On -server- "Init" and "Continue" will most likely be similar however "Continue" will most likely be a bit more lightweight.
If calculations happening in "Init" will not change over the course of the native (e.g. the direction if you are driving in a straight line) "Init" can save them for "Continue" to access them.
This will save valuable calculation time in the "Continue" process.
--]]

--[[
--- Layout of the -handler- file ---
A -handler- file normally consists of one function and three events:
The $task$-function is triggered by other resources. It is used to set the task. The function only sets data for serpent; it doesn't trigger any natives or interact with the game at all.
The $task$-event is the event directly triggered by -MainTaskHandler-. It contains logic for successful termination of the task, logic to change "Init" to "Continue" and logic to trigger the next event.
The $task$:Init-event is triggered by the $task$-event at first execution. It checks whether the ped is currently spawns and sends a command to execute the task either to the server or the client.
The $task$:Continue-event is triggered by the $task$-event after first execution. It does the same as Init.
--]]

----- The $task$-function -----
-- This function sets your task in serpent.
-- It fetches all relevant information and enters the data into serpent.
-- This is the function that will get triggered by you if you want the ped to do a certain task.
-- First parameter should be the PedSID of the ped executing the task.
-- Last parameter should be "ObjType" as explained in the docs.
-- The other parameters should be the parameters you need to create the task.
-- The function collects the necessary data and sends it to serpent.
function $yourTaskName$(PedSID, %(variablesForYourTask)%, ObjType) -- variablesForYourTask: Can be the parameters for a native if you implement one, or whatever you need to simulate the task at hand.
    local source = '$yourResourceName$' -- place the name of your resource here
    local Objective = 'Custom' -- this has to be 'Custom'. -MainTaskHandler- uses this to know that it has to trigger an export, not a serpent-internal task.
    local ObjectiveCustom = {
        resource = source,
        name = '$yourTaskEventName$' -- this has to be the name of the $task$-event
    }
    local ObjectiveData = {
        task = 'Init', -- this has to be set to 'Init' at first.
        %(ObjectiveDataForYourTask)% -- the objectiveData for your task. Most likely this saves the function parameters variablesForYourTask as described above.
    }
    local PathfindingData = {} -- most likely empty at first. This is the place to save results of functions like A* or other calculations which you don't want to calculate every 500 ms.
    exports.serpent:ssv_nat_SetSerpentPedTask(PedSID, Objective, ObjectiveCustom, ObjectiveData, PathfindingData, ObjType) -- sends all data to serpent. Serpent will do the rest.
end

----- The $task$-event -----
-- This event is triggered by -MainTaskHandler-.
-- It fulfills multiple purposes:
-- It changes specific variables when the event is in status 'Init'.
-- It contains the logic to check whether the task was completed succesfully.
-- It updates the task status to 'Continue'.
-- It triggers the $task$:Init-event or the $task$:Continue-event.
-- The event triggers with the following parameters:
-- SID - The SID of the ped that performs the task.
-- ObjectiveData - The objective data of the ped for this task as defined in the $task$-function.
-- PathfindingData - The pathfinding data of the ped for this task as defined in the $task$-function and the $task$:Init-event.
-- isOverride - Boolean that states whether the task is the "Curr" task or the "Override" task.
RegisterNetEvent('ssv:custom:$yourResourceName$:$yourTaskEventName$')
AddEventHandler('ssv:custom:$yourResourceName$:$yourTaskEventName$', function(SID, ObjectiveData, PathfindingData, isOverride)
    local task = ObjectiveData.task -- writes the task status
    if task == 'Init' then
        %(yourDecisionsForWhenThisEventIsExecuted)% -- place to set different functions like behavior flags for peds or something else.
        -- e.g. if you have a task which uses the Serpent path nodes you might want to use exports.serpent:ssv_nat_PedUseExactSpawnCoordinates(SID, false).
    end

    if %(successCondition)% then -- determine when your task is completed successfully. E.g. if entering a car the task is a success if the ped is in the car.
    -- note that more complicated successConditions could be implemented by a variable in ObjectiveData which gets manipulated in -server- or -client- files.
    -- for a more complicated successCondition check out the serpent native TaskEnterVehicle.
        %(successCodeToBeExecuted)% -- optionally you can execute other code here if necessary after the task is completed.
        exports.serpent:ssv_nat_FinishSerpentPedTask(SID, isOverride)
    else
        TriggerEvent('$yourTaskEventName$:' .. task, SID, ObjectiveData, PathfindingData, isOverride) -- triggers either $task$:Init-event or $task$:Continue-event.

        if task == 'Init' then -- this codeblock is used to set the task status to 'Continue'.
            exports.serpent:ssv_nat_UpdateSerpentPedTaskStatus(SID, 'Continue', isOverride)
        end
    end
end)

----- The $task$:Init-event -----
-- This event is triggered only once, when the task is initialized.
-- The event is nearly only used to determine whether -client- or -server- get contacted next.
AddEventHandler('$yourTaskEventName$:Init', function(SID, ObjectiveData, PathfindingData, isOverride)
    local peddata = exports.serpent:ssv_nat_GetSerpentPedData(SID) -- fetch the serpent peddata.
    local vehdata = exports.serpent:ssv_nat_GetSerpentVehData(ObjectiveData.VehSID) -- optional: fetch the serpent vehdata if the task uses a vehicle and the VehSID is saved in ObjectiveData.
    
    -- Check whether -client- or -server- is to be called. In specific functions (e.g. TaskEnterVehicle) it is also important to check whether the vehicle is spawned. This results in four different cases:
    -- ped and vehicle spawned,
    -- ped spawned, vehicle not spawned,
    -- vehicle spawned, ped not spawned,
    -- nothing spawned.
    -- Check 'TaskEnterVehicle' to see how a possible solution looks like.
    if peddata.IsSpawnedBool then
        -- finds the entity owner in GTA V. Serpent calls this "ScriptOwner".
        local PedNetID = peddata.PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)
        exports.serpent:ssv_nat_SetSerpentPedData(SID, '', 'ScriptOwnerNetID', OwnerID)

        -- Triggers the event on the client to execute the task or native.
        -- Send peddata and vehdata to the client too as it doesn't have easy access to that data otherwise.
        TriggerClientEvent('$yourTaskEventName$:cl:Init', OwnerID, SID, peddata, vehdata, ObjectiveData, PathfindingData, isOverride)
    else
        -- Triggers the event on the server to simulate the task or native.
        -- You don't need to send peddata and vehdata to the server as it always has access to that data.
        TriggerEvent('$yourTaskEventName$:sv:Init', SID, ObjectiveData, PathfindingData, isOverride)
    end
end)

----- The $task$:Continue-event -----
-- This event is triggered after the initialization every 500 ms.
-- The event has nearly the exact same scope and looks as the $task$:Init-event.
AddEventHandler('$yourTaskEventName$:Continue', function(SID, ObjectiveData, PathfindingData, isOverride)
    local peddata = exports.serpent:ssv_nat_GetSerpentPedData(SID)
    local vehdata = exports.serpent:ssv_nat_GetSerpentVehData(ObjectiveData.VehSID)
    if peddata.IsSpawnedBool and vehdata.IsSpawnedBool then
        local PedNetID = peddata.PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)

        -- if the GTA V-entity owner migrates during the execution of a task, it is noticed here.
        if peddata.ScriptOwnerNetID ~= OwnerID then
            exports.serpent:ssv_nat_SetSerpentPedData(SID, '', 'ScriptOwnerNetID', OwnerID)
            -- if a migration happened, trigger 'Init' again to reapply the task. Safeguard in case a bug happens during migration and a task gets lost.
            TriggerClientEvent('$yourTaskEventName$:cl:Init', OwnerID, SID, peddata, vehdata, ObjectiveData, PathfindingData, isOverride)
        else
            -- if the ownership didn't migrate, trigger 'Continue'.
            TriggerClientEvent('$yourTaskEventName$:cl:Continue', OwnerID, SID, peddata, vehdata, ObjectiveData, PathfindingData, isOverride)
        end
    else
        TriggerEvent('$yourTaskEventName$:sv:Continue', SID, ObjectiveData, PathfindingData, isOverride)
    end
end)
