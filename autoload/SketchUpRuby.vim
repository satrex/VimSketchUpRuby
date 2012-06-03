" autoload/sketchup.vim
" Author:  Satoshi Suzuki <satrex@livedoor.com>
" Version: 0.0.1
" Install this file as autoload/sketchup.vim.  This file is sourced manually by
" plugin/sketchup.vim.  It is in autoload directory to allow for future usage of
" Vim 7's autoload feature.

" Exit quickly when:
" - this plugin was already loaded (or disabled)
" - when 'compatible' is set

if &cp || exists("g:autoloaded_vsu")
  finish
endif
let g:autoloaded_vsu= '1'

let s:cpo_save = &cpo
set cpo&vim

" Utility Functions {{{1
function! s:error(str)
  echohl ErrorMsg
  echomsg a:str
  echohl None
  let v:errmsg = a:str

endfunction
" }}}1


function! s:escarg(s)
  return escape(a:s, ' ')
endfunction

let g:su_plugin_path= expand(g:su_plugin_path, ':p')
if !isdirectory(g:su_plugin_path)
  call mkdir(g:su_plugin_path, 'p')
endif

"------------------------
" function
"------------------------

let g:suBridgePath = expand('<sfile>:p:h')

function! SketchUpRuby#run()
    let saveCursor = getpos(".")  
    normal! gg"*yG  
    call setpos('.', saveCursor)  
    execute "!osascript " . g:suBridgePath . "/" . "RunSketchUpRuby.scpt"
endfunction

function! SketchUpRuby#list()
  if get(g:, 'vsu_vimfiler', 0) != 0
    exe "VimFiler" s:escarg(g:su_plugin_path) 
  else
    exe "e" s:escarg(g:su_plugin_path) 
  endif
endfunction

function! SketchUpRuby#grep(word)
  let word = a:word
  if word == ''
    let word = input("SketchUpRuby word: ")
  endif
  if word == ''
    return
  endif

  try
    if get(g:, 'vsu_qfixgrep', 0) != 0
      exe "Vimgrep" s:escarg(word) s:escarg(g:su_plugin_path)
    else
      exe "vimgrep" s:escarg(word) s:escarg(g:su_plugin_path )
    endif
  catch
    redraw | echohl ErrorMsg | echo v:exception | echohl None
  endtry
endfunction

function! SketchUpRuby#new(title)
 if 0 < strlen(a:title)
  let title= a:title
else
  let title = input("Script name: ", "") 
endif
 
if 0 < strlen(title) 
  let file_name = title . ".rb"
else
  return
endif

  echo "Making that script" . file_name
  exe (&l:modified ? "sp" : "e") s:escarg(g:su_plugin_path . file_name)

  " apply template
  let err = append(0, "require 'Sketchup'")

endfunction

let &cpo = s:cpo_save

" vim:set ft=vim ts=2 sw=2 sts=2:
