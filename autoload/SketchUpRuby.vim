	" autoload/sketchup.vim
" Author:  satrex <satrex@livedoor.com>
" Version: 0.0.2
" Install this file as autoload/sketchup.vim.  This file is sourced manually by
" plugin/sketchup.vim.  It is in autoload directory to allow for future usage of
" Vim 7's autoload feature.

" Exit quickly when:
" - this plugin was already loaded (or disabled)
" - when 'compatible' is set

if &cp || exists("g:autoloaded_vsu")
  finish
endif
let g:autoloaded_vsu = '1'

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

let g:su_labo_path = expand(g:su_labo_path, ':p')
if !isdirectory(g:su_labo_path)
  call mkdir(g:su_labo_path, 'p')
endif

let g:su_deploy_path = expand(g:su_deploy_path, ':p')
if !isdirectory(g:su_deploy_path)
  call mkdir(g:su_deploy_path, 'p')
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

  echo "Making script" . file_name
  exe (&l:modified ? "sp" : "e") s:escarg(g:su_labo_path . file_name)

  " apply template
  let err = append(0, "require 'Sketchup'")

endfunction

function! SketchUpRuby#deploy(menu)
 if 0 < strlen(a:menu)
  let menu= a:menu
else
  let menu= input("Menu item name: ", "") 
endif
"ファイル名をメニューに使う場合は、コレを使う　expand("%:p:t:r")

if 0 == strlen(menu) 
  return
endif

" テスト中のファイルを、メニューに表示させる形でコピー
  let defLine = getline(search("def", "cw"))  
  call cursor(10000, 1)
  let endLine = search("end", "bcw")

  " endまでを取得
  let currentScript = getline(1, endLine)

 " テスト中のファイルのメソッド名を取得
  let methodName = matchstr(defLine, '\(def\s\+\)\zs\k\+', 0)
  echo " methodName=" . methodName

 " フッターを付加
  let currentScript += [ " plugins_menu = UI.menu(\"Plugins\") "]
  let currentScript += [ " item = plugins_menu.add_item(\"" . menu . "\") { " . methodName  . " }" ]  
  let currentScript += [ " file_loaded(__FILE__)"]
  call writefile(currentScript,  g:su_deploy_path . expand("%:p:t") )

" 拡張機能呼び出しファイルを作成
let i = 0
let newLines = []

let newLines += [ "require 'sketchup.rb'" ]
let newLines += [ "require 'extensions.rb'" ]
let newLines += [ "require 'LangHandler.rb'" ]

let newLines += [ "$exStrings = LanguageHandler.new(\"Examples.strings\")" ]

let newLines += [ "examplesExtension = SketchupExtension.new $exStrings.GetString(\"Ruby Script Deployment\"), \"" . g:su_deploy_path .  expand("%:p:t") . "\"" ]
                    
let newLines += [ "examplesExtension.description=$exStrings.GetString(\"Adds examples of tools created in Ruby to the SketchUp interface.  The example tools are Draw->Box, Plugins->Cost and Camera->Animations.\")" ]
"  let newLines += [ "file_loaded(__FILE__)" ]
 
let newLines += [ "Sketchup.register_extension examplesExtension, false" ]
let newLines += [ "examplesExtension.check" ]
  let newLines += []
  echo resolve(g:su_plugin_path)
  echo resolve(expand("%:p:t"))
  "echo g:su_plugin_path . expand("%:t")
  "
  call writefile(newLines,  g:su_plugin_path . expand("%:p:t") )


" 拡張機能登録処理（既存の処理を抜いて、新しいスクリプトを登録） 
" 既存の処理は抜けないっぽいので、SketchUpを再起動する
execute "!osascript " . g:suBridgePath . "RestartSketchUp.scpt"

endfunction

let &cpo = s:cpo_save

" vim:set ft=vim ts=2 sw=2 sts=2:
