if status is-interactive
    # Commands to run in interactive sessions can go here
end

# opam configuration
source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# PYTHON
set -l pyenv_root $HOME/.pyenv
if test -d "$pyenv_root"
	set -Ux PYENV_ROOT "$pyenv_root"
	fish_add_path -p $PYENV_ROOT/bin
	pyenv init - | source
end

# RUBY
set -l rbenv_root "$HOME/.rbenv"
if test -d "$rbenv_root"
    set -Ux RBENV_ROOT "$rbenv_root"
    fish_add_path "$RBENV_ROOT/bin"
    fish_add_path "$RBENV_ROOT/plugins/ruby-build/bin"
    status --is-interactive; and source (rbenv init - | psub)
end

# NEOVIM
if sudo -v --non-interactive &> /dev/null
	# SUDO: install nvim at /opt
	fish_add_path /opt/nvim-linux-x86_64/bin
else
	# NON-SUDO: install nvim at $HOME
	fish_add_path $HOME/environ/nvim/nvim-linux-x86_64/bin
end

# TEXLIVE
set -l texlive_root "/usr/local/texlive/2025"
if test -d "$texlive_root"
	set -Ux TEXLIVE_ROOT "$texlive_root"
	fish_add_path $TEXLIVE_ROOT/bin/x86_64-linux
end

# Lean
if test -d '$HOME/.elan/bin/'
  fish_add_path $HOME/.elan/bin/
end

# Shortcuts
function da
	docker attach
end

function gs
	git status
end

function ga
  git add
end

