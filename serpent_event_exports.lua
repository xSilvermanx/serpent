--[[Copy this file to your resource, then copy the following codeblock to the end of your 'fxmanifest.lua'.
Afterwards you can delete this comment.

-- COPY THIS PART TO FXMANIFEST.LUA --

server_scripts {'serpent_event_exports.lua'}

server_exports { -- serpent event exports
    'sev_RandomPedIsInSerpentVehicle',
    'sev_SerpentPedDamaged',
    'sev_SerpentPedDespawned',
    'sev_SerpentPedIsInRandomVehicle',
    'ssv_SerpentPedMightBeStuck',
    'sev_SerpentPedOwnershipSwitched',
    'sev_SerpentPedSpawned',
    'sev_SerpentPedTaskFinished',
    'sev_SerpentPedTaskSet',
    'sev_SerpentPedTaskStarted',
    'sev_SerpentVehDamaged',
    'sev_SerpentVehDespawned',
    'sev_SerpentVehicleOutOfFuel',
    'sev_SerpentVehicleUndrivable',
    'sev_SerpentVehOwnershipSwitched',
    'sev_SerpentVehSpawned',
}

-- END OF THE PART TO COPY TO FXMANIFEST.LUA --
--]]

-- Event that fires if a random ped is in a serpent vehicle.
-- Gives the VehSID and the seat the ped is in.
-- Event expects a return:
-- decision = 0 -> Do nothing.
-- decision = 1 -> Kick ped out of the seat.
-- You can also use this event to load this ped as a serpent ped.
-- For this use the native LoadPedIntoSerpent() in this function.
-- Leave decision = 0 if you do this.
function sev_RandomPedIsInSerpentVehicle(VehSID, seat)
    local decision = 0

    return decision
end

-- Event that fires if a serpent ped got damaged.
-- Gives the following returns:
-- PedSID - the serpent ID of the damaged ped.
-- AttackerIsSerpentEntity - returns 'Ped' if serpent ped, 'Veh' if serpent veh, false if not a serpent entity.
-- AttackerID - the SerpentID of the attacker, or the network ID if the attacker is not a serpent ped or vehicle. Or -1 for environmental damage.
-- isDead - Boolean whether the serpent ped died from the damage.
-- weapon hash as in CEventNetworkEntityDamage - args[7].
function sev_SerpentPedDamaged(PedSID, AttackerIsSerpentEntity, AttackerID, isDead, weaponHash)

end

-- Event that fires if a serpent ped has been despawned from the game.
-- Gives the PedSID of the serpent ped.
function sev_SerpentPedDespawned(PedSID)

end

-- Event that fires if a serpent ped is in a random vehicle.
-- Gives the PedSID of the serpent ped.
-- Event expects a return:
-- decision = 0 -> Do nothing.
-- decision = 1 -> Kick serpent ped out of the seat. NOT RECOMMENDED especially if the serpent ped is currently fleeing.
-- If decision == 1 serpent automatically reapplies the task that should be set currently.
-- You can also use this event to load this vehicle as a serpent vehicle.
-- For this use the native LoadVehIntoSerpent() in this function.
-- Leave decision = 0 if you do this.
function sev_SerpentPedIsInRandomVehicle(PedSID)
    local decision = 0

    return decision
end

-- Not implemented and quite complicated to code for all proper tasks.
-- If you need and want to use this, please push me to work on it.
-- Note to self: Check PD5M -> tow truck and coroner arrival scripts.
function sev_SerpentPedMightBeStuck(PedSID)

end

-- Event that fires if the ownership of a serpent ped migrates.
-- Gives the PedSID of the serpent ped and the new serpent owner client of the ped.
function sev_SerpentPedOwnershipSwitched(PedSID, owner)

end

-- Event that fires if a serpent ped has been spawned in the game.
-- Gives the PedSID of the serpent ped and the serpent owner client of the ped.
function sev_SerpentPedSpawned(PedSID, owner)

