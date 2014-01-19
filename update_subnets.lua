if ARGV[1] == nil then
  return "No mask given"
end 
local m = tonumber(ARGV[1])
local t = {}
for i, subnet in ipairs(redis.call("keys", "mo:subnets:*")) do
    redis.call("del", subnet)
end
for i, addresses in ipairs(redis.call("keys", "mo:user:*:addresses")) do
  local prefix, id = string.match(addresses, "(.+:(%d+)):addresses$")
  if prefix ~= nil then    
    local userkey = prefix..":subnets"
    table.insert(t, userkey)
    redis.call("del", userkey)
    for j, ip in ipairs(redis.call("hkeys", addresses)) do
      local s = subnet(ip, m)..":"..m
      local subnetkey = "mo:subnets:"..s
      table.insert(t, subnetkey)
      redis.call("sadd", userkey, s)
      redis.call("sadd", subnetkey, id)
    end
  end
end
return t

