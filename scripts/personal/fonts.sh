#!/usr/bin/env bash

TMP_DIR="/tmp/font_install"
INSTALL_DIR="$HOME/.local/share/fonts"
JB_API="https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest"
NERD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip"

for cmd in curl unzip fc-cache grep sed; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is required but not installed."
        exit 1
    fi
done

mkdir -p "$TMP_DIR"
mkdir -p "$INSTALL_DIR"

JB_ZIP_URL=$(curl -s "$JB_API" \
    | grep "browser_download_url.*zip" \
    | grep -v "Variable" \
    | head -n 1 \
    | cut -d '"' -f 4)

if [ -z "$JB_ZIP_URL" ]; then
    echo "Failed to detect latest JetBrains Mono release."
    exit 1
fi

curl -L "$JB_ZIP_URL" -o "$TMP_DIR/jb.zip"
unzip -o "$TMP_DIR/jb.zip" -d "$TMP_DIR/jb"
find "$TMP_DIR/jb" -type f -name "*.ttf" -exec cp {} "$INSTALL_DIR" \;

curl -L "$NERD_URL" -o "$TMP_DIR/nerd.zip"
unzip -o "$TMP_DIR/nerd.zip" -d "$TMP_DIR/nerd"
find "$TMP_DIR/nerd" -type f -name "*.ttf" -exec cp {} "$INSTALL_DIR" \;

fc-cache -f -v
rm -rf "$TMP_DIR"
