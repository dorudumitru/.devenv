#!/usr/bin/env bash

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$root_dir/lib/install.sh"

if is_fedora; then
  sudo dnf copr enable erikreider/SwayNotificationCenter -y
  install_packages SwayNotificationCenter
else
  install_packages swaync
fi
