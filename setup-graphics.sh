#!/bin/sh
sudo update-pciids
echo "Listing Controllers..."
lspci -nn | grep '\[03'

# Install utilities
echo "Installing benchmark utilities..."
sudo apt-get install -y mesa-utils
sudo apt-get install -y glmark2
sudo apt-get install -y bumblebee

# Test Commands
# glxgears
# glmark2
# vblank_mode=0 optirun glmark2
