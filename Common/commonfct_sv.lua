AddEventHandler('ssv:FinishTask', function(SID, isOverride, isSuccess) --implement isSuccess for event listeners
  Resource = ssv_PedList[SID].OwningRes

  if isOverride then
    TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjective', 'none')
    TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjectiveData', {})
    TriggerEvent('ssv:SyncPedData', SID, '', 'OverridePathfindingData', {})
  else
    local NewObjective = ssv_PedList[SID].NextObjective
    local NewObjectiveData = ssv_PedList[SID].NextObjectiveData
    local NewPathfindingData = ssv_PedList[SID].NextPathfindingData

    TriggerEvent('ssv:SyncPedData', SID, '', 'CurrObjective', NewObjective)
    TriggerEvent('ssv:SyncPedData', SID, '', 'CurrObjectiveData', NewObjectiveData)
    TriggerEvent('ssv:SyncPedData', SID, '', 'CurrPathfindingData', NewPathfindingData)

    TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjective', 'idle')
    TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjectiveData', {})
    TriggerEvent('ssv:SyncPedData', SID, '', 'NextPathfindingData', {})
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

