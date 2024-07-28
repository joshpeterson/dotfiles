set -x JEROME_DATABASE_PASSWORD mydata
set -x VCPKG_FORCE_SYSTEM_BINARIES 1
set -x EDITOR nvim
set -x MODULAR_HOME /Users/josh/.modular
set -x PATH ~/bin ~/.rbenv/shims ~/.cargo/bin /Users/josh/.modular/pkg/packages.modular.com_mojo/bin $PATH

set -g theme_newline_cursor yes

# Remove exa for now as it is difficult to install in codespaces
# alias ls "exa --icons"
#alias bat batcat
alias tx tmuxinator
alias vim nvim

# NNN
export NNN_PLUG='p:preview-tui;o:fzopen;f:finder'
export NNN_FCOLORS='0000E6310000000000000000'
alias nnn "nnn -e"
set --export NNN_FIFO "/tmp/nnn.fifo"

#FZF
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --exclude external'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Created by `pipx` on 2023-08-15 10:09:22
set PATH $PATH /Users/josh/.local/bin
