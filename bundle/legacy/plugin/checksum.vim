" vim:ft=vim foldmethod=marker tw=78 ff=unix
" TODO: bug in the range handling logic of MD5Compare() and MD5CheckSum()
" ==========================================================================
" File:         checksum.vim (global plugin)
" Last Changed: 2008-06-26
" Maintainer:   Erik Falor <ewfalor@gmail.com>
" Version:      0.2
" License:      Vim License
" Purpose:      Compute MD5 or SHA1 checksum of entire file or range of lines.
"               Store checksum in buffer variable or in user-specified
"               register.  Uses external programs to compute checksums;
"               currently supports GNU md5sum, GNU sha1sum, and OpenSSL.
"
"               If you are a Windows user, you should install GNU CoreUtils
"               for Windows
"               (http://gnuwin32.sourceforge.net/downlinks/coreutils.php)
"               or Win32 OpenSSL
"               (http://www.slproweb.com/products/Win32OpenSSL.html)
"
" Usage:        :{range}MD5 [register] - displays MD5 checksum for given range
"               of lines (default is entire file) and stores in b:md5sum and
"               the register named as an argument.
"               :{range}SHA1 [register] - displays SHA1 checksum for given
"               range of lines (default is entire file) and stores in
"               b:sha1sum and the register named as an argument.
"               <Leader>md - displays MD5 checksum for entire file or visual
"               selection and stores in b:md5sum
"               <Leader>sh - displays SHA1 checksum for entire file or visual
"               selection and stores in b:sha1sum
" Changes: 
" 0.2 2008-06-26
"   Checksum can be compared to previously calculated value.  Uppercased
"   custom command names.
"
" 0.1 2007-11-07
"   Initial release
" ==========================================================================

" Exit quickly if the script has already been loaded {{{
let s:this_version = '0.2'
if exists('g:loaded_checksum') && g:loaded_checksum == s:this_version
	finish
endif
let g:loaded_checksum = s:this_version
"}}}

" SHA1 Functions {{{
function! SHA1_sha1sum(first, last) "{{{
	let eol = Eol()
	if a:first < a:last
		let [f, l] = [a:first, a:last]
	else
		let [f, l] = [1, '$']
	endif
	return split(system('sha1sum', join(getline(f,l), eol) . eol))[0]
endfunction "}}}

function! SHA1_openssl(first, last) "{{{
	let eol = Eol()
	if a:first < a:last
		let [f, l] = [a:first, a:last]
	else
		let [f, l] = [1, '$']
	endif
	return split(system('openssl sha1 ', join(getline(f,l), eol) . eol))[-1]
endfunction "}}}

function! SHA1_noprog(...) "{{{
	return "Error: No sha1 program found"
endfunction "}}}

function! SHA1CheckSum(...) range "{{{
	"save the checksum in the variable b:md5sum, and optionally
	"into the register specified by the user

	if a:0 > 0 
		"if <line1> and <line2> were passed in from the command
		let [f, l] = [a:2, a:3]
	elseif a:firstline == a:lastline
		let [f, l] = [1, line('$')]
	else
		"use values in range
		let [f, l] = [a:firstline, a:lastline]
	endif

	let b:sha1sum = s:SHA1Prog(f, l)

	"save checksum into user-specified register
	if a:0 > 0 && len(a:1) > 0
		execute "let @" . a:1 . " = b:sha1sum"
	endif
	redraw | echo b:sha1sum
endfunction "}}}

function! SHA1GetCmd() "{{{
	"return name of command we're using to generate checksums
	return string(s:SHA1Prog)
endfunction
"}}}

function! SHA1SetCmd(cmd) "{{{
	"set sha1cmd
	let s:SHA1Prog = function(a:cmd)
	"return name of command we're using to generate checksums
	return string(s:SHA1Prog)
endfunction
"}}}

