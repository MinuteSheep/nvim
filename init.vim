" Author: MinuteSheep<minutesheep@163.com>
"  __  __ ____        _   ___     ___
" |  \/  / ___|      | \ | \ \   / (_)_ __ ___
" | |\/| \___ \ _____|  \| |\ \ / /| | '_ ` _ \
" | |  | |___) |_____| |\  | \ V / | | | | | | |
" |_|  |_|____/      |_| \_|  \_/  |_|_| |_| |_|


" -------- -------- -------- -------- -------- --------
"  首次自动配置
" -------- -------- -------- -------- -------- --------
if empty(glob('~/.config/nvim/autoload/plug.vim'))
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" -------- -------- -------- -------- -------- --------
"  Python 环境
" -------- -------- -------- -------- -------- --------
let g:python_host_prog = '~/.pyenv/versions/nvim2/bin/python'
let g:python3_host_prog = '~/.pyenv/versions/nvim3/bin/python'


" -------- -------- -------- -------- -------- --------
"  备份
" -------- -------- -------- -------- -------- --------
silent !mkdir -p ~/.config/nvim/tmp/backup
silent !mkdir -p ~/.config/nvim/tmp/undo
set backupdir=~/.config/nvim/tmp/backup,.
set directory=~/.config/nvim/tmp/backup,.
if has('persistent_undo')
        set undofile
        set undodir=~/.config/nvim/tmp/undo,.
endif


" -------- -------- -------- -------- -------- --------
"  基本设置
" -------- -------- -------- -------- -------- --------
" 语法高亮
syntax on
" 让vim可以使用系统的剪切板
set clipboard=unnamed
" 设置行号
set number
set relativenumber
" 自动设当前编辑文件所在目录为当前工作目录
" set autochdir
" 高亮第81列
set cc=81
" tab大小
set ts=4
set expandtab
" 自动缩进
set autoindent
set smartindent
" 去掉vi一致性模式
" set nocompatible
set backspace=indent,start
" 开启真色,MacOs Terminal不需要开启真色
" set termguicolors
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1


" -------- -------- -------- -------- -------- --------
"  基本键位映射
" -------- -------- -------- -------- -------- --------
noremap H 0
noremap L $
noremap J 5j
noremap K 5k
noremap U <nop>
noremap U J
noremap s <nop>
inoremap <S-CR> <Esc>o
let mapleader=" "


" -------- -------- -------- -------- -------- --------
"  auto add head info
" -------- -------- -------- -------- -------- --------
function HeaderPython()
        call setline(1, "#!/usr/bin/env python")
        call append(1, "#-*- coding:UTF-8 -*-")
        normal G
        normal 3o
endf
autocmd bufnewfile *.py call HeaderPython()

function HeaderShell()
        call setline(1, "#!/usr/bin/env bash")
        call append(1, "# Author: MinuteSheep<minutesheep@163.com>")
        normal G
        normal 3o
endf
autocmd bufnewfile *.sh call HeaderShell()


"-------- -------- -------- -------- -------- --------
" C,C++,Fortran,Python,java,sh等按R编译运行
"-------- -------- -------- -------- -------- --------
map R :call CompileAndRun()<CR>
func! CompileAndRun()
        exec "w"
        if &filetype == 'c'
                exec "!gcc % -o %< && ./%<"
        elseif &filetype == 'cpp'
                set splitbelow
                exec "!g++ -std=c++11 % -Wall -o %< && ./%<"
        elseif &filetype == 'java'
                exec "!javac %"
                exec "!time java %<"
        elseif &filetype == 'sh'
                :!time bash %
        elseif &filetype == 'python'
                exec "!python % "
        elseif &filetype == 'html'
                silent! exec "!chromium % &"
        elseif &filetype == 'markdown'
                exec "MarkdownPreview"
        elseif &filetype == 'tex'
                silent! exec "VimtexStop"
                silent! exec "VimtexCompile"
        elseif &filetype == 'go'
                set splitbelow
                :sp
                :term go run %
        endif
