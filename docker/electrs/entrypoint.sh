#!/bin/sh
set -e

# Create config file if it doesn't already exist
if [ ! -f "/home/user/.electrs/config.toml" ]; then
    envsubst < /tmp/electrs.toml > /home/user/.electrs/config.toml
fi

# Change local user id and group
if [ -n "${LOCAL_USER_ID}" ]; then
    usermod -u "$LOCAL_USER_ID" user
fi
if [ -n "${LOCAL_GROUP_ID}" ]; then
    groupmod -g "$LOCAL_GROUP_ID" user
fi

# Fix ownership
chown -R user /home/user/.electrs

# Start electrs
exec sudo -u user "$@"
