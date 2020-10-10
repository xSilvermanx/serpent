--[[for name, node in pairs(ListNodes) do
  if #node.paths ~= 0 then
    for _, link in ipairs(node.paths) do
      local blip = AddBlipForCoord(node.x, node.y, node.z)
      SetBlipSprite(blip, 399)
      SetBlipColour(blip, 1)
      SetBlipScale(blip, 0.5)
      SetBlipAsShortRange(blip, true)
      local dx = ListNodes[link[1] ].x
      local dy = ListNodes[link[1] ].y
      local rx = dx-node.x
      local ry = dy-node.y
      local angle = 0.0

      if ry > 0 then
        angle = math.atan(-rx / ry) *180 / math.pi
      elseif ry < 0 then
        angle = math.atan(-rx / ry) *180 / math.pi + 180.0
      else
        if rx > 0 then
          angle = 270
        else
          angle = 90
        end
      end

      angle = math.ceil(angle)

      SetBlipRotation(blip, angle)
    end
  else
    local blip = AddBlipForCoord(node.x, node.y, node.z)
    SetBlipColour(blip, 1)
    SetBlipSprite(blip, 148)
    SetBlipScale(blip, 0.5)
    SetBlipAsShortRange(blip, true)
  end
end]]
