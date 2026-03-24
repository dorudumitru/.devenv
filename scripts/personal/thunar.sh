#!/usr/bin/env bash

yay -S --needed --noconfirm thunar xdg-utils tumbler
xdg-mime default thunar.desktop inode/directory

echo -e "\nthunar installed successfully!"
