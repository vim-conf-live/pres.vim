" Last Change: 2020 août 03

augroup pres_vim
	autocmd FileType markdown command! -buffer -nargs=0 PresStart call pres#start(expand("%"))
	autocmd FileType markdown command! -buffer -nargs=0 PresNotes call pres#notes(expand("%"))
augroup END
