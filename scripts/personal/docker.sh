#!/usr/bin/env bash

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$root_dir/lib/install.sh"

if is_fedora; then
  remove_packages \
    docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine || true

  install_packages dnf-plugins-core
  sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
  install_packages docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
  install_packages docker docker-buildx docker-compose containerd
fi

enable_now_service docker
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker "$USER"

echo -e "\nDocker installed successfully! You must log out and back in for group changes to take effect."
