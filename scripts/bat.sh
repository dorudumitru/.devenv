#!/usr/bin/env bash

sudo dnf install bat -y
rm -rf "$(bat --config-dir)"
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
bat cache --build
echo "--theme=\"Catppuccin Macchiato\"" >>"$(bat --config-dir)/config"
