local api = vim.api

local M = {}

local QUOTES = { ['"'] = true, ["'"] = true, ['`'] = true }

local function is_string_type(node)
  local t = node:type()
  return t:find('string') ~= nil or t:find('quote') ~= nil or t:find('char') ~= nil
end

local function parse_delims(text, wanted)
  local prefix = text:match('^[%a_]*') or ''
  local rest = text:sub(#prefix + 1)
  local quote = rest:sub(1, 1)
  if not QUOTES[quote] then
    return nil
  end
  if wanted and quote ~= wanted then
    return nil
  end
  if #rest < 2 or rest:sub(-1) ~= quote then
    return nil
  end
  local triple = quote:rep(3)
  if #rest >= 6 and rest:sub(1, 3) == triple and rest:sub(-3) == triple then
    return #prefix, 3
  end
  return #prefix, 1
end

local function ensure_parsed(bufnr)
  pcall(function()
    vim.treesitter.get_parser(bufnr):parse(true)
  end)
end

local function string_node_at(bufnr, row, col, wanted)
  local ok, node = pcall(vim.treesitter.get_node, { bufnr = bufnr, pos = { row, col } })
  if not ok or not node then
    return nil
  end
  local loose
  local current = node
  while current do
    local ok_text, text = pcall(vim.treesitter.get_node_text, current, bufnr)
    if ok_text and text then
      local prefix, delim = parse_delims(text, wanted)
      if prefix then
        if is_string_type(current) then
          return current, prefix, delim
        end
        loose = loose or { current, prefix, delim }
      end
    end
    current = current:parent()
  end
  if loose then
    return loose[1], loose[2], loose[3]
  end
end

local function search_pattern(wanted)
  if wanted then
    return '\\V' .. wanted
  end
  return "['\"" .. '`' .. ']'
end

local function lookahead_node(bufnr, wanted)
  local found = vim.fn.searchpos(search_pattern(wanted), 'nWz')
  if found[1] == 0 then
    return nil
  end
  return string_node_at(bufnr, found[1] - 1, found[2] - 1, wanted)
end

local function line_end_col(bufnr, row)
  local line = api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ''
  return #line
end

function M.range(wanted, kind)
  local bufnr = api.nvim_get_current_buf()
  local cursor = api.nvim_win_get_cursor(0)
  ensure_parsed(bufnr)
  local node, prefix, delim = string_node_at(bufnr, cursor[1] - 1, cursor[2], wanted)
  if not node then
    node, prefix, delim = lookahead_node(bufnr, wanted)
  end
  if not node then
    return nil
  end

  local start_row, start_col, end_row, end_col = node:range()
  if kind == 'inner' then
    start_col = start_col + prefix + delim
    end_col = end_col - delim
  end

  if end_col == 0 then
    end_row = end_row - 1
    end_col = line_end_col(bufnr, end_row)
  end
  end_col = end_col - 1

  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    return nil
  end
  return { start_row, start_col }, { end_row, end_col }
end

local pending = nil

function M.apply()
  if not pending then
    return
  end
  local start_pos, end_pos = pending[1], pending[2]
  pending = nil
  if api.nvim_get_mode().mode ~= 'v' then
    vim.cmd.normal({ 'v', bang = true })
  end
  api.nvim_win_set_cursor(0, { start_pos[1] + 1, start_pos[2] })
  vim.cmd.normal({ 'o', bang = true })
  api.nvim_win_set_cursor(0, { end_pos[1] + 1, end_pos[2] })
end

function M.setup()
  local maps = {
    { 'i"', '"', 'inner' },
    { 'a"', '"', 'outer' },
    { "i'", "'", 'inner' },
    { "a'", "'", 'outer' },
    { 'i`', '`', 'inner' },
    { 'a`', '`', 'outer' },
    { 'iq', nil, 'inner' },
    { 'aq', nil, 'outer' },
  }
  for _, map in ipairs(maps) do
    local lhs, wanted, kind = map[1], map[2], map[3]
    local fallback = wanted and lhs or '<Esc>'
    vim.keymap.set({ 'x', 'o' }, lhs, function()
      local start_pos, end_pos = M.range(wanted, kind)
      if not start_pos then
        return fallback
      end
      pending = { start_pos, end_pos }
      return '<Cmd>lua require("pietietjie.quotes").apply()<CR>'
    end, { expr = true, desc = 'Treesitter ' .. kind .. ' quote' })
  end
end

return M
