#!/usr/bin/env bash

if [[ $1 == "dnf" ]]; then
  sudo dnf -y install ninja-build cmake gcc make gettext curl glibc-gconv-extra git
elif [[ $1 == "pacman" ]]; then
  sudo pacman -S base-devel cmake ninja curl git
elif [[ $1 == "apt" ]]; then
  sudo apt install ninja-build gettext cmake curl build-essential git
fi

neovim_dir="$HOME/Downloads/neovim"
git clone --depth 1 https://github.com/neovim/neovim "$neovim_dir"

cd "$neovim_dir" || exit
# uncomment if you want the stable release
# git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
rm -rf "$neovim_dir"
