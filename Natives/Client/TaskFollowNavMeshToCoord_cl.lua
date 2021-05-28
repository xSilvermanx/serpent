RegisterNetEvent('scl:nat:res:TaskFollowNavMeshToCoord:Init')
AddEventHandler('scl:nat:res:TaskFollowNavMeshToCoord:Init', function(SID, PedNetID, x, y, z, speed, timeout, stoppingRange, persistFollowing, PathfindingData, isOverride)
  if not persistFollowing then
    local ped = NetToPed(PedNetID)

    local retval, outposition = GetSafeCoordForPed(x, y, z, false, 16)
    if not retval then
      retval, outposition = GetPointOnRoadSide(x, y, z, 0)
      if not retval then
      elseif ssh_VectorDistance(x, y, z, table.unpack(outposition)) < 22.0 then
        x, y, z = table.unpack(outposition)
      end
    elseif ssh_VectorDistance(x, y, z, table.unpack(outposition)) < 22.0 then
      x, y, z = table.unpack(outposition)
    end

    if isOverride then
      scl_PedList[SID].OverrideObjectiveData.x = x
      scl_PedList[SID].OverrideObjectiveData.y = y
      scl_PedList[SID].OverrideObjectiveData.z = z
      TriggerServerEvent('ssv:RecievePedData', SID, 'OverrideObjectiveData', 'x', x)
      TriggerServerEvent('ssv:RecievePedData', SID, 'OverrideObjectiveData', 'y', y)
      TriggerServerEvent('ssv:RecievePedData', SID, 'OverrideObjectiveData', 'z', z)
    else
      scl_PedList[SID].CurrObjectiveData.y = y
      scl_PedList[SID].CurrObjectiveData.x = x
      scl_PedList[SID].CurrObjectiveData.z = z
      TriggerServerEvent('ssv:RecievePedData', SID, 'CurrObjectiveData', 'x', x)
      TriggerServerEvent('ssv:RecievePedData', SID, 'CurrObjectiveData', 'y', y)
      TriggerServerEvent('ssv:RecievePedData', SID, 'CurrObjectiveData', 'z', z)
    end

    TaskFollowNavMeshToCoord(ped, x, y, z, speed, timeout, stoppingRange, persistFollowing)
  else
    local ped = NetToPed(PedNetID)

    local nodex = x
    local nodey = y
    local nodez = z

    if PathfindingData.orx ~= nil then
      nodex = PathfindingData.orx
      nodey = PathfindingData.ory
      nodez = PathfindingData.orz
    elseif PathfindingData.CurrEnd == 'EndPos' then
      nodex = PathfindingData.CurrEndData.x
      nodey = PathfindingData.CurrEndData.y
      nodez = PathfindingData.CurrEndData.z
    elseif PathfindingData.CurrStart == 'none' then
      local retval, outposition = GetSafeCoordForPed(PathfindingData.CurrEndData.x, PathfindingData.CurrEndData.y, PathfindingData.CurrEndData.z, false, 16)
      if not retval then
        retval, outposition = GetPointOnRoadSide(PathfindingData.CurrEndData.x, PathfindingData.CurrEndData.y, PathfindingData.CurrEndData.z, 0)
        if not retval then
          nodex = PathfindingData.CurrEndData.x
          nodey = PathfindingData.CurrEndData.y
          nodez = PathfindingData.CurrEndData.z
        else
          nodex, nodey, nodez = table.unpack(outposition)
        end
      else
        nodex, nodey, nodez = table.unpack(outposition)
      end
    else
      for i, path in ipairs(PathfindingData.CurrStartData.paths) do
        if path.id == PathfindingData.CurrEnd then
          if path.IsActualPath == true then
            nodex = PathfindingData.CurrEndData.x
            nodey = PathfindingData.CurrEndData.y
            nodez = PathfindingData.CurrEndData.z
          else
            local retval, outposition = GetSafeCoordForPed(PathfindingData.CurrEndData.x, PathfindingData.CurrEndData.y, PathfindingData.CurrEndData.z, false, 16)
            if not retval then
              retval, outposition = GetPointOnRoadSide(PathfindingData.CurrEndData.x, PathfindingData.CurrEndData.y, PathfindingData.CurrEndData.z, 0)
              if not retval then
                nodex = PathfindingData.CurrEndData.x
                nodey = PathfindingData.CurrEndData.y
                nodez = PathfindingData.CurrEndData.z
              else
                nodex, nodey, nodez = table.unpack(outposition)
              end
            else
              nodex, nodey, nodez = table.unpack(outposition)
            end
          end
          break
        end
      end
    end

    PathfindingData.orx = nodex
    PathfindingData.ory = nodey
    PathfindingData.orz = nodez

    if isOverride then
      TriggerServerEvent('ssv:RecievePedData', SID, 'OverridePathfindingData', 'orx', orx)
      TriggerServerEvent('ssv:RecievePedData', SID, 'OverridePathfindingData', 'ory', ory)
      TriggerServerEvent('ssv:RecievePedData', SID, 'OverridePathfindingData', 'orz', orz)
    else
      TriggerServerEvent('ssv:RecievePedData', SID, 'CurrPathfindingData', 'orx', orx)
      TriggerServerEvent('ssv:RecievePedData', SID, 'CurrPathfindingData', 'ory', ory)
      TriggerServerEvent('ssv:RecievePedData', SID, 'CurrPathfindingData', 'orz', orz)
    end

    TaskFollowNavMeshToCoord(ped, nodex, nodey, nodez, speed, timeout, stoppingRange, persistFollowing)
  end

  if isOverride then
    scl_PedList[SID].OverrideObjectiveData.task = 'Continue'
    scl_PedList[SID].OverridePathfindingData = PathfindingData
  else
    scl_PedList[SID].CurrObjectiveData.task = 'Continue'
    scl_PedList[SID].CurrPathfindingData = PathfindingData
  end

end)

