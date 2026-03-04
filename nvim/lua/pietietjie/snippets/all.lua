local ls = require("luasnip")
local s = ls.snippet
local f_node = ls.function_node

local function randomString(chars, length)
  local result = {}
  math.randomseed(os.time())
  for i = 1, length do
    local randomIndex = math.random(1, #chars)
    result[i] = chars:sub(randomIndex, randomIndex)
  end
  return table.concat(result)
end

return {
  s({ trig = "random string alpha num: (%d+)", regTrig = true }, {
    f_node(function(_, snip)
      local n = tonumber(snip.captures[1])
      local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return randomString(chars, n)
    end, {}),
  }),
  s({ trig = "random string alpha: (%d+)", regTrig = true }, {
    f_node(function(_, snip)
      local n = tonumber(snip.captures[1])
      local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
      return randomString(chars, n)
    end, {}),
  }),
  s({ trig = "random string: (%d+)", regTrig = true }, {
    f_node(function(_, snip)
      local n = tonumber(snip.captures[1])
      local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?/~"
      return randomString(chars, n)
    end, {}),
  }),
}
