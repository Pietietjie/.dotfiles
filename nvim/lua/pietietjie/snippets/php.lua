local ls = require("luasnip")
local s = ls.snippet
local t_node = ls.text_node
local i_node = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node

local laravel_cache = nil

local function is_laravel()
  if laravel_cache ~= nil then
    return laravel_cache
  end
  local clients = vim.lsp.get_clients({ name = 'intelephense' })
  if #clients == 0 then
    return false
  end
  local result = clients[1].request_sync('workspace/symbol', { query = 'Illuminate\\Foundation\\Application' }, 5000)
  local found = result and result.result and #result.result > 0
  laravel_cache = found
  return found
end

return {
  s("$app =", {
    t_node("$app = Wow_Application::getInstance();"),
  }),
  s("echo_print_r_die", {
    d(1, function()
      if is_laravel() then
        return sn(nil, { t_node("dd("), i_node(1, "\"😿\""), t_node(");") })
      else
        return sn(nil, {
          t_node("echo '<pre>';"),
          t_node({ "", "print_r([" }),
          i_node(1, "\"😢\""),
          t_node("]);"),
          t_node({ "", "die;" }),
        })
      end
    end),
  }),
  s("echo_print_r", {
    d(1, function()
      if is_laravel() then
        return sn(nil, { t_node("dump("), i_node(1, "\"😹\""), t_node(");") })
      else
        return sn(nil, {
          t_node("echo '<pre>';"),
          t_node({ "", "print_r([" }),
          i_node(1, "\"🤣\""),
          t_node("]);"),
          t_node({ "", "echo '</pre>';" }),
        })
      end
    end),
  }),
  s("$placeholders =", {
    t_node("$placeholders = '(' . implode(',', array_fill(0, count("),
    i_node(0),
    t_node("), '?')) . ')';"),
  }),
}
