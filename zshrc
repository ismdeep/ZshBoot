#!/usr/bin/env bash

#################### DO NOT EDIT THIS SECTION ####################
zshboot_root="${HOME}/ZshBoot"

if [ ! -d "${zshboot_root}" ]; then
  echo "[ERROR] directory not exists: ${zshboot_root}" && echo "[HINT] shell will exit after 10s ..." && sleep 10 && exit 1
fi

# export shell
export PATH="${zshboot_root}/shell:${PATH}"

# timezone
export TZ=Asia/Shanghai

# Language & LC_CTYPE
export LC_CTYPE=en_US.UTF-8

# disable auto update
DISABLE_AUTO_UPDATE="true"

# shellcheck disable=SC2034
export ZSH_DISABLE_COMPFIX=true

export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="ys"
plugins=(git zsh-autosuggestions)
source "${ZSH}/oh-my-zsh.sh"
TIMEFMT=$'\n================\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E'

# aliases
alias tmp='cd $(tmpdir-in-home.sh)'
alias gs="git status -u"
alias dateh="date +%Y-%m-%d-%H%M%S"
alias datetag="date '+%Y%m%d%H%M%S'"

# Load .zshboot_custom_rc
if [ -f "${HOME}/.zshboot_custom_rc" ]; then
  source "${HOME}/.zshboot_custom_rc"
else
  touch "${HOME}/.zshboot_custom_rc"
fi
#################### DO NOT EDIT THIS SECTION ####################
