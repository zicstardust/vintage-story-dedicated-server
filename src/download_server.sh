#!/usr/bin/env bash

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

CONTAINER_ARCH=$(uname -m)

if [ "$CONTAINER_ARCH" = "aarch64" ]; then
    if awk "BEGIN {exit !($VERSION < 1.18.15)}"; then
        echo "ERROR: Version $VERSION is not compatible with ARM64; please run version 1.18.15 or higher."
        exit 1
    fi
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
    echo "Downloading Vintage Story Server version ${VERSION} from legacy stable..."
else
    echo "ERROR: Version ${VERSION} not found in either stable or unstable channels"
    exit 1
fi


wget -q "$DOWNLOAD_URL" -O "vs_server_linux.tar.gz"
tar xzf vs_server_linux.tar.gz
rm -f vs_server_linux.tar.gz


if [ "$CONTAINER_ARCH" = "aarch64" ]; then
    server_arm64_config.sh $VERSION
fi

#install dotnet (or mono)
#1.17.12 - Mono
#1.20.12 - .NET 7
#1.21.X - .NET 8
#1.22.X - .NET 10
if awk "BEGIN {exit !($VERSION <= 1.17.12)}"; then
    download_dotnet.sh "mono" $CONTAINER_ARCH
elif awk "BEGIN {exit !($VERSION <= 1.20.12)}"; then
    download_dotnet.sh "7.0" $CONTAINER_ARCH
elif [[ "$VERSION" == 1.21* ]]; then
    download_dotnet.sh "8.0" $CONTAINER_ARCH
else
    download_dotnet.sh "10.0" $CONTAINER_ARCH
fi

exit 0
