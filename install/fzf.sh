#!/usr/bin/env bash
set -euo pipefail

fzf_dir="${HOME}/.fzf"
fish_config="${HOME}/.config/fish/config.fish"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(dirname "$script_dir")"
repo_fish_config="${repo_dir}/config.fish"

if [ ! -d "$fzf_dir" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$fzf_dir"
fi

"${fzf_dir}/install" --all --no-bash --no-zsh

mkdir -p "$(dirname "$fish_config")"

if [ -L "$fish_config" ]; then
  config_target="$(readlink -f "$fish_config")"
else
  config_target="$fish_config"
fi

if [ "$config_target" = "$repo_fish_config" ] || [ -e "$repo_fish_config" ]; then
  config_file="$repo_fish_config"
else
  config_file="$fish_config"
  touch "$config_file"
fi

if ! grep -Fq "fzf --fish | source" "$config_file"; then
  cat >> "$config_file" <<'EOF'

if status is-interactive; and command -q fzf
    fzf --fish | source
end
EOF
fi

fish_bindings="${HOME}/.config/fish/functions/fish_user_key_bindings.fish"
if [ -f "$fish_bindings" ] && grep -Eq "fzf_key_bindings|fzf --fish" "$fish_bindings"; then
  cat > "$fish_bindings" <<'EOF'
function fish_user_key_bindings
end
EOF
fi
