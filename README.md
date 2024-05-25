# Minecraft Server Automation

This repository contains a set of scripts to automate the management of a Minecraft server. Currently this is designed around SpigotMC but could be tweaked to run the vanilla server easily.

## Installation

To install the Minecraft server automation scripts, follow these steps:

1. Clone this repository to your local machine:

    ```bash
    git clone https://github.com/mblank/minecraft-server-automation.git
    ```

2. Change into the project directory:

    ```bash
    cd minecraft-server-automation
    ```

3. Install the required dependencies:

    ```bash
    sudo apt update
    sudo apt install openjdk-21-jre tmux
    ```
4. (Optional) Edit variables in config/vars.env:

    ```bash
    MINECRAFT_DIR=/opt/minecraft-server
    SPIGOT_DIR=/opt/spigot-buildtools
    BACKUP_DIR=/var/backups/minecraft-server
    MINECRAFT_USER=minecraft
    BUILD_TOOLS_URL=https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
    SPIGOT_VERSION=latest
    ```

5. Run the server setup script:

    ```bash
    sudo ./setup-server.sh
    ```

This will:

- Create directories for the server and Spigot BuildTools
- Create a new minecraft user to run the server
- Install operational scripts to /opt/minecraft-server/scripts

## Usage

### Controlling the Minecraft Server

Start the Minecraft server: `systemctl start minecraft`

Stop it: `systemctl stop minecraft`

Check the status: `systemctl status minecraft`

View logged messages: `journalctl -u minecraft`

### Updating Spigot

Run `scripts/spigot-build.sh`, this will produce 