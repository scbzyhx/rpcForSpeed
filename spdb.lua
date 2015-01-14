
local modname =...
local luasql = require("luasql.sqlite3")
local util = require("util")

local dbfile = "/etc/db/hostdb.db"
local MAX_INT = 9876543210  -- may be a smaller integer is OK
local MAX_TTL = 256
local function connectToDB(dbFile)
	dbFile = dbFile or "/etc/db/hostdb.db"
	local env = luasql.sqlite3()
	local db = env:connect(dbFile,'wr')
	err = db:execute([[
	CREATE TABLE if not exists speedTable (nw_dst TEXT PRIMARY KEY COLLATE NOCASE, delay INTEGER,ttl INTEGER,bw REAL);
	]])
	
	return env,db,err
end
--
--delay time : an interger , 1/1000 millisecond
--           : (0,MAXINT) : delay time ----------in fact it's impossible be such a big number
--           : -1: NO DATA
--           : 0: unreachable
--TTL : integer
--bw is bandwidth value, REAL , KB/s 
--
local function insertSpeed(db,ip,delay,ttl,bw)
    ttl = ttl or MAX_TTL
    bw = bw or 0
    delay = delay or MAX_INT
    local cmd = string.format("INSERT INTO speedTable VALUES('%s',%d,%d,%f)",ip,delay,ttl,bw)
    local err = db:execute(cmd)
    return err
end

--args is a table, just delay ttl or bw is promised
local function updateSpeed(db,ip,args)
    if not util.isValidIP(ip) then
        print("invalid IP address")
        return nil
    end
    -- table mustn't be empty
    -- TO 
    if type(args) ~= 'table' then
        print("args must be a table")
    end
    local delay = args.delay
    local ttl = args.ttl
    local bw = args.bw
    local cmd = "UPDATE speedTable SET "
    if delay ~= nil then
        cmd = string.format(cmd.."delay = %d ",delay)
    end
    if ttl ~= nil then
        cmd = string.format(cmd.."ttl = %d ",ttl)
    end
    if bw ~= nil then
        cmd = string.format(cmd.."bw = %f ",bw)
    end

    cmd = string.format(cmd .. "WHERE ip = '%s'",ip)
    return db:execute(cmd)

end
local function delSpeed(db,ip)
    if not util.isValid(ip) then
        print("invalide IP address")
        return nil
    end
    local cmd = string.format("delete from speedTable where ip = '%s'",ip)
    return db:execute(cmd)
end
local function execute(db,cmd)
    return db:execute(cmd)
end
local function lookup(db,ip)
    --env,db,err = connectToDB()
    if lookup == nil or db == nil or util.isValidIP(ip) == false then
        print("invalid IP address or didn't connect to database")
    end
    local cmd = string.format("SELECT * FROM speedTable WHERE nw_dst = '%s'",ip)
    local cursor,err = db:execute(cmd)
    row = cursor:fetch({},'a')
    -- in fact only one row
    while row do
        --print(string.format("%s %d %d %d",row.nw_dst,row.delay,row.ttl,row.bw))
        --row = cursor:fetch(row,"a")
        return row.delay,row.ttl,row.bw
    end
    return nil

end

local function insert(ip,delay,ttl,bw)
    local env,db,err = connectToDB('tmp.db')
    insertSpeed(db,ip,delay,ttl,bw)
    db:close()
    env:close()
end

--test
--insert("192.168.1.1",1,1,1)
--env,db,err = connectToDB('tmp.db')
--print(lookup(db,'192.168.1.1'))

local M = {
    connectToDB = connectToDB,
    insertSpeed = insertSpeed,
    updateSpeed = updateSpeed,
    delSpeed = delSpeed,
    insert = insert,
    execute = execute
}
if modname == nil then
    spdb = M
else
    _G[modname] = M
end

return M
