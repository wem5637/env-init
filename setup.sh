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

# Install expect
sudo apt install -y expect

chmod +x ./rustup.exp
./rustup.exp

source "$HOME/.cargo/env"

# Install Ruby on Rails
sudo apt install -y ruby-full
gem install rails

# Install nvm
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash


# Install Neovim
# Add the Neovim repository and update the package list
DEBIAN_FRONTEND=noninteractive yes | sudo add-apt-repository ppa:neovim-ppa/unstable
DEBIAN_FRONTEND=noninteractive yes | sudo apt update

# Install Neovim
sudo apt install -y neovim

# Install Neovim dependencies
sudo apt install -y python3 python3-pip

# Install Python support for Neovim
pip3 install -y neovim

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
# Set up an ml virtual environment
virtualenv venv_ml
source venv_ml/bin/activate

# Install machine learning tools
pip install numpy scipy scikit-learn tensorflow

# Deactivate the virtual environment
deactivate

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
' >> ~/.bashrc

# Load the updated .bashrc
source ~/.bashrc

# Install NeoVim plugins using Packer.nvim
git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Create a basic init.vim configuration for NeoVim
mkdir -p ~/.config/nvim
echo '
lua << EOF

autocmd VimEnter * wincmd p
autocmd BufWritePre *.tsx,*.ts Prettier

"nerdtree
autocmd VimEnter * NERDTree
let NERDTreeShowHidden=1
nnoremap <leader>n :NERDTreeFocus<CR>

let mapleader = ","
let g:neoformat_try_node_exe = 1
let g:airline#extensions#clock#format = '%l:%M%p'
let g:rooter_patterns = ['.git', 'package.json']
set number
set expandtab
set shiftwidth=2
set autoindent
set smartindent
inoremap jk <esc>
vnoremap <esc> <nop>
inoremap <F1> <nop>
noremap <f1> <nop>
inoremap <esc> <nop>
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
nnoremap J jjj
nnoremap K kkk
nnoremap H hhhhhh
nnoremap L llllll
nnoremap <c-j> ddjP
nnoremap <c-k> ddkP
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>cwp :let @+ = expand("%:p")
"""""""""""""""""""""""""""""""""""""""""""""""""
" Color Settings
"""""""""""""""""""""""""""""""""""""""""""""""""
syntax on


-- Use Packer.nvim for plugin management
vim.cmd([[packadd packer.nvim]])

require("packer").startup(function()

  use ("preservim/nerdtree")
  use ("prettier/vim-prettier")
  use ("ibhagwan/fzf-lua")
  use ("vim-airline/vim-airline")
  use ("vim-airline/vim-airline-themes")
  use ("enricobacis/vim-airline-clock")
  use ("mg979/vim-visual-multi")
  use ("tanvirtin/monokai.nvim")

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
  -- if fails, then run nvim-treesitter.install.update() manually


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