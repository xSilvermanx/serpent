-- Event triggers when a Task was finished successfully.
AddEventHandler('ssv:FinishTask', function(SID, isOverride)
  Resource = ssv_PedList[SID].OwningRes
  TriggerEvent('ssv:nat:GetPedSpecificTaskType', SID)
  local OldTask = ''
  local hasNewTask = false

  if isOverride then
    OldTask = ssv_PedList[SID].OverrideObjective
    TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjective', 'none')
    TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjectiveData', {})
    TriggerEvent('ssv:SyncPedData', SID, '', 'OverridePathfindingData', {})
  else
    OldTask = ssv_PedList[SID].CurrObjective
    local NewObjective = ssv_PedList[SID].NextObjective
    local NewObjectiveData = ssv_PedList[SID].NextObjectiveData
    local NewPathfindingData = ssv_PedList[SID].NextPathfindingData
    
    if NewObjective ~= 'idle' then
      hasNewTask = true
    end

    TriggerEvent('ssv:SyncPedData', SID, '', 'CurrObjective', NewObjective)
    TriggerEvent('ssv:SyncPedData', SID, '', 'CurrObjectiveData', NewObjectiveData)
    TriggerEvent('ssv:SyncPedData', SID, '', 'CurrPathfindingData', NewPathfindingData)

    TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjective', 'idle')
    TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjectiveData', {})
    TriggerEvent('ssv:SyncPedData', SID, '', 'NextPathfindingData', {})
  end
  TriggerEvent('ssv:ev:SerpentPedTaskFinished', SID, OldTask, isOverride, hasNewTask)
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

function GetSerpentPedId(PedNetID)
  local found = false
  local value = -1
  for PedSID, peddata in pairs(ssv_PedList) do
    if PedNetID == peddata.PedNetID then
      found = true
      value = PedSID
      break
    end
  end
  return found, value
end

function GetSerpentVehId(VehNetID)
  local found = false
  local value = -1
  for VehSID, vehdata in pairs(ssv_VehList) do
    if VehNetID == vehdata.VehNetID then
      found = true
      value = VehSID
      break
    end
  end
  return found, value
end