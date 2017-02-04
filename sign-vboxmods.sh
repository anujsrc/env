#!/bin/sh
sudo /usr/src/linux-headers-4.4.0-59-generic/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxdrv)
sudo /usr/src/linux-headers-4.4.0-59-generic/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxnetadp)
sudo /usr/src/linux-headers-4.4.0-59-generic/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxnetflt)
sudo /usr/src/linux-headers-4.4.0-59-generic/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxpci)
sudo /usr/src/linux-headers-4.4.0-59-generic/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxguest)
sudo /usr/src/linux-headers-4.4.0-59-generic/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxsf)
sudo /usr/src/linux-headers-4.4.0-59-generic/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxvideo)

# Restart vboxdrv
sudo service vboxdrv restart
