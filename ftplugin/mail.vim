set formatoptions=tcql
set comments+=n:\|	" '|' is a quote char.
set comments+=n:%	" '%' as well.
set spell
abbreviate plq Please let me know if you have any questions

"===========================================================================
" File:         Mail_Sig_set.vim                                        {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://hermitte.free.fr>
" URL: http://hermitte.free.fr/vim/ressources/vimfiles/ftplugin/mail/Mail_Sig_set.vim
"
" Last Update:  08th Apr 2004
"
" Purpose:      {{{2
"       Defines a command that strip signatures at the end of e-mail (/usenet
"       post) replies.
"
" Bonus:        {{{2
"       Defines an operator-pending mapping that will match our own signature
"       or the end of the file. Very handy when we want to delete every line
"       of a reply but our signature.
"       Usage: d-- to delete till the signature/footnote/end of the file
"              c-- to change till the signature/footnote/end of the file
"              y-- to yank   till the signature/footnote/end of the file etc.
"---------------------------------------------------------------------------
" Installation: {{{2
"       Drop this file into one of your {runtimepath}/ftplugin/mail/
"       directories and invokes the :EraseSignature command (either from this
"       file, or another one -- require a little modification).
"
"       If you don't use '>' as the indent char when you reply (cf.  the
"       $indent_string in mutt for instance), set "g:my_indent_char" to the
"       correct value before loading this file -- two options :
"       a) install this ftplugin into {rtp}/after/ftplugin/mail/ and
"          initialize the variable into another e-mail ftplugin present into
"          {rtp}/ftplugin/mail/ ; 
"       or b) add "let g:my_indent_char = ..." into your .vimrc --
"          "b:my_indent_char" is also supported.
"          Please note that I personally discourage anybody from such
"          practices -- but why am I supporting such a feature ?
"               
"       The characters recognized as quote characters can be changed thanks to
"       the variable : "g:quote_chars" (or "b:quote_chars").
"       }}}2
"
" Requires:     VIM 6.0+
" Thanks:       Cédric Duval for his improvments ; Loic Minier and Yann
"               Kéhervé for their suggestions and ideas.
" }}}1
"===========================================================================

" Avoid reinclusion ; not necessary very important for email ftplugins
if exists("g:loaded_Mail_Sig_set_vim") | finish | endif
let g:loaded_Mail_Sig_set_vim = 1

"---------------------------------------------------------------------------
" Operator Pending Mode Mapping:
" onoremap -- /\n^-- \=$\\|\%$/+0<cr>
onoremap -- /\n^-- \=$\\|\n^\[\d\+\]\\|\%$/+0<cr>
" explanation of the pattern : {{{
" 1- either match a new line (\n) followed by the double dashes alone on a
"    line
" 2- or match a footnote -> [\d+]
" 3- or match the last line (\%: line ; $:last)
" the {offset} of '+0' permit to match the end of the new line or the very end
" of the file.
" }}}

"---------------------------------------------------------------------------
command! -nargs=0 EraseSignature :call <sid>Erase_Sig()

"---------------------------------------------------------------------------
" Function:     s:Erase_Sig() {{{
" Purpose:      Delete signatures at the end of e-mail replies.
" Features:     * Does not beep when no signature is found
"               * Also deletes the empty lines (even those beginning by '>')
"                 preceding the signature.
"               * Do not delete the automatic signature inserted by the MUA
"               * Delete multiple signatures inserted by mailing lists
"---------------------------------------------------------------------------
function! s:Erase_Sig()
  normal! G
  " position of our signature if automatically inserted by our MUA
  let s = search('^-- $', 'b')
  let s = (s!=0) ? s : line('$')+1
  " position of a signature from the replied email
  let i = s:SearchSignatureOnce( s-1, s )
  " If found, then
  if i != 0
    " Try to see if an automatic signature from a mailing list has been
    " inserted
    let j = s:SearchSignatureOnce(i-1, s)
    if j != 0 | let i = j | endif
    " Finally, delete these lines plus the signature
    exe 'normal! '.i.'Gd'.(s-1).'G'
  endif
endfunction
" }}}

"---------------------------------------------------------------------------
" Function:     s:SearchSignatureOnce(l,s) {{{
" Purpose:      Search for the first line of a bloc empty of any information
"               (ie. only composed of spaces and indent characters) that
"               preceedes a quoted signature placed just before the l-th line.
"               If there is no bloc empty of information, the number of the
"               line of the quoted signature found is returned.
" Return:       The matching line, or 0 if no signature is found.
" Parameters:
"       l:  starting line of the backward search
"       s:  line number of the signature our MUA has automatically inserted.
"---------------------------------------------------------------------------
" Some Constants: {{{
" Function: s:SetVar() to global or default {{{
function! s:SetVar(var,default)
  if exists('b:'.a:var)
    let s:{a:var} = b:{a:var}
  elseif exists('g:'.a:var)
    let s:{a:var} = g:{a:var}
  else
    " doing :exe to dequote a:default
    exe "let s:{a:var} =".a:default
  endif
endfunction
command! -nargs=+ SetVar :call <sid>SetVar(<f-args>)
" }}}
SetVar my_indent_char '>'
SetVar quote_chars '>|:%'
if -1 != stridx(s:quote_chars,s:my_indent_char)
  let s:quote_chars = s:quote_chars . s:my_indent_char
endif
let s:empty_quoted_line ='^'.s:my_indent_char.'\(\s*['.s:quote_chars.']\)*\s*$'
" }}}
"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function! s:SearchSignatureOnce(l, pos_self_sig)
  " Search for the signature pattern : "^> -- $"
  exe a:l
  " let i = search('^> *-- \=$', 'b')
  let i = search('^'.s:my_indent_char.' *-- \=$', 'b')
  " If found, then
  if i != 0
    " 1- check that there is nothing (that is not quoted) between the
    " to-be-stripped signature and ours ; but is it really needed ?
    let j = search('^\s*[^'.s:my_indent_char.'[:space:]]', 'W')
    " call confirm('j='.j."  -- i=".i, '&Ok')
    if (j != 0) && (j<a:pos_self_sig) | return 0 | endif

    " 2- search for the last non empty (non sig) line
    while i >= 1
      let i = i - 1
      " rem : i can't value 1
      " if getline(i) !~ '^\(>\s*\)*$'
      if getline(i) !~ s:empty_quoted_line
        break
      endif
    endwhile
    " 3- return the number of line from which we can strip.
    let i = i + 1
  endif
  return i
endfunction
" }}}

"---------------------------------------------------------------------------
" NB: comment the next line if you don't want to handle the suppresion of the
" signatures from this file ...
:EraseSignature " comment me ?
"===========================================================================
" vim60: set fdm=marker:

