" Scratch.vim:		Puts a scratch buffer at the tip of your fingers
" Maintainer:		Erik Falor <ewfalor@gmail.com>
" Date:				Oct 17, 2007
" Version:			0.1
" License:			If you copy this, just give me props.
"
" History:
"   Version 0.1:	Initial version - creates a 

if exists('loaded_scratch')
	finish
endif
let loaded_scratch = 1

let s:sc_bufname = 'Scratch'

function! s:OpenScratchWin() "{{{
	"first see if the scratch buffer even exists
	if !exists("g:scratchWinheight")
		let g:scratchWinheight = 10
	endif
	if !bufexists(s:sc_bufname) && bufnr("*/".s:sc_bufname."$") == -1
		"create new buffer if not existant
		execute "bot " . g:scratchWinheight . "new " . s:sc_bufname
		setlocal buftype=nofile
		setlocal bufhidden=hide
		setlocal noswapfile
	elseif ( bufwinnr(s:sc_bufname) > 0)
		"window exists and is visible, switch to it
		execute bufwinnr(s:sc_bufname) . "wincmd W"
		"execute "res " . g:scratchWinheight
	else
		"window must be closed, make a new one
		execute "bot " . g:scratchWinheight ."new"
		execute "b ".bufnr(s:sc_bufname)
	endif
	let g:scratchWinOpen = 1
endfunction "}}}

function! s:CloseScratchWin() "{{{
	if ( bufwinnr(s:sc_bufname) > 0)
		"window exists and is visible, close it
		let l:curWin = bufwinnr("%")
		"switch to scratch buffer, 
		execute bufwinnr(s:sc_bufname) . "wincmd W"
		"close it,
		execute bufwinnr(s:sc_bufname) . "wincmd c"
		"switch back to original buf
		execute l:curWin . "wincmd W"
		let g:scratchWinOpen = 0
	endif
endfunction "}}}

function! <SID>ToggleScratchWin() "{{{
	if bufwinnr(s:sc_bufname) < 0
		call s:OpenScratchWin()
	else
		call s:CloseScratchWin()
	endif
endfunction "}}}

if !exists(":Scratch")
	command! -nargs=0 Scratch call <SID>ToggleScratchWin()
endif
