--This is a program that 
--
local ubus  = require "ubus"
local uloop = require "uloop"
local util  = require "luci.model.util"
local spdb  = require "luci.model.db"

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
                --k is IP and value is what ever, It seems good
                if util.isValidIP(k)  then
                    local delay,ttl = util.ping(k)
                    --print(v)
                    --print(delay)

                    spdb.insertSpeed(db,k,delay)
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

local allIP = {}
local timer
function t()
    if #allIP == 0 then
        local env,db,err = spdb.connectToDB()
        local cursor,err = spdb.execute(db,'SELECT * FROM speedTable')
        row = cursor:fetch({},'a')
        while row do
            table.insert(allIP,row.nw_dst)
            row = cursor:fetch(row,'a')
        end
        cursor:close()
        db:close()
        env:close()
    end

    local target = table.remove(allIP,1)
    
    local d,t = util.ping(target)
    
    local env,db,err = spdb.connectToDB()
    spdb.updateSpeed(db,target,{delay=d,ttl=t})
    --print('ttl='.. t)
    print(''..d.."  "..t)
    print(spdb.lookup(db,target))
    db:close()
    env:close()

	--print("1000 ms timer")
	timer:set(1000)
end
timer = uloop:timer(t)
timer:set(1000)

uloop.run()
conn:close()


