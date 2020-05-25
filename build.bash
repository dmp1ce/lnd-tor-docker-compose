#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Create .env if it doesn't exist already
if [ ! -f "$DIR/.env" ]; then
    echo ".env does not exist"
else
    echo ".env does exist"
fi

# Get list of overrides
OVERRIDE_OPTIONS=()
shopt -s nullglob
for f in "$DIR/overrides"/*.yml
do
    OVERRIDE_OPTIONS+=(-f)
    OVERRIDE_OPTIONS+=("$f")
done

docker-compose -f docker-compose.yml "${OVERRIDE_OPTIONS[@]}" build --pull \
               --build-arg LOCAL_USER_ID="$(id -u "$USER")" \
               --build-arg LOCAL_GROUP_ID="$(id -g "$USER")"
