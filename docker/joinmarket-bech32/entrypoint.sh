#!/bin/bash
set -e

JM_HOME=/home/joinmarket

# Create data directory
mkdir -p "$JM_HOME"/.joinmarket
chown joinmarket: "$JM_HOME"/.joinmarket

# Create tumbler logs directory
#mkdir -p "$JM_HOME"/.joinmarket/tumbler_logs
#chown joinmarket: "$JM_HOME"/.joinmarket/tumbler_logs

# Create config file if it doesn't already exist
if [ ! -f "$JM_HOME/.joinmarket/joinmarket.cfg" ]; then
    envsubst < /tmp/joinmarket.cfg > "$JM_HOME"/.joinmarket/joinmarket.cfg
    chown joinmarket: "$JM_HOME"/.joinmarket/joinmarket.cfg
fi

# Change local user id and group
if [ -n "${LOCAL_USER_ID}" ]; then
    usermod -u "$LOCAL_USER_ID" joinmarket
fi
if [ -n "${LOCAL_GROUP_ID}" ]; then
    groupmod -g "$LOCAL_GROUP_ID" joinmarket
fi

# Run command as joinmarket user
cd /jm/clientserver/scripts
exec gosu joinmarket bash -c "$*"
