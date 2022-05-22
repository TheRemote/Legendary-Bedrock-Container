# Minecraft Bedrock Server Docker Container
# Author: James A. Chambers - https://jamesachambers.com/legendary-minecraft-bedrock-container/
# GitHub Repository: https://github.com/TheRemote/Legendary-Bedrock-Container

# Use "Impish" Ubuntu version for builder
FROM ubuntu:21.10 AS builder

# Update apt
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install qemu-user-static binfmt-support apt-utils -yqq

# Clean apt
RUN apt-get clean && apt-get autoclean

# Use "Impish" Ubuntu version
FROM --platform=linux/ppc64le ubuntu:21.10

# Add QEMU
COPY --from=builder /usr/bin/qemu-ppc64le-static /usr/bin/

# Fetch dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install sudo curl unzip screen net-tools gawk openssl findutils pigz libcurl4 libc6 libcrypt1 apt-utils libcurl4-openssl-dev ca-certificates binfmt-support -yqq

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
COPY libssl.deb /scripts/
RUN chmod -R +x /scripts/*.sh

# Run SetupMinecraft.sh
RUN /scripts/SetupMinecraft.sh

# Clean apt
RUN apt-get clean && apt-get autoclean

# Set entrypoint to start.sh script
ENTRYPOINT ["/bin/bash", "/scripts/start.sh"]
