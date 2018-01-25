" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" neovim は python3 依存なので専用の virtualenv へのパス
let g:python3_host_prog = "$HOME/.pyenv/versions/neovim/bin/python"

let $CACHE = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let $CONFIG = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let $DATA = empty($XDG_DATA_HOME) ? expand('$HOME/.local/share') : $XDG_DATA_HOME

" dein {{{
let s:dein_dir = expand('$DATA/dein')

if &runtimepath !~# '/dein.vim'
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

  " Auto Download
  if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
  endif

  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" dein.vim settings
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let s:toml_dir = expand('$CONFIG/nvim/dein')

  call dein#load_toml(s:toml_dir . '/plugins.toml', {'lazy': 0})
  call dein#load_toml(s:toml_dir . '/lazy.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif
" }}}

" clipboard 共有
set clipboard+=unnamedplus

syntax on

set noswapfile
set nobackup

set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set cursorline
set number
" 不可視文字の表示
set list
" 背景色を Terminal の背景色と揃える
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none
