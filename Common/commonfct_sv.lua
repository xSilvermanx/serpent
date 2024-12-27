AddEventHandler('ssv:FinishTask', function(SID, isOverride, isSuccess) --implement isSuccess for event listeners
  Resource = ssv_PedList[SID].OwningRes

  if isOverride then
    TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjective', 'none')
    TriggerEvent('ssv:SyncPedData', SID, 'OverrideObjectiveData', 'OverrideObjectiveData', {})
    TriggerEvent('ssv:SyncPedData', SID, 'OverridePathfindingData', 'OverridePathfindingData', {})
  else
    local NewObjective = ssv_PedList[SID].NextObjective
    local NewObjectiveData = ssv_PedList[SID].NextObjectiveData
    local NewPathfindingData = ssv_PedList[SID].NextPathfindingData

    TriggerEvent('ssv:SyncPedData', SID, '', 'CurrObjective', NewObjective)
    TriggerEvent('ssv:SyncPedData', SID, 'CurrObjectiveData', 'CurrObjectiveData', NewObjectiveData)
    TriggerEvent('ssv:SyncPedData', SID, 'Objective', 'CurrPathfindingData', NewPathfindingData)

    TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjective', 'idle')
    TriggerEvent('ssv:SyncPedData', SID, 'NextObjectiveData', 'NextObjectiveData', {})
    TriggerEvent('ssv:SyncPedData', SID, 'NextPathfindingData', 'NextPathfindingData', {})
  end
end)

function ssv_FindPedSeatInSerpentVehicle(pedid)
  local seat = -1
  local VehSID = ssv_PedList[pedid].VehSID
  for i, passenger in pairs(ssv_VehList[VehSID].Passengers) do
    if passenger == pedid then
        seat = i
        break
    end
  end
  return seat
end

