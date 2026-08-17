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
    close = '%s;'
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

return M
