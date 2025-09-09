if status is-interactive
    # Commands to run in interactive sessions can go here
end

# opam configuration
source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# PYTHON
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path -p $PYENV_ROOT/bin
pyenv init - | source

# RUBY
set -Ux RBENV_ROOT $HOME/.rbenv
fish_add_path $RBENV_ROOT/bin
fish_add_path $HOME/.rbenv/plugins/ruby-build/bin
status --is-interactive; and source (rbenv init -|psub)

# NEOVIM
fish_add_path /opt/nvim-linux-x86_64/bin

# TEXLIVE
set -Ux TEXLIVE_ROOT /usr/local/texlive/2025
fish_add_path $TEXLIVE_ROOT/bin/x86_64-linux

# Lean
if test -d '$HOME/.elan/bin/'
  fish_add_path $HOME/.elan/bin/
end

