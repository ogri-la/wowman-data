#!/bin/bash
set -eux
export XDG_DATA_HOME="$(pwd)"
export XDG_CONFIG_HOME="$(pwd)"

if [ ! -d wowman ]; then
    git clone --single-branch --branch develop https://github.com/ogri-la/wowman
else
    (
        cd wowman
        git reset --hard
        git pull
    )
fi

(
    cd wowman
    lein run - --action scrape-catalog
)

echo "$(date -I) complete catalog update" > commit-message.txt
cp full-catalog.json catalog.json
