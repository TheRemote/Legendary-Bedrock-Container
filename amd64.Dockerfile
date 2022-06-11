# Minecraft Bedrock Server Docker Container
# Author: James A. Chambers - https://jamesachambers.com/legendary-minecraft-bedrock-container/
# GitHub Repository: https://github.com/TheRemote/Legendary-Bedrock-Container

# Use "Impish" Ubuntu version for builder
FROM ubuntu:21.10 AS builder

# Update apt
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install apt-utils -yqq && rm -rf /var/cache/apt/*

# Use "Impish" Ubuntu version
FROM --platform=linux/amd64 ubuntu:21.10

# Fetch dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install apt-utils -yqq && DEBIAN_FRONTEND=noninteractive apt-get install sudo curl unzip screen net-tools gawk openssl findutils pigz libcurl4 libc6 libcrypt1 libcurl4-openssl-dev ca-certificates binfmt-support libssl1.1 -yqq && rm -rf /var/cache/apt/*

# Set port environment variables
ENV PortIPV4=19132
ENV PortIPV6=19133

# Version environment variable (must exist on Microsoft's servers)
ENV Version=

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

# Set entrypoint to start.sh script
ENTRYPOINT ["/bin/bash", "/scripts/start.sh"]