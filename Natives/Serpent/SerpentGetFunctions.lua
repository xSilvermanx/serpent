function ssv_nat_GetSerpentPedNetId(SID)
    return ssv_PedList[SID].PedNetID
end

function ssv_nat_GetSerpentVehNetId(SID)
    return ssv_VehList[SID].VehNetID
end

function ssv_nat_GetSerpentPedData(SID)
    local Data = ssv_PedList[SID]
    return Data
end

function ssv_nat_GetSerpentVehData(SID)
    local Data = ssv_VehList[SID]
    return Data
end

function ssv_nat_GetSerpentPedId(PedNetID)
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
  
function ssv_nat_GetSerpentVehId(VehNetID)
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