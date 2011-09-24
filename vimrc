" ------------------------------------------------------------------------------
" {{{1 Core Options (@todo organize these a bit)
" ------------------------------------------------------------------------------
" {{{2 Base (@todo organize these a bit)
set guitablabel=%t
set nocompatible             " dont worry about Vi compat
set history=500              " command line remembers X commands
set ruler
set showmode
set showcmd
set scrolloff=7              " scroll offset
set cmdheight=2              " The commandbar height
set showmatch                " Show matching bracets when text indicator is over them
set mat=2                    " How many tenths of a second to blink
set nostartofline
set textwidth=80
set columns=85
set colorcolumn=+2,+3,+4,+5,+6,+7,+8,+9,+10,+11,+12,+13,+14,+15,+16,+17,+18,+19,+20
set nowrap
set linebreak                " wrap at end of word
set showbreak=+              "show char in front of wraped lines
set nowrapscan
set ignorecase
set smartcase                " case insensitive searches become sensitive with capitals
set foldmethod=syntax
set nohlsearch               " see hl function & mapping below
set incsearch
set showmatch
set matchtime=2
set wildmenu                 " command line completion shows options in menu
set wildmode=list:longest,full
set magic                    " set magic on, for regular expressions
set switchbuf=useopen
set number                   " not sure why, but keep this one last or it won't work 
                             " on current gvim's setup
