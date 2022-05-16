#!/bin/bash
# Minecraft Bedrock Docker server startup script using screen
# Author: James A. Chambers - https://jamesachambers.com/legendary-minecraft-bedrock-container/
# GitHub Repository: https://github.com/TheRemote/Legendary-Bedrock-Container

echo "Minecraft Bedrock Server Docker script by James A. Chambers"
echo "Latest version always at https://github.com/TheRemote/Legendary-Bedrock-Container"
echo "Don't forget to set up port forwarding on your router!  The default port is 19132"

if [ ! -d '/minecraft' ]; then
  echo "ERROR:  A named volume was not specified for the minecraft server data.  Please create one with: docker volume create yourvolumename"
  echo "Please pass the new volume to docker like this:  docker run -it -v yourvolumename:/minecraft"
  exit 1
fi

# Randomizer for user agent
RandNum=$(echo $((1 + $RANDOM % 5000)))

if [ -z "$PortIPV4" ]; then
  PortIPV4="19132"
fi
if [ -z "$PortIPV6" ]; then
  PortIPV6="19133"
fi
echo "Ports used - IPV4: $PortIPV4 - IPV6: $PortIPV6"

# Check if server is already started
ScreenWipe=$(screen -wipe)
if screen -list | grep -q "\.minecraftbe"; then
    echo "Server is already started!  Press screen -r minecraftbe to open it"
    exit 1
fi

# Change directory to server directory
cd /minecraft

# Create logs/backups/downloads folder if it doesn't exist
if [ ! -d "/minecraft/logs" ]; then
    mkdir -p /minecraft/logs
fi
if [ ! -d "/minecraft/downloads" ]; then
    mkdir -p /minecraft/downloads
fi
if [ ! -d "/minecraft/backups" ]; then
    mkdir -p /minecraft/backups
fi

# Check if network interfaces are up
NetworkChecks=0
if [ -e '/sbin/route' ]; then
    DefaultRoute=$(/sbin/route -n | awk '$4 == "UG" {print $2}')
else
    DefaultRoute=$(route -n | awk '$4 == "UG" {print $2}')
fi
while [ -z "$DefaultRoute" ]; do
    echo "Network interface not up, will try again in 1 second";
    sleep 1;
    if [ -e '/sbin/route' ]; then
        DefaultRoute=$(/sbin/route -n | awk '$4 == "UG" {print $2}')
    else
        DefaultRoute=$(route -n | awk '$4 == "UG" {print $2}')
    fi
    NetworkChecks=$((NetworkChecks+1))
    if [ $NetworkChecks -gt 20 ]; then
        echo "Waiting for network interface to come up timed out - starting server without network connection ..."
        break
    fi
done

# Take ownership of server files and set correct permissions
Permissions=$(sudo bash /scripts/fixpermissions.sh -a)

# Create backup
if [ -d "worlds" ]; then
    echo "Backing up server (to minecraftbe/backups folder)"
    if [ -n "`which pigz`" ]; then
        echo "Backing up server (multiple cores) to minecraftbe/backups folder"
        tar -I pigz -pvcf backups/$(date +%Y.%m.%d.%H.%M.%S).tar.gz worlds
    else
        echo "Backing up server (single cored) to minecraftbe/backups folder"
        tar -pzvcf backups/$(date +%Y.%m.%d.%H.%M.%S).tar.gz worlds
    fi
fi

# Rotate backups -- keep most recent 10
if [ -e /minecraft/backups ]; then
  Rotate=$(pushd /minecraft/backups; ls -1tr | head -n -10 | xargs -d '\n' rm -f --; popd)
fi

# Retrieve latest version of Minecraft Bedrock dedicated server
echo "Checking for the latest version of Minecraft Bedrock server ..."

# Test internet connectivity first
curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RandNum.212 Safari/537.36" -s google.com -o /dev/null
if [ "$?" != 0 ]; then
    echo "Unable to connect to update website (internet connection may be down).  Skipping update ..."
else
    # Download server index.html to check latest version

    curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RandNum.212 Safari/537.36" -o /minecraft/downloads/version.html https://www.minecraft.net/en-us/download/server/bedrock
    DownloadURL=$(grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*' /minecraft/downloads/version.html)

    DownloadFile=$(echo "$DownloadURL" | sed 's#.*/##')

    # Download latest version of Minecraft Bedrock dedicated server if a new one is available
    if [ -f "/minecraft/downloads/$DownloadFile" ]
    then
        echo "Minecraft Bedrock server is up to date..."
    else
        echo "New version $DownloadFile is available.  Updating Minecraft Bedrock server ..."
        curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RandNum.212 Safari/537.36" -o "downloads/$DownloadFile" "$DownloadURL"
        if [ -e server.properties ]; then
          unzip -o "downloads/$DownloadFile" -x "*server.properties*" "*permissions.json*" "*whitelist.json*" "*valid_known_packs.json*" "*allowlist.json*"
        else
          unzip -o "downloads/$DownloadFile"
        fi
        
        # Take ownership of server files and set correct permissions
        Permissions=$(sudo bash /scripts/fixpermissions.sh -a)
    fi
fi

# Change ports in server.properties
sed -i "/server-port=/c\server-port=$PortIPV4" /minecraft/server.properties
sed -i "/server-portv6=/c\server-portv6=$PortIPV6" /minecraft/server.properties

# Start server
echo "Starting Minecraft server..."
BASH_CMD="LD_LIBRARY_PATH=/minecraft /minecraft/bedrock_server"
if command -v gawk &> /dev/null; then
  BASH_CMD+=$' | gawk \'{ print strftime(\"[%Y-%m-%d %H:%M:%S]\"), $0 }\''
else
  echo "gawk application was not found -- timestamps will not be available in the logs.  Please delete SetupMinecraft.sh and run the script the new recommended way!"
fi
screen -L -Logfile /minecraft/logs/minecraft.$(date +%Y.%m.%d.%H.%M.%S).log -mS minecraftbe /bin/bash -c "${BASH_CMD}"