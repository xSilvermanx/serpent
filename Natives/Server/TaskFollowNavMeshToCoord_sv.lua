AddEventHandler('ssv:nat:res:TaskFollowNavMeshToCoord:Init', function(SID, x, y, z, speed, timeout, stoppingRange, persistFollowing, PathfindingData, isOverride)
  local posx = ssv_PedList[SID].x
  local posy = ssv_PedList[SID].y
  local posz = ssv_PedList[SID].z

  local tarx, tary, tarz = nil

  if PathfindingData.CurrEnd == 'EndPos' then
    tarx = PathfindingData.orx
    tary = PathfindingData.ory
    tarz = PathfindingData.orz
  else
    tarx = PathfindingData.CurrEndData.x
    tary = PathfindingData.CurrEndData.y
    tarz = PathfindingData.CurrEndData.z
  end

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

end)

AddEventHandler('ssv:nat:res:TaskFollowNavMeshToCoord:Continue', function(SID, x, y, z, speed, timeout, stoppingRange, persistFollowing, PathfindingData, isOverride)
  local posx = ssv_PedList[SID].x
  local posy = ssv_PedList[SID].y
  local posz = ssv_PedList[SID].z
  local recreateNormalVector = false

  if nx == nil then
    recreateNormalVector = true
  end

  local nx = 1
  local ny = 0
  local nz = 0



  if recreateNormalVector then
    local tarx, tary, tarz = nil
    recreateNormalVector = true

    if PathfindingData.CurrEnd == 'EndPos' then
      tarx = PathfindingData.orx
      tary = PathfindingData.ory
      tarz = PathfindingData.orz
    else
      tarx = PathfindingData.CurrEndData.x
      tary = PathfindingData.CurrEndData.y
      tarz = PathfindingData.CurrEndData.z
    end

    ssv_PedList[SID].heading = ssh_getGameHeadingFromPoints(posx, posy, tarx, tary)

    nx, ny, nz = ssh_getNormalisedVector(posx, posy, posz, tarx, tary, tarz)
  else
    if isOverride then
      nx = ssv_PedList[SID].OverridePathfindingData['nx']
      ny = ssv_PedList[SID].OverridePathfindingData['ny']
      nz = ssv_PedList[SID].OverridePathfindingData['nz']
    else
      nx = ssv_PedList[SID].CurrPathfindingData['nx']
      ny = ssv_PedList[SID].CurrPathfindingData['ny']
      nz = ssv_PedList[SID].CurrPathfindingData['nz']
    end
  end

  ssv_PedList[SID].x = posx + speed*nx/2
  ssv_PedList[SID].y = posy + speed*ny/2
  ssv_PedList[SID].z = posz + speed*nz/2

  if recreateNormalVector then
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
