" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" neovim は python 依存なので専用の virtualenv へのパス
" let g:python_host_prog = system('(type pyenv &>/dev/null && echo -n "$(pyenv root)/versions/$(pyenv global | grep python2)/bin/python") || echo -n $(which python2)')
" let g:python3_host_prog = system('(type pyenv &>/dev/null && echo -n "$(pyenv root)/versions/$(pyenv global | grep python3)/bin/python") || echo -n $(which python3)')
let g:python3_host_prog = $PYENV_ROOT . '/shims/python2'
let g:python3_host_prog = $PYENV_ROOT . '/shims/python3'

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

" clipboard 共有
set clipboard+=unnamedplus

filetype plugin on
syntax on

set noswapfile
set nobackup
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set cursorline
" set cursorcolumn
set number
" 不可視文字の表示
set list
" 背景色を Terminal の背景色と揃える
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none


" Keybinds --------------------------------------------------
let g:mapleader = "\<Space>"
inoremap <silent> jj <ESC>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>W :wq<CR>
nnoremap <Leader>q :q<CR>

nmap <Esc><Esc> :nohl<CR>


" autocmd --------------------------------------------------
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


" languages --------------------------------------------------
" asm
au BufNewFile,BufRead *.asm set tabstop=4 shiftwidth=4
