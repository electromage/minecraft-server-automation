#!/bin/bash

source config/vars.env

# Create the directories
mkdir -p $MINECRAFT_DIR
mkdir -p $SPIGOT_DIR
mkdir -p $BACKUP_DIR

# Copy files to the server directory
cp -r scripts/ $MINECRAFT_DIR
cp -r config/ $MINECRAFT_DIR

# Create a new user if it doesn't already exist
if ! id -u minecraft >/dev/null 2>&1; then
    sudo useradd -m $MINECRAFT_USER
    # Set the password for the new user
    sudo passwd -d $MINECRAFT_USER
else
    echo "User $MINECRAFT_USER already exists."
fi

# Grant the new user access to the server directory
sudo chown -R $MINECRAFT_USER:$MINECRAFT_USER $MINECRAFT_DIR
sudo chown -R $MINECRAFT_USER:$MINECRAFT_USER $SPIGOT_DIR

# Build the Spigot server if spigot*.jar isn't already installed
if ! ls $MINECRAFT_DIR/spigot*.jar >/dev/null 2>&1; then
    bash scripts/spigot-build.sh
fi

# Install the unit file if it doesn't already exist
if [ ! -f /etc/systemd/system/minecraft.service ]; then
    sudo cp systemd/minecraft.service /etc/systemd/system/
    sudo chmod 644 /etc/systemd/system/minecraft.service
    sudo systemctl daemon-reload

else
    echo "/etc/systemd/system/minecraft.service already exists."
fi

if ! systemctl status minecraft.service >/dev/null 2>&1; then
    sudo systemctl enable minecraft.service
else
    echo "minecraft.service is already enabled."
fi

# Configure crontab for backups if not already configured
crontab -u $MINECRAFT_USER -l | grep -q '$MINECRAFT_DIR/scripts/backup.sh' || {
    (crontab -u $MINECRAFT_USER -l ; echo "0 2 * * * $MINECRAFT_DIR/scripts/backup.sh") | crontab -u $MINECRAFT_USER -
}

# Enable the service to start on boot if not already enabled

echo "Minecraft server initialized. Run 'sudo systemctl start minecraft' to start the server."
