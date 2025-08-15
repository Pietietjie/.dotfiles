vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- if windows use the chocolatey sqlite package
if (string.find(vim.loop.os_uname().sysname, "indows")) then
  vim.cmd("let g:sqlite_clib_path = '/ProgramData/chocolatey/lib/SQLite/tools/sqlite3.dll'")
end

-- Install package manager
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

  {
    'mbbill/undotree',
    event = "VeryLazy",
  },

  -- Git related plugins
  'tpope/vim-fugitive',
  --
  -- github plugin
  -- 'tpope/vim-rhubarb',

  -- adds, replaces, removes surrounding pairs
  'tpope/vim-surround',

  -- improves netrw
  'tpope/vim-vinegar',

  -- adds compatibility for "." in other packages
  'tpope/vim-repeat',

  -- use * to search visual mode selection
  {
    'nelstrom/vim-visual-star-search',
    event = "VeryLazy",
  },

  -- continue editing file from last location
  'farmergreg/vim-lastplace',

  -- Detect tabstop and shiftwidth automatically
  {
    'tpope/vim-sleuth',
    event = "VeryLazy",
  },

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
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
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
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    opts = {}
  },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = "VeryLazy",
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
        vim.keymap.set('n', '<leader>hv', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[h]unk pre[v]iew' })
        vim.keymap.set('n', '<leader>ha', require('gitsigns').stage_hunk, { buffer = bufnr, desc = '[h]unk [a]dd' })
        vim.keymap.set(
          'n',
          '<leader>hu',
          require('gitsigns').stage_hunk,
          {
            buffer = bufnr,
            desc =
            '[h]unk [u]nstage (Gitsigns removed the unstage hunk and it is now a toggle still keeping this for muscle memory)'
          }
        )
        vim.keymap.set('n', '<leader>hr', require('gitsigns').reset_hunk, { buffer = bufnr, desc = '[h]unk [r]eset' })
        vim.keymap.set(
          'n',
          '<leader>ga',
          function()
            vim.cmd("sil Git add %")
          end,
          { buffer = bufnr, desc = '[g]it [a]dd current buffer' }
        )
        vim.keymap.set(
          'n',
          '<leader>gu',
          function()
            vim.cmd("sil Git restore % --staged")
          end,
          { buffer = bufnr, desc = '[g]it [u]nstage current buffer' }
        )
        vim.keymap.set(
          'n',
          '<leader>gr',
          function()
            vim.cmd("sil Git restore %")
          end,
          { buffer = bufnr, desc = '[g]it [r]estore current buffer' }
        )
        vim.keymap.set('n', '<leader>gb', require('gitsigns').blame_line, { buffer = bufnr, desc = '[g]it [b]lame' })
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
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          {
            function()
              local recording_register = vim.fn.reg_recording()
              if recording_register == '' then
                return ''
              else
                return 'RECORDING @' .. recording_register
              end
            end,
            cond = function()
              return vim.fn.reg_recording() ~= ''
            end,
            color = { fg = '#E0AF68', bg = '#2D445D' },
          },
          'branch',
          'diff',
        },
        lualine_c = {
          {
            'filename',
            file_status = true,
            path = 1,
          },
        },
        lualine_x = { 'diagnostics', 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
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
          modified_icon = '😒',
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
    event = "VeryLazy",
  },

  {
    -- -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    event = "VeryLazy",
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
  {
    'numToStr/Comment.nvim',
    event = "VeryLazy",
    opts = {},
  },

  -- Fuzzy Finder (files, LSP, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
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
        enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 5,            -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20,     -- The Z-index of the context window
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
      'whatyouhide/vim-textobj-xmlattr',     -- for XML based text objects
      'kana/vim-textobj-entire',             -- for 'ae' and 'ie' everything
      'glts/vim-textobj-comment',            -- comments 'ac' and 'ic'
      'michaeljsmith/vim-indent-object',     -- 'ii' indentation
      'kana/vim-textobj-lastpat',            -- 'i/' last searched pattern
      'Julian/vim-textobj-variable-segment', -- 'iv' case segment
    }
  },

  {
    'nishigori/increment-activator',
    event = "VeryLazy",
    config = function()
      vim.cmd(
        "let g:increment_activator_filetype_candidates = { '_': [['true', 'false'],['enable', 'disable'],['enabled','disabled'],], }"
      )
    end
  },

  -- saves buffers automatically
  'pocco81/auto-save.nvim',

  -- Syntax and indent for Laravel blade files
  -- loading this on ft because that seems to work better for some reason
  -- otherwise indents for example only work after set ft=blade
  {
    "jwalton512/vim-blade",
    event = "VeryLazy",
    ft = "blade",
  },

  -- improves the styling of the folded lines
  {
    "bbjornstad/pretty-fold.nvim",
    event = "VeryLazy",
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

  -- hides env values
  'laytan/cloak.nvim',

  -- useless plugin
  {
    'eandrju/cellular-automaton.nvim',
    event = "VeryLazy",
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- TODO enable
      -- "rcarriga/nvim-notify",
    }
  },

  {
    'laytan/tailwind-sorter.nvim',
    event = "VeryLazy",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
    build = 'cd formatter && npm ci && npm run build',
    config = true,
  },
}, {})

