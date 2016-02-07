wifi.setmode(wifi.STATION)
wifi.sta.config("Magesh","jayakumar")
print(wifi.sta.getip())
gpio.mode(5, gpio.OUTPUT)
gpio.mode(6, gpio.OUTPUT)
gpio.mode(7, gpio.OUTPUT)
gpio.mode(8, gpio.OUTPUT)
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."<h1> Web Server</h1>";
        buf = buf.."<p>LIGHT 1 <a href=\"?pin=ON1\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF1\"><button>OFF</button></a></p>";
        buf = buf.."<p>LIGHT 2 <a href=\"?pin=ON2\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF2\"><button>OFF</button></a></p>";
        buf = buf.."<p>LIGHT 3 <a href=\"?pin=ON3\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF3\"><button>OFF</button></a></p>";
        buf = buf.."<p>LIGHT 4 <a href=\"?pin=ON4\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF4\"><button>OFF</button></a></p>";
              local _on,_off = "",""
        if(_GET.pin == "ON1")then
              gpio.write(5, gpio.HIGH);
        elseif(_GET.pin == "OFF1")then
              gpio.write(5, gpio.LOW);
        elseif(_GET.pin == "ON2")then
              gpio.write(6, gpio.HIGH);
        elseif(_GET.pin == "OFF2")then
              gpio.write(6, gpio.LOW);
              elseif(_GET.pin == "ON3")then
              gpio.write(7, gpio.HIGH);
        elseif(_GET.pin == "OFF3")then
              gpio.write(7, gpio.LOW);
              elseif(_GET.pin == "ON4")then
              gpio.write(8, gpio.HIGH);
        elseif(_GET.pin == "OFF4")then
              gpio.write(8, gpio.LOW);
        end
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
