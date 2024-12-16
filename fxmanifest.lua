fx_version 'cerulean'
games { 'gta5' }

author 'multiple'
description '[Serpent] Server Platform for Entity Management - Dev Resource'
version '0.1'

client_scripts { -- temp
  'NodeConfig/nodes_display.lua',
  'newnodes.txt',
}

shared_scripts {
  'Common/commonfct_shared.lua',
  'Config/config_shared.lua',
  'Def/def_shared.lua',
  'NodeConfig/nodes_sh.lua',
  'Pathfinding/paths_sh.lua',
}

server_scripts {
  'Common/commonfct_sv.lua',
  'Config/config_sv.lua',
  'Def/def_sv.lua',
  'Main/main_sv.lua',
  'Natives/EntityCreationFct_sv.lua',
  'Natives/Handler/*.lua',
  'Natives/Serpent/*.lua',
  'Natives/Server/*.lua',
  'NodeConfig/nodes_creation_sv.lua',
  'Sync/sync_sv.lua',
}

client_scripts {
  'Common/commonfct_cl.lua',
  'Config/config_cl.lua',
  'Def/def_cl.lua',
  'Main/main_cl.lua',
  'Natives/Client/*.lua',
  'Pathfinding/paths_cl.lua',
  'Sync/sync_cl.lua',
}

server_scripts{
  'Startup/startup_sv.lua',
}

client_scripts{
  'Startup/startup_cl.lua',
}

server_exports {
  'ssv_nat_CreatePed',
  'ssv_nat_CreateVehicle',
  'ssv_nat_CreateObject',
  'ssv_nat_DeletePed',
  'ssv_nat_DeleteVehicle',
  'ssv_nat_DeleteObject',
  'ssv_nat_IsPedInSerpentVehicle',
  'ssv_nat_PedUseExactSpawnCoordinates',
  'ssv_nat_SetPedIntoVehicle',
  'ssv_nat_TaskEnterVehicle',
  'ssv_nat_TaskGoStraightToCoord',
  'ssv_nat_TaskVehicleDriveToCoord',
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