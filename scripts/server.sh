#!/bin/bash

case $1 in
  start)
    /usr/bin/tmux new-session -d -s minecraft '/usr/bin/java -Xmx1024M -Xms1024M -jar server.jar nogui'
    ;;
  stop)
    if /usr/bin/tmux has-session -t minecraft 2>/dev/null; then
      /usr/bin/tmux send-keys -t minecraft 'say SERVER SHUTTING DOWN.' Enter 'stop' Enter
    fi
    ;;
esac