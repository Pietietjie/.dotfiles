local ls = require("luasnip")
local s = ls.snippet
local i_node = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("cl", fmt("console.log({}){}", { i_node(1, "'💡'"), i_node(2) })),
  s("ce", fmt("console.error({}){}", { i_node(1, "'❌'"), i_node(2) })),
  s("cw", fmt("console.warn({}){}", { i_node(1, "'⚠️'"), i_node(2) })),
  s("ci", fmt("console.info({}){}", { i_node(1, "'💬'"), i_node(2) })),
  s("cdebug", fmt("console.debug({}){}", { i_node(1, "'🐞'"), i_node(2) })),
  s("ct", fmt("console.trace({}){}", { i_node(1, "''"), i_node(2) })),
  s("ca", fmt("console.assert({}, {}){}", { i_node(1), i_node(2, "'🤔'"), i_node(3) })),
  s("cc", fmt("console.clear(){}", { i_node(1) })),
  s("cco", fmt("console.count({}){}", { i_node(1, "'🔢'"), i_node(2) })),
  s("ccr", fmt("console.countReset({}){}", { i_node(1, "'🔄'"), i_node(2) })),
  s("cg", fmt("console.group({}){}", { i_node(1, "'👇'"), i_node(2) })),
  s("cgc", fmt("console.groupCollapsed({}){}", { i_node(1, "'📁'"), i_node(2) })),
  s("cge", fmt("console.groupEnd(){}", { i_node(1) })),
  s("cta", fmt("console.table({}){}", { i_node(1, "'📊'"), i_node(2) })),
  s("cti", fmt("console.time({}){}", { i_node(1, "'⏱️'"), i_node(2) })),
  s("cte", fmt("console.timeEnd({}){}", { i_node(1, "'🏁'"), i_node(2) })),
  s("ctl", fmt("console.timeLog({}){}", { i_node(1, "'⏳'"), i_node(2) })),
}
