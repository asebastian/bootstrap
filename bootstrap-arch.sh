#!/bin/bash -xe

# TODO: All commands need to use the user who executed the script with sudo's
# home directory, not root.
if [ "$EUID" -ne 0 ]
  then echo "This script needs to be run with sudo or as root, exiting"
  exit
fi

echo "==> Installing basic tools"
pacman --noconfirm -S ripgrep zsh vim tmux curl wget git

echo "==> Configuring zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/.zshrc -O ~/.zshrc

echo "==> Installing go"
export LATEST_GO_VERSION=$(curl 'https://golang.org/VERSION?m=text')
export GO_ARCHIVE="$LATEST_GO_VERSION.linux-amd64.tar.gz"
export GO_ARCHIVE_URL="https://dl.google.com/go/$GO_ARCHIVE"

wget -q $GO_ARCHIVE_URL
tar xzf $GO_ARCHIVE
mv go /usr/local/

rm $GO_ARCHIVE

echo "==> Configuring vim"
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

git clone https://github.com/elixir-lang/vim-elixir.git ~/.vim/bundle/vim-elixir
git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes
git clone https://github.com/pearofducks/ansible-vim ~/.vim/bundle/ansible-vim
git clone https://github.com/airblade/vim-gitgutter.git ~/.vim/bundle/vim-gitgutter
git clone https://github.com/thaerkh/vim-workspace ~/.vim/bundle/vim-workspace
git clone https://github.com/wincent/terminus.git ~/.vim/bundle/terminus

echo "==> Configuring git"
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/git/.gitconfig
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/git/.githelpers
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/git/.gitignore
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/.vimrc

mkdir -p ~/.vim/colors
wget -q https://raw.githubusercontent.com/jnurmine/Zenburn/master/colors/zenburn.vim -P ~/.vim/colors/

echo "==> Configuring tmux"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/.tmux.conf
echo "==> !!! Manual Action Required!!! Enter tmux then hit Ctrl-b (leader) + I to automatically configure the plugins"

echo "==> Installing vim-go dependencies, this may take awhile..."
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
vim -c 'GoInstallBinaries' -c 'qa!'

echo "==> Installing fzf from source..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

chsh -s /bin/zsh
echo "==> Bootstrap complete! Log out and log back in to use zsh."
