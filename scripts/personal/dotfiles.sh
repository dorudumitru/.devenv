#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
dotfiles_dir="$script_dir/../dotfiles"
cd "$dotfiles_dir" || exit
./stow.sh
