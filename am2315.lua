-- ***************************************************************************
-- AM2315 module for ESP8266 with nodeMCU
--
-- Written by tectiv3
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************
local moduleName = ... 
local M = {}
_G[moduleName] = M

--default value for i2c communication
local id = 0
--default sensor address
local dev_addr = 0x5c

-- initialize i2c
--parameters:
--d: sda
--l: scl
function M.init(d, l, a)
    if (d ~= nil) and (l ~= nil) and (d >= 0) and (d <= 11) and (l >= 0) and ( l <= 11) and (d ~= l) then
        sda = d
        scl = l
    else
        print("i2c config failed!") return nil
    end
    if (a ~= nil) then
        dev_addr = a
    end
    i2c.setup(id, sda, scl, i2c.SLOW)
    print("init done")
end

function M.getData()
    return read_data()
end

function read_data()
     i2c.start(id)
     i2c.address(id, dev_addr, i2c.TRANSMITTER)
     i2c.stop(id)

     tmr.delay(800)

     i2c.start(id)
     response = i2c.address(id, dev_addr, i2c.TRANSMITTER)
     if response == false then return nil end
     i2c.write(id, 0x03)
     i2c.write(id, 0x00)
     i2c.write(id, 0x04)
     i2c.stop(id)

     tmr.delay(800)

     i2c.start(id)
     i2c.address(id, dev_addr, i2c.RECEIVER)
     str = i2c.read(id, 8)
     i2c.stop(0)

     b = {}
     str:gsub(".",function(c) table.insert(b,c) end)

     if string.byte(b[1]) ~= 3 then return nil end --checking for correct response
     if string.byte(b[2]) ~= 4 then return nil end --number of bytes returned, should be 4

     h = string.byte(b[3]) * 256 + string.byte(b[4]) --humidity
     h = h / 10
     t = string.byte(b[5]) * 256 + string.byte(b[6]) --temperature
     t = t / 10
     return t, h
end
return M
