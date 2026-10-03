#!/usr/bin/env bash

set -e
set -o pipefail
set -u

if [[ "${TERM}" =~ ^(xterm|screen|vt100) ]]; then
  log_debug()   { echo -e "$(date '+%Y-%m-%d %H:%M:%S %z') [ \033[34mDEBUG\033[0m ] $*"    ; }
  log_info()    { echo -e "$(date '+%Y-%m-%d %H:%M:%S %z') [ \033[36mINFO\033[0m  ] $*"    ; }
  log_success() { echo -e "$(date '+%Y-%m-%d %H:%M:%S %z') [ \033[32mOK\033[0m    ] $*"    ; }
  log_warn()    { echo -e "$(date '+%Y-%m-%d %H:%M:%S %z') [ \033[33mWARN\033[0m  ] $*" >&2; }
  log_error()   { echo -e "$(date '+%Y-%m-%d %H:%M:%S %z') [ \033[31mERROR\033[0m ] $*" >&2; }
else
  log_debug()   { echo -e "$(date '+%Y-%m-%d %H:%M:%S %z') [ DEBUG ] $*"    ; }
  log_info()    { echo -e "$(date '+%Y-%m-%d %H:%M:%S %z') [ INFO  ] $*"    ; }
  log_success() { echo -e "$(date '+%Y-%m-%d %H:%M:%S %z') [ OK    ] $*"    ; }
  log_warn()    { echo -e "$(date '+%Y-%m-%d %H:%M:%S %z') [ WARN  ] $*" >&2; }
  log_error()   { echo -e "$(date '+%Y-%m-%d %H:%M:%S %z') [ ERROR ] $*" >&2; }
fi

command_check() {
  command_name="${1:?}" && \
  if ! command -v "${command_name}" >/dev/null 2>&1; then
    echo "[ERROR] command required: ${command_name}" && false
  fi
}

command_check rsync
command_check tar
command_check xz
command_check zsh

cd "$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"

task="${1:-"all"}"
case ${task} in
all)
  bash install.sh ohmyzsh
  bash install.sh zsh-autosuggestions
  bash install.sh zshboot
  bash install.sh zshrc
  ;;
ohmyzsh)
  log_info "+ create tmpdir ..."
  tmpdir="$(mktemp -d)"
  log_info "+ uncompress ohmyzsh.tar.xz ..."
  cp "./vendor/ohmyzsh.tar.xz" "${tmpdir:?}/"
  (cd "${tmpdir:?}/" && tar -Jxf ohmyzsh.tar.xz)
  log_info "+ copy ohmyzsh to ${HOME}/.oh-my-zsh/ ..."
  mkdir -p "${HOME}/.oh-my-zsh/"
  rsync -a -r --no-owner --no-group --no-perms --delete \
    "${tmpdir:?}/ohmyzsh/" \
    "${HOME}/.oh-my-zsh/"
  ;;
zsh-autosuggestions)
  log_info "+ create tmpdir ..."
  tmpdir="$(mktemp -d)"
  log_info "+ uncompress zsh-autosuggestions.tar.xz ..."
  mkdir -p "${HOME}/.oh-my-zsh/custom/plugins/"
  cp "./vendor/zsh-autosuggestions.tar.xz" "${tmpdir:?}/"
  (cd "${tmpdir:?}/" && tar -Jxf zsh-autosuggestions.tar.xz)
  log_info "+ copy zsh-autosuggestions to ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions/ ..."
  rsync -a -r --no-owner --no-group --no-perms --delete \
    "${tmpdir:?}/zsh-autosuggestions/" \
    "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions/"
  ;;
zshboot)
  if [ "$(pwd)" != "${HOME:?}/ZshBoot" ]; then
    log_info "+ copy ZshBoot to ${HOME:?}/ZshBoot/ ..."
    rsync -a -r --no-owner --no-group --no-perms --delete \
      ./ \
      "${HOME:?}/ZshBoot/"
  else
    log_info "skip copy ZshBoot to ${HOME:?}/ZshBoot/ due source directory and target directory are same."
  fi
  ;;
zshrc)
  log_info "+ copy zshrc to ${HOME}/.zshrc ..."
  cp zshrc "${HOME}/.zshrc"
  log_info "+ check zsh config ..."
  zsh -l -i -c 'uname -a'
  echo ""
  echo ""
  echo "HINT: Follow these command to change shell."
  echo ""
  if [ "$(whoami)" == "root" ]; then
    echo "  $ chsh -s $(command -v zsh)"
  else
    echo "  $ sudo usermod -s $(command -v zsh) $(whoami)"
    echo "  $ chsh -s $(command -v zsh)"
  fi
  echo ""
  ;;
*)
  log_error "invalid task: ${task}" && false
  ;;
esac
