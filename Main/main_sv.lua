local PedThreads = {}

function ssv_nat_CreatePed(pedType, modelHash, posx, posy, posz, pedheading)

  local Owner = GetInvokingResource()

  local SID = 1

  table.insert(PedThreads, 1)
  local tCount = #PedThreads
  local tCountNow = tCount

  while tCount > 1 and tCountNow > tCount-1 do
    tCountNow = table.getn(PedThreads)
  end

  while ssv_PedList[SID] ~= nil do
    SID = SID + 1
  end

  ssv_PedList[SID] = {
    PedSID = SID,
    OwningRes = Owner,
    x = posx,
    y = posy,
    z = posz,
    heading = pedheading,
    IsSpawnedBool = false,
    ScriptOwnerNetID = 0, -- FiveM Networking Ownership
    OwnerClientNetID = 0, -- Serpent Ownership
    PedNetID = 0,
    PedType = pedType,
    ModelHash = modelHash,
    PedVisualData = {
      Components = {
        {0, 0, 0},
        {1, 0, 0},
        {2, 0, 0},
        {3, 0, 0},
        {4, 0, 0},
        {5, 0, 0},
        {6, 0, 0},
        {7, 0, 0},
        {8, 0, 0},
        {9, 0, 0},
        {10, 0, 0},
        {11, 0, 0},
      },
      Props = {
        {0, 0, 0},
        {1, 0, 0},
        {2, 0, 0},
        {6, 0, 0},
        {7, 0, 0},
      },
    },
    CurrObjective = "idle",
    CurrObjectiveData = {},
    CurrPathfindingData = {},
    OverrideObjective = "none",
    OverrideObjectiveData = {},
    OverridePathfindingData = {},
    NextObjective = "idle",
    NextObjectiveData = {},
    NextPathfindingData = {},
    IsInVeh = false,
    VehSID = 0,
    PedRelationshipGroup = "NO_RELATIONSHIP",
    PedHealth = 100,
    PedArmor = 0,
    BlockNonTemporaryEvents = true,
  }

  table.remove(PedThreads)

  if modelhash == FreemodeHashM or modelhash == FreemodeHashF then
    ssv_PedList[SID].PedVisualData.Inheritance = {
      MotherShapeID = 0,
      FatherShapeID = 0,
      MotherSkinID = 0,
      FatherSkinID = 0,
      shapeMix = 0.0,
      skinMix = 0.0,
    }
    ssv_PedList[SID].PedVisualData.FaceFeatures = {
      NoseWidth = 0.0,
      NosePeakHeight = 0.0,
      NosePeakLength = 0.0,
      NoseBoneHeight = 0.0,
      NosePeakLowering = 0.0,
      NoseBoneTwist = 0.0,
      EyeBrowHeight = 0.0,
      EyeBrowForward = 0.0,
      CheeksBoneHeight = 0.0,
      CheeksBoneWidth = 0.0,
      CheeksWidth = 0.0,
      EyesOpening = 0.0,
      LipsThickness = 0.0,
      JawBoneWidth = 0.0,
      JawBoneBackLength = 0.0,
      ChimpBoneLower = 0.0,
      ChimpBoneLength = 0.0,
      ChimpBoneWidth = 0.0,
      ChimpHole = 0.0,
      NeckThickness = 0.0,
    }
    ssv_PedList[SID].PedVisualData.Appearance = {
      HairColor = 0,
      HairHighlightColor = 0,
      BlemishesStyle = 255,
      BlemishesOpacity = 0.0,
      FacialHairStyle = 255,
      FacialHairOpacity = 0.0,
      FacialHairFirstColor = 0,
      FacialHairSecondColor = 0,
      EyebrowsStyle = 255,
      EyebrowsOpacity = 0.0,
      EyebrowsFirstColor = 0,
      EyebrowsSecondColor = 0,
      AgeingStyle = 255,
      AgeingOpacity = 0.0,
      MakeupStyle = 255,
      MakeupOpacity = 0.0,
      MakeupFirstColor = 0,
      MakeupSecondColor = 0,
      BlushStyle = 255,
      BlushOpacity = 0.0,
      BlushFirstColor = 0,
      BlushSecondColor = 0,
      ComplexionStyle = 255,
      ComplexionOpacity = 0.0,
      SunDamageStyle = 255,
      SunDamageOpacity = 0.0,
      LipstickStyle = 255,
      LipstickOpacity = 0.0,
      LipstickFirstColor = 0,
      LipstickSecondColor = 0,
      MolesStyle = 255,
      MolesOpacity = 0.0,
      ChestHairStyle = 255,
      ChestHairOpacity = 0.0,
      ChestHairFirstColor = 0,
      ChestHairSecondColor = 0,
      BodyBlemishesStyle = 255,
      BodyBlemishesOpacity = 0.0,
      AddBodyBlemishesStyle = 255,
      AddBodyBlemishesOpacity = 0.0,
      EyeColor = 0,
    }
  end

  return SID

end

function ssv_nat_CreateVehicle()

end

function ssv_nat_CreateObject()

end

RegisterNetEvent('ssv:RecievePlayerPos')
AddEventHandler('ssv:RecievePlayerPos', function(px, py, pz)
  local PlayerID = tonumber(source)

  ssv_PlayerList[PlayerID].x = px
  ssv_PlayerList[PlayerID].y = py
  ssv_PlayerList[PlayerID].z = pz
end)

