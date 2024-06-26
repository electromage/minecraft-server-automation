#!/bin/bash

# Set the source and backup directories
MINECRAFT_DIR="/opt/minecraft-server"
BACKUP_DIR="/var/backups/minecraft-server"

# Get a list of the available backups
backups=("$BACKUP_DIR"/*)
backup_names=()
for backup in "${backups[@]}"; do
    backup_names+=($(basename "$backup"))
done

# Generate a menu for the user to select a backup
echo "Please select a backup to restore:"
select backup_name in "${backup_names[@]}"; do
    # Check if the user's selection is valid
    if [[ -n $backup_name ]]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Ask for confirmation
read -p "Are you sure you want to restore the backup from $backup_name? This will overwrite the current server directory. (y/n): " confirm
confirm=${confirm,,}  # tolower

if [[ $confirm =~ ^(yes|y)$ ]]; then
    # Stop the Minecraft server
    echo "Stopping Minecraft server..."
    systemctl stop minecraft

    # Restore the backup
    echo "Restoring backup..."
    rsync -a --delete "$BACKUP_DIR/$backup_name/" "$MINECRAFT_DIR/"
    echo "Backup restored."

    # Start the Minecraft server
    echo "Starting Minecraft server..."
    systemctl start minecraft
else
    echo "Restore cancelled."
fi