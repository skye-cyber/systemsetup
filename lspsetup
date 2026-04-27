#!/bin/bash
# ============================================================
# KUBUNTU LANGUAGE SERVER INSTALLER
# Installs all major language servers for LSP-compatible editors
# (Kate, Neovim, VS Code, Helix, Emacs, Sublime Text, etc.)
# ============================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================${NC}"
}

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warn()  { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info()  { echo -e "${BLUE}ℹ${NC} $1"; }

# Check if we should use --break-system-packages
PIP_FLAGS=""
if python3 -c "import sys; print(sys.version_info >= (3, 11))" 2>/dev/null | grep -q "True"; then
    PIP_FLAGS="--break-system-packages"
fi

# Check for Node.js
NODE_VERSION=$(node --version 2>/dev/null | cut -d'v' -f2 | cut -d'.' -f1) || NODE_VERSION=""
if [[ -z "$NODE_VERSION" ]] || [[ "$NODE_VERSION" -lt 18 ]]; then
    print_header "Installing Node.js 20 LTS"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
    print_success "Node.js $(node --version) installed"
fi

# Check for npm
if ! command -v npm &> /dev/null; then
    print_error "npm not found. Installing..."
    sudo apt-get install -y npm
fi

print_header "Kubuntu Language Server Installer"
echo ""

# ============================================================
# PYTHON SERVERS
# ============================================================
print_header "Python Language Servers"

# python-lsp-server with all extras
print_info "Installing python-lsp-server (with ruff, flake8, pycodestyle, pydocstyle, pyflakes)..."
pip3 install python-lsp-server[all] $PIP_FLAGS || {
    print_warn "Failed with [all] extras, trying basic install..."
    pip3 install python-lsp-server $PIP_FLAGS
}
print_success "python-lsp-server installed"

# Ruff (fast Python linter/formatter)
print_info "Installing ruff (Rust-based Python linter)..."
pip3 install ruff $PIP_FLAGS
print_success "ruff installed"

# Black formatter
print_info "Installing black (Python formatter)..."
pip3 install black $PIP_FLAGS
print_success "black installed"

# isort
print_info "Installing isort (import sorter)..."
pip3 install isort $PIP_FLAGS
print_success "isort installed"

# mypy
print_info "Installing mypy (static type checker)..."
pip3 install mypy $PIP_FLAGS
print_success "mypy installed"

# flake8, pycodestyle, pydocstyle, pyflakes)
print_info "Installing mypy (static type checker)..."
pip3 install flake8 pycodestyle pydocstyle pyflakes $PIP_FLAGS
print_success "(flake8, pycodestyle, pydocstyle, pyflakes) installed"

# Pyright (Microsoft's type checker)
print_info "Installing pyright (Microsoft type checker)..."
sudo npm install -g pyright
print_success "pyright installed"

echo ""

# ============================================================
# NODE.JS / WEB SERVERS
# ============================================================
print_header "JavaScript/TypeScript/HTML/CSS/JSON Language Servers"

# TypeScript/JavaScript
print_info "Installing typescript-language-server..."
sudo npm install -g typescript-language-server typescript
print_success "typescript-language-server installed"

# HTML
print_info "Installing vscode-html-languageserver-bin..."
sudo npm install -g vscode-html-languageserver-bin
print_success "HTML language server installed"

# CSS/LESS/SCSS
print_info "Installing vscode-css-languageserver-bin..."
sudo npm install -g vscode-css-languageserver-bin
print_success "CSS language server installed"

# JSON
print_info "Installing vscode-json-languageserver-bin..."
sudo npm install -g vscode-json-languageserver-bin
print_success "JSON language server installed"

# YAML
print_info "Installing yaml-language-server..."
sudo npm install -g yaml-language-server
print_success "YAML language server installed"

# ESLint
print_info "Installing vscode-eslint-language-server..."
sudo npm install -g vscode-langservers-extracted
print_success "ESLint language server installed"

# Vue
print_info "Installing volar (Vue language server)..."
sudo npm install -g @volar/vue-language-server
print_success "Vue language server installed"

# Tailwind CSS
print_info "Installing tailwindcss-language-server..."
sudo npm install -g @tailwindcss/language-server
print_success "Tailwind CSS language server installed"

echo ""

# ============================================================
# SHELL SERVERS
# ============================================================
print_header "Shell Language Servers"

# Bash
print_info "Installing bash-language-server..."
sudo npm install -g bash-language-server
print_success "bash-language-server installed"

# Install shellcheck for bash-language-server
if ! command -v shellcheck &> /dev/null; then
    print_info "Installing shellcheck (required by bash-language-server)..."
    sudo apt-get install -y shellcheck
    print_success "shellcheck installed"
fi

# Install shfmt for formatting
if ! command -v shfmt &> /dev/null; then
    print_info "Installing shfmt (shell formatter)..."
    if command -v go &> /dev/null; then
        go install mvdan.cc/sh/v3/cmd/shfmt@latest
    else
        print_warn "Go not found. Install go to get shfmt, or: snap install shfmt"
    fi
fi

echo ""

# ============================================================
# SYSTEM/COMPILED LANGUAGES
# ============================================================
print_header "C/C++/Go/Rust Language Servers"

# C/C++ - clangd
print_info "Installing clangd (C/C++ language server)..."
sudo apt-get install -y clangd || {
    print_warn "clangd not in default repos, trying clang-tools..."
    sudo apt-get install -y clang-tools
}
print_success "clangd installed"

# Go - gopls
print_info "Installing gopls (Go language server)..."
if command -v go &> /dev/null; then
    go install golang.org/x/tools/gopls@latest
    print_success "gopls installed"
else
    print_warn "Go not found. Install Go first, then: go install golang.org/x/tools/gopls@latest"
fi

# Rust - rust-analyzer
print_info "Installing rust-analyzer (Rust language server)..."
if command -v rustup &> /dev/null; then
    rustup component add rust-analyzer
    print_success "rust-analyzer installed via rustup"
else
    print_warn "Rustup not found. Install Rust via rustup first."
    print_info "Then run: rustup component add rust-analyzer"
fi

echo ""

# ============================================================
# OTHER LANGUAGES
# ============================================================
print_header "Other Language Servers"

# Lua
print_info "Installing lua-language-server..."
if ! command -v lua-language-server &> /dev/null; then
    # Try to install via snap first
    if command -v snap &> /dev/null; then
        sudo snap install lua-language-server || true
    fi
    # Fallback: manual install
    if ! command -v lua-language-server &> /dev/null; then
        print_info "Downloading lua-language-server manually..."
        LLS_VERSION=$(curl -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        if [[ -n "$LLS_VERSION" ]]; then
            curl -L "https://github.com/LuaLS/lua-language-server/releases/download/${LLS_VERSION}/lua-language-server-${LLS_VERSION}-linux-x64.tar.gz" -o /tmp/lls.tar.gz
            sudo mkdir -p /opt/lua-language-server
            sudo tar -xzf /tmp/lls.tar.gz -C /opt/lua-language-server
            sudo ln -sf /opt/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server
            rm /tmp/lls.tar.gz
            print_success "lua-language-server installed"
        else
            print_warn "Could not determine latest lua-language-server version"
        fi
    fi
else
    print_success "lua-language-server already installed"
fi

# Dockerfile
print_info "Installing dockerfile-language-server..."
sudo npm install -g dockerfile-language-server-nodejs
print_success "Dockerfile language server installed"

# Docker (official)
print_info "Installing docker-language-server (official Docker)..."
if command -v go &> /dev/null; then
    go install github.com/docker/docker-language-server/cmd/docker-language-server@latest || {
        print_warn "docker-language-server failed, dockerfile-language-server-nodejs is available as fallback"
    }
else
    print_warn "Go not found. Skipping docker-language-server (install Go to get it)"
fi

# Markdown
print_info "Installing markdown-oxide (Markdown language server)..."
if command -v cargo &> /dev/null; then
    cargo install --locked markdown-oxide || {
        print_warn "markdown-oxide failed, trying unified-language-server..."
        sudo npm install -g unified-language-server
    }
else
    sudo npm install -g unified-language-server
    print_success "unified-language-server (Markdown) installed"
fi

# SQL
print_info "Installing sql-language-server..."
sudo npm install -g sql-language-server
print_success "SQL language server installed"

# XML
# print_info "Installing lemminx (XML language server)..."
# if ! command -v lemminx &> /dev/null; then
#     LEMMINX_VERSION=$(curl -s https://api.github.com/repos/eclipse/lemminx/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
#     if [[ -n "$LEMMINX_VERSION" ]]; then
#         curl -L "https://github.com/eclipse/lemminx/releases/download/${LEMMINX_VERSION}/lemminx-linux.zip" -o /tmp/lemminx.zip
#         sudo unzip -o /tmp/lemminx.zip -d /usr/local/bin/
#         sudo chmod +x /usr/local/bin/lemminx
#         rm /tmp/lemminx.zip
#         print_success "lemminx (XML) installed"
#     fi
# else
#     print_success "lemminx already installed"
# fi

# Toml
print_info "Installing taplo (TOML language server)..."
if command -v cargo &> /dev/null; then
    cargo install --locked taplo-cli || {
        print_warn "taplo install failed"
    }
else
    print_warn "Cargo not found. Install Rust to get taplo."
fi

# Haskell
print_info "Installing haskell-language-server..."
if command -v ghc &> /dev/null; then
    if command -v ghcup &> /dev/null; then
        ghcup install hls
        print_success "haskell-language-server installed"
    else
        print_warn "ghcup not found. Install ghcup first."
    fi
else
    print_warn "GHC not found. Install Haskell toolchain first."
fi

# Zig
print_info "Installing zls (Zig language server)..."
if command -v zig &> /dev/null; then
    if ! command -v zls &> /dev/null; then
        ZLS_VERSION=$(curl -s https://api.github.com/repos/zigtools/zls/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        if [[ -n "$ZLS_VERSION" ]]; then
            curl -L "https://github.com/zigtools/zls/releases/download/${ZLS_VERSION}/zls-x86_64-linux.tar.xz" -o /tmp/zls.tar.xz
            sudo tar -xf /tmp/zls.tar.xz -C /usr/local/bin/
            sudo chmod +x /usr/local/bin/zls
            rm /tmp/zls.tar.xz
            print_success "zls (Zig) installed"
        fi
    else
        print_success "zls already installed"
    fi
else
    print_warn "Zig not found. Install Zig first to use zls."
fi

# ============================================================
# SUMMARY
# ============================================================
echo ""
print_header "Installation Summary"

echo ""
echo -e "${GREEN}Python:${NC}"
echo "  • python-lsp-server (with ruff, flake8, pycodestyle, pydocstyle, pyflakes)"
echo "  • ruff (Rust-based linter)"
echo "  • pyright (Microsoft type checker)"
echo "  • black, isort, mypy"

echo ""
echo -e "${GREEN}JavaScript/TypeScript/Web:${NC}"
echo "  • typescript-language-server"
echo "  • vscode-html-languageserver-bin"
echo "  • vscode-css-languageserver-bin"
echo "  • vscode-json-languageserver-bin"
echo "  • yaml-language-server"
echo "  • vscode-langservers-extracted (ESLint)"
echo "  • @volar/vue-language-server"
echo "  • @tailwindcss/language-server"

echo ""
echo -e "${GREEN}Shell:${NC}"
echo "  • bash-language-server"
echo "  • shellcheck (linting)"
echo "  • shfmt (formatting, if Go installed)"

echo ""
echo -e "${GREEN}Systems Languages:${NC}"
echo "  • clangd (C/C++)"
echo "  • gopls (Go, if Go installed)"
echo "  • rust-analyzer (Rust, if rustup installed)"

echo ""
echo -e "${GREEN}Other:${NC}"
echo "  • lua-language-server"
echo "  • dockerfile-language-server-nodejs"
echo "  • docker-language-server (if Go installed)"
echo "  • unified-language-server / markdown-oxide (Markdown)"
echo "  • sql-language-server"
echo "  • lemminx (XML)"
echo "  • taplo (TOML, if Rust installed)"
echo "  • haskell-language-server (if Haskell installed)"
echo "  • zls (Zig, if Zig installed)"

echo ""
print_info "Some servers require their language toolchain (Go, Rust, Haskell, Zig) to be installed first."
print_info "If any failed, install the language toolchain and re-run this script."
print_info ""
print_info "To verify installations:"
echo "  bash-language-server --version"
echo "  typescript-language-server --version"
echo "  clangd --version"
echo "  pyright --version"
echo "  ruff --version"
