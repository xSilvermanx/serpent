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
      local NewCost = CostSoFarList[CurrentLocation] + CostFunction(ListNodes[CurrentLocation], ListNodes[NextLocation[1]])
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

    Wait(0)
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

function CostFunction(CurrentLocation, NextLocation) --to determine the costs between two neighboring functions. That means that NextLocation has to be one node inside CurrentLocation.paths

  return ( math.sqrt ( math.pow ( NextLocation.x - CurrentLocation.x, 2 ) + math.pow ( NextLocation.y - CurrentLocation.y, 2 ) + math.pow ( NextLocation.z - CurrentLocation.z, 2 ) ) )
end

function HeuristicFunction(NodeA, NodeB) -- to determine the costs between two nodes. Mostly used with NodeB the end-node. No node can be sure to be a part of NodeX.paths

  return ( math.sqrt ( math.pow ( NodeA.x - NodeB.x, 2 ) + math.pow ( NodeA.y - NodeB.y, 2 ) + math.pow ( NodeA.z - NodeB.z, 2 ) ) )
end

function ssv_nat_GetClosestNodeId(x, y, z)
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

function ssv_nat_GetNodeData(Id)
  local Data = ListNodes[Id]
  return Data
end

--[[CreateThread(function()

  local bool1, node1 = ssv_nat_GetClosestNodeId(-459.79, 5878.41, 33.25)
  local bool2, node2 = ssv_nat_GetClosestNodeId(219.32, 6572.94, 31.89)

  print(bool1, node1)
  print(bool2, node2)

  Path = AStar(node1, node2)
  for i, entry in ipairs(Path) do
    print(entry)
  end
  print(#Path)
end)]]