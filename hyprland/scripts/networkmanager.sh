#!/usr/bin/env bash

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$root_dir/lib/install.sh"

if is_fedora; then
  install_packages NetworkManager NetworkManager-tui nm-connection-editor
else
  install_packages networkmanager nm-connection-editor
fi

enable_service NetworkManager
start_service NetworkManager
