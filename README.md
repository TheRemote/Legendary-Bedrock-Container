# Legendary Bedrock Container - Minecraft Bedrock Dedicated Server for Docker
<img src="https://jamesachambers.com/wp-content/uploads/2022/05/Minecraft-Docker-Bedrock-1024x576.webp" alt="Legendary Minecraft Bedrock Container">

This is the Docker containerized version of my <a href="https://github.com/TheRemote/MinecraftBedrockServer" target="_blank" rel="noopener">Minecraft Bedrock Dedicated Server for Linux</a>.<br>
<br>
My <a href="https://jamesachambers.com/legendary-minecraft-bedrock-container/" target="_blank" rel="noopener">main blog article (and the best place for support) is here</a>.<br>
The <a href="https://github.com/TheRemote/Legendary-Bedrock-Container" target="_blank" rel="noopener">official GitHub repository is located here</a>.<br>
The <a href="https://hub.docker.com/r/05jchambers/legendary-bedrock-container" target="_blank" rel="noopener">official Docker Hub repository is located here</a>.<br>
<br>
The <a href="https://jamesachambers.com/minecraft-java-bedrock-server-together-geyser-floodgate/" target="_blank" rel="noopener">Java version of the container that has Geyser allowing Bedrock players to connect is here</a><br>
The <a href="https://github.com/TheRemote/Legendary-Java-Minecraft-Paper" target="_blank" rel="noopener">regular Java version of the Docker container is available here</a>.

<h2>Features</h2>
<ul>
  <li>Sets up the official Minecraft Bedrock Server (currently in alpha testing)</li>
  <li>Fully operational Minecraft Bedrock edition server in a couple of minutes</li>
  <li>Adds logging with timestamps to "logs" directory</li>
  <li>Multiarch Support - all Docker platforms supported including Raspberry Pi</li>
  <li>Automatic backups when container/server restarts</li>
  <li>Supports multiple instances -- you can run multiple Bedrock servers on the same system</li>
  <li>Updates automatically to the latest or user-defined version when server is started</li>
  <li>Files stored in named Docker volume allowing for extremely easy access/editing and leveraging more advanced Docker features such as automatic volume backups</li>
  <li><strong>*NEW*</strong> Uses Box64 for aarch64 (ARM 64 bit) for improved emulation speed due to box64's use of native syscalls where possible</li>
</ul>

<h2>Usage</h2>
First you must create a named Docker volume.  This can be done with:<br>
<pre>docker volume create yourvolumename</pre>

Now you may launch the server and open the ports necessary with one of the following Docker launch commands:<br>
<br>
With default ports:
<pre>docker run -it -v yourvolumename:/minecraft -p 19132:19132/udp -p 19132:19132 -p 19133:19133/udp -p 19133:19133 --restart unless-stopped 05jchambers/legendary-bedrock-container:latest</pre>
With custom ports:
<pre>docker run -it -v yourvolumename:/minecraft -p 12345:12345/udp -p 12345:12345 -p 12346:12346/udp -p 12346:12346 -e PortIPV4=12345 -e PortIPV6=12346 --restart unless-stopped 05jchambers/legendary-bedrock-container:latest</pre>
IPV4 only:
<pre>docker run -it -v yourvolumename:/minecraft -p 19132:19132/udp -p 19132:19132 --restart unless-stopped 05jchambers/legendary-bedrock-container:latest</pre>

<h2>Configuration / Accessing Server Files</h2>
The server data is stored where Docker stores your volumes.  This is typically a folder on the host OS that is shared and mounted with the container.<br>
You can find your exact path by typing: <pre>docker volume inspect yourvolumename</pre>  This will give you the fully qualified path to your volume like this:
<pre>{
        "CreatedAt": "2022-05-09T21:08:34-06:00",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/yourvolumename/_data",
        "Name": "yourvolumename",
        "Options": {},
        "Scope": "local"
    }</pre>
