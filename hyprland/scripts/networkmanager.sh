#!/usr/bin/env bash

sudo dnf install -y NetworkManager NetworkManager-tui nm-connection-editor
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
