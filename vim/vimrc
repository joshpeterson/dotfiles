set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" For Ruby
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rake'
Plugin 'ecomba/vim-ruby-refactoring'
Plugin 'jwhitley/vim-matchit'
" For C#
Plugin 'Chiel92/vim-autoformat'
"Plugin 'scrooloose/syntastic'
"
" vim-nox in Unbuntu 17.04 does not support python, just python3
" I'm waiting for omnisharp-vim to work with python3
" https://github.com/OmniSharp/omnisharp-vim/pull/316
"
"Plugin 'OmniSharp/omnisharp-vim'
Plugin 'tpope/vim-dispatch'
" For C++
Plugin 'rhysd/vim-clang-format'
Plugin 'vim-scripts/a.vim'
Plugin 'Valloric/YouCompleteMe'
" For Rust
Plugin 'rust-lang/rust.vim'
" General
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-vinegar'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'ap/vim-buftabline'
Plugin 'szw/vim-tags'
Plugin 'yssl/QFEnter'
Plugin 'junegunn/fzf.vim'
Plugin 'jremmen/vim-ripgrep'
"
" " The following are examples of different formats supported.
" " Keep Plugin commands between vundle#begin/end.
" " plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" " plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" " Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}
"
" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin indent on    " required
filetype plugin on    " Enable filetype-specific plugins
syntax on             " Enable syntax highlighting
" " To ignore plugin indent changes, instead use:
" "filetype plugin on
" "
" " Brief help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
" "
" " see :h vundle for more details or wiki for FAQ
" " Put your non-Plugin stuff after this line

