AddEventHandler('scl:Startup', function()

  TriggerServerEvent('ssv:PlayerConnected')

  Wait(500)

  TriggerEvent('scl:MainClientPedLoop')
end)

TriggerEvent('scl:Startup')



--[[CreateThread(function()
  while true do
    for pedid, peddata in ipairs(scl_PedList) do
      print('PedID', pedid)
      print('PedNetID', peddata.PedNetID)
      print('---')
    end
    print('------------')
    Wait(1000)
  end
end)]]
