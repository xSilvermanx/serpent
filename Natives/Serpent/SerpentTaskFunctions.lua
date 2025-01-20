function ssv_nat_SetSerpentPedTask(SID, Objective, ObjCustom, ObjData, ObjPathfindingData, ObjType)
    if ObjType == 'Next' then
        TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjective', Objective)
        TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjectiveCustom', ObjCustom)
        TriggerEvent('ssv:SyncPedData', SID, '', 'NextObjectiveData', ObjData)
        TriggerEvent('ssv:SyncPedData', SID, '', 'NextPathfindingData', ObjPathfindingData)
    elseif ObjType == 'Override' then
        TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjective', Objective)
        TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjectiveCustom', ObjCustom)
        TriggerEvent('ssv:SyncPedData', SID, '', 'OverrideObjectiveData', ObjData)
        TriggerEvent('ssv:SyncPedData', SID, '', 'OverridePathfindingData', ObjPathfindingData)
    else
        TriggerEvent('ssv:SyncPedData', SID, '', 'CurrObjective', Objective)
        TriggerEvent('ssv:SyncPedData', SID, '', 'CurrObjectiveCustom', ObjCustom)
        TriggerEvent('ssv:SyncPedData', SID, '', 'CurrObjectiveData', ObjData)
        TriggerEvent('ssv:SyncPedData', SID, '', 'CurrPathfindingData', ObjPathfindingData)
    end
    if Objective == "Custom" then
        TriggerEvent('ssv:ev:SerpentPedTaskSet', SID, ObjCustom.name, ObjType)
    else
        TriggerEvent('ssv:ev:SerpentPedTaskSet', SID, Objective, ObjType)
    end
end

function ssv_nat_UpdateSerpentPedTaskStatus(PedSID, task, isOverride)
    if isOverride then
        TriggerEvent('ssv:SyncPedData', PedSID, 'OverrideObjectiveData', 'task', task)
    else
        TriggerEvent('ssv:SyncPedData', PedSID, 'CurrObjectiveData', 'task', task)
    end
end

function ssv_nat_FinishSerpentPedTask(PedSID, isOverride)
    TriggerEvent('ssv:FinishTask', PedSID, isOverride, true)
end