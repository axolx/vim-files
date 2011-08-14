set foldmarker={,}
set foldmethod=marker

"if exists('&omnifunc')
"" Distinguish between HTML versions
"" To use with other HTML versions add another
"" elseif condition to match proper DOCTYPE
setlocal omnifunc=csscomplete#CompleteCSS
"endif
