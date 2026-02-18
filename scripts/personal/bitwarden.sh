#!/usr/bin/env bash

curl -L -o /tmp/bitwarden.rpm "https://bitwarden.com/download/?app=desktop&platform=linux&variant=rpm"
sudo dnf install -y /tmp/bitwarden.rpm
rm /tmp/bitwarden.rpm
