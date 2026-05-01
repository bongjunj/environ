mkdir -p ~/.config/fish
if [ -e ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
  rm -rf ~/.config/nvim
fi

ln -sf "$(pwd)/config.fish" ~/.config/fish/config.fish
ln -sf "$(pwd)/.tmux.conf" ~/.tmux.conf
ln -sf "$(pwd)/.gitconfig" ~/.gitconfig
ln -sfn "$(pwd)/nvim" ~/.config/nvim
