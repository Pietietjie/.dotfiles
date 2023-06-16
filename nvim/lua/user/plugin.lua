-- ----------------------------------------------------
-- Packer bootstrap logic
-- ----------------------------------------------------
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Initialize packer
require('packer').init({
  compile_path = vim.fn.stdpath('data')..'/site/plugin/packer_compiled.lua',
  -- display = {
  --   open_fn = function()
  --     return require('packer.util').float({ border = 'solid' })
  --   end,
  -- },
})

-- Install plugins
local use = require('packer').use

use('wbthomason/packer.nvim') -- Let packer manage itself

-- ----------------------------------------------------
-- My plugins
-- ----------------------------------------------------

use('tpope/vim-repeat')
use('tpope/vim-commentary')
use('tpope/vim-surround')
use('tpope/vim-eunuch') -- Adds :Rename, :SudoWrite
use('tpope/vim-unimpaired') -- Adds [b and other handy mappings
use('tpope/vim-sleuth') -- Indent autodetection with editorconfig support

use({
  'sheerun/vim-polyglot',
})

use('christoomey/vim-tmux-navigator')
-- open files from the last place that it was opened on
use('farmergreg/vim-lastplace')
-- use * to search visual mode selection
use('nelstrom/vim-visual-star-search')
-- auto create dirs when saving a new file
use('jessarcher/vim-heritage')

-- xml text objects
use({
  'whatyouhide/vim-textobj-xmlattr',
  requires = 'kana/vim-textobj-user',
})

--make that nvim base dir the project file
use({
  'airblade/vim-rooter',
  setup = function()
    vim.g.rooter_manual_only = 1
  end,
  config = function()
    vim.cmd('Rooter')
  end,
})

-- auto closing brackets
use({
  'windwp/nvim-autopairs',
  config = function()
    require('nvim-autopairs').setup()
  end,
})

-- smooth scrolling on big jumps 
-- TODO: not currently working as expected will debut later
use({
  'karb94/neoscroll.nvim',
  config = function()
    require('neoscroll').setup()
  end,
})

-- split arrays and methods into multiple lines or join them
use({
  'AndrewRadev/splitjoin.vim',
  config = function()
    vim.g.splitjoin_html_attributes_bracket_on_new_line = 1
    vim.g.splitjoin_trailing_comma = 1
    vim.g.splitjoin_php_method_chain_full = 1

  end,
})

-- fixes indentation of pasted lines
use({
  'sickill/vim-pasta',
})
-- ----------------------------------------------------
-- Automatically install plugins on first run
-- ----------------------------------------------------
if packer_bootstrap then
  require('packer').sync()
end


