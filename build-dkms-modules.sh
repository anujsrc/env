#!/bin/sh

# Resign your modules if you kernels was updated and you get the error-
# Failed to load kernel modules with required key not available for modules

# Fail on error
set -e

echo "-----------------------------------------------"
echo "Looking up the journal for failed modules..."
echo "-----------------------------------------------"
journalctl | grep modules

echo "Building for all kernels..."
ls /var/lib/initramfs-tools | \
    sudo xargs -n1 /usr/lib/dkms/dkms_autoinstaller start

echo "-----------------------------------------------"
echo "Signing for updated kernel: $(uname -r)"
echo "-----------------------------------------------"

echo "Signing vbox..."
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der $(modinfo -n vboxnetadp)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der \
     /lib/modules/$(uname -r)/misc/vboxnetadp.ko

sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der $(modinfo -n vboxnetflt)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der \
     /lib/modules/$(uname -r)/misc/vboxnetflt.ko

sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der $(modinfo -n vboxpci)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der \
     /lib/modules/$(uname -r)/misc/vboxpci.ko

sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der $(modinfo -n vboxguest)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der \
     /lib/modules/$(uname -r)/kernel/ubuntu/vbox/vboxguest/vboxguest.ko

#sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
#     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der $(modinfo -n vboxsf)
#sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
#     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der \
#     /lib/modules/$(uname -r)/kernel/ubuntu/vbox/vboxsf/vboxsf.ko
#
#sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
#     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der $(modinfo -n vboxvideo)
#sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
#     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der \
#     /lib/modules/$(uname -r)/kernel/ubuntu/vbox/vboxvideo/vboxvideo.ko
#
#sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
#     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der $(modinfo -n vboxdrv)
#sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
#     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der \
#     /lib/modules/4.4.0-64-generic/misc/vboxdrv.ko

echo "Signing bbswitch..."
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der $(modinfo -n bbswitch)
echo "Signing nvidia..."
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der $(modinfo -n nvidia_375_drm)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der $(modinfo -n nvidia_375_uvm)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der $(modinfo -n nvidia_375_modeset)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
     kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der $(modinfo -n nvidia_375)

echo "-----------------------------------------------"
echo "Configuring vbox..."
echo "-----------------------------------------------"
# Enable if you wish to rebuild
# sudo sh -x /sbin/vboxconfig
# Sign all
sudo find / -name "vbox*" | grep ko | sudo xargs -n1 /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 kernel-signing-keys/MOK.priv kernel-signing-keys/MOK.der
echo "Restarting vboxdrv"
sudo modprobe vboxdrv
sudo service vboxdrv restart

echo "Done!"
