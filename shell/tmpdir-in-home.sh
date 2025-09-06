#!/usr/bin/env bash

set -e

tmpdir="${HOME:?}/tmp.$(date +%y%m%d%H%M%S)-$(openssl rand -hex 8)"
mkdir -p "${tmpdir}"
echo -n "${tmpdir}"
