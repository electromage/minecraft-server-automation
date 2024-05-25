#!/bin/bash

# Initialize the Minecraft server
source config/vars.env

# Create the directories
mkdir -p /opt/minecraft-server
mkdir -p /opt/spigot-buildtools
mkdir -p /var/backups/minecraft-server

# Create a new user if it doesn't already exist
if ! id -u minecraft >/dev/null 2>&1; then
    sudo useradd -m minecraft
    # Set the password for the new user
    sudo passwd -d minecraft
else
    echo "User minecraft already exists."
fi

# Grant the new user access to the server directory
sudo chown -R minecraft:minecraft /opt/minecraft-server
sudo chown -R minecraft:minecraft /opt/spigot-buildtools

# Get the latest version of the Spigot BuildTools
wget -O /opt/spigot-buildtools/BuildTools.jar "$BUILD_TOOLS_URL"

# Copy Scripts to the server directory
cp scripts/* /opt/minecraft-server

# Install the unit file if it doesn't already exist
if [ ! -f /etc/systemd/system/minecraft.service ]; then
    sudo cp scripts/minecraft.service /etc/systemd/system/
    sudo chmod 644 /etc/systemd/system/minecraft.service
    sudo systemctl daemon-reload

else
    echo "/etc/systemd/system/minecraft.service already exists."
fi

if ! systemctl is-enabled minecraft.service; then
    sudo systemctl enable minecraft.service
else
    echo "minecraft.service is already enabled."
fi

# Configure crontab for backups if not already configured
crontab -u minecraft -l | grep -q '/opt/minecraft-server/scripts/backup.sh' || {
    crontab -u minecraft -l > mycron
    echo "0 2 * * * /opt/minecraft-server/scripts/backup.sh" >> mycron
    crontab -u minecraft mycron
    rm mycron
}

# Enable the service to start on boot if not already enabled

echo "Minecraft server initialized. Run 'sudo systemctl start minecraft' to start the server."
