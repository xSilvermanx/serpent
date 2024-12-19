-- Get functions are QoL but you can get all the data already by loading the whole list and searching manually
-- as such: No priority for these functions. Might be done later

--[[
DoesVehicleTyreExist
GetIsDoorValid
DoesExtraExist
IsVehicleExtraTurnedOn
GetVehicleColour -- Combination of GetVehicleColourCombination, GetVehicleCustomPrimaryColour, GetVehicleCustomSecondaryColour, GetVehicleColours and the "Is"-functions
GetVehicleDashboardColor
GetVehicleExtraColours
GetVehicleInteriorColor
GetVehicleModColor_1
GetVehicleModColor_2
IsVehicleNeonLightEnabled
GetVehicleNeonLightsColour
GetVehicleTyreSmokeColor
GetVehicleXenonLightsColor
GetVehicleLivery
GetVehicleRoofLivery
GetVehicleLightsState
DoesVehicleHaveSearchlight
IsVehicleInteriorLightOn
GetVehicleIndicatorLights
GetVehicleWindowTint
IsVehicleAConvertible
GetConvertibleRoofState
GetVehicleMod
GetVehicleModVariation
GetVehicleWheelType
GetVehicleFuelLevel
GetVehicleBodyHealth
GetVehicleEngineHealth
GetVehiclePetrolTankHealth
GetVehicleDirtLevel
]]

-- ColourCombination(colorCombination)
-- CustomPrimaryColour(r1, g1, b1)
-- CustomSecondaryColour(r2, g2, b2)
-- SetVehicleColours(colorPrimary, colorSecondary)
-- colorType: 0 -> ColourCombination; 1 -> CustomPrimaryColour, normalSecondaryColour; 2 -> CustomSecondaryColour, normalPrimaryColour; 3 -> CustomPrimaryColour and CustomSecondaryColour; 4 -> Normal Colours
-- intList is a list of a fixed number of integers:
-- 0 -> 1 integer (colorCombination) -> this is equivalent to the native SetVehicleColourCombination()
-- 1 -> 4 integers (r1, g1, b1, colorSecondary)
-- 2 -> 4 integers (colorPrimary, r2, g2, b2)
-- 3 -> 6 integers (r1, g1, b1, r2, g2, b2) -> this is equivalent to the native SetVehicleCustomPrimaryColour() and SetVehicleCustomSecondaryColour()
-- 4 -> 2 integers (colorPrimary, colorSecondary) -> this is equivalent to the native SetVehicleColours()
function ssv_nat_SetVehicleColour(SID, colorType, intList)
    if colorType == 0 then
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'IsColorCombination', true)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'PrimaryColorCustom', false)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'SecondaryColorCustom', false)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'ColorCombination', intList[1])
    elseif colorType == 1 then
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'IsColorCombination', false)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'PrimaryColorCustom', true)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'SecondaryColorCustom', false)
        local PrimaryColor = {r = intList[1], g = intList[2], b = intList[3]}
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'PrimaryColor', PrimaryColor)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'SecondaryColor', intList[4])
    elseif colorType == 2 then
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'IsColorCombination', false)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'PrimaryColorCustom', false)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'SecondaryColorCustom', true)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'PrimaryColor', intList[1])
        local SecondaryColor = {r = intList[2], g = intList[3], b = intList[4]}
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'SecondaryColor', SecondaryColor)
    elseif colorType == 3 then
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'IsColorCombination', false)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'PrimaryColorCustom', true)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'SecondaryColorCustom', true)
        local PrimaryColor = {r = intList[1], g = intList[2], b = intList[3]}
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'PrimaryColor', PrimaryColor)
        local SecondaryColor = {r = intList[4], g = intList[5], b = intList[6]}
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'SecondaryColor', SecondaryColor)
    elseif colorType == 4 then
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'IsColorCombination', false)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'PrimaryColorCustom', false)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'SecondaryColorCustom', false)
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'PrimaryColor', intList[1])
        TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'SecondaryColor', intList[2])
    end

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleColour', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, colorType, intList)
    end
