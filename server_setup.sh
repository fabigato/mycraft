#!/bin/bash

MINECRAFTSERVERURL=$1


# Download Java
sudo yum install -y java-21-amazon-corretto-headless
# Install MC Java server in a directory we create
adduser minecraft
mkdir /opt/minecraft/
mkdir /opt/minecraft/server/
cd /opt/minecraft/server

# Download server jar file from Minecraft official website
wget $MINECRAFTSERVERURL

# Generate Minecraft server files and create script
chown -R minecraft:minecraft /opt/minecraft/
mv server.jar server_name.jar  # useful name used to identify the process
java -Xmx5120M -Xms2048M -jar server_name.jar nogui
sleep 40
sed -i 's/false/true/p' eula.txt
touch start
printf '#!/bin/bash\njava -Xmx5120M -Xms2048M -jar server_name.jar nogui\n' >> start
chmod +x start
sleep 1
touch stop
printf '#!/bin/bash\nkill -9 $(ps -ef | pgrep -f "server_name")' >> stop
chmod +x stop
sleep 1

# Create SystemD Script to run Minecraft server jar on reboot
cd /etc/systemd/system/
touch minecraft.service
printf '[Unit]\nDescription=Minecraft Server on start up\nWants=network-online.target\n[Service]\nUser=minecraft\nWorkingDirectory=/opt/minecraft/server\nExecStart=/opt/minecraft/server/start\nStandardInput=null\n[Install]\nWantedBy=multi-user.target' >> minecraft.service
# Systemctl Minecraft.service heeft de wanted by = multi-user.target lijn.
# Dat is de requirement om dit service te starten. Die target is zoals system level 3:
# netwerk aan, login aan maar geen gui. Binnen folder multi-user.target.wants staat een
# link naar je service. Dat geeft aan dat je service moet starten bij level 3 status.
# Zonder dat wants, start je service niet (tenzij een andere wanted service heeft
# het als dependency)
sudo systemctl daemon-reload
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service

# End script