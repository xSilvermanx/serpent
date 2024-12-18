-- Get functions are QoL but you can get all the data already by loading the whole list and searching manually
-- as such: No priority for these functions. Might be done later

--[[
GetPedHeadBlendData
GetPedFaceFeature
GetPedHairColor
GetPedHairHighlightColor
GetPedEyeColor
GetPedHeadOverlayData
GetPedComponentVariation -- Combination of GetPedDrawableVariation, GetPedTextureVariation, GetPedPaletteVariation
GetPedPropVariation -- Combination of GetPedPropIndex, GetPedPropTextureIndex
]]

-- SetEntityHealth
-- SetPedArmour


function ssv_nat_SetPedHeadBlendData(SID, FirstFaceShape, SecondFaceShape, ThirdFaceShape, FirstSkinTone, SecondSkinTone, ThirdSkinTone, ParentFaceShapePercent, ParentSkinTonePercent, ParentThirdUnkPercent, IsParentInheritance)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Inheritance', 'FirstShapeID', FirstFaceShape)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Inheritance', 'SecondShapeID', SecondFaceShape)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Inheritance', 'ThirdShapeID', ThirdFaceShape)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Inheritance', 'FirstSkinID', FirstSkinTone)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Inheritance', 'SecondSkinID', SecondSkinTone)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Inheritance', 'ThirdSkinID', ThirdSkinTone)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Inheritance', 'shapeMix', ParentFaceShapePercent)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Inheritance', 'skinMix', ParentSkinTonePercent)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Inheritance', 'thirdMix', ParentThirdUnkPercent)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Inheritance', 'isParentBool', IsParentInheritance)

    if ssv_PedList[SID].IsSpawnedBool then
        local PedNetID = ssv_PedList[SID].PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)
        TriggerServerEvent('ssv:SyncPedData', SID, '', 'ScriptOwnerNetID', OwnerID)
        TriggerClientEvent('scl:nat:res:SetPedHeadBlendData', ssv_PedList[SID].ScriptOwnerNetID, ssv_PedList[SID].PedNetID, FirstFaceShape, SecondFaceShape, ThirdFaceShape, FirstSkinTone, SecondSkinTone, ParentFaceShapePercent, ParentSkinTonePercent, ParentThirdUnkPercent, IsParentInheritance)
    end

end

function ssv_nat_SetPedFaceFeature(SID, index, scale)
    local FeatureNames = {
        [0] = 'NoseWidth',
        [1] = 'NosePeakHeight',
        [2] = 'NosePeakLength',
        [3] = 'NoseBoneHeight',
        [4] = 'NosePeakLowering',
        [5] = 'NoseBoneTwist',
        [6] = 'EyeBrowHeight',
        [7] = 'EyeBrowForward',
        [8] = 'CheeksBoneHeight',
        [9] = 'CheeksBoneWidth',
        [10] = 'CheeksWidth',
        [11] = 'EyesOpening',
        [12] = 'LipsThickness',
        [13] = 'JawBoneWidth',
        [14] = 'JawBoneBackLength',
        [15] = 'ChimpBoneLower',
        [16] = 'ChimpBoneLength',
        [17] = 'ChimpBoneWidth',
        [18] = 'ChimpHole',
        [19] = 'NeckThickness',
    }
   
    TriggerServerEvent('ssv:SyncPedData', SID, 'FaceFeature', FeatureNames[index], scale)

    if ssv_PedList[SID].IsSpawnedBool then
        local PedNetID = ssv_PedList[SID].PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)
        TriggerServerEvent('ssv:SyncPedData', SID, '', 'ScriptOwnerNetID', OwnerID)
        TriggerClientEvent('scl:nat:res:SetPedFaceFeature', ssv_PedList[SID].ScriptOwnerNetID, ssv_PedList[SID].PedNetID, index, scale)
    end
end

function ssv_nat_SetPedHairTint(SID, colorID, highlightID)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Appearance', 'HairColor', colorID)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Appearance', 'HairHightlightColor', highlightID)

    if ssv_PedList[SID].IsSpawnedBool then
        local PedNetID = ssv_PedList[SID].PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)
        TriggerServerEvent('ssv:SyncPedData', SID, '', 'ScriptOwnerNetID', OwnerID)
        TriggerClientEvent('scl:nat:res:SetPedHairTint', ssv_PedList[SID].ScriptOwnerNetID, ssv_PedList[SID].PedNetID, colorID, highlightID)
    end
end