<br>
On Linux it's typically available at: <pre>/var/lib/docker/volumes/yourvolumename/_data</pre><br>
On Windows it's at <pre>C:\ProgramData\DockerDesktop</pre> but if you are using WSL (Windows Subsystem for Linux) it may be located at something more like <pre>\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes\</pre><br>
On Mac it's typically <pre>~/Library/Containers/com.docker.docker/Data/vms/0/</pre><br>
If you are using Docker Desktop on Mac then you need to access the Docker VM with the following command first:
<pre>screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty</pre>
You can then normally access the Docker volumes using the path you found in the first step with docker volume inspect<br><br>
Most people will want to edit server.properties.  You can make the changes to the file and then restart the container to make them effective.<br>
Backups of the Minecraft are server are created each time the server starts and are stored in the "backups" folder<br>
<br>
Log files with timestamps are stored in the "logs" folder.

<h2>Version Override</h2>
In some scenarios you may want to run a specific version of the Bedrock server.  That is now possible by using the "Version" environment variable: <pre>docker run -it -v yourvolumename:/minecraft -e Version=1.18.33.02 -p 19132:19132/udp -p 19132:19132 --restart unless-stopped 05jchambers/legendary-bedrock-container:latest</pre>
This is useful if Microsoft hasn't released versions of the client and dedicated server at the same time so you can match whichever version your players can connect with.

<h2>Clean Environment Variable</h2>
If the server is having trouble starting you can clean the downloads folder and force reinstallation of the latest version: <pre>docker run -it -v yourvolumename:/minecraft -e Clean=Y -p 19132:19132/udp -p 19132:19132 05jchambers/legendary-bedrock-container:latest</pre>

<h2>Disable Box64 (aarch64 only)</h2>
Box64 speeds up performance on 64-bit ARM platforms by translating some calls that are normally emulated as native system calls (much faster).  If you are having trouble running the dedicated server with Box64 support you can tell it to use QEMU instead with: <pre>-e UseQEMU=Y</pre>
For example: <pre>docker run -it -v yourvolumename:/minecraft -e UseQEMU=Y -p 19132:19132/udp -p 19132:19132 --restart unless-stopped 05jchambers/legendary-bedrock-container:latest</pre>

<h2>TZ (timezone) Environment Variable</h2>
You can change the timezone from the default "America/Denver" to own timezone using this environment variable: <pre>docker run -it -v yourvolumename:/minecraft -e TZ="America/Denver" -p 19132:19132/udp -p 19132:19132 05jchambers/legendary-bedrock-container:latest</pre>
A <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">list of Linux timezones is available here</a>

<h2>ScheduleRestart Environment Variable</h2>
You can schedule a restart by using the ScheduleRestart environment variable with a time in 24 hour format: <pre>docker run -it -v yourvolumename:/minecraft -e ScheduleRestart="03:30" -p 19132:19132/udp -p 19132:19132 --restart unless-stopped 05jchambers/legendary-bedrock-container:latest</pre>

<h2>NoPermCheck Environment Variable</h2>
You can skip the permissions check (can be slow on very large servers) with the NoPermCheck environment variable: <pre>docker run -it -v yourvolumename:/minecraft -e NoPermCheck="Y" -p 19132:19132/udp -p 19132:19132 --restart unless-stopped 05jchambers/legendary-bedrock-container:latest</pre>

<h2>Troubleshooting Note - Oracle Virtual Machines</h2>
A very common problem people have with the Oracle Virtual Machine tutorials out there that typically show you how to use a free VM is that the VM is much more difficult to configure than just about any other product / offering out there.<br>
The symptom you will have is that nobody will be able to connect.  This is not because of the second set of ports that it shows after startup (that is a nearly 3-4 years now old Bedrock bug and all servers do it).<br>
It is because there are several steps you need to take to open the ports on the Oracle VM.  You need to both:<br>
<ul>
  <li>Set the ingress ports (TCP/UDP) in the Virtual Cloud Network (VCN) security list</li>
  <li>*and* set the ingress ports in a Network Security Group assigned to your instance</li>