-- [[ configure noice ]]
require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = true,         -- use a classic bottom cmdline for search
    command_palette = true,       -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false,       -- add a border to hover docs and signature help
  },
})



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

-- For tab completion complete the longest common match then cycle through the matches
vim.opt.wildmode = 'longest:full,full'

vim.opt.title = true

vim.opt.mouse = 'a'

vim.opt.termguicolors = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true -- case sensitive searches when there is a capital in the search

vim.opt.list = true      -- enable the below listchars
vim.opt.listchars = { tab = '▸ ', trail = '·' }

vim.opt.fillchars:append({ eob = ' ' })

vim.opt.splitright = true

vim.opt.spell = true
vim.opt.spelllang = 'en_us'
vim.opt.spelloptions = 'camel'

vim.opt.scrolloff = 100
vim.opt.sidescrolloff = 100

vim.opt.confirm = true        -- ask for confirmation instead of erring

vim.opt.undofile = true       -- persistent undo

vim.opt.backup = true         -- automatically save a backup file

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
-- Key Bindings/Shortcuts/Keybinds
-- ----------------------------------------------------
vim.keymap.set({ 'n', 'v' }, 'x', '"_x')
vim.keymap.set('n', 's', 'ys', { desc = 'Vim surround', remap = true })
vim.keymap.set('v', 's', 'S', { desc = 'Vim surround', remap = true })
-- treesitter repeat that overrides the ;,fFtT
local treesitter_repeat = require('nvim-treesitter.textobjects.repeatable_move')
vim.keymap.set({ 'n', 'x', 'o' }, ';', treesitter_repeat.repeat_last_move, { desc = 'Repeat last Treesitter move' })
vim.keymap.set({ 'n', 'x', 'o' }, ',', treesitter_repeat.repeat_last_move_opposite,
  { desc = 'Repeat last Treesitter move opposite' })
vim.keymap.set({ 'n', 'x', 'o' }, 'f', treesitter_repeat.builtin_f_expr,
  { expr = true, desc = 'Treesitter find char forward' })
vim.keymap.set({ 'n', 'x', 'o' }, 'F', treesitter_repeat.builtin_F_expr,
  { expr = true, desc = 'Treesitter find char backward' })
vim.keymap.set({ 'n', 'x', 'o' }, 't', treesitter_repeat.builtin_t_expr,
  { expr = true, desc = 'Treesitter to char forward' })
vim.keymap.set({ 'n', 'x', 'o' }, 'T', treesitter_repeat.builtin_T_expr,
  { expr = true, desc = 'Treesitter to char backward' })

