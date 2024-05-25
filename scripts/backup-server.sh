#!/bin/bash

# Set the source and backup directories
source_dir="/opt/minecraft-server"
backup_dir="/var/backups/minecraft-server"

# Create the backup directory if it doesn't exist
mkdir -p "$backup_dir"

# Get the current date
date=$(date +%Y%m%d)

# Create a new backup
rsync -a "$source_dir/" "$backup_dir/minecraft-server-$date"

# Delete backups older than 7 days
find "$backup_dir" -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \;