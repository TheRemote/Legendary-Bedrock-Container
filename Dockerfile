# Minecraft Server Docker Container Permissions Fix Script
# Author: James A. Chambers - https://jamesachambers.com/
# GitHub Repository: https://github.com/TheRemote/Legendary-Bedrock-Container

# Use current Ubuntu LTS version
FROM ubuntu:20.04

# Update apt
RUN apt-get update 

# Fetch dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install sudo curl unzip screen net-tools gawk openssl findutils pigz libcurl4 libc6 libcrypt1 apt-utils libcurl4-openssl-dev ca-certificates -yqq

# Set port environment variables
ENV PortIPV4=19132
ENV PortIPV6=19133

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

# Run SetupMinecraft.sh
RUN /scripts/SetupMinecraft.sh

# Clean apt
RUN apt-get clean && apt-get autoclean

# Set entrypoint to start.sh script
ENTRYPOINT ["/bin/bash", "/scripts/start.sh"]
