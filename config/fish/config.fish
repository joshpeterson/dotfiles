set -x JEROME_DATABASE_PASSWORD mydata
set -x VCPKG_FORCE_SYSTEM_BINARIES 1
set -x EDITOR nvim
set -x PATH $PATH ~/bin ~/.cargo/bin /opt/nvim-linux64/bin
set -x AWS_PROFILE identity-dev-devaccess-8c21111
set -x MODULAR_PATH ~/code/modular
set -x RIPGREP_CONFIG_PATH ~/.config/rg.config

set -g theme_newline_cursor yes

# Remove exa for now as it is difficult to install in codespaces
# alias ls "exa --icons"
alias tx tmuxinator
alias vim nvim

# NNN
export NNN_PLUG='p:preview-tui;o:fzopen;f:fzcd'
export NNN_FCOLORS='0000E6310000000000000000'
export NNN_OPTS='H'
alias nnn "nnn -de"
set --export NNN_FIFO "/tmp/nnn.fifo"

#FZF
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --exclude external'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Bazel at Modular
alias b="$MODULAR_PATH/bazelw"
alias bq="$MODULAR_PATH/bazelw query ... | grep"
alias bb="$MODULAR_PATH/bazelw build"
alias ibb="ibazel -bazel_path $MODULAR_PATH/bazelw build"
alias bt="$MODULAR_PATH/bazelw test --test_summary=terse"
alias ibt="ibazel -bazel_path $MODULAR_PATH/bazelw test --test_summary=terse"

# source ~/start-modular.fish

### Useful for previwing modular docs
#source /opt/homebrew/Cellar/chruby-fish/1.0.0/share/fish/vendor_functions.d/chruby.fish
#source /opt/homebrew/Cellar/chruby-fish/1.0.0/share/fish/vendor_conf.d/chruby_auto.fish
#chruby ruby-3.1.3
