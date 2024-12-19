RegisterNetEvent('scl:nat:res:SetVehicleColour')
AddEventHandler('scl:nat:res:SetVehicleColour', function(VehNetID, colorType, intList)
    local veh = NetToVeh(VehNetID)
    if colorType == 0 then
        SetVehicleColourCombination(veh, intList[1])
    elseif colorType == 1 then
        SetVehicleColours(veh, 0, intList[4])
        SetVehicleCustomPrimaryColour(veh, intList[1], intList[2], intList[3])
    elseif colorType == 2 then
        SetVehicleColours(veh, intList[1], 0)
        SetVehicleCustomSecondaryColour(veh, intList[2], intList[3], intList[4])
    elseif colorType == 3 then
        SetVehicleCustomPrimaryColour(veh, intList[1], intList[2], intList[3])
        SetVehicleCustomSecondaryColour(veh, intList[4], intList[5], intList[6])
    elseif colorType == 4 then
        SetVehicleColours(veh, intList[1], intList[2])
    end
end)

RegisterNetEvent('scl:nat:res:RollDownWindow')
AddEventHandler('scl:nat:res:RollDownWindow', function(VehNetID, windowIndex)
    local veh = NetToVeh(VehNetID)
    RollDownWindow(veh, windowIndex)
end)

RegisterNetEvent('scl:nat:res:RollUpWindow')
AddEventHandler('scl:nat:res:RollUpWindow', function(VehNetID, windowIndex)
    local veh = NetToVeh(VehNetID)
    RollUpWindow(veh, windowIndex)
end)

RegisterNetEvent('scl:nat:res:SetVehicleExtra')
AddEventHandler('scl:nat:res:SetVehicleExtra', function(VehNetID, extraId, disable)
    local veh = NetToVeh(VehNetID)
    SetVehicleExtra(veh, extraId, disable)
end)

RegisterNetEvent('scl:nat:res:SetVehicleDashboardColor')
AddEventHandler('scl:nat:res:SetVehicleDashboardColor', function(VehNetID, color)
    local veh = NetToVeh(VehNetID)
    SetVehicleDashboardColor(veh, color)
end)

RegisterNetEvent('scl:nat:res:SetVehicleExtraColours')
AddEventHandler('scl:nat:res:SetVehicleExtraColours', function(VehNetID, pearlescentColor, wheelColor)
    local veh = NetToVeh(VehNetID)
    SetVehicleExtraColours(pearlescentColor, wheelColor)
end)

RegisterNetEvent('scl:nat:res:SetVehicleInteriorColor')
AddEventHandler('scl:nat:res:SetVehicleInteriorColor', function(VehNetID, color)
    local veh = NetToVeh(VehNetID)
    SetVehicleInteriorColor(veh, color)
end)

RegisterNetEvent('scl:nat:res:SetVehicleModColor_1')
AddEventHandler('scl:nat:res:SetVehicleModColor_1', function(VehNetID, paintType, color, pearlescentColor)
    local veh = NetToVeh(VehNetID)
    SetVehicleModColor_1(veh, paintType, color, pearlescentColor)
end)

RegisterNetEvent('scl:nat:res:SetVehicleModColor_2')
AddEventHandler('scl:nat:res:SetVehicleModColor_2', function(VehNetID, paintType, color)
    local veh = NetToVeh(VehNetID)
    SetVehicleModColor_2(veh, paintType, color)
end)

RegisterNetEvent('scl:nat:res:SetVehicleNeonLightEnabled')
AddEventHandler('scl:nat:res:SetVehicleNeonLightEnabled', function(VehNetID, index, toggle)
    local veh = NetToVeh(VehNetID)
    SetVehicleNeonLightEnabled(veh, index, toggle)
end)

RegisterNetEvent('scl:nat:res:SetVehicleNeonLightsColour')
AddEventHandler('scl:nat:res:SetVehicleNeonLightsColour', function(VehNetID, r, g, b)
    local veh = NetToVeh(VehNetID)
    SetVehicleNeonLightsColour(veh, r, g, b)
end)

RegisterNetEvent('scl:nat:res:SetVehicleTyreSmokeColor')
AddEventHandler('scl:nat:res:SetVehicleTyreSmokeColor', function(VehNetID, r, g, b)
    local veh = NetToVeh(VehNetID)
    SetVehicleTyreSmokeColor(veh, r, g, b)
end)

RegisterNetEvent('scl:nat:res:SetVehicleXenonLightsColor')
AddEventHandler('scl:nat:res:SetVehicleXenonLightsColor', function(VehNetID, color)
    local veh = NetToVeh(VehNetID)
    SetVehicleXenonLightsColor(veh, color)
end)

