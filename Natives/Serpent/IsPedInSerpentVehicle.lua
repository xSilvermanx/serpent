function ssv_native_IsPedInSerpentVehicle(SID, VehSID)
  local bool = false
  if ssv_PedList[SID].IsInVeh then
    for i, passenger in pairs(ssv_VehList[VehSID].Passengers) do
      if passenger == SID then
        bool = true
        break
      end
    end
  end
  return bool
end
