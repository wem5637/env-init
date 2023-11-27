echo "THIS IS A SETUP SCRIPT"



curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

apt-get install curl git npm nvm rbenv neovim tmux

cat <<EOT >> .bashrc
alias gb="git branch"
alias gst="git status"
alias gnb="git checkout -b"

function F(){
  grep $1 -iR $(git ls-files)
}

function P(){
  list=$(git ls-files | grep $1 -i)
  a=("${(f)list}")

  select item in $a; do
    echo "Opening file: $item"
    lv $item
    break
  done
}
EOT
