#! /bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run \"sudo su\" then try again." 2>&1
  exit 1
fi

 wget -q https://raw.githubusercontent.com/gkuba/Debian-Gkuba/main/sources.list -O sources.list

# Change Debian to SID Branch
cp /etc/apt/sources.list /etc/apt/sources.list.bak
mv sources.list /etc/apt/sources.list

# Update packages list and update system
apt update
apt upgrade -y

# Install packages
apt install -y git curl unzip nala vim most fontconfig zsh zsh-autosuggestions zsh-syntax-highlighting fonts-firacode