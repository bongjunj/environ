mkdir -p ~/.config/fish
mkdir -p ~/.config/nvim

ln -sf $(pwd)/config.fish ~/.config/fish/config.fish
ln -sf $(pwd)/.tmux.conf ~/.tmux.conf
ln -sf $(pwd)/.tmux.conf.local ~/.tmux.conf.local
ln -sf $(pwd)/.gitconfig ~/.gitconfig
ln -sf $(pwd)/init.lua ~/.config/nvim/init.lua

cp ./fish_prompt.fish ~/.config/fish/functions/
