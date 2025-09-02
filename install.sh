#!/usr/bin/env bash

set -e
set -o pipefail
set -u

cd "$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"

command_check() {
  command_name="${1:?}" && \
  if ! command -v "${command_name}" >/dev/null 2>&1; then
    echo "[ERROR] command required: ${command_name}" && false
  fi
}

command_check xz
command_check zsh
command_check tar

if [ ! -d "${HOME}/.oh-my-zsh/" ]; then
  tmpdir="$(mktemp -d)"
  cp "./build/ohmyzsh.tar.xz" "${tmpdir:?}/"
  (cd "${tmpdir:?}/" && < ohmyzsh.tar.xz xz -cdk - | tar -x)
  mv "${tmpdir:?}/ohmyzsh/" "${HOME}/.oh-my-zsh/"
fi

if [ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions/" ]; then
  mkdir -p "${HOME}/.oh-my-zsh/custom/plugins/"
  tmpdir="$(mktemp -d)"
  cp "./build/zsh-autosuggestions.tar.xz" "${tmpdir:?}/"
  (cd "${tmpdir:?}/" && < zsh-autosuggestions.tar.xz xz -cdk - | tar -x)
  mv "${tmpdir:?}/zsh-autosuggestions/" "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions/"
fi

if [ ! -f "${HOME}/.zshrc" ]; then
  ln -s "$(pwd)/zshrc" "${HOME}/.zshrc"
fi

echo "HINT: $ chsh -s /usr/bin/zsh"

zsh -l -i -c 'uname -a'
