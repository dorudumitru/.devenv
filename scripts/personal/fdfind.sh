#!/usr/bin/env bash

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$root_dir/lib/install.sh"

install_packages fd

echo -e "\nfd installed successfully!"
