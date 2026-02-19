#!/usr/bin/env bash

mkdir -p "$HOME"/.ssh

rm "$HOME"/.ssh/hh_enterprise.pub
rm "$HOME"/.ssh/work.pub
rm "$HOME"/.ssh/personal.pub

ssh-add -L | grep "HH-Enterprise" >"$HOME"/.ssh/hh_enterprise.pub
ssh-add -L | grep "Work" >"$HOME"/.ssh/work.pub
ssh-add -L | grep "Personal" >"$HOME"/.ssh/personal.pub

chmod 644 "$HOME"/.ssh/hh_enterprise.pub
chmod 644 "$HOME"/.ssh/work.pub
chmod 644 "$HOME"/.ssh/personal.pub

cd ~/.devenv && git remote set-url origin git@github.com:dorudumitru/.devenv.git

echo -e "\nSSH public keys exported successfully!"
