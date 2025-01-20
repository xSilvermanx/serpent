function ssv_nat_TaskWait(SID, tduration, ObjType)
    local Objective = 'TaskWait'
    local ObjectiveData = {
        task = 'Init',
        duration = tduration,
        ticks = 0,
    }
    if ObjType == "Next" then
        TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjective', Objective)
        TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjectiveData', ObjectiveData)
        TriggerEvent('ssv:SyncPedData', SID, '', 'NextPathfindingData', {})
    elseif ObjType == "Override" then
        TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjective', Objective)
        TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjectiveData', ObjectiveData)
        TriggerEvent('ssv:SyncPedData', SID, '', 'OverridePathfindingData', {})
    else
        TriggerEvent('ssv:SyncPedData', SID, '', 'CurrObjective', Objective)
        TriggerEvent('ssv:SyncPedData', SID, '', 'CurrObjectiveData', ObjectiveData)
        TriggerEvent('ssv:SyncPedData', SID, '', 'CurrPathfindingData', {})
    end
    TriggerEvent('ssv:ev:SerpentPedTaskSet', SID, 'TaskWait', ObjType)
end

RegisterNetEvent('ssv:nat:TaskWait')
AddEventHandler('ssv:nat:TaskWait', function(SID, ObjectiveData, PathfindingData, isOverride)
    if ObjectiveData.task == 'Init' then
        if isOverride then
            TriggerEvent('ssv:SyncPedData', SID, 'OverrideObjectiveData', 'task', 'Continue')
        else
            TriggerEvent('ssv:SyncPedData', SID, 'CurrObjectiveData', 'task', 'Continue')
        end
    end
        
    local ticks = ObjectiveData.ticks
    if ObjectiveData.duration == -1 then
        return
    end

    if ticks*500 >= ObjectiveData.duration then
        TriggerEvent('ssv:FinishTask', SID, isOverride, true)
    else
        ticks = ticks + 1
        if isOverride then
            TriggerEvent('ssv:SyncPedData', SID, 'OverrideObjectiveData', 'ticks', ticks)
        else
            TriggerEvent('ssv:SyncPedData', SID, 'CurrObjectiveData', 'ticks', ticks)
        end
    end
end)