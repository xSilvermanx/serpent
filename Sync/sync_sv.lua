AddEventHandler('ssv:SendPedData', function(PlayerId, pedid, type, key, value)
  TriggerClientEvent('scl:RecievePedData', PlayerId, pedid, type, key, value)
end)

RegisterNetEvent('ssv:RecievePedData')
AddEventHandler('ssv:RecievePedData', function(pedid, type, key, value)
  if type == 'Component' then

  elseif type == 'Prop' then

  elseif type == 'Inheritance' then

  elseif type == 'FaceFeature' then

  elseif type == 'Appearance' then

  else
    ssv_PedList[pedid][key] = value
  end
end)
