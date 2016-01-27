function! <SID>Shebang(command, ...)
	if a:command == ''
		echoerr "Usage: Shebang(command)"
		return
	endif

	"save cursor position
	let save_pos = getpos('.')

	let path = system('which ' . a:command)
	"path has a null char at the end of it, this 
	"trims it off
	let path = path[:-2]
	if !v:shell_error
		let shebang = '#!' . path

		for a in a:000
			let shebang .= ' ' . a
		endfor

		if getline(1) =~ '^#!'
			"replace an already existing shebang line
			call setline(1, shebang)
		else
			"otherwise, add it to the top and replace the cursor
			"one line lower than we found it
			call append(0, shebang)
			let save_pos[1] += 1
		endif
	else
		call setpos('.', save_pos)
		echoerr "Could not find command " . a:command
		return
	endif

	"make this file executable
	call system('chmod +x -- ' . shellescape(expand('%')))

	"restore cursor positon
	call setpos('.', save_pos)
endfunction

command! -nargs=+ -bar Shebang call <SID>Shebang(<f-args>)
