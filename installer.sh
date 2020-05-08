#!/bin/bash
#=============================================================================
#title           : scisoft_installer for ESO scisoft software collection.
#description     : This script will install scisoft to GNU/Linux, macOS.
#author		     : @yucelkilic and @korhanyelkenci from TAY Platform (bilgi@tay.org.tr) 
#date            : May 7th, 2020
#version         : 0.1    
#usage		     : bash scisoft_installer.sh
#source          : http://cosmology.istanbul.edu.tr/index.php/members/installation-of-scisoft/
#reference       : https://www.eso.org/sci/software/scisoft/
#=============================================================================

function getScisoft() {
    if [ -x "$(which wget)" ] ; then
        wget $1
    elif [ -x "$(which curl)" ]; then
        curl $1 --output $2
    else
        echo "Could not find curl or wget, please install one." >&2
    fi
}

runMacScript()
{
    getScisoft http://cosmology.istanbul.edu.tr/korhan/scisoft_mac.tar scisoft_mac.tar
    tar xvzf scisoft_mac.tar
    sudo installer -pkg Scisoft_OSX_macintel_2013.6.1.pkg -target /
    echo ". /usr/local/scisoft/bin/Setup.bash" >> ~/.bash_profile
    source ~/.bash_profile
    echo "Copying edited extern.pkg file to /usr/local/scisoft/packages/iraf/iraf/unix/hlib/"
    sudo cp extern_tay.pkg /usr/local/scisoft/packages/iraf/iraf/unix/hlib/extern.pkg
    printEcl
}

runLinuxScript()
{
    LIST_OF_APPS="libc6:i386 libncurses5:i386 libstdc++6:i386 tcsh:i386 libgfortran3:i386 libreadline5:i386 sudo apt-get install libsdl-image1.2:i386 libsdl-ttf2.0-0:i386 unixodbc:i386 libxft2:i386 libxrandr2:i386 libxmu6:i386 libxss1:i386 libxml2:i386 lib32stdc++6 lib64stdc++6 libxft2:i386"
    getScisoft http://cosmology.istanbul.edu.tr/korhan/scisoft.tar scisoft.tar
    sudo apt-get install -y $LIST_OF_APPS
    tar xvzf scisoft.tar --directory /
    echo ". /usr/local/scisoft/bin/Setup.bash" >> ~/.bash_profile
    source ~/.bash_profile
    echo "Copying edited extern.pkg file to /usr/local/scisoft/packages/iraf/iraf/unix/hlib/"
    sudo cp extern_tay.pkg /usr/local/scisoft/packages/iraf/iraf/unix/hlib/extern.pkg
    printEcl
}


printEcl()
{
  cat <<EOF
=====================================================================

Now, you are ready to run following command;
ecl

=====================================================================
EOF
}

# Determining OS
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

echo "Installation script running for: " ${machine}

if [ ${machine} == "Mac" ]; then
    runMacScript
elif [ ${machine} == "Linux" ] || [ ${machine} == "Cygwin" ]; then
    runLinuxScript
else
    echo "Unsupported OS:" ${machine}
fi

echo "Installation completed for: " ${machine}
