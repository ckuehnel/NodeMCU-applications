-- Title   : Lists NodeMCU and hardware information
-- Date    : 2015-07-30
-- Id      : nodemcu_info.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Created : Claus Kuehnel 

-- get NodeMCU and hardware information.
majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info()

-- print NodeMCU major version and minor version.
print("NodeMCU Version "..majorVer.."."..minorVer.."."..devVer)
print("\nChipID "..chipid)
print("FlashID "..flashid.." Flashsize "..flashsize/1000 .." MByte")
print("Flashmode ".. flashmode.." Flashspeed "..flashspeed/1000000 .." MHz")

-- get file system info
remaining, used, total=file.fsinfo()
print("\nFile system info:\nTotal : "..total.." Bytes\nUsed : "..used.." Bytes\nRemain: "..remaining.." Bytes\n")

-- print system availible heap size.
heap_size = node.heap()
print("Remaining heap size is: "..heap_size)

-- print current value of timer
print("NodeMCU running "..tmr.now()/1000000 .." sec from last restart\n")
