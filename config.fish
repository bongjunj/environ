if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx PATH /opt/nvim-linux64/bin/ $PATH

alias vi nvim

# opam configuration
source /home/bonjune/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
