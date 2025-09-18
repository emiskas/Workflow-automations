#!/bin/bash
WATCH_DIR="/home/youruser/projects"

inotifywait -m -r -e close_write --format '%w%f' "$WATCH_DIR" |
while read -r file; do
    if [[ "$file" == *.py ]]; then
        echo "Restarting Gunicorn because $file changed"
        sudo systemctl restart gunicorn
    fi
done
