scl_PedList = {}


AddEventHandler('scl:MainClientLoop', function()

  CreateThread(function()
    while true do
      local playerped = GetPlayerPed(-1)
      local px, py, pz = table.unpack(GetEntityCoords(playerped))
      TriggerServerEvent('ssv:RecievePlayerInfo', px, py, pz)

      for id, data in pairs(scl_PedList) do
        
      end
      Wait(500)
    end
  end)

end)
