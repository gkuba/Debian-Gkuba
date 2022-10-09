#! /bin/bash

# Install packages
sudo apt install -y git curl unzip neofetch nala vim most fontconfig zsh zsh-autosuggestions zsh-syntax-highlighting fonts-firacode

# Setup Passwordless sudo
sed -i 's/^%sudo   ALL=(ALL:ALL) ALL/%sudo   ALL=(ALL) NOPASSWD ALL/' /etc/sudoers
