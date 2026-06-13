#!/usr/bin/env bash
set -euo pipefail

version="2026-02-08"
binary_name="marksman-linux-x64"
url="https://github.com/artempyanykh/marksman/releases/download/${version}/${binary_name}"
workdir="$(mktemp -d)"

cleanup() {
  rm -rf "$workdir"
}
trap cleanup EXIT

cd "$workdir"
curl -fLo "$binary_name" "$url"
chmod 755 "$binary_name"

sudo install -m 755 "$binary_name" /usr/local/bin/marksman

marksman --version
