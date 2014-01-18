if ARGV[1] == nil then
  return "No mask given"
end 
local m = tonumber(ARGV[1])
local t = {}
for i, addresses in ipairs(redis.call("keys", "mo:user:*:addresses")) do
  local prefix = string.match(addresses, "(.+:%d+):addresses$")
  if prefix ~= nil then    
    local key = prefix..":subnets"
    redis.call("del", key)
    table.insert(t, key)
    for j, ip in ipairs(redis.call("hkeys", addresses)) do
      local s = subnet(ip, m)
      redis.call("sadd", key, s..":"..m)
    end
  end
end
return t

