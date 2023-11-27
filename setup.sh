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

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Ruby on Rails
sudo apt install -y ruby-full
gem install rails

# Install npm and Node.js
sudo apt install -y npm

# Install Neovim
sudo apt install -y neovim

# Install Tmux
sudo apt install -y tmux


# Add the F, P, and FS functions to .bashrc
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

# Set up an ml virtual environment
virtualenv venv_ml
source venv_ml/bin/activate

# Install machine learning tools
pip install numpy scipy scikit-learn tensorflow

# Deactivate the virtual environment
deactivate

echo "Development environment setup complete!"