#!/usr/bin/env bash
set -euo pipefail

version="2.83.0"
archive_name="gh_${version}_linux_amd64.tar.gz"
url="https://github.com/cli/cli/releases/download/v${version}/${archive_name}"
extract_dir="gh_${version}_linux_amd64"
workdir="$(mktemp -d)"

cleanup() {
  rm -rf "$workdir"
}
trap cleanup EXIT

cd "$workdir"
curl -Lo "$archive_name" "$url"
tar -xzvf "$archive_name"
sudo install -m 755 "${extract_dir}/bin/gh" /usr/local/bin/gh
