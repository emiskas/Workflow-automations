#!/bin/bash

# WATCH_DIR must target the directory where you want to watch for any changes
WATCH_DIR="/home/youruser/"

DEBOUNCE=3   # seconds to wait after a save before restarting

inotifywait -m -r -e close_write --format '%w%f' "$WATCH_DIR" |
while read -r file; do
    logger "Watcher detected change in $file"
    (
        sleep $DEBOUNCE
        systemctl restart gunicorn
        logger "Gunicorn restarted by watcher"
    ) &
done
