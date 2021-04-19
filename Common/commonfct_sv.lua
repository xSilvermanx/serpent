AddEventHandler('ssv:FinishTask', function(SID, isOverride, isSuccess) --implement isSuccess for event listeners
  if isOverride then
    ssv_PedList[SID].OverrideObjective = 'none'
    ssv_PedList[SID].OverrideObjectiveData = {}
    ssv_PedList[SID].OverridePathfindingData = {}

    if ssv_PedList[SID].IsSpawnedBool then
      local OwnerID = ssv_PedList[SID].OwnerClientNetID
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'Objective', 'OverrideObjective', 'none')
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'Objective', 'OverrideObjectiveData', {} )
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'Objective', 'OverridePathfindingData', {} )
    end
  else
    local NewObjective = ssv_PedList[SID].NextObjective
    local NewObjectiveData = ssv_PedList[SID].NextObjectiveData
    local NewPathfindingData = ssv_PedList[SID].NextPathfindingData

    ssv_PedList[SID].CurrObjective = NewObjective
    ssv_PedList[SID].CurrObjectiveData = NewObjectiveData
    ssv_PedList[SID].CurrPathfindingData = NewPathfindingData

    ssv_PedList[SID].NextObjective = "idle"
    ssv_PedList[SID].NextObjectiveData = {}
    ssv_PedList[SID].NextPathfindingData = {}

    if ssv_PedList[SID].IsSpawnedBool then
      local OwnerID = ssv_PedList[SID].OwnerClientNetID
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'Objective', 'CurrObjective', NewObjective)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'Objective', 'CurrObjectiveData', NewObjectiveData)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'Objective', 'CurrPathfindingData', NewPathfindingData)
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'Objective', 'NextObjective', "idle")
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'Objective', 'NextObjectiveData', {} )
      TriggerClientEvent('scl:RecievePedData', OwnerID, SID, 'Objective', 'NextPathfindingData', {} )
    end
  end
end)
