#!/usr/bin/env bash

LAST="fast-syntax-highlighting"
deferred=()

for dir in */; do # list directories in the form "dirname/"
  dir=${dir%*/}   # remove the trailing "/"

  if [ "$dir" == "fast-syntax-highlighting" ]; then
    if [[ "$LAST" =~ $dir ]]; then
      deferred+=("$dir")
      continue
    fi
  elif [ "$dir" == "gitconfig" ]; then
    rm "$HOME/.gitconfig"
    stow -t "$HOME" "${dir##*/}"
    continue
  elif [ "$dir" == "zsh" ]; then
    rm "$HOME/.zshrc"
    stow -t "$HOME" "${dir##*/}"
    continue
  elif [ "$dir" == "ideavim" ]; then
    rm "$HOME/.ideavimrc"
    stow -t "$HOME" "${dir##*/}"
    continue
  elif [ "$dir" == "starship" ]; then
    rm "$HOME/.config/starship.toml"
    stow -t "$HOME" "${dir##*/}"
    continue
  elif [ "$dir" == "vscode-keybindings" ]; then
    rm "$HOME/.config/Code/User/keybindings.json"
    stow -t "$HOME" "${dir##*/}"
    continue
  elif [ "$dir" == "vscode-settings" ]; then
    rm "$HOME/.config/Code/User/settings.json"
    stow -t "$HOME" "${dir##*/}"
    continue
  elif [ "$dir" == "makefile-go" ]; then
    rm -rf "$HOME/Documents/Go"
    stow -t "$HOME" "${dir##*/}"
    continue
  elif [ "$dir" == "sdkman" ]; then
    rm "$HOME"/.sdkman/etc/config
    stow -t "$HOME" "${dir##*/}"
  elif [ "$dir" == "hypr" ]; then
    rm "$HOME"/.config/hypr/*.conf
    stow -t "$HOME" "${dir##*/}"
  fi

  rm -rf "$HOME"/.config/"${dir##*/}"
  stow -t "$HOME" "${dir##*/}"

done

for dir in "${deferred[@]}"; do
  if [ "$dir" == "fast-syntax-highlighting" ]; then
    rm "$HOME"/.oh-my-zsh/custom/plugins/fast-syntax-highlighting/themes/catppuccin-macchiato.ini
    stow -t "$HOME" "${dir##*/}"
    ZSH_COMMAND="
      FSH_PATH=\"$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting\"
      source \"$HOME/.oh-my-zsh/oh-my-zsh.sh\" 2>/dev/null
      source \"\$FSH_PATH/fast-syntax-highlighting.plugin.zsh\" 2>/dev/null
      fast-theme \"\$FSH_PATH/themes/catppuccin-macchiato\"
    "
    /usr/bin/env zsh -c "$ZSH_COMMAND"
    continue
  fi
done
