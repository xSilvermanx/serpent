AddEventHandler('scl:Startup', function()

  TriggerServerEvent('ssv:PlayerConnected')

  Wait(500)

  TriggerEvent('scl:MainClientPedLoop')
end)

TriggerEvent('scl:Startup')
