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
let has_machine_specific_file = 1
if empty(glob('~/.config/nvim/_machine_specific.vim'))
		let has_machine_specific_file = 0
		silent! exec "!cp ~/.config/nvim/default_configs/
								\_machine_specific_default.vim
								\ ~/.config/nvim/_machine_specific.vim"
endif
source ~/.config/nvim/_machine_specific.vim


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
syntax on
" vim自身命名行模式智能补全
set wildmenu
" 让vim可以使用系统的剪切板
set clipboard=unnamed
" 设置行号
set number
set relativenumber
" 自动设当前编辑文件所在目录为当前工作目录
set autochdir
" 高亮第80列
set cc=80
" 自动缩进
set autoindent
set smartindent
" tab大小
set tabstop=4
set softtabstop=4
" 去掉vi一致性模式
" set nocompatible
" set backspace=indent,start
" 开启真色
set termguicolors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1


" -------- -------- -------- -------- -------- --------
"  基本键位映射
" -------- -------- -------- -------- -------- --------
noremap H 0
noremap L $
noremap J 5j
noremap K 5k
noremap M J
noremap s <nop>
let mapleader=" "


" -------- -------- -------- -------- -------- --------
"  具体语言具体分析
" -------- -------- -------- -------- -------- --------
autocmd FileType php setlocal tabstop=2 shiftwidth=2
						\ softtabstop=2 textwidth=80
autocmd FileType ruby setlocal tabstop=2 shiftwidth=2
						\ softtabstop=2 textwidth=80
autocmd FileType php setlocal tabstop=4 shiftwidth=4
						\ softtabstop=4 textwidth=80
autocmd FileType coffee,javascript setlocal tabstop=2
						\ shiftwidth=2 softtabstop=2 textwidth=80
autocmd FileType python setlocal tabstop=4 shiftwidth=4
						\ softtabstop=4 textwidth=80
autocmd FileType html,htmldjango,xhtml,haml setlocal tabstop=2
						\ shiftwidth=2 softtabstop=2 textwidth=80
autocmd FileType sass,scss,css setlocal tabstop=2 shiftwidth=2
						\ softtabstop=2 textwidth=80


" -------- -------- -------- -------- -------- --------
"  auto add head info
" -------- -------- -------- -------- -------- --------
function HeaderPython()
		call setline(1, "#!/usr/bin/env python")
		call append(1, "#-*- coding:utf-8 -*-")
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
				exec "!gcc % -o %<"
				exec "!time ./%<"
		elseif &filetype == 'cpp'
				set splitbelow
				exec "!g++ -std=c++11 % -Wall -o %<"
				:sp
				:res -15
				:term ./%<
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

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }


" Python
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" Move
Plug 'easymotion/vim-easymotion'

" Undo Tree
Plug 'mbbill/undotree'

" Editor Enhancement
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'AndrewRadev/switch.vim'  " press gs to switch ture/false

" Commenter
Plug 'scrooloose/nerdcommenter'

" Auto Complete
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" remember  :CocCommand python.setInterpreter
Plug 'godlygeek/tabular'

" Formatter
Plug 'Chiel92/vim-autoformat'

" File navigation
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'ctrlpvim/ctrlp.vim'

" Git
Plug 'Xuyuanp/nerdtree-git-plugin'

" Rainbow
Plug 'luochen1990/rainbow'

" IndentLine
Plug 'Yggdroot/indentLine'

" Vim-airline
Plug 'vim-airline/vim-airline'

" Theme
Plug 'hzchirs/vim-material'
" Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'ajmwagar/vim-deus'

call plug#end()


"-------- -------- -------- -------- -------- --------
" NerdTree
"-------- -------- -------- -------- -------- --------
noremap <silent> tt :NERDTreeToggle<CR>
" 退出最后一个文件则自动关闭目录
autocmd bufenter * if (winnr("$") == 1
						\ && exists("b:NERDTree")
						\ && b:NERDTree.isTabTree()) | q | endif
" 在终端启动vim时，共享NERDTree
let g:nerdtree_tabs_open_on_console_startup=1

" Default  Description~
" Key~

