#!/usr/bin/env bash

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$root_dir/lib/install.sh"

if is_fedora; then
  curl -1sLf -o /tmp/teams-for-linux.asc https://repo.teamsforlinux.de/teams-for-linux.asc
  sudo rpm --import /tmp/teams-for-linux.asc
  sudo curl -1sLf -o /etc/yum.repos.d/teams-for-linux.repo https://repo.teamsforlinux.de/rpm/teams-for-linux.repo
  install_packages teams-for-linux
else
  install_aur_packages teams-for-linux
fi

echo -e "\nMicrosoft Teams for Linux installed successfully!"
