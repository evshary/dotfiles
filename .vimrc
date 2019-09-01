" evshary           .__                                                     
"   _______  _______|  |__ _____ _______ ___.__.                            
" _/ __ \  \/ /  ___/  |  \\__  \\_  __ <   |  |                            
" \  ___/\   /\___ \|   Y  \/ __ \|  | \/\___  |                            
"  \___  >\_//____  >___|  (____  /__|   / ____|                            
"      \/         \/     \/     \/       \/     
" Tohsaka Rin
" ___________    .__                    __             __________.__        
" \__    ___/___ |  |__   ___________  |  | _______    \______   \__| ____  
"   |    | /  _ \|  |  \ /  ___/\__  \ |  |/ /\__  \    |       _/  |/    \ 
"   |    |(  <_> )   Y  \\___ \  / __ \|    <  / __ \_  |    |   \  |   |  \
"   |____| \____/|___|  /____  >(____  /__|_ \(____  /  |____|_  /__|___|  /
"                     \/     \/      \/     \/     \/          \/        \/ 
" Author: evshary
" Mail: evshary@gmail.com
" Date: 2015-04-01
" Updated:
" 2015-04-01 Tainan: Complete architecture of vimrc
" 2015-04-02 Tainan: Adjust the windows size and title

" mapping
" if python, F4 = call flake8
autocmd FileType python map <buffer> <F4> :call Flake8()<CR>

" Trinity mapping
nmap <F5> :TrinityToggleSourceExplorer<CR>
nmap <F6> :TrinityToggleTagList<CR>
nmap <F7> :TrinityToggleNERDTree<CR>
nmap <F8> :TrinityToggleAll<CR>

" :set is for setting options, :let for assigning a value to a variable.
" 因為mac的預設ctags有問題，所以要另外設定才能使用taglist
if has("unix")
  let s:uname = system("uname -s")
  if s:uname == "Darwin"
    " Do Mac stuff here
    let Tlist_Ctags_Cmd="/usr/local/bin/ctags"
  endif
endif

" ctags
" open definition in new tabs
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nmap <C-L>l :exec "ts"<CR>
nmap <C-L>n :exec "tnext"<CR>
nmap <C-L>p :exec "tprevious"<CR>
map <F9>  : !ctags -R<CR>
map <F12> : !rm tags<CR>

" cscope
nnoremap <leader>fa :call cscope#findInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>
" s: Find this C symbol
nnoremap  <leader>fs :call cscope#find('s', expand('<cword>'))<CR>
" g: Find this definition
nnoremap  <leader>fg :call cscope#find('g', expand('<cword>'))<CR>
" d: Find functions called by this function
nnoremap  <leader>fd :call cscope#find('d', expand('<cword>'))<CR>
" c: Find functions calling this function
nnoremap  <leader>fc :call cscope#find('c', expand('<cword>'))<CR>
" t: Find this text string
nnoremap  <leader>ft :call cscope#find('t', expand('<cword>'))<CR>
" e: Find this egrep pattern
nnoremap  <leader>fe :call cscope#find('e', expand('<cword>'))<CR>
" f: Find this file
nnoremap  <leader>ff :call cscope#find('f', expand('<cword>'))<CR>
" i: Find files #including this file
nnoremap  <leader>fi :call cscope#find('i', expand('<cword>'))<CR>
" make cscope silent
let g:cscope_silent = 1

" CtrlSF
nmap <C-F>s :CtrlSF<CR>

" CtrlP
let g:ctrlp_map = '<c-f>f'

" We should used \<XYZ\> to prompt vim that 
" we only want the word XYZ in string \W(XYZ)\W
" However, exec string needs \\ to escape \
nmap <C-h> :exec 'call MatchPattern("Todo")'<CR>
nmap <C-j> :exec 'call MatchPattern("Error")'<CR>
nmap <C-k> :exec 'call clearmatches()'<CR>:exec 'noh'<CR>
function! MatchPattern(name)
    let var = ""
    for i in getmatches()
        if i['pattern'] == "\\<".expand('<cword>')."\\>" && i['group'] == a:name
            let var = i['id']
            break
        endif
    endfor
    if var != ""
        call matchdelete(var)
    else
        call matchadd(a:name, "\\<".expand('<cword>')."\\>", 10)
    endif
endfunction

nnoremap K   :tabnext<CR>
nnoremap J   :tabprev<CR>

" You should adjust the parameters in trinity yourself
let g:SrcExpl_winHeight = 8
let g:Tlist_WinWidth = 20

" gitgutter settings
" update gitgutter every 250ms
set updatetime=250

" easy motion settings
" use ',w' or ',b' to jump word or back
let g:EasyMotion_leader_key = '\'

" vim-markdown
" Don't fold markdown in default
let g:vim_markdown_folding_disabled = 1

"自動fold C code
set foldmethod=syntax

" tab是4個空白
set tabstop=4
set expandtab
" set list
" set listchars=tab:----

" 關閉vi相容模式
set nocompatible
" using mouse
set mouse=nv
" 搜尋時高亮顯示關閉
set nohls
" setting backspace
set backspace=indent,eol,start
" check spell
setlocal spell spelllang=en_us
set nospell

" filetype support
filetype on
filetype plugin on
filetype indent on

" set syntax
syntax on
" colorscheme
colorscheme desert

" remember commands
set history=1000
" remember undo
set undolevels=1000

" highlight 80
set colorcolumn=80
" display location
set ruler
" show cursor
set cursorline
" 行號
set nu
" 讓搜尋的字變色
set hlsearch

" highlight current line
" gui => gvim
" cterm => color terminal
" term => black-and-white terminal
" fg => foreground
" bg => background
" You can put bold, underline, reverse, italic, none in term, cterm, gui
" red, yellow, green, blue, magenta, cyan, white, black, gray in ctermfg/bg
" #xxxxxx format in guifg/bg
highlight CursorLine cterm=none ctermbg=233 guibg=#1c1c1c
highlight Cursor ctermbg=153 guibg=#b0d0f0
highlight LineNr term=underline ctermfg=59 ctermbg=232
highlight CursorLineNr term=bold ctermfg=11 gui=bold guifg=Yellow

" 關於airline，打開tab行
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" set status bar
set laststatus=2
" let the vim know term support color256
set term=xterm-256color

" 跟上一行同樣縮進
set autoindent
" 辨別是否要縮進
set smartindent
" 設定縮排寬度為4
set shiftwidth=4

" encoding
" 檔案編碼
set fenc=utf-8
set fencs=utf-8,big5,gbk,euc-jp,utf-16le
" vim 內部編碼
set enc=utf-8
" terminal編碼
set tenc=utf-8

" no backup
set nobackup
set noswapfile
" no beep
set visualbell
set noerrorbells

" 讓貼上不會跑掉格式
set pastetoggle=<F2>
set nopaste

" NeoBundle
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

" -------------my plugin----------------
" HTML5 + inline SVG omnicomplete function, indent and syntax for Vim. Based on
" the default htmlcomplete.vim.
NeoBundle 'othree/html5.vim'
" Syntax highlighting, matching rules and mappings for the original Markdown
" and extensions.
" Usage: https://github.com/plasticboy/vim-markdown
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'bling/vim-airline'
" git plugin for vim
" 常用:Gdiff(看本文件被改的情況), :Gstatus(看有哪些被改),
" :Gread(回到上次checkout的情況), :Gblame(看每一行是誰改的)
" Usage: https://github.com/tpope/vim-fugitive
NeoBundle 'tpope/vim-fugitive'
" A (G)Vim plugin which build the trinity of Source Explorer, TagList and NERD
" tree to be an IDE for software development.
NeoBundle 'wesleyche/Trinity'
NeoBundle 'taglist.vim'
NeoBundle 'vim-scripts/SrcExpl'
" Python
" Using python flake8
NeoBundle 'nvie/vim-flake8'
" Folding python
" zo 展開
" zc 收起 
" zn 全部展開 
" zN 全部收起
NeoBundle 'python_fold'
" cscope
NeoBundle 'vim-scripts/cscope.vim' 
" html/xml跳轉, use %
NeoBundle 'vim-scripts/matchit.zip'

" DON'T USE!!!! it will cause open tab too slowly
" make rgb(x,x,x) or #00ff colorize 
" NeoBundle 'lilydjwg/colorizer'

" 用git看改了哪幾行
" 用[c, ]c可以上下跳轉
NeoBundle 'airblade/vim-gitgutter'
" vim easymotion
" 快速跳轉，連按\\再加上w或b可以向後或向前跳
" 如果是s則是搜尋某個字母
NeoBundle 'easymotion/vim-easymotion'
" able to select multiple cursors (這是神器啊Orz)
" C-n C-p C-x: 選擇下個/上個/跳過同樣的字詞，然後再按c就可以重命名
" 用vip選擇某個block，然後再按C-n加上i就可以在前面插入文字
" 備註：如果是用vip加上J，代表把這個block的換行拿掉
NeoBundle 'terryma/vim-multiple-cursors'
" 可以用來快速搜尋某個單詞
" :CtrlSF [pattern]後，會跳出搜尋結果視窗(這邊改成C-f + s)
" p可以preview，t可以在新頁開啟，T可以新頁開啟並保留window，q為離開
" C-j, C-k: 上下移動cursor
NeoBundle 'dyng/ctrlsf.vim'
" 快速開啟file
" C-p(我這邊改成C-f + f)可以開list，要離開要用esc
" C-j, C-k: 上下移動  C-t: 新分頁開啟
NeoBundle 'ctrlpvim/ctrlp.vim'
" To operate quoting/parenthesizing easily.
" cs"'     -> "Hi" to 'Hi'
" cs'<tag> -> 'hi' to <tag>hi</tag>
" ds"      -> "Hi" to Hi
" ysiw"    -> Hi to "Hi" (iw means whole word)
" yss"     -> Hi to "Hi" (s means whole line)
NeoBundle 'tpope/vim-surround'
" -------------my plugin----------------

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
