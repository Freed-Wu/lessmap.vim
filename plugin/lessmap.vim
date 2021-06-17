if exists('g:loaded_lessmap') || &cpoptions
	finish
endif
let g:loaded_lessmap = 1

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let g:lessmap#git_author = get(g:, 'lessmap#git_author', split(system('git config --global user.name'))[0])

augroup lessmap "{{{
	autocmd!
	" for buffers whose &modifiable are 0 when them are created. (e.g.
	" help, quickfix)
	autocmd BufRead * call lessmap#remap(!&modifiable)
	autocmd StdinReadPre * call lessmap#remap()
	if exists('##TermEnter')
		autocmd TermOpen * call lessmap#remap()
	elseif exists('##TerminalOpen')
		autocmd TerminalOpen * call lessmap#remap()
	endif
	" for buffers whose &modifiable are seted to 0. (e.g. startify, defx)
	autocmd OptionSet modifiable call lessmap#remap(!&modifiable)
augroup END "}}}

function! lessmap#remap(...) abort "{{{
	if !a:0 || a:1
		call lessmap#map()
	else
		try
			call lessmap#unmap()
		catch /^Vim\%((\a\+)\)\=:E31:/
		endtry
	endif
endfunction "}}}

function! lessmap#map() abort "{{{
	nnoremap <nowait><buffer> <C-r> :<C-u>execute 'vertical resize ' . (winwidth(0) > &columns * 3 / 8? &columns / 4: &columns / 2)<CR>
	nmap <nowait><buffer> u <C-U>
	nmap <nowait><buffer> d <C-D>
	nmap <nowait><buffer> U <C-B>
	nmap <nowait><buffer> D <C-F>
endfunction "}}}

function! lessmap#unmap() abort "{{{
	nunmap <buffer> <C-r>
	nunmap <buffer> u
	nunmap <buffer> d
	nunmap <buffer> U
	nunmap <buffer> D
endfunction "}}}

" undotree will load self's map to override lessmap
if exists(':UndotreeToggle') == 2
	function! Undotree_CustomMap()
		call lessmap#map()
	endfunction
endif

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
