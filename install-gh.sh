#!/usr/bin/env fish

curl -LO https://github.com/cli/cli/releases/download/v2.83.0/gh_2.83.0_linux_amd64.tar.gz
tar -xzvf gh_2.83.0_linux_amd64.tar.gz
fish_add_path gh_2.83.0_linux_amd64/bin
