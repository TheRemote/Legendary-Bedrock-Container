# Legendary Bedrock Container - Minecraft Bedrock Dedicated Server for Docker
This is the Docker containerized version of my <a href="https://github.com/TheRemote/MinecraftBedrockServer" target="_blank" rel="noopener">Minecraft Bedrock Dedicated Server for Linux</a>.<br>
<br>
My <a href="https://jamesachambers.com/legendary-minecraft-bedrock-container/" target="_blank" rel="noopener">main blog article (and the best place for support) is here</a>.<br>
The <a href="https://github.com/TheRemote/Legendary-Bedrock-Container" target="_blank" rel="noopener">official GitHub repository is located here</a>.<br>
The <a href="https://hub.docker.com/r/05jchambers/legendary-bedrock-container" target="_blank" rel="noopener">official Docker Hub repository is located here</a>.<br>
<br>
The <a href="https://github.com/TheRemote/Legendary-Java-Minecraft-Paper" target="_blank" rel="noopener">Java version of the Docker container is available here</a>.  This is for the Bedrock edition of Minecraft.<br>

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
</ul>

<h2>Usage</h2>
First you must create a named Docker volume.  This can be done with:<br>
<pre>docker volume create yourvolumename</pre>

Now you may launch the server and open the ports necessary with one of the following Docker launch commands:<br>
<br>
With default ports:
<pre>docker run -it -v yourvolumename:/minecraft -p 19132:19132/udp -p 19132:19132 -p 19133:19133/udp -p 19133:19133 05jchambers/legendary-bedrock-container:latest</pre>
With custom ports:
<pre>docker run -it -v yourvolumename:/minecraft -p 12345:12345/udp -p 12345:12345 -p 12346:12346/udp -p 12346:12346 -e PortIPV4=12345 -e PortIPV6=12346 05jchambers/legendary-bedrock-container:latest</pre>
IPV4 only:
<pre>docker run -it -v yourvolumename:/minecraft -p 19132:19132/udp -p 19132:19132 05jchambers/legendary-bedrock-container:latest</pre>

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
Most people will want to edit server.properties.  You can make the changes to the file and then restart the container to make them effective.<br>
<br>
Backups of the Minecraft are server are created each time the server starts and are stored in the "backups" folder<br>
<br>
Log files with timestamps are stored in the "logs" folder.

<h2>Version Override</h2>
In some scenarios you may want to run a specific version of the Bedrock server.  That is now possible by using the "Version" environment variable: <pre>docker run -it -v yourvolumename:/minecraft -e Version=1.18.33.02 -p 19132:19132/udp -p 19132:19132 05jchambers/legendary-bedrock-container:latest</pre>
This is useful if Microsoft hasn't released versions of the client and dedicated server at the same time so you can match whichever version your players can connect with.

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