#!/usr/bin/env bash

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$root_dir/lib/install.sh"

if is_fedora; then
  curl -L -o /tmp/bitwarden.rpm "https://bitwarden.com/download/?app=desktop&platform=linux&variant=rpm"
  sudo dnf install -y /tmp/bitwarden.rpm
  rm /tmp/bitwarden.rpm
else
  install_packages bitwarden
fi

echo -e "\nBitwarden installed successfully!"