local next_diagnostic, prev_diagnostic = treesitter_repeat.make_repeatable_move_pair(
  vim.diagnostic.goto_next,
  vim.diagnostic.goto_prev
)
vim.keymap.set('n', '[d', prev_diagnostic, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', next_diagnostic, { desc = 'Go to next diagnostic message' })

local next_buffer, prev_buffer = treesitter_repeat.make_repeatable_move_pair(
  function() vim.cmd('bnext') end,
  function() vim.cmd('bprevious') end
)
vim.keymap.set('n', ']b', next_buffer, { desc = 'Next buffer' })
local first_buffer, last_buffer = treesitter_repeat.make_repeatable_move_pair(
  function() vim.cmd('blast') end,
  function() vim.cmd('bfirst') end
)
vim.keymap.set('n', ']B', first_buffer, { desc = 'Last buffer' })
vim.keymap.set('n', '[B', last_buffer, { desc = 'First buffer' })
vim.keymap.set('n', '[b', prev_buffer, { desc = 'Previous buffer' })

local next_qf, prev_qf = treesitter_repeat.make_repeatable_move_pair(
  function() vim.cmd('cnext') end,
  function() vim.cmd('cprevious') end
)
vim.keymap.set('n', ']q', next_qf, { desc = 'Next quickfix' })
vim.keymap.set('n', '[q', prev_qf, { desc = 'Previous quickfix' })
local first_qf, last_qf = treesitter_repeat.make_repeatable_move_pair(
  function() vim.cmd('clast') end,
  function() vim.cmd('cfirst') end
)
vim.keymap.set('n', ']Q', first_qf, { desc = 'Last quickfix' })
vim.keymap.set('n', '[Q', last_qf, { desc = 'First quickfix' })

local next_loc, prev_loc = treesitter_repeat.make_repeatable_move_pair(
  function() vim.cmd('lnext') end,
  function() vim.cmd('lprevious') end
)
vim.keymap.set('n', ']l', next_loc, { desc = 'Next location list' })
vim.keymap.set('n', '[l', prev_loc, { desc = 'Previous location list' })
local first_loc_list, last_loc_list = treesitter_repeat.make_repeatable_move_pair(
  function() vim.cmd('llast') end,
  function() vim.cmd('lfirst') end
)
vim.keymap.set('n', ']L', first_loc_list, { desc = 'Last location list' })
vim.keymap.set('n', '[L', last_loc_list, { desc = 'First location list' })

local next_arg, prev_arg = treesitter_repeat.make_repeatable_move_pair(
  function() vim.cmd('next') end,
  function() vim.cmd('previous') end
)
vim.keymap.set('n', ']a', next_arg, { desc = 'Next argument' })
vim.keymap.set('n', '[a', prev_arg, { desc = 'Previous argument' })

local next_tag, prev_tag = treesitter_repeat.make_repeatable_move_pair(
  function() vim.cmd('tnext') end,
  function() vim.cmd('tprevious') end
)
vim.keymap.set('n', ']t', next_tag, { desc = 'Next tag' })
vim.keymap.set('n', '[t', prev_tag, { desc = 'Previous tag' })

local next_hunk, prev_hunk = treesitter_repeat.make_repeatable_move_pair(
  function() require('gitsigns').nav_hunk('prev', { target = 'all' }) end,
  function() require('gitsigns').nav_hunk('next', { target = 'all' }) end
)
vim.keymap.set('n', ']h', next_hunk, { desc = 'Next git hunk' })
vim.keymap.set('n', '[h', prev_hunk, { desc = 'Previous git hunk' })

local next_spell, prev_spell = treesitter_repeat.make_repeatable_move_pair(
  function() vim.cmd('normal! ]s') end,
  function() vim.cmd('normal! [s') end
)
vim.keymap.set('n', ']s', next_spell, { desc = 'Next misspelling' })
vim.keymap.set('n', '[s', prev_spell, { desc = 'Previous misspelling' })

-- vim.keymap.'set'({'n', 'v'}, 's', '"_s')
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
-- vim.keymap.set('i', 'jj', '<Esc>')
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
-- made that capital c & d work as usual when prefaced with c or d
vim.keymap.set("n", "dD", "D")
vim.keymap.set("n", "cC", "C")
-- useless binding for useless plugin
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")

-- keybinding/keymaps that use the leader key
vim.keymap.set("n", "<leader>=", vim.lsp.buf.format, { desc = "Formats the entire buffer using the LSP's formatter" })
vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle, { desc = "Toggles the [u]ndo [t]ree side bar" })
vim.keymap.set(
  { 'n', 'v' },
  'q:',
  ':',
  { desc = 'Goes into command mode when accedently mashing q before the colon when trying to :q' }
)
vim.keymap.set("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[r]e[p]lace' })
vim.keymap.set({ 'n', 'v' }, '<leader>v', '<c-v>', { desc = 'Goes into [v]isual [b]lock mode' })
vim.keymap.set('n', '<leader>o', 'moo<Esc>`o', { desc = '[⬇] empty new line' })
vim.keymap.set('n', '<leader>O', 'moO<Esc>`o', { desc = '[⬆] empty new line' })
vim.keymap.set({ 'n', 'v' }, '<leader>c', '"_c', { desc = '[c]hange without copying' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d', { desc = '[d]elete without copying' })
vim.keymap.set({ 'n', 'v' }, '<leader>D', '"_d$', { desc = '[D]elete without copying until the end of the line' })
vim.keymap.set('v', '<leader>p', '"_c<C-r>"<ESC>', { desc = '[P]astes over without copying' })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = '[y]anks into system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"+y$', { desc = '[Y]anks into system clipboard until the end of the line' })
vim.keymap.set(
  { 'n', 'v' },
  '<leader>.',
  function()
    pcall(
      function()
        local count = vim.v.count
        if count == 0 then count = 1 end
        for _ = 1, count do
          vim.cmd('normal! n')
          vim.cmd('normal! .')
        end
      end
    )
  end,
  {
    noremap = true,
    silent = true,
    desc =
    '[→] Finds next and does the repeats the previous action. (For using with counts.)'
  }
)
vim.keymap.set('v', '<leader>j', 'joko', { desc = 'Move the selection both up and down' })
vim.keymap.set('v', '<leader>k', 'kojo', { desc = 'Move the selection both up and down' })
vim.keymap.set('v', '<leader>h', 'holo', { desc = 'Move the selection both left and right' })
vim.keymap.set('v', '<leader>l', 'loho', { desc = 'Move the selection both left and right' })
-- When text is wrapped, move by terminal rows, not lines, unless a count is provided
-- Fold related mappings
vim.keymap.set('n', '<leader>z', 'zfai', { desc = 'Fold Current Indentation', remap = true })
vim.keymap.set(
  'n',
  '<leader>az',
  'mz:%g/\\(public\\|protected\\|private\\|static\\)\\_s*function\\_s/normal zfafu<cr>:%g/\\/\\*\\*/normal zfac<cr>`z',
  { desc = 'Fold [a]ll', remap = true }
)
-- Open the current file in the default program (on Mac this should just be just `open`)
vim.keymap.set('n', '<leader>x', ':!xdg-open %<cr><cr>', { desc = 'E[x]ecute the current file' })
vim.keymap.set('n', '<leader>X', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'Make the current file e[X]ecutable' })

-- text object keymaps/bindings
vim.keymap.set({ 'o', 'x' }, 'ih', require('gitsigns').select_hunk)
vim.keymap.set({ 'o', 'x' }, 'ah', require('gitsigns').select_hunk)

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
-- [[ disable text width on git commit ]]
vim.api.nvim_create_augroup("gitcommit", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.textwidth = 0
  end,
  group = "gitcommit",
})

