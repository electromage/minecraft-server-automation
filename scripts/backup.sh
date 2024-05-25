#!/bin/bash

# Set the source and backup directories
source_dir="/opt/minecraft-server"
backup_dir="/var/backups/minecraft-server"

# Create the backup directory if it doesn't exist
mkdir -p "$backup_dir"

# Get the current date
date=$(date +%Y%m%d)

# Iterate over the directories in the source directory
for dir in "$source_dir"/*; do
    # Check if it's a directory
    if [ -d "$dir" ]; then
        # Get the name of the directory
        dir_name=$(basename "$dir")

        # Create a new backup
        rsync -a "$dir" "$backup_dir/$dir_name-$date"
    fi
done

# Delete backups older than 7 days
find "$backup_dir" -type d -mtime +7 -exec rm -rf {} \;