AddEventHandler('scl:Startup', function()

  TriggerServerEvent('ssv:PlayerConnected')

  Wait(500)

  TriggerEvent('scl:MainClientLoop')
end)



TriggerEvent('scl:Startup')
