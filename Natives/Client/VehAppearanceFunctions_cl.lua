--[[
RollDownWindow
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
SetVehicleSearchlight -- safeguard this function by checking whether it actually has a Searchlight
SetVehicleInteriorlight
SetVehicleIndicatorLights
SetVehicleWindowTint
LowerConvertibleRoof -- safeguard this function by checking whether it actually is a convertible
RaiseConvertibleRoof -- safeguard this function by checking whether it actually is a convertible
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
+ a few which I deleted before noticing!
]]

RegisterNetEvent('scl:nat:res:SetVehicleDoorCanBreak')
AddEventHandler('scl:nat:res:SetVehicleDoorCanBreak', function(VehNetID, doorIndex, isBreakable)
    local veh = NetToVeh(VehNetID)
    SetVehicleDoorCanBreak(veh, doorIndex, isBreakable)
end)