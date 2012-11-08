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

Usage
------------
To write a SketchupScript

1. Launch Sketchup
2. Launch VIM
3. Type "\sun" (as SketchUp New)
4. Type script file name in prompt and you'll got a file in your su_plugin_path/test.
5. Write your script in script file.
6. Type "\sur" (as Sketchup Run) and script will run in Sketchup.
7. When the script is completed, you should make a method wrapping the script.
8. To add script to Sketchup plugin menu, type "\sud" (as Sketchup deploy).
9. Type menu name into script and then Sketchup restarts.
10. Sketchup menu will have item you typed.
11. When clicked the item in Sketchup Plugin menu, you'll see the script run.

Commands
------------

Create New Script on SketchUp Plugin Directory:

    :SketchUpRubyNew

Show Plugin List:

    :SketchUpRubyList

Deploy script as sketchup plugin(notice: this adds menu of local SketchUp, not to cloud):

    :SketchUpRubyDeploy

Options
------------

    let g:su_plugin_path  = "path/to/dir"

Install
------------

Copy it to your plugin and autoload directory.

License
------------

License: Same terms as Vim itself (see [license](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license))
