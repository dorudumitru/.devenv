#!/usr/bin/env bash

cp ~/.devenv/dotfiles/zsh/.zshrc ~/.devenv/dotfiles/zsh/.zshrc.backup
curl -fsSL https://opencode.ai/install | bash
rm ~/.devenv/dotfiles/zsh/.zshrc
mv ~/.devenv/dotfiles/zsh/.zshrc.backup ~/.devenv/dotfiles/zsh/.zshrc

echo -e "\nOpenCode installed successfully!"
