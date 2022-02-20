set -x JEROME_DATABASE_PASSWORD mydata
set -x VCPKG_FORCE_SYSTEM_BINARIES 1
set -x EDITOR nvim

alias ls "exa --icons"
alias bat batcat
alias tx tmuxinator

# NNN
export NNN_PLUG='p:preview-tui;o:fzopen;f:finder'
export NNN_FCOLORS='0000E6310000000000000000'
alias nnn "nnn -e"
set --export NNN_FIFO "/tmp/nnn.fifo"
