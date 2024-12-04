#!/bin/bash

set -e  # Exit immediately if a command fails
set -u  # Treat unset variables as an error
set -o pipefail  # Catch errors in pipelines

# Function for error messages
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Update system
sudo apt update || error_exit "Failed to update package list."

# Install essential tools
sudo apt install -y build-essential git python3 python3-pip curl || error_exit "Failed to install essential tools."

# Install Python virtualenv
pip3 install --user virtualenv || error_exit "Failed to install virtualenv."

# Install Rust (ensure rustup.exp exists)
if [[ -f ./rustup.exp ]]; then
    chmod +x ./rustup.exp
    ./rustup.exp || error_exit "Rust installation failed."
    source "$HOME/.cargo/env"
else
    echo "rustup.exp file not found. Skipping Rust setup."
fi

# Install Ruby and Rails
sudo apt install -y ruby-full || error_exit "Failed to install Ruby."
gem install rails || error_exit "Failed to install Rails."

# Install Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable -y || error_exit "Failed to add Neovim PPA."
sudo apt update
sudo apt install -y neovim || error_exit "Failed to install Neovim."
pip3 install --user neovim || error_exit "Failed to install Neovim Python support."

# Set up Python virtual environment for ML
virtualenv venv_ml || error_exit "Failed to create ML virtual environment."
source venv_ml/bin/activate
pip install numpy scipy scikit-learn tensorflow || error_exit "Failed to install ML tools."
deactivate

# Clean up
rm -rf alacritty || echo "Alacritty cleanup failed."

echo "Setup completed successfully!"
