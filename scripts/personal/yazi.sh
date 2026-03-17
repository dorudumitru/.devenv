#!/usr/bin/env bash

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$root_dir/lib/install.sh"

if is_fedora; then
  sudo dnf copr enable lihaohong/yazi -y
fi

install_packages yazi

echo -e "\nyazi installed successfully!"
