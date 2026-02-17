#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
dotfiles_dir="$script_dir/../../dotfiles"
sudo dnf install stow -y
cd "$dotfiles_dir" || exit
./stow.sh