set dictionary=/usr/share/dict/words
set laststatus=2             "always show status line
set joinspaces
set comments+=b:\"
set comments+=n::
set matchpairs+=<:>
set diffopt=filler,iwhite
set encoding=utf-8
set fileformats=unix,mac,dos
set undofile
set path=$PWD/**             " http://vim.wikia.com/wiki/VimTip1146
filetype on
syntax on
filetype plugin indent on
" ------------------------------------------------------------------------------
" {{{2 Tabs and indenting
set autoindent               " Do dumb autoindentation when no filetype is set
set tabstop=4                " Real tab characters are 8 spaces wide,
set shiftwidth=4             " but an indent level is 2 spaces wide.
set softtabstop=4            " <BS> over an autoindent deletes both spaces.
set expandtab                " Use spaces, not tabs, for autoindent/tab key.
set smarttab                 " some smarty tab handling
set shiftround               " Indent/outdent to nearest tabstop
" ------------------------------------------------------------------------------
" {{{2 Windows, Buffers
set splitright
set hidden                   " can jump btw buffers w/out saving
" ------------------------------------------------------------------------------
" {{{2 Buffer reading and writing
set noautowrite              " Never write a file unless I request it.
set noautowriteall           " NEVER.
set noautoread               " Don't automatically re-read changed files.
set modeline                 " Allow vim options to be embedded in files;
set modelines=5              " they must be within the first or last 5 lines.
set fileformats=unix,dos,mac         " Try recognizing dos, unix, and mac line endings.
" ------------------------------------------------------------------------------
" {{{2 Backups
set nobackup                 " Turn backup off
set nowritebackup
set noswapfile
" ------------------------------------------------------------------------------
" {{{2 Undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000          " maximum number of changes that can be undone
set undoreload=10000         " maximum number lines to save for undo on a buffer reload
" ------------------------------------------------------------------------------
" {{{2 Statusline
set laststatus=2             " Always hide the statusline
" Format the statusline
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c
" ------------------------------------------------------------------------------
" {{{2 Completion
set completeopt=menu,longest,preview
set infercase
" ------------------------------------------------------------------------------
" {{{2 Color
" colorscheme axolx2
" colorscheme lettuce
" colorscheme darkblue
" colorscheme xterm16
" colorscheme inkpot
colorscheme default
" ------------------------------------------------------------------------------
" {{{2 Autocommands                                                             
if has("autocmd")
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost * if line("'\"") | exe "'\"" | endif
    autocmd FileType python set smartindent
    autocmd FileType css set smartindent
    autocmd FileType xhtml,html set formatoptions+=tl
    "autocmd BufWritePost *.less exe '!lessc ' . shellescape(expand('<afile>')) . ' ' . shellescape(expand('<afile>:r')) . '.css'
    autocmd BufReadPost *.less exe 'set ft=less'
endif

if has("autocmd")
 augroup myvimrchooks
  au!
  autocmd bufwritepost .vimrc source ~/.vimrc
  autocmd bufwritepost .vimrc source ~/.gvimrc
 augroup END
endif
" {{{2 @todo Oragnize me!
let g:netrw_liststyle = 1
let g:netrw_hide = 1
let g:netrw_winsize = 20
let g:netrw_browse_split = 0
let g:netrw_sort_by='time'
let g:netrw_sort_direction='reverse'
let g:javaScript_fold = 1
let g:xml_syntax_folding = 1
let g:bufExplorerOpenMode = 1
let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:bufExplorerSortBy='fullpath'
let g:Perl_Root= 'Plugin.&Perl.'
let g:proj_flags='g'
let g:tlist_javascript_settings = 'javascript;s:string;a:array;o:object;f:function'
set errorformat+=\"%f\"\\,%l\\,%c\\,%t%*[a-zA-Z]\\,\"%m\"\\,%*[a-zA-Z0-9_.-]

" ------------------------------------------------------------------------------
" {{{2 Functions
function! ToggleHLSearch()
    if &hls
        set nohls
    else
        set hls
    endif
endfunction

function! ToggleSpell()
    if &spell
        set nospell
    else
        set spell
    endif
endfunction
com! Kwbd let kwbd_bn= bufnr("%")|enew|exe "bdel ".kwbd_bn|unlet kwbd_bn 

function! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

function! CurDir()
    let curdir = substitute(getcwd(), '/Users/amir/', "~/", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction

function! ToggleBackground()
    if &background == "light"
        set background=dark
    else
        set background=light
    endif
endfunction

" ------------------------------------------------------------------------------
" {{{2 Mappings
let mapleader = '\'
cnoremap <C-a> <S-Left>
cnoremap <C-s> <S-Right>
imap jj <Esc>
noremap <Leader>m   :MarksBrowser<CR>
noremap <Leader>r   :MRU<CR>
noremap <Leader>as   ^y$:!<C-R>"<CR>
noremap <Leader>abd :Kbbd<CR>
noremap <Leader>bb  :call ToggleBackground()<CR> 
noremap <Leader>bc  :close<CR>
noremap <Leader>lo  :lopen<CR>
noremap <Leader>lc  :lclose<CR>
noremap <Leader>po  :popen<CR>
noremap <Leader>pc  :pclose<CR>
noremap <leader>cts :CommandTFlush<CR>
noremap <Leader>f0  :set fdl=0<CR>
noremap <Leader>f1  :set fdl=1<CR>
noremap <Leader>f2  :set fdl=2<CR>
noremap <Leader>ft  :let &foldlevel=foldlevel('.')<CR>
noremap <Leader>i   :IndentGuidesToggle<CR>
noremap <Leader>n   :Ex<CR>
noremap <Leader>h   :call ToggleHLSearch()<CR> 
noremap <Leader>s   :call ToggleSpell()<CR> 
noremap <Leader>v   :BufExplorer<CR>
noremap <Leader>ys  :YRShow<CR>

" write file as sudo
cmap w!! w !sudo tee % >/dev/null

" fixes lame regex system
"nnoremap / /\v
"vnoremap / /\v
" ------------------------------------------------------------------------------
" {{{2 File associations
au BufRead,BufNewFile *.tt2 set filetype=tt2html
au BufRead,BufNewFile *.tt2 set foldmethod=marker
au BufNewFile,BufRead *.as set filetype=actionscript
au BufRead,BufNewFile *.module set filetype=php
au BufRead,BufNewFile *.profile set filetype=php
au BufRead,BufNewFile *.inc set filetype=php
au BufRead,BufNewFile *.tpl set filetype=php
au BufRead,BufNewFile *.md set filetype=markdown 
" ------------------------------------------------------------------------------
" {{{1 Plugins
" ------------------------------------------------------------------------------
" {{{2 Indentguides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
" let g:indent_guides_enable_on_vim_startup = 1
" ------------------------------------------------------------------------------
" {{{2 Tags
set tags=./tags,tags,~/Dropbox/lib/php/tags
let Tlist_Ctags_Cmd = "/opt/local/bin/ctags --langmap=php:.install.inc.module.theme.php --php-kinds=cdfi --languages=php"
let Tlist_WinWidth = 25
let Tlist_Process_File_Always = 1
let tlist_php_settings = 'php;c:class;d:constant;f:function'
noremap <Leader>c1 :TlistToggle<CR>
noremap <Leader>cr :!/opt/local/bin/ctags -R .<CR>
noremap <Leader>cd :!/opt/local/bin/ctags --langmap=php:.engine.inc.module.theme.php.test --php-kinds=cdfi --languages=php --recurse<CR>
" ------------------------------------------------------------------------------
" {{{2 Buffexplorer
let g:bufExplorerShowRelativePath=1
let g:bufExplorerSortBy='mru'
" ------------------------------------------------------------------------------
" {{{2 Command-T
let g:CommandTMaxHeight = 15
set wildignore+=*.o,*.obj,.git,*.pyc
" ------------------------------------------------------------------------------
" {{{2 Yankring
let g:yankring_history_dir='$HOME/.vim'
" ------------------------------------------------------------------------------
" {{{2 Project
let g:proj_flags='st'
let g:proj_window_increment=25
" ------------------------------------------------------------------------------
" {{{2 SuperTab
" Currently disabled in favor of AutoComplPop 
" let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
" ------------------------------------------------------------------------------
" {{{2 Gundo
nnoremap <leader>g :GundoToggle<CR>
" ------------------------------------------------------------------------------
" {{{2 VimDebugger
noremap <F11> :DbgStepInto<CR>
noremap <F10> :DbgStepOver<CR>
noremap <S-F11> :DbgStepOut<CR>
noremap <F5> :DbgRun<CR>
noremap <S-F5> :DbgDetach<CR>
noremap <F8> :DbgToggleBreakpoint<CR>
" ------------------------------------------------------------------------------
" {{{2 AutoComplPop
let g:acp_enableAtStartup = 1
let g:acp_completeoptPreview = 1
"let g:acp_completeOption = ".,w,b,k,t,i"
let g:acp_behaviorSnipmateLength = 1
" ------------------------------------------------------------------------------
" {{{2 Syntastic
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
" ------------------------------------------------------------------------------
" {{{2 Commentary
set commentstring=//\ %s
" Custom comments per file type: 
autocmd FileType apache set commentstring=#\ %s

" ------------------------------------------------------------------------------
" {{{2 VCSCommand
let g:VCSCommandDisableMappings=1
let g:VCSCommandVCSTypeOverride = [ [ '\/si\/core\/', 'git' ] ]
let g:VCSCommandSVNDiffOpt='w'

" ------------------------------------------------------------------------------
" {{{2 Pathogen                                                                 
source ~/.vim/bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
" {{{1 Language Specific
" {{{2 PHP
"  @see:
"  http://www.koch.ro/blog/index.php?/archives/62-Integrate-PHP-CodeSniffer-in-VIM.html
function! RunPhpcs()
    let l:filename=@%
    let l:phpcs_output=system('/opt/local/bin/phpcs --report=csv --standard=Zend '.l:filename)
    let l:phpcs_list=split(l:phpcs_output, "\n")
    unlet l:phpcs_list[0]
    cexpr l:phpcs_list
    cwindow
endfunction
command! Phpcs execute RunPhpcs()
nnoremap <leader>ps :Phpcs<CR>

au FileType php set omnifunc=phpcomplete#CompletePHP
au BufRead,BufNewFile *.php set foldlevel=1
au BufRead,BufNewFile *.module set foldlevel=1
" au BufWrite *.php :call DeleteTrailingWS()
au FileType php au BufWrite <buffer> :call DeleteTrailingWS()
let php_folding = 1
let php_noShortTags = 1
let php_sql_query=1                                                                                        
let php_htmlInStrings=1
let g:php_folding='2'
" ------------------------------------------------------------------------------
" {{{2 JS
function! JavaScriptFold() 
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au BufRead,BufNewFile *.json set ft=javascript
" ------------------------------------------------------------------------------
" {{{2 Git
au FileType gitcommit set nofoldenable

" ------------------------------------------------------------------------------
" {{{1 Ideas and inspiration
"
" Matt Wozniski: https://github.com/godlygeek/vim-files/blob/master/.vimrc
" Steve Losh:    https://github.com/sjl/dotfiles/tree/master/vim
" Tim Pope:      https://github.com/tpope/vimfiles
" ------------------------------------------------------------------------------
"
" vim:fdm=marker
"
