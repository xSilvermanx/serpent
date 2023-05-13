function scl_SpawnVeh(vehid, vehdata)
    
    scl_VehList[vehid] = vehdata

    local x = vehdata.x
    local y = vehdata.y
    local z = vehdata.z

    local retval, Pos = GetClosestVehicleNode(x, y, z, 1, 3.0, 0) -- include heading when spawning the vehicle so that it always faced the right direction
    
    if not retval then -- temp fix attempt
        Pos = {x = x, y = y, z = z}
    end
    
    --make sure that selected coordinates are free for entity to spawn
  
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
      
    if peddata.ModelHash == FreemodeHashM or peddata.ModelHash == FreemodeHashF then
        -- code inheritance, facefeatures and appearance. Copy most from 'Charspawner' script
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