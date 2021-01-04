AddEventHandler('scl:SendPedData', function(pedid, type, key, value)
  TriggerServerEvent('ssv:RecievePedData', pedid, type, key, value)
end)

RegisterNetEvent('scl:RecievePedData')
AddEventHandler('scl:RecievePedData', function(pedid, type, key, value)
  if type == 'Component' then

  elseif type == 'Prop' then

  elseif type == 'Inheritance' then

  elseif type == 'FaceFeature' then

  elseif type == 'Appearance' then

  else
    scl_PedList[pedid][key] = value
  end
end)
