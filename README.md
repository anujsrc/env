# env
Dev Environment for Ubuntu that sets up these tools-

* [zsh](https://github.com/robbyrussell/oh-my-zsh)
* Liquid Prompt
* [vim](http://www.vim.org/)
  - All the base Vim plug-ins for Clojure
* [emacs-25](https://www.gnu.org/software/emacs/)
* [Screen](https://www.gnu.org/software/screen/)
* [Solarized Theme](https://github.com/Anthony25/gnome-terminal-colors-solarized)
* Inconsolata and Hermit fonts

## Usage
Run [setup.sh](https://github.com/anujsrc/env/blob/master/setup.sh)

## Disk Partitions
A typical single HDD partitions can be done as shown below-

![Disk Partitions](https://github.com/anujsrc/env/blob/master/references/disk-partitions.png "Disk Partitions")

## Utilities
Here are some of the utilities-

* [Setup Docker](https://github.com/anujsrc/env/blob/master/setup-docker.sh)
* [Setup Virtualbox](https://github.com/anujsrc/env/blob/master/setup-virtualbox.sh)
* [Benchmark Graphic Card](https://github.com/anujsrc/env/blob/master/setup-graphics.sh)
* [Build Emacs25](https://github.com/anujsrc/env/blob/master/setup-emacs.sh)
* [Restart Network](https://github.com/anujsrc/env/blob/master/restart-network.sh)

## Checklists and Cheatsheets
Here are some of the checklists and references that are always handy-

* [Ubuntu-16.04 Installation Notes](https://github.com/anujsrc/env/blob/master/checklists/config.txt)
* [Emacs Quick Reference](https://github.com/anujsrc/env/blob/master/references/emacsup.txt)
* [Docker/Vagrant/VirtualBox Quick Reference](https://github.com/anujsrc/env/blob/master/checklists/container.txt)

### Secure boot and VirtualBox Component Signing
VirtualBox requires the components to be signed and key to be enrolled with to
work with Secureboot. To do so, first generate the keys using the command-

```
openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=Descriptive name/"
```
Above command will generate two files ``MOK.priv`` and ``MOK.der``. To sign
VirtualBox components execute the script
[sign-vboxmods.sh](https://github.com/anujsrc/env/blob/master/sign-vboxmods.sh)
in the same folder where the ``MOK.*`` files have been generated. Once you have
signed the components, you need to enroll the key (only once) as shown below-

```
sudo mokutil --import MOK.der
```
Now, reboot the machine, enrol the key from the manager screen and probe the
component as shown below-

```
sudo modprobe vboxdrv
```
