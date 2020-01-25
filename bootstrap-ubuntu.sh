#!/bin/bash -e

# TODO: All commands need to use the user who executed the script with sudo's
# home directory, not root.
if [ "$EUID" -ne 0 ]
  then echo -e "\e[31m[!] This script needs to be run with sudo or as root, exiting"
  exit
fi

echo -e "\e[92m==> Installing basic tools available via snap"
snap install ripgrep --classic &> /dev/null
snap alias ripgrep.rg rg &> /dev/null

echo -e "\e[92m==> Installing basic tools available via apt"
apt-get update &> /dev/null
apt-get install -q -y zsh vim tmux git wget curl build-essential &> /dev/null

echo -e "\e[33m==> Configuring zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &> /dev/null
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/.zshrc -O ~/.zshrc &> /dev/null

# Compose the latest go archive url for linux-amd64.
export LATEST_GO_VERSION=$(curl 'https://golang.org/VERSION?m=text')
export GO_ARCHIVE="$LATEST_GO_VERSION.linux-amd64.tar.gz"
export GO_ARCHIVE_URL="https://dl.google.com/go/$GO_ARCHIVE"

echo -e "\e[92m==> Latest version of go is $LATEST_GO_VERSION, downloading from $GO_ARCHIVE_URL..."
wget -q $GO_ARCHIVE_URL &> /dev/null

echo -e "\e[92m==> Installing $LATEST_GO_VERSION to /usr/local/go"
tar xzf $GO_ARCHIVE &> /dev/null
mv go /usr/local/ &> /dev/null

echo -e "\e[94m==> Go toolchain install was successful, removing temporary artifacts"
rm -rf $GO_ARCHIVE &> /dev/null

echo -e "\e[33m==> Configuring vim"
mkdir -p ~/.vim/autoload ~/.vim/bundle &> /dev/null

echo -e "\e[33m==> Vim: configuring pathogen"
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim &> /dev/null

echo -e "\e[33m==> Vim: installing vim-elixir, vim-airline, vim-airline-themes, ansible-vim, vim-gitgutter, vim-workspace and terminus"
git clone https://github.com/elixir-lang/vim-elixir.git ~/.vim/bundle/vim-elixir &> /dev/null
git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline &> /dev/null
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes &> /dev/null
git clone https://github.com/pearofducks/ansible-vim ~/.vim/bundle/ansible-vim &> /dev/null
git clone https://github.com/airblade/vim-gitgutter.git ~/.vim/bundle/vim-gitgutter &> /dev/null
git clone https://github.com/thaerkh/vim-workspace ~/.vim/bundle/vim-workspace &> /dev/null
git clone https://github.com/wincent/terminus.git ~/.vim/bundle/terminus &> /dev/null

echo -e "\e[33m==> Vim: performing final configuration operations prior to vim-go dependency installation"
mkdir -p ~/.vim/colors
wget -q https://raw.githubusercontent.com/jnurmine/Zenburn/master/colors/zenburn.vim -P ~/.vim/colors/ &> /dev/null
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/.vimrc &> /dev/null

echo -e "\e[33m==> Vim: Installing vim-go dependencies, this may take awhile..."
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go &> /dev/null
vim -c 'GoInstallBinaries' -c 'qa!'


echo -e "\e[33m==> Configuring git"
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/git/.gitconfig &> /dev/null
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/git/.githelpers &> /dev/null
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/git/.gitignore &> /dev/null

echo -e "\e[33m==> Configuring tmux"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &> /dev/null
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/.tmux.conf &> /dev/null

echo -e "\e[92m==> Installing fzf from source..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &> /dev/null
~/.fzf/install --key-bindings --completion --update-rc --no-bash --no-fish &> /dev/null

echo -e "\e[33m==> Setting the default shell to zsh for $(whoami)"
chsh -s /bin/zsh &> /dev/null

echo -e "\e[96m==> One last thing to do for tmux (optional)! Enter tmux then hit Ctrl-b (leader) + I to automatically configure the plugins"
echo -e "\e[92m==> Bootstrap complete! Log out and log back in to use zsh."
echo -e "\e[39m"
