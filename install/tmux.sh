#!/usr/bin/env bash
set -euo pipefail

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

cd "$workdir"
curl -LO https://github.com/tmux/tmux/releases/download/3.6b/tmux-3.6b.tar.gz
tar -xvzf tmux-3.6b.tar.gz
pushd tmux-3.6b
./configure && make
sudo make install
