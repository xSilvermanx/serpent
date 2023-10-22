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

-- Calculates the point R on any given line X1(x1, y1, z1) -> X2(x2, y2, z2) that is closest to given point X0(x0, y0, z0).
-- Also returns parameters r and d. d is the distance between point R and X0.
-- r is the line parameter defined by: X = X1 + r * (X2 - X1)
function ssh_GetPositionOnLineClosestToPoint(x0, y0, z0, x1, y1, z1, x2, y2, z2) 
  -- X2 - X1 = u
  local u1 = x2 - x1
  local u2 = y2 - y1
  local u3 = z2 - z1
  local pa1 = x0 - x1
  local pa2 = y0 - y1
  local pa3 = z0 - z1
  local u12 = u1^2
  local u22 = u2^2
  local u32 = u3^2

  local r = (u1*pa1+u2*pa2+u3*pa3)/(u12+u22+u32)

  local rx = x1 + r * (x2 - x1)
  local ry = y1 + r * (y2 - y1)
  local rz = z1 + r * (z2 - z1)

  local d = ssh_VectorDistance(rx, ry, rz, x0, y0, z0)

  return rx, ry, rz, r, d
end

function ssh_mphTomps(speed)
  newspeed = speed / 2.237
  return newspeed
end