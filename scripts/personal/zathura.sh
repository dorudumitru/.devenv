#!/usr/bin/env bash

yay -S --needed --noconfirm zathura zathura-pdf-mupdf
xdg-mime default org.pwmt.zathura.desktop application/pdf

echo -e "\nzathura installed successfully!"
