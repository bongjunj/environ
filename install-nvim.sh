#! /usr/bin/env bash

set -e

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
if sudo -v &>/dev/null; then
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
else
	rm -rf nvim
	mkdir -p nvim
	tar -C nvim -xzf nvim-linux-x86_64.tar.gz
fi

