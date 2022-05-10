# Legendary Bedrock Container - Minecraft Bedrock Dedicated Server for Docker
This is the Docker containerized version of my <a href="https://github.com/TheRemote/MinecraftBedrockServer">Minecraft Bedrock Dedicated Server for Linux</a>.
 
<h3>Features</h3>
<ul>
  <li>Sets up the official Minecraft Bedrock Server (currently in alpha testing)</li>
  <li>Fully operational Minecraft Bedrock edition server in a couple of minutes</li>
  <li>Adds logging with timestamps to "logs" directory</li>
  <li>All Docker platforms supported</li>
  <li>Automatic backups when server restarts</li>
  <li>Supports multiple instances -- you can run multiple Bedrock servers on the same system</li>
  <li>Updates automatically to the latest version when server is started</li>
  <li>Easy control of server with start.sh, stop.sh and restart.sh scripts</li>
</ul>

<h3>Usage</h3>
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

<h3>Configuration / Accessing Server Files</h3>
The server data is stored where Docker stores your volumes.  This is typically a folder on the host OS that is shared and mounted with the container.  I'll give the usual locations here but if you're having trouble just do some Googling for your exact platform and you should find where Docker is storing the volume files.<br>
<br>
On Linux it's typically available at: <pre>/var/lib/docker/volumes/yourvolumename/_data</pre><br>
On Windows it's at <pre>C:\ProgramData\DockerDesktop</pre> but may be located at something more like <pre>\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes\</pre><br>if you are using WSL (Windows Subsystem for Linux)
<br>
<br>
On Mac it's typically <pre>~/Library/Containers/com.docker.docker/Data/vms/0/</pre><br>
Most people will want to edit server.properties.  You can make the changes to the file and then restart the container to make them effective.<br>
<br>
Backups are stored in the "backups" folder<br>
<br>
Log files with timestamps are stored in the "logs" folder.

<h3>Buy A Coffee / Donate</h3>
<p>People have expressed some interest in this (you are all saints, thank you, truly)</p>
<ul>
 <li>PayPal: 05jchambers@gmail.com</li>
 <li>Venmo: @JamesAChambers</li>
 <li>CashApp: $theremote</li>
 <li>Bitcoin (BTC): 3H6wkPnL1Kvne7dJQS8h7wB4vndB9KxZP7</li>
</ul>

<h3>Update History</h3>
<ul>
  <li>May 9th 2022</li>
    <ul>
        <li>Initial release -- thanks to everyone who kept asking about it so I would finally put it together!</li>
    </ul>
</ul>