set -x EDITOR nvim

alias bat batcat

# NNN
export NNN_PLUG='p:preview-tui;o:fzopen;f:finder'
export NNN_FCOLORS='0000E6310000000000000000'
alias nnn "nnn -e"
set --export NNN_FIFO "/tmp/nnn.fifo"
