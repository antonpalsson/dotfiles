set nocompatible " be iMproved
filetype off " required!

" INSTALL
" - Ag
" - FZF
" - Base16 Shell

" plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" eilixir syntax colors
Plugin 'elixir-editors/vim-elixir' 

" themes
Plugin 'chriskempson/base16-vim'
Plugin 'arcticicestudio/nord-vim'

" FZF search
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'

call vundle#end()

filetype indent on " load filetype-specific indent files
set history=500 " longer histiry
set mouse=a " activate mouse
set noswapfile " no swap file
set backspace=indent,eol,start " enable backspace 

" looks
colorscheme nord " color scheme
syntax enable " colored syntax
set number " show line number
set relativenumber " show relative line number
set showcmd " show last command in bottom bar
set wildmenu " visual autocomplete for command menu
set lazyredraw " redraw only when we need to
set showmatch " highlight matching [{()}]

" search
" ag search in vim
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
set path+=**
set ignorecase " ignore case
set smartcase " if there is a uppercase letter do not ignore case
set incsearch " search as characters are entered
set hlsearch  " highlight matches
set scrolloff=10 " show 10 lines above/below search hit

" tabs
set expandtab
set tabstop=2
set shiftwidth=2

" remap keys
let mapleader="," " leader is comma
set pastetoggle=<f5> " paste toggle
" move to beginning/end of line
nnoremap B ^ 
nnoremap E $
nnoremap $ <nop>
nnoremap ^ <nop>
" ,a to ag search
nnoremap <leader>a :Ag<CR> 
" ,f to fzf search
nnoremap <leader>f :FZF<CR> 
" ,nh to stop highlight
nnoremap <leader>nh :noh<CR> 
" ,rn to toggle relative number
nnoremap <Leader>rn :set relativenumber!<cr>
" ,nt to open new tab
nnoremap <leader>tn :tabnew<CR> 
