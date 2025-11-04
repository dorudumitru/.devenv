#!/usr/bin/env bash

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf "$HOME"/.local/kitty.app/bin/kitty "$HOME"/.local/kitty.app/bin/kitten ~/.local/bin/
cp "$HOME"/.local/kitty.app/share/applications/kitty.desktop "$HOME"/.local/share/applications/
cp "$HOME"/.local/kitty.app/share/applications/kitty-open.desktop "$HOME"/.local/share/applications/
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" "$HOME"/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" "$HOME"/.local/share/applications/kitty*.desktop
echo 'kitty.desktop' >"$HOME"/.config/xdg-terminals.list
