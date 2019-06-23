#!/bin/bash
set -eux
export XDG_DATA_HOME="$(pwd)"
export XDG_CONFIG_HOME="$(pwd)"

if [ ! -d wowman ]; then
    git clone --single-branch --branch master https://github.com/ogri-la/wowman
fi
(
    cd wowman
    echo "starting wowman ..."
    if [ "$(date +%A)" = "Monday" ]; then
        echo "complete scrape"
        lein run - --action scrape-catalog
    else
        echo "just the updates"
        lein run - --action update-catalog
    fi
)

if [ "$(date +%A)" = "Monday" ]; then
    echo "weekly full update" > commit-message.txt
else
    echo "daily partial update" > commit-message.txt
fi
