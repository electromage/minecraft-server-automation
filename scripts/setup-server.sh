# Initialize the Minecraft server
source scripts/config.env

# Create the directories
mkdir -p /opt/minecraft-server
mkdir -p /opt/spigot-buildtools
mkdir -p /var/backups/minecraft-server

# Create a new user
sudo useradd -m minecraft

# Set the password for the new user
sudo passwd -d minecraft

# Grant the new user access to the server directory
sudo chown -R minecraft:minecraft /opt/minecraft-server
sudo chown -R minecraft:minecraft /opt/spigot-buildtools

# Get the latest version of the Spigot BuildTools
cd /opt/spigot-buildtools
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar

# Install the unit file
sudo cp scripts/minecraft.service /etc/systemd/system/

# Reload systemd daemon
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable minecraft.service