end

-- Event that fires if a task has finished successfully.
-- Gives the PedSID of the serpent ped, the task name, whether it was an override task and whether a new task will be started.
-- Information on the new task will be sent in the event 'sev_SerpentPedTaskStarted'
function sev_SerpentPedTaskFinished(PedSID, Task, isOverride, hasNewTask)

end

-- Event that fires if a task has been set for a serpent ped.
-- Gives the PedSID of the serpent ped, the task name and the objective type ('Curr', 'Next', 'Override')
function sev_SerpentPedTaskSet(PedSID, Task, ObjType)

end

-- Event that fires if a task has been started or is reapplied.
-- Gives the PedSID of the serpent ped, the task name and whether it is an override task.
function sev_SerpentPedTaskStarted(PedSID, Task, isOverride)

end

-- Event that fires if a serpent vehicle got damaged.
-- All given visual damage is *total* damage, not newly acquired damage.
-- Gives the following returns:
-- VehSID - the serpent ID of the damaged vehicle.
-- AttackerIsSerpentEntity - returns 'Ped' if serpent ped, 'Veh' if serpent veh, false if not a serpent entity.
-- AttackerID - the SerpentID of the attacker, or the network ID if the attacker is not a serpent ped or vehicle. Or -1 for environmental damage.
-- isExploded - Boolean whether the serpent veh has exploded.
-- weapon hash as in CEventNetworkEntityDamage - args[7].
-- damage flag as in CEventNetworkEntityDamage - args[12].
-- isTyreAffected - whether a Tyre is flat or destroyed
-- TyreDamageList - List of affected tyres (integers)
-- isWheelAffected - whether a Wheel is broken off -- unimplemented, there is no native to check this.
-- WheelDamageList - List of affected wheels -- unimplemented
-- isDoorAffected - whether a Door has broken off -- unimplemented
-- DoorDamageList - List of affected doors -- unimplemented
-- isWindowAffected - whether a Window was smashed
-- WindowDamageList - List of affected windows (integers)
-- isBumperAffected - whether a Bumper (front or rear) has broken off or is bouncing
-- BumperDamageList - List of affected bumpers ('Front' and 'Rear') -- serpent doesn't sync the bumper damage currently.
-- areLightsAffected - whether Vehicle Lights are smashed -- unimplemented
-- LightsDamageList - List of affected Lights -- unimplemented
function sev_SerpentVehDamaged(VehSID, AttackerIsSerpentEntity, AttackerID, isExploded, weaponHash, damageFlag, isTyreAffected, TyreDamageList, isWheelAffected, WheelDamageList, isDoorAffected, DoorDamageList, isWindowAffected, WindowDamageList, isBumperAffected, BumperDamageList, areLightsAffected, LightsDamageList)

end

-- Event that fires if a serpent vehicle has been despawned from the game.
-- Gives the VehSID of the serpent vehicle.
function sev_SerpentVehDespawned(VehSID)

end

-- Event that fires if a serpent vehicle has ran out of fuel.
-- Gives the VehSID of the serpent vehicle.
function sev_SerpentVehicleOutOfFuel(VehSID)

end

-- Event that fires if a serpent vehicle has become undrivable.
-- Gives the VehSID of the serpent vehicle.
-- This event relies on the gameEvent CEventNetworkVehicleUndrivable.
function sev_SerpentVehicleUndrivable(VehSID)

end

-- Event that fires if the ownership of a serpent vehicle migrates.
-- Gives the VehSID of the serpent vehicle and the new serpent owner client of the vehicle.
function sev_SerpentVehOwnershipSwitched(VehSID, owner)

end

-- Event that fires if a serpent vehicle has been spawned in the game.
-- Gives the VehSID of the serpent vehicle and the serpent owner client of the vehicle.
function sev_SerpentVehSpawned(VehSID, owner)

end
