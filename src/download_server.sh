#!/bin/bash

set -e

: "${VERSION:=stable}"


LEGACY_STABLE_URL="https://cdn.vintagestory.at/gamefiles/stable/vs_archive_"
STABLE_URL="https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_"
UNSTABLE_URL="https://cdn.vintagestory.at/gamefiles/unstable/vs_server_linux-x64_"

STABLE_JSON=$(wget -qO- https://api.vintagestory.at/stable.json)
LATEST_STABLE=$(echo "$STABLE_JSON" | jq -r 'keys_unsorted[0]')

UNSTABLE_JSON=$(wget -qO- https://api.vintagestory.at/unstable.json)
LATEST_UNSTABLE=$(echo "$UNSTABLE_JSON" | jq -r 'keys_unsorted[0]')



if [ "$VERSION" == "stable" ]; then
    VERSION="$LATEST_STABLE"
elif [ "$VERSION" == "unstable" ]; then
    VERSION="$LATEST_UNSTABLE"
fi


LEGACY_STABLE_FULL_URL="${LEGACY_STABLE_URL}${VERSION}.tar.gz"
STABLE_FULL_URL="${STABLE_URL}${VERSION}.tar.gz"
UNSTABLE_FULL_URL="${UNSTABLE_URL}${VERSION}.tar.gz"


if wget --spider -q "$STABLE_FULL_URL" 2>/dev/null; then
    DOWNLOAD_URL="$STABLE_FULL_URL"
    echo "Downloading Vintage Story Server version ${VERSION} from stable..."
    if [ "$VERSION" != "$LATEST_STABLE" ]; then
        echo "NOTE: You are running stable version ${VERSION} but version ${LATEST_STABLE} is available!"
    fi
elif wget --spider -q "$UNSTABLE_FULL_URL" 2>/dev/null; then
    DOWNLOAD_URL="$UNSTABLE_FULL_URL"
    echo "Downloading Vintage Story Server version ${VERSION} from unstable..."
    if [ "$VERSION" != "$LATEST_UNSTABLE" ]; then
        echo "NOTE: You are running unstable version ${VERSION} but version ${LATEST_UNSTABLE} is available!"
    fi
elif wget --spider -q "$LEGACY_STABLE_FULL_URL" 2>/dev/null; then
    DOWNLOAD_URL="$LEGACY_STABLE_FULL_URL"
    FILENAME="vs_archive_"
    echo "Downloading Vintage Story Server version ${VERSION} from legacy stable..."
else
    echo "ERROR: Version ${VERSION} not found in either stable or unstable channels"
    exit 1
fi


wget -q "$DOWNLOAD_URL"
tar xzf ${FILENAME:-vs_server_linux-x64_}${VERSION}.tar.gz
rm -f ${FILENAME:-vs_server_linux-x64_}${VERSION}.tar.gz


#install dotnet (or mono)
if awk "BEGIN {exit !($VERSION <= 1.17.12)}"; then
    DOTNET_VERSION="mono" download_dotnet.sh
elif awk "BEGIN {exit !($VERSION <= 1.20.12)}"; then
    DOTNET_VERSION="7.0.20" download_dotnet.sh
else
    download_dotnet.sh
fi

exit 0