end

function ssv_nat_RollDownWindow(SID, windowIndex)
    TriggerServerEvent('ssv:SyncVehData', SID, 'WindowStatus', windowIndex, 'Down')

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:RollDownWindow', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, windowIndex)
    end
end

function ssv_nat_RollUpWindow(SID, windowIndex)
    TriggerServerEvent('ssv:SyncVehData', SID, 'WindowStatus', windowIndex, 'Up')

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:RollUpWindow', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, windowIndex)
    end
end

function ssv_nat_SetVehicleExtra(SID, extraId, disable)
    TriggerServerEvent('ssv:SyncVehData', SID, 'VehicleExtra', extraId, disable)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleExtra', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, extraId, disable)
    end
end

function ssv_nat_SetVehicleDashboardColor(SID, color)
    TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'DashboardColor', color)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleDashboardColor', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, color)
    end
end

function ssv_nat_SetVehicleExtraColours(SID, pearlescentColorTemp, wheelColorTemp)
    local ExtraColors = {pearlescentColor = pearlescentColorTemp, wheelColor = wheelColorTemp}
    TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'ExtraColors', ExtraColors)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleExtraColours', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, pearlescentColorTemp, wheelColorTemp)
    end
end

function ssv_nat_SetVehicleInteriorColor(SID, color)
    TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'InteriorColor', color)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleInteriorColor', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, color)
    end
end

function ssv_nat_SetVehicleModColor_1(SID, paintTypeTemp, colorTemp, pearlescentColorTemp)
    local ModColor1 = {paintType = paintTypeTemp, color = colorTemp, pearlescentColor = pearlescentColorTemp}
    TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'ModColor1', ModColor1)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleModColor_1', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, paintTypeTemp, colorTemp, pearlescentColorTemp)
    end
end

function ssv_nat_SetVehicleModColor_2(SID, paintTypeTemp, colorTemp)
    local ModColor2 = {paintType = paintTypeTemp, color = colorTemp}
    TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'ModColor2', ModColor2)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleModColor_2', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, paintTypeTemp, colorTemp)
    end
end

function ssv_nat_SetVehicleNeonLightEnabled(SID, index, toggle)
    TriggerServerEvent('ssv:SyncVehData', SID, 'NeonLightsEnabled', index, toggle)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleNeonLightEnabled', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, index, toggle)
    end
end

function ssv_nat_SetVehicleNeonLightsColour(SID, cr, cg, cb)
    local color = {r = cr, g = cg, b = cb}
    TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'NeonLightsColor', color)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleNeonLightsColour', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, cr, cg, cb)
    end
end

function ssv_nat_SetVehicleTyreSmokeColor(SID, cr, cg, cb)
    local color = {r = cr, g = cg, b = cb}
    TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'TyreSmokeColor', color)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleTyreSmokeColor', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, cr, cg, cb)
    end
end

function ssv_nat_SetVehicleXenonLightsColor(SID, color)
    TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'XenonLightsColor', color)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleXenonLightsColor', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, color)
    end
end

function ssv_nat_SetVehicleLivery(SID, livery)
    TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'Livery', livery)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleLivery', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, livery)
    end
end

function ssv_nat_SetVehicleRoofLivery(SID, livery)
    TriggerServerEvent('ssv:SyncVehData', SID, 'Color', 'RoofLivery', livery)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleRoofLivery', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, livery)
    end
end

function ssv_nat_SetVehicleSearchlight(SID, toggle, canBeUsedByAI)
    if toggle then
        TriggerServerEvent('ssv:SyncVehData', SID, 'Lights', 'Searchlight', 'On')
    else
        TriggerServerEvent('ssv:SyncVehData', SID, 'Lights', 'Searchlight', 'Off')
    end

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleSearchlight', ssv_VehList[SID].ScriptOwnerNetID, SID, ssv_VehList[SID].VehNetID, toggle, canBeUsedByAI)
    end
