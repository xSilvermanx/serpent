AddEventHandler('AddNodeForBlip', function(name, x, y, z)
    local blip = AddBlipForCoord(x, y, z)
    local zone = GetNameOfZone(x, y, z)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(zone)
    EndTextCommandSetBlipName(blip)
end)

function getCurrentCount(zone)
    local count = 1

    for name, entry in pairs(ListNodes) do
        if string.find(name, zone) then
            count = count + 1
        end
    end

    return count
end

RegisterCommand('CreateNode', function(source, args)
    local coords = GetEntityCoords(PlayerPedId())
    local zone = GetNameOfZone(coords)
    local number = getCurrentCount(zone)
    local name = zone .. "-" .. number
    Notify('Creating Node ' .. name .. ' at ' .. coords.x .. ", " .. coords.y .. ", " .. coords.z .. ".")
    local infotable = {
        x=coords.x,
        y=coords.y,
        z=coords.z,
        paths = {
            {},
        },
    }
    ListNodes[name] = infotable
    TriggerEvent('AddNodeForBlip', name, coords.x, coords.y, coords.z)
    TriggerServerEvent('AddNode', name, coords)
end)

RegisterKeyMapping('CreateNode', 'Create Node', 'Keyboard', 'e')

CreateThread(function()
    while true do
        Wait(0)
        SetPedDensityMultiplierThisFrame(0.0)
        SetVehicleDensityMultiplierThisFrame(0.0)
    end
end)

CreateThread(function()
    print('Starting')
    local path = AStar("PALETO-2", "DOWNT-14")
    
    for i, entry in ipairs(path) do
      print(i, entry)
      local data = ssh_nat_GetNodeData(entry)
      TriggerEvent('AddNodeForBlip', entry, data.x, data.y, data.z)
    end
    print('Length of Path', #path)
end)

local list_show_nodes = {}
CreateThread(function()
    local range = 200000.0
    while true do
        local playerped = GetPlayerPed(-1)
        local plc = GetEntityCoords(playerped, true)
        list_show_nodes = {}
        for name, coord in pairs(ListNodes) do
            if Vdist2(plc.x, plc.y, plc.z, coord.x, coord.y, coord.z) < range then
                local pathdata = {}
                for i, line in ipairs(coord.paths) do
                    if line[1] then
                        newx = ListNodes[line[1]].x
                        newy = ListNodes[line[1]].y
                        newz = ListNodes[line[1]].z
                        heading = ssh_getGameHeadingFromPoints(coord.x, coord.y, newx, newy)
                        c0x, c0y, c0z = ssh_OffsetPosition(coord.x, coord.y, coord.z, heading, 0.5, 0.0, 0.0)
                        c1x, c1y, c1z = ssh_OffsetPosition(newx, newy, newz, heading, 0.5, 0.0, 0.0)
                        local onepathdata = {c0x, c0y, c0z, c1x, c1y, c1z}
                        table.insert(pathdata, onepathdata)
                    end
                end
                local nodedata = {name, coord.x, coord.y, coord.z, pathdata}
                table.insert(list_show_nodes, nodedata)
            end
        end
        Wait(5000)
    end
end)

CreateThread(function()
    while true do
        local p = GetGameplayCamCoords()
        for i, coord in ipairs(list_show_nodes) do
            DrawMarker(0, coord[2], coord[3], coord[4]+0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 255, false, false, 2, false, nil, nil, false)
            local onScreen, textx, texty = GetScreenCoordFromWorldCoord(coord[2], coord[3], coord[4] + 1.0)
            if onScreen then
                local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, coord[2], coord[3], coord[4], 1)
                local scale = (1 / distance) * (2)
                local fov = (1 / GetGameplayCamFov()) * 75
                scale = scale * fov * (2)
                SetTextScale(0.0, scale)
                SetTextColour(0, 255, 255, 255)
                SetTextOutline()
                SetTextEntry("STRING")
                SetTextCentre(true)
                AddTextComponentString(coord[1])
                DrawText(textx, texty)
            end
            for j, entry in ipairs(coord[5]) do
                DrawLine(entry[1], entry[2], entry[3], entry[4], entry[5], entry[6], 255, 0, 0, 255)
            end
        end
        Wait(0)
    end
end)