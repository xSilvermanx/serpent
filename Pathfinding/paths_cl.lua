local PathThreads = {}

RegisterNetEvent('scl:CreatePathBetweenTwoPointsForServer')
AddEventHandler('scl:CreatePathBetweenTwoPointsForServer', function(SID, i, Startposition, Endposition, AName, Ax, Ay, Az, BName, Bx, By, Bz, Task, isOverride)
    
    table.insert(PathThreads, 1)
    local tCount = #PathThreads
    local tCountNow = tCount

    while tCount > 1 and tCountNow > tCount-1 do
        tCountNow = #PathThreads
        Wait(10)
    end

    local Ablip = AddBlipForCoord(Ax, Ay, Az)
    SetBlipRoute(Ablip, true)
    SetNewWaypoint(Bx, By)
    

    --[[local startzone = GetZoneAtCoords(Ax, Ay, Az)
    local startzonename = GetNameOfZone(Ax, Ay, Az)
    print(startzone, startzonename)

    local endzone = GetZoneAtCoords(Bx, By, Bz)
    local endzonename = GetNameOfZone(Bx, By, Bz)
    print(endzone, endzonename)

    SetZoneEnabled(startzone, true)
    SetZoneEnabled(endzone, true)

    local centerx = (Bx + Ax)/2
    local centery = (Ay + By)/2
    local radius = math.abs(Bx-Ax)
    if math.abs(By-Ay) > radius then
        radius = math.abs(By-Ay)
    end

    AddNavmeshRequiredRegion(centerx, centery, radius)

    ClearGpsMultiRoute()
    StartGpsMultiRoute(6, false, true)
    AddPointToGpsMultiRoute(Startposition.x, Startposition.y, Startposition.z)
    AddPointToGpsMultiRoute(Ax, Ay, Az)
    AddPointToGpsMultiRoute(Bx, By, Bz)
    AddPointToGpsMultiRoute(Endposition.x, Endposition.y, Endposition.z)
    SetGpsMultiRouteRender(true)

    local _ = RequestPathsPreferAccurateBoundingstruct(Ax, Ay, Bx, By)

    local _, _, _, _ = GenerateDirectionsToCoord(Startposition.x, Startposition.y, Startposition.z, 0)
    local _, _, _, _ = GenerateDirectionsToCoord(Ax, Ay, Az, 0)
    local _, _, _, _ = GenerateDirectionsToCoord(Bx, By, Bz, 0)
    local _, _, _, _ = GenerateDirectionsToCoord(Endposition.x, Endposition.y, Endposition.z, 0)
    
    local retval = false
    retval = AreNodesLoadedForArea(Ax, Ay, Bx, By)
    local k = 0
    print('Requested', retval)
    --[[while not retval do
        print('Waiting for return')
        k = k + 1
        Wait(10)
        if k > 100 then
            print('Aborted')
        end
    end]]

    print('Triggered:')
    print('SID', SID)
    print('i', i)
    print('Task', Task)
    
    print('Given start position', Startposition.x, Startposition.y, Startposition.z)
    local _, startpositiontemp, starth = GetClosestVehicleNodeWithHeading(Startposition.x, Startposition.y, Startposition.z, 1, 3.0, 0)
    local startposition = {x = startpositiontemp.x, y = startpositiontemp.y, z = startpositiontemp.z, heading = starth}
    print('Movement start', startposition.x, startposition.y, startposition.z)

    print('Given end position', Endposition.x, Endposition.y, Endposition.z)
    local _, endpositiontemp, endh = GetClosestVehicleNodeWithHeading(Endposition.x, Endposition.y, Endposition.z, 1, 3.0, 0)
    local endposition = {x = endpositiontemp.x, y = endpositiontemp.y, z = endpositiontemp.z, heading = endh}
    print('Movement end', endposition.x, endposition.y, endposition.z)

    print('End', BName)
    print('End Coordinates', Bx, By, Bz)
    local _, EndPosition, _ = GetClosestVehicleNodeWithHeading(Bx, By, Bz, 1, 3.0, 0)
    local _, MainEndPosition, _ = GetClosestVehicleNodeWithHeading(Bx, By, Bz, 0, 3.0, 0)
    print('End Node', EndPosition.x, EndPosition.y, EndPosition.z)
    print('Main End Node', MainEndPosition.x, MainEndPosition.y, MainEndPosition.z)

    local ListOfReturnNodes = {}
    print('Start', AName)
    print('Start Coordinates', Ax, Ay, Az)
    local _, position, heading = GetClosestVehicleNodeWithHeading(Ax, Ay, Az, 1, 3.0, 0)
    local _, MainPosition, _ = GetClosestVehicleNodeWithHeading(Ax, Ay, Az, 0, 3.0, 0)
    local NewNode = {}
    print('Start Node', position.x, position.y, position.z)
    print('Main Start Node', MainPosition.x, MainPosition.y, MainPosition.z)


    local steps = 20
    local nodeType = 1
    if EndPosition == MainEndPosition and position == MainPosition then
        steps = 40
        nodeType = 0
        print('Task is on main roads')
    else
        print('Task is not on main roads')
    end
    print('---')


    table.insert(ListOfReturnNodes, {x = position.x, y = position.y, z = position.z, heading = heading})
    
    local x = position.x
    local y = position.y
    local z = position.z
    local m = 0
    local breakcounter = 0
    local StartNodeAlreadyAddedBool = false
    local EndNodeAlreadyAddedBool = false
    print('First distance calculation values', x, y, z)
    if ssh_VectorDistance(x, y, z, startposition.x, startposition.y, startposition.z) < 0.1 then
        print('Startnode was found')
        StartNodeAlreadyAddedBool = true
    end
    if ssh_VectorDistance(EndPosition.x, EndPosition.y, EndPosition.z, endposition.x, endposition.y, endposition.z) < 0.1 then
        print('Endnode was found')
        EndNodeAlreadyAddedBool = true
    end
    distance = ssh_VectorDistance(x, y, z, EndPosition.x, EndPosition.y, EndPosition.z)
    print('First distance', distance)
    print('---')
    while distance > 1.0 do
        m = m + 1
        print('While loop iteration', m)
        local newx = 0
        local newy = 0
        local newz = 0
        local h = 0
        local newdistance = 999999.9
        local NewNodeFound = false
        local NodeAlreadyAddedBool = false
        for n = 1, steps do
            print('for-loop iteration', n)
            local _, newpos, newhead = GetNthClosestVehicleNodeWithHeading(x, y, z, n, nodeType, 3.0, 2.5)
            print('Found position', newpos.x, newpos.y, newpos.z)
            newdistance = ssh_VectorDistance(newpos.x, newpos.y, newpos.z, EndPosition.x, EndPosition.y, EndPosition.z)
            print('Distance to End Node', newdistance)
            if newdistance < distance then
                NewNodeFound = true
                print('Adding the node')
                NodeAlreadyAddedBool = false
                newx = newpos.x
                newy = newpos.y
                newz = newpos.z
                h = newhead
                distance = newdistance
            end
            if not StartNodeAlreadyAddedBool and ssh_VectorDistance(newpos.x, newpos.y, newpos.z, startposition.x, startposition.y, startposition.z) < 20.0 then
                print('Found Start node')
                StartNodeAlreadyAddedBool = true
                table.insert(ListOfReturnNodes, startposition)
                NodeAlreadyAddedBool = true
            end
            if not EndNodeAlreadyAddedBool and ssh_VectorDistance(newpos.x, newpos.y, newpos.z, endposition.x, endposition.y, endposition.z) < 20.0 then
                print('Found End Node')
                EndNodeAlreadyAddedBool = true
                table.insert(ListOfReturnNodes, endposition)
                NodeAlreadyAddedBool = true
            end
            print('---')
        end
        
        print('Finished for-loop')
        if NewNodeFound then
            breakcounter = 0
            x = newx
            y = newy
            z = newz
        else
            breakcounter = breakcounter + 1
        end
        print('Final node position', x, y, z)

        if not NodeAlreadyAddedBool then
            print('Added node to list')
            table.insert(ListOfReturnNodes, {x = newx, y = newy, z = newz, heading = h})
        end
        
        distance = ssh_VectorDistance(x, y, z, EndPosition.x, EndPosition.y, EndPosition.z)
        print('New distance check', distance)
        print('---------')
        if breakcounter > 10 then
            print('Breakcounter triggered')
            print('SID, Pathfinding-part, while-iteration', SID, i, m)
            print('Startposition')
            print(startposition.x, startposition.y, startposition.z)
            print('Endposition')
            print(endposition.x, endposition.y, endposition.z)
            break
        end
        Wait(0)
    end
    
    print('Results:')
    print(i)
    for n, node in ipairs(ListOfReturnNodes) do
        print(n, node.x, node.y, node.z, node.heading)
        local blip = AddBlipForCoord(node.x, node.y, node.z)
        local blipname = i .. "-" .. n
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipname)
        EndTextCommandSetBlipName(blip)
        SetBlipColour(blip, i)
    end
    print('---')

    TriggerServerEvent('ssv:RecievePathBetweenTwoPoints', SID, Task, i, ListOfReturnNodes, isOverride)

    --[[SetZoneEnabled(startzone, false)
    SetZoneEnabled(endzone, false)]]

    table.remove(PathThreads)
end)