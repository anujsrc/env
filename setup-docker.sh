#!/bin/sh

# Grab the script to setup docker
wget -qO- https://get.docker.com/ | sh

# Access docker with non-sudo privileges
sudo usermod -a -G docker anuj
