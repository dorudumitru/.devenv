#!/usr/bin/env bash

wget -P "$HOME"/Downloads https://clientdownload.catonetworks.com/public/clients/cato-client-install.rpm
cd "$HOME"/Downloads || exit
sudo rpm -i cato-client-install.rpm
rm cato-client-install.rpm
