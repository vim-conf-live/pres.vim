# pres.vim

The official vim-based presentation tool for VimConf.Live !

## Commands

Only in markdown files :

`PresStart` : to start the presentation, showing only the slides
`PresNotes` : to show the presenter notes

Showing the slides and the notes must be done in different vim instances.

When the presentation in opened :

`PresGoto {number}` : to go to a given slide
`PresReload` : to reload the current slide (might be needed if the window has changed size)

## Mappings

When inside a presentation :

`<Leader>n` : to go to the next slide
`<Leader>p` : to go to the previous slide

## Example

Open `Plugin_presentation.md`, run `:PresStart`, and be amazed !

One thing to note is that the plugin infers the name of the presentation from the file name, thus
the name of this presentation will be `Plugin presentation`.
