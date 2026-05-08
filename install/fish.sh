#!/usr/bin/env bash
set -euo pipefail

version="4.1.2"
archive_name="fish-${version}.tar.xz"
url="https://github.com/fish-shell/fish-shell/releases/download/${version}/${archive_name}"
workdir="$(mktemp -d)"

cleanup() {
  rm -rf "$workdir"
}
trap cleanup EXIT

cd "$workdir"
curl -Lo "$archive_name" "$url"
tar -xvf "$archive_name"
cd "fish-${version}"
cmake .
make
sudo make install
