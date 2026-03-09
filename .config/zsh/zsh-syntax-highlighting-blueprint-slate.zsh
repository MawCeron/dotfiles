## Blueprint Slate — ZSH Syntax Highlighting Theme
## Palette:
##   text    #c8d4dc   dim     #5a6570   muted   #6878a0
##   accent  #95a1aa   cyan    #5fb3b3   green   #7ab87a
##   yellow  #c9a84c   red     #c96a6a   purple  #8a7ab8

## Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#5a6570'

## Functions/methods
ZSH_HIGHLIGHT_STYLES[alias]='fg=#6878a0'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#6878a0,underline'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#6878a0,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#6878a0'
ZSH_HIGHLIGHT_STYLES[command]='fg=#6878a0'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#6878a0,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#c9a84c,italic,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#c9a84c'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#c9a84c'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#8a7ab8'

## Built ins
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#5fb3b3,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#5fb3b3,bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#5fb3b3,bold'

## Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#c96a6a'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#c8d4dc'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#c8d4dc'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#c8d4dc'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#c96a6a'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#c96a6a'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#c96a6a'

## Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#7ab87a'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#7ab87a'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#7ab87a'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#c96a6a'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#7ab87a'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#c96a6a'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#7ab87a'

## Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#c8d4dc'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#c96a6a'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#c8d4dc'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#c8d4dc'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#c8d4dc'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#c8d4dc'

## No category relevant in spec
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#c96a6a'
ZSH_HIGHLIGHT_STYLES[path]='fg=#c8d4dc,bold'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#c96a6a'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#c8d4dc'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#c96a6a'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#c8d4dc'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#8a7ab8'
#ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
#ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#c96a6a'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#95a1aa'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#c8d4dc'
ZSH_HIGHLIGHT_STYLES[default]='fg=#c8d4dc'
ZSH_HIGHLIGHT_STYLES[cursor]='standout'