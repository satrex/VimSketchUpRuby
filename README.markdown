SketchUpRuby(Google/Trimble SketchUp Ruby Envionment)
============

This script is intended to improve development of  [Google/Trimble SketchUp](http://sketchup.google.com/) plugins with running editing script immidiately.
It's currently available only on mac.

Setup
------------
Set the path to your Google/Trimble SketchUp plugins directory in your .vimrc.(default directory `"/Library/Application Support/Google SketchUp 8/SketchUp/Plugins/"`)

	let g:su_plugin_path = "path/to/directory/"
	
NOTICE: 
- Don't forget to escape spaces by backslash(\).
- The directory expression needs slash(/) at the end.

 Example:
 
		let g:su_plugin_path = "/Library/Application\ Support/Google\ SketchUp\ 8/SketchUp/Plugins/"


    let g:octopress_path = "path/to/dir"

You may also want to add a few mappings to stream line the behavior:

    nnoremap <Leader>sun  :SketchUpRubyNew<CR>
    nnoremap <Leader>sul  :SketchUpRubyList<CR>
    nnoremap <Leader>sug  :SketchUpRubyGrep<CR>
    nnoremap <leader>sur :SketchUpRubyRun<CR>

Commands
------------

Create New Script on SketchUp Plugin Directory:

    :SketchUpRubyNew

Show Plugin List:

    :SketchUpRubyList

Grep Octopress Posts Directory:

    :SketchUpRubyGrep

Options
------------

    let g:su_plugin_path  = "path/to/dir"

Install
------------

Copy it to your plugin and autoload directory.

License
------------

License: Same terms as Vim itself (see [license](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license))
