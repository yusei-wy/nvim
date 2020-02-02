" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" --- plugins ---

" neovim は python 依存なので専用の virtualenv へのパス
let g:python_host_prog = $PYENV_ROOT . '/versions/neovim2/bin/python'
let g:python3_host_prog = $PYENV_ROOT . '/versions/neovim3/bin/python'

" ENV
let $CACHE = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let $CONFIG = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let $DATA = empty($XDG_DATA_HOME) ? expand('$HOME/.local/share') : $XDG_DATA_HOME

" Load rc file
function! s:load(file) abort
  let s:path = expand('$CONFIG/nvim/rc/' . a:file . '.vim')

  if filereadable(s:path)
    execute 'source' fnameescape(s:path)
  endif
endfunction

call s:load('plugins')

augroup initvim-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:initvim_local(expand('<afile>:p:h'))
augroup END

function! s:initvim_local(loc)
  let files = findfile('.init.vim.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

" ネストしたディレクトリを作成する関数
function! s:mkdir(dir)
  if !isdirectory(a:dir)
    " "p" を渡すことでネストしたディレクトリ全てが作成される
    call mkdir(a:dir, "p")
  endif
endfunction

" --- init ---

" clipboard 共有
set clipboard+=unnamedplus

filetype plugin on
syntax on

" colorscheme blue
" " 背景透過
" highlight Normal ctermbg=NONE guibg=NONE
" highlight LineNr ctermbg=NONE guibg=NONE

set noswapfile
set backupdir=$HOME/.vimbackup
call s:mkdir(&backupdir)
set undodir=$HOME/.vimundo
call s:mkdir(&undodir)

set t_Co=256
set termguicolors
set number
" カーソルの点滅
set guicursor=a:blinkon100
" 不可視文字の表示
set list
set listchars=tab:»\ ,trail:-,extends:»,precedes:«,nbsp:% "space 対応"
set ruler "カーソルが何行目の何列目に置かれているかを表示"
set colorcolumn=80
set autoindent
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set backspace=indent,eol,start
set mouse=a   "マウス有効"
set fileformats=unix,dos,mac
set autowrite " :make でファイル内容を自動保存

" --- Keybinds ---
let g:mapleader = "\<Space>"
inoremap <silent> jj <ESC>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>W :wq<CR>
nnoremap <Leader>q :q<CR>

nmap <Esc><Esc> :nohl<CR>


" --- autocmd ---
" カーソル位置記憶
autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif

" バイナリ編集(xxd)モード（vim -b での起動、もしくは *.bin ファイルを開くと発動します）
augroup BinaryXXD
  autocmd!
  autocmd BufReadPre  *.bin let &binary =1
  autocmd BufReadPost * if &binary | silent %!xxd -g 1
  autocmd BufReadPost * set ft=xxd | endif
  autocmd BufWritePre * if &binary | %!xxd -r | endif
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
augroup END
