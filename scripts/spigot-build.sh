#!/bin/bash

source config/vars.env

# Check if the script is being run with sudo
if [ "$EUID" -ne 0 ]; then
    # If the script is not being run with sudo, check if $SPIGOT_DIR is writable by the current user
    if [ ! -w "$SPIGOT_DIR" ]; then
        echo "$SPIGOT_DIR is not writable. Please run the script with sudo or check the permissions."
        exit 1
    fi
fi

cd $SPIGOT_DIR

# Create the directories if they don't exist
mkdir -p "$SPIGOT_DIR"
mkdir -p "$MINECRAFT_DIR"
chown -R minecraft:minecraft "$SPIGOT_DIR"

# Download BuildTools.jar if it doesn't exist
if [ ! -f "$SPIGOT_DIR/BuildTools.jar" ]; then
    wget -O "$SPIGOT_DIR/BuildTools.jar" https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
fi

# Run BuildTools.jar
java -jar "$SPIGOT_DIR/BuildTools.jar" --rev $SPIGOT_VERSION

# Copy the resulting jar file to the minecraft server directory
find "$SPIGOT_DIR" -name "spigot-*.jar" -type f -exec ls -t {} + | head -n 1 | xargs -I {} cp {} "$MINECRAFT_DIR"