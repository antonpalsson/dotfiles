call plug#begin("~/.vim/plugged")
  Plug 'joshdick/onedark.vim'						" One dark theme
  Plug 'vim-airline/vim-airline'					" Status/tabline theme
  Plug 'scrooloose/nerdtree'						" NERDTree file explorer
  Plug 'ryanoasis/vim-devicons'						" Icons
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }	" FZF search
  Plug 'junegunn/fzf.vim'
  Plug 'mileszs/ack.vim'						" Ack / Ag search
  Plug 'neoclide/coc.nvim', {'branch': 'release'}			" Coc autocomplete
  let g:coc_global_extensions = []
call plug#end()

" Configs
syntax on
colorscheme onedark
set cursorline		" Add cursor line
set number		" Show line number
set ignorecase		" Ignore case
set smartcase		" If there is a uppercase letter do not ignore case
set colorcolumn=120	" Show line length border
set scrolloff=20	" Above / below cursor padding

" Bindings
let mapleader=","
nnoremap <leader>noh :noh<CR>
nnoremap <leader>t :tabnew<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>a :Ag<CR>
nnoremap <leader>b :NERDTreeToggle<CR>

" Autoread file on focus gained (required for Tmux)
au FocusGained * silent! checktime
" Autoread file every 3rd sec
if ! exists("g:CheckUpdateStarted")
    let g:CheckUpdateStarted=1
    call timer_start(1,'CheckUpdate')
endif
function! CheckUpdate(timer)
    silent! checktime
    call timer_start(3000,'CheckUpdate')
endfunction

" NERDTree
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Close nvim if NERDTree is the only thing pane left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" FZF/Ag search
" Pipe through ag to respect gitignores, show hidden files and ignore .git
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
" Open search result in current pane with Enter, new tab with Ctrl-T, split with Ctrl-V
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-v': 'vsplit' }

" Coc autocomplete n
" Navigate with tabs
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <silent><expr> <C-space> coc#refresh()
