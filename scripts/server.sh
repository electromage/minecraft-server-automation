#!/bin/bash

# Get the latest spigot*.jar file
SPIGOT_JAR=$(find . -maxdepth 1 -name 'spigot*.jar' -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)

case $1 in
  start)
    /usr/bin/tmux new-session -d -s minecraft "/usr/bin/java -Xmx1024M -Xms1024M -jar $SPIGOT_JAR nogui"
    ;;
  stop)
    if /usr/bin/tmux has-session -t minecraft 2>/dev/null; then
      /usr/bin/tmux send-keys -t minecraft 'say SERVER SHUTTING DOWN.' Enter 'stop' Enter
    fi
    ;;
esac
