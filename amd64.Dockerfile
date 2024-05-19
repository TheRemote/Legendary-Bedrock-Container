# Minecraft Bedrock Server Docker Container
# Author: James A. Chambers - https://jamesachambers.com/legendary-minecraft-bedrock-container/
# GitHub Repository: https://github.com/TheRemote/Legendary-Bedrock-Container

# Use latest Ubuntu version for builder
FROM ubuntu:latest AS builder

# Use latest Ubuntu version
FROM --platform=linux/amd64 ubuntu:latest

# Fetch dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install apt-utils -yqq && DEBIAN_FRONTEND=noninteractive apt-get install systemd-sysv tzdata sudo curl unzip screen net-tools gawk openssl findutils pigz libcurl4t64 libc6 libcrypt1 libcurl4-openssl-dev ca-certificates binfmt-support libssl3t64 nano -yqq && rm -rf /var/cache/apt/*

# Set port environment variables
ENV PortIPV4=19132
ENV PortIPV6=19133

# Version environment variable (must exist on Microsoft's servers)
ENV Version=

# Specifies whether to clean the downloads folder and reinstall the server (set to Y to enable)
ENV Clean=

# Optional Timezone
ENV TZ="America/Denver"

# Optional switch to skip permissions check
ENV NoPermCheck=""

# Number of rolling backups to keep
ENV BackupCount=10

# Optional switch to tell curl to suppress the progress meter which generates much less noise in the logs
ENV QuietCurl=""

# IPV4 Ports
EXPOSE 19132/tcp
EXPOSE 19132/udp

# IPV6 Ports
EXPOSE 19133/tcp
EXPOSE 19133/udp

# Copy scripts to minecraftbe folder and make them executable
RUN mkdir /scripts
COPY *.sh /scripts/
RUN chmod -R +x /scripts/*.sh
COPY server.properties /scripts/
COPY allowlist.json /scripts/
COPY permissions.json /scripts/

# Set entrypoint to start.sh
ENTRYPOINT ["/bin/bash", "/scripts/start.sh"]