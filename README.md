rpcForSpeed
===========

RPC APIs to get network speed of openWRT

url http://router:/cgi-bin/luci/rpc/net.
method name: lookup.
params: a list of IPs, all IPs are string.

return value:
a table of speed(delay time).
e.g. {ip1:delaytime,ip2:delaytime2,...}.

libubus is is necessary on openWRT for communication between process
