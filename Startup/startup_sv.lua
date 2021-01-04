ssv_PedList = {}
ssv_VehicleList = {}
ssv_ObjectList = {}
ssv_PlayerList = {}

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
  ssv_PlayerList[PID] = nil
end)

AddEventHandler('ssv:Startup', function()

  TriggerEvent('ssv:MainServerPedLoop')
end)

FreemodeHashM = GetHashKey('mp_m_freemode_01')
FreemodeHashF = GetHashKey('mp_f_freemode_01')

TriggerEvent('ssv:Startup')


CreateThread(function()
  while true do
    for pedid, peddata in ipairs(ssv_PedList) do
      print('SID', pedid)
      print('IsSpawned', peddata.IsSpawnedBool)
      print('OwnerNetID', peddata.OwnerClientNetID)
      print('PedNetID', peddata.PedNetID)
      for plid, pldata in ipairs(ssv_PlayerList) do
        local distance = ssh_VectorDistance(pldata.x, pldata.y, pldata.z, peddata.x, peddata.y, peddata.z)
        print('Distance from player', plid, distance)
      end
      print('---')
    end
    print('------------')
    Wait(1000)
  end
end)