-- [[ Configure Telescope ]]
local telescopeActions = require("telescope.actions")
local previousHistoryAndChangeToNormalMode = function(prompt_bufnr)
  telescopeActions.cycle_history_prev(prompt_bufnr);
  local keys = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
  -- 'm' is the mode, you can find on the feedkeys docs, but your case is
  -- 'm', I think
  vim.api.nvim_feedkeys(keys, 'm', false)
end
local nextHistoryAndChangeToNormalMode = function(prompt_bufnr)
  telescopeActions.cycle_history_nextt(prompt_bufnr);
  local keys = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
  -- 'm' is the mode, you can find on the feedkeys docs, but your case is
  -- 'm', I think
  vim.api.nvim_feedkeys(keys, 'm', false)
end
local select_one_or_multi = function(prompt_bufnr)
  local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    telescopeActions.send_selected_to_qflist(prompt_bufnr)
    telescopeActions.open_qflist(prompt_bufnr)
  else
    require('telescope.actions').select_default(prompt_bufnr)
  end
end
local telescopeActionsLiveGrepArgs = require("telescope-live-grep-args.actions")

require('telescope').setup {
  defaults = {
    preview = {
      filetype_hook = function(filepath, bufnr, opts)
        local putils = require("telescope.previewers.utils")
        local function is_minified_file(path, buf)
          if path:match("%.min%.js$") or path:match("%.min%.css$") or
              path:match("%.min%.html$") or path:match("-min%.") then
            return true
          end
          local filename = vim.fn.fnamemodify(path, ":t")
          if filename:match("bundle") or filename:match("vendor") or
              filename:match("dist") or filename:match("build") then
            return true
          end
          local stat = vim.loop.fs_stat(path)
          if stat and stat.size > 1024 * 1024 then -- 1MB
            return true
          end
          local lines = vim.api.nvim_buf_get_lines(buf, 0, 5, false)
          for _, line in ipairs(lines) do
            -- If any line is extremely long (typical of minified files)
            if #line > 500 then
              return true
            end
          end
          return false
        end
        if is_minified_file(filepath, bufnr) then
          putils.set_preview_message(
            bufnr,
            opts.winid,
            "Preview disabled for minified/bundled files"
          )
          return false
        end
        return true
      end,
    },
    history = {
      path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
      limit = 100,
    },
    prompt_prefix = '',
    multi_icon = '> ',
    selection_caret = '> ',
    file_ignore_patterns = {
      "node_modules/",
      ".git/",
      ".vscode/",
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
        ["V"] = telescopeActions.toggle_selection,
        ["<C-a>"] = telescopeActions.toggle_all,
        ["<C-x>"] = telescopeActions.delete_buffer,
        ['<CR>'] = select_one_or_multi,
      },
      i = {
        ['<CR>'] = select_one_or_multi,
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<C-p>"] = previousHistoryAndChangeToNormalMode,
        ["<C-Down>"] = nextHistoryAndChangeToNormalMode,
        ["<C-Up>"] = previousHistoryAndChangeToNormalMode,
        ["<C-j>"] = nextHistoryAndChangeToNormalMode,
        ["<C-k>"] = previousHistoryAndChangeToNormalMode,
        ["<C-s>"] = telescopeActions.to_fuzzy_refine,
        ["<C-a>"] = telescopeActions.toggle_all,
        ["<C-x>"] = telescopeActions.delete_buffer,
      },
    },
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = {         -- extend mappings
        i = {
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
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function(args)
    vim.wo.wrap = true
  end,
})

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
local previousTelescopeMenuShowHistory = true;
local function telescope_menu_bind_n_and_v_mode(bindingInputVim, bindingAction, opt, dontShowPreviousHistory)
  vim.keymap.set(
    'n',
    bindingInputVim,
    function()
      previousTelescopeMenuAction = bindingAction;
      previousTelescopeMenuShowHistory = not dontShowPreviousHistory
      bindingAction();
    end,
    opt
  );
  vim.keymap.set(
    'v',
    bindingInputVim,
    function()
      previousTelescopeMenuAction = bindingAction;
      previousTelescopeMenuShowHistory = not dontShowPreviousHistory
      bindingAction(get_visual_selection());
    end,
    opt
  );
end
vim.keymap.set(
  'n',
  '<C-p>',
  function()
    if (previousTelescopeMenuAction == nil) then
      return;
    end
    previousTelescopeMenuAction();
    if (previousTelescopeMenuShowHistory) then
      local keys = vim.api.nvim_replace_termcodes('<C-p>', true, false, true)
      -- 'm' is the mode, you can find on the feedkeys docs, but your case is
      -- 'm', I think
      vim.api.nvim_feedkeys(keys, 'm', false)
    end
  end
)
-- See `:help telescope.builtin`
telescope_menu_bind_n_and_v_mode(
  '<leader>sf',
  function(defaultText)
    require('telescope.builtin').find_files { default_text = defaultText, initial_mode = defaultText and "normal" or "insert", hidden = true }
  end,
  { desc = '[s]earch [f]iles' }
)
telescope_menu_bind_n_and_v_mode(
  '<leader>sg',
  function(defaultText)
    if defaultText then
      defaultText = defaultText:gsub("[%.%*%[%]%^%$%\\%+%?%(%)%{%}%|]", "\\%1");
    end
    require('telescope').extensions.live_grep_args.live_grep_args({
      default_text = defaultText,
      initial_mode = defaultText and "normal" or "insert",
    })
  end, { desc = '[s]earch by [g]rep args' }
)
telescope_menu_bind_n_and_v_mode(
  '<leader>?',
  function(defaultText)
    require('telescope.builtin').oldfiles({ default_text = defaultText, initial_mode = "normal" })
  end,
  { desc = '[?] Find recently opened files' }, true
)
telescope_menu_bind_n_and_v_mode(
  '<leader><cr>',
  function(defaultText)
    require('telescope.builtin').buffers({ default_text = defaultText, initial_mode = "normal" })
  end,
  { desc = 'Find existing buffers' }, true
)
telescope_menu_bind_n_and_v_mode(
  '<leader>/',
  function(defaultText)
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
      default_text =
          defaultText,
      initial_mode = defaultText and "normal" or "insert",
      winblend = 10,
      previewer = false,
    }))
  end,
  { desc = '[/] Fuzzily search in current buffer' }, true
)
telescope_menu_bind_n_and_v_mode(
  '<leader>gs',
  function(defaultText)
    require('telescope.builtin').git_status({ default_text = defaultText, initial_mode = "normal" })
  end,
  { desc = 'Search current [g]it [s]tatus' }, true
)
telescope_menu_bind_n_and_v_mode(
  '<leader>gc',
  function(defaultText)
    require('telescope.builtin').git_commits({ default_text = defaultText, initial_mode = "normal" })
  end,
  { desc = 'Search [g]it [c]ommits' }, true
)
telescope_menu_bind_n_and_v_mode(
  '<leader>gt',
  function(defaultText)
    require('telescope.builtin').git_stash({ default_text = defaultText, initial_mode = "normal" })
  end,
  { desc = 'Search the [g]it s[t]ash' }, true
)
telescope_menu_bind_n_and_v_mode(
  '<leader>sd',
  function(defaultText)
    require('telescope.builtin').diagnostics({
      default_text = defaultText,
      initial_mode = defaultText and "normal" or
          "insert"
    })
  end,
  { desc = '[s]earch [d]iagnostics' }, true
)
telescope_menu_bind_n_and_v_mode(
  '<leader>sk',
  function(defaultText)
    require('telescope.builtin').keymaps({
      default_text = defaultText,
      initial_mode = defaultText and "normal" or
          "insert"
    })
  end,
  { desc = '[s]earch Binding/[k]eymaps' }
)
telescope_menu_bind_n_and_v_mode(
  '<leader>sh',
  function(defaultText)
    require('telescope.builtin').help_tags({
      default_text = defaultText,
      initial_mode = defaultText and "normal" or
          "insert"
    })
  end,
  { desc = '[s]earch [h]elp' }
)
-- configure tailwind class sorter
require('tailwind-sorter').setup({
  on_save_pattern = { '*.html', '*.js', '*.jsx', '*.tsx', '*.twig', '*.hbs', '*.php', '*.heex', '*.astro' }, -- The file patterns to watch and sort.
  node_path = 'node',
})

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'bash',
    'css',
    'diff',
    'git_config',
    'gitcommit',
    'git_rebase',
    'gitattributes',
    'gitignore',
    'json',
    'jq',
    'javascript',
    'jsdoc',
    'nginx',
    'html',
    'lua',
    'php',
    'phpdoc',
    'powershell',
    'regex',
    'scss',
    'sql',
    'twig',
    'toml',
    'typescript',
    'xml',
    'yaml',
    'vimdoc',
    'vim',
  },
  -- auto-install languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<M-o>',
      node_incremental = '<M-o>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-i>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['afu'] = '@function.outer',
        ['ifu'] = '@function.inner',
        ['afi'] = '@conditional.outer',
        ['ifi'] = '@conditional.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['a='] = '@assignment.outer',
        ['i='] = '@assignment.inner',
        ['ao'] = '@class.outer',
        ['io'] = '@class.inner',
        ['a,'] = '@parameter.outer',
        ['i,'] = '@parameter.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jump-list
      goto_next_start = {
        [']f'] = '@function.outer',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>wa'] = '@parameter.inner',
        ['<leader>wf'] = '@function.outer',
      },
      swap_previous = {
        ['<leader>wA'] = '@parameter.inner',
        ['<leader>wF'] = '@function.outer',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>-', function() vim.cmd('Explore .') end, { desc = 'Open Netrw in the project root' })

-- [[ Configure LSP ]]
-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

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
      on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')

        nmap('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')
        nmap('grr', vim.lsp.buf.references, '[g]oto quicklist [r]eferences')
        nmap(
          'grs',
          function()
            require('telescope.builtin').lsp_references({ initial_mode = "normal" })
          end,
          '[g]oto tele[s]cope references'
        )
        nmap('gI', vim.lsp.buf.implementation, '[g]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap(
          '<leader>sy',
          function()
            require('telescope.builtin').lsp_document_symbols({ initial_mode = "normal" })
          end,
          'Tele[s]cope Document S[y]mbols'
        )
        nmap(
          '<leader>swy',
          function()
            require('telescope.builtin').lsp_dynamic_workspace_symbols({ initial_mode = "normal" })
          end,
          'Tele[s]cope [w]orkspace S[y]mbols'
        )

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')
        nmap('<leader>wd', vim.lsp.buf.add_workspace_folder, '[w]orkspace [d]ir/folder add')
        nmap('<leader>wdr', vim.lsp.buf.remove_workspace_folder, '[w]orkspace [d]ir/folder [r]emove')
        nmap(
          '<leader>wl',
          function()
            vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end,
          '[w]orkspace [d]ir/folder [l]ist'
        )

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end,
      settings = servers[server_name],
    }
  end,
}

