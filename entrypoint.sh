#!/bin/bash

#Download Server
download_server.sh

if [ $? != 0 ]; then
    exit $?
fi

set -e

: "${PUID:=1000}"
: "${PGID:=1000}"

if ! getent group vintagestory >/dev/null; then
    groupadd -g "$PGID" vintagestory
fi

if ! id -u vintagestory >/dev/null 2>&1; then
    useradd -m -u "$PUID" -g "$PGID" -s /sbin/nologin vintagestory
fi

mkdir -p /data

chown -R vintagestory:vintagestory /app /data

exec gosu vintagestory "$@"