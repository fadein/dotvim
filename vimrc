call pathogen#infect()

" Erik's vimrc file
"
" mapping to ShowSynStack() is found in Functions section

if ($TERM == "screen" || $TERM =~ "256")
    set t_Co=256
    set t_kb=
endif

if v:progname == "vim"
    set modeline
    set number
else
    "moved into this else: was just above this if before...
    set nomodeline
    set nonumber
endif

" Settings {{{
if exists("+autochdir")
    set noautochdir
endif

if has('folding')
    set foldmethod=indent
endif

"I never use a white terminal
if !has('gui_running')
    set background=dark
endif

"sort this block with the following command:
" .,/endsettings/-1sort /^"\?set\s\(no\)\?/
set autoindent
set autowrite "writes file before I :make it
set backspace=indent,eol,start "lets you use backspace on previously inserted words
set nobackup
set nocindent
set comments=s1:/*,mbx:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:- " is this right?
set cpoptions=BadFAces
set cscopequickfix=s-,c-,d-,i-,t-,e-
set cursorline
set directory^=/dev/shm
set noexpandtab
set formatoptions=tcqron
set grepformat=%f:%l:%m
set grepprg=grep\ -HnEi
set history=200
set hlsearch
set ignorecase
set incsearch
set isfname-==
set keymodel=startsel,stopsel
set laststatus=2 "make sure status line always appears, regardless of splits
set matchpairs=(:),{:},[:],<:>
set matchtime=3
set modeline  "activate modelines
set mouse=
set nrformats=hex
set number
set ruler
set scrolloff=0
set shiftwidth=4
set shortmess=aoOTt
set showcmd
set smartcase
set smartindent
set spellfile=$HOME/.vim/spell/local.en.add
set spellsuggest=best,5
set splitbelow splitright
set nostartofline
set statusline=%<%m%f:%l\ _%{winnr()}_\ %y%r%=<%b\ 0x%B>\ \ %c%V\ %P
set statusline=%m%f:%l/%L\ %P\ %<<%-3b\ 0x%-2B>\ %y%r%w%=b:%n\ w:%{winnr()}
set tabstop=4
set tags=tags
set undodir=$HOME/.vim/undo
set viminfo='100,<50,s10,h,n~/.vim/viminfo
set whichwrap=b,s,<,>,[,]
set nowildmenu
set wildmode=list:longest,full
set wrap
"endsettings

"settings to fix dreaded un-indenting of lines beginning with # 
set autoindent
inoremap # X#
"set commentstring="#%s"

if has('syntax')
    syntax enable
    highlight Folded      term=standout ctermfg=12 ctermbg=None
    "highlight CursorLine term=underline cterm=underline ctermfg=None
endif

if has('eval')
    filetype plugin indent on
endif
"}}}

" Mappings {{{
"emulate eclipse and VS build hotkey
map  <F4> :sign unplace *<CR> <bar>:ccl<CR>
imap <F4> <C-O>:sign unplace *<CR>
map  <F5> :make<CR>
imap <F5> <C-O>:make<CR>

" Make F1 less useless
map <F1> <Nop>
imap <F1> <Nop>
cmap <F1> <Nop>
smap <F1> <Nop>

" execute the current line of text as a shell command
noremap  Q !!zsh<CR>
vnoremap Q  !zsh<CR>

" Map alt-v in command-line mode to replace the commandline with the Ex
" command-line beneath the cursor in the buffer
cnoremap <Esc>v <C-\>esubstitute(getline('.'), '^\s*\(' . escape(substitute(&commentstring, '%s.*$', '', ''), '*') . '\)*\s*:*' , '', '')<CR>

" Use <C-L> to clear search highlighting
noremap <silent> <C-l> :nohlsearch <bar> redraw!<CR>
inoremap <silent> <C-l> <C-O>:nohlsearch <bar> redraw!<CR>

if has("win32")
    map <F1>   :silent ! start explorer.exe /select,% <CR>
    map <S-F1> :silent ! start cmd.exe <CR>
    no <F6> :silent !start ctags *<CR>
    imap <F6> <C-O>:silent !start ctags *<CR>
elseif has("unix")
    no <F6> :silent !ctags .<CR>
    im <F6> <C-O>:silent !ctags .<CR>
endif

map <F9> :Scratch<CR>

"}}}

" Global variables {{{
if has('eval')
let g:obviousModeInsertHi = 'gui=reverse'
let g:loaded_lustyjuggler = 1
let g:ZO_syntaxhighlight = 1
let g:ZO_sleepdelay = '50m'

let g:showfuncctagsbin='/usr/bin/exuberant-ctags'
let g:showfunc_width_pct=45
let g:errormarker_errorgroup = "Error"
let g:errormarker_warninggroup = "Todo"

"git branch info
let g:git_branch_status_nogit=""

let NERDShutUp = 1
endif
"}}}

"commands/aliases {{{
if has('user_commands')
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
command! -nargs=1 -complete=help Help      :help <args>
command! -nargs=1 -complete=help HElp      :help <args>
command! -nargs=* -bar -bang Ls            :ls<bang>
command! -nargs=0 Noh       :noh
command! -nargs=0 Date      :put ='* ' . strftime('%b %d, %Y %I:%M %p')
command! -nargs=? -bar Underline    :put =repeat( len('<args>') > 0 ? '<args>' : '=', len(getline('.')))
command! -nargs=0 Max       :let [s:lines, s:columns] = [&lines, &columns] | set lines=999 columns=999
command! -nargs=0 Taller    :let [s:lines, s:columns] = [&lines, &columns] |set lines=999
command! -nargs=0 Wider     :let [s:lines, s:columns] = [&lines, &columns] |set columns=999
command! -nargs=0 Restore  :let [s:lines, s:columns, &lines, &columns] = [&lines, &columns, s:lines, s:columns]
command! -nargs=0 Merge /^\(<\|=\|>\)\{7}\ze\(\s\|$\)/
endif
"}}}

" Autocommands {{{
if has('autocmd')
	autocmd BufRead *.xsl,*.xslt,*.xml,*.xsd,*.tas set filetype=xml
	autocmd FileType {xml,xslt} setlocal iskeyword=$,@,-,\:,48-57,_,128-167,224-235 
	autocmd FileType {xml,xslt} setlocal noexpandtab

    augroup RE_SOURCE_ON_WRITE
        autocmd! BufWritePost vimrc nested source <afile>
    augroup END

endif "has('autocmd')
"}}}

" Functions {{{
if has('eval')

    function! MakeSession() 
        let l:sess='$HOME\Desktop\new.session.vim'
        let l:msg="Wrote session "
        if v:this_session == eval("$HOME") . "\\_vimrc"
            exe "mksession! " . l:sess
            echomsg l:msg . l:sess
        else
            exe "mksession! " . v:this_session
            echomsg l:msg . v:this_session
        endif
    endfunction 

    function! Urldecode(str)
      let retval = a:str
      let retval = substitute(retval, '+', ' ', 'g')
      let retval = substitute(retval, '%\(\x\x\)', '\=nr2char("0x".submatch(1))', 'g')
      return retval
    endfunction

    if v:version > 700
        function! ShowSynStack()
            for id in synstack(line('.'), col('.'))
                echo synIDattr(id, "name")
            endfor
        endfunction

        "map <F1> :call ShowSynStack()<CR>
    endif

    if ! exists("g:running_ReSourceVimrc") 
        function! ReSourceVimrc() 
            let g:running_ReSourceVimrc = 1
            let l:this_session = v:this_session
            source ~/.vimrc
            let v:this_session = l:this_session
            unlet g:running_ReSourceVimrc
            redraw | echomsg "Re-sourced .vimrc"
        endfunction 
    endif

endif


" Cycle between line numbers, relative numbers, no numbers
if exists('+relativenumber')
  let g:loaded_RltvNmbrPlugin='skip'
  "CTRL-N is traditionally mapped to move the cursor down;
  "I never use it that way, and there are already four other
  "ways to do that
  nnoremap <expr> <C-N> CycleLNum()
  xnoremap <expr> <C-N> CycleLNum()
  onoremap <expr> <C-N> CycleLNum()

  " function to cycle between normal, relative, and no line numbering
  func! CycleLNum()
    if &l:rnu
      setlocal nonumber norelativenumber
    elseif &l:nu
      setlocal number relativenumber
    else
      setlocal number
    endif
    " sometimes (like in op-pending mode) the redraw doesn't happen
    " automatically
    redraw
    " do nothing, even in op-pending mode
    return ""
  endfunc
endif

"}}}

" File Changed Shell Handler {{{

if has('eval') && has('autocmd')
    augroup FCSHandler
        au FileChangedShell * call FCSHandler(expand("<afile>:p"))
    augroup END

    function! FCSHandler(name)
        let msg = 'File "'.a:name.'"'
        let v:fcs_choice = ''
        if v:fcs_reason == 'deleted'
            let msg .= " no longer available - 'modified' set"
            call setbufvar(expand(a:name), '&modified', '1')
        elseif v:fcs_reason == 'time'
            let msg .= ' timestamp changed'
        elseif v:fcs_reason == 'mode'
            let msg .= ' permissions changed'
        elseif v:fcs_reason == 'changed'
            let msg .= ' contents changed'
            let v:fcs_choice = 'ask'
        elseif v:fcs_reason == 'conflict'
            let msg .= ' CONFLICT --'
            let msg .= ' is modified, but'
            let msg .= ' was changed outside Vim'
            let v:fcs_choice = 'ask'
            echohl Error
        else  " unknown values (future Vim versions?)
            let msg .= ' FileChangedShell reason='
            let msg .= v:fcs_reason
            let v:fcs_choice = 'ask'
        endif
        redraw!
        echomsg msg
        echohl None
    endfunction
endif
" }}}

" vim:filetype=vim sw=4 foldmethod=marker tw=78 expandtab:
