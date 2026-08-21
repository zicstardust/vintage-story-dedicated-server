#!/usr/bin/env bash

VERSION=$1

ARM64_PATCH_URL_BASE="https://github.com/anegostudios/VintagestoryServerArm64/releases/download"

if [[ "$VERSION" == 1.18* ]]; then
    ARM64_PATCH_URL="${ARM64_PATCH_URL_BASE}/1.18.8/vs_server_linux-arm64-1.18.tar.gz"
elif [[ "$VERSION" == 1.19* ]]; then
    ARM64_PATCH_URL="${ARM64_PATCH_URL_BASE}/1.19.0-rc.6/vs_server_linux-arm64-1.19.tar.gz"
elif [[ "$VERSION" == 1.20* ]]; then
    ARM64_PATCH_URL="${ARM64_PATCH_URL_BASE}/1.20.0-rc.8/vs_server_linux-arm64_1.20.0.tar.gz"
elif [[ "$VERSION" == 1.21* ]]; then
    ARM64_PATCH_URL="${ARM64_PATCH_URL_BASE}/1.21.0/vs_server_linux-arm64_1.21.0.tar.gz"
elif [[ "$VERSION" == 1.22* ]]; then
    ARM64_PATCH_URL="${ARM64_PATCH_URL_BASE}/1.22.0/vs_server_linux-arm64_1.22.0.tar.gz"
else
    echo "ARM64 version not yet compatible with this container."
    exit 1
fi

echo "Applying ARM64 patch..."
wget -q "$ARM64_PATCH_URL" -O "vs_server_linux-arm64.tar.gz"
tar xzf "vs_server_linux-arm64.tar.gz" --overwrite
rm -f "vs_server_linux-arm64.tar.gz"