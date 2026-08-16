#!/usr/bin/env bash

#Download Server
download_server.sh

if [ $? != 0 ]; then
    exit $?
fi

set -e

: "${PUID:=1000}"
: "${PGID:=1000}"

if [ "$(id -g vintagestory)" != "${PGID}" ]; then
    groupmod -o -g "${PGID}" vintagestory
fi


if [ "$(id -u vintagestory)" != "${PUID}" ]; then
    usermod -o -u "${PUID}" vintagestory
fi

mkdir -p /data

chown -R vintagestory:vintagestory /app /data

exec gosu vintagestory "$@"