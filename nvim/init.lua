vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- if windows use the chocolatey sqlite package
if (string.find(vim.loop.os_uname().sysname, "indows")) then
  vim.cmd("let g:sqlite_clib_path = '/ProgramData/chocolatey/lib/SQLite/tools/sqlite3.dll'")
end
-- add error handling
-- vim.cmd 'colorscheme tokyonight'

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    checker = {
        check_pinned = true
    },
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  --
  -- github plugin
  -- 'tpope/vim-rhubarb',

  -- adds, replaces, removes surrounding pairs
  'tpope/vim-surround',

  -- Adds some bindings useing the bracket pairing ] [
  'tpope/vim-unimpaired',

  -- improves netrw
  'tpope/vim-vinegar',

  -- adds compatibility for "." in other packages
  'tpope/vim-repeat',

  -- use * to search visual mode selection
  'nelstrom/vim-visual-star-search',

  -- continue editing file from last location
  'farmergreg/vim-lastplace',

  -- better language based highlighting
  -- TODO fix this as it is giving issues with lazy package manager
  -- 'sheerun/vim-polyglot',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- detects the root dir of the project
  {
    'airblade/vim-rooter',
    init = function() vim.g.rooter_manual_only = 1 end,
    config = function() vim.cmd('Rooter') end,
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      sign_priority = 20,
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '[h', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[H]unk Previous' })
        vim.keymap.set('n', ']h', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[H]unk Next' })
        vim.keymap.set('n', '<leader>hv', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[H]unk pre[V]iew' })
        vim.keymap.set('n', '<leader>ha', require('gitsigns').stage_hunk, { buffer = bufnr, desc = '[H]unk [A]dd' })
        vim.keymap.set('n', '<leader>hu', require('gitsigns').undo_stage_hunk, { buffer = bufnr, desc = '[H]unk [U]nstage' })
        vim.keymap.set('n', '<leader>hr', require('gitsigns').reset_hunk, { buffer = bufnr, desc = '[H]unk [R]eset' })
        vim.keymap.set('n', '<leader>ga', function () vim.cmd("sil Git add %") end, { buffer = bufnr, desc = '[G]it [A]dd current buffer' })
        vim.keymap.set('n', '<leader>gu', function () vim.cmd("sil Git restore % --staged") end, { buffer = bufnr, desc = '[G]it [U]nstage current buffer' })
        vim.keymap.set('n', '<leader>gr', function () vim.cmd("sil Git restore %") end, { buffer = bufnr, desc = '[G]it [R]estore current buffer' })
        vim.keymap.set('n', '<leader>gb', require('gitsigns').blame_line, { buffer = bufnr, desc = '[G]it [B]lame' })
      end,
    },
  },

  -- theme
  {
    'folke/tokyonight.nvim',
    priority = 1000,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    opts = {
      options = {
        theme = 'tokyonight',
        component_separators = '|',
      },
    },
  },
  -- Shows active buffers at the top to the screen kind of like vscode's file tabs
  {
    'akinsho/bufferline.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
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
            modified_icon = '😡',
            custom_areas = {
              left = function()
                return {
                  { text = '    ', fg = '#bb9af7', bg = '' },
                }
              end,
            },
          },
        })
    end,
  },
  -- Makes that bracket pairs have different colors based on level {#color1 {#color2 {#color3 { #color1 } } } }
  {
    'HiPhish/rainbow-delimiters.nvim',
  },
  {
    -- -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {
      exclude = {
        filetypes = {
          'help',
          'terminal',
          'lspinfo',
          'TelescopePrompt',
          'TelescopeResults',
        },
        buftypes = {
          'terminal'
        },
      },
      indent = {
        char = '┊',
      },
    },
  },

  -- Add comment key binding on "gc"
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, LSP, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        "nvim-telescope/telescope-live-grep-args.nvim" ,
        version = "^1.0.0",
      },
    }
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  -- adds history to telescope uses sqlite
  {
    'nvim-telescope/telescope-smart-history.nvim',
    dependencies = {
      'kkharji/sqlite.lua',
    }
  },

  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- show the current context of the cursor like which function, class, if statement, loop, etc. at the top of the buffer
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })
    end
  },

  -- copy paste intent fix
  'sickill/vim-pasta',

  -- allows easier custom text objects
  -- https://github.com/kana/vim-textobj-user/wiki
  {
    'kana/vim-textobj-user',
    dependencies = {
      'whatyouhide/vim-textobj-xmlattr', -- for XML based text objects
      'kana/vim-textobj-entire', -- for 'ae' and 'ie' everything
      'kana/vim-textobj-function', -- for 'af' and 'if' function
      'glts/vim-textobj-comment', -- comments 'ac' and 'ic'
      'michaeljsmith/vim-indent-object', -- 'ii' indentation
      'kana/vim-textobj-lastpat', -- 'i/' last searched pattern
      'sgur/vim-textobj-parameter', -- 'i,' argument
      'Julian/vim-textobj-variable-segment', -- 'iv' case segment
      'adriaanzon/vim-textobj-blade-directive', -- 'ad' blade directive
    }
  },

  {
    'nishigori/increment-activator',
    config = function ()
      vim.cmd( "let g:increment_activator_filetype_candidates = { '_': [['true', 'false'],['enable', 'disable'],['enabled','disabled'],], }")
    end
  },

  -- makes the background transparent to blend in with the terminal
  'xiyaowong/transparent.nvim',

  -- saves buffers automatically
  'pocco81/auto-save.nvim',

  -- Syntax and indent for Laravel blade files
  -- loading this on ft because that seems to work better for some reason
  -- otherwise indents for example only work after set ft=blade
  {
    "jwalton512/vim-blade",
    ft = "blade",
  },

  -- improves the styling of the folded lines
  {
    "anuvyklack/pretty-fold.nvim",
    config = function()
      require('pretty-fold').setup({
        sections = {
          left = {
            '› ', 'content',
          },
          right = {
            ' ', 'number_of_folded_lines', ': ', 'percentage', ' ',
            function(config) return config.fill_char:rep(3) end
          }
        },
        fill_char = ' ',
      })
    end

  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Un-comment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',
}, {})

