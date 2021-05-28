function AStar(Start, Goal, Type, TypeData) -- Type: Vehicle, Cycle, Ped; TypeData = {}
  -- VehData: {IgnoreNoVeh; Speeding}
  -- CycData: {IgnoreNoVeh; IgnoreAbsNoVeh; Speeding}
  -- PedData: {IgnoreNoPed}
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
      local UseNextLocation = false
      if Type == 'Vehicle' then
        if (not NextLocation.AbsNoVeh) and (TypeData.IgnoreNoVeh or not NextLocation.NoVeh) then
          UseNextLocation = true
        end
      elseif Type == 'Cycle' then
        if (TypeData.IgnoreNoVeh or not NextLocation.NoVeh) and (TypeData.IgnoreAbsNoVeh or not NextLocation.AbsNoVeh) then
          UseNextLocation = true
        end
      elseif Type == 'Ped' then
        if (TypeData.IgnoreNoPed or not NextLocation.NoPed) then
          UseNextLocation = true
        end
      end

      if UseNextLocation then

        local speed = NextLocation.S + 0.0
        local maxspeed = 60.0 / 2.237

        if Type == 'Ped' then
          speed = 1.0
          maxspeed = 1.0
        elseif TypeData.Speeding == true then
          speed = speed*NextLocation.SMult
          maxspeed = 180.0 / 2.237
        end

        local NewCost = CostSoFarList[CurrentLocation] + CostFunction(ListNodes[CurrentLocation], ListNodes[NextLocation.id], speed)
        if not CostSoFarList[NextLocation.id] or NewCost < CostSoFarList[NextLocation.id] then
          CostSoFarList[NextLocation.id] = NewCost
          local NewPriority = NewCost + HeuristicFunction(ListNodes[Goal], ListNodes[NextLocation.id], maxspeed)
          if IsInOpenList[NextLocation.id] then
            for i, Entry in ipairs(OpenList) do
              if NextLocation.id == Entry then
                PriorityList[i] = NewPriority
                break
              end
            end
          else
            table.insert(OpenList, NextLocation.id)
            IsInOpenList[NextLocation.id] = true
            table.insert(PriorityList, NewPriority)
          end
          ClosedList[NextLocation.id] = CurrentLocation
        end
      end
    end

    Wait(0)
  end

  --print('No. of Steps: ', Number)

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

  return ( math.sqrt ( math.pow ( NextLocation.x - CurrentLocation.x, 2 ) + math.pow ( NextLocation.y - CurrentLocation.y, 2 ) + math.pow ( NextLocation.z - CurrentLocation.z, 2 ) ) ) / speed
end

function HeuristicFunction(NodeA, NodeB, maxspeed) -- to determine the costs between two nodes. Mostly used with NodeB the end-node. No node can be sure to be a part of NodeX.paths

  return ( math.sqrt ( math.pow ( NodeA.x - NodeB.x, 2 ) + math.pow ( NodeA.y - NodeB.y, 2 ) + math.pow ( NodeA.z - NodeB.z, 2 ) ) ) / maxspeed
end

CreateThread(function()

  local Start = "PALETO-4"
  local Goal = "PALETO-23"

  Path = AStar(Start, Goal, "Ped", {IgnoreNoVeh = false, Speeding = false})
  for i, entry in ipairs(Path) do
    print(entry)
  end
end)

function ssv_nat_GetClosestNodeId(x, y, z)
  local Id = nil
  local Found = false
  local ClosestDist = 9999999999.9
  local radius = 100.0
  for name, data in pairs(ListNodes) do
    if data.x - radius < x and data.x + radius > x and data.y - radius < y and data.y + radius > y then
      local Dist = math.sqrt(math.pow(data.x-x, 2)+math.pow(data.y-y, 2)+math.pow(data.z-z,2))
      if Dist < ClosestDist then
        ClosestDist = Dist
        Id = name
      end
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
