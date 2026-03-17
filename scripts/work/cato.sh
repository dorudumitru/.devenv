#!/usr/bin/env bash

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$root_dir/lib/install.sh"

if is_arch; then
  devenv_fail "Cato client installation is not supported on Arch by this repo."
fi

wget -P "$HOME"/Downloads https://clientdownload.catonetworks.com/public/clients/cato-client-install.rpm
cd "$HOME"/Downloads || exit
sudo rpm -i cato-client-install.rpm
rm cato-client-install.rpm
