#!/usr/bin/env bash
set -euo pipefail

version="1.26.3"
archive_name="go${version}.linux-amd64.tar.gz"
checksum="2b2cfc7148493da5e73981bffbf3353af381d5f93e789c82c79aff64962eb556"
workdir="$(mktemp -d)"

cleanup() {
  rm -rf "$workdir"
}
trap cleanup EXIT

cd "$workdir"
curl -fLo "$archive_name" "https://go.dev/dl/${archive_name}"
echo "${checksum}  ${archive_name}" | sha256sum -c -

sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "$archive_name"

/usr/local/go/bin/go version

gopath="$(/usr/local/go/bin/go env GOPATH)"
go_bin_dir="/usr/local/go/bin"
go_tools_dir="${gopath}/bin"

mkdir -p "$go_tools_dir"

if command -v fish >/dev/null 2>&1; then
  fish -lc "fish_add_path '$go_bin_dir' '$go_tools_dir'"
fi

export PATH="${go_bin_dir}:${go_tools_dir}:${PATH}"

go install github.com/jesseduffield/lazygit@latest
lazygit --version
