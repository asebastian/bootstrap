#!/bin/bash -xe


# TODO: All commands need to use the user who executed the script with sudo's
# home directory, not root.
if [ "$EUID" -ne 0 ]
  then echo "This script needs to be run with sudo or as root, exiting"
  exit
fi

echo "==> Installing basic tools"
snap install ripgrep --classic

echo "==> Installing zsh"
apt-get install -q -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "==> Configuring zsh"
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/.zshrc -O ~/.zshrc

echo "==> Installing go"
export LATEST_GO_VERSION=$(curl 'https://golang.org/VERSION?m=text')
export GO_ARCHIVE="$LATEST_GO_VERSION.linux-amd64.tar.gz"
export GO_ARCHIVE_URL="https://dl.google.com/go/$GO_ARCHIVE"

wget -q $GO_ARCHIVE_URL
tar xzf $GO_ARCHIVE
mv go /usr/local/

rm $GO_ARCHIVE

echo "==> Installing vim"
apt-get install vim

echo "==> Configuring vim"
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

git clone https://github.com/elixir-lang/vim-elixir.git ~/.vim/bundle/vim-elixir

mkdir -p ~/.vim/colors
wget -q https://raw.githubusercontent.com/jnurmine/Zenburn/master/colors/zenburn.vim -P ~/.vim/colors/

wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/.vimrc

echo "==> Installing vim-go dependencies, this may take awhile..."
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
vim +GoInstallBinaries +qall

chsh -s /bin/zsh
echo "==> Bootstrap complete! Log out and log back in to use zsh."
