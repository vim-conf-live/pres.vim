# pres.vim

A dead-simple slideshow helper, that works within Vim.

We follow use a markdown formatting, with two additions :

- `---` represents slide separations
- `???` represents presenter notes separation

Hit `<Leader>n` to go to the next slide !

???

You can even have presenter notes !

---

# Mappings

`<Leader>n` to go to the next slide
`<Leader>p` to go to the previous slide

---

# Commands


`PresStart` to start a slideshow using the current markdown file
`PresGoto` when presenting to switch slide
`PresReload` when presenting to reload current slide
