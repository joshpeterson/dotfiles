#!/usr/bin/env bash
#
# bootstrap-ubuntu.sh — install my standard toolset on a fresh Ubuntu machine.
#
# Tools: git, neovim (latest stable from GitHub), ripgrep, bat, fd, fzf, fish,
# ruby, lazygit, oh-my-pi (omp), opencode, Oh My Fish + bobthefish theme,
# and my dotfiles (github.com/joshpeterson/dotfiles, linked with dotbot).
#
# Safe to re-run: system packages are upgraded in place, user-local tools
# are skipped or updated, existing dotfiles are pulled. Also sets fish as
# the login shell. System packages use sudo; everything else lands in
# ~/.local/bin, ~/.local/share, or ~/.opencode.

set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    echo "Run as a normal user, not root (sudo is used only for apt)." >&2
    exit 1
fi

LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"
ORIG_PATH="$PATH" # captured before the export below, for the PATH check at the end
export PATH="$LOCAL_BIN:$PATH"
export DEBIAN_FRONTEND=noninteractive

have() { command -v "$1" >/dev/null 2>&1; }

echo "==> Installing system packages (needs sudo)"
sudo apt-get update -qq
sudo apt-get install -y -qq git ripgrep bat fd-find fzf fish ruby-full curl vim

# Ubuntu ships bat as batcat and fd-find as fdfind; link the canonical names
# when the Ubuntu-specific binaries exist.
command -v batcat >/dev/null && ln -sf "$(command -v batcat)" "$LOCAL_BIN/bat"
command -v fdfind >/dev/null && ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"

echo "==> Setting fish as the default shell"
login_shell=$(getent passwd "$USER" | cut -d: -f7)
if [[ $login_shell == "$(command -v fish)" ]]; then
    echo "    fish is already the login shell, skipping"
else
    sudo chsh -s "$(command -v fish)" "$USER"
fi

echo "==> Installing dotfiles (github.com/joshpeterson/dotfiles)"
if [[ -d ~/.dotfiles/.git ]]; then
    git -C ~/.dotfiles pull --ff-only -q \
        || echo "    warning: could not update dotfiles, continuing with current copy"
else
    git clone -q https://github.com/joshpeterson/dotfiles.git ~/.dotfiles
fi

# Fold any pre-existing real ~/.config entries into the repo tree so dotbot
# can replace the directory with a symlink. Entries whose names already exist
# in the repo are regenerated machine state and are removed.
if [[ -d ~/.config && ! -L ~/.config ]]; then
    shopt -s dotglob nullglob
    for entry in ~/.config/*; do
        name=$(basename "$entry")
        if [[ -e ~/.dotfiles/config/$name ]]; then
            echo "    removing machine-generated ~/.config/$name (tracked in dotfiles)"
            rm -rf "$entry"
        else
            mv "$entry" ~/.dotfiles/config/
        fi
    done
    rmdir ~/.config
fi
(cd ~/.dotfiles && ./install) \
    || echo "    note: install script reported an error (usually the vim PlugInstall step); links were still applied"

echo "==> Installing Oh My Fish + bobthefish theme"
if [[ ! -d ~/.local/share/omf ]]; then
    git clone -q https://github.com/oh-my-fish/oh-my-fish.git ~/.local/share/omf
    fish ~/.local/share/omf/bin/install --yes --noninteractive
fi
fish -c 'omf install bobthefish' >/dev/null \
    || echo "    warning: could not install bobthefish theme; run: fish -c 'omf install bobthefish'"

echo "==> Installing neovim (latest stable from GitHub)"
latest=$(curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest \
    | grep -oP '"tag_name":\s*"\K[^"]+') # e.g. v0.12.6
if have nvim && [[ $(nvim --version | head -1) == "NVIM v${latest#v}" ]]; then
    echo "    NVIM v${latest#v} already installed, skipping"
else
    arch=$(dpkg --print-architecture) # amd64 | arm64
    nv_arch=$([[ $arch == amd64 ]] && echo x86_64 || echo arm64)
    curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${nv_arch}.tar.gz" \
        | tar -xzf - -C "$HOME/.local" --strip-components=1
fi

echo "==> Installing lazygit (latest from GitHub)"
if have lazygit; then
    echo "    $(lazygit --version | grep -o 'version=[0-9.]*' | head -1) already installed, skipping"
else
    arch=$(dpkg --print-architecture) # amd64 | arm64
    lg_arch=$([[ $arch == amd64 ]] && echo x86_64 || echo arm64)
    version=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
        | grep -oP '"tag_name":\s*"v\K[^"]+')
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/lazygit.tar.gz" \
        "https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_${lg_arch}.tar.gz"
    tar -xzf "$tmp/lazygit.tar.gz" -C "$tmp" lazygit
    install -m 0755 "$tmp/lazygit" "$LOCAL_BIN/lazygit"
    rm -rf "$tmp"
fi

echo "==> Installing oh-my-pi (omp)"
curl -fsSL https://omp.sh/install | sh

echo "==> Installing opencode"
curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path
export PATH="$HOME/.opencode/bin:$PATH"

echo
echo "==> All done. Installed versions:"
git --version
nvim --version | head -1
rg --version | head -1
bat --version
fd --version
fzf --version
fish --version
ruby --version | head -1
lazygit --version | grep -o 'version=[0-9.]*' | head -1
omp --version
opencode --version

case ":$ORIG_PATH:" in
    *":$LOCAL_BIN:"*) ;;
    *)
        echo
        echo "NOTE: $LOCAL_BIN is not in your PATH."
        echo "  fish: fish_add_path ~/.local/bin"
        echo "  bash: echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
        ;;
esac

echo
echo "Next steps:"
echo "  opencode auth login    # authenticate opencode on first use"
