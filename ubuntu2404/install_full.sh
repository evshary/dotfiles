#!/bin/bash

# Stop whenever any commit fails
set -e

echo "======== Start to install full dotfiles configuration ========"
echo ""


# Install the development environment
./ubuntu2404/install.sh


# flatpak: application management tool
sudo apt install -y flatpak


# SDKMAN: sdk management tool
curl -s "https://get.sdkman.io" | bash


# docker without sudo privilege
sudo apt install -y docker.io
sudo groupadd docker
sudo usermod -aG docker $USER


echo ""
echo "======== Full dotfiles installation is done ======="
