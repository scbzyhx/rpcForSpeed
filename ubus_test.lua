--This is a program that 
--
local ubus = require("ubus")
local uloop = require "uloop"
uloop.init()
local conn = ubus.connect()
if not conn then
	error("Failed to connect to ubus")
end

--the method to be registered
local myMethod = {
	broken = {
		ttest = 1
	},
	rreply={
		ttest = {
			function(req,msg)
				print("in ttest")
				conn:reply(req, {message="echo"})
				print("Call to function ")
				for k,v in pairs(msg) do
					print("key="..k.." value="..tostring(v))
				end
			end,
				{id = ubus.INT32, msg = ubus.STRING }
		}
	}
}
conn:add(myMethod)
local myEvent = {
	reply = function(msg)
			print("Call to reply event")
			for k,v in pairs(msg) do
				print("key="..k.." value="..tostring(v))
			end
			print("start delay")
			for i=1,100 do
				for j=1,100000 do
					local a =10000*1000
				end
			end
			print("after delay")
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


