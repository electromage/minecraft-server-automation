#!/bin/bash

# Set the paths
buildtools_dir="/opt/spigot-buildtools"
minecraft_server_dir="/opt/minecraft-server"
log_file="/var/log/spigot-build.log"

# Create the directories if they don't exist
mkdir -p "$buildtools_dir"
mkdir -p "$minecraft_server_dir"

# Download BuildTools.jar if it doesn't exist
if [ ! -f "$buildtools_dir/BuildTools.jar" ]; then
    wget -O "$buildtools_dir/BuildTools.jar" https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar >> "$log_file" 2>&1
fi

# Run BuildTools.jar
java -jar "$buildtools_dir/BuildTools.jar" --rev latest >> "$log_file" 2>&1

# Copy the resulting jar file to the minecraft server directory
cp "$buildtools_dir/spigot-*.jar" "$minecraft_server_dir" >> "$log_file" 2>&1