-- ----------------------------------------------------
-- colorscheme
-- ----------------------------------------------------

vim.cmd 'colorscheme tokyonight-night'
vim.cmd 'highlight FloatShadow guibg=#24283b blend=none'
vim.cmd 'highlight FloatShadowThrough guibg=#24283b blend=none'
vim.cmd 'highlight Folded guifg=#7aa2f7 guibg=none'
vim.cmd 'highlight Todo guifg=#ffa500'
vim.cmd 'highlight BufferLineDevIconDefaultSelected ctermfg=66 guifg=#6d8086'
vim.cmd 'highlight BufferLineDevIconDefaultInactive ctermfg=66 guifg=#6d8086'
vim.cmd 'highlight BufferLineDevIconLuaSelected ctermfg=66 guifg=#6d8086'
vim.cmd 'highlight BufferLineDevIconLuaInactive ctermfg=66 guifg=#6d8086'

-- ----------------------------------------------------
-- Options
-- ----------------------------------------------------
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Set highlight on search
vim.o.hlsearch = false

-- Enable break indent
vim.o.breakindent = true

vim.opt.smartindent = true

vim.opt.number = true
vim.opt.relativenumber = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.opt.wildmode = 'longest:full,full' -- For tab completion complete the longest common match then cycle through the matches

vim.opt.title = true

vim.opt.mouse = 'a'

vim.opt.termguicolors = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true -- case sensitive searches when there is a capital in the search

vim.opt.list = true -- enable the below listchars
vim.opt.listchars = { tab = '▸ ', trail = '·' }

vim.opt.fillchars:append({ eob = ' ' })

vim.opt.splitright = true

