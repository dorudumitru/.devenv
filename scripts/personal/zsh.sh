#!/usr/bin/env bash

yay -S --needed --noconfirm zsh

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME"/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$HOME"/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
else
  echo "Oh My Zsh already installed. Skipping..."
fi

if [ "$SHELL" != "/bin/zsh" ]; then
  echo "Setting zsh as default shell..."
  sudo chsh -s "$(which zsh)"
fi

echo -e "\nZsh and Oh My Zsh installed successfully!"
