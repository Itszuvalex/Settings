so ~\AppData\local\nvim\.vimrc
so ~\AppData\local\nvim\init_plugins.vim

" Function to source all .vim files in directory {
function! SourceDirectory(file)
  for s:fpath in split(globpath(a:file, '*.vim'), '\n')
    exe 'source' s:fpath
  endfor
endfunction
" }

call SourceDirectory("~\AppData\local\nvim\Vimfiles")

if has('nvim')
	so ~\AppData\local\nvim\nvim_keys.vim
endif

let g:python3_host_prog = expand("~\\scoop\\apps\\python\\current\\python.exe")

set guifont=Source\ Code\ Pro
color darcula
"let g:airline_theme='dracula'
set number
set relativenumber

call deoplete#enable()

au BufRead,BufNewFile,BufWinEnter sources set syntax=make
au BufRead,BufNewFile,BufWinEnter sources.inc set syntax=make

set clipboard=unnamedplus
