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
  for vehid, vehdata in pairs(ssv_VehList) do
    if vehdata.OwnerClientNetID == PID and not vehdata.DriverIsSerpentPed then
      TriggerEvent('ssv:RecieveVehicleControlFromClient', vehid, vehdata)
    end
  end

  ssv_PlayerList[PID] = nil
end)

AddEventHandler('ssv:Startup', function()

  TriggerEvent('ssv:MainServerPedLoop')
  TriggerEvent('ssv:MainServerVehLoop')
end)

TriggerEvent('ssv:Startup')

