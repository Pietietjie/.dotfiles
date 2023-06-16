require('user/plugin')
-- ----------------------------------------------------
-- Options
-- ----------------------------------------------------
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

vim.opt.smartindent = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wildmode = 'longest:full,full' -- For tab completion complete the longest common match then cycle through the matches
 
vim.opt.title = true

vim.opt.mouse = 'a'

vim.opt.termguicolors = true

vim.opt.spell = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true -- case sensitive searches when there is a capital in the search

vim.opt.list = true -- enable the below listchars
vim.opt.listchars = { tab = '▸ ', trail = '·' }

vim.opt.fillchars:append({ eob = ' ' })

vim.opt.splitright = true

vim.opt.scrolloff = 100
vim.opt.sidescrolloff = 100

vim.opt.confirm = true -- ask for confirmation instead of erroring

vim.opt.undofile = true -- persistent undo

vim.opt.backup = true -- automatically save a backup file

vim.opt.backupdir:remove('.') -- keep backups out of the current directory

-- ----------------------------------------------------
-- Key Bindings
-- ----------------------------------------------------

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Reselect visual selection after indenting
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

vim.keymap.set('n', '<leader>k', ':nohlsearch<CR>')

-- Open the current file in the default program (on Mac this should just be just `open`)
vim.keymap.set('n', '<leader>x', ':!xdg-open %<cr><cr>')


-- Move text up and down
vim.keymap.set('i', '<A-j>', '<Esc>:move .+1<CR>==gi')
vim.keymap.set('i', '<A-k>', '<Esc>:move .-2<CR>==gi')
vim.keymap.set('x', '<A-j>', ":move '>+1<CR>gv-gv")
vim.keymap.set('x', '<A-k>', ":move '<-2<CR>gv-gv")


