RegisterNetEvent('scl:nat:res:SetPedHeadBlendData')
AddEventHandler('scl:nat:res:SetPedHeadBlendData', function(PedNetID, FirstFaceShape, SecondFaceShape, ThirdFaceShape, FirstSkinTone, SecondSkinTone, ParentFaceShapePercent, ParentSkinTonePercent, ParentThirdUnkPercent, IsParentInheritance)
    local ped = NetToPed(PedNetID)
    SetPedHeadBlendData(ped, FirstFaceShape, SecondFaceShape, ThirdFaceShape, FirstSkinTone, SecondSkinTone, ParentFaceShapePercent, ParentSkinTonePercent, ParentThirdUnkPercent, IsParentInheritance)
end)

RegisterNetEvent('scl:nat:res:SetPedFaceFeature')
AddEventHandler('scl:nat:res:SetPedFaceFeature', function(PedNetID, index, scale)
    local ped = NetToPed(PedNetID)
    SetPedFaceFeature(ped, index, scale)
end)

RegisterNetEvent('scl:nat:res:SetPedHairTint')
AddEventHandler('scl:nat:res:SetPedHairTint', function(PedNetID, colorID, highlightID)
    local ped = NetToPed(PedNetID)
    SetPedHairTint(ped, colorID, highlightID)
end)

RegisterNetEvent('scl:nat:res:SetPedEyeColor')
AddEventHandler('scl:nat:res:SetPedEyeColor', function(PedNetID, index)
    local ped = NetToPed(PedNetID)
    SetPedEyeColor(ped, index)
end)

RegisterNetEvent('scl:nat:res:SetPedHeadOverlay')
AddEventHandler('scl:nat:res:SetPedHeadOverlay', function(PedNetID, overlayID, index, opacity)
    local ped = NetToPed(PedNetID)
    SetPedHeadOverlay(ped, overlayID, index, opacity)
end)

RegisterNetEvent('scl:nat:res:SetPedHeadOverlayColor')
AddEventHandler('scl:nat:res:SetPedHeadOverlayColor', function(PedNetID, overlayID, colorType, colorID, secondColorID)
    local ped = NetToPed(PedNetID)
    SetPedHeadOverlayColor(ped, overlayID, colorType, colorID, secondColorID)
end)

RegisterNetEvent('scl:nat:res:SetPedComponentVariation')
AddEventHandler('scl:nat:res:SetPedComponentVariation', function(PedNetID, componentID, drawableID, textureID, paletteID)
    local ped = NetToPed(PedNetID)
    SetPedComponentVariation(ped, componentID, drawableID, textureID, paletteID)
end)

RegisterNetEvent('scl:nat:res:SetPedPropIndex')
AddEventHandler('scl:nat:res:SetPedPropIndex', function(PedNetID, componentID, drawableID, textureID, attach)
    local ped = NetToPed(PedNetID)
    if drawableID == 255 then
        ClearPedProp(ped, componentID)
    else
        SetPedPropIndex(ped, componentID, drawableID, textureID, attach)
    end
end)