RegisterNetEvent('scl:nat:res:TaskFollowNavMeshToCoord:Continue')
AddEventHandler('scl:nat:res:TaskFollowNavMeshToCoord:Continue', function(SID, PedNetID, x, y, z, speed, timeout, stoppingRange, persistFollowing, PathfindingData, isOverride)
  if not persistFollowing then
    local ped = NetToPed(PedNetID)

    local retval, outposition = GetSafeCoordForPed(x, y, z, false, 16)
    if not retval then
      retval, outposition = GetPointOnRoadSide(x, y, z, 0)
      if not retval then
      elseif ssh_VectorDistance(x, y, z, table.unpack(outposition)) < 22.0 then
        x, y, z = table.unpack(outposition)
      end
    elseif ssh_VectorDistance(x, y, z, table.unpack(outposition)) < 22.0 then
      x, y, z = table.unpack(outposition)
    end

    if isOverride then
      scl_PedList[SID].OverrideObjectiveData.x = x
      scl_PedList[SID].OverrideObjectiveData.y = y
      scl_PedList[SID].OverrideObjectiveData.z = z
      TriggerServerEvent('ssv:RecievePedData', SID, 'OverrideObjectiveData', 'x', x)
      TriggerServerEvent('ssv:RecievePedData', SID, 'OverrideObjectiveData', 'y', y)
      TriggerServerEvent('ssv:RecievePedData', SID, 'OverrideObjectiveData', 'z', z)
    else
      scl_PedList[SID].CurrObjectiveData.y = y
      scl_PedList[SID].CurrObjectiveData.x = x
      scl_PedList[SID].CurrObjectiveData.z = z
      TriggerServerEvent('ssv:RecievePedData', SID, 'CurrObjectiveData', 'x', x)
      TriggerServerEvent('ssv:RecievePedData', SID, 'CurrObjectiveData', 'y', y)
      TriggerServerEvent('ssv:RecievePedData', SID, 'CurrObjectiveData', 'z', z)
    end

    TaskFollowNavMeshToCoord(ped, x, y, z, speed, timeout, stoppingRange, persistFollowing)
  else
    local ped = NetToPed(PedNetID)

    local nodex = x
    local nodey = y
    local nodez = z

    if PathfindingData.orx ~= nil then
      nodex = PathfindingData.orx
      nodey = PathfindingData.ory
      nodez = PathfindingData.orz
    elseif PathfindingData.CurrEnd == 'EndPos' then
      nodex = PathfindingData.CurrEndData.x
      nodey = PathfindingData.CurrEndData.y
      nodez = PathfindingData.CurrEndData.z
    elseif PathfindingData.CurrStart == 'none' then
      local retval, outposition = GetSafeCoordForPed(PathfindingData.CurrEndData.x, PathfindingData.CurrEndData.y, PathfindingData.CurrEndData.z, false, 16)
      if not retval then
        retval, outposition = GetPointOnRoadSide(PathfindingData.CurrEndData.x, PathfindingData.CurrEndData.y, PathfindingData.CurrEndData.z, 0)
        if not retval then
          nodex = PathfindingData.CurrEndData.x
          nodey = PathfindingData.CurrEndData.y
          nodez = PathfindingData.CurrEndData.z
        else
          nodex, nodey, nodez = table.unpack(outposition)
        end
      else
        nodex, nodey, nodez = table.unpack(outposition)
      end
    else
      for i, path in ipairs(PathfindingData.CurrStartData.paths) do
        if path.id == PathfindingData.CurrEnd then
          if path.IsActualPath == true then
            nodex = PathfindingData.CurrEndData.x
            nodey = PathfindingData.CurrEndData.y
            nodez = PathfindingData.CurrEndData.z
          else
            local retval, outposition = GetSafeCoordForPed(PathfindingData.CurrEndData.x, PathfindingData.CurrEndData.y, PathfindingData.CurrEndData.z, false, 16)
            if not retval then
              retval, outposition = GetPointOnRoadSide(PathfindingData.CurrEndData.x, PathfindingData.CurrEndData.y, PathfindingData.CurrEndData.z, 0)
              if not retval then
                nodex = PathfindingData.CurrEndData.x
                nodey = PathfindingData.CurrEndData.y
                nodez = PathfindingData.CurrEndData.z
              else
                nodex, nodey, nodez = table.unpack(outposition)
              end
            else
              nodex, nodey, nodez = table.unpack(outposition)
            end
          end
          break
        end
      end
    end

    PathfindingData.orx = nodex
    PathfindingData.ory = nodey
    PathfindingData.orz = nodez

    if isOverride then
      TriggerServerEvent('ssv:RecievePedData', SID, 'OverridePathfindingData', 'orx', orx)
      TriggerServerEvent('ssv:RecievePedData', SID, 'OverridePathfindingData', 'ory', ory)
      TriggerServerEvent('ssv:RecievePedData', SID, 'OverridePathfindingData', 'orz', orz)
    else
      TriggerServerEvent('ssv:RecievePedData', SID, 'CurrPathfindingData', 'orx', orx)
      TriggerServerEvent('ssv:RecievePedData', SID, 'CurrPathfindingData', 'ory', ory)
      TriggerServerEvent('ssv:RecievePedData', SID, 'CurrPathfindingData', 'orz', orz)
    end

    TaskFollowNavMeshToCoord(ped, nodex, nodey, nodez, speed, timeout, stoppingRange, persistFollowing)
  end

end)
