-- This program will test the speed of a specific ip, and get the delayTime value
require "os"
require "io"
require "spdb"

-- ip  is a tring
function ping(ip)
    local cmd = "ping -c 4 -w 2 "..ip
    local f = assert(io.popen(cmd,'r'))
    local s = assert(f:read('*a'))
    f:close()
    --s = string.gsub(s,'^%s+','')
    --s = string.gsub(s,'%s+$','')
    --s = string.gsub(s,'[\n\r]+','')
    --print(s)
    local retval = 0
    local s = string.gfind(s,'time=%d+%.%d+')
    --print(s)
    for ss in s do
        --print(ss)
        ss = string.gfind(ss,'%d+%.%d+')
        for t in ss do
            retval = retval + tonumber(t)*1000

        end
    end
    return math.floor(retval/4)
end

function test()
    print(ping("192.168.1.1"))
end
local ips = {
    "114.212.80.1",
    "114.212.81.44",
    "114.212.82.107",
    "114.212.82.0"
}
function main()
    for k,v in pairs(ips) do
        spdb.insert(v,ping(v))
    end
end
print(string.format)
--test()
main()


