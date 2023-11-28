#!/bin/bash

# Update package list
sudo apt update

# Install essential development tools
sudo apt install -y build-essential

# Install Git
sudo apt install -y git

# Install Python 3 and pip
sudo apt install -y python3 python3-pip

# Install virtualenv for Python virtual environments
pip3 install virtualenv

# Install curl
sudo apt install -y curl

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Ruby on Rails
sudo apt install -y ruby-full
gem install rails

# Install npm and Node.js
sudo apt install -y npm


# Install Neovim
# Add the Neovim repository and update the package list
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update

# Install Neovim
sudo apt install -y neovim=0.X.X

# Install Neovim dependencies
sudo apt install -y python3 python3-pip

# Install Python support for Neovim
pip3 install neovim


# Install Tmux
sudo apt install -y tmux

# Install Alacritty dependencies
sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

# Clone Alacritty repository
git clone https://github.com/alacritty/alacritty.git

# Build and install Alacritty
cd alacritty
cargo build --release
sudo cp target/release/alacritty /usr/local/bin

# Clean up
cd ..
rm -rf alacritty

# Install machine learning tools
pip install numpy scipy scikit-learn tensorflow

# Add the F, P, FS, and machine learning virtual environment functions to .bashrc
echo '
# Function to grep case-insensitively through Git-tracked files
F() {
  grep "$1" -iR "$(git ls-files)"
}

# Function to grep case-sensitively through Git-tracked files
FS() {
  grep "$1" -R "$(git ls-files)"
}

# Function to select and open a file from Git-tracked files matching a pattern
P() {
  list=$(git ls-files | grep "$1" -i)
  a=("${(f)list}")

  select item in $a; do
    echo "Opening file: $item"
    nvim $item # Assuming you want to use Neovim to open the file
    break
  done
}

# Set up an ml virtual environment
virtualenv venv_ml
source venv_ml/bin/activate

# Install machine learning tools
pip install numpy scipy scikit-learn tensorflow

# Deactivate the virtual environment
deactivate
' >> ~/.bashrc

# Load the updated .bashrc
source ~/.bashrc

# Install NeoVim plugins using Packer.nvim
git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Create a basic init.vim configuration for NeoVim
mkdir -p ~/.config/nvim
echo '
lua << EOF
-- Use Packer.nvim for plugin management
vim.cmd([[packadd packer.nvim]])

require("packer").startup(function()
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- startup customization
  use {
  "startup-nvim/startup.nvim",
    requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
    config = function()
      require"startup".setup()
    end
  }

  -- Telescope for fuzzy finding
  use("nvim-telescope/telescope.nvim")

  -- Tree-sitter for improved syntax highlighting
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })

  -- Language servers (LSP)
  use("neovim/nvim-lspconfig")
  use("kabouzeid/nvim-lspinstall")

  -- Additional LSP-related plugins
  use("glepnir/lspsaga.nvim")
  use("hrsh7th/nvim-compe")

  -- Status line and bufferline
  use("hoob3rt/lualine.nvim")
  use("akinsho/bufferline.nvim")
end)
EOF
' > ~/.config/nvim/init.vim

# Install plugins using Packer.nvim
nvim --headless +PackerInstall +qall

echo "Development environment setup complete!"