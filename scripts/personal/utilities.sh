#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
utilities_dir="$script_dir/../../utilities"
cd "$utilities_dir" || exit
./stow.sh
