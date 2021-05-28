function ssh_VectorDistance(x1, y1, z1, x2, y2, z2)
  local dist = math.sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)

  return dist
end

function ssh_getNormalisedVector(x1, y1, z1, x2, y2, z2)
  local x = x2 - x1
  local y = y2 - y1
  local z = z2 - z1

  local length = ssh_VectorDistance(0,0,0,x,y,z)

  local nx = x/length
  local ny = y/length
  local nz = z/length

  return nx, ny, nz
end

function ssh_getGameHeadingFromPoints(x1, y1, x2, y2) -- (x1, y1) -> (x2, y2) meaning (x1, y1) is the starting point
  local h = ssh_VectorDistance(x1, y1, 0.0, x2, y2, 0.0)
  local a = y2 - y1
  local g = x2 - x1

  local angle = math.acos(a/h) * 180.0 / math.pi

  if g > 0 then
    angle = 360.0 - angle
  end

  while angle < 0.0 or angle > 360.0 do
    if angle < 0.0 then
      angle = angle + 360.0
    else
      angle = angle - 360.0
      Wait(0)
    end
  end

  return angle
end