endfunc


" -------- -------- -------- -------- -------- --------
"  vim-plug
" -------- -------- -------- -------- -------- --------
call plug#begin('~/.config/nvim/plugged')

" Move
Plug 'easymotion/vim-easymotion'

" Undo Tree
Plug 'mbbill/undotree'

" Bookmarks
Plug 'MattesGroeger/vim-bookmarks'

" Editor Enhancement
" Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'AndrewRadev/switch.vim'  " press gs to switch ture/false

" Commenter
Plug 'scrooloose/nerdcommenter'

" Auto Complete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" remember  :CocCommand python.setInterpreter
Plug 'godlygeek/tabular'

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

" Formatter
Plug 'Chiel92/vim-autoformat'

" Skin
Plug 'theniceboy/vim-deus'

" File navigation
if has('nvim')
        Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
        Plug 'Shougo/defx.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'kristijanhusak/defx-icons'

" Table
Plug 'dhruvasagar/vim-table-mode'

" Rainbow
Plug 'luochen1990/rainbow'

" IndentLine
Plug 'Yggdroot/indentLine'

" Vim-airline
Plug 'vim-airline/vim-airline'


call plug#end()


" -------- -------- -------- -------- -------- --------
"  Defx
" -------- -------- -------- -------- -------- --------
source ~/.config/nvim/defx.vim
noremap <silent> tt :Defx<CR>


"-------- -------- -------- -------- -------- --------
" UndoTree
"-------- -------- -------- -------- -------- --------
noremap <silent> X :UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1


"-------- -------- -------- -------- -------- --------
" Coc
"-------- -------- -------- -------- -------- --------
let g:coc_global_extensions = ['coc-json', 'coc-vimlsp', 'coc-python','coc-clangd']
" TextEdit might fail if hidden is not set.
set hidden
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
                        \ pumvisible() ? "\<C-n>" :
                        \ <SID>check_back_space() ? "\<TAB>" :
                        \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
        inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
        inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> <leader>[ <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>] <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Show documentation in preview window.
nnoremap <silent> <leader>k :call <SID>show_documentation()<CR>
function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
                execute 'h '.expand('<cword>')
        else
                call CocAction('doHover')
        endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)


"-------- -------- -------- -------- -------- --------
" AutoFormater
"-------- -------- -------- -------- -------- --------
nnoremap ff :Autoformat<CR>


" -------- -------- -------- -------- -------- --------
"  Rainbow
" -------- -------- -------- -------- -------- --------
let g:rainbow_active = 1


"-------- -------- -------- -------- -------- --------
" IndentLine
"-------- -------- -------- -------- -------- --------
let g:indentLine_color_term = 239
let g:indentLine_char = '┊'


" -------- -------- -------- -------- -------- --------
"  AirLine
" -------- -------- -------- -------- -------- --------
let g:airline_powerline_fonts = 0


" -------- -------- -------- -------- -------- --------
"  Commenter
" -------- -------- -------- -------- -------- --------
" 注释的时候自动加个空格
let g:NERDSpaceDelims=1

" -------- -------- -------- -------- -------- --------
"  EasyMotion
" -------- -------- -------- -------- -------- --------
nmap s <Plug>(easymotion-s2)


" -------- -------- -------- -------- -------- --------
"  BookMarks
" -------- -------- -------- -------- -------- --------
let g:bookmark_sign = '¶'
let g:bookmark_annotation_sign = '§'
let g:bookmark_auto_close = 1
let g:bookmark_highlight_lines = 1
let g:bookmark_center = 1
highlight link BookmarkLine SpellBad
highlight link BookmarkAnnotationLine SpellBad


" -------- -------- -------- -------- -------- --------
"  Skin
" -------- -------- -------- -------- -------- --------
" color deus
" colorscheme molokai
