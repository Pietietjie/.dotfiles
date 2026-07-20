" Plain-vim config mirroring nvim/init.lua where no plugin is needed.

" ----------------------------------------------------
" Leader
" ----------------------------------------------------
let mapleader = ' '
let maplocalleader = ' '

nnoremap <silent> <Space> <Nop>
xnoremap <silent> <Space> <Nop>
nnoremap <silent> <Enter> <Nop>
xnoremap <silent> <Enter> <Nop>

" ----------------------------------------------------
" Options
" ----------------------------------------------------
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set exrc

set nohlsearch
set breakindent
set smartindent

set number
set relativenumber

set completeopt=menuone,noselect
set wildmode=longest:full,full

set title
set mouse=a
if has('termguicolors')
  set termguicolors
endif

set ignorecase
set smartcase

set list
set listchars=tab:▸\ ,trail:·
set fillchars+=eob:\

set splitright

set spell
set spelllang=en_us
set spelloptions=camel

set scrolloff=8
set confirm

set undofile
set undodir=~/.vim/undo//
if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), 'p')
endif

set backup
set backupdir-=.
set backupdir^=~/.vim/backup//
if !isdirectory(expand('~/.vim/backup'))
  call mkdir(expand('~/.vim/backup'), 'p')
endif

set signcolumn=yes:1

" ----------------------------------------------------
" netrw
" ----------------------------------------------------
let g:netrw_bufsettings = 'noma nomod nu nowrap ro nobl'
let g:netrw_fastbrowse = 0
autocmd FileType netrw setlocal number
autocmd FileType netrw setlocal bufhidden=delete

" ----------------------------------------------------
" Custom commands
" ----------------------------------------------------
command! E edit .env

" ----------------------------------------------------
" Insert-mode helpers
" ----------------------------------------------------
inoremap jj <Esc>
inoremap ;; <Esc>A;<Esc>
inoremap ,, <Esc>A,<Esc>
inoremap <C-v> <Esc>"+p

" ----------------------------------------------------
" Center-cursor motions
" ----------------------------------------------------
nnoremap <expr> k v:count == 0 ? 'gkzz' : 'kzz'
nnoremap <expr> j v:count == 0 ? 'gjzz' : 'jzz'
xnoremap j jzz
xnoremap k kzz
nnoremap <C-d> <C-d>zz
xnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
xnoremap <C-u> <C-u>zz
nnoremap <C-f> <C-f>zz
xnoremap <C-f> <C-f>zz
nnoremap <C-b> <C-b>zz
xnoremap <C-b> <C-b>zz
nnoremap n nzzzv
xnoremap n nzzzv
nnoremap N Nzzzv
xnoremap N Nzzzv
nnoremap G Gzz
xnoremap G Gzz
nnoremap gg ggzz
xnoremap gg ggzz
nnoremap { {zz
xnoremap { {zz
nnoremap } }zz
xnoremap } }zz
nnoremap % %zz
xnoremap % %zz
xnoremap o ozz

" ----------------------------------------------------
" Visual mode
" ----------------------------------------------------
xnoremap < <gv
xnoremap > >gv
xnoremap y myy`y
xnoremap Y myY`y

" ----------------------------------------------------
" Capital c/d passthrough
" ----------------------------------------------------
nnoremap dD D
nnoremap cC C

" ----------------------------------------------------
" Void-register cut/change/paste
" ----------------------------------------------------
nnoremap <leader>c "_c
xnoremap <leader>c "_c
nnoremap <leader>d "_d
xnoremap <leader>d "_d
nnoremap <leader>D "_d$
xnoremap <leader>D "_d$
nnoremap <leader>C "_c$
xnoremap <leader>C "_c$
xnoremap <leader>p "_c<C-r>"<Esc>
nnoremap x "_x
xnoremap x "_x

" ----------------------------------------------------
" System-clipboard yank
" ----------------------------------------------------
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>Y "+y$
xnoremap <leader>Y "+y$
nnoremap <silent> <leader>yn :let @+ = expand('%:.')<CR>:echo 'Relative path yanked'<CR>
nnoremap <silent> <leader>yp :let @+ = expand('%:p')<CR>:echo 'Absolute path yanked'<CR>

" ----------------------------------------------------
" Misc
" ----------------------------------------------------
nnoremap <silent> <leader>- :Explore .<CR>
nnoremap <leader>_ 1z=

nnoremap <leader>rp :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

nnoremap q: :
xnoremap q: :

nnoremap <leader>v <C-v>
xnoremap <leader>v <C-v>

nnoremap <leader>o moo<Esc>`o
nnoremap <leader>O moO<Esc>`o

xnoremap <leader>j joko
xnoremap <leader>k kojo
xnoremap <leader>h holo
xnoremap <leader>l loho

nnoremap <leader>z zfai

nnoremap <leader>x :!xdg-open %<CR><CR>
nnoremap <silent> <leader>X :!chmod +x %<CR>

" ----------------------------------------------------
" Find-next-and-repeat (supports count)
" ----------------------------------------------------
function! s:FindNextRepeat() abort
  let l:count = v:count == 0 ? 1 : v:count
  for _ in range(l:count)
    silent! normal! n.
  endfor
endfunction
nnoremap <silent> <leader>. :<C-u>call <SID>FindNextRepeat()<CR>
xnoremap <silent> <leader>. :<C-u>call <SID>FindNextRepeat()<CR>

" ----------------------------------------------------
" Quickfix Enter stays as normal Enter
" ----------------------------------------------------
augroup qf_enter
  autocmd!
  autocmd FileType qf nnoremap <buffer> <silent> <CR> <CR>
augroup END

" ----------------------------------------------------
" gitcommit: no forced text width
" ----------------------------------------------------
augroup gitcommit_notw
  autocmd!
  autocmd FileType gitcommit setlocal textwidth=0
augroup END

" ----------------------------------------------------
" Highlight on yank (mirrors vim.hl.on_yank)
" ----------------------------------------------------
if exists('##TextYankPost')
  augroup yank_highlight
    autocmd!
    autocmd TextYankPost * call s:HighlightYank()
  augroup END

  function! s:HighlightYank() abort
    if v:event.operator !=# 'y' | return | endif
    let l:start = getpos("'[")
    let l:end = getpos("']")
    let l:mid = '\%'.l:start[1].'l\%'.l:start[2].'c\_.*\%'.l:end[1].'l\%'.l:end[2].'c.'
    let l:id = matchadd('IncSearch', l:mid, 100)
    call timer_start(200, {-> matchdelete(l:id)})
  endfunction
endif
