#!/bin/bash
# Minecraft Server Docker Container Permissions Fix Script
# Author: James A. Chambers - https://jamesachambers.com/
# GitHub Repository: https://github.com/TheRemote/Legendary-Bedrock-Container

# Takes ownership of server files to fix common permission errors such as access denied
# This is very common when restoring backups, moving and editing files, etc.

# Get whether command is automated
Automated=0
while getopts ":a:" opt; do
  case $opt in
    t)
      case $OPTARG in
        ''|*[!0-9]*)
          Automated=1
          ;;
        *)
          Automated=1
          ;;
      esac
      ;;
    \?)
      echo "Invalid option: -$OPTARG; countdown time must be a whole number in minutes." >&2
      ;;
  esac
done

# Take ownership of files
echo "Taking ownership of all server files/folders in /minecraft..."
if [[ $Automated == 1 ]]; then
    sudo -n chown -R $(whoami) /minecraft
    sudo -n chmod -R 755 /scripts/*.sh
    sudo -n chmod 755 /minecraft/bedrock_server
    sudo -n chmod +x /minecraft/bedrock_server
else
    sudo chown -Rv $(whoami) /minecraft
    sudo chmod -Rv 755 /scripts/*.sh
    sudo chmod 755 /minecraft/bedrock_server
    sudo chmod +x /minecraft/bedrock_server

    NewestLog=$(find /minecraft/logs -type f -exec stat -c "%y %n" {} + | sort -r | head -n1 | cut -d " " -f 4-)
    if [ -z "$NewestLog" ]; then
      echo "No log files were found"
    else
      echo "Displaying last 10 lines from log file $NewestLog in /logs folder:"
      tail -10 "$NewestLog"
    fi
fi

echo "Complete"