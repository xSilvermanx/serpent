RegisterNetEvent('ssv:PlayerConnected')
AddEventHandler('ssv:PlayerConnected', function()
  local PID = tonumber(source)

  local PlayerData = {
    PlayerID = PID,
    PlayerName = GetPlayerName(PID),
    x = 0.0,
    y = 0.0,
    z = 0.0,
  }

  ssv_PlayerList[PID] = PlayerData
end)

AddEventHandler('playerDropped', function(reason)
  local PID = tonumber(source)

  for pedid, peddata in pairs(ssv_PedList) do
    if peddata.OwnerClientNetID == PID then
      TriggerEvent('ssv:RecieveEntityControlFromClient', pedid, peddata)
    end
  end

  ssv_PlayerList[PID] = nil
end)

AddEventHandler('ssv:Startup', function()

  TriggerEvent('ssv:MainServerPedLoop')
end)

TriggerEvent('ssv:Startup')

--[[CreateThread(function()
  while true do
    for pedid, peddata in pairs(ssv_PedList) do
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