" o       Open files, directories and bookmarks
" go      Open selected file, but leave cursor in the NERDTree
" t       Open selected node/bookmark in a new tab
" T       Same as 't' but keep the focus on the current tab
" i       Open selected file in a split window
" gi      Same as i, but leave the cursor on the NERDTree
" s       Open selected file in a new vsplit
" gs      Same as s, but leave the cursor on the NERDTree
" O       Recursively open the selected directory
" x       Close the current nodes parent
" X       Recursively close all children of the current node
" e       Edit the current dir

" <CR>               same as |NERDTree-o|
" double-click       same as the |NERDTree-o| map
" middle-click       same as |NERDTree-i| for files, same as
" |NERDTree-e| for dirs

" D       Delete the current bookmark

" P       Jump to the root node
" p       Jump to current nodes parent
" K       跳转到与光标相同深度的第一个子节点
" J       跳转到与光标相同深度的最后一个子节点
" <C-J>   Jump down to the next sibling of the current directory
" <C-K>   Jump up to the previous sibling of the current directory

" C       Change the tree root to the selected dir
" u       Move the tree root up one directory
" U       Same as 'u' except the old root node is left open
" r       Recursively refresh the current directory
" R       Recursively refresh the current root
" m       Display the NERD tree menu
" cd      Change the CWD to the dir of the selected node
" CD      Change tree root to the CWD

" I       Toggle whether hidden files displayed
" f       Toggle whether the file filters are used
" F       Toggle whether files are displayed
" B       Toggle whether the bookmark table is displayed

" q       Close the NERDTree window
" A       Zoom (maximize/minimize) the NERDTree window
" ?       Toggle the display of the quick help


" -------- -------- -------- -------- -------- --------
"  NerdGit
" -------- -------- -------- -------- -------- --------
let g:NERDTreeIndicatorMapCustom = {
						\ "Modified"  : "✹",
						\ "Staged"    : "✚",
						\ "Untracked" : "✭",
						\ "Renamed"   : "➜",
						\ "Unmerged"  : "═",
						\ "Deleted"   : "✖",
						\ "Dirty"     : "✗",
						\ "Clean"     : "✔︎",
						\ "Unknown"   : "?"
						\ }


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
" silent! au BufEnter,BufRead,BufNewFile * silent! unmap if
" let g:coc_global_extensions = ['coc-python', 'coc-vimlsp', 'coc-html',
						" \ 'coc-json', 'coc-css', 'coc-tsserver',
						" \'coc-yank', 'coc-lists', 'coc-gitignore',
						" \'coc-vimlsp', 'coc-tailwindcss', 'coc-stylelint']
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" " use <tab> for trigger completion and navigate to the next complete item
" function! s:check_back_space() abort
		" let col = col('.') - 1
		" return !col || getline('.')[col - 1]	=~ '\s'
" endfunction
" inoremap <silent><expr> <Tab>
						" \ pumvisible() ? "\<C-n>" :
						" \ <SID>check_back_space() ? "\<Tab>" :
						" \ coc#refresh()
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <silent><expr> <c-space> coc#refresh()
" nmap <silent> gd <Plug>(coc-definition)
" nmap <leader>rn <Plug>(coc-rename)


"-------- -------- -------- -------- -------- --------
" AutoFormater
"-------- -------- -------- -------- -------- --------
nnoremap /f :Autoformat<CR>


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
"  Theme (Choose one you like)
" -------- -------- -------- -------- -------- --------
" Dark
" set background=dark
" colorscheme vim-material
" Palenight
" let g:material_style='palenight'
" set background=dark
" colorscheme vim-material
" Oceanic
" let g:material_style='oceanic'
" set background=dark
" colorscheme vim-material
" Light
" set background=light
" colorscheme vim-material
" onehalflight
" colorscheme onehalflight
color deus
hi NonText ctermfg=gray guifg=grey10


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
"  FZF
" -------- -------- -------- -------- -------- --------
noremap <C-p> :FZF<CR>


" -------- -------- -------- -------- -------- --------
"  CtrlP
" -------- -------- -------- -------- -------- --------
let g:ctrlp_map = ''
let g:ctrlp_cmd = 'CtrlP'


" -------- -------- -------- -------- -------- --------
"  Open the _machine_specific.vim file if it has just been created
" -------- -------- -------- -------- -------- --------
if has_machine_specific_file == 0
		exec "e ~/.config/nvim/_machine_specific.vim"
endif
