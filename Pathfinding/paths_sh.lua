function AStar(Start, Goal)

  local OpenList = {}
  local IsInOpenList = {}
  local PriorityList = {}
  table.insert(OpenList, Start)
  IsInOpenList[Start] = true
  table.insert(PriorityList, 0)

  local ClosedList = {}
  local CostSoFarList = {}
  ClosedList[Start] = 'None'
  CostSoFarList[Start] = 0

  --local Number = 0

  while #OpenList ~= 0 do
    --Number = Number + 1
    local NextIndex = 1
    local SmallestPriority = PriorityList[1]

    for i, Priority in ipairs(PriorityList) do
      if Priority < SmallestPriority then
        SmallestPriority = Priority
        NextIndex = i
      end
    end

    local CurrentLocation = OpenList[NextIndex]
    local CurrentPriority = PriorityList[NextIndex]

    if CurrentLocation == Goal then
      break
    end

    table.remove(OpenList, NextIndex)
    IsInOpenList[CurrentLocation] = false
    table.remove(PriorityList, NextIndex)

    for i, NextLocation in ipairs(ListNodes[CurrentLocation].paths) do
      local speed = NextLocation[2]
      local NewCost = CostSoFarList[CurrentLocation] + CostFunction(ListNodes[CurrentLocation], ListNodes[NextLocation[1]], speed)
      if not CostSoFarList[NextLocation[1]] or NewCost < CostSoFarList[NextLocation[1]] then
        CostSoFarList[NextLocation[1]] = NewCost
        local NewPriority = NewCost + HeuristicFunction(ListNodes[Goal], ListNodes[NextLocation[1]])
        if IsInOpenList[NextLocation[1]] then
          for i, Entry in ipairs(OpenList) do
            if NextLocation[1] == Entry then
              PriorityList[i] = NewPriority
              break
            end
          end
        else
          table.insert(OpenList, NextLocation[1])
          IsInOpenList[NextLocation[1]] = true
          table.insert(PriorityList, NewPriority)
        end
        ClosedList[NextLocation[1]] = CurrentLocation
      end
    end
  end

  local PathCurrLocation = Goal
  local Path = {}
  while PathCurrLocation ~= Start do
    table.insert(Path, PathCurrLocation)
    PathCurrLocation = ClosedList[PathCurrLocation]
    Wait(0)
  end
  table.insert(Path, Start)
  return(Path)
end

function CostFunction(CurrentLocation, NextLocation, speed) --to determine the costs between two neighboring functions. That means that NextLocation has to be one node inside CurrentLocation.paths

  return ( math.sqrt ( math.pow ( NextLocation.x - CurrentLocation.x, 2 ) + math.pow ( NextLocation.y - CurrentLocation.y, 2 ) + math.pow ( NextLocation.z - CurrentLocation.z, 2 ) ) / speed)
end

function HeuristicFunction(NodeA, NodeB) -- to determine the costs between two nodes. Mostly used with NodeB the end-node. No node can be sure to be a part of NodeX.paths

  return ( math.sqrt ( math.pow ( NodeA.x - NodeB.x, 2 ) + math.pow ( NodeA.y - NodeB.y, 2 ) + math.pow ( NodeA.z - NodeB.z, 2 ) ) / 60 )
end

function ssh_nat_GetNodeData(Id)
  local Data = ListNodes[Id]
  return Data
end

function ssh_nat_GetClosestNodeId(x, y, z)
  local Id = nil
  local Found = false
  local ClosestDist = 9999999999.9
  for name, data in pairs(ListNodes) do
    local Dist = math.sqrt(math.pow(data.x-x, 2)+math.pow(data.y-y, 2)+math.pow(data.z-z,2))
    if Dist < ClosestDist then
      ClosestDist = Dist
      Id = name
    end
  end

  if Id ~= nil then
    Found = true
  end

  return Found, Id
end

function ssh_nat_FindAllNodesInRadius(x, y, z, radius)
  local Found = false
  local NodeIds = {}
  for name, data in pairs(ListNodes) do
    local Dist = ssh_VectorDistance(x, y, z, data.x, data.y, data.z)
    if Dist < radius then
      Found = true
      table.insert(NodeIds, name)
    end
  end
  
  return Found, NodeIds
end

function ssh_nat_FindClosestRoads(x, y, z)
  local Found = false
  local ClosestPaths = {}
  local FoundNode, Nodes = ssh_nat_FindAllNodesInRadius(x, y, z, SearchDistance)

  if FoundNode then
    for i, name in ipairs(Nodes) do
      for j, path in ipairs(ListNodes[name].paths) do
        local _, _, _, _, d = ssh_GetPositionOnLineClosestToPoint(x, y, z, ListNodes[name].x, ListNodes[name].y, ListNodes[name].z, ListNodes[path[1]].x, ListNodes[path[1]].y, ListNodes[path[1]].z)
        if d < MaximumDistanceFromSerpentPathToRoad then
          Found = true
          local ClosePath = {name, path[1]}
          table.insert(ClosestPaths, ClosePath)
        end
      end
    end
  end

  return Found, ClosestPaths
end
