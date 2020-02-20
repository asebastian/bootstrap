#!/bin/bash -e

# NOTE: THIS SCRIPT IS PRIMARILY FOR PROVISIONING A USER ONCE.
# WHILE LARGELY IDEMPOTENT, RUNNING REPEATEDLY MAY CAUSE ERRORS.

while [ $# -gt 0 ] ; do
  case $1 in
    -g | --with-go) INSTALL_GO=true ;;
    -h | --help) show_help;;
  esac
  shift
done

function show_help() {
  echo "There's not much to this. If you want to install go, use --with-go or -g"
}

$(sudo -n bash -c "checking for passwordless sudo")
if [[ ${?} != "0" ]]; then
  echo "$(whoami) must have passwordless sudo to execute this script"
  exit 1
fi

export INSTALL_COLOR="92m"
export CONFIG_COLOR="33m"
export INFO_COLOR="34m"
export OPTIONAL_COLOR="96m"
export RESET_COLOR="39m"

echo -e "\e[$INSTALL_COLOR==> Installing basic tools available via snap"
sudo snap install ripgrep --classic &> /dev/null
sudo snap alias ripgrep.rg rg &> /dev/null

echo -e "\e[$INSTALL_COLOR==> Installing basic tools available via apt"
sudo apt-get update &> /dev/null
sudo apt-get install -q -y zsh vim tmux git wget curl build-essential apt-file hdparm &> /dev/null

echo -e "\e[$CONFIG_COLOR==> Populating apt-file cache"
sudo apt-get update &> /dev/null # `apt-get update` needs to be run again to popultate apt-file's cache

echo -e "\e[$INSTALL_COLOR==> Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &> /dev/null
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/.zshrc -O ~/.zshrc &> /dev/null

# Compose the latest go archive url for linux-amd64.
export LATEST_GO_VERSION=$(curl 'https://golang.org/VERSION?m=text')
export GO_ARCHIVE="$LATEST_GO_VERSION.linux-amd64.tar.gz"
export GO_ARCHIVE_URL="https://dl.google.com/go/$GO_ARCHIVE"

if [ "$INSTALL_GO" = true ]; then
  echo -e "\e[$INFO_COLOR==> Latest version of go is $LATEST_GO_VERSION, downloading from $GO_ARCHIVE_URL..."
  wget -q $GO_ARCHIVE_URL &> /dev/null

  echo -e "\e[$INSTALL_COLOR==> Installing $LATEST_GO_VERSION to /usr/local/go"
  tar xzf $GO_ARCHIVE &> /dev/null
  sudo mv go /usr/local/ &> /dev/null

  echo -e "\e[$INFO_COLOR==> Go toolchain install was successful, removing temporary artifacts"
  rm -rf $GO_ARCHIVE &> /dev/null
else
  echo -e "\e[$INFO_COLOR==> Skipping installation of go since --with-go is not present"
fi


echo -e "\e[$CONFIG_COLOR==> Creating user-local vim directories"
mkdir -p ~/.vim/autoload ~/.vim/bundle &> /dev/null

echo -e "\e[$CONFIG_COLOR==> Vim: configuring pathogen"
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim &> /dev/null

echo -e "\e[$INSTALL_COLOR==> Vim: installing vim-elixir, vim-airline, vim-airline-themes, ansible-vim, vim-gitgutter, vim-workspace and terminus"
git clone https://github.com/elixir-lang/vim-elixir.git ~/.vim/bundle/vim-elixir &> /dev/null
git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline &> /dev/null
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes &> /dev/null
git clone https://github.com/pearofducks/ansible-vim ~/.vim/bundle/ansible-vim &> /dev/null
git clone https://github.com/airblade/vim-gitgutter.git ~/.vim/bundle/vim-gitgutter &> /dev/null
git clone https://github.com/thaerkh/vim-workspace ~/.vim/bundle/vim-workspace &> /dev/null
git clone https://github.com/wincent/terminus.git ~/.vim/bundle/terminus &> /dev/null
git clone https://github.com/vimwiki/vimwiki.git ~/.vim/bundle/vimwiki &> /dev/null
git clone git@github.com:vim-pandoc/vim-pandoc.git ~/.vim/bundle/vim-pandoc &> /dev/null
git clone https://github.com/dhruvasagar/vim-table-mode.git ~/.vim/bundle/vim-table-mode &> /dev/null
git clone https://github.com/joe-skb7/cscope-maps.git ~/.vim/bundle/cscope-maps &> /dev/null

echo -e "\e[$CONFIG_COLOR==> Vim: performing final configuration operations prior to vim-go dependency installation"
mkdir -p ~/.vim/colors
wget -q https://raw.githubusercontent.com/jnurmine/Zenburn/master/colors/zenburn.vim -P ~/.vim/colors/ &> /dev/null
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/.vimrc &> /dev/null

if [ "$INSTALL_GO" = true ]; then
  echo -e "\e[$CONFIG_COLOR==> Vim: Installing vim-go dependencies, this may take awhile..."
  export PATH=/usr/local/go/bin:$PATH
  git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go &> /dev/null
  vim -c 'GoInstallBinaries' -c 'qa!'
else
  echo -e "\e[$INFO_COLOR==> Vim: skipping vim-go installation since --with-go is not present"
fi

echo -e "\e[$CONFIG_COLOR==> Configuring git..."
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/git/.gitconfig &> /dev/null
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/git/.githelpers &> /dev/null
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/git/.gitignore &> /dev/null

echo -e "\e[$CONFIG_COLOR==> Configuring tmux..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &> /dev/null
wget -q https://raw.githubusercontent.com/asebastian/bootstrap/master/files/.tmux.conf &> /dev/null

echo -e "\e[$INSTALL_COLOR==> Installing fzf from source..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &> /dev/null
~/.fzf/install --key-bindings --completion --update-rc --no-bash --no-fish &> /dev/null

echo -e "\e[$INFO_COLOR==> Setting the default shell to zsh for $(whoami)"
sudo chsh -s /usr/bin/zsh $(whoami) &> /dev/null

echo -e "\e[$OPTIONAL_COLOR==> One last thing to do for tmux (optional)! Enter tmux then hit Ctrl-b (leader) + I to automatically configure the plugins"
echo -e "\e[$INSTALL_COLOR==> Bootstrap complete!"
echo -e "\e[$RESET_COLOR"

exec /usr/bin/zsh --login
