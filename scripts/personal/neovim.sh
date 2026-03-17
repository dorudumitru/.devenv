#!/usr/bin/env bash

neovim_dir="$HOME/Downloads/neovim"
root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$root_dir/lib/install.sh"

if is_fedora; then
  install_packages ninja-build cmake gcc make gettext curl glibc-gconv-extra git
else
  install_packages base-devel cmake ninja gettext curl git
fi

git clone --depth 1 https://github.com/neovim/neovim "$neovim_dir"

cd "$neovim_dir" || exit
# uncomment if you want the stable release
# git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
rm -rf "$neovim_dir"

echo -e "\nNeovim installed successfully!"
