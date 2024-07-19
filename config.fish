if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx TERM xterm-256color
set -gx PATH /opt/nvim-linux64/bin/ $PATH

alias vi nvim
alias python python3
alias eoe 'eval $(opam env)'
alias ta 'tmux attach -t main'
alias exp2 ~/llfuzz-experiment/exp2

# opam configuration
source /home/bonjune/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true

set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths
pyenv init - | source
