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
                startpathoverridedistance = entry[2]*entry[3]
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
                endpathoverridedistance = entry[2]*entry[3]
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

    --TriggerClientEvent('CreateBlips', -1, Path, sx, sy, sz, ex, ey, ez, vehx, vehy, vehz, tarx, tary, tarz)

    table.insert(Path, "START")
    table.insert(Path, 1, "GOAL")

    for i, entry in ipairs(Path) do
        print(i, entry)
    end

    print('Length of Path', #Path)

    if isOverride then
        ssv_PedList[SID].OverridePathfindingData['Path'] = Path
        ssv_PedList[SID].OverridePathfindingData['CurrentNode'] = #Path-1
    else
        ssv_PedList[SID].CurrPathfindingData['Path'] = Path
        ssv_PedList[SID].CurrPathfindingData['CurrentNode'] = #Path-1
    end
    
    TriggerEvent('ssv:nat:res:TaskVehicleDriveToCoord:Continue')
end)

AddEventHandler('ssv:nat:res:TaskVehicleDriveToCoord:Continue', function(SID, ObjectiveData, PathfindingData, isOverride)  

    if not PathfindingData or not PathfindingData['Path'] then
        return
    end

    local posx = ssv_PedList[SID].x
    local posy = ssv_PedList[SID].y
    local posz = ssv_PedList[SID].z

    local nxttarx = 0
    local nxttary = 0
    local nxttarz = 0
    local speed = ObjectiveData.speed

    if PathfindingData['Path'][PathfindingData['CurrentNode']] == "STARTHELPER" then
        nxttarx = PathfindingData['STARTHELPER'][1]
        nxttary = PathfindingData['STARTHELPER'][2]
        nxttarz = PathfindingData['STARTHELPER'][3]
    elseif PathfindingData['Path'][PathfindingData['CurrentNode']] == "ENDHELPER" then
        nxttarx = PathfindingData['ENDHELPER'][1]
        nxttary = PathfindingData['ENDHELPER'][2]
        nxttarz = PathfindingData['ENDHELPER'][3]
    elseif PathfindingData['Path'][PathfindingData['CurrentNode']] == "GOAL" then
        nxttarx = ObjectiveData.x
        nxttary = ObjectiveData.y
        nxttarz = ObjectiveData.z
    else
        nxttarx = ListNodes[PathfindingData['Path'][PathfindingData['CurrentNode']]].x
        nxttary = ListNodes[PathfindingData['Path'][PathfindingData['CurrentNode']]].y
        nxttarz = ListNodes[PathfindingData['Path'][PathfindingData['CurrentNode']]].z
    end

    if speed == -1 or speed == -2 then      
        local speedingvalue = 2.0

        if PathfindingData['Path'][PathfindingData['CurrentNode']] == "STARTHELPER" then
            speed = 30.0
        elseif PathfindingData['Path'][PathfindingData['CurrentNode']] == "ENDHELPER" then
            speed = 30.0
        elseif PathfindingData['Path'][PathfindingData['CurrentNode']] == "GOAL" then
            speed = 30.0
        elseif not PathfindingData['Path'][PathfindingData['CurrentNode']+1] or PathfindingData['Path'][PathfindingData['CurrentNode']+1] == "START" then
            speed = 30.0
        else
            local OldNode = PathfindingData['Path'][PathfindingData['CurrentNode']+1]
            for i, path in ipairs(ListNodes[OldNode].paths) do
                if path[1] == PathfindingData['Path'][PathfindingData['CurrentNode']] then
                    speed = path[2]
                    speedingvalue = path[3]
                    break
                end
            end
            speed = 25.0
        end
        
        if speed == -2 then
            speed = speed * speedingvalue
        end
        if speed == 25.0 or speed == 50.0 then
            print('Invalid speed detected for values:')
            print('CurrentNode', PathfindingData['Path'][PathfindingData['CurrentNode']])
            print('OldNode', PathfindingData['Path'][PathfindingData['CurrentNode']+1])
            print('CurrPos', posx, posy, posz)
            print('CurrTarget', nxttarx, nxttary, nxttarz)
        end
    end

    speed = ssh_mphTomps(speed)

    local currdistance = ssh_VectorDistance(posx, posy, posz, nxttarx, nxttary, nxttarz)
    local distancecheckbool = false

    if currdistance < 2*speed then
        distancecheckbool = true
        if currdistance < speed then
            return
        end
    end
  
    --[[print("Driving to next coordinate: ")
    print(PathfindingData['Path'][PathfindingData['CurrentNode'] ])
    print(nxttarx)
    print(nxttary)
    print(nxttarz)
    print('---')]]

    local heading = ssh_getGameHeadingFromPoints(posx, posy, nxttarx, nxttary)
    ssv_PedList[SID].heading = heading
    ssv_VehList[ObjectiveData.VehSID].heading = heading

    local nx, ny, nz = ssh_getNormalisedVector(posx, posy, posz, nxttarx, nxttary, nxttarz)
      
    local newposx = posx + speed*nx/2
    local newposy = posy + speed*ny/2
    local newposz = posz + speed*nz/2
    
    ssv_PedList[SID].x = newposx
    ssv_PedList[SID].y = newposy
    ssv_PedList[SID].z = newposz

    ssv_VehList[ObjectiveData.VehSID].x = newposx
    ssv_VehList[ObjectiveData.VehSID].y = newposy
    ssv_VehList[ObjectiveData.VehSID].z = newposz

    if isOverride then
      ssv_PedList[SID].OverridePathfindingData['nx'] = nx
      ssv_PedList[SID].OverridePathfindingData['ny'] = ny
      ssv_PedList[SID].OverridePathfindingData['nz'] = nz
    else
      ssv_PedList[SID].CurrPathfindingData['nx'] = nx
      ssv_PedList[SID].CurrPathfindingData['ny'] = ny
      ssv_PedList[SID].CurrPathfindingData['nz'] = nz
    end

    -- update Ped AND vehicle position
    -- check for passengers and update their position too!

    if distancecheckbool then
        ssv_PedList[SID].CurrPathfindingData['CurrentNode'] = ssv_PedList[SID].CurrPathfindingData['CurrentNode']-1
    end
end)
