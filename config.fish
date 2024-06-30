if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx TERM xterm-256color
set -gx PATH /opt/nvim-linux64/bin/ $PATH

alias vi nvim
alias python python3
alias eoe 'eval $(opam env)'
alias ta 'tmux attach -t main'

# opam configuration
source /home/bonjune/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