end

function ssv_nat_SetVehicleInteriorlight(SID, toggle)
    TriggerServerEvent('ssv:SyncVehData', SID, 'Lights', 'InteriorLight', toggle)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleInteriorlight', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, toggle)
    end
end

function ssv_nat_SetVehicleIndicatorLights(SID, turnSignal, toggle)
    if turnSignal == 1 then
        TriggerServerEvent('ssv:SyncVehData', SID, 'Lights', 'IndicatorLeft', toggle)
    elseif turnSignal == 0 then
        TriggerServerEvent('ssv:SyncVehData', SID, 'Lights', 'IndicatorRight', toggle)
    end

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleIndicatorLights', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, turnSignal, toggle)
    end
end


function ssv_nat_SetVehicleWindowTint(SID, tint)
    TriggerServerEvent('ssv:SyncVehData', SID, '', 'WindowTint', tint)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleWindowTint', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, tint)
    end
end


function ssv_nat_LowerConvertibleRoof(SID, instantlyLower)
    TriggerServerEvent('ssv:SyncVehData', SID, '', 'ConvertibleRoof', 'Open')

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:LowerConvertibleRoof', ssv_VehList[SID].ScriptOwnerNetID, SID, ssv_VehList[SID].VehNetID, instantlyLower)
    end
end

function ssv_nat_RaiseConvertibleRoof(SID, instantlyRaise)
    TriggerServerEvent('ssv:SyncVehData', SID, '', 'ConvertibleRoof', 'Closed')

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:RaiseConvertibleRoof', ssv_VehList[SID].ScriptOwnerNetID, SID, ssv_VehList[SID].VehNetID, instantlyRaise)
    end
end

function ssv_nat_RemoveVehicleWindow(SID, windowIndex)
    TriggerServerEvent('ssv:SyncVehData', SID, 'WindowStatus', windowIndex, 'Smashed')

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:RemoveVehicleWindow', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, windowIndex)
    end
end

function ssv_nat_SmashVehicleWindow(SID, windowIndex)
    TriggerServerEvent('ssv:SyncVehData', SID, 'WindowStatus', windowIndex, 'Smashed')

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SmashVehicleWindow', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, windowIndex)
    end
end

function ssv_nat_SetVehicleWheelType(SID, wheelType)
    TriggerServerEvent('ssv:SyncVehData', SID, 'Wheel', 'WheelType', wheelType)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleWheelType', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, wheelType)
    end
end

function ssv_nat_SetVehicleMod(SID, modType, modIndex, customTyres)
    TriggerServerEvent('ssv:SyncVehData', SID, 'Tuning', modType, modIndex)
    if modType == 23 then
        TriggerServerEvent('ssv:SyncVehData', SID, 'Wheel', 'CustomWheel', customTyres)
    elseif modType == 24 then
        TriggerServerEvent('ssv:SyncVehData', SID, 'Wheel', 'CustomWheelHydraulics', customTyres)
    end

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleMod', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, modType, modIndex, customTyres)
    end
end

function ssv_nat_SetDriftTyresEnabled(SID, toggle)
    TriggerServerEvent('ssv:SyncVehData', SID, '', 'HasDriftTyres', toggle)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetDriftTyresEnabled', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, toggle)
    end
end

function ssv_nat_SetVehicleBodyHealth(SID, health)
    TriggerServerEvent('ssv:SyncVehData', SID, '', 'VehicleBodyHealth', health)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleBodyHealth', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, health)
    end
end

function ssv_nat_SetVehicleEngineHealth(SID, health)
    TriggerServerEvent('ssv:SyncVehData', SID, '', 'VehicleEngineHealth', health)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleEngineHealth', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, health)
    end
end

function ssv_nat_SetVehiclePetrolTankHealth(SID, health)
    TriggerServerEvent('ssv:SyncVehData', SID, '', 'VehiclePetrolTankHealth', health)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehiclePetrolTankHealth', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, health)
    end
end

