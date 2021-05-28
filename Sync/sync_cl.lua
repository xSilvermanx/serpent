RegisterNetEvent('scl:RecievePedData')
AddEventHandler('scl:RecievePedData', function(pedid, type, key, value)
  if type == 'Component' then

  elseif type == 'Prop' then

  elseif type == 'Inheritance' then

  elseif type == 'FaceFeature' then

  elseif type == 'Appearance' then

  elseif type == 'CurrPathfindingData' or type == 'OverridePathfindingData' or type == 'NextPathfindingData' or type == 'CurrObjectiveData' or type == 'OverrideObjectiveData' or type == 'NextObjectiveData' then
    scl_PedList[pedid][type][key] = value
  else
    scl_PedList[pedid][key] = value
  end
end)
