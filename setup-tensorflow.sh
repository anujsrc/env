#!/bin/sh

# ----------------------------------------------------------
# Please setup Bumblebee and Nvidia drivers
# using setup-graphics.sh before running this script
# ----------------------------------------------------------

# First review and make sure you have compatible libraries as mentioned here-
# http://docs.nvidia.com/cuda/cuda-installation-guide-linux/#axzz4VZnqTJ2A
# See- https://www.youtube.com/watch?v=fY0n0WD3UXs for step-by-step instructions

# Fail on error
set -e

echo "------------------------------------------------------"
echo "Installing CUDA"
echo "------------------------------------------------------"
echo "Downloading CUDA 8.0 deb file (~ 1.8GB)..."
echo "Downloading from https://developer.nvidia.com/cuda-downloads"
wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
echo "Installing CUDA 8.0..."
sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get install -y cuda
#sudo apt-get install -y nvidia-cuda-dev nvidia-cuda-toolkit
#sudo apt-get install libmpich-dev libopenmpi-dev

echo "Setting environment for this session..."
export CUDA_HOME=/usr/local/cuda-8.0
export PATH=$PATH:$CUDA_HOME/bin
export LD_LIBRARY_PATH=/usr/lib/nvidia-375:/usr/lib32/nvidia-375:$CUDA_HOME/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

echo "------------------------------------------------------"
echo "Verify Driver Version"
echo "------------------------------------------------------"
#cat /proc/driver/nvidia/version
nvcc -V

echo "------------------------------------------------------"
echo "Installing cuDNN"
echo "------------------------------------------------------"
echo "Downloading cuDNN 5.1 (~100MB)..."
echo "Downloading from https://developer.nvidia.com/rdp/cudnn-download"
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v5.1/prod_20161129/8.0/cudnn-8.0-linux-x64-v5.1-tgz
echo "Extracting cuDNN..."
tar -xvf cudnn-8.0-linux-x64-v5.1.tgz
echo "Copying libraries..."
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/* /usr/local/cuda/lib64
echo "Setting permissions for all users..."
sudo chmod a+r /usr/local/cuda/lib64/libcudnn*

echo "------------------------------------------------------"
echo "Setting up NVIDIA CUDA Profile Tools Interface"
sudo apt-get install -y libcupti-de
echo "------------------------------------------------------"

echo "------------------------------------------------------"
echo "Setting up virtualenv for TensorFlow"
echo "------------------------------------------------------"
sudo apt-get install -y python-pip python3-pip python-dev python3-dev python-virtualenv
echo "Setting up virtual environment at ~/tensorflowGPU"
virtualenv --system-site-packages ~/tensorflowGPU
echo "Activating environment..."
source ~/tensorflowGPU/bin/activate

echo "------------------------------------------------------"
echo "(tensortflowGPU): Installing TensorFlow GPU support..."
echo "------------------------------------------------------"
pip install --upgrade tensorflow-gpu

echo "------------------------------------------------------"
echo "Please update your bashrc or environment file-"
echo "Set CUDA_HOME to /usr/local/cuda"
echo "Update LD_LIBRARY_PATH to include $CUDA_HOME/lib64"
echo "------------------------------------------------------"
