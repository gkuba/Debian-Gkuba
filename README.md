# Debian-Gkuba

This is my customization for fresh Debian installs.

### Download Debian non-free netinstall

Use the following Debian ISO as the base <https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/weekly-builds/amd64/iso-cd/>

do **NOT** grab the **EDU** download and this includes non-free and firmware
### Base Stuff - Root

This changes it so you don't need a password when you run sudo commands. This **MUST** be run as **ROOT** and with **VISUDO**.

```bash
sudo su
visudo /etc/sudoers
```
Add this to the end of your /etc/sudoers file. 

_Change gkuba to your username._
```bash
gkuba   ALL=(ALL) NOPASSWD:ALL
```

_Run as ROOT_
```bash
wget https://raw.githubusercontent.com/gkuba/Debian-Gkuba/main/root.sh
chmod +x root.sh
sudo su
./root.sh
```
## If running on Debian - Bullseye

To install Nala you will have to change your sources.list file to the bookworm branch from bullseye.

Open your `/etc/apt/sources.list` file in your editor of choice and change "bullseye" to "bookworm"
```bash
deb http://deb.debian.org/debian bookworm main non-free contrib
deb http://deb.debian.org/debian bookworm-updates main non-free contrib
deb http://security.debian.org/debian-security bookworm-security main non-free contrib
deb http://ftp.debian.org/debian bookworm-backports main
```
It is recommended to do this before running the "root.sh" script.

### Theme Stuff - User Level
 ```bash
  ./user.sh
 ```
