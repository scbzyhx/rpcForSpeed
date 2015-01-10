local function isValidIP(ip)
    return true
end

local M = {
    isValidIP = isValidIP
}

local modname = ...
if modname == nil then
    utils = M
else
    _G[modname] = M
end
