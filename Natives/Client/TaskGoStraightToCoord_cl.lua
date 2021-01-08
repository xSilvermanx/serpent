RegisterNetEvent('scl:nat:res:TaskGoStraightToCoord')
AddEventHandler('scl:nat:res:TaskGoStraightToCoord', function(SID, PedNetID, x, y, z, speed, timeout, targetHeading, distanceToSlide, isOverride)
  local ped = NetToPed(PedNetID)
  print(x)
  print(y)
  print(z)
  TaskGoStraightToCoord(ped, x, y, z, speed, timeout, targetHeading, distanceToSlide)
  if isOverride then
    scl_PedList[SID].OverrideObjectiveData.task = 'Continue'
  else
    scl_PedList[SID].CurrObjectiveData.task = 'Continue'
  end
end)
