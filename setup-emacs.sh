#!/bin/sh

# Pick script location
SETUP_DIR=$(pwd)

# Create installers placeholder
mkdir -p $SETUP_DIR/installers
# Utilities
echo "Setting up utilities..."
sudo apt-get install -y build-essential
#sudo apt-get install -y autoconf
#sudo apt-get install -y texinfo
#sudo apt-get install -y xaw3dg-dev
#sudo apt-get install -y libncurses5-dev
#sudo apt-get install -y libncurses-dev
#sudo apt-get install -y libtool
#sudo apt-get install -y libssl-dev
#sudo apt-get install -y libjpeg-dev
#sudo apt-get install -y libpng16-dev
#sudo apt-get install -y libotf-dev
#sudo apt-get install -y libm17n-dev
#sudo apt-get install -y libgif-dev
#sudo apt-get install -y libgpm-dev
#sudo apt-get install -y libghc-gconf-dev
#sudo apt-get install -y libtiff-dev
#sudo apt-get install -y librsvg2-dev
#sudo apt-get install -y libmagickcore-dev
#sudo apt-get install -y libmagick++-dev
#sudo apt-get install -y libgtk2.0-dev
#sudo apt-get install -y libgtk-3-dev
#sudo apt-get install -y libwebkitgtk-3.0-dev
#sudo apt-get install -y libx11-dev
#sudo apt-get install -y libxft-dev
#sudo apt-get install -y libgnutls-dev
#sudo apt-get install -y libxpm-dev
#sudo apt-get install -y libxml2-dev
#sudo apt-get install -y automake
sudo apt-get install -y checkinstall
sudo apt-get build-dep emacs24

if [ ! -e $SETUP_DIR/installers/emacs-25.1.tar.gz ]; then
    echo "Downloading Emacs 25.1..."
    wget http://ftp.gnu.org/gnu/emacs/emacs-25.1.tar.gz -P $SETUP_DIR/installers
fi

if [ ! -e $SETUP_DIR/emacs-25.1 ]; then
    echo "Extracting emacs-25.1.tar.gz..."
    cd $SETUP_DIR/installers
    tar -xvf emacs-25.1.tar.gz
    mv emacs-25.1 ../
    cd ../emacs-25.1
    ./configure
    make
    sudo checkinstall
    echo "Successfully built .deb file and installed Emacs-25.1"
fi

if [ ! -e ~/.emacs.d ]; then
    cd
    echo "Pulling emacs.d..."
    git clone https://github.com/anujsrc/emacs.d ~/.emacs.d
fi

echo "Enjoy!"
