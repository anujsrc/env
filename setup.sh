#!/bin/sh

# Fail on error
set -e

# Pick script location
SETUP_DIR=$(pwd)

# Create installers placeholder
mkdir -p $SETUP_DIR/installers

# Update repo and libraries
echo "Updating libraries..."
sudo apt-get update
echo "Upgrading system..."
#sudo apt-get upgrade

# Utilities
echo "Setting up utilities..."
sudo apt-get install -y gconf2
sudo apt-get install -y dconf-cli
sudo apt-get install -y gnome-shell
sudo apt-get install -y gnome-terminal
sudo apt-get install -y dconf-editor
sudo apt-get install -y vim
sudo apt-get install -y curl
sudo apt-get install -y git
sudo apt-get install -y awscli
sudo apt-get install -y screen
sudo apt-get install -y gcc
sudo apt-get install -y make
sudo apt-get install -y g++
sudo apt-get install -y build-essential
sudo apt-get install -y uuid-dev
sudo apt-get install -y autoconf
sudo apt-get install -y openssl
sudo apt-get install -y fop
sudo apt-get install -y xsltproc
sudo apt-get install -y unixodbc-dev
sudo apt-get install -y gnuplot
sudo apt-get install -y rlwrap
sudo apt-get install -y tree
sudo apt-get install -y libncurses-dev
sudo apt-get install -y libtool
sudo apt-get install -y libssl-dev
sudo apt-get install -y automake
sudo apt-get install -y checkinstall
sudo apt-get install -y graphviz
sudo apt-get install -y markdown
sudo apt-get install -y font-manager
sudo apt-get install -y figlet
sudo apt-get install -y cowsay
sudo apt-get install -y htop
sudo apt-get install -y sysstat
sudo apt-get install -y yajl-tools
sudo apt-get install -y gimp
sudo apt-get install -y meld
sudo apt-get install -y ruby
sudo apt-get install -y ant
sudo apt-get install -y p7zip-full
sudo apt-get install -y unrar
sudo apt-get install -y cmake
sudo apt-get install -y ssmtp
sudo apt-get install -y alien
sudo apt-get install -y libevent-dev
sudo apt-get install -y libpng-dev
sudo apt-get install -y libcurl4-openssl-dev

echo "Setting up R..."
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo add-apt-repository "deb https://cran.cnr.berkeley.edu/bin/linux/ubuntu xenial/"
sudo apt-get update
sudo apt-get install r-base
sudo apt-get install r-base-dev

echo "Setting up nodejs..."
sudo apt-get purge nodejs npm
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 68576280
sudo apt-add-repository "deb https://deb.nodesource.com/node_7.x $(lsb_release -sc) main"
sudo apt-get update
sudo apt-get install nodejs

# Shell (zsh) and syntax highlighting
echo "Setting up oh-my-zsh..."
sudo apt-get install -y zsh
if [ ! -e ~/.oh-my-zsh ]; then
    git clone git@github.com:ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    git clone git@github.com:zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    sudo chsh -s /bin/zsh
fi

# Pull environment files
if [ ! -e $SETUP_DIR/dotfiles ]; then
    echo "Grabing dotfiles..."
    git clone https://github.com/anujsrc/dotfiles.git
fi

# Keep a backup of existing files, if any
BACKUP_TS=$(date +"%m-%d-%Y_%T")
backup_dotfiles() {
    mkdir -p ~/dotfbkp_$BACKUP_TS
    while [ $# -ne 0 ]; do
        mv ~/$1 ~/dotfbkp_$BACKUP_TS
        cp $SETUP_DIR/dotfiles/$1 ~/$1
        shift
    done
}

# Backup and setup environment files
echo "Setting up dotfiles..."
backup_dotfiles .vimrc .zshrc .screenrc .ctags .minttyrc .tmux.conf

# Setup envrc, iff it does not exist
if [ ! -e ~/.envrc ]; then
    echo "Setting up envrc..."
    cp $SETUP_DIR/dotfiles/.envrc ~/.envrc;
fi

# solarized and dircolors setup for ubuntu
# colors from git@github.com:seebi/dircolors-solarized.git
platform=`uname`
if [ $platform = 'Linux' ] && [ ! -e $SETUP_DIR/gnome-terminal-colors-solarized ]; then
  echo "Preparing solarized theme for terminal..."
  git clone git@github.com:aruhier/gnome-terminal-colors-solarized.git
  cd gnome-terminal-colors-solarized
  ./set_dark.sh
  cd ..
  cp $SETUP_DIR/dotfiles/external/dircolors.256dark ~/.dir_colors
fi

# fonts
echo "Setting up fonts..."
mkdir -p ~/.fonts
cp $SETUP_DIR/dotfiles/external/Hermit*.otf ~/.fonts
cp $SETUP_DIR/dotfiles/external/Inconsolata*.otf ~/.fonts
sudo fc-cache -vf ~/.fonts

# liquid prompt
if [ ! -e ~/bin/liquidprompt ]; then
    echo "Setting up liquidprompt..."
    mkdir -p ~/bin
    wget https://raw.github.com/nojhan/liquidprompt/master/liquidprompt -P ~/bin
fi

# Setup vim plug-ins
echo "Setting up vim plugins..."
mkdir -p ~/.vim/pathogen ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# vundle setup
if [ ! -e ~/.vim/bundle/vundle ]; then
    git clone git@github.com:VundleVim/Vundle.vim.git ~/.vim/bundle/vundle
fi

# vim pathogen plugins
if [ ! -e ~/.vim/pathogen/vim-colors-solarized ]; then
    git clone git@github.com:altercation/vim-colors-solarized.git ~/.vim/pathogen/vim-colors-solarized
fi

if [ ! -e ~/.vim/pathogen/nerdtree ]; then
    git clone git@github.com:preservim/nerdtree.git ~/.vim/pathogen/nerdtree
fi

echo "Installing vim plugins..."
vim +BundleInstall +qall

echo "Installing emacs 25.1"
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt-get update
sudo apt-get install emacs25

if [ ! -e ~/.emacs.d ]; then
    cd
    echo "Pulling emacs.d..."
    git clone https://github.com/anujsrc/emacs.d ~/.emacs.d
fi

echo "Enjoy!"
