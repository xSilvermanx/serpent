function ssv_nat_PedEnableRandomLook(PedSID, bool)
    TriggerEvent('ssv:SyncPedData', PedSID, '', 'RandomLooks', bool)
end