#!/usr/bin/env bash

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$root_dir/lib/install.sh"

if is_fedora; then
  sudo dnf copr enable dejan/lazygit -y
fi

install_packages lazygit

echo -e "\nlazygit installed successfully!"
