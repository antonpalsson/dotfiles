set nocompatible " be iMproved
filetype off " required!


" Plugins {{{
call plug#begin('~/.vim/plugged')
Plug 'arcticicestudio/nord-vim'       " Theme
Plug 'vim-airline/vim-airline'        " Status/tabline theme
Plug 'vim-airline/vim-airline-themes'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fzf search
Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'} " VSCode-like autocompletion
"Plug 'neoclide/coc-solargraph', {'do': 'yarn install --frozen-lockfile'}

Plug 'elixir-editors/vim-elixir'          " General Vim <3 Elixir
Plug 'vim-ruby/vim-ruby'                  " General Vim <3 Ruby
Plug 'jiangmiao/auto-pairs'               " Auto complete ()[]{}
Plug 'tmux-plugins/vim-tmux-focus-events' " Auto read on focus event
call plug#end()
" }}}


" General {{{
colorscheme nord    " Nord theme

" Auto read file on focus
set autoread
au FocusGained,BufEnter * :checktime

set colorcolumn=120 " Show line length border
set noswapfile      " No swap
set number          " Show line number
set showcmd         " Show last command in bottom bar
set wildmenu        " Visual autocomplete for command menu
set showmatch       " Highlight matching ()[]{}
set scrolloff=20    " Above / below cursor padding

set backspace=indent,eol,start  " Make backspace work
set tabstop=2                   " Tab is two columns
set shiftwidth=2                " Two columns for reindent
set expandtab                   " Turn tab to spaces
" }}}


" Search {{{
" Ag search
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

set ignorecase  " Ignore case
set smartcase   " If there is a uppercase letter do not ignore case
set incsearch   " Search as characters are entered
set hlsearch    " Highlight matches
" }}}


" Remaps {{{
" Set comma to leader
" and some other custom shortcuts
let mapleader=","                 
nnoremap <leader>a :Ag!<CR>
nnoremap <leader>f :Files!<CR>
nnoremap <leader>e :Explore<CR>   
nnoremap <leader>noh :noh<CR>
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>pm :set paste<CR>
nnoremap <leader>npm :set nopaste<CR>

nnoremap <leader>rc :so ~/.vimrc<CR>   " Reload vimrc

" Move to beginning / end of line
nnoremap B ^
nnoremap E $
nnoremap $ <nop>
nnoremap ^ <nop>
" }}}


" Coc {{{
set hidden          " TextEdit might fail if hidden is not set
set nobackup        " Some servers have issues with backup files
set nowritebackup
set updatetime=300  " Snappier UX (default 4000ms)
set shortmess+=c    " Don't pass messages to |ins-completion-menu|
set signcolumn=yes  " Always show the signcolumn. Otherwise it would shift the
                    " text each time diagnostics appear/become resolved

" Use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Navigate the completion list with Tab / Shift + Tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" }}}
