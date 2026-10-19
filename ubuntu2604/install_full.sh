#!/bin/bash

# Stop whenever any commit fails
set -eo pipefail

cd "$(dirname -- "${BASH_SOURCE[0]}")/.."

echo "======== Start to install full dotfiles configuration ========"
echo ""


# Install the development environment
./ubuntu2604/install.sh


# flatpak: application management tool
sudo apt install -y flatpak


# SDKMAN: sdk management tool
curl -fsS "https://get.sdkman.io" | bash


# docker without sudo privilege
sudo apt install -y docker.io
getent group docker >/dev/null || sudo groupadd docker
sudo usermod -aG docker "$(id -un)"


echo ""
echo "======== Full dotfiles installation is done ======="
