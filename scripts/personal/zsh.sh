#!/usr/bin/env bash

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
source "$root_dir/lib/install.sh"

if is_fedora; then
  install_packages zsh util-linux-user
else
  install_packages zsh util-linux
fi

# sudo chsh "$USER"
# sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

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
  sudo chsh -s /bin/zsh "$USER"
fi

echo -e "\nZsh and Oh My Zsh installed successfully!"
