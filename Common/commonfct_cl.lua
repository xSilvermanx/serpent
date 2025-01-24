function scl_SpawnVeh(vehid, vehdata)
    
    scl_VehList[vehid] = vehdata

    local x = vehdata.x
    local y = vehdata.y
    local z = vehdata.z
    local Pos = {x = x, y = y, z = z}

    if not scl_VehList[vehid].UseExactSpawnCoordinates then
        local retval, Pos1 = GetClosestVehicleNode(x, y, z, 1, 3.0, 0)
        Pos = Pos1

        if not retval then
            Pos = {x = x, y = y, z = z}
        else
            local x1, y1, z1 = ssh_OffsetPosition(Pos.x, Pos.y, Pos.z, vehdata.heading, 3, 0, 0)
            Pos = {x = x1, y = y1, z = z1}

            local rayHandle = StartShapeTestRay(Pos.x, Pos.y, Pos.z+5.0, Pos.x, Pos.y, Pos.z-5.0, 30, 0, 0)
            local _, hit, _, _, _ = GetShapeTestResult(rayHandle)

            if hit == 1 then
                Pos = {x = Pos1.x, y = Pos1.y, z = Pos1.z}
                local rayHandle = StartShapeTestRay(Pos.x, Pos.y, Pos.z+5.0, Pos.x, Pos.y, Pos.z-5.0, 30, 0, 0)
                local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)
                if hit == 1 then
                    Pos = {x = x, y = y, z = z}
                end
            end
        end
    end
    
    RequestModel(vehdata.ModelHash)
  
    while not HasModelLoaded(vehdata.ModelHash) do
      RequestModel(vehdata.ModelHash)
      Wait(50)
    end
    
    local veh = CreateVehicle(vehdata.ModelHash, Pos.x, Pos.y, Pos.z, vehdata.heading, true, false)    
    local VehNetID = VehToNet(veh)
    SetVehicleForwardSpeed(veh, vehdata.currspeed)

    TriggerServerEvent('ssv:ev:SerpentVehSpawned', vehid)
    scl_VehList[vehid].VehNetID = VehNetID
    TriggerServerEvent('ssv:SyncVehData', vehid, '', 'VehNetID', VehNetID)
    scl_VehEventList[veh] = vehid
    TriggerServerEvent('ssv:SyncVehData', vehid, '', 'VehID', veh)

    return true
end

function scl_SpawnPed(pedid, peddata, seatindex)
    local isOverride = false
    local PedNetID = 0
    local ped = 0
    scl_PedList[pedid] = peddata
    
    if peddata.IsInVeh then
        local VehNetID = scl_VehList[peddata.VehSID].VehNetID
        local veh = NetToVeh(VehNetID)
        local seat = seatindex

        if seatindex == -2 then
            for i, passenger in pairs(scl_VehList[peddata.VehSID].Passengers) do
                if passenger == pedid then
                    seat = i
                    break
                end
            end
        end

        RequestModel(peddata.ModelHash)
      
        while not HasModelLoaded(peddata.ModelHash) do
          RequestModel(peddata.ModelHash)
          Wait(50)
        end
      
        ped = CreatePedInsideVehicle(veh, peddata.PedType, peddata.ModelHash, seat, true, true)
        PedNetID = PedToNet(ped)
    else
        local x = peddata.x
        local y = peddata.y
        local z = peddata.z

        if peddata.OverrideObjective ~= 'none' then
            isOverride = true
        end

        if not scl_PedList[pedid].UseExactSpawnCoordinates then
            local retval, r = GetSafeCoordForPed(peddata.x, peddata.y, peddata.z, false, 16)
            local rx, ry, rz = table.unpack(r)
            if retval and ssh_VectorDistance(x, y, z, rx, ry, rz) < 22.0 then
                x = rx
                y = ry
                z = rz
            else
                retval, r = GetPointOnRoadSide(peddata.x, peddata.y, peddata.z, 0)
                if retval and ssh_VectorDistance(x, y, z, rx, ry, rz) < 22.0 then
                x = rx
                y = ry
                z = rz
                end
            end
        end

        --make sure that selected coordinates are free for entity to spawn

        RequestModel(peddata.ModelHash)

        while not HasModelLoaded(peddata.ModelHash) do
            RequestModel(peddata.ModelHash)
            Wait(50)
        end

        ped = CreatePed(peddata.PedType, peddata.ModelHash, x, y, z-1.0, peddata.heading, true, false)
        PedNetID = PedToNet(ped)
    end
    TriggerServerEvent('ssv:ev:SerpentPedSpawned', pedid)
    scl_PedList[pedid].PedNetID = PedNetID
    TriggerServerEvent('ssv:SyncPedData', pedid, '', 'PedNetID', PedNetID)
    scl_PedEventList[ped] = pedid
    TriggerServerEvent('ssv:SyncPedData', pedid, '', 'PedID', ped)
    return true
end

