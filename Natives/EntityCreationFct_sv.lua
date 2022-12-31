local PedThreads = {}
local VehThreads = {}

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
    IsInVeh = false, -- refers to Serpent Vehicles only
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

function ssv_nat_CreateVehicle(modelHash, posx, posy, posz, vehheading)
  local Owner = GetInvokingResource()

  local SID = 1

  table.insert(VehThreads, 1)
  local tCount = #VehThreads
  local tCountNow = tCount

  while tCount > 1 and tCountNow > tCount-1 do
    tCountNow = table.getn(VehThreads)
  end

  while ssv_VehList[SID] ~= nil do
    SID = SID + 1
  end

  ssv_VehList[SID] = {
    VehSID = SID,
    OwningRes = Owner,
    x = posx,
    y = posy,
    z = posz,
    heading = vehheading,
    IsSpawnedBool = false,
    OwnerClientNetID = 0, -- Serpent Ownership
    VehNetID = 0,
    ModelHash = modelHash,
    DriverIsSerpentPed = false,
    Passengers = {
      [-1] = 0,
      [0] = 0,
      [1] = 0,
      [2] = 0,
      [3] = 0,
      [4] = 0,
      [5] = 0,
      [6] = 0,
    },
    VehicleMods = {
      Tuning = {

      },
      Color = {

      },
      Extras = {

      },
    },
    VehicleEngineHealth = 1000,
    VehicleLockStatus = 1,
    VehicleLightsStatus = {

    },
    VehicleDirtLevel = 0.0,
    WindowStatus = { --check IsVehicleWindowIntact() and RollDownWindows()

    },
    DoorsStatus = {

    },
    Deformation = { --check GetVehicleDeformationAtPos()

    },
    TyreDamage = { -- if false, no damage, else set either 'flat' or 'gone'. Numbers refer to wheelID as in native IsVehicleTyreBurst()
      [0] = false,
      [1] = false,
      [2] = false,
      [3] = false,
      [4] = false,
      [5] = false,
      [45] = false,
      [47] = false,
    },
    Attachments = {

    },
    ConvertibleRoofClosed = true,
    HasDriftTyres = false,

  }

  table.remove(VehThreads)

  return SID
end

function ssv_nat_CreateObject()

end

function ssv_nat_DeletePed(pedid)
  if ssv_PedList[pedid].IsSpawnedBool then
    local OwnerID = ssv_PedList[pedid].OwnerClientNetID
    TriggerClientEvent('scl:RemovePed', OwnerID, pedid)
  end
  if ssv_PedList[pedid].IsInVeh then
    local VehSID = ssv_PedList[pedid].VehSID
    local seat = ssv_FindPedSeatInSerpentVehicle(pedid)

    TriggerEvent('ssv:SyncVehData', VehSID, 'Passenger', seat, 0)
    if seat == -1 then
      TriggerEvent('ssv:SyncVehData', VehSID, '', 'DriverIsSerpentPed', false)
    end
  end
  ssv_PedList[pedid] = nil
end

function ssv_nat_DeleteVehicle(vehid)
  if ssv_VehList[vehid].IsSpawnedBool then
    local OwnerID = ssv_VehList[vehid].OwnerClientNetID
    TriggerClientEvent('scl:RemoveVeh', OwnerID, vehid)
  end
  for i, passenger in pairs(ssv_VehList[vehid].Passengers) do
    if passenger ~= 0 then
      TriggerEvent('ssv:SyncPedData', passenger, '', "IsInVeh", false)
      TriggerEvent('ssv:SyncPedData', passenger, '', "VehSID", 0)
    end
  end
  ssv_VehList[vehid] = nil
end

function ssv_nat_DeleteObject(objid)

end
