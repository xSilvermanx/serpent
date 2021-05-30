-- WHEN UNCOMMENTING THIS, BE SURE TO CHANGE FXMANIFEST TO INCLUDE nodes_sv.lua CLIENTSIDE! THIS IS NOT DONE TO PRESERVE PERFORMANCE IN NORMAL GAMEPLAY!

--[[local list_show_Markers = {}
local list_show_lines = {}

CreateThread(function()
  local range = 40000.0

  while true do
    list_show_Markers = {}
    local playerped = GetPlayerPed(-1)
    local plc = GetEntityCoords(playerped, true)
    for name, marker in pairs(ListNodes) do
      if Vdist2(marker.x, marker.y, marker.z, plc.x, plc.y, plc.z) < range then
        table.insert(list_show_Markers, marker)
        for j, path in ipairs(marker.paths) do
          local Line = {}
          local dist = 0.3
          local sr = 255
          local sg = 255
          local sb = 255
          if path.NoVeh then
            sg = 0
          end
          if path.AbsNoVeh then
            sb = 0
          end
          if path.NoPed then
            sr = 0
          end
          Line["r"] = sr
          Line["g"] = sg
          Line["b"] = sb
          local angle = ssh_getGameHeadingFromPoints(marker.x, marker.y, ListNodes[path.id].x, ListNodes[path.id].y) - 90.0

          ssx = marker.x + dist * math.cos(angle)
          ssy = marker.y - dist * math.sin(angle)
          sfx = ListNodes[path.id].x + dist * math.cos(angle)
          sfy = ListNodes[path.id].y - dist * math.sin(angle)

          Line["sx"] = ssx
          Line["sy"] = ssy
          Line["sz"] = marker.z
          Line["fx"] = sfx
          Line["fy"] = sfy
          Line["fz"] = ListNodes[path.id].z

          table.insert(list_show_lines, Line)
        end
      end
    end
    Wait(2000)
  end
end)

CreateThread(function()
  while true do
    for i, marker in ipairs(list_show_Markers) do
      DrawMarker(0, marker.x, marker.y, marker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 255, false, false, 2, false, nil, nil, false)
      local onScreen, _x, _y = GetScreenCoordFromWorldCoord(marker.x, marker.y, marker.z + 1.0)
			local px,py,pz = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
      local dist = GetDistanceBetweenCoords(px,py,pz, marker.x, marker.y, marker.z + 1.0, 1)
			local scale = ((1/math.sqrt(dist))*2)*(1/GetGameplayCamFov())*100
      if onScreen then
        SetTextScale(0.0*scale, 0.3*scale)
        SetTextProportional(1)
        SetTextCentre(true)

        BeginTextCommandDisplayText("STRING")
        AddTextComponentString(marker.id)
        EndTextCommandDisplayText(_x, _y)
      end
    end
    for j, line in ipairs(list_show_lines) do
      DrawLine(line.sx, line.sy, line.sz, line.fx, line.fy, line.fz, line.r, line.g, line.b, 255)
    end
    Wait(0)
  end
end)]]
