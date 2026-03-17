#!/usr/bin/env bash

yay -S --needed --noconfirm docker docker-buildx docker-compose containerd

sudo systemctl enable --now docker
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker "$USER"

echo -e "\nDocker installed successfully! You must log out and back in for group changes to take effect."
