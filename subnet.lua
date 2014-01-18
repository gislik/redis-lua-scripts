local function subnet(ip, mask)
  if ip == nil or mask == nil then
    return nil
  end
  local s = {}
  local m
  local mask1 = tonumber(mask)
  local i = 32
  if mask1 >= 0 and mask1 < 32 then
    m = bit.lshift(-1, mask1)
  elseif mask1 == 32 then
    m = 0
  else
    return nil
  end
  for chunk in string.gmatch(ip, "(%d+)") do
    local num = tonumber(chunk)
    if num < 0 or num > 255 then
      return nil
    end
    i = i - 8
    local m1 = bit.rshift(m, i)
    table.insert(s, bit.band(num, m1))
  end
  if i == 0 then
    return table.concat(s, ".")
  else
    return nil
  end
end
