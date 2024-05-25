#!/bin/bash

source config/vars.env

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Get the current date
date=$(date +%Y%m%d)

# Create a new backup
rsync -a "$MINECRAFT_DIR/" "$BACKUP_DIR/minecraft-server-$date"

# Delete backups older than X days
find "$BACKUP_DIR" -maxdepth 1 -type d -mtime +$BACKUP_COPIES -exec rm -rf {} \;