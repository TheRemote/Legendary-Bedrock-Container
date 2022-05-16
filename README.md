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
  <li>All Docker platforms supported including Raspberry Pi</li>
  <li>Automatic backups when container/server restarts</li>
  <li>Supports multiple instances -- you can run multiple Bedrock servers on the same system</li>
  <li>Updates automatically to the latest version when server is started</li>
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
The server data is stored where Docker stores your volumes.  This is typically a folder on the host OS that is shared and mounted with the container.  I'll give the usual locations here but if you're having trouble just do some Googling for your exact platform and you should find where Docker is storing the volume files.<br>
<br>
On Linux it's typically available at: <pre>/var/lib/docker/volumes/yourvolumename/_data</pre><br>
On Windows it's at <pre>C:\ProgramData\DockerDesktop</pre> but if you are using WSL (Windows Subsystem for Linux) it may be located at something more like <pre>\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes\</pre><br>
On Mac it's typically <pre>~/Library/Containers/com.docker.docker/Data/vms/0/</pre><br>
Most people will want to edit server.properties.  You can make the changes to the file and then restart the container to make them effective.<br>
<br>
Backups are stored in the "backups" folder<br>
<br>
Log files with timestamps are stored in the "logs" folder.

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