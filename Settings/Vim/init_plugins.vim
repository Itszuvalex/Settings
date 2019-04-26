call plug#begin('~\AppData\Local\nvim\plugged')

Plug 'arcticicestudio/nord-vim'
Plug 'blueshirts/darcula'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'shougo/denite.nvim'
Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'shougo/neoinclude.vim'
Plug 'shougo/defx.nvim'
Plug 'neoclide/coc.nvim', {'do' : { -> coc#util#install() }}
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'

" Langs
Plug 'davidhalter/jedi'
Plug 'deoplete-plugins/deoplete-jedi'

call plug#end()
