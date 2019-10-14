set nocompatible
filetype off

" INSTALL
" - Ag
" - FZF
" - Base16 Shell

" Plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" Themes
Plugin 'chriskempson/base16-vim'
Plugin 'arcticicestudio/nord-vim'

" Search
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'

call vundle#end()

filetype indent on
set history=500
set mouse=a
set noswapfile
set noerrorbells
set novisualbell
set backspace=indent,eol,start

" Looks
colorscheme nord
syntax enable
set number
set relativenumber
set showcmd
set wildmenu
set lazyredraw
set showmatch

" Search
" Ag search in vim
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
set path+=**
set ignorecase
set smartcase
set incsearch
set hlsearch 

" Tabs
set tabstop=4 
set softtabstop=4
set expandtab


" move to beginning/end of line
nnoremap B ^
nnoremap E $
nnoremap $ <nop>
nnoremap ^ <nop>
