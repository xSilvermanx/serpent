fx_version 'bodacious'
games { 'gta5' }

author 'multiple'
description '[Serpent] Serverside Platform for Entity Management - Dev Resource'
version '0.1'

server_scripts {
  'Common/commonfct_sv.lua',
  'Common/commonfct_shared.lua',
  'Config/config_sv.lua',
  'Config/config_shared.lua',
  'Main/main_sv.lua',
  'NodeConfig/nodes_sv.lua',
  'Pathfinding/paths_sv.lua',
  'Sync/sync_sv.lua',
  'Startup/startup_sv.lua',
}

client_scripts {
  'Common/commonfct_cl.lua',
  'Common/commonfct_shared.lua',
  'Config/config_cl.lua',
  'Config/config_shared.lua',
  'Main/main_cl.lua',
  'Pathfinding/paths_cl.lua',
  'Sync/sync_cl.lua',
  'Startup/startup_cl.lua',
}

server_exports {
  'ssv_nat_CreatePed',
  'ssv_nat_CreateVehicle',
  'ssv_nat_CreateObject',
}
