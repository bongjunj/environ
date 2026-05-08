#!/usr/bin/env bash
set -euo pipefail

target="${HOME}/.rbenv"
shell_path="${SHELL:-/bin/bash}"
shell_name="$(basename "$shell_path")"

git clone https://github.com/rbenv/rbenv.git "$target"
"${target}/bin/rbenv" init - "$shell_name"
