#!/usr/bin/env bash
set -euo pipefail

version="25.07.1"
archive_name="helix-${version}-x86_64-linux.tar.xz"
url="https://github.com/helix-editor/helix/releases/download/${version}/${archive_name}"
extract_dir="helix-${version}-x86_64-linux"
runtime_dir="${HOME}/.config/helix/runtime"
workdir="$(mktemp -d)"

cleanup() {
  rm -rf "$workdir"
}
trap cleanup EXIT

cd "$workdir"
curl -fLo "$archive_name" "$url"
tar -xJf "$archive_name"

sudo install -m 755 "${extract_dir}/hx" /usr/local/bin/hx

rm -rf "$runtime_dir"
mkdir -p "$(dirname "$runtime_dir")"
cp -R "${extract_dir}/runtime" "$runtime_dir"

hx --version
