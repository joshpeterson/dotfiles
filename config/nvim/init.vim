call plug#begin()
" below are some vim plugins for demonstration purpose.
" add the plugin you want to use here.
Plug 'iCyMind/NeoSolarized'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

Plug 'preservim/nerdtree'

Plug 'wincent/ferret'

Plug 'jlanzarotta/bufexplorer'

Plug 'tpope/vim-fugitive'

Plug 'ryanoasis/vim-devicons'

Plug 'rhysd/vim-clang-format'

Plug 'github/copilot.vim'

Plug 'jamespwilliams/bat.vim'

Plug 'anuvyklack/pretty-fold.nvim'
call plug#end()

" Basic settings
set number
set nowrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab
set list

" system clipboard
nmap <c-c> "+y
vmap <c-c> "+y
nmap <c-v> "+p
inoremap <c-v> <c-r>+
cnoremap <c-v> <c-r>+
" use <c-r> to insert original character without triggering things like auto-pairs
inoremap <c-r> <c-v>

" GUI Settings
"
if has("gui_running")
" Color scheme
colorscheme NeoSolarized
let g:airline_theme='solarized'

" Font
let g:guifont='Fira Code'

if exists("g:neovide")
    " Put anything you want to happen only in Neovide here
    let g:neovide_cursor_animation_length=0
endif
endif

" FZF
nnoremap <c-t> :FZF<cr>

" NERDTree
" Close the tab if NERDTree is the only window remaining in it.
"autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
let g:NERDTreeWinSize=45

nnoremap <leader>n :NERDTreeToggle<CR>

" vim-airline
let g:airline_powerline_fonts = 1

" bufexplorer
let g:bufExplorerDefaultHelp=0
let g:bufExplorerSplitHorzSize=6

" Buffer switching
nnoremap <c-p> :bp<cr>
nnoremap <c-n> :bn<cr>

" vim-clang-format
let g:clang_format#auto_format = 1

" Use syntac highlighting from bat
set termguicolors
colorscheme bat

" Github Copilot
imap <silent> <C-j> <Plug>(copilot-next)
imap <silent> <C-k> <Plug>(copilot-previous)
imap <silent> <C-\> <Plug>(copilot-dismiss)

" Ferret
let g:FerretExecutableArguments = {
  \   'ag': '--vimgrep --width=4096 --ignore-dir=external/'
  \ }

" Folding
require('pretty-fold').ft_setup('cpp', {
   matchup_patterns = {
       { '^%s*TEST_CASE', 'i^}$' }, -- TEST_CASE blocks
   },
}

" Older settings
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc
