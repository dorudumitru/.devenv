export GIT_EDITOR=nvim
export EDITOR=nvim
export MANPAGER="nvim +Man!"
export PATH=$PATH:$HOME/.local/bin
export ZSH="$HOME/.oh-my-zsh"
export SSH_AUTH_SOCK=$HOME/.bitwarden-ssh-agent.sock

ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX=true

plugins=(
	git
	zsh-autosuggestions
  fast-syntax-highlighting
	vi-mode
  direnv
)

source $ZSH/oh-my-zsh.sh

# functions
function idea { ( intellij "$@" & ) > /dev/null 2>&1 }

function tmux-ssh() {
  ssh "$1" -t -- /bin/sh -c 'tmux has-session && exec tmux attach || exec tmux'
}

function git-ssh() {
  if [[ "$1" == "work" ]]; then
    git config core.sshCommand "ssh -i $HOME/.ssh/work.pub"
    echo "Successfully configured \"Work\" ssh key for current repository"
  elif [[ "$1" == "hh" ]]; then
    git config core.sshCommand "ssh -i $HOME/.ssh/hh_enterprise.pub"
    echo "Successfully configured \"HH Enterprise\" ssh key for current repository"
  elif [[ "$1" == "personal" ]]; then
    git config core.sshCommand "ssh -i $HOME/.ssh/personal.pub"
    echo "Successfully configured \"Personal\" ssh key for current repository"
  else
    echo "Argument required: work | hh | personal"
  fi
}

# aliases
alias ls='eza --icons=auto --group-directories-first'
alias cat='bat'
alias vim='nvim'
alias ts='tmux-sessionizer'
alias ngp='new-go-project'
alias uao='unzip-and-open'
alias tssh='tmux-ssh'
alias lg='lazygit'
alias fp='. project-finder'
alias cato='cato-sdp'
alias yz='yazi'
alias oc='opencode'
alias cc='claude'
alias cx='codex'
alias visualvm='visualvm --fontsize 20'
alias stremio="flatpak run com.stremio.Stremio"

# open tmux sessionizer with <C-f>
bindkey -s "^f" "ts\n"

# remove annoying error when using ssh with kitty
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

# git-completion
autoload -Uz compinit && compinit

# starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh --cmd cd)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# go
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin

# .NET
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
export DOTNET_CLI_TELEMETRY_OPTOUT=true

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS=" \
--prompt '❯ '
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#8bd5ca,pointer:#ed8796 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=selected-bg:#494d64 \
--color=border:#8aadf4,label:#cad3f5"

# opencode
export PATH=/home/dorudumitru/.opencode/bin:$PATH

