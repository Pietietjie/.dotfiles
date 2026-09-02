local M = {}

local heredocs = {
  bash = {
    staticDelim = false,
    open = '<<%s',
    close = '%s'
  },
  sh = {
    staticDelim = false,
    open = '<<%s',
    close = '%s'
  },
  zsh = {
    staticDelim = false,
    open = '<<%s',
    close = '%s'
  },
  php = {
    staticDelim = false,
    open = '<<<%s',
    close = '%s'
  },
  ruby = {
    staticDelim = false,
    open = '<<~%s',
    close = '%s'
  },
  perl = {
    staticDelim = false,
    open = '<<"%s"',
    close = '%s'
  },
  lua = {
    staticDelim = true,
    open = '[[',
    close = ']]'
  },
  python = {
    staticDelim = true,
    open = '"""',
    close = '"""'
  },
  elixir = {
    staticDelim = true,
    open = '"""',
    close = '"""'
  },
}

local function languages_at_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then
    return { vim.bo[bufnr].filetype }
  end

  pcall(parser.parse, parser)

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local range = { row - 1, col, row - 1, col }
  local langs = {}

  local function descend(tree)
    table.insert(langs, tree:lang())
    for _, child in pairs(tree:children()) do
      if child:contains(range) then
        descend(child)
      end
    end
  end

  descend(parser)

  return langs
end

local function spec_at_cursor()
  local langs = languages_at_cursor()
  for i = #langs, 1, -1 do
    local spec = heredocs[langs[i]]
    if spec then
      return spec
    end
  end
end

function M.is_supported()
  return spec_at_cursor() ~= nil
end

function M.config()
  return spec_at_cursor()
end

function M.get_delims(tag)
  local spec = spec_at_cursor()
  if not spec then
    return nil
  end

  if tag == nil or tag == '' then
    tag = 'EOT'
  end

  return { open = spec.open:format(tag), close = spec.close:format(tag) }
end

local function find_open(open)
  local last = vim.fn.line('$')
  for _, offset in ipairs({ 0, -1, 1, -2, 2 }) do
    local lnum = vim.fn.line('.') + offset
    if lnum >= 1 and lnum <= last then
      local col = vim.fn.getline(lnum):find(open, 1, true)
      if col then
        return lnum, col
      end
    end
  end
end

local function find_close(open_lnum, close)
  local pattern = '^%s*' .. vim.pesc(close)
  for lnum = open_lnum + 1, vim.fn.line('$') do
    if vim.fn.getline(lnum):match(pattern) then
      return lnum
    end
  end
end

local function is_blank(lnum)
  return vim.fn.getline(lnum):match('^%s*$') ~= nil
end

local function drop_line(lnum)
  vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, {})
end

local function reindent(lines, indent, open_col)
  local body_min
  for i = 2, #lines - 1 do
    if not lines[i]:match('^%s*$') then
      local width = #lines[i]:match('^%s*')
      if not body_min or width < body_min then
        body_min = width
      end
    end
  end

  if lines[1]:sub(1, open_col - 1):match('^%s*$') then
    lines[1] = indent .. lines[1]:gsub('^%s*', '')
  end

  for i = 2, #lines - 1 do
    if not lines[i]:match('^%s*$') then
      lines[i] = indent .. lines[i]:sub(body_min + 1)
    end
  end

  lines[#lines] = indent .. lines[#lines]:gsub('^%s*', '')

  return lines
end

function M.current_indent()
  return vim.fn.getline('.'):match('^%s*')
end

function M.align(spec)
  local open_lnum, open_col = find_open(spec.open)
  if not open_lnum then
    return
  end

  local close_lnum = find_close(open_lnum, spec.close)
  if not close_lnum then
    return
  end

  if close_lnum > open_lnum + 1 and is_blank(close_lnum - 1) then
    drop_line(close_lnum - 1)
    close_lnum = close_lnum - 1
  end

  if close_lnum > open_lnum + 1 and is_blank(open_lnum + 1) then
    drop_line(open_lnum + 1)
    close_lnum = close_lnum - 1
  end

  local lines = vim.api.nvim_buf_get_lines(0, open_lnum - 1, close_lnum, false)
  vim.api.nvim_buf_set_lines(0, open_lnum - 1, close_lnum, false, reindent(lines, spec.indent, open_col))
end

return M
