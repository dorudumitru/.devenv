#!/usr/bin/env bash

sudo dnf copr enable dejan/lazygit -y
sudo dnf install lazygit -y

echo -e "\nlazygit installed successfully!"
