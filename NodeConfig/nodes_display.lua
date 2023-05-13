AddEventHandler('AddNodeForBlip', function(name, x, y, z)
    local blip = AddBlipForCoord(x, y, z)
    local zone = GetNameOfZone(x, y, z)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(zone)
    EndTextCommandSetBlipName(blip)
end)

function getCurrentCount(zone)
    local count = 1

    for name, entry in pairs(ListNodes) do
        if string.find(name, zone) then
            count = count + 1
        end
    end

    return count
end

RegisterCommand('CreateNode', function(source, args)
    local coords = GetEntityCoords(PlayerPedId())
    local zone = GetNameOfZone(coords)
    local number = getCurrentCount(zone)
    local name = zone .. "-" .. number
    Notify('Creating Node ' .. name .. ' at ' .. coords.x .. ", " .. coords.y .. ", " .. coords.z .. ".")
    local infotable = {
        x=coords.x,
        y=coords.y,
        z=coords.z,
        paths = {
            {},
        },
    }
    ListNodes[name] = infotable
    TriggerEvent('AddNodeForBlip', name, coords.x, coords.y, coords.z)
    TriggerServerEvent('AddNode', name, coords)
end)

RegisterKeyMapping('CreateNode', 'Create Node', 'Keyboard', 'e')

CreateThread(function()
for name, entry in pairs(ListNodes) do
    if entry.y < -430.0 then
        TriggerEvent('AddNodeForBlip', name, entry.x, entry.y, entry.z)
        Wait(50)
    end
end
print("I'm done.")
end)

CreateThread(function()
    while true do
        Wait(0)
        SetPedDensityMultiplierThisFrame(0.0)
        SetVehicleDensityMultiplierThisFrame(0.0)
    end
end)