function! SHA1Compare(...) range "{{{
	" Compare current SHA1 checksum to previously computed value
	if !exists("b:sha1sum")
		if (a:0 > 0)
			call call('SHA1CheckSum', [a:1, a:firstline, a:lastline])
		else
			call call('SHA1CheckSum', ['', a:firstline, a:lastline])
		endif
	else
		let oldSHA1sum = b:sha1sum

		if (a:0 > 0)
			call call('SHA1CheckSum', [a:1, a:firstline, a:lastline])
		else
			call call('SHA1CheckSum', ['', a:firstline, a:lastline])
		endif

		if oldSHA1sum != b:sha1sum
			echo "SHA1 checksum differs"
		else
			echo "SHA1 checksum is the same"
		endif
	endif
endfunction "}}}
"}}}

" MD5 Functions {{{
function! MD5_md5sum(first, last) "{{{
	let eol = Eol()
	if a:first < a:last
		let [f, l] = [a:first, a:last]
	else
		let [f, l] = [1, '$']
	endif
	return split(system('md5sum', join(getline(f,l), eol) . eol))[0]
endfunction "}}}

function! MD5_openssl(first, last) "{{{
	let eol = Eol()
	if a:first < a:last
		let [f, l] = [a:first, a:last]
	else
		let [f, l] = [1, '$']
	endif
	return split(system('openssl md5 ', join(getline(f,l), eol) . eol))[-1]
endfunction "}}}

function! MD5_noprog(...) "{{{
	return "Error: No md5 program found"
endfunction "}}}

function! MD5CheckSum(...) range "{{{
	"save the checksum in the variable b:md5sum, and optionally
	"into the register specified by the user
"	call Dfunc('MD5CheckSum')
"	call Decho(a:000)

	if a:0 > 0 
"		call Decho("<line1> and <line2> were passed in from the command: " . a:0 . ', ' . a:1 . ', ' . a:2 . ', ' . a:3)
		"if <line1> and <line2> were passed in from the command
		let [f, l] = [a:2, a:3]
	elseif a:firstline == a:lastline
"		call Decho("using entire file")
		let [f, l] = [1, line('$')]
	else
		"use values in range
"		call Decho("using a:firstline=" . a:firstline . ", a:lastline=" . a:lastline)
		let [f, l] = [a:firstline, a:lastline]
	endif

	let b:md5sum = s:MD5Prog(f, l)

	"save checksum into user-specified register
	if a:0 > 0 && len(a:1) > 0
		execute "let @" . a:1 . " = b:md5sum"
	endif
	redraw | echo b:md5sum

"	call Decho(b:md5sum)
"	call Dret('MD5CheckSum')
endfunction "}}}

function! MD5GetCmd() "{{{
	"return name of command we're using to generate checksums
	return string(s:MD5Prog)
endfunction
"}}}

function! MD5SetCmd(cmd) "{{{
	"set md5cmd
	let s:MD5Prog = function(a:cmd)
	"return name of command we're using to generate checksums
	return string(s:MD5Prog)
endfunction
"}}}

function! MD5Compare(...) range "{{{
"	call Dfunc("MD5Compare")
	" Compare current MD5 checksum to previously computed value
"	call Decho("a:firstline=" . a:firstline . ", a:lastline=" . a:lastline)
	if (a:0 > 0)
"		call Decho("<line1> and <line2> were passed in to MD5Compare " . a:0 . ', ' . a:1 . ', ' . a:2 . ', ' . a:3)
	endif
	if !exists("b:md5sum")
		if (a:0 > 0)
			call call('MD5CheckSum', [a:1, a:firstline, a:lastline])
		else
			call call('MD5CheckSum', ['', a:firstline, a:lastline])
		endif
	else
		let oldMD5sum = b:md5sum

		if (a:0 > 0)
"			call Decho("a:0 > 0")
			call call('MD5CheckSum', [a:1, a:firstline, a:lastline])
		else
"			call Decho("a:0 <= 0")
			call call('MD5CheckSum', ['', a:firstline, a:lastline])
		endif

		if oldMD5sum != b:md5sum
			echo "MD5 checksum differs"
		else
			echo "MD5 checksum is the same"
		endif
	endif
"	call Dret("MD5Compare")
endfunction "}}}
"}}}

