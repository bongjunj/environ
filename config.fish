if status is-interactive
    # Commands to run in interactive sessions can go here
end

# opam configuration
source /home/bonjune/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

set -Ux RBENV_ROOT $HOME/.rbenv
fish_add_path $RBENV_ROOT/bin
fish_add_path $HOME/.rbenv/plugins/ruby-build/bin
status --is-interactive; and source (rbenv init -|psub)

fish_add_path /opt/nvim-linux-x86_64/bin

# texlive
set -Ux TEXLIVE_ROOT /usr/local/texlive/2025
fish_add_path $TEXLIVE_ROOT/bin/x86_64-linux

pyenv init - | source

# Lean Theorem Prover
if test -d '$HOME/.elan/bin/'
  fish_add_path $HOME/.elan/bin/
end

