function ssv_nat_PedUseExactSpawnCoordinates(PedSID, bool)
    TriggerEvent('ssv:SyncPedData', PedSID, '', 'UseExactSpawnCoordinates', bool)
end

function ssv_nat_VehUseExactSpawnCoordinates(VehSID, bool)
    TriggerEvent('ssv:SyncVehData', VehSID, '', 'UseExactSpawnCoordinates', bool)
end