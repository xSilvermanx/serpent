scl_PedList = {}
scl_VehicleList = {}
scl_ObjectList = {}

AddEventHandler('scl:Startup', function()

  TriggerServerEvent('ssv:PlayerConnected')

  Wait(500)

  TriggerEvent('scl:MainClientPedLoop')
end)

FreemodeHashM = GetHashKey('mp_m_freemode_01')
FreemodeHashF = GetHashKey('mp_f_freemode_01')

TriggerEvent('scl:Startup')



CreateThread(function()
  while true do
    for pedid, peddata in ipairs(scl_PedList) do
      print('PedID', pedid)
      print('PedNetID', peddata.PedNetID)
      print('---')
    end
    print('------------')
    Wait(1000)
  end
end)