function ssv_nat_SetPedEyeColor(SID, index)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Appearance', 'EyeColor', index)

    if ssv_PedList[SID].IsSpawnedBool then
        local PedNetID = ssv_PedList[SID].PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)
        TriggerServerEvent('ssv:SyncPedData', SID, '', 'ScriptOwnerNetID', OwnerID)
        TriggerClientEvent('scl:nat:res:SetPedEyeColor', ssv_PedList[SID].ScriptOwnerNetID, ssv_PedList[SID].PedNetID, index)
    end
end

function ssv_nat_SetPedHeadOverlay(SID, overlayID, index, opacity)
    local FeatureNames = {
        [0] = 'Blemishes',
        [1] = 'FacialHair',
        [2] = 'Eyebrows',
        [3] = 'Ageing',
        [4] = 'Makeup',
        [5] = 'Blush',
        [6] = 'Complexion',
        [7] = 'SunDamage',
        [8] = 'Lipstick',
        [9] = 'Moles',
        [10] = 'ChestHair',
        [11] = 'BodyBlemishes',
        [12] = 'AddBodyBlemishes',
    }

    local Style = FeatureNames[overlayID] + 'Style'
    local Opacity = FeatureNames[overlayID] + 'Opacity'

    TriggerServerEvent('ssv:SyncPedData', SID, 'Appearance', Style, index)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Appearance', Opacity, opacity)

    if ssv_PedList[SID].IsSpawnedBool then
        local PedNetID = ssv_PedList[SID].PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)
        TriggerServerEvent('ssv:SyncPedData', SID, '', 'ScriptOwnerNetID', OwnerID)
        TriggerClientEvent('scl:nat:res:SetPedHeadOverlay', ssv_PedList[SID].ScriptOwnerNetID, ssv_PedList[SID].PedNetID, overlayID, index, opacity)
    end
end

function ssv_nat_SetPedHeadOverlayColor(SID, overlayID, colorType, colorID, secondColorID)
    local FeatureNames = {
        [0] = 'Blemishes',
        [1] = 'FacialHair',
        [2] = 'Eyebrows',
        [3] = 'Ageing',
        [4] = 'Makeup',
        [5] = 'Blush',
        [6] = 'Complexion',
        [7] = 'SunDamage',
        [8] = 'Lipstick',
        [9] = 'Moles',
        [10] = 'ChestHair',
        [11] = 'BodyBlemishes',
        [12] = 'AddBodyBlemishes',
    }

    local FirstColor = FeatureNames[overlayID] + 'FirstColor'
    local SecondColor = FeatureNames[overlayID] + 'SecondColor'

    TriggerServerEvent('ssv:SyncPedData', SID, 'Appearance', FirstColor, colorID)
    TriggerServerEvent('ssv:SyncPedData', SID, 'Appearance', SecondColor, secondColorID)

    if ssv_PedList[SID].IsSpawnedBool then
        local PedNetID = ssv_PedList[SID].PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)
        TriggerServerEvent('ssv:SyncPedData', SID, '', 'ScriptOwnerNetID', OwnerID)
        TriggerClientEvent('scl:nat:res:SetPedHeadOverlayColor', ssv_PedList[SID].ScriptOwnerNetID, ssv_PedList[SID].PedNetID, overlayID, colorType, colorID, secondColorID)
    end
end

function ssv_nat_SetPedComponentVariation(SID, componentID, drawableID, textureID, paletteID)

    local component = {componentID, drawableID, textureID, paletteID}
    TriggerServerEvent('ssv:SyncPedData', SID, 'Component', componentID, component)

    if ssv_PedList[SID].IsSpawnedBool then
        local PedNetID = ssv_PedList[SID].PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)
        TriggerServerEvent('ssv:SyncPedData', SID, '', 'ScriptOwnerNetID', OwnerID)
        TriggerClientEvent('scl:nat:res:SetPedComponentVariation', ssv_PedList[SID].ScriptOwnerNetID, ssv_PedList[SID].PedNetID, componentID, drawableID, textureID, paletteID)
    end
end

-- also handles ClearPedProp - set drawableID = 255 to clear the prop
function ssv_nat_SetPedPropIndex(SID, componentID, drawableID, textureID, attach)

    local prop = {componentID, drawableID, textureID, attach}
    TriggerServerEvent('ssv:SyncPedData', SID, 'Prop', componentID, prop)

    if ssv_PedList[SID].IsSpawnedBool then
        local PedNetID = ssv_PedList[SID].PedNetID
        local ped = NetworkGetEntityFromNetworkId(PedNetID)
        local OwnerID = NetworkGetEntityOwner(ped)
        TriggerServerEvent('ssv:SyncPedData', SID, '', 'ScriptOwnerNetID', OwnerID)
        TriggerClientEvent('scl:nat:res:SetPedPropIndex', ssv_PedList[SID].ScriptOwnerNetID, ssv_PedList[SID].PedNetID, componentID, drawableID, textureID, attach)
    end
end