AddEventHandler('ssv:MainServerPedLoop', function()
  CreateThread(function()
    while true do
      for pedid, peddata in pairs(ssv_PedList) do
        if (not peddata.IsSpawnedBool) then

          local pedx = peddata.x
          local pedy = peddata.y
          local pedz = peddata.z
          local BoolCloseToPl = false
          local ClosestPlId = 0
          local ClosestPlDist = 999999.9

          for plid, pldata in pairs(ssv_PlayerList) do
            local plx = pldata.x
            local ply = pldata.y
            local plz = pldata.z
            local pldist = ssh_VectorDistance(pedx, pedy, pedz, plx, ply, plz)
            if pldist < SpawnRange then
              BoolCloseToPl = true
              if pldist < ClosestPlDist then
                ClosestPlId = plid
                ClosestPlDist = pldist
              end
            end
          end

          if BoolCloseToPl == true then
            if peddata.IsInVeh then
              TriggerEvent('ssv:SpawnPedInVeh', pedid, peddata, ClosestPlId)
            else
              TriggerEvent('ssv:SpawnPed', pedid, peddata, ClosestPlId)
            end
          else
            TriggerEvent('ssv:MainTaskHandler', pedid)
          end

        end
      end
      Wait(500)
    end
  end)
end)

AddEventHandler('ssv:MainTaskHandler', function(pedid)
  local isOverride = false
  local Objective = nil
  local ObjectiveData = nil
  local PathfindingData = nil
  if ssv_PedList[pedid].OverrideObjective ~= 'none' then
    isOverride = true
    Objective = ssv_PedList[pedid].OverrideObjective
    ObjectiveData = ssv_PedList[pedid].OverrideObjectiveData
    PathfindingData = ssv_PedList[pedid].OverridePathfindingData
  else
    Objective = ssv_PedList[pedid].CurrObjective
    ObjectiveData = ssv_PedList[pedid].CurrObjectiveData
    PathfindingData = ssv_PedList[pedid].CurrPathfindingData
  end

  if Objective ~= 'idle' and ObjectiveData.task ~= 'Ignore' then
    TriggerEvent('ssv:nat:' .. Objective, pedid, ObjectiveData, PathfindingData, isOverride)
  end
end)

AddEventHandler('ssv:SpawnPed', function (pedid, peddata, plid)
  ssv_PedList[pedid].IsSpawnedBool = true
  ssv_PedList[pedid].OwnerClientNetID = plid

  if ssv_PedList[pedid].OverrideObjective ~= 'none' and ssv_PedList[pedid].OverrideObjectiveData.task ~= 'Ignore' then
    ssv_PedList[pedid].OverrideObjectiveData.task = 'Init'
  elseif ssv_PedList[pedid].CurrObjectiveData.task ~= 'Ignore' then
    ssv_PedList[pedid].CurrObjectiveData.task = 'Init'
  end

  local newpeddata = ssv_PedList[pedid]
  TriggerClientEvent('scl:SpawnPed', plid, pedid, newpeddata)
end)

AddEventHandler('ssv:SpawnPedInVeh', function(pedid, plid)
  ssv_PedList[pedid].IsSpawnedBool = true
  ssv_PedList[pedid].OwnerClientNetID = plid

  local vehid = newpeddata.VehSID
  local vehdata = nil --get the appropriate vehdata from ssv_VehList

  local newpeddata = ssv_PedList[pedid]
  TriggerClientEvent('scl:SpawnPedInVeh', plid, pedid, newpeddata, vehid, vehdata)
end)

RegisterNetEvent('ssv:RecieveEntityControlFromClient')
AddEventHandler('ssv:RecieveEntityControlFromClient', function(pedid, peddata)

  ssv_PedList[pedid] = peddata

  if ssv_PedList[pedid].OverrideObjective ~= 'none' then
    ssv_PedList[pedid].OverrideObjectiveData.task = 'Init'
  else
    ssv_PedList[pedid].CurrObjectiveData.task = 'Init'
  end

  local data = ssv_PedList[pedid]

  local pedx = data.x
  local pedy = data.y
  local pedz = data.z
  local BoolCloseToPl = false
  local ClosestPlId = 0
  local ClosestPlDist = 999999.9

  for plid, pldata in pairs(ssv_PlayerList) do
    local plx = pldata.x
    local ply = pldata.y
    local plz = pldata.z
    local pldist = ssh_VectorDistance(pedx, pedy, pedz, plx, ply, plz)
    if pldist < DespawnRange then
      BoolCloseToPl = true
      if pldist < ClosestPlDist then
        ClosestPlId = plid
        ClosestPlDist = pldist
      end
    end
  end

  if BoolCloseToPl == true then
    ssv_PedList[pedid].OwnerClientNetID = ClosestPlId
    local newpeddata = ssv_PedList[pedid]
    TriggerClientEvent('scl:RecievePedOwnership', ClosestPlId, pedid, newpeddata)
  else
    TriggerEvent('ssv:DespawnPed', pedid, data)
  end
end)

RegisterNetEvent('ssv:DespawnPed')
AddEventHandler('ssv:DespawnPed', function(pedid, peddata)

  local PedNetID = peddata.PedNetID
  local ped = NetworkGetEntityFromNetworkId(PedNetID)
  DeleteEntity(ped)

  ssv_PedList[pedid] = peddata

  ssv_PedList[pedid].IsSpawnedBool = false
  ssv_PedList[pedid].OwnerClientNetID = 0
  ssv_PedList[pedid].PedNetID = 0
end)
