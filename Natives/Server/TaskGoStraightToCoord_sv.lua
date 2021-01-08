AddEventHandler('ssv:nat:res:TaskGoStraightToCoord:Init', function(SID, tarx, tary, tarz, speed, timeout, targetHeading, distanceToSlide, isOverride)
  ssv_PedList[SID].heading = targetHeading
  local posx = ssv_PedList[SID].x
  local posy = ssv_PedList[SID].y
  local posz = ssv_PedList[SID].z

  local nx, ny, nz = ssh_getNormalisedVector(posx, posy, posz, tarx, tary, tarz)

  ssv_PedList[SID].x = posx + nx/2
  ssv_PedList[SID].y = posy + ny/2
  ssv_PedList[SID].z = posz + nz/2

  if isOverride then
    ssv_PedList[SID].OverridePathfindingData['nx'] = nx
    ssv_PedList[SID].OverridePathfindingData['ny'] = ny
    ssv_PedList[SID].OverridePathfindingData['nz'] = nz
  else
    ssv_PedList[SID].CurrPathfindingData['nx'] = nx
    ssv_PedList[SID].CurrPathfindingData['ny'] = ny
    ssv_PedList[SID].CurrPathfindingData['nz'] = nz
  end
end)

AddEventHandler('ssv:nat:res:TaskGoStraightToCoord:Continue', function(SID, x, y, z, speed, timeout, targetHeading, distanceToSlide, isOverride)

  local posx = ssv_PedList[SID].x
  local posy = ssv_PedList[SID].y
  local posz = ssv_PedList[SID].z

  local nx = 1
  local ny = 0
  local nz = 0

  if isOverride then
    nx = ssv_PedList[SID].OverridePathfindingData['nx']
    ny = ssv_PedList[SID].OverridePathfindingData['ny']
    nz = ssv_PedList[SID].OverridePathfindingData['nz']
  else
    nx = ssv_PedList[SID].CurrPathfindingData['nx']
    ny = ssv_PedList[SID].CurrPathfindingData['ny']
    nz = ssv_PedList[SID].CurrPathfindingData['nz']
  end

  ssv_PedList[SID].x = posx + nx/2
  ssv_PedList[SID].y = posy + ny/2
  ssv_PedList[SID].z = posz + nz/2

end)
