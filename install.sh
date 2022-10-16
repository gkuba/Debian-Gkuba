#! /bin/bash

function isPresent { command -v "$1" &> /dev/null && echo 1; }
source /etc/os-release

clear
echo
echo "Please wait, examining your system and network configuration..."
echo

ARCH=$(uname -m)
TESTING_RELEASE="$(wget -q --save-headers --output-document - http://ftp.debian.org/debian/dists/testing/Release | awk /'Codename/ {print $2}')"
PM_COMMAND=apt-get
PM_INSTALL="install -y"
WGET_IS_PRESENT="$(isPresent wget)"
JAVA_PACKAGE="temurin-8-jdk temurin-17-jdk temurin-18-jdk"
WANTED_PACKAGES="git curl unzip nala vim most fontconfig zsh zsh-autosuggestions zsh-syntax-highlighting fonts-firacode"

## Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run \"sudo su\" then try again."
  exit 1
fi

## Checks for wget
if [[ $WGET_IS_PRESENT -ne 1 ]]; then
  echo "Wget is not installed and required for this script to run. Please install wget then try again"
  exit 1
fi

## Checks if you want to install other repos.
function promptRepoChange
{
  clear
  echo
  echo "OS Name: $NAME"
  echo "Version: $VERSION_CODENAME"
  echo 
  echo
  echo "Would you like to change to latest Testing ($TESTING_RELEASE) branch?"
  echo "This will make a backup copy of your /etc/apt/sources.list then update them to your choice."
  echo
  echo "You can revert this anytime by changing /etc/sources.list.bak to /etc/sources.list like this:"
  echo "sudo mv /etc/apt/sources.list.bak /etc/apt/sources.list"
  echo
  echo
  read -n1 -rp "Selection: [y|N] " checkRepoChange
  checkRepoChange=${checkRepoChange:-n}
  echo
  echo
}

## Checks if you want to install JAVA
function promptInstallJava
{
  echo
  echo "Would you like to install the Java?"
  echo "This will install the Adoptium Java JDK Repository and the following packages:"
  echo "$JAVA_PACKAGE"
  echo "Adoptium JDKs are part of the Eclipse Foundation and are free to use under the GNU/GPL 2 License"
  echo
  echo
  read -n1 -rp "Install Java: [y|N] " checkInstallJava
  checkInstallJava=${checkInstallJava:-n}
}

## Updates the sources.list file to the specified option. 
function writeSourceList
{
  echo
  echo "Backing up /etc/apt/sources.list to /etc/apt/sources.list.bak"
  echo

  cp /etc/apt/sources.list /etc/apt/sources.list.bak

  echo "Writing sources.list to /etc/apt/sources.list" 
  echo
  cat <<EOF > /etc/apt/sources.list 
deb http://deb.debian.org/debian $TESTING_RELEASE main non-free contrib
deb http://deb.debian.org/debian $TESTING_RELEASE-updates main non-free contrib
deb http://security.debian.org/debian-security $TESTING_RELEASE-security main non-free contrib
deb http://ftp.debian.org/debian $TESTING_RELEASE-backports main
EOF
}

## Add the AdoptOpenJDK repository. Currently no bookworm repo so forcing bullseye current stable. Also doesn't have Sid.
function addJavaRepo
{
  echo
  echo "Adding AdoptOpenJDK APT repository..."
  echo
  wget -qO- https://packages.adoptium.net/artifactory/api/gpg/key/public > /usr/share/keyrings/adoptium.asc
	echo "deb [signed-by=/usr/share/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb bullseye main" | sudo tee /etc/apt/sources.list.d/adoptium.list
}

function checkUpdtes 
{
  echo
  echo "Checking for and installing updates..."
  echo
  $PM_COMMAND update
  $PM_COMMAND upgrade -y
}

## Installs Java version defined in JAVA_PACKAGE.
function installJava
{
  if [ -f /etc/apt/sources.list.d/adoptium.list ]; then
    echo
    echo "Installing $JAVA_PACKAGE"
    echo
    checkUpdtes
    $PM_COMMAND $PM_INSTALL $JAVA_PACKAGE
  else
    echo
    echo "Java repository not set up. Please re-run \"./install.sh addJavaRepo\" first then retry."
    echo
    exit 1
  fi
}

## Checks for wanted repo's to add / change.
function installDependencies
{
if [[ "$checkRepoChange" =~ ^[Yy]$ ]] && [[ "$VERSION_CODENAME" != "$TESTING_RELEASE" ]]; then
  writeSourceList
elif [[ "$checkRepoChange" =~ ^[Nn]$ ]]; then
  return
else
  echo
  echo -e "Your current version is the same as Testing."
  echo -e "Current Version:  "$VERSION_CODENAME
  echo -e "Testing Version:  "$TESTING_RELEASE
  return
fi

if [[ "$checkInstallJava" =~ ^[Yy]$ ]]; then
  addJavaRepo
  installJava
fi
}

## Installs packages defined in WANTED_PACKAGES list.
function installPackages
{
  echo
  echo "Installing packages ...."
  echo "Selected Packages: $WANTED_PACKAGES"
  echo
  $PM_COMMAND $PM_INSTALL $WANTED_PACKAGES
}

if [ -n "$*" ]; then
  for ARG in $@
  do
    if ! type "$ARG" &> /dev/null; then
      echo "No such function $ARG"
      exit 1
    fi
  done
  
  for ARG_RUN in $@
  do
    $ARG_RUN
  done
  echo
  echo
  echo "Done"
  exit
 fi

##############
## ENTRY POINT
##############

promptRepoChange
promptInstallJava

echo
echo
echo "===================="
echo "Installation Summary"
echo "===================="
echo
echo -en "Testing Repo:  "
if [[ "$checkRepoChange" =~ ^[Yy]$ ]]; then echo "Yes"; else echo "No"; fi
echo -en "Install Java:  "
if [[ "$checkInstallJava" =~ ^[Yy]$ ]]; then echo "Yes"; else echo "No"; fi
echo
echo "Ready to install, Press ENTER to continue or CTRL+C to cancel."
read -r 
echo
echo "Installing please wait ..."

installDependencies

if [[ "$checkInstallJava" =~ ^[Nn]$ ]]; then
  checkUpdtes
fi

installPackages

echo "Installation complete."

exit 0