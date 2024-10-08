AddEventHandler('ssv:nat:res:TaskEnterVehicle:Init', function(SID, VehSID, timeout, seatIndex, speed, flag, isOverride)
  local posx = ssv_PedList[SID].x
  local posy = ssv_PedList[SID].y
  local posz = ssv_PedList[SID].z

  local tarx = ssv_VehList[VehSID].x
  local tary = ssv_VehList[VehSID].y
  local tarz = ssv_VehList[VehSID].z

  local distance = ssh_VectorDistance(posx, posy, posz, tarx, tary, tarz)

  if flag == 3 or flag == 16 or distance < 2.0 then
    ssv_nat_SetPedIntoVehicle(SID, VehSID, seatIndex)
  else
    ssv_PedList[SID].heading = ssh_getGameHeadingFromPoints(posx, posy, tarx, tary)

    local nx, ny, nz = ssh_getNormalisedVector(posx, posy, posz, tarx, tary, tarz)

    ssv_PedList[SID].x = posx + speed*nx/2
    ssv_PedList[SID].y = posy + speed*ny/2
    ssv_PedList[SID].z = posz + speed*nz/2

    if isOverride then
      ssv_PedList[SID].OverridePathfindingData['nx'] = nx
      ssv_PedList[SID].OverridePathfindingData['ny'] = ny
      ssv_PedList[SID].OverridePathfindingData['nz'] = nz
    else
      ssv_PedList[SID].CurrPathfindingData['nx'] = nx
      ssv_PedList[SID].CurrPathfindingData['ny'] = ny
      ssv_PedList[SID].CurrPathfindingData['nz'] = nz
    end
  end
end)

AddEventHandler('ssv:nat:res:TaskEnterVehicle:Continue', function(SID, VehSID, timeout, seatIndex, speed, flag, isOverride)

  local posx = ssv_PedList[SID].x
  local posy = ssv_PedList[SID].y
  local posz = ssv_PedList[SID].z

  local tarx = ssv_VehList[VehSID].x
  local tary = ssv_VehList[VehSID].y
  local tarz = ssv_VehList[VehSID].z

  local distance = ssh_VectorDistance(posx, posy, posz, tarx, tary, tarz)

  if flag == 3 or flag == 16 or distance < 2.0 then
    ssv_nat_SetPedIntoVehicle(SID, VehSID, seatIndex)
  else
    -- subject to change: Build in a way to check whether the car moved.
    ssv_PedList[SID].heading = ssh_getGameHeadingFromPoints(posx, posy, tarx, tary)

    local nx, ny, nz = ssh_getNormalisedVector(posx, posy, posz, tarx, tary, tarz)

    ssv_PedList[SID].x = posx + speed*nx/2
    ssv_PedList[SID].y = posy + speed*ny/2
    ssv_PedList[SID].z = posz + speed*nz/2

    if isOverride then
      ssv_PedList[SID].OverridePathfindingData['nx'] = nx
      ssv_PedList[SID].OverridePathfindingData['ny'] = ny
      ssv_PedList[SID].OverridePathfindingData['nz'] = nz
    else
      ssv_PedList[SID].CurrPathfindingData['nx'] = nx
      ssv_PedList[SID].CurrPathfindingData['ny'] = ny
      ssv_PedList[SID].CurrPathfindingData['nz'] = nz
    end
  end
end)