vim.opt.spell = true
vim.opt.spelllang = 'en_us'
vim.opt.spelloptions = 'camel'

vim.opt.scrolloff = 100
vim.opt.sidescrolloff = 100

vim.opt.confirm = true -- ask for confirmation instead of erring

vim.opt.undofile = true -- persistent undo

vim.opt.backup = true -- automatically save a backup file

vim.opt.backupdir:remove('.') -- keep backups out of the current directory

vim.opt.signcolumn = 'yes:1'

vim.cmd('autocmd User TelescopePreviewerLoaded setlocal number')
vim.cmd('autocmd FileType netrw setl bufhidden=delete')
vim.cmd('let g:netrw_fastbrowse = 0')
vim.cmd('set lazyredraw')
vim.cmd('let g:netrw_bufsettings = \'noma nomod nu nowrap ro nobl\'')
vim.cmd('autocmd FileType netrw setlocal number')
-- ----------------------------------------------------
-- Custom Commands
-- ----------------------------------------------------
vim.api.nvim_create_user_command('E', 'e .env', {})
-- ----------------------------------------------------
-- Key Bindings/Shortcuts
-- ----------------------------------------------------
vim.keymap.set({'n', 'v'}, 'x', '"_x')
vim.keymap.set('n', 's', 'ys', { desc = 'Vim surround', remap = true })
vim.keymap.set('v', 's', 'S', { desc = 'Vim surround', remap = true })
-- vim.keymap.'set'({'n', 'v'}, 's', '"_s')
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set('i', 'jj', '<Esc>')
-- Easy insertion of a trailing ; or , from insert mode
vim.keymap.set('i', ';;', '<Esc>A;<Esc>')
vim.keymap.set('i', ',,', '<Esc>A,<Esc>')
-- Re-select visual selection after indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
-- Maintain the cursor position when yanking a visual selection @see http://ddrscott.github.io/blog/2016/yank-without-jank/
vim.keymap.set('v', 'y', 'myy`y')
vim.keymap.set('v', 'Y', 'myY`y')
-- System paste command
vim.keymap.set('i', '<C-v>', '<Esc>"+p', { desc = 'Paste from system clipboard' })
-- make that space can be used as a leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- keybinding/maps that use the leader key
vim.keymap.set({ 'n', 'v' }, 'q:', ':', { desc = 'Goes into command mode when accedently mashing q before the colon when trying to :q'} )
vim.keymap.set({ 'n', 'v' }, '<leader>vb', '<c-v>', { desc = 'Goes into [V]isual [B]lock mode'} )
vim.keymap.set('n', '<leader>o', 'moo<Esc>`o', { desc = '[⬇] empty new line'} )
vim.keymap.set('n', '<leader>O', 'moO<Esc>`o', { desc = '[⬆] empty new line'} )
vim.keymap.set({'n', 'v'}, '<leader>c', '"_c', { desc = '[C]hange without copying'} )
vim.keymap.set({'n', 'v'}, '<leader>d', '"_d', { desc = '[D]elete without copying'} )
vim.keymap.set('v', '<leader>p', '"_dP', { desc = '[P]astes over without copying'} )
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = '[Y]anks into system clipboard'} )
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+y$', { desc = '[Y]anks into system clipboard'} )
vim.keymap.set({'n', 'v'}, '<leader>.', function()
  pcall(function ()
    local count = vim.v.count
    if count == 0 then count = 1 end
    for _ = 1, count do
      vim.cmd('normal! n')
      vim.cmd('normal! .')
    end
  end)
end, { noremap = true, silent = true, desc = '[→] Finds next and does the repeats the previous action. (For using with counts.)' } )
vim.keymap.set('v', '<leader>j', 'joko', { desc = 'Move the selection both up and down'} )
vim.keymap.set('v', '<leader>k', 'kojo', { desc = 'Move the selection both up and down'} )
vim.keymap.set('v', '<leader>h', 'holo', { desc = 'Move the selection both left and right'} )
vim.keymap.set('v', '<leader>l', 'loho', { desc = 'Move the selection both left and right'} )
-- When text is wrapped, move by terminal rows, not lines, unless a count is provided
-- Fold related mappings
vim.keymap.set('n', '<leader>z', 'zfai', { desc = 'Fold Current Indentation', remap = true })
vim.keymap.set('n', '<leader>az', 'mz:%g/\\_sfunction\\_s\\(.\\|\\n\\)\\{-\\}\\_s*{/normal! gn%zf<cr>:%g/\\/\\*/normal zfac<cr>:%g/\\(public\\|protected\\|private\\) [a-zA-Z?]* \\$.\\{-\\} = [a-zA-Z(\'"]*\\n\\(\\n\\|.\\)\\{-\\};/normal! zfgn<cr>:%g/const \\_S* = [a-zA-Z(\'"]*\\n\\(\\n\\|.\\)\\{-\\};/normal! zfgn<cr>`z', { desc = 'Fold [A]ll', remap = true })
-- Open the current file in the default program (on Mac this should just be just `open`)
vim.keymap.set('n', '<leader>x', ':!xdg-open %<cr><cr>')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local telescopeActions = require("telescope.actions")
local previousHistoryAndChangeToNormalMode = function (prompt_bufnr)
  telescopeActions.cycle_history_prev(prompt_bufnr);
  local keys = vim.api.nvim_replace_termcodes('<ESC>',true,false,true)
  -- 'm' is the mode, you can find on the feedkeys docs, but your case is
  -- 'm', I think
  vim.api.nvim_feedkeys(keys,'m',false)
