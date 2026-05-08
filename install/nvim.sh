#!/usr/bin/env bash
set -euo pipefail

archive_name="nvim-linux-x86_64.tar.gz"
url="https://github.com/neovim/neovim/releases/latest/download/${archive_name}"
workdir="$(mktemp -d)"

cleanup() {
  rm -rf "$workdir"
}
trap cleanup EXIT

archive_path="${workdir}/${archive_name}"

curl -Lo "$archive_path" "$url"
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf "$archive_path"
