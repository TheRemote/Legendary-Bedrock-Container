#!/bin/bash
# Legendary Bedrock Container setup script - image build time
# Author: James A. Chambers - https://jamesachambers.com/minecraft-bedrock-edition-ubuntu-dedicated-server-guide/

Check_Dependencies() {
  # Install dependencies required to run Minecraft server in the background
  if command -v apt-get &> /dev/null; then
    echo "Updating apt.."
    sudo apt-get update

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

    # Install libssl 1.1 if available
    SSLVer=$(apt-cache show libssl1.1 | grep Version | awk 'NR==1{ print $2 }')
    if [[ "$SSLVer" ]]; then
      sudo DEBIAN_FRONTEND=noninteractive apt-get install libssl1.1 -yqq
    else
      CPUArch=$(uname -m)
      if [[ "$CPUArch" == *"x86_64"* ]]; then
        echo "No libssl1.1 available in repositories -- attempting manual install"
        
        sudo curl -o libssl.deb -k -L http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1l-1ubuntu1.3_amd64.deb
        sudo dpkg -i libssl.deb
        sudo rm libssl.deb
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


Check_Architecture () {
  # Check CPU archtecture to see if we need to do anything special for the platform the server is running on
  echo "Getting system CPU architecture..."
  CPUArch=$(uname -m)
  echo "System Architecture: $CPUArch"

  # Check for ARM architecture
  if [[ "$CPUArch" == *"aarch"* || "$CPUArch" == *"arm"* ]]; then
    # ARM architecture detected -- download QEMU and dependency libraries
    echo "ARM platform detected -- installing dependencies..."

    # Check if latest available QEMU version is at least 3.0 or higher
    QEMUVer=$(apt-cache show qemu-user-static | grep Version | awk 'NR==1{ print $2 }' | cut -c3-3)
    if [[ "$QEMUVer" -lt "3" ]]; then
      echo "Available QEMU version is not high enough to emulate x86_64.  Please update your QEMU version."
      exit
    else
      sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install qemu-user-static binfmt-support -yqq
    fi

    if [ -n "`which qemu-x86_64-static`" ]; then
      echo "QEMU-x86_64-static installed successfully"
    else
      echo "QEMU-x86_64-static did not install successfully -- please check the above output to see what went wrong."
      exit 1
    fi

    # Retrieve depends.zip from GitHub repository
    cd /scripts
    curl -H "Accept-Encoding: identity" -L -o depends.zip https://raw.githubusercontent.com/TheRemote/minecraftdrockServer/master/depends.zip
    unzip depends.zip
    rm -f depends.zip
    sudo mkdir /lib64
    # Create soft link ld-linux-x86-64.so.2 mapped to ld-2.31.so
    sudo rm -rf /lib64/ld-linux-x86-64.so.2
    sudo ln -s /scripts/ld-2.31.so /lib64/ld-linux-x86-64.so.2
  fi

  # Check for x86 (32 bit) architecture
  if [[ "$CPUArch" == *"i386"* || "$CPUArch" == *"i686"* ]]; then
    # 32 bit attempts have not been successful -- notify user to install 64 bit OS
    echo "You are running a 32 bit operating system (i386 or i686) and the Bedrock Dedicated Server has only been released for 64 bit (x86_64).  If you have a 64 bit processor please install a 64 bit operating system to run the Bedrock dedicated server!"
    exit 1
  fi
}

Check_Dependencies
Check_Architecture