local ls = require("luasnip")
local s = ls.snippet
local t_node = ls.text_node

return {
  s("echo_all_vars", {
    t_node("<ol>"),
    t_node({ "", "    {% for key, value in _context  %}" }),
    t_node({ "", "      <li>{{ key }}: {{ value | json_encode(constant('JSON_PRETTY_PRINT')) }}</li>" }),
    t_node({ "", "    {% endfor %}" }),
    t_node({ "", "</ol>" }),
  }),
}