function! Eol() "{{{
	"return lineending string
	if &fileformat == 'unix'
		return "\n"
	elseif &fileformat == 'dos'
		return "\r\n"
	elseif &fileformat == 'mac'
		return "\r"
	endif
endfunction "}}}

" Find a program to calculate the checksum, or die trying
"md5 checksum {{{
if executable('md5sum')
	"md5sum
	let s:MD5Prog = function('MD5_md5sum')
elseif executable('openssl')
	"OpenSSL
	let s:MD5Prog = function('MD5_openssl')
else
	"No program found
	let s:MD5Prog = function('MD5_noprog')
endif
"}}}
	
"sha1 checksum {{{
"sha1sum
if executable('sha1sum')
	let s:SHA1Prog = function('SHA1_sha1sum')
"OpenSSL
elseif executable('openssl')
	let s:SHA1Prog = function('SHA1_openssl')
else
	"No program found
	let s:SHA1Prog = function('SHA1_noprog')
endif
"}}}


"Mappings 
" MD5 {{{
" clean up existing key mappings upon re-loading of script
if hasmapto('<Plug>MD5Sum') 
	nunmap \md
	vunmap \md
	nunmap \mc
	vunmap \mc
	nunmap <Plug>MD5Sum
	vunmap <Plug>MD5Sum
	nunmap <Plug>MD5SumCompare
	vunmap <Plug>MD5SumCompare
endif

" Key mappings
nmap <silent> <unique> <Leader>md <Plug>MD5Sum
vmap <silent> <unique> <Leader>md <Plug>MD5Sum
nmap <silent> <unique> <Leader>mc <Plug>MD5SumCompare
vmap <silent> <unique> <Leader>mc <Plug>MD5SumCompare

" Plug mappings for the key mappings
nmap <silent> <unique> <script> <Plug>MD5Sum :call MD5CheckSum()<CR>
vmap <silent> <unique> <script> <Plug>MD5Sum :call MD5CheckSum()<CR>
nmap <silent> <unique> <script> <Plug>MD5SumCompare :call MD5Compare()<CR>
vmap <silent> <unique> <script> <Plug>MD5SumCompare :call MD5Compare()<CR>

" Command - may take a register name as an argument
command! -nargs=? -range=% -register MD5 call MD5CheckSum("<reg>", "<line1>", "<line2>")
command! -nargs=? -range=% -register MD5C call MD5Compare("<reg>", "<line1>", "<line2>")
"}}}

"SHA1 {{{
" clean up existing key mappings upon re-loading of script
if hasmapto('<Plug>SHA1Sum') 
	nunmap \sh
	vunmap \sh
	nunmap \sc
	vunmap \sc
	nunmap <Plug>SHA1Sum
	vunmap <Plug>SHA1Sum
	nunmap <Plug>SHA1SumCompare
	vunmap <Plug>SHA1SumCompare
endif

" Key mappings
nmap <silent> <unique> <Leader>sh <Plug>SHA1Sum
vmap <silent> <unique> <Leader>sh <Plug>SHA1Sum
nmap <silent> <unique> <Leader>sc <Plug>SHA1SumCompare
vmap <silent> <unique> <Leader>sc <Plug>SHA1SumCompare

" Plug mappings for the key mappings
nmap <silent> <unique> <script> <Plug>SHA1Sum :call SHA1CheckSum() <CR>
vmap <silent> <unique> <script> <Plug>SHA1Sum :call SHA1CheckSum() <CR>
nmap <silent> <unique> <script> <Plug>SHA1SumCompare :call SHA1Compare() <CR>
vmap <silent> <unique> <script> <Plug>SHA1SumCompare :call SHA1Compare() <CR>

" Command - may take a register name as an argument
command! -nargs=? -range=% -register SHA1 call SHA1CheckSum("<reg>", "<line1>", "<line2>")
command! -nargs=? -range=% -register SHA1C call SHA1Compare("<reg>", "<line1>", "<line2>")
"}}}

let g:MD5Prog = s:MD5Prog
