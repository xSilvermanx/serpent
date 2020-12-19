fx_version 'bodacious'
games { 'gta5' }

author 'multiple'
description '[Serpent] Serverside Platform for Entity Handling - Dev Resource'
version '0.1'

server_scripts {
  'Startup/startup_sv.lua',
  'Main/main_sv.lua',
  'NodeConfig/nodes_sv.lua',
  'Pathfinding/paths_sv.lua',
}

client_scripts {
  'Startup/startup_cl.lua',
  'Main/main_cl.lua',
  'Pathfinding/paths_cl.lua',
}
