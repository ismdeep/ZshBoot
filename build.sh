#!/usr/bin/env bash

set -e

build_tag="${GIT_TAG:?}"

safe_tag="${build_tag//\//-}"

rm    -r -f ./build/ZshBoot/
mkdir -p    ./build/ZshBoot/
rsync -a -r --no-i-r -i --no-owner --no-group --no-perms \
  --exclude=/.git/ \
  --exclude=/.github/ \
  --exclude=/.gitignore \
  --exclude=/.idea/ \
  --exclude=/Makefile \
  --exclude=/build.sh \
  --exclude=/build/ \
  --exclude=/vendor.sh \
  ./ ./build/ZshBoot/

echo "[ INFO ] compress build/ZshBoot-${safe_tag}.zip ..."
(cd build/ && zip -q -r -o "ZshBoot-${safe_tag}.zip" ZshBoot/)
