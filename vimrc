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
" Updated:
" 2022.12.28 Able to use coc for Rust, C/C++, and Python
" 2022-12-12 Add some cheatsheet for vim
" 2022-09-06 Add fzf plugin
" 2019-09-28 Use vim-plug to replace NeoBundle and organize the order
" 2015-04-02 Adjust the windows size and title
" 2015-04-01 Complete architecture of vimrc

" -------------Usefule cheatsheet-------------
" Reference: https://vim.rtorr.com/lang/zh_tw
" Move words:
"   - right: w
"   - left: b
" Move screen
"   - down without moving cursor: ctrl+e
"   - up without moving cursor: ctrl+y
" Jump to file: gf
" Change to uppercase: gU
" Change to lowercase: gu
" Combine the next line to current line: gJ

" -------------vim settings----------------
set tabstop=4
set expandtab

" 關閉vi相容模式
set nocompatible
" using mouse
set mouse=nv
" setting backspace
set backspace=indent,eol,start
" check spell
setlocal spell spelllang=en_us
set nospell
" Use system clipbard
" Use "+y or "+p to copy and paste
set clipboard=unnamedplus

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


" -------------key mappings----------------
"  >>>> vim key mappings <<<<
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

" >>>> plugin key mappings <<<<
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
map <F9>  : !ctags -R -f .tags<CR>
map <F12> : !rm .tags<CR>
" find .tags in the current folder first and then the parent folders.
set tags=./.tags;,.tags

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


" -------------plugin settings----------------
" 關於airline，打開tab行
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" vim-markdown
" Don't fold markdown in default
let g:vim_markdown_folding_disabled = 1

" vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1

" vim-fugitive: vertical Gdiff
set diffopt+=vertical

" You should adjust the parameters in trinity yourself
let g:SrcExpl_winHeight = 8
let g:Tlist_WinWidth = 20

" easymotion settings
" use '\\w' or '\\b' to jump word or back
" f for whole page
let g:EasyMotion_leader_key = '\'
nmap f <Plug>(easymotion-bd-w)

" CtrlSF
nmap <C-F>s :CtrlSF<CR>
let g:ctrlsf_ackprg = 'ag'

" FZF
nmap <C-p> :FZF<CR>
let $FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{node_modules/*,.git/*}"'
let $FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

" Rust related
" Do Rust format while save
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

" coc related
" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" disable ALE and only show from coc
" https://github.com/dense-analysis/ale#5iii-how-can-i-use-ale-and-cocnvim-together
let g:ale_disable_lsp = 1

" vim-plug
call plug#begin('~/.vim/plugged')
" -------------my plugin----------------
"  >>>> highlight & beautify vim <<<<
" HTML5 + inline SVG omnicomplete function, indent and syntax for Vim. Based on
" the default htmlcomplete.vim.
Plug 'othree/html5.vim'
" Syntax highlighting, matching rules and mappings for the original Markdown
" and extensions.
" Usage: https://github.com/plasticboy/vim-markdown
Plug 'plasticboy/vim-markdown'
" vim-cpp-enhanced-highlight: Highlight C++
Plug 'octol/vim-cpp-enhanced-highlight'
" Beautify vim
Plug 'bling/vim-airline'


" >>>> git plugin <<<<
" 常用:Gdiff(看本文件被改的情況), :Gstatus(看有哪些被改),
" :Gread(回到上次checkout的情況), :Gblame(看每一行是誰改的)
" gq可以離開畫面
" Usage: https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-fugitive'
" Show the VCS diff, like git, svn
" Use [c and ]c to jump up and down
Plug 'mhinz/vim-signify'


" >>>> IDE <<<<
" A (G)Vim plugin which build the trinity of Source Explorer, TagList and NERD
" tree to be an IDE for software development.
Plug 'wesleyche/Trinity'
Plug 'vim-scripts/taglist.vim'
Plug 'vim-scripts/SrcExpl'
" Using python flake8
Plug 'nvie/vim-flake8'
" cscope
Plug 'vim-scripts/cscope.vim' 
" html/xml跳轉, use %
Plug 'vim-scripts/matchit.zip'


" >>>> Fast modification <<<<
" f: 可以整頁快速跳轉
" \\w: 向下跳
" \\b: 向上跳
" \\s: 針對某個字母跳轉
Plug 'easymotion/vim-easymotion'
" able to select multiple cursors (這是神器啊Orz)
" C-n C-p C-x: 選擇下個/上個/跳過同樣的字詞，然後再按c就可以重命名
" 用vip選擇某個block，然後再按C-n加上i就可以在前面插入文字
" 備註：如果是用vip加上J，代表把這個block的換行拿掉
Plug 'terryma/vim-multiple-cursors'
" 可以用來快速搜尋某個單詞
" :CtrlSF [pattern]後，會跳出搜尋結果視窗(這邊改成C-f + s)
" p可以preview，t可以在新頁開啟，T可以新頁開啟並保留window，q為離開
" C-j, C-k: 上下移動cursor
Plug 'dyng/ctrlsf.vim'
" To operate quoting/parenthesizing easily.
" cs"'     -> "Hi" to 'Hi'
" cs'<tag> -> 'hi' to <tag>hi</tag>
" ds"      -> "Hi" to Hi
" ysiw"    -> Hi to "Hi" (iw means whole word)
" yss"     -> Hi to "Hi" (s means whole line)
Plug 'tpope/vim-surround'
" fzf plugin
" 沒有 fzf 的開啟檔案方式(netrw)
" :Vex: vertical open file list
" :Hex: horizontal open file list
" fzf 的開檔方式
" :FZF
" :FZF <PATH>
" C-j, C-k: 上下移動
" C-t: 新分頁開啟, C-x: 水平分頁, C-v: 垂直分頁
Plug '~/.fzf'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
" 原始針對文本對象的vim指令
" *iw和*aw: 針對whole word
" *ip和*ap: 針對paragraph
" *i(和*a(: 針對()中的內容
" *i"和*a": 針對""中的內容
" textobj-user新增的vim指令
" *i,和*a,: 針對參數
" *ii和*ai: 針對indent
" *if和*af: 針對function
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }
Plug 'sgur/vim-textobj-parameter'
" Rust related plugins
Plug 'rust-lang/rust.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale' " This can show the syntax error immediately. You don't need to save.
" -------------my plugin----------------
call plug#end()

