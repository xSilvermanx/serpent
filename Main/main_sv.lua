ssv_PedList = {}
ssv_VehicleList = {}
ssv_ObjectList = {}
ssv_PlayerList = {}

ExamplePed = {
  PedIID = 1,
  x = x,
  y = y,
  z = z,
  IsSpawnedBool = false,
  OwnerClientNetID = 0,
  PedNetID = 0,
  PedModel = "a_f_m_beach_01",
  PedVisualData = {},
  CurrObjective = "DriveToCoord",
  CurrObjectiveData = {
    tarx = 2000.0,
    tary = 2000.0,
    tarz = 2000.0,
  },
  NextObjective = "DriveToCoord",
  NextObjectiveData = {
    tarx = 3000.0,
    tary = 3000.0,
    tarz = 3000.0,
  },
  PathfindingData = {},
  IsInVeh = false,
  VehIID = 0,
  PedRelationshipGroup = "",
  PedHealth = 100,
  PedArmor = 0,

}

RegisterNetEvent('ssv:RecievePlayerInfo')
AddEventHandler('ssv:RecievePlayerInfo', function(px, py, pz)
  local PlayerID = tonumber(source)
  ssv_PlayerList[PlayerID].x = px
  ssv_PlayerList[PlayerID].y = py
  ssv_PlayerList[PlayerID].z = pz
end)

CreateThread(function()
  while true do
    for id, data in pairs(ssv_PlayerList) do
      print(id)
      print(data.PlayerID)
      print(data.PlayerName)
      print(data.x)
      print(data.y)
      print(data.z)
      print('-')
    end
    print('---')
    Wait(3000)
  end
end)

function ssv_CreatePed()

end