function scl_ApplyAllPedProperties(pedid, peddata)
    scl_ApplyPedBehaviorFlags(pedid, peddata)
    local PedNetID = peddata.PedNetID
    local ped = NetToPed(PedNetID)

    Wait(0)
    if peddata.isDead then
        DisablePedPainAudio(PedID, true)
    end

    SetEntityHealth(ped, peddata.PedHealth)
    SetPedArmour(ped, peddata.PedArmor)

    if peddata.isDead then
        SetEntityCoordsNoOffset(ped, peddata.x, peddata.y, peddata.z, false, false, true)
        SetEntityRotation(ped, peddata.DeadPitch, peddata.DeadRoll, peddata.Heading, 2, true)
    end
    
    if (peddata.ModelHash == FreemodeHashM or peddata.ModelHash == FreemodeHashF) then
        if peddata.RandomLooks then
            local HeadBlendData = exports.hbw:GetHeadBlendData(ped)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Inheritance', 'FirstShapeID', HeadBlendData.FirstFaceShape)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Inheritance', 'SecondShapeID', HeadBlendData.SecondFaceShape)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Inheritance', 'ThirdShapeID', HeadBlendData.ThirdFaceShape)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Inheritance', 'FirstSkinID', HeadBlendData.FirstSkinTone)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Inheritance', 'SecondSkinID', HeadBlendData.SecondSkinTone)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Inheritance', 'ThirdSkinID', HeadBlendData.ThirdSkinTone)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Inheritance', 'shapeMix', HeadBlendData.ParentFaceShapePercent)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Inheritance', 'skinMix', HeadBlendData.ParentSkinTonePercent)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Inheritance', 'thirdMix', HeadBlendData.ParentThirdUnkPercent)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Inheritance', 'isParentBool', HeadBlendData.IsParentInheritance)

            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'NoseWidth', GetPedFaceFeature(ped, 0))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'NosePeakHeight', GetPedFaceFeature(ped, 1))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'NosePeakLength', GetPedFaceFeature(ped, 2))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'NoseBoneHeight', GetPedFaceFeature(ped, 3))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'NosePeakLowering', GetPedFaceFeature(ped, 4))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'NoseBoneTwist', GetPedFaceFeature(ped, 5))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'EyeBrowHeight', GetPedFaceFeature(ped, 6))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'EyeBrowForward', GetPedFaceFeature(ped, 7))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'CheeksBoneHeight', GetPedFaceFeature(ped, 8))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'CheeksBoneWidth', GetPedFaceFeature(ped, 9))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'CheeksWidth', GetPedFaceFeature(ped, 10))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'EyesOpening', GetPedFaceFeature(ped, 11))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'LipsThickness', GetPedFaceFeature(ped, 12))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'JawBoneWidth', GetPedFaceFeature(ped, 13))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'JawBoneBackLength', GetPedFaceFeature(ped, 14))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'ChimpBoneLower', GetPedFaceFeature(ped, 15))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'ChimpBoneLength', GetPedFaceFeature(ped, 16))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'ChimpBoneWidth', GetPedFaceFeature(ped, 17))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'ChimpHole', GetPedFaceFeature(ped, 18))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'FaceFeature', 'NeckThickness', GetPedFaceFeature(ped, 19))

            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'HairColor', GetPedHairColor(ped))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'HairHightlightColor', GetPedHairHighlightColor(ped))
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'EyeColor', GetPedEyeColor(ped))

            local _, BlemishesStyle, _, _, _, BlemishesOpacity = GetPedHeadOverlayData(ped, 0)
            local _, FacialHairStyle, _, FacialHairFirstColor, FacialHairSecondColor, FacialHairOpacity  = GetPedHeadOverlayData(ped, 1)
            local _, EyebrowsStyle, _, EyebrowsFirstColor, EyebrowsSecondColor, EyebrowsOpacity = GetPedHeadOverlayData(ped, 2)
            local _, AgeingStyle, _, _, _, AgeingOpacity  = GetPedHeadOverlayData(ped, 3)
            local _, MakeupStyle, _, MakeupFirstColor, MakeupSecondColor, MakeupOpacity = GetPedHeadOverlayData(ped, 4)
            local _, BlushStyle, _, BlushFirstColor, BlushSecondColor, BlushOpacity = GetPedHeadOverlayData(ped, 5)
            local _, ComplexionStyle, _, _, _, ComplexionOpacity = GetPedHeadOverlayData(ped, 6)
            local _, SunDamageStyle, _, _, _, SunDamageOpacity = GetPedHeadOverlayData(ped, 7)
            local _, LipstickStyle, _, LipstickFirstColor, LipstickSecondColor, LipstickOpacity = GetPedHeadOverlayData(ped, 8)
            local _, MolesStyle, _, _, _, MolesOpacity = GetPedHeadOverlayData(ped, 9)
            local _, ChestHairStyle, _, ChestHairFirstColor, ChestHairSecondColor, ChestHairOpacity = GetPedHeadOverlayData(ped, 10)
            local _, BodyBlemishesStyle, _, _, _, BodyBlemishesOpacity = GetPedHeadOverlayData(ped, 11)
            local _, AddBodyBlemishesStyle, _, _, _, AddBodyBlemishesOpacity = GetPedHeadOverlayData(ped, 12)

            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'BlemishesStyle', BlemishesStyle )
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'BlemishesOpacity', BlemishesOpacity)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'FacialHairStyle', FacialHairStyle)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'FacialHairFirstColor', FacialHairFirstColor)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'FacialHairSecondColor', FacialHairSecondColor)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'FacialHairOpacity', FacialHairOpacity)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'EyebrowsStyle', EyebrowsStyle)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'EyebrowsFirstColor', EyebrowsFirstColor)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'EyebrowsSecondColor', EyebrowsSecondColor)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'EyebrowsOpacity', EyebrowsOpacity)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'AgeingStyle', AgeingStyle)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'AgeingOpacity', AgeingOpacity)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'MakeupStyle', MakeupStyle)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'MakeupFirstColor', MakeupFirstColor)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'MakeupSecondColor', MakeupSecondColor)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'MakeupOpacity', MakeupOpacity)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'BlushStyle', BlushStyle)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'BlushFirstColor', BlushFirstColor)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'BlushSecondColor', BlushSecondColor)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'BlushOpacity', BlushOpacity)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'ComplexionStyle', ComplexionStyle)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'ComplexionOpacity', ComplexionOpacity)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'SunDamageStyle', SunDamageStyle)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'SunDamageOpacity', SunDamageOpacity)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'LipstickStyle', LipstickStyle)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'LipstickFirstColor', LipstickFirstColor)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'LipstickSecondColor', LipstickSecondColor)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'LipstickOpacity', LipstickOpacity)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'MolesStyle', MolesStyle)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'MolesOpacity', MolesOpacity)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'ChestHairStyle', ChestHairStyle)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'ChestHairFirstColor', ChestHairFirstColor)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'ChestHairSecondColor', ChestHairSecondColor)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'ChestHairOpacity', ChestHairOpacity)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'BodyBlemishesStyle', BodyBlemishesStyle)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'BodyBlemishesOpacity', BodyBlemishesOpacity)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'AddBodyBlemishesStyle', AddBodyBlemishesStyle)
            TriggerServerEvent('ssv:SyncPedData', pedid, 'Appearance', 'AddBodyBlemishesOpacity', AddBodyBlemishesOpacity)

            TriggerServerEvent('ssv:SyncPedData', pedid, '', 'RandomLooks', false)
        else
            SetPedHeadBlendData(ped, peddata.PedVisualData.Inheritance.FirstShapeID, peddata.PedVisualData.Inheritance.SecondShapeID, peddata.PedVisualData.Inheritance.ThirdShapeID, peddata.PedVisualData.Inheritance.FirstSkinID, peddata.PedVisualData.Inheritance.SecondSkinID, peddata.PedVisualData.Inheritance.ThirdSkinID, peddata.PedVisualData.Inheritance.shapeMix, peddata.PedVisualData.Inheritance.skinMix, peddata.PedVisualData.Inheritance.thirdMix, peddata.PedVisualData.Inheritance.isParentBool)
            
            SetPedFaceFeature(ped, 0, peddata.PedVisualData.FaceFeatures.NoseWidth)
            SetPedFaceFeature(ped, 1, peddata.PedVisualData.FaceFeatures.NosePeakHeight)
            SetPedFaceFeature(ped, 2, peddata.PedVisualData.FaceFeatures.NosePeakLength)
            SetPedFaceFeature(ped, 3, peddata.PedVisualData.FaceFeatures.NoseBoneHeight)
            SetPedFaceFeature(ped, 4, peddata.PedVisualData.FaceFeatures.NosePeakLowering)
            SetPedFaceFeature(ped, 5, peddata.PedVisualData.FaceFeatures.NoseBoneTwist)
            SetPedFaceFeature(ped, 6, peddata.PedVisualData.FaceFeatures.EyeBrowHeight)
            SetPedFaceFeature(ped, 7, peddata.PedVisualData.FaceFeatures.EyeBrowForward)
            SetPedFaceFeature(ped, 8, peddata.PedVisualData.FaceFeatures.CheeksBoneHeight)
            SetPedFaceFeature(ped, 9, peddata.PedVisualData.FaceFeatures.CheeksBoneWidth)
            SetPedFaceFeature(ped, 10, peddata.PedVisualData.FaceFeatures.CheeksWidth)
            SetPedFaceFeature(ped, 11, peddata.PedVisualData.FaceFeatures.EyesOpening)
            SetPedFaceFeature(ped, 12, peddata.PedVisualData.FaceFeatures.LipsThickness)
            SetPedFaceFeature(ped, 13, peddata.PedVisualData.FaceFeatures.JawBoneWidth)
            SetPedFaceFeature(ped, 14, peddata.PedVisualData.FaceFeatures.JawBoneBackLength)
            SetPedFaceFeature(ped, 15, peddata.PedVisualData.FaceFeatures.ChimpBoneLower)
            SetPedFaceFeature(ped, 16, peddata.PedVisualData.FaceFeatures.ChimpBoneLength)
            SetPedFaceFeature(ped, 17, peddata.PedVisualData.FaceFeatures.ChimpBoneWidth)
            SetPedFaceFeature(ped, 18, peddata.PedVisualData.FaceFeatures.ChimpHole)
            SetPedFaceFeature(ped, 19, peddata.PedVisualData.FaceFeatures.NeckThickness)

            SetPedHairTint(ped, peddata.PedVisualData.Appearance.HairColor, peddata.PedVisualData.Appearance.HairHighlightColor)
            SetPedEyeColor(ped, peddata.PedVisualData.Appearance.EyeColor)

            SetPedHeadOverlay(ped, 0, peddata.PedVisualData.Appearance.BlemishesStyle, peddata.PedVisualData.Appearance.BlemishesOpacity)
            SetPedHeadOverlay(ped, 1, peddata.PedVisualData.Appearance.FacialHairStyle, peddata.PedVisualData.Appearance.FacialHairOpacity)
            SetPedHeadOverlayColor(ped, 1, 1, peddata.PedVisualData.Appearance.FacialHairFirstColor , peddata.PedVisualData.Appearance.FacialHairSecondColor)
            SetPedHeadOverlay(ped, 2, peddata.PedVisualData.Appearance.EyebrowsStyle , peddata.PedVisualData.Appearance.EyebrowsOpacity)
            SetPedHeadOverlayColor(ped, 2, 1, peddata.PedVisualData.Appearance.EyebrowsFirstColor, peddata.PedVisualData.Appearance.EyebrowsSecondColor)
            SetPedHeadOverlay(ped, 3, peddata.PedVisualData.Appearance.AgeingStyle , peddata.PedVisualData.Appearance.AgeingOpacity)
            SetPedHeadOverlay(ped, 4, peddata.PedVisualData.Appearance.MakeupStyle , peddata.PedVisualData.Appearance.MakeupOpacity)
            SetPedHeadOverlayColor(ped, 4, 1, peddata.PedVisualData.Appearance.MakeupFirstColor, peddata.PedVisualData.Appearance.MakeupSecondColor)            
            SetPedHeadOverlay(ped, 5, peddata.PedVisualData.Appearance.BlushStyle , peddata.PedVisualData.Appearance.BlushOpacity)
            SetPedHeadOverlayColor(ped, 5, 2, peddata.PedVisualData.Appearance.BlushFirstColor, peddata.PedVisualData.Appearance.BlushSecondColor)            
            SetPedHeadOverlay(ped, 6, peddata.PedVisualData.Appearance.ComplexionStyle , peddata.PedVisualData.Appearance.ComplexionOpacity)
            SetPedHeadOverlay(ped, 7, peddata.PedVisualData.Appearance.SunDamageStyle , peddata.PedVisualData.Appearance.SunDamageOpacity)
            SetPedHeadOverlay(ped, 8, peddata.PedVisualData.Appearance.LipstickStyle , peddata.PedVisualData.Appearance.LipstickOpacity)
            SetPedHeadOverlayColor(ped, 8, 2, peddata.PedVisualData.Appearance.LipstickFirstColor, peddata.PedVisualData.Appearance.LipstickSecondColor)            
            SetPedHeadOverlay(ped, 9, peddata.PedVisualData.Appearance.MolesStyle , peddata.PedVisualData.Appearance.MolesOpacity)
            SetPedHeadOverlay(ped, 10, peddata.PedVisualData.Appearance.ChestHairStyle , peddata.PedVisualData.Appearance.ChestHairOpacity)
            SetPedHeadOverlayColor(ped, 10, 1, peddata.PedVisualData.Appearance.ChestHairFirstColor, peddata.PedVisualData.Appearance.ChestHairSecondColor)            
            SetPedHeadOverlay(ped, 11, peddata.PedVisualData.Appearance.BodyBlemishesStyle , peddata.PedVisualData.Appearance.BodyBlemishesOpacity)
            SetPedHeadOverlay(ped, 12, peddata.PedVisualData.Appearance.AddBodyBlemishesStyle , peddata.PedVisualData.Appearance.AddBodyBlemishesOpacity)

        end
    end

    if peddata.RandomLooks then
        for i=0,11 do -- component loop
            local drawableVars = GetNumberOfPedDrawableVariations(ped, i)
            if drawableVars ~= 0 then
                local component = {i, GetPedDrawableVariation(ped, i), GetPedTextureVariation(ped, i), GetPedPaletteVariation(ped, i)}
                TriggerServerEvent('ssv:SyncPedData', pedid, 'Component', i, component)
            end
        end
        for i=0,12 do -- prop loop
            local propVars = GetNumberOfPedPropDrawableVariations(ped, i)
            if propVars ~= 0 then
                local prop = {i, GetPedPropIndex(ped, i), GetPedPropTextureIndex(ped, i), true}
                TriggerServerEvent('ssv:SyncPedData', pedid, 'Prop', i, prop)
            end
        end

        TriggerServerEvent('ssv:SyncPedData', pedid, '', 'RandomLooks', false)
    else
        for i, component in pairs(peddata.PedVisualData.Components) do
            SetPedComponentVariation(ped, component[1], component[2], component[3], component[4])
        end
        for i, prop in pairs(peddata.PedVisualData.Props) do
            if prop[2] == 255 then
                ClearPedProp(ped, prop[1])
            else
                SetPedPropIndex(ped, prop[1], prop[2], prop[3], prop[4])
            end
        end

    end

    return true
