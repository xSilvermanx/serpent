function scl_SpawnVeh(vehid, vehdata)
    
    scl_VehList[vehid] = vehdata

    local x = vehdata.x
    local y = vehdata.y
    local z = vehdata.z
    local Pos = {x = x, y = y, z = z}

    if not scl_VehList[vehid].UseExactSpawnCoordinates then
        local retval, Pos1 = GetClosestVehicleNode(x, y, z, 1, 3.0, 0)
        Pos = Pos1

        if not retval then
            Pos = {x = x, y = y, z = z}
        else
            local x1, y1, z1 = ssh_OffsetPosition(Pos.x, Pos.y, Pos.z, vehdata.heading, 3, 0, 0)
            Pos = {x = x1, y = y1, z = z1}

            local rayHandle = StartShapeTestRay(Pos.x, Pos.y, Pos.z+5.0, Pos.x, Pos.y, Pos.z-5.0, 30, 0, 0)
            local _, hit, _, _, _ = GetShapeTestResult(rayHandle)

            if hit == 1 then
                Pos = {x = Pos1.x, y = Pos1.y, z = Pos1.z}
                local rayHandle = StartShapeTestRay(Pos.x, Pos.y, Pos.z+5.0, Pos.x, Pos.y, Pos.z-5.0, 30, 0, 0)
                local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)
                if hit == 1 then
                    Pos = {x = x, y = y, z = z}
                end
            end
        end
    end
    
    RequestModel(vehdata.ModelHash)
  
    while not HasModelLoaded(vehdata.ModelHash) do
      RequestModel(vehdata.ModelHash)
      Wait(50)
    end
    
    local veh = CreateVehicle(vehdata.ModelHash, Pos.x, Pos.y, Pos.z, vehdata.heading, true, false)    
    local VehNetID = VehToNet(veh)

    scl_VehList[vehid].VehNetID = VehNetID
    TriggerServerEvent('ssv:RecieveVehData', vehid, '', 'VehNetID', VehNetID)

    return true
end

function scl_SpawnPed(pedid, peddata, seatindex)
    local PedNetID = 0
    scl_PedList[pedid] = peddata
    
    if peddata.IsInVeh then
        local VehNetID = scl_VehList[peddata.VehSID].VehNetID
        local veh = NetToVeh(VehNetID)
        local seat = seatindex

        if seatindex == -2 then
            for i, passenger in pairs(scl_VehList[peddata.VehSID].Passengers) do
                if passenger == pedid then
                    seat = i
                    break
                end
            end
        end

        RequestModel(peddata.ModelHash)
      
        while not HasModelLoaded(peddata.ModelHash) do
          RequestModel(peddata.ModelHash)
          Wait(50)
        end
      
        local ped = CreatePedInsideVehicle(veh, peddata.PedType, peddata.ModelHash, seat, true, true)
        PedNetID = PedToNet(ped)
    else
        local x = peddata.x
        local y = peddata.y
        local z = peddata.z

        if peddata.OverrideObjective ~= 'none' then
            isOverride = true
        end

        if not scl_PedList[pedid].UseExactSpawnCoordinates then
            local retval, r = GetSafeCoordForPed(peddata.x, peddata.y, peddata.z, false, 16)
            local rx, ry, rz = table.unpack(r)
            if retval and ssh_VectorDistance(x, y, z, rx, ry, rz) < 22.0 then
                x = rx
                y = ry
                z = rz
            else
                retval, r = GetPointOnRoadSide(peddata.x, peddata.y, peddata.z, 0)
                if retval and ssh_VectorDistance(x, y, z, rx, ry, rz) < 22.0 then
                x = rx
                y = ry
                z = rz
                end
            end
        end

        --make sure that selected coordinates are free for entity to spawn

        RequestModel(peddata.ModelHash)

        while not HasModelLoaded(peddata.ModelHash) do
            RequestModel(peddata.ModelHash)
            Wait(50)
        end

        local ped = CreatePed(peddata.PedType, peddata.ModelHash, x, y, z-1.0, peddata.heading, true, false)
        PedNetID = PedToNet(ped)
    end

    scl_PedList[pedid].PedNetID = PedNetID
    TriggerServerEvent('ssv:RecievePedData', pedid, '', 'PedNetID', PedNetID)

    return true
end

function scl_ApplyAllPedProperties(pedid, peddata)
    scl_ApplyPedBehaviorFlags(pedid, peddata)
    local PedNetID = peddata.PedNetID
    local ped = NetToPed(PedNetID)

    SetEntityHealth(ped, peddata.PedHealth)
    SetPedArmour(ped, peddata.PedArmor)
      
    if (peddata.ModelHash == FreemodeHashM or peddata.ModelHash == FreemodeHashF) and not RandomLooks then
        -- code inheritance, facefeatures and appearance. Copy most from 'Charspawner' script
    end

    if RandomLooks then
        -- get all appearance data and save it to the list
        RandomLooks = false
    end

    -- code components and props. Copy most from 'Charspawner' script

    return true
end

function scl_ApplyAllVehProperties(vehid, vehdata)

    return true
end

function scl_ApplyPedBehaviorFlags(pedid, peddata)
    local PedNetID = peddata.PedNetID
    local ped = NetToPed(PedNetID)
    
    SetBlockingOfNonTemporaryEvents(ped, peddata.BlockNonTemporaryEvents)
    SetPedRelationshipGroupHash(ped, GetHashKey(peddata.PedRelationshipGroup))

    return true
end

function Notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, false)
end