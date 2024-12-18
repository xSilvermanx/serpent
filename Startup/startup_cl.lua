AddEventHandler('scl:Startup', function()

  TriggerServerEvent('ssv:PlayerConnected')

  Wait(500)

  TriggerEvent('scl:MainClientPedLoop')
  TriggerEvent('scl:MainClientVehLoop')
end)

TriggerEvent('scl:Startup')

