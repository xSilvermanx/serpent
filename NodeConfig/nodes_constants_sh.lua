--[[
This file saves constants regarding nodes_sh.lua. Remember to verify the below data after nodes have been changed.

map corners
SW: (-3773.51, -4374.32) - closest node: AIRP-66
NW: (-3773.51, 8027.99) - closest node: PALCOV-1
NE: (4510.57, 8027.99) - closest node: BRADP-2
SE: (4510.57, -4388.38) - closest node: EBURO-57

biggest distance between two nodes
816.848, MTCHIL-5 and PALETO-4
]]

local SearchDistance = 450 -- search distance for FindClosestRoad. Calculation: BiggestDistance/2, then add wiggle room.
local MaximumDistanceFromSerpentPathToRoad = 20 -- wiggle distance to detect a road in FindClosestRoad.
