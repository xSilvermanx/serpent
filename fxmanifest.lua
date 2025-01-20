fx_version 'cerulean'
games { 'gta5' }

author 'multiple'
description '[Serpent] Server Platform for Entity Management - Dev Resource'
version '0.1'

shared_scripts {
  'Common/commonfct_shared.lua',
  'Config/config_shared.lua',
  'Def/def_shared.lua',
  'NodeConfig/nodes_sh.lua',
  'Pathfinding/paths_sh.lua',
}

server_scripts {
  'Admin/admin_sv.lua',
  'Common/commonfct_sv.lua',
  'Config/config_sv.lua',
  'Debug/debug_sv.lua',
  'Def/def_sv.lua',
  'Events/events_sv.lua',
  'Main/main_sv.lua',
  'Natives/EntityCreationFct_sv.lua',
  'Natives/Handler/*.lua',
  'Natives/Serpent/*.lua',
  'Natives/Server/*.lua',
  'NodeConfig/nodes_creation_sv.lua',
  'Sync/sync_sv.lua',
}

client_scripts {
  'Admin/admin_cl.lua',
  'Common/commonfct_cl.lua',
  'Config/config_cl.lua',
  'Debug/debug_cl.lua',
  'Def/def_cl.lua',
  'Events/events_cl.lua',
  'Main/main_cl.lua',
  'Natives/Client/*.lua',
  'Natives/EntityCreationFct_cl.lua',
  'Pathfinding/paths_cl.lua',
  'Sync/sync_cl.lua',
  'newnodes.txt',
}

server_scripts{
  'Startup/startup_sv.lua',
}

client_scripts{
  'Startup/startup_cl.lua',
}

server_exports {
  'ssv_nat_BreakOffVehicleWheel',
  'ssv_nat_CreatePed',
  'ssv_nat_CreateVehicle',
  'ssv_nat_CreateObject',
  'ssv_nat_DeletePed',
  'ssv_nat_DeleteVehicle',
  'ssv_nat_DeleteObject',
  'ssv_nat_FinishSerpentPedTask',
  'ssv_nat_GetSerpentPedData',
  'ssv_nat_GetSerpentPedId',
  'ssv_nat_GetSerpentPedNetId',
  'ssv_nat_GetSerpentVehData',
  'ssv_nat_GetSerpentVehId',
  'ssv_nat_GetSerpentVehNetId',
  'ssv_nat_IsPedInSerpentVehicle',
  'ssv_nat_LoadPedIntoSerpent',
  'ssv_nat_LoadVehIntoSerpent',
  'ssv_nat_LowerConvertibleRoof',
  'ssv_nat_PedUseExactSpawnCoordinates',
  'ssv_nat_RaiseConvertibleRoof',
  'ssv_nat_RemoveVehicleWindow',
  'ssv_nat_RollDownWindow',
  'ssv_nat_RollUpWindow',
  'ssv_nat_SetDriftTyresEnabled',
  'ssv_nat_SetPedComponentVariation',
  'ssv_nat_SetPedEyeColor',
  'ssv_nat_SetPedFaceFeature',
  'ssv_nat_SetPedHairTint',
  'ssv_nat_SetPedHeadBlendData',
  'ssv_nat_SetPedHeadOverlay',
  'ssv_nat_SetPedHeadOverlayColor',
  'ssv_nat_SetPedIntoVehicle',
  'ssv_nat_SetPedPropIndex',
  'ssv_nat_SetSerpentPedData',
  'ssv_nat_SetSerpentPedTask',
  'ssv_nat_SetTyreHealth',
  'ssv_nat_SetVehicleBodyHealth',
  'ssv_nat_SetVehicleCanDeformWheels',
  'ssv_nat_SetVehicleColour',
  'ssv_nat_SetVehicleDashboardColor',
  'ssv_nat_SetVehicleDirtLevel',
  'ssv_nat_SetVehicleDoorCanBreak',
  'ssv_nat_SetVehicleDoorShut',
  'ssv_nat_SetVehicleDoorsLocked',
  'ssv_nat_SetVehicleEngineHealth',
  'ssv_nat_SetVehicleExtra',
  'ssv_nat_SetVehicleExtraColours',
  'ssv_nat_SetVehicleIndicatorLights',
  'ssv_nat_SetVehicleInteriorColor',
  'ssv_nat_SetVehicleInteriorlight',
  'ssv_nat_SetVehicleLivery',
  'ssv_nat_SetVehicleMod',
  'ssv_nat_SetVehicleModColor_1',
  'ssv_nat_SetVehicleModColor_2',
  'ssv_nat_SetVehicleNeonLightEnabled',
  'ssv_nat_SetVehicleNeonLightsColour',
  'ssv_nat_SetVehiclePetrolTankHealth',
  'ssv_nat_SetVehicleRoofLivery',
  'ssv_nat_SetVehicleSearchlight',
  'ssv_nat_SetVehicleTyreBurst',
  'ssv_nat_SetVehicleTyresCanBurst',
  'ssv_nat_SetVehicleTyreSmokeColor',
  'ssv_nat_SetVehicleWheelHealth',
  'ssv_nat_SetVehicleWheelsCanBreak',
  'ssv_nat_SetVehicleWheelsCanBreakOffWhenBlowUp',
  'ssv_nat_SetVehicleWheelType',
  'ssv_nat_SetVehicleWindowTint',
  'ssv_nat_SetVehicleXenonLightsColor',
  'ssv_nat_SmashVehicleWindow',
  'ssv_nat_TaskEnterVehicle',
  'ssv_nat_TaskGoStraightToCoord',
  'ssv_nat_TaskVehicleDriveToCoord',
  'ssv_nat_TaskWait',
  'ssv_nat_UpdateSerpentPedTaskStatus',
  'ssv_nat_VehUseExactSpawnCoordinates',
}

-- Shared Exports

server_exports {
  'ssh_nat_GetNodeData',
  'ssh_nat_GetClosestNodeId',
}

client_exports {
  'ssh_nat_GetNodeData',
  'ssh_nat_GetClosestNodeId',
}