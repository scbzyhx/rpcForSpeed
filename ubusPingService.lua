--This is a program that 
--
local ubus  = require "ubus"
local uloop = require "uloop"
local util  = require "util"
local spdb  = require "spdb"

uloop.init()
local conn = ubus.connect()
if not conn then
	error("Failed to connect to ubus")
end

--the method to be registered
local myMethod = {
	net={
		ping = {
			function(req,msg)
			    msg.status = "Not Supported"
			    conn:reply(req,msg)
			end,{id = ubus.INT32, msg = ubus.STRING }
		}
	}
}
conn:add(myMethod)
local myEvent = {
	ping = function(msg)
			print("Call to reply event")
			env,db,err = spdb.connectToDB()
			
			for k,v in pairs(msg) do
                --print("key="..k.." value="..tostring(v))
                --only for valid IP address
                if util.isValidIP(v)  then
                    local delay,ttl = util.ping(v)
                    --print(v)
                    --print(delay)

                    spdb.insertSpeed(db,v,delay)
                end
                --get delay and ttl, store them into db
                --util.ping()
                --spdb.insert()


			end
			db:close()
			env:close()
		end
}
conn:listen(myEvent)

local timer
function t()
	print("1000 ms timer")
	timer:set(1000)
end
--timer = uloop:timer(t)
--timer:set(1000)

uloop.run()
conn:close()