</ul><br>
Both of these settings are typically required before you will be able to connect to your VM instance.  This is purely configuration related and has nothing to do with the script or the Minecraft server itself.<br><br>
I do not recommend this platform due to the configuration difficulty but the people who have gone through the pain of configuring an Oracle VM have had good experiences with it after that point.  Just keep in mind it's going to be a rough ride through the configuration for most people.<br><br>
Here are some additional links:<br>
<ul>
<li>https://jamesachambers.com/official-minecraft-bedrock-dedicated-server-on-raspberry-pi/comment-page-8/#comment-13946</li>
<li>https://jamesachambers.com/minecraft-bedrock-edition-ubuntu-dedicated-server-guide/comment-page-53/#comment-13936</li>
<li>https://jamesachambers.com/minecraft-bedrock-edition-ubuntu-dedicated-server-guide/comment-page-49/#comment-13377</li>
<li>https://jamesachambers.com/legendary-minecraft-bedrock-container/comment-page-2/#comment-13706</li>
</ul>

<h2>Troubleshooting Note - Hyper-V</h2>
There is a weird bug in Hyper-V that breaks UDP connections on the Minecraft server.  There are two fixes for this.  The simplest fix is that you have to use a Generation 1 VM with the Legacy LAN network driver.<br>
See the following links:<br>
<ul>
<li>https://jamesachambers.com/minecraft-bedrock-edition-ubuntu-dedicated-server-guide/comment-page-54/#comment-13863</li>
<li>https://jamesachambers.com/minecraft-bedrock-edition-ubuntu-dedicated-server-guide/comment-page-56/#comment-14207</li>
</ul>
There is a second fix that was <a href="https://jamesachambers.com/legendary-minecraft-bedrock-container/comment-page-3/#comment-14654">shared by bpsimons here</a>.<br>You need to install ethtool first with sudo apt install ethtool.  Next in your /etc/network/interfaces file add "offload-tx off" to the bottom as the issue appears to be with TX offloading.<br>
Here's an example:<pre># The primary network interface
auto eth0
iface eth0 inet static
address 192.168.1.5
netmask 255.255.255.0
network 192.168.1.0
broadcast 192.168.1.255
gateway 192.168.1.1
offload-tx off</pre>
This can also be done non-persistently with the following ethtool command: <pre>ethtool -K eth0 tx off</pre>

<h2>Buy A Coffee / Donate</h2>
<p>People have expressed some interest in this (you are all saints, thank you, truly)</p>
<ul>
 <li>PayPal: 05jchambers@gmail.com</li>
 <li>Venmo: @JamesAChambers</li>
 <li>CashApp: $theremote</li>
 <li>Bitcoin (BTC): 3H6wkPnL1Kvne7dJQS8h7wB4vndB9KxZP7</li>
</ul>

