#!/bin/sh

# Nvidia Drivers for Ubuntu-16.04
# Credits-
# https://rajat-osgyan.blogspot.in/2016/07/bumblebee-on-ubuntu-1604-revised.html
# http://www.webupd8.org/2016/08/how-to-install-and-configure-bumblebee.html
# Bumblebee PPA issue- http://stackoverflow.com/questions/41244349/getting-following-error-after-the-commad-sudo-apt-get-update-on-ubuntu-16-04
# Primusrun vs Optirun and 60fps limit- http://askubuntu.com/questions/321182/why-is-primusrun-slower-than-optirun and http://askubuntu.com/questions/287113/primusrun-doesnt-seem-to-use-my-nvidia-card
# Graphics Card Indicator Icon Alignment- http://askubuntu.com/questions/493271/prime-indicator-enormous-in-xfce-panel

# Fail on error
set -e

echo "Cleaning up ppa..."
sudo apt-get install -y ppa-purge
sudo ppa-purge ppa:bumblebee/stable

echo "------------------------------------------------------"
echo "Installing Nvidia Drivers (Nvidia Prime and Bumblebee)"
echo "------------------------------------------------------"
echo "Adding graphics drivers ppa..."
sudo apt-add-repository ppa:graphics-drivers/ppa
# Required for latest releases, stable has Release file issues
# See- https://github.com/Bumblebee-Project/Bumblebee/issues/846
sudo apt-add-repository ppa:bumblebee/testing
sudo apt-add-repository ppa:nilarimogard/webupd8
sudo apt-get update
sudo apt-get install -y nvidia-prime nvidia-375

echo "Signing drivers... (secure boot)"
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der /lib/modules/$(uname -r)/updates/dkms/bbswitch.ko
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der /lib/modules/$(uname -r)/updates/dkms/nvidia_375_drm.ko
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der /lib/modules/$(uname -r)/updates/dkms/nvidia_375_uvm.ko
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der /lib/modules/$(uname -r)/updates/dkms/nvidia_375_modeset.ko
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der /lib/modules/$(uname -r)/updates/dkms/nvidia_375.ko

echo "Selecting Intel as default display driver..."
sudo prime-select intel

echo "Installing Bumblebee and Nvidia drivers..."
sudo apt-get install -y bumblebee bumblebee-nvidia primus nvidia-settings nvidia-375

echo "Adding i915 and bbswitch modules to /etc/modules..."
echo "i915\nbbswitch" | sudo tee -a /etc/modules

echo "Blacklist nvidia-375..."
echo "# 375\nblacklist nvidia-375\nblacklist nvidia-375-updates\nblacklist nvidia-experimental-375" | sudo tee -a /etc/modprobe.d/bumblebee.conf
echo "Replacing nvidia-current with nvidia-375 in /etc/bumblebee/bumblebee.conf..."
sudo sed -i 's/nvidia-current/nvidia-375/g' /etc/bumblebee/bumblebee.conf

echo "Make sure that BusID in /etc/bumblebee/xorg.conf.nvidia matches Nvidia graphics Bus ID"
lspci | egrep 'VGA|3D'

echo "Preparing user groups..."
sudo gpasswd -a $USER bumblebee
echo "Enabling bumblebee daemon..."
sudo systemctl enable bumblebeed

echo "Installing mesa-utils..."
sudo apt-get install -y mesa-utils
sudo apt-get install -y glmark2

echo "------------------------------------------------------"
echo "Validating Bumblebee..."
echo "------------------------------------------------------"
primusrun glxinfo | grep OpenGL
echo "Validating... bbswitch 16384 0"
lsmod | grep bbswitch
echo "Validating OFF status..."
cat /proc/acpi/bbswitch

echo "Setting LD_LIBRARY_PATH..."
echo "Please set it in your bashrc to persist"
export LD_LIBRARY_PATH=/usr/lib/nvidia-375:/usr/lib32/nvidia-375:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

echo "Setting up indicator..."
sudo apt-get install prime-indicator-plus
echo "Login/Logout to activate indicator for Intel/Nvidia"

echo "------------------------------------------------------"
echo "Your Nvidia Card is OFF by default."
echo "Once you run an application using primusrun or optirun,"
echo "while the program is running you can see that the"
echo "OFF change to ON in a separate terminal."
echo "------------------------------------------------------"
echo "Try with primusrun glxgears"
echo "For more than 60fps, use vblank_mode=0 primusrun,"
echo "else optirun should do the job"
echo "------------------------------------------------------"

# Load the Kernel Driver
nvidia-modprobe

# Test Commands
# glxgears
# glmark2
# vblank_mode=0 optirun glmark2

# Some more References
# https://linuxconfig.org/how-to-install-the-latest-nvidia-drivers-on-ubuntu-16-04-xenial-xerus
# http://askubuntu.com/questions/477553/ubuntu-14-04-cant-get-nvidia-prime-working/496873#496873
# https://bugs.launchpad.net/ubuntu/+source/coreutils/+bug/1341140
# http://column80.com/api.v2.php?a=askubuntu&q=635349
# https://rajat-osgyan.blogspot.in/2016/04/how-to-install-latest-nvidia-drivers-on.html
# https://forum.manjaro.org/t/nvidia-drivers-load-on-random-bootups-not-always/17492/3
