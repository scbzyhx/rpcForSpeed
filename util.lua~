local function isValidIP(ip)
    if ip == nil or type(ip) ~= "string" then
        return false
    end
    local chunks = {ip:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")}
    if(#chunks ~= 4) then
        return false
    end
    for _,val in pairs(chunks) do
        if (tonumber(val) < 0 or tonumber(val) > 255 ) then
            return false
        end
    end
    if tonumber(chunks[4]) == 255 then
        return false
    end

    return true
end

-- This program will test the speed of a specific ip, and get the delayTime value
local os = require "os"
local io = require "io"
--require "spdb"

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
    local ttl = string.gfind(s,'ttl=%d+')
    
    
    local s = string.gfind(s,'time=%d+%.%d+')
    --print(s)
    for ss in s do
        --print(ss)
        ss = string.gfind(ss,'%d+%.%d+')
        for t in ss do
            retval = retval + tonumber(t)*1000

        end
    end
    local delay =  math.floor(retval/4)
end


local M = {
    isValidIP = isValidIP,
    ping = ping
}
local function test()
    assert(isValidIP("192.168.1.1") == true)
    assert(isValidIP("192.168.1.255") == false)
    assert(isValidIP("192.168.1") == false)
end
local modname = ...
if modname == nil then
    utils = M
    return utils
else
    _G[modname] = M
    return _G[modname]
end