<h2>Update History</h2>
<ul>
  <li>October 20th 2022</li>
    <ul>
      <li>Added new environment variable "NoPermCheck" to skip permissions check during startup</li>
      <li>Added new environment variable "ScheduleRestart" -- this schedules the container to shut down at a certain time which combined with the --restart switch gives daily reboot functionality</li>
    </ul>
  <li>September 27th 2022</li>
    <ul>
        <li>Fix SIGTERM catching in certain situations by running screen/java with the "exec" command which passes execution completely to that process (thanks vp-en)</li>
    </ul>
  <li>August 29th 2022</li>
    <ul>
      <li>Add TZ environment variable to set timezone</li>
      <li>Add environment variables to docker-compose.yml template</li>
    </ul>
  <li>August 22nd 2022</li>
    <ul>
      <li>Add NoScreen environment variable -- disables screen which prevents needing an interactive terminal (but disables some logging)</li>
    </ul>
  <li>August 12th 2022</li>
    <ul>
      <li>Enable "Content Log" in default server.properties which logs errors related to resource and behavior packs</li>
      <li>Add "Clean" environment variable to force cleaning and reinstallation of the bedrock server for troubleshooting/repair</li>
      <li>To use it specify -e Clean=Y on your Docker container launch command line</li>
    </ul>
  <li>August 10th 2022</li>
    <ul>
      <li>Add nano to have an editor while inside the container (for troubleshooting)</li>
    </ul>
  <li>August 2nd 2022</li>
    <ul>
      <li>Added experimental Box64 support for aarch64 -- speeds things up for 64-bit ARM users</li>
      <li>You must be running a 64-bit OS to benefit from the Box64 increased speeds (both Ubuntu and Raspberry Pi OS have 64-bit versions)</li>
      <li>An easy way to check and make sure you are running 64 bit is to use <pre>uname -m</pre> which will return "aarch64" if you are on 64-bit ARM</li>
      <li>If you are having trouble with Box64 (file an issue / leave me a comment on my site so I know about it) you can disable it by adding <pre>-e UseQEMU=Y</pre> to the command line to tell it to use QEMU instead of Box64</li>
    </ul>
  <li>July 14th 2022</li>
    <ul>
      <li>Added over a dozen new very recently introduced dependencies -- update container with docker pull 05jchambers/legendary-bedrock-container:latest to get new dependencies</li>
      <li>Updated from Ubuntu "Impish" to Ubuntu "Latest" base image as libssl3 is now linked in the bedrock_server dependencies</li>
    </ul>
  <li>July 13th 2022</li>
    <ul>
      <li>Update base Ubuntu image</li>
    </ul>
  <li>June 27th 2022</li>
    <ul>
      <li>Update base Ubuntu image</li>
    </ul>
  <li>Jun 11th 2022</li>
    <ul>
      <li>Added allowlist.json and permissions.json default template files to prevent crashes when they are missing</li>
    </ul>
  <li>Jun 7th 2022</li>
    <ul>
      <li>Add docker-compose.yml template for use with docker-compose</li>
    </ul>
  <li>Jun 2nd 2022</li>
    <ul>
      <li>Added a couple of path safety checks and more information about what paths are being used with Version environment variable</li>
    </ul>
  <li>May 31st 2022</li>
    <ul>
      <li>Added default server.properties file to prevent rare container launch issue</li>
    </ul>
  <li>May 27th 2022</li>
    <ul>
      <li>Cleaned up qemu-user-static installation</li>
    </ul>
  <li>May 26th 2022</li>
    <ul>
      <li>Fixed issue with new Version environment variable that could lead to it not working</li>
    </ul>
  <li>May 25th 2022</li>
    <ul>
      <li>Added Version environment variable.  Example: -e Version=1.19.10.20</li>
    </ul>
  <li>May 22nd 2022</li>
    <ul>
      <li>Fixed container launch issue on aarch64</li>
    </ul>
  <li>May 21st 2022</li>
    <ul>
      <li>Added multiarch Docker images</li>
      <li>Reduced image sizes</li>
    </ul>
  <li>May 17th 2022</li>
    <ul>
      <li>Bump Dockerfile base image to ubuntu:latest</li>
      <li>Add libssl1.1 manual installation baked into base image</li>
    </ul>
  <li>May 15th 2022</li>
    <ul>
        <li>Added screen -wipe to beginning of start.sh to prevent a startup issue that could occur if there was a "dead" screen instance (thanks grimholme, <a href="https://github.com/TheRemote/Legendary-Bedrock-Container/issues/2">issue #2</a>).</li>
    </ul>
  <li>May 12th 2022</li>
    <ul>
        <li>Added --platform=linux/amd64 to Dockerfile as on aarch64 platforms the container was not starting successfully without it (thanks Mootch, <a href="https://github.com/TheRemote/Legendary-Bedrock-Container/issues/1">issue #1</a>).</li>
    </ul>
  <li>May 9th 2022</li>
    <ul>
        <li>Initial release -- thanks to everyone who kept asking about it so I would finally put it together!</li>
    </ul>
</ul>