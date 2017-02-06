#!/bin/sh

# Update deps
sudo apt-get update

echo "Installing vagrant..."
sudo apt-get install -y vagrant

echo "Installing required plug-ins"
vagrant plugin install vagrant-vbguest
vagrant plugin update vagrant-vbguest
vagrant plugin install vagrant-triggers

echo "Restarting vagrant services..."
sudo service vboxdrv restart

echo "---------------------------------"
echo "Please restart VirtualBox if you are using it"
echo "Set VAGRANT_HOME if you intend to change the default location for boxes"
echo "If you see vboxdrv probe errors, please sign the key as mentioned in\nhttp://askubuntu.com/questions/760671/could-not-load-vboxdrv-after-upgrade-to-ubuntu-16-04-and-i-want-to-keep-secu"
echo "---------------------------------"
echo "Done!"
