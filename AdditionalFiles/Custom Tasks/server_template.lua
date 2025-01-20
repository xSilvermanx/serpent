--[[
This file is the template for a server file for a custom task.
Please start by reading the handler_template.lua file which explains the basics of the system.
--]]

--[[
--- Layout of the -server- file ---
The -server- file normally consists of two events:
The $task$:sv:Init event gets triggered on first execution.
The $task$:sv:Continue event gets triggered from after the first execution to the termination of the task.
--]]


AddEventHandler('$yourTaskEventName$:sv:Init', function(SID, ObjectiveData, PathfindingData, isOverride)
%(yourTaskLogicHere)%
end)

AddEventHandler('$yourTaskEventName$:sv:Continue', function(SID, ObjectiveData, PathfindingData, isOverride)
%(yourTaskLogicHere)%
end)

--[[
--- Important: Send changed data to serpent! ---
Remember that if you change data you need to send that data to serpent.
For this use the serpent native ssv_nat_setSerpentPedData(SID, type, key, data) and ssv_nat_setSerpentVehData(SID, type, key, data).
E.g. if you want to set a new position for your ped, do this:

    local newpos = {x = posx, y = posy, z = posz}
    ssv_nat_SetSerpentPedData(SID, '', 'x', newpos.x)
    ssv_nat_SetSerpentPedData(SID, '', 'y', newpos.y)
    ssv_nat_SetSerpentPedData(SID, '', 'z', newpos.z)

--]]

--[[
--- Tips ---
There is no proper template for how to set up a server side approach to a native.
First understand what your ped should do in any given task.
Try to formalize that understanding in mathematical equations.
Most likely linear algebra and vector calculus will be very useful to you, as well as a bit of physics (velocity = distance / time).
Remember that the events get executed every 500 ms.
It can be useful to save data that stays the same in PathfindingData.
For example if your ped walks in a straight line, save a normalized vector so you don't need to calculate it every 500 ms. It won't change over the course of the whole task.
]]