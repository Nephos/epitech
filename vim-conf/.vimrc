" General
scriptencoding utf-8
set fileencoding=utf-8
set nocompatible
set number
set showcmd
syntax on
" set mouse=a

" Style
set t_Co=256
colorscheme wombat256mod
set cursorline

" Tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

" Controler les tabs
set list
set listchars=tab:>\ 

" Search
set hlsearch

" Folding
set foldmethod=marker

" Controler 80 colonnes et espace en fin de ligne
highlight OverLength ctermbg=52 ctermfg=white guibg=#592929
match OverLength /\s\+$\|\%81v.\+/

" Filetype
filetype plugin on

" Buffer
au BufNewFile * call Epi_Header_Insert()
au BufWritePre * call UpdateHeaderDate()

" Mapping
map <F3> <esc>ggvG=
inoremap ''; '';<esc>hi
inoremap '' ''<esc>i
inoremap ""; "";<esc>hi
inoremap "" ""<esc>i
inoremap (( ()<esc>i
inoremap ((; ();<esc>hi
inoremap [[ []<esc>i
inoremap [[; [];<esc>hi
" inoremap << <><esc>i
inoremap {{ {<cr><cr>}<esc>ki

if filereadable("./.vim.custom")
    so ./.vim.custom
endif
