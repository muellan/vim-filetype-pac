# vim-ft-pac

### About

A simple filetype plugin that provides basic syntax highlighting for [AM Simple Packing Format (PAC)](https://github.com/muellan/packing#file-format) files.


### Highlight Groups

```vim
hi def link pacNumber       Number
hi def link pacSeparator    String
hi def link pacScenario     PreProc
hi def link pacPacking      PreProc
hi def link pacContainer    Keyword
hi def link pacContent      Keyword
hi def link pacRemaining    Keyword
hi def link pacFileRef      Type
hi def link pacEntityType   Type 
hi def link pacEntityCount  Identifier 
```

