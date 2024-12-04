#!/bin/bash

# Exit on error, unset variable, or pipeline failure
set -euo pipefail

# Function for error messages
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Function to install essential tools
install_essentials() {
    echo "Installing essential tools..."
    sudo apt update || error_exit "Failed to update package list."
    sudo apt install -y build-essential git python3 python3-pip curl || error_exit "Failed to install essential tools."
    pip3 install --user virtualenv || error_exit "Failed to install virtualenv."
}

# Function to set up Rust
setup_rust() {
    echo "Setting up Rust..."
    if [[ -f ./rustup.exp ]]; then
        chmod +x ./rustup.exp
        ./rustup.exp || error_exit "Rust installation failed."
        source "$HOME/.cargo/env"
    else
        echo "rustup.exp file not found. Skipping Rust setup."
    fi
}

# Function to set up Ruby and Rails
setup_ruby_rails() {
    echo "Setting up Ruby and Rails..."
    sudo apt install -y ruby-full || error_exit "Failed to install Ruby."
    gem install rails || error_exit "Failed to install Rails."
}

# Function to set up Neovim
setup_neovim() {
    echo "Setting up Neovim..."
    sudo add-apt-repository ppa:neovim-ppa/unstable -y || error_exit "Failed to add Neovim PPA."
    sudo apt update
    sudo apt install -y neovim || error_exit "Failed to install Neovim."
    pip3 install --user neovim || error_exit "Failed to install Neovim Python support."

    echo "Configuring Neovim..."
    mkdir -p ~/.config/nvim
    cat > ~/.config/nvim/init.lua << 'EOF'
-- Load Packer.nvim
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd([[packadd packer.nvim]])
    end
end

ensure_packer()

-- Plugin setup
require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Packer can manage itself
    use 'neovim/nvim-lspconfig'  -- Language server configurations
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lualine/lualine.nvim' -- Status line
end)

-- Basic Neovim settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.cmd('colorscheme default')
EOF

    echo "Installing Neovim plugins..."
    nvim --headless +PackerSync +qall || error_exit "Failed to install Neovim plugins."
}

# Function to set up Alacritty
setup_alacritty() {
    echo "Setting up Alacritty..."
    sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev || error_exit "Failed to install Alacritty dependencies."
    git clone https://github.com/alacritty/alacritty.git || error_exit "Failed to clone Alacritty repository."
    pushd alacritty || error_exit "Failed to enter Alacritty directory."
    cargo build --release || error_exit "Failed to build Alacritty."
    sudo cp target/release/alacritty /usr/local/bin || error_exit "Failed to copy Alacritty binary."
    popd
    rm -rf alacritty || echo "Warning: Failed to clean up Alacritty repository."
}

# Function to set up Python virtual environment for ML
setup_ml_env() {
    echo "Setting up Python ML virtual environment..."
    virtualenv venv_ml || error_exit "Failed to create ML virtual environment."
    source venv_ml/bin/activate
    pip install numpy scipy scikit-learn tensorflow || error_exit "Failed to install ML tools."
    deactivate
}

# Function to set up custom bash aliases and functions
setup_bashrc() {
    echo "Setting up .bashrc..."
    cat >> ~/.bashrc << 'EOF'
# Custom bash functions
F() {
  grep "$1" -iR "$(git ls-files)"
}

FS() {
  grep "$1" -R "$(git ls-files)"
}

P() {
  list=$(git ls-files | grep "$1" -i)
  a=("${(f)list}")

  select item in $a; do
    echo "Opening file: $item"
    nvim $item
    break
  done
}
EOF
    source ~/.bashrc
}

# Main script execution
main() {
    install_essentials
    setup_rust
    setup_ruby_rails
    setup_neovim
    setup_alacritty
    setup_ml_env
    setup_bashrc
    echo "Development environment setup complete!"
}

main