RegisterNetEvent('scl:nat:res:SetVehicleLivery')
AddEventHandler('scl:nat:res:SetVehicleLivery', function(VehNetID, livery)
    local veh = NetToVeh(VehNetID)
    SetVehicleLivery(veh, livery)
end)

RegisterNetEvent('scl:nat:res:SetVehicleRoofLivery')
AddEventHandler('scl:nat:res:SetVehicleRoofLivery', function(VehNetID, livery)
    local veh = NetToVeh(VehNetID)
    SetVehicleRoofLivery(veh, livery)
end)

RegisterNetEvent('scl:nat:res:SetVehicleSearchlight')
AddEventHandler('scl:nat:res:SetVehicleSearchlight', function(SID, VehNetID, toggle, canBeUsedByAI)
    local veh = NetToVeh(VehNetID)
    if DoesVehicleHaveSearchlight(veh) then
        SetVehicleSearchlight(veh, toggle, canBeUsedByAI)
    else
        TriggerServerEvent('ssv:SyncVehData', SID, 'Lights', 'Searchlight', false)
    end
end)

RegisterNetEvent('scl:nat:res:SetVehicleInteriorlight')
AddEventHandler('scl:nat:res:SetVehicleInteriorlight', function(VehNetID, toggle)
    local veh = NetToVeh(VehNetID)
    SetVehicleInteriorlight(veh, toggle)
end)

RegisterNetEvent('scl:nat:res:SetVehicleIndicatorLights')
AddEventHandler('scl:nat:res:SetVehicleIndicatorLights', function(VehNetID, turnSignal, toggle)
    local veh = NetToVeh(VehNetID)
    SetVehicleIndicatorLights(veh, turnSignal, toggle)
end)

RegisterNetEvent('scl:nat:res:SetVehicleWindowTint')
AddEventHandler('scl:nat:res:SetVehicleWindowTint', function(VehNetID, tint)
    local veh = NetToVeh(VehNetID)
    SetVehicleWindowTint(veh, tint)
end)

RegisterNetEvent('scl:nat:res:LowerConvertibleRoof')
AddEventHandler('scl:nat:res:LowerConvertibleRoof', function(SID, VehNetID, instantlyLower)
    local veh = NetToVeh(VehNetID)
    if IsVehicleAConvertible(veh, false) then
        LowerConvertibleRoof(veh, instantlyLower)
    elseif IsVehicleAConvertible(veh, true) then
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ConvertibleRoof', 'Fixed')
    else
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ConvertibleRoof', false)
    end
end)


RegisterNetEvent('scl:nat:res:RaiseConvertibleRoof')
AddEventHandler('scl:nat:res:RaiseConvertibleRoof', function(SID, VehNetID, instantlyRaise)
    local veh = NetToVeh(VehNetID)
    if IsVehicleAConvertible(veh, false) then
        RaiseConvertibleRoof(veh, instantlyRaise)
    elseif IsVehicleAConvertible(veh, true) then
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ConvertibleRoof', 'Fixed')
    else
        TriggerServerEvent('ssv:SyncVehData', SID, '', 'ConvertibleRoof', false)
    end
end)

RegisterNetEvent('scl:nat:res:RemoveVehicleWindow')
AddEventHandler('scl:nat:res:RemoveVehicleWindow', function(VehNetID, windowIndex)
    local veh = NetToVeh(VehNetID)
    RemoveVehicleWindow(veh, windowIndex)
end)

RegisterNetEvent('scl:nat:res:SmashVehicleWindow')
AddEventHandler('scl:nat:res:SmashVehicleWindow', function(VehNetID, windowIndex)
    local veh = NetToVeh(VehNetID)
    SmashVehicleWindow(veh, windowIndex)
end)

RegisterNetEvent('scl:nat:res:SetVehicleWheelType')
AddEventHandler('scl:nat:res:SetVehicleWheelType', function(VehNetID, wheelType)
    local veh = NetToVeh(VehNetID)
    SetVehicleWheelType(veh, wheelType)
end)

RegisterNetEvent('scl:nat:res:SetVehicleMod')
AddEventHandler('scl:nat:res:SetVehicleMod', function(VehNetID, modType, modIndex, customTyres)
    local veh = NetToVeh(VehNetID)
    SetVehicleMod(veh, modType, modIndex, customTyres)
end)

RegisterNetEvent('scl:nat:res:SetDriftTyresEnabled')
AddEventHandler('scl:nat:res:SetDriftTyresEnabled', function(VehNetID, toggle)
    local veh = NetToVeh(VehNetID)
    SetDriftTyresEnabled(veh, toggle)
end)

RegisterNetEvent('scl:nat:res:SetVehicleBodyHealth')
AddEventHandler('scl:nat:res:SetVehicleBodyHealth', function(VehNetID, health)
    local veh = NetToVeh(VehNetID)
    SetVehicleBodyHealth(veh, health)
end)

