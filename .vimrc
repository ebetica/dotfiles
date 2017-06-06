

"""GENERAL CONFIG
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
set autoindent
set expandtab
set autoread            "Reload files changed outside of vim
set visualbell          "No sounds

"Saves pinkies
nnoremap ; :


"""Visual niceties
set colorcolumn=81

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
nnoremap <C-j> <C-f>
nnoremap <C-k> <C-b>


"""Searching
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital


"""Vundles
if filereadable(expand("~/dotfiles/vundles.vim"))
    source ~/dotfiles/vundles.vim
endif

" Semantic Highlight
autocmd BufWrite,BufRead,InsertLeave * :SemanticHighlight

"NERDTree
nnoremap <C-u> :NERDTreeToggle %<CR>
let NERDTreeQuitOnOpen=1

"CtrlP
nnoremap tn :CtrlPMixed<CR>
