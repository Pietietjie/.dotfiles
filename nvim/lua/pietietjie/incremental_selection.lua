local M = {}

local stacks = {}

local function parser_for(buf)
  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  if not ok or not parser then
    return nil
  end
  return parser
end

local function visual_range()
  local anchor = vim.fn.getpos('v')
  local cursor = vim.fn.getpos('.')
  local srow, scol = anchor[2] - 1, anchor[3] - 1
  local erow, ecol = cursor[2] - 1, cursor[3] - 1
  if srow > erow or (srow == erow and scol > ecol) then
    srow, scol, erow, ecol = erow, ecol, srow, scol
  end
  return { srow, scol, erow, ecol + 1 }
end

local function select_node(buf, node)
  local srow, scol, erow, ecol = node:range()
  if ecol == 0 then
    erow = erow - 1
    local line = vim.api.nvim_buf_get_lines(buf, erow, erow + 1, false)[1] or ''
    ecol = #line
  end
  ecol = math.max(ecol - 1, 0)

  if vim.fn.mode() ~= 'v' then
    vim.cmd('normal! v')
  end
  vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
  vim.cmd('normal! o')
  vim.api.nvim_win_set_cursor(0, { erow + 1, ecol })
end

local function same_range(a, b)
  local a1, a2, a3, a4 = a:range()
  local b1, b2, b3, b4 = b:range()
  return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
end

local function current_stack(buf)
  local stack = stacks[buf]
  if stack and #stack > 0 then
    local top = stack[#stack]
    local srow, scol, erow, ecol = top:range()
    local range = visual_range()
    if ecol == 0 then
      erow = erow - 1
      local line = vim.api.nvim_buf_get_lines(buf, erow, erow + 1, false)[1] or ''
      ecol = #line
    end
    if srow == range[1] and scol == range[2] and erow == range[3] and ecol == range[4] then
      return stack
    end
  end
  return nil
end

local function root_node(buf, range)
  local parser = parser_for(buf)
  if not parser then
    return nil
  end
  parser:parse(true)
  return parser:named_node_for_range(range, { ignore_injections = false })
end

local function init(buf)
  local range
  if vim.fn.mode():match('[vV\22]') then
    range = visual_range()
  else
    local cursor = vim.api.nvim_win_get_cursor(0)
    range = { cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2] + 1 }
  end
  local node = root_node(buf, range)
  if not node then
    return nil
  end
  stacks[buf] = { node }
  return stacks[buf]
end

local function scope_query(buf)
  local parser = parser_for(buf)
  if not parser then
    return nil
  end
  local ok, query = pcall(vim.treesitter.query.get, parser:lang(), 'locals')
  if not ok then
    return nil
  end
  return query
end

local function is_scope(query, node)
  if not query then
    return false
  end
  for id, _ in query:iter_captures(node, 0, node:start(), node:end_() + 1) do
    if query.captures[id] == 'local.scope' then
      return true
    end
  end
  return false
end

function M.init()
  local buf = vim.api.nvim_get_current_buf()
  local stack = init(buf)
  if stack then
    select_node(buf, stack[1])
  end
end

function M.node_incremental()
  local buf = vim.api.nvim_get_current_buf()
  local stack = current_stack(buf) or init(buf)
  if not stack then
    return
  end
  local node = stack[#stack]
  local parent = node:parent()
  while parent and same_range(parent, node) do
    parent = parent:parent()
  end
  if parent then
    stack[#stack + 1] = parent
  end
  select_node(buf, stack[#stack])
end

function M.scope_incremental()
  local buf = vim.api.nvim_get_current_buf()
  local stack = current_stack(buf) or init(buf)
  if not stack then
    return
  end
  local query = scope_query(buf)
  local node = stack[#stack]
  local parent = node:parent()
  while parent and (same_range(parent, node) or not is_scope(query, parent)) do
    parent = parent:parent()
  end
  if parent then
    stack[#stack + 1] = parent
  end
  select_node(buf, stack[#stack])
end

function M.node_decremental()
  local buf = vim.api.nvim_get_current_buf()
  local stack = current_stack(buf)
  if not stack then
    return
  end
  if #stack > 1 then
    stack[#stack] = nil
  end
  select_node(buf, stack[#stack])
end

return M
