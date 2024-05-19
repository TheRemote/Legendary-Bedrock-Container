# Minecraft Bedrock Server Docker Container
# Author: James A. Chambers - https://jamesachambers.com/legendary-minecraft-bedrock-container/
# GitHub Repository: https://github.com/TheRemote/Legendary-Bedrock-Container

# Use latest Ubuntu version for builder
FROM ubuntu:latest AS builder

# Install libssl 1.1
COPY libssl1-1.deb /scripts/
RUN dpkg -x /scripts/libssl1-1.deb /tmp/ext; rm -rf /scripts/libssl1-1.deb; cp -Rf /tmp/ext/usr/lib/x86_64-linux-gnu/* /usr/lib/x86_64-linux-gnu/

# Update apt
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install qemu-user-static binfmt-support apt-utils libcurl4 libssl-dev -yqq && rm -rf /var/cache/apt/*

# Use latest Ubuntu version
FROM --platform=linux/riscv64 ubuntu:latest

# Add QEMU
COPY --from=builder /usr/bin/qemu-riscv64-static /usr/bin/

# Copy bedrock_server dynamically linked dependencies
RUN mkdir -p /lib64/
RUN mkdir -p /lib/x86_64-linux-gnu
COPY --from=builder /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
COPY --from=builder /lib/x86_64-linux-gnu/libnsl.so.1 /lib/x86_64-linux-gnu/libnsl.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libssl.so.1.1 /lib/x86_64-linux-gnu/libssl.so.1.1
COPY --from=builder /lib/x86_64-linux-gnu/libcrypto.so.1.1 /lib/x86_64-linux-gnu/libcrypto.so.1.1
COPY --from=builder /lib/x86_64-linux-gnu/libdl.so.2 /lib/x86_64-linux-gnu/libdl.so.2
COPY --from=builder /lib/x86_64-linux-gnu/librt.so.1 /lib/x86_64-linux-gnu/librt.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu/libm.so.6
COPY --from=builder /lib/x86_64-linux-gnu/libpthread.so.0 /lib/x86_64-linux-gnu/libpthread.so.0
COPY --from=builder /lib/x86_64-linux-gnu/libcurl.so.4 /lib/x86_64-linux-gnu/libcurl.so.4
COPY --from=builder /lib/x86_64-linux-gnu/libstdc++.so.6 /lib/x86_64-linux-gnu/libstdc++.so.6
COPY --from=builder /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/libgcc_s.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6
COPY --from=builder /lib/x86_64-linux-gnu/libnghttp2.so.14 /lib/x86_64-linux-gnu/libnghttp2.so.14
COPY --from=builder /lib/x86_64-linux-gnu/libidn2.so.0 /lib/x86_64-linux-gnu/libidn2.so.0
COPY --from=builder /lib/x86_64-linux-gnu/librtmp.so.1 /lib/x86_64-linux-gnu/librtmp.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libssh.so.4 /lib/x86_64-linux-gnu/libssh.so.4
COPY --from=builder /lib/x86_64-linux-gnu/libpsl.so.5 /lib/x86_64-linux-gnu/libpsl.so.5
COPY --from=builder /lib/x86_64-linux-gnu/libssl.so.3 /lib/x86_64-linux-gnu/libssl.so.3
COPY --from=builder /lib/x86_64-linux-gnu/libcrypto.so.3 /lib/x86_64-linux-gnu/libcrypto.so.3
COPY --from=builder /lib/x86_64-linux-gnu/libgssapi_krb5.so.2 /lib/x86_64-linux-gnu/libgssapi_krb5.so.2
COPY --from=builder /lib/x86_64-linux-gnu/libldap-2.5.so.0 /lib/x86_64-linux-gnu/libldap-2.5.so.0
COPY --from=builder /lib/x86_64-linux-gnu/liblber-2.5.so.0 /lib/x86_64-linux-gnu/liblber-2.5.so.0
COPY --from=builder /lib/x86_64-linux-gnu/libzstd.so.1 /lib/x86_64-linux-gnu/libzstd.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libbrotlidec.so.1 /lib/x86_64-linux-gnu/libbrotlidec.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libunistring.so.2 /lib/x86_64-linux-gnu/libunistring.so.2
COPY --from=builder /lib/x86_64-linux-gnu/libgnutls.so.30 /lib/x86_64-linux-gnu/libgnutls.so.30
COPY --from=builder /lib/x86_64-linux-gnu/libhogweed.so.6 /lib/x86_64-linux-gnu/libhogweed.so.6
COPY --from=builder /lib/x86_64-linux-gnu/libnettle.so.8 /lib/x86_64-linux-gnu/libnettle.so.8
COPY --from=builder /lib/x86_64-linux-gnu/libgmp.so.10 /lib/x86_64-linux-gnu/libgmp.so.10
COPY --from=builder /lib/x86_64-linux-gnu/libkrb5.so.3 /lib/x86_64-linux-gnu/libkrb5.so.3
COPY --from=builder /lib/x86_64-linux-gnu/libk5crypto.so.3 /lib/x86_64-linux-gnu/libk5crypto.so.3
COPY --from=builder /lib/x86_64-linux-gnu/libcom_err.so.2 /lib/x86_64-linux-gnu/libcom_err.so.2
COPY --from=builder /lib/x86_64-linux-gnu/libkrb5support.so.0 /lib/x86_64-linux-gnu/libkrb5support.so.0
COPY --from=builder /lib/x86_64-linux-gnu/libsasl2.so.2 /lib/x86_64-linux-gnu/libsasl2.so.2
COPY --from=builder /lib/x86_64-linux-gnu/libbrotlicommon.so.1 /lib/x86_64-linux-gnu/libbrotlicommon.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libp11-kit.so.0 /lib/x86_64-linux-gnu/libp11-kit.so.0
COPY --from=builder /lib/x86_64-linux-gnu/libtasn1.so.6 /lib/x86_64-linux-gnu/libtasn1.so.6
COPY --from=builder /lib/x86_64-linux-gnu/libkeyutils.so.1 /lib/x86_64-linux-gnu/libkeyutils.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libresolv.so.2 /lib/x86_64-linux-gnu/libresolv.so.2
COPY --from=builder /lib/x86_64-linux-gnu/libffi.so.8 /lib/x86_64-linux-gnu/libffi.so.8

# Fetch dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install apt-utils -yqq && DEBIAN_FRONTEND=noninteractive apt-get install systemd-sysv tzdata sudo curl unzip screen net-tools gawk openssl findutils pigz libcurl4 libc6 libcrypt1 libcurl4-openssl-dev ca-certificates binfmt-support libssl3 nano -yqq

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

# Get qemu-user-static
RUN curl -o /scripts/qemu.deb -k -L $(apt-get download --print-uris qemu-user-static | cut -d"'" -f2); dpkg -x /scripts/qemu.deb /tmp; rm -rf /scripts/qemu.deb; cp -Rf /tmp/usr/libexec* /usr/libexec; cp -Rf /tmp/usr/share/binfmts /usr/share/binfmts; cp /tmp/usr/bin/qemu-x86_64-static /usr/bin/qemu-x86_64-static; rm -rf /tmp/*

# Set entrypoint to start.sh script
ENTRYPOINT ["/bin/bash", "/scripts/start.sh"]
