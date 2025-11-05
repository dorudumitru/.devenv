#!/usr/bin/env bash

GO_VERSION=$(curl -s "https://go.dev/VERSION?m=text" | head -n 1)
DOWNLOAD_URL="https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"

sudo rm -rf /usr/local/go
wget -q "$DOWNLOAD_URL" -O /tmp/go.tar.gz
sudo tar -C /usr/local -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz
