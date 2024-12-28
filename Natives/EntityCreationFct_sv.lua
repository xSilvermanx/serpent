local PedThreads = {}
local VehThreads = {}

function ssv_nat_CreatePed(pedType, PedmodelHash, pedposx, pedposy, pedposz, pedheading)

  local PedOwner = GetInvokingResource()

  local PedSID = 1

  table.insert(PedThreads, 1)
  local tPedCount = #PedThreads
  local tPedCountNow = tPedCount

  while tPedCount > 1 and tPedCountNow > tPedCount-1 do
    tPedCountNow = #PedThreads
  end

  while ssv_PedList[PedSID] ~= nil do
    PedSID = PedSID + 1
  end

  ssv_PedList[PedSID] = {
    PedSID = PedSID,
    OwningRes = PedOwner,
    x = pedposx,
    y = pedposy,
    z = pedposz,
    heading = pedheading,
    JustSpawnedBool = false,
    IsSpawnedBool = false,
    ScriptOwnerNetID = 0, -- FiveM Networking Ownership
    OwnerClientNetID = 0, -- Serpent Ownership
    PedNetID = 0,
    PedID = 0, -- used for PedEventList only on clientside
    PedType = pedType,
    ModelHash = PedmodelHash,
    RandomLooks = true,
    PedVisualData = {
      Components = {

      },
      Props = {

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
    IsDead = false,
    DeadPitch = 0.0,
    DeadRoll = 0.0,
    BlockNonTemporaryEvents = true,
    UseExactSpawnCoordinates = false,
  }

  table.remove(PedThreads)

  if PedmodelHash == FreemodeHashM or PedmodelHash == FreemodeHashF then
    ssv_PedList[PedSID].PedVisualData.Inheritance = {
      FirstShapeID = 0,
      SecondShapeID = 0,
      ThirdShapeID = 0,
      FirstSkinID = 0,
      SecondSkinID = 0,
      ThirdSkinID = 0,
      shapeMix = 0.0,
      skinMix = 0.0,
      thirdMix = 0.0,
      isParentBool = false,
    }
    ssv_PedList[PedSID].PedVisualData.FaceFeature = {
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
    ssv_PedList[PedSID].PedVisualData.Appearance = {
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

  return PedSID
end

function ssv_nat_CreateVehicle(VehmodelHash, vehposx, vehposy, vehposz, vehheading)
  local VehOwner = GetInvokingResource()

  local VehSID = 1

  table.insert(VehThreads, 1)
  local tVehCount = #VehThreads
  local tVehCountNow = tVehCount

  while tVehCount > 1 and tVehCountNow > tVehCount-1 do
    tVehCountNow = #VehThreads
  end

  while ssv_VehList[VehSID] ~= nil do
    VehSID = VehSID + 1
  end

  ssv_VehList[VehSID] = {
    VehSID = VehSID,
    OwningRes = VehOwner,
    x = vehposx,
    y = vehposy,
    z = vehposz,
    heading = vehheading,
    currspeed = 0.0,
    JustSpawnedBool = false,
    IsSpawnedBool = false,
    ScriptOwnerNetID = 0, -- FiveM Networking Ownership
    OwnerClientNetID = 0, -- Serpent Ownership
    VehNetID = 0,
    VehID = 0, -- used for VehEventList only clientside.
    ModelHash = VehmodelHash,
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
    RandomSpawn = true,
    VehicleMods = {
      Tuning = {

      },
      CustomWheel = false,
      CustomWheelHydraulics = false,
      WheelType = 0,
      Extras = {

      },
    },
    Color = {
      IsColorCombination = false,
      PrimaryColorCustom = false,
      SecondaryColorCustom = false,
      ColorCombination = -1,
      PrimaryColor = 0,
      SecondaryColor = 0,
      DashboardColor = 0,
      ExtraColors = {},
      InteriorColor = 0,
      ModColor1 = {},
      ModColor2 = {},
      NeonLightsEnabled = {},
      NeonLightsColor = {},
      TyreSmokeColor = {},
      XenonLightsColor = 255,
      Livery = -1,
      RoofLivery = -1,
    },
    Lights = {
      HeadlightsState = 0, -- 0 = off, 1 = on, 2 = highbeams
      Searchlight = false, -- false = not existent, 'Off' = Turned off, 'On' = Turned on
      Siren = false,
      IndicatorLeft = false,
      IndicatorRight = false,
      InteriorLight = false,
    },
    VehicleEngineHealth = 1000,
    VehicleBodyHealth = 1000,
    VehiclePetrolTankHealth = 1000,
    VehicleFuelLevel = 100.0,
    VehicleDirtLevel = 0.0,
    WindowStatus = { -- 'Up', 'Down', 'Smashed'
      [0] = 'Up',
      [1] = 'Up',
      [2] = 'Up',
      [3] = 'Up',
      [4] = 'Up',
      [5] = 'Up',
      [6] = 'Up',
      [7] = 'Up',
    },
    WindowTint = 0,
    Hydraulics = { -- not implemented yet

    },
    CheckedDoors = false,
    ExistingDoors = {

    },
    DoorCanBreak = {

    },
    DoorsStatus = { -- "Closed", "Open", "Loose", "Broken"

    },
    DoorLockStatus = 0,
    Deformation = { --not implemented yet, check GetVehicleDeformationAtPos()

    },
    CheckedTyres = false,
    TyreInvincible = false,
    ExistingTyres = {

    },
    TyreDamage = { -- false, 'Flat', 'Destroyed'

    },
    TyreHealth = {

    },
    WheelsCanBreak = false, -- use ExistingTyres for wheels
    WheelsCanBreakBlow = false,
    WheelsCanDeform = false,
    WheelDamage = {  -- false, 'Broken'

    },
    WheelHealth = {

    },
    Attachments = { -- not implemented yet. Has to do with attaching entities to each other - used either very generally or specially for tow trucks, trailers and the likes. Probably generally.

    },
    ConvertibleRoof = false, -- false, 'Open', 'Closed', 'Fixed'
    HasDriftTyres = false,
    IsUndrivable = false,
    IsExploded = false,
    FrontBumper = true, --true = Undamaged, 'Bouncing', 'BrokenOff'
    RearBumper = true, --true = Undamaged, 'Bouncing', 'BrokenOff'
    UseExactSpawnCoordinates = false,
  }

  table.remove(VehThreads)

  return VehSID
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
