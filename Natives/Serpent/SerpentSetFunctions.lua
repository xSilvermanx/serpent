function ssv_nat_SetSerpentPedData(PedSID, type, key, data)
    TriggerEvent('ssv:SyncPedData', PedSID, type, key, data)
end