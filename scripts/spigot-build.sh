#!/bin/bash

source config/env.sh

cd $SPIGOT_DIR

# Create the directories if they don't exist
mkdir -p "$SPIGOT_DIR"
mkdir -p "$MINECRAFT_DIR"

# Download BuildTools.jar if it doesn't exist
if [ ! -f "$SPIGOT_DIR/BuildTools.jar" ]; then
    wget -O "$SPIGOT_DIR/BuildTools.jar" https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
fi

# Run BuildTools.jar
java -jar "$SPIGOT_DIR/BuildTools.jar" --rev $SPIGOT_VERSION

# Copy the resulting jar file to the minecraft server directory
find "$SPIGOT_DIR" -name "spigot-*.jar" -type f -exec ls -t {} + | head -n 1 | xargs -I {} cp {} "$MINECRAFT_DIR"