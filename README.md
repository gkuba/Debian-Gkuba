# Debian-Gkuba

This is my customization for fresh Debian installs.

## Requirements

_This install changes Debian to the SID (Dev) Branch_

### Download Debian non-free netinstall

Use the following Debian ISO as the base <https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/weekly-builds/amd64/iso-cd/>

_do NOT grab the EDU download and this includes non-free and firmware_

### To Install

```bash
bash <(wget -qO- https://raw.githubusercontent.com/gkuba/Debian-Gkuba/main/install.sh)
```

## Optional Changes

If you would like it not to prompt you for a password for every sudo operation you can edit the sudoers file as follows.

_These changes MUST be run as the root user_

```bash
sudo su
visudo /etc/sudoers
```

You will then add the following to the end of the file replacing "username" with your user:

```bash
username    ALL=(ALL) NOPASSWD:ALL
```

Then reboot.

### AMP Java Requirements

If you are installing AMP this install script already added the adoptium java repo you just need to run the following to get the right java versions.

```bash
sudo apt install temurin-8-jdk temurin-17-jdk temurin-18-jdk
```
