#!/usr/bin/env bash
set -euo pipefail

workdir="$(mktemp -d)"

cleanup() {
  rm -rf "$workdir"
}
trap cleanup EXIT

script_path="${workdir}/nodesource_setup.sh"

curl -fsSL https://deb.nodesource.com/setup_22.x -o "$script_path"
sudo -E bash "$script_path"
sudo apt-get install -y nodejs
node -v