lspconfig.html.setup({
  filetypes = { "html", "templ", "twig" },
})
lspconfig.emmet_language_server.setup({
  filetypes = { "css", "eruby", "html", "htmldjango", "javascriptreact", "less", "pug", "sass", "scss", "typescriptreact", "htmlangular", "twig" },
})

-- [[ Configure nvim-cmp ]]
local cmp = require 'cmp'
local ls = require 'luasnip'
local s = ls.snippet
local f_node = ls.function_node
local t_node = ls.text_node
local i_node = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

require('luasnip.loaders.from_vscode').lazy_load()
ls.config.setup {}

ls.add_snippets("gitcommit", {
  s(":rename:", fmt("🚚{}", { i_node(1) })),
  s(":move:", fmt("🚚{}", { i_node(1) })),
  s(":feat:", fmt("✨{}", { i_node(1) })),
  s(":bug:", fmt("🐛{}", { i_node(1) })),
  s(":assets:", fmt("🍱{}", { i_node(1) })),
  s(":docs:", fmt("📝{}", { i_node(1) })),
  s(":deploy:", fmt("🚀{}", { i_node(1) })),
  s(":style_code:", fmt("🎨{}", { i_node(1) })),
  s(":formatting:", fmt("🎨{}", { i_node(1) })),
  s(":style_ui:", fmt("💄{}", { i_node(1) })),
  s(":remove:", fmt("🔥{}", { i_node(1) })),
  s(":nothing_burger:", fmt("🍔{}", { i_node(1) })),
  s(":performance:", fmt("⚡{}", { i_node(1) })),
  s(":work_in_progress:", fmt("🚧{}", { i_node(1) })),
  s(":tests_add:", fmt("✅{}", { i_node(1) })),
  s(":add_dependency:", fmt("➕{}", { i_node(1) })),
  s(":remove_dependency:", fmt("➖{}", { i_node(1) })),
  s(":upgrade_dependency:", fmt("⬆️{}", { i_node(1) })),
  s(":downgrade_dependency:", fmt("⬇️{}", { i_node(1) })),
  s(":pin_dependency_version:", fmt("📌{}", { i_node(1) })),
  s(":add_comments:", fmt("💡{}", { i_node(1) })),
  s(":refactor:", fmt("♻️{}", { i_node(1) })),
  s(":new_package:", fmt("📦{}", { i_node(1) })),
  s(":configuration:", fmt("🔧{}", { i_node(1) })),
  s(":internationalization:", fmt("🌐{}", { i_node(1) })),
  s(":i18n:", fmt("🌐{}", { i_node(1) })),
  s(":typo:", fmt("✏️{}", { i_node(1) })),
  s(":revert:", fmt("⏪{}", { i_node(1) })),
  s(":remove_linter_warning:", fmt("🚨{}", { i_node(1) })),
  s(":fix_ci:", fmt("💚{}", { i_node(1) })),
  s(":security:", fmt("🔒{}", { i_node(1) })),
  s(":add_logs:", fmt("🔊{}", { i_node(1) })),
  s(":remove_logs:", fmt("🔇{}", { i_node(1) })),
  s(":ux:", fmt("🚸{}", { i_node(1) })),
  s(":add_ci:", fmt("👷{}", { i_node(1) })),
  s(":analytics:", fmt("📈{}", { i_node(1) })),
  s(":tracking:", fmt("📈{}", { i_node(1) })),
  s(":accessibility:", fmt("♿{}", { i_node(1) })),
  s(":comments:", fmt("💡{}", { i_node(1) })),
  s(":add_text:", fmt("💬{}", { i_node(1) })),
  s(":copy_changes:", fmt("💬{}", { i_node(1) })),
  s(":add_contributors:", fmt("👥{}", { i_node(1) })),
  s(":infrastructure:", fmt("🏗️{}", { i_node(1) })),
  s(":responsive:", fmt("📱{}", { i_node(1) })),
  s(":mocking_test:", fmt("🤡{}", { i_node(1) })),
  s(":gitignore:", fmt("🙈{}", { i_node(1) })),
  s(":add_snapshots:", fmt("📸{}", { i_node(1) })),
  s(":experiment:", fmt("⚗️{}", { i_node(1) })),
  s(":seo:", fmt("🔍{}", { i_node(1) })),
  s(":add_seed_file:", fmt("🌱{}", { i_node(1) })),
  s(":add_feature_flag:", fmt("🚩{}", { i_node(1) })),
  s(":catch_errors:", fmt("🥅{}", { i_node(1) })),
  s(":add_animations:", fmt("💫{}", { i_node(1) })),
  s(":deprecated:", fmt("🗑️{}", { i_node(1) })),
  s(":authentication:", fmt("🛂{}", { i_node(1) })),
  s(":simple_fix:", fmt("🩹{}", { i_node(1) })),
  s(":data_exploration:", fmt("🧐{}", { i_node(1) })),
  s(":dead_code:", fmt("⚰️{}", { i_node(1) })),
  s(":add_failing_test:", fmt("🧪{}", { i_node(1) })),
  s(":business_logic:", fmt("👔{}", { i_node(1) })),
  s(":database:", fmt("🗂️{}", { i_node(1) })),
  s(":db:", fmt("🗂️{}", { i_node(1) })),
  s(":development_experience:", fmt("🧑‍💻{}", { i_node(1) })),
  s(":breaking_changes:", fmt("💥{}", { i_node(1) })),
  s(":fix_external_api:", fmt("👽{}", { i_node(1) })),
  s(":initial_commit:", fmt("🎉{}", { i_node(1) })),
  s(":code_cleanup:", fmt("🛁{}", { i_node(1) })),
  s(":improve_code:", fmt("💎{}", { i_node(1) })),
  s(":os_related:", fmt("💻{}", { i_node(1) })),
  s(":docker:", fmt("🐳{}", { i_node(1) })),
  s(":automation:", fmt("🤖{}", { i_node(1) })),
  s(":merge:", fmt("🔀{}", { i_node(1) })),
  s(":validation:", fmt("🦺{}", { i_node(1) })),
})
ls.add_snippets("php", {
  s("$app =", {
    t_node("$app = Wow_Application::getInstance();"),
  }),
  s("echo_print_r", {
    t_node("echo '<pre>';"),
    t_node({ "", "print_r([" }),
    i_node(0),
    t_node("]);"),
    t_node({ "", "die;" }),
  }),
  s("$placeholders =", {
    t_node("$placeholders = '(' . implode(',', array_fill(0, count("),
    i_node(0),
    t_node("), '?')) . ')';"),
  }),
})
ls.add_snippets("twig", {
  s("echo_all_vars", {
    t_node("<ol>"),
    t_node({ "", "    {% for key, value in _context  %}" }),
    t_node({ "", "      <li>{{ key }}: {{ value | json_encode }}</li>" }),
    t_node({ "", "    {% endfor %}" }),
    t_node({ "", "</ol>" }),
  }),
})
local function randomString(chars, length)
  local result = {}
  math.randomseed(os.time())
  for i = 1, length do
    local randomIndex = math.random(1, #chars)
    result[i] = chars:sub(randomIndex, randomIndex)
  end
  return table.concat(result)
end
ls.add_snippets("all", {
  s({ trig = "random string alpha num: (%d+)", regTrig = true }, {
    f_node(function(_, snip)
      local n = tonumber(snip.captures[1])
      local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return randomString(chars, n)
    end, {}),
  }),
  s({ trig = "random string alpha: (%d+)", regTrig = true }, {
    f_node(function(_, snip)
      local n = tonumber(snip.captures[1])
      local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
      return randomString(chars, n)
    end, {}),
  }),
  s({ trig = "random string: (%d+)", regTrig = true }, {
    f_node(function(_, snip)
      local n = tonumber(snip.captures[1])
      local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?/~"
      return randomString(chars, n)
    end, {}),
  }),
})


cmp.setup {
  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body)
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
    ['<C-e>'] = cmp.mapping(function(fallback)
      if ls.expand_or_locally_jumpable() then
        ls.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-a>'] = cmp.mapping(function(fallback)
      if ls.locally_jumpable(-1) then
        ls.jump(-1)
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

-- cloak config
require('cloak').setup({
  enabled = true,
  cloak_character = '•',
  -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
  highlight_group = 'Comment',
  -- Applies the length of the replacement characters for all matched
  -- patterns, defaults to the length of the matched pattern.
  cloak_length = nil, -- Provide a number if you want to hide the true length of the value.
  -- Whether it should try every pattern to find the best fit or stop after the first.
  try_all_patterns = true,
  -- Set to true to cloak Telescope preview buffers. (Required feature not in 0.1.x)
  cloak_telescope = true,
  -- Re-enable cloak when a matched buffer leaves the window.
  cloak_on_leave = false,
  patterns = {
    {
      -- Match any file starting with '.env'.
      -- This can be a table to match multiple file patterns.
      file_pattern = '.env*',
      -- Match an equals sign and any character after it.
      -- This can also be a table of patterns to cloak,
      -- example: cloak_pattern = { ':.+', '-.+' } for yaml files.
      cloak_pattern = '=.+',
      -- A function, table or string to generate the replacement.
      -- The actual replacement will contain the 'cloak_character'
      -- where it doesn't cover the original text.
      -- If left empty the legacy behavior of keeping the first character is retained.
      replace = nil,
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
