#!/bin/bash
set -eux
export XDG_DATA_HOME="$(pwd)"
export XDG_CONFIG_HOME="$(pwd)"

function cleanup {
    rm -rf wowman/ cache/ etag-db.json config.json
}

if [ ! -d wowman ]; then
    git clone --single-branch --branch master https://github.com/ogri-la/wowman
fi
commit_message=""
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
    git commit -am "weekly full update"
else
    git commit -am "daily partial update"
fi

git push

cleanup
