" Last Change: 2020 Sep 02

" Utility functions "{{{

function! s:setupTab(filename) abort "{{{
	let l:pres_name = s:fnameToPresName(a:filename)

	call execute("silent tabedit " . l:pres_name)
	setlocal ft=markdown
	setlocal noswapfile
	setlocal buftype=nofile
	setlocal bufhidden=hide
	setlocal nonumber
	setlocal norelativenumber
	setlocal colorcolumn=
	setlocal signcolumn=no
	setlocal laststatus=0
	setlocal noruler
	setlocal shortmess=
	setlocal nohlsearch
	setlocal nolist

	let w:pres_name = l:pres_name
	let w:slides = s:parse(a:filename)
endfunction "}}}

function! s:buildContent(slide, pres_name, index, total, win_height) abort "{{{
	let l:content = copy(get(a:slide, "content", []))
	let l:content_len = len(l:content)
	let l:padding_len = (a:win_height - l:content_len) / 2

	for j in range(l:padding_len - 1)
		call insert(l:content, '')
	endfor

	" First line is the header
	call insert(l:content, strftime("VimConf.Live %Y"))

	let l:padding_len = a:win_height - len(l:content)

	for j in range(l:padding_len - 1)
		call add(l:content, '')
	endfor

	call add(l:content, printf("%s [ %d / %d ]", a:pres_name, a:index + 1, a:total))

	return l:content
endfunction "}}}

function! s:fnameToPresName(filename) "{{{
	let l:name = fnamemodify(a:filename, ":t:r")
	let l:name = substitute(l:name, '\(-\|_\)', ' ', 'g')
	return l:name
endfunction "}}}

function! s:showSlide(index) abort "{{{
	if !exists("w:slides")
				\ || a:index >= len(w:slides)
				\ || a:index < 0
				\ || !exists("w:pres_name")
		echoerr "Invalid plugin state"
		return
	endif

	setlocal modifiable

	silent %delete
	silent call append(0, s:buildContent(w:slides[a:index], w:pres_name, a:index, len(w:slides), winheight(0)))
	silent call deletebufline(bufname(), '$')

	setlocal nomodifiable

	" Goto first line with a # symbol
	normal gg
	/^#/
	echo ""
endfunction "}}}

function! s:parse(filename) abort "{{{
	let l:slides = []
	let l:content_buffer = []
	let l:notes_buffer = []
	let l:fill_content = v:true
	for line in readfile(a:filename)
		" All --- lines will separate slides
		if line =~? '^-\+$'
			call add(l:slides, {"content": l:content_buffer, "notes": l:notes_buffer})
			let l:content_buffer = []
			let l:notes_buffer = []
			let l:fill_content = v:true
		" All ??? lines will make slide notes
		elseif line =~? '^?\+$'
			let l:fill_content = v:false
		else
			if l:fill_content
				call add(l:content_buffer, line)
			else
				call add(l:notes_buffer, line)
			end
		endif
	endfor

	" Tail call
	call add(l:slides, {"content": l:content_buffer, "notes": l:notes_buffer})

	return l:slides
endfunction "}}}
"}}}

" Starts the presentation
function! pres#start(filename) abort "{{{

	call s:setupTab(a:filename)

	let w:index = 0

	nnoremap <silent> <buffer> <Leader>n :call pres#next()<CR>
	nnoremap <silent> <buffer> <Leader>p :call pres#prev()<CR>
	if !exists(":PresGoto")
		command -buffer -nargs=1 PresGoto call pres#goto(<f-args>)
		command -buffer -nargs=0 PresReload call s:showSlide(w:index)
	endif

	call s:showSlide(w:index)
endfunction "}}}

" Shows presenter notes in a new tab
function! pres#notes(filename) abort "{{{
	call s:setupTab(a:filename)

	let l:content = []
	let l:i = 1

	for slide in w:slides
		call add(l:content, printf("# Slide %d : %s", l:i, l:slide.content[1]))
		let l:i += 1

		call extend(l:content, get(slide, "notes", []))
	endfor

	setlocal modifiable
	call append(0, l:content)
	setlocal nomodifiable

	nnoremap <buffer> <silent> ]] /^#/<CR>
	nnoremap <buffer> <silent> [[ ?^#?<CR>

	goto 1
endfunction "}}}

" Slide navigation "{{{

function! pres#next() abort "{{{
	if !exists("w:slides") || !exists("w:index")
		return
	endif

	" Already at last slide
	if w:index >= len(w:slides) - 1
		echo "Already on last slide."
		return
	endif

	let w:index += 1

	call s:showSlide(w:index)
endfunction "}}}

function! pres#prev() abort "{{{
	if !exists("w:slides") || !exists("w:index")
		return
	endif

	" Already at first slide
	if w:index <= 0
		echo "Already on first slide"
		return
	endif

	let w:index -= 1

	call s:showSlide(w:index)
endfunction "}}}

function! pres#goto(new_index) abort "{{{
	if !exists("w:slides") || !exists("w:index")
		return
	endif

	let l:index = a:new_index - 1

	" Already at first slide
	if l:index < 0 || l:index >= len(w:slides)
		echo "Invalid slide number : " . a:new_index
		return
	endif

	let w:index = l:index

	call s:showSlide(w:index)
endfunction "}}}

"}}}