end
local nextHistoryAndChangeToNormalMode = function (prompt_bufnr)
  telescopeActions.cycle_history_nextt(prompt_bufnr);
  local keys = vim.api.nvim_replace_termcodes('<ESC>',true,false,true)
  -- 'm' is the mode, you can find on the feedkeys docs, but your case is
  -- 'm', I think
  vim.api.nvim_feedkeys(keys,'m',false)
end
local telescopeActionsLiveGrepArgs = require("telescope-live-grep-args.actions")
require('telescope').setup {
  defaults = {
    wrap_results = true,
    history = {
      path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
      limit = 100,
    },
    file_ignore_patterns = {
      "node_modules/",
      "dist/",
      ".git/",
      ".vscode/",
      ".min",
      "/bundle.",
    },
    mappings = {
      n = {
        q = telescopeActions.close,
        ["-"] = telescopeActions.close,
        ["<C-Down>"] = telescopeActions.cycle_history_next,
        ["<C-Up>"] = telescopeActions.cycle_history_prev,
        ["<C-p>"] = telescopeActions.cycle_history_prev,
        ["<C-j>"] = telescopeActions.cycle_history_next,
        ["<C-k>"] = telescopeActions.cycle_history_prev,
        ["<C-s>"] = telescopeActions.to_fuzzy_refine,
      },
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<C-p>"] = previousHistoryAndChangeToNormalMode,
        ["<C-Down>"] = nextHistoryAndChangeToNormalMode,
        ["<C-Up>"] = previousHistoryAndChangeToNormalMode,
        ["<C-j>"] = nextHistoryAndChangeToNormalMode,
        ["<C-k>"] = previousHistoryAndChangeToNormalMode,
        ["<C-s>"] = telescopeActions.to_fuzzy_refine,
      },
    },
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = { -- extend mappings
        i = {
          ["<C-s>"] = telescopeActions.to_fuzzy_refine,
          ["<C-i>"] = telescopeActionsLiveGrepArgs.quote_prompt({ postfix = " --iglob " }),
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    }
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
-- Enable telescope smart history, if installed
pcall(require('telescope').load_extension, 'smart_history')
-- Enable telescope live grep args, if installed
pcall(require('telescope').load_extension, 'live_grep_args')

-- from https://neovim.discourse.group/t/function-that-return-visually-selected-text/1601 @credit to https://github.com/kristijanhusak
-- also fixed with https://www.reddit.com/r/neovim/comments/1b3uarv/trouble_getting_start_and_end_position_of_a/
local function get_visual_selection()
  local s_start = vim.fn.getpos("v")
  local s_end = vim.fn.getpos(".")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

local previousTelescopeMenuAction = nil;
local function telescope_menu_bind_n_and_v_mode(bindingInputVim, bindingAction, opt)
  vim.keymap.set(
    'n',
    bindingInputVim,
    function ()
      previousTelescopeMenuAction = bindingAction;
      bindingAction();
    end,
    opt
  );
  vim.keymap.set(
    'v',
    bindingInputVim,
    function ()
      previousTelescopeMenuAction = bindingAction;
      bindingAction(get_visual_selection());
    end,
    opt
  );
end
vim.keymap.set(
  'n',
  '<C-p>',
  function ()
    if (previousTelescopeMenuAction == nil) then
      return;
    end
    previousTelescopeMenuAction();
    local keys = vim.api.nvim_replace_termcodes('<C-p>',true,false,true)
    -- 'm' is the mode, you can find on the feedkeys docs, but your case is
    -- 'm', I think
    vim.api.nvim_feedkeys(keys,'m',false)
  end
)
-- See `:help telescope.builtin`
telescope_menu_bind_n_and_v_mode('<leader>?', function (defaultText) require('telescope.builtin').oldfiles({ default_text = defaultText, initial_mode = "normal" }) end, { desc = '[?] Find recently opened files' })
telescope_menu_bind_n_and_v_mode('<leader>:', function (defaultText) require('telescope.builtin').commands({ default_text = defaultText, initial_mode = defaultText and "normal" or "insert"  }) end, { desc = '[:] Finds & executes vim commands from command mode' })
telescope_menu_bind_n_and_v_mode('<leader><cr>', function (defaultText) require('telescope.builtin').buffers({ default_text = defaultText, initial_mode = "normal" }) end, { desc = 'Find existing buffers' })
telescope_menu_bind_n_and_v_mode('<leader>/', function(defaultText) require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({ default_text = defaultText, initial_mode = defaultText and "normal" or "insert", winblend = 10, previewer = false, })) end, { desc = '[/] Fuzzily search in current buffer' })
telescope_menu_bind_n_and_v_mode('<leader>sf', function (defaultText) require('telescope.builtin').find_files { default_text = defaultText, initial_mode = defaultText and "normal" or "insert", hidden = true } end, { desc = '[S]earch [F]iles' })
telescope_menu_bind_n_and_v_mode('<leader>sb', function (defaultText) require('telescope.builtin').keymaps({ default_text = defaultText, initial_mode = defaultText and "normal" or "insert" }) end, { desc = '[S]earch [B]inding/Keymaps' })
telescope_menu_bind_n_and_v_mode('<leader>sh', function (defaultText) require('telescope.builtin').help_tags({ default_text = defaultText, initial_mode = defaultText and "normal" or "insert" }) end, { desc = '[S]earch [H]elp' })
telescope_menu_bind_n_and_v_mode('<leader>sg', function (defaultText) require('telescope').extensions.live_grep_args.live_grep_args({ default_text = defaultText, initial_mode = defaultText and "normal" or "insert" }) end, { desc = '[S]earch by [G]rep args' })
telescope_menu_bind_n_and_v_mode('<leader>gs', function (defaultText) require('telescope.builtin').git_status({ default_text = defaultText, initial_mode = "normal" }) end, { desc = 'Search current [G]it [S]tatus' })
telescope_menu_bind_n_and_v_mode('<leader>gh', function (defaultText) require('telescope.builtin').git_commits({ default_text = defaultText, initial_mode = "normal" }) end, { desc = 'Search [G]it [H]istory' })
telescope_menu_bind_n_and_v_mode('<leader>gc', function (defaultText) require('telescope.builtin').git_commits({ default_text = defaultText, initial_mode = "normal" }) end, { desc = 'Search [G]it [C]ommits' })
telescope_menu_bind_n_and_v_mode('<leader>gt', function (defaultText) require('telescope.builtin').git_stash({ default_text = defaultText, initial_mode = "normal" }) end, { desc = 'Search the [G]it s[T]ash' })
telescope_menu_bind_n_and_v_mode('<leader>gb', function (defaultText) require('telescope.builtin').git_branches({ default_text = defaultText, initial_mode = "normal" }) end, { desc = 'Search [G]it [B]ranches' })
telescope_menu_bind_n_and_v_mode('<leader>sd', function (defaultText) require('telescope.builtin').diagnostics({ default_text = defaultText, initial_mode = defaultText and "normal" or "insert" }) end, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

  -- auto-install languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to text obj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jump-list
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>-', function () vim.cmd('Explore .') end, { desc = 'Open Netrw in the project root'})

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', function () require('telescope.builtin').lsp_references({ initial_mode = "normal" }) end, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>sy', function () require('telescope.builtin').lsp_document_symbols({ initial_mode = "normal" }) end, 'Tele[S]cope Document S[Y]mbols')
  nmap('<leader>wy', function () require('telescope.builtin').lsp_dynamic_workspace_symbols({ initial_mode = "normal" }) end, '[W]orkspace S[Y]mbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local mason_lspconfig = require 'mason-lspconfig'

-- LSP servers to install
-- also @see https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  ["twiggy_language_server"] = {
  },
  intelephense = {
  },
  html = {
  },
  ["emmet_language_server"] = {
  },
}

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

local lspconfig = require('lspconfig');
mason_lspconfig.setup_handlers {
  function(server_name)
    lspconfig[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

lspconfig.html.setup({
  filetypes = {"html", "templ", "twig"},
})
lspconfig.emmet_language_server.setup({
  filetypes = { "css", "eruby", "html", "htmldjango", "javascriptreact", "less", "pug", "sass", "scss", "typescriptreact", "htmlangular", "twig" },
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

local function copy(args)
  return args[1]
end

luasnip.add_snippets("all", {
  -- trigger is `fn`, second argument to snippet-constructor are the nodes to insert into the buffer on expansion.
  luasnip.snippet("example", {
    -- Simple static text.
    luasnip.text_node("//Parameters: "),
    -- function, first parameter is the function, second the Placeholders
    -- whose text it gets as input.
    luasnip.function_node(copy, 2),
    luasnip.text_node({ "", "function " }),
    -- Placeholder/Insert.
    luasnip.insert_node(1),
    luasnip.text_node("("),
    -- Placeholder with initial text.
    luasnip.insert_node(2, "int foo"),
    -- Linebreak
    luasnip.text_node({ ") {", "\t" }),
    -- Last Placeholder, exit Point of the snippet.
    luasnip.insert_node(0),
    luasnip.text_node({ "", "}" }),
  }),
})
luasnip.add_snippets("php", {
  luasnip.snippet("$app =", {
    luasnip.text_node("$app = Wow_Application::getInstance();"),
  }),
  luasnip.snippet("echo_print_r", {
    luasnip.text_node("echo '<pre>';"),
    luasnip.text_node({ "", "print_r(" }),
    luasnip.insert_node(0),
    luasnip.text_node(");"),
    luasnip.text_node({ "", "die;" }),
  }),
})
luasnip.add_snippets("twig", {
  luasnip.snippet("echo_all_vars", {
    luasnip.text_node("<ol>"),
    luasnip.text_node({"", "    {% for key, value in _context  %}"}),
    luasnip.text_node({"", "      <li>{{ key }}: {{ value | json_encode }}</li>"}),
    luasnip.text_node({"", "    {% endfor %}"}),
    luasnip.text_node({"", "</ol>"}),
  }),
})

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-l>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
