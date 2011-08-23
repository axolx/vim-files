set background=dark
set cursorline
set lines=50                 " Makes gui win 50 chars tall
set columns=85
set guifont=Monaco:h12
set noantialias
set fuopt=maxvert,maxhorz    " Full screen options
set guioptions-=T            " turn off toolbar

colorscheme inkpot           " Other good ones: vibrantink, lettuce, moria, solarized

if has("diff") && &diff
    set columns=165
endif

if exists('&macatsui')
    set nomacatsui
endif
