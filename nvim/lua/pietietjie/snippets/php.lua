local ls = require("luasnip")
local s = ls.snippet
local t_node = ls.text_node
local i_node = ls.insert_node

return {
  s("$app =", {
    t_node("$app = Wow_Application::getInstance();"),
  }),
  s("echo_print_r_die", {
    t_node("echo '<pre>';"),
    t_node({ "", "print_r([" }),
    i_node(0),
    t_node("]);"),
    t_node({ "", "die;" }),
  }),
  s("echo_print_r", {
    t_node("echo '<pre>';"),
    t_node({ "", "print_r([" }),
    i_node(0),
    t_node("]);"),
    t_node({ "", "echo '</pre>';" }),
  }),
  s("$placeholders =", {
    t_node("$placeholders = '(' . implode(',', array_fill(0, count("),
    i_node(0),
    t_node("), '?')) . ')';"),
  }),
}
