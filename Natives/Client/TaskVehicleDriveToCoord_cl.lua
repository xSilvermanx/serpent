RegisterNetEvent('scl:nat:res:TaskVehicleDriveToCoord:Init')
AddEventHandler('scl:nat:res:TaskVehicleDriveToCoord:Init', function(SID, PedData, VehData, ObjectiveData, PathfindingData, isOverride)
    local ped = NetToPed(PedData.PedNetID)
    local veh = NetToVeh(VehData.VehNetID)

    -- todo: Speed == -1 -> Driving the speed limit on any given street
    -- todo: Speed == -2 -> Speeding reasonably on any given street (Factor 2 or 2.5 of the given speed limit)

    TaskVehicleDriveToCoord(ped, veh, ObjectiveData.x, ObjectiveData.y, ObjectiveData.z, ObjectiveData.speed, 0, VehData.ModelHash, ObjectiveData.drivingMode, ObjectiveData.stopRange, true)
end)

RegisterNetEvent('scl:nat:res:TaskVehicleDriveToCoord:Continue')
AddEventHandler('scl:nat:res:TaskVehicleDriveToCoord:Init', function(SID, PedData, VehData, ObjectiveData, PathfindingData, isOverride)
    -- todo: Speed == -1 -> Driving the speed limit on any given street
    -- todo: Speed == -2 -> Speeding reasonably on any given street (Factor 2 or 2.5 of the given speed limit)
end)