--[[CreateThread(function()
  while true do
    for pedid, peddata in pairs(ssv_PedList) do
      print('SID', peddata.PedSID)
      print('PedNetID', peddata.PedNetID)
      print('IsSpawned', peddata.IsSpawnedBool)
      print('OwnerClientNetID', peddata.OwnerClientNetID)
      print('Pos', peddata.x, peddata.y, peddata.z)
      print('Heading', peddata.heading)
      print('Current Task', peddata.CurrObjective)
      print('IsInVeh', peddata.IsInVeh)
      print('VehSID', peddata.VehSID)
      print('---')
    end
    print('----------------')
    for vehid, vehdata in pairs(ssv_VehList) do
      print('SID', vehdata.VehSID)
      print('VehNetID', vehdata.VehNetID)
      print('IsSpawned', vehdata.IsSpawnedBool)
      print('OwnerClientNetID', vehdata.OwnerClientNetID)
      print('Pos', vehdata.x, vehdata.y, vehdata.z)
      print('Heading', vehdata.heading)
      print('Driver is Serpent Ped', vehdata.DriverIsSerpentPed)
      print('Driver Ped SID', vehdata.Passengers[-1])
      print('---')
    end
    print('----------------')
    print('---------------------------------------------')
    Wait(1000)
  end
end)]]
