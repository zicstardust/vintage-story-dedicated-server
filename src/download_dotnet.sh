#!/bin/bash

set -e

: "${DOTNET_VERSION:=8.0.24}"


if [ "$DOTNET_VERSION" == "mono" ]; then
    echo "Downloading mono..."
    apt-get update  &> /dev/null
    apt-get install -y mono-complete &> /dev/null
else
    echo "Downloading .NET Runtime ${DOTNET_VERSION}..."
    apt-get update &> /dev/null
    apt-get install -y libc6 libgcc-s1 libgssapi-krb5-2 libicu76 libssl3 libstdc++6 zlib1g  &> /dev/null
    mkdir -p /opt/dotnet
    cd /opt/dotnet
    wget -q https://builds.dotnet.microsoft.com/dotnet/Runtime/${DOTNET_VERSION}/dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz
    tar xf dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz
    rm -f dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz
    ln -s /opt/dotnet/dotnet /usr/local/bin/dotnet
    cd /app
fi


apt-get -y autoremove &> /dev/null
apt-get -y autoclean &> /dev/null
apt-get -y clean &> /dev/null
rm -Rf /var/lib/apt/lists/*
