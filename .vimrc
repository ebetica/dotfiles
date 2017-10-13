

"""GENERAL CONFIG
syntax on
set number
set relativenumber
set smartindent
set autoindent
set expandtab
set autoread            "Reload files changed outside of vim
set visualbell          "No sounds
set nowrap

"Saves pinkies
nnoremap ; :

"Leader
let mapleader=" "


"""Visual niceties
set colorcolumn=81,121
hi ColorColumn ctermbg=darkgrey guibg=darkgrey 
colorscheme default
let g:lightline = {'colorscheme': 'default'}

"""Navigation
"Easy tab navigation
nnoremap tj :tabnext<CR>
nnoremap tk :tabprev<CR>
nnoremap tl :tablast<CR>
nnoremap th :tabfirst<CR>
nnoremap tN :tabnew<Space>
nnoremap tm :tabmove<Space>
set switchbuf=usetab

"Easy split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"Easy page up down
nnoremap <C-j> <C-D>
nnoremap <C-k> <C-U>

"Folds
set foldmethod=syntax

"""Searching
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

"Better tab support for files
set wildmode=longest,list,full
set wildmenu


"""Vundles
if filereadable(expand("~/dotfiles/vundles.vim"))
    source ~/dotfiles/vundles.vim
endif

" Semantic Highlight
autocmd BufWrite,BufRead,InsertLeave *.c,*.cc,*.cpp,*.h,*.hpp,*.java,*.js,*.php,*.py,*.rb,*.rs,*.lua :SemanticHighlight

"NERDTree
let g:jedi#usages_command = "<leader>u"  " Unbinds leader-n
nnoremap <leader>n :NERDTreeToggle %<CR>
let NERDTreeQuitOnOpen=1

"CtrlP
nnoremap tn :CtrlPMixed<CR>
let g:ctrlp_prompt_mappings = {
      \ 'AcceptSelection("e")': ['<c-t>'],
      \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
      \ }

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are
" tabs (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

"Syntastic
let g:syntastic_cpp_compiler_options=" -std=c++14 -Wall"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_python_checkers = ['python']
nnoremap <leader>j :lnext<CR>
nnoremap <leader>k :lprev<CR>

"Jedi
let g:jedi#force_py_version = 3
