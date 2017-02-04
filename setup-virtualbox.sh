#!/bin/sh

# Only for VirtualBox 5.1
# Add source
if [ ! -e /etc/apt/sources.list.d/virtualbox.list ]; then
    echo "Adding virtualbox.list..."
    sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" >> /etc/apt/sources.list.d/virtualbox.list'
    echo "Adding the require key..."
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
fi
# Update deps
sudo apt-get update
# Install VirtualBox 5.1
sudo apt-get install -y virtualbox-5.1

echo "---------------------------------"
echo "If you see vboxdrv probe errors, please sign the key as mentioned in\nhttp://askubuntu.com/questions/760671/could-not-load-vboxdrv-after-upgrade-to-ubuntu-16-04-and-i-want-to-keep-secu"
echo "---------------------------------"

# Setup VirtualBox 5.0
# sudo apt-get install -y virtualbox
# sudo apt-get install -y virtualbox-dkms
