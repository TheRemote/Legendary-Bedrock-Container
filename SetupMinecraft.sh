#!/bin/bash
# Legendary Bedrock Container setup script - image build time
# Author: James A. Chambers - https://jamesachambers.com/legendary-minecraft-bedrock-container/

Check_Dependencies() {
  # Install dependencies required to run Minecraft server in the background
  if command -v apt-get &> /dev/null; then
    echo "Updating apt.."
    sudo apt-get update && sudo apt dist-upgrade -y

    echo "Checking and installing dependencies.."
    if ! command -v curl &> /dev/null; then sudo DEBIAN_FRONTEND=noninteractive apt-get install curl -yqq; fi
    if ! command -v unzip &> /dev/null; then sudo DEBIAN_FRONTEND=noninteractive apt-get install unzip -yqq; fi
    if ! command -v screen &> /dev/null; then sudo DEBIAN_FRONTEND=noninteractive apt-get install screen -yqq; fi
    if ! command -v route &> /dev/null; then sudo DEBIAN_FRONTEND=noninteractive apt-get install net-tools -yqq; fi
    if ! command -v gawk &> /dev/null; then sudo DEBIAN_FRONTEND=noninteractive apt-get install gawk -yqq; fi
    if ! command -v openssl &> /dev/null; then sudo DEBIAN_FRONTEND=noninteractive apt-get install openssl -yqq; fi
    if ! command -v xargs &> /dev/null; then sudo DEBIAN_FRONTEND=noninteractive apt-get install xargs -yqq; fi
    if ! command -v xargs &> /dev/null; then sudo DEBIAN_FRONTEND=noninteractive apt-get install findutils -yqq; fi
    if ! command -v pigz &> /dev/null; then sudo DEBIAN_FRONTEND=noninteractive apt-get install pigz -yqq; fi

    CurlVer=$(apt-cache show libcurl4 | grep Version | awk 'NR==1{ print $2 }')
    if [[ "$CurlVer" ]]; then
      sudo DEBIAN_FRONTEND=noninteractive apt-get install libcurl4 -yqq
    else
      # Install libcurl3 for backwards compatibility in case libcurl4 isn't available
      CurlVer=$(apt-cache show libcurl3 | grep Version | awk 'NR==1{ print $2 }')
      if [[ "$CurlVer" ]]; then sudo DEBIAN_FRONTEND=noninteractive apt-get install libcurl3 -yqq; fi
    fi

    sudo DEBIAN_FRONTEND=noninteractive apt-get install libc6 -yqq
    sudo DEBIAN_FRONTEND=noninteractive apt-get install libcrypt1 -yqq
    sudo DEBIAN_FRONTEND=noninteractive apt-get install qemu -yqq

    # Install libssl 1.1 if available
    SSLVer=$(apt-cache show libssl1.1 2>&1 | grep Version | awk 'NR==1{ print $2 }')
    if [[ "$SSLVer" ]]; then
      sudo DEBIAN_FRONTEND=noninteractive apt-get install libssl1.1 -yqq
    else
      CPUArch=$(uname -m)
      if [[ "$CPUArch" == *"x86_64"* ]]; then
        echo "Performing manual libssl1.1 installation..."
        
        sudo DEBIAN_FRONTEND=noninteractive dpkg -i /scripts/libssl.deb
        rm -f /scripts/libssl.deb
        SSLVer=$(apt-cache show libssl1.1 | grep Version | awk 'NR==1{ print $2 }')
        if [[ "$SSLVer" ]]; then
          echo "Manual libssl1.1 installation successful!"
        else
          echo "Manual libssl1.1 installation failed."
        fi
      fi
    fi

    # Double check curl since libcurl dependency issues can sometimes remove it
    if ! command -v curl &> /dev/null; then sudo DEBIAN_FRONTEND=noninteractive apt-get install curl -yqq; fi
    echo "Dependency installation completed"
  else
    echo "Warning: apt was not found.  You may need to install curl, screen, unzip, libcurl4, openssl, libc6 and libcrypt1 with your package manager for the server to start properly!"
  fi
}

Check_Dependencies