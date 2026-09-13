#!/usr/bin/env bash

yay -S --needed --noconfirm python-pipx
pipx install sqlit-tui

echo -e "\nsqlit installed successfully!"
