RegisterNetEvent('AddNode')
AddEventHandler('AddNode', function(name, coords)
    local string = LoadResourceFile('serpent', 'newnodes.txt')
    local data = string .. '["' .. name .. '"] = {\n' .. '  x=' .. coords.x .. ',\n' .. '  y=' .. coords.y .. ',\n' .. '  z=' .. coords.z .. ',\n' .. '  paths = {\n' .. '    {}\n' .. '  },\n' .. '},\n'
    SaveResourceFile('serpent', 'newnodes.txt', data, -1)
end)