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
