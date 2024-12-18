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

--[[RollDownWindow
RollUpWindow
SetVehicleExtra
SetVehicleColour -- Combination of GetVehicleColourCombination, GetVehicleCustomPrimaryColour, GetVehicleCustomSecondaryColour, GetVehicleColours and the "Is"-functions
SetVehicleDashboardColor
SetVehicleExtraColours
SetVehicleInteriorColor
SetVehicleModColor_1
SetVehicleModColor_2
SetVehicleNeonLightEnabled
SetVehicleNeonLightsColour
SetVehicleTyreSmokeColor
SetVehicleXenonLightsColor
SetVehicleLivery
SetVehicleRoofLivery
SetVehicleSearchlight
SetVehicleInteriorlight
SetVehicleIndicatorLights
SetVehicleWindowTint
LowerConvertibleRoof
RaiseConvertibleRoof
RemoveVehicleWindow
SmashVehicleWindow
SetVehicleWheelType
SetVehicleMod
SetDriftTyresEnabled
SetVehicleBodyHealth
SetVehicleEngineHealth
SetVehiclePetrolTankHealth
SetVehicleTyresCanBurst
SetVehicleCanDeformWheels
SetVehicleWheelsCanBreak
SetVehicleWheelsCanBreakOffWhenBlowUp
SetTyreHealth
SetVehicleWheelHealth
SetVehicleTyreBurst
BreakOffVehicleWheel
SetVehicleDoorsLocked
SetVehicleDoorShut
SetVehicleDirtLevel]]

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

