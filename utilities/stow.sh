#!/usr/bin/env bash

for dir in */; do # list directories in the form "dirname/"
  dir=${dir%*/}   # remove the trailing "/"

  rm "$HOME"/.local/bin/"${dir##*/}"
  stow -t "$HOME" "${dir##*/}"

done
