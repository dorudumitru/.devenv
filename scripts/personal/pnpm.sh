#!/usr/bin/env bash

cp ~/.devenv/dotfiles/zsh/.zshrc ~/.devenv/dotfiles/zsh/.zshrc.backup
curl -fsSL https://get.pnpm.io/install.sh | sh -
rm ~/.devenv/dotfiles/zsh/.zshrc
mv ~/.devenv/dotfiles/zsh/.zshrc.backup ~/.devenv/dotfiles/zsh/.zshrc

echo -e "\npnpm installed successfully!"
