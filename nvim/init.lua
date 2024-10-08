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
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-eunuch',
  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'tpope/vim-vinegar',
  'tpope/vim-repeat',
  -- use * to search visual mode selection
  'nelstrom/vim-visual-star-search',
  -- better language based highlighting 
  -- TODO fix this as it is giving issues with lazy package manager
  -- 'sheerun/vim-polyglot',
  -- continue editing file from last location
  'farmergreg/vim-lastplace',
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    'airblade/vim-rooter',
    init = function()
      vim.g.rooter_manual_only = 1
    end,
    config = function()
      vim.cmd('Rooter')
    end,
  },
  -- auto closing brackets
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end,
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

  {
    -- Autocompletion
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
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 0,
      },
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
        vim.keymap.set('n', '<leader>hs', require('gitsigns').stage_hunk, { buffer = bufnr, desc = '[H]unk [S]tage' })
        vim.keymap.set('n', '<leader>hu', require('gitsigns').undo_stage_hunk, { buffer = bufnr, desc = '[H]unk [U]nstage' })
        vim.keymap.set('n', '<leader>hr', require('gitsigns').reset_hunk, { buffer = bufnr, desc = '[H]unk [R]eset' })
        vim.keymap.set('n', '<leader>ga', function () vim.cmd("sil Git add %") end, { buffer = bufnr, desc = '[G]it [A]dd current buffer' })
        vim.keymap.set('n', '<leader>gu', function () vim.cmd("sil Git restore % --staged") end, { buffer = bufnr, desc = '[G]it [U]nstage current buffer' })
        vim.keymap.set('n', '<leader>gr', function () vim.cmd("sil Git restore %") end, { buffer = bufnr, desc = '[G]it [R]estore current buffer' })
        vim.keymap.set('n', '<leader>gb', require('gitsigns').blame_line, { buffer = bufnr, desc = '[G]it [B]lame' })
      end,
    },
  },

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

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, LSP, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

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

  {
    'nvim-telescope/telescope-smart-history.nvim',
    dependencies = {
      'kkharji/sqlite.lua',
    }
  },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
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
  -- smooth scrolling
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup()
      local neoscroll_avail, neoscroll_config = pcall(require, "neoscroll.config")
         if neoscroll_avail then
         neoscroll_config.set_mappings {
              ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "25" } },
              ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "25" } },
          }
      end
    end,
  },
  -- copy paste intent fix
  'sickill/vim-pasta',

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
  'xiyaowong/transparent.nvim',
  'pocco81/auto-save.nvim',
  -- Syntax and indent files
  -- loading this on ft because that seems to work better for some reason
  -- otherwise indents for example only work after set ft=blade
  -- blade
  {
    "jwalton512/vim-blade",
    ft = "blade",
  },
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

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Un-comment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
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
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>vb', '<c-v>', { desc = 'Goes into [V]isual [B]lock mode'} )
vim.keymap.set('n', '<leader>o', 'moo<Esc>`o', { desc = '[⬇] empty new line'} )
vim.keymap.set('n', '<leader>O', 'moO<Esc>`o', { desc = '[⬆] empty new line'} )
vim.keymap.set({'n', 'v'}, 'x', '"_x')
vim.keymap.set({'n', 'v'}, 's', '"_s')
vim.keymap.set({'n', 'v'}, '<leader>c', '"_c', { desc = '[C]hanges without copying'} )
vim.keymap.set({'n', 'v'}, '<leader>d', '"_d', { desc = '[D]eletes without copying'} )
vim.keymap.set('v', '<leader>p', '"_dP', { desc = '[P]astes over without copying'} )
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = '[Y]anks into system clipboard'} )
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+y$', { desc = '[Y]anks into system clipboard'} )
-- When text is wrapped, move by terminal rows, not lines, unless a count is provided
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
-- Fold related mappings
vim.keymap.set('n', '<leader>z', 'zfai', { remap = true })

-- Re-select visual selection after indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Maintain the cursor position when yanking a visual selection
-- http://ddrscott.github.io/blog/2016/yank-without-jank/
vim.keymap.set('v', 'y', 'myy`y')
vim.keymap.set('v', 'Y', 'myY`y')

-- Paste replace visual selection without copying it
vim.keymap.set('v', 'p', '"_dP')

vim.keymap.set('i', 'jj', '<Esc>')

-- Easy insertion of a trailing ; or , from insert mode
vim.keymap.set('i', ';;', '<Esc>A;<Esc>')
vim.keymap.set('i', ',,', '<Esc>A,<Esc>')

-- Open the current file in the default program (on Mac this should just be just `open`)
vim.keymap.set('n', '<leader>x', ':!xdg-open %<cr><cr>')


-- Move text up and down
vim.keymap.set('i', '<A-j>', '<Esc>:move .+1<CR>==gi')
vim.keymap.set('i', '<A-k>', '<Esc>:move .-2<CR>==gi')
-- vim.keymap.set('i', '<A-J>', ":move '>+1<CR>gv-gv")
-- vim.keymap.set('i', '<A-K>', ":move '<-2<CR>gv-gv")

-- System paste command
vim.keymap.set('i', '<C-v>', '<Esc>"+p')

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
require('telescope').setup {
  defaults = {
    history = {
      path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
      limit = 100,
    },
    file_ignore_patterns = {
      "node_modules/",
      "dist/",
      ".git/",
      ".vscode/",
    },
    mappings = {
      n = {
        q = telescopeActions.close,
        ["<C-Down>"] = telescopeActions.cycle_history_next,
        ["<C-Up>"] = telescopeActions.cycle_history_prev,
        ["<C-p>"] = telescopeActions.cycle_history_prev,
        ["<C-j>"] = telescopeActions.cycle_history_next,
        ["<C-k>"] = telescopeActions.cycle_history_prev,
      },
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<C-p>"] = previousHistoryAndChangeToNormalMode,
        ["<C-Down>"] = nextHistoryAndChangeToNormalMode,
        ["<C-Up>"] = previousHistoryAndChangeToNormalMode,
        ["<C-j>"] = nextHistoryAndChangeToNormalMode,
        ["<C-k>"] = previousHistoryAndChangeToNormalMode,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
-- Enable telescope smart history, if installed
pcall(require('telescope').load_extension, 'smart_history')

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
telescope_menu_bind_n_and_v_mode('<leader>sg', function (defaultText) require('telescope.builtin').live_grep({ default_text = defaultText, initial_mode = defaultText and "normal" or "insert" }) end, { desc = '[S]earch by [G]rep' })
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

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

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
