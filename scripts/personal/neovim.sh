#!/usr/bin/env bash

neovim_dir="$HOME/Downloads/neovim"
sudo dnf -y install ninja-build cmake gcc make gettext curl glibc-gconv-extra git
git clone --depth 1 https://github.com/neovim/neovim "$neovim_dir"

cd "$neovim_dir" || exit
# uncomment if you want the stable release
# git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
rm -rf "$neovim_dir"

echo -e "\nNeovim installed successfully!"
