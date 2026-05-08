#!/usr/bin/env bash
set -euo pipefail

pyenv_root="${HOME}/.pyenv"

export PYENV_ROOT="$pyenv_root"
export PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"

curl https://pyenv.run | bash
"${PYENV_ROOT}/bin/pyenv" install -s 3.12.4
"${PYENV_ROOT}/bin/pyenv" global 3.12.4
