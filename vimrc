let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'Shougo/unite.vim'

Plug 'fadein/vim-FIGlet'
Plug 'fadein/vim-legacy'

Plug 'guns/vim-sexp'
let g:sexp_enable_insert_mode_mappings = 0

Plug 'junegunn/fzf'

Plug 'jamessan/vim-gnupg'

Plug 'mbbill/undotree'

Plug 'ramele/agrep'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

Plug 'vim-scripts/VisIncr'

Plug 'bhurlow/vim-parinfer'

call plug#end()
