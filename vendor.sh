#!/usr/bin/env bash

set -e

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

# Get to workdir
cd "$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"

download_package() {
  package_name="${1:?}"
  git_url="${2:?}"
  log_info "+ create tmpdir ..."
  tmpdir="$(mktemp -d)"
  log_info "+ git clone ${git_url} ..."
  (cd "${tmpdir:?}" && git clone "${git_url}")
  log_info "+ fetch last revision id ..."
  last_revision_id="$(cat "vendor/${package_name}.txt")"
  log_info "+ fetch current download revision id ..."
  download_revision_id="$(cd "${tmpdir}/${package_name}/" && git rev-parse HEAD)"
  if [ "${last_revision_id}" != "${download_revision_id}" ]; then
    log_info "+ compress ${package_name}.tar.xz ..."
    (cd "${tmpdir:?}" && tar -Jcf "${package_name}.tar.xz" "${package_name}/")
    log_info "+ copy ${package_name}.tar.xz to vendor ..."
    cp "${tmpdir:?}/${package_name}.tar.xz" "./vendor/${package_name}.tar.xz"
    echo "${download_revision_id}" | tee "vendor/${package_name}.txt"
  else
    log_info "+ skip compress and copy ${package_name}.tar.xz due revision id not changed."
  fi
}

task="${1:?}"

case ${task} in
all)
  bash vendor.sh ohmyzsh
  bash vendor.sh zsh-autosuggestions
  ;;
ohmyzsh)
  download_package "ohmyzsh" "https://github.com/ohmyzsh/ohmyzsh.git"
  ;;
zsh-autosuggestions)
  download_package "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
  ;;
*)
  log_error "invalid task: ${task}" && false
  ;;
esac