" Vim filetype detection file
" Author:	Erik Falor <ewfalor@gmail.com>
" Copyright:	Copyright (c) 2015
" Licence:	You may redistribute this under the same terms as Vim itself

if did_filetype()
	finish
endif

" .notes files
if expand('<amatch>:t') =~ '^\.notes$'
	setfiletype txt
	finish
endif

if expand('<amatch>') =~ '\.xaml$'
	setfiletype xml
	finish
endif
