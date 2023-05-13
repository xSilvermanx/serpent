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


--[[RegisterNetEvent('CreateBlips')
AddEventHandler('CreateBlips', function(Path, sx, sy, sz, ex, ey, ez, vehx, vehy, vehz, tarx, tary, tarz)
    local startblip = AddBlipForCoord(sx, sy, sz)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("STARTHELPER")
    EndTextCommandSetBlipName(startblip)

    local endblip = AddBlipForCoord(ex, ey, ez)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("ENDHELPER")
    EndTextCommandSetBlipName(endblip)

    local vehblip = AddBlipForCoord(vehx, vehy, vehz)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("START")
    EndTextCommandSetBlipName(vehblip)

    local goalblip = AddBlipForCoord(tarx, tary, tarz)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("GOAL")
    EndTextCommandSetBlipName(goalblip)


    for i, entry in ipairs(Path) do
        print(entry)
        if ListNodes[entry] then
            blip = AddBlipForCoord(ListNodes[entry].x, ListNodes[entry].y, ListNodes[entry].z)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(entry)
            EndTextCommandSetBlipName(blip)
        end
    end

end)]]