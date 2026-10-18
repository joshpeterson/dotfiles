#!/usr/bin/env bash
#
# bootstrap-ubuntu.sh — install my standard toolset on a fresh Ubuntu machine.
#
# Tools: git, neovim (latest stable from GitHub), ripgrep, bat, fd, fish, ruby,
# lazygit, oh-my-pi (omp)
#
# Safe to re-run: system packages are upgraded in place, user-local tools
# are skipped if already installed. Also sets fish as the login shell.
# System packages use sudo; everything else lands in ~/.local/bin.

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
sudo apt-get install -y -qq git ripgrep bat fd-find fish ruby-full curl

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
    echo "    $(lazygit --version) already installed, skipping"
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

echo
echo "==> All done. Installed versions:"
git --version
nvim --version | head -1
rg --version | head -1
bat --version
fd --version
fish --version
ruby --version | head -1
lazygit --version
omp --version

case ":$ORIG_PATH:" in
    *":$LOCAL_BIN:"*) ;;
    *)
        echo
        echo "NOTE: $LOCAL_BIN is not in your PATH."
        echo "  fish: fish_add_path ~/.local/bin"
        echo "  bash: echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
        ;;
esac
