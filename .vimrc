nmap <F8> :TrinityToggleAll<CR>
nmap <F5> :TrinityToggleSourceExplorer<CR>
nmap <F6> :TrinityToggleTagList<CR>
nmap <F7> :TrinityToggleNERDTree<CR>

"tab是4個空白
set tabstop=4
"set list
"set listchars=tab:----

"關閉vi相容模式
set nocompatible
"using mouse
set mouse=nv
"搜尋時高亮顯示關閉
set nohls
"setting backspace
set backspace=indent,eol,start
"check spell
setlocal spell spelllang=en_us
set nospell

"filetype support
filetype on
filetype plugin on
filetype indent on

"set syntax
syntax on
"colorscheme
colorscheme desert

"remember commands
set history=1000
"remember undo
set undolevels=1000

"highlight 80
set colorcolumn=80
"display location
set ruler
"show cursor
set cursorline
"行號
set nu
"highlight current line
hi CursorLine term=bold ctermfg=Yellow gui=bold guifg=Yellow

"關於airline，打開tab行
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

"set status bar
set laststatus=2
"let the vim know term support color256
set term=xterm-256color

"跟上一行同樣縮進
set autoindent
"辨別是否要縮進
set smartindent
"設定縮排寬度為4
set shiftwidth=4

"encoding
"檔案編碼
set fenc=utf-8
set fencs=utf-8,big5,gbk,euc-jp,utf-16le
"vim 內部編碼
set enc=utf-8
"terminal編碼
set tenc=utf-8

"no backup
set nobackup
set noswapfile
"no beep
set visualbell
set noerrorbells

let Tlist_Ctags_Cmd="/usr/local/bin/ctags"

if has('vim_starting')
    set nocompatible               " Be iMproved
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc'

" My Bundles here:
"
" Note: You don't set neobundle setting in .gvimrc!
" Original repos on github

" -> TO DO <-
NeoBundle 'othree/html5.vim'
NeoBundle 'BBCode--Dahn'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'bling/vim-airline'
NeoBundle 'tpope/vim-fugitive'

filetype plugin indent on     " Required!

"
" Brief help
" :NeoBundleList          - list configured bundles
" :NeoBundleInstall(!)    - install(update) bundles
" :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles

" Installation check.
NeoBundleCheck
