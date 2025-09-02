#!/usr/bin/env bash

#################### DO NOT EDIT THIS SECTION ####################
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

# Load .zshboot_custom_rc
if [ -f "${HOME}/.zshboot_custom_rc" ]; then
  source "${HOME}/.zshboot_custom_rc"
fi
#################### DO NOT EDIT THIS SECTION ####################
