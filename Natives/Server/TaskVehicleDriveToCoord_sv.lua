AddEventHandler('ssv:nat:res:TaskVehicleDriveToCoord:Init', function(SID, ObjectiveData, PathfindingData, isOverride)
    local VehSID = ssv_PedList[SID].VehSID
    local vehx = ssv_VehList[VehSID].x
    local vehy = ssv_VehList[VehSID].y
    local vehz = ssv_VehList[VehSID].z
    local tarx = ObjectiveData.x
    local tary = ObjectiveData.y
    local tarz = ObjectiveData.z
    local _, startid = ssv_nat_GetClosestNodeId(vehx, vehy, vehz)
    local _, endid = ssv_nat_GetClosestNodeId(tarx, tary, tarz)

    local Path = AStar(startid, endid)

    local speed = ObjectiveData.speed
    
    -- begin of path
    local startpathoverridedistance = speed
    if speed == -1 then
        for i, entry in ListNodes[Path[#Path]].paths do
            if entry[1] == Path[#Path-1] then
                startpathoverridedistance = entry[2]
                break
            end
        end
    elseif speed == -2 then
        for i, entry in ListNodes[Path(#Path)].paths do
            if entry[1] == Path[#Path-1] then
                startpathoverridedistance = entry[2]*2
                break
            end
        end
    end
    local sx, sy, sz, sr, sd = ssh_GetPositionOnLineClosestToPoint(vehx, vehy, vehz, ListNodes[Path[#Path]].x, ListNodes[Path[#Path]].y, ListNodes[Path[#Path]].z, ListNodes[Path[#Path-1]].x, ListNodes[Path[#Path-1]].y, ListNodes[Path[#Path-1]].z)
    if sr > 0 then
        table.remove(Path, #Path)
        if sd > startpathoverridedistance then
            table.insert(Path, "STARTHELPER")
            if isOverride then
                ssv_PedList[SID].OverridePathfindingData['STARTHELPER'] = {sx, sy, sz}
            else
                ssv_PedList[SID].CurrPathfindingData['STARTHELPER'] = {sx, sy, sz}
            end
        end
    end

    -- end of path
    local endpathoverridedistance = speed
    if speed == -1 then
        for i, entry in ListNodes[Path[#Path]].paths do
            if entry[1] == Path[#Path-1] then
                endpathoverridedistance = entry[2]
                break
            end
        end
    elseif speed == -2 then
        for i, entry in ListNodes[Path[#Path]].paths do
            if entry[1] == Path[#Path-1] then
                endpathoverridedistance = entry[2]*2
                break
            end
        end
    end
    local ex, ey, ez, er, ed = ssh_GetPositionOnLineClosestToPoint(tarx, tary, tarz, ListNodes[Path[1]].x, ListNodes[Path[1]].y, ListNodes[Path[1]].z, ListNodes[Path[2]].x, ListNodes[Path[2]].y, ListNodes[Path[2]].z)
    if er > 0 then
        table.remove(Path, 1)
        if ed > endpathoverridedistance then
            table.insert(Path, 1, "ENDHELPER")
            if isOverride then
                ssv_PedList[SID].OverridePathfindingData['ENDHELPER'] = {ex, ey, ez}
            else
                ssv_PedList[SID].CurrPathfindingData['ENDHELPER'] = {ex, ey, ez}
            end
        end
    end

    TriggerClientEvent('CreateBlips', -1, Path, sx, sy, sz, ex, ey, ez, vehx, vehy, vehz, tarx, tary, tarz)

    table.insert(Path, "START")
    table.insert(Path, 1, "GOAL")

    for i, entry in ipairs(Path) do
        print(i, entry)
    end
    print('Length of Path', #Path)

    if isOverride then
        ssv_PedList[SID].OverridePathfindingData['Path'] = Path
        ssv_PedList[SID].OverridePathfindingData['CurrentNode'] = #Path - 1
    else
        ssv_PedList[SID].CurrPathfindingData['Path'] = Path
        ssv_PedList[SID].CurrPathfindingData['CurrentNode'] = #Path - 1
    end

end)

AddEventHandler('ssv:nat:res:TaskVehicleDriveToCoord:Continue', function(SID, ObjectiveData, PathfindingData, isOverride)

end)