end

function scl_ApplyAllVehProperties(vehid, vehdata)
    local VehNetID = vehdata.VehNetID
    local veh = NetToVeh(VehNetID)

    if not vehdata.CheckedTyres then
        local tyrei = {0, 1, 2, 3, 4, 5, 6, 7, 8, 45, 47}
        local ExistingTyres = {}
        for i, number in ipairs(tyrei) do
            if DoesVehicleTyreExist(veh, number) then
                table.insert(ExistingTyres, number)
            end
        end
        TriggerServerEvent('ssv:SyncVehData', vehid, 'ExistingTyres', '', ExistingTyres)
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'CheckedTyres', true)
        vehdata.ExistingTyres = ExistingTyres
        vehdata.CheckedTyres = true
    end

    
    if not vehdata.CheckedDoors then
        local doori = {0,1,2,3,4,5}
        local ExistingDoors = {}
        for i, number in ipairs(doori) do
            if GetIsDoorValid(veh, number) then
                table.insert(ExistingDoors, number)
            end
        end
        TriggerServerEvent('ssv:SyncVehData', vehid, 'ExistingDoors', '', ExistingDoors)
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'CheckedDoors', true)
        vehdata.ExistingDoors = ExistingDoors
        vehdata.CheckedDoors = true
    end

    if vehdata.RandomSpawn then
        for i=1,14 do
            if DoesExtraExist(veh, i) then
                local IsOn = 1
                if IsVehicleExtraTurnedOn(veh, i) then
                    IsOn = 0
                end
                TriggerServerEvent('ssv:SyncVehData', vehid, 'VehicleExtra', i, IsOn)
            end
        end

        local ColorCombination = GetVehicleColourCombination(veh)
        if ColorCombination ~= -1 and ColorCombination ~= 0 then
            TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'IsColorCombination', true)
            TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'ColorCombination', ColorCombination)
        else
            local PrimaryColorCustom = GetIsVehiclePrimaryColourCustom(veh)
            if PrimaryColorCustom then
                TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'PrimaryColorCustom', true)
                local cr, cg, cb = GetVehicleCustomPrimaryColour(veh)
                local PrimaryColor = {r = cr, g = cg, b = cb}
                TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'PrimaryColor', PrimaryColor)
            else
                local PrimaryColor, SecondaryColor = GetVehicleColours(veh)
                TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'PrimaryColor', PrimaryColor)
            end

            local SecondaryColorCustom = GetIsVehicleSecondaryColourCustom(veh)
            if SecondaryColorCustom then
                TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'SecondaryColorCustom', true)
                local cr, cg, cb = GetVehicleCustomSecondaryColour(veh)
                local SecondaryColor = {r = cr, g = cg, b = cb}
                TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'SecondaryColor', SecondaryColor)
            else
                local PrimaryColor, SecondaryColor = GetVehicleColours(veh)
                TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'SecondaryColor', SecondaryColor)
            end
        end

        TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'DashboardColor', GetVehicleDashboardColor(veh))
        local pearlColorTemp, wheelColorTemp = GetVehicleExtraColours(veh)
        local ExtraColors = {pearlColor = pearlColorTemp, wheelColor = wheelColorTemp}
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'ExtraColors', ExtraColors)
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'InteriorColor', GetVehicleInteriorColor(veh))
        local paintTypeTemp, colorTemp, pearlescentColorTemp = GetVehicleModColor_1(veh)
        local ModColor1 = {paintType = paintTypeTemp, color = colorTemp, pearlescentColor = pearlescentColorTemp}
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'ModColor1', ModColor1)
        local paintTypeTemp, colorTemp = GetVehicleModColor_2(veh)
        local ModColor2 = {paintType = paintTypeTemp, color = colorTemp}
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'ModColor2', ModColor2)

        local NeonLightsEnabled = {}
        for i=0,3 do
            if IsVehicleNeonLightEnabled(veh, i) then
                NeonLightsEnabled[i] = true
            else
                NeonLightsEnabled[i] = false
            end
        end
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'NeonLightsEnabled', NeonLightsEnabled)
        local cr, cg, cb = GetVehicleNeonLightsColour(veh)
        local NeonLightsColor = {r = cr, g = cg, b = cb}
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'NeonLightsColor', NeonLightsColor)

        local cr, cg, cb = GetVehicleTyreSmokeColor(veh)
        local TyreSmokeColor = {r = cr, g = cg, b = cb}
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'TyreSmokeColor', TyreSmokeColor)
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'XenonLightsColor', GetVehicleXenonLightsColor(veh))
        
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'Livery', GetVehicleLivery(veh))
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Color', 'RoofLivery', GetVehicleRoofLivery(veh))

        local _, lights, highbeams = GetVehicleLightsState(veh)
        local HeadlightsState = 0
        if highbeams then
            HeadlightsState = 2
        elseif lights then
            HeadlightsState = 1
        end
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Lights', 'HeadlightsState', HeadlightsState)

        if DoesVehicleHaveSearchlight(veh) then
            TriggerServerEvent('ssv:SyncVehData', vehid, 'Lights', 'Searchlight', 'Off')
        end
        
        if IsVehicleInteriorLightOn(veh) then
            TriggerServerEvent('ssv:SyncVehData', vehid, 'Lights', 'InteriorLight', true)
        end

        local Indicators = GetVehicleIndicatorLights(veh)
        if Indicators == 3 then
            TriggerServerEvent('ssv:SyncVehData', vehid, 'Lights', 'IndicatorLeft', true)
            TriggerServerEvent('ssv:SyncVehData', vehid, 'Lights', 'IndicatorRight', true)
        elseif Indicators == 2 then
            TriggerServerEvent('ssv:SyncVehData', vehid, 'Lights', 'IndicatorRight', true)
        elseif Indicators == 1 then
            TriggerServerEvent('ssv:SyncVehData', vehid, 'Lights', 'IndicatorLeft', true)
        end

        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'WindowTint', GetVehicleWindowTint(veh))

        local ConvertibleRoof = IsVehicleAConvertible(veh, false)
        if ConvertibleRoof then
            local State = GetConvertibleRoofState(veh)
            while State == 4 do
                local i = 0
                Wait(100)
                State = GetConvertibleRoofState(veh)
                if i > 10 then
                    break
                end
            end
            if State == 0 or State == 3 or State == 5 then
                TriggerServerEvent('ssv:SyncVehData', vehid, '', 'ConvertibleRoof', 'Closed')
                for i=0,7 do
                    RollUpWindow(veh, i)
                    TriggerServerEvent('ssv:SyncVehData', vehid, 'WindowStatus', i, 'Up')
                end
            elseif State == 1 or State == 2 or State == 6 then
                TriggerServerEvent('ssv:SyncVehData', vehid, '', 'ConvertibleRoof', 'Open')
                for i=0,5 do
                    TriggerServerEvent('ssv:SyncVehData', vehid, 'WindowStatus', i, 'Down')
                    RollDownWindow(veh, i)
                end
                TriggerServerEvent('ssv:SyncVehData', vehid, 'WindowStatus', 7, 'Down')
                RollDownWindow(veh, 7)
                TriggerServerEvent('ssv:SyncVehData', vehid, 'WindowStatus', 6, 'Up')
                RollUpWindow(veh, 6)
            end
        elseif IsVehicleAConvertible(veh, true) then
            TriggerServerEvent('ssv:SyncVehData', vehid, '', 'ConvertibleRoof', 'Fixed')
            for i=0,7 do
                RollUpWindow(veh, i)
                TriggerServerEvent('ssv:SyncVehData', vehid, 'WindowStatus', i, 'Up')
            end
        else
            TriggerServerEvent('ssv:SyncVehData', vehid, '', 'ConvertibleRoof', false)
            for i=0,7 do
                RollUpWindow(veh, i)
                TriggerServerEvent('ssv:SyncVehData', vehid, 'WindowStatus', i, 'Up')
            end
        end

        local DoorCanBreak = {}
        local DoorsStatus = {}
        for i, doori in ipairs(vehdata.ExistingDoors) do
            DoorCanBreak[doori] = true
            DoorsStatus[doori] = "Closed"
        end
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'DoorCanBreak', DoorCanBreak)
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'DoorsStatus', DoorsStatus)
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'DoorLockStatus', GetVehicleDoorLockStatus(veh))
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'TyreInvincible', GetVehicleTyresCanBurst(veh))
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'WheelsCanBreak', false)
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'WheelsCanBreakBlow', false)
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'WheelsCanDeform', false)

        local TyreDamage = {}
        local TyreHealth = {}
        local WheelDamage = {}
        local WheelHealth = {}
        for i, tyrei in ipairs(vehdata.ExistingTyres) do
            TyreHealth[tyrei] = GetTyreHealth(veh, tyrei)
            if IsVehicleTyreBurst(veh, tyrei, true) then
                TyreDamage[tyrei] = "Destroyed"
            elseif IsVehicleTyreBurst(veh, tyrei, true) then
                TyreDamage[tyrei] = "Flat"
            else
                TyreDamage[tyrei] = false
            end
            WheelHealth[tyrei] = GetVehicleWheelHealth(veh, tyrei)
            WheelDamage[tyrei] = false
        end

        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'TyreDamage', TyreDamage)
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'TyreHealth', TyreHealth)
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'WheelDamage', WheelDamage)
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'WheelHealth', WheelHealth)

        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'HasDriftTyres', GetDriftTyresEnabled(veh))

        local Tuning = {}
        for modType = 0,49 do
            Tuning[modType] = GetVehicleMod(veh, modType)
        end
        TriggerServerEvent('ssv:SyncVehData', vehid, 'TuningInit', 'Tuning', Tuning)
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Wheel', 'CustomWheel', GetVehicleModVariation(veh, 23))
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Wheel', 'CustomWheelHydraulics', GetVehicleModVariation(veh, 24))
        TriggerServerEvent('ssv:SyncVehData', vehid, 'Wheel', 'WheelType', GetVehicleWheelType(veh))

        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'VehicleFuelLevel', GetVehicleFuelLevel(veh))
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'VehicleBodyHealth', GetVehicleBodyHealth(veh))
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'VehicleEngineHealth', GetVehicleEngineHealth(veh))
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'VehiclePetrolTankHealth', GetVehiclePetrolTankHealth(veh))
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'VehicleDirtLevel', GetVehicleDirtLevel(veh))

        -- get hydraulics, deformation (the latter one only after figuring out how to track this properly)
        TriggerServerEvent('ssv:SyncVehData', vehid, '', 'RandomSpawn', false)
    else
        for Extra, isOn in pairs(vehdata.VehicleMods.Extras) do
            SetVehicleExtra(veh, Extra, isOn)
        end


        SetVehicleModColor_1(veh, vehdata.Color.ModColor1.paintType, vehdata.Color.ModColor1.color, vehdata.Color.ModColor1.pearlescentColor)
        SetVehicleModColor_2(veh, vehdata.Color.ModColor2.paintType, vehdata.Color.ModColor2.color)
        SetVehicleExtraColours(veh, vehdata.Color.ExtraColors.pearlColor, vehdata.Color.ExtraColors.wheelColor)

        if vehdata.Color.IsColorCombination then
            SetVehicleColourCombination(veh, vehdata.Color.ColorCombination)
        else
            if vehdata.Color.PrimaryColorCustom and vehdata.Color.SecondaryColorCustom then
                SetVehicleCustomPrimaryColour(veh, vehdata.Color.PrimaryColor.r, vehdata.Color.PrimaryColor.g, vehdata.Color.PrimaryColor.b)
                SetVehicleCustomSecondaryColour(veh, vehdata.Color.SecondaryColor.r, vehdata.Color.SecondaryColor.g, vehdata.Color.SecondaryColor.b)
            elseif vehdata.Color.PrimaryColorCustom then
                SetVehicleColours(veh, 0, vehdata.Color.SecondaryColor)
                SetVehicleCustomPrimaryColour(veh, vehdata.Color.PrimaryColor.r, vehdata.Color.PrimaryColor.g, vehdata.Color.PrimaryColor.b)
            elseif vehdata.Color.SecondaryColorCustom then
                SetVehicleColours(veh, vehdata.Color.PrimaryColor, 0)
                SetVehicleCustomSecondaryColour(veh, vehdata.Color.SecondaryColor.r, vehdata.Color.SecondaryColor.g, vehdata.Color.SecondaryColor.b)
            else
                SetVehicleColours(veh, vehdata.Color.PrimaryColor, vehdata.Color.SecondaryColor)
            end            
        end

        SetVehicleDashboardColor(veh, vehdata.Color.DashboardColor)
        SetVehicleInteriorColor(veh, vehdata.Color.InteriorColor)


        for NeonPosition, isOn in pairs(vehdata.Color.NeonLightsEnabled) do
            SetVehicleNeonLightEnabled(veh, NeonPosition, isOn)
        end

        SetVehicleNeonLightsColour(veh, vehdata.Color.NeonLightsColor.r, vehdata.Color.NeonLightsColor.g, vehdata.Color.NeonLightsColor.b)
        SetVehicleTyreSmokeColor(veh, vehdata.Color.TyreSmokeColor.r, vehdata.Color.TyreSmokeColor.g, vehdata.Color.TyreSmokeColor.b)
        SetVehicleXenonLightsColor(veh, vehdata.Color.XenonLightsColor)

        SetVehicleLivery(veh, vehdata.Color.Livery)
        SetVehicleRoofLivery(veh, vehdata.Color.RoofLivery)

        if DoesVehicleHaveSearchlight(veh) then
            if vehdata.Searchlight == 'On' then
                SetVehicleSearchlight(veh, true, true)
            end
        elseif vehdata.Searchlight == 'On' or vehdata.Searchlight == 'Off' then
            TriggerServerEvent('ssv:SyncVehData', SID, 'Lights', 'Searchlight', false)
        end

        SetVehicleInteriorlight(veh, vehdata.Lights.InteriorLight)
        SetVehicleIndicatorLights(veh, 1, vehdata.Lights.IndicatorLeft)
        SetVehicleIndicatorLights(veh, 0, vehdata.Lights.IndicatorRight)

        SetVehicleWindowTint(veh, vehdata.WindowTint)

        if IsVehicleAConvertible(veh, false) then
            if vehdata.ConvertibleRoof == 'Open' then
                LowerConvertibleRoof(veh, true)
            elseif vehdata.ConvertibleRoof == 'Closed' then
                RaiseConvertibleRoof(veh, true)
            end
        else
            if vehdata.ConvertibleRoof == 'Open' or vehdata.ConvertibleRoof == 'Closed' then
                if IsVehicleAConvertible(veh, true) then
                    TriggerServerEvent('ssv:SyncVehData', SID, '', 'ConvertibleRoof', 'Fixed')
                else
                    TriggerServerEvent('ssv:SyncVehData', SID, '', 'ConvertibleRoof', false)
                end
            end
        end

        for i, Window in pairs(vehdata.WindowStatus) do
            if Window == 'Up' then
                RollUpWindow(veh, i)
            elseif Window == 'Down' then
                RollDownWindow(veh, i)
            elseif Window == 'Smashed' then
                RemoveVehicleWindow(veh, i)
            end
        end

        SetVehicleWheelType(veh, vehdata.VehicleMods.WheelType)
        for modType, modIndex in pairs(vehdata.VehicleMods.Tuning) do
            if modType == 23 then
                SetVehicleMod(veh, modType, modIndex, vehdata.VehicleMods.CustomWheel)
            elseif modType == 24 then
                SetVehicleMod(veh, modType, modIndex, vehdata.VehicleMods.CustomWheelHydraulics)
            else
                SetVehicleMod(veh, modType, modIndex, false)
            end
        end

        SetDriftTyresEnabled(veh, vehdata.HasDriftTyres)
        SetVehicleBodyHealth(veh, vehdata.VehicleBodyHealth)
        SetVehicleEngineHealth(veh, vehdata.VehicleEngineHealth)
        SetVehiclePetrolTankHealth(veh, vehdata.VehiclePetrolTankHealth)
        SetVehicleFuelLevel(veh, vehdata.VehicleFuelLevel)

        if vehdata.TyreInvincible then
            SetVehicleTyresCanBurst(veh, false)
            SetVehicleCanDeformWheels(veh, false)
            SetVehicleWheelsCanBreak(veh, false)
            SetVehicleWheelsCanBreakOffWhenBlowUp(veh, false)
        else
            SetVehicleTyresCanBurst(veh, true)
            SetVehicleCanDeformWheels(veh, vehdata.WheelsCanDeform)
            SetVehicleWheelsCanBreak(veh, vehdata.WheelsCanBreak)
            SetVehicleWheelsCanBreakOffWhenBlowUp(veh, vehdata.WheelsCanBreakBlow)
            for tyrei, health in pairs(TyreHealth) do
                SetTyreHealth(veh, tyrei, health)
            end
            for wheeli, health in pairs(WheelHealth) do
                SetVehicleWheelHealth(veh, wheeli, health)
            end
            for tyrei, damage in pairs(TyreDamage) do
                if damage == 'Flat' then
                    SetVehicleTyreBurst(veh, tyrei, false, 0)
                elseif damage == 'Destroyed' then
                    SetVehicleTyreBurst(veh, tyrei, true, 1000)
                end
            end
            for wheeli, damage in pairs(WheelDamage) do
                if damage == 'Broken' then
                    BreakOffVehicleWheel(veh, wheeli, false, true, false, false)
                end
            end

        end

        for doori, DoorInv in pairs(vehdata.DoorCanBreak) do
            SetVehicleDoorCanBreak(veh, doori, DoorInv)
        end

        SetVehicleDoorsLocked(veh, vehdata.DoorLockStatus)
        for doori, DoorStatus in pairs(vehdata.DoorsStatus) do
            if DoorStatus == "Closed" then
                SetVehicleDoorShut(veh, doori, true)
            elseif DoorStatus == "Open" then
                SetVehicleDoorOpen(veh, doori, false, true)
            elseif DoorStatus == "Loose" then
                SetVehicleDoorOpen(veh, doori, true, true)
            elseif DoorStatus == "Broken" then
                SetVehicleDoorBroken(veh, doori, true)
            end
        end

        SetVehicleDirtLevel(veh, vehdata.VehicleDirtLevel)
        SetVehicleUndriveable(veh, vehdata.IsUndrivable)

        if vehdata.IsExploded then
            NetworkExplodeVehicle(veh, false, true, 0)
            StopEntityFire(veh)
        end
        -- apply Hydraulics, Deformation
    end
    return true
end

function scl_ApplyPedBehaviorFlags(pedid, peddata)
    local PedNetID = peddata.PedNetID
    local ped = NetToPed(PedNetID)
    
    SetBlockingOfNonTemporaryEvents(ped, peddata.BlockNonTemporaryEvents)
    SetPedRelationshipGroupHash(ped, GetHashKey(peddata.PedRelationshipGroup))

    return true
end

function Notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, false)
end