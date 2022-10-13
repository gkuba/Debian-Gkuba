#! /bin/bash

# Sync packages and install updates if needed.
apt update && apt upgrade -y

# Install packages
apt install -y git curl unzip neofetch nala vim most fontconfig zsh zsh-autosuggestions zsh-syntax-highlighting fonts-firacode