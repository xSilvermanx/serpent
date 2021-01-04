function ssh_VectorDistance(x1, y1, z1, x2, y2, z2)
  local dist = math.sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)

  return dist
end
