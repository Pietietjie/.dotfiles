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
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'solid' })
      end,
    },
  })

-- Install plugins
local use = require('packer').use

use('wbthomason/packer.nvim') -- Let packer manage itself

use({
    'jessarcher/onedark.nvim',
    config = function()
      vim.cmd('colorscheme onedark')
    end,
  })
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

use({
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'kyazdani42/nvim-web-devicons' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')

      telescope.setup({
          defaults = {
            path_display = { truncate = 1 },
            prompt_prefix = '   ',
            selection_caret = '  ',
            layout_config = {
              prompt_position = 'top',
            },
            sorting_strategy = 'ascending',
            mappings = {
              i = {
                ['<esc>'] = actions.close,
                ['<C-Down>'] = actions.cycle_history_next,
                ['<C-Up>'] = actions.cycle_history_prev,
              },
            },
            file_ignore_patterns = { '.git/' },
          },
          pickers = {
            find_files = {
              hidden = true,
            },
            buffers = {
              previewer = false,
              layout_config = {
                width = 80,
              },
            },
            oldfiles = {
              prompt_title = 'History',
            },
            lsp_references = {
              previewer = false,
            },
          },
        })

      require('telescope').load_extension('fzf')
      require('telescope').load_extension('live_grep_args')

      vim.keymap.set('n', '<leader>f', [[<cmd>lua require('telescope.builtin').find_files()<CR>]])
      vim.keymap.set('n', '<leader>F', [[<cmd>lua require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'All Files' })<CR>]]) -- luacheck: no max line length
      vim.keymap.set('n', '<leader>b', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
      vim.keymap.set('n', '<leader>g', [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]])
      vim.keymap.set('n', '<leader>h', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]])
      vim.keymap.set('n', '<leader>s', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])
  end,
})

use({
  'kyazdani42/nvim-tree.lua',
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    require('nvim-tree').setup({
        git = {
          ignore = false,
        },
        renderer = {
          group_empty = true,
          icons = {
            show = {
              folder_arrow = false,
            },
          },
          indent_markers = {
            enable = true,
          },
        }
      })
    vim.keymap.set('n', '<leader>t', ':NvimTreeFindFileToggle<CR>')
  end,
})

use({
    'nvim-lualine/lualine.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('lualine').setup({
          options = {
            globalstatus = true,
          },
        })
    end,
  })

use({
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('bufferline').setup({
          options = {
            tab_size = 0,
            max_name_length = 25,
            offsets = {
              {
                filetype = 'NvimTree',
                text = ' Files',
                textalign = 'left',
              },
            },
            modified_icon = '󱠇',
            custom_areas = {
              left = function()
                return {
                  { text = '    ', fg = '#282c34' },
                }
              end,
            },
          },
        })
    end,
  })
use({
  'lukas-reineke/indent-blankline.nvim',
  config = function() 
    require('indent_blankline').setup({
      filetype_exclude = {
        'help',
        'terminal',
        'dashboard',
        'packer',
        'lspinfo',
        'TelescopePrompt',
        'TelescopeResults',
      },
      buftype_exclude = {
        'terminal',
        'NvimTree',
      },
      show_trailing_blankline_indent = false,
      show_first_indent_level = true,
    })
    end,
})

use({
  'lewis6991/gitsigns.nvim',
  requires = 'nvim-lua/plenary.nvim',
  config = function()
    require('gitsigns').setup({
      sign_priority = 20,
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 0,
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', ']h', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true, buffer = bufnr })
        vim.keymap.set('n', '[h', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true, buffer = bufnr })
      end,
    })
    vim.keymap.set('n', 'gs', ':Gitsigns stage_hunk<CR>')
    vim.keymap.set('n', 'gS', ':Gitsigns undo_stage_hunk<CR>')
    vim.keymap.set('n', 'gv', ':Gitsigns preview_hunk<CR>')
    vim.keymap.set('n', 'gb', ':Gitsigns blame_line<CR>')
  end,
})

use({
  'voldikss/vim-floaterm',
  config = function()
    vim.keymap.set('n', '`', ':FloatermToggle scratch<CR>')
    vim.keymap.set('t', '`', '<C-\\><C-n>:FloatermToggle scratch<CR>')
    vim.g.floaterm_height = 0.4
    vim.g.floaterm_wintype = 'split'
  end,
})

use({
  'nvim-treesitter/nvim-treesitter',
  run = function()
    require('nvim-treesitter.install').update({with_sync = true})
  end,
  requires = {
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  config = function()
    require('nvim-treesitter.configs').setup({
        ensure_installed = 'all',
        highlight = {
          enable = true,
          disable = { 'NvimTree' },
          additional_vim_regex_highlighting = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["if"] = "@function.inner",
              ["af"] = "@function.outer",
              ["ic"] = "@class.inner",
              ["ac"] = "@class.outer",
              ['ia'] = '@parameter.inner',
              ['aa'] = '@parameter.outer',
            },
          },
        },
        context_commentstring = {
          enable = true,
        },
      })
  end,
})
-- ----------------------------------------------------
-- Automatically install plugins on first run
-- ----------------------------------------------------
if packer_bootstrap then
  require('packer').sync()
end


