" Vim filetype detection file
" Author:	Erik Falor <ewfalor@gmail.com>
" Copyright:	Copyright (c) 2023
" Licence:	You may redistribute this under the same terms as Vim itself

if did_filetype()
	finish
endif

" .notes files
if expand('<amatch>:t') =~ '^\.notes$'
	setfiletype txt
	finish
endif
