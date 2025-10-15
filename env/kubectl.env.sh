#!/usr/bin/env bash

if [ ! -f "${HOME}/.x98/runtime/kubectl-${1:?}/kubectl" ]; then
  kubectl_version="${1:?}" && \
  echo "$(date -R) [ INFO ] kubectl ${kubectl_version} is installing ..." && \
  rm -r -f "${HOME}/.x98/runtime/kubectl-${1:?}/" && \
  mkdir -p "${HOME}/.x98/runtime/kubectl-${1:?}/" && \
  # get download url
  download_url="" && \
  case $(uname -s)-$(uname -m) in
    Linux-amd64  | Linux-x86_64)   download_url="https://dl.k8s.io/release/${kubectl_version}/bin/linux/amd64/kubectl" ;;
    Linux-arm64  | Linux-aarch64)  download_url="https://dl.k8s.io/release/${kubectl_version}/bin/linux/arm64/kubectl" ;;
    Darwin-amd64 | Darwin-x86_64)  download_url="https://dl.k8s.io/release/${kubectl_version}/bin/darwin/amd64/kubectl" ;;
    Darwin-arm64 | Darwin-aarch64) download_url="https://dl.k8s.io/release/${kubectl_version}/bin/darwin/arm64/kubectl" ;;
    *) echo "[ERROR] unsupported platform: $(uname -s)-$(uname -m)"; return 0 ;;
  esac && \
  # download
  (
    cd "${HOME}/.x98/runtime/kubectl-${1:?}/" && \
    curl \
      --fail \
      --location \
      --output kubectl \
      "${download_url}" && \
    cp kubectl k && \
    chmod +x kubectl && \
    chmod +x k
  )
fi && \
export PATH="${HOME}/.x98/runtime/kubectl-${1:?}:${PATH}"