--[[local list_show_nodes = {}
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
                    if line[1] then]]
                        --newx = ListNodes[line[1]].x
                        --newy = ListNodes[line[1]].y
                        --newz = ListNodes[line[1]].z
                        --[[heading = ssh_getGameHeadingFromPoints(coord.x, coord.y, newx, newy)
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

--[[CreateThread(function()
  while true do
    for pedid, peddata in pairs(scl_PedList) do
      print('SID', peddata.PedSID)
      print('Pos', peddata.x, peddata.y, peddata.z)
      print('Heading', peddata.heading)
      print('Current Task', peddata.CurrObjective)
      print('---')
    end
    print('----------------')
    Wait(1000)
  end
end)]]
