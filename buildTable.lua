-- Id      : BuildTable
-- Date    : 2016-02-09
-- File    : buildTable.lua
-- Lua     : Lua for Windows V5.1
-- Created : Claus Kuehnel


POINTS = 90  -- steps over 360 grd, use multiples of 3 always
FILENAME = "rainbow.dat"

FROM_MIN = -.5
FROM_MAX =  .5

TO_MIN = 0
TO_MAX = 255

-- found at http://rosettacode.org/wiki/Map_range#Lua
function map_range( a1, a2, b1, b2, s )
	b = b1 + (s-a1)*(b2-b1)/(a2-a1)
	b = math.max(b, b1)
	b = math.min(b, b2)
	return math.floor(b)
end

function buildTables()
  print("Building RainbowTables from "..POINTS.." data points")
  green = {}; red = {}; blue = {}
  for i = 0, (POINTS - 1) do
    green[i+1] = map_range(FROM_MIN, FROM_MAX, TO_MIN, TO_MAX, math.cos((i*2*math.pi/POINTS) - (2*math.pi/3)))
	red[i+1]   = map_range(FROM_MIN, FROM_MAX, TO_MIN, TO_MAX, math.cos(i*2*math.pi/POINTS))
	blue[i+1]  = map_range(FROM_MIN, FROM_MAX, TO_MIN, TO_MAX, math.cos((i*2*math.pi/POINTS) - (4*math.pi/3)))
  end
--  print("GREEN") ; for i,v in ipairs(green) do print(i, v) end
--  print("RED  ") ; for i,v in ipairs(red) do print(i, v) end
--  print("BLUE ") ; for i,v in ipairs(blue) do print(i, v) end
end

function saveTables(fname)
  file = io.open(fname, "w")
  io.output(file)
  io.write(POINTS,"\n")
  for i,v in ipairs(green) do io.write(v,"\n") end
  for i,v in ipairs(red)   do io.write(v,"\n") end
  for i,v in ipairs(blue)  do io.write(v,"\n") end

  io.close(file)
  print("\nRainbowTables saved in "..FILENAME)
end

function readTables(fname)
  print("\nRainbowTables reading from "..FILENAME)
  file = io.open(fname, "r")
  io.input(file)
  line = io.read() pts = tonumber(line) print("Data points = ", pts)
  green = {}
  for i = 1, pts do line = io.read() green[i] = tonumber(line) end
  for i, v in ipairs(green) do print(i, v) end
  red = {}
  for i = 1, pts do line = io.read() red[i] = tonumber(line) end
  for i, v in ipairs(red) do print(i, v) end
  blue = {}
  for i = 1, pts do line = io.read() blue[i] = tonumber(line) end
  for i, v in ipairs(blue) do print(i, v) end
  io.close(file)
end

print(_VERSION)

buildTables()        -- Build the requested number of datapoints for the RainbowTable
saveTables(FILENAME) -- Save these data into File "rainbow.dat"
readTables(FILENAME) -- Read data back for test

