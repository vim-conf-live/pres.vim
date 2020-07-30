" Last Change: 2020 juil. 30

augroup pres_vim
	autocmd FileType markdown command! -nargs=0 PresStart call pres#start(expand("%"))
	autocmd FileType markdown command! -nargs=0 PresNotes call pres#notes(expand("%"))
augroup END