function ssv_nat_SetVehicleTyresCanBurst(SID, toggle)
    local value = not toggle
    TriggerServerEvent('ssv:SyncVehData', SID, '', 'TyreInvincible', value)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleTyresCanBurst', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, toggle)
    end
end

function ssv_nat_SetVehicleCanDeformWheels(SID, toggle)
    TriggerServerEvent('ssv:SyncVehData', SID, '', 'WheelsCanDeform', toggle)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleCanDeformWheels', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, toggle)
    end
end

function ssv_nat_SetVehicleWheelsCanBreakOffWhenBlowUp(SID, toggle)
    TriggerServerEvent('ssv:SyncVehData', SID, '', 'WheelsCanBreakBlow', toggle)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleWheelsCanBreakOffWhenBlowUp', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, toggle)
    end
end

function ssv_nat_SetVehicleWheelsCanBreak(SID, enabled)
    TriggerServerEvent('ssv:SyncVehData', SID, '', 'WheelsCanBreak', enabled)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleWheelsCanBreak', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, enabled)
    end
end

function ssv_nat_SetTyreHealth(SID, wheelIndex, health)
    TriggerServerEvent('ssv:SyncVehData', SID, 'TyreHealth', wheelIndex, health)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetTyreHealth', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, wheelIndex, health)
    end
end

function ssv_nat_SetVehicleWheelHealth(SID, wheelIndex, health)
    TriggerServerEvent('ssv:SyncVehData', SID, 'WheelHealth', wheelIndex, health)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleWheelHealth', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, wheelIndex, health)
    end
end

function ssv_nat_SetVehicleTyreBurst(SID, index, onRim, p3)
    if onRim then
        TriggerServerEvent('ssv:SyncVehData', SID, 'TyreDamage', index, 'Destroyed')
    else
        TriggerServerEvent('ssv:SyncVehData', SID, 'TyreDamage', index, 'Flat')
    end

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleTyreBurst', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, index, onRim, p3)
    end
end

function ssv_nat_BreakOffVehicleWheel(SID, wheelIndex, leaveDebrisTrail, deleteWheel, unknownFlag, putOnFire)
    TriggerServerEvent('ssv:SyncVehData', SID, 'WheelDamage', wheelIndex, 'Broken')

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:BreakOffVehicleWheel', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, SID, wheelIndex, leaveDebrisTrail, deleteWheel, unknownFlag, putOnFire)
    end
end


function ssv_nat_SetVehicleDoorsLocked(SID, doorLockStatus)
    TriggerServerEvent('ssv:SyncVehData', SID, '', DoorLockStatus, doorLockStatus)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleDoorsLocked', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, doorLockStatus)
    end
end


function ssv_nat_SetVehicleDoorShut(SID, doorIndex, closeInstantly)
    TriggerServerEvent('ssv:SyncVehData', SID, 'DoorsStatus', doorIndex, "Closed")

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleDoorShut', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, doorIndex, closeInstantly)
    end
end


function ssv_nat_SetVehicleDirtLevel(SID, dirtLevel)
    TriggerServerEvent('ssv:SyncVehData', SID, '', VehicleDirtLevel, dirtLevel)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleDirtLevel', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, dirtLevel)
    end
end

function ssv_nat_SetVehicleDoorCanBreak(SID, doorIndex, isBreakable)
    TriggerServerEvent('ssv:SyncVehData', SID, 'DoorCanBreak', doorIndex, isBreakable)

    if ssv_VehList[SID].IsSpawnedBool then
        local VehNetID = ssv_VehList[SID].VehNetID
        local veh = NetworkGetEntityFromNetworkId(VehNetID)
        local VehOwnerID = NetworkGetEntityOwner(veh)
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ScriptOwnerNetID', VehOwnerID)
        TriggerClientEvent('scl:nat:res:SetVehicleDoorCanBreak', ssv_VehList[SID].ScriptOwnerNetID, ssv_VehList[SID].VehNetID, doorIndex, isBreakable)
    end
end