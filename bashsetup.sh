#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.bash_backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

for file in .bashrc .bash_profile .inputrc .dircolors; do
    [ -f "$HOME/$file" ] && cp "$HOME/$file" "$BACKUP_DIR/"
done

cp "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
cp "$SCRIPT_DIR/.bash_profile" "$HOME/.bash_profile"
cp "$SCRIPT_DIR/.inputrc" "$HOME/.inputrc"
cp "$SCRIPT_DIR/.dircolors" "$HOME/.dircolors"

echo "✅ Bash configs installed."
echo ""
echo "📦 Installing ble.sh (autosuggestions + syntax highlighting)..."
if command -v git &> /dev/null; then
    sudo apt install gawk
    if [[ ! -f ~/.local/share/blesh/ble.sh ]]; then
        temp_dir=$(mktemp -d)
        git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git "$temp_dir" 2>/dev/null
        make -C "$temp_dir" install PREFIX=~/.local 2>/dev/null
        rm -rf "$temp_dir"
        echo "✅ ble.sh installed."
    fi
else
    echo "⚠️  git not found. Install git, then run:"
    echo "   git clone --recursive --depth 1 https://github.com/akinomyoga/ble.sh.git"
    echo "   make -C ble.sh install PREFIX=~/.local"
fi

echo ""
echo "🔄 Restart your terminal or run: source ~/.bashrc"
