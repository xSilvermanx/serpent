local gameEvents = {}

gameEvents.CEventNetworkEntityDamage = function(args)
  if scl_PedEventList[args[1]] then
    local PedSID = scl_PedEventList[args[1]]
    if args[6] == 1 then
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'IsDead', true)
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'PedHealth', 0)
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'UseExactSpawnCoordinates', true)
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'DeadPitch', GetEntityPitch(ped))
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'DeadRoll', GetEntityRoll(ped))
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'DeadHeading', GetEntityHeading(ped))
    else
      local PedNetID = scl_PedList[PedSID].PedNetID
      local ped = NetToPed(PedNetID)
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'PedHealth', GetEntityHealth(ped))
      TriggerServerEvent('ssv:SyncPedData', PedSID, '', 'PedArmor', GetPedArmour(ped))
    end
    local AttackerNetID = args[2]
    if args[2]~= -1 then
      AttackerNetID = NetworkGetNetworkIdFromEntity(args[2])
    end
    TriggerServerEvent('ssv:ev:SerpentPedDamaged', PedSID, AttackerNetID, args[6], args[7])
  elseif scl_VehEventList[args[1]] then
    local VehSID = scl_VehEventList[args[1]]
    if args[6] == 1 then
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'IsExploded', true)
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'UseExactSpawnCoordinates', true)
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'VehicleEngineHealth', -4000.0)
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'VehicleBodyHealth', 0.0)
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'VehiclePetrolTankHealth', 0.0)
    else
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'VehicleEngineHealth', GetVehicleEngineHealth(args[1]))
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'VehicleBodyHealth', GetVehicleBodyHealth(args[1]))
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'VehiclePetrolTankHealth', GetVehiclePetrolTankHealth(args[1]))
    end

    local isTyreAffected = false
    local TyreDamageList = {}
    local isWheelAffected = false
    local WheelDamageList = {}
    for i, tyre in ipairs(scl_VehList[VehSID].ExistingTyres) do
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'TyreHealth', tyre, GetTyreHealth(args[1], tyre))
      TriggerServerEvent('ssv:SyncVehData', VehSID, 'WheelHealth', tyre, GetVehicleWheelHealth(args[1], tyre))
      
      if IsVehicleTyreBurst(args[1], tyre, true) then
        isTyreAffected = true
        table.insert(TyreDamageList, tyre)
        TriggerServerEvent('ssv:SyncVehData', VehSID, 'TyreDamage', tyre, 'Destroyed')
      elseif IsVehicleTyreBurst(args[1], tyre, false) then
        isTyreAffected = true
        table.insert(TyreDamageList, tyre)
        TriggerServerEvent('ssv:SyncVehData', VehSID, 'TyreDamage', tyre, 'Flat')
      end

      -- code to check for broken off wheels is missing
      
    end

    local isDoorAffected = false
    local DoorDamageList = {}
    for i, door in ipairs(scl_VehList[VehSID].ExistingDoors) do
      -- doors
    end

    local isWindowAffected = false
    local WindowDamageList = {}
    for window, status in pairs(scl_VehList[VehSID].WindowStatus) do
      if not IsVehicleWindowIntact(args[1], window) then
        isWindowAffected = true
        table.insert(WindowDamageList, window)
        TriggerServerEvent('ssv:SyncVehData', VehSID, 'WindowStatus', window, 'Smashed')
      end
    end
    
    local isBumperAffected = false
    local BumperDamageList = {}
    if IsVehicleBumperBrokenOff(args[1], true) then
      isBumperAffected = true
      table.insert(BumperDamageList, 'Front')
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'FrontBumper', 'BrokenOff')
    elseif IsVehicleBumperBouncing(args[1], true) then
      isBumperAffected = true
      table.insert(BumperDamageList, 'Front')
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'FrontBumper', 'Bouncing')
    end
    if IsVehicleBumperBrokenOff(args[1], false) then
      isBumperAffected = true
      table.insert(BumperDamageList, 'Rear')
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'RearBumper', 'BrokenOff')
    elseif IsVehicleBumperBouncing(args[1], false) then
      isBumperAffected = true
      table.insert(BumperDamageList, 'Rear')
      TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'RearBumper', 'Bouncing')
    end
    -- lights
    local areLightsAffected = false
    local LightsDamageList = {}

    local AttackerNetID = args[2]
    if args[2]~= -1 then
      AttackerNetID = NetworkGetNetworkIdFromEntity(args[2])
    end
    TriggerServerEvent('ssv:ev:SerpentVehDamaged', VehSID, AttackerNetID, args[6], args[7], args[12], isTyreAffected, TyreDamageList, isWheelAffected, WheelDamageList, isDoorAffected, DoorDamageList, isWindowAffected, WindowDamageList, isBumperAffected, BumperDamageList, areLightsAffected, LightsDamageList)
  end
end

gameEvents.CEventNetworkVehicleUndrivable = function(args)
  if scl_VehEventList[args[1]] then
    local VehSID = scl_VehEventList[args[1]]
    TriggerServerEvent('ssv:SyncVehData', VehSID, '', 'IsUndrivable', true)
    TriggerServerEvent('ssv:ev:SerpentVehicleUndrivable', VehSID)
  end
end

AddEventHandler('gameEventTriggered', function(name, args)
 if not gameEvents[name] then return end
  gameEvents[name](args)
end)



RegisterNetEvent('scl:ev:result:RandomPedIsInSerpentVehicle')
AddEventHandler('scl:ev:result:RandomPedIsInSerpentVehicle', function(VehSID, seat)
  local VehNetID = scl_VehList[VehSID].VehNetID
  local veh = NetToVeh(VehNetID)
  local ped = GetPedInVehicleSeat(veh, seat)
  TaskLeaveVehicle(ped, veh, 0)
end)

RegisterNetEvent('scl:ev:result:SerpentPedIsInRandomVehicle')
AddEventHandler('scl:ev:result:SerpentPedIsInRandomVehicle', function(PedSID)
  local PedNetID = scl_PedList[PedSID].PedNetID
  local ped = NetToPed(PedNetID)
  local veh = GetVehiclePedIsIn(ped, false)
  TaskLeaveVehicle(ped, veh, 0)
  if ssv_PedList[PedSID].OverrideObjective ~= 'none' then
    TriggerServerEvent('ssv:SyncPedData', PedSID, 'OverrideObjectiveData', 'task', 'Init')
  else
    TriggerServerEvent('ssv:SyncPedData', PedSID, 'CurrObjectiveData', 'task', 'Init')
  end
end)
