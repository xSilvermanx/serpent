AddEventHandler('scl:Startup', function()

  TriggerServerEvent('ssv:PlayerConnected')

  Wait(500)

  TriggerEvent('scl:MainClientPedLoop')
  TriggerEvent('scl:MainClientVehLoop')
end)

TriggerEvent('scl:Startup')

--[[CreateThread(function()
  while true do
    for pedid, peddata in pairs(scl_PedList) do
      print('SID', peddata.PedSID)
      print('Pos', peddata.x, peddata.y, peddata.z)
      print('Heading', peddata.heading)
      print('Current Task', peddata.CurrObjective)
      print('---')
    end
    print('----------------')
    Wait(1000)
  end
end)]]
