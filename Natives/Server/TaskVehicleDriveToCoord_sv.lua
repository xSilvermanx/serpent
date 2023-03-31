AddEventHandler('ssv:nat:res:TaskVehicleDriveToCoord:Init', function(SID, ObjectiveData, PathfindingData, isOverride)
    print('I have started')
    local VehSID = ssv_PedList[SID].VehSID
    local vehx = ssv_VehList[VehSID].x
    local vehy = ssv_VehList[VehSID].y
    local vehz = ssv_VehList[VehSID].z
    local startposition = {x = vehx, y = vehy, z = vehz}
    local tarx = ObjectiveData.x
    local tary = ObjectiveData.y
    local tarz = ObjectiveData.z
    local endposition = {x = tarx, y = tary, z = tarz}
    local _, startid = ssv_nat_GetClosestNodeId(vehx, vehy, vehz)
    local _, endid = ssv_nat_GetClosestNodeId(tarx, tary, tarz)

    print(startid)
    print(endid)
    local Path = AStar(startid, endid)

    print('AStar finished')
    table.insert(Path, "START")
    table.insert(Path, 1, "GOAL")

    if isOverride then
        ssv_PedList[SID].OverridePathfindingData['Path'] = Path
        ssv_PedList[SID].OverridePathfindingData['CurrentNode'] = 1
        ssv_PedList[SID].OverridePathfindingData['NoLoopsSinceInit'] = 0
    else
        ssv_PedList[SID].CurrPathfindingData['Path'] = Path
        ssv_PedList[SID].CurrPathfindingData['CurrentNode'] = 1
        ssv_PedList[SID].CurrPathfindingData['NoLoopsSinceInit'] = 0
    end

    local playercount = 0
    local playerids = {}
    for i, player in pairs(ssv_PlayerList) do
        playercount = playercount + 1
        table.insert(playerids, i)
    end

    local PrecisePathMeta = {} -- per entry: Boolean: Has Precise Path been sent?
    local PrecisePath = {} -- per entry: The data sent from the client or FALSE, if not data could be sent

    if playercount > 0 then
        if isOverride then
            ssv_PedList[SID].OverridePathfindingData['PrecisePathBool'] = true
        else
            ssv_PedList[SID].CurrPathfindingData['PrecisePathBool'] = true
        end
        for i=1, #Path, 1 do
            PrecisePath[i] = {}
            PrecisePathMeta[i] = false
        end
        if isOverride then
            ssv_PedList[SID].OverridePathfindingData['PrecisePathMeta'] = PrecisePathMeta
            ssv_PedList[SID].OverridePathfindingData['PrecisePath'] = PrecisePath
        else
            ssv_PedList[SID].CurrPathfindingData['PrecisePathMeta'] = PrecisePathMeta
            ssv_PedList[SID].CurrPathfindingData['PrecisePath'] = PrecisePath
        end
        for i=#Path, 2, -1 do
            if Path[i] == "START" then
                local client = playerids[math.random(#playerids)]
                TriggerClientEvent('scl:CreatePathBetweenTwoPointsForServer', client, SID, i, startposition, endposition, "START", vehx, vehy, vehz, Path[i-1], ListNodes[Path[i-1]].x, ListNodes[Path[i-1]].y, ListNodes[Path[i-1]].z, 'TaskVehicleDriveToCoord', isOverride)
            elseif Path[i-1] == "GOAL" then
                local client = playerids[math.random(#playerids)]
                TriggerClientEvent('scl:CreatePathBetweenTwoPointsForServer', client, SID, i, startposition, endposition, Path[i], ListNodes[Path[i]].x, ListNodes[Path[i]].y, ListNodes[Path[i]].z, Path[i-1], tarx, tary, tarz, 'TaskVehicleDriveToCoord', isOverride)
            else
                local client = playerids[math.random(#playerids)]
                TriggerClientEvent('scl:CreatePathBetweenTwoPointsForServer', client, SID, i, startposition, endposition, Path[i], ListNodes[Path[i]].x, ListNodes[Path[i]].y, ListNodes[Path[i]].z, Path[i-1], ListNodes[Path[i-1]].x, ListNodes[Path[i-1]].y, ListNodes[Path[i-1]].z, 'TaskVehicleDriveToCoord', isOverride)
            end
        end
    else
        if isOverride then
            ssv_PedList[SID].OverridePathfindingData['PrecisePathBool'] = false
        else
            ssv_PedList[SID].CurrPathfindingData['PrecisePathBool'] = false
        end
    end

end)

AddEventHandler('ssv:nat:res:TaskVehicleDriveToCoord:Continue', function(SID, ObjectiveData, PathfindingData, isOverride)
    if isOverride then
        -- if Pathfinding Data exists on the server then
            -- move-function
        -- else
            -- max 3 tries, else reinit
        -- end
    else
        if ssv_PedList[SID].CurrPathfindingData['PrecisePathBool'] then
            local AllDataExists = true
            for i=2, #(ssv_PedList[SID].CurrPathfindingData['PrecisePathMeta']) do
                --print(i)
                --print(ssv_PedList[SID].CurrPathfindingData['PrecisePathMeta'][i])
                for key, value in ipairs(ssv_PedList[SID].CurrPathfindingData['PrecisePath'][i]) do
                    --print(value.x, value.y, value.z, value.heading)
                end
                if not ssv_PedList[SID].CurrPathfindingData['PrecisePathMeta'][i] then
                    AllDataExists = false
                    break
                end
            end
            if AllDataExists then
                print("Yey")
            else
                print("Ohh")
            end
        else
            --very rough approximation, if no players are on the server
        end
    end
end)