RegisterNetEvent('scl:nat:res:SetVehicleEngineHealth')
AddEventHandler('scl:nat:res:SetVehicleEngineHealth', function(VehNetID, health)
    local veh = NetToVeh(VehNetID)
    SetVehicleEngineHealth(veh, health)
end)

RegisterNetEvent('scl:nat:res:SetVehiclePetrolTankHealth')
AddEventHandler('scl:nat:res:SetVehiclePetrolTankHealth', function(VehNetID, health)
    local veh = NetToVeh(VehNetID)
    SetVehiclePetrolTankHealth(veh, health)
end)

RegisterNetEvent('scl:nat:res:SetVehicleTyresCanBurst')
AddEventHandler('scl:nat:res:SetVehicleTyresCanBurst', function(VehNetID, toggle)
    local veh = NetToVeh(VehNetID)
    SetVehicleTyresCanBurst(veh, toggle)
end)

RegisterNetEvent('scl:nat:res:SetVehicleCanDeformWheels')
AddEventHandler('scl:nat:res:SetVehicleCanDeformWheels', function(VehNetID, toggle)
    local veh = NetToVeh(VehNetID)
    SetVehicleCanDeformWheels(veh, toggle)
end)

RegisterNetEvent('scl:nat:res:SetVehicleWheelsCanBreakOffWhenBlowUp')
AddEventHandler('scl:nat:res:SetVehicleWheelsCanBreakOffWhenBlowUp', function(VehNetID, toggle)
    local veh = NetToVeh(VehNetID)
    SetVehicleWheelsCanBreakOffWhenBlowUp(veh, toggle)
end)

RegisterNetEvent('scl:nat:res:SetVehicleWheelsCanBreak')
AddEventHandler('scl:nat:res:SetVehicleWheelsCanBreak', function(VehNetID, enabled)
    local veh = NetToVeh(VehNetID)
    SetVehicleWheelsCanBreak(veh, enabled)
end)

RegisterNetEvent('scl:nat:res:SetTyreHealth')
AddEventHandler('scl:nat:res:SetTyreHealth', function(VehNetID, wheelIndex, health)
    local veh = NetToVeh(VehNetID)
    SetTyreHealth(veh, wheelIndex, health)
end)

RegisterNetEvent('scl:nat:res:SetVehicleWheelHealth')
AddEventHandler('scl:nat:res:SetVehicleWheelHealth', function(VehNetID, wheelIndex, health)
    local veh = NetToVeh(VehNetID)
    SetVehicleWheelHealth(veh, wheelIndex, health)
end)

RegisterNetEvent('scl:nat:res:SetVehicleTyreBurst')
AddEventHandler('scl:nat:res:SetVehicleTyreBurst', function(VehNetID, index, onRim, p3)
    local veh = NetToVeh(VehNetID)
    SetVehicleTyreBurst(veh, index, onRim, p3)    
end)

RegisterNetEvent('scl:nat:res:BreakOffVehicleWheel')
AddEventHandler('scl:nat:res:BreakOffVehicleWheel', function(VehNetID, wheelIndex, leaveDebrisTrail, deleteWheel, unknownFlag, putOnFire)
    local veh = NetToVeh(VehNetID)
    BreakOffVehicleWheel(veh, wheelIndex, leaveDebrisTrail, deleteWheel, unknownFlag, putOnFire)    
end)

RegisterNetEvent('scl:nat:res:SetVehicleDoorsLocked')
AddEventHandler('scl:nat:res:SetVehicleDoorsLocked', function(VehNetID, doorLockStatus)
    local veh = NetToVeh(VehNetID)
    SetVehicleDoorsLocked(veh, doorLockStatus)
end)

RegisterNetEvent('scl:nat:res:SetVehicleDoorShut')
AddEventHandler('scl:nat:res:SetVehicleDoorShut', function(VehNetID, doorIndex, closeInstantly)
    local veh = NetToVeh(VehNetID)
    SetVehicleDoorShut(veh, doorIndex, closeInstantly)
end)

RegisterNetEvent('scl:nat:res:SetVehicleDirtLevel')
AddEventHandler('scl:nat:res:SetVehicleDirtLevel', function(VehNetID, dirtLevel)
    local veh = NetToVeh(VehNetID)
    SetVehicleDirtLevel(veh, dirtLevel)
end)

RegisterNetEvent('scl:nat:res:SetVehicleDoorCanBreak')
AddEventHandler('scl:nat:res:SetVehicleDoorCanBreak', function(VehNetID, doorIndex, isBreakable)
    local veh = NetToVeh(VehNetID)
    SetVehicleDoorCanBreak(veh, doorIndex, isBreakable)
end)