""" Example Omnisharp from README
"This is the default value, setting it isn't actually necessary
let g:OmniSharp_host = "http://localhost:2000"

"Set the type lookup function to use the preview window instead of the
"status line
"let g:OmniSharp_typeLookupInPreview = 1

" "Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 1

"Showmatch significantly slows down omnicomplete
"when the first match contains parentheses.
set noshowmatch

let g:OmniSharp_selector_ui = 'ctrlp'  " Use ctrlp.vim

"Super tab settings - uncomment the next 4 lines
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
let g:SuperTabClosePreviewOnPopupClose = 1

"don't autoselect first item in omnicomplete, show if only one item (for preview)
"remove preview if you don't want to see any documentation whatsoever.
set completeopt=longest,menuone
" Fetch full documentation during omnicomplete requests.
" There is a performance penalty with this (especially on Mono)
" By default, only Type/Method signatures are fetched. Full documentation can still be fetched when
" you need it with the :OmniSharpDocumentation command.
" let g:omnicomplete_fetch_documentation=1

"Move the preview window (code documentation) to the bottom of the screen, so it doesn't move the code!
"You might also want to look at the echodoc plugin
set splitbelow

" Get Code Issues and syntax errors
let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
" If you are using the omnisharp-roslyn backend, use the following
" let g:syntastic_cs_checkers = ['code_checker']
augroup omnisharp_commands
    autocmd!

    "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

    " Synchronous build (blocks Vim)
    "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
    " Builds can also run asynchronously with vim-dispatch installed
    autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
    " automatic syntax check on events (TextChanged requires Vim 7.4)
    " I don't vim 7.4 yet
    "autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

    " Automatically add new cs files to the nearest project on save
    autocmd BufWritePost *.cs call OmniSharp#AddToProject()

    "show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    "The following commands are contextual, based on the current cursor position.

    autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
    autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
    autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
    autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
    autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
    "finds members in the current buffer
    autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
    " cursor can be anywhere on the line containing an issue
    autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
    autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
    autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
    autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
    "navigate up by method/property/field
    autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
    "navigate down by method/property/field
    autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>

augroup END

" this setting controls how long to wait (in ms) before fetching type / symbol information.
set updatetime=500
" Remove 'Press Enter to continue' message when type information is longer than one line.
set cmdheight=2

" Contextual code actions (requires CtrlP or unite.vim)
nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
" Run code actions with text selected in visual mode to extract method
vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

" rename with dialog
nnoremap <leader>nm :OmniSharpRename<cr>
nnoremap <F2> :OmniSharpRename<cr>
" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

" Force OmniSharp to reload the solution. Useful when switching branches etc.
nnoremap <leader>rl :OmniSharpReloadSolution<cr>
nnoremap <leader>cf :OmniSharpCodeFormat<cr>
" Load the current .cs file to the nearest project
nnoremap <leader>tp :OmniSharpAddToProject<cr>

" (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
nnoremap <leader>ss :OmniSharpStartServer<cr>
nnoremap <leader>sp :OmniSharpStopServer<cr>

" Add syntax highlighting for types and interfaces
nnoremap <leader>th :OmniSharpHighlightTypes<cr>
"Don't ask to save when changing buffers (i.e. when jumping to a type definition)
set hidden

""" My settings
syn on
set number
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set expandtab
set list
noremap <Leader>r :Rake test<CR>
au BufRead *.md setlocal spell
au BufRead *.md setlocal wrap
set path+=$PWD/**
match ErrorMsg '\%>83v.\+' "Highlight characters after 80 columns
au BufNew,BufRead *.html match none
au BufNew,BufRead *.yml match none
au BufNew,BufRead *.md match none
au BufNewFile,BufRead COMMIT_EDITMSG setlocal spell " spell check in commit messages
set wildignore+=*.o,*.swp,*.swo,*/vendor/*,*/tmp/*,*/cde-package/*
autocmd QuickFixCmdPost *grep* cwindow
nnoremap <buffer><Leader>k :<C-u>ClangFormat<CR>
vnoremap <buffer><Leader>k :ClangFormat<CR>
if getcwd() !~ "llvm-project"
  autocmd FileType c,cpp,h,hpp ClangFormatAutoEnable
endif

" Custom astyle setup
au BufWrite *.cs :Autoformat
let g:formatdef_my_custom_cs = '"astyle --options=.astylerc"'
let g:formatters_cs = ['my_custom_cs']

" From http://scottsievert.com/blog/2016/01/06/vim-jekyll-mathjax/
function! MathAndLiquid()
  "" Define certain regions
  " Block math. Look for "$$[anything]$$"
  syn region math start=/\$\$/ end=/\$\$/
  " inline math. Look for "$[not $][anything]$"
  syn match math_block '\$[^$].\{-}\$'
  " Liquid single line. Look for "{%[anything]%}"
  syn match liquid '{%.*%}'
  " Liquid multiline. Look for {%[anything]%}[anything]{%[anything]%}"
  syn region highlight_block start='{% highlight .*%}' end='{%.*%}'
  " Fenced code blocks, used in GitHub Flavored Markdown (GFM)
  syn region highlight_block start='```' end='```'

  "" Actually highlight those regions.
  hi link math Statement
  hi link liquid Statement
  hi link highlight_block Function
  hi link math_block Function
endfunction

" Call everytime we open a Markdown file
autocmd BufRead,BufNewFile,BufEnter *.md,*.markdown call MathAndLiquid()
autocmd BufRead,BufNewFile,BufEnter *.md,*.markdown set textwidth=83

" Shortcut to search tags with ctrlp
nnoremap <leader>. :CtrlPTag<cr>

" vim-ruby-refactoring
:nnoremap <leader>rap  :RAddParameter<cr>
:nnoremap <leader>rcpc :RConvertPostConditional<cr>
:nnoremap <leader>rel  :RExtractLet<cr>
:vnoremap <leader>rec  :RExtractConstant<cr>
:vnoremap <leader>relv :RExtractLocalVariable<cr>
:nnoremap <leader>rit  :RInlineTemp<cr>
:vnoremap <leader>rrlv :RRenameLocalVariable<cr>
:vnoremap <leader>rriv :RRenameInstanceVariable<cr>
:vnoremap <leader>rem  :RExtractMethod<cr>

" bind K to grep word under cursor
nnoremap K :Rg "\b<C-R><C-W>\b"<CR>:cw<CR>

let g:vim_tags_project_tags_command = "{CTAGS} -R {OPTIONS} {DIRECTORY} --exclude=artifacts --exclude=build 2>/dev/null"
let g:vim_tags_use_vim_dispatch = 1

let g:rustfmt_autosave = 1

"YCM Keymappings
map <F9> :YcmCompleter FixIt<CR>
map <F12> :YcmCompleter GoTo<CR>

"FZF Stuff
let $FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.hg,build,artifacts}/*" 2> /dev/null'
set rtp+=/usr/local/opt/fzf
set rtp+=~/.fzf
nnoremap <c-t> :FZF<cr>

" macOS clipboard integration
set clipboard=unnamed

"Buffer switching
nnoremap <c-p> :bp<cr>
nnoremap <c-n> :bn<cr>
